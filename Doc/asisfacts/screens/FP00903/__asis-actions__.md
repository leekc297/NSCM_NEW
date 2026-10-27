# AS-IS 액션 대조표 — FP00903

> 원천: `Doc/asisfacts/screens/FP00903/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 393행 · 메서드 40 · 종류 DATA_OP 179 · GRID_INIT 40 · RETURN 36 · FLAG 33 · UI_PROP 21 · GRID_LOCK 15 · ENDPOINT 13 · CALL_EXT 10 · LIST_REBIND 9 · MESSAGE 9 · UI_MISC 8 · VALUE_SET 4 · GRID_SET 3 · POPUP 2 · CALL_BASE 2 · STATE_RESET 2 · COMBO_DATA 2 · THROW 1 · VALIDATE 1 · GRID_CLEAR 1 · STATE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 12


## FP00903_Setup_Matrix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ec775bf | .ctor | FP00903_Setup_Matrix.UIL.cs:149 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00903_Setup_Matrix.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-208ed9c7 | this.spdMain.ActiveSheet.CellChanged | FP00903_Setup_Matrix.UIL.cs:1545 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.BuildAttrMatrix

진입점: cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / cboCategory.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / cboAttribute.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / mcboFrom.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / mcboTo.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / FindButton [try ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ if (Filter[…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ea18854 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1311 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd64986c | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1315 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_KEY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-817ee8ae | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1316 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_CATEGORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed719e1d | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1317 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.LINE_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f04112 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1321 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (matchingMatrix.Count() > 0) | DATA_OP | matchingMatrix.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68fcd0b9 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1322 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (matchingMatrix.Count() > 0) | UI_PROP | m.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-101d67d6 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1323 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (matchingMatrix.Count() > 0) | DATA_OP | dsMatrizLocal.Tables.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-4954f1fe | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1326 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrizLocal.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98e62f18 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1331 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dRow.Field | ("ATTRIBUTE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-308febf8 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1331 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dRow.Field | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d4aade9 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1334 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dictMatrix.Add | ("ALL", "ALL") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef360619 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1338 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) ▸ foreach (var row in distinctRows) | DATA_OP | dictMatrix.Add | (row.attr_list.ToString(), colname) | 데이터 객체 조작/조회 |  |  |  |
| AC-e45974e4 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1344 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.INSTANCE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d175ccef | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1345 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.OPERATION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c57688a | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1346 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.LINE_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0cf8f75 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1347 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_CATEGORY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-87d02a61 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1348 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_KEY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba2b9d38 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1349 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.FROM_ITEM_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a968fb5 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1353 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.Columns.SafeAdd | (kvp.Key, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7762235f | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1365 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c69d01a1 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1367 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a9faf6a6 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1368 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b744d699 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1369 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-118cd932 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1370 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-6671ec4d | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1371 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ef8ccd64 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1373 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | kvp.Key | 행/컬럼 값 대입 |  |  |  |
| AC-6e26f1a3 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1375 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.Rows.Add | (nRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d6ddcb4 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1401 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b1969a4 | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1409 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (x != null) | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-2c93250e | cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SET… 외 6 | FP00903_Setup_Matrix.UIL.cs:1415 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (x != null) | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |

## FP00903_Setup_Matrix.BuildItemMatrix

진입점: cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / cboCategory.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / cboAttribute.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / mcboFrom.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d341bc7 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1098 | if (!dsMatrixRaw.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e002721c | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1117 | if (!dsMatrixRaw.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e69f43b | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1121 | lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_KEY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-18839d1d | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1122 | lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_CATEGORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b82aa9e | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1123 | lambda | DATA_OP | a_rw.Field | (DefColumns.LINE_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae75c5a | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1127 | if (matchingMatrix.Count() > 0) | DATA_OP | matchingMatrix.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50f33453 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1128 | if (matchingMatrix.Count() > 0) | UI_PROP | m.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-1ea57577 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1129 | if (matchingMatrix.Count() > 0) | DATA_OP | dsMatrizLocal.Tables.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-4369a879 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1132 | if (!dsMatrizLocal.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-585ff460 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1136 |  | DATA_OP | dictMatrix.Add | ("ALL", "ALL") | 데이터 객체 조작/조회 |  |  |  |
| AC-9724f071 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1148 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.INSTANCE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8761f27e | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1149 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.OPERATION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcc63ac5 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1150 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.LINE_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce5d839e | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1151 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_CATEGORY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6e1ab0f | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1152 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_KEY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9506fa2e | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1153 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.FROM_ITEM_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80fd3864 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1155 |  | DATA_OP | dtMatrix.Columns.SafeAdd | ("ALL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d292577 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1177 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) | DATA_OP | haveDataFrom.Contains | (from_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e25758 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1178 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) ▸ if (!haveDataFrom.Contains(from_item) && from_item != "AL… | DATA_OP | haveDataFrom.Add | (from_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d48ad62 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1179 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) | DATA_OP | haveDataTo.Contains | (to_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca02eb1 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1180 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) ▸ if (!haveDataTo.Contains(to_item) && to_item != "ALL") | DATA_OP | haveDataTo.Add | (to_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-69eef08c | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1189 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) | DATA_OP | dtMatrix.Columns.SafeAdd | (to_items[i], typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-189c6f3f | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1190 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) | DATA_OP | dictMatrix.ContainsKey | (to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8a2e739 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1191 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) ▸ if (!dictMatrix.ContainsKey(to_items[i])) | DATA_OP | dictMatrix.Add | (to_items[i], to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-559cffe4 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1198 | if (haveDataTo!=null && haveDataTo.Count >0) ▸ foreach (string aItem in haveDataTo) | DATA_OP | dtMatrix.Columns.Contains | (aItem) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bd49c40 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1199 | if (haveDataTo!=null && haveDataTo.Count >0) ▸ foreach (string aItem in haveDataTo) ▸ if (!dtMatrix.Columns.Contains(aItem)) | DATA_OP | dtMatrix.Columns.SafeAdd | (aItem, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-05679650 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1202 |  | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8246d7a7 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1204 |  | DATA_OP | all[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-147cf5f3 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1205 |  | DATA_OP | all[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-4466563e | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1206 |  | DATA_OP | all[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-151b9f40 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1207 |  | DATA_OP | all[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-957dd3db | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1208 |  | DATA_OP | all[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fd919abc | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1209 |  | DATA_OP | all[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e02ab18d | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1210 |  | DATA_OP | dtMatrix.Rows.Add | (all) | 데이터 객체 조작/조회 |  |  |  |
| AC-1abd00c2 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1237 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dictMatrix.ContainsKey | (to_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-086a951b | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1239 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dictMatrix.Add | (to_setup, to_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-1490db0b | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1241 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.Columns.SafeAdd | (to_setup, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a09cd5b | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1246 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-7042ee07 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1253 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7425bd2 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1255 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | from_setup | 행/컬럼 값 대입 |  |  |  |
| AC-d1fe7ee3 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1256 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-62882341 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1257 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1f6d024f | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1258 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-802a4377 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1259 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-56b7b3df | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1260 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-6c65c938 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1261 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-44bbab04 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1262 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-6fa5a373 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1263 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.Rows.Add | (x) | 데이터 객체 조작/조회 |  |  |  |
| AC-171892ec | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1268 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-bcd192ad | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1279 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ lambda | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-10f85443 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1286 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b05159 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1288 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | from_item_setup | 행/컬럼 값 대입 |  |  |  |
| AC-60a29e3c | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1289 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0a16eb0a | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1290 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-40e15245 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1291 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-983d5e94 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1292 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fd31578b | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1293 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1ea7d738 | cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumn… 외 6 | FP00903_Setup_Matrix.UIL.cs:1294 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | dtMatrix.Rows.Add | (x) | 데이터 객체 조작/조회 |  |  |  |

## FP00903_Setup_Matrix.CboAttribute_SelectedIndexChanged

진입점: cboAttribute.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9b38448 | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:185 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-1fc01337 | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:186 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-c0fbaf1c | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:187 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-acab548b | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:188 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLine | 행/컬럼 값 대입 |  |  |  |
| AC-1152be5f | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:189 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7fbb167e | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:190 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-c8aa3b6d | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:190 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-d170c78a | cboAttribute.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:194 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00903_Setup_Matrix.CboCategory_SelectedIndexChanged

진입점: cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bd209b8 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:304 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-0b81aa63 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:305 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-e0336d39 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:306 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-70f437f4 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:307 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLine | 행/컬럼 값 대입 |  |  |  |
| AC-b50808b8 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:308 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ac8c078e | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:309 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-3f7ac737 | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:309 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-8134e3ea | cboCategory.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:312 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00903_Setup_Matrix.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f011399a | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:329 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-0605e7b1 | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:330 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-8612c722 | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:331 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8c0a0a3c | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:332 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d123afbe | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:333 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | FLAG | dtLineSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_setup_group", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 화면 필드/플래그 변경 |  |  |  |
| AC-10fe92d3 | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:333 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b09b378a | cboInstance.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:334 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | LIST_REBIND | clsCtrl.setListBox | (dtLineSetup, cboLineSetup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00903_Setup_Matrix.CboLineSetup_SelectedIndexChanged

진입점: cboLineSetup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ee231b9 | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:285 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-faf9a31f | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:286 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-fa53de4a | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:287 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-a8c5b523 | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:288 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f053c33e | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:289 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-1ecc49d0 | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:289 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-7e3f2d09 | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:292 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-769cf6f3 | cboLineSetup.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:293 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | CString.GetCheckedListValue(dtLineSetup, cboLineSetup.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00903_Setup_Matrix.CboOperation_SelectedIndexChanged

진입점: cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71fbc878 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:215 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-7fefadc2 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:216 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-85f8e3c6 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:217 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-a0ddefb6 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:218 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-85efa4ef | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:222 | if (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | CALL_EXT | cboLineSetup.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd2837bb | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:223 | if (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9184612 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:227 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | FLAG | dtLineSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_setup_group", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 화면 필드/플래그 변경 |  |  |  |
| AC-a8869644 | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:227 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c9ee0c2d | cboOperation.SelectedIndexChanged | FP00903_Setup_Matrix.UIL.cs:228 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | LIST_REBIND | clsCtrl.setListBox | (dtLineSetup, cboLineSetup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00903_Setup_Matrix.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-759ffd2a | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00903_Setup_Matrix.UIL.cs:1757 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-0132cb4b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00903_Setup_Matrix.UIL.cs:1759 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2300439 | this.Load | FP00903_Setup_Matrix.UIL.cs:415 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b6eb8f7f | this.Load | FP00903_Setup_Matrix.UIL.cs:416 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-378bee83 | this.Load | FP00903_Setup_Matrix.UIL.cs:418 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00903_Setup_Matrix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40e27f5d | DeleteButton | FP00903_Setup_Matrix.UIL.cs:675 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-755c7f5f | DeleteButton | FP00903_Setup_Matrix.UIL.cs:678 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-41bc19a2 | DeleteButton | FP00903_Setup_Matrix.UIL.cs:680 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8a860b3d | DeleteButton | FP00903_Setup_Matrix.UIL.cs:682 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00903_Setup_Matrix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-149e4744 | Dispose | FP00903_Setup_Matrix.UIL.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00903_Setup_Matrix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6abc87bb | EditButton | FP00903_Setup_Matrix.UIL.cs:692 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-465df397 | EditButton | FP00903_Setup_Matrix.UIL.cs:696 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5e3838e0 | EditButton | FP00903_Setup_Matrix.UIL.cs:713 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d41423e | EditButton | FP00903_Setup_Matrix.UIL.cs:714 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3df972ea | EditButton | FP00903_Setup_Matrix.UIL.cs:728 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (!IsLock) ▸ for (i <= maxcol) ▸ for (j < maxrow)… | GRID_LOCK | siMain.LockRange | (j, i, j, i, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c861a456 | EditButton | FP00903_Setup_Matrix.UIL.cs:737 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f369820a | EditButton | FP00903_Setup_Matrix.UIL.cs:738 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-89c226d8 | EditButton | FP00903_Setup_Matrix.UIL.cs:755 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") ▸ if (!IsLo… | GRID_LOCK | siMain.LockRange | (j, i, j, i, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-41777b29 | EditButton | FP00903_Setup_Matrix.UIL.cs:763 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ else of (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93fdcad9 | EditButton | FP00903_Setup_Matrix.UIL.cs:764 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ else of (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-25fffa6a | EditButton | FP00903_Setup_Matrix.UIL.cs:776 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddb036d6 | EditButton | FP00903_Setup_Matrix.UIL.cs:777 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-3ef218ca | EditButton | FP00903_Setup_Matrix.UIL.cs:791 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (2, 2, IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-58193d8b | EditButton | FP00903_Setup_Matrix.UIL.cs:792 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (3, 3, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-41e3498f | EditButton | FP00903_Setup_Matrix.UIL.cs:793 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (4, 4, IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5df50858 | EditButton | FP00903_Setup_Matrix.UIL.cs:794 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (5, 5, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee496446 | EditButton | FP00903_Setup_Matrix.UIL.cs:795 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (6, 6, IsLock) | 그리드 편집 잠금/해제 |  |  |  |

## FP00903_Setup_Matrix.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80658758 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1678 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca67828c | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1686 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-419c372c | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1690 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca90104c | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1691 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-adfef6f5 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1698 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-8e4078c1 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1700 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-981a724d | ExcelButton | FP00903_Setup_Matrix.UIL.cs:826 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8f06885c | ExcelButton | FP00903_Setup_Matrix.UIL.cs:827 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-3616bfc0 | ExcelButton | FP00903_Setup_Matrix.UIL.cs:829 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93dea757 | ExcelButton | FP00903_Setup_Matrix.UIL.cs:833 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-df0a40c0 | ExcelButton | FP00903_Setup_Matrix.UIL.cs:834 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-5633c4af | ExcelButton | FP00903_Setup_Matrix.UIL.cs:835 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-83bbe11b | ExcelButton | FP00903_Setup_Matrix.UIL.cs:838 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-1a84c4ad | ExcelButton | FP00903_Setup_Matrix.UIL.cs:839 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-e8e29993 | ExcelButton | FP00903_Setup_Matrix.UIL.cs:840 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-2212aafb | ExcelButton | FP00903_Setup_Matrix.UIL.cs:842 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-6dbe5c5e | ExcelButton | FP00903_Setup_Matrix.UIL.cs:843 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-ec9aaf3e | ExcelButton | FP00903_Setup_Matrix.UIL.cs:850 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d785f2a | ExcelButton | FP00903_Setup_Matrix.UIL.cs:854 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0b3ccaf6 | ExcelButton | FP00903_Setup_Matrix.UIL.cs:858 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00903_Setup_Matrix.FindAttrValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e2e768a | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1520 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-c6e29bbd | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1523 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cde48c8 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1524 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68ee5e83 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1525 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-9aa04708 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1526 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_item_values", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] \| FP\Master\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d9b55dde | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1528 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-9cab2cf4 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1532 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.FindMainMatrix

진입점: FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a1d175f | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1038 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboValid.Text.ToUpper() != "ALL") { Filter["ACTIVE_FL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-eab3c99b | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1042 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-02641d85 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1046 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3e6afcad | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1051 | try ▸ if (Filter["SETUP_KEY_ID"] == "") | DATA_OP | Filter["SETUP_KEY_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-123d9e08 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1053 | try | FLAG | dsMatrixRaw | DataService.FP_ExecuteQuery("FP00902_ItemSetupAttr", "get_setup_matrix", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] \| FP\Master\… | 화면 필드/플래그 변경 |  |  |  |
| AC-541e3f33 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1053 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_setup_matrix", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] \| FP\Master\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-21886f1e | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1054 | try | FLAG | dsItemResult | DataService.FP_ExecuteQuery("FP00902_ItemSetupAttr", "get_recent_item_list", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] \| FP\Mas… | 화면 필드/플래그 변경 |  |  |  |
| AC-331f3ff7 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1054 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_recent_item_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] \| FP\Mas… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cc488c44 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1055 | try | FLAG | dsAttrList | DataService.FP_ExecuteQuery("FP00902_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-da95ce4e | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1055 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00902_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d8aac19f | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1057 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { mcboFrom.SelectedIndexChanged -= McboFrom_SelectedIndexCh… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc351019 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1061 | try ▸ lambda | LIST_REBIND | clsCtrl.setListBox | (dsItemResult.Tables[0], mcboFrom, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cba2ca56 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1062 | try ▸ lambda | LIST_REBIND | clsCtrl.setListBox | (dsItemResult.Tables[0], mcboTo, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-b207c7ee | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1063 | try ▸ lambda | VALUE_SET | mcboFrom.ControlValues | old_from | 컨트롤 값 설정 |  |  |  |
| AC-912936d7 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1064 | try ▸ lambda | VALUE_SET | mcboTo.ControlValues | old_to | 컨트롤 값 설정 |  |  |  |
| AC-373cda43 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1075 | try | RETURN | return dsMatrixRaw; |  | 처리 중단/반환 |  |  |  |
| AC-98ee0b98 | FindButton [try ▸ lambda] 외 1 | FP00903_Setup_Matrix.UIL.cs:1079 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.FindMatrix

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b0d2267 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:909 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1180cb0 | this.Load | FP00903_Setup_Matrix.UIL.cs:343 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00903_Setup_Matrix.GetAttrValueHeaderInfo

진입점: this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97e940d7 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1602 | if (siMain.SpreadObject.Name == "spdMain") | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c5ee0972 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1603 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6468358a | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1609 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-31c64d4b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1610 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-865cc009 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1611 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f255505b | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1612 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b212bac | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1613 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e727115c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1614 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38de7bbc | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1615 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26928a08 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1616 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bdc43199 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1617 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39df8966 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1618 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-159e66de | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1619 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8be315b5 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1620 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-00e6bf5c | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1621 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c206f93d | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1622 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76285885 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1623 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-432990a8 | this.spdMain.KeyUp [if (siMain.IsLock(siMain.SheetName) == t… 외 1 | FP00903_Setup_Matrix.UIL.cs:1625 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP00903_Setup_Matrix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e95c7814 | this.Load | FP00903_Setup_Matrix.UIL.cs:375 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0ca5420 | this.Load | FP00903_Setup_Matrix.UIL.cs:377 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-d183087d | this.Load | FP00903_Setup_Matrix.UIL.cs:379 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-3195963b | this.Load | FP00903_Setup_Matrix.UIL.cs:387 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-24a137f9 | this.Load | FP00903_Setup_Matrix.UIL.cs:388 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-07c56ea4 | this.Load | FP00903_Setup_Matrix.UIL.cs:389 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bc881705 | this.Load | FP00903_Setup_Matrix.UIL.cs:394 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-f2026b05 | this.Load | FP00903_Setup_Matrix.UIL.cs:396 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-1b17935e | this.Load | FP00903_Setup_Matrix.UIL.cs:398 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.INSTANCE, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 화면 필드/플래그 변경 |  |  |  |
| AC-7fd26e28 | this.Load | FP00903_Setup_Matrix.UIL.cs:398 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.INSTANCE, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4252df80 | this.Load | FP00903_Setup_Matrix.UIL.cs:399 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c5ca4680 | this.Load | FP00903_Setup_Matrix.UIL.cs:403 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-cf2d0b08 | this.Load | FP00903_Setup_Matrix.UIL.cs:403 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e884a32 | this.Load | FP00903_Setup_Matrix.UIL.cs:404 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-786954e7 | this.Load | FP00903_Setup_Matrix.UIL.cs:407 |  | FLAG | dtCategory | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MA… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-1d23a27f | this.Load | FP00903_Setup_Matrix.UIL.cs:407 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dcae48b4 | this.Load | FP00903_Setup_Matrix.UIL.cs:408 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00903_Setup_Matrix.InitMatrix

진입점: cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14165e46 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1089 |  | STATE_RESET | dictMatrix.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-95f04741 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1090 |  | FLAG | dsMatrix | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-31b7e875 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1091 |  | FLAG | dtMatrix | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-655038c2 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1092 |  | UI_PROP | dtMatrix.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-119d6577 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1093 |  | DATA_OP | dsMatrix.Tables.Add | (dtMatrix) | 데이터 객체 조작/조회 |  |  |  |

## FP00903_Setup_Matrix.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2897db3a | this.Load | FP00903_Setup_Matrix.UIL.cs:427 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-536e3347 | this.Load | FP00903_Setup_Matrix.UIL.cs:429 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6e5c73fd | this.Load | FP00903_Setup_Matrix.UIL.cs:431 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plan Group*", DefColumns.INSTANCE_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e95097ef | this.Load | FP00903_Setup_Matrix.UIL.cs:432 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1438fd2a | this.Load | FP00903_Setup_Matrix.UIL.cs:433 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73f0b17e | this.Load | FP00903_Setup_Matrix.UIL.cs:434 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaadc1e2 | this.Load | FP00903_Setup_Matrix.UIL.cs:435 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c186686 | this.Load | FP00903_Setup_Matrix.UIL.cs:436 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f18ffdc | this.Load | FP00903_Setup_Matrix.UIL.cs:437 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07ac0da7 | this.Load | FP00903_Setup_Matrix.UIL.cs:438 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6452122 | this.Load | FP00903_Setup_Matrix.UIL.cs:439 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-838f5d4d | this.Load | FP00903_Setup_Matrix.UIL.cs:440 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2c276f3 | this.Load | FP00903_Setup_Matrix.UIL.cs:441 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3315c00a | this.Load | FP00903_Setup_Matrix.UIL.cs:442 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e02d99e0 | this.Load | FP00903_Setup_Matrix.UIL.cs:443 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7cebe9c | this.Load | FP00903_Setup_Matrix.UIL.cs:444 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1f742c6 | this.Load | FP00903_Setup_Matrix.UIL.cs:445 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19364d02 | this.Load | FP00903_Setup_Matrix.UIL.cs:446 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1e7cf44 | this.Load | FP00903_Setup_Matrix.UIL.cs:447 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d8832e9 | this.Load | FP00903_Setup_Matrix.UIL.cs:449 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca94df29 | this.Load | FP00903_Setup_Matrix.UIL.cs:451 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE_ID ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a9ef570 | this.Load | FP00903_Setup_Matrix.UIL.cs:452 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE_TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71a3b7f6 | this.Load | FP00903_Setup_Matrix.UIL.cs:453 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT_ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1868cb0d | this.Load | FP00903_Setup_Matrix.UIL.cs:454 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT_TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c03e35f9 | this.Load | FP00903_Setup_Matrix.UIL.cs:456 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2ee23e41 | this.Load | FP00903_Setup_Matrix.UIL.cs:458 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00903_Setup_Matrix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-096ac1c1 | InsertButton | FP00903_Setup_Matrix.UIL.cs:668 |  | MESSAGE | MessageBox.Show | ("You cannot insert in this window") | 메시지 표시 |  |  |  |
| AC-75bb2fb9 | InsertButton | FP00903_Setup_Matrix.UIL.cs:669 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d7323a7 | InsertButton | FP00903_Setup_Matrix.UIL.cs:1022 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e271d4c | InsertButton | FP00903_Setup_Matrix.UIL.cs:1025 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcdcbcd6 | InsertButton | FP00903_Setup_Matrix.UIL.cs:1027 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP00903_Setup_Matrix.RefreshMatrix

진입점: cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b41706d2 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1429 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ActiveSheet.Columns.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-344e2a16 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1430 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-85ca47f6 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1432 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0e33ec2f | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1435 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plan Group", DefColumns.INSTANCE_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf29f9ab | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1436 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation", DefColumns.OPERATION_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46e42398 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1437 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Line Setup", DefColumns.LINE_SETUP_GROUP_ID, FPMerge.None, 0 ,true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3532eb5b | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1438 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Category", DefColumns.SETUP_CATEGORY_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f45cf77f | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1439 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Key", DefColumns.SETUP_KEY_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7015d14 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1440 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | (". To\r\nFrom .", DefColumns.FROM_ITEM_SETUP_GROUP_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f14591b | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1445 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ foreach (KeyValuePair<string, string> kvp in Matrix) | GRID_INIT | spreadInfo.AddTextColumn | (kvp.Key, kvp.Key, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a175a4f3 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1450 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dee1d426 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:1452 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00903_Setup_Matrix.RefreshSpreadSheet

진입점: cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a3765d | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:624 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcAttr.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a8fb48bf | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:625 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcFrom.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-82407e4d | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:626 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcTo.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-170ebedd | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:631 | else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item") | UI_PROP | lcAttr.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7573099e | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:632 | else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item") | UI_PROP | lcFrom.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a3f60cae | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:633 | else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item") | UI_PROP | lcTo.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-cd8c517d | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:639 |  | FLAG | dsMain | dsMatrix | 화면 필드/플래그 변경 |  |  |  |
| AC-179c09c4 | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:640 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b30dffb | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:641 |  | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7442d0ee | cboLineSetup.SelectedIndexChanged 외 6 | FP00903_Setup_Matrix.UIL.cs:644 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00903_Setup_Matrix.SaveAttrList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49589125 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1507 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fb399f26 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1509 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-0fff8c9a | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1513 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.SaveAttrType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b939d75 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1466 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-46cf3ca5 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1468 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-16a4f7b6 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1472 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.SaveAttrValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6044759f | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1487 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-695345f9 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1489 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-c7460e17 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1493 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.SaveDataAttrType

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c4fa686 | SaveButton | FP00903_Setup_Matrix.UIL.cs:919 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ca3285ae | SaveButton | FP00903_Setup_Matrix.UIL.cs:919 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b15c0413 | SaveButton | FP00903_Setup_Matrix.UIL.cs:924 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-718e40c5 | SaveButton | FP00903_Setup_Matrix.UIL.cs:927 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-0cdcfa47 | SaveButton | FP00903_Setup_Matrix.UIL.cs:927 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62d9836e | SaveButton | FP00903_Setup_Matrix.UIL.cs:928 | if (fps.Name == "spdMain") | FLAG | old_from | mcboFrom.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-64532db5 | SaveButton | FP00903_Setup_Matrix.UIL.cs:929 | if (fps.Name == "spdMain") | FLAG | old_to | mcboTo.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-a5098e78 | SaveButton | FP00903_Setup_Matrix.UIL.cs:933 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d2d83266 | SaveButton | FP00903_Setup_Matrix.UIL.cs:934 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3048ca75 | SaveButton | FP00903_Setup_Matrix.UIL.cs:940 | if (fps.Name == "spdMain") | DATA_OP | dsMatrixRaw.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b28aff15 | SaveButton | FP00903_Setup_Matrix.UIL.cs:947 | if (fps.Name == "spdMain") ▸ for (i<= max_col) | DATA_OP | colnames[i] | siMain.GetColumnTag(i) as string | 행/컬럼 값 대입 |  |  |  |
| AC-45911b47 | SaveButton | FP00903_Setup_Matrix.UIL.cs:973 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveMatrix.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1514dec2 | SaveButton | FP00903_Setup_Matrix.UIL.cs:975 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.INSTANCE_ID] | row[DefColumns.INSTANCE_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-13bb205a | SaveButton | FP00903_Setup_Matrix.UIL.cs:976 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.OPERATION_ID] | row[DefColumns.OPERATION_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-74793ca0 | SaveButton | FP00903_Setup_Matrix.UIL.cs:977 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.LINE_SETUP_GROUP_ID] | row[DefColumns.LINE_SETUP_GROUP_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-e2e626bc | SaveButton | FP00903_Setup_Matrix.UIL.cs:978 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_CATEGORY_ID] | row[DefColumns.SETUP_CATEGORY_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-6e83aa2a | SaveButton | FP00903_Setup_Matrix.UIL.cs:979 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_KEY_ID] | row[DefColumns.SETUP_KEY_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-9e63069a | SaveButton | FP00903_Setup_Matrix.UIL.cs:980 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | row[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-98a884a4 | SaveButton | FP00903_Setup_Matrix.UIL.cs:981 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.TO_ITEM_SETUP_GROUP_ID] | colname | 행/컬럼 값 대입 |  |  |  |
| AC-2e3489b5 | SaveButton | FP00903_Setup_Matrix.UIL.cs:982 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_TIME] | save_value | 행/컬럼 값 대입 |  |  |  |
| AC-ea35ea08 | SaveButton | FP00903_Setup_Matrix.UIL.cs:983 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_TIME_UOM] | "minute" | 행/컬럼 값 대입 |  |  |  |
| AC-a09f36a2 | SaveButton | FP00903_Setup_Matrix.UIL.cs:984 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-66a08479 | SaveButton | FP00903_Setup_Matrix.UIL.cs:985 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveMatrix.Tables[0].Rows.Add | (saveRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f8bd6e | SaveButton | FP00903_Setup_Matrix.UIL.cs:993 | if (fps.Name == "spdMain") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00902_ItemSetupAttr", "save_setup_matrix", saveMatrix, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_setup_matrix] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-54a058bc | SaveButton | FP00903_Setup_Matrix.UIL.cs:994 | if (fps.Name == "spdMain") | CALL_EXT | DataService.ReadResult | (ret) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a51a451 | SaveButton | FP00903_Setup_Matrix.UIL.cs:1008 | if (fps.Name == "spdMain") ▸ if (dr != null && dr.Success == true && dr.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00903_Setup_Matrix.SetAttributeCombo

진입점: cboLineSetup.SelectedIndexChanged / cboOperation.SelectedIndexChanged [else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0)] / cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1968bd09 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:238 | if (Filter["CATEGORY_ID"]!= "Attribute") | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-15208fe8 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:239 | if (Filter["CATEGORY_ID"]!= "Attribute") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fe2eada | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:241 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00902_itemSetupAttr", "get_item_list2", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] \| FP\MASTER\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-02c9d890 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:247 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | FLAG | dtAttribute | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0b2f9fcb | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:248 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | UI_PROP | dtAttribute.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-e077f774 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:249 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | a.Tables.Add | (dtAttribute) | 데이터 객체 조작/조회 |  |  |  |
| AC-327606ce | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:250 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | dtAttribute.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-efaa3a53 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:251 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | dtAttribute.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19bde6fc | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:255 | if (dsAttrList.Good()) ▸ else of (dtAttribute == null) | GRID_CLEAR | dtAttribute.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-2a397baa | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:260 | if (dsAttrList.Good()) ▸ for (i < 15) | DATA_OP | dsAttrList.Columns.Contains | (colname) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b52ddbd | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:265 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | dtAttribute.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17b2bd55 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:266 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | row["CODE"] | colname | 행/컬럼 값 대입 |  |  |  |
| AC-dda98e61 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:267 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | row["NAME"] | colval | 행/컬럼 값 대입 |  |  |  |
| AC-92ccbc0f | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:268 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | dtAttribute.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f68d85d | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:272 | if (dsAttrList.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtAttribute, cboAttribute, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f601d7a8 | cboLineSetup.SelectedIndexChanged 외 2 | FP00903_Setup_Matrix.UIL.cs:276 | else of (dsAttrList.Good()) | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00903_Setup_Matrix.SetAttrValueHeaderInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42f5d0db | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1642 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-50cfa893 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1651 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-8874cd57 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1657 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhite… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |

## FP00903_Setup_Matrix.simpleButton1_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4001932c | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1809 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-e256a929 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1810 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e19b6b26 | this.spdMain.CellClick | FP00903_Setup_Matrix.UIL.cs:1564 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9ee7ff1 | this.spdMain.CellClick | FP00903_Setup_Matrix.UIL.cs:1566 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |

## FP00903_Setup_Matrix.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-542ec982 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1584 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16c51ee3 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1587 | if (siMain.IsLock(siMain.SheetName) == true) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG)).ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00903_Setup_Matrix.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c409c86 | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1766 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-823e0148 | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1774 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aec0aa9 | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1777 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _PressAct_Cell | _UpAct_Cell | 화면 필드/플래그 변경 |  |  |  |
| AC-69fecdec | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1778 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) ▸ if (e.KeyData != Keys.Left && e.KeyData != Keys.Right) | FLAG | _UpAct_Cell | this.spdMain.ActiveSheet.ActiveCell.Row.Index2.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a27fe81d | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1783 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (_UpAct_Cell != _PressAct_Cell) | DATA_OP | Filter["ACTIVE_FLAG"] | siMain.GetValue(this.spdMain.ActiveSheet.ActiveCell.Row.Index2, siMain.GetColumnIndex(DefC… | 행/컬럼 값 대입 |  |  |  |
| AC-b6c20809 | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1794 | if (siMain.IsLock(siMain.SheetName) == true) | UI_PROP | this.ActiveControl | spdMain | 속성 ActiveControl 설정 |  |  |  |
| AC-3080aad7 | this.spdMain.KeyUp | FP00903_Setup_Matrix.UIL.cs:1799 | else of (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00903_Setup_Matrix.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e264bd99 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:479 |  | FLAG | old_from | mcboFrom.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-b6c4ec62 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:480 |  | FLAG | old_to | mcboTo.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-c56623d8 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:486 | if (cboOperation.SelectedIndex < 0 \|\| cboInstance.SelectedIndex < 0 \|\| cboCategory.SelectedIndex < 0 \|\| cboLineSetup.Selecte…) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-9f6a617c | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:487 | if (cboOperation.SelectedIndex < 0 \|\| cboInstance.SelectedIndex < 0 \|\| cboCategory.SelectedIndex < 0 \|\| cboLineSetup.Selecte…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3340e5a8 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:495 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e251100 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:496 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81fd75de | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:499 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4ff7597e | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:501 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3f6d3564 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:505 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-62eab1ac | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:516 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d7984102 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:528 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-1f7d6265 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:529 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-0b4357bb | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:530 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-73ddb397 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:531 | try | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-718dc3c5 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:532 | try | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-6af2d6e7 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:533 | try | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | pSetupKey | 행/컬럼 값 대입 |  |  |  |
| AC-efa2e129 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:534 | try | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLineSetup | 행/컬럼 값 대입 |  |  |  |
| AC-f492f5bc | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:537 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainMatrix("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3a84d60 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:537 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainMatrix("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7e00aee | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:553 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-aad3a5f1 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:554 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-97121290 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:555 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-547a93ad | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:560 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bc134c4c | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:561 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-ace29384 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:583 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2325f5e5 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:588 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9bdb72ff | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:589 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-038e81c1 | FindButton 외 1 | FP00903_Setup_Matrix.UIL.cs:590 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00903_Setup_Matrix.usrTextBox_Att_KeyUp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd427791 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1826 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | MESSAGE | MessageBox.Show | ("Can't search in Edit-Mode") | 메시지 표시 |  |  |  |
| AC-e7128b32 | (진입점 미연결) | FP00903_Setup_Matrix.UIL.cs:1827 | if (!siMain.IsLock(siMain.SheetName) \|\| !siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

