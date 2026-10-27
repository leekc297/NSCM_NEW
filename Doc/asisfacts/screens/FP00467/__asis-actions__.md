# AS-IS 액션 대조표 — FP00467

> 원천: `Doc/asisfacts/screens/FP00467/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 408행 · 메서드 36 · 종류 DATA_OP 204 · GRID_INIT 40 · FLAG 31 · RETURN 31 · UI_PROP 20 · GRID_LOCK 15 · ENDPOINT 13 · CALL_EXT 11 · LIST_REBIND 9 · UI_MISC 8 · MESSAGE 7 · VALUE_SET 4 · GRID_SET 3 · POPUP 2 · CALL_BASE 2 · STATE_RESET 2 · THROW 1 · COMBO_DATA 1 · VALIDATE 1 · GRID_CLEAR 1 · STATE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 13


## FP00467_Setup_Matrix..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0aee8e2f | .ctor | FP00467_Setup_Matrix.UIL.cs:148 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00467_Setup_Matrix.ActiveSheet_CellChanged

진입점: this.spdMain.ActiveSheet.CellChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8874cb72 | this.spdMain.ActiveSheet.CellChanged | FP00467_Setup_Matrix.UIL.cs:1612 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.BuildAttrMatrix

진입점: this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / cboLineSetup.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / cboCategory.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / cboAttribute.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / mcboFrom.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / mcboTo.SelectedIndexChanged [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute")] / FindButton [try ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "At…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3200de52 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1334 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | FLAG | dsMatrixRaw | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-b89ee393 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1336 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | UI_PROP | dtmp.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-16cb19dd | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1337 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dsMatrixRaw.Tables.Add | (dtmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-18bf187e | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1339 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-126e4281 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1340 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c90b5f4 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1341 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("SETUP_CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ba78f85 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1342 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("SETUP_KEY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82aadbe7 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1343 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("FROM_ITEM_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a8a8132 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1344 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("TO_ITEM_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-782aba8a | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1345 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d27e772c | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1346 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("SETUP_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaa504c2 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1347 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("SETUP_TIME_UOM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4716a3d7 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1348 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("ACTIVE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a3afb03 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1349 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-556f650b | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1350 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("INSERT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa21cc52 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1351 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("INSERT_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b52c6334 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1352 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("UPDATE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc326b1b | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1353 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (!dsMatrixRaw.Good()) | DATA_OP | dtmp.Columns.SafeAdd | ("UPDATE_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2970c08 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1359 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_KEY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1bfec46a | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1360 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_CATEGORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-84a2af38 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1361 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ lambda | DATA_OP | a_rw.Field | (DefColumns.LINE_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-213eea9b | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1364 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dsMatrixRaw.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bba7c117 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1367 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (matchingMatrix.Count() > 0) | DATA_OP | matchingMatrix.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-810974ab | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1368 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (matchingMatrix.Count() > 0) | UI_PROP | m.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-6e16f496 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1371 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dsMatrizLocal.Tables.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-93166c6d | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1373 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsMatrizLocal==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68e9096b | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1378 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dRow.Field | ("ATTRIBUTE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-91491645 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1378 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dRow.Field | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f37c6a | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1381 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) | DATA_OP | dictMatrix.Add | ("ALL", "ALL") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f0333bd | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1385 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ if (dsAttrList.Good()) ▸ foreach (var row in distinctRows) | DATA_OP | dictMatrix.Add | (row.attr_list.ToString(), colname) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b47162d | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1391 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.INSTANCE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4ead4f2 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1392 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.OPERATION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdf31c75 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1393 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.LINE_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-412c00e6 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1394 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_CATEGORY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e610d401 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1395 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_KEY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17a712dc | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1396 | if (!string.IsNullOrWhiteSpace(filter_key)) | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.FROM_ITEM_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-618e3ada | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1400 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.Columns.SafeAdd | (kvp.Key, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73444a21 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1430 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6ac5201 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1432 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-20e135d6 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1433 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-40df79d3 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1434 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f5be85ba | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1435 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1a69c2d1 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1436 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-1602aad1 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1438 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | nRow[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | kvp.Key | 행/컬럼 값 대입 |  |  |  |
| AC-ea06bdc6 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1440 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (KeyValuePair<string, string> kvp in dictMatrix) | DATA_OP | dtMatrix.Rows.Add | (nRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-be9062e8 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1466 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ lambda | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-36327189 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1474 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (x != null) | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-d882faf6 | this.Load [if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attr… 외 7 | FP00467_Setup_Matrix.UIL.cs:1480 | if (!string.IsNullOrWhiteSpace(filter_key)) ▸ foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (x != null) | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |

## FP00467_Setup_Matrix.BuildItemMatrix

진입점: this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / cboLineSetup.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / cboCategory.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / cboAttribute.SelectedIndexChanged [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item")] / mcboFrom.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41bdf86c | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1084 | if (dsMatrixRaw==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c0c40e1 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1103 | if (dsMatrixRaw==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b75237be | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1107 | lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_KEY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-593769dc | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1108 | lambda | DATA_OP | a_rw.Field | (DefColumns.SETUP_CATEGORY_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-1760b6a1 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1109 | lambda | DATA_OP | a_rw.Field | (DefColumns.LINE_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-27ea5341 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1111 |  | DATA_OP | dsMatrixRaw.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4fb4bbd | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1114 | if (matchingMatrix.Count() > 0) | DATA_OP | matchingMatrix.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-11051134 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1115 | if (matchingMatrix.Count() > 0) | UI_PROP | m.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-915315a4 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1118 |  | DATA_OP | dsMatrizLocal.Tables.Add | (m) | 데이터 객체 조작/조회 |  |  |  |
| AC-43beaf75 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1121 | if (dsMatrizLocal==null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e358fd64 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1125 |  | DATA_OP | dictMatrix.Add | ("ALL", "ALL") | 데이터 객체 조작/조회 |  |  |  |
| AC-989f51d0 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1137 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.INSTANCE_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f56861dc | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1138 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.OPERATION_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b336a290 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1139 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.LINE_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-effcc4d6 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1140 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_CATEGORY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-611c94c2 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1141 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.SETUP_KEY_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3af8184b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1142 |  | DATA_OP | dtMatrix.Columns.SafeAdd | (DefColumns.FROM_ITEM_SETUP_GROUP_ID, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-350b9176 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1144 |  | DATA_OP | dtMatrix.Columns.SafeAdd | ("ALL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2033336 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1166 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) | DATA_OP | haveDataFrom.Contains | (from_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8a19be6 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1167 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) ▸ if (!haveDataFrom.Contains(from_item) && from_item != "AL… | DATA_OP | haveDataFrom.Add | (from_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-54e4934d | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1168 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) | DATA_OP | haveDataTo.Contains | (to_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d95885 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1169 | if (dsItemResult.Good()) ▸ foreach (DataRow row in dsMatrizLocal.Tables[0].Rows) ▸ if (!haveDataTo.Contains(to_item) && to_item != "ALL") | DATA_OP | haveDataTo.Add | (to_item) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e6b354e | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1177 | for (i< to_items.Length) | DATA_OP | from_to.Contains | (to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-54dd6d20 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1178 | for (i< to_items.Length) ▸ if (!from_to.Contains(to_items[i])) | DATA_OP | from_to.Add | (to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-73df5f96 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1182 | for (i < from_items.Length) | DATA_OP | from_to.Contains | (from_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba4ca94b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1183 | for (i < from_items.Length) ▸ if (!from_to.Contains(from_items[i])) | DATA_OP | from_to.Add | (from_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ff091f1 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1188 | foreach (string from_data in haveDataFrom) | DATA_OP | from_to.Contains | (from_data) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba93a985 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1189 | foreach (string from_data in haveDataFrom) ▸ if (!from_to.Contains(from_data)) | DATA_OP | from_to.Add | (from_data) | 데이터 객체 조작/조회 |  |  |  |
| AC-e805873b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1193 | foreach (string to_data in haveDataTo) | DATA_OP | from_to.Contains | (to_data) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e7f4e6b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1194 | foreach (string to_data in haveDataTo) ▸ if (!from_to.Contains(to_data)) | DATA_OP | from_to.Add | (to_data) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f558703 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1196 |  | DATA_OP | from_to.Sort | () | 데이터 객체 조작/조회 |  |  |  |
| AC-386faa21 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1209 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) | DATA_OP | dtMatrix.Columns.SafeAdd | (to_items[i], typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-42613486 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1210 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) | DATA_OP | dictMatrix.ContainsKey | (to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc2826ca | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1211 | if (to_items != null && to_items.Length > 0) ▸ for (i < to_items.Length) ▸ if (!dictMatrix.ContainsKey(to_items[i])) | DATA_OP | dictMatrix.Add | (to_items[i], to_items[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4953be2 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1218 | if (haveDataTo!=null && haveDataTo.Count >0) ▸ foreach (string aItem in haveDataTo) | DATA_OP | dtMatrix.Columns.Contains | (aItem) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7b1f1c7 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1219 | if (haveDataTo!=null && haveDataTo.Count >0) ▸ foreach (string aItem in haveDataTo) ▸ if (!dtMatrix.Columns.Contains(aItem)) | DATA_OP | dtMatrix.Columns.SafeAdd | (aItem, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-931f3eed | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1222 |  | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a76cb6d7 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1224 |  | DATA_OP | all[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-f6b6350c | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1225 |  | DATA_OP | all[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fb232309 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1226 |  | DATA_OP | all[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-7d2b282b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1227 |  | DATA_OP | all[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f9de5294 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1228 |  | DATA_OP | all[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fb70e5fe | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1229 |  | DATA_OP | all[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c30c48ee | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1230 |  | DATA_OP | dtMatrix.Rows.Add | (all) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ee15b60 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1257 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dictMatrix.ContainsKey | (to_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac84c36b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1259 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dictMatrix.Add | (to_setup, to_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e0f3012 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1261 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.Columns.SafeAdd | (to_setup, typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5929572 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1266 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c79f894 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1273 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a02a3f62 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1275 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | from_setup | 행/컬럼 값 대입 |  |  |  |
| AC-2cb5fe65 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1276 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-5e72a55b | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1277 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-535eecd5 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1278 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f6601d09 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1279 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-eef9007e | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1280 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-df555dd0 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1281 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-c8c2e044 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1282 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-1fd0602d | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1283 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | dtMatrix.Rows.Add | (x) | 데이터 객체 조작/조회 |  |  |  |
| AC-938ed975 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1288 | foreach (DataRow aData in dsMatrizLocal.Tables[0].Rows) ▸ if (!string.IsNullOrWhiteSpace(from_setup) && !string.IsNullOrWhiteSpace(to_setup)… | DATA_OP | x[to_setup] | setup_time | 행/컬럼 값 대입 |  |  |  |
| AC-4825e70f | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1299 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ lambda | DATA_OP | each_row.Field | (DefColumns.FROM_ITEM_SETUP_GROUP_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4a95d9d | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1306 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | dtMatrix.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8268205d | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1308 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | from_item_setup | 행/컬럼 값 대입 |  |  |  |
| AC-7fbcbfe0 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1309 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.INSTANCE_ID] | INSTANCE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-66abd5f9 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1310 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.OPERATION_ID] | OPERATION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f6a3062f | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1311 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.SETUP_CATEGORY_ID] | SETUP_CATEGORY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-99b81a93 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1312 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.LINE_SETUP_GROUP_ID] | LINE_SETUP_GROUP_ID | 행/컬럼 값 대입 |  |  |  |
| AC-e033cd54 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1313 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | x[DefColumns.SETUP_KEY_ID] | SETUP_KEY_ID | 행/컬럼 값 대입 |  |  |  |
| AC-60d9eaf2 | this.Load [else of (Filter[DefColumns.SETUP_CATEGORY_ID] == … 외 7 | FP00467_Setup_Matrix.UIL.cs:1314 | if (from_items != null && from_items.Length > 0) ▸ for (i < from_items.Length) ▸ if (x == null) | DATA_OP | dtMatrix.Rows.Add | (x) | 데이터 객체 조작/조회 |  |  |  |

## FP00467_Setup_Matrix.CboAttribute_SelectedIndexChanged

진입점: cboAttribute.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f40dda94 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:184 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-43b61ce6 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:185 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-1c53ae90 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:186 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0d9669b0 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:187 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLine | 행/컬럼 값 대입 |  |  |  |
| AC-3770163a | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:188 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d9231e90 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:189 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-b59be3b3 | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:189 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-0cd9a2eb | cboAttribute.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:193 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00467_Setup_Matrix.CboCategory_SelectedIndexChanged

진입점: this.Load / cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e07e170 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:303 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-4e5e084f | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:304 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-aaecceb9 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:305 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-09bbb952 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:306 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLine | 행/컬럼 값 대입 |  |  |  |
| AC-2df9350d | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:307 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e788f9e3 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:308 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-a81003af | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:308 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-8e0a5d52 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:311 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00467_Setup_Matrix.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-997d0cb4 | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:328 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-ed78c9f0 | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:329 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-7f680e37 | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:330 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-736227bf | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:331 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-9f2e2dee | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:332 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | FLAG | dtLineSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_setup_group", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 화면 필드/플래그 변경 |  |  |  |
| AC-1867fd2f | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:332 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0e89c905 | cboInstance.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:333 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex< 0) | LIST_REBIND | clsCtrl.setListBox | (dtLineSetup, cboLineSetup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00467_Setup_Matrix.CboLineSetup_SelectedIndexChanged

진입점: cboLineSetup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1bbabce | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:284 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-0b839e10 | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:285 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-b95a2bea | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:286 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-fdb18d9e | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:287 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-765192d1 | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:288 |  | DATA_OP | Filter["CATEGORY_ID"] | Filter[DefColumns.SETUP_CATEGORY_ID] = pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-00bc8e74 | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:288 |  | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-3b116876 | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:291 |  | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | CString.GetCheckedListValue(dtAttribute, cboAttribute.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-98429fda | cboLineSetup.SelectedIndexChanged | FP00467_Setup_Matrix.UIL.cs:292 |  | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | CString.GetCheckedListValue(dtLineSetup, cboLineSetup.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00467_Setup_Matrix.CboOperation_SelectedIndexChanged

진입점: this.Load / cboOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-200e51b8 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:214 |  | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-55ebbd81 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:215 |  | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-1daaeab8 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:216 |  | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-355d9e19 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:217 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6b664974 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:221 | if (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | CALL_EXT | cboLineSetup.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5246f64 | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:222 | if (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-778fa45a | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:226 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | FLAG | dtLineSetup | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_line_setup_group", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 화면 필드/플래그 변경 |  |  |  |
| AC-7723cbbb | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:226 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_line_setup_group", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_line_setup_group] \| FP\MA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3a56485d | this.Load 외 1 | FP00467_Setup_Matrix.UIL.cs:227 | else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0) | LIST_REBIND | clsCtrl.setListBox | (dtLineSetup, cboLineSetup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00467_Setup_Matrix.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94cdfb65 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00467_Setup_Matrix.UIL.cs:1782 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-1005f272 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain.SpreadOb… | FP00467_Setup_Matrix.UIL.cs:1784 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b81513a5 | this.Load | FP00467_Setup_Matrix.UIL.cs:443 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c2a6d956 | this.Load | FP00467_Setup_Matrix.UIL.cs:444 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f150901a | this.Load | FP00467_Setup_Matrix.UIL.cs:446 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00467_Setup_Matrix.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4ebce07 | DeleteButton | FP00467_Setup_Matrix.UIL.cs:705 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77b72712 | DeleteButton | FP00467_Setup_Matrix.UIL.cs:708 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1ee86531 | DeleteButton | FP00467_Setup_Matrix.UIL.cs:710 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3577827 | DeleteButton | FP00467_Setup_Matrix.UIL.cs:712 | else of (fps.Name == "spdMain") ▸ else of (fps.Name == "spdSub") ▸ if (fps.Name == "spdList") | DATA_OP | siList.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00467_Setup_Matrix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4972e991 | Dispose | FP00467_Setup_Matrix.UIL.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00467_Setup_Matrix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c358fd5d | EditButton | FP00467_Setup_Matrix.UIL.cs:722 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2d8afc62 | EditButton | FP00467_Setup_Matrix.UIL.cs:726 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-81956afb | EditButton | FP00467_Setup_Matrix.UIL.cs:743 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b936edb | EditButton | FP00467_Setup_Matrix.UIL.cs:744 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-db3227ae | EditButton | FP00467_Setup_Matrix.UIL.cs:758 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (!IsLock) ▸ for (i <= maxcol) ▸ for (j < maxrow)… | GRID_LOCK | siMain.LockRange | (j, i, j, i, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d77546a9 | EditButton | FP00467_Setup_Matrix.UIL.cs:767 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4dff066e | EditButton | FP00467_Setup_Matrix.UIL.cs:768 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-61f27a65 | EditButton | FP00467_Setup_Matrix.UIL.cs:785 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ if (pCategory.ToUpper() == "ITEM") ▸ if (!IsLo… | GRID_LOCK | siMain.LockRange | (j, i, j, i, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5aa93047 | EditButton | FP00467_Setup_Matrix.UIL.cs:793 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ else of (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a3e0e7b | EditButton | FP00467_Setup_Matrix.UIL.cs:794 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (pCategory.ToUpper()== "ATTRIBUTE") ▸ else of (pCategory.ToUpper() == "ITEM") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1, siMain.GetMaxColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7101d70c | EditButton | FP00467_Setup_Matrix.UIL.cs:806 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-585618c4 | EditButton | FP00467_Setup_Matrix.UIL.cs:807 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-436fd91a | EditButton | FP00467_Setup_Matrix.UIL.cs:821 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (2, 2, IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f98f873 | EditButton | FP00467_Setup_Matrix.UIL.cs:822 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (3, 3, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e885037 | EditButton | FP00467_Setup_Matrix.UIL.cs:823 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (4, 4, IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f2282e6 | EditButton | FP00467_Setup_Matrix.UIL.cs:824 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (5, 5, !IsLock) | 그리드 편집 잠금/해제 |  |  |  |
| AC-19c15bdc | EditButton | FP00467_Setup_Matrix.UIL.cs:825 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (false) | GRID_LOCK | siMain.LockColumn | (6, 6, IsLock) | 그리드 편집 잠금/해제 |  |  |  |

## FP00467_Setup_Matrix.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c89c8b3 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1703 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf5ab824 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1711 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4921e17b | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1715 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b13b070 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1716 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7dd9455f | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1723 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-89c5eb7e | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1725 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79b39ca4 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:856 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5adae123 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:857 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-4daec73b | ExcelButton | FP00467_Setup_Matrix.UIL.cs:859 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1ab931b5 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:863 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-6e8faf1f | ExcelButton | FP00467_Setup_Matrix.UIL.cs:864 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-f6814974 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:865 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-25e683f3 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:868 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-9918bb7e | ExcelButton | FP00467_Setup_Matrix.UIL.cs:869 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-0089f550 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:870 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-3cbfc88d | ExcelButton | FP00467_Setup_Matrix.UIL.cs:872 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-f483078d | ExcelButton | FP00467_Setup_Matrix.UIL.cs:873 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-5be7d1df | ExcelButton | FP00467_Setup_Matrix.UIL.cs:880 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c12a0cfe | ExcelButton | FP00467_Setup_Matrix.UIL.cs:884 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4e5c0bb4 | ExcelButton | FP00467_Setup_Matrix.UIL.cs:888 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00467_Setup_Matrix.FindAttrValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8032c94 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1587 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | mainLookupType.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-e4a64877 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1590 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64783ec8 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1591 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04836a5a | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1592 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-5ee7f571 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1593 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_item_values", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_values] \| FP\Master\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bfb66810 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1595 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-583cf837 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1599 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.FindMainMatrix

진입점: FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e47b26 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1024 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboValid.Text.ToUpper() != "ALL") { Filter["ACTIVE_FL… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c93d301 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1028 | try ▸ lambda ▸ if (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | cboValid.Text.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-4f20f921 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1032 | try ▸ lambda ▸ else of (cboValid.Text.ToUpper() != "ALL") | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8116f3d | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1037 | try ▸ if (Filter["SETUP_KEY_ID"] == "") | DATA_OP | Filter["SETUP_KEY_ID"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f653549a | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1039 | try | FLAG | dsMatrixRaw | DataService.FP_ExecuteQuery("FP00466_ItemSetupAttr", "get_setup_matrix", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] \| FP\Master\… | 화면 필드/플래그 변경 |  |  |  |
| AC-6b3a71f4 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1039 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_setup_matrix", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_setup_matrix] \| FP\Master\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2b40f388 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1040 | try | FLAG | dsItemResult | DataService.FP_ExecuteQuery("FP00466_ItemSetupAttr", "get_recent_item_list", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] \| FP\Mas… | 화면 필드/플래그 변경 |  |  |  |
| AC-023db7b8 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1040 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_recent_item_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_recent_item_list] \| FP\Mas… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f44189cd | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1041 | try | FLAG | dsAttrList | DataService.FP_ExecuteQuery("FP00466_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d5eda22 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1041 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00466_ItemSetupAttr", "get_attr_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_attr_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-56a0ff43 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1043 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { mcboFrom.SelectedIndexChanged -= McboFrom_SelectedIndexCh… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f931ec01 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1047 | try ▸ lambda | LIST_REBIND | clsCtrl.setListBox | (dsItemResult.Tables[0], mcboFrom, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-92002d7e | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1048 | try ▸ lambda | LIST_REBIND | clsCtrl.setListBox | (dsItemResult.Tables[0], mcboTo, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-7687c497 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1049 | try ▸ lambda | VALUE_SET | mcboFrom.ControlValues | old_from | 컨트롤 값 설정 |  |  |  |
| AC-766bbfda | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1050 | try ▸ lambda | VALUE_SET | mcboTo.ControlValues | old_to | 컨트롤 값 설정 |  |  |  |
| AC-fb61f797 | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1061 | try | RETURN | return dsMatrixRaw; |  | 처리 중단/반환 |  |  |  |
| AC-1db7cfac | FindButton [try ▸ lambda] 외 1 | FP00467_Setup_Matrix.UIL.cs:1065 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70a06c83 | this.Load | FP00467_Setup_Matrix.UIL.cs:342 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00467_Setup_Matrix.GetAttrValueHeaderInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-038d7ee8 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1627 | if (siMain.SpreadObject.Name == "spdMain") | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-8114c63d | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1628 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25f4c253 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1634 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2000cbd6 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1635 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34dab2fd | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1636 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d0ac9559 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1637 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-800e55ff | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1638 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40e9850e | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1639 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0ed82e4 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1640 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-39d2f087 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1641 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc35ed40 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1642 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-24a8cb11 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1643 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c6bab1d | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1644 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f859617 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1645 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a0602d05 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1646 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-846cf94b | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1647 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7cabbef0 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1648 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4239fbfd | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1650 | if (siMain.SpreadObject.Name == "spdMain") | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## FP00467_Setup_Matrix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63617f3a | this.Load | FP00467_Setup_Matrix.UIL.cs:400 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-70b8adcc | this.Load | FP00467_Setup_Matrix.UIL.cs:402 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-04b30111 | this.Load | FP00467_Setup_Matrix.UIL.cs:404 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-b57e915a | this.Load | FP00467_Setup_Matrix.UIL.cs:412 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4175326a | this.Load | FP00467_Setup_Matrix.UIL.cs:413 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d04ed6a4 | this.Load | FP00467_Setup_Matrix.UIL.cs:414 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ac28bb5a | this.Load | FP00467_Setup_Matrix.UIL.cs:419 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-7d209b35 | this.Load | FP00467_Setup_Matrix.UIL.cs:421 | if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-313706c1 | this.Load | FP00467_Setup_Matrix.UIL.cs:423 |  | FLAG | dtInstance | DataService.GetInstanceSetupInstance(Filter, _sNonAuth, _sSaveAuth) | 화면 필드/플래그 변경 |  |  |  |
| AC-095c8af7 | this.Load | FP00467_Setup_Matrix.UIL.cs:423 |  | CALL_EXT | DataService.GetInstanceSetupInstance | (Filter, _sNonAuth, _sSaveAuth) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7eb5b83e | this.Load | FP00467_Setup_Matrix.UIL.cs:425 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-67be457b | this.Load | FP00467_Setup_Matrix.UIL.cs:429 |  | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-ccbdece9 | this.Load | FP00467_Setup_Matrix.UIL.cs:429 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e4d6e3c | this.Load | FP00467_Setup_Matrix.UIL.cs:430 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ab93ac3a | this.Load | FP00467_Setup_Matrix.UIL.cs:433 |  | FLAG | dtCategory | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MA… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-38f83ca2 | this.Load | FP00467_Setup_Matrix.UIL.cs:433 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9d1a7b71 | this.Load | FP00467_Setup_Matrix.UIL.cs:434 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00467_Setup_Matrix.InitMatrix

진입점: this.Load / cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e747b148 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1075 |  | STATE_RESET | dictMatrix.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e0e7db23 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1076 |  | FLAG | dsMatrix | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-d1b636ed | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1077 |  | FLAG | dtMatrix | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-85745fad | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1078 |  | UI_PROP | dtMatrix.TableName | "matrix" | 속성 TableName 설정 |  |  |  |
| AC-eb60b224 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1079 |  | DATA_OP | dsMatrix.Tables.Add | (dtMatrix) | 데이터 객체 조작/조회 |  |  |  |

## FP00467_Setup_Matrix.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-855c8c6d | this.Load | FP00467_Setup_Matrix.UIL.cs:455 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9c5132a9 | this.Load | FP00467_Setup_Matrix.UIL.cs:457 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aa49fe63 | this.Load | FP00467_Setup_Matrix.UIL.cs:459 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plan Group*", DefColumns.INSTANCE_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01dfcaec | this.Load | FP00467_Setup_Matrix.UIL.cs:460 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c2c8880 | this.Load | FP00467_Setup_Matrix.UIL.cs:461 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-152b17e8 | this.Load | FP00467_Setup_Matrix.UIL.cs:462 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44d3aa7c | this.Load | FP00467_Setup_Matrix.UIL.cs:463 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e908163 | this.Load | FP00467_Setup_Matrix.UIL.cs:464 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-840201cd | this.Load | FP00467_Setup_Matrix.UIL.cs:465 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5b22c82 | this.Load | FP00467_Setup_Matrix.UIL.cs:466 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8fa534e5 | this.Load | FP00467_Setup_Matrix.UIL.cs:467 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14c44ea1 | this.Load | FP00467_Setup_Matrix.UIL.cs:468 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8df1aca | this.Load | FP00467_Setup_Matrix.UIL.cs:469 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e4aa66e | this.Load | FP00467_Setup_Matrix.UIL.cs:470 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aee5f6c1 | this.Load | FP00467_Setup_Matrix.UIL.cs:471 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f17e841d | this.Load | FP00467_Setup_Matrix.UIL.cs:472 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce61028b | this.Load | FP00467_Setup_Matrix.UIL.cs:473 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-baf14428 | this.Load | FP00467_Setup_Matrix.UIL.cs:474 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad989c3f | this.Load | FP00467_Setup_Matrix.UIL.cs:475 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8b6a889 | this.Load | FP00467_Setup_Matrix.UIL.cs:477 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a632aa3 | this.Load | FP00467_Setup_Matrix.UIL.cs:479 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("UPDATE_ID ID", DefColumns.UPDATE_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-687f7268 | this.Load | FP00467_Setup_Matrix.UIL.cs:480 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("UPDATE_TIME", DefColumns.UPDATE_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66829d0a | this.Load | FP00467_Setup_Matrix.UIL.cs:481 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("INSERT_ID", DefColumns.INSERT_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f8fc00bd | this.Load | FP00467_Setup_Matrix.UIL.cs:482 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("INSERT_TIME", DefColumns.INSERT_TIME, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7979f28a | this.Load | FP00467_Setup_Matrix.UIL.cs:484 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e8b4e7e0 | this.Load | FP00467_Setup_Matrix.UIL.cs:486 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00467_Setup_Matrix.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0a4ba88 | InsertButton | FP00467_Setup_Matrix.UIL.cs:698 |  | MESSAGE | MessageBox.Show | ("You cannot insert in this window") | 메시지 표시 |  |  |  |
| AC-f57d69af | InsertButton | FP00467_Setup_Matrix.UIL.cs:699 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-237613c5 | InsertButton | FP00467_Setup_Matrix.UIL.cs:1008 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8dbe3efa | InsertButton | FP00467_Setup_Matrix.UIL.cs:1011 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa876c02 | InsertButton | FP00467_Setup_Matrix.UIL.cs:1013 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## FP00467_Setup_Matrix.RefreshMatrix

진입점: this.Load / cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-deca1a74 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1493 | if (spreadInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-229134d8 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1496 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spreadInfo.ActiveSheet.Columns.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-17917ec9 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1497 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-b65c3b90 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1499 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf2feee4 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1502 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plan Group", DefColumns.INSTANCE_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a8d72c4 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1503 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation", DefColumns.OPERATION_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6f3b02a | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1504 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Line Setup", DefColumns.LINE_SETUP_GROUP_ID, FPMerge.None, 0 ,true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55b24023 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1505 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Category", DefColumns.SETUP_CATEGORY_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89aa1a9d | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1506 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Key", DefColumns.SETUP_KEY_ID, FPMerge.None, 0, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db7f70b6 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1507 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | (". To\r\nFrom .", DefColumns.FROM_ITEM_SETUP_GROUP_ID, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95db0996 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1512 | if (spreadInfo.SheetName == SpdSheet.shtMain) ▸ foreach (KeyValuePair<string, string> kvp in Matrix) | GRID_INIT | spreadInfo.AddTextColumn | (kvp.Key, kvp.Key, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7195f361 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1517 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.FROM_ITEM_SETUP_GROUP_ID) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed22efbf | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:1519 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00467_Setup_Matrix.RefreshSpreadSheet

진입점: this.Load / cboLineSetup.SelectedIndexChanged / cboCategory.SelectedIndexChanged / cboAttribute.SelectedIndexChanged / mcboFrom.SelectedIndexChanged / mcboTo.SelectedIndexChanged / FindButton [try] / SaveButton [if (fps.Name == "spdMain") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a280e5 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:649 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62b2c4b9 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:654 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcAttr.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4f6578d0 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:655 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcFrom.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e84a0baf | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:656 | if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") | UI_PROP | lcTo.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9cf6d641 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:661 | else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item") | UI_PROP | lcAttr.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c2e97231 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:662 | else of (Filter[DefColumns.SETUP_CATEGORY_ID] == "Attribute") ▸ if (Filter[DefColumns.SETUP_CATEGORY_ID] == "Item") | UI_PROP | lcFrom.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-126a912d | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:669 |  | FLAG | dsMain | dsMatrix | 화면 필드/플래그 변경 |  |  |  |
| AC-5bf0b970 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:670 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bddd918 | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:671 |  | CALL_EXT | siMain.EditQuery | (dsMain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d55fe3b | this.Load 외 7 | FP00467_Setup_Matrix.UIL.cs:674 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00467_Setup_Matrix.SaveAttrList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5715a131 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1574 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-84135267 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1576 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-b3bad821 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1580 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.SaveAttrType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50986371 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1533 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e2dfaabf | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1535 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-29c9df78 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1539 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.SaveAttrValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-312f4b64 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1554 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01990_GET_LOOKUP_FP", SaveFilter, _CurrentUser, pSysType, mFlag) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cfe1d87e | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1556 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-b14dd158 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1560 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.SaveDataAttrType

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d131393f | SaveButton | FP00467_Setup_Matrix.UIL.cs:903 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b84aa324 | SaveButton | FP00467_Setup_Matrix.UIL.cs:903 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff998772 | SaveButton | FP00467_Setup_Matrix.UIL.cs:908 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c571faa9 | SaveButton | FP00467_Setup_Matrix.UIL.cs:911 | if (fps.Name == "spdMain") | FLAG | SaveFilter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c29337fb | SaveButton | FP00467_Setup_Matrix.UIL.cs:911 | if (fps.Name == "spdMain") | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-70246551 | SaveButton | FP00467_Setup_Matrix.UIL.cs:912 | if (fps.Name == "spdMain") | FLAG | old_from | mcboFrom.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-f15adf4f | SaveButton | FP00467_Setup_Matrix.UIL.cs:913 | if (fps.Name == "spdMain") | FLAG | old_to | mcboTo.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-04acf7b9 | SaveButton | FP00467_Setup_Matrix.UIL.cs:917 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4d03acf2 | SaveButton | FP00467_Setup_Matrix.UIL.cs:918 | if (fps.Name == "spdMain") ▸ if (siMain.SpreadObject.DataSource != null) | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1aa7648 | SaveButton | FP00467_Setup_Matrix.UIL.cs:924 | if (fps.Name == "spdMain") | DATA_OP | dsMatrixRaw.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-196f6d05 | SaveButton | FP00467_Setup_Matrix.UIL.cs:941 | if (fps.Name == "spdMain") ▸ for (i<= max_col) | DATA_OP | colnames[i] | siMain.GetColumnTag(i) as string | 행/컬럼 값 대입 |  |  |  |
| AC-707a55bc | SaveButton | FP00467_Setup_Matrix.UIL.cs:967 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveMatrix.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7384f4f | SaveButton | FP00467_Setup_Matrix.UIL.cs:969 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.INSTANCE_ID] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-89936e71 | SaveButton | FP00467_Setup_Matrix.UIL.cs:970 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.OPERATION_ID] | operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-31395ccd | SaveButton | FP00467_Setup_Matrix.UIL.cs:971 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.LINE_SETUP_GROUP_ID] | line_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-38ea098d | SaveButton | FP00467_Setup_Matrix.UIL.cs:972 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_CATEGORY_ID] | setup_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-72c8bfd4 | SaveButton | FP00467_Setup_Matrix.UIL.cs:973 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_KEY_ID] | setup_key_id | 행/컬럼 값 대입 |  |  |  |
| AC-f2ddc65e | SaveButton | FP00467_Setup_Matrix.UIL.cs:974 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | row[DefColumns.FROM_ITEM_SETUP_GROUP_ID] | 행/컬럼 값 대입 |  |  |  |
| AC-aa1c2fb2 | SaveButton | FP00467_Setup_Matrix.UIL.cs:975 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.TO_ITEM_SETUP_GROUP_ID] | colname | 행/컬럼 값 대입 |  |  |  |
| AC-e6b6882b | SaveButton | FP00467_Setup_Matrix.UIL.cs:976 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_TIME] | save_value | 행/컬럼 값 대입 |  |  |  |
| AC-ef833ffe | SaveButton | FP00467_Setup_Matrix.UIL.cs:977 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.SETUP_TIME_UOM] | "minute" | 행/컬럼 값 대입 |  |  |  |
| AC-32beba20 | SaveButton | FP00467_Setup_Matrix.UIL.cs:978 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveRow[DefColumns.ACTIVE_FLAG] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-522eb74e | SaveButton | FP00467_Setup_Matrix.UIL.cs:979 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j<= max_col) ▸ else of (org_double == save_double) | DATA_OP | saveMatrix.Tables[0].Rows.Add | (saveRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-990e6ce0 | SaveButton | FP00467_Setup_Matrix.UIL.cs:987 | if (fps.Name == "spdMain") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00466_ItemSetupAttr", "save_setup_matrix", saveMatrix, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_setup_matrix] \| FP\Master\… | 엔드포인트 호출 |  |  |  |
| AC-6161aae9 | SaveButton | FP00467_Setup_Matrix.UIL.cs:988 | if (fps.Name == "spdMain") | CALL_EXT | DataService.ReadResult | (ret) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4896378 | SaveButton | FP00467_Setup_Matrix.UIL.cs:994 | if (fps.Name == "spdMain") ▸ if (dr != null && dr.Success == true && dr.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { done.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00467_Setup_Matrix.SetAttributeCombo

진입점: this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0)] / cboLineSetup.SelectedIndexChanged / cboOperation.SelectedIndexChanged [else of (cboInstance.SelectedIndex < 0 \|\| cboOperation.SelectedIndex < 0)] / cboCategory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d063331 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:237 | if (Filter["CATEGORY_ID"]!= "Attribute") | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-902eb357 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:238 | if (Filter["CATEGORY_ID"]!= "Attribute") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9ab2e31 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:240 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00466_itemSetupAttr", "get_item_list2", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list2] \| FP\MASTER\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1cb93de8 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:246 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | FLAG | dtAttribute | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-98614486 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:247 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | UI_PROP | dtAttribute.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-be18b680 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:248 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | a.Tables.Add | (dtAttribute) | 데이터 객체 조작/조회 |  |  |  |
| AC-57c8d08b | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:249 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | dtAttribute.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e575762 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:250 | if (dsAttrList.Good()) ▸ if (dtAttribute == null) | DATA_OP | dtAttribute.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2104d87b | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:254 | if (dsAttrList.Good()) ▸ else of (dtAttribute == null) | GRID_CLEAR | dtAttribute.Rows.Clear | () | 그리드 행 비움 |  |  |  |
| AC-ccc44469 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:259 | if (dsAttrList.Good()) ▸ for (i < 15) | DATA_OP | dsAttrList.Columns.Contains | (colname) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9ec916f | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:264 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | dtAttribute.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c10cce9 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:265 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | row["CODE"] | colname | 행/컬럼 값 대입 |  |  |  |
| AC-82b54ccf | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:266 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | row["NAME"] | colval | 행/컬럼 값 대입 |  |  |  |
| AC-0faeea2c | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:267 | if (dsAttrList.Good()) ▸ for (i < 15) ▸ if (dsAttrList.Columns.Contains(colname)) ▸ if (!string.IsNullOrWhiteSpace(colval)) | DATA_OP | dtAttribute.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-a22e7d81 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:271 | if (dsAttrList.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtAttribute, cboAttribute, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7fb8bc94 | this.Load [else of (cboInstance.SelectedIndex < 0 \|\| cboOp… 외 3 | FP00467_Setup_Matrix.UIL.cs:275 | else of (dsAttrList.Good()) | CALL_EXT | cboAttribute.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00467_Setup_Matrix.SetAttrValueHeaderInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-887af7b6 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1667 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-38a08eb7 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1676 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-407c0322 | (진입점 미연결) | FP00467_Setup_Matrix.UIL.cs:1682 | if (dtColumInfo.Good()) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhite… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |

## FP00467_Setup_Matrix.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50baecc6 | this.spdMain.CellClick | FP00467_Setup_Matrix.UIL.cs:1620 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8633f354 | this.spdMain.KeyUp | FP00467_Setup_Matrix.UIL.cs:1791 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00467_Setup_Matrix.UIFindData

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-800ebf3f | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:507 |  | FLAG | old_from | mcboFrom.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-19abab75 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:508 |  | FLAG | old_to | mcboTo.ValueList | 화면 필드/플래그 변경 |  |  |  |
| AC-af4a9f28 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:514 | if (cboOperation.SelectedIndex < 0 \|\| cboInstance.SelectedIndex < 0 \|\| cboCategory.SelectedIndex < 0 \|\| cboLineSetup.Selecte…) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-999dd5a5 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:515 | if (cboOperation.SelectedIndex < 0 \|\| cboInstance.SelectedIndex < 0 \|\| cboCategory.SelectedIndex < 0 \|\| cboLineSetup.Selecte…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-128cba20 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:523 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad001526 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:524 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78c4015a | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:527 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3c35adb0 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:529 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-00473226 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:533 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cf03bec3 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:544 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5ec3e448 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:556 | try | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-39fc4779 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:557 | try | DATA_OP | Filter[DefColumns.INSTANCE_ID] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-8d77ea2b | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:558 | try | DATA_OP | Filter[DefColumns.OPERATION_ID] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-c7fd941d | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:559 | try | DATA_OP | Filter[DefColumns.ACTIVE_FLAG] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-36833637 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:560 | try | DATA_OP | Filter[DefColumns.SETUP_CATEGORY_ID] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-96d09bd4 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:561 | try | DATA_OP | Filter[DefColumns.SETUP_KEY_ID] | pSetupKey | 행/컬럼 값 대입 |  |  |  |
| AC-0862b676 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:562 | try | DATA_OP | Filter[DefColumns.LINE_SETUP_GROUP_ID] | pLineSetup | 행/컬럼 값 대입 |  |  |  |
| AC-1a8fde22 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:565 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainMatrix("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-94958112 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:565 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainMatrix("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f4705bb4 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:581 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-122781a6 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:582 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f708e277 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:583 | try ▸ if (dsMain != null) ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-baf7640d | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:588 | try ▸ else of (dsMain != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a8cbf2b2 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:589 | try ▸ else of (dsMain != null) | MESSAGE | MessageBox.Show | ("Query Statement is Occure Error!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-28d329c3 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:611 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7cc3a3c | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:616 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-56d6a991 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:617 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-435ecac1 | FindButton 외 1 | FP00467_Setup_Matrix.UIL.cs:618 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

