# AS-IS 액션 대조표 — SCP0047

> 원천: `Doc/asisfacts/screens/SCP0047/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 104행 · 메서드 14 · 종류 DATA_OP 39 · UI_MISC 10 · GRID_INIT 8 · FLAG 7 · RETURN 7 · UI_PROP 6 · ENDPOINT 6 · MESSAGE 4 · GRID_LOCK 3 · POPUP 3 · VALIDATE 2 · LIST_REBIND 2 · COMBO_DATA 2 · GRID_SET 2 · GRID_CLEAR 1 · GRID_BIND 1 · CALL_EXT 1 · ⚠ 의미 확인 필요 1


## SCP0047_KPI_Target.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eb166f0 | this.Load | SCP0047_KPI_Target.cs:163 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3fc7e3a4 | this.Load | SCP0047_KPI_Target.cs:164 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb87250a | this.Load | SCP0047_KPI_Target.cs:165 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0047_KPI_Target.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b5c93d4 | Dispose | SCP0047_KPI_Target.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0047_KPI_Target.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a53d53f3 | EditButton | SCP0047_KPI_Target.cs:229 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-970650c8 | EditButton | SCP0047_KPI_Target.cs:230 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-597fe714 | EditButton | SCP0047_KPI_Target.cs:232 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.KPI_NM), siMain.GetColumnIndex(DefColumns.DEPT_ID), true… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0047_KPI_Target.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e7bac8 | FindButton 외 1 | SCP0047_KPI_Target.cs:250 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-fc28c65f | FindButton 외 1 | SCP0047_KPI_Target.cs:251 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-17561651 | FindButton 외 1 | SCP0047_KPI_Target.cs:255 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-df0beb69 | FindButton 외 1 | SCP0047_KPI_Target.cs:255 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ccaa7a49 | FindButton 외 1 | SCP0047_KPI_Target.cs:259 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f32bd82a | FindButton 외 1 | SCP0047_KPI_Target.cs:274 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-12b8158c | FindButton 외 1 | SCP0047_KPI_Target.cs:276 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var request… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e572b2d | FindButton 외 1 | SCP0047_KPI_Target.cs:280 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0047_GET_KPI_TARGET") ⇒ SCP.SCP0047_GET_KPI_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-904966f5 | FindButton 외 1 | SCP0047_KPI_Target.cs:282 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1de206a5 | FindButton 외 1 | SCP0047_KPI_Target.cs:284 | try ▸ lambda | DATA_OP | request.Parameters["p_kpi_id"] | pKpi_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4c6b77b | FindButton 외 1 | SCP0047_KPI_Target.cs:285 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-89ffdfac | FindButton 외 1 | SCP0047_KPI_Target.cs:286 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-e1e1f478 | FindButton 외 1 | SCP0047_KPI_Target.cs:287 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-898afb8d | FindButton 외 1 | SCP0047_KPI_Target.cs:288 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ac30ffad | FindButton 외 1 | SCP0047_KPI_Target.cs:290 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a69d7e56 | FindButton 외 1 | SCP0047_KPI_Target.cs:292 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4661cce4 | FindButton 외 1 | SCP0047_KPI_Target.cs:299 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bbca6c2c | FindButton 외 1 | SCP0047_KPI_Target.cs:300 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4fabefd4 | FindButton 외 1 | SCP0047_KPI_Target.cs:303 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a7d796b1 | FindButton 외 1 | SCP0047_KPI_Target.cs:305 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9ac5ccd4 | FindButton 외 1 | SCP0047_KPI_Target.cs:306 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5dc0bf02 | FindButton 외 1 | SCP0047_KPI_Target.cs:317 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0047_KPI_Target.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7846912e | this.Load | SCP0047_KPI_Target.cs:95 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0047_KPI_Target.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b8eda42 | this.Load | SCP0047_KPI_Target.cs:125 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-c1bcc565 | this.Load | SCP0047_KPI_Target.cs:127 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1bae43c4 | this.Load | SCP0047_KPI_Target.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-60076341 | this.Load | SCP0047_KPI_Target.cs:133 |  | DATA_OP | dtKPI.DefaultView.ToTable | (true, "KPI_ID", "KPI_NM") | 데이터 객체 조작/조회 |  |  |  |
| AC-690556d3 | this.Load | SCP0047_KPI_Target.cs:135 |  | FLAG | dtMyKPI | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-3114805e | this.Load | SCP0047_KPI_Target.cs:136 |  | DATA_OP | dtMyKPI.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-49ba4d57 | this.Load | SCP0047_KPI_Target.cs:137 |  | DATA_OP | dtMyKPI.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-56d9b6ef | this.Load | SCP0047_KPI_Target.cs:141 | foreach (DataRow row in tmpKPI.Rows) | DATA_OP | dtMyKPI.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f5fcb47b | this.Load | SCP0047_KPI_Target.cs:142 | foreach (DataRow row in tmpKPI.Rows) | DATA_OP | drRow["CODE"] | row["KPI_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-23e9671f | this.Load | SCP0047_KPI_Target.cs:143 | foreach (DataRow row in tmpKPI.Rows) | DATA_OP | drRow["NAME"] | row["KPI_NM"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9d61dc9 | this.Load | SCP0047_KPI_Target.cs:144 | foreach (DataRow row in tmpKPI.Rows) | DATA_OP | dtMyKPI.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-c11dd0e5 | this.Load | SCP0047_KPI_Target.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyKPI, cboKPI, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7152642c | this.Load | SCP0047_KPI_Target.cs:154 |  | UI_PROP | drpPeriod.MonthText2 | toDate | 속성 MonthText2 설정 |  |  |  |

## SCP0047_KPI_Target.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8b7631f | this.Load | SCP0047_KPI_Target.cs:109 |  | FLAG | dsdm | (FarPoint.Win.Spread.Model.DefaultSheetDataModel)siMain.Sheet(SpdSheet.shtMain).Models.Dat… | 화면 필드/플래그 변경 |  |  |  |

## SCP0047_KPI_Target.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-101c2e23 | this.Load 외 2 | SCP0047_KPI_Target.cs:174 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9af4cc43 | this.Load 외 2 | SCP0047_KPI_Target.cs:175 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-776a835b | this.Load 외 2 | SCP0047_KPI_Target.cs:178 | if (spreadInfo.SheetName == SpdSheet.shtMain) | UI_PROP | spreadInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |

## SCP0047_KPI_Target.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c685a7a | SaveButton | SCP0047_KPI_Target.cs:458 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2a083f0e | SaveButton | SCP0047_KPI_Target.cs:465 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f07514b | SaveButton | SCP0047_KPI_Target.cs:475 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ed63693 | SaveButton | SCP0047_KPI_Target.cs:476 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_kpi_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-eee49753 | SaveButton | SCP0047_KPI_Target.cs:477 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9c6769 | SaveButton | SCP0047_KPI_Target.cs:478 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_dept_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-70aef70a | SaveButton | SCP0047_KPI_Target.cs:479 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_yyyymm") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cd1f131 | SaveButton | SCP0047_KPI_Target.cs:480 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_kpi_target") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0d79b15 | SaveButton | SCP0047_KPI_Target.cs:481 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-95077862 | SaveButton | SCP0047_KPI_Target.cs:483 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-207e926c | SaveButton | SCP0047_KPI_Target.cs:557 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0e12a9f | SaveButton | SCP0047_KPI_Target.cs:560 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_active_flag"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-46b2f7c0 | SaveButton | SCP0047_KPI_Target.cs:564 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_active_flag"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-fce7b8fb | SaveButton | SCP0047_KPI_Target.cs:566 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_kpi_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.KPI_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85b2106d | SaveButton | SCP0047_KPI_Target.cs:567 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f46daf1 | SaveButton | SCP0047_KPI_Target.cs:568 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_dept_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DEPT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-426ee566 | SaveButton | SCP0047_KPI_Target.cs:569 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_yyyymm"] | strMonthName | 행/컬럼 값 대입 |  |  |  |
| AC-89862a8a | SaveButton | SCP0047_KPI_Target.cs:570 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_kpi_target"] | strMonthTarget | 행/컬럼 값 대입 |  |  |  |
| AC-355af39b | SaveButton | SCP0047_KPI_Target.cs:571 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e161bcb8 | SaveButton | SCP0047_KPI_Target.cs:572 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Co… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-70029061 | SaveButton | SCP0047_KPI_Target.cs:581 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e0f2afa6 | SaveButton | SCP0047_KPI_Target.cs:596 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0047", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-076cfecb | SaveButton | SCP0047_KPI_Target.cs:597 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveKPITarget") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveKPITarget] \| SCP\M… | 엔드포인트 호출 |  |  |  |
| AC-2b3596da | SaveButton | SCP0047_KPI_Target.cs:600 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-511dbd5e | SaveButton | SCP0047_KPI_Target.cs:605 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try ▸ if (result != null && result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount.ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aef498d3 | SaveButton | SCP0047_KPI_Target.cs:614 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try ▸ else of (result != null && r… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9beb3c3b | SaveButton | SCP0047_KPI_Target.cs:623 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a40d9963 | SaveButton | SCP0047_KPI_Target.cs:624 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-690425a0 | SaveButton | SCP0047_KPI_Target.cs:631 | try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-804015bf | SaveButton | SCP0047_KPI_Target.cs:642 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-be080845 | SaveButton | SCP0047_KPI_Target.cs:644 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-658245b9 | SaveButton | SCP0047_KPI_Target.cs:648 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0047_KPI_Target.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4d834e0 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:738 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-50bbef72 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:739 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-aacf72c9 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:740 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-23a34d01 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:741 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-c75ba46a | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:742 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-8d345d41 | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:743 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-9ca9722e | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:744 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-e087a58a | SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain… | SCP0047_KPI_Target.cs:746 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0047_KPI_Target.SetCalendar

진입점: this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] / FindButton [try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)] / SaveButton [try ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0 && sccsCount==1) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9d7fc6 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:186 |  | FLAG | dtCalendar | Data.Common(Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeri… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 화면 필드/플래그 변경 |  |  |  |
| AC-155f0443 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:186 |  | COMBO_DATA | Data.Common | (Data.Type.CalendarMonth, false, drpPeriod.MonthText1.Replace("-", ""), drpPeriod.MonthTex… ⇒ biz:CommonData.CommonDataList [code=CalendarMonth] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7ac473d | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:192 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fd28773 | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:193 | foreach (var a in dtCalendar.AsEnumerable()) | DATA_OP | a.Field | (DefColumns.YYYYMM_NAME) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9cc509b | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:195 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | spreadinfo.AddNumColumn | (sYYYYMM_NAME, sYYYYMM, FPMerge.None, 75, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-829067cc | this.Load [if (spreadInfo.SheetName == SpdSheet.shtMain)] 외 2 | SCP0047_KPI_Target.cs:197 | foreach (var a in dtCalendar.AsEnumerable()) | GRID_INIT | siMain.SetReNumerCellType | (siMain, siMain.GetColumnIndex(sYYYYMM), -9999999999, 1, 100) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0047_KPI_Target.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0e38469 | this.Load | SCP0047_KPI_Target.cs:675 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c6366b72 | this.Load | SCP0047_KPI_Target.cs:678 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d3f03f8 | this.Load | SCP0047_KPI_Target.cs:682 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthText1 설정 |  |  |  |
| AC-edbcc39e | this.Load | SCP0047_KPI_Target.cs:683 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-4750471c | this.Load | SCP0047_KPI_Target.cs:685 | if (dt.Rows.Count > 0) | FLAG | base_yyyymm | drpPeriod.MonthText1.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |

## SCP0047_KPI_Target.spdMain_Change

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcc2c6da | dsdm.Changed | SCP0047_KPI_Target.cs:696 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == 0 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-511db0d7 | dsdm.Changed | SCP0047_KPI_Target.cs:697 | if (siMain.ActiveSheet.Columns[e.Column].Tag.ToString().IndexOf("M_") < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d2fb079 | dsdm.Changed | SCP0047_KPI_Target.cs:698 | if (siMain.IsLock(siMain.SheetName) != false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b068d430 | dsdm.Changed | SCP0047_KPI_Target.cs:711 | if (siMain.GetValue(nRow, nCol) == null \|\| siMain.GetValue(nRow, nCol).ToString() == "") | GRID_SET | siMain.ActiveSheet.Cells[nRow, nCol].ForeColor | Color.Beige | 그리드 속성/값 설정 |  |  |  |
| AC-8d83265f | dsdm.Changed | SCP0047_KPI_Target.cs:715 | else of (siMain.GetValue(nRow, nCol) == null \|\| siMain.GetValue(nRow, nCol).ToString() == "") | GRID_SET | siMain.ActiveSheet.Cells[nRow, nCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SCP0047_KPI_Target.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca2852c1 | this.spdMain.TopChange | SCP0047_KPI_Target.cs:204 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

