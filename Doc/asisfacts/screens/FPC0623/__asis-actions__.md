# AS-IS 액션 대조표 — FPC0623

> 원천: `Doc/asisfacts/screens/FPC0623/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 554행 · 메서드 78 · 종류 DATA_OP 141 · FLAG 83 · RETURN 54 · UI_PROP 40 · STATE 39 · UI_MISC 30 · GRID_INIT 25 · MESSAGE 22 · GRID_SET 21 · CALL_EXT 19 · ENDPOINT 17 · POPUP 14 · THROW 8 · GRID_LOCK 7 · CALL_BASE 7 · COMBO_DATA 6 · LIST_REBIND 6 · GRID_BIND 6 · EXCEL 2 · VALIDATE 2 · VALUE_SET 2 · STATE_RESET 1 · GRID_STYLE 1 · FOCUS 1 · ⚠ 의미 확인 필요 26


## FPC0623_DIOEditPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27fffd67 | .ctor | FPC0623_DIOEditPopup.cs:95 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_DIOEditPopup.btnExcel_Click

진입점: this.btnExcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c5caf86 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1260 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-7fe348e6 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1261 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd1dfcbd | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1272 |  | POPUP | new FPC0623_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-acf9ee51 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1276 |  | UI_PROP | rowPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-cfe18733 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1276 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0edd85ab | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1280 |  | GRID_SET | rowPopup.KeyColumns["INSTANCE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b314ad57 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1281 |  | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-200d1d06 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1282 |  | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f613a59f | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1283 |  | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dbb48fa7 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1284 |  | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9e2ae088 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1285 |  | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-67eb237d | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1286 |  | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d9d8350d | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1288 |  | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0cc829d7 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1290 |  | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-95c3cc8d | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1291 |  | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1b4780e0 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1293 |  | GRID_SET | rowPopup.KeyColumns["TOP_ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4ba4ff8a | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1294 |  | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7295934c | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1296 |  | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-dda500cb | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1311 |  | DATA_OP | rowPopup.ColumnTitle["INSTANCE_ID"] | "Instance" | 행/컬럼 값 대입 |  |  |  |
| AC-08f8cdd4 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1312 |  | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-2e6ed9ce | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1313 |  | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-065a9f7a | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1314 |  | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-af7276b7 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1315 |  | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-b2fdfe11 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1316 |  | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-270ecbfb | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1317 |  | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-f5d1adb1 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1318 |  | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-8bee33fb | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1320 |  | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-4daf4907 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1321 |  | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-bb6adc25 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1322 |  | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-28c0ab38 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1323 |  | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-1ec2cec5 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1325 |  | DATA_OP | rowPopup.ColumnTitle["TOP_ITEM_ID"] | "Model" | 행/컬럼 값 대입 |  |  |  |
| AC-51d9925d | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1326 |  | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-762ee8e5 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1328 |  | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-8dbb6b0a | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1331 |  | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Memo Date" | 행/컬럼 값 대입 |  |  |  |
| AC-e412d2fd | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1332 |  | DATA_OP | rowPopup.ColumnTitle["MEMO_RANGE"] | "Line or Material" | 행/컬럼 값 대입 |  |  |  |
| AC-5e1d0fdf | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1333 |  | DATA_OP | rowPopup.ColumnTitle["MEMO_TYPE"] | "Memo Type" | 행/컬럼 값 대입 |  |  |  |
| AC-f5605edc | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1334 |  | DATA_OP | rowPopup.ColumnTitle["MEMO"] | "Memo" | 행/컬럼 값 대입 |  |  |  |
| AC-a4d22a5f | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1338 |  | DATA_OP | rowPopup.ColumnTitle["UPDATE_ID"] | "Update User" | 행/컬럼 값 대입 |  |  |  |
| AC-4827c694 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1339 |  | DATA_OP | rowPopup.ColumnTitle["UPDATE_TIME"] | "Update Time" | 행/컬럼 값 대입 |  |  |  |
| AC-581cf572 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1341 |  | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-0ed0e43b | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["DIVISION_ID"] | rowPopup.ColumnWidth["SITE_ID"] = rowPopup.ColumnWidth["LINE_NAME"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-76b792c3 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["SITE_ID"] | rowPopup.ColumnWidth["LINE_NAME"] = rowPopup.ColumnWidth["ITEM_ID"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-bcf59b93 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["LINE_NAME"] | rowPopup.ColumnWidth["ITEM_ID"] = rowPopup.ColumnWidth["NICK_NAME"] = rowPopup.ColumnWidth… | 행/컬럼 값 대입 |  |  |  |
| AC-46602733 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["ITEM_ID"] | rowPopup.ColumnWidth["NICK_NAME"] = rowPopup.ColumnWidth["PRODUCTION_TYPE"] = 100 | 행/컬럼 값 대입 |  |  |  |
| AC-bb20947d | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["NICK_NAME"] | rowPopup.ColumnWidth["PRODUCTION_TYPE"] = 100 | 행/컬럼 값 대입 |  |  |  |
| AC-76c0ea59 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1344 |  | DATA_OP | rowPopup.ColumnWidth["PRODUCTION_TYPE"] | 100 | 행/컬럼 값 대입 |  |  |  |
| AC-fedb6717 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1345 |  | DATA_OP | rowPopup.ColumnWidth["MEMO"] | 200 | 행/컬럼 값 대입 |  |  |  |
| AC-639d5e83 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1347 |  | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-d54a30ec | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1349 |  | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-0a7afd5c | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1350 |  | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-536acb93 | this.btnExcel.Click | FPC0623_DIOEditPopup.cs:1351 |  | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0623_DIOEditPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af82587a | this.btnSql.Click | FPC0623_DIOEditPopup.cs:931 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8dc0703b | this.btnSql.Click | FPC0623_DIOEditPopup.cs:932 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f916e8d5 | this.btnSql.Click | FPC0623_DIOEditPopup.cs:934 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00608_AMEND_MEMO_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-a386efcc | this.btnSql.Click | FPC0623_DIOEditPopup.cs:935 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00608_AMEND_MEMO_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7351b2ce | this.btnSql.Click | FPC0623_DIOEditPopup.cs:936 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0623_DIOEditPopup.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daa72558 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1412 | try ▸ if (popup == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "No Data to save") | ⚠ 의미 확인 필요 |  |  |  |
| AC-58265820 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1412 | try ▸ if (popup == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "No Data to save"); |  | 처리 중단/반환 |  |  |  |
| AC-504eb563 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1414 | try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-692e679d | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1416 | try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8953b262 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1417 | try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b30551d4 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1429 | try ▸ if (Save_Data_Momo_Excel(data) == true) | UI_PROP | popup.validation | null | 속성 validation 설정 |  |  |  |
| AC-e60204ce | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1430 | try ▸ if (Save_Data_Momo_Excel(data) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-56e65b4d | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1432 | try ▸ if (Save_Data_Momo_Excel(data) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-23b15789 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1432 | try ▸ if (Save_Data_Momo_Excel(data) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-c7b0e1e5 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1438 | catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83bc2bbf | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1438 | catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-1df8807a | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1440 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Unknown error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-78a43e65 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1440 |  | RETURN | return DataService.CreateResultDataSet(false, 0, "Unknown error"); |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4efa1e36 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1377 | if (popup != null) | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-e186f57a | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1388 | if (popup != null) ▸ if (m.Good()) ▸ foreach (DataRow r in m.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "-") | DATA_OP | r["MEMO_RANGE"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-6c11e708 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1392 | if (popup != null) ▸ if (m.Good()) ▸ foreach (DataRow r in m.Tables[0].Rows) ▸ else of (string.IsNullOrWhiteSpace(item_id) \|\| item_id == "… | DATA_OP | r["MEMO_RANGE"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-25f5d164 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1396 | if (popup != null) ▸ if (m.Good()) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("INSTANCE_ID", "DIVISION_ID", "SITE_ID", "PLANT_ID", "FACTORY_ID", "LINE_ID", "OPERATION_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-105314b6 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1400 | if (popup != null) | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-2b2a9a01 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1403 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4c900bc | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1704 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9bd0e26b | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1707 | if (data.Good()) | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a78dfd7 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1710 | if (data.Good()) | DATA_OP | Filter["GUID"] | g.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d3fd1643 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1712 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("GUID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44f58374 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1715 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["GUID"] | g.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9b78305a | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1719 | if (data.Good()) ▸ try | ENDPOINT | DataService.FP_PseudoBatch | ("MemoExcel", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-f608b437 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1720 | if (data.Good()) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("MemoExcel", "find_Excel_buffer_validation", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-14452180 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1725 | if (data.Good()) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-119749aa | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1730 | if (data.Good()) ▸ finally | ENDPOINT | DataService.FP_ExecuteNonQuery | ("MemoExcel", "delete_validation_buffer", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_validation_buffer] \|… | 엔드포인트 호출 |  |  |  |
| AC-9255acff | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1732 | if (data.Good()) | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-bbd7807a | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1734 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f01bb409 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:308 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e9c0902f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:309 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## FPC0623_DIOEditPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dedd6d0c | this.Load | FPC0623_DIOEditPopup.cs:318 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d6f7d296 | this.Load | FPC0623_DIOEditPopup.cs:319 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b534f6b4 | this.Load | FPC0623_DIOEditPopup.cs:321 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0623_DIOEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4de32bfe | this.Load | FPC0623_DIOEditPopup.cs:195 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-3d753ed1 | this.Load | FPC0623_DIOEditPopup.cs:197 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9aca3c27 | this.Load | FPC0623_DIOEditPopup.cs:198 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-3d20b6b1 | this.Load | FPC0623_DIOEditPopup.cs:199 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-7ff2323c | this.Load | FPC0623_DIOEditPopup.cs:201 |  | FLAG | cellTypeDef | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_DIOEditPopup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f81c4861 | DeleteButton | FPC0623_DIOEditPopup.cs:520 | if (spdMain != null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-528d588b | Dispose | FPC0623_DIOEditPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0623_DIOEditPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc760185 | EditButton | FPC0623_DIOEditPopup.cs:494 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-59310048 | EditButton | FPC0623_DIOEditPopup.cs:498 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b158db53 | EditButton | FPC0623_DIOEditPopup.cs:510 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-43f33960 | EditButton | FPC0623_DIOEditPopup.cs:511 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIO), siMain.GetColumnIndex(DefColumns.DIO), IsLock) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0623_DIOEditPopup.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-912edb21 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1758 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0eea1a8e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1759 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ac04262 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1761 |  | FLAG | clicked_row | siMain.ActiveSheet.Rows[cRow].Tag as DataRow | 화면 필드/플래그 변경 |  |  |  |
| AC-779e0edc | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1763 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4bd8eb3 | ExcelButton | FPC0623_DIOEditPopup.cs:569 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FPC0623_DIOEditPopup.Find_Data_Memo

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b327a2 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:712 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pModel = txtModel.Text; pItem = txtItemID.Text; pNickname… | ⚠ 의미 확인 필요 |  |  |  |
| AC-40290f73 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:724 | try | DATA_OP | Filter["ITEM_ID"] | txtItemID.Text | 행/컬럼 값 대입 |  |  |  |
| AC-073e8b11 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:725 | try | DATA_OP | Filter["TOP_ITEM_ID"] | txtModel.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1c1d095c | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:726 | try | DATA_OP | Filter["NICK_NAME"] | txtNickname.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ea760ada | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:728 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("DIO", "find_dio", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dio] \| FP\MASTER\DIO#find… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aa545e22 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:729 | try | RETURN | return dioInfo; |  | 처리 중단/반환 |  |  |  |
| AC-2135c1e8 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 4 | FPC0623_DIOEditPopup.cs:733 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.Find_Data_Old

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4a36e6 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:575 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1de3c385 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:579 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-525fe715 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:582 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-956c111c | (진입점 미연결) | FPC0623_DIOEditPopup.cs:582 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f080d359 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:588 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a2eb352 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:591 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8761c2a9 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:598 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Memo("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5f321021 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:604 | try ▸ if (!ds.Good()) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-17697374 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:613 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-f167d25b | (진입점 미연결) | FPC0623_DIOEditPopup.cs:616 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0bc75970 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:618 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc1a7af8 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:622 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0e3b72bf | (진입점 미연결) | FPC0623_DIOEditPopup.cs:634 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-7846c09d | (진입점 미연결) | FPC0623_DIOEditPopup.cs:643 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4668cf14 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:645 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-32312865 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:645 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0623_DIOEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6446ef65 | this.Load | FPC0623_DIOEditPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0623_DIOEditPopup.GetCateTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1077a2b8 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1203 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5f864c53 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1204 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5229540d | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1206 | if (!coteInfo.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f66a13e3 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1207 |  | DATA_OP | coteInfo.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4434262e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1208 |  | DATA_OP | coteInfo.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b96339c5 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1212 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["CODE"] | cate["SEGMENT1"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-35fd0c83 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1213 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["NAME"] | cate["ATTRIBUTE2"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-13b24646 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1214 | foreach (DataRow cate in coteInfo.Rows) | DATA_OP | cate["ATTRIBUTE2"].SafeString().ToUpper().Contains | ("MODEL CHANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e580f62 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1217 |  | RETURN | return coteInfo; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-728fc18c | this.Load [try] | FPC0623_DIOEditPopup.cs:1828 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-a104f025 | this.Load [try] | FPC0623_DIOEditPopup.cs:1828 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd76e19f | this.Load [try] | FPC0623_DIOEditPopup.cs:1830 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cbo_division, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0623_DIOEditPopup.GetModelChangeTable

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe3f1683 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1223 |  | DATA_OP | Filter["INSTANCE_ID"] | Instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-41dc65ad | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1224 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("AmendMemo", "find_SetupColor_P_ID", Filter.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P_ID] \| FP\Com… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0ac6c91b | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1229 |  | DATA_OP | modeChange.Columns.SafeAdd | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2f78fc8 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1230 |  | DATA_OP | modeChange.Columns.SafeAdd | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a60dd32 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1234 | foreach (DataRow cate in modeChange.Rows) | DATA_OP | cate["CODE"] | cate["COLOR_ID"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-6df60002 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1235 | foreach (DataRow cate in modeChange.Rows) | DATA_OP | cate["NAME"] | cate["UI_COLOR"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-175f3bec | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1237 |  | RETURN | return modeChange; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.GetSite

진입점: this.Load [try] / cbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a22b8d54 | this.Load [try] 외 1 | FPC0623_DIOEditPopup.cs:1843 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7e4266f | this.Load [try] 외 1 | FPC0623_DIOEditPopup.cs:1843 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d0f95657 | this.Load [try] 외 1 | FPC0623_DIOEditPopup.cs:1845 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0623_DIOEditPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4609325 | this.Load | FPC0623_DIOEditPopup.cs:128 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7aaa843 | this.Load | FPC0623_DIOEditPopup.cs:134 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-868db336 | this.Load | FPC0623_DIOEditPopup.cs:135 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-39518e34 | this.Load | FPC0623_DIOEditPopup.cs:139 | try | DATA_OP | Filter["DIVISION_ID"] | cbo_division.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-fb8c017d | this.Load | FPC0623_DIOEditPopup.cs:142 | try | DATA_OP | Filter["SITE_ID"] | cbo_site.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-ed70dce7 | this.Load | FPC0623_DIOEditPopup.cs:172 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3a6a67aa | this.Load | FPC0623_DIOEditPopup.cs:173 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a644d736 | this.Load | FPC0623_DIOEditPopup.cs:174 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-daac0ac8 | this.Load | FPC0623_DIOEditPopup.cs:175 | try ▸ if (adminAuth == false) | STATE | btnExcel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-eb3f8697 | this.Load | FPC0623_DIOEditPopup.cs:176 | try ▸ if (adminAuth == false) | STATE | btnExcel.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-15a15e50 | this.Load | FPC0623_DIOEditPopup.cs:177 | try ▸ if (adminAuth == false) | UI_PROP | lblExcel.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2c745fa2 | this.Load | FPC0623_DIOEditPopup.cs:188 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.InitSpread

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / this.Load / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2377310d | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:333 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2cc5e1b1 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:334 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-12727338 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:338 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff98b555 | InsertButton | FPC0623_DIOEditPopup.cs:548 | if (fps != null) ▸ if (!siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69334cbd | InsertButton | FPC0623_DIOEditPopup.cs:556 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa250c61 | InsertButton | FPC0623_DIOEditPopup.cs:559 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5ed81112 | InsertButton | FPC0623_DIOEditPopup.cs:560 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == Sp… | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIO), siMain.GetColumnIndex(DefColumns.DIO), tr… | 그리드 편집 잠금/해제 |  |  |  |

## FPC0623_DIOEditPopup.mcbo_division_changed

진입점: cbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b134b1e9 | cbo_division.SelectedIndexChanged | FPC0623_DIOEditPopup.cs:1836 |  | DATA_OP | Filter["DIVISION_ID"] | cbo_division.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |

## FPC0623_DIOEditPopup.mcbo_site_changed

진입점: cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45f6fdb5 | cbo_site.SelectedIndexChanged | FPC0623_DIOEditPopup.cs:1850 |  | DATA_OP | Filter["SITE_ID"] | cbo_site.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |

## FPC0623_DIOEditPopup.rdoGroup1_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01a43c96 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1113 | if (radioGroup.SelectedIndex == 0) | FLAG | this._sMemoType | "DPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-82c7db10 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1117 | else of (radioGroup.SelectedIndex == 0) ▸ if (radioGroup.SelectedIndex == 1) | FLAG | this._sMemoType | "WPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-9a0dd880 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1121 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ if (radioGroup.SelectedIndex == 2) | FLAG | this._sMemoType | "MPP" | 화면 필드/플래그 변경 |  |  |  |
| AC-12a59ccf | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1125 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ else of (radioGroup.SelectedIndex == 2) ▸ if (radioGroup… | FLAG | this._sMemoType | "MRP" | 화면 필드/플래그 변경 |  |  |  |
| AC-7547877f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1129 | else of (radioGroup.SelectedIndex == 0) ▸ else of (radioGroup.SelectedIndex == 1) ▸ else of (radioGroup.SelectedIndex == 2) ▸ else of (radio… | FLAG | this._sMemoType | "WO" | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_DIOEditPopup.RefreshHeader

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13edb05b | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 2 | FPC0623_DIOEditPopup.cs:675 | if (!dsMain.Good()) | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0a1f05d5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 2 | FPC0623_DIOEditPopup.cs:679 | else of (!dsMain.Good()) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-eb68536a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 2 | FPC0623_DIOEditPopup.cs:681 | else of (!dsMain.Good()) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cf170820 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 2 | FPC0623_DIOEditPopup.cs:690 | else of (!dsMain.Good()) ▸ foreach (FarPoint.Win.Spread.Row row in siMain.ActiveSheet.Rows) ▸ if (r!=null) ▸ if (isdefault == "N") | GRID_SET | siMain.ActiveSheet.Cells[row.Index, def_col_idx].BackColor | System.Drawing.Color.Orange | 그리드 속성/값 설정 |  |  |  |

## FPC0623_DIOEditPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b101260f | popSql.OnSql | FPC0623_DIOEditPopup.cs:1148 | if (programID == "PR_UI_FP00608_AMEND_MEMO_SELECT") | RETURN | return Find_Data_Memo("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-24887d38 | popSql.OnSql | FPC0623_DIOEditPopup.cs:1154 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd758153 | SaveButton | FPC0623_DIOEditPopup.cs:744 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39a7b4f4 | SaveButton | FPC0623_DIOEditPopup.cs:746 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a24866e0 | SaveButton | FPC0623_DIOEditPopup.cs:750 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40bf1f33 | SaveButton | FPC0623_DIOEditPopup.cs:751 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-305c1a28 | SaveButton | FPC0623_DIOEditPopup.cs:754 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f2ec1dc3 | SaveButton | FPC0623_DIOEditPopup.cs:761 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-95e5d3f2 | SaveButton | FPC0623_DIOEditPopup.cs:763 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e9172d49 | SaveButton | FPC0623_DIOEditPopup.cs:764 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-698d2f8e | SaveButton | FPC0623_DIOEditPopup.cs:778 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ac86f4f3 | SaveButton | FPC0623_DIOEditPopup.cs:783 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { drResult.Count}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-78894ab6 | SaveButton | FPC0623_DIOEditPopup.cs:792 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (drResult.Success) | MESSAGE | MessageBox.Show | (errorMsg) | 메시지 표시 |  |  |  |
| AC-6f8f109f | SaveButton | FPC0623_DIOEditPopup.cs:797 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec85ee8 | SaveButton | FPC0623_DIOEditPopup.cs:801 | catch () | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-537ccf20 | SaveButton | FPC0623_DIOEditPopup.cs:802 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12f2ee81 | SaveButton | FPC0623_DIOEditPopup.cs:807 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_DIOEditPopup.Save_Data_Momo

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bed086a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:816 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c12df1ba | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:835 | try | DATA_OP | dsSave.Tables.Add | (dtSave) | 데이터 객체 조작/조회 |  |  |  |
| AC-2439b814 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:836 | try | UI_PROP | dtSave.TableName | "SaveTable" | 속성 TableName 설정 |  |  |  |
| AC-4130f684 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:837 | try | DATA_OP | dtSave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7bd4a85 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:838 | try | DATA_OP | dtSave.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2a3d2ba | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:839 | try | DATA_OP | dtSave.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3ee9bfa8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:840 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c29e0af8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:841 | try | DATA_OP | dtSave.Columns.SafeAdd | ("DIO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2a846ec | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:843 | try | DATA_OP | dsSave.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-81023388 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:887 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5d735d6c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:888 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | dtSave.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-b676eca7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:889 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | row[DefColumns.DIVISION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-2cd0a314 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:890 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | row[DefColumns.SITE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SITE_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd859851 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:891 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | row[DefColumns.ITEM_ID] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-b01ae412 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:892 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | row[DefColumns.DIO] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.DIO)).SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-c49353fc | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:893 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagI \|\| actionState == CAppSetting.FlagM) | DATA_OP | row["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-52c93c88 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:903 | try ▸ if (iCount > 0) ▸ if (dtSave.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("DIO", "save_dio", dsSave, 0,"MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_dio] \| FP\MASTER\DIO#save_… | 엔드포인트 호출 |  |  |  |
| AC-86ba76db | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:904 | try ▸ if (iCount > 0) ▸ if (dtSave.Good()) | CALL_EXT | DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8987630a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:906 | try ▸ if (iCount > 0) | RETURN | return drResult; |  | 처리 중단/반환 |  |  |  |
| AC-e1187ae7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:910 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b89eb03b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:911 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b582454c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FPC0623_DIOEditPopup.cs:917 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.Save_Data_Momo_Excel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a65384f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1447 | if (!dsSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0f085ead | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1488 | try | DATA_OP | dtSave.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-25b21b92 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1489 | try | DATA_OP | dtSave.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e65ac32c | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1490 | try | DATA_OP | dtSave.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ada62e87 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1491 | try | DATA_OP | dtSave.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-837e8ec7 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1492 | try | DATA_OP | dtSave.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-680e7c76 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1493 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bb598c8 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1494 | try | DATA_OP | dtSave.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d68d1f4 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1495 | try | DATA_OP | dtSave.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2479b7e0 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1496 | try | DATA_OP | dtSave.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-463b087e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1497 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0495ec52 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1498 | try | DATA_OP | dtSave.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9383305 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1499 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a567b3f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1500 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec431bbe | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1501 | try | DATA_OP | dtSave.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-74f61d2e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1502 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7f94f8e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1503 | try | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9132b2c | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1504 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d6e7a09 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1505 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bd50c3a | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1506 | try | DATA_OP | dtSave.Columns.SafeAdd | ("MEMO_RANGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-187f4718 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1507 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR1", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69900a73 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1508 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR2", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d156d5 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1509 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR3", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ddc92ae1 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1510 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR4", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-41ab9e0f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1511 | try | DATA_OP | dtSave.Columns.SafeAdd | ("ATTR5", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd5492f2 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1623 | try ▸ if (dsSave.Good()) | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4a0c4c3f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1624 | try ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1dd01d5e | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1645 | try ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_UpdateBatch | ("AmendMemo", "fetch_amend_memo", dsSave) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=fetch_amend_memo] \| FP\Common\A… | 엔드포인트 호출 |  |  |  |
| AC-35e54cc0 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1646 | try ▸ if (dsSave.Good()) | CALL_EXT | DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31eb2859 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1664 | try | UI_PROP | drResult.Success | drB.Success | 속성 Success 설정 |  |  |  |
| AC-634acf31 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1665 | try | UI_PROP | drResult.Count | drB.Count | 속성 Count 설정 |  |  |  |
| AC-5ae32f5d | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1666 | try | UI_PROP | drResult.Message | drB.Message | 속성 Message 설정 |  |  |  |
| AC-ff550853 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1668 | try | RETURN | return drResult.Success; |  | 처리 중단/반환 |  |  |  |
| AC-6edef689 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1679 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8190ee35 | SaveButton | FPC0623_DIOEditPopup.cs:527 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f9e128f | SaveButton | FPC0623_DIOEditPopup.cs:528 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cf786a49 | SaveButton | FPC0623_DIOEditPopup.cs:530 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0623_DIOEditPopup.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d71f48c | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1689 |  | DATA_OP | BohSet["PLAN_DATE"] | popupFilter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-aeddaabe | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1690 |  | DATA_OP | BohSet["MASTER_ID"] | popupFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7db89b08 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1691 |  | DATA_OP | BohSet["PLAN_ID"] | popupFilter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2809e134 | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1692 |  | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2728be0f | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1695 | if (string.IsNullOrWhiteSpace(popupFilter["FP_PLAN_ID"])) | DATA_OP | BohSet["PLAN_ID"] | data.Tables[0].Rows[0]["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9140bcd | (진입점 미연결) | FPC0623_DIOEditPopup.cs:1700 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.SetSpreadInit

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e271d2e | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:347 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-633af6a4 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:348 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-f989b43c | this.btnExcel.Click [if (rowPopup.SaveSuccess == true) ▸ try… 외 3 | FPC0623_DIOEditPopup.cs:353 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FPC0623_DIOEditPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7a59b96 | this.spdMain.CellClick | FPC0623_DIOEditPopup.cs:1016 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48697f9c | this.spdMain.CellClick | FPC0623_DIOEditPopup.cs:1018 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c424e0be | this.spdMain.CellClick | FPC0623_DIOEditPopup.cs:1045 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90622ec9 | this.spdMain.CellDoubleClick | FPC0623_DIOEditPopup.cs:1070 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbe91ffa | this.spdMain.CellDoubleClick | FPC0623_DIOEditPopup.cs:1072 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if ((siMain.ActiveSheet.Rows.Count <= 0) \|\| siMain.IsLock(siMain.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79f12324 | this.spdMain.CellDoubleClick | FPC0623_DIOEditPopup.cs:1100 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FPC0623_DIOEditPopup.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47f50ba0 | this.spdMain.Change | FPC0623_DIOEditPopup.cs:1179 | if (string.IsNullOrWhiteSpace(selected_column)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e6e2558 | this.spdMain.Change | FPC0623_DIOEditPopup.cs:1182 | if (sp == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0623_DIOEditPopup.UIFindData

진입점: this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (drResult.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27f54b3a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:388 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd72125a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:389 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55301b6e | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:393 | try ▸ if (string.IsNullOrWhiteSpace(txtModel.Text) && string.IsNullOrWhiteSpace(txtItemID.Text) && string.IsNullOrWhiteSpace(txtNi…) | MESSAGE | MessageBox.Show | ("Please select one of text criteria. If not results count is too big") | 메시지 표시 |  |  |  |
| AC-673714a3 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:394 | try ▸ if (string.IsNullOrWhiteSpace(txtModel.Text) && string.IsNullOrWhiteSpace(txtItemID.Text) && string.IsNullOrWhiteSpace(txtNi…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34d41b46 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:399 | try ▸ if (string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["DIVISION_ID"] | cbo_division.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-35af2338 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:403 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a13cd0d0 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:404 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-736ec46f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:407 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-053c6829 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:412 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-65f8e396 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:422 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a9d2d35f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:424 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7c7ece90 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:431 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b356d41d | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:432 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | dsMain | await proxyPivot.ExecuteAsync<DataSet>(() => Find_Data_Memo("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1547973 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:432 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Memo("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b6b2893 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:436 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a3a3f24a | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:437 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-91c4ba86 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:441 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d80dd69c | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:442 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f7231499 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:448 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6a3ec7ac | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:452 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-323c6c80 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:457 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ed519358 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:459 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-06acb7ef | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:463 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-739166c5 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:470 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-9bece299 | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:474 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2c92a91f | this.btnExcel.Click [if (rowPopup.SaveSuccess == true)] 외 2 | FPC0623_DIOEditPopup.cs:475 | finally | GRID_LOCK | siMain.LockColumn | (0, siMain.ActiveSheet.Columns.Count - 1, true) | 그리드 편집 잠금/해제 |  |  |  |

## FPC0623_OperationByInstPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df4f27c3 | .ctor | FPC0623_OperationByInstPopup.cs:118 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-13914783 | .ctor | FPC0623_OperationByInstPopup.cs:119 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b60ca453 | .ctor | FPC0623_OperationByInstPopup.cs:121 |  | FLAG | this.sInstance | "All" | 화면 필드/플래그 변경 |  |  |  |
| AC-f37e1c38 | .ctor | FPC0623_OperationByInstPopup.cs:129 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-7b568475 | .ctor | FPC0623_OperationByInstPopup.cs:130 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-244cb677 | .ctor | FPC0623_OperationByInstPopup.cs:132 |  | FLAG | this.sInstance | "All" | 화면 필드/플래그 변경 |  |  |  |
| AC-87a525f8 | .ctor | FPC0623_OperationByInstPopup.cs:142 |  | FLAG | this.bCtlEnable | p_controlEnable | 화면 필드/플래그 변경 |  |  |  |
| AC-2af728c8 | .ctor | FPC0623_OperationByInstPopup.cs:143 |  | FLAG | this.bMulltiSelect | p_multiselect | 화면 필드/플래그 변경 |  |  |  |
| AC-e8e86a77 | .ctor | FPC0623_OperationByInstPopup.cs:145 |  | FLAG | this.sInstance | pInstance | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_OperationByInstPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5ac2572 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0623_OperationByInstPopup.cs:380 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c4478a09 | this.btnButtonList.UsrButtonList_Click_Detected | FPC0623_OperationByInstPopup.cs:383 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_OperationByInstPopup.CboInstance_SelectedIndexChanged

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c5b855 | cboInstance.SelectedIndexChanged | FPC0623_OperationByInstPopup.cs:233 |  | FLAG | sInstance | cboInstance.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-fc66fcd4 | cboInstance.SelectedIndexChanged | FPC0623_OperationByInstPopup.cs:236 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-71e04d5f | cboInstance.SelectedIndexChanged | FPC0623_OperationByInstPopup.cs:236 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIn… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5dcf07c | cboInstance.SelectedIndexChanged | FPC0623_OperationByInstPopup.cs:237 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FPC0623_OperationByInstPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288f4424 | this.Load | FPC0623_OperationByInstPopup.cs:243 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0be14fc1 | this.Load | FPC0623_OperationByInstPopup.cs:244 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2720292e | this.Load | FPC0623_OperationByInstPopup.cs:245 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0623_OperationByInstPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5c57944 | this.Load | FPC0623_OperationByInstPopup.cs:207 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0623_OperationByInstPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40e1f376 | Dispose | FPC0623_OperationByInstPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0623_OperationByInstPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04a2a34 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:323 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ed5f0cd2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:324 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b494c316 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:327 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-026f9145 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:329 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { FilterDataSet filter = new FilterDataSet(); filter["USER_ID"] = UserInfoContext.C… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d5d462e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:332 | lambda | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-703f9bf6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:333 | lambda | DATA_OP | filter["INSTANCE_ID"] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-14d847ec | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:334 | lambda | DATA_OP | filter["OPERATION_ID"] | pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-1a249c17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:336 | lambda | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), "SELECT", "OPERATION_INSTANCE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-61728242 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:336 | lambda | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9faebdbe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:339 | lambda | RETURN | return s; |  | 처리 중단/반환 |  |  |  |
| AC-ab422c6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:343 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1c7059b2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:351 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-f0a15b36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FPC0623_OperationByInstPopup.cs:353 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_OperationByInstPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-517f70b3 | this.Load | FPC0623_OperationByInstPopup.cs:153 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-026339f5 | this.Load | FPC0623_OperationByInstPopup.cs:155 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0623_OperationByInstPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adde2613 | this.Load | FPC0623_OperationByInstPopup.cs:182 |  | FLAG | dtInstance | DataService.GetInstanceSetupInstance(Filter, _sNonAuth, _sSaveAuth) | 화면 필드/플래그 변경 |  |  |  |
| AC-88659839 | this.Load | FPC0623_OperationByInstPopup.cs:182 |  | CALL_EXT | DataService.GetInstanceSetupInstance | (Filter, _sNonAuth, _sSaveAuth) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10208ab5 | this.Load | FPC0623_OperationByInstPopup.cs:184 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dee27bab | this.Load | FPC0623_OperationByInstPopup.cs:185 |  | VALUE_SET | cboInstance.ControlValues | sInstance | 컨트롤 값 설정 |  |  |  |
| AC-33a2be78 | this.Load | FPC0623_OperationByInstPopup.cs:188 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-7827756e | this.Load | FPC0623_OperationByInstPopup.cs:188 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, pIn… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-07b60396 | this.Load | FPC0623_OperationByInstPopup.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f070729a | this.Load | FPC0623_OperationByInstPopup.cs:190 |  | VALUE_SET | cboOperation.ControlValues | sOperation | 컨트롤 값 설정 |  |  |  |
| AC-61bd093d | this.Load | FPC0623_OperationByInstPopup.cs:194 | if (bCtlEnable == true) | STATE | cboInstance.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9d23884f | this.Load | FPC0623_OperationByInstPopup.cs:195 | if (bCtlEnable == true) | STATE | cboOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-172d2e40 | this.Load | FPC0623_OperationByInstPopup.cs:199 | else of (bCtlEnable == true) | STATE | cboInstance.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d611f7da | this.Load | FPC0623_OperationByInstPopup.cs:200 | else of (bCtlEnable == true) | STATE | cboOperation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0623_OperationByInstPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b434b440 | this.Load | FPC0623_OperationByInstPopup.cs:255 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78a21c0d | this.Load | FPC0623_OperationByInstPopup.cs:256 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0623_OperationByInstPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25f80a01 | (진입점 미연결) | FPC0623_OperationByInstPopup.cs:278 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0623_OperationByInstPopup.SetLineInfo

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbe0a414 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:422 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16ab3068 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:423 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-814f5abc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:425 |  | FLAG | _InstanceId | this.dtFindData.Rows[iClick_Row][DefColumns.INSTANCE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e5ce6fe2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:426 |  | FLAG | _OperationId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ed22ee1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:427 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[iClick_Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-360e3a2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:428 |  | FLAG | _InstanceName | this.dtFindData.Rows[iClick_Row][DefColumns.INSTANCE_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a4771542 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | FPC0623_OperationByInstPopup.cs:431 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_OperationByInstPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a166c58e | this.Load | FPC0623_OperationByInstPopup.cs:263 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd55a159 | this.Load | FPC0623_OperationByInstPopup.cs:264 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-63bf0aec | this.Load | FPC0623_OperationByInstPopup.cs:268 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-222f3960 | this.Load | FPC0623_OperationByInstPopup.cs:269 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0623_OperationByInstPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a4337b6 | this.spdMain.CellClick | FPC0623_OperationByInstPopup.cs:394 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_OperationByInstPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d91338d6 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:399 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-383cf11d | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:401 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb4a3854 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:403 |  | FLAG | _InstanceId | this.dtFindData.Rows[e.Row][DefColumns.INSTANCE_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ecb55157 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:404 |  | FLAG | _InstanceName | this.dtFindData.Rows[e.Row][DefColumns.INSTANCE_NAME].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-578a8205 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:405 |  | FLAG | _OperationId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8746fe16 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:406 |  | FLAG | _OperationGroupId | this.dtFindData.Rows[e.Row][DefColumns.OPERATION_GROUP_ID].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-721076f7 | this.spdMain.CellDoubleClick | FPC0623_OperationByInstPopup.cs:411 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc65de7 | .ctor | FPC0623_RowExcelPopup.cs:137 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-1a739a1b | .ctor | FPC0623_RowExcelPopup.cs:138 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d832e186 | .ctor | FPC0623_RowExcelPopup.cs:139 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dd2afb02 | .ctor | FPC0623_RowExcelPopup.cs:140 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0623_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89b5b242 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:211 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fa2d2362 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:212 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-01894da7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:213 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5cb161ba | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:214 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1735b3fd | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:216 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-21523ebf | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:216 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f3c9f9c3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:217 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-813e9a3c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:217 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d987df90 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:218 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-b53b1bab | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:218 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e7e368ef | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:219 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-250fed01 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:219 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4fc6e4e3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:228 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-41033290 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:229 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-7c06860d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:230 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-c8a8b4bd | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FPC0623_RowExcelPopup.cs:231 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FPC0623_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a28a9e0 | this.btnClose.Click | FPC0623_RowExcelPopup.cs:795 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2116db69 | this.btnDownload.Click | FPC0623_RowExcelPopup.cs:777 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-be4bf45e | this.btnDownload.Click | FPC0623_RowExcelPopup.cs:778 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FPC0623_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2430d8fd | this.btnFind.Click | FPC0623_RowExcelPopup.cs:768 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d62ab4d6 | this.btnFind.Click | FPC0623_RowExcelPopup.cs:769 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0623_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb1e0a07 | this.Load | FPC0623_RowExcelPopup.cs:259 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8424df57 | this.Load | FPC0623_RowExcelPopup.cs:260 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-110846ca | this.Load | FPC0623_RowExcelPopup.cs:261 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0623_RowExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4794b536 | dateRange.ValueChanged | FPC0623_RowExcelPopup.cs:800 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f4587185 | dateRange.ValueChanged | FPC0623_RowExcelPopup.cs:801 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FPC0623_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d5d1055 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:731 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46f07360 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:731 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FPC0623_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-495b7c15 | this.Load | FPC0623_RowExcelPopup.cs:254 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0623_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-340be088 | Dispose | FPC0623_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0623_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc36d326 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:694 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FPC0623_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad102d5d | FindButton | FPC0623_RowExcelPopup.cs:301 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-430ffa28 | FindButton | FPC0623_RowExcelPopup.cs:302 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-95c48c9f | FindButton | FPC0623_RowExcelPopup.cs:304 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0623_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b329bf20 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:343 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df2df8f3 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:344 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-700bf0a4 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:344 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-44825c50 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:348 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b035b21 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:349 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4d3bad82 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:351 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2fcdb913 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:352 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f3d9fd5e | this.Load 외 2 | FPC0623_RowExcelPopup.cs:353 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6170f1b7 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:354 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cb93dbb7 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:355 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e6e1a0bc | this.Load 외 2 | FPC0623_RowExcelPopup.cs:356 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7dd7afcd | this.Load 외 2 | FPC0623_RowExcelPopup.cs:363 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cea94929 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:368 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5494ff43 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:370 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-7733d289 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:371 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-4c273ec8 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:372 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-b92ddd41 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:374 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fd32dcb | this.Load 외 2 | FPC0623_RowExcelPopup.cs:376 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27ac5808 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderFromDataSource(siMain, set, Co… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aff2b661 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:379 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-ab04c648 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:379 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-4f16550b | this.Load 외 2 | FPC0623_RowExcelPopup.cs:385 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-613abc1c | this.Load 외 2 | FPC0623_RowExcelPopup.cs:386 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-e489f811 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:387 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-285daf25 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d223f39c | this.Load 외 2 | FPC0623_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aa58d1c | this.Load 외 2 | FPC0623_RowExcelPopup.cs:397 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-06f439ec | this.Load 외 2 | FPC0623_RowExcelPopup.cs:398 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a163e1b0 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:407 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6553e5ac | this.Load 외 2 | FPC0623_RowExcelPopup.cs:410 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7519a4e0 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:411 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2aae1d4c | this.Load 외 2 | FPC0623_RowExcelPopup.cs:412 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2e491f01 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:413 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9fb5ee38 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:414 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b5205a19 | this.Load 외 2 | FPC0623_RowExcelPopup.cs:415 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0623_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49fa457a | this.Load | FPC0623_RowExcelPopup.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5555a689 | this.Load | FPC0623_RowExcelPopup.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0623_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fddc275 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:668 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-c3bec1b9 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:669 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-7a83bcf3 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:670 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-ed89a6a1 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:671 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-bbcd19a2 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:672 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-cf7b317f | (진입점 미연결) | FPC0623_RowExcelPopup.cs:673 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-6bcea940 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:674 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5ea1da2f | (진입점 미연결) | FPC0623_RowExcelPopup.cs:676 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-312d63f2 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:677 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-215eb8e5 | (진입점 미연결) | FPC0623_RowExcelPopup.cs:681 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-84cc877a | (진입점 미연결) | FPC0623_RowExcelPopup.cs:682 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FPC0623_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6bd48e66 | this.Load | FPC0623_RowExcelPopup.cs:189 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-cf97f106 | this.Load | FPC0623_RowExcelPopup.cs:190 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-6da3f3cc | this.Load | FPC0623_RowExcelPopup.cs:194 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-0957c3e9 | this.Load | FPC0623_RowExcelPopup.cs:195 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-05ac5278 | this.Load | FPC0623_RowExcelPopup.cs:198 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-42a9bd43 | this.Load | FPC0623_RowExcelPopup.cs:199 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-497e4909 | this.Load | FPC0623_RowExcelPopup.cs:201 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FPC0623_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da628a35 | this.Load | FPC0623_RowExcelPopup.cs:271 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13228ce0 | this.Load | FPC0623_RowExcelPopup.cs:272 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0623_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1d7f9fc | (진입점 미연결) | FPC0623_RowExcelPopup.cs:292 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0623_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e6c7e3c | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:703 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-347f4577 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:703 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8978fa6a | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:705 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-43699a9f | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:706 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f72ca35c | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:707 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a293f570 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:709 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5714dc08 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:711 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-26b7b530 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | ExcelService.LoadExcelFile( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCou… | 화면 필드/플래그 변경 |  |  |  |
| AC-8d5455d3 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:712 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | CALL_EXT | ExcelService.LoadExcelFile | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, prg, … | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fe4cad2 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:720 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-313ac1f6 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:721 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-28dffdc3 | this.btnUpload.Click | FPC0623_RowExcelPopup.cs:723 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0623_RowExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-172edcb4 | this.radioMPP.CheckedChanged | FPC0623_RowExcelPopup.cs:807 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c2d45779 | this.radioMPP.CheckedChanged | FPC0623_RowExcelPopup.cs:809 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FPC0623_RowExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4c694de | this.radioWPP.CheckedChanged | FPC0623_RowExcelPopup.cs:816 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-6f38a56b | this.radioWPP.CheckedChanged | FPC0623_RowExcelPopup.cs:818 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FPC0623_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cd32377 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:428 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-f21d650d | this.btnSave.Click | FPC0623_RowExcelPopup.cs:429 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92e11038 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:433 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-6cccc95a | this.btnSave.Click | FPC0623_RowExcelPopup.cs:434 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37227fcc | this.btnSave.Click | FPC0623_RowExcelPopup.cs:438 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-163f082c | this.btnSave.Click | FPC0623_RowExcelPopup.cs:438 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b068c37c | this.btnSave.Click | FPC0623_RowExcelPopup.cs:443 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e35f695c | this.btnSave.Click | FPC0623_RowExcelPopup.cs:444 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-53af9854 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:445 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bc9bbc42 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:446 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5605cd57 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:447 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-89670077 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:448 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-889d7ba6 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:456 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a75df193 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:459 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-3320e2e1 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:461 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-4029dd88 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:464 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-910f5614 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:469 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-aa68ab5a | this.btnSave.Click | FPC0623_RowExcelPopup.cs:470 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-ed9bc06a | this.btnSave.Click | FPC0623_RowExcelPopup.cs:477 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-b001d067 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:478 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c878a769 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:479 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d412088f | this.btnSave.Click | FPC0623_RowExcelPopup.cs:480 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-97c59baa | this.btnSave.Click | FPC0623_RowExcelPopup.cs:481 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-57e539b3 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:482 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4e1293c8 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:483 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2273cf67 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:484 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d18a17e | this.btnSave.Click | FPC0623_RowExcelPopup.cs:487 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c39e9780 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d22afce | this.btnSave.Click | FPC0623_RowExcelPopup.cs:491 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27db5651 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:526 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ae2e839 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:528 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf08fc37 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:531 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-839988e0 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:533 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) … | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-a27bb9d5 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:538 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ef1d2ba | this.btnSave.Click | FPC0623_RowExcelPopup.cs:540 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d27fb29 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:543 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-81d94776 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcab2604 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:549 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-889a916e | this.btnSave.Click | FPC0623_RowExcelPopup.cs:552 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-81ae2230 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:556 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac360e48 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:569 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef066479 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:571 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5fef989 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:573 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad81b861 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:577 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-a2e759a5 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:592 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-069a433b | this.btnSave.Click | FPC0623_RowExcelPopup.cs:593 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1b4576a1 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:597 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-03c513fd | this.btnSave.Click | FPC0623_RowExcelPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-22836add | this.btnSave.Click | FPC0623_RowExcelPopup.cs:604 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-c2927d2b | this.btnSave.Click | FPC0623_RowExcelPopup.cs:626 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-332a5935 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c5f604e | this.btnSave.Click | FPC0623_RowExcelPopup.cs:628 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e00c424a | this.btnSave.Click | FPC0623_RowExcelPopup.cs:634 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-ce4db744 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:638 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-959adf53 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:644 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:"+e.Message )) | 메시지 표시 |  |  |  |
| AC-e252c0e8 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:645 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-53b47b29 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:650 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c34cf2c1 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:651 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1f52cb2e | this.btnSave.Click | FPC0623_RowExcelPopup.cs:652 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c44d1e2f | this.btnSave.Click | FPC0623_RowExcelPopup.cs:653 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-809c93f7 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:654 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e3a34c74 | this.btnSave.Click | FPC0623_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0623_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2539ac46 | this.Load | FPC0623_RowExcelPopup.cs:284 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec916f24 | this.Load | FPC0623_RowExcelPopup.cs:285 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FPC0623_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca8ac978 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:239 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-33d29a77 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:240 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b1bd5242 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:241 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e7a5d204 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:245 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-aab81bb9 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:246 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f9174b23 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FPC0623_RowExcelPopup.cs:247 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

