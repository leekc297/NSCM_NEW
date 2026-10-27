# AS-IS 액션 대조표 — SCP0049

> 원천: `Doc/asisfacts/screens/SCP0049/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2067행 · 메서드 133 · 종류 DATA_OP 645 · FLAG 214 · UI_PROP 179 · GRID_SET 133 · GRID_INIT 108 · CALL_EXT 91 · RETURN 89 · GRID_LOCK 86 · MESSAGE 77 · UI_MISC 76 · ENDPOINT 68 · COMBO_DATA 62 · POPUP 57 · LIST_REBIND 56 · GRID_STYLE 41 · VALUE_SET 34 · VALUE_CLEAR 13 · VALIDATE 11 · GRID_BIND 9 · STATE 6 · GRID_CLEAR 4 · CALL_BASE 3 · STATE_RESET 2 · THROW 2 · GRID_COMBO 1 · ⚠ 의미 확인 필요 94


## CapaExcelUploadForm..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-546735bf | .ctor | CapaExcelUploadForm.cs:41 |  | FLAG | xlUpload | new ExcelUpload(sXlProgramId, sXlSheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-79e37e98 | .ctor | CapaExcelUploadForm.cs:47 |  | FLAG | xlUpload | new ExcelUpload(sXlProgramId, sXlSheetName, sAddParam) | 화면 필드/플래그 변경 |  |  |  |

## CapaExcelUploadForm.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f2c1273 | Dispose | CapaExcelUploadForm.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## CapaExcelUploadForm.ExcelUpload_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ac8b376 | this.Load | CapaExcelUploadForm.cs:88 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## CapaExcelUploadForm.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2856d2f6 | this.Load | CapaExcelUploadForm.cs:97 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8b2ef730 | this.Load | CapaExcelUploadForm.cs:98 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## CapaExcelUploadForm.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26ac36cd | this.Load | CapaExcelUploadForm.cs:102 |  | VALUE_SET | this.Text | xlUpload.SheetName | 컨트롤 값 설정 |  |  |  |
| AC-1999b72f | this.Load | CapaExcelUploadForm.cs:104 |  | UI_PROP | xlUpload.InitFormHeight | 350 | 속성 InitFormHeight 설정 |  |  |  |
| AC-ae0c2bb1 | this.Load | CapaExcelUploadForm.cs:105 |  | UI_PROP | xlUpload.ResultFormHeight | 450 | 속성 ResultFormHeight 설정 |  |  |  |

## CapaExcelUploadForm.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78539065 | this.Load | CapaExcelUploadForm.cs:114 |  | GRID_INIT | this.AddSheet | (sprdResult, "Upload Result", "Upload Result", 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-365549c9 | this.Load | CapaExcelUploadForm.cs:116 |  | GRID_INIT | si.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-900f9b7d | this.Load | CapaExcelUploadForm.cs:118 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-75efc129 | this.Load | CapaExcelUploadForm.cs:122 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Success", "success_title", FPMerge.None, 80, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e7ef904 | this.Load | CapaExcelUploadForm.cs:123 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Success Count", "success_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11456da4 | this.Load | CapaExcelUploadForm.cs:124 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Error", "error_title", FPMerge.None, 80, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d30dcc68 | this.Load | CapaExcelUploadForm.cs:125 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Error Count", "error_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5aefec38 | this.Load | CapaExcelUploadForm.cs:126 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Total", "total_title", FPMerge.None, 80, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89c9ce04 | this.Load | CapaExcelUploadForm.cs:127 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Total Count", "total_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e160df2 | this.Load | CapaExcelUploadForm.cs:128 |  | GRID_LOCK | si.LockColumn | (0, si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-75d496ad | this.Load | CapaExcelUploadForm.cs:130 |  | UI_PROP | sprdResult.HorizontalScrollBarPolicy | ScrollBarPolicy.Never | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-c50b73a6 | this.Load | CapaExcelUploadForm.cs:131 |  | UI_PROP | sprdResult.VerticalScrollBarPolicy | ScrollBarPolicy.Never | 속성 VerticalScrollBarPolicy 설정 |  |  |  |
| AC-8d35c5e3 | this.Load | CapaExcelUploadForm.cs:132 |  | UI_PROP | si.Sheet().RowHeaderVisible | false | 속성 RowHeaderVisible 설정 |  |  |  |
| AC-d5d6d6be | this.Load | CapaExcelUploadForm.cs:133 |  | UI_PROP | si.Sheet().ColumnHeaderVisible | false | 속성 ColumnHeaderVisible 설정 |  |  |  |
| AC-129e2eb2 | this.Load | CapaExcelUploadForm.cs:135 |  | UI_PROP | si.Sheet().RowCount | 1 | 속성 RowCount 설정 |  |  |  |
| AC-76473ed9 | this.Load | CapaExcelUploadForm.cs:136 |  | GRID_SET | si.Sheet().Columns[0].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-e3ffb394 | this.Load | CapaExcelUploadForm.cs:137 |  | GRID_SET | si.Sheet().Columns[2].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-88b858d8 | this.Load | CapaExcelUploadForm.cs:138 |  | GRID_SET | si.Sheet().Columns[4].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-fa8f181c | this.Load | CapaExcelUploadForm.cs:140 |  | GRID_SET | si.Sheet().Cells[0, 0].Text | "Success" | 그리드 속성/값 설정 |  |  |  |
| AC-062861cc | this.Load | CapaExcelUploadForm.cs:141 |  | GRID_SET | si.Sheet().Cells[0, 2].Text | "Error" | 그리드 속성/값 설정 |  |  |  |
| AC-c20b25e1 | this.Load | CapaExcelUploadForm.cs:142 |  | GRID_SET | si.Sheet().Cells[0, 4].Text | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-de204dcb | this.Load | CapaExcelUploadForm.cs:145 |  | GRID_INIT | this.AddSheet | (sprdDetail, "Error Detail", "Error Detail", 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f0fc1f1 | this.Load | CapaExcelUploadForm.cs:147 |  | GRID_INIT | si.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40cf48d7 | this.Load | CapaExcelUploadForm.cs:151 | for (i < sTitleSet.Length) | CALL_EXT | clsCtrl.AddTextColumnHash | (si, sTitleSet[i], "ATTRIBUTE" + (i + 1).ToString(), FPMerge.Restricted, sTitleSet[i].Leng… | ⚠ 의미 확인 필요 |  |  |  |
| AC-03095e56 | this.Load | CapaExcelUploadForm.cs:153 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Message", "message_text", FPMerge.None, 200, true, FPHAlign.Left) | ⚠ 의미 확인 필요 |  |  |  |

## CapaExcelUploadForm.OnClose_Click

진입점: this.btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f8ff7ad | this.btnCancel.Click | CapaExcelUploadForm.cs:242 | if (btnOK.Enabled && !xlUpload.UploadSaved) | MESSAGE | MessageBox.Show | ("CMsg.CommonMsg(CRM-00011)", this.Text, MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-cc696653 | this.btnCancel.Click | CapaExcelUploadForm.cs:243 | if (btnOK.Enabled && !xlUpload.UploadSaved) ▸ if (MessageBox.Show("CMsg.CommonMsg(CRM-00011)", this.Text, MessageBoxButtons.YesNo) == Dialog… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-56a46a0d | this.btnCancel.Click | CapaExcelUploadForm.cs:245 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## CapaExcelUploadForm.OnOpen_Click

진입점: this.btnOpen.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef3cfbe | this.btnOpen.Click | CapaExcelUploadForm.cs:180 |  | CALL_EXT | xlUpload.GetExcelFileName | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08ccd44e | this.btnOpen.Click | CapaExcelUploadForm.cs:180 | if (xlUpload.GetExcelFileName() == string.Empty) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0810f1a3 | this.btnOpen.Click | CapaExcelUploadForm.cs:181 |  | UI_PROP | xlUpload.Start | DateTime.Now | 속성 Start 설정 |  |  |  |
| AC-99036093 | this.btnOpen.Click | CapaExcelUploadForm.cs:182 |  | VALUE_SET | txtFileName.Text | xlUpload.FileName | 컨트롤 값 설정 |  |  |  |
| AC-df309eda | this.btnOpen.Click | CapaExcelUploadForm.cs:183 |  | UI_PROP | xlUpload.DoSaveUploadTable | SaveUploadExcel | 속성 DoSaveUploadTable 설정 |  |  |  |
| AC-db27bbf7 | this.btnOpen.Click | CapaExcelUploadForm.cs:185 |  | CALL_EXT | xlUpload.SaveUploadTableSet | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac8b35d2 | this.btnOpen.Click | CapaExcelUploadForm.cs:186 | if (!xlUpload.SaveUploadTableSet()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a26415f | this.btnOpen.Click | CapaExcelUploadForm.cs:189 |  | CALL_EXT | xlUpload.GetUploadResult | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cea4241 | this.btnOpen.Click | CapaExcelUploadForm.cs:192 |  | GRID_BIND | si.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-699a00ad | this.btnOpen.Click | CapaExcelUploadForm.cs:194 |  | CALL_EXT | si.SetEvenRowColor | (Color.LightGray) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34d30d49 | this.btnOpen.Click | CapaExcelUploadForm.cs:197 |  | GRID_BIND | si.Query | (ds.Tables[1]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-80864382 | this.btnOpen.Click | CapaExcelUploadForm.cs:199 |  | CALL_EXT | si.SetEvenRowColor | (Color.LightGray) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec787615 | this.btnOpen.Click | CapaExcelUploadForm.cs:205 | for (j < sprdDetail.Sheets[0].ColumnCount) | CALL_EXT | sprdDetail.Sheets[0].Columns[j].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3955199c | this.btnOpen.Click | CapaExcelUploadForm.cs:207 | for (j < sprdDetail.Sheets[0].ColumnCount) ▸ if (sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() > 10) | GRID_SET | sprdDetail.Sheets[0].Columns[j].Width | sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() + 10 | 그리드 속성/값 설정 |  |  |  |
| AC-16c6a9b3 | this.btnOpen.Click | CapaExcelUploadForm.cs:207 | for (j < sprdDetail.Sheets[0].ColumnCount) ▸ if (sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() > 10) | CALL_EXT | sprdDetail.Sheets[0].Columns[j].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2226abed | this.btnOpen.Click | CapaExcelUploadForm.cs:211 | for (j < sprdDetail.Sheets[0].ColumnCount) ▸ else of (sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() > 10) | GRID_SET | sprdDetail.Sheets[0].Columns[j].Width | sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() + 20 | 그리드 속성/값 설정 |  |  |  |
| AC-c2e5dc28 | this.btnOpen.Click | CapaExcelUploadForm.cs:211 | for (j < sprdDetail.Sheets[0].ColumnCount) ▸ else of (sprdDetail.Sheets[0].Columns[j].GetPreferredWidth() > 10) | CALL_EXT | sprdDetail.Sheets[0].Columns[j].GetPreferredWidth | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b3bf8f2 | this.btnOpen.Click | CapaExcelUploadForm.cs:227 | if (iSuccessCnt > 0 && (iErrorCnt == 0 \|\| isSaveExceptError)) | STATE | btnOK.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1d631d01 | this.btnOpen.Click | CapaExcelUploadForm.cs:231 | if (sprdDetail.Sheets[0].RowCount > 0) | UI_PROP | this.Height | xlUpload.ResultFormHeight | 속성 Height 설정 |  |  |  |

## CapaExcelUploadForm.OnSave_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8582cb20 | this.btnOK.Click | CapaExcelUploadForm.cs:235 |  | CALL_EXT | xlUpload.SaveUploadData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f61af33 | this.btnOK.Click | CapaExcelUploadForm.cs:235 | if (xlUpload.SaveUploadData()) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## CapaExcelUploadForm.ResetForm

진입점: this.btnOpen.Click / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62e9befa | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:159 |  | UI_PROP | xlUpload.UploadSaved | false | 속성 UploadSaved 설정 |  |  |  |
| AC-66e7c124 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:160 |  | STATE | btnOK.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bc7de73c | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:161 |  | UI_PROP | xlUpload.Start | DateTime.Now | 속성 Start 설정 |  |  |  |
| AC-f7346ec7 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:162 |  | CALL_EXT | xlUpload.Spans.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad3220b8 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:163 |  | VALUE_CLEAR | txtFileName.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-9f202084 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:166 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e69c8816 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:167 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 3].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-88903235 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:168 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 5].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-0d346357 | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:169 |  | GRID_SET | sprdDetail.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-8f08040c | this.btnOpen.Click 외 1 | CapaExcelUploadForm.cs:171 |  | UI_PROP | this.Height | xlUpload.InitFormHeight | 속성 Height 설정 |  |  |  |

## CapaExcelUploadForm.SaveUploadExcel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3926da54 | (진입점 미연결) | CapaExcelUploadForm.cs:56 | if (form == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e362306b | (진입점 미연결) | CapaExcelUploadForm.cs:60 | foreach (DataRow r in data.Tables[0].Rows) | DATA_OP | r["PROGRAM_ID"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-7d5636f7 | (진입점 미연결) | CapaExcelUploadForm.cs:61 | foreach (DataRow r in data.Tables[0].Rows) | DATA_OP | r["SHEET_NAME"] | form.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-6119147e | (진입점 미연결) | CapaExcelUploadForm.cs:62 | foreach (DataRow r in data.Tables[0].Rows) | DATA_OP | r["CREATION_DATE"] | now.ToString("yyyy-MM-dd HH:mm:ss") | 행/컬럼 값 대입 |  |  |  |
| AC-7b5ded62 | (진입점 미연결) | CapaExcelUploadForm.cs:64 |  | ENDPOINT | GSCM.FP.Common.UIL.Service.DataService.FP_UpdateBatch | ("CAPA", "save_excel_month", data, 0,"Capa") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_excel_month] \| FP\Capa\CAP… | 엔드포인트 호출 |  |  |  |
| AC-35722063 | (진입점 미연결) | CapaExcelUploadForm.cs:65 |  | CALL_EXT | GSCM.FP.Common.UIL.Service.DataService.ReadResult | (dtResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3aee82d9 | (진입점 미연결) | CapaExcelUploadForm.cs:67 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## CapaExcelUploadForm.ValidateUpload

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27784743 | (진입점 미연결) | CapaExcelUploadForm.cs:74 | if (form == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-20be0b3f | (진입점 미연결) | CapaExcelUploadForm.cs:76 | if (form == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-8d6056b5 | (진입점 미연결) | CapaExcelUploadForm.cs:78 |  | DATA_OP | paramDict["PROGRAM_ID"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-8b8f6b8f | (진입점 미연결) | CapaExcelUploadForm.cs:79 |  | DATA_OP | paramDict["SHEET_NAME"] | form.SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-dc9532c8 | (진입점 미연결) | CapaExcelUploadForm.cs:80 |  | DATA_OP | paramDict["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-72561c4b | (진입점 미연결) | CapaExcelUploadForm.cs:82 |  | ENDPOINT | GSCM.Windows.Forms.Service.DataService.FP_ExecuteNonQuery | ("CAPA", "validate_excel_upload", paramDict, "Capa") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=validate_excel_upload] \| FP… | 엔드포인트 호출 |  |  |  |
| AC-44f0f5d8 | (진입점 미연결) | CapaExcelUploadForm.cs:83 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.BtnColumn_Click

진입점: this.btnColumn.Click / this.btnColumn2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c959c5d | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:5067 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0049", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-960ccec3 | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:5068 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-36288ad5 | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:5069 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ae6f3f12 | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:2522 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0049", SpdSheet.shtMain, true) | 팝업/폼 생성 |  |  |  |
| AC-c1e32e36 | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:2523 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4d4c24dc | this.btnColumn.Click 외 1 | SCP0049_CAPA.cs:2524 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0049_CAPA.btnExcelFormDownload_Click

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7cd3e4c | this.formDown.Click | SCP0049_CAPA.cs:5257 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a1e2fa2d | this.formDown.Click | SCP0049_CAPA.cs:5258 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2723d56 | this.formDown.Click | SCP0049_CAPA.cs:2636 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-26db1782 | this.formDown.Click | SCP0049_CAPA.cs:2637 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b0f324a | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5156 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a13d87b | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5157 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba8b1c7f | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5161 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-846bf9e5 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5162 |  | CALL_EXT | select_popup.SetOption | (0, "Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-51630bc9 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5163 |  | CALL_EXT | select_popup.SetOption | (1, "Day") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bd5626a | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5164 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5730131e | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5172 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new GSCM.SCP.Master.UIL.CapaExcelUploadForm | ("SCP0049", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-f04c1632 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5173 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-5ed57c4c | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5174 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | frm.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-0b7288bb | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5175 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | frm.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-a3fa1d16 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5176 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f35b9ef7 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5177 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3ce7bbc9 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5183 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new GSCM.SCP.Master.UIL.CapaExcelUploadForm | ("SCP0049", "CAPA_DAY") | 팝업/폼 생성 |  |  |  |
| AC-9d6f75d2 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5184 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-97c91732 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5185 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | frm.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-b2d994c7 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5186 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | frm.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-127017e3 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5187 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e584be62 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5188 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-09ac1ac0 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:5194 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-220fde5c | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2611 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94682dbb | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2612 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b0e80c1 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2615 |  | POPUP | new ExcelUploadForm | ("SCP0049", this.spdMain.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-398c65fc | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2616 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-0b2fc52c | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2617 |  | UI_PROP | frm.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-9c3a4eed | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2618 |  | UI_PROP | frm.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-f3de3bff | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2619 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9595ebb2 | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2620 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9afb2d5b | this.btnExcelUpload.Click | SCP0049_CAPA.cs:2623 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0049_CAPA.BtnNewModel_Click

진입점: this.buttonNewModel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b16d7ac | this.buttonNewModel.Click | SCP0049_CAPA.cs:4995 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-084b4580 | this.buttonNewModel.Click | SCP0049_CAPA.cs:4996 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9a34695 | this.buttonNewModel.Click | SCP0049_CAPA.cs:5010 |  | POPUP | new SCP0049_CAPANewModelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a7d6f160 | this.buttonNewModel.Click | SCP0049_CAPA.cs:5012 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId, sDivisionId, sPlantId, sGroup, sFactoryId, sLineId, sOperationId, sModel… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3ec6049 | this.buttonNewModel.Click | SCP0049_CAPA.cs:5014 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68e141bc | this.buttonNewModel.Click | SCP0049_CAPA.cs:5015 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50861f7a | this.buttonNewModel.Click | SCP0049_CAPA.cs:5017 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00265") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-957c83a0 | this.buttonNewModel.Click | SCP0049_CAPA.cs:2457 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad64365b | this.buttonNewModel.Click | SCP0049_CAPA.cs:2458 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c0727174 | this.buttonNewModel.Click | SCP0049_CAPA.cs:2472 |  | POPUP | new SCP0049_CAPANewModelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-8bfd5331 | this.buttonNewModel.Click | SCP0049_CAPA.cs:2474 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId,division,sPlantId,sGroup,sFactoryId, sLineId, sOperationId,sModelId,sItem… | ⚠ 의미 확인 필요 |  |  |  |
| AC-242a1435 | this.buttonNewModel.Click | SCP0049_CAPA.cs:2476 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ce32bc77 | this.buttonNewModel.Click | SCP0049_CAPA.cs:2477 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0049_CAPA.BtnNewVersion_Click

진입점: this.buttonNewVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95541420 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5032 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-61542432 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5033 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9dc51e31 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5037 |  | POPUP | new SCP0049_CAPANewVersionConfirmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c71c914a | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5038 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId, sToday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab52f1fd | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5039 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9e09fe00 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:5040 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a4665bfe | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2487 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52af827b | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2488 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0def4185 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2492 |  | POPUP | new SCP0049_CAPANewVersionConfirmPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9fec0ad8 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2493 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId, sToday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2803c4e6 | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2494 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5537acdf | this.buttonNewVersion.Click | SCP0049_CAPA.cs:2495 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0049_CAPA.BtnVersionInfo_Click

진입점: this.buttonVersionInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8528f205 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5050 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7dd38df9 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5051 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a9c8756 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5055 |  | POPUP | new SCP0049_CAPANewVersionInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-29dcab87 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5056 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11d0ee15 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5057 |  | UI_PROP | popup.Width | 930 | 속성 Width 설정 |  |  |  |
| AC-c48657b1 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5058 |  | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-8c6a7057 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5059 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0adee9e6 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:5061 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-965ceebe | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2505 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-603eb143 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2506 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e730ed2 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2510 |  | POPUP | new SCP0049_CAPANewVersionInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bfb7ae90 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2511 |  | CALL_EXT | popup.LoadData | (UserInfo.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8d6f392 | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2512 |  | UI_PROP | popup.Width | 930 | 속성 Width 설정 |  |  |  |
| AC-8417495e | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2513 |  | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-ca8134df | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2514 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-25e6e58b | this.buttonVersionInfo.Click | SCP0049_CAPA.cs:2516 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0049_CAPA.CAPA_Export_Excel

진입점: this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8b1eefb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4522 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40d401a9 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4529 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-485e78c5 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4536 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-301a9cc7 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4543 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-18b7e339 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4545 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cc35188 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4548 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5834a50a | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4583 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5adc9744 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4588 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-6f92ce31 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4593 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdf577dc | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4595 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-51139194 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4604 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-44d596e5 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4616 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-d09cadc6 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4617 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-6fe362f3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4626 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-9008983d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4627 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-2b69b429 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4633 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-02cbcac1 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4647 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.ItemData | arrCode | 속성 ItemData 설정 |  |  |  |
| AC-d60c1f4f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4648 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.Items | arrCode | 속성 Items 설정 |  |  |  |
| AC-b84b6128 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4650 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-16aed7a3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4652 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-247e9924 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4653 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-bebb3dbe | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4654 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].Value | (sText == "True" ? "Y" : "N") | 그리드 속성/값 설정 |  |  |  |
| AC-dc11d548 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4674 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-a4677041 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4674 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1f1a16c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4676 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-90237783 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4691 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLanQty.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90112948 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4696 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-9881e5cc | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4697 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d40f42eb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4700 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-677b4d4c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4701 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-f751625e | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4703 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-b96bf2b4 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4705 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-b220ce56 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4706 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-66dacef4 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4707 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].Value | sText | 그리드 속성/값 설정 |  |  |  |
| AC-3a1b8771 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4721 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-6981b591 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4730 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-af7a5431 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4737 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c992d0 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4742 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-91b328cc | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4744 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-8c473b15 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4748 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-40ca4f75 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4750 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-31b449bb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4753 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-cde83faa | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4755 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-a4ee6e45 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4760 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-e9a96a7f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4771 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-58fa6754 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4773 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e44f26d3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4777 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-e48200a7 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4778 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-14b7b301 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4779 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-81aca9cd | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4780 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-6e454955 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4781 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9be0ca3e | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4788 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-143ed73a | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4789 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8b2cea7 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4791 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b59d3ca9 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4795 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14b80f41 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4801 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30cfa4bb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4805 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d8e5c0bc | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4808 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ee94859 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1997 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bc9b6247 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2004 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cfd4d071 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2011 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f60004be | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2018 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-499733ff | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2020 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e246f13a | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2023 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6baf17b2 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2058 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sv.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-93cad683 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2063 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-219c4e98 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2068 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca7b4861 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2070 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-45dcfdc2 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2079 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-addc201d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2091 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-d61b4553 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2092 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-77cdb2ef | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2101 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-c37ae8ac | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2102 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-d7ef8ec9 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2108 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-209eddb9 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2122 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.ItemData | arrCode | 속성 ItemData 설정 |  |  |  |
| AC-e1e4d7d3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2123 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.Items | arrCode | 속성 Items 설정 |  |  |  |
| AC-fa8c412d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2125 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-f271b814 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2127 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-45ab6f53 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2128 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-dda839b8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2129 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ta… | GRID_SET | newSheet.Cells[idx.Index, i].Value | (sText == "True" ? "Y" : "N") | 그리드 속성/값 설정 |  |  |  |
| AC-32e11ee2 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2149 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-1972866f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2149 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf35248f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2151 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + division + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = '" … | 데이터 객체 조작/조회 |  |  |  |
| AC-4807b350 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2166 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | dtLanQty.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c89acad8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2171 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrCode.Add | (dr["CODE"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-00c800f7 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2172 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | DATA_OP | arrName.Add | (dr["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-4822f01d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2175 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.ItemData | (String[])arrCode.ToArray(typeof(string)) | 속성 ItemData 설정 |  |  |  |
| AC-d66fa05b | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2176 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.Items | (String[])arrName.ToArray(typeof(string)) | 속성 Items 설정 |  |  |  |
| AC-90050981 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2178 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | UI_PROP | cb.EditorValue | FarPoint.Win.Spread.CellType.EditorValue.ItemData | 속성 EditorValue 설정 |  |  |  |
| AC-54f04d86 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2180 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | STATE | cb.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-48fc63b6 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2181 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | cb | 그리드 속성/값 설정 |  |  |  |
| AC-c5a633cb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2182 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (newSheet.Columns[… | GRID_SET | newSheet.Cells[idx.Index, i].Value | sText | 그리드 속성/값 설정 |  |  |  |
| AC-8cdfdb66 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2196 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-89a5a795 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2205 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-0294ee19 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2212 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d53bcae | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2217 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-07a28e3d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2219 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-699df24c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2223 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-3692df9f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2225 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-c5658c6b | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2228 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-8870d0fb | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2230 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-b63bc689 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2235 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-6a221b17 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2246 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9da008b0 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2248 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9e18966 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2252 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-91b2ce96 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2253 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-860fbc84 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2254 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-7a81b5f8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2255 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-20fc6286 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2256 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13169db0 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2263 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d8c3ad3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2264 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0cfa73d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2266 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, FarPoint.Excel.ExcelSaveFlags.NoFormulas \| FarPoint.Excel.ExcelSaveFlags.Save… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ae7d191 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2270 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5dc8029 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2276 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1377751d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2280 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a7dd2dff | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2283 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.cblPlant_changed

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99fe8f96 | this.Load 외 1 | SCP0049_CAPA.cs:4834 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d6da2dd1 | this.Load 외 1 | SCP0049_CAPA.cs:4836 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## SCP0049_CAPA.CboGroup_SelectedIndexChanged

진입점: this.Load / cboGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a83be86 | this.Load 외 1 | SCP0049_CAPA.cs:4827 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-80251955 | this.Load 외 1 | SCP0049_CAPA.cs:4829 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-775ace85 | this.Load 외 1 | SCP0049_CAPA.cs:2305 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-14fb7cae | this.Load 외 1 | SCP0049_CAPA.cs:2305 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c314ed90 | this.Load 외 1 | SCP0049_CAPA.cs:2306 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a5ae916f | this.Load 외 1 | SCP0049_CAPA.cs:2309 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-63e6a5fe | this.Load 외 1 | SCP0049_CAPA.cs:2309 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68f00920 | this.Load 외 1 | SCP0049_CAPA.cs:2310 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-85ea0402 | this.Load 외 1 | SCP0049_CAPA.cs:2313 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e097022 | this.Load 외 1 | SCP0049_CAPA.cs:2313 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID,pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0c4b6d07 | this.Load 외 1 | SCP0049_CAPA.cs:2314 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a786e9d | this.Load 외 1 | SCP0049_CAPA.cs:2317 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId,pGro… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-9b575019 | this.Load 외 1 | SCP0049_CAPA.cs:2317 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId,pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-717bb4b4 | this.Load 외 1 | SCP0049_CAPA.cs:2318 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.cboLine_changed

진입점: this.Load / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b1b8111 | this.Load 외 1 | SCP0049_CAPA.cs:4881 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5bb13e35 | this.Load 외 1 | SCP0049_CAPA.cs:4883 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## SCP0049_CAPA.CboVersionId_Click

진입점: cboVersionId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-075a8109 | cboVersionId.Click | SCP0049_CAPA.cs:4869 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7bab414 | cboVersionId.Click | SCP0049_CAPA.cs:4869 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, pDivisionId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-db42c6e3 | cboVersionId.Click | SCP0049_CAPA.cs:4871 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-705280b3 | cboVersionId.Click | SCP0049_CAPA.cs:4872 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-6cc2462a | cboVersionId.Click | SCP0049_CAPA.cs:4873 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-6447d7f3 | cboVersionId.Click | SCP0049_CAPA.cs:4874 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30b22b28 | cboVersionId.Click | SCP0049_CAPA.cs:4875 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7cb0f758 | cboVersionId.Click | SCP0049_CAPA.cs:4876 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-afc36773 | cboVersionId.Click | SCP0049_CAPA.cs:2379 |  | FLAG | dtVersionId | Data_SCP.Common(Data_SCP.Type.MDMVersionId, false, division, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f8af93 | cboVersionId.Click | SCP0049_CAPA.cs:2379 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.MDMVersionId, false, division, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0cd60372 | cboVersionId.Click | SCP0049_CAPA.cs:2381 |  | DATA_OP | dtVersionId.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3c0e75a3 | cboVersionId.Click | SCP0049_CAPA.cs:2382 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-3ed922ad | cboVersionId.Click | SCP0049_CAPA.cs:2383 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-2e6d6556 | cboVersionId.Click | SCP0049_CAPA.cs:2384 |  | CALL_EXT | dtVersionId.Rows.InsertAt | (drCurrentRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a18266e2 | cboVersionId.Click | SCP0049_CAPA.cs:2385 |  | DATA_OP | dtVersionId.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-21419219 | cboVersionId.Click | SCP0049_CAPA.cs:2386 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersionId, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.CboVersionId_SelectedIndexChanged

진입점: cboVersionId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9be8bc97 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4848 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-f34d34ea | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4849 |  | VALUE_CLEAR | this.txtTotal.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-87a0bccb | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4850 |  | VALUE_CLEAR | this.txtAuto.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-25e1942b | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4851 |  | VALUE_CLEAR | this.txtSmall.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-74bf5e31 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4852 |  | VALUE_CLEAR | this.txtElec.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1d0ac918 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4853 |  | VALUE_CLEAR | this.txtPIC.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-094d1fc5 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4856 | if (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4544d6b6 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:4860 | else of (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bf8ab7d3 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2358 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-3ca4133d | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2359 |  | VALUE_CLEAR | this.txtTotal.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-142a01bc | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2360 |  | VALUE_CLEAR | this.txtAuto.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ae06aac0 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2361 |  | VALUE_CLEAR | this.txtSmall.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-34e59f8e | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2362 |  | VALUE_CLEAR | this.txtElec.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e0ce5f07 | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2363 |  | VALUE_CLEAR | this.txtPIC.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-68b86f1e | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2366 | if (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c5ae2add | cboVersionId.SelectedIndexChanged | SCP0049_CAPA.cs:2370 | else of (cboVersionId.SelectedIndex == 0) | FLAG | bRealFlag | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPA.ClbBucket_SelectedIndexChanged

진입점: clbBucket.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fcbfd34 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4888 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-89d73320 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4890 |  | DATA_OP | clbBucket.CheckedItems.Contains | ("Day") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe2139ae | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4896 | if (clbBucket.CheckedItems.Contains("Day")) | UI_PROP | drpPeriodMonth.MonthText1 | currentMonth | 속성 MonthText1 설정 |  |  |  |
| AC-e54211f5 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4899 | if (clbBucket.CheckedItems.Contains("Day")) ▸ if (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | currentMonth | 속성 MonthText2 설정 |  |  |  |
| AC-a8b83056 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4903 | if (clbBucket.CheckedItems.Contains("Day")) ▸ else of (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | to_value.Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-40f2ecc6 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4907 | if (clbBucket.CheckedItems.Contains("Day")) ▸ if (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | currentMonth | 속성 MonthMin1 설정 |  |  |  |
| AC-012e88f1 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4911 | if (clbBucket.CheckedItems.Contains("Day")) ▸ else of (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | from_value.Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-4a731729 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4913 | if (clbBucket.CheckedItems.Contains("Day")) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-82360578 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4921 | else of (clbBucket.CheckedItems.Contains("Day")) | UI_PROP | drpPeriodMonth.MonthText1 | currentMonth | 속성 MonthText1 설정 |  |  |  |
| AC-92157348 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4924 | else of (clbBucket.CheckedItems.Contains("Day")) ▸ if (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | currentMonth | 속성 MonthText2 설정 |  |  |  |
| AC-3e67464f | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4928 | else of (clbBucket.CheckedItems.Contains("Day")) ▸ else of (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | to_value.Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-afcda1bc | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4932 | else of (clbBucket.CheckedItems.Contains("Day")) ▸ if (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | currentMonth | 속성 MonthMin1 설정 |  |  |  |
| AC-3837b5b4 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4936 | else of (clbBucket.CheckedItems.Contains("Day")) ▸ else of (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | from_value.Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-8a8f45ff | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:4938 | else of (clbBucket.CheckedItems.Contains("Day")) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-28a27de7 | clbBucket.SelectedIndexChanged | SCP0049_CAPA.cs:2403 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.clbBuilding_changed

진입점: this.Load / clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e63b8577 | this.Load 외 1 | SCP0049_CAPA.cs:4841 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-821878c1 | this.Load 외 1 | SCP0049_CAPA.cs:4843 |  | UI_PROP | clbLine.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## SCP0049_CAPA.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0468229d | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2347 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ca2b68e | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2347 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c7595b4f | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2348 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e37adcfc | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2352 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false,division,pPlantID,pFactoryID, pLineId, pGroup… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-6abf2fd5 | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2352 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false,division,pPlantID,pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-462f8ce2 | clbBuilding.SelectedIndexChanged | SCP0049_CAPA.cs:2353 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62f7e83e | clbLine.SelectedIndexChanged | SCP0049_CAPA.cs:2397 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-718815f0 | clbLine.SelectedIndexChanged | SCP0049_CAPA.cs:2397 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-75b11a4f | clbLine.SelectedIndexChanged | SCP0049_CAPA.cs:2398 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a873d59f | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2327 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-bcf1b88b | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2327 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c14eb51e | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2328 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c4eb1fe | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2331 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryI… | 화면 필드/플래그 변경 |  |  |  |
| AC-3eee43db | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2331 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-272f59b6 | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2332 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-34aa05d8 | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2336 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGr… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-0308110d | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2336 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23da9f68 | clbPlant.SelectedIndexChanged | SCP0049_CAPA.cs:2337 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80fb2334 | this.Load | SCP0049_CAPA.cs:697 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c9cfb28 | this.Load | SCP0049_CAPA.cs:698 |  | GRID_INIT | this.AddSheet | (spdExcel, SpdSheet.shtCAPAExcel, SpdSheet.shtCAPAExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fd4722f2 | this.Load | SCP0049_CAPA.cs:700 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-435c7fac | this.Load | SCP0049_CAPA.cs:701 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce8dd518 | this.Load | SCP0049_CAPA.cs:704 |  | FLAG | siExcelTemp | GetSheetInfo(spdExcel.Name, SpdSheet.shtCAPAExcel) | 화면 필드/플래그 변경 |  |  |  |
| AC-cf0c9c2e | this.Load | SCP0049_CAPA.cs:705 |  | GRID_INIT | siExcelTemp.ChangeSheet | (SpdSheet.shtCAPAExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc6dfc35 | this.Load | SCP0049_CAPA.cs:709 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f1994a1 | this.Load | SCP0049_CAPA.cs:396 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfa6ad08 | this.Load | SCP0049_CAPA.cs:397 |  | GRID_INIT | this.AddSheet | (spdExcel, SpdSheet.shtCAPAExcel, SpdSheet.shtCAPAExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4c9e59a7 | this.Load | SCP0049_CAPA.cs:399 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d9f2741 | this.Load | SCP0049_CAPA.cs:400 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbc524ec | this.Load | SCP0049_CAPA.cs:403 |  | FLAG | siExcelTemp | GetSheetInfo(spdExcel.Name, SpdSheet.shtCAPAExcel) | 화면 필드/플래그 변경 |  |  |  |
| AC-4bda527b | this.Load | SCP0049_CAPA.cs:404 |  | GRID_INIT | siExcelTemp.ChangeSheet | (SpdSheet.shtCAPAExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-34083fec | this.Load | SCP0049_CAPA.cs:408 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0049_CAPA.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-246db6da | this.Load | SCP0049_CAPA.cs:318 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0d58954 | this.Load | SCP0049_CAPA.cs:318 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb986352 | this.Load | SCP0049_CAPA.cs:264 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-29e9e4eb | this.Load | SCP0049_CAPA.cs:264 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0049_CAPA.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c7e7a03 | Dispose | SCP0049_CAPA.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-e71ed038 | Dispose | SCP0049_CAPA.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPA.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c45623a7 | EditButton | SCP0049_CAPA.cs:810 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Capa screen,You always in edit mode while you have prop… | 메시지 표시 |  |  |  |
| AC-d3ed25d4 | EditButton | SCP0049_CAPA.cs:813 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a35d5ac1 | EditButton | SCP0049_CAPA.cs:814 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-44a043e6 | EditButton | SCP0049_CAPA.cs:821 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | POPUP | pg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ca49bcd3 | EditButton | SCP0049_CAPA.cs:828 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6c9b45f | EditButton | SCP0049_CAPA.cs:829 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | UI_MISC | pg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a19d684c | EditButton | SCP0049_CAPA.cs:831 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55121f2e | EditButton | SCP0049_CAPA.cs:833 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb789899 | EditButton | SCP0049_CAPA.cs:834 | try ▸ if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-24fd503c | EditButton | SCP0049_CAPA.cs:846 | finally ▸ if (pg!=null) | UI_MISC | pg.Close | () | 창 닫기/해제 |  |  |  |
| AC-60bab519 | EditButton | SCP0049_CAPA.cs:508 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfd93f96 | EditButton | SCP0049_CAPA.cs:509 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3fc0c1f | EditButton | SCP0049_CAPA.cs:512 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d959231e | EditButton | SCP0049_CAPA.cs:513 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-73d010a7 | EditButton | SCP0049_CAPA.cs:524 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1b2d79c2 | EditButton | SCP0049_CAPA.cs:552 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.SITE_NAME), row, siMain.ActiveSheet.ColumnCount - 1… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc37920d | EditButton | SCP0049_CAPA.cs:560 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6400f093 | EditButton | SCP0049_CAPA.cs:566 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-775e94d6 | EditButton | SCP0049_CAPA.cs:576 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG), row, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65a95cfa | EditButton | SCP0049_CAPA.cs:584 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-58a653f3 | EditButton | SCP0049_CAPA.cs:584 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8255f01 | EditButton | SCP0049_CAPA.cs:586 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + division + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = '" … | 데이터 객체 조작/조회 |  |  |  |
| AC-1a786749 | EditButton | SCP0049_CAPA.cs:596 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | DATA_OP | dtLanQty.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-54754246 | EditButton | SCP0049_CAPA.cs:597 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_COMBO | siMain.SetCellTypeCombo | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), dtComboLaneQty) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-890d2a67 | EditButton | SCP0049_CAPA.cs:598 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-296ec5a8 | EditButton | SCP0049_CAPA.cs:602 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, 4, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0dfefc7 | EditButton | SCP0049_CAPA.cs:605 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6bbc99bc | EditButton | SCP0049_CAPA.cs:615 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1097a1e3 | EditButton | SCP0049_CAPA.cs:622 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3632b919 | EditButton | SCP0049_CAPA.cs:627 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, col, row, col, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9df7353 | EditButton | SCP0049_CAPA.cs:638 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a539fafc | EditButton | SCP0049_CAPA.cs:639 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.SITE_NAME), siMain.Sheet(0).Rows.Count-1, siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b42ce12 | EditButton | SCP0049_CAPA.cs:647 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.Sh… | CALL_EXT | siMain.SetDecimal | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2 , 2, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.EXECUTE_GENERATE

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4465b302 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5208 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION") ⇒ FP_Master.PR_UI_FP03033_MODEL_MEASURECONVERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-d876d975 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5209 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f132b0e8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5210 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-8174d2dd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5211 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXECUTE_ITEM_LINE_VERSION" | 행/컬럼 값 대입 |  |  |  |
| AC-c220f07e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5212 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e25f534e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5213 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5b4956e8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5215 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a5baf2d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5216 | try | DATA_OP | request.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e9f7f53c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5217 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bcb9ccf9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5218 | try | DATA_OP | request.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-287051f3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5219 | try | DATA_OP | request.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7af9b66c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5221 | try | DATA_OP | request.Parameters["p_model_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dba3d6ad | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5222 | try | DATA_OP | request.Parameters["p_pjt_code"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a65a34a5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5223 | try | DATA_OP | request.Parameters["p_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0f99ade4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5224 | try | DATA_OP | request.Parameters["p_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-abadea1f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5225 | try | DATA_OP | request.Parameters["p_prod_yn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a76ae2f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5227 | try | DATA_OP | request.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07fa2df8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5228 | try | DATA_OP | request.Parameters["p_item_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4f556474 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5229 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1789f7aa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5230 | try | DATA_OP | request.Parameters["p_category_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-896bd998 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5231 | try | DATA_OP | request.Parameters["p_value"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6ebe8640 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5233 | try | DATA_OP | request.Parameters["p_prod_ver_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-86a1bb4c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5234 | try | DATA_OP | request.Parameters["p_max_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5fe9b944 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5235 | try | DATA_OP | request.Parameters["p_mark"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3fc3c982 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5236 | try | DATA_OP | request.Parameters["p_org_version"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac4c8022 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5237 | try | DATA_OP | request.Parameters["p_job_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-26b43aa2 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5239 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0cf80813 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5241 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d0dff4b3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 1 | SCP0049_CAPA.cs:5246 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.FindData_Excel_DownLoad

진입점: this.formDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6e8a7e2 | this.formDown.Click | SCP0049_CAPA.cs:5267 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f2623cc1 | this.formDown.Click | SCP0049_CAPA.cs:5274 | try ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0c613ed | this.formDown.Click | SCP0049_CAPA.cs:5275 | try ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db72f4fa | this.formDown.Click | SCP0049_CAPA.cs:5278 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-1ac2fbc8 | this.formDown.Click | SCP0049_CAPA.cs:5278 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0182659b | this.formDown.Click | SCP0049_CAPA.cs:5291 | try ▸ if (dtCurrentFrom < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00331", new object[] { "3" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cd9ef82 | this.formDown.Click | SCP0049_CAPA.cs:5292 | try ▸ if (dtCurrentFrom < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtCurrentFrom.AddMonths(41).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-ff15bc47 | this.formDown.Click | SCP0049_CAPA.cs:5293 | try ▸ if (dtCurrentFrom < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2e83103 | this.formDown.Click | SCP0049_CAPA.cs:5298 | try | POPUP | new SCP0049_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e8331cd1 | this.formDown.Click | SCP0049_CAPA.cs:5299 | try | VALUE_SET | select_popup.Text | "Excel Down" | 컨트롤 값 설정 |  |  |  |
| AC-a04ebdcb | this.formDown.Click | SCP0049_CAPA.cs:5300 | try | CALL_EXT | select_popup.SetOption | (0, "Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-38538744 | this.formDown.Click | SCP0049_CAPA.cs:5301 | try | CALL_EXT | select_popup.SetOption | (1, "Day") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9725a60b | this.formDown.Click | SCP0049_CAPA.cs:5302 | try | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-31cce75b | this.formDown.Click | SCP0049_CAPA.cs:5310 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) ▸ if (pBucket.IndexOf("D") == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00329", new object[] { "Day" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-075d8ba3 | this.formDown.Click | SCP0049_CAPA.cs:5311 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) ▸ if (pBucket.IndexOf("D") == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8353f91e | this.formDown.Click | SCP0049_CAPA.cs:5316 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a0663dc | this.formDown.Click | SCP0049_CAPA.cs:5319 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a305243 | this.formDown.Click | SCP0049_CAPA.cs:5344 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4dd20961 | this.formDown.Click | SCP0049_CAPA.cs:5348 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-abbf9393 | this.formDown.Click | SCP0049_CAPA.cs:5349 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ca2aba0e | this.formDown.Click | SCP0049_CAPA.cs:5350 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-4ad93a76 | this.formDown.Click | SCP0049_CAPA.cs:5351 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-52963884 | this.formDown.Click | SCP0049_CAPA.cs:5352 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-8f378114 | this.formDown.Click | SCP0049_CAPA.cs:5353 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-e43c7907 | this.formDown.Click | SCP0049_CAPA.cs:5354 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-65d3a267 | this.formDown.Click | SCP0049_CAPA.cs:5355 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-a82f21ca | this.formDown.Click | SCP0049_CAPA.cs:5356 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-1862b903 | this.formDown.Click | SCP0049_CAPA.cs:5357 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-2ec769c1 | this.formDown.Click | SCP0049_CAPA.cs:5358 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-9dcf08b8 | this.formDown.Click | SCP0049_CAPA.cs:5359 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-8b5afae7 | this.formDown.Click | SCP0049_CAPA.cs:5360 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-b91fe37b | this.formDown.Click | SCP0049_CAPA.cs:5361 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-cc2d6fb4 | this.formDown.Click | SCP0049_CAPA.cs:5362 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-7788933c | this.formDown.Click | SCP0049_CAPA.cs:5363 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-0c15e0c4 | this.formDown.Click | SCP0049_CAPA.cs:5364 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-ff6f9842 | this.formDown.Click | SCP0049_CAPA.cs:5365 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-9713c603 | this.formDown.Click | SCP0049_CAPA.cs:5366 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-eec8ad61 | this.formDown.Click | SCP0049_CAPA.cs:5367 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-fb3161ec | this.formDown.Click | SCP0049_CAPA.cs:5368 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-0a763b2b | this.formDown.Click | SCP0049_CAPA.cs:5369 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1d3d3981 | this.formDown.Click | SCP0049_CAPA.cs:5370 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f272f506 | this.formDown.Click | SCP0049_CAPA.cs:5371 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["p_search_type"] | SearchType.EXCEL | 행/컬럼 값 대입 |  |  |  |
| AC-d5f553fd | this.formDown.Click | SCP0049_CAPA.cs:5372 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4772f542 | this.formDown.Click | SCP0049_CAPA.cs:5374 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ef8773ac | this.formDown.Click | SCP0049_CAPA.cs:5388 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-30caaaff | this.formDown.Click | SCP0049_CAPA.cs:5389 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb7ad0a | this.formDown.Click | SCP0049_CAPA.cs:5389 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d5cfaaf | this.formDown.Click | SCP0049_CAPA.cs:5391 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0) | GRID_BIND | siExcelTemp.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cc0105e0 | this.formDown.Click | SCP0049_CAPA.cs:5403 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ffd40c1b | this.formDown.Click | SCP0049_CAPA.cs:5406 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b222aa74 | this.formDown.Click | SCP0049_CAPA.cs:5431 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-47530357 | this.formDown.Click | SCP0049_CAPA.cs:5435 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-1f9a3b43 | this.formDown.Click | SCP0049_CAPA.cs:5436 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b6d7c1bb | this.formDown.Click | SCP0049_CAPA.cs:5437 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-90e3a26d | this.formDown.Click | SCP0049_CAPA.cs:5438 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-a791fd26 | this.formDown.Click | SCP0049_CAPA.cs:5439 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-d9a17ee2 | this.formDown.Click | SCP0049_CAPA.cs:5440 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-6b066eb9 | this.formDown.Click | SCP0049_CAPA.cs:5441 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-0284a45e | this.formDown.Click | SCP0049_CAPA.cs:5442 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-152b305f | this.formDown.Click | SCP0049_CAPA.cs:5443 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-dcfaa67a | this.formDown.Click | SCP0049_CAPA.cs:5444 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-15deabbe | this.formDown.Click | SCP0049_CAPA.cs:5445 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-065a3d1e | this.formDown.Click | SCP0049_CAPA.cs:5446 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-6ac4b23c | this.formDown.Click | SCP0049_CAPA.cs:5447 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-ce92c433 | this.formDown.Click | SCP0049_CAPA.cs:5448 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-c7bff431 | this.formDown.Click | SCP0049_CAPA.cs:5449 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-bb9237f0 | this.formDown.Click | SCP0049_CAPA.cs:5450 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-2fc2de69 | this.formDown.Click | SCP0049_CAPA.cs:5451 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-6e9eb948 | this.formDown.Click | SCP0049_CAPA.cs:5452 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-f78ea9c3 | this.formDown.Click | SCP0049_CAPA.cs:5453 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-ce09686b | this.formDown.Click | SCP0049_CAPA.cs:5454 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-20632b7b | this.formDown.Click | SCP0049_CAPA.cs:5455 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-2df06dec | this.formDown.Click | SCP0049_CAPA.cs:5456 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4294c6c3 | this.formDown.Click | SCP0049_CAPA.cs:5457 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3204d55f | this.formDown.Click | SCP0049_CAPA.cs:5458 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["p_search_type"] | "EXCEL_DAY" | 행/컬럼 값 대입 |  |  |  |
| AC-11d03c8b | this.formDown.Click | SCP0049_CAPA.cs:5459 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-4703d6b7 | this.formDown.Click | SCP0049_CAPA.cs:5461 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c57b7e4 | this.formDown.Click | SCP0049_CAPA.cs:5475 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-e386f042 | this.formDown.Click | SCP0049_CAPA.cs:5476 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-81cd9e35 | this.formDown.Click | SCP0049_CAPA.cs:5476 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55bee5a3 | this.formDown.Click | SCP0049_CAPA.cs:5478 | try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0) | GRID_BIND | siExcelTemp.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-953d85b3 | this.formDown.Click | SCP0049_CAPA.cs:5488 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d240a6b7 | this.formDown.Click | SCP0049_CAPA.cs:5489 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62ae4fc3 | this.formDown.Click | SCP0049_CAPA.cs:5493 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-05d21afb | this.formDown.Click | SCP0049_CAPA.cs:2646 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9008b64b | this.formDown.Click | SCP0049_CAPA.cs:2653 | try ▸ if (bRealFlag == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00312", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bcfc8664 | this.formDown.Click | SCP0049_CAPA.cs:2654 | try ▸ if (bRealFlag == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b833303 | this.formDown.Click | SCP0049_CAPA.cs:2657 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-47704453 | this.formDown.Click | SCP0049_CAPA.cs:2657 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6253394 | this.formDown.Click | SCP0049_CAPA.cs:2670 | try ▸ if (dtCurrentFrom < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00331", new object[] { "3" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3182561 | this.formDown.Click | SCP0049_CAPA.cs:2671 | try ▸ if (dtCurrentFrom < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtCurrentFrom.AddMonths(41).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-01244ecc | this.formDown.Click | SCP0049_CAPA.cs:2672 | try ▸ if (dtCurrentFrom < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-086a5d19 | this.formDown.Click | SCP0049_CAPA.cs:2679 | try ▸ if (pBucket.IndexOf("D") == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00329", new object[] { "Day" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c50f75a6 | this.formDown.Click | SCP0049_CAPA.cs:2680 | try ▸ if (pBucket.IndexOf("D") == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3d676a6 | this.formDown.Click | SCP0049_CAPA.cs:2685 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3bf637c0 | this.formDown.Click | SCP0049_CAPA.cs:2688 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3498d59e | this.formDown.Click | SCP0049_CAPA.cs:2713 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3b61a236 | this.formDown.Click | SCP0049_CAPA.cs:2717 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-29c492db | this.formDown.Click | SCP0049_CAPA.cs:2718 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4640074c | this.formDown.Click | SCP0049_CAPA.cs:2719 | try | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-1c9bc32b | this.formDown.Click | SCP0049_CAPA.cs:2720 | try | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-ec86e690 | this.formDown.Click | SCP0049_CAPA.cs:2721 | try | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-c73ab4cb | this.formDown.Click | SCP0049_CAPA.cs:2722 | try | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-53c7d979 | this.formDown.Click | SCP0049_CAPA.cs:2723 | try | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-533177da | this.formDown.Click | SCP0049_CAPA.cs:2724 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-ff5a5e1b | this.formDown.Click | SCP0049_CAPA.cs:2725 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-137082f6 | this.formDown.Click | SCP0049_CAPA.cs:2726 | try | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-508c27d4 | this.formDown.Click | SCP0049_CAPA.cs:2727 | try | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-1c0c81cb | this.formDown.Click | SCP0049_CAPA.cs:2728 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-e0d0fce9 | this.formDown.Click | SCP0049_CAPA.cs:2729 | try | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-4ac298a8 | this.formDown.Click | SCP0049_CAPA.cs:2730 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-07f1742f | this.formDown.Click | SCP0049_CAPA.cs:2731 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-10d3456c | this.formDown.Click | SCP0049_CAPA.cs:2732 | try | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-5f9b8f33 | this.formDown.Click | SCP0049_CAPA.cs:2733 | try | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-4fb70ecf | this.formDown.Click | SCP0049_CAPA.cs:2734 | try | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-e42cb055 | this.formDown.Click | SCP0049_CAPA.cs:2735 | try | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-1ccff53a | this.formDown.Click | SCP0049_CAPA.cs:2736 | try | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-c18fb70d | this.formDown.Click | SCP0049_CAPA.cs:2737 | try | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-788f015a | this.formDown.Click | SCP0049_CAPA.cs:2738 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3f4cb8c8 | this.formDown.Click | SCP0049_CAPA.cs:2739 | try | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-89ccc118 | this.formDown.Click | SCP0049_CAPA.cs:2740 | try | DATA_OP | request.Parameters["p_search_type"] | SearchType.EXCEL | 행/컬럼 값 대입 |  |  |  |
| AC-28c24f26 | this.formDown.Click | SCP0049_CAPA.cs:2741 | try | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-20f99f34 | this.formDown.Click | SCP0049_CAPA.cs:2743 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6ea797d | this.formDown.Click | SCP0049_CAPA.cs:2757 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-7103c100 | this.formDown.Click | SCP0049_CAPA.cs:2758 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c77f299c | this.formDown.Click | SCP0049_CAPA.cs:2758 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a1cc64ef | this.formDown.Click | SCP0049_CAPA.cs:2760 | try | GRID_BIND | siExcelTemp.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3efe0492 | this.formDown.Click | SCP0049_CAPA.cs:2768 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc00d6ad | this.formDown.Click | SCP0049_CAPA.cs:2769 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f87194b | this.formDown.Click | SCP0049_CAPA.cs:2773 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPA.FindData_Main

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70f9decd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1833 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-857957a8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1836 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d47ab36e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1836 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d80b9a5e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1859 | try ▸ if (nDate1 > nDate2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93bce10f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1860 | try ▸ if (nDate1 > nDate2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a8caf5d5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1865 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00354", new object[] { "Day", "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e66d5579 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1866 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-815990ab | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1871 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326", new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73d4f6ed | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1873 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-3b7edd6d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1874 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f0229b9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1879 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-88e4b821 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1882 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b095908 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1903 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e18cbfe8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1906 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b7d862ef | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1907 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8bdc6008 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1911 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-ce5e200e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1912 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-23888c45 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1913 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-c5a5b476 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1914 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-1bf363c7 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1915 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-21031767 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1916 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-ffe84df4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1917 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-62400ad9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1918 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-6483ecaa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1919 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-682557ee | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1920 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-c35e5fd4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1921 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-1c0935c8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1922 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-4fb2baa6 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1923 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-b26c1d14 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1924 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-62d9d830 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1925 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-e842bb76 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1926 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-aa5e45a8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1927 | try ▸ lambda | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-b3564c23 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1928 | try ▸ lambda | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-40669473 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1929 | try ▸ lambda | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-556592f0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1930 | try ▸ lambda | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-47aca861 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1931 | try ▸ lambda | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-bcac89b0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1932 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-98152927 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1933 | try ▸ lambda | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-66ba2128 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1934 | try ▸ lambda | DATA_OP | request.Parameters["p_search_type"] | SearchType.CAPA | 행/컬럼 값 대입 |  |  |  |
| AC-4ebb4e95 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1935 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-ba745f5b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1937 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f7e91f91 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1979 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-34662b25 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1986 | try | FLAG | dtTactTimeInfo | GetTactTime("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-7e3ccef0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1987 | try | FLAG | dtLossNoRun | GetLossNoRun("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-edfcfd62 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2002 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-91ffb086 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2004 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-83e2046f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2004 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4de515ce | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2010 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7d3d6991 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2012 | try | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5af05582 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2015 | try | VALUE_SET | txtTotal.Text | ds.Tables[1].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-765d3186 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2016 | try | VALUE_SET | txtAuto.Text | ds.Tables[1].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-c8194e21 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2017 | try | VALUE_SET | txtSmall.Text | ds.Tables[1].Rows[0][2].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7e5136dd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2018 | try | VALUE_SET | txtElec.Text | ds.Tables[1].Rows[0][3].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bca4fcca | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2019 | try | VALUE_SET | txtPIC.Text | ds.Tables[2].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-dbaf3c6d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2021 | try | UI_PROP | txtTotal.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-80e3a65f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2022 | try | UI_PROP | txtAuto.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-461846b1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2023 | try | UI_PROP | txtSmall.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-97c7ab55 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2024 | try | UI_PROP | txtElec.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-3aaeab70 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2025 | try | UI_PROP | txtPIC.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-17affe2d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2028 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-950f4129 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2036 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-437d6822 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2058 | try ▸ if (dtInstance_FP != null) | DATA_OP | dtInstance_FP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb69f53a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2060 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | bFP_Instance | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a1ecc906 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2061 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | dtInstance_FP_div | dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).CopyToDataTa… | 화면 필드/플래그 변경 |  |  |  |
| AC-6093b1f9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2061 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | DATA_OP | dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).CopyToDataTa… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f0df7d80 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2061 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | DATA_OP | dtInstance_FP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-57886b39 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2063 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | GRID_CLEAR | _List_FP_CategoryId.Clear | () | 그리드 행 비움 |  |  |  |
| AC-31930bc1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2070 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) ▸ for (i <… | DATA_OP | _List_FP_CategoryId.Contains | (getParam) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ca35e47 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2072 | try ▸ if (dtInstance_FP != null) ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) ▸ for (i <… | DATA_OP | _List_FP_CategoryId.Add | (getParam) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcf7eed8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2078 | try ▸ if (dtInstance_FP != null) ▸ else of (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | bFP_Instance | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3a5b6017 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2084 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89a68fcf | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2091 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5807522b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2096 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a2c25bc1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2097 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eece1838 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2101 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa9ee71 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2102 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ff2ea17a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2122 |  | FLAG | _index_Div | clbDivision.SelectedIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-99cc3bf4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:776 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-fea426d3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:779 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-14d044cb | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:779 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5319d63 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:794 | try ▸ if (nDate1 > nDate2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e83eed0f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:795 | try ▸ if (nDate1 > nDate2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2695aaab | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:800 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00354", new object[] { "Day" ,"1"}) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e66f86a5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:801 | try ▸ if (pBucket.IndexOf("D") == 0 && dtPeriodFrom.AddYears(1) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dca6cf3e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:806 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | MESSAGE | MessageHelper.GMessageBox | ("MSG00326" , new object[] { "6" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4558c7e8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:808 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | UI_PROP | drpPeriodMonth.MonthText2 | dtPeriodFrom.AddYears(6).ToString("yyyy-MM") | 속성 MonthText2 설정 |  |  |  |
| AC-2ea269fa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:809 | try ▸ if (dtPeriodFrom.AddYears(6) < dtPeriodTo) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4bbf788 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:814 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3527c235 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:817 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b40783c4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:839 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5aa21e18 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:840 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-27e58003 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:844 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_CAPA") ⇒ SCP.SCP0049_GET_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-5bc320b1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:845 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b2aa0fc5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:846 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-242ba167 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:847 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymm"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-20f1aa42 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:848 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-d5171656 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:849 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-661be013 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:850 | try ▸ lambda | DATA_OP | request.Parameters["p_group"] | pGroup | 행/컬럼 값 대입 |  |  |  |
| AC-02da73e0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:851 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId.Equals("ALL") ? DBNull.Value : pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-ddd412f3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:852 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-f394c8ad | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:853 | try ▸ lambda | DATA_OP | request.Parameters["p_version_id"] | pVersionId | 행/컬럼 값 대입 |  |  |  |
| AC-d319a886 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:854 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-c22900c1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:855 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-2f9c199f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:856 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-0f0da8aa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:857 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-5895471a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:858 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-61d8af2c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:859 | try ▸ lambda | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-8bf2f812 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:860 | try ▸ lambda | DATA_OP | request.Parameters["p_check_loss"] | pCheckLoss | 행/컬럼 값 대입 |  |  |  |
| AC-ebd2eb0f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:861 | try ▸ lambda | DATA_OP | request.Parameters["p_check_line"] | pCheckLine | 행/컬럼 값 대입 |  |  |  |
| AC-452e193c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:862 | try ▸ lambda | DATA_OP | request.Parameters["p_check_tact"] | pCheckTact | 행/컬럼 값 대입 |  |  |  |
| AC-c2edf0f7 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:863 | try ▸ lambda | DATA_OP | request.Parameters["p_check_yield"] | pCheckYield | 행/컬럼 값 대입 |  |  |  |
| AC-34a0facd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:864 | try ▸ lambda | DATA_OP | request.Parameters["p_check_empty"] | pCheckEmpty | 행/컬럼 값 대입 |  |  |  |
| AC-dc45a3c4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:865 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4038ab88 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:866 | try ▸ lambda | DATA_OP | request.Parameters["p_user_auth"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e916a057 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:867 | try ▸ lambda | DATA_OP | request.Parameters["p_search_type"] | SearchType.CAPA | 행/컬럼 값 대입 |  |  |  |
| AC-0f6abd9b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:868 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-758071fd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:870 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d6e78c2 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:872 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f900349c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:886 | try | UI_PROP | dv.Sort | sOrderBy | 속성 Sort 설정 |  |  |  |
| AC-5c22a71f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:888 | try | DATA_OP | dsSort.Tables.Add | (dv.ToTable()) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6fbfeb5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:888 | try | DATA_OP | dv.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-13a59da5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:891 | try | GRID_BIND | siMain.Query | (dsSort) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cf496cc6 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:893 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9c34e74 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:896 | try | VALUE_SET | txtTotal.Text | ds.Tables[1].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b631a293 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:897 | try | VALUE_SET | txtAuto.Text | ds.Tables[1].Rows[0][1].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a9026867 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:898 | try | VALUE_SET | txtSmall.Text | ds.Tables[1].Rows[0][2].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-409daca7 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:899 | try | VALUE_SET | txtElec.Text | ds.Tables[1].Rows[0][3].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a62874a9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:900 | try | VALUE_SET | txtPIC.Text | ds.Tables[2].Rows[0][0].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0d6815dd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:902 | try | UI_PROP | txtTotal.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-cd5a164f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:903 | try | UI_PROP | txtAuto.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-3d2c77e3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:904 | try | UI_PROP | txtSmall.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-a50b2b93 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:905 | try | UI_PROP | txtElec.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-d5eac700 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:906 | try | UI_PROP | txtPIC.TextAlign | HorizontalAlignment.Right | 속성 TextAlign 설정 |  |  |  |
| AC-e3fe39f5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:909 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-557d8a0f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:914 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ff11b08e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:934 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4336f29 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:935 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-611b2af1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:939 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2074d261 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:940 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPA.FindData_MyAddedAuthList

진입점: this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29ce908e | this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.C… 외 6 | SCP0049_CAPA.cs:1701 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthMyListAdded") ⇒ SystemManager.UP_FX_GetReqAuthMyListAdded | 엔드포인트 요청 생성 |  |  |  |
| AC-c370cbc2 | this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.C… 외 6 | SCP0049_CAPA.cs:1702 |  | DATA_OP | request.Parameters["p_UserID"] | Req_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0bed6732 | this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.C… 외 6 | SCP0049_CAPA.cs:1703 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3f006cfd | this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.C… 외 6 | SCP0049_CAPA.cs:1708 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4481caf7 | this.Load | SCP0049_CAPA.cs:305 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b3f796d8 | this.Load | SCP0049_CAPA.cs:251 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0049_CAPA.GetDayRange

진입점: this.Load / clbBucket.SelectedIndexChanged [else of (clbBucket.CheckedItems.Contains("Day"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7799b084 | this.Load 외 1 | SCP0049_CAPA.cs:2721 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_DAY_RANGE") ⇒ SCP.SCP0049_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-759ffe5b | this.Load 외 1 | SCP0049_CAPA.cs:2722 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-21f84109 | this.Load 외 1 | SCP0049_CAPA.cs:2724 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-1f4291e0 | this.Load 외 1 | SCP0049_CAPA.cs:2726 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d68058ee | this.Load 외 1 | SCP0049_CAPA.cs:2726 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-ce8657cd | this.Load 외 1 | SCP0049_CAPA.cs:1485 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_DAY_RANGE") ⇒ SCP.SCP0049_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-2372d358 | this.Load 외 1 | SCP0049_CAPA.cs:1486 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5fc979f4 | this.Load 외 1 | SCP0049_CAPA.cs:1487 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-7dd74995 | this.Load 외 1 | SCP0049_CAPA.cs:1489 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52caa3d1 | this.Load 외 1 | SCP0049_CAPA.cs:1489 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.GetDayRange_Day

진입점: clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.Contains("Day"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b98bdc4 | clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.C… | SCP0049_CAPA.cs:2734 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_DAY_RANGE") ⇒ SCP.SCP0049_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-e3a6bb0e | clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.C… | SCP0049_CAPA.cs:2735 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ae711118 | clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.C… | SCP0049_CAPA.cs:2736 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-b0cf3cbe | clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.C… | SCP0049_CAPA.cs:2738 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a9e8b26 | clbBucket.SelectedIndexChanged [if (clbBucket.CheckedItems.C… | SCP0049_CAPA.cs:2738 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4678199e | this.Load | SCP0049_CAPA.cs:465 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b93b82d0 | this.Load | SCP0049_CAPA.cs:466 |  | DATA_OP | Filter["NowGroupId"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-88975938 | this.Load | SCP0049_CAPA.cs:467 |  | FLAG | dtDivision | DataService.GetInnerTable("MY_DIVISION_ID", Filter) ⇒ biz:AppService.GeneralExecuteQuery [batchId=MyDivision] \| SCM\COMMON\BigFilter#… | 화면 필드/플래그 변경 |  |  |  |
| AC-18fd9299 | this.Load | SCP0049_CAPA.cs:467 |  | COMBO_DATA | DataService.GetInnerTable | ("MY_DIVISION_ID", Filter) ⇒ biz:AppService.GeneralExecuteQuery [batchId=MyDivision] \| SCM\COMMON\BigFilter#… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-63cf9ab5 | this.Load | SCP0049_CAPA.cs:470 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-68037009 | this.Load | SCP0049_CAPA.cs:473 |  | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6949bfd | this.Load | SCP0049_CAPA.cs:474 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e7f14bb | this.Load | SCP0049_CAPA.cs:475 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ded7ca1b | this.Load | SCP0049_CAPA.cs:479 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a8d0934 | this.Load | SCP0049_CAPA.cs:480 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1cdc00e | this.Load | SCP0049_CAPA.cs:481 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-4fdfe337 | this.Load | SCP0049_CAPA.cs:483 | foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | HardCodeService.MatchCodeFp("SCP0049_CAPA","DIVORDER1",dr["CODE"]) ? 1 : HardCodeService.M… | 행/컬럼 값 대입 |  |  |  |
| AC-e2227c19 | this.Load | SCP0049_CAPA.cs:483 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA","DIVORDER1",dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8afe03a | this.Load | SCP0049_CAPA.cs:483 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | HardCodeService.MatchCodeFp | ("SCP0049_CAPA", "DIVORDER2", dr["CODE"]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c28e62f | this.Load | SCP0049_CAPA.cs:485 | foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e056605 | this.Load | SCP0049_CAPA.cs:488 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-38ad1be4 | this.Load | SCP0049_CAPA.cs:489 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b24df024 | this.Load | SCP0049_CAPA.cs:491 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-179799c7 | this.Load | SCP0049_CAPA.cs:493 |  | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f69fe2e7 | this.Load | SCP0049_CAPA.cs:494 |  | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-acec6e9c | this.Load | SCP0049_CAPA.cs:494 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e7e7a3a | this.Load | SCP0049_CAPA.cs:496 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.GetExcelDown

진입점: this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bb51e46 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2882 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_SCP0049_FIND") ⇒ FP_Master.PR_UI_SCP0049_FIND | 엔드포인트 요청 생성 |  |  |  |
| AC-231f4731 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2883 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9336c737 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2884 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-926d685f | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2885 | try | DATA_OP | request.Parameters["p_sys_flag"] | "EXCEL_DOWN_DAY" | 행/컬럼 값 대입 |  |  |  |
| AC-f0fe0e44 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2886 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ad99ebc2 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2887 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a27ad5be | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2889 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b0bc6de0 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2890 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-0862774b | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2891 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5c10dad3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2892 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-edc0b7e9 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2893 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-d7e9d9c3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2894 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-d0e7b16c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2895 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-475d02ed | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2896 | try | DATA_OP | request.Parameters["p_line_id"] | pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-b349e871 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2897 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bb4dd028 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2898 | try | DATA_OP | request.Parameters["p_from_date"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-a0390fab | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2899 | try | DATA_OP | request.Parameters["p_to_date"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-df906be4 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2901 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d82a53b8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2903 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-451f243d | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:2908 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.GetLossNoRun

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9788418 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2825 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_SCP0049_FIND") ⇒ FP_Master.PR_UI_SCP0049_FIND | 엔드포인트 요청 생성 |  |  |  |
| AC-e314fc93 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2826 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f61165c1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2827 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-d6fe052b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2828 | try | DATA_OP | request.Parameters["p_sys_flag"] | "LOSS_NORUN_NOTPM" | 행/컬럼 값 대입 |  |  |  |
| AC-db9f1052 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2829 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1c45ed22 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2830 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-675c8979 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2832 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-853e5200 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2833 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-4bc47cdc | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2834 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-70f84c35 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2835 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-bafae230 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2836 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-e060276e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2837 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-d6d06443 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2838 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-5fe9fc02 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2839 | try | DATA_OP | request.Parameters["p_line_id"] | pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-2352a77e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2840 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a25c680c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2841 | try | DATA_OP | request.Parameters["p_from_date"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-b046b45a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2842 | try | DATA_OP | request.Parameters["p_to_date"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-90919714 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2847 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0aca4d8a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2849 | try | RETURN | return response.DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-343d1cdd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2854 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-816623c9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2623 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_CALENDAR") ⇒ SCP.SCP0049_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-f1c5ef82 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2629 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-43ca32f6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2630 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | currentMonth | 행/컬럼 값 대입 |  |  |  |
| AC-7c9f69f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2631 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-a75f3d13 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2632 |  | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-fd0d0223 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2634 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7fa142f8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2634 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e6690b96 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1388 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_CALENDAR") ⇒ SCP.SCP0049_GET_SHEET_CALENDAR | 엔드포인트 요청 생성 |  |  |  |
| AC-5e1b7f78 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1394 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-8796b58c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1395 |  | DATA_OP | request.Parameters["p_from_yyyymm"] | currentMonth | 행/컬럼 값 대입 |  |  |  |
| AC-062323f4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1396 |  | DATA_OP | request.Parameters["p_to_yyyymm"] | sPeriodMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-ac60769a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1397 |  | DATA_OP | request.Parameters["p_bucket"] | pBucket | 행/컬럼 값 대입 |  |  |  |
| AC-6417908a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1399 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-7a21c981 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1399 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0049_CAPA.GetTactTime

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e210aa7e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2768 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_SCP0049_FIND") ⇒ FP_Master.PR_UI_SCP0049_FIND | 엔드포인트 요청 생성 |  |  |  |
| AC-bb41a215 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2769 | try | UI_PROP | request.CommandTimeout | 5 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c59ffaa3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2770 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-90317b61 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2771 | try | DATA_OP | request.Parameters["p_sys_flag"] | "TACT_TIME" | 행/컬럼 값 대입 |  |  |  |
| AC-ebb64d58 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2772 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-58cd31d9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2773 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f54fdaf | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2775 | try | DATA_OP | request.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec0d8ae4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2776 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-a6348df5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2777 | try | DATA_OP | request.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d457899 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2778 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-ae2ec682 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2779 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-d70df28e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2780 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-4560fe41 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2781 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-5ff6e757 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2782 | try | DATA_OP | request.Parameters["p_line_id"] | pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-017282aa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2783 | try | DATA_OP | request.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-943343e1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2784 | try | DATA_OP | request.Parameters["p_from_date"] | sPeriodMonth1 | 행/컬럼 값 대입 |  |  |  |
| AC-c23709b3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2785 | try | DATA_OP | request.Parameters["p_to_date"] | sPeriodMonth2 | 행/컬럼 값 대입 |  |  |  |
| AC-307d7a2b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2789 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-715d2285 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2791 | try | RETURN | return response.DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |
| AC-e3a24d5a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2796 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.GetUserTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3966d58b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2642 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_USER_TITLE") ⇒ SCP.SCP0049_GET_SHEET_USER_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-58b6834e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2644 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-4f2ac3ad | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2645 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-a0601047 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2646 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-244e2785 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2648 |  | FLAG | dsUserTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4b65d054 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2648 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-96616409 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1407 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_USER_TITLE") ⇒ SCP.SCP0049_GET_SHEET_USER_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-d083da1b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1409 |  | DATA_OP | request.Parameters["p_program_id"] | "SCP0049" | 행/컬럼 값 대입 |  |  |  |
| AC-d604423a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1410 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-27f6cc90 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1411 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4af2f3d7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1413 |  | FLAG | dsUserTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-5b1782a5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1413 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0049_CAPA.GoEdit

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContex…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ccda11b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:854 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-61d24200 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:855 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed124939 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:864 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ce810796 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:867 | if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b89982ed | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:876 | if (bEdit_Mode == false) ▸ if (siMain.ActiveSheet.Rows.Count > 0 && siMain.ActiveSheet.ColumnCount > 0) | GRID_LOCK | siMain.LockRange2 | (0, G_DefColumns_SITE_NAME, siMain.ActiveSheet.Rows.Count - 1, siMain.ActiveSheet.ColumnCo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-c34a6ef9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:899 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ if (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f73c864c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:904 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ if ("… | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3068cb94 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:941 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_REQUEST_CHK, row, G_DefColumns_REQUEST_CHK, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-c47fb66a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:952 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-9c495399 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:959 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_LANE_QTY, row, G_DefColumns_LANE_QTY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5cbe49df | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:987 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 1, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4ef0b8fa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:997 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-8c9ccc00 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1004 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dd9cb307 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1009 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-980fbe93 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1034 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-fef4bd69 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1039 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_LANE_QTY, row, G_DefColumns_LANE_QTY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-60693240 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1062 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-6c7e44d1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1074 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-81530bd2 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1081 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5e3aba4e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1086 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-bf920a70 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1099 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | DATA_OP | _List_FP_CategoryId.Contains | (p_backValue__FP_Cate) | 데이터 객체 조작/조회 |  |  |  |
| AC-51740dfb | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1102 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | DATA_OP | _OperGroupList.Contains | (sOperationId) | 데이터 객체 조작/조회 |  |  |  |
| AC-effe1062 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1110 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-3ab030a3 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1136 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-83944657 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1148 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f50c52d8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1158 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-69c3f0e4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1164 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-b910e965 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1169 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4afc2c31 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1187 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-52c0c52c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1214 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-eed1a353 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1226 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f1ae4065 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1236 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e9eb895b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1242 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-c1a30624 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1247 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-bcbf6ece | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1274 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | DATA_OP | _OperGroupList.Contains | (sOperationId) | 데이터 객체 조작/조회 |  |  |  |
| AC-46a7f71c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1291 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-85583824 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1296 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_LANE_QTY, row, G_DefColumns_LANE_QTY, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f21cbc58 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1319 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4ca6222e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1329 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-95fa7bd2 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1336 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-cd5d95fe | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1341 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-4d396cbc | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1346 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-c1b47119 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1359 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | DATA_OP | _List_FP_CategoryId.Contains | (p_backValue__FP_Cate) | 데이터 객체 조작/조회 |  |  |  |
| AC-d82a0fd0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1367 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | DATA_OP | _OperGroupList.Contains | (sOperationId) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5933b78 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1375 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ed8c6616 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1400 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-f43f2398 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1412 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-a7fe55dc | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1419 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-ff91b9cb | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1424 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e85e128d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1429 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-d902d2cd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1440 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, G_DefColumns_CONFIRM_FLAG, row, G_DefColumns_CONFIRM_FLAG, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dc18ceb1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1468 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, startIdx, row, siMain.ActiveSheet.ColumnCount - 2, false) | 그리드 편집 잠금 전환 |  |  |  |
| AC-726a8f95 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1480 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-74adf526 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1487 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-7388093b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1492 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-dcab5339 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1497 | if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else … | GRID_LOCK | siMain.LockRange2 | (row, col, row, col, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-aab522f5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1523 | else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-18e78fee | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1528 | else of (bEdit_Mode == false) ▸ if (siMain.ActiveSheet.Rows.Count > 0 && siMain.ActiveSheet.ColumnCount > 0) | GRID_LOCK | siMain.LockRange2 | (0, G_DefColumns_SITE_NAME, siMain.ActiveSheet.Rows.Count - 1, siMain.ActiveSheet.ColumnCo… | 그리드 편집 잠금 전환 |  |  |  |
| AC-f4b8f001 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1542 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0049_CAPA.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeef5e07 | this.Load | SCP0049_CAPA.cs:325 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a378df4 | this.Load | SCP0049_CAPA.cs:327 |  | DATA_OP | Filter["SCREEN_EXCEPTION"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-be3974c7 | this.Load | SCP0049_CAPA.cs:328 |  | UI_PROP | typeNumber2.DecimalPlaces | -2 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-c3047d5c | this.Load | SCP0049_CAPA.cs:329 |  | UI_PROP | typeNumber2.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-01405f9f | this.Load | SCP0049_CAPA.cs:330 |  | UI_PROP | typeNumber2.NegativeRed | true | 속성 NegativeRed 설정 |  |  |  |
| AC-9a87662d | this.Load | SCP0049_CAPA.cs:331 |  | UI_PROP | typeNumber2.MaximumValue | 99999999999999 | 속성 MaximumValue 설정 |  |  |  |
| AC-50b02eb1 | this.Load | SCP0049_CAPA.cs:332 |  | UI_PROP | typeNumber2.MinimumValue | -99999999999999 | 속성 MinimumValue 설정 |  |  |  |
| AC-11312acd | this.Load | SCP0049_CAPA.cs:334 |  | UI_PROP | typeNumber4.DecimalPlaces | -4 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-0013984f | this.Load | SCP0049_CAPA.cs:335 |  | UI_PROP | typeNumber4.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-faeffb47 | this.Load | SCP0049_CAPA.cs:336 |  | UI_PROP | typeNumber4.NegativeRed | true | 속성 NegativeRed 설정 |  |  |  |
| AC-656f5716 | this.Load | SCP0049_CAPA.cs:337 |  | UI_PROP | typeNumber4.MaximumValue | 99999999999999 | 속성 MaximumValue 설정 |  |  |  |
| AC-818e7609 | this.Load | SCP0049_CAPA.cs:338 |  | UI_PROP | typeNumber4.MinimumValue | -99999999999999 | 속성 MinimumValue 설정 |  |  |  |
| AC-b29e2b82 | this.Load | SCP0049_CAPA.cs:349 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-61914b65 | this.Load | SCP0049_CAPA.cs:352 |  | VALUE_SET | checkLoss.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-3eab75c6 | this.Load | SCP0049_CAPA.cs:353 |  | VALUE_SET | checkLineAssign.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8b031fd1 | this.Load | SCP0049_CAPA.cs:354 |  | VALUE_SET | checkTactTime.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b790bdfd | this.Load | SCP0049_CAPA.cs:355 |  | VALUE_SET | checkYield.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-29486a54 | this.Load | SCP0049_CAPA.cs:356 |  | VALUE_SET | checkRESULT.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-65c47041 | this.Load | SCP0049_CAPA.cs:359 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("SCP0049_CAPA", "VERSION_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd5d3e96 | this.Load | SCP0049_CAPA.cs:368 |  | LIST_REBIND | clsCtrl.setListBox | (dtTemp, cboVersionId, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0e6fa3ec | this.Load | SCP0049_CAPA.cs:376 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | currentMonth | 속성 MonthText1 설정 |  |  |  |
| AC-7735aabe | this.Load | SCP0049_CAPA.cs:379 | if (dt != null && dt.Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | currentMonth | 속성 MonthText2 설정 |  |  |  |
| AC-b29efebd | this.Load | SCP0049_CAPA.cs:383 | if (dt != null && dt.Rows.Count > 0) ▸ else of (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthText2 | to_value.Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-b12ab4a3 | this.Load | SCP0049_CAPA.cs:387 | if (dt != null && dt.Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | currentMonth | 속성 MonthMin1 설정 |  |  |  |
| AC-e111365c | this.Load | SCP0049_CAPA.cs:391 | if (dt != null && dt.Rows.Count > 0) ▸ else of (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin1 | from_value.Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-fd1ef696 | this.Load | SCP0049_CAPA.cs:393 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-c2442ecc | this.Load | SCP0049_CAPA.cs:401 | if (dt != null && dt.Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin2 | currentMonth | 속성 MonthMin2 설정 |  |  |  |
| AC-ddb41086 | this.Load | SCP0049_CAPA.cs:405 | if (dt != null && dt.Rows.Count > 0) ▸ else of (string.IsNullOrWhiteSpace(from_value)) | UI_PROP | drpPeriodMonth.MonthMin2 | from_value.Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-d0ddbde6 | this.Load | SCP0049_CAPA.cs:409 | if (dt != null && dt.Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthMax2 | DateUtil.GetDateAdd(currentDay, 2, "Y") | 속성 MonthMax2 설정 |  |  |  |
| AC-d4bb090a | this.Load | SCP0049_CAPA.cs:413 | if (dt != null && dt.Rows.Count > 0) ▸ else of (string.IsNullOrWhiteSpace(to_value)) | UI_PROP | drpPeriodMonth.MonthMax2 | DateUtil.GetDateAdd(currentDay, 2, "Y") | 속성 MonthMax2 설정 |  |  |  |
| AC-c5f730fb | this.Load | SCP0049_CAPA.cs:418 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("SCP0049_CAPA", "BUCKET_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7f3c62a | this.Load | SCP0049_CAPA.cs:433 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketTemp, clbBucket, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-3b0b2ecf | this.Load | SCP0049_CAPA.cs:434 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e24f4fe1 | this.Load | SCP0049_CAPA.cs:439 | if (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-582a4256 | this.Load | SCP0049_CAPA.cs:443 | else of (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-c250e8fd | this.Load | SCP0049_CAPA.cs:269 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-421926d4 | this.Load | SCP0049_CAPA.cs:272 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-25d421b1 | this.Load | SCP0049_CAPA.cs:276 |  | DATA_OP | dtMyDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30d6930d | this.Load | SCP0049_CAPA.cs:277 |  | DATA_OP | tmpDivision.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1d3847a | this.Load | SCP0049_CAPA.cs:278 |  | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-19ecd84d | this.Load | SCP0049_CAPA.cs:282 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6515d3f | this.Load | SCP0049_CAPA.cs:283 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-33c3d611 | this.Load | SCP0049_CAPA.cs:284 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-2321a3a6 | this.Load | SCP0049_CAPA.cs:285 | foreach (DataRow dr in dtMyDivision.Rows) | DATA_OP | dataRow["SORT_ORDER"] | dr["CODE"].ToString() == "81" ? 1 : dr["CODE"].ToString() == "40" ? 2 : 3 | 행/컬럼 값 대입 |  |  |  |
| AC-4dc6f2cb | this.Load | SCP0049_CAPA.cs:287 | foreach (DataRow dr in dtMyDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5082bbd | this.Load | SCP0049_CAPA.cs:290 |  | UI_PROP | tmpDivision.DefaultView.Sort | "SORT_ORDER Asc" | 속성 Sort 설정 |  |  |  |
| AC-4da91375 | this.Load | SCP0049_CAPA.cs:291 |  | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50377f3d | this.Load | SCP0049_CAPA.cs:293 |  | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-772c31c5 | this.Load | SCP0049_CAPA.cs:295 |  | STATE_RESET | dtMyDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f3b7d4f4 | this.Load | SCP0049_CAPA.cs:296 |  | FLAG | dtMyDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1bfdd809 | this.Load | SCP0049_CAPA.cs:296 |  | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0890b6a2 | this.Load | SCP0049_CAPA.cs:298 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-843ed073 | this.Load | SCP0049_CAPA.cs:301 |  | VALUE_SET | checkLoss.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-8034fc6a | this.Load | SCP0049_CAPA.cs:302 |  | VALUE_SET | checkLineAssign.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-ee0033e8 | this.Load | SCP0049_CAPA.cs:303 |  | VALUE_SET | checkTactTime.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2dfa9fbe | this.Load | SCP0049_CAPA.cs:304 |  | VALUE_SET | checkYield.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f919831b | this.Load | SCP0049_CAPA.cs:305 |  | VALUE_SET | checkRESULT.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6cec1c57 | this.Load | SCP0049_CAPA.cs:309 |  | DATA_OP | dtTemp.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-efae4f1f | this.Load | SCP0049_CAPA.cs:310 |  | DATA_OP | dtTemp.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c842efb | this.Load | SCP0049_CAPA.cs:311 |  | DATA_OP | dtTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b7898d37 | this.Load | SCP0049_CAPA.cs:313 |  | DATA_OP | drCurrentRow["CODE"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-8bf7f974 | this.Load | SCP0049_CAPA.cs:314 |  | DATA_OP | drCurrentRow["NAME"] | "Current" | 행/컬럼 값 대입 |  |  |  |
| AC-bd907b29 | this.Load | SCP0049_CAPA.cs:315 |  | DATA_OP | dtTemp.Rows.Add | (drCurrentRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ee7c3d4 | this.Load | SCP0049_CAPA.cs:316 |  | LIST_REBIND | clsCtrl.setListBox | (dtTemp, cboVersionId, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2bee3a8e | this.Load | SCP0049_CAPA.cs:322 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText1 | currentMonth | 속성 MonthText1 설정 |  |  |  |
| AC-0043b410 | this.Load | SCP0049_CAPA.cs:323 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthText2 | dt.Rows[0]["TO_VALUE"].ToString().Substring(0, 6) | 속성 MonthText2 설정 |  |  |  |
| AC-91ca82d4 | this.Load | SCP0049_CAPA.cs:325 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin1 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin1 설정 |  |  |  |
| AC-cbdb1c54 | this.Load | SCP0049_CAPA.cs:326 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax1 | currentMonth | 속성 MonthMax1 설정 |  |  |  |
| AC-562c3fb8 | this.Load | SCP0049_CAPA.cs:332 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMin2 | dt.Rows[0]["FROM_VALUE"].ToString().Substring(0, 6) | 속성 MonthMin2 설정 |  |  |  |
| AC-e0b2bc44 | this.Load | SCP0049_CAPA.cs:334 | if (dt != null && dt.Rows.Count > 0) | UI_PROP | drpPeriodMonth.MonthMax2 | dateMaxMonth.Substring(0, 6) | 속성 MonthMax2 설정 |  |  |  |
| AC-eac804ae | this.Load | SCP0049_CAPA.cs:339 |  | DATA_OP | dtBucketTemp.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-af8903c8 | this.Load | SCP0049_CAPA.cs:340 |  | DATA_OP | dtBucketTemp.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-51509893 | this.Load | SCP0049_CAPA.cs:342 |  | DATA_OP | dtBucketTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-92ea4b5d | this.Load | SCP0049_CAPA.cs:343 |  | DATA_OP | drBucketMonthRow["CODE"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-bfdb3bcb | this.Load | SCP0049_CAPA.cs:344 |  | DATA_OP | drBucketMonthRow["NAME"] | "Month" | 행/컬럼 값 대입 |  |  |  |
| AC-249d010c | this.Load | SCP0049_CAPA.cs:345 |  | DATA_OP | dtBucketTemp.Rows.Add | (drBucketMonthRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c7960cb | this.Load | SCP0049_CAPA.cs:347 |  | DATA_OP | dtBucketTemp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d9965edc | this.Load | SCP0049_CAPA.cs:348 |  | DATA_OP | drBucketDayRow["CODE"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-56227a0f | this.Load | SCP0049_CAPA.cs:349 |  | DATA_OP | drBucketDayRow["NAME"] | "Day" | 행/컬럼 값 대입 |  |  |  |
| AC-32e2cb74 | this.Load | SCP0049_CAPA.cs:350 |  | DATA_OP | dtBucketTemp.Rows.Add | (drBucketDayRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-6882841d | this.Load | SCP0049_CAPA.cs:352 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketTemp, clbBucket, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-1328c1a5 | this.Load | SCP0049_CAPA.cs:353 |  | CALL_EXT | clbBucket.SetValues | ("Month") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b31131be | this.Load | SCP0049_CAPA.cs:358 | if (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-02171e51 | this.Load | SCP0049_CAPA.cs:362 | else of (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin") | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0049_CAPA.InitSpread

진입점: this.Load / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0)] / this.btnExcelU…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c814ee99 | this.Load 외 9 | SCP0049_CAPA.cs:720 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6801535e | this.Load 외 9 | SCP0049_CAPA.cs:721 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dfb07cda | this.Load 외 9 | SCP0049_CAPA.cs:732 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-95dc1fbb | this.Load 외 9 | SCP0049_CAPA.cs:736 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-760299bc | this.Load 외 9 | SCP0049_CAPA.cs:419 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f176c91 | this.Load 외 9 | SCP0049_CAPA.cs:420 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fc1fdced | this.Load 외 9 | SCP0049_CAPA.cs:429 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ae6a19dc | this.Load 외 9 | SCP0049_CAPA.cs:433 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0049_CAPA.InitSpread_day

진입점: this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b780e2b | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:5500 |  | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-7a2836b8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:5504 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0049_CAPA.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64968302 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2665 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc58d5a9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2671 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (dr[DefColumns.DayCode].ToString() == De… | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-847502c2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2677 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | CALL_EXT | spdInfo.AddNumColumnEx | (columnText, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0f902cc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2683 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-70d44469 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2687 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-f5f43ba2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2694 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (G_DefColumns_CONFIRM_FLAG + 1, siMain.ActiveSheet.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a9c1ef3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1430 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | spdInfo.AddNumColumnEx | (sColumnLabelname, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2485c233 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1436 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (dr[DefColumns.DayCode].ToString() == De… | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-69ed4a03 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1442 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | CALL_EXT | spdInfo.AddNumColumnEx | (columnText, sColumnName, FPMerge.None, 70, true, true, 2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-de5486c3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1448 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-6b883669 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1452 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtC… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, startIdx + iCellCnt].BackColor | Color.LightGreen | 그리드 속성/값 설정 |  |  |  |
| AC-f954d093 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1459 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG) + 1, siMain.ActiveSheet.ColumnCount - 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.InitSpreadRequestColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a0574cd | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2707 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddCheckColumn | ("Mail REQ", DefColumns.REQUEST_CHK, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b1023fef | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2709 | if (spdInfo.SheetName == SpdSheet.shtMain) | FLAG | G_DefColumns_REQUEST_CHK | siMain.GetColumnIndex(DefColumns.REQUEST_CHK) | 화면 필드/플래그 변경 |  |  |  |
| AC-6491df80 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2710 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, G_DefColumns_REQUEST_CHK].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-d03764c4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2711 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, G_DefColumns_REQUEST_CHK].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-453bc43f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2712 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, G_DefColumns_REQUEST_CHK].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-cbe8d02c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:2713 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, G_DefColumns_REQUEST_CHK].Text | "Mail REQ" | 그리드 속성/값 설정 |  |  |  |
| AC-7352d686 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1472 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddCheckColumn | ("Mail REQ", DefColumns.REQUEST_CHK, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85c3b30b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1474 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-4b871c26 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1475 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-d2156291 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1476 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-358658a6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1477 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Te… | "Mail REQ" | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPA.LoadAuthority

진입점: this.Load [if (UserInfoContext.Current["NowGroupID"] != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05ab466b | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:569 | if (param_GroupID == "") | FLAG | bPartAuthority | false | 화면 필드/플래그 변경 |  |  |  |
| AC-df1dfcc1 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:577 | else of (param_GroupID == "") ▸ if (_PlannerType != PlannerType.None) | FLAG | bPartAuthority | true | 화면 필드/플래그 변경 |  |  |  |
| AC-62ae2967 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:578 | else of (param_GroupID == "") ▸ if (_PlannerType != PlannerType.None) | FLAG | _CurrentGroupID | param_GroupID | 화면 필드/플래그 변경 |  |  |  |
| AC-cdc56602 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:582 | else of (param_GroupID == "") ▸ else of (_PlannerType != PlannerType.None) | FLAG | bPartAuthority | false | 화면 필드/플래그 변경 |  |  |  |
| AC-34d384ab | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:589 | if (bPartAuthority) | FLAG | bLineAssign_Auth | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5d94a073 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:590 | if (bPartAuthority) | FLAG | dtOperGroup_SCP | Data.Common(Data.Type.LocationGroupByCapa, false, "") ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-5cc4d0b8 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:590 | if (bPartAuthority) | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false, "") ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b23173fa | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:594 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | FLAG | _OperGroupList | dtOperGroup_SCP.Rows.OfType<DataRow>().Select(k => k["code"].ToString()).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-5c617e5d | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:594 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | DATA_OP | dtOperGroup_SCP.Rows.OfType<DataRow>().Select | (k => k["code"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-de77127c | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:594 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | CALL_EXT | dtOperGroup_SCP.Rows.OfType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-715dbc7a | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:599 | if (bPartAuthority) | FLAG | dtMyAuthList | FindData_MyAddedAuthList(p_userInfo) | 화면 필드/플래그 변경 |  |  |  |
| AC-f39385c5 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:609 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = UserInfoContext.Current.UserId; /… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c024178 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:621 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST") ⇒ FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-aee7c432 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:622 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-ebf3422a | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:623 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-79539837 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:624 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c55a9e26 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:625 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-190031c6 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:626 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-c73c8558 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:627 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-1d908005 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:628 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c2efd27a | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:629 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4ab3e7de | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:630 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b0944656 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:631 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8f09713e | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:632 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-58b53b31 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:633 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-95ce976b | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:634 | try | DATA_OP | request.Parameters["p_shop_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-80873cbd | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:635 | try | DATA_OP | request.Parameters["p_plan_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b2a67fe | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:636 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9f68a6a9 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:637 | try | DATA_OP | request.Parameters["p_request_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ffef9a8 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:638 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-320ea89c | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:639 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c09f3244 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:641 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-597a9c0b | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:647 | try ▸ if (saveData != null) | DATA_OP | saveData.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dcfe115b | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:651 | try ▸ if (saveData != null) ▸ if (saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL_FLAG"].ToString… | FLAG | dtInstance_FP | saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL… | 화면 필드/플래그 변경 |  |  |  |
| AC-ad211a2c | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:651 | try ▸ if (saveData != null) ▸ if (saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL_FLAG"].ToString… | DATA_OP | saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e1e02ffd | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPA.cs:651 | try ▸ if (saveData != null) ▸ if (saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL_FLAG"].ToString… | DATA_OP | saveData.Select | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0049_CAPA.PlannerTypeLogic

진입점: this.Load / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ed2e5d0 | this.Load 외 6 | SCP0049_CAPA.cs:508 | if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0) | FLAG | dtMyAuthList | FindData_MyAddedAuthList(p_userInfo) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6900d20 | this.Load 외 6 | SCP0049_CAPA.cs:523 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d66c510b | this.Load 외 6 | SCP0049_CAPA.cs:531 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7b9c800 | this.Load 외 6 | SCP0049_CAPA.cs:539 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c0a1b29c | this.Load 외 6 | SCP0049_CAPA.cs:553 | if (SCP_CAPA_bool && FP_bool) | FLAG | _PlannerType | PlannerType.SuperPlanner | 화면 필드/플래그 변경 |  |  |  |
| AC-4c744aaf | this.Load 외 6 | SCP0049_CAPA.cs:557 | else of (SCP_CAPA_bool && FP_bool) ▸ if (SCP_CAPA_bool \|\| FP_bool) | FLAG | _PlannerType | PlannerType.SidePlanner | 화면 필드/플래그 변경 |  |  |  |
| AC-1110957f | this.Load 외 6 | SCP0049_CAPA.cs:561 | else of (SCP_CAPA_bool && FP_bool) ▸ else of (SCP_CAPA_bool \|\| FP_bool) | FLAG | _PlannerType | PlannerType.None | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPA.pSetDecimal2

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate) ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate) ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityCon…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b604e34f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1552 |  | UI_PROP | range1.CellType | typeNumber2 | 속성 CellType 설정 |  |  |  |

## SCP0049_CAPA.pSetDecimal4

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (this.ViewModel != null && ViewModel.SecurityContext.CanUpdate) ▸ if (bEdit_Mode == false) ▸ for (row < siMain.ActiveSheet.Rows.Count) ▸ else of (!"Y".Equals(sEditorbleYN) \|\| "LA999" == sLossCode) ▸ else of ("VIRTUAL" == sPlantType) ▸ if (UserInfoContext.Current["NowGroupID"] == "SCM PI Admin" //\|\| UserInfoContext.Current["NowGroupID"] == "ADMIN" \|\| UserInf…) ▸ else of ("LINE ASSIGN" == sCategoryId) ▸ if ("TACT TIME" == sCategoryId)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.F…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d022846 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1564 |  | UI_PROP | range1.CellType | typeNumber4 | 속성 CellType 설정 |  |  |  |

## SCP0049_CAPA.Re_Design

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea9349da | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2921 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-070aeba0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:2942 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1063cf35 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1502 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-60b627eb | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1522 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0049_CAPA.Re_Design_Excel

진입점: this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ if (selected == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b07cb9a3 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4479 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor2 | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-fe957105 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4486 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor2 | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-3061e342 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4493 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor2 | (row, startColIdx, row, lastRowIdx, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-68b54e13 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4497 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4f3c470 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4497 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22c04b73 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4499 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-53bf5fc4 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4509 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor2 | (row, siExcelTemp.GetColumnIndex(DefColumns.LANE_QTY), row, siExcelTemp.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |
| AC-db4cff46 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:4514 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor2 | (row, startColIdx, row, siExcelTemp.ActiveSheet.ColumnCount - 1, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-f571b78c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1954 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-1d2603d8 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1961 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ if (sCategoryId == "Not-Available" \|\| sCategory… | GRID_STYLE | siExcelTemp.SetBGColor | (row, col, row, col, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-7efa0c6c | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1968 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, startColIdx, row, lastRowIdx, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-0675610a | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1972 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c46ce29 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1972 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac039072 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1974 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + division + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = '" … | 데이터 객체 조작/조회 |  |  |  |
| AC-91d4a54e | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1984 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, siExcelTemp.GetColumnIndex(DefColumns.LANE_QTY), row, siExcelTemp.GetColumnIndex(Def… | 그리드 표시 설정 |  |  |  |
| AC-ba836341 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:1989 | if (siExcelTemp.ActiveSheet.RowCount > 0) ▸ for (row < siExcelTemp.ActiveSheet.RowCount) ▸ else of (sCategoryId == "Not-Available" \|\| sCat… | GRID_STYLE | siExcelTemp.SetBGColor | (row, startColIdx, row, siExcelTemp.ActiveSheet.ColumnCount - 1, Color.Yellow) | 그리드 표시 설정 |  |  |  |

## SCP0049_CAPA.RecordColumnIndex

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.K…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b4a2612 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1773 |  | FLAG | G_DefColumns_LOSS_CODE | siMain.GetColumnIndex(DefColumns.LOSS_CODE) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e92452d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1774 |  | FLAG | G_DefColumns_CATEGORY_ID | siMain.GetColumnIndex(DefColumns.CATEGORY_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-28400cbe | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1775 |  | FLAG | G_DefColumns_DATA_TABLE | siMain.GetColumnIndex(DefColumns.DATA_TABLE) | 화면 필드/플래그 변경 |  |  |  |
| AC-076d462a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1778 |  | FLAG | G_DefColumns_MANAGER | siMain.GetColumnIndex(DefColumns.MANAGER) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a07f648 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1780 |  | FLAG | G_DefColumns_USER_ID_1 | siMain.GetColumnIndex(DefColumns.USER_ID_1) | 화면 필드/플래그 변경 |  |  |  |
| AC-938529a2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1781 |  | FLAG | G_DefColumns_USER_ID_2 | siMain.GetColumnIndex(DefColumns.USER_ID_2) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a793acb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1782 |  | FLAG | G_DefColumns_USER_ID_3 | siMain.GetColumnIndex(DefColumns.USER_ID_3) | 화면 필드/플래그 변경 |  |  |  |
| AC-3542b90d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1783 |  | FLAG | G_DefColumns_USER_ID_4 | siMain.GetColumnIndex(DefColumns.USER_ID_4) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2ce9b4f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1784 |  | FLAG | G_DefColumns_USER_ID_5 | siMain.GetColumnIndex(DefColumns.USER_ID_5) | 화면 필드/플래그 변경 |  |  |  |
| AC-959fc090 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1785 |  | FLAG | G_DefColumns_USER_ID_6 | siMain.GetColumnIndex(DefColumns.USER_ID_6) | 화면 필드/플래그 변경 |  |  |  |
| AC-a363eb99 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1786 |  | FLAG | G_DefColumns_USER_ID_7 | siMain.GetColumnIndex(DefColumns.USER_ID_7) | 화면 필드/플래그 변경 |  |  |  |
| AC-603da5f2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1787 |  | FLAG | G_DefColumns_USER_ID_8 | siMain.GetColumnIndex(DefColumns.USER_ID_8) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a773b1a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1788 |  | FLAG | G_DefColumns_USER_ID_9 | siMain.GetColumnIndex(DefColumns.USER_ID_9) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0233ddc | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1789 |  | FLAG | G_DefColumns_USER_ID_10 | siMain.GetColumnIndex(DefColumns.USER_ID_10) | 화면 필드/플래그 변경 |  |  |  |
| AC-a73eeb55 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1791 |  | FLAG | G_DefColumns_ROW_RANKING | siMain.GetColumnIndex(DefColumns.ROW_RANKING) | 화면 필드/플래그 변경 |  |  |  |
| AC-4786cda3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1792 |  | FLAG | G_DefColumns_DIVISION_ID | siMain.GetColumnIndex(DefColumns.DIVISION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a430c3f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1793 |  | FLAG | G_DefColumns_COMPANY_ID | siMain.GetColumnIndex(DefColumns.COMPANY_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-81710eb9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1794 |  | FLAG | G_DefColumns_SITE_ID | siMain.GetColumnIndex(DefColumns.SITE_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-7279f441 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1795 |  | FLAG | G_DefColumns_SITE_NAME | siMain.GetColumnIndex(DefColumns.SITE_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0a503f8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1796 |  | FLAG | G_DefColumns_LINE_ID | siMain.GetColumnIndex(DefColumns.LINE_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-57692d91 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1797 |  | FLAG | G_DefColumns_OPERATION_ID | siMain.GetColumnIndex(DefColumns.OPERATION_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea37c527 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1798 |  | FLAG | G_DefColumns_ELECTRODE_TYPE | siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9e161d8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1799 |  | FLAG | G_DefColumns_ITEM_ID | siMain.GetColumnIndex(DefColumns.ITEM_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d93f9b0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1800 |  | FLAG | G_DefColumns_EDITABLE | siMain.GetColumnIndex(DefColumns.EDITABLE) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7b4a59d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1802 |  | FLAG | G_DefColumns_UOM | siMain.GetColumnIndex(DefColumns.UOM) | 화면 필드/플래그 변경 |  |  |  |
| AC-04274908 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1804 |  | FLAG | G_DefColumns_PLANT_ID | siMain.GetColumnIndex(DefColumns.PLANT_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d50081c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1805 |  | FLAG | G_DefColumns_FACTORY_ID | siMain.GetColumnIndex(DefColumns.FACTORY_ID) | 화면 필드/플래그 변경 |  |  |  |
| AC-9af679c0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1806 |  | FLAG | G_DefColumns_OPERATION_GROUP_NAME | siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_NAME) | 화면 필드/플래그 변경 |  |  |  |
| AC-c2d165e8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1807 |  | FLAG | G_DefColumns_PLANT_TYPE | siMain.GetColumnIndex(DefColumns.PLANT_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-88d6d98b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1809 |  | FLAG | G_DefColumns_CONFIRM_FLAG | siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG) | 화면 필드/플래그 변경 |  |  |  |
| AC-883a6acb | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1810 |  | FLAG | G_DefColumns_LANE_QTY | siMain.GetColumnIndex(DefColumns.LANE_QTY) | 화면 필드/플래그 변경 |  |  |  |
| AC-8db0fb29 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1811 |  | FLAG | G_DefColumns_REQUEST_CHK | siMain.GetColumnIndex(DefColumns.REQUEST_CHK) | 화면 필드/플래그 변경 |  |  |  |
| AC-2718e6e1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1814 |  | FLAG | G_DefColumns_BEF_M6 | siMain.GetColumnIndex(DefColumns.BEF_M6) | 화면 필드/플래그 변경 |  |  |  |
| AC-1a1967c8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1815 |  | FLAG | G_DefColumns_BEF_M5 | siMain.GetColumnIndex(DefColumns.BEF_M5) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e0e5056 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1816 |  | FLAG | G_DefColumns_BEF_M4 | siMain.GetColumnIndex(DefColumns.BEF_M4) | 화면 필드/플래그 변경 |  |  |  |
| AC-b33fadc9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1817 |  | FLAG | G_DefColumns_BEF_M3 | siMain.GetColumnIndex(DefColumns.BEF_M3) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a9ea495 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1818 |  | FLAG | G_DefColumns_BEF_M2 | siMain.GetColumnIndex(DefColumns.BEF_M2) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdc190c2 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1819 |  | FLAG | G_DefColumns_BEF_M1 | siMain.GetColumnIndex(DefColumns.BEF_M1) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b9de396 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1820 |  | FLAG | G_DefColumns_BEF_BEST | siMain.GetColumnIndex(DefColumns.BEF_BEST) | 화면 필드/플래그 변경 |  |  |  |
| AC-070ed4ef | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1821 |  | FLAG | G_DefColumns_BEF_WORST | siMain.GetColumnIndex(DefColumns.BEF_WORST) | 화면 필드/플래그 변경 |  |  |  |
| AC-a8ac6cec | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1822 |  | FLAG | G_DefColumns_BEF_M6_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M6_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b45c869 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1823 |  | FLAG | G_DefColumns_BEF_M5_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M5_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f4fc515 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1824 |  | FLAG | G_DefColumns_BEF_M4_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M4_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-b172d97e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1825 |  | FLAG | G_DefColumns_BEF_M3_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M3_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-7759f9db | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1826 |  | FLAG | G_DefColumns_BEF_M2_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M2_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccb8fe22 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1827 |  | FLAG | G_DefColumns_BEF_M1_RESULT | siMain.GetColumnIndex(DefColumns.BEF_M1_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-ed30ffad | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1828 |  | FLAG | G_DefColumns_BEF_BEST_RESULT | siMain.GetColumnIndex(DefColumns.BEF_BEST_RESULT) | 화면 필드/플래그 변경 |  |  |  |
| AC-a303ffe9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1829 |  | FLAG | G_DefColumns_BEF_WORST_RESULT | siMain.GetColumnIndex(DefColumns.BEF_WORST_RESULT) | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPA.RequestData

진입점: this.btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0d85839 | this.btnRequest.Click | SCP0049_CAPA.cs:2526 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e994edca | this.btnRequest.Click | SCP0049_CAPA.cs:2530 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b64b861d | this.btnRequest.Click | SCP0049_CAPA.cs:2571 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_MAIL_SEND_REQUEST") ⇒ SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-bca715e0 | this.btnRequest.Click | SCP0049_CAPA.cs:2575 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f758ee30 | this.btnRequest.Click | SCP0049_CAPA.cs:2576 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-3254bffc | this.btnRequest.Click | SCP0049_CAPA.cs:2577 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-a69f7d84 | this.btnRequest.Click | SCP0049_CAPA.cs:2578 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-d0bb6c60 | this.btnRequest.Click | SCP0049_CAPA.cs:2579 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4eb5fcde | this.btnRequest.Click | SCP0049_CAPA.cs:2580 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-49ccfac5 | this.btnRequest.Click | SCP0049_CAPA.cs:2581 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-c186ea70 | this.btnRequest.Click | SCP0049_CAPA.cs:2582 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2047a85 | this.btnRequest.Click | SCP0049_CAPA.cs:2583 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e3b7bab4 | this.btnRequest.Click | SCP0049_CAPA.cs:2584 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ddc9f64d | this.btnRequest.Click | SCP0049_CAPA.cs:2585 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-fdf5ea29 | this.btnRequest.Click | SCP0049_CAPA.cs:2586 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-e904207d | this.btnRequest.Click | SCP0049_CAPA.cs:2587 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-79b73b29 | this.btnRequest.Click | SCP0049_CAPA.cs:2589 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0a022e7 | this.btnRequest.Click | SCP0049_CAPA.cs:2594 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-75fbdd83 | this.btnRequest.Click | SCP0049_CAPA.cs:2595 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00339", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-505362b9 | this.btnRequest.Click | SCP0049_CAPA.cs:2599 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5f5e3a8a | this.btnRequest.Click | SCP0049_CAPA.cs:2600 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d3148c1a | this.btnRequest.Click | SCP0049_CAPA.cs:2605 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc079e9b | this.btnRequest.Click | SCP0049_CAPA.cs:2606 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00021", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-928b402f | this.btnRequest.Click | SCP0049_CAPA.cs:2611 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8fcaf83 | this.btnRequest.Click | SCP0049_CAPA.cs:2615 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7041842e | this.btnRequest.Click | SCP0049_CAPA.cs:1291 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e592c44 | this.btnRequest.Click | SCP0049_CAPA.cs:1295 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0b490ff6 | this.btnRequest.Click | SCP0049_CAPA.cs:1336 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_MAIL_SEND_REQUEST") ⇒ SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-963aa4e8 | this.btnRequest.Click | SCP0049_CAPA.cs:1340 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-785aebd4 | this.btnRequest.Click | SCP0049_CAPA.cs:1341 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f314c2d | this.btnRequest.Click | SCP0049_CAPA.cs:1342 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-c484e6c6 | this.btnRequest.Click | SCP0049_CAPA.cs:1343 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7149c91 | this.btnRequest.Click | SCP0049_CAPA.cs:1344 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-57e4f69f | this.btnRequest.Click | SCP0049_CAPA.cs:1345 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0011eb1e | this.btnRequest.Click | SCP0049_CAPA.cs:1346 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf4b06fe | this.btnRequest.Click | SCP0049_CAPA.cs:1347 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-6347fa95 | this.btnRequest.Click | SCP0049_CAPA.cs:1348 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3adc0662 | this.btnRequest.Click | SCP0049_CAPA.cs:1349 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-d48fb151 | this.btnRequest.Click | SCP0049_CAPA.cs:1350 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6e69bb6c | this.btnRequest.Click | SCP0049_CAPA.cs:1351 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-7fe6f820 | this.btnRequest.Click | SCP0049_CAPA.cs:1352 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-12bcb40c | this.btnRequest.Click | SCP0049_CAPA.cs:1354 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc54c86b | this.btnRequest.Click | SCP0049_CAPA.cs:1359 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e98eb779 | this.btnRequest.Click | SCP0049_CAPA.cs:1360 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00339", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7490ef64 | this.btnRequest.Click | SCP0049_CAPA.cs:1364 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6be1c836 | this.btnRequest.Click | SCP0049_CAPA.cs:1365 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d89501ec | this.btnRequest.Click | SCP0049_CAPA.cs:1370 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3c05e5f7 | this.btnRequest.Click | SCP0049_CAPA.cs:1371 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00021", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bcee7a0 | this.btnRequest.Click | SCP0049_CAPA.cs:1376 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc16be23 | this.btnRequest.Click | SCP0049_CAPA.cs:1380 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPA.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bad1ac96 | SaveButton | SCP0049_CAPA.cs:1687 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e459a7d | SaveButton | SCP0049_CAPA.cs:766 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPA.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b43152ef | SaveButton | SCP0049_CAPA.cs:2129 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ade68a8a | SaveButton | SCP0049_CAPA.cs:2131 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-22672520 | SaveButton | SCP0049_CAPA.cs:2135 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d762f24d | SaveButton | SCP0049_CAPA.cs:2137 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-fbe604bd | SaveButton | SCP0049_CAPA.cs:2137 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2bb87f5 | SaveButton | SCP0049_CAPA.cs:2162 | try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ed0621e | SaveButton | SCP0049_CAPA.cs:2163 | try | DATA_OP | dtInput.Columns.Add | ("p_company_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fbb22f1 | SaveButton | SCP0049_CAPA.cs:2164 | try | DATA_OP | dtInput.Columns.Add | ("p_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d8380eb | SaveButton | SCP0049_CAPA.cs:2165 | try | DATA_OP | dtInput.Columns.Add | ("p_plant_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-10f67dca | SaveButton | SCP0049_CAPA.cs:2166 | try | DATA_OP | dtInput.Columns.Add | ("p_factory_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-01c9cc66 | SaveButton | SCP0049_CAPA.cs:2167 | try | DATA_OP | dtInput.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e198f4c | SaveButton | SCP0049_CAPA.cs:2168 | try | DATA_OP | dtInput.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8725dbb7 | SaveButton | SCP0049_CAPA.cs:2169 | try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd691cc9 | SaveButton | SCP0049_CAPA.cs:2170 | try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d4d6818 | SaveButton | SCP0049_CAPA.cs:2171 | try | DATA_OP | dtInput.Columns.Add | ("p_loss_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-4104960a | SaveButton | SCP0049_CAPA.cs:2172 | try | DATA_OP | dtInput.Columns.Add | ("p_data_table") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3a3d028 | SaveButton | SCP0049_CAPA.cs:2173 | try | DATA_OP | dtInput.Columns.Add | ("p_data_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3e08906 | SaveButton | SCP0049_CAPA.cs:2174 | try | DATA_OP | dtInput.Columns.Add | ("p_day_name") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b5bc1b8 | SaveButton | SCP0049_CAPA.cs:2175 | try | DATA_OP | dtInput.Columns.Add | ("p_day_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-58ce72ba | SaveButton | SCP0049_CAPA.cs:2176 | try | DATA_OP | dtInput.Columns.Add | ("p_lane_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4fe9797 | SaveButton | SCP0049_CAPA.cs:2177 | try | DATA_OP | dtInput.Columns.Add | ("p_confirm_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-19a20fcd | SaveButton | SCP0049_CAPA.cs:2178 | try | DATA_OP | dtInput.Columns.Add | ("p_update_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f0777fbf | SaveButton | SCP0049_CAPA.cs:2179 | try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cb630ec | SaveButton | SCP0049_CAPA.cs:2244 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f449bf8d | SaveButton | SCP0049_CAPA.cs:2245 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 9 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-70237ff5 | SaveButton | SCP0049_CAPA.cs:2247 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-45569fd5 | SaveButton | SCP0049_CAPA.cs:2248 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-5afaa795 | SaveButton | SCP0049_CAPA.cs:2249 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-162a636e | SaveButton | SCP0049_CAPA.cs:2250 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-256fb071 | SaveButton | SCP0049_CAPA.cs:2255 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ff2636cc | SaveButton | SCP0049_CAPA.cs:2256 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02d2ef7b | SaveButton | SCP0049_CAPA.cs:2258 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-275d4e94 | SaveButton | SCP0049_CAPA.cs:2259 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-7f536ecd | SaveButton | SCP0049_CAPA.cs:2260 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-f8067139 | SaveButton | SCP0049_CAPA.cs:2261 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d5e0f99 | SaveButton | SCP0049_CAPA.cs:2274 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-b8971c57 | SaveButton | SCP0049_CAPA.cs:2336 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ac077d63 | SaveButton | SCP0049_CAPA.cs:2338 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83623c9d | SaveButton | SCP0049_CAPA.cs:2340 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-ed95eea2 | SaveButton | SCP0049_CAPA.cs:2341 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-89856cea | SaveButton | SCP0049_CAPA.cs:2342 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-cea8a784 | SaveButton | SCP0049_CAPA.cs:2343 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db0fc35b | SaveButton | SCP0049_CAPA.cs:2347 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9ac6d646 | SaveButton | SCP0049_CAPA.cs:2348 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b309f9a | SaveButton | SCP0049_CAPA.cs:2350 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-94bc7645 | SaveButton | SCP0049_CAPA.cs:2351 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-a44272c0 | SaveButton | SCP0049_CAPA.cs:2352 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-ffc5661d | SaveButton | SCP0049_CAPA.cs:2353 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Doubl… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b066a31d | SaveButton | SCP0049_CAPA.cs:2359 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | arrayChangeRowCol.Add | (changeRowCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef4b628a | SaveButton | SCP0049_CAPA.cs:2402 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-13b189c8 | SaveButton | SCP0049_CAPA.cs:2403 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_division_id"] | siMain.GetValue(row, G_DefColumns_DIVISION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-1b717eb4 | SaveButton | SCP0049_CAPA.cs:2404 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_company_id"] | siMain.GetValue(row, G_DefColumns_COMPANY_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-89411f5d | SaveButton | SCP0049_CAPA.cs:2405 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_site_id"] | siMain.GetValue(row, G_DefColumns_SITE_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-2574d016 | SaveButton | SCP0049_CAPA.cs:2406 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_plant_id"] | siMain.GetValue(row, G_DefColumns_PLANT_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-5a1505f4 | SaveButton | SCP0049_CAPA.cs:2407 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_factory_id"] | siMain.GetValue(row, G_DefColumns_FACTORY_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-ed8479e2 | SaveButton | SCP0049_CAPA.cs:2408 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_line_id"] | siMain.GetValue(row, G_DefColumns_LINE_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-2eb9707f | SaveButton | SCP0049_CAPA.cs:2409 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_operation_id"] | siMain.GetValue(row, G_DefColumns_OPERATION_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-9e1f14ec | SaveButton | SCP0049_CAPA.cs:2410 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_electrode_type"] | siMain.GetValue(row, G_DefColumns_ELECTRODE_TYPE) | 행/컬럼 값 대입 |  |  |  |
| AC-e26a56ab | SaveButton | SCP0049_CAPA.cs:2411 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_item_id"] | siMain.GetValue(row, G_DefColumns_ITEM_ID) | 행/컬럼 값 대입 |  |  |  |
| AC-a1dfcc06 | SaveButton | SCP0049_CAPA.cs:2412 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_loss_code"] | siMain.GetValue(row, G_DefColumns_LOSS_CODE) | 행/컬럼 값 대입 |  |  |  |
| AC-75a1184f | SaveButton | SCP0049_CAPA.cs:2413 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_table"] | sDataTable | 행/컬럼 값 대입 |  |  |  |
| AC-6423fe13 | SaveButton | SCP0049_CAPA.cs:2414 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_type"] | sDataType | 행/컬럼 값 대입 |  |  |  |
| AC-e850d66a | SaveButton | SCP0049_CAPA.cs:2415 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_name"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-04135fa8 | SaveButton | SCP0049_CAPA.cs:2416 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-205d5264 | SaveButton | SCP0049_CAPA.cs:2417 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_lane_qty"] | siMain.GetValue(row, G_DefColumns_LANE_QTY) | 행/컬럼 값 대입 |  |  |  |
| AC-def10c30 | SaveButton | SCP0049_CAPA.cs:2418 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_confirm_flag"] | sConfrimflag | 행/컬럼 값 대입 |  |  |  |
| AC-5ef27d0b | SaveButton | SCP0049_CAPA.cs:2419 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_update_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-eadf3b03 | SaveButton | SCP0049_CAPA.cs:2421 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-545febf5 | SaveButton | SCP0049_CAPA.cs:2430 | try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5815f6 | SaveButton | SCP0049_CAPA.cs:2444 | try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0049", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab8da269 | SaveButton | SCP0049_CAPA.cs:2445 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveCapa") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveCapa] \| SCM\Capa\C… | 엔드포인트 호출 |  |  |  |
| AC-e36815ac | SaveButton | SCP0049_CAPA.cs:2448 | try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c08ff1df | SaveButton | SCP0049_CAPA.cs:2453 | try ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db668b27 | SaveButton | SCP0049_CAPA.cs:2463 | try ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51513fb7 | SaveButton | SCP0049_CAPA.cs:2472 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7e96b088 | SaveButton | SCP0049_CAPA.cs:2473 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec00674e | SaveButton | SCP0049_CAPA.cs:2479 | try ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-59202679 | SaveButton | SCP0049_CAPA.cs:2486 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9adac639 | SaveButton | SCP0049_CAPA.cs:2487 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d7af2e0 | SaveButton | SCP0049_CAPA.cs:2495 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-65b2141d | SaveButton | SCP0049_CAPA.cs:946 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-406dfe25 | SaveButton | SCP0049_CAPA.cs:948 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1a0f4728 | SaveButton | SCP0049_CAPA.cs:952 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4a76787e | SaveButton | SCP0049_CAPA.cs:954 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-27a372ab | SaveButton | SCP0049_CAPA.cs:954 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c18e9c0 | SaveButton | SCP0049_CAPA.cs:979 | try | DATA_OP | dtInput.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-27748123 | SaveButton | SCP0049_CAPA.cs:980 | try | DATA_OP | dtInput.Columns.Add | ("p_company_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-70582914 | SaveButton | SCP0049_CAPA.cs:981 | try | DATA_OP | dtInput.Columns.Add | ("p_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f51d50d9 | SaveButton | SCP0049_CAPA.cs:982 | try | DATA_OP | dtInput.Columns.Add | ("p_plant_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-baa53521 | SaveButton | SCP0049_CAPA.cs:983 | try | DATA_OP | dtInput.Columns.Add | ("p_factory_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d40948c | SaveButton | SCP0049_CAPA.cs:984 | try | DATA_OP | dtInput.Columns.Add | ("p_line_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c6f134a | SaveButton | SCP0049_CAPA.cs:985 | try | DATA_OP | dtInput.Columns.Add | ("p_operation_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-391de8b1 | SaveButton | SCP0049_CAPA.cs:986 | try | DATA_OP | dtInput.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-e192de30 | SaveButton | SCP0049_CAPA.cs:987 | try | DATA_OP | dtInput.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c333a24 | SaveButton | SCP0049_CAPA.cs:988 | try | DATA_OP | dtInput.Columns.Add | ("p_loss_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-d50ba593 | SaveButton | SCP0049_CAPA.cs:989 | try | DATA_OP | dtInput.Columns.Add | ("p_data_table") | 데이터 객체 조작/조회 |  |  |  |
| AC-105a5a88 | SaveButton | SCP0049_CAPA.cs:990 | try | DATA_OP | dtInput.Columns.Add | ("p_data_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-0690c15c | SaveButton | SCP0049_CAPA.cs:991 | try | DATA_OP | dtInput.Columns.Add | ("p_day_name") | 데이터 객체 조작/조회 |  |  |  |
| AC-54d6b92e | SaveButton | SCP0049_CAPA.cs:992 | try | DATA_OP | dtInput.Columns.Add | ("p_day_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-f676d5ff | SaveButton | SCP0049_CAPA.cs:993 | try | DATA_OP | dtInput.Columns.Add | ("p_lane_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-60841454 | SaveButton | SCP0049_CAPA.cs:994 | try | DATA_OP | dtInput.Columns.Add | ("p_confirm_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9c762a9 | SaveButton | SCP0049_CAPA.cs:995 | try | DATA_OP | dtInput.Columns.Add | ("p_update_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8e2e45b | SaveButton | SCP0049_CAPA.cs:996 | try | DATA_OP | dsInput.Tables.Add | (dtInput) | 데이터 객체 조작/조회 |  |  |  |
| AC-da3679c1 | SaveButton | SCP0049_CAPA.cs:1023 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-97995e2e | SaveButton | SCP0049_CAPA.cs:1024 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | MESSAGE | MessageHelper.GMessageBox | ("MSG00337", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d1c684b | SaveButton | SCP0049_CAPA.cs:1025 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("E2000" == sOperationId && "LANE_QTY" … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13674ba0 | SaveButton | SCP0049_CAPA.cs:1050 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e0c5d188 | SaveButton | SCP0049_CAPA.cs:1051 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 9 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49e08813 | SaveButton | SCP0049_CAPA.cs:1053 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-837eeb10 | SaveButton | SCP0049_CAPA.cs:1054 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-a1f5a331 | SaveButton | SCP0049_CAPA.cs:1055 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-e84c72b6 | SaveButton | SCP0049_CAPA.cs:1056 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9f7b17e1 | SaveButton | SCP0049_CAPA.cs:1061 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-49a8af6b | SaveButton | SCP0049_CAPA.cs:1062 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00107", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d4a513d | SaveButton | SCP0049_CAPA.cs:1064 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-0e3d3251 | SaveButton | SCP0049_CAPA.cs:1065 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-7231458c | SaveButton | SCP0049_CAPA.cs:1066 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-c0244cd8 | SaveButton | SCP0049_CAPA.cs:1067 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f988d095 | SaveButton | SCP0049_CAPA.cs:1078 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + division + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = '" … | 데이터 객체 조작/조회 |  |  |  |
| AC-0f54a08a | SaveButton | SCP0049_CAPA.cs:1089 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c2ad5bff | SaveButton | SCP0049_CAPA.cs:1090 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | MESSAGE | MessageHelper.GMessageBox | ("MSG00337", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19d0aed2 | SaveButton | SCP0049_CAPA.cs:1091 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("SCM_ITEM_LINE_ASSIGN_M" == siMain.Get… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9b3ef57 | SaveButton | SCP0049_CAPA.cs:1102 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c0485eab | SaveButton | SCP0049_CAPA.cs:1104 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | MESSAGE | MessageHelper.GMessageBox | ("MSG00193", new object[] { "Yield : 1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98cd3bcd | SaveButton | SCP0049_CAPA.cs:1106 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-4a92d686 | SaveButton | SCP0049_CAPA.cs:1107 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-03338c39 | SaveButton | SCP0049_CAPA.cs:1108 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-38e98454 | SaveButton | SCP0049_CAPA.cs:1109 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (Decim… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-73d0d6bc | SaveButton | SCP0049_CAPA.cs:1113 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-19a1a963 | SaveButton | SCP0049_CAPA.cs:1114 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | MESSAGE | MessageHelper.GMessageBox | ("MSG00072", new object[] { "Yield : 100" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-341fc377 | SaveButton | SCP0049_CAPA.cs:1116 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-5befa233 | SaveButton | SCP0049_CAPA.cs:1117 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, row) | 그리드 표시 설정 |  |  |  |
| AC-1468c4d2 | SaveButton | SCP0049_CAPA.cs:1118 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | GRID_STYLE | siMain.SpreadObject.SetViewportLeftColumn | (0, col) | 그리드 표시 설정 |  |  |  |
| AC-a01faefd | SaveButton | SCP0049_CAPA.cs:1119 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ("LA003".Equals(sLossCode)) ▸ if (100 <… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5829ab1 | SaveButton | SCP0049_CAPA.cs:1124 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | arrayChangeRowCol.Add | (changeRowCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-bec2addf | SaveButton | SCP0049_CAPA.cs:1167 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed98a13f | SaveButton | SCP0049_CAPA.cs:1168 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_division_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-091b4b64 | SaveButton | SCP0049_CAPA.cs:1169 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_company_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.COMPANY_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-7a71df11 | SaveButton | SCP0049_CAPA.cs:1170 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_site_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.SITE_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-e25d382c | SaveButton | SCP0049_CAPA.cs:1171 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_plant_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-0ef21ec5 | SaveButton | SCP0049_CAPA.cs:1172 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_factory_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.FACTORY_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-99a8513c | SaveButton | SCP0049_CAPA.cs:1173 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_line_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LINE_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-a5a58dac | SaveButton | SCP0049_CAPA.cs:1174 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_operation_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-ebe303eb | SaveButton | SCP0049_CAPA.cs:1175 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_electrode_type"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE)) | 행/컬럼 값 대입 |  |  |  |
| AC-f807a5f4 | SaveButton | SCP0049_CAPA.cs:1176 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_item_id"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-545cc7bd | SaveButton | SCP0049_CAPA.cs:1177 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_loss_code"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LOSS_CODE)) | 행/컬럼 값 대입 |  |  |  |
| AC-96eb3d09 | SaveButton | SCP0049_CAPA.cs:1178 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_table"] | sDataTable | 행/컬럼 값 대입 |  |  |  |
| AC-1d2fb50f | SaveButton | SCP0049_CAPA.cs:1179 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_data_type"] | sDataType | 행/컬럼 값 대입 |  |  |  |
| AC-69b9c5bd | SaveButton | SCP0049_CAPA.cs:1180 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_name"] | strDayName | 행/컬럼 값 대입 |  |  |  |
| AC-bd543c26 | SaveButton | SCP0049_CAPA.cs:1181 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_day_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-a99f7338 | SaveButton | SCP0049_CAPA.cs:1182 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_lane_qty"] | siMain.GetValue(row, siMain.GetColumnIndex(DefColumns.LANE_QTY)) | 행/컬럼 값 대입 |  |  |  |
| AC-776f9696 | SaveButton | SCP0049_CAPA.cs:1183 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_confirm_flag"] | sConfrimflag | 행/컬럼 값 대입 |  |  |  |
| AC-50006ed1 | SaveButton | SCP0049_CAPA.cs:1184 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dRow["p_update_id"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0d0c3405 | SaveButton | SCP0049_CAPA.cs:1186 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | dsInput.Tables[0].Rows.Add | (dRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-0acb1e2b | SaveButton | SCP0049_CAPA.cs:1195 | try ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ab53812d | SaveButton | SCP0049_CAPA.cs:1209 | try ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0049", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea5a76b4 | SaveButton | SCP0049_CAPA.cs:1210 | try ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0049_SAVE_CAPA") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0049_SAVE_CAPA] … | 엔드포인트 호출 |  |  |  |
| AC-f5673b06 | SaveButton | SCP0049_CAPA.cs:1213 | try ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ea7bf5d8 | SaveButton | SCP0049_CAPA.cs:1218 | try ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-887e34c2 | SaveButton | SCP0049_CAPA.cs:1228 | try ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ if… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c74f22de | SaveButton | SCP0049_CAPA.cs:1237 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cc1a96c4 | SaveButton | SCP0049_CAPA.cs:1238 | try ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1121309c | SaveButton | SCP0049_CAPA.cs:1244 | try ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-07015a3e | SaveButton | SCP0049_CAPA.cs:1251 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-39c90650 | SaveButton | SCP0049_CAPA.cs:1252 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5038b43 | SaveButton | SCP0049_CAPA.cs:1260 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPA.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b509b6b | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2507 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-ba6f6a3a | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2508 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-1ceb3e69 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2509 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-038f4f60 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2510 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-3e31e15b | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2511 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-bc818669 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2512 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-97d6e113 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2513 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-fe1ae03c | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:2515 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dac8adcb | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1272 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-250ba811 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1273 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-2b579bdd | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1274 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-8f1e355b | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1275 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-ed27d387 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1276 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-ea03fe6d | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1277 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-6900aa10 | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1278 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-1f2db8fb | SaveButton [try ▸ if (iCount > 0) ▸ try] | SCP0049_CAPA.cs:1280 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0049_CAPA.Set_Calculator

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ if (DefColumns.CONFIRM_FLAG != sColName && DefColumns.LANE_QTY != sColName && DefColumnsDataTable.SCM_WORK_CALENDAR_M != sDa…) ▸ if (sAction == CAppSetting.StringM && e.Column > 0)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickN…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f856ed0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:2986 | if (!dsCapa.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2034073 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:2992 | foreach (DataColumn col in dt.Columns) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-7cad40db | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:2992 | foreach (DataColumn col in dt.Columns) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a3a6470 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3061 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-afa515f3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3065 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (arrayNonOperation.Contai… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a9c8771 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3069 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (arrayNonOperation.Contai… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8b4d617 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3093 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ if (DefColumnsLossCode.XB020 == s… | DATA_OP | rr[sColumnTag] | dXB020 | 행/컬럼 값 대입 |  |  |  |
| AC-9710854a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3100 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-f12bf615 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3105 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | dLoadTime | 행/컬럼 값 대입 |  |  |  |
| AC-067a391e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3113 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-b61c5fe7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3118 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | dXE500 | 행/컬럼 값 대입 |  |  |  |
| AC-f6fa0923 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3125 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | dXE501 | 행/컬럼 값 대입 |  |  |  |
| AC-1d7c754a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3133 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | dM08 | 행/컬럼 값 대입 |  |  |  |
| AC-e98c7c16 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3140 | foreach (DataColumn col in dt.Columns) ▸ if (sColumnTag.StartsWith("M_")) ▸ foreach (DataRow rr in Rows) ▸ else of (DefColumnsLossCode.XB020… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-ba9c3b49 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3200 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-23e4ea2b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3216 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | dAvailable_DAY | 행/컬럼 값 대입 |  |  |  |
| AC-2f50c6f2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3222 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-f85abbf4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3227 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | dLoading_DAY | 행/컬럼 값 대입 |  |  |  |
| AC-c894843a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3232 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-3cd802f1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3244 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | dtLossNoRun.Select | ( "FACTORY_ID = '" + sFactoryId + "' AND LINE_ID = '" + sLineId + "' AND OPERATION_ID = '"… | 데이터 객체 조작/조회 |  |  |  |
| AC-53d9dfc0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3259 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | dOperating_DAY | 행/컬럼 값 대입 |  |  |  |
| AC-d01e1d9a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3264 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | xx | 행/컬럼 값 대입 |  |  |  |
| AC-b5723d82 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3276 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | dtTactTimeInfo.Select | ( "FACTORY_ID = '" + sFactoryId + "' AND OPERATION_ID = '" + sOperationId + "' AND LINE_ID… | 데이터 객체 조작/조회 |  |  |  |
| AC-c35aed1f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3311 | foreach (DataColumn col in dt.Columns) ▸ else of (sColumnTag.StartsWith("M_")) ▸ if (sColumnTag.StartsWith("D_")) ▸ foreach (DataRow rr in R… | DATA_OP | rr[sColumnTag] | dTact2 | 행/컬럼 값 대입 |  |  |  |
| AC-26f95fa1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3951 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-f474ad85 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3951 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-d007054f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3994 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-54d99b5d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:3998 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (arr… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-695c7fae | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4002 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (arr… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1133e6c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4026 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ if (DefColum… | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-18fec9d1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4033 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-8e549de3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4038 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-1462fcee | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4046 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-6d96bd8d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4051 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-746862e0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4058 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-1730e8c0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4066 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-3530f18c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4073 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-c04cdb4c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4115 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-6494b11c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4115 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c707a24 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4129 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d90c10b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4144 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dAvailable_DAY) | 그리드 값 설정 |  |  |  |
| AC-7972f8b7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4150 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-8d5d1a52 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4155 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dLoading_DAY) | 그리드 값 설정 |  |  |  |
| AC-69931d14 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4160 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-1e8c5693 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4168 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | dtLossNoRun.Select | ( "FACTORY_ID = '" + siMain.GetValue(row, G_DefColumns_FACTORY_ID).ToString() + "' AND LIN… | 데이터 객체 조작/조회 |  |  |  |
| AC-796c89c7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4183 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dOperating_DAY) | 그리드 값 설정 |  |  |  |
| AC-c32b37db | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4188 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-2e12573b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4195 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | dtTactTimeInfo.Select | ( "FACTORY_ID = '" + siMain.GetValue(row, G_DefColumns_FACTORY_ID).ToString() + "' AND OPE… | 데이터 객체 조작/조회 |  |  |  |
| AC-25ebd088 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:4230 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dTact2) | 그리드 값 설정 |  |  |  |
| AC-f2b456f1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1596 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-8500f416 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1596 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a82710e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1638 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbca2839 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1642 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-1730f9ee | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1646 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (arrayNonOperation.Contains(sLossCode)) ▸… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-020c765c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1670 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ if (DefColumnsLossCode.XB020 == sLossCode) | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-78c9beca | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1677 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-a4782f54 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1682 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-d6f5e882 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1690 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-c25f606c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1695 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-1f7e9a5c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1702 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-5ab6e6d0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1710 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-7f3cbb79 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… 외 6 | SCP0049_CAPA.cs:1717 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ for (row <= lastRowIdx) ▸ else of (DefColumnsLossCode.XB020 == sLossCode) ▸… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |

## SCP0049_CAPA.Set_CalculatorBestWorst

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f1d4045 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3329 | if (!dsCapa.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8f8a443 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3338 |  | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da7feb80 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3340 |  | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4adb43b9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3371 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-e824ad7c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3384 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-56802b6a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3384 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-2d95a15b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3388 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9f307de | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3388 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e92513c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3396 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a60e48b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3396 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-e67179ee | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3400 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9410133b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3400 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-bea9bb21 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3403 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColumnTag =… | DATA_OP | rr[sColumnTag] | value | 행/컬럼 값 대입 |  |  |  |
| AC-135f56e5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3409 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | CALL_EXT | siMain.GetColumnText | (0, colidx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b554d15b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3416 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | DATA_OP | sColumnTag.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-42b659bd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3421 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d1a9736 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3423 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | GRID_SET | dtTempResultValue.Rows[DtIdx++]["Value"] | tempValue | 그리드 속성/값 설정 |  |  |  |
| AC-91cfe961 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3431 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | DATA_OP | dtTempValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-fa993ef8 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:3433 | foreach (DataRow rr in Rows) ▸ foreach (DataColumn col in dt.Columns) ▸ if (!pass) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| sColumn… | GRID_SET | dtTempValue.Rows[DtIdx2++]["Value"] | tempValue | 그리드 속성/값 설정 |  |  |  |
| AC-946f921b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4252 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ad9697d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4256 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c8ff220 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4258 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1551cc52 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4276 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-59d009f0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4276 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-08f8e853 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4280 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc44acf6 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4280 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b5fdd36 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4288 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1a6d5d9 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4288 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-07528ebd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4292 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0e0cb15 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4292 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-95249c9c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4296 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-a36e1b3b | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4300 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98303ff5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4307 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | sColumnTag.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-54e59d67 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4309 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b98cc4f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:4313 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9a7a7a0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1731 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-3db5d8e1 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1735 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-759b29e4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1737 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec74e80 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1755 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cada6c5c | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1755 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4f28711 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1759 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a408b2a5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1759 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-60165dcd | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1767 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eae6054 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1767 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-d13dbd62 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1771 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3cb6e1f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1771 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-25744f59 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1775 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-fcf41116 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1779 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b5ffcf0 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1786 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | sColumnTag.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b136d4fa | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1788 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d8e1dca | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1792 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |

## SCP0049_CAPA.Set_CalculatorBestWorstValidate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30bfceb9 | (진입점 미연결) | SCP0049_CAPA.cs:3813 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayCalLoss.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-d454342c | (진입점 미연결) | SCP0049_CAPA.cs:3817 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-45de820e | (진입점 미연결) | SCP0049_CAPA.cs:3819 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) | DATA_OP | dtTempResultValue.Columns.Add | ("Value", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8f949c | (진입점 미연결) | SCP0049_CAPA.cs:3837 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ca70efa | (진입점 미연결) | SCP0049_CAPA.cs:3837 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd3d383a | (진입점 미연결) | SCP0049_CAPA.cs:3841 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-81d3c23a | (진입점 미연결) | SCP0049_CAPA.cs:3841 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd7ec50f | (진입점 미연결) | SCP0049_CAPA.cs:3849 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-58281960 | (진입점 미연결) | SCP0049_CAPA.cs:3849 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-b05114be | (진입점 미연결) | SCP0049_CAPA.cs:3853 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | dtTempResultValue.AsEnumerable().Select | (a => a.Field<double>("value")) | 데이터 객체 조작/조회 |  |  |  |
| AC-22d6b041 | (진입점 미연결) | SCP0049_CAPA.cs:3853 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | DATA_OP | a.Field | ("value") | 데이터 객체 조작/조회 |  |  |  |
| AC-7eae6a44 | (진입점 미연결) | SCP0049_CAPA.cs:3857 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ if (sColumnTag == DefColumns.BEF_BEST \|\| sColum… | GRID_SET | siMain.SetValue | (row, col, value) | 그리드 값 설정 |  |  |  |
| AC-6173e6c9 | (진입점 미연결) | SCP0049_CAPA.cs:3861 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | CALL_EXT | siMain.GetColumnText | (0, col) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78ea6361 | (진입점 미연결) | SCP0049_CAPA.cs:3868 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | sColumnTag.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-48527ebc | (진입점 미연결) | SCP0049_CAPA.cs:3870 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempResultValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3902d46 | (진입점 미연결) | SCP0049_CAPA.cs:3874 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (row <= lastRowIdx) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag == DefColumns.BEF_BEST \|\| s… | DATA_OP | dtTempValue.Rows.Add | (tempValue) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5b22b20 | (진입점 미연결) | SCP0049_CAPA.cs:3894 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col < maxCol) ▸ for (row <= maxRow) | DATA_OP | dsRes.Tables[0].Columns.Contains | (sColumnTag) | 데이터 객체 조작/조회 |  |  |  |

## SCP0049_CAPA.Set_CalculatorValidate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35b377a8 | (진입점 미연결) | SCP0049_CAPA.cs:3489 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b82e9c5 | (진입점 미연결) | SCP0049_CAPA.cs:3489 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-2bbb72d5 | (진입점 미연결) | SCP0049_CAPA.cs:3532 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) | DATA_OP | arrayNonOperation.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-89235496 | (진입점 미연결) | SCP0049_CAPA.cs:3536 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (arr… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-de82c4af | (진입점 미연결) | SCP0049_CAPA.cs:3540 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (arr… | DATA_OP | arrayNoRunNotPM.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9cc3d24 | (진입점 미연결) | SCP0049_CAPA.cs:3564 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ if (DefColum… | GRID_SET | siMain.SetValue | (row, col, dXB020) | 그리드 값 설정 |  |  |  |
| AC-ef4529e1 | (진입점 미연결) | SCP0049_CAPA.cs:3571 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-97965b05 | (진입점 미연결) | SCP0049_CAPA.cs:3576 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dLoadTime) | 그리드 값 설정 |  |  |  |
| AC-6c18d095 | (진입점 미연결) | SCP0049_CAPA.cs:3584 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-6f027698 | (진입점 미연결) | SCP0049_CAPA.cs:3589 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dXE500) | 그리드 값 설정 |  |  |  |
| AC-424c77cd | (진입점 미연결) | SCP0049_CAPA.cs:3596 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dXE501) | 그리드 값 설정 |  |  |  |
| AC-b6e623be | (진입점 미연결) | SCP0049_CAPA.cs:3604 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, dM08) | 그리드 값 설정 |  |  |  |
| AC-b9edb02c | (진입점 미연결) | SCP0049_CAPA.cs:3611 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ if (sColumnTag.IndexOf("M_") == 0) ▸ for (row <= lastRowIdx) ▸ else of (Def… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-d7b32788 | (진입점 미연결) | SCP0049_CAPA.cs:3653 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | sColumnTag.Contains | ("BEST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-673c9af8 | (진입점 미연결) | SCP0049_CAPA.cs:3653 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | sColumnTag.Contains | ("WORST_") | 데이터 객체 조작/조회 |  |  |  |
| AC-1618dcc0 | (진입점 미연결) | SCP0049_CAPA.cs:3667 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | arrayNoLoad.Contains | (sLossCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-534ada61 | (진입점 미연결) | SCP0049_CAPA.cs:3682 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dAvailable_DAY) | 그리드 값 설정 |  |  |  |
| AC-1de7a8f0 | (진입점 미연결) | SCP0049_CAPA.cs:3688 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-dc29b074 | (진입점 미연결) | SCP0049_CAPA.cs:3693 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dLoading_DAY) | 그리드 값 설정 |  |  |  |
| AC-0cc8755c | (진입점 미연결) | SCP0049_CAPA.cs:3698 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-231961a4 | (진입점 미연결) | SCP0049_CAPA.cs:3706 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | dtLossNoRun.Select | ( "FACTORY_ID = '" + siMain.GetValue(row, G_DefColumns_FACTORY_ID).ToString() + "' AND LIN… | 데이터 객체 조작/조회 |  |  |  |
| AC-7ba55b8b | (진입점 미연결) | SCP0049_CAPA.cs:3721 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dOperating_DAY) | 그리드 값 설정 |  |  |  |
| AC-cab78919 | (진입점 미연결) | SCP0049_CAPA.cs:3726 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, xx) | 그리드 값 설정 |  |  |  |
| AC-a6cfb7ea | (진입점 미연결) | SCP0049_CAPA.cs:3733 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | DATA_OP | dtTactTimeInfo.Select | ( "FACTORY_ID = '" + siMain.GetValue(row, G_DefColumns_FACTORY_ID).ToString() + "' AND OPE… | 데이터 객체 조작/조회 |  |  |  |
| AC-a9cfa7b6 | (진입점 미연결) | SCP0049_CAPA.cs:3768 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col <= lastColIdx) ▸ else of (sColumnTag.IndexOf("M_") == 0) ▸ if (sColumnTag.IndexOf("D_") == 0… | GRID_SET | siMain.SetValue | (row, col, dTact2) | 그리드 값 설정 |  |  |  |
| AC-c9f444fa | (진입점 미연결) | SCP0049_CAPA.cs:3798 | if (siMain.ActiveSheet.RowCount > 0) ▸ for (col < maxCol) ▸ for (row <= maxRow) ▸ if (a!=b) | CALL_EXT | Debug.Assert | (a == b) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.Set_ChangeValue

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ if (DefColumns.CONFIRM_FLAG != sColName && DefColumns.LANE_QTY != sColName && DefColumnsDataTable.SCM_WORK_CALENDAR_M != sDa…) ▸ if (sAction == CAppSetting.StringM && e.Column > 0) ▸ if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable \|\| DefColumnsDataTable.SCM_LOSS_M == sDataTable)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37a385d1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | SCP0049_CAPA.cs:2977 | if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable && sColName.StartsWith("D_")) | GRID_SET | siMain.SetValue | (row, newColIdx, oldValue) | 그리드 값 설정 |  |  |  |
| AC-e8453b30 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | SCP0049_CAPA.cs:1557 | if (DefColumnsDataTable.SCM_WORK_CALENDAR_M == sDataTable && sColName.StartsWith("D_")) | GRID_SET | siMain.SetValue | (row, newColIdx, oldValue) | 그리드 값 설정 |  |  |  |

## SCP0049_CAPA.Set_RefreshAfterSave

진입점: SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9925d434 | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0049_CAPA.cs:2951 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-05397a84 | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0049_CAPA.cs:2956 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-ab8e262a | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0049_CAPA.cs:1531 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb63aa2a | SaveButton [try ▸ if (iCount > 0) ▸ try ▸ if (result != null… | SCP0049_CAPA.cs:1536 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## SCP0049_CAPA.SetBackColor

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (row < siMain.ActiveSheet.RowCount)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c10e0a97 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1608 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor2 | (row, G_DefColumns_CATEGORY_ID, row, G_DefColumns_MANAGER, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-27af78da | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1610 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) ▸ if … | GRID_STYLE | siMain.SetBGColor2 | (row, siMain.GetColumnIndex("M_" + currentMonth), row, lastIdx, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-a18f517d | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1621 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | strLineIdOpeartionId | strLineId + strOperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-50a72e8e | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1622 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-702cb9d7 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1637 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | UI_PROP | range1.BackColor | Color.Gray | 속성 BackColor 설정 |  |  |  |
| AC-d3c0bb02 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1638 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | VALUE_CLEAR | range1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ae4e20ec | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1650 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && DefColumnsLossCode.LA001 == sLossCode) ▸ if (strDayName.S… | DATA_OP | arrayLA001.Contains | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c7f5de4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1651 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && DefColumnsLossCode.LA001 == sLossCode) ▸ if (strDayName.S… | DATA_OP | arrayLA001.Add | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-297b4115 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1665 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | DATA_OP | arrayLA001.Contains | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-958eb4b6 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1669 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | UI_PROP | range1.BackColor | Color.FromArgb(216, 228, 188) | 속성 BackColor 설정 |  |  |  |
| AC-04e3bd71 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1677 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-3aa42c8a | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:688 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex(DefColumns.CATEGORY_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-30af17c7 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:690 | try ▸ if (DefColumnsDataTable.CAL == sDataTable \|\| DefColumnsLossCode.M08 == sLossCode) ▸ if (DefColumnsLossCode.XA001 != sLossCode) | GRID_STYLE | siMain.SetBGColor | (row, siMain.GetColumnIndex("M_" + currentMonth) , row, lastIdx, Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-ae2a0ce4 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:701 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | strLineIdOpeartionId | strLineId + strOperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-e0810cf5 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:702 | try ▸ if (!bEdit_Mode && bRealFlag && (strLineIdOpeartionId != strLineId + strOperationId)) | FLAG | arrayLA001 | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-e6271d12 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:717 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | UI_PROP | range1.BackColor | Color.Gray | 속성 BackColor 설정 |  |  |  |
| AC-98eaa3e2 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:718 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if ((DefColumnsCategoryId.NO_RUN == sCategoryId && DefColumnsLossCode.EL011 != sLossCode)… | VALUE_CLEAR | range1.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-17f38667 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:730 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && DefColumnsLossCode.LA001 == sLossCode) ▸ if (strDayName.S… | DATA_OP | arrayLA001.Add | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-ecccd3be | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:744 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | DATA_OP | arrayLA001.Contains | (strCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d3d769f | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:748 | try ▸ for (col < siMain.ActiveSheet.ColumnCount) ▸ if (!bEdit_Mode && bRealFlag && (checkEmpty.Checked && (DefColumnsLossCode.LA002 == sLoss… | UI_PROP | range1.BackColor | Color.FromArgb(216, 228, 188) | 속성 BackColor 설정 |  |  |  |
| AC-0e6288cf | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:756 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0049_CAPA.SetBackColorBef

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0)] / this.btnExcelUpload.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogRe…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2295ef90 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:1578 | if (siMain.ActiveSheet.Rows.Count > 0 && iLastIdx >= 0) | GRID_STYLE | siMain.SetBGColor2 | (0, G_DefColumns_UOM + 1, siMain.ActiveSheet.Rows.Count - 1, iLastIdx, Color.FromArgb(240,… | 그리드 표시 설정 |  |  |  |
| AC-72a06740 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 6 | SCP0049_CAPA.cs:659 |  | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.UOM) + 1, siMain.Sheet(0).Rows.Count - 1, iLastIdx, C… | 그리드 표시 설정 |  |  |  |

## SCP0049_CAPA.SetChangeControl

진입점: this.Load [if (siMain == null \|\| (siMain.ActiveSheet.SheetName == SpdSheet.shtMain))] / clbDivision.SelectedIndexChanged [if (siMain == null \|\| (siMain.ActiveSheet.SheetName == SpdSheet.shtMain))] / cboGroup.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbBuilding.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d5b937c | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5535 | switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8bbca32 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5535 | switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6ae6f25b | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5547 | switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good()) | FLAG | dtShopGroup | DataService.GetInnerTable("SHOP_GROUP_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1ef6c6b2 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5547 | switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SHOP_GROUP_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-760508d5 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5548 | switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fa2d94f3 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5554 | switch (triggerControl) case DefColumns.SHOP_GROUP_ID: ▸ if (dtShopGroup.Good()) | DATA_OP | Filter["SHOP_GROUP_ID"] | CString.GetCheckedListValue(dtShopGroup, cboGroup.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cf6ba64b | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5555 | switch (triggerControl) case DefColumns.SHOP_GROUP_ID: ▸ if (dtShopGroup.Good()) | FLAG | dtPlantByGroup | DataService.GetInnerTable( "PLANT_ID_BY_SHOP", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-168da6b4 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5555 | switch (triggerControl) case DefColumns.SHOP_GROUP_ID: ▸ if (dtShopGroup.Good()) | COMBO_DATA | DataService.GetInnerTable | ( "PLANT_ID_BY_SHOP", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ffc2e3f4 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5556 | switch (triggerControl) case DefColumns.SHOP_GROUP_ID: ▸ if (dtShopGroup.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c4443a64 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5562 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByGroup.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlantByGroup, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a4084a3e | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5563 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByGroup.Good()) | FLAG | dtBuildingByShopGroupId | DataService.GetInnerTable("FACTORY_ID_BY_SHOP", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-d450a240 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5563 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByGroup.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID_BY_SHOP", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-793997a3 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5564 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlantByGroup.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88ff7164 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5571 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingByShopGroupId.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtBuildingByShopGroupId, clbBuilding.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-cf4166f6 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5572 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingByShopGroupId.Good()) | FLAG | dtLineByOperationPlantId | DataService.GetInnerTable("LINE_ID_BY_SHOP", Filter) ⇒ biz:AppService.GeneralExecuteQuery [batchId=LineByShop] \| FP\COMMON\BigFilter#L… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ed4b61f | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5572 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingByShopGroupId.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID_BY_SHOP", Filter) ⇒ biz:AppService.GeneralExecuteQuery [batchId=LineByShop] \| FP\COMMON\BigFilter#L… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f39771e8 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5574 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtBuildingByShopGroupId.Good()) ▸ if (dtLineByOperationPlantId !=null) | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e7541842 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5580 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperationPlantId.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLineByOperationPlantId, clbLine.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-67b10d71 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5581 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperationPlantId.Good()) | FLAG | dtOperationByLine | DataService.GetInnerTable("OPERATION_ID_BY_SHOP", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=OperationByShop] \| FP\COMMON\B… | 화면 필드/플래그 변경 |  |  |  |
| AC-c4ff3745 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5581 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperationPlantId.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID_BY_SHOP", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=OperationByShop] \| FP\COMMON\B… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4c795e53 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5583 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLineByOperationPlantId.Good()) ▸ if (dtOperationByLine != null) | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-41e213e5 | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5589 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperationByLine.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperationByLine, clbOperation.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## SCP0049_CAPA.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37332aad | this.Load 외 1 | SCP0049_CAPA.cs:673 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-141d36f6 | this.Load 외 1 | SCP0049_CAPA.cs:673 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71eff945 | this.Load 외 1 | SCP0049_CAPA.cs:674 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-57fece5f | this.Load 외 1 | SCP0049_CAPA.cs:677 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-e69b314c | this.Load 외 1 | SCP0049_CAPA.cs:677 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5ff6833d | this.Load 외 1 | SCP0049_CAPA.cs:678 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e06f77c | this.Load 외 1 | SCP0049_CAPA.cs:681 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-3617219f | this.Load 외 1 | SCP0049_CAPA.cs:681 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69c4e22a | this.Load 외 1 | SCP0049_CAPA.cs:682 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dd781da1 | this.Load 외 1 | SCP0049_CAPA.cs:686 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-a71df1e4 | this.Load 외 1 | SCP0049_CAPA.cs:686 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f5e81de1 | this.Load 외 1 | SCP0049_CAPA.cs:687 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e987d12a | this.Load 외 1 | SCP0049_CAPA.cs:691 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-dbcd277e | this.Load 외 1 | SCP0049_CAPA.cs:691 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-30f2f0a6 | this.Load 외 1 | SCP0049_CAPA.cs:692 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f431dbc4 | this.Load 외 1 | SCP0049_CAPA.cs:372 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-92850f64 | this.Load 외 1 | SCP0049_CAPA.cs:372 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca378ec8 | this.Load 외 1 | SCP0049_CAPA.cs:373 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, cboGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fff9fcba | this.Load 외 1 | SCP0049_CAPA.cs:376 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-8238f370 | this.Load 외 1 | SCP0049_CAPA.cs:376 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, division , pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d41257f | this.Load 외 1 | SCP0049_CAPA.cs:377 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-676d43da | this.Load 외 1 | SCP0049_CAPA.cs:380 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e9208a1 | this.Load 외 1 | SCP0049_CAPA.cs:380 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, division, pPlantId,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0bdeb8ba | this.Load 외 1 | SCP0049_CAPA.cs:381 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9af62592 | this.Load 외 1 | SCP0049_CAPA.cs:385 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding… | 화면 필드/플래그 변경 |  |  |  |
| AC-866d1433 | this.Load 외 1 | SCP0049_CAPA.cs:385 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, division, pPlantId, pBuilding,pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6674137d | this.Load 외 1 | SCP0049_CAPA.cs:386 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-847f652a | this.Load 외 1 | SCP0049_CAPA.cs:390 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGro… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-64ecec7a | this.Load 외 1 | SCP0049_CAPA.cs:390 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, division, pPlantId, pBuilding, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9d57d10 | this.Load 외 1 | SCP0049_CAPA.cs:391 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPA.SetFilter

진입점: this.Load [if (siMain == null \|\| (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)) ▸ switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [if (siMain == null \|\| (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)) ▸ switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good())] / cboGroup.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: case "MY_DIVISION_ID": ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) c…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0041b3c | this.Load [if (siMain == null \|\| (siMain.ActiveSheet.Sheet… 외 5 | SCP0049_CAPA.cs:5525 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## SCP0049_CAPA.SetLineAssignVisible

진입점: this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (checkEmpty.Checked && !checkLineAssign.Checked)] / txtNickName.KeyDown [if (e.KeyCode == Syste…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73942e04 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:1589 | for (row < siMain.ActiveSheet.Rows.Count) ▸ if ("LA001" == sLossCode) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (row, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3394db09 | this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MS… 외 5 | SCP0049_CAPA.cs:669 | for (row < siMain.Sheet(0).Rows.Count) ▸ if ("LA001" == sLossCode) | CALL_EXT | siMain.ActiveSheet.RemoveRows | (row, 1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPA.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65681b77 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4437 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1887dd27 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4441 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af10b492 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1913 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0ea70172 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1916 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPA.SetSpreadColumnRESULT

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / checkRESULT.CheckedChanged / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-579e6eaa | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4388 | for (i <= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6Col - i].Visible | bVisible | 그리드 속성/값 설정 |  |  |  |
| AC-b282607f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4389 | for (i <= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6ResultCol - i].Visible | bVisibleResult | 그리드 속성/값 설정 |  |  |  |
| AC-90aa586e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4392 |  | GRID_SET | siMain.ActiveSheet.Columns[iBest].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-973cafc0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4393 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorst].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-7eb765d0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4394 |  | GRID_SET | siMain.ActiveSheet.Columns[iBestResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-6fa079a5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:4395 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorstResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-781821e4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1864 | for (i<= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6Col - i].Visible | bVisible | 그리드 속성/값 설정 |  |  |  |
| AC-12fd5745 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1865 | for (i<= 5) | GRID_SET | siMain.ActiveSheet.Columns[iBefM6ResultCol - i].Visible | bVisibleResult | 그리드 속성/값 설정 |  |  |  |
| AC-4817a875 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1868 |  | GRID_SET | siMain.ActiveSheet.Columns[iBest].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-22703ee1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1869 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorst].Visible | !checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5a4bf22d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1870 |  | GRID_SET | siMain.ActiveSheet.Columns[iBestResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c1d090d4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 10 | SCP0049_CAPA.cs:1871 |  | GRID_SET | siMain.ActiveSheet.Columns[iWorstResult].Visible | checkRESULT.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPA.SetSpreadColumnTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00ab98ad | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4408 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M6, bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-89a14c8e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4409 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M5, bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-1f296426 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4410 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M4, bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-967bcaa6 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4411 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M3, bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-3798ad68 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4412 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M2, bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-e7edb376 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4413 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M1, bef1Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-08dc46a0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4415 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M6_RESULT, bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-5b4bfd38 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4416 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M5_RESULT, bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-b2cbd2d3 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4417 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M4_RESULT, bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-804de30a | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4418 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M3_RESULT, bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-e8ee324b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4419 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M2_RESULT, bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-5f9d200b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:4420 |  | GRID_INIT | siMain.SetColumnHeader | (0, G_DefColumns_BEF_M1_RESULT, bef1Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-55e8a992 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1884 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-36b2b99d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1885 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-ffb57cc0 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1886 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-83a37f6d | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1887 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-7b12f5ae | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1888 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-9f79a4ec | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1889 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1), bef1Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-3b0782f5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1891 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M6_RESULT), bef6Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-e203ef28 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1892 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M5_RESULT), bef5Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-8a8a38f1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1893 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M4_RESULT), bef4Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-f267d2d9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1894 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M3_RESULT), bef3Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-41c1063b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1895 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M2_RESULT), bef2Mon) | 그리드 재구성/초기화 |  |  |  |
| AC-66f83895 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:1896 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.BEF_M1_RESULT), bef1Mon) | 그리드 재구성/초기화 |  |  |  |

## SCP0049_CAPA.SetSpreadInit

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.buttonNewModel.Click [if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / this.btnColumn2.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05a195f9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:745 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2, dsUserTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |
| AC-cf1c6bc1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:750 | else of (siObj.SheetName == SpdSheet.shtMain) ▸ if (siObj.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a8e4e54b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:442 | if (siObj.SheetName == SpdSheet.shtMain) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 2, dsUserTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |
| AC-07c6ee0b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 9 | SCP0049_CAPA.cs:446 | else of (siObj.SheetName == SpdSheet.shtMain) ▸ if (siObj.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0049_CAPA.SetSpreadInit_day

진입점: this.formDown.Click [try ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (selected == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53dca191 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:5509 |  | FLAG | dsSpdTitle | GetExcelDown("SELECT") | 화면 필드/플래그 변경 |  |  |  |
| AC-1a3c5ab7 | this.formDown.Click [try ▸ if (select_popup.ShowDialog() == … | SCP0049_CAPA.cs:5513 | if (siObj.SheetName == SpdSheet.shtCAPAExcel) | GRID_INIT | siObj.SetSheetHeaderColumn | (siObj, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0049_CAPA.SetSpreadRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84d90e9c | (진입점 미연결) | SCP0049_CAPA.cs:1813 | for (row < siMain.ActiveSheet.RowCount) ▸ if ("LOSS" == eventParam) ▸ if (sDataTable == "SCM_WORK_CALENDAR_M" \|\| sDataTable =="SCM_LOSS_M"… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkLoss.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e70d01a2 | (진입점 미연결) | SCP0049_CAPA.cs:1820 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ if ("LINE_ASSIGN" == eventParam) ▸ if (DefColumnsLossCode.LA001 =… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkLineAssign.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-7912dd50 | (진입점 미연결) | SCP0049_CAPA.cs:1826 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ else of ("LINE_ASSIGN" == eventParam) ▸ if ("TACT_TIME" == eventP… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkTactTime.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d65d232d | (진입점 미연결) | SCP0049_CAPA.cs:1833 | for (row < siMain.ActiveSheet.RowCount) ▸ else of ("LOSS" == eventParam) ▸ else of ("LINE_ASSIGN" == eventParam) ▸ else of ("TACT_TIME" == e… | GRID_SET | siMain.ActiveSheet.Rows[row].Visible | checkYield.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPA.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-373c283c | dsdm.Changed | SCP0049_CAPA.cs:5113 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71569ae4 | dsdm.Changed | SCP0049_CAPA.cs:5124 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-963d2ee7 | dsdm.Changed | SCP0049_CAPA.cs:5126 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) ▸ if (siMain.… | GRID_SET | siMain.SetValue | (e.Row, e.Column, "False") | 그리드 값 설정 |  |  |  |
| AC-94306573 | dsdm.Changed | SCP0049_CAPA.cs:2568 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6a1df45 | dsdm.Changed | SCP0049_CAPA.cs:2579 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0360cd47 | dsdm.Changed | SCP0049_CAPA.cs:2581 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (DefColumns.REQUEST_CHK == sColName) ▸ if (siMain.… | GRID_SET | siMain.SetValue | (e.Row, e.Column, "False") | 그리드 값 설정 |  |  |  |

## SCP0049_CAPA.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a314fc77 | this.spdMain.CellClick | SCP0049_CAPA.cs:4955 | if (e.Column == G_DefColumns_CONFIRM_FLAG) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-2aac5fcb | this.spdMain.CellClick | SCP0049_CAPA.cs:2417 | if (e.Column == siMain.GetColumnIndex(DefColumns.CONFIRM_FLAG)) | GRID_SET | siMain.ActiveSheet.Cells[e.Row, e.Column].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPA.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a70e1819 | this.spdMain.CellDoubleClick | SCP0049_CAPA.cs:4969 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-8ae19bb4 | this.spdMain.CellDoubleClick | SCP0049_CAPA.cs:4983 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7aa9ddf6 | this.spdMain.CellDoubleClick | SCP0049_CAPA.cs:2431 | if (e.ColumnHeader) ▸ if (siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColum… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | !siMain.ActiveSheet.Columns[iCol].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-1dfda868 | this.spdMain.CellDoubleClick | SCP0049_CAPA.cs:2445 | else of (e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) !… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPANewModelPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8092b046 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0049_CAPANewModelPopup.cs:1460 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewModelPopup.CboGroup_SelectedIndexChanged

진입점: clbGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1b69a50 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1475 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-29bab452 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1475 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b57822ba | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1476 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-10fbf424 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1479 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-77af93ff | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1479 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a3f65771 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1480 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-73511f26 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1483 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-3bfd7277 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1483 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0b57b229 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1484 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1550308d | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1488 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-fd670cd1 | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1488 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b49991c | clbGroup.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1489 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewModelPopup.ClbBuilding_SelectedIndexChanged

진입점: clbBuilding.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b0b756 | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1520 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-3f0f55cd | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1520 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-518421ea | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1521 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c4e9d77a | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1525 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-76178342 | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1525 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5b852ee1 | clbBuilding.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1526 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewModelPopup.ClbLine_SelectedIndexChanged

진입점: clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-254e8480 | clbLine.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1537 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-19f65afd | clbLine.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1537 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineID, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47d7897d | clbLine.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1538 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewModelPopup.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e06346da | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1499 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-e47083e2 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1499 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d65b382 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1500 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-78dc6670 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1504 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFacto… | 화면 필드/플래그 변경 |  |  |  |
| AC-b091494b | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1504 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantID, pFactoryID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-61420389 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1505 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e3d99f36 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1509 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, … ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-85371455 | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1509 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantID, pFactoryID, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e82352dc | clbPlant.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:1510 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewModelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73afe1d6 | this.Load | SCP0049_CAPANewModelPopup.cs:478 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5a1dedd | this.Load | SCP0049_CAPANewModelPopup.cs:479 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fed86a07 | this.Load | SCP0049_CAPANewModelPopup.cs:480 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0049_CAPANewModelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed08cb9f | this.Load | SCP0049_CAPANewModelPopup.cs:451 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-27d2cbec | this.Load | SCP0049_CAPANewModelPopup.cs:453 |  | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-5051c37e | this.Load | SCP0049_CAPANewModelPopup.cs:453 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0049_CAPANewModelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d7dfc50 | Dispose | SCP0049_CAPANewModelPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewModelPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c109dba | EditButton | SCP0049_CAPANewModelPopup.cs:571 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48660b42 | EditButton | SCP0049_CAPANewModelPopup.cs:572 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bbb4d7c0 | EditButton | SCP0049_CAPANewModelPopup.cs:588 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ if (sPlantType == "VIRTUAL") | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84008533 | EditButton | SCP0049_CAPANewModelPopup.cs:593 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c38511c | EditButton | SCP0049_CAPANewModelPopup.cs:595 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.ELECTRODE_TYPE) + 1, row, siMain.ActiveSheet.Column… | 그리드 편집 잠금/해제 |  |  |  |
| AC-da850042 | EditButton | SCP0049_CAPANewModelPopup.cs:637 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ if (UserInfoContext.Current["NowGroupID"] =… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9408878f | EditButton | SCP0049_CAPANewModelPopup.cs:673 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | DATA_OP | _OperGroupList.Contains | (sOperationId) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc74d7b | EditButton | SCP0049_CAPANewModelPopup.cs:676 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7443c4b5 | EditButton | SCP0049_CAPANewModelPopup.cs:707 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5755c9f5 | EditButton | SCP0049_CAPANewModelPopup.cs:708 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d21bc2c | EditButton | SCP0049_CAPANewModelPopup.cs:715 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | DATA_OP | _List_FP_CategoryId.Contains | (p_backValue__FP_Cate) | 데이터 객체 조작/조회 |  |  |  |
| AC-f691dcc8 | EditButton | SCP0049_CAPANewModelPopup.cs:722 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4d4ab63 | EditButton | SCP0049_CAPANewModelPopup.cs:761 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-026601a3 | EditButton | SCP0049_CAPANewModelPopup.cs:762 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1898441f | EditButton | SCP0049_CAPANewModelPopup.cs:767 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-423662d4 | EditButton | SCP0049_CAPANewModelPopup.cs:768 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0fbc20b9 | EditButton | SCP0049_CAPANewModelPopup.cs:781 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21cbccd4 | EditButton | SCP0049_CAPANewModelPopup.cs:811 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | DATA_OP | _List_FP_CategoryId.Contains | (p_backValue__FP_Cate) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4f166c7 | EditButton | SCP0049_CAPANewModelPopup.cs:813 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | DATA_OP | _OperGroupList.Contains | (sOperationId) | 데이터 객체 조작/조회 |  |  |  |
| AC-77935c8d | EditButton | SCP0049_CAPANewModelPopup.cs:819 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.LANE_QTY), row, siMain.GetColumnIndex(DefColumns.LA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-857e6349 | EditButton | SCP0049_CAPANewModelPopup.cs:881 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8fed44bd | EditButton | SCP0049_CAPANewModelPopup.cs:882 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3e83cf43 | EditButton | SCP0049_CAPANewModelPopup.cs:889 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.CHK), row, siMain.ActiveSheet.ColumnCount - 1, true… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcef8663 | EditButton | SCP0049_CAPANewModelPopup.cs:890 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ else of (UserInfoContext.Current["NowGroupI… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.REQUEST_CHK), row, siMain.GetColumnIndex(DefColumns… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a4ebf07 | EditButton | SCP0049_CAPANewModelPopup.cs:893 | if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e6c61edc | EditButton | SCP0049_CAPANewModelPopup.cs:899 | if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefColumns.DIVISION_ID), row, siMain.ActiveSheet.ColumnCount -… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d6783ce5 | EditButton | SCP0049_CAPANewModelPopup.cs:901 | if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPANewModelPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9117cc65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:918 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-855f5524 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:918 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4830ff11 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:935 | try ▸ if (pModelId.Equals("") && pItemId.Equals("") && pNickName.Equals("")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00327", new object[] { "Model","Material","Nick Name" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51a96c0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:936 | try ▸ if (pModelId.Equals("") && pItemId.Equals("") && pNickName.Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddbed7e7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:941 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55ee896a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:945 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_NEW_MODEL") ⇒ SCP.SCP0049_GET_NEW_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-f8e0e17e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:946 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c8c61db0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:947 | try ▸ lambda | DATA_OP | request.Parameters["p_today_yyyymmdd"] | sToday | 행/컬럼 값 대입 |  |  |  |
| AC-824ca0a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:948 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c1848073 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:949 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-0c853195 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:950 | try ▸ lambda | DATA_OP | request.Parameters["p_group_id"] | pGroupId.Equals("ALL") ? DBNull.Value : pGroupId | 행/컬럼 값 대입 |  |  |  |
| AC-cdd537e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:951 | try ▸ lambda | DATA_OP | request.Parameters["p_factory_id"] | pFactoryId.Equals("ALL") ? DBNull.Value : pFactoryId | 행/컬럼 값 대입 |  |  |  |
| AC-8b80be76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:952 | try ▸ lambda | DATA_OP | request.Parameters["p_line_id"] | pLineId.Equals("ALL") ? DBNull.Value : pLineId | 행/컬럼 값 대입 |  |  |  |
| AC-7121d5f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:953 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperationId.Equals("ALL") ? DBNull.Value : pOperationId | 행/컬럼 값 대입 |  |  |  |
| AC-2cebf6f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:954 | try ▸ lambda | DATA_OP | request.Parameters["p_model_id"] | pModelId | 행/컬럼 값 대입 |  |  |  |
| AC-c6737bac | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:955 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-aef19ba4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:956 | try ▸ lambda | DATA_OP | request.Parameters["p_nick_name"] | pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-9febb614 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:957 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-e5eab119 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:958 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aaeb7f09 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:960 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eb55796e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:964 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c3ce6b28 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:965 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-39f2f15f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:968 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-253e4916 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:970 | try | DATA_OP | dtInstance_FP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b3f52d9e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:972 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | bFP_Instance | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0cb12cbc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:973 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | dtInstance_FP_div | dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).CopyToDataTa… | 화면 필드/플래그 변경 |  |  |  |
| AC-0525d074 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:973 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | DATA_OP | dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).CopyToDataTa… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afc30b21 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:973 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | DATA_OP | dtInstance_FP.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-95211685 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:975 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | GRID_CLEAR | _List_FP_CategoryId.Clear | () | 그리드 행 비움 |  |  |  |
| AC-bf8c1591 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:981 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) ▸ for (i < dtInstance_FP_div.Rows.Count… | DATA_OP | _List_FP_CategoryId.Contains | (getParam) | 데이터 객체 조작/조회 |  |  |  |
| AC-33b5020d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:983 | try ▸ if (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) ▸ for (i < dtInstance_FP_div.Rows.Count… | DATA_OP | _List_FP_CategoryId.Add | (getParam) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f478144 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:989 | try ▸ else of (dtInstance_FP.Select().Where(s => s["DIVISION_ID"].ToString() == pDivisionId).Count() > 0) | FLAG | bFP_Instance | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b45e4b1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:997 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c54bc286 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 4 | SCP0049_CAPANewModelPopup.cs:1000 | finally | CALL_BASE | OnClickEditButton | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPANewModelPopup.FindData_MyAddedAuthList

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / this.Load [if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try ▸ if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0)] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.En…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77276a56 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:411 |  | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetReqAuthMyListAdded") ⇒ SystemManager.UP_FX_GetReqAuthMyListAdded | 엔드포인트 요청 생성 |  |  |  |
| AC-c7dbf605 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:412 |  | DATA_OP | request.Parameters["p_UserID"] | Req_User_ID | 행/컬럼 값 대입 |  |  |  |
| AC-b4cb2ae1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:413 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4cd0ddd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:418 |  | RETURN | return ds.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0049_CAPANewModelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffbe7ba3 | this.Load | SCP0049_CAPANewModelPopup.cs:223 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b499472 | this.Load | SCP0049_CAPANewModelPopup.cs:224 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0049_CAPANewModelPopup.GetSpdTitle

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fd69e77 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1609 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_SHEET_CALENDAR_POPUP") ⇒ SCP.SCP0049_GET_SHEET_CALENDAR_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-034450a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1614 |  | DATA_OP | request.Parameters["p_today_yyyymm"] | sTodayMM | 행/컬럼 값 대입 |  |  |  |
| AC-9fba8fb0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1616 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-21512d0c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1616 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0049_CAPANewModelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-001abe58 | this.Load | SCP0049_CAPANewModelPopup.cs:261 |  | FLAG | dtMyDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b09d78b0 | this.Load | SCP0049_CAPANewModelPopup.cs:261 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4370c28a | this.Load | SCP0049_CAPANewModelPopup.cs:262 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-643ed022 | this.Load | SCP0049_CAPANewModelPopup.cs:264 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, divisionId) | 화면 필드/플래그 변경 |  |  |  |
| AC-925104d7 | this.Load | SCP0049_CAPANewModelPopup.cs:264 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, divisionId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58215d61 | this.Load | SCP0049_CAPANewModelPopup.cs:265 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-86976554 | this.Load | SCP0049_CAPANewModelPopup.cs:267 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, divisionId, pGroupId) | 화면 필드/플래그 변경 |  |  |  |
| AC-d597d0bc | this.Load | SCP0049_CAPANewModelPopup.cs:267 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, divisionId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-143dbe52 | this.Load | SCP0049_CAPANewModelPopup.cs:268 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5d591f20 | this.Load | SCP0049_CAPANewModelPopup.cs:270 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, divisionId, pPlantId, pGroupId… | 화면 필드/플래그 변경 |  |  |  |
| AC-ac59b42b | this.Load | SCP0049_CAPANewModelPopup.cs:270 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, divisionId, pPlantId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1476b1a1 | this.Load | SCP0049_CAPANewModelPopup.cs:271 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57b73132 | this.Load | SCP0049_CAPANewModelPopup.cs:273 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, divisionId, pPlantId, pFactor… | 화면 필드/플래그 변경 |  |  |  |
| AC-df94e3de | this.Load | SCP0049_CAPANewModelPopup.cs:273 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, divisionId, pPlantId, pFactoryId, pGroupId) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e186085 | this.Load | SCP0049_CAPANewModelPopup.cs:274 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9d8e4f08 | this.Load | SCP0049_CAPANewModelPopup.cs:282 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, divisionId, pPlantId, pFactoryId, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-065c66c0 | this.Load | SCP0049_CAPANewModelPopup.cs:282 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, divisionId, pPlantId, pFactoryId, pLineId, pGroupId) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba0e42af | this.Load | SCP0049_CAPANewModelPopup.cs:283 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c91e9845 | this.Load | SCP0049_CAPANewModelPopup.cs:286 |  | VALUE_SET | cboDivision.ControlValues | divisionId | 컨트롤 값 설정 |  |  |  |
| AC-c315ef37 | this.Load | SCP0049_CAPANewModelPopup.cs:287 |  | VALUE_SET | clbGroup.ControlValues | groupId | 컨트롤 값 설정 |  |  |  |
| AC-09c7b955 | this.Load | SCP0049_CAPANewModelPopup.cs:288 |  | VALUE_SET | clbPlant.ControlValues | plantId | 컨트롤 값 설정 |  |  |  |
| AC-3e42c816 | this.Load | SCP0049_CAPANewModelPopup.cs:289 |  | VALUE_SET | clbBuilding.ControlValues | factoryId | 컨트롤 값 설정 |  |  |  |
| AC-33dcef1e | this.Load | SCP0049_CAPANewModelPopup.cs:290 |  | VALUE_SET | clbLine.ControlValues | lineId | 컨트롤 값 설정 |  |  |  |
| AC-7c6e827d | this.Load | SCP0049_CAPANewModelPopup.cs:291 |  | VALUE_SET | clbOperation.ControlValues | operationId | 컨트롤 값 설정 |  |  |  |
| AC-0e604531 | this.Load | SCP0049_CAPANewModelPopup.cs:292 |  | VALUE_SET | txtModelId.Text | modelId | 컨트롤 값 설정 |  |  |  |
| AC-a694a235 | this.Load | SCP0049_CAPANewModelPopup.cs:293 |  | VALUE_SET | txtMaterialId.Text | itemId | 컨트롤 값 설정 |  |  |  |
| AC-70b5d147 | this.Load | SCP0049_CAPANewModelPopup.cs:294 |  | VALUE_SET | txtNickName.Text | nickName | 컨트롤 값 설정 |  |  |  |

## SCP0049_CAPANewModelPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cee804ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:487 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-c8f7fb52 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:489 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-509d878b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:491 |  | GRID_INIT | siMain.AddCheckColumn | ("SAVE", DefColumns.CHK, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4a41b98 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:493 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DIVISION_ID, DefColumns.DIVISION_ID, FPMerge.None, 50, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61f1d1fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:494 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.COMPANY_ID, DefColumns.COMPANY_ID, FPMerge.None, 50, false, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-913098a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:495 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.SITE_ID, DefColumns.SITE_ID, FPMerge.None, 50, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-248bcc60 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:496 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PLANT_ID, DefColumns.PLANT_ID, FPMerge.None, 50, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ee281bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:497 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.FACTORY_ID, DefColumns.FACTORY_ID, FPMerge.None, 60, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5be6ed1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:498 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.LINE_ID, DefColumns.LINE_ID, FPMerge.None, 80, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6729775b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:499 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.LINE_NAME, DefColumns.LINE_NAME, FPMerge.None, 80, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-340b7434 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:500 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.OPERATION_ID, DefColumns.OPERATION_ID, FPMerge.None, 50, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49e1d23c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:501 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ITEM_ID, DefColumns.ITEM_ID, FPMerge.None, 90, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ef6d83b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:502 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.NICK_NAME, DefColumns.NICK_NAME, FPMerge.None, 70, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba32d55a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:503 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.LANE_QTY, DefColumns.LANE_QTY, FPMerge.None, 50, true, FPHAlign.Center, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fb4822bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:504 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.ELECTRODE_TYPE, DefColumns.ELECTRODE_TYPE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e934ab22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:505 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_1, DefColumns.USER_ID_1, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cb6c42f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:506 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_2, DefColumns.USER_ID_2, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ee8532e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:507 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_3, DefColumns.USER_ID_3, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-043f2206 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:508 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_4, DefColumns.USER_ID_4, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cb74c02 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:509 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_5, DefColumns.USER_ID_5, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9efb0807 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:510 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_6, DefColumns.USER_ID_6, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d9c7cef7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:511 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_7, DefColumns.USER_ID_7, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc86a80c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:512 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_8, DefColumns.USER_ID_8, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ad0cb9b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:513 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_9, DefColumns.USER_ID_9, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-356cede9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:514 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.USER_ID_10, DefColumns.USER_ID_10, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c31810b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:515 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.PLANT_TYPE, DefColumns.PLANT_TYPE, FPMerge.None, 80, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a638c409 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:523 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-687316cf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:524 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-0c2d7418 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:525 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-bde26131 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:526 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.CHK)].Text | DefColumnsLabel.CHK | 그리드 속성/값 설정 |  |  |  |
| AC-844f6912 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:535 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | siMain.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38849c1c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:538 |  | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.ActiveSheet.ColumnCount-1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b092a066 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:540 |  | GRID_INIT | siMain.AddCheckColumn | ("REQ", DefColumns.REQUEST_CHK, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37ac670f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:542 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Ce… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-e21148ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:543 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Va… | false | 그리드 속성/값 설정 |  |  |  |
| AC-11bf6d04 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:544 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Bo… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-6b277525 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:545 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns.REQUEST_CHK)].Te… | DefColumnsLabel.REQUEST_CHK | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPANewModelPopup.LoadAuthority

진입점: this.Load [if (UserInfoContext.Current["NowGroupID"] != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90465ab4 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:313 | if (param_GroupID == "") | FLAG | bPartAuthority | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fb8007d0 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:321 | else of (param_GroupID == "") ▸ if (_PlannerType != PlannerType.None) | FLAG | bPartAuthority | true | 화면 필드/플래그 변경 |  |  |  |
| AC-86be7761 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:322 | else of (param_GroupID == "") ▸ if (_PlannerType != PlannerType.None) | FLAG | _CurrentGroupID | param_GroupID | 화면 필드/플래그 변경 |  |  |  |
| AC-48cedff0 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:326 | else of (param_GroupID == "") ▸ else of (_PlannerType != PlannerType.None) | FLAG | bPartAuthority | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9427f607 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:333 | if (bPartAuthority) | FLAG | dtOperGroup_SCP | Data.Common(Data.Type.LocationGroupByCapa, false, "") ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 화면 필드/플래그 변경 |  |  |  |
| AC-e7ab6419 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:333 | if (bPartAuthority) | COMBO_DATA | Data.Common | (Data.Type.LocationGroupByCapa, false, "") ⇒ biz:CommonData.CommonDataList [code=LocationGroupByCapa] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33bc2ae0 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:337 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | FLAG | _OperGroupList | dtOperGroup_SCP.Rows.OfType<DataRow>().Select(k => k["code"].ToString()).ToList() | 화면 필드/플래그 변경 |  |  |  |
| AC-c502f8e5 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:337 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | DATA_OP | dtOperGroup_SCP.Rows.OfType<DataRow>().Select | (k => k["code"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7816e70f | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:337 | if (bPartAuthority) ▸ if (dtOperGroup_SCP != null && dtOperGroup_SCP.Rows.Count > 0) | CALL_EXT | dtOperGroup_SCP.Rows.OfType | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-868f0b61 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:342 | if (bPartAuthority) | FLAG | dtMyAuthList | FindData_MyAddedAuthList(p_userInfo) | 화면 필드/플래그 변경 |  |  |  |
| AC-f9b5bf68 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:352 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pUserID = UserInfoContext.Current.UserId; /… | ⚠ 의미 확인 필요 |  |  |  |
| AC-56f1fd0e | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:364 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST") ⇒ FP_Master.PR_UI_FP01886_AUTHORITY_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-39830dba | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:365 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-ca8c92f9 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:366 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-20f5bfdf | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:367 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-346e3323 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:368 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-59ecd5a9 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:369 | try | DATA_OP | request.Parameters["p_alt_user_id"] | pUserID | 행/컬럼 값 대입 |  |  |  |
| AC-975c8bda | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:370 | try | DATA_OP | request.Parameters["p_alt_user_name"] | pUserName | 행/컬럼 값 대입 |  |  |  |
| AC-9737443f | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:371 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ed4bad63 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:372 | try | DATA_OP | request.Parameters["p_division_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b1d007b0 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:373 | try | DATA_OP | request.Parameters["p_site_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-98b6d056 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:374 | try | DATA_OP | request.Parameters["p_plant_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-fcab5c22 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:375 | try | DATA_OP | request.Parameters["p_factory_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-64733ce0 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:376 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b478e292 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:377 | try | DATA_OP | request.Parameters["p_shop_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0b4a4249 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:378 | try | DATA_OP | request.Parameters["p_plan_group"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-71dba7e1 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:379 | try | DATA_OP | request.Parameters["p_menu_authority_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2d2c7c09 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:380 | try | DATA_OP | request.Parameters["p_request_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-850d51e2 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:381 | try | DATA_OP | request.Parameters["p_release_notifiy"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-826f8bd2 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:382 | try | DATA_OP | request.Parameters["p_new_seq"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-dd0996ee | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:384 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-300965fe | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:388 | try | FLAG | dtInstance_FP | saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL… | 화면 필드/플래그 변경 |  |  |  |
| AC-7d185853 | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:388 | try | DATA_OP | saveData.Select().Where(s => s["MENU_AUTHORITY_ID"].ToString() == "PLANNER" && s["APPROVAL… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0a5814ee | this.Load [if (UserInfoContext.Current["NowGroupID"] != null… | SCP0049_CAPANewModelPopup.cs:388 | try | DATA_OP | saveData.Select | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0049_CAPANewModelPopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7289aa4 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:237 |  | FLAG | this.userId | opUserId | 화면 필드/플래그 변경 |  |  |  |
| AC-fc65c532 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:238 |  | FLAG | this.divisionId | opDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-00ffcb53 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:239 |  | FLAG | this.plantId | opPlantId | 화면 필드/플래그 변경 |  |  |  |
| AC-f9aa9ac6 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:240 |  | FLAG | this.groupId | opGroupId | 화면 필드/플래그 변경 |  |  |  |
| AC-329577ab | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:241 |  | FLAG | this.factoryId | opFactoryId | 화면 필드/플래그 변경 |  |  |  |
| AC-70e6b646 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:242 |  | FLAG | this.lineId | opLineId | 화면 필드/플래그 변경 |  |  |  |
| AC-a9a85bf9 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:243 |  | FLAG | this.operationId | opOperationId | 화면 필드/플래그 변경 |  |  |  |
| AC-67e7f6ea | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:244 |  | FLAG | this.modelId | opModelId | 화면 필드/플래그 변경 |  |  |  |
| AC-e6b771e2 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:245 |  | FLAG | this.itemId | opItemId | 화면 필드/플래그 변경 |  |  |  |
| AC-12d72fec | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:246 |  | FLAG | this.nickName | opNickName | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPANewModelPopup.PlannerTypeLogic

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b76aca8d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1012 | if (dtMyAuthList == null \|\| dtMyAuthList.Rows.Count == 0) | FLAG | dtMyAuthList | FindData_MyAddedAuthList(p_userInfo) | 화면 필드/플래그 변경 |  |  |  |
| AC-3cbda60b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1022 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7d330830 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1030 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b465c73 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1038 | if (dtMyAuthList != null && dtMyAuthList.Rows.Count > 0) | DATA_OP | dtMyAuthList.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bfd60381 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1052 | if (SCP_CAPA_bool && FP_bool) | FLAG | _PlannerType | PlannerType.SuperPlanner | 화면 필드/플래그 변경 |  |  |  |
| AC-02e718fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1056 | else of (SCP_CAPA_bool && FP_bool) ▸ if (SCP_CAPA_bool \|\| FP_bool) | FLAG | _PlannerType | PlannerType.SidePlanner | 화면 필드/플래그 변경 |  |  |  |
| AC-08862f6b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 5 | SCP0049_CAPANewModelPopup.cs:1060 | else of (SCP_CAPA_bool && FP_bool) ▸ else of (SCP_CAPA_bool \|\| FP_bool) | FLAG | _PlannerType | PlannerType.None | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPANewModelPopup.RequestData

진입점: btnRequest.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab81fee0 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1339 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ee85415b | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1343 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-97ab1ed3 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1385 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_MAIL_SEND_REQUEST") ⇒ SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-b834865c | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1389 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9a223da1 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1390 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c1c4c2c0 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1391 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-7f3c1b02 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1392 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-69e0d109 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1393 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-6e4b2a3c | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1394 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-504a5329 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1395 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-6486447f | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1396 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-fd68b79a | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1397 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-22e910c3 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1398 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-170b888b | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1399 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-93965209 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1400 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_loss_code"] | p_loss_code | 행/컬럼 값 대입 |  |  |  |
| AC-866ac6f3 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1401 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d934527f | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1403 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99c19ab9 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1421 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1572d473 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1422 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00339", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea911fe7 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1426 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3b44c6b8 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1427 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-525193d4 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1432 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6a661f72 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1433 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00021", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac63fd97 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1438 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7fb9c19 | btnRequest.Click | SCP0049_CAPANewModelPopup.cs:1442 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewModelPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-646e199c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1068 | if (siMain.ActiveSheet.Rows.Count <= 0) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-00c25677 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1069 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55aeb0f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1072 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-979c9d89 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1076 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6d6ee656 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1078 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-072b70e9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1080 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5d8ab5f4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1081 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf57d9f8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1084 | try ▸ else of (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | bSaveCheck | true | 화면 필드/플래그 변경 |  |  |  |
| AC-95505d3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1106 | try ▸ if (dtLaneQtyOfLineAssign == null) | FLAG | dtLaneQtyOfLineAssign | Data_SCP.Common(Data_SCP.Type.LaneQtyOfLineAssign, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-54584448 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1106 | try ▸ if (dtLaneQtyOfLineAssign == null) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LaneQtyOfLineAssign, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f82c141e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1109 | try | FLAG | arrayChangeRowCol | new ArrayList() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7f5c0e4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1172 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) ▸ if ("E2000" == sOperationId \|\| "E3000"… | DATA_OP | dtLaneQtyOfLineAssign.Select | ("DIVISION_ID = '" + sDivisionId + "' AND COMPANY_ID = '" + sCompanyId + "' AND SITE_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-c896b474 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1228 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) ▸ if ("LANE_QTY" != strDayName) ▸ if (1 > … | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8a9c4c83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1229 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) ▸ if ("LANE_QTY" != strDayName) ▸ if (1 > … | MESSAGE | MessageHelper.GMessageBox | ("MSG00203", new object[] { 1, 9 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-500ef66c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1231 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) ▸ if ("LANE_QTY" != strDayName) ▸ if (1 > … | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (row, col) | 그리드 표시 설정 |  |  |  |
| AC-e1fe1120 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1235 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) ▸ if ("LANE_QTY" != strDayName) ▸ if (1 > … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-055822e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1240 | try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ for (col < siMain.ActiveSheet.ColumnCount-1) | DATA_OP | arrayChangeRowCol.Add | (changeRowCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8daded1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1278 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_NEW_MODEL") ⇒ SCP.SCP0049_SAVE_NEW_MODEL | 엔드포인트 요청 생성 |  |  |  |
| AC-9b1239ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1282 | try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-738fb112 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1283 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cc01ee2b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1284 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_today_yyyymmdd"] | p_today_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-44d2fe82 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1285 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-06b29f75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1286 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-13b4e37a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1287 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-862ef007 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1288 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-47680db8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1289 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-0cc9876e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1290 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-d1f1e7c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1291 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-60b0b90f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1292 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-48cdcf25 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1293 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-6101bf75 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1294 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_day_name"] | p_day_name | 행/컬럼 값 대입 |  |  |  |
| AC-a2bce776 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1295 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_day_qty"] | p_day_qty | 행/컬럼 값 대입 |  |  |  |
| AC-76664a8f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1296 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_lane_qty"] | p_lane_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1e855bad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1297 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_data_type"] | p_data_type | 행/컬럼 값 대입 |  |  |  |
| AC-9b2ae1d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1298 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_update_id"] | p_update_id | 행/컬럼 값 대입 |  |  |  |
| AC-8720a017 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1300 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1483f74 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1305 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cfdbbf19 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1307 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6b82615 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1313 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1433cd66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1314 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd2bf2a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1319 | try ▸ else of (iCount > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b848e10f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1320 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d12f018d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1325 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bc8c858 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1329 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewModelPopup.Set_ChkRefreshData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ if (sChk != "True")] / SaveButton [try ▸ for (row <= siMain.ActiveSheet.RowCount - 1) ▸ if (sChk != "True")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b5efaa9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1635 | for (col < siMain.ActiveSheet.ColumnCount) | DATA_OP | arrayChangeRowCol.Add | (changeRowCol) | 데이터 객체 조작/조회 |  |  |  |

## SCP0049_CAPANewModelPopup.Set_RefreshAfterSave

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0946978f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1644 | foreach (int[] k in arrayChangeRowCol) | GRID_SET | siMain.SetValue | (k[0], siMain.GetColumnIndex(DefColumns.CHK) , "False") | 그리드 값 설정 |  |  |  |
| AC-d9ead16e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1645 | foreach (int[] k in arrayChangeRowCol) | CALL_EXT | CUIControl.SetActionFlag | (spdMain, k[0], "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9891d6b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0049_CAPANewModelPopup.cs:1650 | foreach (int[] k in arrayChangeRowCol) | UI_PROP | range1.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |

## SCP0049_CAPANewModelPopup.Set_UnChecked

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57a51609 | (진입점 미연결) | SCP0049_CAPANewModelPopup.cs:1656 |  | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## SCP0049_CAPANewModelPopup.SetChangedControl

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7126fde | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:426 |  | FLAG | dtShopGroup | Data_SCP.Common(Data_SCP.Type.ShopGroupId, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e3165dd | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:426 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.ShopGroupId, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-97f8ea69 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:427 |  | LIST_REBIND | clsCtrl.setListBox | (dtShopGroup, clbGroup, false, "CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5c0176f4 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:430 |  | FLAG | dtPlantByGroup | Data_SCP.Common(Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 화면 필드/플래그 변경 |  |  |  |
| AC-18ea46cf | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:430 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantByGroup, false, pDivisionID, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3fc7609f | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:431 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantByGroup, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1c83f2d0 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:435 |  | FLAG | dtBuildingByShopGroupId | Data_SCP.Common(Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupI… | 화면 필드/플래그 변경 |  |  |  |
| AC-8c2b4b14 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:435 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BuildingByShopGroupId, false, pDivisionID, pPlantId, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e783f900 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:436 |  | LIST_REBIND | clsCtrl.setListBox | (dtBuildingByShopGroupId, clbBuilding, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-639a43d6 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:440 |  | FLAG | dtLineByOperationPlantId | Data_SCP.Common(Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuild… | 화면 필드/플래그 변경 |  |  |  |
| AC-b77b4979 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:440 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.LineByOperationPlantId, false, pDivisionID, pPlantId, pBuilding, pGroupID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6816c6ba | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:441 |  | LIST_REBIND | clsCtrl.setListBox | (dtLineByOperationPlantId, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b9f33994 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:445 |  | FLAG | dtOperationByLine | Data.Common(Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, p… ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 화면 필드/플래그 변경 |  |  |  |
| AC-a9b02a55 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:445 |  | COMBO_DATA | Data.Common | (Data.Type.OperationByLine, false, pDivisionID, pPlantId, pBuilding, pLineId, pGroupID) ⇒ biz:CommonData.CommonDataList [code=OperationByLine] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3604e6f8 | cboDivision.SelectedIndexChanged | SCP0049_CAPANewModelPopup.cs:446 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationByLine, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewModelPopup.SetColumnVisible

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / clbGroup.SelectedIndexChanged / txtModelId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtMaterialId.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / txtNickName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ef0bb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | SCP0049_CAPANewModelPopup.cs:1624 | if ("E" == pGroupId) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.LANE_QTY)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-946516e3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | SCP0049_CAPANewModelPopup.cs:1626 | else of ("E" == pGroupId) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.LANE_QTY)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## SCP0049_CAPANewModelPopup.shtMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2003373f | dsdm.Changed | SCP0049_CAPANewModelPopup.cs:1543 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11f254d3 | dsdm.Changed | SCP0049_CAPANewModelPopup.cs:1557 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ if (De… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CHK), "True") | 그리드 값 설정 |  |  |  |
| AC-9d3d1063 | dsdm.Changed | SCP0049_CAPANewModelPopup.cs:1563 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (DefColumns.REQUEST_CHK == sColName) ▸ else o… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CHK), "False") | 그리드 값 설정 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.ChkBP_CheckedChanged

진입점: this.chkBP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-387719ca | this.chkBP.CheckedChanged | SCP0049_CAPANewVersionConfirmPopup.cs:111 |  | CALL_EXT | cboVersionDivision.SetAllCheckItem | (chkBP.Checked) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.ChkRP_CheckedChanged

진입점: this.chkRP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01c98fae | this.chkRP.CheckedChanged | SCP0049_CAPANewVersionConfirmPopup.cs:115 |  | CALL_EXT | cboVersionDivision.SetAllCheckItem | (chkRP.Checked) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d8b9e41 | Dispose | SCP0049_CAPANewVersionConfirmPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff12e898 | this.Load | SCP0049_CAPANewVersionConfirmPopup.cs:69 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5e576db | this.Load | SCP0049_CAPANewVersionConfirmPopup.cs:76 |  | FLAG | dtDivision | Data.Common(Data.Type.SysLookup, false, "MASTER_DATA_DIVISION_SYSTEM") ⇒ biz:CommonData.CommonDataList [code=SysLookup] | 화면 필드/플래그 변경 |  |  |  |
| AC-444b40d7 | this.Load | SCP0049_CAPANewVersionConfirmPopup.cs:76 |  | COMBO_DATA | Data.Common | (Data.Type.SysLookup, false, "MASTER_DATA_DIVISION_SYSTEM") ⇒ biz:CommonData.CommonDataList [code=SysLookup] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5dadae57 | this.Load | SCP0049_CAPANewVersionConfirmPopup.cs:94 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboVersionDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53ff3c0 | (진입점 미연결) | SCP0049_CAPANewVersionConfirmPopup.cs:63 |  | FLAG | this.userId | opUserId | 화면 필드/플래그 변경 |  |  |  |
| AC-6f7ea8ba | (진입점 미연결) | SCP0049_CAPANewVersionConfirmPopup.cs:64 |  | FLAG | this.toDay | opToday | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_CAPANewVersionConfirmPopup.SaveData

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af0e835d | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:126 |  | CALL_EXT | CString.CheckStrValue | (cboVersionDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5699f6fe | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:133 | if (string.IsNullOrEmpty(p_version_division)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00093", new object[] { "Division" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f295fea0 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:134 | if (string.IsNullOrEmpty(p_version_division)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6badfb1 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:139 | if (string.IsNullOrEmpty(p_version_name) == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "[Name]" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a779afb7 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:140 | if (string.IsNullOrEmpty(p_version_name) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2ebf4fc | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:145 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_SAVE_NEW_VERSION") ⇒ SCP.SCP0049_SAVE_NEW_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-2afdf483 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:149 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7917c27e | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:150 |  | DATA_OP | request.Parameters["p_today_yyyymmdd"] | p_today_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5361ff0f | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:151 |  | DATA_OP | request.Parameters["p_chk_bp"] | p_chk_bp | 행/컬럼 값 대입 |  |  |  |
| AC-31ea1bf5 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:152 |  | DATA_OP | request.Parameters["p_chk_rp"] | p_chk_rp | 행/컬럼 값 대입 |  |  |  |
| AC-55959fa2 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:153 |  | DATA_OP | request.Parameters["p_chk_scp"] | p_chk_scp | 행/컬럼 값 대입 |  |  |  |
| AC-7b255dd6 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:154 |  | DATA_OP | request.Parameters["p_version_division"] | p_version_division | 행/컬럼 값 대입 |  |  |  |
| AC-4f479100 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:155 |  | DATA_OP | request.Parameters["p_version_name"] | p_version_name | 행/컬럼 값 대입 |  |  |  |
| AC-54d89dd6 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:156 |  | DATA_OP | request.Parameters["p_update_id"] | p_update_id | 행/컬럼 값 대입 |  |  |  |
| AC-da01703a | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:158 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-41f098f7 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:163 | if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d5c4499d | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:167 | else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9cdd4423 | this.btnConfirm.Click | SCP0049_CAPANewVersionConfirmPopup.cs:170 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86e66f5e | this.btnButtonList.UsrButtonList_Click_Detected | SCP0049_CAPANewVersionInfoPopup.cs:260 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70515b59 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:142 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-392ba9f9 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:143 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea639b14 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:144 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ee12d92 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:130 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f643f339 | Dispose | SCP0049_CAPANewVersionInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / txtVersionName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8460ce1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:197 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d9332ddf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:197 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29bd17a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:211 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0c6d1a90 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:215 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0049_GET_NEW_VERSION_INFO") ⇒ SCP.SCP0049_GET_NEW_VERSION_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-5d5a9468 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:216 | try ▸ lambda | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-3cf4a37a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:217 | try ▸ lambda | DATA_OP | request.Parameters["p_to_date"] | p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-556c86b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:218 | try ▸ lambda | DATA_OP | request.Parameters["p_version_name"] | p_version_name | 행/컬럼 값 대입 |  |  |  |
| AC-4fe3a632 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:219 | try ▸ lambda | DATA_OP | request.Parameters["p_chk_bp"] | p_chk_bp | 행/컬럼 값 대입 |  |  |  |
| AC-5cf83d42 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:220 | try ▸ lambda | DATA_OP | request.Parameters["p_chk_rp"] | p_chk_rp | 행/컬럼 값 대입 |  |  |  |
| AC-c8df7321 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:221 | try ▸ lambda | DATA_OP | request.Parameters["p_chk_scp"] | p_chk_scp | 행/컬럼 값 대입 |  |  |  |
| AC-50b11aff | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:222 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6e28921d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:224 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-740f9933 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:228 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-60410e26 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:229 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-be06b90d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | SCP0049_CAPANewVersionInfoPopup.cs:232 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dfab4e9 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-14858cff | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b8cd62c | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:123 |  | UI_PROP | drpPeriod.Value1 | Convert.ToDateTime(DateTime.Today.AddDays(-7)) | 속성 Value1 설정 |  |  |  |
| AC-b8f8c890 | this.Load | SCP0049_CAPANewVersionInfoPopup.cs:124 |  | UI_PROP | drpPeriod.Value2 | Convert.ToDateTime(DateTime.Today) | 속성 Value2 설정 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.InitSpread

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try] / this.Load / txtVersionName.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter) ▸ try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e17dd0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:151 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8535f124 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:153 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.VERSION_ID, DefColumns.VERSION_ID, FPMerge.None, 90, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7870177a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:154 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.DIVISION_ID, DefColumns.DIVISION_ID, FPMerge.None, 60, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2912dad3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:155 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.VERSION_WEEK, DefColumns.VERSION_WEEK, FPMerge.None, 60, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3de12e58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:156 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.VERSION_DATE, DefColumns.VERSION_DATE, FPMerge.None, 90, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1a874eb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:157 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.VERSION_TIME, DefColumns.VERSION_TIME, FPMerge.None, 70, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6167cc4a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:158 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.VERSION_NAME, DefColumns.VERSION_NAME, FPMerge.None, 150, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e88230f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:159 |  | GRID_INIT | siMain.AddCheckColumn | (DefColumnsLabel.BP_USE_FLAG, DefColumns.BP_USE_FLAG, FPMerge.None, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41ed7ece | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:160 |  | GRID_INIT | siMain.AddCheckColumn | (DefColumnsLabel.RP_USE_FLAG, DefColumns.RP_USE_FLAG, FPMerge.None, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b3611a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:161 |  | GRID_INIT | siMain.AddCheckColumn | (DefColumnsLabel.SCP_USE_FLAG, DefColumns.SCP_USE_FLAG, FPMerge.None, 40, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5208faf8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | SCP0049_CAPANewVersionInfoPopup.cs:162 |  | GRID_INIT | siMain.AddTextColumn | (DefColumnsLabel.CONFIRMED_BY, DefColumns.CONFIRMED_BY, FPMerge.None, 270, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0049_CAPANewVersionInfoPopup.LoadData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c479b0c9 | (진입점 미연결) | SCP0049_CAPANewVersionInfoPopup.cs:114 |  | FLAG | this.userId | opUserId | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_ExcelSelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9249147c | .ctor | SCP0049_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-e54e1636 | .ctor | SCP0049_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-08a26538 | .ctor | SCP0049_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b8881091 | .ctor | SCP0049_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_ExcelSelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ef74052 | Dispose | SCP0049_ExcelSelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0049_ExcelSelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d09ffd0d | this.Load | SCP0049_ExcelSelect_Popup.cs:93 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_ExcelSelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43cb02b6 | this.Load | SCP0049_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-75dbca3f | this.Load | SCP0049_ExcelSelect_Popup.cs:85 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-2fc4a35c | this.Load | SCP0049_ExcelSelect_Popup.cs:88 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_ExcelSelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4475170a | rbOpt1.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:122 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c82f2f1a | rbOpt1.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:123 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b9d46bc5 | rbOpt1.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:124 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-21b283ff | rbOpt1.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:126 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0049_ExcelSelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b9a4065 | rbOpt2.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:133 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-d911594f | rbOpt2.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:134 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5e83534e | rbOpt2.CheckedChanged | SCP0049_ExcelSelect_Popup.cs:135 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0049_ExcelSelect_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0ea1f76 | (진입점 미연결) | SCP0049_ExcelSelect_Popup.cs:100 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-5c5e69bc | (진입점 미연결) | SCP0049_ExcelSelect_Popup.cs:102 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

