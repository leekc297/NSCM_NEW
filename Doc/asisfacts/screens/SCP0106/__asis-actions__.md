# AS-IS 액션 대조표 — SCP0106

> 원천: `Doc/asisfacts/screens/SCP0106/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1038행 · 메서드 199 · 종류 DATA_OP 266 · CALL_EXT 254 · RETURN 131 · FLAG 123 · POPUP 108 · UI_PROP 51 · GRID_SET 27 · GRID_LOCK 11 · LIST_REBIND 11 · UI_MISC 10 · GRID_INIT 8 · ENDPOINT 7 · MESSAGE 6 · VALUE_SET 6 · GRID_STYLE 6 · CALL_BASE 4 · VALIDATE 3 · GRID_CLEAR 2 · GRID_BIND 1 · STATE_RESET 1 · LIST_CLEAR 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 258


## AssemblyCapaMeasureSet..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c376ca1 | .ctor | AssemblyUtils.cs:997 |  | FLAG | _si | si | 화면 필드/플래그 변경 |  |  |  |
| AC-080a20d8 | .ctor | AssemblyUtils.cs:998 |  | FLAG | _version | version | 화면 필드/플래그 변경 |  |  |  |
| AC-45bc16ea | .ctor | AssemblyUtils.cs:999 |  | FLAG | _tblAll | tbl | 화면 필드/플래그 변경 |  |  |  |
| AC-8091a548 | .ctor | AssemblyUtils.cs:1000 |  | FLAG | _tblProdCapaD | tblProdCapaD | 화면 필드/플래그 변경 |  |  |  |
| AC-6447c71c | .ctor | AssemblyUtils.cs:1001 |  | FLAG | _tblDayCnt | tblDayCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-b2b4b27e | .ctor | AssemblyUtils.cs:1002 |  | FLAG | _currRowIdx | currRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-35badd85 | .ctor | AssemblyUtils.cs:1003 |  | FLAG | _currColIumndx | currColumnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-5554c5dd | .ctor | AssemblyUtils.cs:1005 |  | FLAG | _currColumnName | _si.GetColumnTag(currColumnIndex) | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCapaMeasureSet.GeFilterModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67da8f13 | (진입점 미연결) | AssemblyUtils.cs:1134 |  | DATA_OP | new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e3c1970 | (진입점 미연결) | AssemblyUtils.cs:1136 | if (new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains(measure)) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d31c44a1 | (진입점 미연결) | AssemblyUtils.cs:1162 | else of (new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains(measure)) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8fad4ec | (진입점 미연결) | AssemblyUtils.cs:1186 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetCurrSheetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c11ce7 | (진입점 미연결) | AssemblyUtils.cs:1115 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetDayCount

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1314271c | (진입점 미연결) | AssemblyUtils.cs:1086 |  | CALL_EXT | DateTime.DaysInMonth | (int.Parse(yyyy), int.Parse(mm)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92cad0b1 | (진입점 미연결) | AssemblyUtils.cs:1086 |  | RETURN | return DateTime.DaysInMonth(int.Parse(yyyy), int.Parse(mm)); |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetLineValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fcbfedd | (진입점 미연결) | AssemblyUtils.cs:1216 | try | DATA_OP | DBUtils.Filter | (_tblCurrMeasureSet, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5a52e6f4 | (진입점 미연결) | AssemblyUtils.cs:1226 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetMeasureRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-297b1336 | (진입점 미연결) | AssemblyUtils.cs:1326 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetMeasureValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db283cc7 | (진입점 미연결) | AssemblyUtils.cs:1291 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetMonthList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba96732d | (진입점 미연결) | AssemblyUtils.cs:1095 | while (startDate <= endDate) | DATA_OP | res.Add | (startDate.ToString("yyyyMM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d35adf1f | (진입점 미연결) | AssemblyUtils.cs:1100 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetSheetRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8d90f9e | (진입점 미연결) | AssemblyUtils.cs:1357 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.GetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d8c08e3 | (진입점 미연결) | AssemblyUtils.cs:1195 |  | DATA_OP | DBUtils.Filter | (_tblCurrMeasureSet, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-74ddf52b | (진입점 미연결) | AssemblyUtils.cs:1205 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCapaMeasureSet.Init

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcbe58b0 | .ctor | AssemblyUtils.cs:1015 |  | FLAG | _keyColumnNames | new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "PL… | 화면 필드/플래그 변경 |  |  |  |
| AC-f992cf9d | .ctor | AssemblyUtils.cs:1029 | if (_keyColumValues.Count > 0) | CALL_EXT | _keyColumValues.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d43eb50 | .ctor | AssemblyUtils.cs:1049 | foreach (string colName in _keyColumnNames) | DATA_OP | _keyColumValues.Add | (colValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-223f7478 | .ctor | AssemblyUtils.cs:1053 |  | FLAG | _tblCurrMeasureSet | _tblAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d8b526c | .ctor | AssemblyUtils.cs:1053 |  | DATA_OP | _tblAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2b4ae03a | .ctor | AssemblyUtils.cs:1054 |  | GRID_CLEAR | _tblCurrMeasureSet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-0a232a47 | .ctor | AssemblyUtils.cs:1070 |  | CALL_EXT | DBUtils.GetAndFilterString | (whereColumnNames, whereColumnValues, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2af40bd1 | .ctor | AssemblyUtils.cs:1072 |  | FLAG | _tblCurrMeasureSet | DBUtils.Filter(_tblAll, filterMeasureSet, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b543994 | .ctor | AssemblyUtils.cs:1072 |  | DATA_OP | DBUtils.Filter | (_tblAll, filterMeasureSet, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## AssemblyCapaMeasureSet.SetSheetEditStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56199a4e | (진입점 미연결) | AssemblyUtils.cs:1362 |  | GRID_SET | _si.SetValue | (sheetRowIdex, 0, "M") | 그리드 값 설정 |  |  |  |

## AssemblyCapaMeasureSet.SetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e5993c0 | (진입점 미연결) | AssemblyUtils.cs:1236 |  | CALL_EXT | DBUtils.Set | (_tblCurrMeasureSet, filter, new List<string>() { _currColumnName }, new List<object>() { … | ⚠ 의미 확인 필요 |  |  |  |
| AC-4826cb93 | (진입점 미연결) | AssemblyUtils.cs:1237 |  | CALL_EXT | DBUtils.Set | (_tblAll, filter, new List<string>() { _currColumnName }, new List<object>() { value }) | ⚠ 의미 확인 필요 |  |  |  |

## AssemblyCapaMeasureSetLine..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e445dd85 | .ctor | AssemblyUtils.cs:1699 |  | CALL_EXT | DBUtils.GetAndFilterString | (whereCapaColumnNames, whereCapaColumnValues, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f1d8bb1 | .ctor | AssemblyUtils.cs:1701 |  | DATA_OP | DBUtils.Filter | (_tblProdCapaD, filterProdCapaD, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## AssemblyCapaMeasureSetLine.Refresh

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-455e990a | (진입점 미연결) | AssemblyUtils.cs:1723 | try | FLAG | SCP_PROD_PLAN_DDN | SCP_PROD_PLAN / PROD_CAPA_D | 화면 필드/플래그 변경 |  |  |  |
| AC-ff3eb48c | (진입점 미연결) | AssemblyUtils.cs:1729 |  | FLAG | WT_RT | DAY_CNT - (SD_RT + TD_RT + MC_RT + SCP_PROD_PLAN_DDN_LINE) | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd58dbcd | .ctor | AssemblyUtils.cs:960 |  | FLAG | _si | si | 화면 필드/플래그 변경 |  |  |  |
| AC-2393b9d1 | .ctor | AssemblyUtils.cs:961 |  | FLAG | _tblMeasure | tblMeasure | 화면 필드/플래그 변경 |  |  |  |
| AC-fb12c687 | .ctor | AssemblyUtils.cs:962 |  | FLAG | _tblDayCnt | tblDayCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-01f68cd8 | .ctor | AssemblyUtils.cs:963 |  | FLAG | _measureColumnNameofSheet | measureColumnNameofSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-3c91b4c9 | .ctor | AssemblyUtils.cs:964 |  | FLAG | _currRowIndex | currRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-89bcc712 | .ctor | AssemblyUtils.cs:965 |  | FLAG | _currColumnIndex | currColumnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-efa6e4e8 | .ctor | AssemblyUtils.cs:966 |  | FLAG | _version | version | 화면 필드/플래그 변경 |  |  |  |
| AC-c6db7276 | .ctor | AssemblyUtils.cs:967 |  | FLAG | _progress_status | progress_status | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.ApplyToSheet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82894bd5 | (진입점 미연결) | AssemblyUtils.cs:887 | if (rowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c9f3f2c | (진입점 미연결) | AssemblyUtils.cs:889 |  | GRID_SET | _si.SetValue | (rowIndex, _currColumnIndex, _values[measure]) | 그리드 값 설정 |  |  |  |
| AC-57c6ddfc | (진입점 미연결) | AssemblyUtils.cs:891 |  | GRID_SET | _si.SetValue | (rowIndex, 0, "M") | 그리드 값 설정 |  |  |  |

## AssemblyCurrentCapaMeasureSet.ApplyToSheetOnlyEditMode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9ae450 | (진입점 미연결) | AssemblyUtils.cs:924 | if (rowIdx != -1) | GRID_SET | _si.SetValue | (rowIdx, 0, "M") | 그리드 값 설정 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetBaseColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fa14071 | (진입점 미연결) | AssemblyUtils.cs:760 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetDayCount

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baa4d1bc | (진입점 미연결) | AssemblyUtils.cs:82 |  | CALL_EXT | DateTime.DaysInMonth | (int.Parse(yyyy), int.Parse(mm)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-115cd199 | (진입점 미연결) | AssemblyUtils.cs:82 |  | RETURN | return DateTime.DaysInMonth(int.Parse(yyyy), int.Parse(mm)); |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetIGofTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ff5e8e | (진입점 미연결) | AssemblyUtils.cs:860 |  | RETURN | return GetValueFromMeasureTable(measure, "IPRV_GOL_TP"); |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetLossColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1988734e | (진입점 미연결) | AssemblyUtils.cs:786 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetMeasureIndexOfTable

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6581ff51 | .ctor [foreach (DataRow r in _tblMeasure.Rows)] 외 1 | AssemblyUtils.cs:855 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetMonthList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e024d5d | (진입점 미연결) | AssemblyUtils.cs:91 | while (startDate <= endDate) | DATA_OP | res.Add | (startDate.ToString("yyyyMM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1847744 | (진입점 미연결) | AssemblyUtils.cs:96 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetPlanColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d71e5b | (진입점 미연결) | AssemblyUtils.cs:812 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetResultColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1316fd36 | (진입점 미연결) | AssemblyUtils.cs:745 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetRowIndexOfMeasure

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c991df02 | .ctor [foreach (DataRow r in _tblMeasure.Rows)] 외 1 | AssemblyUtils.cs:827 | if (currMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-30f9995f | .ctor [foreach (DataRow r in _tblMeasure.Rows)] 외 1 | AssemblyUtils.cs:832 | if (toFindMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-964b7dfe | .ctor [foreach (DataRow r in _tblMeasure.Rows)] 외 1 | AssemblyUtils.cs:838 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetValueFromDayCntTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20093763 | (진입점 미연결) | AssemblyUtils.cs:146 | try | CALL_EXT | DBUtils.GetAndFilterString | ( new List<string>() { "VER_ID", "VER_SEQ", "DIVISION_ID", "COMPANY_ID", "SITE_ID", "PLANT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c50b903d | (진입점 미연결) | AssemblyUtils.cs:162 | try | DATA_OP | DBUtils.Filter | (_tblDayCnt, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-34efa7c9 | (진입점 미연결) | AssemblyUtils.cs:173 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.GetValueFromMeasureTable

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-885a759d | .ctor [foreach (DataRow r in _tblMeasure.Rows)] 외 1 | AssemblyUtils.cs:879 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## AssemblyCurrentCapaMeasureSet.Init

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc5dee4 | .ctor | AssemblyUtils.cs:930 |  | FLAG | _measureColumnIndex | _si.GetColumnIndex(_measureColumnNameofSheet) | 화면 필드/플래그 변경 |  |  |  |
| AC-770fe554 | .ctor | AssemblyUtils.cs:935 | if (this._values.Count > 0) | CALL_EXT | this._values.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4404ccc9 | .ctor | AssemblyUtils.cs:938 |  | FLAG | _currColumnName | _si.GetColumnTag(currColumnIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d80bc8a1 | .ctor | AssemblyUtils.cs:953 | foreach (DataRow r in _tblMeasure.Rows) | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcLD_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d0ce7fe | (진입점 미연결) | AssemblyUtils.cs:677 |  | FLAG | LD_RT | 100 - (ID_RT //Idle_LOB 설비대기 + NM_RT) | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcOP_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a9f74dd | (진입점 미연결) | AssemblyUtils.cs:667 |  | FLAG | OP_RT | 100 - (BM_RT //BM + CM_RT //CM + PD_RT //PD + PM_RT //PM + UD_RT //UT Down + PP_RT //생산준비 … | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcPROD_CAPA_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08150899 | (진입점 미연결) | AssemblyUtils.cs:704 |  | FLAG | PROD_CAPA_D | THRY_CAPA_D * (PROD_OP_RT / (decimal)100) | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcPROD_CAPA_M

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9a0a42c | (진입점 미연결) | AssemblyUtils.cs:709 |  | FLAG | PROD_CAPA_M | PROD_CAPA_D * DAY_CNT | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcPROD_OP_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-586fadf3 | (진입점 미연결) | AssemblyUtils.cs:692 |  | FLAG | PROD_OP_RT | (LD_RT / (decimal)100) //부하율 * (OP_RT / (decimal)100) //시간가동률 * (PF_RT / (decimal)100) //성… | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcTEEP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e76b41c | (진입점 미연결) | AssemblyUtils.cs:683 |  | FLAG | TEEP | (AV_RT / (decimal)100) //조업율 * (LD_RT / (decimal)100) //부하율 * (OP_RT / (decimal)100) //시간가… | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcTHRY_CAPA_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49607c9d | (진입점 미연결) | AssemblyUtils.cs:700 |  | FLAG | THRY_CAPA_D | SPEED_PPM * (decimal)1440 | 화면 필드/플래그 변경 |  |  |  |

## AssemblyCurrentCapaMeasureSet.recalcWT_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99e4b304 | (진입점 미연결) | AssemblyUtils.cs:713 |  | FLAG | WT_RT | DAY_CNT - (SD_RT + TD_RT + MC_RT + SCP_PROD_PLAN_DDN) | 화면 필드/플래그 변경 |  |  |  |

## EltrCapaMeasureSet..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6c7f497 | .ctor | EltrUtils.cs:1586 |  | FLAG | _si | si | 화면 필드/플래그 변경 |  |  |  |
| AC-747377f8 | .ctor | EltrUtils.cs:1587 |  | FLAG | _version | version | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb9c003 | .ctor | EltrUtils.cs:1588 |  | FLAG | _tblAll | tbl | 화면 필드/플래그 변경 |  |  |  |
| AC-bf08ef94 | .ctor | EltrUtils.cs:1589 |  | FLAG | _tblProdCapaD | tblProdCapaD | 화면 필드/플래그 변경 |  |  |  |
| AC-8ef8a06f | .ctor | EltrUtils.cs:1590 |  | FLAG | _tblDayCnt | tblDayCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-8c63758f | .ctor | EltrUtils.cs:1591 |  | FLAG | _currRowIndex | currRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-dcc6f428 | .ctor | EltrUtils.cs:1592 |  | FLAG | _currColIumnIndex | currColumnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-8590b65a | .ctor | EltrUtils.cs:1594 |  | FLAG | _currColumnName | _si.GetColumnTag(currColumnIndex) | 화면 필드/플래그 변경 |  |  |  |

## EltrCapaMeasureSet.GeFilterModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-347f3f9f | (진입점 미연결) | EltrUtils.cs:1722 |  | DATA_OP | new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0b8dc1f | (진입점 미연결) | EltrUtils.cs:1724 | if (new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains(measure)) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-500a5c50 | (진입점 미연결) | EltrUtils.cs:1750 | else of (new List<string>() { "SD_RT", "TD_RT", "MC_RT", "WT_RT" }.Contains(measure)) | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "P… | ⚠ 의미 확인 필요 |  |  |  |
| AC-31d1b163 | (진입점 미연결) | EltrUtils.cs:1774 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetCurrSheetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c90056b | (진입점 미연결) | EltrUtils.cs:1703 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetDayCount

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4d732d | (진입점 미연결) | EltrUtils.cs:1674 |  | CALL_EXT | DateTime.DaysInMonth | (int.Parse(yyyy), int.Parse(mm)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d18c8848 | (진입점 미연결) | EltrUtils.cs:1674 |  | RETURN | return DateTime.DaysInMonth(int.Parse(yyyy), int.Parse(mm)); |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetIGofTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-677c2161 | (진입점 미연결) | EltrUtils.cs:1561 |  | RETURN | return GetValueFromMeasureTable(measure, "IPRV_GOL_TP"); |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetItemValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75710d24 | (진입점 미연결) | EltrUtils.cs:1458 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ try | CALL_EXT | _si.GetValue2 | (r, currColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f36ed5d4 | (진입점 미연결) | EltrUtils.cs:1464 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) | DATA_OP | res.Add | (currItemId, value) | 데이터 객체 조작/조회 |  |  |  |
| AC-b932d481 | (진입점 미연결) | EltrUtils.cs:1472 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetLineValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-425b92e5 | (진입점 미연결) | EltrUtils.cs:1823 | try | DATA_OP | DBUtils.Filter | (_tblCurrMeasureSet, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f91c4509 | (진입점 미연결) | EltrUtils.cs:1833 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetMeasureIndexOfTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10b33618 | (진입점 미연결) | EltrUtils.cs:1530 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetMeasureRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-333293f4 | (진입점 미연결) | EltrUtils.cs:1952 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-ddc4093c | (진입점 미연결) | EltrUtils.cs:1967 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetMeasureValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41980c55 | (진입점 미연결) | EltrUtils.cs:1917 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetMonthList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9746549a | (진입점 미연결) | EltrUtils.cs:1683 | while (startDate <= endDate) | DATA_OP | res.Add | (startDate.ToString("yyyyMM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf5b254 | (진입점 미연결) | EltrUtils.cs:1688 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetRowIndexOfMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05273a3a | (진입점 미연결) | EltrUtils.cs:1545 | if (currMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-20535d18 | (진입점 미연결) | EltrUtils.cs:1550 | if (toFindMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-40a6f817 | (진입점 미연결) | EltrUtils.cs:1556 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetSheetRowIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bca95c0 | (진입점 미연결) | EltrUtils.cs:1998 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-317f9696 | (진입점 미연결) | EltrUtils.cs:1783 |  | DATA_OP | DBUtils.Filter | (_tblCurrMeasureSet, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-07462ac6 | (진입점 미연결) | EltrUtils.cs:1793 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-65889924 | (진입점 미연결) | EltrUtils.cs:1802 |  | DATA_OP | DBUtils.Filter | (_tblCurrMeasureSet, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-71e7acc1 | (진입점 미연결) | EltrUtils.cs:1812 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.GetValueFromMeasureTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9505bc5c | (진입점 미연결) | EltrUtils.cs:1580 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSet.Init

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dfbfe1f | .ctor | EltrUtils.cs:1604 |  | FLAG | _keyColumnNames | new List<string>() { "VER_ID" , "VER_SEQ" , "DIVISION_ID" , "COMPANY_ID" , "SITE_ID" , "PL… | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b776b0 | .ctor | EltrUtils.cs:1618 | if (_keyColumValues.Count > 0) | CALL_EXT | _keyColumValues.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-506fde0e | .ctor | EltrUtils.cs:1638 | foreach (string colName in _keyColumnNames) | DATA_OP | _keyColumValues.Add | (colValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-93d7ce38 | .ctor | EltrUtils.cs:1642 |  | FLAG | _tblCurrMeasureSet | _tblAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-ffd52662 | .ctor | EltrUtils.cs:1642 |  | DATA_OP | _tblAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-03734f8b | .ctor | EltrUtils.cs:1643 |  | GRID_CLEAR | _tblCurrMeasureSet.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-dd1211f9 | .ctor | EltrUtils.cs:1659 |  | CALL_EXT | DBUtils.GetAndFilterString | (whereColumnNames, whereColumnValues, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6febdf8 | .ctor | EltrUtils.cs:1661 |  | FLAG | _tblCurrMeasureSet | DBUtils.Filter(_tblAll, filterMeasureSet, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-d4fffc0c | .ctor | EltrUtils.cs:1661 |  | DATA_OP | DBUtils.Filter | (_tblAll, filterMeasureSet, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## EltrCapaMeasureSet.SetItemValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3186233 | (진입점 미연결) | EltrUtils.cs:1492 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ foreach (var k in values) ▸ if (currItemId == k.Key) | GRID_SET | _si.SetValue | (r, currColumnIndex, k.Value) | 그리드 값 설정 |  |  |  |
| AC-7714d1b7 | (진입점 미연결) | EltrUtils.cs:1494 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ foreach (var k in values) ▸ if (currItemId == k.Key) | GRID_SET | _si.SetValue | (r, 0, "M") | 그리드 값 설정 |  |  |  |

## EltrCapaMeasureSet.SetSheetEditStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4370603 | (진입점 미연결) | EltrUtils.cs:2003 |  | GRID_SET | _si.SetValue | (sheetRowIdex, 0, "M") | 그리드 값 설정 |  |  |  |

## EltrCapaMeasureSet.SetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34b85b52 | (진입점 미연결) | EltrUtils.cs:1844 |  | CALL_EXT | DBUtils.Set | (_tblCurrMeasureSet, filter, new List<string>() { _currColumnName }, new List<object>() { … | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fe58c3b | (진입점 미연결) | EltrUtils.cs:1845 |  | CALL_EXT | DBUtils.Set | (_tblAll, filter, new List<string>() { _currColumnName }, new List<object>() { value }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d7e2036 | (진입점 미연결) | EltrUtils.cs:1862 |  | CALL_EXT | DBUtils.Set | (_tblCurrMeasureSet, filter, new List<string>() { _currColumnName }, new List<object>() { … | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa291b4d | (진입점 미연결) | EltrUtils.cs:1863 |  | CALL_EXT | DBUtils.Set | (_tblAll, filter, new List<string>() { _currColumnName }, new List<object>() { value }) | ⚠ 의미 확인 필요 |  |  |  |

## EltrCapaMeasureSetLine..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ae1516 | .ctor | EltrUtils.cs:2436 |  | CALL_EXT | DBUtils.GetAndFilterString | (whereCapaColumnNames, whereCapaColumnValues, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0909b272 | .ctor | EltrUtils.cs:2438 |  | DATA_OP | DBUtils.Filter | (_tblProdCapaD, filterProdCapaD, true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## EltrCapaMeasureSetLine.Init

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-698c9341 | .ctor | EltrUtils.cs:2357 | if (this._values.Count > 0) | CALL_EXT | this._values.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb62f717 | .ctor | EltrUtils.cs:2369 | foreach (DataRow r in _tblCurrMeasureSet.Rows) | DATA_OP | _itemMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0669027 | .ctor | EltrUtils.cs:2371 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ if (!_itemMeasures.Contains(measure)) | CALL_BASE | GetRowIndexOfMeasure | (currRowIndex, measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-775a0ccb | .ctor | EltrUtils.cs:2380 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ if (!_itemMeasures.Contains(measure)) | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |
| AC-5523bd8e | .ctor | EltrUtils.cs:2386 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ else of (!_itemMeasures.Contains(measure)) ▸ if (this._values.Count == 0) | CALL_BASE | GetItemValues | (measure, currColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9f50ebd | .ctor | EltrUtils.cs:2388 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ else of (!_itemMeasures.Contains(measure)) ▸ if (this._values.Count == 0) | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |
| AC-cabd6807 | .ctor | EltrUtils.cs:2392 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ else of (!_itemMeasures.Contains(measure)) ▸ else of (this._values.Count == 0) | DATA_OP | this._values.ContainsKey | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-3486e5d2 | .ctor | EltrUtils.cs:2394 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ else of (!_itemMeasures.Contains(measure)) ▸ else of (this._values.Count == 0) ▸ if (!this.… | CALL_BASE | GetItemValues | (measure, currColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4595ca5 | .ctor | EltrUtils.cs:2396 | foreach (DataRow r in _tblCurrMeasureSet.Rows) ▸ else of (!_itemMeasures.Contains(measure)) ▸ else of (this._values.Count == 0) ▸ if (!this.… | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |

## EltrCapaMeasureSetLine.InitLineInfo

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7851a564 | .ctor | EltrUtils.cs:2317 | if (_lineIdxColumnIndex > -1) | CALL_EXT | _si.GetValue2 | (_currRowIndex, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9be1e5e | .ctor | EltrUtils.cs:2322 | for (r >= 0) | CALL_EXT | _si.GetValue2 | (r, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8be95113 | .ctor | EltrUtils.cs:2336 | for (r <= _si.GetMaxRowIndex()) | CALL_EXT | _si.GetValue2 | (r, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |

## EltrCapaMeasureSetLine.PROD_CAPA_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f0ce7e0 | (진입점 미연결) | EltrUtils.cs:2297 | try | DATA_OP | DBUtils.Filter | (_tblCurrProdCapaD, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-111a883b | (진입점 미연결) | EltrUtils.cs:2307 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCapaMeasureSetLine.Refresh

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-120776f8 | (진입점 미연결) | EltrUtils.cs:2477 | try ▸ foreach (var v in SCP_PROD_PLAN) | DATA_OP | SCP_PROD_PLAN_DDN[v.Key] | currProdPlanDDN | 행/컬럼 값 대입 |  |  |  |
| AC-cb3a02da | (진입점 미연결) | EltrUtils.cs:2479 | try ▸ foreach (var v in SCP_PROD_PLAN) | GRID_SET | SetValue | ("SCP_PROD_PLAN_DDN", v.Key, currProdPlanDDN) | 그리드 값 설정 |  |  |  |
| AC-fb085041 | (진입점 미연결) | EltrUtils.cs:2486 |  | FLAG | WT_RT | DAY_CNT - (SD_RT + TD_RT + MC_RT + SCP_PROD_PLAN_DDN_LINE) | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29d4a91e | .ctor | EltrUtils.cs:1361 |  | FLAG | _si | si | 화면 필드/플래그 변경 |  |  |  |
| AC-a11d90e5 | .ctor | EltrUtils.cs:1362 |  | FLAG | _tblMeasure | tblMeasure | 화면 필드/플래그 변경 |  |  |  |
| AC-1ec26ced | .ctor | EltrUtils.cs:1363 |  | FLAG | _tblDayCnt | tblDayCnt | 화면 필드/플래그 변경 |  |  |  |
| AC-80c3b649 | .ctor | EltrUtils.cs:1365 |  | FLAG | _measureColumnNameofSheet | measureColumnNameofSheet | 화면 필드/플래그 변경 |  |  |  |
| AC-df9f8876 | .ctor | EltrUtils.cs:1366 |  | FLAG | _currRowIndex | currRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-a1c91213 | .ctor | EltrUtils.cs:1367 |  | FLAG | _currColumnIndex | currColumnIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-64a69b8a | .ctor | EltrUtils.cs:1368 |  | FLAG | _version | version | 화면 필드/플래그 변경 |  |  |  |
| AC-ea698cb5 | .ctor | EltrUtils.cs:1369 |  | FLAG | _progress_status | progress_status | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.ApplyToSheet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33a849ef | (진입점 미연결) | EltrUtils.cs:1074 |  | DATA_OP | _itemMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffde6e99 | (진입점 미연결) | EltrUtils.cs:1079 | if (!_itemMeasures.Contains(measure)) ▸ if (rowIndex == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-354447c4 | (진입점 미연결) | EltrUtils.cs:1081 | if (!_itemMeasures.Contains(measure)) | GRID_SET | _si.SetValue | (rowIndex, _currColumnIndex, _values[measure]) | 그리드 값 설정 |  |  |  |
| AC-732685c6 | (진입점 미연결) | EltrUtils.cs:1083 | if (!_itemMeasures.Contains(measure)) | GRID_SET | _si.SetValue | (rowIndex, 0, "M") | 그리드 값 설정 |  |  |  |

## EltrCurrentCapaMeasureSet.ApplyToSheetOnlyEditMode

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3348854 | (진입점 미연결) | EltrUtils.cs:1121 | if (rowIdx != -1) | GRID_SET | _si.SetValue | (rowIdx, 0, "M") | 그리드 값 설정 |  |  |  |

## EltrCurrentCapaMeasureSet.GetBaseColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5562b4a8 | (진입점 미연결) | EltrUtils.cs:963 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetDayCount

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1034c432 | (진입점 미연결) | EltrUtils.cs:93 |  | CALL_EXT | DateTime.DaysInMonth | (int.Parse(yyyy), int.Parse(mm)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cab7ade3 | (진입점 미연결) | EltrUtils.cs:93 |  | RETURN | return DateTime.DaysInMonth(int.Parse(yyyy), int.Parse(mm)); |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetIGofTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24451227 | (진입점 미연결) | EltrUtils.cs:1377 |  | RETURN | return GetValueFromMeasureTable(measure, "IPRV_GOL_TP"); |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetItemPPMs

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a23fb54 | .ctor | EltrUtils.cs:1264 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) | DATA_OP | res.Add | (currItemId, value) | 데이터 객체 조작/조회 |  |  |  |
| AC-98b99259 | .ctor | EltrUtils.cs:1272 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetItemValues

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ else of (!_itemMeasures.Contains(measure))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c181bf6e | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ else of (!_… | EltrUtils.cs:1180 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ try | CALL_EXT | _si.GetValue2 | (r, currColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-001a0eb3 | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ else of (!_… | EltrUtils.cs:1186 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) | DATA_OP | res.Add | (currItemId, value) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d387de7 | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ else of (!_… | EltrUtils.cs:1194 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetLossColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75845fcc | (진입점 미연결) | EltrUtils.cs:989 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetMeasureIndexOfTable

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemMeasures.Contains(measure))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30187c91 | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemM… 외 1 | EltrUtils.cs:1069 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetMonthList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1ae760 | (진입점 미연결) | EltrUtils.cs:102 | while (startDate <= endDate) | DATA_OP | res.Add | (startDate.ToString("yyyyMM")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de26ba3b | (진입점 미연결) | EltrUtils.cs:107 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetPlanColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-232c4abe | (진입점 미연결) | EltrUtils.cs:1015 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetResultColumnIndex

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-348b6e0b | (진입점 미연결) | EltrUtils.cs:948 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetRowIndexOfMeasure

진입점: .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemMeasures.Contains(measure))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587b30ae | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemM… 외 1 | EltrUtils.cs:1030 | if (currMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-16df6c5e | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemM… 외 1 | EltrUtils.cs:1035 | if (toFindMeasureIdx == -1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-dbc2b3eb | .ctor [foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemM… 외 1 | EltrUtils.cs:1041 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetValueFromDayCntTableByItem

진입점: .ctor [try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a624d78e | .ctor [try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure … | EltrUtils.cs:211 | try | CALL_EXT | DBUtils.GetAndFilterString | ( new List<string>() { "VER_ID", "VER_SEQ", "DIVISION_ID", "COMPANY_ID", "SITE_ID", "PLANT… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aec14aa5 | .ctor [try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure … | EltrUtils.cs:227 | try | DATA_OP | DBUtils.Filter | (_tblDayCnt, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1a92a4b5 | .ctor [try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure … | EltrUtils.cs:238 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.GetValueFromMeasureTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb9a81ca | (진입점 미연결) | EltrUtils.cs:1396 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## EltrCurrentCapaMeasureSet.Init

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0582f79b | .ctor | EltrUtils.cs:1307 |  | FLAG | _measureColumnIndex | _si.GetColumnIndex(_measureColumnNameofSheet) | 화면 필드/플래그 변경 |  |  |  |
| AC-9dd50c9f | .ctor | EltrUtils.cs:1308 |  | FLAG | _itemIdColumnIndex | _si.GetColumnIndex(_itemIdColumnNameofSheet) | 화면 필드/플래그 변경 |  |  |  |
| AC-47a99a55 | .ctor | EltrUtils.cs:1313 | if (this._values.Count > 0) | CALL_EXT | this._values.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d5b3188 | .ctor | EltrUtils.cs:1316 |  | FLAG | _currColumnName | _si.GetColumnTag(currColumnIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-313432d9 | .ctor | EltrUtils.cs:1326 | foreach (DataRow r in _tblMeasure.Rows) | DATA_OP | _itemMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-d04c9739 | .ctor | EltrUtils.cs:1337 | foreach (DataRow r in _tblMeasure.Rows) ▸ if (!_itemMeasures.Contains(measure)) | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a092cce | .ctor | EltrUtils.cs:1343 | foreach (DataRow r in _tblMeasure.Rows) ▸ else of (!_itemMeasures.Contains(measure)) | DATA_OP | this._values.Add | (measure, v) | 데이터 객체 조작/조회 |  |  |  |
| AC-770dd3f3 | .ctor | EltrUtils.cs:1351 |  | DATA_OP | this._values.Add | ("SPEED_PPM", vSpeedPPM) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d45d0c0 | .ctor | EltrUtils.cs:1355 |  | DATA_OP | this._values.Add | ("SPEED_BASE_PPM", vSpeedBasePPM) | 데이터 객체 조작/조회 |  |  |  |

## EltrCurrentCapaMeasureSet.InitLineInfo

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34a2824c | .ctor | EltrUtils.cs:1127 |  | FLAG | _lineIdxColumnIndex | _si.GetColumnIndex("LINE_IDX") | 화면 필드/플래그 변경 |  |  |  |
| AC-501a30a3 | .ctor | EltrUtils.cs:1131 | if (_lineIdxColumnIndex > -1) | FLAG | _currLINE_IDX | (int)_si.GetValue2(_currRowIndex, _lineIdxColumnIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-081b0efb | .ctor | EltrUtils.cs:1131 | if (_lineIdxColumnIndex > -1) | CALL_EXT | _si.GetValue2 | (_currRowIndex, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bee1e544 | .ctor | EltrUtils.cs:1136 | for (r >= 0) | CALL_EXT | _si.GetValue2 | (r, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-064cb672 | .ctor | EltrUtils.cs:1140 | for (r >= 0) ▸ if (lineIdx == _currLINE_IDX) | FLAG | _firstlineRowIndex | r | 화면 필드/플래그 변경 |  |  |  |
| AC-70e339b2 | .ctor | EltrUtils.cs:1150 | for (r <= _si.GetMaxRowIndex()) | CALL_EXT | _si.GetValue2 | (r, _lineIdxColumnIndex) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a28f913 | .ctor | EltrUtils.cs:1154 | for (r <= _si.GetMaxRowIndex()) ▸ if (lineIdx == _currLINE_IDX) | FLAG | _lastlineRowIndex | r | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcLD_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddc1b789 | (진입점 미연결) | EltrUtils.cs:871 |  | FLAG | LD_RT | 100 - (ID_RT //Idle_LOB 설비대기 + NM_RT) | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcOP_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7313a55a | (진입점 미연결) | EltrUtils.cs:861 |  | FLAG | OP_RT | 100 - (BM_RT //BM + CM_RT //CM + PD_RT //PD + PM_RT //PM + UD_RT //UT Down + PP_RT //생산준비 … | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcPROD_CAPA_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-215b0388 | (진입점 미연결) | EltrUtils.cs:903 | foreach (var k in PROD_CAPA_D.ToList()) | DATA_OP | PROD_CAPA_D[k.Key] | THRY_CAPA_D[k.Key] * (PROD_OP_RT / (decimal)100) | 행/컬럼 값 대입 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcPROD_CAPA_M

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12cba338 | (진입점 미연결) | EltrUtils.cs:911 | foreach (var k in PROD_CAPA_M.ToList()) | DATA_OP | PROD_CAPA_M[k.Key] | PROD_CAPA_D[k.Key] * DAY_CNT | 행/컬럼 값 대입 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcPROD_OP_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dfbaa22 | (진입점 미연결) | EltrUtils.cs:886 |  | FLAG | PROD_OP_RT | (LD_RT / (decimal)100) //부하율 * (OP_RT / (decimal)100) //시간가동률 * (PF_RT / (decimal)100) //성… | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcTEEP

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f7a6d20 | (진입점 미연결) | EltrUtils.cs:877 |  | FLAG | TEEP | (AV_RT / (decimal)100) //조업율 * (LD_RT / (decimal)100) //부하율 * (OP_RT / (decimal)100) //시간가… | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcTHRY_CAPA_D

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2310280 | (진입점 미연결) | EltrUtils.cs:896 | foreach (var k in THRY_CAPA_D.ToList()) | DATA_OP | THRY_CAPA_D[k.Key] | PPM[k.Key] * (decimal)1440 * EQP_TYPE_QTY | 행/컬럼 값 대입 |  |  |  |

## EltrCurrentCapaMeasureSet.recalcWT_RT

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1529bba8 | (진입점 미연결) | EltrUtils.cs:916 |  | FLAG | WT_RT | DAY_CNT - (SD_RT + TD_RT + MC_RT + SCP_PROD_PLAN_DDN) | 화면 필드/플래그 변경 |  |  |  |

## EltrCurrentCapaMeasureSet.SetItemValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2f60a82 | (진입점 미연결) | EltrUtils.cs:1292 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ foreach (var k in values) ▸ if (currItemId == k.Key) | GRID_SET | _si.SetValue | (r, currColumnIndex, k.Value) | 그리드 값 설정 |  |  |  |
| AC-46928679 | (진입점 미연결) | EltrUtils.cs:1294 | try ▸ for (r <= _lastlineRowIndex) ▸ if (currMeasure == measure) ▸ foreach (var k in values) ▸ if (currItemId == k.Key) | GRID_SET | _si.SetValue | (r, 0, "M") | 그리드 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan._defaultDataModel_Changed

진입점: _defaultDataModel.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13690f55 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2949 | if (_si == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-061a2801 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2952 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-883d19e2 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2955 | if ((e.Row == -1) \|\| (e.Column == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0971c87 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2958 | if (_si.IsLock(_si.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d14b8b5b | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2962 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3c3e712e | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2965 |  | CALL_EXT | _si.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a0f825e | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2966 | if (_si.IsLockCell(e.Row, e.Column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-558c6a6f | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2988 | if (_progress_status == ProgressStatusType._CURRENT) | DATA_OP | this._editableMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-90005137 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2989 | if (_progress_status == ProgressStatusType._CURRENT) ▸ if (!this._editableMeasures.Contains(measure)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7885d1d3 | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2995 | else of (_progress_status == ProgressStatusType._CURRENT) ▸ if (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type == SheetTy… | DATA_OP | this._recalcLineMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-4259876e | _defaultDataModel.Changed | SCP0106_CAPA_Loss_Plan.cs:2996 | else of (_progress_status == ProgressStatusType._CURRENT) ▸ if (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type == SheetTy… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-773da37b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2750 |  | GRID_BIND | _si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8f4814da | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2765 |  | FLAG | _tblOriginal | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-333cd90a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2765 |  | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10467251 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2769 | if (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) | FLAG | _tblMeasure | ds.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f67704c1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2769 | if (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5e2ffa6 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2770 | if (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) | FLAG | _tblDayCnt | ds.Tables[2].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-6320102a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2770 | if (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) | DATA_OP | ds.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5ce12a2 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2774 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ if ((_progress_status == Progre… | FLAG | _tblMeasure | ds.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-be3f4f7c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2774 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ if ((_progress_status == Progre… | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7b00a4af | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2778 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | FLAG | _tblProdCapaD | ds.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-7f768e45 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2778 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | DATA_OP | ds.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f8d8802 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2779 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | FLAG | _tblMeasure | ds.Tables[2].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c7ef2bc | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2779 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | DATA_OP | ds.Tables[2].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9feb7866 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2783 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | FLAG | _tblDayCnt | ds.Tables[3].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-eb46eec2 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2783 | else of (_progress_status == ProgressStatusType._CURRENT \|\| _progress_status == ProgressStatusType._PRE) ▸ else of ((_progress_status == P… | DATA_OP | ds.Tables[3].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97414f21 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2789 |  | GRID_LOCK | _si.LockColumn | (0, _si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-af1bc2fe | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2794 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9f0c28cf | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2798 | if (this.IsEditMode) | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.AfterSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13aafd30 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3006 |  | CALL_BASE | this._CloseProgress | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd4a967e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3011 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69bed513 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3020 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0106_CAPA_Loss_Plan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10780bf1 | this.btnColumn.Click | SCP0106_CAPA_Loss_Plan.cs:4363 |  | POPUP | new SCM002_CAPAColumnPopup | ("SCP0106", _sheet_name, true) | 팝업/폼 생성 |  |  |  |
| AC-9fa4e89b | this.btnColumn.Click | SCP0106_CAPA_Loss_Plan.cs:4364 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-570e5cf5 | this.btnColumn.Click | SCP0106_CAPA_Loss_Plan.cs:4366 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0106_CAPA_Loss_Plan.btnItem_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25ed3f4b | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4343 | if (nicknames != "") | VALUE_SET | txtItem.Text | nicknames | 컨트롤 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.cboSheetType_SelectedIndexChanged

진입점: this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de63d39c | this.cboProgressStatus.SelectedIndexChanged 외 1 | SCP0106_CAPA_Loss_Plan.cs:3492 | if ((this._progress_status == ProgressStatusType._1ST_CUTOFF \|\| this._progress_status == ProgressStatusType._2ND_CUTOFF) && …) | UI_PROP | lciShowRate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8c847701 | this.cboProgressStatus.SelectedIndexChanged 외 1 | SCP0106_CAPA_Loss_Plan.cs:3496 | else of ((this._progress_status == ProgressStatusType._1ST_CUTOFF \|\| this._progress_status == ProgressStatusType._2ND_CUTOFF) && …) | UI_PROP | lciShowRate.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.ChangeColumnNameToCodeName

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15d4330b | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1103 |  | DATA_OP | tbl.Columns.Contains | (codeColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-a95736e0 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1105 | if (tbl.Columns.Contains(codeColumnName)) | GRID_SET | tbl.Columns[codeColumnName].ColumnName | "CODE" | 그리드 속성/값 설정 |  |  |  |
| AC-e13ba01f | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1108 |  | DATA_OP | tbl.Columns.Contains | (nameColumnName) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5210da7 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1110 | if (tbl.Columns.Contains(nameColumnName)) | GRID_SET | tbl.Columns[nameColumnName].ColumnName | "NAME" | 그리드 속성/값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.CheckChangedValues

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8438e79d | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2628 | else of (base._si.ActiveSheet.RowCount != _tblOriginal.Rows.Count) ▸ for (r <= base._si.ActiveSheet.RowCount - 1) ▸ for (c <= base._si.Activ… | DATA_OP | _tblOriginal.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-b05bf0c2 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2641 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba9530e3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1515 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-72a9987e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1516 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0b4ac1d | this.Load | SCP0106_CAPA_Loss_Plan.cs:1587 | foreach (KeyValuePair<string, int> kvp in this._SHEETS) | GRID_INIT | this.AddSheet | (spdMain, kvp.Key, kvp.Key, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0106_CAPA_Loss_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dce6ec4 | DeleteButton | SCP0106_CAPA_Loss_Plan.cs:2585 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57c0d037 | DeleteButton | SCP0106_CAPA_Loss_Plan.cs:2588 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fb9c84b | DeleteButton | SCP0106_CAPA_Loss_Plan.cs:2591 | if (_si.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-745b6668 | DeleteButton | SCP0106_CAPA_Loss_Plan.cs:2598 | if (action == CAppSetting.FlagI) | DATA_OP | _si.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0106_CAPA_Loss_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c55835c7 | Dispose | SCP0106_CAPA_Loss_Plan.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0106_CAPA_Loss_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11f7e9be | EditButton | SCP0106_CAPA_Loss_Plan.cs:2490 | if (spdMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d88d70a | EditButton | SCP0106_CAPA_Loss_Plan.cs:2493 | if (_si.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4a5f05d | EditButton | SCP0106_CAPA_Loss_Plan.cs:2497 | if (this._currVersionProgressStatus == ProgressStatusType._PRE) | MESSAGE | MessageHelper.GMessageBox | ("MSG00419", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4c02120 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2499 | if (this._currVersionProgressStatus == ProgressStatusType._PRE) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10daf884 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2504 | if (this._currVersionProgressStatus == ProgressStatusType._2ND_CUTOFF) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf4bf766 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2506 | if (this._currVersionProgressStatus == ProgressStatusType._2ND_CUTOFF) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc2f19d1 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2513 | if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF) ▸ if (this._progress_status == ProgressStatusType._1ST_CUTOFF && this… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13aa40df | EditButton | SCP0106_CAPA_Loss_Plan.cs:2515 | if (this._currVersionProgressStatus == ProgressStatusType._1ST_CUTOFF) ▸ if (this._progress_status == ProgressStatusType._1ST_CUTOFF && this… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5d5bc48a | EditButton | SCP0106_CAPA_Loss_Plan.cs:2519 |  | GRID_LOCK | _si.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0ae1d7a8 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2555 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, DefColumns.PFRSLT_QTY, DEF_DATE_COL_WIDTH_EDIT, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81fb0745 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2556 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, DefColumns.BASE_QTY, DEF_DATE_COL_WIDTH_EDIT, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4af2bc9c | EditButton | SCP0106_CAPA_Loss_Plan.cs:2560 | else of (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, DefColumns.PFRSLT_QTY, DEF_DATE_COL_WIDTH, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69fe47d8 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2561 | else of (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, DefColumns.BASE_QTY, DEF_DATE_COL_WIDTH, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaeaeb9a | EditButton | SCP0106_CAPA_Loss_Plan.cs:2570 | foreach (string dateCol in _sheetDateColumns) ▸ if (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, COLUMN_NAME, DEF_DATE_COL_WIDTH_EDIT, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-69a3c905 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2574 | foreach (string dateCol in _sheetDateColumns) ▸ else of (this.IsEditMode) | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, COLUMN_NAME, DEF_DATE_COL_WIDTH, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a8e9043 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2578 |  | CALL_EXT | SheetUtils.SetColumHide | (_si) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4464d36 | FindButton | SCP0106_CAPA_Loss_Plan.cs:2075 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-f5b018b0 | FindButton | SCP0106_CAPA_Loss_Plan.cs:2076 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdde06ef | FindButton | SCP0106_CAPA_Loss_Plan.cs:3354 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GET_CAPA_LOSS_PLAN, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0106_CAPA_Loss_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a4191c3 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1184 |  | DATA_OP | this._SHEETS.Add | (SHEETS._CURRENT_ASSEMBLY, 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-93175a6d | this.Load | SCP0106_CAPA_Loss_Plan.cs:1185 |  | DATA_OP | this._SHEETS.Add | (SHEETS._CUTOFF_MODEL_ASSEMBLY, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b94770b4 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1186 |  | DATA_OP | this._SHEETS.Add | (SHEETS._1ST_CUTOFF_LINE_ASSEMBLY, 2) | 데이터 객체 조작/조회 |  |  |  |
| AC-caad8f39 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1187 |  | DATA_OP | this._SHEETS.Add | (SHEETS._2ND_CUTOFF_LINE_ASSEMBLY, 3) | 데이터 객체 조작/조회 |  |  |  |
| AC-4386a971 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1188 |  | DATA_OP | this._SHEETS.Add | (SHEETS._CURRENT_ELTR, 4) | 데이터 객체 조작/조회 |  |  |  |
| AC-11e0622a | this.Load | SCP0106_CAPA_Loss_Plan.cs:1189 |  | DATA_OP | this._SHEETS.Add | (SHEETS._CUTOFF_MODEL_ELTR, 5) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f0220a4 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1190 |  | DATA_OP | this._SHEETS.Add | (SHEETS._1ST_CUTOFF_LINE_ELTR, 6) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd8b836b | this.Load | SCP0106_CAPA_Loss_Plan.cs:1191 |  | DATA_OP | this._SHEETS.Add | (SHEETS._2ND_CUTOFF_LINE_ELTR, 7) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e8da329 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1193 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) ▸ if (currColName.Equals("BASE_QTY")) ▸ for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ if (colName.Substring(0, 4).Equals("M_00"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aba25094 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3687 | try | CALL_EXT | cmsBase.GetIGofTable | (measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ced79ac5 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3695 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetCalcEltrRt

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-306f10fb | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3706 | try | CALL_EXT | cmsBase.GetIGofTable | (measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0177e3c4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3714 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetCalcRt

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) ▸ if (currColName.Equals("BASE_QTY")) ▸ for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ if (colName.Substring(0, 4).Equals("M_00")) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3303865b | _defaultDataModel.Changed [if (_progress_status == ProgressS… 외 1 | SCP0106_CAPA_Loss_Plan.cs:3752 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f430ffb | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:834 | try | CALL_EXT | _curr_row.Columns | (DefColumns.COMPANY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d2ec146 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:840 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4cd8ad0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:858 | try | CALL_EXT | _curr_row.Columns | (DefColumns.DIVISION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f074d9a3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:864 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd4efb5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1002 | try | CALL_EXT | _curr_row.Columns | (DefColumns.ELTR_LN_TP_CD) | ⚠ 의미 확인 필요 |  |  |  |
| AC-35431116 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1008 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73f761ad | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:930 | try | CALL_EXT | _curr_row.Columns | (DefColumns.FACTORY_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12764b99 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:936 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec00252d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:954 | try | CALL_EXT | _curr_row.Columns | (DefColumns.LINE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-60c07131 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:960 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cfec194 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1050 | try | CALL_EXT | _curr_row.Columns | (DefColumns.MEASURE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02d16f92 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1056 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e9b8066 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1026 | try | CALL_EXT | _curr_row.Columns | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4294f763 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1032 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da71abe4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:978 | try | CALL_EXT | _curr_row.Columns | (DefColumns.OPERATION_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c355703 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:984 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b7ecc80 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:882 | try | CALL_EXT | _curr_row.Columns | (DefColumns.PLANT_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca7b887c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:888 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetCurrSheetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d38c5109 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3882 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getCurrSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb63b07c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:906 | try | CALL_EXT | _curr_row.Columns | (DefColumns.SITE_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0cbec53 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:912 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetCurrVersionProgessStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e658b9d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1246 | try | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE", "VER_SEQ" }, new List<string>() { _division, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-78154f9d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1248 | try | FLAG | dtProgressStatusCurr | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5b57110 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1248 | try | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ee9895c4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1259 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2a1fe13 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:229 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtDivision, cboDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-483e5382 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:235 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getDivisionType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0b7086e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:210 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getElectrodeType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-110f4152 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:781 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtElectrode, clbElectrodeType.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8d2388f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:787 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cad5d3cd | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:685 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtFactory, clbFactory.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24535918 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:691 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b905f9ad | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:763 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b739425 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:709 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtLine, clbLine.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73e0c18b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:715 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetMeasureIdx

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0152aa86 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2686 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "LOSS_CD" }, new List<string>() { measure }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e6425ce | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2688 |  | DATA_OP | DBUtils.Filter | (this._tblMeasure, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f94218a5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2695 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42e4ab4b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:733 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtOperation, clbOperation.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a90b1b33 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:739 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f628ef50 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:661 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtPlant, clbPlant.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-91b36b4f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:667 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b94c5ba0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:323 |  | CALL_EXT | ScpCapaBL.GetPlanType | (dtVersionAll, _division, _version, _version_seq) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3539da25 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:323 |  | RETURN | return ScpCapaBL.GetPlanType(dtVersionAll, _division, _version, _version_seq); |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getProgressStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0ac458f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:572 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetRowIdxOfMeasure

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f00a8d9 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2715 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getSheetType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24f12b81 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:596 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getShopGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b66f1b74 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:643 |  | CALL_EXT | ScpCapa.GetShopGroupId | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b624e60 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:643 |  | RETURN | return ScpCapa.GetShopGroupId(_division_type); |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cee5b93 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:623 | try | CALL_EXT | CString.GetCheckedListValueNone | (dtSite, clbSite.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16f29516 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:629 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.GetSpdTitle

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b873bf30 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1601 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0104_GET_SPREAD_TITLE") ⇒ SCP.SCP0104_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-75cc1655 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1603 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | this._from_yyyymm | 행/컬럼 값 대입 |  |  |  |
| AC-2c4e2098 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1604 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0106" | 행/컬럼 값 대입 |  |  |  |
| AC-94b4dc19 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1605 |  | DATA_OP | request.Parameters["p_sheet_name"] | this._sheet_status | 행/컬럼 값 대입 |  |  |  |
| AC-c9df3627 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1607 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-3adc0f16 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1607 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5103365 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1611 |  | FLAG | this._sheetDateColumns | DBUtils.GetStringColumnValues(dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-92fb1982 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1611 |  | CALL_EXT | DBUtils.GetStringColumnValues | (dsSpdTitle.Tables[0], DateColumns.COLUMN_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4094566c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1612 |  | FLAG | this._sheetDateColumns | this._sheetDateColumns.Where(w => !w.Contains("_ASSIGN_PRIORITY")).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcc7982f | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1612 | lambda | DATA_OP | w.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-f53e45d3 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1614 |  | FLAG | this._sheetNumericColumns | new List<string>() { DefColumns.PFRSLT_QTY, DefColumns.BASE_QTY } | 화면 필드/플래그 변경 |  |  |  |
| AC-e6d12a0a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1618 | foreach (string dateCol in _sheetDateColumns) | DATA_OP | this._sheetNumericColumns.Add | (dateCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c662270 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:262 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.getVersionSeq

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f34652c3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:309 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb51d13c | this.Load | SCP0106_CAPA_Loss_Plan.cs:1483 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-13ae28c3 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1486 |  | DATA_OP | ReadOnlySheetList.Add | (SHEETS._CURRENT_ASSEMBLY) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8662408 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1489 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f7f4f15f | this.Load | SCP0106_CAPA_Loss_Plan.cs:1493 | if (cboSheetType.Items.Count > 0) | LIST_CLEAR | cboSheetType.Items.Clear | () | 목록 항목 비움 |  |  |  |
| AC-fc8bcb01 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1496 |  | DATA_OP | cboSheetType.Items.Add | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-08bdd94c | this.Load | SCP0106_CAPA_Loss_Plan.cs:1497 |  | DATA_OP | cboSheetType.Items.Add | ("LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc0c33e2 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1499 |  | VALUE_SET | cboSheetType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.InitDatasAll

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d215e928 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1090 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-04026a6a | this.Load | SCP0106_CAPA_Loss_Plan.cs:1090 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b290c4d8 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1083 |  | DATA_OP | QueryDics.Add | (DIC_GET_CAPA_LOSS_PLAN, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cba5310 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1084 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LOSS_PLAN_MODEL, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a4101d7 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1085 |  | DATA_OP | QueryDics.Add | (DIC_SAVE_CAPA_LOSS_PLAN_LINE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0106_CAPA_Loss_Plan.InitSpread

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0a64285 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1625 |  | UI_PROP | spdMain.TabStripPolicy | TabStripPolicy.Never | 속성 TabStripPolicy 설정 |  |  |  |
| AC-3aa8cc52 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1629 | for (i <= spdMain.Sheets.Count - 1) | GRID_SET | spdMain.Sheets[i].Visible | (i == this._sheet_idx) | 그리드 속성/값 설정 |  |  |  |
| AC-4d5e6db1 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1632 |  | FLAG | _si | GetSheetInfo(spdMain.Name, _sheet_idx) | 화면 필드/플래그 변경 |  |  |  |
| AC-2b80fe93 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1634 |  | CALL_EXT | SheetUtils.ClearDataSoure | (_si) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8547ac6e | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1636 |  | GRID_INIT | _si.InitSheet | (this._sheet_idx) | 그리드 재구성/초기화 |  |  |  |
| AC-7d2d3f4a | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1638 |  | GRID_INIT | _si.ChangeSheet | (this._sheet_idx) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.IsFormationChagned

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e624dbe | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2943 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.IsGoal

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a29dd3b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3618 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.IsLockClipboardRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d13ea7c5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2016 | try ▸ for (r <= _selEndRow) ▸ for (c <= _selEndCol) | CALL_EXT | _si.IsLockCell | (r, c) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e17cc9d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2029 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.MergeKeyColumns

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-450bb77b | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1811 | for (c <= toIdx) ▸ if (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (headers.Cou… | DATA_OP | headers.Add | (c - 1, _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c03bfcc | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1814 | for (c <= toIdx) ▸ if (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) | DATA_OP | headers.Add | (c, _si.ActiveSheet.ColumnHeader.Columns[c].Label) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fcdb09c | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1820 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (0, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53437448 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1821 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (1, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-899aaf60 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1822 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | GRID_INIT | _si.ColumnHeaderSpan | (2, headers.First().Key, 1, headers.Count, 20, headers.First().Value, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13dcb3ba | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1824 | for (c <= toIdx) ▸ else of (_si.ActiveSheet.ColumnHeader.Columns[c].Label == _si.ActiveSheet.ColumnHeader.Columns[c - 1].Label) ▸ if (header… | CALL_EXT | headers.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetLossColumnAllAssembly

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faa2f773 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3809 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-575cbf1e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3824 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a33c05f2 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3826 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1862f036 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3827 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-261b9313 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3828 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d184be4b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3829 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-294cfc24 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3830 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aadf407b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3831 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1dec350 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3832 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetLossColumnAllEltr

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16fc2a52 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3840 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16b136ca | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3855 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8255f90 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3857 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7170b6b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3858 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-47b22b6c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3859 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-27bcf6c6 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3860 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-397f230a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3861 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a1a6c70 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3862 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b93702f1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3863 | for (i <= _datePlanEndColIdx) ▸ if (columnName.Substring(0, 4).Equals("M_00")) | CALL_EXT | lossMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnAllAssembly

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) ▸ if (currColName.Equals("BASE_QTY"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f38ba78f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3902 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c30492e2 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3905 | if ((rowIdx == -1) \|\| (colIdx == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10b93f9d | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3907 |  | FLAG | this.currSheetRowIdx | rowIdx | 화면 필드/플래그 변경 |  |  |  |
| AC-474dd8fe | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3920 | for (i <= _dateEndColIdx) | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-76fe02ac | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3961 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f65f75c0 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3963 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-975b84b7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3964 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfdf7b14 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3965 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-94562361 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3966 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f376bd2 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3967 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f8fa90f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3968 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4db39d29 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3969 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnAllEltr

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) ▸ if (currColName.Equals("BASE_QTY"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-921b0d8a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3979 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9418065d | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3982 | if ((rowIdx == -1) \|\| (colIdx == -1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db7ea371 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3984 |  | FLAG | this.currSheetRowIdx | rowIdx | 화면 필드/플래그 변경 |  |  |  |
| AC-25043163 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3997 | for (i <= _dateEndColIdx) | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4124b40 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4038 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9eb62355 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4048 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-15c012f9 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4049 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b620e9c3 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4050 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bfad3fb | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4051 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-33579ec8 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4052 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e924c72 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4053 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-635bca62 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4054 | for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ else of (colName.Substring(0, 4).Equals("M_00")) | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnOneAssembly

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) ▸ if (currColName.Equals("BASE_QTY")) ▸ for (i <= _dateEndColIdx) ▸ if (!isPriorityNone) ▸ if (colName.Substring(0, 4).Equals("M_00"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e69a8965 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3628 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c2cf0e7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3635 |  | CALL_EXT | cmsLoss.GetBaseColumnIndex | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d2f0c649 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3636 |  | CALL_EXT | cmsLoss.GetPlanColumnIndex | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c5c64fa | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3642 |  | UI_PROP | cmsPlan.PF_RT | GetCalcAssemblyRt(cmsBase, cmsBase.PF_RT, cmsLoss.PF_RT, LossMeasures.PF_RT) | 속성 PF_RT 설정 |  |  |  |
| AC-97ecdfc5 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3643 |  | UI_PROP | cmsPlan.QL_RT | GetCalcAssemblyRt(cmsBase, cmsBase.QL_RT, cmsLoss.QL_RT, LossMeasures.QL_RT) | 속성 QL_RT 설정 |  |  |  |
| AC-4554bd43 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3644 |  | UI_PROP | cmsPlan.ID_RT | GetCalcAssemblyRt(cmsBase, cmsBase.ID_RT, cmsLoss.ID_RT, LossMeasures.ID_RT) | 속성 ID_RT 설정 |  |  |  |
| AC-2b729349 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3645 |  | UI_PROP | cmsPlan.NM_RT | GetCalcAssemblyRt(cmsBase, cmsBase.NM_RT, cmsLoss.NM_RT, LossMeasures.NM_RT) | 속성 NM_RT 설정 |  |  |  |
| AC-55122d53 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3646 |  | UI_PROP | cmsPlan.BM_RT | GetCalcAssemblyRt(cmsBase, cmsBase.BM_RT, cmsLoss.BM_RT, LossMeasures.BM_RT) | 속성 BM_RT 설정 |  |  |  |
| AC-2c6c6b26 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3647 |  | UI_PROP | cmsPlan.CM_RT | GetCalcAssemblyRt(cmsBase, cmsBase.CM_RT, cmsLoss.CM_RT, LossMeasures.CM_RT) | 속성 CM_RT 설정 |  |  |  |
| AC-f0478d2b | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3648 |  | UI_PROP | cmsPlan.PD_RT | GetCalcAssemblyRt(cmsBase, cmsBase.PD_RT, cmsLoss.PD_RT, LossMeasures.PD_RT) | 속성 PD_RT 설정 |  |  |  |
| AC-65f3211b | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3649 |  | UI_PROP | cmsPlan.PM_RT | GetCalcAssemblyRt(cmsBase, cmsBase.PM_RT, cmsLoss.PM_RT, LossMeasures.PM_RT) | 속성 PM_RT 설정 |  |  |  |
| AC-c5c80176 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3650 |  | UI_PROP | cmsPlan.UD_RT | GetCalcAssemblyRt(cmsBase, cmsBase.UD_RT, cmsLoss.UD_RT, LossMeasures.UD_RT) | 속성 UD_RT 설정 |  |  |  |
| AC-a392e62a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3651 |  | UI_PROP | cmsPlan.PP_RT | GetCalcAssemblyRt(cmsBase, cmsBase.PP_RT, cmsLoss.PP_RT, LossMeasures.PP_RT) | 속성 PP_RT 설정 |  |  |  |
| AC-6576007f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3652 |  | UI_PROP | cmsPlan.MR_RT | GetCalcAssemblyRt(cmsBase, cmsBase.MR_RT, cmsLoss.MR_RT, LossMeasures.MR_RT) | 속성 MR_RT 설정 |  |  |  |
| AC-4fead6f6 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3654 |  | CALL_EXT | cmsPlan.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-26128627 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3656 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PF_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-efc4aadf | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3657 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("QL_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-50751b3a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3658 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("ID_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fb6056f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3659 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("NM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7bf3c85 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3660 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("BM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfc347d1 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3661 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("CM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-412bcfef | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3662 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-87b07e1c | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3663 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-71fcff87 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3664 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("UD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9b491bd | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3665 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-79a73cf7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3666 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("MR_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-04852d4d | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3668 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ab86c3e | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3669 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac42c414 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3670 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1592ba09 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3672 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b7a51ed | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3673 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-86767120 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3674 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-46f9ce1c | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:3675 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnOneEltr

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e098394 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3758 | if (_si.GetMaxRowIndex() == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ec5801c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3762 |  | CALL_EXT | cmsLoss.GetBaseColumnIndex | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1907a7a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3763 |  | CALL_EXT | cmsLoss.GetPlanColumnIndex | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-af269b1c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3768 |  | UI_PROP | cmsPlan.PF_RT | GetCalcEltrRt(cmsBase, cmsBase.PF_RT, cmsLoss.PF_RT, LossMeasures.PF_RT) | 속성 PF_RT 설정 |  |  |  |
| AC-671c8fcd | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3769 |  | UI_PROP | cmsPlan.QL_RT | GetCalcEltrRt(cmsBase, cmsBase.QL_RT, cmsLoss.QL_RT, LossMeasures.QL_RT) | 속성 QL_RT 설정 |  |  |  |
| AC-17d6ea73 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3770 |  | UI_PROP | cmsPlan.ID_RT | GetCalcEltrRt(cmsBase, cmsBase.ID_RT, cmsLoss.ID_RT, LossMeasures.ID_RT) | 속성 ID_RT 설정 |  |  |  |
| AC-6d40e5f1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3771 |  | UI_PROP | cmsPlan.NM_RT | GetCalcEltrRt(cmsBase, cmsBase.NM_RT, cmsLoss.NM_RT, LossMeasures.NM_RT) | 속성 NM_RT 설정 |  |  |  |
| AC-8589ce9a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3772 |  | UI_PROP | cmsPlan.BM_RT | GetCalcEltrRt(cmsBase, cmsBase.BM_RT, cmsLoss.BM_RT, LossMeasures.BM_RT) | 속성 BM_RT 설정 |  |  |  |
| AC-ad6141fe | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3773 |  | UI_PROP | cmsPlan.CM_RT | GetCalcEltrRt(cmsBase, cmsBase.CM_RT, cmsLoss.CM_RT, LossMeasures.CM_RT) | 속성 CM_RT 설정 |  |  |  |
| AC-40cc4019 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3774 |  | UI_PROP | cmsPlan.PD_RT | GetCalcEltrRt(cmsBase, cmsBase.PD_RT, cmsLoss.PD_RT, LossMeasures.PD_RT) | 속성 PD_RT 설정 |  |  |  |
| AC-c30ca58a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3775 |  | UI_PROP | cmsPlan.PM_RT | GetCalcEltrRt(cmsBase, cmsBase.PM_RT, cmsLoss.PM_RT, LossMeasures.PM_RT) | 속성 PM_RT 설정 |  |  |  |
| AC-2280a0e9 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3776 |  | UI_PROP | cmsPlan.UD_RT | GetCalcEltrRt(cmsBase, cmsBase.UD_RT, cmsLoss.UD_RT, LossMeasures.UD_RT) | 속성 UD_RT 설정 |  |  |  |
| AC-4a16c368 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3777 |  | UI_PROP | cmsPlan.PP_RT | GetCalcEltrRt(cmsBase, cmsBase.PP_RT, cmsLoss.PP_RT, LossMeasures.PP_RT) | 속성 PP_RT 설정 |  |  |  |
| AC-c80f6dc0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3778 |  | UI_PROP | cmsPlan.MR_RT | GetCalcEltrRt(cmsBase, cmsBase.MR_RT, cmsLoss.MR_RT, LossMeasures.MR_RT) | 속성 MR_RT 설정 |  |  |  |
| AC-c50f8f6c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3780 |  | CALL_EXT | cmsPlan.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e90025e8 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3782 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PF_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaddb016 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3783 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("QL_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3efea75c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3784 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("ID_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-078cc356 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3785 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("NM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8927d8b0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3786 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("BM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfb7f890 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3787 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("CM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a7cccbf | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3788 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-97da5acf | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3789 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PM_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-02fb5e70 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3790 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("UD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-430b7032 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3791 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0908e328 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3792 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("MR_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f349d95 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3794 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bc6a96b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3795 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-81dce062 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3796 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-28a39302 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3798 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f90c0e5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3799 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa427062 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3800 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e51b7ab1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:3801 |  | CALL_EXT | cmsPlan.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCurrentAssembly

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3612c37 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4080 | if (currColName.Equals("BASE_QTY")) | FLAG | this._assemblyCurrBaseMeasureSet | new AssemblyCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx… | 화면 필드/플래그 변경 |  |  |  |
| AC-11f66448 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4082 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | this._assemblyCurrBaseMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaebe067 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4084 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cff55909 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4085 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-37e29f34 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4086 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7706c757 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4087 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f464e1c4 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4088 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fd792ac | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4089 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eadebaba | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4090 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-86556c88 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4096 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _assemblyCurrBaseMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdaf6548 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4101 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | FLAG | this._assemblyCurrPlanYearMeasureSet | new AssemblyCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b157e60 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4103 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | this._assemblyCurrPlanYearMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce980377 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4105 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-80674f07 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4106 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e865bb7a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4107 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ada375b | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4108 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-590947bc | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4109 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8e7b31e | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4110 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-65c7fae7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4111 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b9d54a7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4114 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _assemblyCurrPlanYearMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc3a252a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4143 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | FLAG | this._assemblyCurrPlanMeasureSet | new AssemblyCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx… | 화면 필드/플래그 변경 |  |  |  |
| AC-4bd39fc4 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4145 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | this._assemblyCurrPlanMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3136bb47 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4147 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc6051ae | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4148 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-943fdd4d | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4149 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-09db8096 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4150 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a606106 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4151 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f63794f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4152 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c968060 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4153 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-273d2cb6 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4155 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _assemblyCurrPlanMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCurrentEltr

진입점: _defaultDataModel.Changed [if (_progress_status == ProgressStatusType._CURRENT) ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-899ed440 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4165 | if (currColName.Equals("BASE_QTY")) | FLAG | this._eltrCurrBaseMeasureSet | new EltrCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx, co… | 화면 필드/플래그 변경 |  |  |  |
| AC-9edb169a | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4167 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | this._eltrCurrBaseMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ecf2bbb | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4180 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0217227 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4181 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7ce603c | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4182 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-45e7932d | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4183 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-96940150 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4184 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-409542b2 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4185 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e617c35 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4186 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa171e12 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4189 | if (currColName.Equals("BASE_QTY")) | CALL_EXT | _eltrCurrBaseMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f91f5a5 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4194 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | FLAG | this._eltrCurrPlanYearMeasureSet | new EltrCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx, co… | 화면 필드/플래그 변경 |  |  |  |
| AC-8f146ee6 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4196 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | this._eltrCurrPlanYearMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6fe734f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4198 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3e59102 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4199 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2ad4661 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4200 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6956a580 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4201 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e588e24 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4202 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc1abb4f | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4203 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-da5266a6 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4204 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-30572454 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4207 | else of (currColName.Equals("BASE_QTY")) ▸ if (currColName.Substring(0, 2).Equals("Y_")) | CALL_EXT | _eltrCurrPlanYearMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c11be4f9 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4236 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | FLAG | this._eltrCurrPlanMeasureSet | new EltrCurrentCapaMeasureSet(_si, _tblMeasure, _tblDayCnt, DefColumns.MEASURE, rowIdx, co… | 화면 필드/플래그 변경 |  |  |  |
| AC-fa798259 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4238 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | this._eltrCurrPlanMeasureSet.RecalcSelf | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-141e9b17 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4240 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("PROD_CAPA_M") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8ffd617 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4241 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("PROD_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d25f1546 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4242 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("THRY_CAPA_D") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9d9b46e2 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4243 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a7cfe60 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4244 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("LD_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eb401ba7 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4245 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("TEEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8652e3da | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4246 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheet | ("PROD_OP_RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c95ea88 | _defaultDataModel.Changed [if (_progress_status == ProgressS… | SCP0106_CAPA_Loss_Plan.cs:4248 | else of (currColName.Equals("BASE_QTY")) ▸ else of (currColName.Substring(0, 2).Equals("Y_")) ▸ if (currColName.Substring(0, 4).Equals("M_01… | CALL_EXT | _eltrCurrPlanMeasureSet.ApplyToSheetOnlyEditModeCurrent | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineAssembly

진입점: _defaultDataModel.Changed [else of (_progress_status == ProgressStatusType._CURRENT) ▸ if (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type == SheetType.LINE) ▸ if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aac60281 | _defaultDataModel.Changed [else of (_progress_status == Prog… | SCP0106_CAPA_Loss_Plan.cs:4256 |  | ENDPOINT | _defaultDataModel.GetDataTable | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96683c0e | _defaultDataModel.Changed [else of (_progress_status == Prog… | SCP0106_CAPA_Loss_Plan.cs:4262 |  | UI_MISC | cmsLine.Refresh | () | 화면 갱신/대기창 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineEltr

진입점: _defaultDataModel.Changed [else of (_progress_status == ProgressStatusType._CURRENT) ▸ if (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type == SheetType.LINE) ▸ else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fb31778 | _defaultDataModel.Changed [else of (_progress_status == Prog… | SCP0106_CAPA_Loss_Plan.cs:4269 |  | ENDPOINT | _defaultDataModel.GetDataTable | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0794e2b9 | _defaultDataModel.Changed [else of (_progress_status == Prog… | SCP0106_CAPA_Loss_Plan.cs:4275 |  | UI_MISC | cmsLine.Refresh | () | 화면 갱신/대기창 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshAllPre

진입점: this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ea694c9 | this.rgrpDivisionType.SelectedIndexChanged | SCP0106_CAPA_Loss_Plan.cs:1522 |  | FLAG | dtCapaLineMaster | ScpCapaBL.GetCapaLineMasterAll(_division_type) | 화면 필드/플래그 변경 |  |  |  |
| AC-19c64b79 | this.rgrpDivisionType.SelectedIndexChanged | SCP0106_CAPA_Loss_Plan.cs:1522 |  | CALL_EXT | ScpCapaBL.GetCapaLineMasterAll | (_division_type) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshColumnsVisible

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.chkShowRate.CheckedChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a93b7e0b | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1895 | for (c <= _si.GetMaxColumnIndex()) | DATA_OP | colName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-11ea98fb | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1897 | for (c <= _si.GetMaxColumnIndex()) ▸ if (colName.Contains("_ASSIGN_PRIORITY")) | GRID_STYLE | _si.setColumnWidth | (c, 0) | 그리드 표시 설정 |  |  |  |
| AC-97c76457 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1899 | for (c <= _si.GetMaxColumnIndex()) ▸ if (colName.Contains("_ASSIGN_PRIORITY")) | GRID_SET | _si.ActiveSheet.Columns[c].Resizable | false | 그리드 속성/값 설정 |  |  |  |
| AC-38757a49 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1907 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ if (colName.Substring(0, 4).Equals("M_00")) ▸ if (show… | GRID_STYLE | _si.setColumnWidth | (c, this.DEF_DATE_COL_WIDTH) | 그리드 표시 설정 |  |  |  |
| AC-64bb2e83 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1909 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ if (colName.Substring(0, 4).Equals("M_00")) ▸ if (show… | GRID_SET | _si.ActiveSheet.Columns[c].Resizable | true | 그리드 속성/값 설정 |  |  |  |
| AC-35902e61 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1913 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ if (colName.Substring(0, 4).Equals("M_00")) ▸ else of … | GRID_STYLE | _si.setColumnWidth | (c, 0) | 그리드 표시 설정 |  |  |  |
| AC-774d7f5d | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1915 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ if (colName.Substring(0, 4).Equals("M_00")) ▸ else of … | GRID_SET | _si.ActiveSheet.Columns[c].Resizable | false | 그리드 속성/값 설정 |  |  |  |
| AC-0924fcc7 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1920 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ else of (colName.Substring(0, 4).Equals("M_00")) ▸ if … | GRID_STYLE | _si.setColumnWidth | (c, this.DEF_DATE_COL_WIDTH) | 그리드 표시 설정 |  |  |  |
| AC-b8bdc12e | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1922 | for (c <= _si.GetMaxColumnIndex()) ▸ else of (colName.Contains("_ASSIGN_PRIORITY")) ▸ else of (colName.Substring(0, 4).Equals("M_00")) ▸ if … | GRID_SET | _si.ActiveSheet.Columns[c].Resizable | true | 그리드 속성/값 설정 |  |  |  |
| AC-7010643d | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 9 | SCP0106_CAPA_Loss_Plan.cs:1929 |  | CALL_EXT | SheetUtils.SetVisibleSheetColumn | (_si, this.IsEditMode, new List<string>() { DefColumns.VER_ID , DefColumns.VER_SEQ , DefCo… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26d02774 | this.Load | SCP0106_CAPA_Loss_Plan.cs:1211 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c2c349 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1465 |  | CALL_EXT | ScpCapaBL.GetFilterElectrodeType | (_division_type, _division, _operation) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7e02bc6 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1467 |  | FLAG | dtElectrode | DBUtils.Filter(dtElectrodeAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce27bd06 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1467 |  | DATA_OP | DBUtils.Filter | (dtElectrodeAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b92c01d | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1469 |  | FLAG | dtElectrode | DBUtils.Sort(dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-bd8b5c19 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1469 |  | DATA_OP | DBUtils.Sort | (dtElectrode, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-406e837a | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1471 |  | FLAG | dtElectrode | DBUtils.GetDistinctTable(dtElectrode, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-e18fb400 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1471 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtElectrode, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3eca9733 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1473 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrodeType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshElectrodeTypeAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1df49621 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1171 |  | FLAG | dtElectrodeAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD",… | 화면 필드/플래그 변경 |  |  |  |
| AC-bbbd2e47 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1171 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "OPERATION_ID", "ELTR_LN_TP_CD", "ELTR_LN_TP_NM", "DISPL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a0130cd | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1175 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtElectrodeAll, "CODE", "NAME", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2865f42 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1177 |  | FLAG | dtElectrodeAll | DBUtils.Sort(dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-c5c8bd5b | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1177 |  | DATA_OP | DBUtils.Sort | (dtElectrodeAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshFactory

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90f93e51 | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1333 |  | CALL_EXT | ScpCapaBL.GetFilterFactory | (_division_type, _division, "", _shop_group, _plant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f818735e | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1335 |  | FLAG | dtFactory | DBUtils.GetDistinctedCode(dtFactoryAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-5955f16a | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1335 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtFactoryAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d396783 | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1337 |  | FLAG | dtFactory | ScpCapaBL.GetSortedCode(dtFactory) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7e1241e | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1337 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtFactory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af009a1b | this.Load 외 6 | SCP0106_CAPA_Loss_Plan.cs:1338 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshFactoryAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c43e710a | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1138 |  | FLAG | dtFactoryAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-286ec2ed | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1138 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "F… | ⚠ 의미 확인 필요 |  |  |  |
| AC-13d96884 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1142 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtFactoryAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshLine

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908e3e02 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1343 |  | CALL_EXT | ScpCapaBL.GetFilterLine | (_division_type, _division, _shop_group, _plant, _factory) | ⚠ 의미 확인 필요 |  |  |  |
| AC-005c0cdf | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1345 |  | FLAG | dtLine | DBUtils.GetDistinctedCode(dtLineAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-23e6a3c6 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1345 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtLineAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4715268 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1347 |  | FLAG | dtLine | ScpCapaBL.GetSortedCode(dtLine) | 화면 필드/플래그 변경 |  |  |  |
| AC-91145d3c | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1347 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtLine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b04d9a41 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1357 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d14d0fdf | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1358 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2161286 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1359 |  | DATA_OP | _dt.Columns.Add | (new DataColumn("SEQ2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b71a27c | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1366 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select("CODE LIKE '%" + _rowstr + "%'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f04337b9 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1366 | for (i < _dt.Rows.Count) | DATA_OP | _dt.Select | ("CODE LIKE '%" + _rowstr + "%'") | 데이터 객체 조작/조회 |  |  |  |
| AC-68901f1f | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1379 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-f8ce575d | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1380 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ if (_name == "_A") | GRID_SET | _dt.Rows[i]["SEQ2"] | "2" | 그리드 속성/값 설정 |  |  |  |
| AC-e5b1dbac | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1384 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8500b367 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1385 | for (i < _dt.Rows.Count) ▸ if (_dt2.Rows.Count == 2) ▸ else of (_name == "_A") ▸ if (_name == "_C") | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-6637de7c | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1391 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ1"] | _cd.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-9bdaecb5 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1392 | for (i < _dt.Rows.Count) ▸ else of (_dt2.Rows.Count == 2) | GRID_SET | _dt.Rows[i]["SEQ2"] | "1" | 그리드 속성/값 설정 |  |  |  |
| AC-455204db | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1400 | if (_dt.Rows.Count > 0) | DATA_OP | _dt.Select("", "SEQ1,SEQ2 ASC").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fec31530 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1400 | if (_dt.Rows.Count > 0) | DATA_OP | _dt.Select | ("", "SEQ1,SEQ2 ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d4dbd61 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:1402 |  | LIST_REBIND | clsCtrl.setListBox | (resultDt, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshLineAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5855c5c3 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1149 |  | FLAG | dtLineAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-514590bb | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1149 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "L… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e934218 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1153 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtLineAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3334aed5 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1407 |  | CALL_EXT | ScpCapaBL.GetFilterOperation | (_division_type, _division, _shop_group, _plant, _factory, _line) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7885381a | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1420 | if ((_division_type == DivisionType.CELL) && ((_progress_status == ProgressStatusType._1ST_CUTOFF) \|\| (_progress_status == P…) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "CPS_LOSS_CELL_LINE_OPERATION") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6d037a0 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1426 | if ((_division_type == DivisionType.CELL) && ((_progress_status == ProgressStatusType._1ST_CUTOFF) \|\| (_progress_status == P…) ▸ if (_divi… | DATA_OP | DBUtils.Filter | (dtOp, "CODE = '" + _division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c2d43cf8 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1430 | if ((_division_type == DivisionType.CELL) && ((_progress_status == ProgressStatusType._1ST_CUTOFF) \|\| (_progress_status == P…) ▸ else of (… | DATA_OP | DBUtils.Filter | (dtOp, "CODE = 'DEFAULT'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-29b14060 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1452 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-10124bbb | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1452 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-44f8f6e2 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1454 |  | FLAG | dtOperation | DBUtils.Sort(dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> … | 화면 필드/플래그 변경 |  |  |  |
| AC-567660e3 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1454 |  | DATA_OP | DBUtils.Sort | (dtOperation, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDirect… | 데이터 객체 조작/조회 |  |  |  |
| AC-6db613f4 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1456 |  | FLAG | dtOperation | DBUtils.GetDistinctTable(dtOperation, "CODE", "NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-f8d5f127 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1456 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtOperation, "CODE", "NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9022c6b | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:1458 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshOperationAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9015e79 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1160 |  | FLAG | dtOperationAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FA… | 화면 필드/플래그 변경 |  |  |  |
| AC-9216d262 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1160 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SHOP_GROUP_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "O… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aee195ba | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1164 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtOperationAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97001fa0 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1166 |  | FLAG | dtOperationAll | DBUtils.Sort(dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionTyp… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e142735 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1166 |  | DATA_OP | DBUtils.Sort | (dtOperationAll, new List<string> { "DISPLAY_SEQ" }, new List<SortDirectionType> { SortDir… | 데이터 객체 조작/조회 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshPlant

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7e26123 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1323 |  | CALL_EXT | ScpCapaBL.GetFilterPlant | (_division_type, _division, _site, "", _shop_group) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e579678 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1325 |  | FLAG | dtPlant | DBUtils.GetDistinctedCode(dtPlantAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c6c3b69 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1325 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtPlantAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b653ac0 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1327 |  | FLAG | dtPlant | ScpCapaBL.GetSortedCode(dtPlant) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1da0bc8 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1327 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtPlant) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cf64875 | this.Load 외 5 | SCP0106_CAPA_Loss_Plan.cs:1328 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshPlantAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04092d55 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1127 |  | FLAG | dtPlantAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLA… | 화면 필드/플래그 변경 |  |  |  |
| AC-2783800f | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1127 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SHOP_GROUP_ID", "PLANT_ID", "PLANT_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc51cfe6 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1131 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtPlantAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshPlanType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bc45b58 | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1237 |  | VALUE_SET | txtPlanType.Text | _plan_type | 컨트롤 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshProgressStatus

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84876301 | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1277 |  | FLAG | dtProgressStatus | DBUtils.GetDistinctedCode(dtProgressStatusAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-04dd7772 | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1277 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtProgressStatusAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a80b02bc | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1279 |  | LIST_REBIND | clsCtrl.setListBox | (dtProgressStatus, cboProgressStatus, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-97b381fe | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1290 |  | CALL_EXT | UIUtils.GetIndexByCode | (cboProgressStatus, _currVersionProgressStatus) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec8e52fa | this.Load 외 3 | SCP0106_CAPA_Loss_Plan.cs:1296 | if (cboProgressStatus.Items.Count > 0) | VALUE_SET | cboProgressStatus.SelectedIndex | cboProgressStatus.Items.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshSheetHeader

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7ce0a32 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1834 |  | GRID_INIT | _si.SetSheetHeaderColumnSCP | (_si, 3, refreshAllColumn, _fixed_column_name) | 그리드 재구성/초기화 |  |  |  |
| AC-7f117b58 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:1838 |  | CALL_EXT | SheetUtils.RefreshSpreadDateColumn | (_si , dsSpdTitle.Tables[0] // tblTitle , DateColumns.COLUMN_NAME // dataColumnName, 월 , D… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshSheetType

진입점: this.Load / this.cboProgressStatus.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-035e133d | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1303 | if (_progress_status == ProgressStatusType._1ST_CUTOFF \|\| _progress_status == ProgressStatusType._2ND_CUTOFF) | UI_PROP | ucpSheetType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-930e3bfd | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1307 | else of (_progress_status == ProgressStatusType._1ST_CUTOFF \|\| _progress_status == ProgressStatusType._2ND_CUTOFF) | UI_PROP | ucpSheetType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshSite

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7be65ea | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1313 |  | CALL_EXT | ScpCapaBL.GetFilterSite | (_division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cae5eef3 | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1315 |  | FLAG | dtSite | DBUtils.GetDistinctedCode(dtSiteAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fd76f3d | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1315 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtSiteAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce8804ba | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1317 |  | FLAG | dtSite | ScpCapaBL.GetSortedCode(dtSite) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc327007 | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1317 |  | CALL_EXT | ScpCapaBL.GetSortedCode | (dtSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bea3847 | this.Load 외 4 | SCP0106_CAPA_Loss_Plan.cs:1318 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshSiteAll

진입점: this.Load / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f78e2208 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1116 |  | FLAG | dtSiteAll | DBUtils.GetDistinctTable(dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | 화면 필드/플래그 변경 |  |  |  |
| AC-88701fc4 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1116 |  | CALL_EXT | DBUtils.GetDistinctTable | (dtCapaLineMaster, "DIVISION_ID", "SITE_ID", "SITE_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed44b4cc | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1120 |  | CALL_EXT | DBUtils.DeleteEmptyName | (ref dtSiteAll, "CODE", "NAME", false) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshVersion

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25cb55f9 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1216 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID" }, new List<string>() { _division }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1560c3a5 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1218 |  | FLAG | dtVersion | DBUtils.GetDistinctedCode(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-afe9bd8c | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1218 |  | CALL_EXT | DBUtils.GetDistinctedCode | (dtVersionAll, filter, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf85ac23 | this.Load 외 1 | SCP0106_CAPA_Loss_Plan.cs:1221 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.RefreshVersionSeq

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-678aa6ae | this.Load 외 2 | SCP0106_CAPA_Loss_Plan.cs:1226 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "CODE" }, new List<string>() { _division, _version },… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c30ae616 | this.Load 외 2 | SCP0106_CAPA_Loss_Plan.cs:1228 |  | FLAG | dtVersionSeq | DBUtils.Filter(dtVersionAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c695fbb0 | this.Load 외 2 | SCP0106_CAPA_Loss_Plan.cs:1228 |  | DATA_OP | DBUtils.Filter | (dtVersionAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-33c386ce | this.Load 외 2 | SCP0106_CAPA_Loss_Plan.cs:1232 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionSeq, cboVersionSeq, false, "VER_SEQ", "VER_SEQ") | 목록 컨트롤 재구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8f430dd | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2647 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fc08e66 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2651 | if (_si == null \|\| _si.IsLock(_si.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44780fc4 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2654 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3354ebf | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2657 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (_si) | 프레임워크 검증 |  |  |  |
| AC-e66f40be | SaveButton | SCP0106_CAPA_Loss_Plan.cs:2658 | if (!DataUtil.checkRequiredOfSpread(_si)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a43bb37 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:3389 | if (!CheckChangedValues(ref changedCnt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-597b3106 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:3393 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e774f30 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:3395 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SaveDataMain

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d437a457 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:3369 | if (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type ==…) | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { base._si, base._si } , new List<string>() { DIC_SAVE_CAPA_LOSS_P… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2fa59ad6 | SaveButton | SCP0106_CAPA_Loss_Plan.cs:3378 | else of (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type ==…) | ENDPOINT | this.ExecuteSQL | (new List<SpreadInfo>() { base._si, base._si } , new List<string>() { DIC_SAVE_CAPA_LOSS_P… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0106_CAPA_Loss_Plan.Set_MeasureColor

진입점: EditButton [if (!this.IsEditMode)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91c40e12 | EditButton [if (!this.IsEditMode)] 외 1 | SCP0106_CAPA_Loss_Plan.cs:2809 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07ccaa0d | EditButton [if (!this.IsEditMode)] 외 1 | SCP0106_CAPA_Loss_Plan.cs:2855 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureVal != "") | GRID_STYLE | _si.SetBGColor | (i, _si.GetColumnIndex(DefColumns.MEASURE_NAME), i, spdMain.ActiveSheet.ColumnCount - 1, m… | 그리드 표시 설정 |  |  |  |
| AC-f988599c | EditButton [if (!this.IsEditMode)] 외 1 | SCP0106_CAPA_Loss_Plan.cs:2859 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetEditableMeasures

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-018bc94d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2739 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string> { measureVisibleColumnName }, new List<string> { "Y" }, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3cdb8979 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2741 |  | DATA_OP | DBUtils.Filter | (_tblMeasure, filter, false) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c348be54 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2743 |  | FLAG | this._editableMeasures | DBUtils.GetStringColumnValues(tbl, "LOSS_CD") | 화면 필드/플래그 변경 |  |  |  |
| AC-fac18525 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2743 |  | CALL_EXT | DBUtils.GetStringColumnValues | (tbl, "LOSS_CD") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetLockColumnsAll

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-454defc5 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2096 | if (this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef6761c5 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2100 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a9fee95d | EditButton | SCP0106_CAPA_Loss_Plan.cs:2141 | try ▸ if (this.IsEditMode) | GRID_LOCK | _si.LockRange2 | (0, 0, rowCnt - 1, _fixed_column_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-2887a284 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2156 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if ((_progress_status == ProgressStatusType._CURRENT) \|\| (_progress_status == Pr… | DATA_OP | _editableMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e60eef9 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2172 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == Prog… | GRID_LOCK | SheetUtils.SetLockCell | (this._si, rowIdx, baseColIdx, isMeasureLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a482b8ea | EditButton | SCP0106_CAPA_Loss_Plan.cs:2190 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIdx, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4a11c51 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2227 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColId… | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4fb8e53 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2243 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ else of (_progress_status == ProgressStatusType._CURRENT) ▸ if ((_progress_status … | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIdx, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13a95431 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2280 | try ▸ if (this.IsEditMode) ▸ for (rowIdx <= rowCnt - 1) ▸ else of (_progress_status == ProgressStatusType._CURRENT) ▸ if ((_progress_status … | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIdx, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6d71217 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2289 | try ▸ else of (this.IsEditMode) | GRID_LOCK | SheetUtils.SetLockAllRows | (_si, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce4b567e | EditButton | SCP0106_CAPA_Loss_Plan.cs:2296 | finally ▸ if (!this.IsEditMode) | CALL_EXT | SheetUtils.SetToggleMerge | (_si, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ab48206 | EditButton | SCP0106_CAPA_Loss_Plan.cs:2299 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetLockColumnsOneRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ef7a5db | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2344 | try ▸ if (this.IsEditMode) | GRID_LOCK | _si.LockRange2 | (0, 0, rowCnt - 1, _fixed_column_idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ba58417f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2357 | try ▸ if (this.IsEditMode) ▸ if ((_progress_status == ProgressStatusType._CURRENT) \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF … | DATA_OP | _editableMeasures.Contains | (measure) | 데이터 객체 조작/조회 |  |  |  |
| AC-39c4b2b1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2373 | try ▸ if (this.IsEditMode) ▸ if (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF &&… | GRID_LOCK | SheetUtils.SetLockCell | (this._si, rowIndex, baseColIdx, isMeasureLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c75e342d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2391 | try ▸ if (this.IsEditMode) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColIdx) | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIndex, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-788a1bc4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2422 | try ▸ if (this.IsEditMode) ▸ if (_progress_status == ProgressStatusType._CURRENT) ▸ for (colIdx <= dateEndColIdx) | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIndex, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d9d3bd3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2438 | try ▸ if (this.IsEditMode) ▸ else of (_progress_status == ProgressStatusType._CURRENT) ▸ if ((_progress_status == ProgressStatusType._1ST_CU… | CALL_EXT | SheetUtils.IsCurrPriorityNone | (_si, rowIndex, colIdx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5625cd0d | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2475 | try ▸ if (this.IsEditMode) ▸ else of (_progress_status == ProgressStatusType._CURRENT) ▸ if ((_progress_status == ProgressStatusType._1ST_CU… | GRID_LOCK | SheetUtils.SetLockCell | (_si, rowIndex, colIdx, isCellLocked) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetMeasureColorOneRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6e97553 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2865 | if (this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-735960a5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2868 | if (spdMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d23c8907 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2908 | if (measureVal != "") | GRID_STYLE | _si.SetBGColor2 | (rowIndex, _si.GetColumnIndex(DefColumns.MEASURE_NAME), rowIndex, spdMain.ActiveSheet.Colu… | 그리드 표시 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetQueryInfoGet

진입점: FindButton / SaveButton [if (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type ==…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-860429ab | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3028 | if (this.QueryDics[DIC_GET_CAPA_LOSS_PLAN].Count > 0) | CALL_EXT | this.QueryDics[DIC_GET_CAPA_LOSS_PLAN].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdcf620d | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3033 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.BeforeFindData | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-e86964b0 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3034 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-e4a996a1 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3035 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-a4612160 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3037 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0106_GET_CAPA_LOSS_PLAN_{0}", this._sheet_name) | 속성 QueryId 설정 |  |  |  |
| AC-18e4fb31 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3046 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11222dec | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3047 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac658678 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3048 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", this._progress_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d89ff1ac | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3049 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0f6dcc8 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3050 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", this._site)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbd05c46 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3051 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", this._plant)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b5ceafd | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3052 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", this._factory)) | 데이터 객체 조작/조회 |  |  |  |
| AC-20c9360c | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3053 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._line)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b00c48d9 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3054 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a53e813a | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3055 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11c08ac3 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3056 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", this._electrode_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9bdc246 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3057 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0106")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eaeadfe | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3058 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0eda5d1 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3059 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95b50155 | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3060 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ecb01ca | FindButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:3063 |  | DATA_OP | this.QueryDics[DIC_GET_CAPA_LOSS_PLAN] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveLine

진입점: SaveButton [else of (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type ==…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5e299b2 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3269 | if (this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_LINE].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_LINE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd042e45 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3274 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-b394f8bd | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3275 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-357a23c0 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3276 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-72d957dd | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3277 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0106_SAVE_CAPA_LOSS_PLAN_LINE_{0}", this._division_type_name) | 속성 QueryId 설정 |  |  |  |
| AC-2e477ba3 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3279 |  | CALL_EXT | SheetUtils.GetChangedData | (_si, _tblOriginal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8054f01f | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3314 | foreach (DataRow r in tbl.Rows) ▸ foreach (DataColumn c in tbl.Columns) | DATA_OP | columnName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6b632a5 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3325 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c05eec3a | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3326 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-335aea83 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3327 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", this._progress_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca78bb1c | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3328 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38471166 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3329 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3214f9b | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3330 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae26087 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3331 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ca05f7b | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3332 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f159079a | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3333 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-563fd636 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3334 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24ebf0de | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3335 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ac8e304 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3336 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", NICK_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-524079fb | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3337 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_measure_group", MSR_GR_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9957d09 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3338 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_measure", MSR_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cedee4d | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3339 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_names", DATE_COLUMN_NAMES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5663bf78 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3340 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_values", DATE_COLUMN_VALUES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24a6dfa6 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3341 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0106")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe9bb45 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3342 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-025114c2 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3343 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f17c83d2 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3344 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-89a29d34 | SaveButton [else of (_progress_status == ProgressStatusType.… | SCP0106_CAPA_Loss_Plan.cs:3347 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_LINE] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveModel

진입점: SaveButton [if (_progress_status == ProgressStatusType._CURRENT \|\| (_progress_status == ProgressStatusType._1ST_CUTOFF && _sheet_type ==…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc1dbc40 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3070 | if (this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_MODEL].Count > 0) | CALL_EXT | this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_MODEL].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-489584f9 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3075 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-f1ecb579 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3076 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-842c8681 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3077 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-e22b4fd7 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3078 |  | UI_PROP | qi.QueryId | string.Format("SCP.SCP0106_SAVE_CAPA_LOSS_PLAN_MODEL_{0}", this._division_type_name) | 속성 QueryId 설정 |  |  |  |
| AC-75a09537 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3081 |  | CALL_EXT | SheetUtils.GetChangedData | (_si, _tblOriginal) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47e6b1ad | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3121 | foreach (DataRow r in tbl.Rows) ▸ foreach (DataColumn c in tbl.Columns) | DATA_OP | columnName.Contains | ("_ASSIGN_PRIORITY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1beae51 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3132 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version", this._version)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a0268d4 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3133 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_seq", this._version_seq)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7717ae8 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3134 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_prog_stat", this._progress_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb27f700 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3135 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", DIVISION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7de5c3f | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3136 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company_id", COMPANY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80176a86 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3137 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_site_id", SITE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c393988a | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3138 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plant_id", PLANT_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fae54110 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3139 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_factory_id", FACTORY_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cf88cc9 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3140 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", LINE_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47048faa | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3141 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", OPERATION_ID)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35fad555 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3142 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_electrode_type", ELTR_LN_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-09c2c8d5 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3143 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nick_name", NICK_NAME)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0506f1e4 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3144 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_measure_group", MSR_GR_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11d76674 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3145 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_measure", MSR_TP_CD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dc10e90 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3147 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_iprv_gol_divs_cd", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-78fa3b1c | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3148 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_pfrslt_qty", PFRSLT_QTY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4edc016b | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3149 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_base_qty", BASE_QTY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-938a3be0 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3150 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_names", DATE_COLUMN_NAMES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a323454e | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3151 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_date_column_values", DATE_COLUMN_VALUES)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec0f76d0 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3152 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", "SCP0106")) | 데이터 객체 조작/조회 |  |  |  |
| AC-54c8d2c8 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3153 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_status)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c68c390c | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3154 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-019bc547 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3155 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fddaa663 | SaveButton [if (_progress_status == ProgressStatusType._CURR… | SCP0106_CAPA_Loss_Plan.cs:3157 |  | DATA_OP | this.QueryDics[DIC_SAVE_CAPA_LOSS_PLAN_MODEL] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetSheetMerge

진입점: this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.OK)] / this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ba4e544 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:2917 | if (!this.IsEditMode) | CALL_EXT | _si.ToggleMerge | (spdMain.ActiveSheet, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-29546dd5 | this.btnColumn.Click [if (frm.ShowDialog() == DialogResult.O… 외 8 | SCP0106_CAPA_Loss_Plan.cs:2918 | if (!this.IsEditMode) | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat

진입점: EditButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca387056 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1643 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-562755f1 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1655 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b592d16 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1655 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-f73779fc | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1656 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_M", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a6343a2 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1656 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a4d84edf | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1657 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_D", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24f2c51f | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1657 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-214aeccd | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1658 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN_DDN", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1645adc0 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1658 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-8d0008da | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1659 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("THRY_CAPA_D", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a17ccf2 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1659 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-4d88ce00 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1660 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("TEEP", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6add75d | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1660 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-8d8b30c3 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1661 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_OP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c68fef71 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1661 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a3e6c44b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1662 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("AV_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5189fb02 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1662 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-5f5e3659 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1663 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("LD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-134ad589 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1663 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-bb5319e4 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1664 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("OP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ccdaab7 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1664 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-d055c463 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1665 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PF_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a57a5773 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1665 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-00db5c76 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1666 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("QL_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-54873214 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1666 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-1851342a | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1667 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("SD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1edebbb9 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1667 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-9544af92 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1668 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("WT_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34610682 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1668 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-24a88a00 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1669 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("TD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8be235b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1669 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-959e263b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1670 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("MC_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e7b1e44 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1670 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-be3641c7 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1671 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("ID_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-978bf44d | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1671 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-b3d1ef15 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1672 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("NM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce5b6b64 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1672 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a76cc3cb | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1673 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("ADJ_ULD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e517d1c9 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1673 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-6b4a38cb | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1674 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("BM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69489e75 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1674 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-6eca7b39 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1675 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("CM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b117234 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1675 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-15390354 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1676 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8dbf068a | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1676 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-e1857717 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1677 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f971b741 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1677 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-817978ef | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1678 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("UD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e383d26 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1678 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-c2fcda3c | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1679 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("PP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac59ebe6 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1679 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-9903ca24 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1680 | try ▸ if (this.IsEditMode) | DATA_OP | dic.Add | ("MR_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c0e1261 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1680 | try ▸ if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-abe628d5 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1686 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b42f36cd | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1686 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-ef7dc177 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1687 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_M", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-72b87396 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1687 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-3867a251 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1688 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_D", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dd27c23 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1688 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-73d1aa26 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1689 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN_DDN", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f8eab49 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1689 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-abce4b26 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1690 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("THRY_CAPA_D", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-77d4fcc6 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1690 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-5995d81a | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1691 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("TEEP", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d60ee81 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1691 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-a3727d5f | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1692 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_OP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4897c82e | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1692 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-6a9ebf8e | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1693 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("AV_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9a1b37e | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1693 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-745347c5 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1694 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("LD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53a9227b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1694 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-15e73db4 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1695 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("OP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8687d0a7 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1695 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-c28a6e60 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1696 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PF_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3016645c | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1696 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-1e49779a | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1697 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("QL_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-089aabde | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1697 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-8cfb00aa | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1698 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("SD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d139608 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1698 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-19c82b40 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1699 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("WT_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83ccd357 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1699 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-6fcffaf4 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1700 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("TD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3f21829 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1700 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-b890eb19 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1701 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("MC_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cee1617b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1701 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-892a145f | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1702 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("ID_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd6e805d | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1702 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-3b6fc32b | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1703 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("NM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d061f961 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1703 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-c86a3830 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1704 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("ADJ_ULD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cac542d2 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1704 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-2fb4a86d | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1705 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("BM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65a357d8 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1705 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-f211d8ab | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1706 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("CM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1bd60527 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1706 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-9a69f4e7 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1707 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6ddca88 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1707 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-3bd66c39 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1708 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18c41289 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1708 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-96e49683 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1709 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("UD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7da7809e | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1709 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-4d1ac546 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1710 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("PP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ebf9a7f | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1710 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-bd8653a5 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1711 | try ▸ else of (this.IsEditMode) | DATA_OP | dic.Add | ("MR_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88403dab | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1711 | try ▸ else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-bf2bf762 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1715 | try | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, this._sheetNumericColumns, DefColumns.MEASURE, dic, this.IsEditMode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44044f50 | EditButton 외 1 | SCP0106_CAPA_Loss_Plan.cs:1720 | finally | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormatOneRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac5370ec | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1734 | if (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b59f2631 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1734 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-2e0c6cd7 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1735 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_M", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16c4fc2f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1735 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-c073179f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1736 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_D", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62c476a4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1736 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-394cf7ac | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1737 | if (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN_DDN", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bdd0960 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1737 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-e1b67d88 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1738 | if (this.IsEditMode) | DATA_OP | dic.Add | ("THRY_CAPA_D", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43a3178b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1738 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-8b60feff | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1739 | if (this.IsEditMode) | DATA_OP | dic.Add | ("TEEP", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fef3b062 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1739 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-5c697ab6 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1740 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_OP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-15253991 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1740 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-f7dd07b5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1741 | if (this.IsEditMode) | DATA_OP | dic.Add | ("AV_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-439050d7 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1741 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-1efc8d3b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1742 | if (this.IsEditMode) | DATA_OP | dic.Add | ("LD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-217e75c8 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1742 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-fce8b88b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1743 | if (this.IsEditMode) | DATA_OP | dic.Add | ("OP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2e0e813 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1743 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-b1d0fc8f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1744 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PF_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-036c92c5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1744 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-e8b7412e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1745 | if (this.IsEditMode) | DATA_OP | dic.Add | ("QL_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3766b371 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1745 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-1d6d1a45 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1746 | if (this.IsEditMode) | DATA_OP | dic.Add | ("SD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cdd3554 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1746 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-9fe52b26 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1747 | if (this.IsEditMode) | DATA_OP | dic.Add | ("WT_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-06955e9c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1747 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-edfeb3ce | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1748 | if (this.IsEditMode) | DATA_OP | dic.Add | ("TD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3967d32 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1748 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-8e1517fb | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1749 | if (this.IsEditMode) | DATA_OP | dic.Add | ("MC_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbc6fcdb | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1749 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-ba621a29 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1750 | if (this.IsEditMode) | DATA_OP | dic.Add | ("ID_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dfd0e0a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1750 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-05486b4e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1751 | if (this.IsEditMode) | DATA_OP | dic.Add | ("NM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed0a85a1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1751 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-ae730178 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1752 | if (this.IsEditMode) | DATA_OP | dic.Add | ("ADJ_ULD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-40443529 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1752 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-95b8060f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1753 | if (this.IsEditMode) | DATA_OP | dic.Add | ("BM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-095f9255 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1753 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-81cb49c1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1754 | if (this.IsEditMode) | DATA_OP | dic.Add | ("CM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ae95eb5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1754 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-7124817a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1755 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-45a3f047 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1755 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a4a3cd88 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1756 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PM_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de924177 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1756 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a8e1fea9 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1757 | if (this.IsEditMode) | DATA_OP | dic.Add | ("UD_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08a808a3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1757 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-6d709cfe | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1758 | if (this.IsEditMode) | DATA_OP | dic.Add | ("PP_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c2a561b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1758 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-bc64abff | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1759 | if (this.IsEditMode) | DATA_OP | dic.Add | ("MR_RT", new CellFormatConditionType(10, 10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1e9a1c0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1759 | if (this.IsEditMode) | POPUP | new CellFormatConditionType | (10, 10) | 팝업/폼 생성 |  |  |  |
| AC-a1f9f1d4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1765 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a7b3357 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1765 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-92d3a615 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1766 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_M", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b59049c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1766 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-0f4cabe2 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1767 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_CAPA_D", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-802eba08 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1767 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-53fad842 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1768 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("SCP_PROD_PLAN_DDN", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4beeef0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1768 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-435e41aa | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1769 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("THRY_CAPA_D", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75b3d6fe | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1769 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-1e1e3668 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1770 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("TEEP", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-984959b8 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1770 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-0c197b3f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1771 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PROD_OP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfacd7b8 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1771 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-29b24935 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1772 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("AV_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4d65664 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1772 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-ed1975d7 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1773 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("LD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43d5f178 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1773 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-a1b853ca | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1774 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("OP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35ff3d68 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1774 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-fe4383fa | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1775 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PF_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec19b01 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1775 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-ef47497c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1776 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("QL_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53076857 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1776 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-b180faae | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1777 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("SD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cec3929a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1777 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-e1a53e6a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1778 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("WT_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d17f19a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1778 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-c8856c7f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1779 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("TD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46bfd4d4 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1779 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-33a391ca | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1780 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("MC_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c078c269 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1780 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-a035ad64 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1781 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("ID_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ac5cdc | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1781 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-dcbc40ef | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1782 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("NM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12c86682 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1782 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-2535e49b | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1783 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("ADJ_ULD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88f3bce0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1783 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-251d2f52 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1784 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("BM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-feaf9a8e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1784 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-d5c0182f | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1785 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("CM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44bdf054 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1785 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-d95045a0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1786 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-563cba15 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1786 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-f965b011 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1787 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PM_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdcffb2e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1787 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-7d84bf3c | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1788 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("UD_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d595cdb0 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1788 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-1e383e7a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1789 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("PP_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a11d06be | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1789 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-a63a1b2e | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1790 | else of (this.IsEditMode) | DATA_OP | dic.Add | ("MR_RT", new CellFormatConditionType(1, 1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddafe8b5 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1790 | else of (this.IsEditMode) | POPUP | new CellFormatConditionType | (1, 1) | 팝업/폼 생성 |  |  |  |
| AC-636133af | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:1794 |  | CALL_EXT | SheetUtils.SetNumericColumnFormat | (_si, rowIndex, this._sheetNumericColumns, DefColumns.MEASURE, dic, this.IsEditMode) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetSheetRangeValue

진입점: this.spdMain.KeyDown [else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88201cfa | this.spdMain.KeyDown [else of (e.Control && e.KeyCode == Key… 외 1 | SCP0106_CAPA_Loss_Plan.cs:1998 | for (r <= _selEndRow) ▸ for (c <= _selEndCol) | GRID_SET | _si.ActiveSheet.SetValue | (r, c, value) | 그리드 값 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetVisibleElectrodeType

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.clbOperation.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-747b1b7f | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:3460 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | VALUE_SET | this.lciItem.Text | ScpCapa.ItemNames.NICK_NAME | 컨트롤 값 설정 |  |  |  |
| AC-dd0b51dc | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:3464 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.CELL) | VALUE_SET | this.lciItem.Text | ItemNames.MODEL | 컨트롤 값 설정 |  |  |  |
| AC-74e07ea3 | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:3469 | if (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5d453fbb | this.Load 외 7 | SCP0106_CAPA_Loss_Plan.cs:3473 | else of (_division_type == DivisionType.MODULE_PACK \|\| _division_type == DivisionType.ELTR) | UI_PROP | lciElectrodeType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.SetVisibleOperation

진입점: this.Load / this.cboDivision.SelectedIndexChanged / this.cboVersion.SelectedIndexChanged / this.cboVersionSeq.SelectedIndexChanged / this.cboProgressStatus.SelectedIndexChanged / this.cboSheetType.SelectedIndexChanged / this.clbSite.SelectedIndexChanged / this.clbPlant.SelectedIndexChanged / this.clbFactory.SelectedIndexChanged / this.clbLine.SelectedIndexChanged / this.rgrpDivisionType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58bc8739 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:3448 | if (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7b7e1692 | this.Load 외 10 | SCP0106_CAPA_Loss_Plan.cs:3452 | else of (_division_type == DivisionType.ELTR) | UI_PROP | lciOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.ShowItem

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0581f0f6 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4310 |  | POPUP | new SCM0002_CAPAItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e48b4f79 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4312 |  | CALL_EXT | pop.Init | (true, dtDivision, _division, _shop_group, _item_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6440dcdb | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4313 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-76bb683b | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4314 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e79a63ce | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4322 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.NICK_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-06be3931 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4322 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eed5e8b1 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4324 | if (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.NICK_NAME) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1a69ae0 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4328 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | FLAG | selectedItems | pop.GetSelectedValues(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-d1412415 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4328 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValues | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8f62032 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4330 | else of (_division_type == DivisionType.CELL \|\| _division_type == DivisionType.MODULE_PACK) | CALL_EXT | pop.GetSelectedValuesText | (DefColumns.ITEM_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec11c9d2 | this.btnItemId.Click | SCP0106_CAPA_Loss_Plan.cs:4333 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0106_CAPA_Loss_Plan.spdMain_ClipboardChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fdedb11 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:4353 | try | FLAG | _clipboard | _si.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |
| AC-e4b476b3 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:4357 | catch () | FLAG | _clipboard | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0106_CAPA_Loss_Plan.spdMain_ClipboardPasting

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6b584b1 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2036 | if (!this.IsEditMode) | UI_PROP | e.Handled | false | 속성 Handled 설정 |  |  |  |
| AC-16cf7813 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2038 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb5cf2bf | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2043 | if (IsLockClipboardRange()) | UI_PROP | e.Handled | false | 속성 Handled 설정 |  |  |  |
| AC-e0202307 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2045 | if (IsLockClipboardRange()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1f78f30 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2048 |  | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cad55c3 | this.spdMain.KeyDown | SCP0106_CAPA_Loss_Plan.cs:1967 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-e5ab0c97 | this.spdMain.KeyDown | SCP0106_CAPA_Loss_Plan.cs:1974 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCP0106_CAPA_Loss_Plan.spdMain_SelectionChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ff8e34a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2062 |  | FLAG | _selBegRow | e.Range.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-75298140 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2063 |  | FLAG | _selRowCnt | e.Range.RowCount | 화면 필드/플래그 변경 |  |  |  |
| AC-01e74729 | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2064 |  | FLAG | _selBegCol | e.Range.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-a0a909dd | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2065 |  | FLAG | _selColCnt | e.Range.ColumnCount | 화면 필드/플래그 변경 |  |  |  |
| AC-599e8d7a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2066 |  | FLAG | _selEndRow | _selBegRow + _selRowCnt - 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2e2d735a | (진입점 미연결) | SCP0106_CAPA_Loss_Plan.cs:2067 |  | FLAG | _selEndCol | _selBegCol + _selColCnt - 1 | 화면 필드/플래그 변경 |  |  |  |

