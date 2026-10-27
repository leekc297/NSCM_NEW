# AS-IS 액션 대조표 — FP00460

> 원천: `Doc/asisfacts/screens/FP00460/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 821행 · 메서드 75 · 종류 DATA_OP 228 · RETURN 103 · UI_PROP 77 · FLAG 75 · GRID_SET 57 · MESSAGE 42 · ENDPOINT 34 · GRID_INIT 26 · POPUP 23 · UI_MISC 19 · STATE 17 · CALL_EXT 16 · VALUE_SET 16 · GRID_STYLE 15 · LIST_REBIND 14 · VALUE_CLEAR 14 · GRID_LOCK 13 · THROW 9 · VALIDATE 6 · COMBO_DATA 5 · GRID_BIND 4 · CALL_BASE 3 · EXCEL 2 · FOCUS 1 · LIST_BIND 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 19


## FP00460_ExcelImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd11c12a | .ctor | FP00460_ExcelImportPopup.cs:109 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-6c00ce68 | .ctor | FP00460_ExcelImportPopup.cs:110 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-ddfb2f82 | .ctor | FP00460_ExcelImportPopup.cs:111 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-49894950 | .ctor | FP00460_ExcelImportPopup.cs:112 |  | FLAG | this.sParamsValue | pParamsValue | 화면 필드/플래그 변경 |  |  |  |
| AC-12b3f847 | .ctor | FP00460_ExcelImportPopup.cs:113 |  | FLAG | this.sParamsList | pParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-65ce54f7 | .ctor | FP00460_ExcelImportPopup.cs:116 | if (pServiceCallName.IndexOf("FP_Analysis") != -1) | FLAG | this.sPgmBinding | sAnalysisBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-597e89ed | .ctor | FP00460_ExcelImportPopup.cs:118 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ if (pServiceCallName.IndexOf("FP_Common") != -1) | FLAG | this.sPgmBinding | sCommonBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-9c588e00 | .ctor | FP00460_ExcelImportPopup.cs:120 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ if (pServiceCallName.Index… | FLAG | this.sPgmBinding | sMasterBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-7acc0f48 | .ctor | FP00460_ExcelImportPopup.cs:122 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ else of (pServiceCallName.… | FLAG | this.sPgmBinding | sPlanningBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-655d09bc | .ctor | FP00460_ExcelImportPopup.cs:125 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-7868d3ee | .ctor | FP00460_ExcelImportPopup.cs:129 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-2ec4acc9 | .ctor | FP00460_ExcelImportPopup.cs:130 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7dbd8c24 | .ctor | FP00460_ExcelImportPopup.cs:134 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | MESSAGE | MessageBox.Show | ("the Value/List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a7c854c4 | .ctor | FP00460_ExcelImportPopup.cs:135 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-cedca71f | .ctor | FP00460_ExcelImportPopup.cs:142 |  | FLAG | iParmsCount | arrList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-77747169 | .ctor | FP00460_ExcelImportPopup.cs:144 |  | UI_PROP | structParam._sDbParamsList | new string[iParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-6d129a6f | .ctor | FP00460_ExcelImportPopup.cs:145 |  | UI_PROP | structParam._sParamFilter | new string[iParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-4528991e | .ctor | FP00460_ExcelImportPopup.cs:150 | for (i < iParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-79c0d430 | .ctor | FP00460_ExcelImportPopup.cs:151 | for (i < iParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrValue[i] | 행/컬럼 값 대입 |  |  |  |
| AC-2eea3115 | .ctor | FP00460_ExcelImportPopup.cs:153 | for (i < iParmsCount) | DATA_OP | pParams.Add | (String.Format("p_param{0}", i.ToString()), "") | 데이터 객체 조작/조회 |  |  |  |
| AC-684bf20f | .ctor | FP00460_ExcelImportPopup.cs:159 | if (!string.IsNullOrEmpty(pHiddenColumns)) | FLAG | _arrHiddenColumns | pHiddenColumns.Split('\|') | 화면 필드/플래그 변경 |  |  |  |

## FP00460_ExcelImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-457c8667 | this.btnClose.Click | FP00460_ExcelImportPopup.cs:945 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00460_ExcelImportPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6165123 | this.btnExport.Click | FP00460_ExcelImportPopup.cs:833 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-0f312b8c | this.btnExport.Click | FP00460_ExcelImportPopup.cs:834 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00460_ExcelImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8cfc28e | this.btnImport.Click | FP00460_ExcelImportPopup.cs:848 | try | CALL_EXT | siComExcel.GetSpdTitle | (sProgramId, UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d45e81d | this.btnImport.Click | FP00460_ExcelImportPopup.cs:851 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-78e37eb9 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:852 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-8bacfffa | this.btnImport.Click | FP00460_ExcelImportPopup.cs:854 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-9bed7519 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:855 | try | UI_PROP | opd.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ebd12754 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:856 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-783097db | this.btnImport.Click | FP00460_ExcelImportPopup.cs:858 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-461e08ef | this.btnImport.Click | FP00460_ExcelImportPopup.cs:861 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f9abf8ff | this.btnImport.Click | FP00460_ExcelImportPopup.cs:867 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-104e995a | this.btnImport.Click | FP00460_ExcelImportPopup.cs:867 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c740f2f0 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:871 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c80ef8a | this.btnImport.Click | FP00460_ExcelImportPopup.cs:872 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b78fb29d | this.btnImport.Click | FP00460_ExcelImportPopup.cs:876 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b35f5b4d | this.btnImport.Click | FP00460_ExcelImportPopup.cs:877 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dtExcel.AsEnumerable().CopyToDataTable | (dtData, LoadOption.Upsert) | 데이터 객체 조작/조회 |  |  |  |
| AC-9aef3d58 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:879 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | LIST_BIND | spdComExcel.DataSource | dtData | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-8d8c3120 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:882 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef8c1024 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:884 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5d45e93 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:885 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bface487 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:899 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-79affe66 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:899 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5a536f58 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:912 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "S… | FLAG | bUpload | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e519e397 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:919 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ else of (dst.Tables[0].Rows[0][0].ToString() … | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69d11eb9 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:928 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c9588c52 | this.btnImport.Click | FP00460_ExcelImportPopup.cs:939 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00460_ExcelImportPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec610f33 | this.btnSql.Click | FP00460_ExcelImportPopup.cs:951 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-deecd0ae | this.btnSql.Click | FP00460_ExcelImportPopup.cs:952 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-19875f3b | this.btnSql.Click | FP00460_ExcelImportPopup.cs:954 |  | DATA_OP | popSql.Services.Add | ("SELECT_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dcdbd51 | this.btnSql.Click | FP00460_ExcelImportPopup.cs:955 |  | DATA_OP | popSql.Services.Add | ("SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ceae3ce1 | this.btnSql.Click | FP00460_ExcelImportPopup.cs:956 |  | DATA_OP | popSql.Services.Add | ("INSERT_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5d87822 | this.btnSql.Click | FP00460_ExcelImportPopup.cs:957 |  | DATA_OP | popSql.Services.Add | ("INSERT_EXCEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c946411 | this.btnSql.Click | FP00460_ExcelImportPopup.cs:958 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00460_ExcelImportPopup.CheckNullDataTableValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56df63a9 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1026 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-284fb4af | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1026 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afbab643 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1029 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0bfd5f9d | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1033 | for (iRow < dtSheetColumn.Rows.Count) | DATA_OP | dtVal.Columns.Add | (dtSheetColumn.Rows[iRow]["COLUMN_NAME"].ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0dc72a06 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1038 | foreach (var row in dt.Rows) | DATA_OP | dtVal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-adba01b5 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1041 | foreach (var row in dt.Rows) ▸ for (i< ((System.Data.DataRow)row).ItemArray.Length) | DATA_OP | dr[i] | (((System.Data.DataRow)row).ItemArray[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-c1dfa0a7 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1044 | foreach (var row in dt.Rows) | DATA_OP | dtVal.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e247570 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1069 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count-2] | " Not Null : " + actionText | 그리드 속성/값 설정 |  |  |  |
| AC-6a615e63 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1070 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count - 1] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-c1a39ea7 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1079 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-f43b4294 | (진입점 미연결) | FP00460_ExcelImportPopup.cs:1081 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.CheckNullSpreadValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-502f16bf | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:980 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e954218a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:980 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-588d6875 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:983 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3f8341db | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1007 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex() - 1].Text | actionText + " Not Null : " + siComExcel.GetText(i, siComExcel.GetMaxColumnIndex() - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-42a06e66 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1008 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex()].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-9e267ea4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1009 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-fecae752 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1017 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-977c35ce | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1019 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21e6636b | this.Load | FP00460_ExcelImportPopup.cs:218 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-69f766de | this.Load | FP00460_ExcelImportPopup.cs:219 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-af7935c6 | this.Load | FP00460_ExcelImportPopup.cs:221 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00460_ExcelImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64b32e64 | this.Load | FP00460_ExcelImportPopup.cs:211 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00460_ExcelImportPopup.Delete_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6d3f6b1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:773 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-53a0670c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:777 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b545b277 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:779 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-b3d8513f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:780 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-68f0fc28 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:781 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ff375a72 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:782 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-279f8bda | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:787 | try ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1b05909c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:790 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0553197e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:805 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-1dd1ddc5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:808 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-9d8bc043 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:812 | catch () | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf651409 | Dispose | FP00460_ExcelImportPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00460_ExcelImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2e5f8d0 | EditButton | FP00460_ExcelImportPopup.cs:288 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7b35116 | EditButton | FP00460_ExcelImportPopup.cs:289 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-194fa503 | ExcelButton | FP00460_ExcelImportPopup.cs:320 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00460_ExcelImportPopup.Find_Data

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / this.Load / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b445aa85 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:328 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-27498501 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:332 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de8bcf3c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:335 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d631aeeb | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:335 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0ad3e89 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:341 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0481817c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:344 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-edb5aa18 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:350 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-10e37c70 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:363 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d4c1d72 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:365 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7411a1d2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:368 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f0291d8a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:371 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2e38257a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:374 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-56088cbd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:385 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-9d38c5ba | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:394 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fa938589 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FP00460_ExcelImportPopup.cs:395 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00460_ExcelImportPopup.Find_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_IMPORT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d52fcbd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:405 | if (DoSearchData != null) | CALL_EXT | filter.Set | (set) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bf557a1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:406 | if (DoSearchData != null) | CALL_BASE | DoSearchData | (filter, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95a0f8db | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:406 | if (DoSearchData != null) | RETURN | return DoSearchData(filter, this); |  | 처리 중단/반환 |  |  |  |
| AC-cf6b0fe9 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:413 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-def92bdc | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:415 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-879baf18 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:416 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-192114f4 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:417 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6f87dd3d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:418 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7272e40d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:422 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-9821eb87 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:426 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-16b97da5 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:428 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d5d58c68 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FP00460_ExcelImportPopup.cs:434 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.Find_Data_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c245559 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:448 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-bfbf133f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:450 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-b45f0e04 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:451 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-74e51d10 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:452 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-69bdf60b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:453 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-94d34459 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:457 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-b8c63889 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:461 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83376bc1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:464 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d5bb58b0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:470 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.Find_Save_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-911e7745 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:480 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6291d6b8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:485 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-621b0c2a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:488 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-277a63de | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:488 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe383d61 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:494 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-667aa5ab | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:497 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8e49acaf | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:513 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-741dac8c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:519 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65497cdb | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:522 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e14b5278 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:533 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-c0abe4cc | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:538 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bca6859 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:542 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00460_ExcelImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c862d31 | this.Load | FP00460_ExcelImportPopup.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d400b326 | this.Load | FP00460_ExcelImportPopup.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cc5b7834 | this.Load | FP00460_ExcelImportPopup.cs:183 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |
| AC-e2df6f1f | this.Load | FP00460_ExcelImportPopup.cs:185 |  | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |

## FP00460_ExcelImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af2a90f1 | this.Load | FP00460_ExcelImportPopup.cs:193 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9d45688 | this.Load | FP00460_ExcelImportPopup.cs:196 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfee7db5 | this.Load | FP00460_ExcelImportPopup.cs:202 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a62b872a | this.Load | FP00460_ExcelImportPopup.cs:203 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-11095a40 | this.Load | FP00460_ExcelImportPopup.cs:204 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00460_ExcelImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b667732c | this.Load | FP00460_ExcelImportPopup.cs:234 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6879f5c8 | this.Load | FP00460_ExcelImportPopup.cs:235 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c64c9820 | this.Load | FP00460_ExcelImportPopup.cs:242 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_ExcelImportPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a19266b | popSql.OnSql | FP00460_ExcelImportPopup.cs:1156 | if (programID == "SELECT_IMPORT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-6ffa0eb3 | popSql.OnSql | FP00460_ExcelImportPopup.cs:1161 | else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8ca470fd | popSql.OnSql | FP00460_ExcelImportPopup.cs:1170 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6a5675c | popSql.OnSql | FP00460_ExcelImportPopup.cs:1170 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d0e560e | popSql.OnSql | FP00460_ExcelImportPopup.cs:1174 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ else of (spdComExcel.Ac… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6304841d | popSql.OnSql | FP00460_ExcelImportPopup.cs:1178 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-8f6ba32b | popSql.OnSql | FP00460_ExcelImportPopup.cs:1184 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-84146fd9 | popSql.OnSql | FP00460_ExcelImportPopup.cs:1187 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ca1b636 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:551 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8d082fe | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:553 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66e69dfd | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:557 | if (bUpload == false) | MESSAGE | MessageBox.Show | ("After Excel Upload, Try Again!", "Upload Error", MessageBoxButtons.OK, MessageBoxIcon.Er… | 메시지 표시 |  |  |  |
| AC-9c6fd126 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:558 | if (bUpload == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f886015a | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:565 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a320688 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:566 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6406b09d | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:570 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4d06242a | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:585 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsv.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70c58501 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:595 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ else of (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d2760403 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:599 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bcbe291e | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:603 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b6d582f9 | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:604 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d5c8244e | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:608 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4e7d5d0e | this.btnSave.Click 외 1 | FP00460_ExcelImportPopup.cs:609 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00460_ExcelImportPopup.Save_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e12130e0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:699 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-61a2fc43 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:712 | try ▸ for (i< sParm.Length) | DATA_OP | sParm[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ea9288b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:733 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-15c27fd3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:737 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-141fbb56 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:739 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d1e2069f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:740 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d682e269 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:741 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-e9677fa2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:742 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ae8d0623 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:747 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k] | 행/컬럼 값 대입 |  |  |  |
| AC-ea5fd5b3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:749 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-76733922 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:751 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-33bc13a5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:757 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b0d705f2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FP00460_ExcelImportPopup.cs:762 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.Save_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "INSERT_EXCEL")] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95b9a973 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:630 | try ▸ for (i < sParams.Length) | DATA_OP | sParams[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1adc8bb3 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:641 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { sMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da2a05c7 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:642 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-f4de4132 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:662 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-1595a1a2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:666 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-34e14ef9 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:668 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-1f4c9c91 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:669 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e049fbf8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:670 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d57d1b62 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:671 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2259b630 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:675 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParams[k] | 행/컬럼 값 대입 |  |  |  |
| AC-de87865b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:678 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db868895 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:680 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d9979858 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:685 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-bb514c22 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FP00460_ExcelImportPopup.cs:690 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-732160c2 | SaveButton | FP00460_ExcelImportPopup.cs:314 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.SetSheetHeadColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds != null) ▸ if (ds.Tables[0].Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a369c879 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FP00460_ExcelImportPopup.cs:1126 | try ▸ for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siComExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-58a023ab | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FP00460_ExcelImportPopup.cs:1133 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_ExcelImportPopup.SetSheetHeaderWidth

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56316982 | this.Load [try] | FP00460_ExcelImportPopup.cs:1145 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cca95296 | this.Load [try] | FP00460_ExcelImportPopup.cs:1146 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FP00460_ExcelImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ecbc2c | this.Load [try] | FP00460_ExcelImportPopup.cs:250 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd16df2e | this.Load [try] | FP00460_ExcelImportPopup.cs:251 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-81bda81a | this.Load [try] | FP00460_ExcelImportPopup.cs:255 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-50afd64b | this.Load [try] | FP00460_ExcelImportPopup.cs:263 | if (_arrHiddenColumns != null) ▸ if (_arrHiddenColumns.Length > 0) ▸ for (i < _arrHiddenColumns.Length) | GRID_SET | siComExcel.ActiveSheet.Columns[_arrHiddenColumns[i]].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4c8f457d | this.Load [try] | FP00460_ExcelImportPopup.cs:267 |  | GRID_INIT | siComExcel.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00460_ExcelImportPopup.SetValidationResultSheetColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-009a9dff | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1100 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N"… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-1ab6c69f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1107 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-9db190f2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00460_ExcelImportPopup.cs:1110 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FP00460_ExcelImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfc13cda | (진입점 미연결) | FP00460_ExcelImportPopup.cs:967 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.btnRefreshSetup_Click

진입점: this.btnRefreshSetup.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa87cef | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1374 | try | MESSAGE | MessageBox.Show | ("Will you refresh to Setup Group?", "Confrim", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-8032f41e | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1376 | try ▸ if (MessageBox.Show("Will you refresh to Setup Group?", "Confrim", MessageBoxButtons.YesNo) == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1b46fd4 | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1380 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6c4b168d | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1381 | try | DATA_OP | filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-a3dee9c9 | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1383 | try | DATA_OP | filter["INSTANCE_ID"] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-a714a84e | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1384 | try | DATA_OP | filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-13d96ffe | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1393 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), "SELECT", "EXECUTE_INIT_SETUP_V2") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-65899908 | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1393 | try | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec2d995a | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1398 | try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d38b56c3 | this.btnRefreshSetup.Click | FP00460_Setup_Group.cs:1406 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c06c94a3 | this.btnSql.Click | FP00460_Setup_Group.cs:1901 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8226bceb | this.btnSql.Click | FP00460_Setup_Group.cs:1902 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-639b54d6 | this.btnSql.Click | FP00460_Setup_Group.cs:1904 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN_V2") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a1c4e40 | this.btnSql.Click | FP00460_Setup_Group.cs:1905 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-8191e683 | this.btnSql.Click | FP00460_Setup_Group.cs:1906 |  | DATA_OP | popSql.Services.Add | ("REFRESH_SETUP_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bfc5691 | this.btnSql.Click | FP00460_Setup_Group.cs:1907 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-9805cec6 | this.btnSql.Click | FP00460_Setup_Group.cs:1908 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-beb9d2a8 | this.btnSql.Click | FP00460_Setup_Group.cs:1909 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00460_Setup_Group.btnSubImport_Click

진입점: this.btnSubImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58b6809c | this.btnSubImport.Click | FP00460_Setup_Group.cs:1862 | try ▸ if (iClickRow < 0 \|\| siSub.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4145d335 | this.btnSubImport.Click | FP00460_Setup_Group.cs:1874 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-07137a8f | this.btnSubImport.Click | FP00460_Setup_Group.cs:1877 | try | POPUP | new FP00460_ExcelImportPopup | ("FPC0100", "SetupGroupImport", "FP_Master.PR_UI_FP00460_SETUP_GROUP_EXCEL", sParamsFilter… | 팝업/폼 생성 |  |  |  |
| AC-1c3c07f6 | this.btnSubImport.Click | FP00460_Setup_Group.cs:1878 | try | UI_PROP | popImport.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-aec10cc0 | this.btnSubImport.Click | FP00460_Setup_Group.cs:1880 | try | UI_PROP | popImport.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-c5e66cdf | this.btnSubImport.Click | FP00460_Setup_Group.cs:1881 | try | UI_PROP | popImport.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-1d4163e4 | this.btnSubImport.Click | FP00460_Setup_Group.cs:1882 | try | UI_PROP | popImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9ae9728f | this.btnSubImport.Click | FP00460_Setup_Group.cs:1883 | try | POPUP | popImport.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a21c342a | this.btnSubImport.Click | FP00460_Setup_Group.cs:1893 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-143aee3e | (진입점 미연결) | FP00460_Setup_Group.cs:1446 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2fa3519e | (진입점 미연결) | FP00460_Setup_Group.cs:1451 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-320c6617 | (진입점 미연결) | FP00460_Setup_Group.cs:1452 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e9c14764 | (진입점 미연결) | FP00460_Setup_Group.cs:1458 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-b7239735 | (진입점 미연결) | FP00460_Setup_Group.cs:1543 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad092820 | (진입점 미연결) | FP00460_Setup_Group.cs:1545 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-301e2d5d | (진입점 미연결) | FP00460_Setup_Group.cs:1546 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTA… | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecbb3d53 | (진입점 미연결) | FP00460_Setup_Group.cs:1547 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-47b1eb04 | (진입점 미연결) | FP00460_Setup_Group.cs:1548 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PL… | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3486989 | (진입점 미연결) | FP00460_Setup_Group.cs:1551 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ddd780f | (진입점 미연결) | FP00460_Setup_Group.cs:1552 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-21da87a8 | (진입점 미연결) | FP00460_Setup_Group.cs:1559 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-be5d0168 | (진입점 미연결) | FP00460_Setup_Group.cs:1560 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-49a7dab6 | (진입점 미연결) | FP00460_Setup_Group.cs:1562 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e44f892b | (진입점 미연결) | FP00460_Setup_Group.cs:1562 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-df79d83b | (진입점 미연결) | FP00460_Setup_Group.cs:1564 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-f78d2b05 | (진입점 미연결) | FP00460_Setup_Group.cs:1569 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-436c9abb | (진입점 미연결) | FP00460_Setup_Group.cs:1569 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-7fb2166e | (진입점 미연결) | FP00460_Setup_Group.cs:1573 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-385b9809 | (진입점 미연결) | FP00460_Setup_Group.cs:1573 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3369c61 | (진입점 미연결) | FP00460_Setup_Group.cs:1437 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a34fb825 | (진입점 미연결) | FP00460_Setup_Group.cs:1845 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9b2a21b | this.Load | FP00460_Setup_Group.cs:244 | try | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3edebf29 | this.Load | FP00460_Setup_Group.cs:245 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-404b0c9b | this.Load | FP00460_Setup_Group.cs:248 | try | GRID_SET | spdMain.ActiveSheet.Columns["INSTANCE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-741ade50 | this.Load | FP00460_Setup_Group.cs:249 | try | GRID_SET | spdMain.ActiveSheet.Columns["INSTANCE_NAME"].Width | 170 | 그리드 속성/값 설정 |  |  |  |
| AC-ee1e3035 | this.Load | FP00460_Setup_Group.cs:250 | try | GRID_SET | spdMain.ActiveSheet.Columns["COMPANY_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-0927511f | this.Load | FP00460_Setup_Group.cs:251 | try | GRID_SET | spdMain.ActiveSheet.Columns["SITE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-21bb4595 | this.Load | FP00460_Setup_Group.cs:252 | try | GRID_SET | spdMain.ActiveSheet.Columns["DIVISION_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-1ab5c8c1 | this.Load | FP00460_Setup_Group.cs:254 | try | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d7dfeb3 | this.Load | FP00460_Setup_Group.cs:255 | try | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-73e9f1cf | this.Load | FP00460_Setup_Group.cs:258 | try | GRID_SET | siSub.ActiveSheet.Columns["INSTANCE_NAME"].Width | 170 | 그리드 속성/값 설정 |  |  |  |
| AC-af9512cf | this.Load | FP00460_Setup_Group.cs:259 | try | GRID_SET | siSub.ActiveSheet.Columns["PLANT_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d1ccd84f | this.Load | FP00460_Setup_Group.cs:260 | try | GRID_SET | siSub.ActiveSheet.Columns["COMPANY_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-162b50d0 | this.Load | FP00460_Setup_Group.cs:261 | try | GRID_SET | siSub.ActiveSheet.Columns["SITE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e1439f2f | this.Load | FP00460_Setup_Group.cs:262 | try | GRID_SET | siSub.ActiveSheet.Columns["DIVISION_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-3121d858 | this.Load | FP00460_Setup_Group.cs:266 | try | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eae1a403 | this.Load | FP00460_Setup_Group.cs:272 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-931187b8 | this.Load | FP00460_Setup_Group.cs:273 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10ce6d42 | this.Load | FP00460_Setup_Group.cs:142 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-8972c021 | this.Load | FP00460_Setup_Group.cs:144 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-e5b9677b | this.Load | FP00460_Setup_Group.cs:145 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-7beddda6 | this.Load | FP00460_Setup_Group.cs:146 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00460_Setup_Group.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bedf4ea8 | DeleteButton | FP00460_Setup_Group.cs:559 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4316d362 | DeleteButton | FP00460_Setup_Group.cs:565 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae21dc6f | DeleteButton | FP00460_Setup_Group.cs:569 | if (fps.Name == "spdMain") ▸ if (spdMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-36f81bd0 | DeleteButton | FP00460_Setup_Group.cs:576 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.Acti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5528cb35 | DeleteButton | FP00460_Setup_Group.cs:580 | else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (spdSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## FP00460_Setup_Group.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32646fed | Dispose | FP00460_Setup_Group.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00460_Setup_Group.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d232731 | EditButton | FP00460_Setup_Group.cs:359 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ef64592 | EditButton | FP00460_Setup_Group.cs:368 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7e1c5d9f | EditButton | FP00460_Setup_Group.cs:369 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.REFERANCE_OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e36457ca | EditButton | FP00460_Setup_Group.cs:379 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-465a9de4 | EditButton | FP00460_Setup_Group.cs:380 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-f84217c9 | EditButton | FP00460_Setup_Group.cs:385 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-ef3608a3 | EditButton | FP00460_Setup_Group.cs:386 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-0674bce1 | EditButton | FP00460_Setup_Group.cs:394 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-bf260a1b | EditButton | FP00460_Setup_Group.cs:398 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-4ebb37ee | EditButton | FP00460_Setup_Group.cs:399 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-6602aed2 | EditButton | FP00460_Setup_Group.cs:403 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-c5f09028 | EditButton | FP00460_Setup_Group.cs:404 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-0eee112b | EditButton | FP00460_Setup_Group.cs:411 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-9a120cbb | EditButton | FP00460_Setup_Group.cs:415 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-d0da477c | EditButton | FP00460_Setup_Group.cs:422 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99e9d950 | EditButton | FP00460_Setup_Group.cs:424 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5253231 | EditButton | FP00460_Setup_Group.cs:425 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-19e4472f | EditButton | FP00460_Setup_Group.cs:426 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": | GRID_LOCK | siSub.LockColumn | (0, siSub.GetColumnIndex(DefColumns.OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d6ad8767 | EditButton | FP00460_Setup_Group.cs:436 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (!siSub.… | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-80957e9c | EditButton | FP00460_Setup_Group.cs:437 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (!siSub.… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-bfe48d58 | EditButton | FP00460_Setup_Group.cs:442 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (!siSub.… | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-0c013bf7 | EditButton | FP00460_Setup_Group.cs:443 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (!siSub.… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-39b6b1dd | EditButton | FP00460_Setup_Group.cs:451 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_SET | siSub.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-5338da35 | EditButton | FP00460_Setup_Group.cs:455 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-98b6496f | EditButton | FP00460_Setup_Group.cs:456 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-723fa02f | EditButton | FP00460_Setup_Group.cs:460 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_SET | siSub.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-fc06be6e | EditButton | FP00460_Setup_Group.cs:461 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-0521ea16 | EditButton | FP00460_Setup_Group.cs:468 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |
| AC-43acd553 | EditButton | FP00460_Setup_Group.cs:472 | if (this.fps != null) ▸ switch (fps.Name) case "spdSub": ▸ if (siSub.GetMaxRowIndex() > 0) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (!s… | GRID_STYLE | siSub.SetBGColor | (i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID), i, siSub.GetColumnIndex(DefColum… | 그리드 표시 설정 |  |  |  |

## FP00460_Setup_Group.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1250fc20 | ExcelButton | FP00460_Setup_Group.cs:614 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00460_Setup_Group.Find_Data_Detail

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-106b2022 | (진입점 미연결) | FP00460_Setup_Group.cs:907 | try ▸ try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0c8a3e3e | (진입점 미연결) | FP00460_Setup_Group.cs:908 | try ▸ try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), pSysType, "SELECT_DETAIL_POPUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-71e601b6 | (진입점 미연결) | FP00460_Setup_Group.cs:908 | try ▸ try | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f626c012 | (진입점 미연결) | FP00460_Setup_Group.cs:909 | try ▸ try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2161748c | (진입점 미연결) | FP00460_Setup_Group.cs:913 | try ▸ catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6c15477b | (진입점 미연결) | FP00460_Setup_Group.cs:918 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.Find_Data_Main

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ lambda] / this.btnSubImport.Click [try ▸ if (popImport.SaveSuccess == true) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN_V2")] / FindButton [try ▸ lambda] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / InsertButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.Shee…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a8e017b | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:747 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pInstanceID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1bccfc70 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:764 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-bc10c358 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:765 | try | DATA_OP | filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-18090f44 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:766 | try | DATA_OP | filter["SETUP_CATEGORY_ID"] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-2296c038 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:767 | try | DATA_OP | filter["INSTANCE_ID"] | pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-f710e368 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:768 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(),pSysType, "SELECT_MAIN_V2") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4db43341 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:768 | try | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5ffd5c32 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:769 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-53f7e074 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:801 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-7052cb7d | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:805 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.Find_Data_Sub

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ if (ds.Good()) ▸ try] / this.btnSubImport.Click [try ▸ if (popImport.SaveSuccess == true) ▸ try ▸ if (ds.Good()) ▸ try] / popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ if (programID == "SELECT_SUB")] / FindButton [try ▸ if (ds.Good()) ▸ try] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6371deb1 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:886 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1430b61d | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:887 | try | DATA_OP | filter["INSTANCE_ID"] | pInstance | 행/컬럼 값 대입 |  |  |  |
| AC-83e50687 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:888 | try | DATA_OP | filter["OPERATION_ID"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-c04c9e03 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:889 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), pSysType, "SELECT_SUB") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-63778479 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:889 | try | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95680522 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:890 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e0d91b90 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:894 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.Find_Sub

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ if (ds.Good())] / this.btnSubImport.Click [try ▸ if (popImport.SaveSuccess == true) ▸ try ▸ if (ds.Good())] / FindButton [try ▸ if (ds.Good())] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / InsertButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93bf838a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:812 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-56904911 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:826 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-68b07c3a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:838 | try ▸ if (ds.Good()) | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fe61e08a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:843 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["INSTANCE_ID"].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-f5ea6571 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:845 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["PLANT_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-4b6f5e61 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:846 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["COMPANY_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b561d170 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:847 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["SITE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f4d3001d | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:848 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["DIVISION_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9fce8ba2 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:855 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c2370961 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:863 | try | GRID_INIT | siSub.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb647d2c | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:876 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-037c8015 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:876 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00460_Setup_Group.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-480398b2 | this.Load | FP00460_Setup_Group.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00460_Setup_Group.GetInstanceSetupInstance

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3446b5da | this.Load [try] | FP00460_Setup_Group.cs:151 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.INSTANCE, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0cc4089 | this.Load [try] | FP00460_Setup_Group.cs:152 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_instance", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f2c7b6d2 | this.Load [try] | FP00460_Setup_Group.cs:154 |  | DATA_OP | dtAllInstance.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-feb203d4 | this.Load [try] | FP00460_Setup_Group.cs:165 | if (dtAllInstance.Good() && dtAvailableInstance.Good()) ▸ foreach (DataRow r in dtAllInstance.Rows) ▸ foreach (DataRow rA in dtAvailableInst… | DATA_OP | dtK.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bec3ab79 | this.Load [try] | FP00460_Setup_Group.cs:166 | if (dtAllInstance.Good() && dtAvailableInstance.Good()) ▸ foreach (DataRow r in dtAllInstance.Rows) ▸ foreach (DataRow rA in dtAvailableInst… | UI_PROP | nR.ItemArray | r.ItemArray | 속성 ItemArray 설정 |  |  |  |
| AC-4267581e | this.Load [try] | FP00460_Setup_Group.cs:167 | if (dtAllInstance.Good() && dtAvailableInstance.Good()) ▸ foreach (DataRow r in dtAllInstance.Rows) ▸ foreach (DataRow rA in dtAvailableInst… | DATA_OP | dtK.Rows.Add | (nR) | 데이터 객체 조작/조회 |  |  |  |
| AC-abe5fe9e | this.Load [try] | FP00460_Setup_Group.cs:172 |  | RETURN | return dtK; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c047689f | this.Load | FP00460_Setup_Group.cs:180 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-36b005e2 | this.Load | FP00460_Setup_Group.cs:186 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-137e115c | this.Load | FP00460_Setup_Group.cs:187 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-f6bc846e | this.Load | FP00460_Setup_Group.cs:188 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-66b08c4e | this.Load | FP00460_Setup_Group.cs:193 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-90956b99 | this.Load | FP00460_Setup_Group.cs:195 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-491feaaf | this.Load | FP00460_Setup_Group.cs:198 | try | FLAG | dtInstance | GetInstanceSetupInstance() | 화면 필드/플래그 변경 |  |  |  |
| AC-43722af0 | this.Load | FP00460_Setup_Group.cs:201 | try | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5c167550 | this.Load | FP00460_Setup_Group.cs:204 | try | FLAG | dtOperationByInstance | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-b5c2b689 | this.Load | FP00460_Setup_Group.cs:204 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, Filter["USER_ID"], _sNonAuth, _sSaveAuth, pInstanceID, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b43738d | this.Load | FP00460_Setup_Group.cs:205 | try | LIST_REBIND | clsCtrl.setListBox | (dtOperationByInstance, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1b697c98 | this.Load | FP00460_Setup_Group.cs:208 | try | FLAG | dtCategory | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MA… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-6f0e2ae1 | this.Load | FP00460_Setup_Group.cs:208 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-977e24a0 | this.Load | FP00460_Setup_Group.cs:209 | try | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d9f2f2c | this.Load | FP00460_Setup_Group.cs:211 | try | FLAG | dtCalculation | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_calculation", Filter.Dictionary, … ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] \| FP\MASTER\… | 화면 필드/플래그 변경 |  |  |  |
| AC-307f0f13 | this.Load | FP00460_Setup_Group.cs:211 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_calculation", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] \| FP\MASTER\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6d98502c | this.Load | FP00460_Setup_Group.cs:222 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-49823875 | this.Load | FP00460_Setup_Group.cs:223 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c31b3b6e | this.Load | FP00460_Setup_Group.cs:224 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d21dcec4 | this.Load | FP00460_Setup_Group.cs:230 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-71aea661 | this.Load | FP00460_Setup_Group.cs:231 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.InitSpread

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1") ▸ try ▸ else of (ds.Good())] / this.btnSubImport.Click [try ▸ if (popImport.SaveSuccess == true) ▸ try ▸ else of (ds.Good())] / this.Load [try] / FindButton [try ▸ else of (ds.Good())] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ else of (ds.Good())] / InsertButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af69863f | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:283 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-21e4cc78 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:286 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a26e43bd | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:291 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9df0cb47 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:294 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-655c729a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:295 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-251c2f35 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:300 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-df4a2e53 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:303 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-bc7246ec | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:305 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.EDIT_YN)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b797a36f | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:308 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-edbd279c | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:309 | try ▸ else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eb0f7fc3 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:342 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-98a51d73 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 5 | FP00460_Setup_Group.cs:343 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.Insert_Row_Sub

진입점: InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c799e17 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP00460_Setup_Group.cs:597 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-df183345 | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP00460_Setup_Group.cs:604 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.OPERATION_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-16e9fcda | InsertButton [try ▸ else of (fps.Name == "spdMain") ▸ if (fp… | FP00460_Setup_Group.cs:606 | if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.SheetName == SpdSheet.shtSub) | GRID_LOCK | siSub.LockRange | (insCell, siSub.GetColumnIndex(DefColumns.INSTANCE_ID), siSub.GetColumnIndex(DefColumns.IN… | 그리드 편집 잠금/해제 |  |  |  |

## FP00460_Setup_Group.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8db1b48b | InsertButton | FP00460_Setup_Group.cs:508 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3eab794d | InsertButton | FP00460_Setup_Group.cs:523 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-57785ec6 | InsertButton | FP00460_Setup_Group.cs:527 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | POPUP | new FP00460_SetupGroupAddPopup | (pInstanceID, pOperation) | 팝업/폼 생성 |  |  |  |
| AC-6b6545ce | InsertButton | FP00460_Setup_Group.cs:528 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | UI_PROP | popSetupAdd.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2452e08d | InsertButton | FP00460_Setup_Group.cs:529 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | POPUP | popSetupAdd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c91f0780 | InsertButton | FP00460_Setup_Group.cs:533 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.INSTANCE_ID), siMain.GetColumnIndex(DefColumns.EDIT_YN),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ac65adb0 | InsertButton | FP00460_Setup_Group.cs:535 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7dbe2e8c | InsertButton | FP00460_Setup_Group.cs:536 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMai… | GRID_LOCK | siMain.LockRange | (0, 0, siMain.GetMaxRowIndex(), siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-15e4c2f7 | InsertButton | FP00460_Setup_Group.cs:545 | try ▸ else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub.IsLock(siSub.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6773e15 | InsertButton | FP00460_Setup_Group.cs:553 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3406ccc2 | popSql.OnSql | FP00460_Setup_Group.cs:2104 | if (programID == "SELECT_MAIN_V2") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9d710abc | popSql.OnSql | FP00460_Setup_Group.cs:2112 | else of (programID == "SELECT_MAIN_V2") ▸ if (programID == "SELECT_SUB") | RETURN | return Find_Data_Sub("SQL", pInstanceID, pOperation); |  | 처리 중단/반환 |  |  |  |
| AC-18e610f5 | popSql.OnSql | FP00460_Setup_Group.cs:2124 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-43db7031 | popSql.OnSql | FP00460_Setup_Group.cs:2125 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | dt.Rows.Add | ("EXEC PR_SCM_UF_ITEM_SETUP_RENEW ") | 데이터 객체 조작/조회 |  |  |  |
| AC-446637f4 | popSql.OnSql | FP00460_Setup_Group.cs:2127 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3990190a | popSql.OnSql | FP00460_Setup_Group.cs:2129 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ if (programID == "REFRESH_SETUP_GROUP") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-4879733e | popSql.OnSql | FP00460_Setup_Group.cs:2134 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID… | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-c93ade94 | popSql.OnSql | FP00460_Setup_Group.cs:2134 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e71a0113 | popSql.OnSql | FP00460_Setup_Group.cs:2135 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID… | RETURN | return Save_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-86dcc9b6 | popSql.OnSql | FP00460_Setup_Group.cs:2140 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (prog… | VALIDATE | DataUtil.checkRequiredOfSpread | (siSub) | 프레임워크 검증 |  |  |  |
| AC-9046ca0c | popSql.OnSql | FP00460_Setup_Group.cs:2140 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (prog… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-aab8221a | popSql.OnSql | FP00460_Setup_Group.cs:2141 | else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (prog… | RETURN | return Save_Data_Sub("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-65cff4d6 | popSql.OnSql | FP00460_Setup_Group.cs:2144 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.Save_Data_Main

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ if (programID == "SAVE_MAIN")] / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f2603e8 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1016 | try | DATA_OP | dsMain.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d6e97ed5 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1017 | try | DATA_OP | dsDelete.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1123e35 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1026 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dsDelete.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-06ff06cf | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1027 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9713f00 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1028 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a42e878 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1029 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_CATEGORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_CATEGORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d574a9d | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1030 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_KEY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_KEY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-485bc20e | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1031 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dsDelete.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd2d5401 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1044 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dsSave.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b476602f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1045 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ca94e7c | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1046 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e8c93f17 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1047 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.CALCULATION] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CALCULATION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd93dc15 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1048 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_CATEGORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_CATEGORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c5f881f8 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1051 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_KEY_ID] | dsMain.getColumn(i, "SETUP_KEY_ID_BAK").ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c44d63b | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1051 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dsMain.getColumn | (i, "SETUP_KEY_ID_BAK") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3545840c | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1052 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dsSave.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d06e8ac | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1059 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | UI_PROP | dtResult.TableName | "res" | 속성 TableName 설정 |  |  |  |
| AC-24c66da3 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1060 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Columns.SafeAdd | ("Result", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce2cd992 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1061 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Columns.SafeAdd | ("CNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bface2a | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1063 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dsResult.Tables.Add | (dtResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5547793 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1082 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "save_item_setup_group", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-7c68e999 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1091 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (dsDelete.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "delete_item_setup_group", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-af08762b | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1098 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bbcfd208 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1101 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (success_cnt > 0) | DATA_OP | resRow["Result"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-8e975625 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1102 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (success_cnt > 0) | DATA_OP | resRow["CNT"] | success_cnt | 행/컬럼 값 대입 |  |  |  |
| AC-96ac8022 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1106 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ else of (success_cnt > 0) | DATA_OP | resRow["Result"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-b50abe0f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1107 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ else of (success_cnt > 0) | DATA_OP | resRow["CNT"] | success_cnt | 행/컬럼 값 대입 |  |  |  |
| AC-431e4008 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1109 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Rows.Add | (resRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-93474e19 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1111 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-f9f0bf83 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1115 | try ▸ else of (dsDelete.Good() \|\| dsSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-db67625f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1121 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.Save_Data_Sub

진입점: popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else of (programID == "SELECT_SUB") ▸ else of (programID == "REFRESH_SETUP_GROUP") ▸ else of (programID == "SAVE_MAIN") ▸ if (programID == "SAVE_SUB")] / SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ try ▸ if (siSub.SheetName == SpdSheet.shtSub)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14bf5948 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1204 | try ▸ if (r == null) | DATA_OP | r.Tables.Add | (new DataTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc197faa | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1205 | try ▸ if (r == null) | UI_PROP | r.Tables[0].TableName | "LineSetup" | 속성 TableName 설정 |  |  |  |
| AC-b92e5f37 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1206 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9509bf54 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1207 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3c2bdb1 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1208 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d221236 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1209 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("ORG_LINE_SETUP_GROUP_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed2139d2 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1210 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("ACTIVE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-926606ef | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1211 | try ▸ if (r == null) | DATA_OP | r.Tables[0].Columns.SafeAdd | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-27c1c635 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1213 | try | DATA_OP | r.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39f6367f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1214 | try | DATA_OP | SaveTable.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ac21ce8 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1234 | try | DATA_OP | SaveTable.Tables[0].Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-95104253 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1235 | try | DATA_OP | SaveTable.Tables[0].Columns.SafeAdd | ("ACTIVE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4339c47 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1236 | try | DATA_OP | SaveTable.Tables[0].Columns.SafeAdd | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9158bd2f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1238 | try | DATA_OP | DeleteTable.Tables[0].Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93692060 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1239 | try | DATA_OP | DeleteTable.Tables[0].Columns.SafeAdd | ("ACTIVE_FLAG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-feb53140 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1240 | try | DATA_OP | DeleteTable.Tables[0].Columns.SafeAdd | ("DESCRIPTION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12e1251f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1261 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | DeleteTable.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f16e799 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1262 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.INSTANCE_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c197b56 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1263 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.OPERATION_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c7b0a22 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1264 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.LINE_SETUP_GROUP_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5610f078 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1265 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.ORG_LINE_SETUP_GROUP_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ORG_LINE_SETUP_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee3cf0ca | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1266 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-40c531d0 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1267 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0a93d6a9 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1268 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | row["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebd20629 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1269 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (pSysFlag == "DELETE_SUB") | DATA_OP | DeleteTable.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-8448c0ca | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1273 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | SaveTable.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-01d6e75f | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1274 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.INSTANCE_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9de9dca0 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1275 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.OPERATION_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f31cf53d | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1276 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.LINE_SETUP_GROUP_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.LINE_SETUP_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ca0e0bf | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1277 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row[DefColumns.ORG_LINE_SETUP_GROUP_ID] | siSub.GetValue(i, siSub.GetColumnIndex(DefColumns.ORG_LINE_SETUP_GROUP_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d21c6e87 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1278 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6d262704 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1279 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-3e8cea8e | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1280 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | row["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-01ffd7dd | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1281 | try ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (pSysFlag == "DELETE_SUB") | DATA_OP | SaveTable.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5718c509 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1309 | try ▸ if (SaveTable.Good() \|\| DeleteTable.Good()) ▸ if (SaveTable.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "save_line_setup_group", SaveTable, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_line_setup_group] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-3a8b7566 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1311 | try ▸ if (SaveTable.Good() \|\| DeleteTable.Good()) ▸ if (SaveTable.Good()) | DATA_OP | ret2.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-343ec320 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1315 | try ▸ if (SaveTable.Good() \|\| DeleteTable.Good()) ▸ if (DeleteTable.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "delete_line_setup_group", DeleteTable, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_line_setup_group] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-a35f278c | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1316 | try ▸ if (SaveTable.Good() \|\| DeleteTable.Good()) ▸ if (DeleteTable.Good()) | DATA_OP | ret2.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4903a09 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1318 | try ▸ if (SaveTable.Good() \|\| DeleteTable.Good()) | RETURN | return ret2; |  | 처리 중단/반환 |  |  |  |
| AC-a256855b | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1321 | try ▸ else of (SaveTable.Good() \|\| DeleteTable.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-658b9f61 | popSql.OnSql [else of (programID == "SELECT_MAIN_V2") ▸ else… 외 1 | FP00460_Setup_Group.cs:1354 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.Save_Main

진입점: SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f33372e | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:927 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f46ff38 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:929 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3860975c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:934 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-509defdd | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:935 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd4626d7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:938 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cad333fe | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:947 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("COMPANY_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-34ff3ba1 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:948 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("DIVISION_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-9dedc1dc | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:949 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("SITE_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-023fb612 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:951 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-f0bd5355 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:953 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b36e7bf6 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:954 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c63859c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:959 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-427b2bb1 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:964 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae58e3a7 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:973 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fbc32be2 | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:977 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a224237b | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:981 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6575553d | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:982 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ce85faef | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:987 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-45a91f3c | SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null … | FP00460_Setup_Group.cs:988 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.Save_Sub

진입점: SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name == "spdSub") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-731e162f | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1130 | if (siSub == null \|\| siSub.IsLock(siSub.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c828a92 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1132 | if (siSub.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33825286 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1137 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e204e08 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1138 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96eec2d2 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1141 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b87bee97 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1156 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5bd84898 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1160 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | CALL_EXT | ds.Tables[0].Rows[0][1].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9044c996 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1161 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | GRID_SET | ds.Tables[0].Rows[0][1] | count / 2 | 그리드 속성/값 설정 |  |  |  |
| AC-771aa74d | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1163 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a080ba31 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1177 | try ▸ if (siSub.SheetName == SpdSheet.shtSub) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be0117c0 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1181 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-64c49a25 | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1185 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-27b2891c | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1186 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a09386b | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1191 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-65b28bde | SaveButton [else of (fps.Name == "spdMain") ▸ if (fps.Name =… | FP00460_Setup_Group.cs:1192 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-960d19a1 | SaveButton | FP00460_Setup_Group.cs:488 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f6e74af | (진입점 미연결) | FP00460_Setup_Group.cs:1579 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00460_Setup_Group.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3acd86ba | this.spdMain.CellClick | FP00460_Setup_Group.cs:1988 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-76e42730 | this.spdMain.CellClick | FP00460_Setup_Group.cs:1989 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7d1af489 | this.spdMain.CellClick | FP00460_Setup_Group.cs:1996 | if (siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CALCULATION)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CALCULATION), dtCalculation) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6e499f34 | this.spdMain.CellClick | FP00460_Setup_Group.cs:2000 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e505627 | this.spdMain.CellDoubleClick | FP00460_Setup_Group.cs:2007 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-8634a4bc | this.spdMain.CellDoubleClick | FP00460_Setup_Group.cs:2008 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c45eb3d1 | this.spdMain.CellDoubleClick | FP00460_Setup_Group.cs:2084 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00460_Setup_Group.spdSub_CellClick

진입점: this.spdSub.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dfc3d03 | this.spdSub.CellClick | FP00460_Setup_Group.cs:1941 | try ▸ if (siSub.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fea70bb3 | this.spdSub.CellClick | FP00460_Setup_Group.cs:1958 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | POPUP | new FPC0623_OperationByInstPopup | (bFilterEnable, bMultiSelect, sInstance) | 팝업/폼 생성 |  |  |  |
| AC-29778af9 | this.spdSub.CellClick | FP00460_Setup_Group.cs:1959 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-993f1ac8 | this.spdSub.CellClick | FP00460_Setup_Group.cs:1960 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4ca23b4f | this.spdSub.CellClick | FP00460_Setup_Group.cs:1968 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex("INSTANCE_NAME"), sInstanceName) | 그리드 값 설정 |  |  |  |
| AC-41ced21a | this.spdSub.CellClick | FP00460_Setup_Group.cs:1969 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.INSTANCE_ID), sInstance) | 그리드 값 설정 |  |  |  |
| AC-04100674 | this.spdSub.CellClick | FP00460_Setup_Group.cs:1970 | try ▸ if (siSub.ActiveSheet.Columns[CAppSetting.StringAction].Visible) ▸ if (e.Column == siSub.GetColumnIndex(DefColumns.OPERATION_ID) && ac… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.OPERATION_ID), sOperation) | 그리드 값 설정 |  |  |  |
| AC-24c4451d | this.spdSub.CellClick | FP00460_Setup_Group.cs:1979 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00460_Setup_Group.UIFindData

진입점: this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables[0].Rows[0][0].ToString() == "1")] / this.btnSubImport.Click [try ▸ if (popImport.SaveSuccess == true)] / FindButton / SaveButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / InsertButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (popSetupAdd.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba5477f | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:623 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d2fa4c34 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:628 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd41ab09 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:629 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3a59f54 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:632 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c961feff | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:635 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f9d4366 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:638 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e3338622 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:638 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b86d3319 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:644 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b0dc4afb | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:647 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-410e8cca | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:653 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1fb13d20 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:654 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2f63ade | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:661 | try ▸ if (ds.Good()) | FLAG | dsMain | ds | 화면 필드/플래그 변경 |  |  |  |
| AC-c4ee0b49 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:684 | try ▸ if (ds.Good()) ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.Add | (new DataColumn("SETUP_KEY_ID_BAK", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0043084e | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:689 | try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (row["SETUP_CATEGORY_ID"].SafeString()=="ATTRIBUTE") | DATA_OP | row["SETUP_KEY_ID_BAK"] | row["SETUP_KEY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aabc89c0 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:690 | try ▸ if (ds.Good()) ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (row["SETUP_CATEGORY_ID"].SafeString()=="ATTRIBUTE") | DATA_OP | row["SETUP_KEY_ID"] | row["SETUP_KEY_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-79e23ecb | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:695 | try ▸ if (ds.Good()) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9d6702e5 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:697 | try ▸ if (ds.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5d322ed | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:700 | try ▸ if (ds.Good()) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7cd03608 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:703 | try ▸ if (ds.Good()) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3009331 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:711 | try ▸ if (ds.Good()) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-399c4b2e | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:716 | try ▸ else of (ds.Good()) | GRID_SET | spdMain.ActiveSheet.Columns["INSTANCE_ID"].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-fe1013d9 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:718 | try ▸ else of (ds.Good()) | GRID_SET | spdMain.ActiveSheet.Columns["COMPANY_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-9eee5621 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:719 | try ▸ else of (ds.Good()) | GRID_SET | spdMain.ActiveSheet.Columns["SITE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-76c37cc7 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:720 | try ▸ else of (ds.Good()) | GRID_SET | spdMain.ActiveSheet.Columns["DIVISION_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-7275046a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:724 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["INSTANCE_ID"].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-2ad4887c | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:726 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["PLANT_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e1dbbd0b | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:727 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["COMPANY_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-221edc9a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:728 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["SITE_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c9e1b00d | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:729 | try ▸ else of (ds.Good()) | GRID_SET | siSub.ActiveSheet.Columns["DIVISION_ID"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5810976a | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:735 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ed9593ae | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:736 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a5924951 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:737 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a96eaf70 | this.btnRefreshSetup.Click [try ▸ if (ds.Good() && ds.Tables… 외 4 | FP00460_Setup_Group.cs:737 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00460_SetupGroupAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32a6e56b | .ctor | FP00460_SetupGroupAddPopup.cs:78 |  | FLAG | this._sInstance | instance | 화면 필드/플래그 변경 |  |  |  |
| AC-4922854f | .ctor | FP00460_SetupGroupAddPopup.cs:79 |  | FLAG | this._sOperation | operation | 화면 필드/플래그 변경 |  |  |  |

## FP00460_SetupGroupAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bcfba0c | this.btnClose.Click | FP00460_SetupGroupAddPopup.cs:332 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00460_SetupGroupAddPopup.btnSearchOperation_Click

진입점: this.btnSearchOperation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d5f02ba | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:343 |  | POPUP | new FPC0623_OperationByInstPopup | (bFilterEnable, bMultiSelect, sInstance) | 팝업/폼 생성 |  |  |  |
| AC-8c68f971 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:344 |  | UI_PROP | popOperation.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-d7bc67c7 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:344 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5e11f41 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:345 |  | UI_PROP | popOperation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-77458b8f | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:346 |  | POPUP | popOperation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b4fdabfa | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:350 | if (popOperation.DialogResult == DialogResult.OK) | CALL_EXT | cboClass.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-76255a90 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:351 | if (popOperation.DialogResult == DialogResult.OK) | CALL_EXT | cboAttrKey.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-72dd8b19 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:353 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_CLEAR | cboCategory.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-dc8ddd2b | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:355 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | _sOperationGroup | popOperation._OperationGroupId | 화면 필드/플래그 변경 |  |  |  |
| AC-b436ab85 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:356 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | _sInstance | popOperation._InstanceId | 화면 필드/플래그 변경 |  |  |  |
| AC-6218eaff | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:360 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_SET | txtInstance.Text | sInstance | 컨트롤 값 설정 |  |  |  |
| AC-ae957162 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:361 | if (popOperation.DialogResult == DialogResult.OK) | VALUE_SET | txtOperation.Text | sOperation | 컨트롤 값 설정 |  |  |  |
| AC-0c50d401 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:363 | if (popOperation.DialogResult == DialogResult.OK) | FLAG | dtLevelKey | DataCommon.GetMasterFormCodeData(_FormProcedure, "FP00460_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-adb80bb4 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:363 | if (popOperation.DialogResult == DialogResult.OK) | COMBO_DATA | DataCommon.GetMasterFormCodeData | (_FormProcedure, "FP00460_findKey") ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52fc4e83 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:370 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) | DATA_OP | dtLevelKey.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90f3afb8 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:379 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc32fdca | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:385 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ foreach (var row in distinctR… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-a069f6c3 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:393 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ if (dtResult.Rows.Count ==0) … | MESSAGE | MessageBox.Show | ("Operation Group : " + _sOperationGroup + " Has no Class for Material Category") | 메시지 표시 |  |  |  |
| AC-ddbce8b2 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:395 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ if (dtResult.Rows.Count ==0) | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-3950f97f | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:399 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | DATA_OP | dtResult.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-9274e2bd | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:400 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d0e8dc38 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:401 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ if (dtLevelKey.Rows.Count > 0) ▸ else of (dtResult.Rows.Count … | VALUE_SET | cboClass.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-a42471cb | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:407 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtLevelKey != null) ▸ else of (dtLevelKey.Rows.Count > 0) | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-ea61ee49 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:416 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-531bb3b9 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:417 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-141590a0 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:419 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-91ad26f0 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:420 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f17c41f7 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:420 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-208ffe68 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:425 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) ▸ foreach (var row in di… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-78bb2f17 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:428 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | DATA_OP | dtResult.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-abad5180 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:429 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4abf6fa3 | this.btnSearchOperation.Click | FP00460_SetupGroupAddPopup.cs:430 | if (popOperation.DialogResult == DialogResult.OK) ▸ if (dtRefOperation != null) ▸ if (dtRefOperation.Rows.Count >0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |

## FP00460_SetupGroupAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b25b8139 | this.btnSql.Click | FP00460_SetupGroupAddPopup.cs:440 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d72e891e | this.btnSql.Click | FP00460_SetupGroupAddPopup.cs:441 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-986043ff | this.btnSql.Click | FP00460_SetupGroupAddPopup.cs:443 |  | DATA_OP | popSql.Services.Add | ("SETUP_GROUP_ADD_V2") | 데이터 객체 조작/조회 |  |  |  |
| AC-25d3edef | this.btnSql.Click | FP00460_SetupGroupAddPopup.cs:444 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00460_SetupGroupAddPopup.cboAttrKey_SelectedIndexChanged

진입점: this.cboAttrKey.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe30beb5 | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:767 | if (cboAttrKey.SelectedIndex < 0) | VALUE_CLEAR | txtAttrValue.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0acb5c83 | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:768 | if (cboAttrKey.SelectedIndex < 0) | STATE | txtAttrValue.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-a3cc93ca | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:769 | if (cboAttrKey.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-932492ee | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:774 |  | VALUE_SET | txtAttrValue.Text | value | 컨트롤 값 설정 |  |  |  |
| AC-fe8e10c6 | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:776 | if (string.IsNullOrWhiteSpace(value)) | STATE | txtAttrValue.ReadOnly | false | 컨트롤 상태 ReadOnly |  |  |  |
| AC-964c4ad2 | this.cboAttrKey.SelectedIndexChanged | FP00460_SetupGroupAddPopup.cs:778 | else of (string.IsNullOrWhiteSpace(value)) | STATE | txtAttrValue.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |

## FP00460_SetupGroupAddPopup.cboCategory_SelectionChangeCommitted

진입점: this.cboCategory.SelectionChangeCommitted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db2b1433 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:464 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4e49f04d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:465 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-151993f6 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:466 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-081eac7f | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:467 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f6c44a9e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:469 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c65f641b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:470 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | layoutAttrKeyText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-34be8617 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:471 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | layoutAttrValue.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-da2a0d9c | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:472 | if (sValue == "Item" \|\| sValue == "Jig") | UI_PROP | layoutAttrValueText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c9321f56 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:474 | if (sValue == "Item" \|\| sValue == "Jig") | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-643fd4d5 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:475 | if (sValue == "Item" \|\| sValue == "Jig") | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-16f698b1 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:477 | if (sValue == "Item" \|\| sValue == "Jig") | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-84d06b2e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:478 | if (sValue == "Item" \|\| sValue == "Jig") | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8f43a4c1 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:482 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f3b18ba3 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:483 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | layoutAttrKeyText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5ac2e247 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:484 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | layoutAttrValue.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ccd739aa | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:485 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | layoutAttrValueText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-4de65cc2 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:487 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8a7cdc57 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:488 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0e5e46e2 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:489 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-eaa31e13 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:490 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c3d0a86a | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:491 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-25dc29dc | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:495 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | DATA_OP | dtLevelKey.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a2c8e5d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:504 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae075019 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:509 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ foreach (var row in distinctRows) | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString(), row.col3.ToString(), row.col4.ToString(), row.c… | 데이터 객체 조작/조회 |  |  |  |
| AC-99bdd915 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:512 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | LIST_REBIND | clsCtrl.setListBox | (dtResult, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-04ecd1f1 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:513 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-769c5a3f | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:520 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d39b4c2 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:521 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e431993 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:522 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-1bdd3670 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:523 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | LIST_REBIND | clsCtrl.setListBox | (dtResult2, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6cf3036d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:524 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-40d92e49 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:526 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ if (dtResult.Rows.Count == 0) | MESSAGE | MessageBox.Show | ("Operation Group : " + _sOperationGroup + " Has no Class for Material Category") | 메시지 표시 |  |  |  |
| AC-b078e141 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:538 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10402b55 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:539 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0f005c8 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:543 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-17529f9e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:544 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e81ad899 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:544 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dRow.Field | ("OPERATION_GROUP_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fe07f31 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:549 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) ▸ foreach (var row in disti… | DATA_OP | dtResult2.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a88a0af8 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:553 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | DATA_OP | dtResult2.Rows.Add | ("-", "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1257c9b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:554 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | LIST_REBIND | clsCtrl.setListBox | (dtResult2, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b589477e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:555 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ if (sValue == "Material") ▸ else of (dtResult.Rows.Count == 0) | VALUE_SET | cboRefOperation.SelectedValue | "-" | 컨트롤 값 설정 |  |  |  |
| AC-c9d60329 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:562 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1eb68eb1 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:563 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | layoutAttrKeyText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-53089459 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:564 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | layoutAttrValue.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-76d32fae | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:565 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | layoutAttrValueText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c0590f82 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:569 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ea34e40c | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:570 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-f8607423 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:571 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-222bcfd4 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:572 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-3f64ff07 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:574 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fa598f44 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:575 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0ef995d5 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:579 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | FLAG | dtAttrTable | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dd3f8731 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:581 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | DATA_OP | dRow.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-80ba9bb6 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:581 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | DATA_OP | dRow.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f587f77 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:601 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1bc2724 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:602 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83f76ddb | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:605 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE1.ToString(), "ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-994211e0 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:607 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE2.ToString(), "ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-6055b3d3 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:608 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE3.ToString(), "ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-fad30106 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:609 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE4.ToString(), "ATTRIBUTE4") | 데이터 객체 조작/조회 |  |  |  |
| AC-caa439f9 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:610 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE5.ToString(), "ATTRIBUTE5") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff144b91 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:611 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE6.ToString(), "ATTRIBUTE6") | 데이터 객체 조작/조회 |  |  |  |
| AC-c40a968b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:612 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE7.ToString(), "ATTRIBUTE7") | 데이터 객체 조작/조회 |  |  |  |
| AC-798fb8f8 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:613 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE8.ToString(), "ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e72571b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:614 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE9.ToString(), "ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4c9e27c | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:616 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE10.ToString(), "ATTRIBUTE10") | 데이터 객체 조작/조회 |  |  |  |
| AC-f566d305 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:617 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE11.ToString(), "ATTRIBUTE11") | 데이터 객체 조작/조회 |  |  |  |
| AC-446943d6 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:618 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE12.ToString(), "ATTRIBUTE12") | 데이터 객체 조작/조회 |  |  |  |
| AC-afd2ed3f | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:619 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE13.ToString(), "ATTRIBUTE13") | 데이터 객체 조작/조회 |  |  |  |
| AC-1eb4f1c4 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:620 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE14.ToString(), "ATTRIBUTE14") | 데이터 객체 조작/조회 |  |  |  |
| AC-068a0336 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:621 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ foreach (var row … | DATA_OP | dtResult.Rows.Add | (row.ATTRIBUTE15.ToString(), "ATTRIBUTE15") | 데이터 객체 조작/조회 |  |  |  |
| AC-5786d79c | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:625 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ if (dtResult.Good… | FLAG | dtAttrTable | dtResult | 화면 필드/플래그 변경 |  |  |  |
| AC-4794add0 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:626 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ if (dtResult.Good… | LIST_REBIND | clsCtrl.setListBox | (dtAttrTable, cboAttrKey, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3e4a2a34 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:627 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ if (dtResult.Good… | VALUE_CLEAR | cboAttrKey.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-d5ece6ec | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:631 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c2bd6cc | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:632 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-25029f49 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:633 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-f656a24e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:634 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE4") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c5b07a8 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:635 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE5") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ce58b5e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:636 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE6") | 데이터 객체 조작/조회 |  |  |  |
| AC-c87d6c4e | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:637 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE7") | 데이터 객체 조작/조회 |  |  |  |
| AC-94f53866 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:638 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9e8d9b2 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:639 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cc2c8f6 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:640 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE10") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffe5f9e6 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:641 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE11") | 데이터 객체 조작/조회 |  |  |  |
| AC-24098528 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:642 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE12") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a00fdec | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:643 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE13") | 데이터 객체 조작/조회 |  |  |  |
| AC-234f74fb | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:644 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE14") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f3e1621 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:645 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | DATA_OP | dtResult.Rows.Add | ("", "ATTRIBUTE15") | 데이터 객체 조작/조회 |  |  |  |
| AC-41d76763 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:646 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | FLAG | dtAttrTable | dtResult | 화면 필드/플래그 변경 |  |  |  |
| AC-56b60b0b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:647 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | LIST_REBIND | clsCtrl.setListBox | (dtAttrTable, cboAttrKey, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b0269c78 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:648 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ if (sValue.IndexOf("Attribute") == 0) ▸ else of (dtResult… | VALUE_CLEAR | cboAttrKey.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-305b4336 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:653 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7089f48d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:654 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | layoutAttrKeyText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1eb0de17 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:655 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | layoutAttrValue.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-8a66488f | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:656 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | layoutAttrValueText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6dfdb24f | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:658 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e7f674cb | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:659 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1ccd0f86 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:660 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6325ccb7 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:661 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-0ce345e8 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:663 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-29b981fb | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:664 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-516c8f93 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:666 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-148c274d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:667 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ if (sValue.I… | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-18e6987b | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:672 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | lbltxtClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-826484ae | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:673 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7ec234ef | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:674 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | lbltxtRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1ade7a78 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:675 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-84dc9352 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:676 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | layoutAttribute.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6af4230a | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:677 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | layoutAttrKeyText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-18c3032d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:678 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | layoutAttrValue.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-67455e0d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:679 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | UI_PROP | layoutAttrValueText.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c96b8631 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:681 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | VALUE_SET | txtClass.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-dbcb0751 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:682 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | VALUE_SET | txtRefOperation.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-fd4b5b28 | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:684 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | STATE | txtClass.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-945ae42d | this.cboCategory.SelectionChangeCommitted | FP00460_SetupGroupAddPopup.cs:685 | else of (sValue == "Item" \|\| sValue == "Jig") ▸ else of (sValue == "Material") ▸ else of (sValue.IndexOf("Attribute") == 0) ▸ else of (sVa… | STATE | txtRefOperation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00460_SetupGroupAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6df05bf2 | Dispose | FP00460_SetupGroupAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00460_SetupGroupAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76ee827f | this.Load | FP00460_SetupGroupAddPopup.cs:88 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-131c78f5 | this.Load | FP00460_SetupGroupAddPopup.cs:90 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00460_SetupGroupAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71a02df8 | this.Load | FP00460_SetupGroupAddPopup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-25d79ca2 | this.Load | FP00460_SetupGroupAddPopup.cs:107 |  | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eab9f03 | this.Load | FP00460_SetupGroupAddPopup.cs:108 |  | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57a3baa5 | this.Load | FP00460_SetupGroupAddPopup.cs:110 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7d23dbdf | this.Load | FP00460_SetupGroupAddPopup.cs:113 |  | FLAG | dtCategory | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MA… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-5de80092 | this.Load | FP00460_SetupGroupAddPopup.cs:113 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_category", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_category] \| FP\MASTER\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-62068481 | this.Load | FP00460_SetupGroupAddPopup.cs:114 |  | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboCategory, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9f0461f6 | this.Load | FP00460_SetupGroupAddPopup.cs:115 |  | VALUE_CLEAR | cboCategory.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-945c1465 | this.Load | FP00460_SetupGroupAddPopup.cs:118 |  | FLAG | dtLevelKey | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_key", Filter.Dictionary, "MASTER"… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_key] \| FP\MASTER\FP00460_… | 화면 필드/플래그 변경 |  |  |  |
| AC-2daff5ae | this.Load | FP00460_SetupGroupAddPopup.cs:118 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_key", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_key] \| FP\MASTER\FP00460_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d6ddc0df | this.Load | FP00460_SetupGroupAddPopup.cs:119 |  | LIST_REBIND | clsCtrl.setListBox | (dtLevelKey, cboClass, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f5a4d44b | this.Load | FP00460_SetupGroupAddPopup.cs:120 |  | VALUE_CLEAR | cboClass.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-cc7d2f7f | this.Load | FP00460_SetupGroupAddPopup.cs:123 |  | DATA_OP | Filter["INSTANCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca11b991 | this.Load | FP00460_SetupGroupAddPopup.cs:124 |  | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2e09d184 | this.Load | FP00460_SetupGroupAddPopup.cs:125 |  | FLAG | dtAttribute | DataService.FP_ExecuteQuery2("FP00902_ItemSetupAttr", "get_item_list", Filter.Dictionary, … ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] \| FP\Master\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-30b588f2 | this.Load | FP00460_SetupGroupAddPopup.cs:125 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00902_ItemSetupAttr", "get_item_list", Filter.Dictionary, "Master") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_item_list] \| FP\Master\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-739ab920 | this.Load | FP00460_SetupGroupAddPopup.cs:127 |  | FLAG | dtRefOperation | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_ref_operation", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ref_operation] \| FP\MASTE… | 화면 필드/플래그 변경 |  |  |  |
| AC-7fc16151 | this.Load | FP00460_SetupGroupAddPopup.cs:127 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_ref_operation", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ref_operation] \| FP\MASTE… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7eba974c | this.Load | FP00460_SetupGroupAddPopup.cs:128 |  | LIST_REBIND | clsCtrl.setListBox | (dtRefOperation, cboRefOperation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a4b7b3ba | this.Load | FP00460_SetupGroupAddPopup.cs:129 |  | VALUE_CLEAR | cboRefOperation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-847b90d2 | this.Load | FP00460_SetupGroupAddPopup.cs:132 |  | FLAG | dtCalculation | DataService.FP_ExecuteQuery2("FP00460_SetupGroup", "find_calculation", Filter.Dictionary, … ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] \| FP\MASTER\… | 화면 필드/플래그 변경 |  |  |  |
| AC-9636506c | this.Load | FP00460_SetupGroupAddPopup.cs:132 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00460_SetupGroup", "find_calculation", Filter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_calculation] \| FP\MASTER\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bd3ee4b3 | this.Load | FP00460_SetupGroupAddPopup.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtCalculation, cboCalculation, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-98c77ece | this.Load | FP00460_SetupGroupAddPopup.cs:134 |  | VALUE_CLEAR | cboCalculation.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |
| AC-a5d8360e | this.Load | FP00460_SetupGroupAddPopup.cs:136 |  | VALUE_CLEAR | txtInstance.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-3324f53a | this.Load | FP00460_SetupGroupAddPopup.cs:137 |  | VALUE_CLEAR | txtRefOperation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f013f22b | this.Load | FP00460_SetupGroupAddPopup.cs:139 |  | VALUE_CLEAR | txtClass.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6b3415ff | this.Load | FP00460_SetupGroupAddPopup.cs:142 |  | UI_PROP | lblcboClass.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9770ca76 | this.Load | FP00460_SetupGroupAddPopup.cs:143 |  | UI_PROP | lblcboRefOperation.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3982d93e | this.Load | FP00460_SetupGroupAddPopup.cs:151 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3809af93 | this.Load | FP00460_SetupGroupAddPopup.cs:152 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-798297b5 | this.Load | FP00460_SetupGroupAddPopup.cs:153 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00460_SetupGroupAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1811b950 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:715 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrWhiteSpace(txtInstance.Text.ToString()) \|\| string.IsNullOrWhiteSpace(txtOperat… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Instance, Operation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b26387b3 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:716 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrWhiteSpace(txtInstance.Text.ToString()) \|\| string.IsNullOrWhiteSpace(txtOperat… | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d55059d7 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:720 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Category" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2dd08c96 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:721 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrEmpty(p_setup_category_id.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-2cfc276f | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:726 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrEmpty(p_calculation.ToString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Calculation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92ac0ee4 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:727 | if (programID == "SETUP_GROUP_ADD_V2") ▸ if (string.IsNullOrEmpty(p_calculation.ToString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7c3a126c | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:753 | if (programID == "SETUP_GROUP_ADD_V2") | DATA_OP | dt.Columns.Add | ("QUERY_VALUE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0be93ebf | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:754 | if (programID == "SETUP_GROUP_ADD_V2") | DATA_OP | dt.Rows.Add | ("EXEC PR_UI_FP00460_SETUP_GROUP " + "'" + p_instance_id + "', " + "'" + p_operation_id + … | 데이터 객체 조작/조회 |  |  |  |
| AC-768f208b | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:757 | if (programID == "SETUP_GROUP_ADD_V2") | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e32e9769 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:758 | if (programID == "SETUP_GROUP_ADD_V2") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-eff404c4 | popSql.OnSql | FP00460_SetupGroupAddPopup.cs:761 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00460_SetupGroupAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43a8b754 | this.btnSave.Click | FP00460_SetupGroupAddPopup.cs:182 | try ▸ if (dsResult == null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f673c204 | this.btnSave.Click | FP00460_SetupGroupAddPopup.cs:187 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ffaa2fc9 | this.btnSave.Click | FP00460_SetupGroupAddPopup.cs:188 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-d3129310 | this.btnSave.Click | FP00460_SetupGroupAddPopup.cs:189 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "1") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-130258ee | this.btnSave.Click | FP00460_SetupGroupAddPopup.cs:194 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00460_SetupGroupAddPopup.Save_Data_Add

진입점: this.btnSave.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1554f9dc | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:219 | if (string.IsNullOrWhiteSpace(txtInstance.Text.SafeString()) \|\| string.IsNullOrWhiteSpace(txtOperation.Text.SafeString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Instance, Operation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdb0ec4c | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:220 | if (string.IsNullOrWhiteSpace(txtInstance.Text.SafeString()) \|\| string.IsNullOrWhiteSpace(txtOperation.Text.SafeString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c249c373 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:224 | if (string.IsNullOrEmpty(p_setup_category_id.SafeString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Category" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5bc60dfa | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:225 | if (string.IsNullOrEmpty(p_setup_category_id.SafeString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1add5274 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:230 | if (string.IsNullOrEmpty(p_calculation.SafeString())) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Calculation" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1f6c4aa | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:231 | if (string.IsNullOrEmpty(p_calculation.SafeString())) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-64462874 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:250 | else of (p_setup_category_id.ToString() == "Item" \|\| p_setup_category_id.ToString() == "Jig") ▸ else of (p_setup_category_id.ToString() ==… | MESSAGE | MessageBox.Show | ("Check Attribute Key and Text") | 메시지 표시 |  |  |  |
| AC-9869bd4a | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:251 | else of (p_setup_category_id.ToString() == "Item" \|\| p_setup_category_id.ToString() == "Jig") ▸ else of (p_setup_category_id.ToString() ==… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-af5c6165 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:273 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-25fdc75f | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:274 | try | DATA_OP | filter["OPERATION_ID"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-61e0111f | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:275 | try | DATA_OP | filter["SETUP_CATEGORY_ID"] | p_setup_category_id.Equals("ALL") ? "-" : p_setup_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-7ad7cdca | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:276 | try | DATA_OP | filter["SETUP_KEY_ID"] | p_setup_key_id.Equals("ALL") ? "-" : p_setup_key_id | 행/컬럼 값 대입 |  |  |  |
| AC-99281782 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:277 | try | DATA_OP | filter["LEVEL"] | p_level | 행/컬럼 값 대입 |  |  |  |
| AC-079c3433 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:278 | try | DATA_OP | filter["REFERANCE_OPERATION_ID"] | p_referance_operation_id.Equals("ALL") ? "-" : p_referance_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-45b97214 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:279 | try | DATA_OP | filter["CALCULATION"] | p_calculation.Equals("ALL") ? "-" : p_calculation | 행/컬럼 값 대입 |  |  |  |
| AC-a716f9dd | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:280 | try | DATA_OP | filter["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d78c22a3 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:281 | try | DATA_OP | filter["LINE_SETUP_GROUP_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-284e4e43 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:282 | try | DATA_OP | filter["ORG_LINE_SETUP_GROUP_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8bf04f30 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:283 | try | DATA_OP | filter["INSTANCE_ID"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-de2b591a | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:286 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | DATA_OP | filter["SETUP_CATEGORY_ID"] | p_setup_category_id.ToUpper() | 행/컬럼 값 대입 |  |  |  |
| AC-a6713860 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:290 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) ▸ for (i< 15) | DATA_OP | filter[filter_key] | dtAttrTable.Rows[i]["CODE"].SafeString() | 행/컬럼 값 대입 |  |  |  |
| AC-aefb8258 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:293 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) ▸ for (i< 15) ▸ if (p_setup_key_id == filter_key) | DATA_OP | filter[filter_key] | txtAttrValue.Text | 행/컬럼 값 대입 |  |  |  |
| AC-9c85c82c | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:297 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), pSysType, "EXECUTE_ADD_ATTR") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-202529e8 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:297 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9aff9ddd | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:298 | try ▸ if (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-7b1dbc4d | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:302 | try ▸ else of (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00460_SETUP_GROUP_V2", filter.Copy(), pSysType, "EXECUTE_ADD_V2") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-32a4108a | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:302 | try ▸ else of (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | DATA_OP | filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-26639aa6 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:303 | try ▸ else of (p_setup_category_id.ToString().IndexOf("Attribute") == 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-10d5f9a9 | this.btnSave.Click [try] | FP00460_SetupGroupAddPopup.cs:309 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

