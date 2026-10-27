# AS-IS 액션 대조표 — FP06969

> 원천: `Doc/asisfacts/screens/FP06969/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 331행 · 메서드 27 · 종류 DATA_OP 80 · RETURN 42 · GRID_SET 33 · CALL_EXT 29 · UI_PROP 24 · FLAG 22 · MESSAGE 19 · UI_MISC 18 · POPUP 16 · GRID_STYLE 14 · GRID_INIT 7 · STATE 6 · VALUE_SET 5 · ENDPOINT 5 · THROW 3 · GRID_LOCK 2 · VALIDATE 2 · EXCEL 1 · CALL_BASE 1 · LIST_REBIND 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 30


## FP06969_Distribute.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-652ecf06 | this.btnSql.Click | FP06969_Distribute..cs:932 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e6e68a79 | this.btnSql.Click | FP06969_Distribute..cs:933 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a16153e6 | this.btnSql.Click | FP06969_Distribute..cs:935 |  | DATA_OP | popSql.Services.Add | ("SELECT_MAIN_V2") | 데이터 객체 조작/조회 |  |  |  |
| AC-7345b013 | this.btnSql.Click | FP06969_Distribute..cs:936 |  | DATA_OP | popSql.Services.Add | ("SELECT_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-c88f3980 | this.btnSql.Click | FP06969_Distribute..cs:937 |  | DATA_OP | popSql.Services.Add | ("REFRESH_SETUP_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-b12325bd | this.btnSql.Click | FP06969_Distribute..cs:938 |  | DATA_OP | popSql.Services.Add | ("SAVE_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f0d088e | this.btnSql.Click | FP06969_Distribute..cs:939 |  | DATA_OP | popSql.Services.Add | ("SAVE_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-625dc364 | this.btnSql.Click | FP06969_Distribute..cs:940 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP06969_Distribute.btnUpload_Click

진입점: this.btnSelect.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-330bfa93 | this.btnSelect.Click | FP06969_Distribute..cs:1316 | try | CALL_EXT | Registry.CurrentUser.CreateSubKey | (@"devscm\setting") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ba0ad77 | this.btnSelect.Click | FP06969_Distribute..cs:1317 | try | UI_MISC | key.Close | () | 창 닫기/해제 |  |  |  |
| AC-1f3853aa | this.btnSelect.Click | FP06969_Distribute..cs:1326 | try | CALL_EXT | Registry.CurrentUser.OpenSubKey | (@"devscm\setting", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcb56fe6 | this.btnSelect.Click | FP06969_Distribute..cs:1328 | try | UI_MISC | key.Close | () | 창 닫기/해제 |  |  |  |
| AC-f425c345 | this.btnSelect.Click | FP06969_Distribute..cs:1334 |  | POPUP | new FolderBrowserDialog | () | 팝업/폼 생성 |  |  |  |
| AC-542324a8 | this.btnSelect.Click | FP06969_Distribute..cs:1337 |  | UI_PROP | folderBrowserDialog.Description | "Select Base Folder" | 속성 Description 설정 |  |  |  |
| AC-40b507a7 | this.btnSelect.Click | FP06969_Distribute..cs:1338 |  | UI_PROP | folderBrowserDialog.SelectedPath | domain | 속성 SelectedPath 설정 |  |  |  |
| AC-4da78e2c | this.btnSelect.Click | FP06969_Distribute..cs:1341 |  | POPUP | folderBrowserDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9b3a556f | this.btnSelect.Click | FP06969_Distribute..cs:1347 | if (result == DialogResult.OK) | VALUE_SET | txtBase.Text | selectedFolder | 컨트롤 값 설정 |  |  |  |
| AC-3da9576a | this.btnSelect.Click | FP06969_Distribute..cs:1351 | if (result == DialogResult.OK) ▸ try | CALL_EXT | Registry.CurrentUser.OpenSubKey | (@"devscm\setting", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c22ed74 | this.btnSelect.Click | FP06969_Distribute..cs:1352 | if (result == DialogResult.OK) ▸ try | GRID_SET | key.SetValue | ("lastdomain", selectedFolder) | 그리드 값 설정 |  |  |  |
| AC-c94bcbb1 | this.btnSelect.Click | FP06969_Distribute..cs:1353 | if (result == DialogResult.OK) ▸ try | UI_MISC | key.Close | () | 창 닫기/해제 |  |  |  |

## FP06969_Distribute.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-319538a9 | this.Load | FP06969_Distribute..cs:223 | try | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28a7524f | this.Load | FP06969_Distribute..cs:224 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a75772f | this.Load | FP06969_Distribute..cs:228 | try | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cde49402 | this.Load | FP06969_Distribute..cs:234 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-b9946f9c | this.Load | FP06969_Distribute..cs:235 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP06969_Distribute.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-586bd98c | DeleteButton | FP06969_Distribute..cs:396 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88f025cc | Dispose | FP06969_Distribute..Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP06969_Distribute.DoDownload

진입점: this.btnDownload.Click [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-365039fa | this.btnDownload.Click [try ▸ lambda] | FP06969_Distribute..cs:1449 | if (download.Good()) ▸ foreach (DataRow row in download.Tables[0].Rows) ▸ if (row != null) ▸ if (cc == true) | CALL_EXT | DataService.FP_DataPull | (fi.DirectoryName, path, shortname, Filter.Dictionary) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aba41467 | this.btnDownload.Click [try ▸ lambda] | FP06969_Distribute..cs:1454 | if (download.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9b3d65c2 | this.btnDownload.Click [try ▸ lambda] | FP06969_Distribute..cs:1456 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.DoUpload

진입점: this.btnUpload.Click [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25bc4a53 | this.btnUpload.Click [try ▸ lambda] | FP06969_Distribute..cs:1527 | if (dbUpload.Good()) ▸ foreach (DataRow row in dbUpload.Tables[0].Rows) ▸ if (row != null) ▸ if (cc == true && isFolder!="Y") | CALL_EXT | DataService.FP_DataPushFile | (fi.FullName, shortname, domain, Path.DirectorySeparatorChar +path, true,Filter.Dictionary… | ⚠ 의미 확인 필요 |  |  |  |
| AC-374daec3 | this.btnUpload.Click [try ▸ lambda] | FP06969_Distribute..cs:1532 | if (dbUpload.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-439da798 | this.btnUpload.Click [try ▸ lambda] | FP06969_Distribute..cs:1534 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-131b1f7b | EditButton | FP06969_Distribute..cs:306 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-973f7a3b | EditButton | FP06969_Distribute..cs:315 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-94ba96b6 | EditButton | FP06969_Distribute..cs:316 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.REFERANCE_OPERATION_ID), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8ce57b4a | EditButton | FP06969_Distribute..cs:326 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-0e74d53f | EditButton | FP06969_Distribute..cs:327 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-99e96458 | EditButton | FP06969_Distribute..cs:332 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-a07df048 | EditButton | FP06969_Distribute..cs:333 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (!siM… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-279e48c1 | EditButton | FP06969_Distribute..cs:341 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-eac039ba | EditButton | FP06969_Distribute..cs:345 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-aabb6835 | EditButton | FP06969_Distribute..cs:346 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-dc60b7cb | EditButton | FP06969_Distribute..cs:350 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-b385f314 | EditButton | FP06969_Distribute..cs:351 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-0c0b2de9 | EditButton | FP06969_Distribute..cs:358 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-c8e7e056 | EditButton | FP06969_Distribute..cs:362 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.CALCULATION), i, siMain.GetColumnIndex(DefColumns.CAL… | 그리드 표시 설정 |  |  |  |
| AC-f1e00442 | EditButton | FP06969_Distribute..cs:369 | if (this.fps != null) ▸ switch (fps.Name) case "spdMain": | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c752059e | ExcelButton | FP06969_Distribute..cs:407 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP06969_Distribute.Find_Data_Main

진입점: this.btnDownload.Click [try ▸ lambda] / this.btnUpload.Click [try ▸ lambda] / popSql.OnSql [if (programID == "SELECT_MAIN_V2")] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f1b51f | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:681 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 domain = CString.GetCheckedListValue(dtCate… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7aaa544c | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:696 | try | DATA_OP | filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-30ec538e | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:705 | try | CALL_EXT | DataService.FP_FileDataClient | (domain, "none", Filter.Dictionary) | ⚠ 의미 확인 필요 |  |  |  |
| AC-31bff6e4 | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:707 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b5b040e1 | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:712 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-98ae947d | this.btnDownload.Click [try ▸ lambda] 외 4 | FP06969_Distribute..cs:716 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP06969_Distribute.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71be11cb | this.Load | FP06969_Distribute..cs:115 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP06969_Distribute.GetHash

진입점: this.btnDownload.Click [try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile))] / this.btnUpload.Click [try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile))] / FindButton [try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68581568 | this.btnDownload.Click [try ▸ if (ds.Good()) ▸ foreach (Data… 외 3 | FP06969_Distribute..cs:668 |  | CALL_EXT | SHA256.Create | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8eba4c82 | this.btnDownload.Click [try ▸ if (ds.Good()) ▸ foreach (Data… 외 3 | FP06969_Distribute..cs:670 |  | CALL_EXT | File.OpenRead | (filePath) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6bfdf0ce | this.btnDownload.Click [try ▸ if (ds.Good()) ▸ foreach (Data… 외 3 | FP06969_Distribute..cs:672 |  | CALL_EXT | sha256.ComputeHash | (stream) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d06acdf | this.btnDownload.Click [try ▸ if (ds.Good()) ▸ foreach (Data… 외 3 | FP06969_Distribute..cs:673 |  | RETURN | return BitConverter.ToString(hash).Replace("-", string.Empty); |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.GoDownload

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d3e1002 | this.btnDownload.Click | FP06969_Distribute..cs:1368 |  | CALL_EXT | Directory.Exists | (txtBase.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7416f07a | this.btnDownload.Click | FP06969_Distribute..cs:1370 | if (!Directory.Exists(txtBase.Text)) | MESSAGE | MessageBox.Show | ("You must select available directory first") | 메시지 표시 |  |  |  |
| AC-eea3a152 | this.btnDownload.Click | FP06969_Distribute..cs:1371 | if (!Directory.Exists(txtBase.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4492db8d | this.btnDownload.Click | FP06969_Distribute..cs:1376 | if (string.IsNullOrWhiteSpace(domain) \|\| cboDomain.ControlValues == "ALL") | MESSAGE | MessageBox.Show | ("You must select available domain first") | 메시지 표시 |  |  |  |
| AC-1a9b8335 | this.btnDownload.Click | FP06969_Distribute..cs:1377 | if (string.IsNullOrWhiteSpace(domain) \|\| cboDomain.ControlValues == "ALL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63767f70 | this.btnDownload.Click | FP06969_Distribute..cs:1380 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1350c716 | this.btnDownload.Click | FP06969_Distribute..cs:1381 |  | CALL_EXT | Path.Combine | (txtBase.Text, domain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6625f1e8 | this.btnDownload.Click | FP06969_Distribute..cs:1386 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2ac2406a | this.btnDownload.Click | FP06969_Distribute..cs:1389 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8f3823fb | this.btnDownload.Click | FP06969_Distribute..cs:1390 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => // FullDownload //DataService.FP_DataPull(downloadPath, domain, "", Filter.Dictiona… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d407eee8 | this.btnDownload.Click | FP06969_Distribute..cs:1400 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-6216656b | this.btnDownload.Click | FP06969_Distribute..cs:1401 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP06969_Distribute.goUpload

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fc01c38 | this.btnUpload.Click | FP06969_Distribute..cs:1466 |  | CALL_EXT | Directory.Exists | (txtBase.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d294a9e | this.btnUpload.Click | FP06969_Distribute..cs:1468 | if (!Directory.Exists(txtBase.Text)) | MESSAGE | MessageBox.Show | ("You must select available directory first") | 메시지 표시 |  |  |  |
| AC-141c6e95 | this.btnUpload.Click | FP06969_Distribute..cs:1469 | if (!Directory.Exists(txtBase.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f42f8893 | this.btnUpload.Click | FP06969_Distribute..cs:1474 | if (string.IsNullOrWhiteSpace(domain) \|\| cboDomain.ControlValues== "ALL") | MESSAGE | MessageBox.Show | ("You must select available domain first") | 메시지 표시 |  |  |  |
| AC-5f0374d9 | this.btnUpload.Click | FP06969_Distribute..cs:1475 | if (string.IsNullOrWhiteSpace(domain) \|\| cboDomain.ControlValues== "ALL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec482fb7 | this.btnUpload.Click | FP06969_Distribute..cs:1477 |  | CALL_EXT | Path.Combine | (txtBase.Text, domain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ef156f1 | this.btnUpload.Click | FP06969_Distribute..cs:1479 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ea682033 | this.btnUpload.Click | FP06969_Distribute..cs:1483 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-20a6d084 | this.btnUpload.Click | FP06969_Distribute..cs:1486 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3339dc5 | this.btnUpload.Click | FP06969_Distribute..cs:1487 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => // FolderUpload //DataService.FP_DataPush(upload_base_folder, domain, "", true, Fil… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77d0db85 | this.btnUpload.Click | FP06969_Distribute..cs:1497 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9bb5d86c | this.btnUpload.Click | FP06969_Distribute..cs:1498 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP06969_Distribute.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59deba4 | this.Load | FP06969_Distribute..cs:150 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f2013ba | this.Load | FP06969_Distribute..cs:156 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2da63238 | this.Load | FP06969_Distribute..cs:157 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ff6acdfe | this.Load | FP06969_Distribute..cs:158 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-41920774 | this.Load | FP06969_Distribute..cs:163 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-44407d32 | this.Load | FP06969_Distribute..cs:165 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-7522d3ac | this.Load | FP06969_Distribute..cs:168 | try | FLAG | dtCategory | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-b4500f59 | this.Load | FP06969_Distribute..cs:169 | try | UI_PROP | dtCategory.TableName | "domain" | 속성 TableName 설정 |  |  |  |
| AC-9c92d7ee | this.Load | FP06969_Distribute..cs:170 | try | DATA_OP | dtCategory.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-81187b30 | this.Load | FP06969_Distribute..cs:171 | try | DATA_OP | dtCategory.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-70fe4a28 | this.Load | FP06969_Distribute..cs:173 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9a769710 | this.Load | FP06969_Distribute..cs:174 | try | DATA_OP | row["CODE"] | row["NAME"] = "Deploy" | 행/컬럼 값 대입 |  |  |  |
| AC-c8aed99c | this.Load | FP06969_Distribute..cs:174 | try | DATA_OP | row["NAME"] | "Deploy" | 행/컬럼 값 대입 |  |  |  |
| AC-682cccde | this.Load | FP06969_Distribute..cs:175 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-31282339 | this.Load | FP06969_Distribute..cs:176 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55de0df2 | this.Load | FP06969_Distribute..cs:177 | try | DATA_OP | row["CODE"] | row["NAME"] = "FoxQuery" | 행/컬럼 값 대입 |  |  |  |
| AC-fef0b2e9 | this.Load | FP06969_Distribute..cs:177 | try | DATA_OP | row["NAME"] | "FoxQuery" | 행/컬럼 값 대입 |  |  |  |
| AC-6aaa079b | this.Load | FP06969_Distribute..cs:178 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b1e98bf | this.Load | FP06969_Distribute..cs:179 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f2f496a | this.Load | FP06969_Distribute..cs:180 | try | DATA_OP | row["CODE"] | row["NAME"] = "GSCM_FILE" | 행/컬럼 값 대입 |  |  |  |
| AC-0b296a1c | this.Load | FP06969_Distribute..cs:180 | try | DATA_OP | row["NAME"] | "GSCM_FILE" | 행/컬럼 값 대입 |  |  |  |
| AC-f29fa4cf | this.Load | FP06969_Distribute..cs:181 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e42a7b66 | this.Load | FP06969_Distribute..cs:182 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-481bcb19 | this.Load | FP06969_Distribute..cs:183 | try | DATA_OP | row["CODE"] | row["NAME"] = "GSCM_HELP" | 행/컬럼 값 대입 |  |  |  |
| AC-6b583142 | this.Load | FP06969_Distribute..cs:183 | try | DATA_OP | row["NAME"] | "GSCM_HELP" | 행/컬럼 값 대입 |  |  |  |
| AC-f6f689d3 | this.Load | FP06969_Distribute..cs:184 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-5107c6f2 | this.Load | FP06969_Distribute..cs:185 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-50a458e3 | this.Load | FP06969_Distribute..cs:186 | try | DATA_OP | row["CODE"] | row["NAME"] = "Log" | 행/컬럼 값 대입 |  |  |  |
| AC-ee7fed0d | this.Load | FP06969_Distribute..cs:186 | try | DATA_OP | row["NAME"] | "Log" | 행/컬럼 값 대입 |  |  |  |
| AC-d4cd185d | this.Load | FP06969_Distribute..cs:187 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-10d71dc6 | this.Load | FP06969_Distribute..cs:188 | try | DATA_OP | dtCategory.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4597a3e7 | this.Load | FP06969_Distribute..cs:189 | try | DATA_OP | row["CODE"] | row["NAME"] = "UserLog" | 행/컬럼 값 대입 |  |  |  |
| AC-1ef28549 | this.Load | FP06969_Distribute..cs:189 | try | DATA_OP | row["NAME"] | "UserLog" | 행/컬럼 값 대입 |  |  |  |
| AC-a7b338de | this.Load | FP06969_Distribute..cs:190 | try | DATA_OP | dtCategory.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-51b41b41 | this.Load | FP06969_Distribute..cs:191 | try | LIST_REBIND | clsCtrl.setListBox | (dtCategory, cboDomain, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-05830b5f | this.Load | FP06969_Distribute..cs:195 | try ▸ if (!adminAuth) | STATE | btnUpload.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-30cfc2a8 | this.Load | FP06969_Distribute..cs:196 | try ▸ if (!adminAuth) | STATE | btnDownload.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0f4d6efa | this.Load | FP06969_Distribute..cs:197 | try ▸ if (!adminAuth) | STATE | btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3964e7c6 | this.Load | FP06969_Distribute..cs:198 | try ▸ if (!adminAuth) | STATE | btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b0653e8b | this.Load | FP06969_Distribute..cs:199 | try ▸ if (!adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-7c4f4ecb | this.Load | FP06969_Distribute..cs:200 | try ▸ if (!adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6cf8d31b | this.Load | FP06969_Distribute..cs:201 | try ▸ if (!adminAuth) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-69fe9a95 | this.Load | FP06969_Distribute..cs:202 | try ▸ if (!adminAuth) | UI_PROP | layoutControlItem4.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9e4593f2 | this.Load | FP06969_Distribute..cs:203 | try ▸ if (!adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-02c4b8bf | this.Load | FP06969_Distribute..cs:209 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-f79ee959 | this.Load | FP06969_Distribute..cs:210 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP06969_Distribute.InitSpread

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79d1cff0 | this.Load [try] | FP06969_Distribute..cs:245 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-463b0170 | this.Load [try] | FP06969_Distribute..cs:248 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-8de81464 | this.Load [try] | FP06969_Distribute..cs:253 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ca15bf6 | this.Load [try] | FP06969_Distribute..cs:256 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-8955fa33 | this.Load [try] | FP06969_Distribute..cs:257 | try ▸ if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-eb16162e | this.Load [try] | FP06969_Distribute..cs:289 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message.ToString()) | 메시지 표시 |  |  |  |
| AC-10823827 | this.Load [try] | FP06969_Distribute..cs:290 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP06969_Distribute.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-558c5461 | InsertButton | FP06969_Distribute..cs:390 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.onDownloadMenu

진입점: download.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9319914 | download.Click | FP06969_Distribute..cs:1052 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00c9a869 | download.Click | FP06969_Distribute..cs:1055 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2b4da50 | download.Click | FP06969_Distribute..cs:1071 | if (select.Count > 0) ▸ if (range != null) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5e581445 | download.Click | FP06969_Distribute..cs:1072 | if (select.Count > 0) ▸ if (range != null) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cea570c7 | download.Click | FP06969_Distribute..cs:1079 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | CALL_EXT | Directory.Exists | (txtBase.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d8e6973 | download.Click | FP06969_Distribute..cs:1081 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (!Directory.Exists(txtBase.Text)) | MESSAGE | MessageBox.Show | ("You must select available directory first") | 메시지 표시 |  |  |  |
| AC-1eb89228 | download.Click | FP06969_Distribute..cs:1082 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (!Directory.Exists(txtBase.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5877cf47 | download.Click | FP06969_Distribute..cs:1094 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | POPUP | new System.Windows.Forms.SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-cb9e730d | download.Click | FP06969_Distribute..cs:1095 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | UI_PROP | ofp.FileName | shortname | 속성 FileName 설정 |  |  |  |
| AC-342ea925 | download.Click | FP06969_Distribute..cs:1096 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | POPUP | ofp.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f593f464 | download.Click | FP06969_Distribute..cs:1103 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (fi.Name.ToUpper() != sh… | MESSAGE | MessageBox.Show | ("File Name ignored. Use "+shortname, "Name Not Match", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-22fe336f | download.Click | FP06969_Distribute..cs:1104 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (fi.Name.ToUpper() != sh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55fb312d | download.Click | FP06969_Distribute..cs:1107 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | DataService.FP_DataPull | (fi.DirectoryName, path, shortname, Filter.Dictionary) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80ada579 | download.Click | FP06969_Distribute..cs:1110 | if (select.Count > 0) ▸ if (range != null) ▸ try | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c9c4940a | download.Click | FP06969_Distribute..cs:1120 | if (select.Count > 0) ▸ if (range != null) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b138ea5a | download.Click | FP06969_Distribute..cs:1121 | if (select.Count > 0) ▸ if (range != null) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c8e25350 | download.Click | FP06969_Distribute..cs:1124 | if (select.Count > 0) ▸ if (range != null) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP06969_Distribute.onUploadMenu

진입점: upload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3de83680 | upload.Click | FP06969_Distribute..cs:966 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd7f41be | upload.Click | FP06969_Distribute..cs:969 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb725e40 | upload.Click | FP06969_Distribute..cs:985 | if (select.Count > 0) ▸ if (range != null) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fe17337d | upload.Click | FP06969_Distribute..cs:986 | if (select.Count > 0) ▸ if (range != null) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a12a75d0 | upload.Click | FP06969_Distribute..cs:1001 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (string.IsNullOrWhiteSpace(server_domain) \|\| cboDomain.ControlVal… | MESSAGE | MessageBox.Show | ("You must select available domain first") | 메시지 표시 |  |  |  |
| AC-5701c4dd | upload.Click | FP06969_Distribute..cs:1002 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (string.IsNullOrWhiteSpace(server_domain) \|\| cboDomain.ControlVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c55c35d | upload.Click | FP06969_Distribute..cs:1008 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | POPUP | new System.Windows.Forms.OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-1de14c8c | upload.Click | FP06969_Distribute..cs:1009 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) | POPUP | ofp.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4bcb566c | upload.Click | FP06969_Distribute..cs:1016 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (fi.Name.ToUpper() != se… | MESSAGE | MessageBox.Show | ("Are you sure? File name not matched!!!", "Name Not Match", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-06ec26dd | upload.Click | FP06969_Distribute..cs:1017 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) ▸ if (fi.Name.ToUpper() != se… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31130c84 | upload.Click | FP06969_Distribute..cs:1020 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | DataService.StripPath | (server_side_full_path, server_side_base_path,server_shortbame) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67a645cb | upload.Click | FP06969_Distribute..cs:1023 | if (select.Count > 0) ▸ if (range != null) ▸ try ▸ if (row != null) ▸ if (ofp.ShowDialog() == DialogResult.OK) | CALL_EXT | DataService.FP_DataPushFile | (fi.FullName, server_shortbame, server_domain, server_path, true, Filter.Dictionary) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af1826f1 | upload.Click | FP06969_Distribute..cs:1026 | if (select.Count > 0) ▸ if (range != null) ▸ try | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a99080b | upload.Click | FP06969_Distribute..cs:1036 | if (select.Count > 0) ▸ if (range != null) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ee70b50d | upload.Click | FP06969_Distribute..cs:1037 | if (select.Count > 0) ▸ if (range != null) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c26b4615 | upload.Click | FP06969_Distribute..cs:1040 | if (select.Count > 0) ▸ if (range != null) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP06969_Distribute.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9cded86 | popSql.OnSql | FP06969_Distribute..cs:1297 | if (programID == "SELECT_MAIN_V2") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-0f81c721 | popSql.OnSql | FP06969_Distribute..cs:1299 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.Save_Data_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63610a50 | (진입점 미연결) | FP06969_Distribute..cs:815 | try | DATA_OP | dsMain.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2bbe78a0 | (진입점 미연결) | FP06969_Distribute..cs:816 | try | DATA_OP | dsDelete.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-41ddc607 | (진입점 미연결) | FP06969_Distribute..cs:825 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dsDelete.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d19949f3 | (진입점 미연결) | FP06969_Distribute..cs:826 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c6248524 | (진입점 미연결) | FP06969_Distribute..cs:827 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-38923347 | (진입점 미연결) | FP06969_Distribute..cs:828 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_CATEGORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_CATEGORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f8cbb5e7 | (진입점 미연결) | FP06969_Distribute..cs:829 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_KEY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_KEY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1a453013 | (진입점 미연결) | FP06969_Distribute..cs:830 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (actionState == CAppSetting.FlagD) | DATA_OP | dsDelete.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-a15db896 | (진입점 미연결) | FP06969_Distribute..cs:843 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dsSave.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a2a4e975 | (진입점 미연결) | FP06969_Distribute..cs:844 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.INSTANCE_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.INSTANCE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21a3075b | (진입점 미연결) | FP06969_Distribute..cs:845 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.OPERATION_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.OPERATION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b9a8885 | (진입점 미연결) | FP06969_Distribute..cs:846 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.CALCULATION] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CALCULATION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5880eeb8 | (진입점 미연결) | FP06969_Distribute..cs:847 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_CATEGORY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_CATEGORY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f58ec814 | (진입점 미연결) | FP06969_Distribute..cs:848 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | row[DefColumns.SETUP_KEY_ID] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SETUP_KEY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7c082b18 | (진입점 미연결) | FP06969_Distribute..cs:849 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (actionState == CAppSetting.FlagD) | DATA_OP | dsSave.Tables[0].Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4e13fe6 | (진입점 미연결) | FP06969_Distribute..cs:856 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | UI_PROP | dtResult.TableName | "res" | 속성 TableName 설정 |  |  |  |
| AC-1b1e020d | (진입점 미연결) | FP06969_Distribute..cs:857 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Columns.SafeAdd | ("Result", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24e256e0 | (진입점 미연결) | FP06969_Distribute..cs:858 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Columns.SafeAdd | ("CNT", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4eea62e9 | (진입점 미연결) | FP06969_Distribute..cs:860 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dsResult.Tables.Add | (dtResult) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3bf2d69 | (진입점 미연결) | FP06969_Distribute..cs:879 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (dsSave.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "save_item_setup_group", dsSave, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] \| FP\Mas… | 엔드포인트 호출 |  |  |  |
| AC-3ea4b335 | (진입점 미연결) | FP06969_Distribute..cs:888 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (dsDelete.Good()) | ENDPOINT | DataService.FP_PseudoBatch | ("FP00460_SetupGroup", "delete_item_setup_group", dsDelete, 0, "Master") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] \| FP\M… | 엔드포인트 호출 |  |  |  |
| AC-eea172ec | (진입점 미연결) | FP06969_Distribute..cs:895 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e300703 | (진입점 미연결) | FP06969_Distribute..cs:898 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (success_cnt > 0) | DATA_OP | resRow["Result"] | "SUCCESS" | 행/컬럼 값 대입 |  |  |  |
| AC-790b6dc0 | (진입점 미연결) | FP06969_Distribute..cs:899 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ if (success_cnt > 0) | DATA_OP | resRow["CNT"] | success_cnt | 행/컬럼 값 대입 |  |  |  |
| AC-4e30f922 | (진입점 미연결) | FP06969_Distribute..cs:903 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ else of (success_cnt > 0) | DATA_OP | resRow["Result"] | "FAIL" | 행/컬럼 값 대입 |  |  |  |
| AC-9d9c6e84 | (진입점 미연결) | FP06969_Distribute..cs:904 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) ▸ else of (success_cnt > 0) | DATA_OP | resRow["CNT"] | success_cnt | 행/컬럼 값 대입 |  |  |  |
| AC-22910932 | (진입점 미연결) | FP06969_Distribute..cs:906 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | DATA_OP | dtResult.Rows.Add | (resRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-11680488 | (진입점 미연결) | FP06969_Distribute..cs:908 | try ▸ if (dsDelete.Good() \|\| dsSave.Good()) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-91c9d3f8 | (진입점 미연결) | FP06969_Distribute..cs:912 | try ▸ else of (dsDelete.Good() \|\| dsSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6023d3c3 | (진입점 미연결) | FP06969_Distribute..cs:918 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.Save_Main

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2b46502 | (진입점 미연결) | FP06969_Distribute..cs:726 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9d983621 | (진입점 미연결) | FP06969_Distribute..cs:728 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d748bfd0 | (진입점 미연결) | FP06969_Distribute..cs:733 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d804b09 | (진입점 미연결) | FP06969_Distribute..cs:734 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-555aea0c | (진입점 미연결) | FP06969_Distribute..cs:737 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-29363e61 | (진입점 미연결) | FP06969_Distribute..cs:746 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("COMPANY_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-c8e0c037 | (진입점 미연결) | FP06969_Distribute..cs:747 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("DIVISION_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-c7f1d141 | (진입점 미연결) | FP06969_Distribute..cs:748 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetValue | (i, siMain.GetColumnIndex("SITE_ID"), "-") | 그리드 값 설정 |  |  |  |
| AC-fb52974b | (진입점 미연결) | FP06969_Distribute..cs:750 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-54e09bd5 | (진입점 미연결) | FP06969_Distribute..cs:752 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aea64d58 | (진입점 미연결) | FP06969_Distribute..cs:753 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b467e2a | (진입점 미연결) | FP06969_Distribute..cs:758 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-06d254be | (진입점 미연결) | FP06969_Distribute..cs:763 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18dd1fa2 | (진입점 미연결) | FP06969_Distribute..cs:772 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-994cdf20 | (진입점 미연결) | FP06969_Distribute..cs:776 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7c2ec23c | (진입점 미연결) | FP06969_Distribute..cs:780 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-241ab923 | (진입점 미연결) | FP06969_Distribute..cs:781 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ece715f6 | (진입점 미연결) | FP06969_Distribute..cs:786 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c3a3248 | (진입점 미연결) | FP06969_Distribute..cs:787 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP06969_Distribute.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e387aeb6 | SaveButton | FP06969_Distribute..cs:377 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2e8b8b5 | this.spdMain.CellClick | FP06969_Distribute..cs:1144 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (isdir=="Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f1c9fb2 | this.spdMain.CellClick | FP06969_Distribute..cs:1174 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | VALUE_SET | download.Text | download_message | 컨트롤 값 설정 |  |  |  |
| AC-301e36fc | this.spdMain.CellClick | FP06969_Distribute..cs:1175 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | UI_PROP | download.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-3e99baad | this.spdMain.CellClick | FP06969_Distribute..cs:1177 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | DATA_OP | m.MenuItems.Add | (download) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d08e7eb | this.spdMain.CellClick | FP06969_Distribute..cs:1181 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | VALUE_SET | upload.Text | upload_message | 컨트롤 값 설정 |  |  |  |
| AC-df755e56 | this.spdMain.CellClick | FP06969_Distribute..cs:1182 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | UI_PROP | upload.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-1c3fd309 | this.spdMain.CellClick | FP06969_Distribute..cs:1184 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | DATA_OP | m.MenuItems.Add | (upload) | 데이터 객체 조작/조회 |  |  |  |
| AC-d91659da | this.spdMain.CellClick | FP06969_Distribute..cs:1190 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |
| AC-6dfac044 | this.spdMain.CellClick | FP06969_Distribute..cs:1193 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b81ecfe4 | this.spdMain.CellDoubleClick | FP06969_Distribute..cs:1200 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-3f8348bb | this.spdMain.CellDoubleClick | FP06969_Distribute..cs:1201 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-636295c1 | this.spdMain.CellDoubleClick | FP06969_Distribute..cs:1277 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP06969_Distribute.tvTri_NodeMouseClick

진입점: this.tvTri.NodeMouseClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4120b5e | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1550 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | VALUE_SET | download.Text | "Download" | 컨트롤 값 설정 |  |  |  |
| AC-0ec76406 | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1551 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | UI_PROP | download.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-01a75ddf | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1553 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | DATA_OP | m.MenuItems.Add | (download) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1acaa0b | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1557 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | VALUE_SET | upload.Text | "Upload" | 컨트롤 값 설정 |  |  |  |
| AC-6c4ac822 | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1558 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | UI_PROP | upload.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-83181d15 | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1560 | if (e.Button == MouseButtons.Right) ▸ if (row != null) | DATA_OP | m.MenuItems.Add | (upload) | 데이터 객체 조작/조회 |  |  |  |
| AC-eed0cb7e | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1566 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (tvTri, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |
| AC-906cb479 | this.tvTri.NodeMouseClick | FP06969_Distribute..cs:1569 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP06969_Distribute.UIFindData

진입점: this.btnDownload.Click / this.btnUpload.Click / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cad13e5 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:417 |  | CALL_EXT | Directory.Exists | (txtBase.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71deb008 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:419 | if (!Directory.Exists(txtBase.Text)) | MESSAGE | MessageBox.Show | ("Please select valid base directory first") | 메시지 표시 |  |  |  |
| AC-c6c5cb88 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:420 | if (!Directory.Exists(txtBase.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53eb9e12 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:422 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-648c1e68 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:427 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d84efb6e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:428 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-667ccc30 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:431 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d72554c1 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:434 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28179800 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:437 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2fffc131 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:437 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-937190f6 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:443 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28aecf09 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:446 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a70d145 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:452 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-733dc4fa | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:453 | try | FLAG | fileDataset | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Main("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-add1a5e9 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:453 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f393eea | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:463 | try ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.SafeAdd | ("path", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2672ec6e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:464 | try ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.SafeAdd | ("cmd", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d15abfe | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:465 | try ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.SafeAdd | ("hash2", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-afd41a11 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:466 | try ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.SafeAdd | ("status", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-df3a9b35 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:467 | try ▸ if (ds.Good()) | DATA_OP | ds.Tables[0].Columns.SafeAdd | ("CHK", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-74b92911 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:468 | try ▸ if (ds.Good()) | CALL_EXT | Path.Combine | (txtBase.Text,domain) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd477738 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:472 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) | CALL_EXT | row["parentid"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-69606758 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:477 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) ▸ lambda | CALL_EXT | each_row.Field<string>("nodeid").SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ee7c618 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:477 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) ▸ lambda | DATA_OP | each_row.Field | ("nodeid") | 데이터 객체 조작/조회 |  |  |  |
| AC-488d90bd | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:484 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) ▸ if (result.Count() > 0) ▸ while (p!=null) | CALL_EXT | p["parentid"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd3479e7 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:489 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) ▸ if (result.Count() > 0) ▸ while (p!=null) ▸ if (pinde… | CALL_EXT | each_row.Field<string>("nodeid").SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc58b47f | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:489 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) ▸ if (result.Count() > 0) ▸ while (p!=null) ▸ if (pinde… | DATA_OP | each_row.Field | ("nodeid") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce6a3219 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:497 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (pindex >= 0) | DATA_OP | row["PATH"] | path_string | 행/컬럼 값 대입 |  |  |  |
| AC-aa66691e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:507 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") | CALL_EXT | File.Exists | (localfile) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aea9e778 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:511 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) | DATA_OP | row["hash2"] | hash2 | 행/컬럼 값 대입 |  |  |  |
| AC-75b8928e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:515 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) ▸ if (hash == hash2) | DATA_OP | row["status"] | "same" | 행/컬럼 값 대입 |  |  |  |
| AC-5d16ef73 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:519 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) ▸ else of (hash == ha… | DATA_OP | row["CHK"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-b269a789 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:525 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) ▸ else of (hash == ha… | DATA_OP | row["status"] | "server newer" | 행/컬럼 값 대입 |  |  |  |
| AC-715af905 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:527 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) ▸ else of (hash == ha… | DATA_OP | row["status"] | "server older" | 행/컬럼 값 대입 |  |  |  |
| AC-1ac11160 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:530 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ if (File.Exists(localfile)) ▸ else of (hash == ha… | DATA_OP | row["status"] | "diff" | 행/컬럼 값 대입 |  |  |  |
| AC-fa09bcc5 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:535 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (isfolder == "N") ▸ else of (File.Exists(localfile)) | DATA_OP | row["status"] | "not found" | 행/컬럼 값 대입 |  |  |  |
| AC-123805bc | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:540 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ else of (isfolder == "N") | CALL_EXT | Directory.Exists | (localfile) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d57d2059 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:542 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ else of (isfolder == "N") ▸ if (Directory.Exists(localfile)) | DATA_OP | row["status"] | "folder" | 행/컬럼 값 대입 |  |  |  |
| AC-d9686fe1 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:546 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ else of (isfolder == "N") ▸ else of (Directory.Exists(localfile)) | DATA_OP | row["status"] | "folder N/A" | 행/컬럼 값 대입 |  |  |  |
| AC-3b96f4d0 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:554 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (locA.HasValue) | DATA_OP | row["update_time"] | locA.Value.AddHours(9) | 행/컬럼 값 대입 |  |  |  |
| AC-eecf96b4 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:554 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (locA.HasValue) | CALL_EXT | locA.Value.AddHours | (9) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bcf4bb9a | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:556 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (locB.HasValue) | DATA_OP | row["creation"] | locA.Value.AddHours(9) | 행/컬럼 값 대입 |  |  |  |
| AC-dd92d566 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:556 | try ▸ if (ds.Good()) ▸ foreach (DataRow row in ds.Tables[0].Rows) ▸ if (locB.HasValue) | CALL_EXT | locA.Value.AddHours | (9) | ⚠ 의미 확인 필요 |  |  |  |
| AC-341bf70d | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:562 | try | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, ds, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-2860a534 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:563 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-25669a59 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:566 | try ▸ if (ds.Good()) | UI_PROP | tvTri.HideCheckBox | false | 속성 HideCheckBox 설정 |  |  |  |
| AC-6d7ff684 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:567 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataName | "shortname" | 속성 UIDataName 설정 |  |  |  |
| AC-dc4f875f | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:568 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataID | "nodeid" | 속성 UIDataID 설정 |  |  |  |
| AC-3d77e74a | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:569 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataOrder | "nameorder" | 속성 UIDataOrder 설정 |  |  |  |
| AC-703cd207 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:570 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UILevel | "level" | 속성 UILevel 설정 |  |  |  |
| AC-27887515 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:571 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataImg | "img" | 속성 UIDataImg 설정 |  |  |  |
| AC-eeebc0d8 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:572 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataParentID | "parentid" | 속성 UIDataParentID 설정 |  |  |  |
| AC-db17c048 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:574 | try ▸ if (ds.Good()) | UI_PROP | tvTri.UIDataSource | ds.Tables[0] | 속성 UIDataSource 설정 |  |  |  |
| AC-3d14c2c0 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:577 | try | GRID_SET | spdMain.ActiveSheet.Columns["CHK"].Width | 40 | 그리드 속성/값 설정 |  |  |  |
| AC-da0a06fe | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:578 | try | GRID_SET | spdMain.ActiveSheet.Columns["shortname"].Width | 200 | 그리드 속성/값 설정 |  |  |  |
| AC-8603ab1e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:579 | try | GRID_SET | spdMain.ActiveSheet.Columns["longname"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-535de3bc | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:580 | try | GRID_SET | spdMain.ActiveSheet.Columns["creation"].Width | 160 | 그리드 속성/값 설정 |  |  |  |
| AC-7e65f551 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:581 | try | GRID_SET | spdMain.ActiveSheet.Columns["hash"].Width | 3 | 그리드 속성/값 설정 |  |  |  |
| AC-5144a139 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:582 | try | GRID_SET | spdMain.ActiveSheet.Columns["hash2"].Width | 3 | 그리드 속성/값 설정 |  |  |  |
| AC-47247cf6 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:583 | try | GRID_SET | spdMain.ActiveSheet.Columns["status"].Width | 40 | 그리드 속성/값 설정 |  |  |  |
| AC-2f17d0d8 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:584 | try | GRID_SET | spdMain.ActiveSheet.Columns["PATH"].Width | 300 | 그리드 속성/값 설정 |  |  |  |
| AC-bc92ec4a | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:585 | try | GRID_SET | spdMain.ActiveSheet.Columns["CMD"].Width | 100 | 그리드 속성/값 설정 |  |  |  |
| AC-816c7592 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:588 | try | GRID_SET | spdMain.ActiveSheet.Columns["CHK"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-82ddd891 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:589 | try | GRID_SET | spdMain.ActiveSheet.Columns["shortname"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-7e82c45d | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:590 | try | GRID_SET | spdMain.ActiveSheet.Columns["longname"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-ed7d85a0 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:591 | try | GRID_SET | spdMain.ActiveSheet.Columns["creation"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-cfeb8076 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:592 | try | GRID_SET | spdMain.ActiveSheet.Columns["hash"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-27d41e5b | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:593 | try | GRID_SET | spdMain.ActiveSheet.Columns["hash2"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-75caee54 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:594 | try | GRID_SET | spdMain.ActiveSheet.Columns["status"].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-4a97d653 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:597 | try | GRID_SET | spdMain.ActiveSheet.Columns["parentid"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-d79f2d98 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:598 | try | GRID_SET | spdMain.ActiveSheet.Columns["nodeid"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bc7263ee | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:599 | try | GRID_SET | spdMain.ActiveSheet.Columns["nameorder"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-aad14e3c | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:600 | try | GRID_SET | spdMain.ActiveSheet.Columns["level"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dc6ba356 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:601 | try | GRID_SET | spdMain.ActiveSheet.Columns["img"].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-82be5c7f | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:603 | try | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bf18a750 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:617 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ if (isfolder == "Y") ▸ switch (status) case "folder": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-c7f48adf | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:620 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ if (isfolder == "Y") ▸ switch (status) default: | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightGoldenrodYellow) | 그리드 표시 설정 |  |  |  |
| AC-d3b3a7b9 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:629 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) case "found": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-1346288d | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:632 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) case "same": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-83e0f42e | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:635 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) case "not found": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightCoral) | 그리드 표시 설정 |  |  |  |
| AC-ba8d0b99 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:638 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) case "server older": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightYellow) | 그리드 표시 설정 |  |  |  |
| AC-3da8577c | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:641 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) case "server newer": | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightBlue) | 그리드 표시 설정 |  |  |  |
| AC-cf853078 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:644 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (r!=null) ▸ else of (isfolder == "Y") ▸ switch (status) default: | GRID_STYLE | siMain.SetBGColor2 | (i, 0, i, siMain.GetMaxColumnIndex(), Color.LightCoral) | 그리드 표시 설정 |  |  |  |
| AC-3206f7d5 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:653 | try | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d3ad6005 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:660 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c69dad4a | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:661 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b28dcfa2 | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:662 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f0bb6bfe | this.btnDownload.Click 외 3 | FP06969_Distribute..cs:662 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

