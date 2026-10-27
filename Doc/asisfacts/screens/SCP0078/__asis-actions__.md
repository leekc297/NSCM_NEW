# AS-IS 액션 대조표 — SCP0078

> 원천: `Doc/asisfacts/screens/SCP0078/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 991행 · 메서드 124 · 종류 RETURN 175 · DATA_OP 172 · GRID_LOCK 149 · CALL_EXT 118 · MESSAGE 78 · UI_PROP 62 · GRID_INIT 52 · GRID_SET 35 · ENDPOINT 34 · UI_MISC 32 · FLAG 29 · POPUP 27 · LIST_REBIND 7 · VALUE_SET 6 · THROW 5 · GRID_BIND 3 · COMBO_DATA 3 · VALIDATE 3 · CALL_BASE 1 · ⚠ 의미 확인 필요 119


## FileParameter..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b881008e | .ctor | SCP0078_FileUpload.cs:1550 |  | FLAG | File | file | 화면 필드/플래그 변경 |  |  |  |
| AC-73428d7a | .ctor | SCP0078_FileUpload.cs:1551 |  | FLAG | FileName | filename | 화면 필드/플래그 변경 |  |  |  |
| AC-fe588c94 | .ctor | SCP0078_FileUpload.cs:1552 |  | FLAG | ContentType | contenttype | 화면 필드/플래그 변경 |  |  |  |

## FormUpload.GetMultipartFormData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb5e390e | (진입점 미연결) | SCP0078_FileUpload.cs:1498 | foreach (var param in postParameters) ▸ if (needsCLRF) | CALL_EXT | formDataStream.Write | (encoding.GetBytes("\r\n"), offset, encoding.GetByteCount("\r\n")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0687b726 | (진입점 미연결) | SCP0078_FileUpload.cs:1498 | foreach (var param in postParameters) ▸ if (needsCLRF) | CALL_EXT | encoding.GetBytes | ("\r\n") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c9c45535 | (진입점 미연결) | SCP0078_FileUpload.cs:1498 | foreach (var param in postParameters) ▸ if (needsCLRF) | CALL_EXT | encoding.GetByteCount | ("\r\n") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c621a75 | (진입점 미연결) | SCP0078_FileUpload.cs:1513 | foreach (var param in postParameters) ▸ if (param.Value is FileParameter) | CALL_EXT | formDataStream.Write | (encoding.GetBytes(header), offset, encoding.GetByteCount(header)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b19c0c3e | (진입점 미연결) | SCP0078_FileUpload.cs:1513 | foreach (var param in postParameters) ▸ if (param.Value is FileParameter) | CALL_EXT | encoding.GetBytes | (header) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a9e876a | (진입점 미연결) | SCP0078_FileUpload.cs:1513 | foreach (var param in postParameters) ▸ if (param.Value is FileParameter) | CALL_EXT | encoding.GetByteCount | (header) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fd788d9 | (진입점 미연결) | SCP0078_FileUpload.cs:1516 | foreach (var param in postParameters) ▸ if (param.Value is FileParameter) | CALL_EXT | formDataStream.Write | (fileToUpload.File, offset, fileToUpload.File.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85a481cc | (진입점 미연결) | SCP0078_FileUpload.cs:1524 | foreach (var param in postParameters) ▸ else of (param.Value is FileParameter) | CALL_EXT | formDataStream.Write | (encoding.GetBytes(postData), offset, encoding.GetByteCount(postData)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e5f8323 | (진입점 미연결) | SCP0078_FileUpload.cs:1524 | foreach (var param in postParameters) ▸ else of (param.Value is FileParameter) | CALL_EXT | encoding.GetBytes | (postData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6f6a0e5 | (진입점 미연결) | SCP0078_FileUpload.cs:1524 | foreach (var param in postParameters) ▸ else of (param.Value is FileParameter) | CALL_EXT | encoding.GetByteCount | (postData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bceafcf | (진입점 미연결) | SCP0078_FileUpload.cs:1530 |  | CALL_EXT | formDataStream.Write | (encoding.GetBytes(footer), offset, encoding.GetByteCount(footer)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4c1051b | (진입점 미연결) | SCP0078_FileUpload.cs:1530 |  | CALL_EXT | encoding.GetBytes | (footer) | ⚠ 의미 확인 필요 |  |  |  |
| AC-183eb814 | (진입점 미연결) | SCP0078_FileUpload.cs:1530 |  | CALL_EXT | encoding.GetByteCount | (footer) | ⚠ 의미 확인 필요 |  |  |  |
| AC-165c5658 | (진입점 미연결) | SCP0078_FileUpload.cs:1533 |  | UI_PROP | formDataStream.Position | 0 | 속성 Position 설정 |  |  |  |
| AC-40b09cf1 | (진입점 미연결) | SCP0078_FileUpload.cs:1535 |  | CALL_EXT | formDataStream.Read | (formData, offset, formData.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-536998df | (진입점 미연결) | SCP0078_FileUpload.cs:1536 |  | UI_MISC | formDataStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-361ad649 | (진입점 미연결) | SCP0078_FileUpload.cs:1538 |  | RETURN | return formData; |  | 처리 중단/반환 |  |  |  |

## FormUpload.MultipartFormDataPost

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65539a72 | (진입점 미연결) | SCP0078_FileUpload.cs:1443 |  | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac8b3b4e | (진입점 미연결) | SCP0078_FileUpload.cs:1448 |  | RETURN | return PostForm(postUrl, userAgent, contentType, formData); |  | 처리 중단/반환 |  |  |  |

## FormUpload.PostForm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70e88ba7 | (진입점 미연결) | SCP0078_FileUpload.cs:1452 |  | CALL_EXT | WebRequest.Create | (postUrl) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d5e4db0 | (진입점 미연결) | SCP0078_FileUpload.cs:1457 | try ▸ if (request == null) | THROW | throw new NullReferenceException("request is not a http request"); |  | 예외 발생 |  |  |  |
| AC-43bab775 | (진입점 미연결) | SCP0078_FileUpload.cs:1461 | try | UI_PROP | request.Method | "POST" | 속성 Method 설정 |  |  |  |
| AC-357c9b9f | (진입점 미연결) | SCP0078_FileUpload.cs:1462 | try | UI_PROP | request.ContentType | contentType | 속성 ContentType 설정 |  |  |  |
| AC-4cf3667a | (진입점 미연결) | SCP0078_FileUpload.cs:1463 | try | UI_PROP | request.UserAgent | userAgent | 속성 UserAgent 설정 |  |  |  |
| AC-966d0799 | (진입점 미연결) | SCP0078_FileUpload.cs:1464 | try | UI_PROP | request.CookieContainer | new CookieContainer() | 속성 CookieContainer 설정 |  |  |  |
| AC-c0438d4d | (진입점 미연결) | SCP0078_FileUpload.cs:1465 | try | UI_PROP | request.ContentLength | formData.Length | 속성 ContentLength 설정 |  |  |  |
| AC-8389547d | (진입점 미연결) | SCP0078_FileUpload.cs:1473 | try | CALL_EXT | request.GetRequestStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce2eb56a | (진입점 미연결) | SCP0078_FileUpload.cs:1475 | try | CALL_EXT | requestStream.Write | (formData, offset, formData.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8b79ab8 | (진입점 미연결) | SCP0078_FileUpload.cs:1476 | try | UI_MISC | requestStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-cc764b7c | (진입점 미연결) | SCP0078_FileUpload.cs:1478 | try | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d435ee08 | (진입점 미연결) | SCP0078_FileUpload.cs:1485 |  | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e18b8c5 | (진입점 미연결) | SCP0078_FileUpload.cs:1485 |  | RETURN | return request.GetResponse() as HttpWebResponse; |  | 처리 중단/반환 |  |  |  |

## RequestHelper.PostMultipart

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-553faa31 | (진입점 미연결) | SCP0078_FileUpload.cs:1369 |  | CALL_EXT | System.Text.Encoding.ASCII.GetBytes | ("\r\n--" + boundary + "\r\n") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9129fcc | (진입점 미연결) | SCP0078_FileUpload.cs:1371 |  | CALL_EXT | WebRequest.Create | (url) | ⚠ 의미 확인 필요 |  |  |  |
| AC-318fe9e3 | (진입점 미연결) | SCP0078_FileUpload.cs:1372 |  | UI_PROP | request.ContentType | "multipart/form-data; boundary=" + boundary | 속성 ContentType 설정 |  |  |  |
| AC-53bcdce3 | (진입점 미연결) | SCP0078_FileUpload.cs:1373 |  | UI_PROP | request.Method | "POST" | 속성 Method 설정 |  |  |  |
| AC-f4321c24 | (진입점 미연결) | SCP0078_FileUpload.cs:1374 |  | UI_PROP | request.KeepAlive | true | 속성 KeepAlive 설정 |  |  |  |
| AC-e47a9ab0 | (진입점 미연결) | SCP0078_FileUpload.cs:1375 |  | UI_PROP | request.Credentials | System.Net.CredentialCache.DefaultCredentials | 속성 Credentials 설정 |  |  |  |
| AC-c431e4d2 | (진입점 미연결) | SCP0078_FileUpload.cs:1380 | if (parameters != null && parameters.Count > 0) | CALL_EXT | request.GetRequestStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7606d0a | (진입점 미연결) | SCP0078_FileUpload.cs:1386 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) | CALL_EXT | requestStream.Write | (boundaryBytes, 0, boundaryBytes.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c568ff26 | (진입점 미연결) | SCP0078_FileUpload.cs:1391 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) | CALL_EXT | System.Text.Encoding.UTF8.GetBytes | (header) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a2abf73 | (진입점 미연결) | SCP0078_FileUpload.cs:1392 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) | CALL_EXT | requestStream.Write | (bytes, 0, bytes.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5717d1c | (진입점 미연결) | SCP0078_FileUpload.cs:1398 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | CALL_EXT | File.OpenRead | (file.FilePath) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8dfbf2ed | (진입점 미연결) | SCP0078_FileUpload.cs:1400 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | CALL_EXT | fileStream.Read | (buffer, 0, buffer.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d7a29e6 | (진입점 미연결) | SCP0078_FileUpload.cs:1401 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | CALL_EXT | requestStream.Write | (buffer, 0, bytesRead) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9000e42e | (진입점 미연결) | SCP0078_FileUpload.cs:1402 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | UI_MISC | fileStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-30d0cff5 | (진입점 미연결) | SCP0078_FileUpload.cs:1408 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | CALL_EXT | file.Stream.Read | (buffer, 0, buffer.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-706ff7d9 | (진입점 미연결) | SCP0078_FileUpload.cs:1409 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ if (pair.Value is FormFile) ▸ … | CALL_EXT | requestStream.Write | (buffer, 0, bytesRead) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6570570c | (진입점 미연결) | SCP0078_FileUpload.cs:1415 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ else of (pair.Value is FormFil… | CALL_EXT | System.Text.Encoding.UTF8.GetBytes | (data) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0d29a08 | (진입점 미연결) | SCP0078_FileUpload.cs:1416 | if (parameters != null && parameters.Count > 0) ▸ foreach (KeyValuePair<string, object> pair in parameters) ▸ else of (pair.Value is FormFil… | CALL_EXT | requestStream.Write | (bytes, 0, bytes.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-269149f0 | (진입점 미연결) | SCP0078_FileUpload.cs:1420 | if (parameters != null && parameters.Count > 0) | CALL_EXT | System.Text.Encoding.ASCII.GetBytes | ("\r\n--" + boundary + "--\r\n") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa84df43 | (진입점 미연결) | SCP0078_FileUpload.cs:1421 | if (parameters != null && parameters.Count > 0) | CALL_EXT | requestStream.Write | (trailer, 0, trailer.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec25f649 | (진입점 미연결) | SCP0078_FileUpload.cs:1422 | if (parameters != null && parameters.Count > 0) | UI_MISC | requestStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-e96e18df | (진입점 미연결) | SCP0078_FileUpload.cs:1426 |  | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0541a8b | (진입점 미연결) | SCP0078_FileUpload.cs:1428 |  | CALL_EXT | response.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4577670d | (진입점 미연결) | SCP0078_FileUpload.cs:1430 |  | CALL_EXT | reader.ReadToEnd | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-492c846f | (진입점 미연결) | SCP0078_FileUpload.cs:1430 |  | RETURN | return reader.ReadToEnd(); |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.BtnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f396b3c2 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0078_FileUpload.cs:1249 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_FileUpload.CallFileDownload

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dc096aa | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:674 | try | POPUP | new FolderBrowserDialog | () | 팝업/폼 생성 |  |  |  |
| AC-e7d4bc68 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:675 | try | POPUP | fbd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d5e8b74e | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:677 | try ▸ if (fbd.ShowDialog() == DialogResult.OK) | FLAG | dirPath | fbd.SelectedPath | 화면 필드/플래그 변경 |  |  |  |
| AC-d2c78422 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:678 | try ▸ if (fbd.ShowDialog() == DialogResult.OK) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-46f5f1a7 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:679 | try ▸ if (fbd.ShowDialog() == DialogResult.OK) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-70a7d12f | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:683 | try ▸ if (fbd.ShowDialog() == DialogResult.OK) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9151bb03 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:688 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0078_FileUpload.CallFileList

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Coun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdfea500 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:460 | try ▸ else of (isTest) | CALL_EXT | WebRequest.Create | (webUrl) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c51472ea | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:462 | try ▸ else of (isTest) | UI_PROP | request.Credentials | CredentialCache.DefaultCredentials | 속성 Credentials 설정 |  |  |  |
| AC-ce9b1c50 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:463 | try ▸ else of (isTest) | UI_PROP | request.Method | "POST" | 속성 Method 설정 |  |  |  |
| AC-b4f055c4 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:465 | try ▸ else of (isTest) | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eead5642 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:467 | try ▸ else of (isTest) | CALL_EXT | response.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-beb3a1e1 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:470 | try ▸ else of (isTest) | CALL_EXT | reader.ReadToEnd | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-60081973 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:473 | try ▸ else of (isTest) | UI_MISC | response.Close | () | 창 닫기/해제 |  |  |  |
| AC-3fe95d1d | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:478 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-e74ea864 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:480 |  | RETURN | return json; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.CallFileUpload

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.btnOpen.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-feaca197 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:492 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-644ba8b7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:496 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-8e2557c3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:498 | try | POPUP | ofd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7691690f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:505 | try ▸ if (dr == DialogResult.OK) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-b88f490a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:519 | try ▸ if (dr == DialogResult.OK) | CALL_EXT | httpClient.DefaultRequestHeaders.TryAddWithoutValidation | ("Content-Type", "multipart/form-data; charset=utf-8") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b584b6d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:521 | try ▸ if (dr == DialogResult.OK) | POPUP | new MultipartFormDataContent | () | 팝업/폼 생성 |  |  |  |
| AC-97a210bf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:523 | try ▸ if (dr == DialogResult.OK) | CALL_EXT | File.ReadAllBytes | (fileFullPath) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8c9b1d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:528 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileSize(content.Length) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00390") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de5803f7 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:529 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileSize(content.Length) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7d00527 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:535 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileExtenExtension(fileName) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00391") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd24f5cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:536 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileExtenExtension(fileName) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-892c5fad | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:542 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileMaxCount(5, 1) == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00392") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28d3da0b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:543 | try ▸ if (dr == DialogResult.OK) ▸ if (CheckFileMaxCount(5, 1) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dff6211 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:547 | try ▸ if (dr == DialogResult.OK) | UI_PROP | byteContent.Headers.ContentType | new System.Net.Http.Headers.MediaTypeHeaderValue("*/*") | 속성 ContentType 설정 |  |  |  |
| AC-ff29747e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:548 | try ▸ if (dr == DialogResult.OK) | DATA_OP | multipartFormContent.Add | (byteContent, name: "file", fileName: fileName) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cd06536 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:549 | try ▸ if (dr == DialogResult.OK) | CALL_EXT | httpClient.PostAsync | (url, multipartFormContent) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b14292ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:550 | try ▸ if (dr == DialogResult.OK) | CALL_EXT | response.Content.ReadAsStringAsync | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbde0d5f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:553 | try ▸ if (dr == DialogResult.OK) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a8aeb6be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:559 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00388") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e65fc722 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:560 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd25ca8b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:566 | finally ▸ if (prg != null) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_FileUpload.CallFileUploadKor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f253cb46 | (진입점 미연결) | SCP0078_FileUpload.cs:642 | try | CALL_EXT | File.ReadAllBytes | (fileFullPath) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81e21396 | (진입점 미연결) | SCP0078_FileUpload.cs:645 | try | POPUP | new MultipartFormDataContent | () | 팝업/폼 생성 |  |  |  |
| AC-78ca3c2f | (진입점 미연결) | SCP0078_FileUpload.cs:646 | try | UI_PROP | form.Headers.ContentType | new System.Net.Http.Headers.MediaTypeHeaderValue("multipart/form-data") | 속성 ContentType 설정 |  |  |  |
| AC-f7c0d469 | (진입점 미연결) | SCP0078_FileUpload.cs:649 | try | DATA_OP | form.Add | (new StringContent(UserId), "userId") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1f13447 | (진입점 미연결) | SCP0078_FileUpload.cs:650 | try | DATA_OP | form.Add | (new ByteArrayContent(file_bytes, 0, file_bytes.Length), "file", fileName) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf0d69be | (진입점 미연결) | SCP0078_FileUpload.cs:651 | try | CALL_EXT | httpClient.PostAsync | (url_scpFileUpload, form) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d9fe7e8 | (진입점 미연결) | SCP0078_FileUpload.cs:652 | try | UI_MISC | httpClient.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-7891673f | (진입점 미연결) | SCP0078_FileUpload.cs:653 | try | CALL_EXT | response.Content.ReadAsStringAsync | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e5974c2 | (진입점 미연결) | SCP0078_FileUpload.cs:657 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0078_FileUpload.CallFileUploadKor2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8254cd2 | (진입점 미연결) | SCP0078_FileUpload.cs:614 | try | DATA_OP | data[0] | UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6eae66b5 | (진입점 미연결) | SCP0078_FileUpload.cs:615 | try | DATA_OP | data[1] | fileName | 행/컬럼 값 대입 |  |  |  |
| AC-39ca0ead | (진입점 미연결) | SCP0078_FileUpload.cs:617 | try | CALL_EXT | WebRequest.Create | (url) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e302af92 | (진입점 미연결) | SCP0078_FileUpload.cs:619 | try | CALL_EXT | UTF8Encoding.UTF8.GetBytes | (postData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e5f9e76 | (진입점 미연결) | SCP0078_FileUpload.cs:620 | try | UI_PROP | httpWebRequest.ContentType | "multipart/form-data; charset=UTF-8" | 속성 ContentType 설정 |  |  |  |
| AC-789caecf | (진입점 미연결) | SCP0078_FileUpload.cs:621 | try | UI_PROP | httpWebRequest.Method | "POST" | 속성 Method 설정 |  |  |  |
| AC-79c94aa9 | (진입점 미연결) | SCP0078_FileUpload.cs:622 | try | UI_PROP | httpWebRequest.ContentLength | sendData.Length | 속성 ContentLength 설정 |  |  |  |
| AC-936d1efc | (진입점 미연결) | SCP0078_FileUpload.cs:623 | try | CALL_EXT | httpWebRequest.GetRequestStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c95ed61d | (진입점 미연결) | SCP0078_FileUpload.cs:624 | try | CALL_EXT | requestStream.Write | (sendData, 0, sendData.Length) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4fef1c87 | (진입점 미연결) | SCP0078_FileUpload.cs:625 | try | UI_MISC | requestStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-9aa72299 | (진입점 미연결) | SCP0078_FileUpload.cs:626 | try | CALL_EXT | httpWebRequest.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-64be688c | (진입점 미연결) | SCP0078_FileUpload.cs:627 | try | CALL_EXT | httpWebResponse.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a876d2c | (진입점 미연결) | SCP0078_FileUpload.cs:627 | try | CALL_EXT | Encoding.GetEncoding | ("UTF-8") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c53b0694 | (진입점 미연결) | SCP0078_FileUpload.cs:628 | try | CALL_EXT | streamReader.ReadToEnd | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4c2f67f | (진입점 미연결) | SCP0078_FileUpload.cs:629 | try | UI_MISC | streamReader.Close | () | 창 닫기/해제 |  |  |  |
| AC-1a17655c | (진입점 미연결) | SCP0078_FileUpload.cs:630 | try | UI_MISC | httpWebResponse.Close | () | 창 닫기/해제 |  |  |  |
| AC-4f31d1aa | (진입점 미연결) | SCP0078_FileUpload.cs:631 | try | CALL_EXT | Console.Write | ("returns: " + returns) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc16fdc9 | (진입점 미연결) | SCP0078_FileUpload.cs:635 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0078_FileUpload.CheckFileExtenExtension

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bfcb260 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:871 | try | DATA_OP | fileExtList.Contains | (fileExt) | 데이터 객체 조작/조회 |  |  |  |
| AC-c57cf70a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:879 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.CheckFileMaxCount

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8f9f49 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:924 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.CheckFileSize

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-899ba840 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:856 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.checkHasOtherLetter

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db88d170 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:940 | try | CALL_EXT | value.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ee2a25c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:943 | try ▸ foreach (char c in charArr) | CALL_EXT | char.GetUnicodeCategory | (c) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0870506 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:952 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.ConvertDataSet

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0) ▸ try] / this.btnButtonList.UsrButtonList_Clic…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2759034b | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1130 | try | CALL_EXT | JsonConvert.DeserializeObject | (json) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4c4d8a5 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1131 | try | DATA_OP | myDataSet.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ecf77ea | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1136 |  | RETURN | return myDataSet; |  | 처리 중단/반환 |  |  |  |
| AC-4a8eace1 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1143 | try | DATA_OP | myDataSet.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-031ccd5c | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1148 |  | RETURN | return myDataSet; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.convertDBFileName

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName))] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1915c4d2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:1005 |  | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.convertHasOtherLetter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d814eea3 | (진입점 미연결) | SCP0078_FileUpload.cs:962 | try | CALL_EXT | value.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-31eae918 | (진입점 미연결) | SCP0078_FileUpload.cs:967 | try ▸ foreach (char c in charArr) | CALL_EXT | char.GetUnicodeCategory | (c) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf3990fc | (진입점 미연결) | SCP0078_FileUpload.cs:972 | try ▸ foreach (char c in charArr) | DATA_OP | returnArr[focus] | change | 행/컬럼 값 대입 |  |  |  |
| AC-9ac95e4d | (진입점 미연결) | SCP0078_FileUpload.cs:981 |  | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c7cf5cd | this.Load | SCP0078_FileUpload.cs:154 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e034500 | this.Load | SCP0078_FileUpload.cs:155 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d98e8494 | this.Load | SCP0078_FileUpload.cs:156 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0078_FileUpload.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0913540 | this.Load | SCP0078_FileUpload.cs:142 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-9dbca25c | this.Load | SCP0078_FileUpload.cs:146 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-246f0915 | this.Load | SCP0078_FileUpload.cs:147 |  | DATA_OP | list.Add | (ButtonListType.Find) | 데이터 객체 조작/조회 |  |  |  |
| AC-232a1917 | this.Load | SCP0078_FileUpload.cs:149 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0078_FileUpload.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-896b9ac0 | Dispose | SCP0078_FileUpload.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0078_FileUpload.DownFile

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (fbd.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48caa532 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:700 | try | CALL_EXT | System.Net.HttpWebRequest.Create | (urlAddress) | ⚠ 의미 확인 필요 |  |  |  |
| AC-26812918 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:701 | try | UI_PROP | request.Timeout | 30000 | 속성 Timeout 설정 |  |  |  |
| AC-44a03a9b | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:702 | try | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2ce93de1 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:714 | try | CALL_EXT | System.Web.HttpUtility.UrlDecode | (fileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca4aa227 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:720 | try | CALL_EXT | System.IO.Path.Combine | (dirPath, fileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fb241af | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:722 | try | CALL_EXT | response.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-521a1699 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:726 | try | CALL_EXT | s.Read | (buff, 0, 10400) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4576a38 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:728 | try ▸ while ((c = s.Read(buff, 0, 10400)) > 0) | CALL_EXT | os.Write | (buff, 0, c) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1277e519 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:729 | try ▸ while ((c = s.Read(buff, 0, 10400)) > 0) | CALL_EXT | os.Flush | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-25ef5549 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:731 | try | UI_MISC | os.Close | () | 창 닫기/해제 |  |  |  |
| AC-6a886c01 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:732 | try | UI_MISC | s.Close | () | 창 닫기/해제 |  |  |  |
| AC-9b4c0a71 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:736 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## SCP0078_FileUpload.EUCKR_TO_UTF8

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3256b31 | (진입점 미연결) | SCP0078_FileUpload.cs:1022 |  | CALL_EXT | Encoding.Convert | ( Encoding.GetEncoding("euc-kr"), Encoding.UTF8, Encoding.GetEncoding("euc-kr").GetBytes(s… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a04e3eb5 | (진입점 미연결) | SCP0078_FileUpload.cs:1023 |  | CALL_EXT | Encoding.GetEncoding | ("euc-kr") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3479233a | (진입점 미연결) | SCP0078_FileUpload.cs:1025 |  | CALL_EXT | Encoding.GetEncoding("euc-kr").GetBytes | (strEUCKR) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4226664b | (진입점 미연결) | SCP0078_FileUpload.cs:1025 |  | CALL_EXT | Encoding.GetEncoding | ("euc-kr") | ⚠ 의미 확인 필요 |  |  |  |
| AC-55692f96 | (진입점 미연결) | SCP0078_FileUpload.cs:1021 |  | RETURN | return Encoding.UTF8.GetString( Encoding.Convert( Encoding.GetEncoding("euc-kr")… |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.FindData

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)] / this.btnButtonList.UsrButtonList_Click_Detected […

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32f2e033 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:279 | try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ if (specialty == null \|\| specialty.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00386") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e84e0ef | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:280 | try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ if (specialty == null \|\| specialty.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5af929ac | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:288 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-49bc6c3b | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:289 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-76093d2e | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:303 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00387") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e69af85 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:304 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de1daddc | this.Load | SCP0078_FileUpload.cs:113 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f36eaded | this.Load | SCP0078_FileUpload.cs:126 |  | VALUE_SET | this.Text | string.Format("VOC NO = {0}", VOC_NO) | 컨트롤 값 설정 |  |  |  |
| AC-3cad1fdf | this.Load | SCP0078_FileUpload.cs:127 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0078_FileUpload.GetByteValue

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ try ▸ if (string.IsNullOrWhiteSpace(fileSeq) == false) ▸ try] / this.btnOpen.Click [try ▸ if (dr == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82fae219 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:1157 | try ▸ if (string.IsNullOrWhiteSpace(value) == false) | CALL_EXT | Encoding.Default.GetBytes | (value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6a6b77a | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:1162 |  | RETURN | return byteSize; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetCellValue

진입점: spdMain.CellDoubleClick [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-616ecbe9 | spdMain.CellDoubleClick [try] | SCP0078_FileUpload.cs:1087 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetCopyFileName

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (fbd.ShowDialog() == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18ca0995 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1095 | try | CALL_EXT | System.IO.Path.Combine | (dirPath, fileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e95983c | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1096 | try | CALL_EXT | File.Exists | (fullpath) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0319dafd | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1098 | try ▸ if (File.Exists(fullpath)) | CALL_EXT | fileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-01a540a5 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1107 | try ▸ if (File.Exists(fullpath)) ▸ while (bExist) | CALL_EXT | System.IO.Path.Combine | (dirPath, fileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ef775f4f | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1109 | try ▸ if (File.Exists(fullpath)) ▸ while (bExist) | CALL_EXT | System.IO.File.Exists | (pathCombine) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f36c317 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… | SCP0078_FileUpload.cs:1123 |  | RETURN | return fileName; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetFileExtenExtension

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName)) ▸ try] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f45ab190 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:896 |  | RETURN | return fileExt; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetFileMapping

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Row…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab2b1789 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:389 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_GET_GSCM_VOC_DATA") ⇒ SCP.SCP0078_GET_GSCM_VOC_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-3bbfb6c1 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:390 | try | DATA_OP | request.Parameters["p_voc_no"] | strVOC_NO | 행/컬럼 값 대입 |  |  |  |
| AC-fee83751 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:392 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a250a445 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:400 | try ▸ if (dsReturn != null && dsReturn.Tables[0].Rows.Count > 0) | FLAG | FILE_MAPPING | GetStringValue(dsReturn.Tables[0].Rows[0]["FILE_MAPPING"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd4fbb1d | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:403 | try ▸ if (dsReturn != null && dsReturn.Tables[0].Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(FILE_MAPPING) == false) | FLAG | dtFileNameMapping | GetFileNameMapping(FILE_MAPPING) | 화면 필드/플래그 변경 |  |  |  |

## SCP0078_FileUpload.GetFileNameMapping

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ try ▸ if (dsReturn != null && dsReturn.Tables[0].Rows.Count > 0) ▸ if (string.IsNullOrWhiteSpace(FILE_MAPPING) == false)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrW…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a624c5d8 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:419 | try | DATA_OP | tbl.Columns.Add | ("ROW") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c8b429a | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:420 | try | DATA_OP | tbl.Columns.Add | ("fileid") | 데이터 객체 조작/조회 |  |  |  |
| AC-aae49c8e | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:421 | try | DATA_OP | tbl.Columns.Add | ("fileRealName") | 데이터 객체 조작/조회 |  |  |  |
| AC-00465dec | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:429 | try ▸ foreach (string s in array) | DATA_OP | tbl.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fedfa15e | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:430 | try ▸ foreach (string s in array) | DATA_OP | row["ROW"] | i.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e413d41 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:432 | try ▸ foreach (string s in array) | DATA_OP | row["fileid"] | numb[0] | 행/컬럼 값 대입 |  |  |  |
| AC-3ac953f3 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:433 | try ▸ foreach (string s in array) | DATA_OP | row["fileRealName"] | numb[1] | 행/컬럼 값 대입 |  |  |  |
| AC-e2ee404c | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:435 | try ▸ foreach (string s in array) | DATA_OP | tbl.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-917c1d35 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:442 |  | RETURN | return tbl; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetJsonData

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (isTest)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0d6d956 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1073 |  | RETURN | return json; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetJsonValue

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ try] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6148d962 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:1215 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |
| AC-03a7f7f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:1231 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetNewGUID

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName)) ▸ try ▸ if (string.IsNullOrWhiteSpace(fileName) == false)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK) ▸ if (checkHasOtherLetter(fileName)) ▸ try ▸ if (string.IsNullOrWhiteSpace(fileName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4babf1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:1194 |  | CALL_EXT | Guid.NewGuid | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f83ccb5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:1194 |  | RETURN | return Guid.NewGuid().ToString(); |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetStringValue

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try ▸ if (dtAPI != null && dtAPI.Rows.Count > 0) ▸ foreach (DataRow row in dtAPI.Rows)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (fbd.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == Dialog…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff3f91ea | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try ▸ if (dt… 외 4 | SCP0078_FileUpload.cs:1036 |  | RETURN | return returnString; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.GetVocFileAPI

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-699ec73e | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try] | SCP0078_FileUpload.cs:1045 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-ac54e0ae | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try] | SCP0078_FileUpload.cs:1046 |  | DATA_OP | request.Parameters["p_lookup_type"] | "VOC_FILE_API" | 행/컬럼 값 대입 |  |  |  |
| AC-b9f901c8 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try] | SCP0078_FileUpload.cs:1047 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a480a6ea | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ try] | SCP0078_FileUpload.cs:1049 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83f514cd | this.Load | SCP0078_FileUpload.cs:163 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-b52fe821 | this.Load | SCP0078_FileUpload.cs:164 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-4e5f4132 | this.Load | SCP0078_FileUpload.cs:166 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a25383b3 | this.Load | SCP0078_FileUpload.cs:167 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d2d95f75 | this.Load | SCP0078_FileUpload.cs:168 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0078_FileUpload.MappingFileName

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Coun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0777bf6 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:323 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) | DATA_OP | mappingDT.Columns.Add | ("fileid") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d9e18e9 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:324 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) | DATA_OP | mappingDT.Columns.Add | ("fileRealName") | 데이터 객체 조작/조회 |  |  |  |
| AC-af777668 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:325 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) | DATA_OP | mappingDT.Columns.Add | ("fileSize") | 데이터 객체 조작/조회 |  |  |  |
| AC-6be0221b | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:326 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) | DATA_OP | mappingDT.Columns.Add | ("registerId") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b8a6bb7 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:332 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | mappingDT.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f9c917df | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:333 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | row2["fileid"] | row1["fileid"] | 행/컬럼 값 대입 |  |  |  |
| AC-a50f8294 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:334 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | row2["fileRealName"] | SearchFileNameMapping(dtFileNameMapping, row1["fileid"], row1["fileRealName"]) | 행/컬럼 값 대입 |  |  |  |
| AC-3f167f06 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:335 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | row2["fileSize"] | row1["fileSize"] | 행/컬럼 값 대입 |  |  |  |
| AC-0630a85b | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:336 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | row2["registerId"] | row1["registerId"] | 행/컬럼 값 대입 |  |  |  |
| AC-8e3282df | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:338 | try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows) | DATA_OP | mappingDT.Rows.Add | (row2) | 데이터 객체 조작/조회 |  |  |  |
| AC-71ee0620 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:346 |  | RETURN | return mappingDT; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.SearchFileNameMapping

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ else of (dtFileNameMapping == null \|\| dtFileNameMapping.Rows.Count == 0) ▸ foreach (DataRow row1 in dt.Rows)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (fbd.ShowDialog() == DialogResult.OK) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a1c6004 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:366 | try ▸ foreach (DataRow row in dt.Rows) ▸ if (GetStringValue(row["fileId"]) == skey) | RETURN | return searchValue; |  | 처리 중단/반환 |  |  |  |
| AC-eb1703c0 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:375 |  | RETURN | return searchValue; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.SetAPI

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aece1112 | this.Load [if (!string.IsNullOrEmpty(VOC_NO))] | SCP0078_FileUpload.cs:239 | try ▸ if (dtAPI != null && dtAPI.Rows.Count > 0) ▸ foreach (DataRow row in dtAPI.Rows) ▸ switch (code) case "scpFileUpload": | FLAG | url_scpFileUpload | url | 화면 필드/플래그 변경 |  |  |  |
| AC-982a48dd | this.Load [if (!string.IsNullOrEmpty(VOC_NO))] | SCP0078_FileUpload.cs:242 | try ▸ if (dtAPI != null && dtAPI.Rows.Count > 0) ▸ foreach (DataRow row in dtAPI.Rows) ▸ switch (code) case "scpFileDownload": | FLAG | url_scpFileDownload | url | 화면 필드/플래그 변경 |  |  |  |
| AC-96f5144e | this.Load [if (!string.IsNullOrEmpty(VOC_NO))] | SCP0078_FileUpload.cs:245 | try ▸ if (dtAPI != null && dtAPI.Rows.Count > 0) ▸ foreach (DataRow row in dtAPI.Rows) ▸ switch (code) case "scpFileList": | FLAG | url_scpFileList | url | 화면 필드/플래그 변경 |  |  |  |
| AC-3ac0bf16 | this.Load [if (!string.IsNullOrEmpty(VOC_NO))] | SCP0078_FileUpload.cs:248 | try ▸ if (dtAPI != null && dtAPI.Rows.Count > 0) ▸ foreach (DataRow row in dtAPI.Rows) ▸ switch (code) default: | FLAG | CallUrl | url | 화면 필드/플래그 변경 |  |  |  |

## SCP0078_FileUpload.SetSpreadColumn

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Count > …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfc36166 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:183 | for (iRow < siMain.ActiveSheet.RowCount) | UI_PROP | row.Height | 30 | 속성 Height 설정 |  |  |  |
| AC-0b1c08bb | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:192 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefColumns.FILE_NAME: | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |

## SCP0078_FileUpload.SetVOCFileList

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S")] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ try ▸ if (string.IsNullOrWhiteSpace(fileSeq) == false)] / this.bt…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06cc4359 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:805 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var request… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-debd919e | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:809 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_GET_GSCM_VOC_DATA") ⇒ SCP.SCP0078_GET_GSCM_VOC_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-cba66a1b | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:810 | try ▸ lambda | DATA_OP | request.Parameters["p_voc_no"] | voc_no | 행/컬럼 값 대입 |  |  |  |
| AC-15411b2c | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:812 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4072468d | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:814 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6a7ec721 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:821 | try ▸ if (ds != null && ds.Tables[0].Rows.Count > 0) | FLAG | FILE_LIST | Convert.ToString(ds.Tables[0].Rows[0]["FILE_UPLOAD"]) | 화면 필드/플래그 변경 |  |  |  |

## SCP0078_FileUpload.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e39fd079 | this.spdMain.CellClick | SCP0078_FileUpload.cs:1273 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-be2387da | this.spdMain.CellClick | SCP0078_FileUpload.cs:1274 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-11daafa6 | this.spdMain.CellClick | SCP0078_FileUpload.cs:1278 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-1a2f51a0 | this.spdMain.CellClick | SCP0078_FileUpload.cs:1279 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## SCP0078_FileUpload.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8178ec6 | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1291 | try ▸ if (this.siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b21fdde | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1309 | try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00393") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-805ce2fb | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1316 | try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59432756 | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1317 | try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49ed9ccb | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1327 | try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column… | MESSAGE | MessageHelper.GMessageBox | ("MSG00393") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-badcf4d3 | spdMain.CellDoubleClick | SCP0078_FileUpload.cs:1333 | try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column… | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_FileUpload.toDataTable

진입점: this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false) ▸ try ▸ if (string.IsNullOrWhiteSpace(FILE_LIST) == false)] / spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false) ▸ try ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try ▸ if (ds != null && ds.Tables[0].Rows.Coun…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84e97166 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1175 | foreach (var row in jArray) ▸ foreach (var jToken in row) ▸ if (result.Columns[jproperty.Name] == null) | DATA_OP | result.Columns.Add | (jproperty.Name, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79e30629 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1180 | foreach (var row in jArray) | DATA_OP | result.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6d9ace3 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1185 | foreach (var row in jArray) ▸ foreach (var jToken in row) | DATA_OP | datarow[jProperty.Name] | jProperty.Value.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5bc93da5 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1187 | foreach (var row in jArray) | DATA_OP | result.Rows.Add | (datarow) | 데이터 객체 조작/조회 |  |  |  |
| AC-98fca618 | this.Load [if (!string.IsNullOrEmpty(VOC_NO)) ▸ if (string.I… 외 4 | SCP0078_FileUpload.cs:1190 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.UpdateFileList

진입점: spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DOWN) \|\| e.Column == siMain.GetColumnIndex(DefColumns.FILE_NAME) \|\| e.…) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.FILE_DELETE)) ▸ if (string.IsNullOrWhiteSpace(FILE_SEQ) == false)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK) ▸ try ▸ if (string.IsNullOrWhiteSpace(fileSeq) == false)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK) ▸ try…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4203efc | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:750 | try ▸ if (string.IsNullOrWhiteSpace(fileSeq) \|\| string.IsNullOrWhiteSpace(p_active_flag)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edccbc8d | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:751 | try ▸ if (string.IsNullOrWhiteSpace(fileSeq) \|\| string.IsNullOrWhiteSpace(p_active_flag)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ac0f3be6 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:757 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_SAVE_GSCM_VOC_FILE") ⇒ SCP.SCP0078_SAVE_GSCM_VOC_FILE | 엔드포인트 요청 생성 |  |  |  |
| AC-b30840ee | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:759 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { request.Com… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-78328475 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:762 | try ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ee42c0dc | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:764 | try ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e7b2d384 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:765 | try ▸ lambda | DATA_OP | request.Parameters["p_voc_no"] | voc_no | 행/컬럼 값 대입 |  |  |  |
| AC-b9ef8fa2 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:766 | try ▸ lambda | DATA_OP | request.Parameters["p_file_seq"] | fileSeq | 행/컬럼 값 대입 |  |  |  |
| AC-98238498 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:767 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dee36e15 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:769 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55c1fae9 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:769 | try ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-ce3fb882 | spdMain.CellDoubleClick [try ▸ if (!String.IsNullOrEmpty(VOC… 외 2 | SCP0078_FileUpload.cs:787 | try ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0078_FileUpload.UploadFileResult

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ if (dr == DialogResult.OK)] / this.btnOpen.Click [try ▸ if (dr == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d231b15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:575 | try | DATA_OP | obj.Contains | ("error") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6dd849a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:578 | try ▸ if (string.IsNullOrWhiteSpace(obj) \|\| obj.Contains("error")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00388") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-63e69369 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:579 | try ▸ if (string.IsNullOrWhiteSpace(obj) \|\| obj.Contains("error")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe2649d0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:588 | try ▸ if (specialty == null \|\| specialty.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00389") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-42196755 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | SCP0078_FileUpload.cs:589 | try ▸ if (specialty == null \|\| specialty.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_FileUpload.UTF8_TO_EUCKR

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4e566f0 | (진입점 미연결) | SCP0078_FileUpload.cs:1013 |  | CALL_EXT | Encoding.GetEncoding | ("euc-kr") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a92f275d | (진입점 미연결) | SCP0078_FileUpload.cs:1014 |  | CALL_EXT | Encoding.Convert | ( Encoding.UTF8, Encoding.GetEncoding("euc-kr"), Encoding.UTF8.GetBytes(strUTF8)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-77005b1f | (진입점 미연결) | SCP0078_FileUpload.cs:1016 |  | CALL_EXT | Encoding.GetEncoding | ("euc-kr") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b287a27c | (진입점 미연결) | SCP0078_FileUpload.cs:1017 |  | CALL_EXT | Encoding.UTF8.GetBytes | (strUTF8) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85b02148 | (진입점 미연결) | SCP0078_FileUpload.cs:1013 |  | RETURN | return Encoding.GetEncoding("euc-kr").GetString( Encoding.Convert( Encoding.UTF8… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43dc3cfe | this.btnButtonList.UsrButtonList_Click_Detected | SCP0078_GSCM_VOC_Popup.cs:191 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_PROP | this.DialogResult | DialogResult.No | 속성 DialogResult 설정 |  |  |  |
| AC-4f251cb4 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0078_GSCM_VOC_Popup.cs:192 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_GSCM_VOC_Popup.ConvertDos2Unix

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b04b35dd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… 외 1 | SCP0078_GSCM_VOC_Popup.cs:179 |  | RETURN | return xString; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC_Popup.ConvertUnix2DOS

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-816714d2 | this.Load | SCP0078_GSCM_VOC_Popup.cs:174 |  | RETURN | return xString; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-474a05c6 | Dispose | SCP0078_GSCM_VOC_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0078_GSCM_VOC_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f9f865e | this.Load | SCP0078_GSCM_VOC_Popup.cs:55 |  | VALUE_SET | this.Text | string.Format("VOC NO = {0}", VOC_NO) | 컨트롤 값 설정 |  |  |  |
| AC-d23fc477 | this.Load | SCP0078_GSCM_VOC_Popup.cs:57 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0078_GSCM_VOC_Popup.GetDetailText

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fb804c0 | this.Load | SCP0078_GSCM_VOC_Popup.cs:211 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var request… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a24834af | this.Load | SCP0078_GSCM_VOC_Popup.cs:215 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_GET_GSCM_VOC_DATA") ⇒ SCP.SCP0078_GET_GSCM_VOC_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-57849d94 | this.Load | SCP0078_GSCM_VOC_Popup.cs:216 | lambda | DATA_OP | request.Parameters["p_voc_no"] | strVOC_NO | 행/컬럼 값 대입 |  |  |  |
| AC-01224754 | this.Load | SCP0078_GSCM_VOC_Popup.cs:218 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-eae50427 | this.Load | SCP0078_GSCM_VOC_Popup.cs:220 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-95c2f6fb | this.Load | SCP0078_GSCM_VOC_Popup.cs:228 | if (ds != null && ds.Tables[0].Rows.Count > 0) | COMBO_DATA | DATA_COLUMN.Contains | ( "DETAIL") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fbae3489 | this.Load | SCP0078_GSCM_VOC_Popup.cs:239 |  | VALUE_SET | rtxtSQL.Text | ConvertUnix2DOS(voc_data) | 컨트롤 값 설정 |  |  |  |

## SCP0078_GSCM_VOC_Popup.SaveDetailData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd8a75ae | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:98 |  | COMBO_DATA | DATA_COLUMN.Contains | ("DETAIL") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-32a47447 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:102 | if (DATA_COLUMN == "VIEW" \|\| DATA_COLUMN.Contains("DETAIL")) | ENDPOINT | ScpUtils.GetDataLength | ("CHAR", strData) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-097d31e1 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:104 | if (DATA_COLUMN == "VIEW" \|\| DATA_COLUMN.Contains("DETAIL")) ▸ if (ScpUtils.GetDataLength("CHAR", strData) > 400) | MESSAGE | MessageHelper.GMessageBox | ("MSG00165") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b999596e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:105 | if (DATA_COLUMN == "VIEW" \|\| DATA_COLUMN.Contains("DETAIL")) ▸ if (ScpUtils.GetDataLength("CHAR", strData) > 400) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d3272fc | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:114 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_SAVE_GSCM_VOC_DATA") ⇒ SCP.SCP0078_SAVE_GSCM_VOC_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-499dbeda | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:116 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { request.Par… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-991ffe78 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:120 | lambda | DATA_OP | request.Parameters["p_active_flag"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-4cd18cc2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:121 | lambda | DATA_OP | request.Parameters["p_edit_type"] | column | 행/컬럼 값 대입 |  |  |  |
| AC-2fd6deab | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:122 | lambda | DATA_OP | request.Parameters["p_voc_no"] | VOC_NO | 행/컬럼 값 대입 |  |  |  |
| AC-bd781aba | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:123 | lambda | DATA_OP | request.Parameters["p_voc_type"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c1a982c4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:124 | lambda | DATA_OP | request.Parameters["p_voc_name"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-dba93c7e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:125 | lambda | DATA_OP | request.Parameters["p_voc_detail"] | strData | 행/컬럼 값 대입 |  |  |  |
| AC-de87f5fb | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:126 | lambda | DATA_OP | request.Parameters["p_request_date"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-409df50c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:127 | lambda | DATA_OP | request.Parameters["p_request_user_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-76f3a7f2 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:128 | lambda | DATA_OP | request.Parameters["p_scm_pi_user_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-b5c6fb38 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:129 | lambda | DATA_OP | request.Parameters["p_scm_solution_user_id"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-98bf9513 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:130 | lambda | DATA_OP | request.Parameters["p_csr_no"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-62c4c105 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:131 | lambda | DATA_OP | request.Parameters["p_remark"] | strData | 행/컬럼 값 대입 |  |  |  |
| AC-7faad606 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:132 | lambda | DATA_OP | request.Parameters["p_use_yn"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-58a04d06 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:134 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4312133 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:134 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-36060626 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:143 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33ab30fd | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:151 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a272b738 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:154 | if (t.Success) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-080fec57 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0078_GSCM_VOC_Popup.cs:155 | if (t.Success) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_GSCM_VOC.btnItemId_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-787bba48 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:3332 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f17f9fb3 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:3334 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3141b36b | (진입점 미연결) | SCP0078_GSCM_VOC.cs:3335 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-31fa5b39 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:3340 | if (popItem.ItemID != "") | VALUE_SET | txtReqUserID.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0078_GSCM_VOC.CellValueValidation

진입점: this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1221b68b | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2807 | try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (BeforSte… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-cf325622 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2808 | try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (BeforSte… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e6e32584 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2815 | try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (CheckBef… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-7fd09ca1 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2816 | try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (CheckBef… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-68395abf | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2842 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (iCo… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-627a2667 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2843 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (iCo… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2fc876f9 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2850 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (iCo… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-9bb5be0d | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2851 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ if (iCo… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e27b7d67 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2868 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-17811ed8 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2869 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ce7b6d38 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2876 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-570a5c44 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2877 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4dd68d24 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2885 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-fd1416b7 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2886 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4032df81 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2904 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-7b6a685c | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2905 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-488b06bc | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2912 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-f22c5d80 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2913 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a3a51881 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2921 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-8e8aa6a6 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2922 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5aff2905 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2929 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | MESSAGE | MessageBox.Show | (ReturnMessage) | 메시지 표시 |  |  |  |
| AC-dadfca41 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2930 | try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-966c1f63 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:3046 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-08133903 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:3054 |  | RETURN | return returnResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckBeforeStepDateLate

진입점: this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE))] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea758802 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2719 | if (string.IsNullOrEmpty(BeforeStepDate) == false && string.IsNullOrEmpty(StepDate) == false) ▸ try ▸ if (BeforeStepDate.Length == 8) | DATA_OP | BeforeStepDate.Insert(6, "-").Insert | (4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-2740566f | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2719 | if (string.IsNullOrEmpty(BeforeStepDate) == false && string.IsNullOrEmpty(StepDate) == false) ▸ try ▸ if (BeforeStepDate.Length == 8) | DATA_OP | BeforeStepDate.Insert | (6, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba7cd405 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2723 | if (string.IsNullOrEmpty(BeforeStepDate) == false && string.IsNullOrEmpty(StepDate) == false) ▸ try ▸ if (StepDate.Length == 8) | DATA_OP | StepDate.Insert(6, "-").Insert | (4, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d06cb2d | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2723 | if (string.IsNullOrEmpty(BeforeStepDate) == false && string.IsNullOrEmpty(StepDate) == false) ▸ try ▸ if (StepDate.Length == 8) | DATA_OP | StepDate.Insert | (6, "-") | 데이터 객체 조작/조회 |  |  |  |
| AC-e180bbea | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2736 | if (string.IsNullOrEmpty(BeforeStepDate) == false && string.IsNullOrEmpty(StepDate) == false) ▸ catch ((Exception ex)) | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |
| AC-37f1af3f | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 1 | SCP0078_GSCM_VOC.cs:2740 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckBeforStepFinish

진입점: this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ try ▸ if (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1803249 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2677 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckConfirmStatus

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6030d11 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1161 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckConvertDateType

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (string.IsNullOrWhiteSpace(value) == false) ▸ if (valueCount > 0) ▸ for (i < strResult.Length) ▸ if (string.IsNullOrWhiteSpace(checkValue) == false) ▸ else of (checkValue.Length < 10)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6312153 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2509 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d141f56b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2513 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckDateNoStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a637a35 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2575 | if (string.IsNullOrEmpty(date) == false && date != "19000101") ▸ if (string.IsNullOrEmpty(status) == true) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-acc42fc6 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2579 | if (string.IsNullOrEmpty(date) == false && date != "19000101") ▸ else of (string.IsNullOrEmpty(status) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c356af82 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2584 | else of (string.IsNullOrEmpty(date) == false && date != "19000101") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckDateValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3685514a | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2523 | if (value == "19000101") | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |
| AC-7a0f03f9 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2527 | else of (value == "19000101") | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckDelay

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try ▸ if (dsBinding != null && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STATUS: case DefMain.RECEIPT_STATUS: case DefMain.REVIEW_STATUS: case DefMain.… ▸ switch (focusValue) case "": case "RN":] / FindButton…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3281b218 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2338 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckExceptBeforeStepFinish

진입점: this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ try ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.FINISH_DATE)) ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.TEST_DATE)) ▸ else of (iColumn == siMain.GetColumnIndex(DefMain.DEV_STATUS) \|\| iColumn == siMain.GetColumnIndex(DefMain.DEV_DATE)) ▸ if (iColumn == siMain.GetColumnIndex(DefMain.PRIORITY_STATU…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c75dd9e1 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2613 | if (CheckBeforStepFinish(CLASSIFY_STATUS)) ▸ if (step == siMain.GetColumnIndex(DefMain.PRIORITY_STATUS)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-56ee7fb7 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… | SCP0078_GSCM_VOC.cs:2616 |  | RETURN | return result; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckFinishButNoDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-120b8245 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2545 | if (status == checkFinishCode \|\| status == checkFinishWord) ▸ if (string.IsNullOrEmpty(date)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-baa2e7f1 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2549 | if (status == checkFinishCode \|\| status == checkFinishWord) ▸ else of (string.IsNullOrEmpty(date)) ▸ if (date == "19000101") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-af882ce6 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2553 | if (status == checkFinishCode \|\| status == checkFinishWord) ▸ else of (string.IsNullOrEmpty(date)) ▸ else of (date == "19000101") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-668a43ce | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2558 | else of (status == checkFinishCode \|\| status == checkFinishWord) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckSoon

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try ▸ if (dsBinding != null && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STATUS: case DefMain.RECEIPT_STATUS: case DefMain.REVIEW_STATUS: case DefMain.… ▸ switch (focusValue) case "": case "RN": ▸ else of (Ch…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6aabc4a | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2366 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckStartDateValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3bd3ed7 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2437 | if (CheckWorkDateValue(value) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d1e31893 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2447 | switch (status) case "FH": ▸ if (valueCount != 1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cbc6670d | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2455 | switch (status) case "RN": case "HD": case "DR": default: | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6a960629 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2460 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckStepFinish

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d40f1581 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2666 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckValidationSave

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-698480b7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1910 | try ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | ScpUtils.GetByteValue | (row_voc_name) | ⚠ 의미 확인 필요 |  |  |  |
| AC-754d6ce5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1916 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_voc_name)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefMainLabel.VOC_NAME }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-704b59bc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1917 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_voc_name)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-447ade5f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1923 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_voc_name)) ▸ if (voc_name_byte > 200) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { DefMainLabel.VOC_NAME }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec9554b4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1924 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_voc_name)) ▸ if (voc_name_byte > 200) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eaec78ef | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2030 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (CheckConfirmStatus("RUN", row_confi… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6a65c8e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2031 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (CheckConfirmStatus("RUN", row_confi… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6e6296cb | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2038 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (string.IsNullOrWhiteSpace(row_confi… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53ea1a78 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2039 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (string.IsNullOrWhiteSpace(row_confi… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dfd41dd6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2045 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (string.IsNullOrWhiteSpace(row_confi… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d4e2d3f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2046 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status)) ▸ if (string.IsNullOrWhiteSpace(row_confi… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f1f48de | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2057 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (CheckWorkDateValue(p_classify_status, ref p_classify_date) == fal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.CLASSIFY_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f0b24b9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2058 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (CheckWorkDateValue(p_classify_status, ref p_classify_date) == fal… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-44e77023 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2062 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.RECEIPT_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3172dafb | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2063 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b3a2c355 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2067 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.REVIEW_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7b38497 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2068 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ff18d861 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2072 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.PRIORITY_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47d80940 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2073 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-561842d8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2077 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.DEV_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f00c361d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2078 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c7772500 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2082 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.TEST_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-482e67de | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2083 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b73cf747 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2087 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.FINISH_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-159685a6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2088 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateValue(p_classify_status, ref p_classify_date) =… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3354f75c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2098 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.REQUEST_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-508e9352 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2099 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a8917b33 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2103 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.SCM_PI_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-97c223b6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2104 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-893c0337 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2108 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.SCM_SOLUTION_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ef32909 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2109 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-84562210 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2119 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_division_id)) | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDivision(p_voc_no, row_voc_name, DefMainLabel.DIVISION_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51012a0f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2120 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_division_id)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-78a0dde8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2145 |  | RETURN | return bResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CheckWorkDateValue

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d385d42 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2384 | if (CheckWorkDateValue(value) == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d8824c5f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2398 | switch (status) case "FH": ▸ if (valueCount != 3) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-51c50891 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2406 | switch (status) case "RN": case "HD": ▸ if (valueCount < 1 \|\| valueCount >= 3) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1bf720b0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2414 | switch (status) case "DR": default: ▸ if (valueCount == 3) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fe779516 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2420 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7cc3d338 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2486 | if (string.IsNullOrWhiteSpace(value) == false) ▸ if (valueCount > 0) ▸ for (i < strResult.Length) ▸ if (string.IsNullOrWhiteSpace(checkValue… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-385024c3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2494 | if (string.IsNullOrWhiteSpace(value) == false) ▸ if (valueCount > 0) ▸ for (i < strResult.Length) ▸ if (string.IsNullOrWhiteSpace(checkValue… | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ff65e60f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… 외 1 | SCP0078_GSCM_VOC.cs:2502 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.ConvertArrayToString

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try ▸ try ▸ if (string.IsNullOrWhiteSpace(value) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a24a65e4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3248 |  | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.ConvertDateCopy

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b2da32f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3169 |  | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.ConvertDateFormat

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9446b7bc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3212 | try ▸ if (string.IsNullOrWhiteSpace(value) == false) ▸ if (iArrayCount > 0) ▸ for (i < strResult.Length) | DATA_OP | strConvertResult[i] | rowValue | 행/컬럼 값 대입 |  |  |  |
| AC-debd96f2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3222 |  | RETURN | return value; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.ConvertWorkDate

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06035acc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3114 | try ▸ if (string.IsNullOrWhiteSpace(value)) | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |
| AC-c8fada40 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:3136 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-786214a9 | this.Load | SCP0078_GSCM_VOC.cs:325 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d6ba4f26 | this.Load | SCP0078_GSCM_VOC.cs:326 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c4e6e8f4 | this.Load | SCP0078_GSCM_VOC.cs:327 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0078_GSCM_VOC.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3f9894d | this.Load | SCP0078_GSCM_VOC.cs:273 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-c56876db | this.Load | SCP0078_GSCM_VOC.cs:274 |  | FLAG | UserGroup | GetUserGroup() | 화면 필드/플래그 변경 |  |  |  |

## SCP0078_GSCM_VOC.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf84fa05 | DeleteButton | SCP0078_GSCM_VOC.cs:422 |  | MESSAGE | MessageHelper.GMessageBox | (MessageVOC.CLICK_DELETE) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ab49ff8 | DeleteButton | SCP0078_GSCM_VOC.cs:423 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23a2a54a | Dispose | SCP0078_GSCM_VOC.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0078_GSCM_VOC.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4c2f42f | EditButton | SCP0078_GSCM_VOC.cs:428 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad07141b | EditButton | SCP0078_GSCM_VOC.cs:429 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a9f7d41b | EditButton | SCP0078_GSCM_VOC.cs:432 |  | DATA_OP | UserGroup.Contains | ("PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c69934c | EditButton | SCP0078_GSCM_VOC.cs:432 |  | DATA_OP | UserGroup.Contains | ("VIEWER") | 데이터 객체 조작/조회 |  |  |  |
| AC-69e14fa3 | EditButton | SCP0078_GSCM_VOC.cs:437 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_NO), siMain.GetColumnIndex(DefMain.VOC_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14c26399 | EditButton | SCP0078_GSCM_VOC.cs:438 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_TYPE), siMain.GetColumnIndex(DefMain.VOC_TYPE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e68bfad | EditButton | SCP0078_GSCM_VOC.cs:442 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_DATE), siMain.GetColumnIndex(DefMain.REQUEST_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d1df3bae | EditButton | SCP0078_GSCM_VOC.cs:443 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_STATUS), siMain.GetColumnIndex(DefMain.CLASSIFY_ST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ad17519 | EditButton | SCP0078_GSCM_VOC.cs:444 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_DATE), siMain.GetColumnIndex(DefMain.CLASSIFY_DATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a6261c13 | EditButton | SCP0078_GSCM_VOC.cs:445 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_STATUS), siMain.GetColumnIndex(DefMain.RECEIPT_STAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-10c57105 | EditButton | SCP0078_GSCM_VOC.cs:446 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_DATE), siMain.GetColumnIndex(DefMain.RECEIPT_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7a894f3 | EditButton | SCP0078_GSCM_VOC.cs:447 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_STATUS), siMain.GetColumnIndex(DefMain.REVIEW_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b585ab8 | EditButton | SCP0078_GSCM_VOC.cs:448 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_DATE), siMain.GetColumnIndex(DefMain.REVIEW_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-14f06147 | EditButton | SCP0078_GSCM_VOC.cs:449 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_STATUS), siMain.GetColumnIndex(DefMain.PRIORITY_ST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0933078f | EditButton | SCP0078_GSCM_VOC.cs:450 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_DATE), siMain.GetColumnIndex(DefMain.PRIORITY_DATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1d73034 | EditButton | SCP0078_GSCM_VOC.cs:451 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_STATUS), siMain.GetColumnIndex(DefMain.DEV_STATUS), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-30e15eab | EditButton | SCP0078_GSCM_VOC.cs:452 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_DATE), siMain.GetColumnIndex(DefMain.DEV_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a9eb9d97 | EditButton | SCP0078_GSCM_VOC.cs:453 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_STATUS), siMain.GetColumnIndex(DefMain.TEST_STATUS), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-040e3138 | EditButton | SCP0078_GSCM_VOC.cs:454 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_DATE), siMain.GetColumnIndex(DefMain.TEST_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad1d5c1b | EditButton | SCP0078_GSCM_VOC.cs:455 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_STATUS), siMain.GetColumnIndex(DefMain.FINISH_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2aaec8f5 | EditButton | SCP0078_GSCM_VOC.cs:456 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_DATE), siMain.GetColumnIndex(DefMain.FINISH_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d980eb4c | EditButton | SCP0078_GSCM_VOC.cs:461 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), siMain.GetColumnIndex(DefMain.REQUEST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-91dbecd6 | EditButton | SCP0078_GSCM_VOC.cs:462 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_PI_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c0d022d | EditButton | SCP0078_GSCM_VOC.cs:463 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-31389cab | EditButton | SCP0078_GSCM_VOC.cs:468 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.USE_YN), siMain.GetColumnIndex(DefMain.USE_YN), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-55c0b009 | EditButton | SCP0078_GSCM_VOC.cs:470 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_USER_ID), siMain.GetColumnIndex(DefMain.CLASSIFY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dbcf3d20 | EditButton | SCP0078_GSCM_VOC.cs:471 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_USER_ID), siMain.GetColumnIndex(DefMain.RECEIPT_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1c0bf734 | EditButton | SCP0078_GSCM_VOC.cs:472 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_USER_ID), siMain.GetColumnIndex(DefMain.REVIEW_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f53db117 | EditButton | SCP0078_GSCM_VOC.cs:473 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_USER_ID), siMain.GetColumnIndex(DefMain.PRIORITY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b0c4765 | EditButton | SCP0078_GSCM_VOC.cs:474 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_USER_ID), siMain.GetColumnIndex(DefMain.DEV_USER_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c16ffb1 | EditButton | SCP0078_GSCM_VOC.cs:475 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_USER_ID), siMain.GetColumnIndex(DefMain.TEST_USER_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a029eb20 | EditButton | SCP0078_GSCM_VOC.cs:476 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_USER_ID), siMain.GetColumnIndex(DefMain.FINISH_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7065442 | EditButton | SCP0078_GSCM_VOC.cs:482 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_DATE), siMain.GetColumnIndex(DefMain.CONFIRM_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bccd559a | EditButton | SCP0078_GSCM_VOC.cs:483 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_USER_NAME), siMain.GetColumnIndex(DefMain.CONFIRM_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-58b7420f | EditButton | SCP0078_GSCM_VOC.cs:485 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_PLAN), siMain.GetColumnIndex(DefMain.MAN_MONTH_PL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca846ab9 | EditButton | SCP0078_GSCM_VOC.cs:486 | if (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_REAL), siMain.GetColumnIndex(DefMain.MAN_MONTH_RE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-36094c36 | EditButton | SCP0078_GSCM_VOC.cs:489 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) | DATA_OP | UserGroup.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-3bd4bf1e | EditButton | SCP0078_GSCM_VOC.cs:493 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_NO), siMain.GetColumnIndex(DefMain.VOC_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d958bb89 | EditButton | SCP0078_GSCM_VOC.cs:497 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_DETAIL), siMain.GetColumnIndex(DefMain.VOC_DETAIL), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-250a3800 | EditButton | SCP0078_GSCM_VOC.cs:498 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_DATE), siMain.GetColumnIndex(DefMain.REQUEST_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4a5122e9 | EditButton | SCP0078_GSCM_VOC.cs:503 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_STATUS), siMain.GetColumnIndex(DefMain.REVIEW_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b96901a6 | EditButton | SCP0078_GSCM_VOC.cs:504 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_DATE), siMain.GetColumnIndex(DefMain.REVIEW_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a6a1af7 | EditButton | SCP0078_GSCM_VOC.cs:507 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_STATUS), siMain.GetColumnIndex(DefMain.DEV_STATUS), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80a447e8 | EditButton | SCP0078_GSCM_VOC.cs:508 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_DATE), siMain.GetColumnIndex(DefMain.DEV_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d60ebb26 | EditButton | SCP0078_GSCM_VOC.cs:509 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_STATUS), siMain.GetColumnIndex(DefMain.TEST_STATUS), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-582fe187 | EditButton | SCP0078_GSCM_VOC.cs:510 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_DATE), siMain.GetColumnIndex(DefMain.TEST_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bacb5ae4 | EditButton | SCP0078_GSCM_VOC.cs:511 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_STATUS), siMain.GetColumnIndex(DefMain.FINISH_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c1ee973 | EditButton | SCP0078_GSCM_VOC.cs:512 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_DATE), siMain.GetColumnIndex(DefMain.FINISH_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eed3a6a3 | EditButton | SCP0078_GSCM_VOC.cs:517 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), siMain.GetColumnIndex(DefMain.REQUEST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-030e3a4c | EditButton | SCP0078_GSCM_VOC.cs:518 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_PI_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65aabd54 | EditButton | SCP0078_GSCM_VOC.cs:519 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-02815b4b | EditButton | SCP0078_GSCM_VOC.cs:522 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.USE_YN), siMain.GetColumnIndex(DefMain.USE_YN), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-84eef8e7 | EditButton | SCP0078_GSCM_VOC.cs:524 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_USER_ID), siMain.GetColumnIndex(DefMain.CLASSIFY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f19aa48 | EditButton | SCP0078_GSCM_VOC.cs:525 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_USER_ID), siMain.GetColumnIndex(DefMain.RECEIPT_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-be23b8c9 | EditButton | SCP0078_GSCM_VOC.cs:526 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_USER_ID), siMain.GetColumnIndex(DefMain.REVIEW_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c28063c7 | EditButton | SCP0078_GSCM_VOC.cs:527 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_USER_ID), siMain.GetColumnIndex(DefMain.PRIORITY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-219a9d6f | EditButton | SCP0078_GSCM_VOC.cs:528 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_USER_ID), siMain.GetColumnIndex(DefMain.DEV_USER_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-330651dd | EditButton | SCP0078_GSCM_VOC.cs:529 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_USER_ID), siMain.GetColumnIndex(DefMain.TEST_USER_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed70974d | EditButton | SCP0078_GSCM_VOC.cs:530 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_USER_ID), siMain.GetColumnIndex(DefMain.FINISH_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-818d3178 | EditButton | SCP0078_GSCM_VOC.cs:536 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_DATE), siMain.GetColumnIndex(DefMain.CONFIRM_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-46552dff | EditButton | SCP0078_GSCM_VOC.cs:537 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_USER_NAME), siMain.GetColumnIndex(DefMain.CONFIRM_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3dd81e72 | EditButton | SCP0078_GSCM_VOC.cs:539 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_PLAN), siMain.GetColumnIndex(DefMain.MAN_MONTH_PL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-516788f3 | EditButton | SCP0078_GSCM_VOC.cs:540 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ if (UserGroup.Contains("TEST")) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_REAL), siMain.GetColumnIndex(DefMain.MAN_MONTH_RE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-51b8cbbf | EditButton | SCP0078_GSCM_VOC.cs:543 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) | DATA_OP | UserGroup.Contains | ("PI") | 데이터 객체 조작/조회 |  |  |  |
| AC-0735ca51 | EditButton | SCP0078_GSCM_VOC.cs:543 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) | DATA_OP | UserGroup.Contains | ("ADMIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-031a5049 | EditButton | SCP0078_GSCM_VOC.cs:547 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_NO), siMain.GetColumnIndex(DefMain.VOC_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c5bfa951 | EditButton | SCP0078_GSCM_VOC.cs:551 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_DETAIL), siMain.GetColumnIndex(DefMain.VOC_DETAIL), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c132f736 | EditButton | SCP0078_GSCM_VOC.cs:552 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_DATE), siMain.GetColumnIndex(DefMain.REQUEST_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abd025f9 | EditButton | SCP0078_GSCM_VOC.cs:573 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), siMain.GetColumnIndex(DefMain.REQUEST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4b520e02 | EditButton | SCP0078_GSCM_VOC.cs:574 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_PI_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-011c55c1 | EditButton | SCP0078_GSCM_VOC.cs:575 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8217f75 | EditButton | SCP0078_GSCM_VOC.cs:580 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_USER_ID), siMain.GetColumnIndex(DefMain.CLASSIFY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-80e1ba06 | EditButton | SCP0078_GSCM_VOC.cs:581 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_USER_ID), siMain.GetColumnIndex(DefMain.RECEIPT_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0696d522 | EditButton | SCP0078_GSCM_VOC.cs:582 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_USER_ID), siMain.GetColumnIndex(DefMain.REVIEW_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b350209 | EditButton | SCP0078_GSCM_VOC.cs:583 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_USER_ID), siMain.GetColumnIndex(DefMain.PRIORITY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d356907 | EditButton | SCP0078_GSCM_VOC.cs:584 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_USER_ID), siMain.GetColumnIndex(DefMain.DEV_USER_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-58616b60 | EditButton | SCP0078_GSCM_VOC.cs:585 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_USER_ID), siMain.GetColumnIndex(DefMain.TEST_USER_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-28af9232 | EditButton | SCP0078_GSCM_VOC.cs:586 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_USER_ID), siMain.GetColumnIndex(DefMain.FINISH_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-27425694 | EditButton | SCP0078_GSCM_VOC.cs:592 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_DATE), siMain.GetColumnIndex(DefMain.CONFIRM_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cd759404 | EditButton | SCP0078_GSCM_VOC.cs:593 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI")… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_USER_NAME), siMain.GetColumnIndex(DefMain.CONFIRM_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9f11f7fb | EditButton | SCP0078_GSCM_VOC.cs:602 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_NO), siMain.GetColumnIndex(DefMain.VOC_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2de5b5f8 | EditButton | SCP0078_GSCM_VOC.cs:603 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_TYPE), siMain.GetColumnIndex(DefMain.VOC_TYPE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-213b1574 | EditButton | SCP0078_GSCM_VOC.cs:604 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISION_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f7750438 | EditButton | SCP0078_GSCM_VOC.cs:605 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_NAME), siMain.GetColumnIndex(DefMain.VOC_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-48288e8c | EditButton | SCP0078_GSCM_VOC.cs:606 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.VOC_DETAIL), siMain.GetColumnIndex(DefMain.VOC_DETAIL), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9382bbad | EditButton | SCP0078_GSCM_VOC.cs:607 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_DATE), siMain.GetColumnIndex(DefMain.REQUEST_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07dbb1d1 | EditButton | SCP0078_GSCM_VOC.cs:608 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_STATUS), siMain.GetColumnIndex(DefMain.CLASSIFY_ST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0b01c6cf | EditButton | SCP0078_GSCM_VOC.cs:609 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_DATE), siMain.GetColumnIndex(DefMain.CLASSIFY_DATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07fd754c | EditButton | SCP0078_GSCM_VOC.cs:610 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_STATUS), siMain.GetColumnIndex(DefMain.RECEIPT_STAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abbf0b40 | EditButton | SCP0078_GSCM_VOC.cs:611 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_DATE), siMain.GetColumnIndex(DefMain.RECEIPT_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cc35ec88 | EditButton | SCP0078_GSCM_VOC.cs:612 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_STATUS), siMain.GetColumnIndex(DefMain.REVIEW_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a9cce9f | EditButton | SCP0078_GSCM_VOC.cs:613 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_DATE), siMain.GetColumnIndex(DefMain.REVIEW_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-87ee7a69 | EditButton | SCP0078_GSCM_VOC.cs:614 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_STATUS), siMain.GetColumnIndex(DefMain.PRIORITY_ST… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca9165ef | EditButton | SCP0078_GSCM_VOC.cs:615 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_DATE), siMain.GetColumnIndex(DefMain.PRIORITY_DATE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0cf31043 | EditButton | SCP0078_GSCM_VOC.cs:616 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_STATUS), siMain.GetColumnIndex(DefMain.DEV_STATUS), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fee3e1ea | EditButton | SCP0078_GSCM_VOC.cs:617 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_DATE), siMain.GetColumnIndex(DefMain.DEV_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1ea7ff72 | EditButton | SCP0078_GSCM_VOC.cs:618 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_STATUS), siMain.GetColumnIndex(DefMain.TEST_STATUS), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3891b786 | EditButton | SCP0078_GSCM_VOC.cs:619 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_DATE), siMain.GetColumnIndex(DefMain.TEST_DATE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c9c921a | EditButton | SCP0078_GSCM_VOC.cs:620 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_STATUS), siMain.GetColumnIndex(DefMain.FINISH_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-84631d29 | EditButton | SCP0078_GSCM_VOC.cs:621 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_DATE), siMain.GetColumnIndex(DefMain.FINISH_DATE), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-35eb6717 | EditButton | SCP0078_GSCM_VOC.cs:622 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_STATUS), siMain.GetColumnIndex(DefMain.CONFIRM_STAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-42bfd19d | EditButton | SCP0078_GSCM_VOC.cs:623 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_DATE), siMain.GetColumnIndex(DefMain.CONFIRM_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d16be45a | EditButton | SCP0078_GSCM_VOC.cs:625 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_USER_ID), siMain.GetColumnIndex(DefMain.REQUEST_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6373557e | EditButton | SCP0078_GSCM_VOC.cs:626 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_PI_USER_ID), siMain.GetColumnIndex(DefMain.SCM_PI_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e805e2e | EditButton | SCP0078_GSCM_VOC.cs:627 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_ID), siMain.GetColumnIndex(DefMain.SCM_SO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce3b211e | EditButton | SCP0078_GSCM_VOC.cs:628 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), siMain.GetColumnIndex(DefMain.REQUEST_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0415861a | EditButton | SCP0078_GSCM_VOC.cs:629 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_PI_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3093f8e0 | EditButton | SCP0078_GSCM_VOC.cs:630 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), siMain.GetColumnIndex(DefMain.SCM_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-736cd31e | EditButton | SCP0078_GSCM_VOC.cs:632 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CSR_NO), siMain.GetColumnIndex(DefMain.CSR_NO), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1537aac1 | EditButton | SCP0078_GSCM_VOC.cs:633 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REMARK), siMain.GetColumnIndex(DefMain.REMARK), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-25067f2f | EditButton | SCP0078_GSCM_VOC.cs:634 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.USE_YN), siMain.GetColumnIndex(DefMain.USE_YN), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-227decc1 | EditButton | SCP0078_GSCM_VOC.cs:636 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CLASSIFY_USER_ID), siMain.GetColumnIndex(DefMain.CLASSIFY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b70e9d2c | EditButton | SCP0078_GSCM_VOC.cs:637 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.RECEIPT_USER_ID), siMain.GetColumnIndex(DefMain.RECEIPT_USE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38379b41 | EditButton | SCP0078_GSCM_VOC.cs:638 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.REVIEW_USER_ID), siMain.GetColumnIndex(DefMain.REVIEW_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3d3ae56 | EditButton | SCP0078_GSCM_VOC.cs:639 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.PRIORITY_USER_ID), siMain.GetColumnIndex(DefMain.PRIORITY_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-27f03bdc | EditButton | SCP0078_GSCM_VOC.cs:640 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.DEV_USER_ID), siMain.GetColumnIndex(DefMain.DEV_USER_ID), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ad5c02c1 | EditButton | SCP0078_GSCM_VOC.cs:641 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.TEST_USER_ID), siMain.GetColumnIndex(DefMain.TEST_USER_ID),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c70fff3 | EditButton | SCP0078_GSCM_VOC.cs:642 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.FINISH_USER_ID), siMain.GetColumnIndex(DefMain.FINISH_USER_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4a97c03 | EditButton | SCP0078_GSCM_VOC.cs:645 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.BENEFIT_QUANTITATIVE), siMain.GetColumnIndex(DefMain.BENEFI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3736cf69 | EditButton | SCP0078_GSCM_VOC.cs:646 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.BENEFIT_QUALITATIVE), siMain.GetColumnIndex(DefMain.BENEFIT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-43dc5ddc | EditButton | SCP0078_GSCM_VOC.cs:647 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_STATUS), siMain.GetColumnIndex(DefMain.CONFIRM_STAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae203812 | EditButton | SCP0078_GSCM_VOC.cs:648 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_DATE), siMain.GetColumnIndex(DefMain.CONFIRM_DATE),… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4266025 | EditButton | SCP0078_GSCM_VOC.cs:649 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_USER_NAME), siMain.GetColumnIndex(DefMain.CONFIRM_U… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81e9045b | EditButton | SCP0078_GSCM_VOC.cs:650 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CONFIRM_OPINION), siMain.GetColumnIndex(DefMain.CONFIRM_OPI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bda2bb9f | EditButton | SCP0078_GSCM_VOC.cs:651 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_PLAN), siMain.GetColumnIndex(DefMain.MAN_MONTH_PL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-22d038bc | EditButton | SCP0078_GSCM_VOC.cs:652 | else of (UserGroup.Contains("PLAN") \|\| UserGroup.Contains("VIEWER")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains(… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.MAN_MONTH_REAL), siMain.GetColumnIndex(DefMain.MAN_MONTH_RE… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0078_GSCM_VOC.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5b5f22b | ExcelButton | SCP0078_GSCM_VOC.cs:680 |  | CALL_BASE | GetSpread | (fps.Name) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c043d7d | ExcelButton | SCP0078_GSCM_VOC.cs:683 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00100") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-383dc4c8 | ExcelButton | SCP0078_GSCM_VOC.cs:690 | else of (result == DialogResult.Yes) ▸ else of (result == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.ExportExcel

진입점: ExcelButton [if (result == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c285ea68 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:701 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a43513ec | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:705 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4f8c7256 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:714 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-30504596 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:721 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ab55a83d | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:723 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bcfcf76 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:726 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-24aa917f | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:763 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc7ea822 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:763 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a7c0477 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:769 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-80ded84a | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:774 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66b95e16 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:776 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d03d8609 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:785 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-546cb84b | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:797 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-f2479ac2 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:798 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-7f43c190 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:807 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-4bc9c4b4 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:808 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-c5b5fdc5 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:814 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (newSheet.Columns[i].Ce… | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-862f64c3 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:827 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-85058ee3 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:836 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-4ec9bbea | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:843 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-2829c847 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:848 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-473ed932 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:850 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-a76c59d9 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:854 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-126ac140 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:856 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-dd764b4f | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:859 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-f833f695 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:861 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-617b1b79 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:866 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-261944fd | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:880 | try ▸ if (isOpen) | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b14f5d0 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:882 | try ▸ if (isOpen) | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a19bd322 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:886 | try ▸ else of (isOpen) | POPUP | new SaveFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-afc668bc | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:887 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Filter | "Excel files (*.xls or .xlsx)\|*.xls;*.xlsx" | 속성 Filter 설정 |  |  |  |
| AC-dee0c8d3 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:888 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.Title | "Save an Excel File" | 속성 Title 설정 |  |  |  |
| AC-317b55bf | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:889 | try ▸ else of (isOpen) | UI_PROP | saveFileDialog.FileName | sExcelFileName | 속성 FileName 설정 |  |  |  |
| AC-1c0bdee7 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:890 | try ▸ else of (isOpen) | POPUP | saveFileDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dd517950 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:897 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") | CALL_EXT | sFileName.LastIndexOf | (".") | ⚠ 의미 확인 필요 |  |  |  |
| AC-45f32c55 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:899 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ if (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUpper() =… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bf10d20 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:902 | try ▸ else of (isOpen) ▸ if (saveFileDialog.FileName != "") ▸ else of (sFileName.Substring(sFileName.LastIndexOf(".") + 1).ToString().ToUppe… | CALL_EXT | sp.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf1ee1b7 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:906 | try | CALL_EXT | GC.GetGeneration | ((object)sp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ce65c2d | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:913 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc7459fb | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:918 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-492387c8 | ExcelButton [if (result == DialogResult.Yes)] | SCP0078_GSCM_VOC.cs:921 | finally ▸ if (ver >= 0) | CALL_EXT | GC.Collect | (ver) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0078_GSCM_VOC.FindData_Main

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this))] / FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f356994 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:966 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ad197780 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:966 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e557b77 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:967 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-330b03e1 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:967 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddb62c2a | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:987 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2e81a850 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:990 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e2fedf55 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:993 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4e34f4d | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:996 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6bab1adb | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:998 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { var req = n… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-951a142c | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1001 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_GET_GSCM_VOC") ⇒ SCP.SCP0078_GET_GSCM_VOC | 엔드포인트 요청 생성 |  |  |  |
| AC-0e684a47 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1002 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0e68d41a | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1003 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b66ca099 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1004 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b0cbade0 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1005 | try ▸ lambda | DATA_OP | req.Parameters["p_voc_name"] | txtVocName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-30216808 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1006 | try ▸ lambda | DATA_OP | req.Parameters["p_csr"] | txtCSR.Text | 행/컬럼 값 대입 |  |  |  |
| AC-5119d0fe | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1007 | try ▸ lambda | DATA_OP | req.Parameters["p_req_user_id"] | pReqUserID.Equals("ALL") ? DBNull.Value : pReqUserID | 행/컬럼 값 대입 |  |  |  |
| AC-3017a85d | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1008 | try ▸ lambda | DATA_OP | req.Parameters["p_voc_type"] | pVocType.Equals("ALL") ? DBNull.Value : pVocType | 행/컬럼 값 대입 |  |  |  |
| AC-7a584af6 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1009 | try ▸ lambda | DATA_OP | req.Parameters["p_voc_step"] | pVocStep.Equals("ALL") ? DBNull.Value : pVocStep | 행/컬럼 값 대입 |  |  |  |
| AC-8b4066ba | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1010 | try ▸ lambda | DATA_OP | req.Parameters["p_voc_status"] | pVocStatus.Equals("ALL") ? DBNull.Value : pVocStatus | 행/컬럼 값 대입 |  |  |  |
| AC-2e16a6d0 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1011 | try ▸ lambda | DATA_OP | req.Parameters["p_use_yn"] | pUseYN.Equals("ALL") ? DBNull.Value : pUseYN | 행/컬럼 값 대입 |  |  |  |
| AC-1bc3bc1b | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1012 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id.Equals("ALL") ? DBNull.Value : p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-b11f82ab | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1013 | try ▸ lambda | DATA_OP | req.Parameters["p_voc_confirm"] | pVocConfirm.Equals("ALL") ? DBNull.Value : pVocConfirm | 행/컬럼 값 대입 |  |  |  |
| AC-e8097e2b | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1015 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-187107b6 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1016 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2c62da7c | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1023 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-910d57cc | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1024 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-88ccf6a9 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1025 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-313c2c9b | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1037 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2f40f4f2 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1039 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81078a36 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1043 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-17ddf31f | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:1044 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0078_GSCM_VOC.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a1d9a3c | this.Load | SCP0078_GSCM_VOC.cs:261 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0078_GSCM_VOC.GetCellDateArray

진입점: this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_DATE) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_DATE) \|\| e.Colu…) ▸ try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a02e936 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 2 | SCP0078_GSCM_VOC.cs:3090 | try ▸ if (string.IsNullOrWhiteSpace(value) == false) | RETURN | return strResult; |  | 처리 중단/반환 |  |  |  |
| AC-ef86c628 | this.spdMain.EditChange [try ▸ if (e.Column == siMain.GetCol… 외 2 | SCP0078_GSCM_VOC.cs:3097 |  | RETURN | return strResult; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCellValue

진입점: this.spdMain.CellDoubleClick / FindButton [try ▸ if (dsBinding != null && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STATUS: case DefMain.RECEIPT_STATUS: case DefMain.REVIEW_STATUS: case DefMain.… ▸ switch (focusValue) case "": case "RN": ▸ try ▸ if (focusHeaderName != null && string.IsNullOrWhiteSpace(focusHeaderName.ToString()) == false)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c62a666 | this.spdMain.CellDoubleClick 외 2 | SCP0078_GSCM_VOC.cs:3298 |  | RETURN | return returnValue; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessage

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96273cb4 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2622 |  | RETURN | return string.Format("[{0}] 단계 완료 시 완료일을 필수 입력해야 합니다.", stepLabel); |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageBeforeSTepDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d27f4729 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2630 |  | RETURN | return string.Format("[{0}] 단계 완료일 보다 빠릅니다.", stepLabel); |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageDateType

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (CheckWorkDateValue(p_classify_status, ref p_classify_date) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-047523dd | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2634 |  | RETURN | return string.Format("NO = {0}\r\n[{1}] 단계 \r\n완료일 입력값에 오류가 있습니다.\r\n또는 단계 상태에 적… |  | 처리 중단/반환 |  |  |  |
| AC-c3b0552d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2638 |  | RETURN | return string.Format("NO : {0}\r\n과제명 : {1}\r\n[{2}] 단계 \r\n완료일 입력값에 오류가 있습니다.\r… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageDivision

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_division_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c040eb | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2654 |  | RETURN | return string.Format("과제명 : {1}\r\n[{2}] 값이 필요합니다..\r\n", voc_no, voc_name, divL… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageNoStatus

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baea869d | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2626 |  | RETURN | return string.Format("[{0}] 단계 완료일 입력 시 상태값을 필수 입력해야 합니다.", stepLabel); |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageStartDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd051f13 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2642 |  | RETURN | return string.Format("NO : {0}\r\n과제명 : {1}\r\n[{2}] 단계 \r\n[완료] 시 시작일 값이 필요합니다"… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageStartDateCompare

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if ((CheckBeforeStepDateLate(row_classify_start_date, row_priority_start_date)))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa9007d9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2646 |  | RETURN | return string.Format("NO : {0}\r\n과제명 : {1}\r\n[{2}] 단계 \r\n이전 단계 시작일 보다 빠릅니다.",… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetCheckMessageUser

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equals("FH")) ▸ if (string.IsNullOrWhiteSpace(p_request_user_id))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae0b0c4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:2650 |  | RETURN | return string.Format("NO : {0}\r\n과제명 : {1}\r\n[{2}] 값이 필요합니다.", voc_no, voc_nam… |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14795e13 | this.Load | SCP0078_GSCM_VOC.cs:3320 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetSpdTitle

진입점: this.Load / this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-592d97ca | this.Load 외 3 | SCP0078_GSCM_VOC.cs:3306 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-b051242f | this.Load 외 3 | SCP0078_GSCM_VOC.cs:3307 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-db5d543d | this.Load 외 3 | SCP0078_GSCM_VOC.cs:3308 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-be76d4eb | this.Load 외 3 | SCP0078_GSCM_VOC.cs:3310 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-408e098e | this.Load 외 3 | SCP0078_GSCM_VOC.cs:3310 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0078_GSCM_VOC.GetUserGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73c7f6da | this.Load | SCP0078_GSCM_VOC.cs:2150 |  | RETURN | return UserInfoContext.Current["NowGroupID"].ToUpper(); |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetUserMenuAuth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fea7a1ac | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2160 |  | DATA_OP | UserGroup.Contains | ("PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-78480de5 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2162 | if (UserGroup.Contains("PLAN")) | RETURN | return MenuAuth.PLAN; |  | 처리 중단/반환 |  |  |  |
| AC-db34e137 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2164 | else of (UserGroup.Contains("PLAN")) | DATA_OP | UserGroup.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8778304 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2166 | else of (UserGroup.Contains("PLAN")) ▸ if (UserGroup.Contains("TEST")) | RETURN | return MenuAuth.TEST; |  | 처리 중단/반환 |  |  |  |
| AC-3ec7eb09 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2168 | else of (UserGroup.Contains("PLAN")) ▸ else of (UserGroup.Contains("TEST")) | DATA_OP | UserGroup.Contains | ("PI") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c0c8b2c | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2168 | else of (UserGroup.Contains("PLAN")) ▸ else of (UserGroup.Contains("TEST")) | DATA_OP | UserGroup.Contains | ("ADMIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-58355e00 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2170 | else of (UserGroup.Contains("PLAN")) ▸ else of (UserGroup.Contains("TEST")) ▸ if (UserGroup.Contains("PI") \|\| UserGroup.Contains("ADMIN")) | RETURN | return MenuAuth.PI; |  | 처리 중단/반환 |  |  |  |
| AC-016dc252 | (진입점 미연결) | SCP0078_GSCM_VOC.cs:2174 | else of (UserGroup.Contains("PLAN")) ▸ else of (UserGroup.Contains("TEST")) ▸ else of (UserGroup.Contains("PI") \|\| UserGroup.Contains("ADM… | RETURN | return ""; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.GetVocDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-050c0416 | this.Load | SCP0078_GSCM_VOC.cs:313 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-8aa47bb2 | this.Load | SCP0078_GSCM_VOC.cs:314 |  | DATA_OP | request.Parameters["p_lookup_type"] | sLookupType | 행/컬럼 값 대입 |  |  |  |
| AC-2f9caf49 | this.Load | SCP0078_GSCM_VOC.cs:315 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-905e899a | this.Load | SCP0078_GSCM_VOC.cs:319 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37a8db58 | this.Load | SCP0078_GSCM_VOC.cs:280 |  | DATA_OP | this.ConditionNotUseList.Add | (cboVocStep) | 데이터 객체 조작/조회 |  |  |  |
| AC-800832c3 | this.Load | SCP0078_GSCM_VOC.cs:285 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-30a48018 | this.Load | SCP0078_GSCM_VOC.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (Data.Common(Data.Type.YesOrNo), cboUseYN, true, "CODE", "NAME") ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-80cee9c0 | this.Load | SCP0078_GSCM_VOC.cs:286 |  | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-73107185 | this.Load | SCP0078_GSCM_VOC.cs:288 |  | FLAG | dtVocType | ScpUtils.GetLookupValues("VOC_TYPE") | 화면 필드/플래그 변경 |  |  |  |
| AC-a773a4c7 | this.Load | SCP0078_GSCM_VOC.cs:288 |  | CALL_EXT | ScpUtils.GetLookupValues | ("VOC_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc461a4a | this.Load | SCP0078_GSCM_VOC.cs:289 |  | FLAG | dtVocStep | ScpUtils.GetLookupValues("VOC_STEP") | 화면 필드/플래그 변경 |  |  |  |
| AC-e23d71cd | this.Load | SCP0078_GSCM_VOC.cs:289 |  | CALL_EXT | ScpUtils.GetLookupValues | ("VOC_STEP") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cb3ef8c | this.Load | SCP0078_GSCM_VOC.cs:290 |  | FLAG | dtVocStatus | ScpUtils.GetLookupValues("VOC_STATUS_SEARCH") | 화면 필드/플래그 변경 |  |  |  |
| AC-3336e585 | this.Load | SCP0078_GSCM_VOC.cs:290 |  | CALL_EXT | ScpUtils.GetLookupValues | ("VOC_STATUS_SEARCH") | ⚠ 의미 확인 필요 |  |  |  |
| AC-02d88958 | this.Load | SCP0078_GSCM_VOC.cs:291 |  | FLAG | dtVocConfirm | ScpUtils.GetLookupValues("VOC_STATUS_CONFIRM") | 화면 필드/플래그 변경 |  |  |  |
| AC-25a936a9 | this.Load | SCP0078_GSCM_VOC.cs:291 |  | CALL_EXT | ScpUtils.GetLookupValues | ("VOC_STATUS_CONFIRM") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cd91f0f | this.Load | SCP0078_GSCM_VOC.cs:293 |  | LIST_REBIND | clsCtrl.setListBox | (dtVocType, cboVocType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-51c3fa53 | this.Load | SCP0078_GSCM_VOC.cs:294 |  | LIST_REBIND | clsCtrl.setListBox | (dtVocStep, cboVocStep, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-75245b01 | this.Load | SCP0078_GSCM_VOC.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtVocStatus, cboVocStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7a65e213 | this.Load | SCP0078_GSCM_VOC.cs:296 |  | LIST_REBIND | clsCtrl.setListBox | (dtVocConfirm, cboConfirm, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0c81e2b6 | this.Load | SCP0078_GSCM_VOC.cs:298 |  | FLAG | dtDivision | GetVocDivision("VOC_DIVISION") | 화면 필드/플래그 변경 |  |  |  |
| AC-6143713c | this.Load | SCP0078_GSCM_VOC.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d794910 | this.Load | SCP0078_GSCM_VOC.cs:302 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-a148d401 | this.Load | SCP0078_GSCM_VOC.cs:304 |  | LIST_REBIND | ScpUtils.SetComboSelect | (cboUseYN, "Y") | 목록 컨트롤 재구성 |  |  |  |

## SCP0078_GSCM_VOC.InitSpread

진입점: this.Load / this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80910cee | this.Load 외 3 | SCP0078_GSCM_VOC.cs:338 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-afe75806 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:340 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-6a1a9bdc | this.Load 외 3 | SCP0078_GSCM_VOC.cs:343 |  | CALL_EXT | spdInfo.ColumnHeaderSpanRow | (0, spdInfo.GetColumnIndex(DefMain.REQUEST_USER_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9239e005 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:345 |  | CALL_EXT | spdInfo.ColumnHeaderSpanRow | (spdInfo.GetColumnIndex(DefMain.BENEFIT_QUANTITATIVE), spdInfo.GetColumnIndex(DefMain.BENE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a7de148 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:346 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.BENEFIT_QUANTITATIVE), 2, 2, 20, DefMainAddLabel.BENEFI… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85d21cca | this.Load 외 3 | SCP0078_GSCM_VOC.cs:348 |  | CALL_EXT | spdInfo.ColumnHeaderSpanRow | (spdInfo.GetColumnIndex(DefMain.CLASSIFY_STATUS), spdInfo.GetColumnIndex(DefMain.CONFIRM_S… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8cb9104a | this.Load 외 3 | SCP0078_GSCM_VOC.cs:349 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.CLASSIFY_STATUS), 1, 20, 20, DefMainAddLabel.STEP, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-509bf10c | this.Load 외 3 | SCP0078_GSCM_VOC.cs:350 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.CLASSIFY_STATUS), 1, 3, 20, DefStepLabel.CLASSIFY_STATU… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f55a6e11 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:351 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.RECEIPT_STATUS), 1, 2, 20, DefStepLabel.RECEIPT_STATUS,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebdafd68 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:352 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.REVIEW_STATUS), 1, 2, 20, DefStepLabel.REVIEW_STATUS, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-239e9630 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:353 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.PRIORITY_STATUS), 1, 3, 20, DefStepLabel.PRIORITY_STATU… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a6b5419 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:354 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.DEV_STATUS), 1, 3, 20, DefStepLabel.DEV_STATUS, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c92e91a | this.Load 외 3 | SCP0078_GSCM_VOC.cs:355 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.TEST_STATUS), 1, 2, 20, DefStepLabel.TEST_STATUS, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-277f9967 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:356 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.FINISH_STATUS), 1, 2, 20, DefStepLabel.FINISH_STATUS, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b46af7be | this.Load 외 3 | SCP0078_GSCM_VOC.cs:357 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.CONFIRM_STATUS), 1, 3, 20, DefStepLabel.CONFIRM_STATUS,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5111e449 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:360 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.REQUEST_USER_ID), 1, 7, 20, DefMainAddLabel.PIC, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d259a53 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:361 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.REQUEST_USER_ID), 1, 3, 20, DefPICLabel.REQUEST_USER_ID… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0b43be7 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:362 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.SCM_SOLUTION_USER_ID), 1, 2, 20, DefPICLabel.SCM_SOLUTI… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d626b22 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:363 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefMain.SCM_PI_USER_ID), 1, 2, 20, DefPICLabel.SCM_PI_USER_ID, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9228410d | this.Load 외 3 | SCP0078_GSCM_VOC.cs:366 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.CSR_NO), 3, 1, 20, DefMainLabel.CSR_NO, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4289bdb | this.Load 외 3 | SCP0078_GSCM_VOC.cs:368 |  | CALL_EXT | spdInfo.ColumnHeaderSpanRow | (spdInfo.GetColumnIndex(DefMain.MAN_MONTH_PLAN), spdInfo.GetColumnIndex(DefMain.MAN_MONTH_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c61a9c6a | this.Load 외 3 | SCP0078_GSCM_VOC.cs:369 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.MAN_MONTH_PLAN), 2, 2, 20, DefMainAddLabel.ManMonth, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b35c9567 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:371 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.REMARK), 3, 1, 20, DefMainLabel.REMARK, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17471cb0 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:372 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.FILE_UPLOAD), 3, 1, 20, DefMainLabel.FILE_UPLOAD, FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64eb0846 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:373 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.USE_YN), 3, 1, 20, DefMainLabel.USE_YN, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7729918 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:376 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, spdInfo.GetColumnIndex(DefMain.CLASSIFY_DATE), 1, 1, 50, DefMainLabel.CLASSIFY_DATE, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd54d067 | this.Load 외 3 | SCP0078_GSCM_VOC.cs:382 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c5f1191c | this.Load 외 3 | SCP0078_GSCM_VOC.cs:383 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76224acd | this.Load 외 3 | SCP0078_GSCM_VOC.cs:384 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0078_GSCM_VOC.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0e346d | InsertButton | SCP0078_GSCM_VOC.cs:1059 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ab8d9633 | InsertButton | SCP0078_GSCM_VOC.cs:1060 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | insCell.Row.Height | 60 | 속성 Height 설정 |  |  |  |
| AC-c77db570 | InsertButton | SCP0078_GSCM_VOC.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.VOC_NO, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ad45a04 | InsertButton | SCP0078_GSCM_VOC.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.VOC_TYPE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8db3e73 | InsertButton | SCP0078_GSCM_VOC.cs:1065 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.VOC_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-41f8ca46 | InsertButton | SCP0078_GSCM_VOC.cs:1066 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.VOC_DETAIL, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc0883c2 | InsertButton | SCP0078_GSCM_VOC.cs:1067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REQUEST_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb0c3ad8 | InsertButton | SCP0078_GSCM_VOC.cs:1068 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REQUEST_USER_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-a27b2af5 | InsertButton | SCP0078_GSCM_VOC.cs:1069 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REQUEST_USER_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-076c9c9e | InsertButton | SCP0078_GSCM_VOC.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.CLASSIFY_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bfdc167 | InsertButton | SCP0078_GSCM_VOC.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.CLASSIFY_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-293cc445 | InsertButton | SCP0078_GSCM_VOC.cs:1073 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.RECEIPT_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-08b6894c | InsertButton | SCP0078_GSCM_VOC.cs:1074 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.RECEIPT_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a813e2f | InsertButton | SCP0078_GSCM_VOC.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REVIEW_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-58ffffc2 | InsertButton | SCP0078_GSCM_VOC.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REVIEW_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2719b9fe | InsertButton | SCP0078_GSCM_VOC.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.DEV_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c6adf54 | InsertButton | SCP0078_GSCM_VOC.cs:1080 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.DEV_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-cafd4687 | InsertButton | SCP0078_GSCM_VOC.cs:1082 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.TEST_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d06d9370 | InsertButton | SCP0078_GSCM_VOC.cs:1083 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.TEST_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9fa805 | InsertButton | SCP0078_GSCM_VOC.cs:1085 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.FINISH_STATUS, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2c1a6d0 | InsertButton | SCP0078_GSCM_VOC.cs:1086 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.FINISH_DATE, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fc699b5 | InsertButton | SCP0078_GSCM_VOC.cs:1088 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.SCM_PI_USER_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-d03e768e | InsertButton | SCP0078_GSCM_VOC.cs:1089 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.SCM_PI_USER_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-97ac0e12 | InsertButton | SCP0078_GSCM_VOC.cs:1090 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.SCM_SOLUTION_USER_ID, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2dadb2c | InsertButton | SCP0078_GSCM_VOC.cs:1091 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.SCM_SOLUTION_USER_NAME, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-70c9df8b | InsertButton | SCP0078_GSCM_VOC.cs:1092 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.CSR_NO, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-c725652b | InsertButton | SCP0078_GSCM_VOC.cs:1093 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.REMARK, "") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5e1ad89 | InsertButton | SCP0078_GSCM_VOC.cs:1094 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | defaultData.Add | (DefMain.USE_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-df4ee39e | InsertButton | SCP0078_GSCM_VOC.cs:1096 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-25b33d5b | InsertButton | SCP0078_GSCM_VOC.cs:1099 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.VOC_NO), siMain.GetColumnIndex(DefMain.VOC_NO), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7320c054 | InsertButton | SCP0078_GSCM_VOC.cs:1100 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.VOC_TYPE), siMain.GetColumnIndex(DefMain.VOC_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0412cc62 | InsertButton | SCP0078_GSCM_VOC.cs:1101 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REQUEST_DATE), siMain.GetColumnIndex(DefMain.REQUE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81bc427f | InsertButton | SCP0078_GSCM_VOC.cs:1102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REQUEST_USER_ID), siMain.GetColumnIndex(DefMain.RE… | 그리드 편집 잠금/해제 |  |  |  |
| AC-44747328 | InsertButton | SCP0078_GSCM_VOC.cs:1104 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.CLASSIFY_STATUS), siMain.GetColumnIndex(DefMain.CL… | 그리드 편집 잠금/해제 |  |  |  |
| AC-402c70a7 | InsertButton | SCP0078_GSCM_VOC.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.CLASSIFY_DATE), siMain.GetColumnIndex(DefMain.CLAS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b1124348 | InsertButton | SCP0078_GSCM_VOC.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.RECEIPT_STATUS), siMain.GetColumnIndex(DefMain.REC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7b94863 | InsertButton | SCP0078_GSCM_VOC.cs:1108 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.RECEIPT_DATE), siMain.GetColumnIndex(DefMain.RECEI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6b90f0e3 | InsertButton | SCP0078_GSCM_VOC.cs:1110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REVIEW_STATUS), siMain.GetColumnIndex(DefMain.REVI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-915bd3e8 | InsertButton | SCP0078_GSCM_VOC.cs:1111 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REVIEW_DATE), siMain.GetColumnIndex(DefMain.REVIEW… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d055cad | InsertButton | SCP0078_GSCM_VOC.cs:1113 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.PRIORITY_STATUS), siMain.GetColumnIndex(DefMain.PR… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c09e572 | InsertButton | SCP0078_GSCM_VOC.cs:1114 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.PRIORITY_DATE), siMain.GetColumnIndex(DefMain.PRIO… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0c68d784 | InsertButton | SCP0078_GSCM_VOC.cs:1116 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DEV_STATUS), siMain.GetColumnIndex(DefMain.DEV_STA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8cc41eee | InsertButton | SCP0078_GSCM_VOC.cs:1117 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DEV_DATE), siMain.GetColumnIndex(DefMain.DEV_DATE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9aed57c | InsertButton | SCP0078_GSCM_VOC.cs:1119 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.TEST_STATUS), siMain.GetColumnIndex(DefMain.TEST_S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5fd78c9e | InsertButton | SCP0078_GSCM_VOC.cs:1120 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.TEST_DATE), siMain.GetColumnIndex(DefMain.TEST_DAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-af5054e2 | InsertButton | SCP0078_GSCM_VOC.cs:1122 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.FINISH_STATUS), siMain.GetColumnIndex(DefMain.FINI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1f06275c | InsertButton | SCP0078_GSCM_VOC.cs:1123 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.FINISH_DATE), siMain.GetColumnIndex(DefMain.FINISH… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1e6744ae | InsertButton | SCP0078_GSCM_VOC.cs:1125 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), siMain.GetColumnIndex(DefMain.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d591dd2d | InsertButton | SCP0078_GSCM_VOC.cs:1126 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.SCM_PI_USER_ID), siMain.GetColumnIndex(DefMain.SCM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e92b48fe | InsertButton | SCP0078_GSCM_VOC.cs:1127 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_ID), siMain.GetColumnIndex(DefMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f51c822b | InsertButton | SCP0078_GSCM_VOC.cs:1128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), siMain.GetColumnIndex(DefMain.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4debd62e | InsertButton | SCP0078_GSCM_VOC.cs:1129 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-764087fa | InsertButton | SCP0078_GSCM_VOC.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.CSR_NO), siMain.GetColumnIndex(DefMain.CSR_NO), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38631143 | InsertButton | SCP0078_GSCM_VOC.cs:1132 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.REMARK), siMain.GetColumnIndex(DefMain.REMARK), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2c5c497 | InsertButton | SCP0078_GSCM_VOC.cs:1133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.USE_YN), siMain.GetColumnIndex(DefMain.USE_YN), tr… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0078_GSCM_VOC.openFileUpload

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.REMARK)) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FILE_UPLOAD))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f7fbf05 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3270 |  | UI_PROP | popup.VOC_NO | voc_no | 속성 VOC_NO 설정 |  |  |  |
| AC-2e90d619 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3271 |  | UI_PROP | popup.FILE_LIST | fileList | 속성 FILE_LIST 설정 |  |  |  |
| AC-e8769339 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3272 |  | UI_PROP | popup.UserId | UserInfo.UserId | 속성 UserId 설정 |  |  |  |
| AC-9f2d88a9 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3274 |  | POPUP | popup.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |

## SCP0078_GSCM_VOC.openPopup

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd31957a | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3255 |  | POPUP | new SCP0078_GSCM_VOC_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-8553b9c6 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3257 |  | UI_PROP | popup.VOC_NO | voc_no | 속성 VOC_NO 설정 |  |  |  |
| AC-a73cfb05 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3258 |  | UI_PROP | popup.DATA_COLUMN | colName | 속성 DATA_COLUMN 설정 |  |  |  |
| AC-91f53094 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3259 |  | UI_PROP | popup.USER_ID | UserInfo.UserId | 속성 USER_ID 설정 |  |  |  |
| AC-9ce75c6b | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… | SCP0078_GSCM_VOC.cs:3261 |  | POPUP | popup.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |

## SCP0078_GSCM_VOC.Save_Data

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cadcca0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1171 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3096593 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1173 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95be160c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1178 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d9447777 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1180 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48b2f791 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1278 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (checkResult == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb4240ad | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1298 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | ScpUtils.GetByteValue | (row_voc_name) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0fbae73 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1304 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_voc_name)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefMainLabel.VOC_NAME }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-775c9997 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1305 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_voc_name)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75a0575c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1311 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_voc_name)) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { DefMainLabel.VOC_NAME }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12b47553 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1312 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (string.IsNullOrWhiteSpace(row_voc_name)) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18d72e24 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1317 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | ScpUtils.GetDataLength | ("CHAR", row_voc_detail) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0207a189 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1320 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (voc_detail_byte > 400) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00165", GAppSettings.LanguageCode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e852fa5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1321 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (voc_detail_byte > 400) | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bae610c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1322 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (voc_detail_byte > 400) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39e4ac25 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1396 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) | ENDPOINT | ScpUtils.GetDataLength | ("CHAR", row_csr_no) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-28f50e99 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1399 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (csr_no_byte > 30) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00165", GAppSettings.LanguageCode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38d211be | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1400 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (csr_no_byte > 30) | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d19ac4c6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1401 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (csr_no_byte > 30) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ca5dc09 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1433 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4048961c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1434 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b46d9b6a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1441 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93f55b2e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1442 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95aa7aea | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1448 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | MESSAGE | MessageHelper.GMessageBox | (checkMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da28c53d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1449 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (CheckConfirmStatus("USE_CODE", row_confirm_status… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-557dca7c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1491 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (CheckWorkDateValue(p_… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.CLASSIFY_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0075929f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1492 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (CheckWorkDateValue(p_… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33b871e0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1496 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.RECEIPT_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81311399 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1497 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-81e0f434 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1501 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.REVIEW_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3c8dc83 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1502 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-388b5477 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1506 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.PRIORITY_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-786490e0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1507 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab2471c5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1511 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.DEV_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21835fe7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1512 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59099f87 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1516 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.TEST_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7368d859 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1517 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1799fa6a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1521 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDateType(p_voc_no, p_voc_name, DefStepLabel.FINISH_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e5b89c78 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1522 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of (CheckWorkDateVal… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-17b18e5b | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1549 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if ((CheckBeforeStepDateL… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageStartDateCompare(p_voc_no, p_voc_name, DefStepLabel.PRIORITY_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-897e6824 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1550 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if ((CheckBeforeStepDateL… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6dbdb6a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1554 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of ((CheckBeforeStep… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageStartDateCompare(p_voc_no, p_voc_name, DefStepLabel.DEV_STATUS)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31a0a392 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1555 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ else of ((CheckBeforeStep… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be8e1ce4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1564 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.REQUEST_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5159b927 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1565 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8cd6d7a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1569 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.SCM_PI_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9276d1d6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1570 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ef1af98 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1574 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageUser(p_voc_no, p_voc_name, DefMainLabel.SCM_SOLUTION_USER_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df1d3288 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1575 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (p_active_flag == "M") ▸ if (p_classify_status.Equ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15637f56 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1584 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_division_id)) | MESSAGE | MessageHelper.GMessageBox | (GetCheckMessageDivision(p_voc_no, row_voc_name, DefMainLabel.DIVISION_ID)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-513df626 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1585 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrWhiteSpace(row_division_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-789adab0 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1706 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0078_SAVE_GSCM_VOC") ⇒ SCP.SCP0078_SAVE_GSCM_VOC | 엔드포인트 요청 생성 |  |  |  |
| AC-db0f2791 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1709 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_MASTER_SVC)) { req.Command… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-abfe1fda | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1713 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c51894f2 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1719 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f7c49387 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1720 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_voc_no"] | p_voc_no | 행/컬럼 값 대입 |  |  |  |
| AC-a3a15330 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1721 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_voc_type"] | p_voc_type | 행/컬럼 값 대입 |  |  |  |
| AC-472e8ce7 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1722 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_voc_name"] | p_voc_name | 행/컬럼 값 대입 |  |  |  |
| AC-57784652 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1723 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_voc_detail"] | p_voc_detail | 행/컬럼 값 대입 |  |  |  |
| AC-eae5d213 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1724 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_request_date"] | p_request_date | 행/컬럼 값 대입 |  |  |  |
| AC-5e1fb330 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1725 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_request_user_id"] | p_request_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-42132171 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1726 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_classify_status"] | p_classify_status | 행/컬럼 값 대입 |  |  |  |
| AC-d54fa35d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1727 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_classify_date"] | p_classify_date | 행/컬럼 값 대입 |  |  |  |
| AC-97db2329 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1728 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_classify_user_id"] | p_classify_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-b435c3af | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1729 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_receipt_status"] | p_receipt_status | 행/컬럼 값 대입 |  |  |  |
| AC-2346ef40 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1730 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_receipt_date"] | p_receipt_date | 행/컬럼 값 대입 |  |  |  |
| AC-60e9ae67 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1731 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_receipt_user_id"] | p_receipt_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e2241e5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1732 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_review_status"] | p_review_status | 행/컬럼 값 대입 |  |  |  |
| AC-afafa9be | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1733 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_review_date"] | p_review_date | 행/컬럼 값 대입 |  |  |  |
| AC-a7bdd229 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1734 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_review_user_id"] | p_review_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ff3e6f1e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1735 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_priority_status"] | p_priority_status | 행/컬럼 값 대입 |  |  |  |
| AC-e6ff926a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1736 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_priority_date"] | p_priority_date | 행/컬럼 값 대입 |  |  |  |
| AC-146b200e | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1737 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_priority_user_id"] | p_priority_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c1ffe69 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1738 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dev_status"] | p_dev_status | 행/컬럼 값 대입 |  |  |  |
| AC-d701ae8f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1739 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dev_date"] | p_dev_date | 행/컬럼 값 대입 |  |  |  |
| AC-dcbef51c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1740 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dev_user_id"] | p_dev_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-35616884 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1741 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_test_status"] | p_test_status | 행/컬럼 값 대입 |  |  |  |
| AC-f0a9635c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1742 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_test_date"] | p_test_date | 행/컬럼 값 대입 |  |  |  |
| AC-01adfb42 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1743 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_test_user_id"] | p_test_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-44bfcc7f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1744 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_finish_status"] | p_finish_status | 행/컬럼 값 대입 |  |  |  |
| AC-8dfd285f | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1745 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_finish_date"] | p_finish_date | 행/컬럼 값 대입 |  |  |  |
| AC-23b22e35 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1746 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_finish_user_id"] | p_finish_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6dcb89f8 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1747 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_pi_user_id"] | p_scm_pi_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-899ebbde | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1748 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scm_solution_user_id"] | p_scm_solution_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e20f96d5 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1749 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_csr_no"] | p_csr_no | 행/컬럼 값 대입 |  |  |  |
| AC-a1b841ff | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1750 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_remark"] | p_remark | 행/컬럼 값 대입 |  |  |  |
| AC-8e42769a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1751 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_use_yn"] | p_use_yn | 행/컬럼 값 대입 |  |  |  |
| AC-6a5e04f3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1752 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e84dcc77 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1754 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_confirm_status"] | p_confirm_status | 행/컬럼 값 대입 |  |  |  |
| AC-fc91ab7a | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1755 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_confirm_date"] | p_confirm_date | 행/컬럼 값 대입 |  |  |  |
| AC-a9e403f1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1756 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_confirm_user_id"] | p_confirm_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a79e6491 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1757 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_confirm_opinion"] | p_confirm_opinion | 행/컬럼 값 대입 |  |  |  |
| AC-07202bc4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1758 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_man_month_plan"] | p_man_month_plan | 행/컬럼 값 대입 |  |  |  |
| AC-0ebf29db | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1759 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_man_month_real"] | p_man_month_real | 행/컬럼 값 대입 |  |  |  |
| AC-e0921dd6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1760 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_benefit_quantitative"] | p_benefit_quantitative | 행/컬럼 값 대입 |  |  |  |
| AC-df0f8c12 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1761 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_benefit_qualitative"] | p_benefit_qualitative | 행/컬럼 값 대입 |  |  |  |
| AC-ae893187 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1763 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_classify_start_date"] | p_classify_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-43d65cd9 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1764 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_priority_start_date"] | p_priority_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-cb5ae4da | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1765 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_dev_start_date"] | p_dev_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-3f0196f3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1767 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35effd04 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1767 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-d6c962dc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1778 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-db4e8239 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1789 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tranResult == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-83cbb486 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1796 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00017") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-997b31b4 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1803 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0078_GSCM_VOC.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f9132a8 | SaveButton | SCP0078_GSCM_VOC.cs:662 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d36d9d2 | SaveButton | SCP0078_GSCM_VOC.cs:664 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea1feba0 | SaveButton | SCP0078_GSCM_VOC.cs:669 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == "RUN") | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d64473a | SaveButton | SCP0078_GSCM_VOC.cs:670 | if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (save_status == "RUN") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.SCM_SYS_LOG_BATCH_VOC

진입점: ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Exception e))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f2bb87a | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:941 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-acacd8bb | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:942 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-3b0b4296 | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:943 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-41a676b8 | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:944 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-9c8fcffc | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:945 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-1825b1d7 | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:946 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-a3a6270a | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:947 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-a6442659 | ExcelButton [if (result == DialogResult.Yes) ▸ catch ((Excep… | SCP0078_GSCM_VOC.cs:949 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0078_GSCM_VOC.SetSaveStatus

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-032aab07 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0078_GSCM_VOC.cs:1815 |  | FLAG | save_status | status | 화면 필드/플래그 변경 |  |  |  |

## SCP0078_GSCM_VOC.SetSpreadColumn

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try ▸ if (dsBinding != null && dsBinding.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (dsBinding != null && dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7785a1f7 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2220 | for (iRow < siMain.ActiveSheet.RowCount) | UI_PROP | row.Height | 60 | 속성 Height 설정 |  |  |  |
| AC-5fc767f4 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2245 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | CALL_EXT | ScpUtils.CheckValueEqual | (focusValue, "RN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-75ecfb4c | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2247 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-ad21ae6d | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2248 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-593cfdac | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2257 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColDate].BackColor | Color.Gold | 그리드 속성/값 설정 |  |  |  |
| AC-c3898f13 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2265 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColDate].BackColor | Color.Yellow | 그리드 속성/값 설정 |  |  |  |
| AC-983b0530 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2269 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | Color.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-97563dee | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2270 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-b53f4d0f | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2273 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CLASSIFY_STAT… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | Color.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-b77ffb12 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2281 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.FILE_UPLOAD: | CALL_EXT | ScpUtils.CheckValueEqual | (focusValue, "Y") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eba0e6a0 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2283 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.FILE_UPLOAD: … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-24d0ac19 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2284 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.FILE_UPLOAD: … | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-6b6b315e | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2292 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CONFIRM_STATU… | CALL_EXT | ScpUtils.CheckValueEqual | (focusValue, "CN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0d14faa | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2294 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CONFIRM_STATU… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].BackColor | Color.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-e4a41922 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2297 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CONFIRM_STATU… | CALL_EXT | ScpUtils.CheckValueEqual | (focusValue, "RT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee9a664f | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2300 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case DefMain.CONFIRM_STATU… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |

## SCP0078_GSCM_VOC.SetSpreadInit

진입점: this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL)) ▸ if (DialogResult.OK == popup.ShowDialog(this)) ▸ try] / FindButton [try] / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tranResult == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20e160ef | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2182 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ef23171 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2194 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da3db989 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2195 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-0c50a7e1 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2199 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32bf645a | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2200 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-e86d0ad8 | this.spdMain.CellDoubleClick [if (!String.IsNullOrEmpty(VOC_… 외 2 | SCP0078_GSCM_VOC.cs:2203 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0078_GSCM_VOC.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-946fef11 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3547 | if (this.siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bbf330a6 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3583 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | new SCP0078_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0bc81ab5 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3585 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-a3d44912 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3586 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-02e0c1fb | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3587 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1e0c6822 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3589 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-2d1e18bc | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3591 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-822bb5f6 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3597 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.SCM_PI_USER_NAME), item.USER_NAME) | 그리드 값 설정 |  |  |  |
| AC-73c35d23 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3598 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.SCM_PI_USER_ID), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-d87150ea | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3607 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | new SCP0078_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0ae87edf | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3609 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-ad65e7d8 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3610 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-454ed5c5 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3611 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ced06f7 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3613 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-7fc9440e | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3615 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3ca5bf39 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3621 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_NAME), item.USER_NAME) | 그리드 값 설정 |  |  |  |
| AC-ee144126 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3622 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.SCM_SOLUTION_USER_ID), item.USER_ID) | 그리드 값 설정 |  |  |  |
| AC-73930aba | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3631 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | new SCP0078_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-38876937 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3633 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-e54ad37e | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3634 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-223dd10b | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3635 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5037583e | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3637 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-7e928ce0 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3639 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1cbc3634 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3645 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.REQUEST_USER_NAME), item.USER_NAME) | 그리드 값 설정 |  |  |  |
| AC-f59bcec3 | this.spdMain.CellDoubleClick | SCP0078_GSCM_VOC.cs:3646 | if (!String.IsNullOrEmpty(VOC_NO) && !e.ColumnHeader) ▸ else of (e.Column == siMain.GetColumnIndex(DefMain.VOC_DETAIL_VIEW) \|\| e.Column ==… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.REQUEST_USER_ID), item.USER_ID) | 그리드 값 설정 |  |  |  |

## SCP0078_GSCM_VOC.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d280520c | this.spdMain.EditChange | SCP0078_GSCM_VOC.cs:3704 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ i… | GRID_SET | siMain.SetText | (e.Row, e.Column, null) | 그리드 값 설정 |  |  |  |
| AC-091b20f3 | this.spdMain.EditChange | SCP0078_GSCM_VOC.cs:3709 | try | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fd78f57 | this.spdMain.EditChange | SCP0078_GSCM_VOC.cs:3717 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0078_GSCM_VOC.SpdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4962121c | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3503 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ i… | MESSAGE | MessageHelper.GMessageBox | ("MSG00394") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-900e2c2d | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3504 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.FINISH_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.TEST_STATUS) \|\| e.…) ▸ i… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f66508e | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3518 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) ▸ if (c… | MESSAGE | MessageHelper.GMessageBox | ("MSG00395") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68342e8b | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3519 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) ▸ if (c… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-075d4c3c | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3523 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) | FLAG | isAdminPI | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ab77aceb | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3524 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) | DATA_OP | UserGroup.Contains | ("PI") | 데이터 객체 조작/조회 |  |  |  |
| AC-58065279 | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3524 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) | DATA_OP | UserGroup.Contains | ("ADMIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-344a08d3 | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3526 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) ▸ if (U… | FLAG | isAdminPI | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4428bf23 | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3533 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) ▸ if (R… | MESSAGE | MessageHelper.GMessageBox | ("MSG00396") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55870833 | this.spdMain.EditorFocused | SCP0078_GSCM_VOC.cs:3534 | try ▸ if (e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_STATUS) \|\| e.Column == siMain.GetColumnIndex(DefMain.CONFIRM_OPINION)) ▸ if (R… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0078_GSCM_VOC.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ab92037 | this.spdMain.TopChange | SCP0078_GSCM_VOC.cs:3347 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0078_UserInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd98c77f | this.Load | SCP0078_UserInfoPopup.cs:115 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb00957f | this.Load | SCP0078_UserInfoPopup.cs:116 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bd19bcf1 | this.Load | SCP0078_UserInfoPopup.cs:117 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0078_UserInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48fff989 | this.Load | SCP0078_UserInfoPopup.cs:103 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-94be13ba | this.Load | SCP0078_UserInfoPopup.cs:108 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |
| AC-de07883e | this.Load | SCP0078_UserInfoPopup.cs:110 |  | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0078_UserInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f2c5513 | Dispose | SCP0078_UserInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0078_UserInfoPopup.FindData

진입점: this.Load [if (!string.IsNullOrEmpty(strSearch))] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6474f95b | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:153 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45b63531 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:157 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP") ⇒ SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-867a00ba | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:158 | lambda | DATA_OP | request.Parameters["Search"] | this.txtSearch.Text | 행/컬럼 값 대입 |  |  |  |
| AC-4f08cdcc | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:159 | lambda | DATA_OP | request.Parameters["Language"] | Language | 행/컬럼 값 대입 |  |  |  |
| AC-f0d504b4 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:160 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e971892 | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:162 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-706133ef | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:166 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-133a12ab | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:167 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a47b5d7e | this.Load [if (!string.IsNullOrEmpty(strSearch))] 외 2 | SCP0078_UserInfoPopup.cs:170 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0078_UserInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf9605be | this.Load | SCP0078_UserInfoPopup.cs:82 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fa326c0d | this.Load | SCP0078_UserInfoPopup.cs:88 | if (!string.IsNullOrEmpty(strSearch)) | VALUE_SET | this.txtSearch.Text | strSearch | 컨트롤 값 설정 |  |  |  |

## SCP0078_UserInfoPopup.InitSpread

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c494280 | this.Load 외 2 | SCP0078_UserInfoPopup.cs:124 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-35d130c0 | this.Load 외 2 | SCP0078_UserInfoPopup.cs:126 |  | GRID_INIT | siMain.AddTextColumn | ("UserID", DefColumns.USER_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e73c422 | this.Load 외 2 | SCP0078_UserInfoPopup.cs:127 |  | GRID_INIT | siMain.AddTextColumn | ("UserName", DefColumns.USER_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac9a01f0 | this.Load 외 2 | SCP0078_UserInfoPopup.cs:128 |  | GRID_INIT | siMain.AddTextColumn | ("EnglishName", DefColumns.USER_NAME_EN, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19a0c4ae | this.Load 외 2 | SCP0078_UserInfoPopup.cs:129 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_ID", DefColumns.DEPT_ID, FPMerge.None, 100, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d09f8775 | this.Load 외 2 | SCP0078_UserInfoPopup.cs:130 |  | GRID_INIT | siMain.AddTextColumn | ("Dept_Name", DefColumns.DEPT_NAME, FPMerge.None, 240, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d83723a | this.Load 외 2 | SCP0078_UserInfoPopup.cs:131 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.USER_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0078_UserInfoPopup.OkButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5713707 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0078_UserInfoPopup.cs:223 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.USE… | 데이터 객체 조작/조회 |  |  |  |
| AC-1ebac63c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0078_UserInfoPopup.cs:238 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-0b759607 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0078_UserInfoPopup.cs:241 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0078_UserInfoPopup.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66e39a0c | this.spdMain.CellClick | SCP0078_UserInfoPopup.cs:200 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-9662e640 | this.spdMain.CellClick | SCP0078_UserInfoPopup.cs:201 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab5f5694 | this.spdMain.CellClick | SCP0078_UserInfoPopup.cs:205 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.SetValue | (iRow, e.Column, true) | 그리드 값 설정 |  |  |  |
| AC-839c51be | this.spdMain.CellClick | SCP0078_UserInfoPopup.cs:206 | if (siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ▸ if (siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |

## SCP0078_UserInfoPopup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e256da7b | spdMain.CellDoubleClick | SCP0078_UserInfoPopup.cs:248 |  | DATA_OP | lstUserInfo.Add | (new SelectedUserInfo() { USER_ID = siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns… | 데이터 객체 조작/조회 |  |  |  |
| AC-2af403f3 | spdMain.CellDoubleClick | SCP0078_UserInfoPopup.cs:262 |  | FLAG | SelectedUserInfoList | lstUserInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-01a72cb4 | spdMain.CellDoubleClick | SCP0078_UserInfoPopup.cs:265 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## WebClientWithResponse.GetWebResponse

진입점: GetWebResponse

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af8a8cdc | GetWebResponse | SCP0078_FileUpload.cs:1571 | if (httpResponse != null) | CALL_EXT | httpResponse.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a6c8ea1 | GetWebResponse | SCP0078_FileUpload.cs:1575 | if (httpResponse != null) | CALL_EXT | stream.CopyTo | (ms) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b238e2f | GetWebResponse | SCP0078_FileUpload.cs:1576 | if (httpResponse != null) | FLAG | Response | ms.ToArray() | 화면 필드/플래그 변경 |  |  |  |
| AC-403d4f71 | GetWebResponse | SCP0078_FileUpload.cs:1580 |  | RETURN | return response; |  | 처리 중단/반환 |  |  |  |

