# AS-IS 액션 대조표 — SCP0037

> 원천: `Doc/asisfacts/screens/SCP0037/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 219행 · 메서드 20 · 종류 DATA_OP 91 · GRID_SET 25 · FLAG 18 · RETURN 15 · LIST_REBIND 9 · GRID_COMBO 9 · POPUP 8 · GRID_LOCK 8 · MESSAGE 7 · ENDPOINT 6 · UI_PROP 5 · GRID_INIT 5 · UI_MISC 4 · CALL_EXT 3 · VALIDATE 3 · VALUE_SET 1 · GRID_BIND 1 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 3


## SCP0037_OperationLT.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3fe0f59 | this.btnItemId.Click | SCP0037_OperationLT.cs:828 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c215410 | this.btnItemId.Click | SCP0037_OperationLT.cs:833 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ca09d3fe | this.btnItemId.Click | SCP0037_OperationLT.cs:835 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-80e5d24c | this.btnItemId.Click | SCP0037_OperationLT.cs:836 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1656dfff | this.btnItemId.Click | SCP0037_OperationLT.cs:837 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7f64dc0b | this.btnItemId.Click | SCP0037_OperationLT.cs:843 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0037_OperationLT.checkValidN1

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb01a874 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0037_OperationLT.cs:970 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7dc3bf2f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | SCP0037_OperationLT.cs:973 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0037_OperationLT.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged / cboLTOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bb0028e | cboDivision.SelectedIndexChanged 외 1 | SCP0037_OperationLT.cs:856 | if (siMain.ActiveSheet != null) ▸ if (CString.GetCheckedListValue(dtOperationLT, cboLTOperation.ControlValues) == "PRE_INSP") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INV_FLAG)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ad8b3a68 | cboDivision.SelectedIndexChanged 외 1 | SCP0037_OperationLT.cs:860 | if (siMain.ActiveSheet != null) ▸ else of (CString.GetCheckedListValue(dtOperationLT, cboLTOperation.ControlValues) == "PRE_INSP") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INV_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0037_OperationLT.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c461e03 | this.Load | SCP0037_OperationLT.cs:230 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da5f8254 | this.Load | SCP0037_OperationLT.cs:231 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-efa89211 | this.Load | SCP0037_OperationLT.cs:232 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0037_OperationLT.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108bcf2e | this.Load | SCP0037_OperationLT.cs:135 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtPlantSite | DBUtils.Filter(dtPlantSiteAll, filterDivision + " AND OPERATION_GROUP IN ('P', 'E', 'A')",… | 화면 필드/플래그 변경 |  |  |  |
| AC-6b690a23 | this.Load | SCP0037_OperationLT.cs:135 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (dtPlantSiteAll, filterDivision + " AND OPERATION_GROUP IN ('P', 'E', 'A')", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-31fb3e02 | this.Load | SCP0037_OperationLT.cs:137 | if (dtMyDivision.Rows.Count > 0) | FLAG | tmp | DBUtils.Filter(tmpBuff, filterDivision + " AND OPERATION_GROUP IN ('P', 'E')", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-bfb56e0d | this.Load | SCP0037_OperationLT.cs:137 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | DBUtils.Filter | (tmpBuff, filterDivision + " AND OPERATION_GROUP IN ('P', 'E')", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aa1259ef | this.Load | SCP0037_OperationLT.cs:140 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dtPlantSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-13b69fc5 | this.Load | SCP0037_OperationLT.cs:141 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7def2221 | this.Load | SCP0037_OperationLT.cs:142 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-30e11141 | this.Load | SCP0037_OperationLT.cs:143 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dataRow["OSP_YN"] | dr["OSP_YN"] | 행/컬럼 값 대입 |  |  |  |
| AC-e0953500 | this.Load | SCP0037_OperationLT.cs:144 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dataRow["OPERATION_GROUP"] | dr["OPERATION_GROUP"] | 행/컬럼 값 대입 |  |  |  |
| AC-c626357a | this.Load | SCP0037_OperationLT.cs:145 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | DATA_OP | dataRow["DIVISION_ID"] | dr["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fba33f63 | this.Load | SCP0037_OperationLT.cs:147 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in tmp.Rows) | CALL_EXT | dtPlantSite.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e586bdaf | this.Load | SCP0037_OperationLT.cs:151 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtMyDivisionIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-567ef129 | this.Load | SCP0037_OperationLT.cs:152 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivisionIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-848a5f19 | this.Load | SCP0037_OperationLT.cs:153 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtMyDivisionIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d2d0cd | this.Load | SCP0037_OperationLT.cs:157 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dtMyDivisionIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3654f1b7 | this.Load | SCP0037_OperationLT.cs:158 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-995b0646 | this.Load | SCP0037_OperationLT.cs:159 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | drRow["NAME"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bf923ef4 | this.Load | SCP0037_OperationLT.cs:160 | if (dtMyDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dtMyDivisionIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-18b9d3f1 | this.Load | SCP0037_OperationLT.cs:163 | if (dtMyDivision.Rows.Count > 0) | FLAG | dtEmpty | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7dc838ae | this.Load | SCP0037_OperationLT.cs:164 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtEmpty.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-57e08c14 | this.Load | SCP0037_OperationLT.cs:165 | if (dtMyDivision.Rows.Count > 0) | DATA_OP | dtEmpty.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |

## SCP0037_OperationLT.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1283cdde | DeleteButton | SCP0037_OperationLT.cs:291 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13cb1165 | DeleteButton | SCP0037_OperationLT.cs:296 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0037_OperationLT.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0436509d | Dispose | SCP0037_OperationLT.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0037_OperationLT.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c5c1073 | EditButton | SCP0037_OperationLT.cs:277 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7722206 | EditButton | SCP0037_OperationLT.cs:278 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-98035a7b | EditButton | SCP0037_OperationLT.cs:280 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.LT_OPERAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-41c9066e | EditButton | SCP0037_OperationLT.cs:281 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.SITE_ITEM_VALID_YN), siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0037_OperationLT.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c3d4409 | FindButton 외 1 | SCP0037_OperationLT.cs:313 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4d4449c7 | FindButton 외 1 | SCP0037_OperationLT.cs:316 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-3b539aa7 | FindButton 외 1 | SCP0037_OperationLT.cs:316 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-67455193 | FindButton 외 1 | SCP0037_OperationLT.cs:320 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-20a96337 | FindButton 외 1 | SCP0037_OperationLT.cs:333 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4bdf9abd | FindButton 외 1 | SCP0037_OperationLT.cs:334 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1f1ab55b | FindButton 외 1 | SCP0037_OperationLT.cs:338 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0037_GET_OPERATION_LT") ⇒ SCP.SCP0037_GET_OPERATION_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-453e02b3 | FindButton 외 1 | SCP0037_OperationLT.cs:339 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-85d9437f | FindButton 외 1 | SCP0037_OperationLT.cs:340 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bb420108 | FindButton 외 1 | SCP0037_OperationLT.cs:341 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8defc0ba | FindButton 외 1 | SCP0037_OperationLT.cs:342 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f967b805 | FindButton 외 1 | SCP0037_OperationLT.cs:343 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_valid_yn"] | p_scm_valid_yn.Equals("ALL") ? DBNull.Value : p_scm_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-32dae640 | FindButton 외 1 | SCP0037_OperationLT.cs:344 | try ▸ lambda | DATA_OP | request.Parameters["p_lt_operation"] | p_lt_operation | 행/컬럼 값 대입 |  |  |  |
| AC-3c5d0f8b | FindButton 외 1 | SCP0037_OperationLT.cs:346 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8d15f59 | FindButton 외 1 | SCP0037_OperationLT.cs:348 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e6fe5856 | FindButton 외 1 | SCP0037_OperationLT.cs:357 | try ▸ if (CString.GetCheckedListValue(dtOperationLT, cboLTOperation.ControlValues) == "PRE_INSP") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INV_FLAG)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-cc96dcc7 | FindButton 외 1 | SCP0037_OperationLT.cs:360 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-875112e7 | FindButton 외 1 | SCP0037_OperationLT.cs:361 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-acb2eff4 | FindButton 외 1 | SCP0037_OperationLT.cs:364 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1428790c | FindButton 외 1 | SCP0037_OperationLT.cs:376 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0037_OperationLT.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0e15165 | this.Load | SCP0037_OperationLT.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0037_OperationLT.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3910fda1 | this.Load | SCP0037_OperationLT.cs:171 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e1b4fda | this.Load | SCP0037_OperationLT.cs:174 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d3871e6e | this.Load | SCP0037_OperationLT.cs:176 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c895b737 | this.Load | SCP0037_OperationLT.cs:177 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationLT, cboLTOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-547e53a5 | this.Load | SCP0037_OperationLT.cs:178 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCP0037_OperationLT.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06c166de | this.Load 외 2 | SCP0037_OperationLT.cs:239 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-39b0f2fc | this.Load 외 2 | SCP0037_OperationLT.cs:240 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantByDivisionOperation", dtPlantSiteByDivisionForSpread) | 목록 컨트롤 재구성 |  |  |  |
| AC-aab39a90 | this.Load 외 2 | SCP0037_OperationLT.cs:241 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0d598e72 | this.Load 외 2 | SCP0037_OperationLT.cs:242 |  | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(DefColumns.LT_DAY), 1, 0, 100) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-74f5c5b1 | this.Load 외 2 | SCP0037_OperationLT.cs:246 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.INV_FLAG)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0037_OperationLT.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-417ea6e9 | InsertButton | SCP0037_OperationLT.cs:388 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9970d471 | InsertButton | SCP0037_OperationLT.cs:397 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d2d8626 | InsertButton | SCP0037_OperationLT.cs:398 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.SITE_ITEM_VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-5929f213 | InsertButton | SCP0037_OperationLT.cs:400 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefColumns.LT_OPERATION, pLTOperation) | 데이터 객체 조작/조회 |  |  |  |
| AC-2aecb27b | InsertButton | SCP0037_OperationLT.cs:402 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0098d754 | InsertButton | SCP0037_OperationLT.cs:403 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ab152cdc | InsertButton | SCP0037_OperationLT.cs:404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7692b493 | InsertButton | SCP0037_OperationLT.cs:405 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.NICK_NAME), siMain.GetColumnIndex(DefColumns.LT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21bb2dfd | InsertButton | SCP0037_OperationLT.cs:406 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.SITE_ITEM_VALID_YN), siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0037_OperationLT.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2a72234 | SaveButton | SCP0037_OperationLT.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.Rows.Co… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7851e3c0 | SaveButton | SCP0037_OperationLT.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-bb39ea8a | SaveButton | SCP0037_OperationLT.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfS… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d04b836 | SaveButton | SCP0037_OperationLT.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!checkValidN1()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c690144 | SaveButton | SCP0037_OperationLT.cs:476 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0037_SAVE_OPERATION_LT") ⇒ SCP.SCP0037_SAVE_OPERATION_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-5bc8f616 | SaveButton | SCP0037_OperationLT.cs:480 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4c95184 | SaveButton | SCP0037_OperationLT.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d11ec930 | SaveButton | SCP0037_OperationLT.cs:485 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2dfb24c | SaveButton | SCP0037_OperationLT.cs:486 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-df5ef629 | SaveButton | SCP0037_OperationLT.cs:487 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-dafebae4 | SaveButton | SCP0037_OperationLT.cs:488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_lt_operation"] | p_lt_operation | 행/컬럼 값 대입 |  |  |  |
| AC-94032c79 | SaveButton | SCP0037_OperationLT.cs:489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_lt_day"] | p_lt_day | 행/컬럼 값 대입 |  |  |  |
| AC-7d034fd9 | SaveButton | SCP0037_OperationLT.cs:490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-90b39794 | SaveButton | SCP0037_OperationLT.cs:491 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-476a22f1 | SaveButton | SCP0037_OperationLT.cs:492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-b0ccb317 | SaveButton | SCP0037_OperationLT.cs:493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_inv_flag"] | p_inv_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5fbeb847 | SaveButton | SCP0037_OperationLT.cs:496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-621d2364 | SaveButton | SCP0037_OperationLT.cs:496 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-cb77c64b | SaveButton | SCP0037_OperationLT.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1efd67f6 | SaveButton | SCP0037_OperationLT.cs:518 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81732923 | SaveButton | SCP0037_OperationLT.cs:522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0037_OperationLT.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / cboLTOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-237926cf | this.Load 외 2 | SCP0037_OperationLT.cs:192 | if (pLTOperation == "SLITTING") | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-629fc847 | this.Load 외 2 | SCP0037_OperationLT.cs:192 | if (pLTOperation == "SLITTING") | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = 'E'", t… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c95f8990 | this.Load 외 2 | SCP0037_OperationLT.cs:194 | if (pLTOperation == "SLITTING") | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d6079c6b | this.Load 외 2 | SCP0037_OperationLT.cs:198 | else of (pLTOperation == "SLITTING") ▸ if (pLTOperation == "PRE_INSP") | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-14ca887f | this.Load 외 2 | SCP0037_OperationLT.cs:198 | else of (pLTOperation == "SLITTING") ▸ if (pLTOperation == "PRE_INSP") | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = 'P'", t… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d4d60e6e | this.Load 외 2 | SCP0037_OperationLT.cs:200 | else of (pLTOperation == "SLITTING") ▸ if (pLTOperation == "PRE_INSP") | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32ac41cd | this.Load 외 2 | SCP0037_OperationLT.cs:204 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ if (pLTOperation == "OSP_LT") | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' OPERATION_GROUP… | 화면 필드/플래그 변경 |  |  |  |
| AC-8c83032f | this.Load 외 2 | SCP0037_OperationLT.cs:204 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ if (pLTOperation == "OSP_LT") | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' OPERATION_GROUP IN ('P', 'E')… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3f36d017 | this.Load 외 2 | SCP0037_OperationLT.cs:206 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ if (pLTOperation == "OSP_LT") | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-21f91b96 | this.Load 외 2 | SCP0037_OperationLT.cs:210 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ else of (pLTOperation == "OSP_LT") ▸ if (pLTOperation == "CTP_… | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_G… | 화면 필드/플래그 변경 |  |  |  |
| AC-2cfc720d | this.Load 외 2 | SCP0037_OperationLT.cs:210 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ else of (pLTOperation == "OSP_LT") ▸ if (pLTOperation == "CTP_… | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = 'A'", t… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-203f0da8 | this.Load 외 2 | SCP0037_OperationLT.cs:212 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ else of (pLTOperation == "OSP_LT") ▸ if (pLTOperation == "CTP_… | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8742f1d8 | this.Load 외 2 | SCP0037_OperationLT.cs:217 | else of (pLTOperation == "SLITTING") ▸ else of (pLTOperation == "PRE_INSP") ▸ else of (pLTOperation == "OSP_LT") ▸ else of (pLTOperation == … | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a6c64a87 | this.Load 외 2 | SCP0037_OperationLT.cs:222 | if (spdMain != null && spdMain.ActiveSheet != null && spdMain.ActiveSheet.Rows.Count > 0) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0037_OperationLT.setScmSiteId

진입점: spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID))] / spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (rDivisionID != "")] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-070a3bb7 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:880 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + pdivision + "' AND OSP_YN = 'N'" + " AND OPERATION_GROUP = '" + pOper… | 데이터 객체 조작/조회 |  |  |  |
| AC-477262c7 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:882 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7a05a3b1 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:883 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff76acc0 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:884 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-80cff24d | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:888 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-51e14baf | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:889 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-35a07a0b | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:890 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ foreach (DataRow dr in drArr) | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e1f02d1 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:891 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ foreach (DataRow dr in drArr) | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f4e6909 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:893 | if (null != pdivision && "" != pdivision) ▸ if (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") | GRID_COMBO | siMain.SetCellTypeCombo | (nRow, nCol, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-525c17f2 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:900 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + pdivision + "' AND OSP_YN = 'Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d01b92b | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:902 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-31e40509 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:903 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-26c3ecfb | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:904 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2348e2f6 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:908 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3613cb43 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:909 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7628583a | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:910 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5fa429f7 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:911 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f0a8eb9 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:913 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ if (pltopration == "OSP_LT"… | GRID_COMBO | siMain.SetCellTypeCombo | (nRow, nCol, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-504f67d0 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:918 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + pdivision + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-dec65a68 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:920 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ba16906 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:921 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c65de16a | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:922 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3e345fc | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:926 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5ff8708 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:927 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f49b519 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:928 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27a3f858 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:929 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3e57995 | spdMain.ComboSelChange [if (siMain.IsLock(siMain.SheetName) … 외 2 | SCP0037_OperationLT.cs:931 | if (null != pdivision && "" != pdivision) ▸ else of (pltopration == "SLITTING" \|\| pltopration == "PRE_INSP") ▸ else of (pltopration == "OS… | GRID_COMBO | siMain.SetCellTypeCombo | (nRow, nCol, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0037_OperationLT.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bcf7f2e | spdMain.CellClick | SCP0037_OperationLT.cs:539 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-158ef8db | spdMain.CellClick | SCP0037_OperationLT.cs:551 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f4a2ea7 | spdMain.CellClick | SCP0037_OperationLT.cs:556 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-ff58dabc | spdMain.CellClick | SCP0037_OperationLT.cs:573 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + division + "' AND OSP_YN = 'N'" + " AND OPERATION_GROUP = '" + pOpera… | 데이터 객체 조작/조회 |  |  |  |
| AC-881f58ec | spdMain.CellClick | SCP0037_OperationLT.cs:575 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-a8f6c839 | spdMain.CellClick | SCP0037_OperationLT.cs:576 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-01b76861 | spdMain.CellClick | SCP0037_OperationLT.cs:577 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-167910f9 | spdMain.CellClick | SCP0037_OperationLT.cs:581 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-102ec014 | spdMain.CellClick | SCP0037_OperationLT.cs:582 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a1b4e3a | spdMain.CellClick | SCP0037_OperationLT.cs:583 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7817a8ec | spdMain.CellClick | SCP0037_OperationLT.cs:584 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab1165bd | spdMain.CellClick | SCP0037_OperationLT.cs:586 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b16021fd | spdMain.CellClick | SCP0037_OperationLT.cs:592 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + division + "' AND OSP_YN = 'Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d197881 | spdMain.CellClick | SCP0037_OperationLT.cs:594 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-226c3dee | spdMain.CellClick | SCP0037_OperationLT.cs:595 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-da9246c4 | spdMain.CellClick | SCP0037_OperationLT.cs:596 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a35604a | spdMain.CellClick | SCP0037_OperationLT.cs:600 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-08e320de | spdMain.CellClick | SCP0037_OperationLT.cs:601 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04af727b | spdMain.CellClick | SCP0037_OperationLT.cs:602 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af767172 | spdMain.CellClick | SCP0037_OperationLT.cs:603 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b50ba31 | spdMain.CellClick | SCP0037_OperationLT.cs:605 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-61d899f2 | spdMain.CellClick | SCP0037_OperationLT.cs:610 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + division + "' AND OSP_YN = 'N'" + " AND OPERATION_GROUP = '" + pOpera… | 데이터 객체 조작/조회 |  |  |  |
| AC-f016c93c | spdMain.CellClick | SCP0037_OperationLT.cs:612 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-4b090af2 | spdMain.CellClick | SCP0037_OperationLT.cs:613 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e38524a | spdMain.CellClick | SCP0037_OperationLT.cs:614 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3cae738b | spdMain.CellClick | SCP0037_OperationLT.cs:618 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f612cb64 | spdMain.CellClick | SCP0037_OperationLT.cs:619 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f52ecb80 | spdMain.CellClick | SCP0037_OperationLT.cs:620 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a5667b13 | spdMain.CellClick | SCP0037_OperationLT.cs:621 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-38863ac5 | spdMain.CellClick | SCP0037_OperationLT.cs:623 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-31aaed54 | spdMain.CellClick | SCP0037_OperationLT.cs:631 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSite.Select | ("DIVISION_ID = '" + division + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-26bf0a91 | spdMain.CellClick | SCP0037_OperationLT.cs:633 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | FLAG | dtPlantSiteByDivisionForIns | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-39b86609 | spdMain.CellClick | SCP0037_OperationLT.cs:634 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9790585 | spdMain.CellClick | SCP0037_OperationLT.cs:635 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c80fef | spdMain.CellClick | SCP0037_OperationLT.cs:639 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c0be65d | spdMain.CellClick | SCP0037_OperationLT.cs:640 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["CODE"] | dr["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b1c06342 | spdMain.CellClick | SCP0037_OperationLT.cs:641 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | drRow["NAME"] | dr["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-12bd65f5 | spdMain.CellClick | SCP0037_OperationLT.cs:642 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | DATA_OP | dtPlantSiteByDivisionForIns.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1cebc09 | spdMain.CellClick | SCP0037_OperationLT.cs:644 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, e.Column, dtPlantSiteByDivisionForIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-c083be00 | spdMain.CellClick | SCP0037_OperationLT.cs:653 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), dtMyDivisionIns) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7e51e9a6 | spdMain.CellClick | SCP0037_OperationLT.cs:654 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), divisionId) | 그리드 값 설정 |  |  |  |
| AC-19c04590 | spdMain.CellClick | SCP0037_OperationLT.cs:664 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Div" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-042bccd7 | spdMain.CellClick | SCP0037_OperationLT.cs:665 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-195b7ec0 | spdMain.CellClick | SCP0037_OperationLT.cs:671 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Plant Site" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49c8bfb6 | spdMain.CellClick | SCP0037_OperationLT.cs:672 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8be10904 | spdMain.CellClick | SCP0037_OperationLT.cs:676 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-820f0afc | spdMain.CellClick | SCP0037_OperationLT.cs:681 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | new SCM0002_ItembyPlantSitePopup | () | 팝업/폼 생성 |  |  |  |
| AC-e26d3c7c | spdMain.CellClick | SCP0037_OperationLT.cs:683 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | popItem.Form_Load | (false, "N", division, sScmSite, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-310139ba | spdMain.CellClick | SCP0037_OperationLT.cs:684 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3f343276 | spdMain.CellClick | SCP0037_OperationLT.cs:685 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-aabd6736 | spdMain.CellClick | SCP0037_OperationLT.cs:689 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), popItem.ItemID) | 그리드 값 설정 |  |  |  |
| AC-0ae85f37 | spdMain.CellClick | SCP0037_OperationLT.cs:690 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), popItem.NickName) | 그리드 값 설정 |  |  |  |

## SCP0037_OperationLT.SpdMain_ClipboardPasted

진입점: spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3b30c1b | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:743 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fd65bc1 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:746 | if (siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a2db14e | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:763 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-dbdefd97 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:766 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-d001b36f | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:776 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | DATA_OP | dtPlantSiteByDivisionForIns.Select | ("CODE = '" + rScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-df744889 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:779 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), rScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-fc7f5726 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:780 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), rScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-95922a6f | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:785 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtEmpty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-10e26e92 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:793 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-91f2ce4a | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:802 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | DATA_OP | dtPlantSiteByDivisionForIns.Select | ("CODE = '" + rScmSiteId + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-49e5e467 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:805 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), rScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-6e51c7d5 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:806 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), rScmSiteId) | 그리드 값 설정 |  |  |  |
| AC-7449387f | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:810 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-055a33d1 | spdMain.ClipboardPasted | SCP0037_OperationLT.cs:817 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |

## SCP0037_OperationLT.SpdMain_ComboSelChange

진입점: spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e33b961b | spdMain.ComboSelChange | SCP0037_OperationLT.cs:699 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0e066529 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:705 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-0fb6c17e | spdMain.ComboSelChange | SCP0037_OperationLT.cs:706 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-fc202fb1 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:707 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-70f70673 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:708 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ if (e.Colum… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), "") | 그리드 값 설정 |  |  |  |
| AC-c0d720f8 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:718 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-39f24c61 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:719 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-fd944825 | spdMain.ComboSelChange | SCP0037_OperationLT.cs:721 | if (siMain.IsLock(siMain.SheetName) == false && siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) == CA…) ▸ else of (e.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PLANT_SITE_ID), siMain.GetValue(e.Row, siMain.Get… | 그리드 값 설정 |  |  |  |

## SCP0037_OperationLT.SpdMain_KeyPress

진입점: spdMain.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f27962bd | spdMain.KeyPress | SCP0037_OperationLT.cs:732 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-f7625251 | spdMain.KeyPress | SCP0037_OperationLT.cs:734 | if (!fps.ActiveSheet.Cells[fps.ActiveSheet.ActiveRow.Index, fps.ActiveSheet.ActiveColumn.Index].Locked) ▸ if (fps.ActiveSheet.Columns[fps.Ac… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

