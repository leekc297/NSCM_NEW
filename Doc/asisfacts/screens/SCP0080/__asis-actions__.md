# AS-IS 액션 대조표 — SCP0080

> 원천: `Doc/asisfacts/screens/SCP0080/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 282행 · 메서드 50 · 종류 DATA_OP 65 · FLAG 50 · RETURN 37 · UI_PROP 35 · GRID_INIT 26 · STATE 14 · MESSAGE 8 · CALL_EXT 8 · UI_MISC 7 · GRID_SET 7 · ENDPOINT 5 · GRID_LOCK 4 · POPUP 4 · LIST_REBIND 3 · VALUE_SET 3 · VALIDATE 2 · GRID_BIND 1 · GRID_STYLE 1 · CALL_BASE 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 9


## SCP0080_GroupCodeManagement.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f95ae56b | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:932 |  | GRID_BIND | _si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ea856d9a | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:934 |  | GRID_LOCK | _si.LockColumn | (0, _si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c3c98fc | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:936 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b3f1071 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:938 |  | GRID_INIT | _si.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-225c642b | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:947 | if (bEdit_Mode) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0080_GroupCodeManagement.AfterSaveData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f6ff720 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:957 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8ed99e23 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:963 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0080_GroupCodeManagement.AlarmByStatusMass

진입점: EditButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9c3be8e | EditButton 외 1 | SCP0080_GroupCodeManagement.cs:1013 |  | UI_MISC | this._si.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9e9f106a | EditButton 외 1 | SCP0080_GroupCodeManagement.cs:1039 | try ▸ for (nRow < _si.ActiveSheet.Rows.Count) ▸ if (idx != -1) ▸ if (_si.ActiveSheet.GetText(nRow, _si.GetColumnIndex(DefColumns.STATUS_MASS… | GRID_STYLE | _si.SetBGColor2 | (nRow, idx, nRow, idx, Color.FromArgb(255, 255, 000)) | 그리드 표시 설정 |  |  |  |
| AC-a10378c3 | EditButton 외 1 | SCP0080_GroupCodeManagement.cs:1046 | finally | UI_MISC | this._si.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0080_GroupCodeManagement.ChangeColumnTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a926408 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:1786 |  | GRID_SET | _sheet.Columns[colName].Label | title | 그리드 속성/값 설정 |  |  |  |

## SCP0080_GroupCodeManagement.CheckChangedValues

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a5c7e28 | SaveButton | SCP0080_GroupCodeManagement.cs:1164 |  | FLAG | p_changed_division_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-5966b815 | SaveButton | SCP0080_GroupCodeManagement.cs:1165 |  | FLAG | p_changed_model_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-2dad2b12 | SaveButton | SCP0080_GroupCodeManagement.cs:1166 |  | FLAG | p_changed_group_code1 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-92dc84f8 | SaveButton | SCP0080_GroupCodeManagement.cs:1167 |  | FLAG | p_changed_group_code2 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b9b64593 | SaveButton | SCP0080_GroupCodeManagement.cs:1168 |  | FLAG | p_changed_group_code3 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-017b153f | SaveButton | SCP0080_GroupCodeManagement.cs:1169 |  | FLAG | p_changed_group_code4 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-e0e2ad48 | SaveButton | SCP0080_GroupCodeManagement.cs:1170 |  | FLAG | p_changed_group_code5 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-10c2b72d | SaveButton | SCP0080_GroupCodeManagement.cs:1171 |  | FLAG | p_changed_group_code6 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-37cd950a | SaveButton | SCP0080_GroupCodeManagement.cs:1172 |  | FLAG | p_changed_group_code7 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fdd2b6c4 | SaveButton | SCP0080_GroupCodeManagement.cs:1173 |  | FLAG | p_changed_group_code8 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-70b0d523 | SaveButton | SCP0080_GroupCodeManagement.cs:1174 |  | FLAG | p_changed_group_code9 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-30b9f11b | SaveButton | SCP0080_GroupCodeManagement.cs:1175 |  | FLAG | p_changed_group_code10 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-6a713d05 | SaveButton | SCP0080_GroupCodeManagement.cs:1176 |  | FLAG | p_changed_attribute1 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1bceb31a | SaveButton | SCP0080_GroupCodeManagement.cs:1177 |  | FLAG | p_changed_attribute2 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a5c66bec | SaveButton | SCP0080_GroupCodeManagement.cs:1178 |  | FLAG | p_changed_attribute3 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-8fc402a5 | SaveButton | SCP0080_GroupCodeManagement.cs:1179 |  | FLAG | p_changed_attribute4 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-1f0862da | SaveButton | SCP0080_GroupCodeManagement.cs:1180 |  | FLAG | p_changed_attribute5 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-687de108 | SaveButton | SCP0080_GroupCodeManagement.cs:1181 |  | FLAG | p_changed_attribute6 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-29dcd28e | SaveButton | SCP0080_GroupCodeManagement.cs:1182 |  | FLAG | p_changed_attribute7 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b8ab257a | SaveButton | SCP0080_GroupCodeManagement.cs:1183 |  | FLAG | p_changed_attribute8 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-34e38af4 | SaveButton | SCP0080_GroupCodeManagement.cs:1184 |  | FLAG | p_changed_attribute9 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-24dded3c | SaveButton | SCP0080_GroupCodeManagement.cs:1185 |  | FLAG | p_changed_attribute10 | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-886e7d79 | SaveButton | SCP0080_GroupCodeManagement.cs:1186 |  | FLAG | p_changed_pic_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9427a7c9 | SaveButton | SCP0080_GroupCodeManagement.cs:1187 |  | FLAG | p_changed_user_id | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-01cfc031 | SaveButton | SCP0080_GroupCodeManagement.cs:1188 |  | FLAG | p_changed_sales_model | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-511f355e | SaveButton | SCP0080_GroupCodeManagement.cs:1189 |  | FLAG | p_changed_sales_valid_yn | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-bc311322 | SaveButton | SCP0080_GroupCodeManagement.cs:1190 |  | FLAG | p_changed_sales_priority | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c2604734 | SaveButton | SCP0080_GroupCodeManagement.cs:1191 |  | FLAG | p_changed_sales_from_yyyymmdd | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-782ec2f6 | SaveButton | SCP0080_GroupCodeManagement.cs:1192 |  | FLAG | p_changed_sales_to_yyyymmdd | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ecf4d2b1 | SaveButton | SCP0080_GroupCodeManagement.cs:1193 |  | FLAG | p_changed_level1_group | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3e5297f9 | SaveButton | SCP0080_GroupCodeManagement.cs:1194 |  | FLAG | p_changed_level2_code | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-54c3f7d7 | SaveButton | SCP0080_GroupCodeManagement.cs:1195 |  | FLAG | p_changed_status_prototype | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-931b9cb7 | SaveButton | SCP0080_GroupCodeManagement.cs:1196 |  | FLAG | p_changed_status_mass | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-3fe73143 | SaveButton | SCP0080_GroupCodeManagement.cs:1197 |  | FLAG | p_changed_status_new | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-ed91eb83 | SaveButton | SCP0080_GroupCodeManagement.cs:1198 |  | FLAG | p_changed_replacement | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-534a6ca8 | SaveButton | SCP0080_GroupCodeManagement.cs:1199 |  | FLAG | p_changed_basic_end_customer | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-fb535b58 | SaveButton | SCP0080_GroupCodeManagement.cs:1200 |  | FLAG | p_changed_basic_finished_product | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-434bbbd9 | SaveButton | SCP0080_GroupCodeManagement.cs:1201 |  | FLAG | p_changed_mkt_dept | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-04956a5a | SaveButton | SCP0080_GroupCodeManagement.cs:1202 |  | FLAG | p_changed_remark | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a3ee82f4 | SaveButton | SCP0080_GroupCodeManagement.cs:1310 | try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81") ▸ try ▸ if (Convert.ToDateTime(sales_from_y… | MESSAGE | MessageHelper.GMessageBox | ("MSG00048") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dff1d4fc | SaveButton | SCP0080_GroupCodeManagement.cs:1311 | try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81") ▸ try ▸ if (Convert.ToDateTime(sales_from_y… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0b7f5193 | SaveButton | SCP0080_GroupCodeManagement.cs:1320 | try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81") ▸ if (!CheckValidSalesModel(division, opera… | DATA_OP | invalidSalesModels.Add | (rowIdx) | 데이터 객체 조작/조회 |  |  |  |
| AC-11e6c8ef | SaveButton | SCP0080_GroupCodeManagement.cs:1325 | try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81") ▸ if (!CheckValidSalesModelPriority(divisio… | DATA_OP | invalidSalesModelPrioritys.Add | (rowIdx) | 데이터 객체 조작/조회 |  |  |  |
| AC-9df07c17 | SaveButton | SCP0080_GroupCodeManagement.cs:1330 | try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81") ▸ if (!CheckValidBasicEndCustomer(division,… | DATA_OP | invalidBasicEndCustomer.Add | (rowIdx) | 데이터 객체 조작/조회 |  |  |  |
| AC-1babb4bf | SaveButton | SCP0080_GroupCodeManagement.cs:1411 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidSalesModels.Count > 0) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-455ee9fe | SaveButton | SCP0080_GroupCodeManagement.cs:1413 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidSalesModels.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-62c17b7a | SaveButton | SCP0080_GroupCodeManagement.cs:1434 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidSalesModelPrioritys.Count > 0) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-ddd2e225 | SaveButton | SCP0080_GroupCodeManagement.cs:1436 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidSalesModelPrioritys.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fb8ca6dc | SaveButton | SCP0080_GroupCodeManagement.cs:1456 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidBasicEndCustomer.Count > 0) | MESSAGE | MessageBox.Show | (msg) | 메시지 표시 |  |  |  |
| AC-b0ea9b5c | SaveButton | SCP0080_GroupCodeManagement.cs:1458 | try ▸ if (this._division.Substring(0, 2) == "81") ▸ if (invalidBasicEndCustomer.Count > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-54464f7e | SaveButton | SCP0080_GroupCodeManagement.cs:1467 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.CheckUser

진입점: spd81.Change / spd82.Change / spd40.Change / spdEtc.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f464eda7 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1750 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", BLUtils.GSCM_DM_MASTER_SVC)) { var … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f54017ff | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1754 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP") ⇒ SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-471e68e4 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1756 | lambda | DATA_OP | request.Parameters["Search"] | _si.GetValue(iRow, _si.GetColumnIndex(DefColumns.PIC_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbcf787e | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1757 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-fea668aa | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1759 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-338a8718 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1761 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e83b7e8a | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1768 | lambda | DATA_OP | x.Field | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9735394c | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1773 | if (defaultSelectedRow == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4aed9ec1 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1775 | if (defaultSelectedRow == null) | GRID_SET | _si.ActiveSheet.Cells.Get(iRow, _si.GetColumnIndex(DefColumns.PIC_ID)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-4b23ef1a | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1775 | if (defaultSelectedRow == null) | CALL_EXT | _si.ActiveSheet.Cells.Get | (iRow, _si.GetColumnIndex(DefColumns.PIC_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-03f2db4c | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1776 | if (defaultSelectedRow == null) | GRID_SET | _si.ActiveSheet.Cells.Get(iRow, _si.GetColumnIndex(DefColumns.PIC_NAME)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-76c87dd0 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1776 | if (defaultSelectedRow == null) | CALL_EXT | _si.ActiveSheet.Cells.Get | (iRow, _si.GetColumnIndex(DefColumns.PIC_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c61ec69 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1778 | if (defaultSelectedRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2085711c | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1781 |  | GRID_SET | _si.ActiveSheet.Cells.Get(iRow, _si.GetColumnIndex(DefColumns.PIC_NAME)).Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e0e31662 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1781 |  | CALL_EXT | _si.ActiveSheet.Cells.Get | (iRow, _si.GetColumnIndex(DefColumns.PIC_NAME)) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0080_GroupCodeManagement.CheckValidBasicEndCustomer

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c640933 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:762 | if (this._division.Substring(0, 2) != "81") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e7e24996 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:765 | if (BasicEndCustomer.Length <= 50) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-992741d3 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:773 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.CheckValidSalesModel

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adf94a8e | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:722 | if (this._division.Substring(0, 2) != "81") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ca5c513a | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:725 | if (string.IsNullOrEmpty(salesModel)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d598daab | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:731 | lambda | DATA_OP | f.Contains | (salesModel) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5e983ed | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:735 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.CheckValidSalesModelPriority

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99014593 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:741 | if (this._division.Substring(0, 2) != "81") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-c46b66e7 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:744 | if (string.IsNullOrEmpty(salesPriority) \|\| !string.IsNullOrEmpty(salesPriority)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-59a3574c | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:756 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84c5687 | this.Load | SCP0080_GroupCodeManagement.cs:507 |  | GRID_INIT | this.AddSheet | (spd81, this.SHEET_NAME_81, this.SHEET_NAME_81, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-97cdc9ab | this.Load | SCP0080_GroupCodeManagement.cs:508 |  | GRID_INIT | this.AddSheet | (spd81_UC, this.SHEET_NAME_81_UC, this.SHEET_NAME_81_UC, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7df0b047 | this.Load | SCP0080_GroupCodeManagement.cs:509 |  | GRID_INIT | this.AddSheet | (spd81_HM, this.SHEET_NAME_81_HM, this.SHEET_NAME_81_HM, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9bab41ef | this.Load | SCP0080_GroupCodeManagement.cs:510 |  | GRID_INIT | this.AddSheet | (spd81_ST, this.SHEET_NAME_81_ST, this.SHEET_NAME_81_ST, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bd19e229 | this.Load | SCP0080_GroupCodeManagement.cs:511 |  | GRID_INIT | this.AddSheet | (spd40, this.SHEET_NAME_40, this.SHEET_NAME_40, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ded8f584 | this.Load | SCP0080_GroupCodeManagement.cs:512 |  | GRID_INIT | this.AddSheet | (spd82, this.SHEET_NAME_82, this.SHEET_NAME_82, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a35a68e | this.Load | SCP0080_GroupCodeManagement.cs:513 |  | GRID_INIT | this.AddSheet | (spdEtc, this.SHEET_NAME_ETC, this.SHEET_NAME_ETC, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-29490164 | this.Load | SCP0080_GroupCodeManagement.cs:515 |  | FLAG | si81 | GetSheetInfo(spd81.Name, spd81.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1107362d | this.Load | SCP0080_GroupCodeManagement.cs:516 |  | FLAG | si81_UC | GetSheetInfo(spd81_UC.Name, spd81_UC.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-86039b81 | this.Load | SCP0080_GroupCodeManagement.cs:517 |  | FLAG | si81_HM | GetSheetInfo(spd81_HM.Name, spd81_HM.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f8dcbb1a | this.Load | SCP0080_GroupCodeManagement.cs:518 |  | FLAG | si81_ST | GetSheetInfo(spd81_ST.Name, spd81_ST.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-01755806 | this.Load | SCP0080_GroupCodeManagement.cs:519 |  | FLAG | si40 | GetSheetInfo(spd40.Name, spd40.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-422f5e9f | this.Load | SCP0080_GroupCodeManagement.cs:520 |  | FLAG | si82 | GetSheetInfo(spd82.Name, spd82.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-472ba9a5 | this.Load | SCP0080_GroupCodeManagement.cs:521 |  | FLAG | siEtc | GetSheetInfo(spdEtc.Name, spdEtc.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-df658d00 | this.Load | SCP0080_GroupCodeManagement.cs:523 |  | GRID_INIT | si81.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55827836 | this.Load | SCP0080_GroupCodeManagement.cs:524 |  | GRID_INIT | si81_UC.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f85f4361 | this.Load | SCP0080_GroupCodeManagement.cs:525 |  | GRID_INIT | si81_HM.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93c6f837 | this.Load | SCP0080_GroupCodeManagement.cs:526 |  | GRID_INIT | si81_ST.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de64aa46 | this.Load | SCP0080_GroupCodeManagement.cs:527 |  | GRID_INIT | si82.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52ccca0d | this.Load | SCP0080_GroupCodeManagement.cs:528 |  | GRID_INIT | si40.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30e0702a | this.Load | SCP0080_GroupCodeManagement.cs:529 |  | GRID_INIT | siEtc.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0080_GroupCodeManagement.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7ac05af | Dispose | SCP0080_GroupCodeManagement.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0080_GroupCodeManagement.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a184ab98 | EditButton | SCP0080_GroupCodeManagement.cs:869 |  | GRID_LOCK | _si.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-0584dcc5 | EditButton | SCP0080_GroupCodeManagement.cs:896 |  | FLAG | bEdit_Mode | !bEdit_Mode | 화면 필드/플래그 변경 |  |  |  |

## SCP0080_GroupCodeManagement.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72ca9e80 | ExcelButton | SCP0080_GroupCodeManagement.cs:913 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0080_GroupCodeManagement.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcdc41cd | FindButton | SCP0080_GroupCodeManagement.cs:1008 |  | ENDPOINT | this.ExecuteSQL | (_si, DIC_GROUP_CODE, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0080_GroupCodeManagement.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84c38847 | this.Load | SCP0080_GroupCodeManagement.cs:460 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0080_GroupCodeManagement.getActiveChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-895d079e | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:150 |  | RETURN | return chkActive.Checked == true ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getBOMChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e324ee5f | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:164 |  | RETURN | return chkBOM.Checked == true ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.GetColumnValue

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-840a9ce4 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:845 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cb8e4e3 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:61 |  | RETURN | return CString.GetCheckedListValue(dtMyDivision, cboDivision.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getFCSTChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb719ecd | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:120 |  | RETURN | return chkFCST.Checked == true ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getModel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0244b2af | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:90 |  | RETURN | return txtModel.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getNickname

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3abb67c | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:105 |  | RETURN | return txtNickname.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d58d377 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:75 |  | RETURN | return CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.getProductionChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-763ea951 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:135 |  | RETURN | return chkProduction.Checked == true ? "Y" : "N"; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.GetProductionModels

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3962afba | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:674 | for (r <= this._sheet.Rows.Count - 1) ▸ if (this._sheet.Cells[r, colIdxDIVISION_ID].Value != null && this._sheet.Cells[r, colIdxOPERATION_ID… | DATA_OP | lst.Add | (this._sheet.Cells[r, colIdxITEM_ID].Value.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-142793df | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:682 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.GetSalesModelPrioritys

진입점: SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - 1) ▸ if (this._division.Substring(0, 2) == "81")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb1acb1 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:708 | for (r <= this._sheet.Rows.Count - 1) ▸ if (this._sheet.Cells[r, colIdxDIVISION_ID].Value != null && this._sheet.Cells[r, colIdxOPERATION_ID… | DATA_OP | res.Add | (this._sheet.Cells[r, colIdxSALES_PRIORITY].Value.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-46714f77 | SaveButton [try ▸ for (rowIdx <= _si.ActiveSheet.RowCount - … | SCP0080_GroupCodeManagement.cs:714 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd40347 | this.Load | SCP0080_GroupCodeManagement.cs:480 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-125c5a29 | this.Load | SCP0080_GroupCodeManagement.cs:483 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-24d6974a | this.Load | SCP0080_GroupCodeManagement.cs:486 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-da166a3c | this.Load | SCP0080_GroupCodeManagement.cs:487 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-35572360 | this.Load | SCP0080_GroupCodeManagement.cs:490 |  | VALUE_SET | chkFCST.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4f9644d2 | this.Load | SCP0080_GroupCodeManagement.cs:491 |  | VALUE_SET | chkProduction.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ac8c0708 | this.Load | SCP0080_GroupCodeManagement.cs:492 |  | VALUE_SET | chkActive.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0080_GroupCodeManagement.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-889bf326 | this.Load | SCP0080_GroupCodeManagement.cs:454 |  | DATA_OP | QueryDics.Add | (DIC_GROUP_CODE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |
| AC-282531a1 | this.Load | SCP0080_GroupCodeManagement.cs:455 |  | DATA_OP | QueryDics.Add | (DIC_GROUP_CODE_SAVE, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpread

진입점: cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98c4d805 | cboDivision.SelectedIndexChanged 외 1 | SCP0080_GroupCodeManagement.cs:542 |  | GRID_INIT | _si.InitSheet | (_si.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7fdddd0e | cboDivision.SelectedIndexChanged 외 1 | SCP0080_GroupCodeManagement.cs:543 |  | GRID_INIT | _si.SetSheetHeaderColumn | (_si, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpread40

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2783e597 | this.Load | SCP0080_GroupCodeManagement.cs:554 |  | GRID_INIT | si40.InitSheet | (si40.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-63b7f988 | this.Load | SCP0080_GroupCodeManagement.cs:555 |  | GRID_INIT | si40.SetSheetHeaderColumn | (si40, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpread81

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99a0ff42 | this.Load | SCP0080_GroupCodeManagement.cs:604 |  | GRID_INIT | si.InitSheet | (si.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c43ec315 | this.Load | SCP0080_GroupCodeManagement.cs:605 |  | GRID_INIT | si.SetSheetHeaderColumn | (si, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpread82

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d57325f6 | this.Load | SCP0080_GroupCodeManagement.cs:613 |  | GRID_INIT | si82.InitSheet | (si82.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a21d21be | this.Load | SCP0080_GroupCodeManagement.cs:614 |  | GRID_INIT | si82.SetSheetHeaderColumn | (si82, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpreadEtc

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3701b8c | this.Load | SCP0080_GroupCodeManagement.cs:548 |  | GRID_INIT | siEtc.InitSheet | (siEtc.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-afb454c7 | this.Load | SCP0080_GroupCodeManagement.cs:549 |  | GRID_INIT | siEtc.SetSheetHeaderColumn | (siEtc, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0080_GroupCodeManagement.InitSpreadMain

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1784e67 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:925 |  | GRID_INIT | _si.ChangeSheet | (this._sheetName) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0080_GroupCodeManagement.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-679d4e0e | InsertButton | SCP0080_GroupCodeManagement.cs:813 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.IsESSEdit

진입점: spd81.KeyPress / spd82.KeyPress / spd40.KeyPress / spdEtc.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e559dec | spd81.KeyPress 외 3 | SCP0080_GroupCodeManagement.cs:1512 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e62f2d9 | SaveButton | SCP0080_GroupCodeManagement.cs:906 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33e1867b | SaveButton | SCP0080_GroupCodeManagement.cs:1113 |  | ENDPOINT | this.ExecuteSQL | ( new List<SpreadInfo>() { _si, _si } , new List<string>() { DIC_GROUP_CODE_SAVE, DIC_GROU… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0080_GroupCodeManagement.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47faea6e | SaveButton | SCP0080_GroupCodeManagement.cs:1473 | if (_si.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6cb67007 | SaveButton | SCP0080_GroupCodeManagement.cs:1475 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (_si) | 프레임워크 검증 |  |  |  |
| AC-6d898354 | SaveButton | SCP0080_GroupCodeManagement.cs:1475 | if (!DataUtil.checkRequiredOfSpread(_si)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe57b54f | SaveButton | SCP0080_GroupCodeManagement.cs:1480 | if (!CheckChangedValues(ref changedCnt)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6952fc87 | SaveButton | SCP0080_GroupCodeManagement.cs:1484 | if (changedCnt == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1bb609a | SaveButton | SCP0080_GroupCodeManagement.cs:1486 | if (changedCnt == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1a4f1b6 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:500 |  | FLAG | dtOperation | DBUtils.Filter(dtOperationAll, filter, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b23ac56f | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:500 |  | DATA_OP | DBUtils.Filter | (dtOperationAll, filter, true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ab7101e7 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:502 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0080_GroupCodeManagement.SetColumnCondition81

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb03d2e | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:596 |  | CALL_EXT | SheetUtils.GetFormulaConditaion | (si81, "STATUS_MASS", "=", "\"Y\"") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec838223 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:597 |  | CALL_EXT | SheetUtils.GetFormulaConditaion | (si81, "GROUP_CODE1", "=", "\"\"") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4be8e09 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:600 |  | CALL_EXT | SheetUtils.SetColumnStyleByCondition | (si81, "GROUP_CODE1", condition, Color.Black, Color.Yellow) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0080_GroupCodeManagement.SetLockColumns

진입점: EditButton [if (!bEdit_Mode) ▸ switch (this._division.Substring(0, 2)) case "81":]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8de447ff | EditButton [if (!bEdit_Mode) ▸ switch (this._division.Substr… | SCP0080_GroupCodeManagement.cs:851 |  | UI_MISC | this._si.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c014325d | EditButton [if (!bEdit_Mode) ▸ switch (this._division.Substr… | SCP0080_GroupCodeManagement.cs:857 | try ▸ foreach (int idx in _notEditableColumnIdxes) | GRID_LOCK | _si.LockColumn2 | (idx, idx, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dbc788e1 | EditButton [if (!bEdit_Mode) ▸ switch (this._division.Substr… | SCP0080_GroupCodeManagement.cs:863 | finally | UI_MISC | this._si.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0080_GroupCodeManagement.SetNotEitableColumns

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-332a23be | this.Load | SCP0080_GroupCodeManagement.cs:566 | if (_notEditableColumnIdxes.Count > 0) | STATE_RESET | _notEditableColumnIdxes.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bd8396e4 | this.Load | SCP0080_GroupCodeManagement.cs:575 | foreach (string c in _notEditableColumns) | DATA_OP | _notEditableColumnIdxes.Add | (idx) | 데이터 객체 조작/조회 |  |  |  |

## SCP0080_GroupCodeManagement.SetQueryInfoGet

진입점: FindButton / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16c44881 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:980 | if (this.QueryDics[DIC_GROUP_CODE].Count > 0) | CALL_EXT | this.QueryDics[DIC_GROUP_CODE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c523c0f7 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:985 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadMain | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-8950d346 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:986 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-0690c3ee | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:987 |  | UI_PROP | qi.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-5db16a1c | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:988 |  | UI_PROP | qi.QueryId | "SCP.SCP0080_GET_GROUP_CODE_MANAGEMENT" | 속성 QueryId 설정 |  |  |  |
| AC-cc41038e | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:990 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d942798 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:991 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e29cc3f | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:992 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_model_id", this._model)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c8f3666 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:993 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nickname", this._nickname)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f871dfc | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:994 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_check_fcst", this._fcstChecked)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07b93909 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:995 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_check_production", this._productionChecked)) | 데이터 객체 조작/조회 |  |  |  |
| AC-042810df | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:996 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_check_active", this._activeChecked)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f2ecfc4 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:997 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_check_bom", this._bomChecked)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c7633f1 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:998 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfo.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d58e4d1 | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:999 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d95e3fed | FindButton 외 1 | SCP0080_GroupCodeManagement.cs:1001 |  | DATA_OP | this.QueryDics[DIC_GROUP_CODE] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0080_GroupCodeManagement.SetQueryInfoSave

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a49ff77b | SaveButton | SCP0080_GroupCodeManagement.cs:1055 | if (this.QueryDics[DIC_GROUP_CODE_SAVE].Count > 0) | CALL_EXT | this.QueryDics[DIC_GROUP_CODE_SAVE].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b1baa68 | SaveButton | SCP0080_GroupCodeManagement.cs:1060 |  | UI_PROP | qi.BeforeExecuteSQLProc | null | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-f684319f | SaveButton | SCP0080_GroupCodeManagement.cs:1061 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterSaveData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-b62a4230 | SaveButton | SCP0080_GroupCodeManagement.cs:1062 |  | UI_PROP | qi.ServiceUri | BLUtils.GSCM_SCM_MASTER_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-e3062703 | SaveButton | SCP0080_GroupCodeManagement.cs:1063 |  | UI_PROP | qi.QueryId | "SCP.SCP0080_SAVE_GROUP_CODE_MANAGEMENT" | 속성 QueryId 설정 |  |  |  |
| AC-de0521fc | SaveButton | SCP0080_GroupCodeManagement.cs:1065 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this.p_changed_division_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2360c81a | SaveButton | SCP0080_GroupCodeManagement.cs:1066 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_model_id", this.p_changed_model_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60c6f777 | SaveButton | SCP0080_GroupCodeManagement.cs:1067 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_pic_id", this.p_changed_pic_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e3d2b5b | SaveButton | SCP0080_GroupCodeManagement.cs:1068 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sales_model", this.p_changed_sales_model)) | 데이터 객체 조작/조회 |  |  |  |
| AC-66d3db23 | SaveButton | SCP0080_GroupCodeManagement.cs:1069 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sales_valid_yn", this.p_changed_sales_valid_yn)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e134810 | SaveButton | SCP0080_GroupCodeManagement.cs:1070 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sales_priority", this.p_changed_sales_priority)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c0f8a59 | SaveButton | SCP0080_GroupCodeManagement.cs:1071 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sales_from_yyyymmdd", this.p_changed_sales_from_yyyym… | 데이터 객체 조작/조회 |  |  |  |
| AC-a923affb | SaveButton | SCP0080_GroupCodeManagement.cs:1072 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sales_to_yyyymmdd", this.p_changed_sales_to_yyyymmdd)… | 데이터 객체 조작/조회 |  |  |  |
| AC-de105311 | SaveButton | SCP0080_GroupCodeManagement.cs:1073 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", this.p_changed_user_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d65caf42 | SaveButton | SCP0080_GroupCodeManagement.cs:1074 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_level1_group", this.p_changed_level1_group)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5be96f1 | SaveButton | SCP0080_GroupCodeManagement.cs:1075 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_level2_code", this.p_changed_level2_code)) | 데이터 객체 조작/조회 |  |  |  |
| AC-03dedd14 | SaveButton | SCP0080_GroupCodeManagement.cs:1076 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_status_prototype", this.p_changed_status_prototype)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2bc28178 | SaveButton | SCP0080_GroupCodeManagement.cs:1077 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_status_mass", this.p_changed_status_mass)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19daff49 | SaveButton | SCP0080_GroupCodeManagement.cs:1078 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_status_new", this.p_changed_status_new)) | 데이터 객체 조작/조회 |  |  |  |
| AC-439aa736 | SaveButton | SCP0080_GroupCodeManagement.cs:1079 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_replacement", this.p_changed_replacement)) | 데이터 객체 조작/조회 |  |  |  |
| AC-770c1699 | SaveButton | SCP0080_GroupCodeManagement.cs:1080 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_basic_end_customer", this.p_changed_basic_end_custome… | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d521c7 | SaveButton | SCP0080_GroupCodeManagement.cs:1081 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_basic_finished_product", this.p_changed_basic_finishe… | 데이터 객체 조작/조회 |  |  |  |
| AC-9e1d4834 | SaveButton | SCP0080_GroupCodeManagement.cs:1082 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_mkt_dept", this.p_changed_mkt_dept)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e684d179 | SaveButton | SCP0080_GroupCodeManagement.cs:1083 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_remark", this.p_changed_remark)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a447953 | SaveButton | SCP0080_GroupCodeManagement.cs:1084 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code1", this.p_changed_group_code1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bce0f33 | SaveButton | SCP0080_GroupCodeManagement.cs:1085 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code2", this.p_changed_group_code2)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fb43c9d | SaveButton | SCP0080_GroupCodeManagement.cs:1086 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code3", this.p_changed_group_code3)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38130136 | SaveButton | SCP0080_GroupCodeManagement.cs:1087 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code4", this.p_changed_group_code4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-180b5cbf | SaveButton | SCP0080_GroupCodeManagement.cs:1088 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code5", this.p_changed_group_code5)) | 데이터 객체 조작/조회 |  |  |  |
| AC-56e6e87f | SaveButton | SCP0080_GroupCodeManagement.cs:1089 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code6", this.p_changed_group_code6)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfc14c7e | SaveButton | SCP0080_GroupCodeManagement.cs:1090 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code7", this.p_changed_group_code7)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec142e51 | SaveButton | SCP0080_GroupCodeManagement.cs:1091 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code8", this.p_changed_group_code8)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a62ac55c | SaveButton | SCP0080_GroupCodeManagement.cs:1092 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code9", this.p_changed_group_code9)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d693309 | SaveButton | SCP0080_GroupCodeManagement.cs:1093 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_code10", this.p_changed_group_code10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9632885 | SaveButton | SCP0080_GroupCodeManagement.cs:1094 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute1", this.p_changed_attribute1)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e792dce1 | SaveButton | SCP0080_GroupCodeManagement.cs:1095 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute2", this.p_changed_attribute2)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb4ab60 | SaveButton | SCP0080_GroupCodeManagement.cs:1096 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute3", this.p_changed_attribute3)) | 데이터 객체 조작/조회 |  |  |  |
| AC-76e31a37 | SaveButton | SCP0080_GroupCodeManagement.cs:1097 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute4", this.p_changed_attribute4)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2eb0f53 | SaveButton | SCP0080_GroupCodeManagement.cs:1098 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute5", this.p_changed_attribute5)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6d16476 | SaveButton | SCP0080_GroupCodeManagement.cs:1099 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute6", this.p_changed_attribute6)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e083f940 | SaveButton | SCP0080_GroupCodeManagement.cs:1100 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute7", this.p_changed_attribute7)) | 데이터 객체 조작/조회 |  |  |  |
| AC-90438f87 | SaveButton | SCP0080_GroupCodeManagement.cs:1101 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute8", this.p_changed_attribute8)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4fc428f | SaveButton | SCP0080_GroupCodeManagement.cs:1102 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute9", this.p_changed_attribute9)) | 데이터 객체 조작/조회 |  |  |  |
| AC-63aa37e8 | SaveButton | SCP0080_GroupCodeManagement.cs:1103 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_attribute10", this.p_changed_attribute10)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ec7ef5c | SaveButton | SCP0080_GroupCodeManagement.cs:1105 |  | DATA_OP | this.QueryDics[DIC_GROUP_CODE_SAVE] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |

## SCP0080_GroupCodeManagement.SetSheetLock

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa50b746 | (진입점 미연결) | SCP0080_GroupCodeManagement.cs:821 | try | GRID_LOCK | _si.LockRange | (iRow1, iCol1, iRow2, iCol2, pLock) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0080_GroupCodeManagement.SetVisibleSheet

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfd37233 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1521 |  | STATE | this.spd81.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fff00128 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1522 |  | UI_PROP | this.spd81.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-75bdc430 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1524 |  | STATE | this.spd81_UC.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-792fe293 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1525 |  | UI_PROP | this.spd81_UC.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-07d2c3b4 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1527 |  | STATE | this.spd81_HM.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fa5879c8 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1528 |  | UI_PROP | this.spd81_HM.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-639cf0f8 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1530 |  | STATE | this.spd81_ST.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a5ca8104 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1531 |  | UI_PROP | this.spd81_ST.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-e1dfd264 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1533 |  | STATE | this.spd82.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-01e22b1c | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1534 |  | UI_PROP | this.spd82.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-0703e349 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1536 |  | STATE | this.spd40.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-05c3d22f | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1537 |  | UI_PROP | this.spd40.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-60fac66d | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1539 |  | STATE | this.spdEtc.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-accd5a8c | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1540 |  | UI_PROP | this.spdEtc.Dock | DockStyle.None | 속성 Dock 설정 |  |  |  |
| AC-2aed8064 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1546 | switch (this._division) case "81": | UI_PROP | this.spd81.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-3782fd18 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1547 | switch (this._division) case "81": | STATE | this.spd81.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-8fbe49ec | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1552 | switch (this._division) case "81_UC": | UI_PROP | this.spd81_UC.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-170ea58f | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1553 | switch (this._division) case "81_UC": | STATE | this.spd81_UC.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-46b8a115 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1558 | switch (this._division) case "81_HM": | UI_PROP | this.spd81_HM.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-9c2e3c9c | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1559 | switch (this._division) case "81_HM": | STATE | this.spd81_HM.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0752a63a | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1564 | switch (this._division) case "81_ST": | UI_PROP | this.spd81_ST.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-be54fd2b | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1565 | switch (this._division) case "81_ST": | STATE | this.spd81_ST.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-4fa9455e | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1570 | switch (this._division) case "82": | UI_PROP | this.spd82.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-290f8c4c | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1571 | switch (this._division) case "82": | STATE | this.spd82.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-58f39dff | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1576 | switch (this._division) case "40": | UI_PROP | this.spd40.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-8ebc9542 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1577 | switch (this._division) case "40": | STATE | this.spd40.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-7791ce44 | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1582 | switch (this._division) default: | UI_PROP | this.spdEtc.Dock | DockStyle.Fill | 속성 Dock 설정 |  |  |  |
| AC-8f2c582c | this.Load 외 1 | SCP0080_GroupCodeManagement.cs:1583 | switch (this._division) default: | STATE | this.spdEtc.Visible | true | 컨트롤 상태 Visible |  |  |  |

## SCP0080_GroupCodeManagement.spdMain_CellDoubleClick

진입점: spd81.CellDoubleClick / spd82.CellDoubleClick / spd40.CellDoubleClick / spdEtc.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb6e85a5 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1646 | if (!this.IsEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98c7d748 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1654 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (currDivisionId != "82") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ee65600 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1657 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | POPUP | new CommonDataSCPPopup | (true, false) | 팝업/폼 생성 |  |  |  |
| AC-e7bd9e8f | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1658 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.DataType | Data_SCP.Type.RTFGubun | 속성 DataType 설정 |  |  |  |
| AC-5d06fb9d | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1659 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.DivisionID | currDivisionId | 속성 DivisionID 설정 |  |  |  |
| AC-ae76b64a | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1660 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.Width | 480 | 속성 Width 설정 |  |  |  |
| AC-ffce5f70 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1661 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-719d02b0 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1662 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7f47f970 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1663 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.AllowMultiRange | false | 속성 AllowMultiRange 설정 |  |  |  |
| AC-e1f599af | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1664 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | UI_PROP | popup.IsPopupEditCheck | false | 속성 IsPopupEditCheck 설정 |  |  |  |
| AC-1ef48a95 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1666 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e20fdeab | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1674 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var item in popup.sel… | DATA_OP | defaultData.Add | (DefColumns.GROUP_CODE5, item.Name) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fef1e7d | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1677 | if (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ foreach (var item in popup.sel… | GRID_SET | _si.SetValue | (_si.ActiveSheet.ActiveCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-b58585cc | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1684 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-502d6db7 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1685 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-d84aef24 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1686 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-16e2adae | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1687 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7ad20ba | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1688 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-ab2490d3 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1690 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b021a4e9 | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1696 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) ▸ if (popup.… | GRID_SET | _si.SetValue | (e.Row, _si.GetColumnIndex(DefColumns.PIC_ID), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-3b51756d | spd81.CellDoubleClick 외 3 | SCP0080_GroupCodeManagement.cs:1697 | else of (_si.GetColumnTag(e.Column).Equals(DefColumns.GROUP_CODE5)) ▸ if (_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) ▸ if (popup.… | GRID_SET | _si.SetValue | (e.Row, _si.GetColumnIndex(DefColumns.PIC_NAME), item.UserName) | 그리드 값 설정 |  |  |  |

## SCP0080_GroupCodeManagement.SpdMain_Change

진입점: spd81.Change / spd82.Change / spd40.Change / spdEtc.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77240759 | spd81.Change 외 3 | SCP0080_GroupCodeManagement.cs:1740 | if (!_si.GetColumnTag(e.Column).Equals(DefColumns.PIC_ID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0080_GroupCodeManagement.spdMain_KeyPress

진입점: spd81.KeyPress / spd82.KeyPress / spd40.KeyPress / spdEtc.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8244dfd | spd81.KeyPress 외 3 | SCP0080_GroupCodeManagement.cs:1729 | if (this.IsESSEdit()) | UI_PROP | e.Handled | (e.KeyChar != (char)Keys.Escape) | 속성 Handled 설정 |  |  |  |
| AC-0bdc6941 | spd81.KeyPress 외 3 | SCP0080_GroupCodeManagement.cs:1733 | else of (this.IsESSEdit()) | UI_PROP | e.Handled | false | 속성 Handled 설정 |  |  |  |

