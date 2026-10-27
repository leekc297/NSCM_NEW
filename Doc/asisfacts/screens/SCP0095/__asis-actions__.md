# AS-IS 액션 대조표 — SCP0095

> 원천: `Doc/asisfacts/screens/SCP0095/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 185행 · 메서드 38 · 종류 DATA_OP 52 · GRID_INIT 22 · RETURN 22 · UI_PROP 16 · CALL_EXT 14 · GRID_SET 9 · UI_MISC 8 · FLAG 8 · ENDPOINT 8 · VALUE_SET 6 · LIST_REBIND 5 · POPUP 4 · VALIDATE 3 · GRID_BIND 2 · GRID_LOCK 2 · MESSAGE 1 · GRID_CLEAR 1 · GRID_STYLE 1 · CALL_BASE 1 · ⚠ 의미 확인 필요 15


## SCP0095_GlobalPSI_Elec.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64d0b34a | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:666 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1e393bff | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:668 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f5966142 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:670 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d1de38c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:679 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.AfterFindDataParallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ff6451c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:696 | foreach (DataSet d in lst) | DATA_OP | tbls.Add | (d.Tables[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9fe853d | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:714 |  | CALL_EXT | DBUtils.MergeAll | (tbls, keyColumns) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42fa43d9 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:716 |  | DATA_OP | t.AsEnumerable() .OrderBy(r => r.Field<string>("COMPANY_ID")) .ThenBy(r => r.Field<string>… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3ccf1f8 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:716 |  | CALL_EXT | t.AsEnumerable() .OrderBy(r => r.Field<string>("COMPANY_ID")) .ThenBy(r => r.Field<string>… | (r => { switch (r.Field<string>("PSI")) { case "": return 0; case "S": return 1; case "P":… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e38d3475 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:716 |  | CALL_EXT | t.AsEnumerable() .OrderBy(r => r.Field<string>("COMPANY_ID")) .ThenBy(r => r.Field<string>… | (r => int.Parse(r.Field<string>("SORT_ORDER_NO"))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-587afeff | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:716 |  | CALL_EXT | t.AsEnumerable() .OrderBy(r => r.Field<string>("COMPANY_ID")).ThenBy | (r => r.Field<string>("ELEC_MODEL")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-185c63e2 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:717 | lambda | DATA_OP | r.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e33062a9 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:718 | lambda | DATA_OP | r.Field | ("ELEC_MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e71276ac | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:719 | lambda | DATA_OP | r.Field | ("SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-54db5cd1 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:722 | lambda | DATA_OP | r.Field | ("PSI") | 데이터 객체 조작/조회 |  |  |  |
| AC-30d0782b | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:724 | lambda ▸ switch (r.Field<string>("PSI")) case "": | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-8f8e51e3 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:725 | lambda ▸ switch (r.Field<string>("PSI")) case "S": | RETURN | return 1; |  | 처리 중단/반환 |  |  |  |
| AC-df30be8f | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:726 | lambda ▸ switch (r.Field<string>("PSI")) case "P": | RETURN | return 2; |  | 처리 중단/반환 |  |  |  |
| AC-18fe9dc6 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:727 | lambda ▸ switch (r.Field<string>("PSI")) case "I": | RETURN | return 3; |  | 처리 중단/반환 |  |  |  |
| AC-53c80035 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:729 | lambda | RETURN | return 5; |  | 처리 중단/반환 |  |  |  |
| AC-60080f3a | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:733 |  | DATA_OP | ds.Tables.Add | (result) | 데이터 객체 조작/조회 |  |  |  |
| AC-20dfc869 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:735 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4468ef1c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:737 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-42058527 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:739 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-13796557 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:748 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.btnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-984fcb04 | this.btnItem_Id.Click | SCP0095_GlobalPSI_Elec.cs:1026 |  | POPUP | new SCM0002_ItembyDivisionPopupEE | (true, this._division, this._company, this._item_id) | 팝업/폼 생성 |  |  |  |
| AC-af6c1fc7 | this.btnItem_Id.Click | SCP0095_GlobalPSI_Elec.cs:1028 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-01c061b3 | this.btnItem_Id.Click | SCP0095_GlobalPSI_Elec.cs:1030 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-85df1aad | this.btnItem_Id.Click | SCP0095_GlobalPSI_Elec.cs:1032 | if (pop.ShowDialog() == DialogResult.OK) | VALUE_SET | txtItem_Id.Text | pop.ItemId | 컨트롤 값 설정 |  |  |  |

## SCP0095_GlobalPSI_Elec.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69b62a8f | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:527 | if (fps == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00007", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6cc0a9a5 | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:528 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-232a81ea | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:531 |  | POPUP | new SCM0002_TitleSetForm_Popup | (this._program_id, this._sheet_name, false) | 팝업/폼 생성 |  |  |  |
| AC-3e8a6c8a | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:533 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a0ec6619 | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:535 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-11d88692 | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:539 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-a962ee7f | this.btnMeasure.Click | SCP0095_GlobalPSI_Elec.cs:543 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0095_GlobalPSI_Elec.CboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b642aa3 | this.cboDivision.SelectedIndexChanged | SCP0095_GlobalPSI_Elec.cs:552 |  | FLAG | bChgDiv | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0095_GlobalPSI_Elec.CboPlanDate_SelectedIndexChanged

진입점: this.cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b90be78d | this.cboPlanDate.SelectedIndexChanged | SCP0095_GlobalPSI_Elec.cs:557 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |
| AC-e42ed894 | this.cboPlanDate.SelectedIndexChanged | SCP0095_GlobalPSI_Elec.cs:558 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0095_GlobalPSI_Elec.CheckKeyColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-724d6b18 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:684 |  | DATA_OP | tbl.Columns.Contains | (colName) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc67806c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:685 | if (tbl.Columns.Contains(colName)) | DATA_OP | keyColumns.Add | (colName) | 데이터 객체 조작/조회 |  |  |  |

## SCP0095_GlobalPSI_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ad50f4c | this.Load | SCP0095_GlobalPSI_Elec.cs:403 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-018c03da | this.Load | SCP0095_GlobalPSI_Elec.cs:405 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e00401c5 | this.Load | SCP0095_GlobalPSI_Elec.cs:407 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2d7f690 | this.Load | SCP0095_GlobalPSI_Elec.cs:320 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-066562a0 | this.Load | SCP0095_GlobalPSI_Elec.cs:322 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-2bb21962 | this.Load | SCP0095_GlobalPSI_Elec.cs:324 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-50183936 | this.Load | SCP0095_GlobalPSI_Elec.cs:325 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-1b6bf17b | this.Load | SCP0095_GlobalPSI_Elec.cs:326 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0095_GlobalPSI_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-551a7dfb | Dispose | SCP0095_GlobalPSI_Elec.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0095_GlobalPSI_Elec.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc799ad7 | FindButton | SCP0095_GlobalPSI_Elec.cs:643 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-d4e128ec | FindButton | SCP0095_GlobalPSI_Elec.cs:644 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-770b1eca | FindButton | SCP0095_GlobalPSI_Elec.cs:646 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-8c35e341 | FindButton | SCP0095_GlobalPSI_Elec.cs:647 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.FindDataMain

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2fd1c9f | FindButton | SCP0095_GlobalPSI_Elec.cs:755 | if (this.QueryDics[DIC_GLOBAL_PSI_ELEC].Count > 0) | CALL_EXT | this.QueryDics[DIC_GLOBAL_PSI_ELEC].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-45bf4ecc | FindButton | SCP0095_GlobalPSI_Elec.cs:760 |  | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpread | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-a39b261d | FindButton | SCP0095_GlobalPSI_Elec.cs:761 |  | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-318a28c2 | FindButton | SCP0095_GlobalPSI_Elec.cs:762 |  | UI_PROP | qi.ServiceUri | GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-dd922925 | FindButton | SCP0095_GlobalPSI_Elec.cs:763 |  | UI_PROP | qi.QueryId | "SCP.SCP0095_GET_GLOBAL_PSI_ELEC" | 속성 QueryId 설정 |  |  |  |
| AC-c5af3bd5 | FindButton | SCP0095_GlobalPSI_Elec.cs:765 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-654fb6ec | FindButton | SCP0095_GlobalPSI_Elec.cs:766 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company", this._company)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4c796a4 | FindButton | SCP0095_GlobalPSI_Elec.cs:767 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-08e6ee97 | FindButton | SCP0095_GlobalPSI_Elec.cs:768 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_yyyymmdd", this._plan_start_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f290b287 | FindButton | SCP0095_GlobalPSI_Elec.cs:769 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-091dbb78 | FindButton | SCP0095_GlobalPSI_Elec.cs:770 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17f379b4 | FindButton | SCP0095_GlobalPSI_Elec.cs:771 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_plan_type", this._plan_type)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99f0ba75 | FindButton | SCP0095_GlobalPSI_Elec.cs:772 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", this._program_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e219caf | FindButton | SCP0095_GlobalPSI_Elec.cs:773 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-51a28b20 | FindButton | SCP0095_GlobalPSI_Elec.cs:774 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d22c2852 | FindButton | SCP0095_GlobalPSI_Elec.cs:775 |  | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-32276773 | FindButton | SCP0095_GlobalPSI_Elec.cs:777 |  | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_ELEC] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-fc664734 | FindButton | SCP0095_GlobalPSI_Elec.cs:780 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_GLOBAL_PSI_ELEC, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0095_GlobalPSI_Elec.FindDataMainParallel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e86f0645 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:787 | if (this.QueryDics[DIC_GLOBAL_PSI_ELEC].Count > 0) | CALL_EXT | this.QueryDics[DIC_GLOBAL_PSI_ELEC].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d90a34d | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:796 | for (i <= terms.Count-1) | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpread | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-8272459c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:797 | for (i <= terms.Count-1) | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindDataParallel | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-c6c4b35b | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:798 | for (i <= terms.Count-1) | UI_PROP | qi.ServiceUri | GSCM_SCP_ANALYSIS_SVC | 속성 ServiceUri 설정 |  |  |  |
| AC-cbfd21cd | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:799 | for (i <= terms.Count-1) | UI_PROP | qi.QueryId | "SCP.SCP0095_GET_GLOBAL_PSI_ELEC" | 속성 QueryId 설정 |  |  |  |
| AC-a7eb21ad | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:801 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62c4bbe9 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:802 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_company", this._company)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc237a35 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:803 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._item_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b89c25a6 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:804 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_yyyymmdd", this._plan_start_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e5e38ab | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:805 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", terms[i].FromYYYYMMDD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7333381e | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:806 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", terms[i].ToYYYYMMDD)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac4a9baa | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:807 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_program_id", this._program_id)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6c7a694 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:808 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_sheet_name", this._sheet_name)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd238a71 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:809 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", UserInfoContext.Current.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-234db0ff | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:810 | for (i <= terms.Count-1) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f35199b | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:815 | for (i <= terms.Count-1) ▸ if (i == 0) | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_ELEC] | new List<QueryInfo>() | 행/컬럼 값 대입 |  |  |  |
| AC-e08e3f3b | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:818 | for (i <= terms.Count-1) | DATA_OP | this.QueryDics[DIC_GLOBAL_PSI_ELEC].Add | (qi) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbf7d30 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:821 |  | ENDPOINT | this.ExecuteSQL | (siMain, DIC_GLOBAL_PSI_ELEC, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0095_GlobalPSI_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2b93af8 | this.Load | SCP0095_GlobalPSI_Elec.cs:307 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0095_GlobalPSI_Elec.getBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57587e38 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:198 |  | RETURN | return cboBucketType.SelectedValue.ToString(); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62642119 | this.Load | SCP0095_GlobalPSI_Elec.cs:393 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-f8384ed0 | this.Load | SCP0095_GlobalPSI_Elec.cs:395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b81b248f | this.Load | SCP0095_GlobalPSI_Elec.cs:398 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getCellValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22e97af5 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:1049 | try ▸ if (col > -1) | CALL_EXT | siMain.GetValue2 | (row, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afd5ae25 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:1056 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getCompany

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-606df72c | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:168 |  | RETURN | return CString.GetCheckedListValue(dtCompanyAll, cboCompany.TextList, true); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.GetDayRange

진입점: this.Load / this.cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ac1d25f | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:830 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6c68498f | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:831 |  | DATA_OP | request.Parameters["p_from_date"] | this._plan_start_yyyymmdd == null ? "" : _plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3311342c | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:832 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-eb366389 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:833 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-f7e49b0e | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:835 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d6596783 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:837 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-539bd8da | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:153 |  | RETURN | return CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a1389a4 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:214 |  | RETURN | return dCalendar.Text1.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getItemId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c03aa30 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:183 |  | RETURN | return txtItem_Id.Text.Trim(); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getPlanDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-384f108d | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:262 |  | RETURN | return cboPlanDate.ControlValues; |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.getPlanType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73f6c9a6 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:243 |  | RETURN | return cboPlanType.SelectedValue.ToString(); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.GetSpdTitle

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac9e7a3 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:956 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-6fc10762 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:957 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | this._from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f6e2dec9 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:958 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | this._to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4f7458f7 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:960 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-83a151cf | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:960 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0095_GlobalPSI_Elec.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae2c6af6 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:228 |  | RETURN | return dCalendar.Text2.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0095_GlobalPSI_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ef58de7 | this.Load | SCP0095_GlobalPSI_Elec.cs:361 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-6e1ff17d | this.Load | SCP0095_GlobalPSI_Elec.cs:363 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8970d733 | this.Load | SCP0095_GlobalPSI_Elec.cs:365 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a511d808 | this.Load | SCP0095_GlobalPSI_Elec.cs:369 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-535a5635 | this.Load | SCP0095_GlobalPSI_Elec.cs:370 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fe0ef93c | this.Load | SCP0095_GlobalPSI_Elec.cs:372 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0095_GlobalPSI_Elec.InitPlanType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23572208 | this.Load | SCP0095_GlobalPSI_Elec.cs:333 |  | FLAG | dtPlanType | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-e8d78a72 | this.Load | SCP0095_GlobalPSI_Elec.cs:334 |  | DATA_OP | dtPlanType.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3458b9fc | this.Load | SCP0095_GlobalPSI_Elec.cs:335 |  | DATA_OP | dtPlanType.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9914dc21 | this.Load | SCP0095_GlobalPSI_Elec.cs:337 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b72b270b | this.Load | SCP0095_GlobalPSI_Elec.cs:338 |  | DATA_OP | r1["CODE"] | "MA" | 행/컬럼 값 대입 |  |  |  |
| AC-27f01623 | this.Load | SCP0095_GlobalPSI_Elec.cs:339 |  | DATA_OP | r1["NAME"] | "MA" | 행/컬럼 값 대입 |  |  |  |
| AC-0d33828a | this.Load | SCP0095_GlobalPSI_Elec.cs:341 |  | DATA_OP | dtPlanType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f33f0e8 | this.Load | SCP0095_GlobalPSI_Elec.cs:342 |  | DATA_OP | r2["CODE"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-577a27a6 | this.Load | SCP0095_GlobalPSI_Elec.cs:343 |  | DATA_OP | r2["NAME"] | "FN" | 행/컬럼 값 대입 |  |  |  |
| AC-e4462602 | this.Load | SCP0095_GlobalPSI_Elec.cs:345 |  | DATA_OP | dtPlanType.Rows.Add | (r1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cd6794d | this.Load | SCP0095_GlobalPSI_Elec.cs:346 |  | DATA_OP | dtPlanType.Rows.Add | (r2) | 데이터 객체 조작/조회 |  |  |  |
| AC-05184ed6 | this.Load | SCP0095_GlobalPSI_Elec.cs:348 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ee95b9e0 | this.Load | SCP0095_GlobalPSI_Elec.cs:351 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-c9ba33a3 | this.Load | SCP0095_GlobalPSI_Elec.cs:354 |  | VALUE_SET | esiPlanType.Text | MessageHelper.GetMessageInfo("MSG00411", UserInfoContext.Current[UserInfoProperites.Langua… | 컨트롤 값 설정 |  |  |  |
| AC-153a53c6 | this.Load | SCP0095_GlobalPSI_Elec.cs:354 |  | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00411", UserInfoContext.Current[UserInfoProperites.Language]) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0095_GlobalPSI_Elec.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b37a7b7 | this.Load | SCP0095_GlobalPSI_Elec.cs:302 |  | DATA_OP | QueryDics.Add | (DIC_GLOBAL_PSI_ELEC, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0095_GlobalPSI_Elec.InitSpread_2

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0dd2786 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:414 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-2588745c | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:419 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-ef5f80b9 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:425 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.InitSpreadDateColumn

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e72fb0b | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:462 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ccf9fba | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:463 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-775a0ecb | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:467 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0e12e6e | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:468 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be328d1d | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:472 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-e05f85a6 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:479 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a82cee98 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:480 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc426c9a | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:485 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83976550 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:486 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e593060d | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:494 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29473918 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:495 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32ee8973 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:505 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19b71cb2 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:506 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74b9993a | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:507 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29519938 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:508 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.Set_CellType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f11417bc | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:889 |  | UI_MISC | this.siMain.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dbc9ae44 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:908 | try ▸ for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("Yield_A") \|\| measure.Equals("Yield_E")) ▸ for (iCol < siMain.Active… | UI_PROP | yieldCellType.DecimalPlaces | 2 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-df680a1f | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:910 | try ▸ for (nRow < siMain.ActiveSheet.Rows.Count) ▸ if (measure.Equals("Yield_A") \|\| measure.Equals("Yield_E")) ▸ for (iCol < siMain.Active… | GRID_SET | siMain.ActiveSheet.Cells[nRow, iCol].CellType | yieldCellType | 그리드 속성/값 설정 |  |  |  |
| AC-38e9311a | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:918 | finally | UI_MISC | this.siMain.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0095_GlobalPSI_Elec.Set_FPOperationColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af5403a2 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:848 | for (nCol < siMain.ActiveSheet.Columns.Count) ▸ if (nCol == siMain.ActiveSheet.Columns.Count - 1) | GRID_STYLE | siMain.SetBGColor | (nRow, befCol, nRow, nCol, backColor) | 그리드 표시 설정 |  |  |  |
| AC-d53a6458 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:854 |  | UI_MISC | this.siMain.SP.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-13893f67 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:883 | finally | UI_MISC | this.siMain.SP.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0095_GlobalPSI_Elec.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b4569f1 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:934 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c2380734 | (진입점 미연결) | SCP0095_GlobalPSI_Elec.cs:939 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0095_GlobalPSI_Elec.SetChangedControl

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e283d5e0 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:380 |  | LIST_REBIND | clsCtrl.setListBox | (dtCompanyAll, cboCompany, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-db22edbc | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:382 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, string.Format("DIVISION_ID = '{0}'", _division), true) | 화면 필드/플래그 변경 |  |  |  |
| AC-b4a5c982 | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:382 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, string.Format("DIVISION_ID = '{0}'", _division), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f969e42b | this.Load 외 1 | SCP0095_GlobalPSI_Elec.cs:384 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0095_GlobalPSI_Elec.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82081df5 | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:986 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (this._bucket_type == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2df9766 | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:991 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (this._bucket_type == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c132f768 | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:998 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (this._bucket_type == BucketType.Daily) ▸ if (this._bucket_type == BucketType.Weekly) ▸ if… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0617dded | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:1002 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (this._bucket_type == BucketType.Daily) ▸ if (this._bucket_type == BucketType.Weekly) ▸ el… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-56bd5ba0 | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:1007 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (this._bucket_type == BucketType.Daily) ▸ if (this._bucket_type == BucketType.Weekly) ▸ if… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-48b7df9b | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:1014 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (this._bucket_type == BucketType.Daily) ▸ else of (this._bucket_type == BucketType.Weekly)… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ec6787d2 | this.Load 외 3 | SCP0095_GlobalPSI_Elec.cs:1018 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (this._bucket_type == BucketType.Daily) ▸ else of (this._bucket_type == BucketType.Weekly)… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0095_GlobalPSI_Elec.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a0c0410 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1086 | if (e.ColumnHeader \|\| e.ColumnFooter) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86f5c1c6 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1093 | if (!colName.Equals("MEASURE_NAME")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-236c189e | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1096 | if (!this._currMeasureName.Equals("Prod Plan (Engine)")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20ddae72 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1098 |  | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3736958d | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1100 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cboDivision", this._division) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc9ce450 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1101 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cboOperationGroup", "E") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dab82e44 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1102 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "clbPlantSite", this._currToSite) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e057802 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1103 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtItemId", this._currElecModel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20217417 | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1104 |  | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cboPlanDate", this._plan_start_yyyymmdd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa40751d | this.spdMain.CellDoubleClick | SCP0095_GlobalPSI_Elec.cs:1106 |  | CALL_BASE | openSubMenu | ("SCP0013", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0095_GlobalPSI_Elec.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e36bcc4 | this.spdMain.TopChange | SCP0095_GlobalPSI_Elec.cs:563 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

