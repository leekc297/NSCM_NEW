# AS-IS 액션 대조표 — SCP0087

> 원천: `Doc/asisfacts/screens/SCP0087/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 86행 · 메서드 12 · 종류 DATA_OP 30 · UI_MISC 11 · GRID_INIT 6 · RETURN 6 · ENDPOINT 6 · FLAG 5 · MESSAGE 5 · GRID_LOCK 4 · CALL_EXT 4 · POPUP 4 · UI_PROP 2 · VALUE_SET 1 · GRID_BIND 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 4


## SCP0087_MDMClassMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f400ef6 | this.Load | SCP0087_MDMClassMaster.cs:118 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-71c3dc44 | this.Load | SCP0087_MDMClassMaster.cs:119 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c706fbe | this.Load | SCP0087_MDMClassMaster.cs:121 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0087_MDMClassMaster.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c43f5472 | this.Load | SCP0087_MDMClassMaster.cs:107 |  | VALUE_SET | cboUseFlag.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |

## SCP0087_MDMClassMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efcda1ae | Dispose | SCP0087_MDMClassMaster.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0087_MDMClassMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be6b139 | EditButton | SCP0087_MDMClassMaster.cs:156 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32b1b840 | EditButton | SCP0087_MDMClassMaster.cs:158 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a57f83ae | EditButton | SCP0087_MDMClassMaster.cs:159 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f2ee44f | EditButton | SCP0087_MDMClassMaster.cs:160 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-58cae75f | EditButton | SCP0087_MDMClassMaster.cs:163 |  | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05f5ea90 | EditButton | SCP0087_MDMClassMaster.cs:164 |  | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff11f43e | EditButton | SCP0087_MDMClassMaster.cs:166 | if (fps.ActiveSheet.Columns.Get(xCol1).Visible == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4778658 | EditButton | SCP0087_MDMClassMaster.cs:169 |  | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e273df0 | EditButton | SCP0087_MDMClassMaster.cs:172 |  | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ITEM_TYPE), spdMain.ActiveSheet.RowCount - 1, siMain.… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0087_MDMClassMaster.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67980472 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:193 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f66e9e84 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:198 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-756a7f6c | FindButton 외 1 | SCP0087_MDMClassMaster.cs:201 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e43576d2 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:211 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3e8aa3e5 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:212 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac03542b | FindButton 외 1 | SCP0087_MDMClassMaster.cs:216 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0087_GET_MDM_CLASS_MASTER") ⇒ SCP.SCP0087_GET_MDM_CLASS_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-72a9b847 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:217 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9dcffcf6 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:218 | try ▸ lambda | DATA_OP | request.Parameters["p_class_id"] | p_class_id | 행/컬럼 값 대입 |  |  |  |
| AC-64fe0eec | FindButton 외 1 | SCP0087_MDMClassMaster.cs:219 | try ▸ lambda | DATA_OP | request.Parameters["p_class_name"] | p_class_name | 행/컬럼 값 대입 |  |  |  |
| AC-dc973bf3 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:220 | try ▸ lambda | DATA_OP | request.Parameters["p_use_flag"] | p_use_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f20833ed | FindButton 외 1 | SCP0087_MDMClassMaster.cs:221 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2d1f316b | FindButton 외 1 | SCP0087_MDMClassMaster.cs:223 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7dfaaac0 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:225 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-3a6f7aae | FindButton 외 1 | SCP0087_MDMClassMaster.cs:232 | try | GRID_BIND | siMain.Query | (ds.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d3dd714 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:234 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-106db397 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:237 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8b7c67c8 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:245 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-395edc39 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:246 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a136ebf | FindButton 외 1 | SCP0087_MDMClassMaster.cs:250 | finally | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6e80b631 | FindButton 외 1 | SCP0087_MDMClassMaster.cs:254 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0087_MDMClassMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a44ff41a | this.Load | SCP0087_MDMClassMaster.cs:94 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0087_MDMClassMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c730243a | this.Load | SCP0087_MDMClassMaster.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bc3c8294 | this.Load | SCP0087_MDMClassMaster.cs:113 |  | LIST_REBIND | cboUseFlag.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0087_MDMClassMaster.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32d39c1b | this.Load 외 2 | SCP0087_MDMClassMaster.cs:128 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-88a70d04 | this.Load 외 2 | SCP0087_MDMClassMaster.cs:129 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-919ddf72 | this.Load 외 2 | SCP0087_MDMClassMaster.cs:130 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0087_MDMClassMaster.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c47be6e8 | InsertButton | SCP0087_MDMClassMaster.cs:151 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0087_MDMClassMaster.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1df0e88a | SaveButton | SCP0087_MDMClassMaster.cs:183 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0087_MDMClassMaster.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-252356ae | SaveButton | SCP0087_MDMClassMaster.cs:260 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94df4de0 | SaveButton | SCP0087_MDMClassMaster.cs:262 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6af59a37 | SaveButton | SCP0087_MDMClassMaster.cs:277 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("CLASS_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebad192a | SaveButton | SCP0087_MDMClassMaster.cs:278 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ITEM_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d55a19a | SaveButton | SCP0087_MDMClassMaster.cs:279 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PROCESS_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-b21323c3 | SaveButton | SCP0087_MDMClassMaster.cs:280 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PROCESS_DETAIL") | 데이터 객체 조작/조회 |  |  |  |
| AC-af941fa7 | SaveButton | SCP0087_MDMClassMaster.cs:281 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("USE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-a47dcbd0 | SaveButton | SCP0087_MDMClassMaster.cs:282 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc367ff8 | SaveButton | SCP0087_MDMClassMaster.cs:283 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PROGRAM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9c69e77 | SaveButton | SCP0087_MDMClassMaster.cs:284 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DEBUG_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52f9f089 | SaveButton | SCP0087_MDMClassMaster.cs:286 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-83654a82 | SaveButton | SCP0087_MDMClassMaster.cs:296 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a71d2fbc | SaveButton | SCP0087_MDMClassMaster.cs:298 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CLASS_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.CLASS_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-950a3599 | SaveButton | SCP0087_MDMClassMaster.cs:298 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.CLASS_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a00c8b0 | SaveButton | SCP0087_MDMClassMaster.cs:299 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ITEM_TYPE"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ITEM_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-aa28e82e | SaveButton | SCP0087_MDMClassMaster.cs:300 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROCESS_GROUP"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PROCESS_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-15aba824 | SaveButton | SCP0087_MDMClassMaster.cs:301 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROCESS_DETAIL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PROCESS_DETAIL)) | 행/컬럼 값 대입 |  |  |  |
| AC-4ff834ec | SaveButton | SCP0087_MDMClassMaster.cs:302 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["USE_FLAG"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.USE_FLAG)) | 행/컬럼 값 대입 |  |  |  |
| AC-48e81442 | SaveButton | SCP0087_MDMClassMaster.cs:303 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6655b205 | SaveButton | SCP0087_MDMClassMaster.cs:304 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROGRAM_ID"] | "SCP0087" | 행/컬럼 값 대입 |  |  |  |
| AC-2dcf186e | SaveButton | SCP0087_MDMClassMaster.cs:305 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-093cae0e | SaveButton | SCP0087_MDMClassMaster.cs:307 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-edd3a962 | SaveButton | SCP0087_MDMClassMaster.cs:311 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-423f872b | SaveButton | SCP0087_MDMClassMaster.cs:319 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5008b8c8 | SaveButton | SCP0087_MDMClassMaster.cs:329 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0087", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22f7c63e | SaveButton | SCP0087_MDMClassMaster.cs:330 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveMDMClassMaster") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveMDMClassMaster] \| … | 엔드포인트 호출 |  |  |  |
| AC-7d5cc412 | SaveButton | SCP0087_MDMClassMaster.cs:333 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-52295c08 | SaveButton | SCP0087_MDMClassMaster.cs:338 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc9dccde | SaveButton | SCP0087_MDMClassMaster.cs:347 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0fd047f | SaveButton | SCP0087_MDMClassMaster.cs:356 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-32a5e49d | SaveButton | SCP0087_MDMClassMaster.cs:358 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b54322cc | SaveButton | SCP0087_MDMClassMaster.cs:364 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1b079fe2 | SaveButton | SCP0087_MDMClassMaster.cs:377 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cf0af40d | SaveButton | SCP0087_MDMClassMaster.cs:378 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19f9aaf1 | SaveButton | SCP0087_MDMClassMaster.cs:382 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-84719e45 | SaveButton | SCP0087_MDMClassMaster.cs:383 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0087_MDMClassMaster.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f347f2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:395 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-cc3830da | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:396 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-0ffdbf3b | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:397 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-d81111c9 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:398 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-3b7e858f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:399 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-af935692 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:400 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-8f3b66c6 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:401 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-92873048 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0087_MDMClassMaster.cs:403 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

