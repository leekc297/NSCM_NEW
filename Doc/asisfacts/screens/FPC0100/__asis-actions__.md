# AS-IS 액션 대조표 — FPC0100

> 원천: `Doc/asisfacts/screens/FPC0100/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 794행 · 메서드 77 · 종류 DATA_OP 154 · RETURN 126 · FLAG 94 · MESSAGE 57 · GRID_INIT 47 · UI_PROP 46 · ENDPOINT 44 · STATE 37 · UI_MISC 34 · GRID_SET 33 · POPUP 30 · CALL_EXT 27 · GRID_LOCK 10 · GRID_BIND 10 · CALL_BASE 9 · THROW 7 · VALIDATE 6 · GRID_STYLE 6 · FOCUS 4 · EXCEL 4 · COMBO_DATA 3 · VALUE_SET 3 · LIST_BIND 2 · STATE_RESET 1 · ⚠ 의미 확인 필요 36


## FPC0100_ExcelImportPopup_WIP..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f3ac88f | .ctor | FPC0100_ExcelImportPopup_WIP.cs:95 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-aab389cb | .ctor | FPC0100_ExcelImportPopup_WIP.cs:96 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-5eddeb0b | .ctor | FPC0100_ExcelImportPopup_WIP.cs:97 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-512e800a | .ctor | FPC0100_ExcelImportPopup_WIP.cs:98 |  | FLAG | this.sParamsValue | pParamsValue | 화면 필드/플래그 변경 |  |  |  |
| AC-d121ea61 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:99 |  | FLAG | this.sParamsList | pParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-4b9ecc75 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:102 | if (pServiceCallName.IndexOf("FP_Analysis") != -1) | FLAG | this.sPgmBinding | sAnalysisBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-75077439 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:104 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ if (pServiceCallName.IndexOf("FP_Common") != -1) | FLAG | this.sPgmBinding | sCommonBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-87a351d1 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:106 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ if (pServiceCallName.Index… | FLAG | this.sPgmBinding | sMasterBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-7f018063 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:108 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ else of (pServiceCallName.… | FLAG | this.sPgmBinding | sPlanningBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-c3226cc7 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:111 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-726199a5 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:115 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-8745d577 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:116 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-78fce707 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:120 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | MESSAGE | MessageBox.Show | ("the Value/List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4c2a4304 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:121 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-06634368 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:128 |  | FLAG | iParmsCount | arrList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-49f8063f | .ctor | FPC0100_ExcelImportPopup_WIP.cs:130 |  | UI_PROP | structParam._sDbParamsList | new string[iParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-39484a38 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:131 |  | UI_PROP | structParam._sParamFilter | new string[iParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-87f44946 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:136 | for (i < iParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-80135a65 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:137 | for (i < iParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrValue[i] | 행/컬럼 값 대입 |  |  |  |
| AC-e599ce2f | .ctor | FPC0100_ExcelImportPopup_WIP.cs:139 | for (i < iParmsCount) | DATA_OP | pParams.Add | (String.Format("p_param{0}", i.ToString()), "") | 데이터 객체 조작/조회 |  |  |  |
| AC-427d39f4 | .ctor | FPC0100_ExcelImportPopup_WIP.cs:145 | if (!string.IsNullOrEmpty(pHiddenColumns)) | FLAG | _arrHiddenColumns | pHiddenColumns.Split('\|') | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8748e3ec | this.btnClose.Click | FPC0100_ExcelImportPopup_WIP.cs:960 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01eab185 | this.btnExport.Click | FPC0100_ExcelImportPopup_WIP.cs:847 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-43fa6a71 | this.btnExport.Click | FPC0100_ExcelImportPopup_WIP.cs:848 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8bb7bf5 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:862 | try | CALL_EXT | siComExcel.GetSpdTitle | (sProgramId, UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95e809b6 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:865 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-56fedec7 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:866 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-bcaa5fb1 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:868 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-8e52ea7d | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:869 | try | UI_PROP | opd.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-e0fe5d82 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:870 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-f04a8560 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:872 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-09a6d5fb | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:875 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile_colZero | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bff59e89 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:881 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e7c9a34 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:881 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a3f51b7 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:885 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f84a2d05 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:886 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7beada46 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:890 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f0029da | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:894 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | LIST_BIND | spdComExcel.DataSource | dtExcel | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ed35bd6d | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:897 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-30972e71 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:899 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-edb1b706 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:900 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aaa5a4d1 | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:914 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fefaa63f | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:914 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a18b20ac | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:927 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "S… | FLAG | bUpload | true | 화면 필드/플래그 변경 |  |  |  |
| AC-26f39d6d | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:934 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ else of (dst.Tables[0].Rows[0][0].ToString() … | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90b6822a | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:943 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bd4367f | this.btnImport.Click | FPC0100_ExcelImportPopup_WIP.cs:954 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0100_ExcelImportPopup_WIP.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e028f620 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:966 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-21fc1464 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:967 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-dc394278 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:969 |  | DATA_OP | popSql.Services.Add | ("SELECT_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-15bf2a16 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:970 |  | DATA_OP | popSql.Services.Add | ("SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5d0b640 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:971 |  | DATA_OP | popSql.Services.Add | ("INSERT_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddbe2dd2 | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:972 |  | DATA_OP | popSql.Services.Add | ("INSERT_EXCEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8e2535a | this.btnSql.Click | FPC0100_ExcelImportPopup_WIP.cs:973 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.CheckNullDataTableValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be8e0733 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1041 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-92d76421 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1041 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e86081d1 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1044 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b4405574 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1048 | for (iRow < dtSheetColumn.Rows.Count) | DATA_OP | dtVal.Columns.Add | (dtSheetColumn.Rows[iRow]["COLUMN_NAME"].ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4715545a | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1053 | foreach (var row in dt.Rows) | DATA_OP | dtVal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4afbbdcc | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1056 | foreach (var row in dt.Rows) ▸ for (i < ((System.Data.DataRow)row).ItemArray.Length) | DATA_OP | dr[i] | (((System.Data.DataRow)row).ItemArray[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-6ed23455 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1059 | foreach (var row in dt.Rows) | DATA_OP | dtVal.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fdff92c | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1084 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count - 2] | " Not Null : " + actionText | 그리드 속성/값 설정 |  |  |  |
| AC-2b5586ac | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1085 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count - 1] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-cf280afd | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1094 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-ee069f09 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:1096 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.CheckNullSpreadValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1d0d50 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:995 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e874153 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:995 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b8e5558 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:998 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2c82d6c9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1022 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex() - 1].Text | actionText + " Not Null : " + siComExcel.GetText(i, siComExcel.GetMaxColumnIndex() - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-d4bcff05 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1023 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex()].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-dbf215db | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1024 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-1f05831d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1032 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-6814e661 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1034 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f353e478 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:204 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-426630ba | this.Load | FPC0100_ExcelImportPopup_WIP.cs:205 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2e8df1e | this.Load | FPC0100_ExcelImportPopup_WIP.cs:207 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa8e0853 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Delete_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-148a49b1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:779 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-a75b64a8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:783 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cdf7efac | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:785 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-6ee19099 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:788 | try ▸ if (this.sSheetName == "LineExcelPopup_WIP") | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER_WIP" | 행/컬럼 값 대입 |  |  |  |
| AC-12e9d13d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:792 | try ▸ else of (this.sSheetName == "LineExcelPopup_WIP") | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-b8bcce3b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:795 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-829367ac | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:796 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b0f8e8f3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:801 | try ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b31acb4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:804 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24e2af93 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:819 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-827a4634 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:822 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-f7e2a55f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:826 | catch () | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a096d4a4 | Dispose | FPC0100_ExcelImportPopup_WIP.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5e5794c | EditButton | FPC0100_ExcelImportPopup_WIP.cs:274 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8824f385 | EditButton | FPC0100_ExcelImportPopup_WIP.cs:275 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34226a0e | ExcelButton | FPC0100_ExcelImportPopup_WIP.cs:306 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Find_Data

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / this.Load / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d79ff6d5 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:314 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bc2e0a68 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:318 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e909e1c0 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:321 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5448593d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:321 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-895cdec2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:327 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f70818ed | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:330 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c4ec2f6 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:336 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc31f199 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:349 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-72fc6a5c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:351 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-85fdbd65 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:354 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-28eb14ba | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:357 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2fd4d15a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:360 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-efe490be | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:371 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-e025fd4b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:380 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-09bca1a4 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup_WIP.cs:381 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Find_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_IMPORT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f712d26f | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:392 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-6b7462ef | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:394 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-b714b67f | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:395 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-80a34029 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:398 | try ▸ if (this.sSheetName == "LineExcelPopup_WIP") | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT_WIP" | 행/컬럼 값 대입 |  |  |  |
| AC-fdc81bb5 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:401 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a9c6085b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:402 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d974c9b4 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:406 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-039791ec | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:410 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d183695e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:412 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-7ddc72de | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:418 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Find_Data_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f540439 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:432 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-eceb2039 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:434 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-d23fe304 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:435 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID_WIP" | 행/컬럼 값 대입 |  |  |  |
| AC-0f56c5ec | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:436 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0389e2a3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:437 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-12906537 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:441 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-e935399d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:445 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ccf9bef | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:448 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-674acf3a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:454 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Find_Save_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8d15c18 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:464 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-04be41ad | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:469 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5896e59d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:472 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-b18f2274 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:472 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ca853ee | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:478 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9c775b3d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:481 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4d6d6db | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:497 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-59dea9c6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:506 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d35a5682 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:509 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f893740b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:520 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-36271a9f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:525 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-34ef28a4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:529 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d19a11de | this.Load | FPC0100_ExcelImportPopup_WIP.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f52e2cb5 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2dc4d7f9 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:169 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |
| AC-281d6d72 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:171 |  | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d3067ca | this.Load | FPC0100_ExcelImportPopup_WIP.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fb17ab5 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-21396c7f | this.Load | FPC0100_ExcelImportPopup_WIP.cs:188 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4b3f53b2 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:189 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5b2fc3fc | this.Load | FPC0100_ExcelImportPopup_WIP.cs:190 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d295ce8 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:220 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ee0e3c6 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:221 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f42eacb0 | this.Load | FPC0100_ExcelImportPopup_WIP.cs:228 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2acb060 | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1172 | if (programID == "SELECT_IMPORT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-83d07151 | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1177 | else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1023f46c | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1186 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2c209d8d | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1186 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9fe9fcf | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1190 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ else of (spdComExcel.Ac… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1c3b4358 | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1194 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-9e36bfab | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1200 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-4a36dbdb | popSql.OnSql | FPC0100_ExcelImportPopup_WIP.cs:1203 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ff4c452 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:538 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3346f92e | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:540 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83f12572 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:544 | if (bUpload == false) | MESSAGE | MessageBox.Show | ("After Excel Upload, Try Again!", "Upload Error", MessageBoxButtons.OK, MessageBoxIcon.Er… | 메시지 표시 |  |  |  |
| AC-fdf33aa3 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:545 | if (bUpload == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fda96265 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:552 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc5cae65 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:553 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e28812a4 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:557 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5cd824dd | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:572 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsv.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-725979ff | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:582 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ else of (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-8ae90adb | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:586 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7ba0f7ba | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:590 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c40ae7db | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:591 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2d10bf08 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:595 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5654c98d | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup_WIP.cs:596 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Save_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940a1b45 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:690 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-44056c3c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:703 | try ▸ for (i < sParm.Length) | DATA_OP | sParm[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eceb157e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:739 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-bbf130e0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:743 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cdb45b8d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:745 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-3b4b7595 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:746 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d6c13a41 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:747 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-22c60d24 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:748 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fcb9553 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:753 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k] | 행/컬럼 값 대입 |  |  |  |
| AC-656b4b24 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:755 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4fd30f15 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:757 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c16257d0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:763 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b94485ca | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup_WIP.cs:768 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.Save_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "INSERT_EXCEL")] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13c559b6 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:617 | try ▸ for (i < sParams.Length) | DATA_OP | sParams[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-15e24a24 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:631 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) ▸ if (this.sSheetName != "LineExce… | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { sMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a981448d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:632 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) ▸ if (this.sSheetName != "LineExce… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6eb2ad4a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:653 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-816d2e7b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:657 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e3240855 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:659 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d161b5ac | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:660 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b1baabd1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:661 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-6161711b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:662 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-2c04d27a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:666 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParams[k] | 행/컬럼 값 대입 |  |  |  |
| AC-32e16781 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:669 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7865300b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:671 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-dcd12f78 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:676 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-b4689181 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup_WIP.cs:681 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b86746f5 | SaveButton | FPC0100_ExcelImportPopup_WIP.cs:300 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.SetSheetHeadColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds != null) ▸ if (ds.Tables[0].Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-677d166c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:1141 | try ▸ for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siComExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-f30c37eb | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup_WIP.cs:1149 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.SetSheetHeaderWidth

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e383b55e | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:1161 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-73585713 | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:1162 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d2500c6 | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:236 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12374d8a | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:237 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-526ba042 | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:241 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-734fb0c8 | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:249 | if (_arrHiddenColumns != null) ▸ if (_arrHiddenColumns.Length > 0) ▸ for (i < _arrHiddenColumns.Length) | GRID_SET | siComExcel.ActiveSheet.Columns[_arrHiddenColumns[i]].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6af2b955 | this.Load [try] | FPC0100_ExcelImportPopup_WIP.cs:253 |  | GRID_INIT | siComExcel.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.SetValidationResultSheetColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (this.sSheetName != "LineExcelPopup_WIP")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b579b2f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1115 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N"… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-c9121cd3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1122 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-39c7be0d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup_WIP.cs:1125 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup_WIP.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9dcd068 | (진입점 미연결) | FPC0100_ExcelImportPopup_WIP.cs:982 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d9d1872 | .ctor | FPC0100_ExcelImportPopup.cs:95 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a15af7a4 | .ctor | FPC0100_ExcelImportPopup.cs:96 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-2b163940 | .ctor | FPC0100_ExcelImportPopup.cs:97 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-0ee15c7c | .ctor | FPC0100_ExcelImportPopup.cs:98 |  | FLAG | this.sParamsValue | pParamsValue | 화면 필드/플래그 변경 |  |  |  |
| AC-fa49b2e8 | .ctor | FPC0100_ExcelImportPopup.cs:99 |  | FLAG | this.sParamsList | pParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-77a80637 | .ctor | FPC0100_ExcelImportPopup.cs:102 | if (pServiceCallName.IndexOf("FP_Analysis") != -1) | FLAG | this.sPgmBinding | sAnalysisBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-eac217a0 | .ctor | FPC0100_ExcelImportPopup.cs:104 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ if (pServiceCallName.IndexOf("FP_Common") != -1) | FLAG | this.sPgmBinding | sCommonBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-868b363c | .ctor | FPC0100_ExcelImportPopup.cs:106 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ if (pServiceCallName.Index… | FLAG | this.sPgmBinding | sMasterBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-d600e415 | .ctor | FPC0100_ExcelImportPopup.cs:108 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ else of (pServiceCallName.… | FLAG | this.sPgmBinding | sPlanningBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-8880fbab | .ctor | FPC0100_ExcelImportPopup.cs:111 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-b841c254 | .ctor | FPC0100_ExcelImportPopup.cs:115 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-2fdec7c4 | .ctor | FPC0100_ExcelImportPopup.cs:116 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-21b2c581 | .ctor | FPC0100_ExcelImportPopup.cs:120 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | MESSAGE | MessageBox.Show | ("the Value/List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-44494d03 | .ctor | FPC0100_ExcelImportPopup.cs:121 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3c52beaf | .ctor | FPC0100_ExcelImportPopup.cs:128 |  | FLAG | iParmsCount | arrList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-1cd8b2c4 | .ctor | FPC0100_ExcelImportPopup.cs:130 |  | UI_PROP | structParam._sDbParamsList | new string[iParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-4bf9b006 | .ctor | FPC0100_ExcelImportPopup.cs:131 |  | UI_PROP | structParam._sParamFilter | new string[iParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-cff2f9b5 | .ctor | FPC0100_ExcelImportPopup.cs:136 | for (i < iParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-b2a6e0ab | .ctor | FPC0100_ExcelImportPopup.cs:137 | for (i < iParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrValue[i] | 행/컬럼 값 대입 |  |  |  |
| AC-db306c0e | .ctor | FPC0100_ExcelImportPopup.cs:139 | for (i < iParmsCount) | DATA_OP | pParams.Add | (String.Format("p_param{0}", i.ToString()), "") | 데이터 객체 조작/조회 |  |  |  |
| AC-800e5186 | .ctor | FPC0100_ExcelImportPopup.cs:145 | if (!string.IsNullOrEmpty(pHiddenColumns)) | FLAG | _arrHiddenColumns | pHiddenColumns.Split('\|') | 화면 필드/플래그 변경 |  |  |  |
| AC-915cb894 | .ctor | FPC0100_ExcelImportPopup.cs:95 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-ffaa13b3 | .ctor | FPC0100_ExcelImportPopup.cs:96 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-f60907dd | .ctor | FPC0100_ExcelImportPopup.cs:97 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-bfc65d7a | .ctor | FPC0100_ExcelImportPopup.cs:98 |  | FLAG | this.sParamsValue | pParamsValue | 화면 필드/플래그 변경 |  |  |  |
| AC-9b66e85d | .ctor | FPC0100_ExcelImportPopup.cs:99 |  | FLAG | this.sParamsList | pParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-9d5ef038 | .ctor | FPC0100_ExcelImportPopup.cs:102 | if (pServiceCallName.IndexOf("FP_Analysis") != -1) | FLAG | this.sPgmBinding | sAnalysisBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-c6b74f2a | .ctor | FPC0100_ExcelImportPopup.cs:104 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ if (pServiceCallName.IndexOf("FP_Common") != -1) | FLAG | this.sPgmBinding | sCommonBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-1103c543 | .ctor | FPC0100_ExcelImportPopup.cs:106 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ if (pServiceCallName.Index… | FLAG | this.sPgmBinding | sMasterBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-d4e7548d | .ctor | FPC0100_ExcelImportPopup.cs:108 | else of (pServiceCallName.IndexOf("FP_Analysis") != -1) ▸ else of (pServiceCallName.IndexOf("FP_Common") != -1) ▸ else of (pServiceCallName.… | FLAG | this.sPgmBinding | sPlanningBinding | 화면 필드/플래그 변경 |  |  |  |
| AC-68b1b549 | .ctor | FPC0100_ExcelImportPopup.cs:111 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-c14d4620 | .ctor | FPC0100_ExcelImportPopup.cs:115 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-61c298b9 | .ctor | FPC0100_ExcelImportPopup.cs:116 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-350123e5 | .ctor | FPC0100_ExcelImportPopup.cs:120 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | MESSAGE | MessageBox.Show | ("the Value/List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f459b476 | .ctor | FPC0100_ExcelImportPopup.cs:121 | if (string.IsNullOrEmpty(this.sParamsValue) \|\| string.IsNullOrEmpty(this.sParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c5469503 | .ctor | FPC0100_ExcelImportPopup.cs:128 |  | FLAG | iParmsCount | arrList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-07fce2ff | .ctor | FPC0100_ExcelImportPopup.cs:130 |  | UI_PROP | structParam._sDbParamsList | new string[iParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-a8adb0ef | .ctor | FPC0100_ExcelImportPopup.cs:131 |  | UI_PROP | structParam._sParamFilter | new string[iParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-042b5986 | .ctor | FPC0100_ExcelImportPopup.cs:136 | for (i < iParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrList[i] | 행/컬럼 값 대입 |  |  |  |
| AC-0de9a8cb | .ctor | FPC0100_ExcelImportPopup.cs:137 | for (i < iParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrValue[i] | 행/컬럼 값 대입 |  |  |  |
| AC-5fd4b1ae | .ctor | FPC0100_ExcelImportPopup.cs:139 | for (i < iParmsCount) | DATA_OP | pParams.Add | (String.Format("p_param{0}", i.ToString()), "") | 데이터 객체 조작/조회 |  |  |  |
| AC-0cbd730a | .ctor | FPC0100_ExcelImportPopup.cs:145 | if (!string.IsNullOrEmpty(pHiddenColumns)) | FLAG | _arrHiddenColumns | pHiddenColumns.Split('\|') | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e6ab5a3 | this.btnClose.Click | FPC0100_ExcelImportPopup.cs:924 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-372e2282 | this.btnClose.Click | FPC0100_ExcelImportPopup.cs:976 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup.btnExport_Click

진입점: this.btnExport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f47b10e1 | this.btnExport.Click | FPC0100_ExcelImportPopup.cs:812 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-fed4a477 | this.btnExport.Click | FPC0100_ExcelImportPopup.cs:813 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-045705ae | this.btnExport.Click | FPC0100_ExcelImportPopup.cs:849 |  | FOCUS | siComExcel.SpreadObject.Focus | () | 포커스 이동 |  |  |  |
| AC-41603b78 | this.btnExport.Click | FPC0100_ExcelImportPopup.cs:850 |  | CALL_BASE | OnClickExcelButton | () | ⚠ 의미 확인 필요 |  |  |  |

## FPC0100_ExcelImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-716c6faf | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:827 | try | CALL_EXT | siComExcel.GetSpdTitle | (sProgramId, UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-884c2db1 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:830 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-0e296f63 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:831 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-20e7a500 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:833 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-7cf185f3 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:834 | try | UI_PROP | opd.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-ecb396bd | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:835 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-71c33b82 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:837 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dd19bb5f | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:840 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0ffaefe0 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:846 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a776eb4f | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:846 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-48870e03 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:850 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf69add9 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:851 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc9da6cd | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:855 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9aba3c65 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:856 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dtExcel.AsEnumerable().CopyToDataTable | (dtData, LoadOption.Upsert) | 데이터 객체 조작/조회 |  |  |  |
| AC-e315609d | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:858 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | LIST_BIND | spdComExcel.DataSource | dtData | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-6f5264ea | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:861 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f6d810f | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:863 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0df7df0 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:864 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ecfcb694 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:878 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c532fde9 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:878 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8790752c | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:891 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "S… | FLAG | bUpload | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8e459838 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:898 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ else of (dst.Tables[0].Rows[0][0].ToString() … | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c24c368 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:907 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7d954101 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:918 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16337a8e | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:864 | try | CALL_EXT | siComExcel.GetSpdTitle | (sProgramId, UserInfoContext.Current.UserId, sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82af3930 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:867 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-aec777e3 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:868 | try | UI_PROP | opd.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-cafa18ce | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:870 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-77946269 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:871 | try | UI_PROP | opd.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-3ecc6765 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:872 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-729c3990 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:874 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d931eb5f | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:877 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iColCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fd5be0e3 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:886 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) ▸ if (dsTmp.Good()) | DATA_OP | dsTmp.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-77a08fa8 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:890 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) ▸ else of (dsTmp.Good()) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-48100aee | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:890 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) ▸ else of (dsTmp.Good()) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b3877bf | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:895 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-395b5c51 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:896 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (spdComExcel.ActiveSheet.ColumnHeader.RowCount > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3529a1d6 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:900 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dt.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dcd5fe40 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:901 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dtExcel.AsEnumerable().CopyToDataTable | (dtData, LoadOption.Upsert) | 데이터 객체 조작/조회 |  |  |  |
| AC-bab89704 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:905 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ foreach (DataRow eR in dtData.Rows) ▸ if (eR["ELECTRODE_TYPE"].ToString() == "") | DATA_OP | eR["ELECTRODE_TYPE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-c20e9686 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:909 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | DATA_OP | dsNew.Tables.Add | (dtData) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe30c24 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:910 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_BIND | siComExcel.Query | (dsNew) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bd2f13b8 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:913 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-044d7463 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:915 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66dc6b05 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:916 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8413a33 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:930 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-baa3bb9a | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:930 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f40b40cb | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:943 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "S… | FLAG | bUpload | true | 화면 필드/플래그 변경 |  |  |  |
| AC-17c26402 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:950 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ else of (dst.Tables[0].Rows[0][0].ToString() … | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c60a7667 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:959 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ else of (dst != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00204", new object[] { errorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc98d6b5 | this.btnImport.Click | FPC0100_ExcelImportPopup.cs:970 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FPC0100_ExcelImportPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbeec3c9 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:930 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6428f26f | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:931 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3ff1e538 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:933 |  | DATA_OP | popSql.Services.Add | ("SELECT_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-17db1a93 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:934 |  | DATA_OP | popSql.Services.Add | ("SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-82d6e8e4 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:935 |  | DATA_OP | popSql.Services.Add | ("INSERT_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-1901658a | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:936 |  | DATA_OP | popSql.Services.Add | ("INSERT_EXCEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9feba34 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:937 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e996170c | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:982 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-24e391c7 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:983 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e426cea6 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:985 |  | DATA_OP | popSql.Services.Add | ("SELECT_IMPORT") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb84a7c2 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:986 |  | DATA_OP | popSql.Services.Add | ("SELECT_VALID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cad5c6df | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:987 |  | DATA_OP | popSql.Services.Add | ("INSERT_BUFFER") | 데이터 객체 조작/조회 |  |  |  |
| AC-924de6c2 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:988 |  | DATA_OP | popSql.Services.Add | ("INSERT_EXCEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b06f87d5 | this.btnSql.Click | FPC0100_ExcelImportPopup.cs:989 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FPC0100_ExcelImportPopup.CheckNullDataTableValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9300d91d | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1005 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a916b9c | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1005 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5775092b | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1008 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-035f83eb | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1012 | for (iRow < dtSheetColumn.Rows.Count) | DATA_OP | dtVal.Columns.Add | (dtSheetColumn.Rows[iRow]["COLUMN_NAME"].ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d86b488d | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1017 | foreach (var row in dt.Rows) | DATA_OP | dtVal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b528c06 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1020 | foreach (var row in dt.Rows) ▸ for (i< ((System.Data.DataRow)row).ItemArray.Length) | DATA_OP | dr[i] | (((System.Data.DataRow)row).ItemArray[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-9a6703bb | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1023 | foreach (var row in dt.Rows) | DATA_OP | dtVal.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d84c0c0 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1048 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count-2] | " Not Null : " + actionText | 그리드 속성/값 설정 |  |  |  |
| AC-5d602956 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1049 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count - 1] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-b76ed2aa | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1058 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-2a132918 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1060 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-a02553ae | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1057 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-59ac1c1d | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1057 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a3f64be | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1060 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3c5111fd | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1064 | for (iRow < dtSheetColumn.Rows.Count) | DATA_OP | dtVal.Columns.Add | (dtSheetColumn.Rows[iRow]["COLUMN_NAME"].ToString(), typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d27b6d9f | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1069 | foreach (var row in dt.Rows) | DATA_OP | dtVal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c3a0b88 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1072 | foreach (var row in dt.Rows) ▸ for (i< ((System.Data.DataRow)row).ItemArray.Length) | DATA_OP | dr[i] | (((System.Data.DataRow)row).ItemArray[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-f608798b | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1075 | foreach (var row in dt.Rows) | DATA_OP | dtVal.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9715a51 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1100 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count-2] | " Not Null : " + actionText | 그리드 속성/값 설정 |  |  |  |
| AC-d141a72c | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1101 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i < dtVal.Rows.Count) ▸ if (string.IsNullOrEmpty(action)) | GRID_SET | dtVal.Rows[i][dt.Columns.Count - 1] | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-61f7ee3e | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1110 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-9356012d | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:1112 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.CheckNullSpreadValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91461157 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:959 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e0dbfb3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:959 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0eb190e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:962 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b6ef9015 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:986 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex() - 1].Text | actionText + " Not Null : " + siComExcel.GetText(i, siComExcel.GetMaxColumnIndex() - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-b799dd8b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:987 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex()].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-01f8dbc7 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:988 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-709f5451 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:996 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-e969a018 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:998 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-6fe43501 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1011 |  | FLAG | dtSheetColumn | siComExcel.GetSpdTitle(this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-62831ced | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1011 |  | CALL_EXT | siComExcel.GetSpdTitle | (this.sProgramId, UserInfoContext.Current.UserId, this.sSheetName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77233034 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1014 | if (dtSheetColumn.Rows.Count == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-384b6525 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1038 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex() - 1].Text | actionText + " Not Null : " + siComExcel.GetText(i, siComExcel.GetMaxColumnIndex() - 1) | 그리드 속성/값 설정 |  |  |  |
| AC-c5d98ed5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1039 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, siComExcel.GetMaxColumnIndex()].Text | "N" | 그리드 속성/값 설정 |  |  |  |
| AC-a7030a91 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1040 | try ▸ for (iRow < dtSheetColumn.Rows.Count) ▸ if (sData.IndexOf("*") != -1) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrE… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-96d4927a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1048 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-3b6a4d98 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1050 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cdc8654 | this.Load | FPC0100_ExcelImportPopup.cs:204 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2d62cc1c | this.Load | FPC0100_ExcelImportPopup.cs:205 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-091defb0 | this.Load | FPC0100_ExcelImportPopup.cs:207 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22820d30 | this.Load | FPC0100_ExcelImportPopup.cs:204 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34d88f52 | this.Load | FPC0100_ExcelImportPopup.cs:205 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-af598bcd | this.Load | FPC0100_ExcelImportPopup.cs:207 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0100_ExcelImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ded6baaf | this.Load | FPC0100_ExcelImportPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-2ca1ec94 | this.Load | FPC0100_ExcelImportPopup.cs:197 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0100_ExcelImportPopup.Delete_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5097a28 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:752 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-c81a81e9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:756 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e8d883ab | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:758 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-6a164255 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:759 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-4689ccf9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:760 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-da5a7b0d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:761 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d364aa3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:766 | try ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fc590f0b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:769 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a24fcdb9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:784 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ec1f49c6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:787 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-92d1642b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:791 | catch () | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-a24a347d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:789 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-1700007d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:793 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ec23bd5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:795 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-bebce680 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:796 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-bdb295df | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:797 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fe62bf4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:798 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a5196304 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:803 | try ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38a7b054 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:806 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f2803867 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:821 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7e513f16 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:824 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-2d375ff0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:828 | catch () | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2abb9bfd | Dispose | FPC0100_ExcelImportPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-8a839dd0 | Dispose | FPC0100_ExcelImportPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-383bef49 | EditButton | FPC0100_ExcelImportPopup.cs:274 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcd3a29c | EditButton | FPC0100_ExcelImportPopup.cs:275 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fb4d8d2 | EditButton | FPC0100_ExcelImportPopup.cs:274 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-542fde1d | EditButton | FPC0100_ExcelImportPopup.cs:275 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4762735a | ExcelButton | FPC0100_ExcelImportPopup.cs:306 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |
| AC-91b46adb | ExcelButton | FPC0100_ExcelImportPopup.cs:306 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FPC0100_ExcelImportPopup.Find_Data

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / this.Load / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-628a3b5e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:314 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1d523fb5 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:318 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3ef1242 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:321 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4a6f6bee | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:321 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22974dab | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:327 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-05e23b25 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:330 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab1bde81 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:336 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8b2ad484 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:349 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c65b6018 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:351 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b067df8b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:354 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b6edc81 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:357 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ab33953 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:360 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08ae062c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:371 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-25c95324 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:380 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2c4039a1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:381 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6f0d052b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:314 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-21b89c9b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:318 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4ad947b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:321 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-639c4d4c | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:321 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5af9631 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:327 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ad333d0e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:330 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8b59bc1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:336 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-221f6644 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:349 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-252cefe2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:351 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-feffac88 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:354 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-16796e1f | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:357 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-79eee60b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:360 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-78d61c04 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:371 | try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-cdc3c99a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:380 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4396cab4 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 4 | FPC0100_ExcelImportPopup.cs:381 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup.Find_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_IMPORT")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-effeba04 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:392 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-31370160 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:394 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-c1c8753a | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:395 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-216317ba | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:396 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-710dce50 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:397 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-88ea3270 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:401 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-aaa732fc | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:405 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33b4f22e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:407 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1ab7bd5b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:413 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-5596667b | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:392 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-5f3a6369 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:394 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e209d7f8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:395 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_IMPORT" | 행/컬럼 값 대입 |  |  |  |
| AC-cdf86f08 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:396 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a845f89d | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:397 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e9272f46 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:401 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-244641d1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:405 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa49a772 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:407 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1c2d6acc | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 5 | FPC0100_ExcelImportPopup.cs:413 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.Find_Data_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e574ee0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:427 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-ea704207 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:429 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-e9e1078f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:430 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-b9a9e1cf | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:431 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1f57e7c3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:432 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0016243d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:436 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-16dace2c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:440 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d38156b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:443 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f5638e63 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:449 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-9b25afac | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:427 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-a19a5f29 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:429 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-443b0149 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:430 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-fcd06525 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:431 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a35a533 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:432 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b2d8565a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:436 | try ▸ for (i < iParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-39a34b38 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:440 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-10c77215 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:443 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-0de3537b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:449 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.Find_Save_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-280d16f2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:459 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2737833c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:464 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f62b9934 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:467 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-744118ed | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:467 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fbae45d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:473 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fc34efe2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:476 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78c2d81e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:492 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ca0bee9d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:498 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5cfee01b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:501 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3c8208e0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:512 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-8831096f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:517 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a0ea61b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:521 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e4d63768 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:459 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5efd4e90 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:464 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57088583 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:467 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-54587653 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:467 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39e5c02f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:473 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-039966f3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:476 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63053442 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:492 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0943649a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:498 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d1359a6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:501 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ee9c6c17 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:512 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-dfdec6cc | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:517 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37dd08a2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:521 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_ExcelImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebf6bcff | this.Load | FPC0100_ExcelImportPopup.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6eb507ad | this.Load | FPC0100_ExcelImportPopup.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7db4b5c4 | this.Load | FPC0100_ExcelImportPopup.cs:169 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |
| AC-fad77c12 | this.Load | FPC0100_ExcelImportPopup.cs:171 |  | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2d4b6dd3 | this.Load | FPC0100_ExcelImportPopup.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa34e3f6 | this.Load | FPC0100_ExcelImportPopup.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-683102a0 | this.Load | FPC0100_ExcelImportPopup.cs:169 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |
| AC-e19b2720 | this.Load | FPC0100_ExcelImportPopup.cs:171 |  | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1b14e47 | this.Load | FPC0100_ExcelImportPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9436b600 | this.Load | FPC0100_ExcelImportPopup.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-8715a972 | this.Load | FPC0100_ExcelImportPopup.cs:188 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a462005b | this.Load | FPC0100_ExcelImportPopup.cs:189 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ffad327a | this.Load | FPC0100_ExcelImportPopup.cs:190 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1ba68c94 | this.Load | FPC0100_ExcelImportPopup.cs:179 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-52457dfd | this.Load | FPC0100_ExcelImportPopup.cs:182 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e7c0ee0 | this.Load | FPC0100_ExcelImportPopup.cs:188 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-58227400 | this.Load | FPC0100_ExcelImportPopup.cs:189 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-68881e96 | this.Load | FPC0100_ExcelImportPopup.cs:190 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FPC0100_ExcelImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee244d09 | this.Load | FPC0100_ExcelImportPopup.cs:220 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc554698 | this.Load | FPC0100_ExcelImportPopup.cs:221 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9870d2a3 | this.Load | FPC0100_ExcelImportPopup.cs:228 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-5609aab5 | this.Load | FPC0100_ExcelImportPopup.cs:220 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e434fd8 | this.Load | FPC0100_ExcelImportPopup.cs:221 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48f067a5 | this.Load | FPC0100_ExcelImportPopup.cs:228 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0100_ExcelImportPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd8d5ffb | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1135 | if (programID == "SELECT_IMPORT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-99bf64a8 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1140 | else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-06ac7bd1 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1149 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-843602d5 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1149 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1c507409 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1153 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ else of (spdComExcel.Ac… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6e0afa27 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1157 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a89e3850 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1163 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a7152c93 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1166 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e52363f2 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1188 | if (programID == "SELECT_IMPORT") | RETURN | return Find_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-235dce47 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1193 | else of (programID == "SELECT_IMPORT") ▸ if (programID == "SELECT_VALID") | RETURN | return Find_Data_Validation("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-7ed8033c | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1202 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | DATA_OP | spdComExcel.ActiveSheet.GetDataView(true).ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62095706 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1202 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ if (spdComExcel.ActiveS… | ENDPOINT | spdComExcel.ActiveSheet.GetDataView | (true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95883b52 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1206 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") ▸ else of (spdComExcel.Ac… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-83fb1f84 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1210 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER") | RETURN | return Save_Data_Buffer(dtExcel, "SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-2d3d71bf | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1216 | else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "… | RETURN | return Save_Data_Import("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-70957235 | popSql.OnSql | FPC0100_ExcelImportPopup.cs:1219 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8deace2b | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:530 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-938e28c2 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:532 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2093bd61 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:536 | if (bUpload == false) | MESSAGE | MessageBox.Show | ("After Excel Upload, Try Again!", "Upload Error", MessageBoxButtons.OK, MessageBoxIcon.Er… | 메시지 표시 |  |  |  |
| AC-f042ad96 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:537 | if (bUpload == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa90afaa | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:544 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d396486e | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:545 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a1b4ac2 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:549 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-190da913 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:564 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsv.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b73f5866 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:574 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ else of (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d21c41ef | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:578 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-373186d4 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:582 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-81be12cc | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:583 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f7f7cd14 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:587 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-244af0ac | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:588 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2b271674 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:530 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d42063f4 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:532 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-351624b2 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:536 | if (bUpload == false) | MESSAGE | MessageBox.Show | ("After Excel Upload, Try Again!", "Upload Error", MessageBoxButtons.OK, MessageBoxIcon.Er… | 메시지 표시 |  |  |  |
| AC-557556f9 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:537 | if (bUpload == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79a57dfb | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:544 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c412c4c | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:545 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30e7bb3d | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:549 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-673e853a | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:564 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsv.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1b824b1 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:574 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ else of (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-becd0d4f | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:578 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9bd35ad1 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:582 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bf7d65d0 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:583 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ec83b878 | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:587 | finally | FLAG | bUpload | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9d185aca | this.btnSave.Click 외 1 | FPC0100_ExcelImportPopup.cs:588 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_ExcelImportPopup.Save_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ if (programID == "INSERT_BUFFER")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae003bb | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:678 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-2778c249 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:691 | try ▸ for (i< sParm.Length) | DATA_OP | sParm[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b200c54 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:712 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-99274383 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:716 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-723a0252 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:718 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c9a2397c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:719 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-8448ca7b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:720 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-62bfd33f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:721 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eebe8d82 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:726 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k] | 행/컬럼 값 대입 |  |  |  |
| AC-08918955 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:728 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2ba0218 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:730 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-50a8aefc | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:736 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-efa82143 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:741 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-83bc6ab3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:705 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ff9895b0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:718 | try ▸ for (i< sParm.Length) | DATA_OP | sParm[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-612e1d53 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:739 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-1920fdee | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:743 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-214f73fa | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:745 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-b337e8e8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:746 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-2d4d7d79 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:747 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-a2a7397a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:748 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a80eff31 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:758 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) ▸ if (structParam._sDbParamsList[k].ToString() == "p_mes_line_id" \|\| structParam._sDbParamsL… | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k-1] | 행/컬럼 값 대입 |  |  |  |
| AC-39b96d62 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:762 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) ▸ else of (structParam._sDbParamsList[k].ToString() == "p_mes_line_id" \|\| structParam._sDbPa… | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParm[k] | 행/컬럼 값 대입 |  |  |  |
| AC-953fefd4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:765 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df4ee6bf | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:767 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c1e4085a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:773 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-08cbd13c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 1 | FPC0100_ExcelImportPopup.cs:778 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.Save_Data_Import

진입점: this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)] / popSql.OnSql [else of (programID == "SELECT_IMPORT") ▸ else of (programID == "SELECT_VALID") ▸ else of (programID == "INSERT_BUFFER") ▸ if (programID == "INSERT_EXCEL")] / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0f866ea | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:609 | try ▸ for (i < sParams.Length) | DATA_OP | sParams[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-771dc3a0 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:620 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { sMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdad0d82 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:621 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e879226e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:641 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-eec960ce | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:645 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-98791b2e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:647 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-60dd28bd | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:648 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f38c21f8 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:649 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-1d35cc9e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:650 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e46e6c7 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:654 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParams[k] | 행/컬럼 값 대입 |  |  |  |
| AC-69b6e7c1 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:657 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da1012d5 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:659 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-517ba4df | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:664 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-f94f41f3 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:669 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-be3927c6 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:611 | try ▸ for (i < sParams.Length) | DATA_OP | sParams[i] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a8e618ba | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:618 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) | DATA_OP | dsTmp.getColumn | (i, "MESSAGE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d9044c49 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:619 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) | DATA_OP | dsTmp.getColumn | (i, "VALID_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-62c76f87 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:624 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { sMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a42805fa | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:625 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValidYN.Equals("N")) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0646ec2e | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:635 | try ▸ for (i <= siComExcel.GetMaxRowIndex()) | DATA_OP | this.spdComExcel.ActiveSheet.ColumnHeader.Cells[0, 0].Text.ToUpper().Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-b71243f3 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:658 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-84064046 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:662 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-33d04af2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:664 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-f25bb9fc | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:665 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-78c366cb | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:666 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-f967a8d9 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:667 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f42f7b09 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:681 | try ▸ if (iCount > 0) ▸ for (k < iParmsCount) | DATA_OP | req.Parameters[structParam._sDbParamsList[k].ToString()] | sParams[k] | 행/컬럼 값 대입 |  |  |  |
| AC-b6045d55 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:684 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d88be2e7 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:686 | try ▸ if (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-d97cf0e2 | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:691 | try ▸ else of (iCount > 0) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-1105339f | this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdShe… 외 2 | FPC0100_ExcelImportPopup.cs:696 | catch () | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4845d1f1 | SaveButton | FPC0100_ExcelImportPopup.cs:300 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5ddb2a28 | SaveButton | FPC0100_ExcelImportPopup.cs:300 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.SetSheetHeadColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (dsv != null) ▸ if (dsv.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / this.Load [try ▸ if (ds != null) ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds != null) ▸ if (ds.Tables[0].Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cc647ad | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup.cs:1105 | try ▸ for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siComExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-718daa6e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup.cs:1112 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-f0be8c09 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup.cs:1157 | try ▸ for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (sHeadName.IndexOf("*") >= 0) | GRID_SET | siComExcel.ActiveSheet.ColumnHeader.Cells[0, idx].ForeColor | System.Drawing.Color.FromArgb(0, 113, 0) | 그리드 속성/값 설정 |  |  |  |
| AC-e3def68d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… 외 5 | FPC0100_ExcelImportPopup.cs:1165 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FPC0100_ExcelImportPopup.SetSheetHeaderWidth

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811194d2 | this.Load [try] | FPC0100_ExcelImportPopup.cs:1124 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45224fd7 | this.Load [try] | FPC0100_ExcelImportPopup.cs:1125 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |
| AC-29e2b47c | this.Load [try] | FPC0100_ExcelImportPopup.cs:1177 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7da1edbd | this.Load [try] | FPC0100_ExcelImportPopup.cs:1178 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FPC0100_ExcelImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78facb9d | this.Load [try] | FPC0100_ExcelImportPopup.cs:236 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80ccc376 | this.Load [try] | FPC0100_ExcelImportPopup.cs:237 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-be9d877b | this.Load [try] | FPC0100_ExcelImportPopup.cs:241 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-55e0d6ca | this.Load [try] | FPC0100_ExcelImportPopup.cs:249 | if (_arrHiddenColumns != null) ▸ if (_arrHiddenColumns.Length > 0) ▸ for (i < _arrHiddenColumns.Length) | GRID_SET | siComExcel.ActiveSheet.Columns[_arrHiddenColumns[i]].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-35c808c0 | this.Load [try] | FPC0100_ExcelImportPopup.cs:253 |  | GRID_INIT | siComExcel.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fc096975 | this.Load [try] | FPC0100_ExcelImportPopup.cs:236 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98f4f765 | this.Load [try] | FPC0100_ExcelImportPopup.cs:237 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-d8b233c7 | this.Load [try] | FPC0100_ExcelImportPopup.cs:241 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-56fb5deb | this.Load [try] | FPC0100_ExcelImportPopup.cs:249 | if (_arrHiddenColumns != null) ▸ if (_arrHiddenColumns.Length > 0) ▸ for (i < _arrHiddenColumns.Length) | GRID_SET | siComExcel.ActiveSheet.Columns[_arrHiddenColumns[i]].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6d7e7b10 | this.Load [try] | FPC0100_ExcelImportPopup.cs:253 |  | GRID_INIT | siComExcel.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0100_ExcelImportPopup.SetValidationResultSheetColor

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (bCheck) ▸ if (bFlag) ▸ if (dst != null) ▸ if (dst.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3692367c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1079 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N"… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-a12ea2d4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1086 | catch () | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-a9c0b5a9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1089 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-08a42264 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1128 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) | DATA_OP | dsTmp.getColumn | (i, "MESSAGE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0a6297f0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1129 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) | DATA_OP | dsTmp.getColumn | (i, "VALID_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1dad183c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1134 | try ▸ if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N"… | GRID_SET | siComExcel.ActiveSheet.Cells[i, 0, i, siComExcel.GetMaxColumnIndex()].BackColor | System.Drawing.Color.Pink | 그리드 속성/값 설정 |  |  |  |
| AC-9ff54892 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1139 | catch ((Exception ex)) | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |
| AC-dfd3c070 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FPC0100_ExcelImportPopup.cs:1141 |  | RETURN | return bCheck; |  | 처리 중단/반환 |  |  |  |

## FPC0100_ExcelImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c2f5325 | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:946 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d204914a | (진입점 미연결) | FPC0100_ExcelImportPopup.cs:998 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_QueryExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3935ac1 | .ctor | FPC0100_QueryExcelPopup.cs:124 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-7e31bf7a | .ctor | FPC0100_QueryExcelPopup.cs:125 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FPC0100_QueryExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-542afc70 | this.btnClose.Click | FPC0100_QueryExcelPopup.cs:814 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_QueryExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d337ffc | this.btnDownload.Click | FPC0100_QueryExcelPopup.cs:798 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-ba32da26 | this.btnDownload.Click | FPC0100_QueryExcelPopup.cs:799 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FPC0100_QueryExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c9defbc | this.btnFind.Click | FPC0100_QueryExcelPopup.cs:793 |  | ENDPOINT | FindData | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## FPC0100_QueryExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fafa0901 | this.Load | FPC0100_QueryExcelPopup.cs:168 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-79d52636 | this.Load | FPC0100_QueryExcelPopup.cs:169 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6e2a9c8 | this.Load | FPC0100_QueryExcelPopup.cs:170 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FPC0100_QueryExcelPopup.DefaultKeyRowDataCheck

진입점: this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (bUseKeyDataCheck)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6551837a | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FPC0100_QueryExcelPopup.cs:781 | if (!string.IsNullOrWhiteSpace(error_message)) | DATA_OP | row["MESSAGE"] | error_message | 행/컬럼 값 대입 |  |  |  |
| AC-63c3a0af | this.btnUpload.Click [if (string.IsNullOrWhiteSpace(FileName… | FPC0100_QueryExcelPopup.cs:782 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0100_QueryExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a367c65 | this.Load | FPC0100_QueryExcelPopup.cs:163 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0100_QueryExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d1878c8 | Dispose | FPC0100_QueryExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0100_QueryExcelPopup.Find_Data

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2262e76 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:235 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-974e058c | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:238 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c82639f3 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:241 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Import() ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fa7477f | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:248 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c43d8357 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:250 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7aa1f447 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:254 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fd9d7d84 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:255 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b4b2640f | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:260 | catch () | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6aa003f2 | this.Load 외 1 | FPC0100_QueryExcelPopup.cs:264 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0100_QueryExcelPopup.Find_Data_Import

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88d51a1a | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:273 | if (OnSearchData == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-98114daf | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:274 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-80cc57dc | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:274 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b292916 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:281 | try ▸ if (OnSearchData != null) | CALL_BASE | this.Invoke | (new Action(delegate () { this.hasError = false; this.IsExcelChanged = false; //this.Enabl… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5877b98c | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:283 | try ▸ if (OnSearchData != null) ▸ lambda | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1ddaa732 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:284 | try ▸ if (OnSearchData != null) ▸ lambda | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8a737495 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:286 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6107e5e6 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:287 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9b5880f6 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:288 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ff7ccff3 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:289 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9e37b3be | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:290 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bc76bc64 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:291 | try ▸ if (OnSearchData != null) ▸ lambda | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0bcc8fb2 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:295 | try ▸ if (OnSearchData != null) ▸ lambda ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-691c433b | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:298 | try ▸ if (OnSearchData != null) ▸ lambda | CALL_BASE | OnSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec9fdf7f | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:307 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, dsSet, ColumnWidth, ColumnTitle, KeyColumns, A… | 화면 필드/플래그 변경 |  |  |  |
| AC-4b81fd9f | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:307 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsSet, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK) | 그리드 재구성/초기화 |  |  |  |
| AC-4d4d8b2a | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:312 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-3f402e31 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:313 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-1fba64fa | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:314 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-d4bc585a | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:318 | try ▸ if (OnSearchData != null) ▸ lambda ▸ else of (dsSet == null) ▸ if (dsSet != null && dsSet.Tables != null && dsSet.Tables.Count > 0) | DATA_OP | dsSet.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad87b664 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:326 | try | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cadb4c5 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:329 | try ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-93afacc5 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:330 | try ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7b4cccb7 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:331 | try ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d743c6f7 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:332 | try ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-92a6fd1a | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:333 | try ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0e3b079e | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:334 | try ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-900a208a | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:337 | try | RETURN | return dsSet; |  | 처리 중단/반환 |  |  |  |
| AC-4c1c8585 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:342 | catch ((Exception e)) | MESSAGE | MessageBox.Show | ( e.Message) | 메시지 표시 |  |  |  |
| AC-e4e980b1 | this.Load [try ▸ lambda] 외 1 | FPC0100_QueryExcelPopup.cs:343 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FPC0100_QueryExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-890abdb3 | this.Load | FPC0100_QueryExcelPopup.cs:133 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b5cedf3 | this.Load | FPC0100_QueryExcelPopup.cs:135 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FPC0100_QueryExcelPopup.GetExcelFileName

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac41d106 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:541 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-cdf7dbf5 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:542 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-4710323e | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:543 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-1cad2420 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:544 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-ac8aca63 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:545 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-938f2b5d | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:546 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-c9cf5dcc | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:547 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-39b8fd47 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:549 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-2bf3a0f4 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:550 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-452ff1c3 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:554 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-dd090642 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:555 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FPC0100_QueryExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0ec1e47 | this.Load | FPC0100_QueryExcelPopup.cs:180 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33078b7d | this.Load | FPC0100_QueryExcelPopup.cs:181 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0100_QueryExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1f11814 | (진입점 미연결) | FPC0100_QueryExcelPopup.cs:201 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FPC0100_QueryExcelPopup.SaveByImportData

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21d46152 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:355 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-603dfeb4 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:356 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-760cc055 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:360 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-ad40cc80 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:361 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a7cbdc0 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:364 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-afa4d086 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:364 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-450d2c1a | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:373 | if (OnExcelSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-23cb10b9 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:374 | if (OnExcelSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dbb001c8 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:375 | if (OnExcelSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8bc5a3c7 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:376 | if (OnExcelSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3e0b9b03 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:377 | if (OnExcelSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e361cbe9 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:378 | if (OnExcelSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5cc7d6d6 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:386 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-be988ed4 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:387 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-95d011b0 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:388 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9686c5dd | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:389 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-46c72c98 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:390 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4bb36f0c | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:391 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1eddeae5 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:392 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2f38e7ca | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:393 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain.Tables.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c60ecbca | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:398 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e49652e | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:401 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-171c4ae5 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:403 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-aaeb14c9 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:406 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ if (!dsMain.Tables[0].Columns… | DATA_OP | dsMain.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-b09de24e | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:411 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-68537a88 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:412 | if (OnExcelSaveData != null) ▸ try ▸ if (dsMain != null && dsMain.Tables != null && dsMain.Tables.Count > 0) ▸ for (i < dsMain.Tables[0].Row… | GRID_SET | dsMain.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-0fc67feb | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:419 | if (OnExcelSaveData != null) ▸ try ▸ if (OnValidationSaveData != null) | CALL_BASE | OnValidationSaveData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe221725 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:446 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) | CALL_BASE | OnExcelSaveData | (dsMain, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3984690 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:457 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { dsMain.Tables[0].Rows.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee11aad2 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:459 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ if (result_string.Equals("SUCC… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-935b87b6 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:464 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | MESSAGE | MessageBox.Show | ("Save error :" + result_string) | 메시지 표시 |  |  |  |
| AC-4e3db864 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:465 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ try ▸ else of (result_string.Equals(… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bc8df7c8 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:471 | if (OnExcelSaveData != null) ▸ try ▸ if (bValid) ▸ if (dsResult != null && dsResult.Tables.Count > 0) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-d4022029 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:508 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7484b07 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:510 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0a26bb0 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:511 | if (OnExcelSaveData != null) ▸ try ▸ else of (bValid) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_VALID"] as string == "N") ▸ f… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ae0aff36 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:521 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d2a76bf1 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:522 | if (OnExcelSaveData != null) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-ffaa4986 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:526 | if (OnExcelSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7a8c258c | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:527 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-977f80a0 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:528 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0f694c5f | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:529 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-73676f63 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:530 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ad08cd38 | this.btnSave.Click | FPC0100_QueryExcelPopup.cs:531 | if (OnExcelSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FPC0100_QueryExcelPopup.SetSpreadByExcelUpLoad

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ca0415 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:563 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32c99f9c | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:565 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c63d2a57 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:566 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-00e03278 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:567 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | STATE_RESET | KeyColumnList.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-5edbe405 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:572 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (KeyColumns != null) ▸ foreach (string keycolumn i… | DATA_OP | KeyColumnList.Add | (keycolumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-15f981c7 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:577 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-7cc8b47f | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:578 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ if (DictColumn == null \|\| DictColumn.Count < 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-731f2ac6 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:589 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0f8ba8aa | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:593 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-05eebae0 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:596 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-74593e5c | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:597 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-a11c9d88 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:599 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlApp.Workbooks.Open | (FileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mis… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5211bdb1 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:618 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89a7a182 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:625 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | MESSAGE | MessageBox.Show | ("There's no data to display", "Excel Import", MessageBoxButtons.OK, MessageBoxIcon.Inform… | 메시지 표시 |  |  |  |
| AC-848e7844 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:626 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iRCnt < 2 \|\| iCCnt < DictColumn.Count) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5272514a | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:649 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | MESSAGE | MessageBox.Show | ("Please check your excel file where should use same column and order as orignal file", "E… | 메시지 표시 |  |  |  |
| AC-60d5e27b | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:650 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iFR == 0 \|\| iFC == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5ed1cc19 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:660 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (main != null) | DATA_OP | main.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a3e85cb | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:679 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec21e9f7 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:686 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ for (j < iFC + DictColumn… | DATA_OP | row[j - iFC] | each_cell_value | 행/컬럼 값 대입 |  |  |  |
| AC-40b7802d | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:695 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) ▸ if (this.DoKeyRowDataChec… | CALL_BASE | DoKeyRowDataCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9937b91 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:699 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ for (i < iRCnt + 1) | DATA_OP | excelData.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f7ab7ad | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:704 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | GRID_BIND | siMain.Query | (excelDataSet, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0ed4a4f5 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:718 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | CALL_EXT | siMain.SetRowColor | (k, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a83597a2 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:719 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (excelDataSet != null && excelDataSet.Tables… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4e1045c9 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:737 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (iSaveCnt == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8c5c5912 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:743 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b69fe1f6 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:747 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a19b73f5 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:752 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c968c109 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:753 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5e03ee43 | this.btnUpload.Click | FPC0100_QueryExcelPopup.cs:758 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FPC0100_QueryExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9fa2d3a | this.Load | FPC0100_QueryExcelPopup.cs:193 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf1cade2 | this.Load | FPC0100_QueryExcelPopup.cs:194 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

