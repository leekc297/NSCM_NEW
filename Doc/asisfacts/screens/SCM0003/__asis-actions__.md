# AS-IS 액션 대조표 — SCM0003

> 원천: `Doc/asisfacts/screens/SCM0003/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 333행 · 메서드 28 · 종류 DATA_OP 131 · GRID_INIT 86 · RETURN 22 · FLAG 17 · ENDPOINT 12 · GRID_LOCK 11 · CALL_EXT 11 · UI_PROP 10 · UI_MISC 7 · MESSAGE 5 · COMBO_DATA 4 · GRID_COMBO 4 · GRID_SET 3 · GRID_BIND 2 · LIST_REBIND 2 · VALIDATE 2 · STATE 1 · VALUE_SET 1 · STATE_RESET 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 12


## SCM0003_Lookup.CheckValidation

진입점: SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b66b2ff | SaveButton [if (fps.Name == "spdMain")] | SCM0003_Lookup.cs:823 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a7c39876 | SaveButton [if (fps.Name == "spdMain")] | SCM0003_Lookup.cs:824 | try ▸ for (i < dt.Rows.Count) ▸ for (j < dt.Rows.Count) ▸ if (sLookupType == schkLookupType && sSegment1 == schkSegment1 && sSegment2 == sch… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0787c742 | SaveButton [if (fps.Name == "spdMain")] | SCM0003_Lookup.cs:831 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ced73f78 | SaveButton [if (fps.Name == "spdMain")] | SCM0003_Lookup.cs:833 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## SCM0003_Lookup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e857e2 | this.Load | SCM0003_Lookup.cs:148 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8276aafc | this.Load | SCM0003_Lookup.cs:149 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2c0746e6 | this.Load | SCM0003_Lookup.cs:151 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a46e8328 | this.Load | SCM0003_Lookup.cs:152 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-abaa0259 | this.Load | SCM0003_Lookup.cs:154 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0003_Lookup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6c35bdc | DeleteButton | SCM0003_Lookup.cs:265 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8c53453 | DeleteButton | SCM0003_Lookup.cs:268 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-058de61f | DeleteButton | SCM0003_Lookup.cs:270 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0003_Lookup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-502b1485 | Dispose | SCM0003_Lookup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0003_Lookup.DoAfterSave

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (t.AffectedRows > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7615d34f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:633 | try | ENDPOINT | new FoxDataRequest | ("SCM.SCM0003_AFTER_LOOKUP_MASTER_DETAIL") ⇒ SCM.SCM0003_AFTER_LOOKUP_MASTER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-183a0a3e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:635 | try | DATA_OP | request.Parameters["p_program_id"] | "SCM0103" | 행/컬럼 값 대입 |  |  |  |
| AC-bb1400c4 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:636 | try | DATA_OP | request.Parameters["p_sheet_name"] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-b9a522fe | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:637 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-633faaea | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:638 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8036614e | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:640 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e990e8cc | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | SCM0003_Lookup.cs:653 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCM0003_Lookup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fb10009 | EditButton | SCM0003_Lookup.cs:279 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-21541040 | EditButton | SCM0003_Lookup.cs:280 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a37bab63 | EditButton | SCM0003_Lookup.cs:282 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.LAST_UPDAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2fc6551b | EditButton | SCM0003_Lookup.cs:287 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f28b2b33 | EditButton | SCM0003_Lookup.cs:288 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-16559c89 | EditButton | SCM0003_Lookup.cs:290 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE), siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab701081 | EditButton | SCM0003_Lookup.cs:291 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAST_UPDATE_… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0003_Lookup.EssentialCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b66ae156 | (진입점 미연결) | SCM0003_Lookup.cs:752 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-743b2868 | (진입점 미연결) | SCM0003_Lookup.cs:760 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ebcfcff | (진입점 미연결) | SCM0003_Lookup.cs:764 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1abf54ef | (진입점 미연결) | SCM0003_Lookup.cs:765 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-38815dad | (진입점 미연결) | SCM0003_Lookup.cs:772 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-0e3ef687 | (진입점 미연결) | SCM0003_Lookup.cs:774 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SCM0003_Lookup.FindData_Main

진입점: FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10011cc1 | FindButton 외 1 | SCM0003_Lookup.cs:311 |  | CALL_EXT | CString.GetComboBoxValue | (cboLookupGroup.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3882031d | FindButton 외 1 | SCM0003_Lookup.cs:312 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f09b9ac | FindButton 외 1 | SCM0003_Lookup.cs:316 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e1efd75 | FindButton 외 1 | SCM0003_Lookup.cs:320 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0003_GET_LOOKUP_MASTER") ⇒ SCM.SCM0003_GET_LOOKUP_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-a08d3125 | FindButton 외 1 | SCM0003_Lookup.cs:321 | lambda | DATA_OP | request.Parameters["p_lookup_type"] | txtLookupType.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-9e0a3fdb | FindButton 외 1 | SCM0003_Lookup.cs:322 | lambda | DATA_OP | request.Parameters["p_lookup_group"] | lookupGroup | 행/컬럼 값 대입 |  |  |  |
| AC-6a101773 | FindButton 외 1 | SCM0003_Lookup.cs:323 | lambda | DATA_OP | request.Parameters["p_valid_yn"] | validYN | 행/컬럼 값 대입 |  |  |  |
| AC-0dc9cacd | FindButton 외 1 | SCM0003_Lookup.cs:325 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8631cdbc | FindButton 외 1 | SCM0003_Lookup.cs:327 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8df54aaf | FindButton 외 1 | SCM0003_Lookup.cs:331 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-996fcd7c | FindButton 외 1 | SCM0003_Lookup.cs:332 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b6af1c48 | FindButton 외 1 | SCM0003_Lookup.cs:335 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9b2fcec3 | FindButton 외 1 | SCM0003_Lookup.cs:338 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0003_Lookup.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16a36929 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:351 | if (string.IsNullOrWhiteSpace(mainLookupType)) | FLAG | mainLookupType | siMain.GetValue(0, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-923fe2e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:355 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6adbc285 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:359 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL") ⇒ SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-542de471 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:360 | lambda | DATA_OP | request.Parameters["p_lookup_type"] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-fed3406c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:361 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-89bd14c6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:363 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8a2d159b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:367 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ec8da4c6 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:377 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) | DATA_OP | dtColumInfo.Columns.Contains | (sColName) | 데이터 객체 조작/조회 |  |  |  |
| AC-93b3d3e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:385 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ if (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(sValue)… | STATE | col.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-eb6dda35 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:391 | if (dr != null) ▸ for (iCol < siSub.ActiveSheet.Columns.Count) ▸ else of (sValue == "-" \|\| sValue == "*" \|\| string.IsNullOrWhiteSpace(sV… | UI_PROP | col.Label | sValue | 속성 Label 설정 |  |  |  |
| AC-8386dd41 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:396 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7e8d3640 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:397 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8b8e8ba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 1 | SCM0003_Lookup.cs:400 |  | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0003_Lookup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adb0e069 | this.Load | SCM0003_Lookup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0003_Lookup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b580aa | this.Load | SCM0003_Lookup.cs:133 |  | LIST_REBIND | cboLookupGroup.DataBind | (Data.Type.System, true) ⇒ biz:CommonData.CommonDataList [code=System] | 목록 컨트롤 재구성 |  |  |  |
| AC-24838d75 | this.Load | SCM0003_Lookup.cs:134 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-832af72a | this.Load | SCM0003_Lookup.cs:136 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-3e7802c0 | this.Load | SCM0003_Lookup.cs:138 |  | FLAG | dtColumInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6656f64 | this.Load | SCM0003_Lookup.cs:142 | foreach (string str in sColumnList) | DATA_OP | dtColumInfo.Columns.Add | (str) | 데이터 객체 조작/조회 |  |  |  |

## SCM0003_Lookup.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)] / FindButton / SaveButton [if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65be00c2 | this.Load 외 3 | SCM0003_Lookup.cs:164 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7b7caaf9 | this.Load 외 3 | SCM0003_Lookup.cs:166 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-02a50bcb | this.Load 외 3 | SCM0003_Lookup.cs:167 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup TypeKey", DefColumns.LOOKUP_TYPE_KEY, FPMerge.None, 160, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3445223 | this.Load 외 3 | SCM0003_Lookup.cs:168 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Type*", DefColumns.LOOKUP_TYPE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-faab8faf | this.Load 외 3 | SCM0003_Lookup.cs:169 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Description*", DefColumns.DESCRIPTION, FPMerge.None, 220, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb2650ab | this.Load 외 3 | SCM0003_Lookup.cs:170 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("System*", DefColumns.LOOKUP_GROUP, FPMerge.None, 80, true, dtSystem, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ea35b274 | this.Load 외 3 | SCM0003_Lookup.cs:171 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a6a4583 | this.Load 외 3 | SCM0003_Lookup.cs:172 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1*", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1e25b68 | this.Load 외 3 | SCM0003_Lookup.cs:173 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2*", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1c0386e | this.Load 외 3 | SCM0003_Lookup.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3*", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6488e4f | this.Load 외 3 | SCM0003_Lookup.cs:175 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4*", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e1953a3 | this.Load 외 3 | SCM0003_Lookup.cs:176 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5*", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc67e955 | this.Load 외 3 | SCM0003_Lookup.cs:177 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03d5d921 | this.Load 외 3 | SCM0003_Lookup.cs:178 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6d0178a | this.Load 외 3 | SCM0003_Lookup.cs:179 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1738e120 | this.Load 외 3 | SCM0003_Lookup.cs:180 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98f3ae29 | this.Load 외 3 | SCM0003_Lookup.cs:181 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b62b6e1 | this.Load 외 3 | SCM0003_Lookup.cs:182 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0d7017e | this.Load 외 3 | SCM0003_Lookup.cs:183 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b130d24 | this.Load 외 3 | SCM0003_Lookup.cs:184 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75a6d39e | this.Load 외 3 | SCM0003_Lookup.cs:185 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbdedeae | this.Load 외 3 | SCM0003_Lookup.cs:186 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-62981a9e | this.Load 외 3 | SCM0003_Lookup.cs:187 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee5ba12a | this.Load 외 3 | SCM0003_Lookup.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80d6d0a2 | this.Load 외 3 | SCM0003_Lookup.cs:189 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36974296 | this.Load 외 3 | SCM0003_Lookup.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-defec9cd | this.Load 외 3 | SCM0003_Lookup.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0698e18f | this.Load 외 3 | SCM0003_Lookup.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefColumns.CREATED_BY, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2f122782 | this.Load 외 3 | SCM0003_Lookup.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefColumns.CREATION_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76ccf262 | this.Load 외 3 | SCM0003_Lookup.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 100, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21153f20 | this.Load 외 3 | SCM0003_Lookup.cs:195 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 160, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d308b300 | this.Load 외 3 | SCM0003_Lookup.cs:197 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d3257069 | this.Load 외 3 | SCM0003_Lookup.cs:199 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46340fb2 | this.Load 외 3 | SCM0003_Lookup.cs:204 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-15b1b445 | this.Load 외 3 | SCM0003_Lookup.cs:206 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0a70eb29 | this.Load 외 3 | SCM0003_Lookup.cs:207 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Lookup Type*", DefColumns.LOOKUP_TYPE, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d89e8321 | this.Load 외 3 | SCM0003_Lookup.cs:208 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2ba865b | this.Load 외 3 | SCM0003_Lookup.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2604d961 | this.Load 외 3 | SCM0003_Lookup.cs:210 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a017640b | this.Load 외 3 | SCM0003_Lookup.cs:211 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e81194b1 | this.Load 외 3 | SCM0003_Lookup.cs:212 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1847aef3 | this.Load 외 3 | SCM0003_Lookup.cs:213 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid", DefColumns.VALID_YN, FPMerge.None, 50, true, dtYesOrNo, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c2d7d2a | this.Load 외 3 | SCM0003_Lookup.cs:214 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute1", DefColumns.ATTRIBUTE1, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b8eb87e9 | this.Load 외 3 | SCM0003_Lookup.cs:215 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute2", DefColumns.ATTRIBUTE2, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44a9d24c | this.Load 외 3 | SCM0003_Lookup.cs:216 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute3", DefColumns.ATTRIBUTE3, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5374ce07 | this.Load 외 3 | SCM0003_Lookup.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute4", DefColumns.ATTRIBUTE4, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1dcbd76c | this.Load 외 3 | SCM0003_Lookup.cs:218 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute5", DefColumns.ATTRIBUTE5, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a79f032d | this.Load 외 3 | SCM0003_Lookup.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute6", DefColumns.ATTRIBUTE6, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b06e653e | this.Load 외 3 | SCM0003_Lookup.cs:220 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute7", DefColumns.ATTRIBUTE7, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b39ba5ae | this.Load 외 3 | SCM0003_Lookup.cs:221 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute8", DefColumns.ATTRIBUTE8, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0091831a | this.Load 외 3 | SCM0003_Lookup.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute9", DefColumns.ATTRIBUTE9, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26ef4185 | this.Load 외 3 | SCM0003_Lookup.cs:223 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute10", DefColumns.ATTRIBUTE10, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5967ff38 | this.Load 외 3 | SCM0003_Lookup.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute11", DefColumns.ATTRIBUTE11, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ef7ddcd | this.Load 외 3 | SCM0003_Lookup.cs:225 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute12", DefColumns.ATTRIBUTE12, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66546daf | this.Load 외 3 | SCM0003_Lookup.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute13", DefColumns.ATTRIBUTE13, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51353be8 | this.Load 외 3 | SCM0003_Lookup.cs:227 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute14", DefColumns.ATTRIBUTE14, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05978717 | this.Load 외 3 | SCM0003_Lookup.cs:228 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Attribute15", DefColumns.ATTRIBUTE15, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d76e8f32 | this.Load 외 3 | SCM0003_Lookup.cs:229 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Desplay Seq", DefColumns.DISPLAY_SEQ, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebe7481b | this.Load 외 3 | SCM0003_Lookup.cs:230 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Description", DefColumns.DESCRIPTION, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca87eeed | this.Load 외 3 | SCM0003_Lookup.cs:231 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefColumns.CREATED_BY, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa8198d8 | this.Load 외 3 | SCM0003_Lookup.cs:232 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefColumns.CREATION_DATE, FPMerge.None, 160, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-637b3d81 | this.Load 외 3 | SCM0003_Lookup.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefColumns.LAST_UPDATED_BY, FPMerge.None, 100, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ccf8b830 | this.Load 외 3 | SCM0003_Lookup.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefColumns.LAST_UPDATE_DATE, FPMerge.None, 160, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a010cb40 | this.Load 외 3 | SCM0003_Lookup.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment1", DefColumns.SEGMENT1_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51f34836 | this.Load 외 3 | SCM0003_Lookup.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment2", DefColumns.SEGMENT2_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5d9ad50 | this.Load 외 3 | SCM0003_Lookup.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment3", DefColumns.SEGMENT3_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-35035877 | this.Load 외 3 | SCM0003_Lookup.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment4", DefColumns.SEGMENT4_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-516a1103 | this.Load 외 3 | SCM0003_Lookup.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.AddTextColumn | ("Segment5", DefColumns.SEGMENT5_KEY, FPMerge.None, 120, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-610a8ab5 | this.Load 외 3 | SCM0003_Lookup.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.DESCRIPTION)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-baf816ea | this.Load 외 3 | SCM0003_Lookup.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0003_Lookup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16887be1 | InsertButton | SCM0003_Lookup.cs:660 | if (fps.Name == "spdMain") | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aa844dc0 | InsertButton | SCM0003_Lookup.cs:663 | if (fps.Name == "spdMain") | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-d58d3fc3 | InsertButton | SCM0003_Lookup.cs:665 | if (fps.Name == "spdMain") | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-c3bfa02e | InsertButton | SCM0003_Lookup.cs:667 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c291bea6 | InsertButton | SCM0003_Lookup.cs:671 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c4ad2e2e | InsertButton | SCM0003_Lookup.cs:673 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.LOOKUP_TYPE, mainLookupType) | 데이터 객체 조작/조회 |  |  |  |
| AC-d47357c0 | InsertButton | SCM0003_Lookup.cs:674 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT1, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-100295d2 | InsertButton | SCM0003_Lookup.cs:675 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT2, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca90202 | InsertButton | SCM0003_Lookup.cs:676 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT3, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e63fbdf1 | InsertButton | SCM0003_Lookup.cs:677 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-aaae4d72 | InsertButton | SCM0003_Lookup.cs:678 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.SEGMENT5, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffa9d04a | InsertButton | SCM0003_Lookup.cs:679 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c6fbc10 | InsertButton | SCM0003_Lookup.cs:681 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_SET | siSub.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7ca6dc75 | InsertButton | SCM0003_Lookup.cs:683 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.LOOKUP_TYPE), siSub.GetColumnIndex(DefColumns.LO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ab0cc22 | InsertButton | SCM0003_Lookup.cs:684 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.CREATED_BY), siSub.GetColumnIndex(DefColumns.LAS… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0003_Lookup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2eb0b02 | SaveButton | SCM0003_Lookup.cs:411 | if (fps.Name == "spdMain") | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-69fc62bc | SaveButton | SCM0003_Lookup.cs:411 | if (fps.Name == "spdMain") ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b49efdd | SaveButton | SCM0003_Lookup.cs:413 | if (fps.Name == "spdMain") ▸ if (!CheckValidation(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce88bf98 | SaveButton | SCM0003_Lookup.cs:417 | if (fps.Name == "spdMain") | DATA_OP | (siMain.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cff2524c | SaveButton | SCM0003_Lookup.cs:418 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a560902a | SaveButton | SCM0003_Lookup.cs:432 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1f15c8b6 | SaveButton | SCM0003_Lookup.cs:434 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[CAppSetting.StringAction] | action | 행/컬럼 값 대입 |  |  |  |
| AC-297d7db7 | SaveButton | SCM0003_Lookup.cs:435 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE_KEY] | sLooupTypeKey | 행/컬럼 값 대입 |  |  |  |
| AC-d08b1f14 | SaveButton | SCM0003_Lookup.cs:436 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e10cdb56 | SaveButton | SCM0003_Lookup.cs:437 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DESCRIPTION] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee0b150e | SaveButton | SCM0003_Lookup.cs:438 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_GROUP] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.LOOKUP_GROUP)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-919868e9 | SaveButton | SCM0003_Lookup.cs:439 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b075f43c | SaveButton | SCM0003_Lookup.cs:440 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14806825 | SaveButton | SCM0003_Lookup.cs:441 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2413e835 | SaveButton | SCM0003_Lookup.cs:442 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ab1813a | SaveButton | SCM0003_Lookup.cs:443 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06ea1969 | SaveButton | SCM0003_Lookup.cs:444 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0c1f1f23 | SaveButton | SCM0003_Lookup.cs:445 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-965bae15 | SaveButton | SCM0003_Lookup.cs:446 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ead02f4 | SaveButton | SCM0003_Lookup.cs:447 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7572a64 | SaveButton | SCM0003_Lookup.cs:448 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6ce82665 | SaveButton | SCM0003_Lookup.cs:449 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d5e401e | SaveButton | SCM0003_Lookup.cs:450 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-02315c9b | SaveButton | SCM0003_Lookup.cs:451 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8ac993fb | SaveButton | SCM0003_Lookup.cs:452 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-392e548d | SaveButton | SCM0003_Lookup.cs:453 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-83a54f86 | SaveButton | SCM0003_Lookup.cs:454 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27d580f1 | SaveButton | SCM0003_Lookup.cs:455 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a0fde6e | SaveButton | SCM0003_Lookup.cs:456 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eed4bd49 | SaveButton | SCM0003_Lookup.cs:457 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0dc8ffda | SaveButton | SCM0003_Lookup.cs:458 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8ef3018 | SaveButton | SCM0003_Lookup.cs:459 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d2b472b | SaveButton | SCM0003_Lookup.cs:463 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-350fa534 | SaveButton | SCM0003_Lookup.cs:464 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b2d99b6d | SaveButton | SCM0003_Lookup.cs:468 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CREATED_BY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b27a5e52 | SaveButton | SCM0003_Lookup.cs:469 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | Convert.ToDateTime(siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CREATION_DATE)).ToS… | 행/컬럼 값 대입 |  |  |  |
| AC-3c72c08f | SaveButton | SCM0003_Lookup.cs:471 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6356e3d9 | SaveButton | SCM0003_Lookup.cs:473 | if (fps.Name == "spdMain") ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-a73d341d | SaveButton | SCM0003_Lookup.cs:476 | if (fps.Name == "spdMain") | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67b348de | SaveButton | SCM0003_Lookup.cs:484 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-77dc4125 | SaveButton | SCM0003_Lookup.cs:485 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eab79d12 | SaveButton | SCM0003_Lookup.cs:486 | if (fps.Name == "spdMain") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.StringAction].ToString()) case CAppSet… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d3783e35 | SaveButton | SCM0003_Lookup.cs:490 | if (fps.Name == "spdMain") | UI_PROP | request.InsertQueryId | "SCM.SCM0003_SAVE_LOOKUP_MASTER" | 속성 InsertQueryId 설정 |  |  |  |
| AC-415e78da | SaveButton | SCM0003_Lookup.cs:491 | if (fps.Name == "spdMain") | UI_PROP | request.DeleteQueryId | "SCM.SCM0003_DELETE_LOOKUP_MASTER" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-f64d4460 | SaveButton | SCM0003_Lookup.cs:492 | if (fps.Name == "spdMain") | UI_PROP | request.UpdateQueryId | "SCM.SCM0003_SAVE_LOOKUP_MASTER" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-05dc1199 | SaveButton | SCM0003_Lookup.cs:494 | if (fps.Name == "spdMain") | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-97a6ded1 | SaveButton | SCM0003_Lookup.cs:494 | if (fps.Name == "spdMain") | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-72adb2d8 | SaveButton | SCM0003_Lookup.cs:498 | if (fps.Name == "spdMain") | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32032e58 | SaveButton | SCM0003_Lookup.cs:502 | if (fps.Name == "spdMain") ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e0f10582 | SaveButton | SCM0003_Lookup.cs:502 | if (fps.Name == "spdMain") ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-e3d0dab8 | SaveButton | SCM0003_Lookup.cs:507 | if (fps.Name == "spdMain") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d568281e | SaveButton | SCM0003_Lookup.cs:515 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | (siSub.SpreadObject.DataSource as DataSet).Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2749c57b | SaveButton | SCM0003_Lookup.cs:516 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].Columns.Add | (CAppSetting.StringAction, typeof(char)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cc00abe | SaveButton | SCM0003_Lookup.cs:519 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-0537a38d | SaveButton | SCM0003_Lookup.cs:519 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!DataUtil.checkRequiredOfSpread(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ac1f91c | SaveButton | SCM0003_Lookup.cs:521 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (!CheckValidation(siSub)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-78fabe11 | SaveButton | SCM0003_Lookup.cs:530 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-247fdf86 | SaveButton | SCM0003_Lookup.cs:537 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[CAppSetting.StringAction] | action | 행/컬럼 값 대입 |  |  |  |
| AC-2fc4bd84 | SaveButton | SCM0003_Lookup.cs:538 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LOOKUP_TYPE] | mainLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-7c52cfba | SaveButton | SCM0003_Lookup.cs:539 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DESCRIPTION] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23b50b79 | SaveButton | SCM0003_Lookup.cs:540 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4998a5a | SaveButton | SCM0003_Lookup.cs:541 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dac77e0e | SaveButton | SCM0003_Lookup.cs:542 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6bf2ba4d | SaveButton | SCM0003_Lookup.cs:543 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd4bba53 | SaveButton | SCM0003_Lookup.cs:544 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d3b3865c | SaveButton | SCM0003_Lookup.cs:545 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT1_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT1_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef20bb49 | SaveButton | SCM0003_Lookup.cs:546 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT2_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT2_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-be2acb9e | SaveButton | SCM0003_Lookup.cs:547 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT3_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT3_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99471d6c | SaveButton | SCM0003_Lookup.cs:548 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT4_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT4_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08faf68a | SaveButton | SCM0003_Lookup.cs:549 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.SEGMENT5_KEY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.SEGMENT5_KEY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-906ca7eb | SaveButton | SCM0003_Lookup.cs:550 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.DISPLAY_SEQ] | sDisplaySeq | 행/컬럼 값 대입 |  |  |  |
| AC-f158bd7e | SaveButton | SCM0003_Lookup.cs:551 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.VALID_YN] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.VALID_YN)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b60c7186 | SaveButton | SCM0003_Lookup.cs:552 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e3bc97a4 | SaveButton | SCM0003_Lookup.cs:553 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b02ddc8e | SaveButton | SCM0003_Lookup.cs:554 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6145bf3a | SaveButton | SCM0003_Lookup.cs:555 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aea1b15f | SaveButton | SCM0003_Lookup.cs:556 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c591a5f8 | SaveButton | SCM0003_Lookup.cs:557 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e3906986 | SaveButton | SCM0003_Lookup.cs:558 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9ba76b7 | SaveButton | SCM0003_Lookup.cs:559 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d6cfd33 | SaveButton | SCM0003_Lookup.cs:560 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3de1aa6c | SaveButton | SCM0003_Lookup.cs:561 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9e2be9e | SaveButton | SCM0003_Lookup.cs:562 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cbaf454a | SaveButton | SCM0003_Lookup.cs:563 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0713407e | SaveButton | SCM0003_Lookup.cs:564 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-383fe68b | SaveButton | SCM0003_Lookup.cs:565 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-083e18bb | SaveButton | SCM0003_Lookup.cs:566 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-067b9bd1 | SaveButton | SCM0003_Lookup.cs:570 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fa86d2bd | SaveButton | SCM0003_Lookup.cs:571 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-98251501 | SaveButton | SCM0003_Lookup.cs:575 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATED_BY] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CREATED_BY)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b4e82764 | SaveButton | SCM0003_Lookup.cs:576 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (action == CAppSetting.FlagI) | DATA_OP | dr[DefColumns.CREATION_DATE] | Convert.ToDateTime(siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.CREATION_DATE)).ToStr… | 행/컬럼 값 대입 |  |  |  |
| AC-d99f7125 | SaveButton | SCM0003_Lookup.cs:578 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | dr[DefColumns.LAST_UPDATED_BY] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-14ebb166 | SaveButton | SCM0003_Lookup.cs:580 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ for (i <= siSub.GetMaxRowIndex()) | DATA_OP | saveDS.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce2c83b3 | SaveButton | SCM0003_Lookup.cs:583 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | DATA_OP | saveDS.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9d75a7a6 | SaveButton | SCM0003_Lookup.cs:591 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | CALL_EXT | row.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d557429 | SaveButton | SCM0003_Lookup.cs:592 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | CALL_EXT | row.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ca62320 | SaveButton | SCM0003_Lookup.cs:593 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ foreach (DataRow row in saveDS.Tables[0].Rows) ▸ switch (row[CAppSetting.Strin… | DATA_OP | row.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-64bde1ed | SaveButton | SCM0003_Lookup.cs:597 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.InsertQueryId | "SCM.SCM0003_SAVE_LOOKUP_MASTER_DETAIL" | 속성 InsertQueryId 설정 |  |  |  |
| AC-59ca36e5 | SaveButton | SCM0003_Lookup.cs:598 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.DeleteQueryId | "SCM.SCM0003_DELETE_LOOKUP_MASTER_DETAIL" | 속성 DeleteQueryId 설정 |  |  |  |
| AC-39a89f22 | SaveButton | SCM0003_Lookup.cs:599 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.UpdateQueryId | "SCM.SCM0003_SAVE_LOOKUP_MASTER_DETAIL" | 속성 UpdateQueryId 설정 |  |  |  |
| AC-777f1237 | SaveButton | SCM0003_Lookup.cs:601 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | UI_PROP | request.DataSet | saveDS.GetChanges() | 속성 DataSet 설정 |  |  |  |
| AC-f263b5a1 | SaveButton | SCM0003_Lookup.cs:601 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | CALL_EXT | saveDS.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-25824ad1 | SaveButton | SCM0003_Lookup.cs:605 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8373051b | SaveButton | SCM0003_Lookup.cs:609 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ lambda | ENDPOINT | client.SaveDataTable | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e5f5905a | SaveButton | SCM0003_Lookup.cs:609 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ lambda | RETURN | return client.SaveDataTable(request); |  | 처리 중단/반환 |  |  |  |
| AC-9964ec41 | SaveButton | SCM0003_Lookup.cs:614 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.AffectedRows }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0003_Lookup.SetColumInfo

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName) == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b55b59e5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:712 |  | DATA_OP | dtColumInfo.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c67deed8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:713 |  | DATA_OP | dr[DefColumns.SEGMENT1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2192500b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:714 |  | DATA_OP | dr[DefColumns.SEGMENT2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-626cf117 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:715 |  | DATA_OP | dr[DefColumns.SEGMENT3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d670fc6c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:716 |  | DATA_OP | dr[DefColumns.SEGMENT4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71433a9b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:717 |  | DATA_OP | dr[DefColumns.SEGMENT5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.SEGMENT5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2a70153 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:718 |  | DATA_OP | dr[DefColumns.ATTRIBUTE1] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b989a3b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:719 |  | DATA_OP | dr[DefColumns.ATTRIBUTE2] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2815c4b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:720 |  | DATA_OP | dr[DefColumns.ATTRIBUTE3] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1819071b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:721 |  | DATA_OP | dr[DefColumns.ATTRIBUTE4] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE4)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6bd97ac7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:722 |  | DATA_OP | dr[DefColumns.ATTRIBUTE5] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE5)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16a6f470 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:723 |  | DATA_OP | dr[DefColumns.ATTRIBUTE6] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE6)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ebe95808 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:724 |  | DATA_OP | dr[DefColumns.ATTRIBUTE7] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE7)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfbba0e0 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:725 |  | DATA_OP | dr[DefColumns.ATTRIBUTE8] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-001f13c4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:726 |  | DATA_OP | dr[DefColumns.ATTRIBUTE9] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ed7fcee | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:727 |  | DATA_OP | dr[DefColumns.ATTRIBUTE10] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE10)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16cdbf5f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:728 |  | DATA_OP | dr[DefColumns.ATTRIBUTE11] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE11)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5e4663a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:729 |  | DATA_OP | dr[DefColumns.ATTRIBUTE12] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE12)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a231bd07 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:730 |  | DATA_OP | dr[DefColumns.ATTRIBUTE13] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE13)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15d3c9e4 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:731 |  | DATA_OP | dr[DefColumns.ATTRIBUTE14] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE14)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-da28d13a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:732 |  | DATA_OP | dr[DefColumns.ATTRIBUTE15] | siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.ATTRIBUTE15)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a62360f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… | SCM0003_Lookup.cs:734 |  | DATA_OP | dtColumInfo.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |

## SCM0003_Lookup.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ec7d326 | this.spdMain.CellDoubleClick | SCM0003_Lookup.cs:698 | if (siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5a55e74 | this.spdMain.CellDoubleClick | SCM0003_Lookup.cs:700 | if (siMain.IsLock(siMain.SheetName) == true) | FLAG | mainLookupType | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.LOOKUP_TYPE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2897c2fb | this.spdMain.CellDoubleClick | SCM0003_Lookup.cs:702 | if (siMain.IsLock(siMain.SheetName) == true) | STATE_RESET | dtColumInfo.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.BtnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-902f52ef | this.btnButtonList.UsrButtonList_Click_Detected | SCM0003_ProductionCapacityInsertPopup.cs:194 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6855f61 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:113 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08861d90 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:114 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5df06503 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:115 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f59358e6 | Dispose | SCM0003_ProductionCapacityInsertPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d4771a5 | EditButton | SCM0003_ProductionCapacityInsertPopup.cs:145 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cafe32f9 | EditButton | SCM0003_ProductionCapacityInsertPopup.cs:146 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.EssentialCheck

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK: ▸ if (siMain.Sheet().Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c639409f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:255 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | CALL_EXT | siMain.GetColumnText | (iRow, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a99b3c91 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:259 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcc8a577 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:260 | try ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-127c4272 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:267 | catch ((Exception ex)) | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |
| AC-dde467ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:269 |  | RETURN | return bFlag; |  | 처리 중단/반환 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17fe2a7e | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:90 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-02fd6b1a | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:95 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f00feac | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6be27bad | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:122 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a81af087 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:124 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8433fbaa | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:125 |  | GRID_INIT | siMain.AddComboColumn | ("Division*", DefColumns.DIVISION_ID, FPMerge.None, 140, true, dtMyDivision, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f04b360d | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:126 |  | GRID_INIT | siMain.AddComboColumn | ("Plant Site*", DefColumns.SCM_SITE_ID, FPMerge.None, 140, true, dtPlantSiteByDivision, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10fe71b7 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:127 |  | GRID_INIT | siMain.AddComboColumn | ("Building*", DefColumns.FACTORY_ID, FPMerge.None, 140, true, dtBuilding, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df845698 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:128 |  | GRID_INIT | siMain.AddComboColumn | ("Operation*", DefColumns.OPERATION_ID, FPMerge.None, 120, true, dtOperation, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75b137c3 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:129 |  | GRID_INIT | siMain.AddComboColumn | ("Line*", DefColumns.LINE_ID, FPMerge.None, 100, true, dtLine, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-069205e1 | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:130 |  | GRID_INIT | siMain.AddTextColumn | ("Project*", DefColumns.PROJECT_ID, FPMerge.None, 80, true, FPHAlign.Center, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a74db2df | this.Load | SCM0003_ProductionCapacityInsertPopup.cs:131 |  | GRID_INIT | siMain.AddTextColumn | ("Model*", DefColumns.ITEM_ID, FPMerge.None, 120, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.InsertButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-518e4fd0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:152 | if (!bIsEditClick) | CALL_BASE | OnClickEditButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b946d41a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:156 |  | FLAG | bIsEditClick | true | 화면 필드/플래그 변경 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.InsertRow

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Insert:] / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac1757bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:165 |  | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-22a6b9ff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:168 |  | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-858db351 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:169 |  | DATA_OP | defaultData.Add | (DefColumns.SCM_SITE_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-5372b53a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:170 |  | DATA_OP | defaultData.Add | (DefColumns.FACTORY_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea03f0f6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:171 |  | DATA_OP | defaultData.Add | (DefColumns.OPERATION_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-a96fe4ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:172 |  | DATA_OP | defaultData.Add | (DefColumns.LINE_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-e98ecef9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:173 |  | DATA_OP | defaultData.Add | (DefColumns.PROJECT_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-e7d24f5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:174 |  | DATA_OP | defaultData.Add | (DefColumns.ITEM_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-67adad65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCM0003_ProductionCapacityInsertPopup.cs:176 |  | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30a680c9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:202 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3568629 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:208 | if (siMain.Sheet().Rows.Count > 0) ▸ if (!EssentialCheck()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-982a254c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:212 | if (siMain.Sheet().Rows.Count > 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | lstPrdCapaInfo.Add | (new ProductionCapacityInfo() { DIVISION_ID = siMain.GetValue(i, siMain.GetColumnIndex(Def… | 데이터 객체 조작/조회 |  |  |  |
| AC-11756c5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:230 | if (siMain.Sheet().Rows.Count > 0) | FLAG | ProductionCapacityInfoList | lstPrdCapaInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-b74c5d65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCM0003_ProductionCapacityInsertPopup.cs:237 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0003_ProductionCapacityInsertPopup.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed65c050 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:278 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-1a7fbaa1 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:278 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-67099143 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:279 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtPlantSiteByDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-62e568c6 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:281 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | FLAG | dtBuilding | Data.Common(Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e8bfb9f8 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:281 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | COMBO_DATA | Data.Common | (Data.Type.BuildingByDivision, false, division) ⇒ biz:CommonData.CommonDataList [code=BuildingByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d520523d | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:282 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FACTORY_ID), dtBuilding) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-75e71eb6 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:290 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) | FLAG | dtOperation | Data.Common(Data.Type.OperationByBuilding, false, division, pPlantSiteID, pFactoryID) ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 화면 필드/플래그 변경 |  |  |  |
| AC-ce11827b | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:290 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) | COMBO_DATA | Data.Common | (Data.Type.OperationByBuilding, false, division, pPlantSiteID, pFactoryID) ⇒ biz:CommonData.CommonDataList [code=OperationByBuilding] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d9f96df5 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:291 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.OPERATION_ID), dtOperation) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4f9a4be8 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:300 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ i… | FLAG | dtLine | Data.Common(Data.Type.LineByOperation, false, division, pPlantSiteID, pFactoryID, pOperati… ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-2441b5d7 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:300 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ i… | COMBO_DATA | Data.Common | (Data.Type.LineByOperation, false, division, pPlantSiteID, pFactoryID, pOperationID) ⇒ biz:CommonData.CommonDataList [code=LineByOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-553a31a1 | spdMain.ComboSelChange | SCM0003_ProductionCapacityInsertPopup.cs:301 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FACTORY_ID)) ▸ i… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.LINE_ID), dtLine) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

