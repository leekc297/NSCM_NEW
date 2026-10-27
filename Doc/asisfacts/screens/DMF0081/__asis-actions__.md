# AS-IS 액션 대조표 — DMF0081

> 원천: `Doc/asisfacts/screens/DMF0081/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1500행 · 메서드 113 · 종류 DATA_OP 312 · GRID_SET 197 · FLAG 150 · RETURN 109 · GRID_LOCK 100 · UI_PROP 92 · GRID_INIT 89 · ENDPOINT 77 · CALL_EXT 61 · MESSAGE 50 · COMBO_DATA 50 · GRID_COMBO 42 · POPUP 35 · STATE 34 · LIST_REBIND 30 · UI_MISC 21 · VALUE_SET 21 · GRID_STYLE 15 · GRID_BIND 5 · VALUE_CLEAR 5 · STATE_RESET 4 · THROW 1 · ⚠ 의미 확인 필요 61


## DMF0081_CustDemandAnalysis.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4a8deda | this.btnButtonList.UsrButtonList_Click_Detected | DMF0081_CustDemandAnalysis.cs:234 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-fcb9d94d | this.btnButtonList.UsrButtonList_Click_Detected | DMF0081_CustDemandAnalysis.cs:235 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0081_CustDemandAnalysis.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42e707d1 | this.Load | DMF0081_CustDemandAnalysis.cs:200 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b16c937b | this.Load | DMF0081_CustDemandAnalysis.cs:201 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6b11909 | this.Load | DMF0081_CustDemandAnalysis.cs:202 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_CustDemandAnalysis.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20c2bf52 | Dispose | DMF0081_CustDemandAnalysis.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0081_CustDemandAnalysis.DMF0081_CustDemandAnalysis_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8e02241 | this.FormClosing | DMF0081_CustDemandAnalysis.cs:1167 |  | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |

## DMF0081_CustDemandAnalysis.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa3dbfeb | EditButton | DMF0081_CustDemandAnalysis.cs:260 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_CustDemandAnalysis.FileDownLoad

진입점: this.btnManual.Click / HelpButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e028891a | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1467 |  | CALL_EXT | System.Net.WebRequest.Create | (sUrl) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d41df046 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1483 | try | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0260dc11 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1484 | try | CALL_EXT | result.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2b617823 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1489 | try | CALL_EXT | ReceiveStream.Read | (buffer, 0, buffer.Length - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5c38350b | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1491 | try ▸ while ((read = ReceiveStream.Read(buffer, 0, buffer.Length - 1)) > 0) | CALL_EXT | fs.Write | (buffer, 0, read) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d89f9545 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1494 | try | CALL_EXT | System.Diagnostics.Process.Start | (Application.StartupPath + "\\" + sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b994cc57 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1537 | finally ▸ if (fs != null) | UI_MISC | fs.Close | () | 창 닫기/해제 |  |  |  |
| AC-be4474eb | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1538 | finally ▸ if (ReceiveStream != null) | UI_MISC | ReceiveStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-7a372ebb | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1539 | finally ▸ if (result != null) | CALL_EXT | request.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8ead35d2 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1540 | finally ▸ if (request != null) | CALL_EXT | request.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0854444 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1547 | if (bSuccess == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00132", new object[] { sFileName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0081_CustDemandAnalysis.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad296357 | this.Load | DMF0081_CustDemandAnalysis.cs:111 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-925349f6 | this.Load | DMF0081_CustDemandAnalysis.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c508b0aa | this.Load | DMF0081_CustDemandAnalysis.cs:123 | if (_POPUP_STATUS != "MODIFY") | DATA_OP | list.Add | (ButtonListType.Save) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff8386b4 | this.Load | DMF0081_CustDemandAnalysis.cs:124 | if (_POPUP_STATUS != "MODIFY") | CALL_EXT | btnButtonList.Set_ButtonVisibleFalse | (list) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46d1fd7e | this.Load | DMF0081_CustDemandAnalysis.cs:131 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-a7139bd0 | this.Load | DMF0081_CustDemandAnalysis.cs:132 |  | FLAG | _END_CUSTOMER | END_CUSTOMER | 화면 필드/플래그 변경 |  |  |  |
| AC-da518ae1 | this.Load | DMF0081_CustDemandAnalysis.cs:133 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-1b31ae09 | this.Load | DMF0081_CustDemandAnalysis.cs:134 |  | FLAG | _YYYYMM | YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-60ebd1fc | this.Load | DMF0081_CustDemandAnalysis.cs:135 |  | FLAG | _MKT_FCST | MKT_FCST | 화면 필드/플래그 변경 |  |  |  |
| AC-6075a15e | this.Load | DMF0081_CustDemandAnalysis.cs:136 |  | FLAG | _MEASURE | MEASURE | 화면 필드/플래그 변경 |  |  |  |
| AC-42e2b320 | this.Load | DMF0081_CustDemandAnalysis.cs:142 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-5deac84c | this.Load | DMF0081_CustDemandAnalysis.cs:143 |  | FLAG | _END_CUSTOMER | END_CUSTOMER | 화면 필드/플래그 변경 |  |  |  |
| AC-fe226c86 | this.Load | DMF0081_CustDemandAnalysis.cs:144 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-21a1323a | this.Load | DMF0081_CustDemandAnalysis.cs:145 |  | FLAG | _YYYYMM | YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-b6875af0 | this.Load | DMF0081_CustDemandAnalysis.cs:146 |  | FLAG | _EDI_QTY | EDI_QTY | 화면 필드/플래그 변경 |  |  |  |
| AC-fa1faed1 | this.Load | DMF0081_CustDemandAnalysis.cs:147 |  | FLAG | _MKT_FCST | MKT_FCST | 화면 필드/플래그 변경 |  |  |  |
| AC-900afb91 | this.Load | DMF0081_CustDemandAnalysis.cs:148 |  | FLAG | _MEASURE | MEASURE | 화면 필드/플래그 변경 |  |  |  |
| AC-e84bf8ca | this.Load | DMF0081_CustDemandAnalysis.cs:153 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-9376cf9e | this.Load | DMF0081_CustDemandAnalysis.cs:154 |  | FLAG | _END_CUSTOMER | END_CUSTOMER | 화면 필드/플래그 변경 |  |  |  |
| AC-74a0d57a | this.Load | DMF0081_CustDemandAnalysis.cs:155 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-041b7a43 | this.Load | DMF0081_CustDemandAnalysis.cs:156 |  | FLAG | _YYYYMM | YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-db3af1e6 | this.Load | DMF0081_CustDemandAnalysis.cs:157 |  | FLAG | _EDI_QTY | EDI_QTY | 화면 필드/플래그 변경 |  |  |  |
| AC-6cde0e0f | this.Load | DMF0081_CustDemandAnalysis.cs:158 |  | FLAG | _MKT_FCST | MKT_FCST | 화면 필드/플래그 변경 |  |  |  |
| AC-11308784 | this.Load | DMF0081_CustDemandAnalysis.cs:159 |  | FLAG | _MEASURE | MEASURE | 화면 필드/플래그 변경 |  |  |  |
| AC-dd8c7c51 | this.Load | DMF0081_CustDemandAnalysis.cs:160 |  | FLAG | _FWEEK | FIRSTWEEK | 화면 필드/플래그 변경 |  |  |  |
| AC-aaa4a0fb | this.Load | DMF0081_CustDemandAnalysis.cs:165 |  | FLAG | _DIVISION_ID | DIVISION_ID | 화면 필드/플래그 변경 |  |  |  |
| AC-834d453b | this.Load | DMF0081_CustDemandAnalysis.cs:166 |  | FLAG | _END_CUSTOMER | END_CUSTOMER | 화면 필드/플래그 변경 |  |  |  |
| AC-7b148032 | this.Load | DMF0081_CustDemandAnalysis.cs:167 |  | FLAG | _PROJECT_CODE | PROJECT_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-13ab9dc2 | this.Load | DMF0081_CustDemandAnalysis.cs:168 |  | FLAG | _YYYYMM | YYYYMM | 화면 필드/플래그 변경 |  |  |  |
| AC-4dbf9083 | this.Load | DMF0081_CustDemandAnalysis.cs:169 |  | FLAG | _EDI_QTY | EDI_QTY | 화면 필드/플래그 변경 |  |  |  |
| AC-d2cbea61 | this.Load | DMF0081_CustDemandAnalysis.cs:170 |  | FLAG | _MKT_FCST | MKT_FCST | 화면 필드/플래그 변경 |  |  |  |
| AC-92cd1137 | this.Load | DMF0081_CustDemandAnalysis.cs:171 |  | FLAG | _MEASURE | MEASURE | 화면 필드/플래그 변경 |  |  |  |
| AC-1aa36f41 | this.Load | DMF0081_CustDemandAnalysis.cs:172 |  | FLAG | _FWEEK | FIRSTWEEK | 화면 필드/플래그 변경 |  |  |  |
| AC-6022c72b | this.Load | DMF0081_CustDemandAnalysis.cs:173 |  | FLAG | _POPUP_STATUS | POPUP_STATUS | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_CustDemandAnalysis.GetDM_DEMAND_GAP_ANL_CD

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / this.spdMain.LeaveCell [if (sActiveCell_Status == "CHANGED")] / this.spdMain.CellClick [if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD")] / this.spdMain.EditChange [if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD")] / this.Load / SaveButton [if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b432f81 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1193 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-d04b1b14 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1194 |  | DATA_OP | request.Parameters["CODE"] | "DM_DEMAND_GAP_ANL_CD" | 행/컬럼 값 대입 |  |  |  |
| AC-f09f7bdc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1195 |  | DATA_OP | request.Parameters["PARAM1"] | p_param1 | 행/컬럼 값 대입 |  |  |  |
| AC-f84a3478 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1196 |  | DATA_OP | request.Parameters["PARAM2"] | p_param2 | 행/컬럼 값 대입 |  |  |  |
| AC-dea125ae | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1197 |  | DATA_OP | request.Parameters["PARAM3"] | p_param3 | 행/컬럼 값 대입 |  |  |  |
| AC-74f9e059 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1198 |  | DATA_OP | request.Parameters["PARAM4"] | p_param4 | 행/컬럼 값 대입 |  |  |  |
| AC-6c981a78 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1199 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7d573850 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1200 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-821e35aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 6 | DMF0081_CustDemandAnalysis.cs:1202 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_CustDemandAnalysis.GetSLOC

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46abdda9 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:674 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-d771dbda | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:675 |  | DATA_OP | request.Parameters["CODE"] | "PR_SLOC" | 행/컬럼 값 대입 |  |  |  |
| AC-41348146 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:676 |  | DATA_OP | request.Parameters["PARAM1"] | SPlant | 행/컬럼 값 대입 |  |  |  |
| AC-887e9ba9 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:677 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-482a7052 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:678 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c0926b9b | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:679 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e79ed6a1 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:680 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e8c7a5be | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:681 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bd39dba8 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:683 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_CustDemandAnalysis.GetSpdTitle_PSI_POPUP

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d806c33 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1176 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_SPREAD_TITLE_PSI_POPUP") ⇒ DM.DMF0081_GET_SPREAD_TITLE_PSI_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-07e54e28 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1178 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | _YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-b86d4435 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1179 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | _YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-ff8f4ee4 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1180 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-586dc0a4 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1181 |  | DATA_OP | request.Parameters["p_division_id"] | _DIVISION_ID.Substring(0,2) | 행/컬럼 값 대입 |  |  |  |
| AC-fbd9fa77 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1183 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-36ab3e34 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:1183 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0081_CustDemandAnalysis.GetSPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b87bb4b1 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:656 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-4fd9ef69 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:657 |  | DATA_OP | request.Parameters["CODE"] | "PR_SPLANT" | 행/컬럼 값 대입 |  |  |  |
| AC-02006b82 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:658 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-abe0c9ac | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:659 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-efb77711 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:660 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0a640713 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:661 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0158577b | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:662 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5957ead0 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:663 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8674b33a | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:665 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_CustDemandAnalysis.GetSplit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58b43b22 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:618 |  | RETURN | return sar.Split('^'); |  | 처리 중단/반환 |  |  |  |

## DMF0081_CustDemandAnalysis.HelpButton

진입점: this.btnManual.Click / HelpButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c62e5c9 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1457 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpServer | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-18f589c4 | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1458 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpPort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e50520d | this.btnManual.Click 외 1 | DMF0081_CustDemandAnalysis.cs:1459 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpPath | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_CustDemandAnalysis.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17e156be | this.Load | DMF0081_CustDemandAnalysis.cs:187 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-f5e3619b | this.Load | DMF0081_CustDemandAnalysis.cs:188 |  | VALUE_SET | usrLabel2.Text | "※" + " " + this._YYYYMM + " " + this._MEASURE | 컨트롤 값 설정 |  |  |  |
| AC-967e5be0 | this.Load | DMF0081_CustDemandAnalysis.cs:189 |  | UI_PROP | usrLabel2.TextAlign | ContentAlignment.MiddleLeft | 속성 TextAlign 설정 |  |  |  |

## DMF0081_CustDemandAnalysis.InitSpread

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b57ec0c8 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:213 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-208b2a79 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:217 | if (dtTitle != null && dtTitle.Rows.Count > 0) | DATA_OP | _DIVISION_ID.Contains | ("81") | 데이터 객체 조작/조회 |  |  |  |
| AC-29452993 | this.Load [try] | DMF0081_CustDemandAnalysis.cs:221 | if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_CustDemandAnalysis.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b13a6888 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:343 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck != "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00440") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57c3b411 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:344 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d737486c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:382 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck != "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00441") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc868c63 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:383 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck != "SUCCESS") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fff22037 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:390 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtDL_ALL | GetDM_DEMAND_GAP_ANL_CD("ALL", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-a859ddfe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:408 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iTempChange… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vREQ_RSN_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5fa9a03c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:412 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iTempChange… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vDIF_ANLS_TP_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e4eb3b68 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:416 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iTempChange… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vANLS_DIF_RSN_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe7027f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:419 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iTempChange… | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD("VALIDATION_CHECK", vParam1, vParam2, vParam3) | 화면 필드/플래그 변경 |  |  |  |
| AC-0fe4f6b8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:443 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (iTempChange… | DATA_OP | sList.Add | (vParam1 + vParam2 + vParam3 + vREQ_RSN_DTL_CTN) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaac82aa | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:453 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck == "LOOKUP_FAIL") | MESSAGE | MessageHelper.GMessageBox | ("MSG00442") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71d616e0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:454 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck == "LOOKUP_FAIL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7896435 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:460 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck == "DESC_FAIL") | MESSAGE | MessageHelper.GMessageBox | ("MSG00444") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-212a8279 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:461 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sValidationCheck == "DESC_FAIL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-02311bc6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:467 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sList.Count() != sList.Distinct().Count()) | MESSAGE | MessageHelper.GMessageBox | ("MSG00443") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ff8de2fd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:468 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sList.Count() != sList.Distinct().Count()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e674ed53 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:474 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6a447145 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:479 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (confirmResult != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49def08f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:494 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-55f3d99c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:495 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | UI_PROP | request.CommandTimeout | 1000 * 1000 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c476e7b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:497 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-836beb17 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:498 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEND_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-24640fa0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:499 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-0b8c0447 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:500 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMEASUE | 행/컬럼 값 대입 |  |  |  |
| AC-dfa27547 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:501 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_yyyymm"] | sYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-6f181ec4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:503 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_req_rsn_cd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8a83d797 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:504 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_dif_anls_tp_cd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc9319a2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:505 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_anls_dif_rsn_cd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e6179367 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:506 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_req_rsn_dtl_ctn"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-68a3bd76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:507 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_qty"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-66927198 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:508 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6cdfd17c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:510 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | DATA_OP | request.Parameters["p_procedure_type"] | sPROCEDURE_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-8ccce24e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:512 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfc1004f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:517 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-151a7664 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:518 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-239fb806 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:532 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vREQ_RSN_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-09f59ec8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:536 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vDIF_ANLS_TP_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-07b0cbc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:540 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + vANLS_DIF_RSN_CD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-07f882b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:556 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0081_SAVE_CUST_DEMAND_ANL_DETAIL_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-f6cede6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:557 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | UI_PROP | request.CommandTimeout | 1000 * 1000 | 속성 CommandTimeout 설정 |  |  |  |
| AC-36d3d278 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:559 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-236a3a80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:560 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEND_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-0a83a1e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:561 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-e3a513de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:562 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMEASUE | 행/컬럼 값 대입 |  |  |  |
| AC-fedc6d6f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:563 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_yyyymm"] | sYYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-ea4cb534 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:565 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_req_rsn_cd"] | p_req_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-2401c849 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:566 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_dif_anls_tp_cd"] | p_dif_anls_tp_cd | 행/컬럼 값 대입 |  |  |  |
| AC-5463a476 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:567 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_anls_dif_rsn_cd"] | p_anls_dif_rsn_cd | 행/컬럼 값 대입 |  |  |  |
| AC-f7189c83 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:568 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_req_rsn_dtl_ctn"] | p_req_rsn_dtl_ctn | 행/컬럼 값 대입 |  |  |  |
| AC-6a762b29 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:569 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1278de1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:570 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-584ec2a8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:572 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | DATA_OP | request.Parameters["p_procedure_type"] | sPROCEDURE_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-9265b2fc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:574 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c3d8e65 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:579 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Excepti… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eea112c8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:580 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Excepti… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-027708b4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:588 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | this.IsChange | false | 속성 IsChange 설정 |  |  |  |
| AC-d48c8d1b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:589 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-114e09e6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | DMF0081_CustDemandAnalysis.cs:590 | if (siMain != null) ▸ if (siMain != null) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0081_CustDemandAnalysis.Select_Calculate_Demand

진입점: this.spdMain.LeaveCell / this.spdMain.KeyUp / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f0b527b | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:965 | for (i <= siMain.GetMaxRowIndex()) ▸ if (string.IsNullOrEmpty(siMain.GetText(i, siMain.GetColumnIndex(DefColumns.CHANGE_QTY)))) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.CHANGE_QTY), "0") | 그리드 값 설정 |  |  |  |
| AC-73e00622 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:975 | for (i <= siMain.GetMaxRowIndex()) ▸ if (i == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.RESULT), sResult) | 그리드 값 설정 |  |  |  |
| AC-0fde8f34 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:979 | for (i <= siMain.GetMaxRowIndex()) ▸ if (i == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.GAP), sGap) | 그리드 값 설정 |  |  |  |
| AC-44cabea3 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:981 | for (i <= siMain.GetMaxRowIndex()) ▸ if (i == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-87bdb3d6 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:982 | for (i <= siMain.GetMaxRowIndex()) ▸ if (i == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-5202de9f | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:992 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ if (iChangeQTY == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.RESULT), "0") | 그리드 값 설정 |  |  |  |
| AC-e52518eb | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:993 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ if (iChangeQTY == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.GAP), "0") | 그리드 값 설정 |  |  |  |
| AC-561d5d40 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:1002 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ else of (iChangeQTY == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.RESULT), sResult) | 그리드 값 설정 |  |  |  |
| AC-7ca67a51 | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:1006 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ else of (iChangeQTY == 0) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.GAP), sGap) | 그리드 값 설정 |  |  |  |
| AC-7f00493d | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:1008 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ else of (iChangeQTY == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.RESULT)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-1fae9d4d | this.spdMain.LeaveCell 외 2 | DMF0081_CustDemandAnalysis.cs:1009 | for (i <= siMain.GetMaxRowIndex()) ▸ else of (i == 0) ▸ else of (iChangeQTY == 0) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |

## DMF0081_CustDemandAnalysis.Select_Data

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0895053e | this.Load | DMF0081_CustDemandAnalysis.cs:846 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-836adeae | this.Load | DMF0081_CustDemandAnalysis.cs:849 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0195913 | this.Load | DMF0081_CustDemandAnalysis.cs:853 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP") ⇒ DM.DMF0081_GET_CUST_DEMAND_ANL_DETAIL_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-d809b7e3 | this.Load | DMF0081_CustDemandAnalysis.cs:855 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | _DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-a50af41b | this.Load | DMF0081_CustDemandAnalysis.cs:856 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | _END_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-f2caf3ca | this.Load | DMF0081_CustDemandAnalysis.cs:857 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | _PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-4c830f13 | this.Load | DMF0081_CustDemandAnalysis.cs:858 | try ▸ lambda | DATA_OP | request.Parameters["p_measure"] | this._MEASURE.ToUpper() == "Demand Plan (1st)".ToUpper() ? "MKT_FCST_FST" : "MKT_FCST_FNL" | 행/컬럼 값 대입 |  |  |  |
| AC-c24b46aa | this.Load | DMF0081_CustDemandAnalysis.cs:859 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyymm"] | _YYYYMM | 행/컬럼 값 대입 |  |  |  |
| AC-4aa85af2 | this.Load | DMF0081_CustDemandAnalysis.cs:860 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8eb86a1d | this.Load | DMF0081_CustDemandAnalysis.cs:862 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aa36c603 | this.Load | DMF0081_CustDemandAnalysis.cs:864 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-18d13436 | this.Load | DMF0081_CustDemandAnalysis.cs:868 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-73a8980a | this.Load | DMF0081_CustDemandAnalysis.cs:872 | try ▸ if (ds != null) | FLAG | dtSave | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-8cc6b784 | this.Load | DMF0081_CustDemandAnalysis.cs:884 | try ▸ if (ds != null) ▸ for (i < 5) | DATA_OP | dt.Rows.Add | (new object[] { _DIVISION_ID, _END_CUSTOMER, _PROJECT_CODE, _MEASURE, _YYYYMM, int.Parse(_… | 데이터 객체 조작/조회 |  |  |  |
| AC-04658b17 | this.Load | DMF0081_CustDemandAnalysis.cs:887 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (dt.DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bda603c8 | this.Load | DMF0081_CustDemandAnalysis.cs:891 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a1d0b9f9 | this.Load | DMF0081_CustDemandAnalysis.cs:897 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4463cac | this.Load | DMF0081_CustDemandAnalysis.cs:901 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-224daf00 | this.Load | DMF0081_CustDemandAnalysis.cs:907 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.EDI_QTY), _EDI_QTY) | 그리드 값 설정 |  |  |  |
| AC-9a6f6498 | this.Load | DMF0081_CustDemandAnalysis.cs:908 | for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.MKT_DP), _MKT_FCST) | 그리드 값 설정 |  |  |  |
| AC-603b9d0a | this.Load | DMF0081_CustDemandAnalysis.cs:912 |  | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD("DEFAULT", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-8df1ea47 | this.Load | DMF0081_CustDemandAnalysis.cs:915 | for (i < 5) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3c9f52ed | this.Load | DMF0081_CustDemandAnalysis.cs:916 | for (i < 5) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-2115dfbc | this.Load | DMF0081_CustDemandAnalysis.cs:917 | for (i < 5) | GRID_COMBO | siMain.SetCellTypeCombo | (i, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4cbf2fb4 | this.Load | DMF0081_CustDemandAnalysis.cs:924 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-693c42ec | this.Load | DMF0081_CustDemandAnalysis.cs:928 | if (siMain.GetMaxRowIndex() > -1) | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.EDI_QTY)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-2774b89b | this.Load | DMF0081_CustDemandAnalysis.cs:929 | if (siMain.GetMaxRowIndex() > -1) | GRID_SET | siMain.ActiveSheet.Cells[0, siMain.GetColumnIndex(DefColumns.MKT_DP)].RowSpan | siMain.GetMaxRowIndex() + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-750374d6 | this.Load | DMF0081_CustDemandAnalysis.cs:934 | if (_POPUP_STATUS != "MODIFY") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EDI_QTY), siMain.GetColumnIndex(DefColumns.GAP), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c4ebee4 | this.Load | DMF0081_CustDemandAnalysis.cs:935 | if (_POPUP_STATUS != "MODIFY") | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (-1, -1) | 그리드 표시 설정 |  |  |  |
| AC-cc325af7 | this.Load | DMF0081_CustDemandAnalysis.cs:939 | else of (_POPUP_STATUS != "MODIFY") | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (-1, -1) | 그리드 표시 설정 |  |  |  |
| AC-58a56d92 | this.Load | DMF0081_CustDemandAnalysis.cs:942 | else of (_POPUP_STATUS != "MODIFY") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EDI_QTY), siMain.GetColumnIndex(DefColumns.EDI_QTY), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa861f19 | this.Load | DMF0081_CustDemandAnalysis.cs:943 | else of (_POPUP_STATUS != "MODIFY") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.RESULT), siMain.GetColumnIndex(DefColumns.RESULT), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f2bded8 | this.Load | DMF0081_CustDemandAnalysis.cs:944 | else of (_POPUP_STATUS != "MODIFY") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MKT_DP), siMain.GetColumnIndex(DefColumns.MKT_DP), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3bade26e | this.Load | DMF0081_CustDemandAnalysis.cs:945 | else of (_POPUP_STATUS != "MODIFY") | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.GAP), siMain.GetColumnIndex(DefColumns.GAP), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0081_CustDemandAnalysis.SET_CHANGE_QTY

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c990c2e | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1304 | if (siMain.GetColumnValue(_col) == "CHANGE_QTY" && string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE)) | FLAG | this.sOrignal_CHANGE_QTY_VALUE | siMain.GetText(_row, siMain.GetColumnIndex(DefColumns.CHANGE_QTY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e0dc6543 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1305 | if (siMain.GetColumnValue(_col) == "CHANGE_QTY" && string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE)) | FLAG | this.sOrignal_CHANGE_QTY_ROW | _row | 화면 필드/플래그 변경 |  |  |  |
| AC-0ae2e301 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1306 | if (siMain.GetColumnValue(_col) == "CHANGE_QTY" && string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE)) | FLAG | this.sOrignal_CHANGE_QTY_COLUMN | _col | 화면 필드/플래그 변경 |  |  |  |
| AC-fbba83fd | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1322 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-83a1a56f | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1327 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) ▸ if (dtDL !=… | GRID_COMBO | siMain.SetCellTypeCombo | (sOrignal_CHANGE_QTY_ROW, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cd8dc9e7 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1328 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) ▸ if (dtDL !=… | GRID_SET | siMain.SetText | (sOrignal_CHANGE_QTY_ROW, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), "") | 그리드 값 설정 |  |  |  |
| AC-76e70c17 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1329 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) ▸ if (dtDL !=… | GRID_SET | siMain.SetText | (sOrignal_CHANGE_QTY_ROW, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), "") | 그리드 값 설정 |  |  |  |
| AC-c843d37d | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1330 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) ▸ if (dtDL !=… | CALL_EXT | siMain.SetHAlign | (sOrignal_CHANGE_QTY_ROW, _col, sOrignal_CHANGE_QTY_ROW, _col, FarPoint.Win.Spread.CellHor… | ⚠ 의미 확인 필요 |  |  |  |
| AC-314ad58b | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1334 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) //현재 값이 있고 && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrig…) ▸ if (dtDL !=… | GRID_SET | siMain.SetText | (sOrignal_CHANGE_QTY_ROW, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), ori_REQ_RSN_CD) | 그리드 값 설정 |  |  |  |
| AC-35364d93 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1343 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrignal_CHANGE_…) | FLAG | this.sOrignal_CHANGE_QTY_VALUE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-9610f48d | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1344 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrignal_CHANGE_…) | FLAG | this.sOrignal_CHANGE_QTY_ROW | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-12c025dc | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:1345 | if (!string.IsNullOrEmpty(this.sOrignal_CHANGE_QTY_VALUE) && this.sOrignal_CHANGE_QTY_ROW.ToString() + this.sOrignal_CHANGE_…) | FLAG | this.sOrignal_CHANGE_QTY_COLUMN | 0 | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_CustDemandAnalysis.SetSpreadHeaderSpan

진입점: this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (_DIVISION_ID.Contains("81"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d86ec76 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:709 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 1, 2, 2, 20, this._MEASURE, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3692629c | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:712 | if (this._MEASURE.ToUpper() == "Demand Plan (1st)".ToUpper()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, 3, 1, 1, 20, "1st Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45ae3cc0 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:717 | if (this._MEASURE.ToUpper() == "Demand Plan (Final)".ToUpper()) | GRID_INIT | siMain.ColumnHeaderSpan | (0, 3, 1, 1, 20, "Final Plan", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f45eeaeb | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:724 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.EDI_QTY) , 1, 1, 20, date.ToString("MMM-dd", culture)… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-834bfe80 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:725 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.CHANGE_QTY) , 1, 5, 20, "Detailed input by factors" ,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-916fd3c2 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:726 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD) , 1, 1, 20, "Level 1" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-618713b7 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:727 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD) , 1, 1, 20, "Level 2" , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e301e9f | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:728 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), 1, 1, 20, "Level 3" , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ea39e7a | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:729 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefColumns.REQ_RSN_DTL_CTN), 1, 1, 20, "Level 4" , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e460465 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:730 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.RESULT) , 3, 1, 20, "ⓒ Result (ⓐ+ⓑ)" , FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15f16a74 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:731 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MKT_DP) , 3, 1, 20, "ⓓ MKT.FCST (DP)" , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-798b97d1 | this.Load [try ▸ if (dtTitle != null && dtTitle.Rows.Count >… | DMF0081_CustDemandAnalysis.cs:732 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.GAP) , 3, 1, 20, "GAP (ⓒ-ⓓ)" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_CustDemandAnalysis.sheetSetting

진입점: this.Load [if (_POPUP_STATUS == "MODIFY")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15d85566 | this.Load [if (_POPUP_STATUS == "MODIFY")] | DMF0081_CustDemandAnalysis.cs:1021 | for (i <= siMain.GetMaxRowIndex()) ▸ for (j < siMain.GetColumnIndex(DefColumns.REQ_RSN_DTL_CTN) + 1) | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |

## DMF0081_CustDemandAnalysis.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-600d586d | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:747 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.Items | (new String[] { "수요" }) | 속성 Items 설정 |  |  |  |
| AC-21af5629 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:748 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-934459eb | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:749 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-1a86597b | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:750 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-a9d99885 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:754 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (cboText == "고객") ▸ for (i <= siMain.GetMaxRowIndex()) | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-608d1fa4 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:762 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.Items | (new String[] { "운영" }) | 속성 Items 설정 |  |  |  |
| AC-6b7e18a3 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:763 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-d0a2cbf8 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:764 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | STATE | cmbDemandOperation.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-02c2d2fa | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:765 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") | UI_PROP | cmbDemandOperation.MaxDrop | 2 | 속성 MaxDrop 설정 |  |  |  |
| AC-fc170379 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:769 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ else of (cboText == "고객") ▸ if (cboText == "당사") ▸ for (i <= siMain.GetMaxRowIn… | GRID_SET | siMain.ActiveSheet.Cells[i, 7].CellType | cmbDemandOperation | 그리드 속성/값 설정 |  |  |  |
| AC-4ecea46c | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:774 | if (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b808fa17 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:782 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.Items | (new String[] { "차량생산", "차량판매", "물류이슈" }) | 속성 Items 설정 |  |  |  |
| AC-dc306e6f | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:783 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-878e4471 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:784 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-fdba7e16 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:785 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-8ceef5ae | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:789 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ if (cboText =… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-b4d90c27 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:797 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.Items | (new String[] { "시점조정", "모델믹스" }) | 속성 Items 설정 |  |  |  |
| AC-136734af | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:798 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.AutoSearch | FarPoint.Win.AutoSearch.SingleCharacter | 속성 AutoSearch 설정 |  |  |  |
| AC-c35ffa76 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:799 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | STATE | cmbVariationFactor.Editable | true | 컨트롤 상태 Editable |  |  |  |
| AC-5eac3b4e | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:800 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | UI_PROP | cmbVariationFactor.MaxDrop | 5 | 속성 MaxDrop 설정 |  |  |  |
| AC-f7b89f24 | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:804 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") ▸ else of (cboT… | GRID_SET | siMain.ActiveSheet.Cells[i, 8].CellType | cmbVariationFactor | 그리드 속성/값 설정 |  |  |  |
| AC-410befea | (진입점 미연결) | DMF0081_CustDemandAnalysis.cs:809 | else of (siMain.GetColumnValue(e.Column) == "DEMAND_OPERATION") ▸ if (siMain.GetColumnValue(e.Column) == "VARIATION_FACTOR") | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_CustDemandAnalysis.spdMain_CellClick_1

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d95abf78 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1221 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-e603b5e3 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1226 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a36622c0 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1229 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dc97eb9 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1233 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) ▸ if (ori_R… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), ori_REQ_RSN_CD) | 그리드 값 설정 |  |  |  |
| AC-a99c786c | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1239 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | FLAG | dtDL_ALL | GetDM_DEMAND_GAP_ANL_CD("ALL", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-97fde1d3 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1242 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + sTemp + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c86b59dd | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1245 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, sParam2, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-b85fb492 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1251 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | FLAG | dtDL | dtDL.Select("CODE <>" + "'" + "SUPPLY" + "'").CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-568d5142 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1251 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | DATA_OP | dtDL.Select("CODE <>" + "'" + "SUPPLY" + "'").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9d35c9b | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1251 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | DATA_OP | dtDL.Select | ("CODE <>" + "'" + "SUPPLY" + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-f18be04e | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1255 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0dd52496 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1257 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f644a8b | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1261 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), ori_DIF_ANLS_TP_CD) | 그리드 값 설정 |  |  |  |
| AC-01d43059 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1267 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | FLAG | dtDL_ALL | GetDM_DEMAND_GAP_ANL_CD("ALL", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-9f27e5b3 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1270 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + sTemp + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-b78bf962 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1274 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + sTemp + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-47bf333f | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1277 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, sParam2, sParam3, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-436476e2 | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1283 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-23a0775f | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1284 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a2dd4be | this.spdMain.CellClick | DMF0081_CustDemandAnalysis.cs:1288 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), ori_ANLS_DIF_RSN_CD) | 그리드 값 설정 |  |  |  |

## DMF0081_CustDemandAnalysis.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00aecdc1 | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1374 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-30afd5c5 | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1378 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), "") | 그리드 값 설정 |  |  |  |
| AC-67ab616d | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1379 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), "") | 그리드 값 설정 |  |  |  |
| AC-f1a42bfb | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1380 | if (_POPUP_STATUS == "MODIFY") ▸ if (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ba32575f | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1386 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | FLAG | dtDL_ALL | GetDM_DEMAND_GAP_ANL_CD("ALL", "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-4d102ece | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1389 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | DATA_OP | dtDL_ALL.Select | ("NAME =" + "'" + sTemp + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5920e322 | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1392 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, sParam2, "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-2b0ce49e | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1397 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), "") | 그리드 값 설정 |  |  |  |
| AC-e267a1aa | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1398 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ if (siMain.GetColumnValue(e.Column) == "DIF_ANL… | CALL_EXT | siMain.SetHAlign | (e.Row, e.Column, e.Row, e.Column, FarPoint.Win.Spread.CellHorizontalAlignment.Center) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb597f10 | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1411 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | FLAG | this.sActiveCell_Status | "CHANGED" | 화면 필드/플래그 변경 |  |  |  |
| AC-95954fd2 | this.spdMain.EditChange | DMF0081_CustDemandAnalysis.cs:1416 | if (_POPUP_STATUS == "MODIFY") ▸ else of (siMain.GetColumnValue(e.Column) == "REQ_RSN_CD") ▸ else of (siMain.GetColumnValue(e.Column) == "DI… | FLAG | this.sActiveCell_Status | "" | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_CustDemandAnalysis.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4bd7ca | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1049 | if (sActiveCell_Status == "CHANGED") | FLAG | dtDL | GetDM_DEMAND_GAP_ANL_CD(sParam1, "", "", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-313260df | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1054 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), dtDL) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-6bad7e91 | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1055 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.DIF_ANLS_TP_CD), "") | 그리드 값 설정 |  |  |  |
| AC-95dce6c8 | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1056 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ANLS_DIF_RSN_CD), "") | 그리드 값 설정 |  |  |  |
| AC-570e85a0 | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1057 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | CALL_EXT | siMain.SetHAlign | (e.Row, siMain.GetColumnIndex(DefColumns.CHANGE_QTY), e.Row, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1951a4e6 | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1058 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | CALL_EXT | siMain.SetHAlign | (e.Row, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), e.Row, siMain.GetColumnIndex(DefColu… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b4d7394 | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1062 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) ▸ if (ori_REQ_RSN_CD != null && ori_REQ_RSN_CD.Length > 0) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.REQ_RSN_CD), ori_REQ_RSN_CD) | 그리드 값 설정 |  |  |  |
| AC-154cacde | this.spdMain.LeaveCell | DMF0081_CustDemandAnalysis.cs:1064 | if (sActiveCell_Status == "CHANGED") ▸ if (dtDL != null && dtDL.Rows.Count > 0) | FLAG | sActiveCell_Status | "" | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_MktFcst_Auto.btnCalculation_Click

진입점: this.btnCalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b20b6d0e | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5559 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5beb0f54 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5560 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a94edbdb | this.btnColumn.Click | DMF0081_MktFcst_Auto.cs:3957 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0003", SpdSheet.shtMain, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-d3647b8d | this.btnColumn.Click | DMF0081_MktFcst_Auto.cs:3958 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50d50ab9 | this.btnColumn.Click | DMF0081_MktFcst_Auto.cs:3959 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef9331bd | this.btnExcelUpload.Click | DMF0081_MktFcst_Auto.cs:5547 |  | POPUP | new ExcelUploadForm | ("DMF0081", this.spdSub2.ActiveSheet.SheetName) | 팝업/폼 생성 |  |  |  |
| AC-b8e16c7d | this.btnExcelUpload.Click | DMF0081_MktFcst_Auto.cs:5548 |  | UI_PROP | frm.SaveExceptError | true | 속성 SaveExceptError 설정 |  |  |  |
| AC-bcda3731 | this.btnExcelUpload.Click | DMF0081_MktFcst_Auto.cs:5549 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-720b65d8 | this.btnExcelUpload.Click | DMF0081_MktFcst_Auto.cs:5550 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.btnIncotermsChg_Click

진입점: this.btnIncotermsChg.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b140269 | this.btnIncotermsChg.Click | DMF0081_MktFcst_Auto.cs:4668 |  | POPUP | new DMF0003_MatsterChgPopup | () | 팝업/폼 생성 |  |  |  |
| AC-aa464ed5 | this.btnIncotermsChg.Click | DMF0081_MktFcst_Auto.cs:4669 |  | POPUP | popAdjst.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-94224e47 | this.btnIncotermsChg.Click | DMF0081_MktFcst_Auto.cs:4671 |  | UI_PROP | popAdjst.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a5fbf61b | this.btnIncotermsChg.Click | DMF0081_MktFcst_Auto.cs:4672 |  | POPUP | popAdjst.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71e74f9b | this.btnItemId.Click | DMF0081_MktFcst_Auto.cs:3940 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-674d937f | this.btnItemId.Click | DMF0081_MktFcst_Auto.cs:3942 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-e9386b15 | this.btnItemId.Click | DMF0081_MktFcst_Auto.cs:3943 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d41999db | this.btnItemId.Click | DMF0081_MktFcst_Auto.cs:3944 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cafeaac4 | this.btnItemId.Click | DMF0081_MktFcst_Auto.cs:3950 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6f66a63 | this.btnMeasure.Click | DMF0081_MktFcst_Auto.cs:3969 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0003", SpdSheet.shtMain, false, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-c470c090 | this.btnMeasure.Click | DMF0081_MktFcst_Auto.cs:3971 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f54606e0 | this.btnMeasure.Click | DMF0081_MktFcst_Auto.cs:3972 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.btnOwner_Click

진입점: this.btnOwner.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38b5f84f | this.btnOwner.Click | DMF0081_MktFcst_Auto.cs:4686 |  | POPUP | new DM0020_OwnerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-400a93e5 | this.btnOwner.Click | DMF0081_MktFcst_Auto.cs:4689 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, sOwner) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f82747f0 | this.btnOwner.Click | DMF0081_MktFcst_Auto.cs:4690 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7fd93659 | this.btnOwner.Click | DMF0081_MktFcst_Auto.cs:4691 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-db2ea732 | this.btnOwner.Click | DMF0081_MktFcst_Auto.cs:4693 |  | VALUE_SET | txtOwner.Text | popItem.OwnerID | 컨트롤 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be1dc059 | this.btnProject.Click | DMF0081_MktFcst_Auto.cs:3916 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-cf678e57 | this.btnProject.Click | DMF0081_MktFcst_Auto.cs:3918 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-97435856 | this.btnProject.Click | DMF0081_MktFcst_Auto.cs:3919 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8a454ae6 | this.btnProject.Click | DMF0081_MktFcst_Auto.cs:3920 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-373deda2 | this.btnProject.Click | DMF0081_MktFcst_Auto.cs:3926 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.btnReport_Click

진입점: this.btnReport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-497951c5 | this.btnReport.Click | DMF0081_MktFcst_Auto.cs:5998 |  | CALL_EXT | System.Diagnostics.Process.Start | ("https://app.powerbi.com/groups/9a4a6328-c6a8-4ea0-99f0-11d3e40060bd/reports/5b71e00e-11c… | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.btnToggle_Click

진입점: this.btnToggle.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e34d85 | this.btnToggle.Click | DMF0081_MktFcst_Auto.cs:6014 | if (siSub1 != null) ▸ if (btnToggle.Tag.ToString() == "Visible_False") | UI_PROP | btnToggle.Tag | "Visible_True" | 속성 Tag 설정 |  |  |  |
| AC-2134d78b | this.btnToggle.Click | DMF0081_MktFcst_Auto.cs:6019 | if (siSub1 != null) ▸ else of (btnToggle.Tag.ToString() == "Visible_False") | UI_PROP | btnToggle.Tag | "Visible_False" | 속성 Tag 설정 |  |  |  |
| AC-78a95849 | this.btnToggle.Click | DMF0081_MktFcst_Auto.cs:6034 | if (siSub1 != null) ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "M3_CUST_FCST_QTY": case "M3_MKT_FCST_QTY": case "M2… | GRID_INIT | siSub1.VisibleColumns | (i, bVisible) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0081_MktFcst_Auto.btnUpDown_Click

진입점: this.btnUpDown.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bdd4d25 | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5942 | if (splitContainer2.Panel1Collapsed == false) | UI_PROP | splitContainer2.Panel1Collapsed | true | 속성 Panel1Collapsed 설정 |  |  |  |
| AC-1db3bde2 | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5944 | if (splitContainer2.Panel1Collapsed == false) | UI_PROP | btnUpDown.ImageOptions.Image | down | 속성 Image 설정 |  |  |  |
| AC-854eaec3 | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5949 | else of (splitContainer2.Panel1Collapsed == false) ▸ if (splitContainer2.Panel1Collapsed == true) | UI_PROP | splitContainer2.Panel1Collapsed | false | 속성 Panel1Collapsed 설정 |  |  |  |
| AC-7aeefa56 | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5952 | else of (splitContainer2.Panel1Collapsed == false) ▸ if (splitContainer2.Panel1Collapsed == true) | UI_PROP | btnUpDown.ImageOptions.Image | up | 속성 Image 설정 |  |  |  |
| AC-52f923cf | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5957 | else of (splitContainer2.Panel1Collapsed == false) ▸ else of (splitContainer2.Panel1Collapsed == true) | UI_PROP | splitContainer2.SplitterDistance | 5 | 속성 SplitterDistance 설정 |  |  |  |
| AC-4c47a362 | this.btnUpDown.Click | DMF0081_MktFcst_Auto.cs:5960 | else of (splitContainer2.Panel1Collapsed == false) ▸ else of (splitContainer2.Panel1Collapsed == true) | UI_PROP | btnUpDown.ImageOptions.Image | down | 속성 Image 설정 |  |  |  |

## DMF0081_MktFcst_Auto.CAR_PROPERTY

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-789a50ad | this.Load | DMF0081_MktFcst_Auto.cs:5758 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD") ⇒ DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-f1d2377e | this.Load | DMF0081_MktFcst_Auto.cs:5759 |  | DATA_OP | request.Parameters["p_EV_TP_CD"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4eba208c | this.Load | DMF0081_MktFcst_Auto.cs:5760 |  | DATA_OP | request.Parameters["p_CUST_CO_CD"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0a716771 | this.Load | DMF0081_MktFcst_Auto.cs:5761 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-037faeeb | this.Load | DMF0081_MktFcst_Auto.cs:5766 | if (response.DataSet != null && response.DataSet.Tables[0] != null && response.DataSet.Tables[0].Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (response.DataSet.Tables[0], cmbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-02519f6d | this.Load | DMF0081_MktFcst_Auto.cs:5772 | if (response.DataSet != null && response.DataSet.Tables[1] != null && response.DataSet.Tables[1].Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (response.DataSet.Tables[1], cmbBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.CAR_REF_DATA

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86389a90 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5659 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_DM_ANL_CAR_REF") ⇒ DM.DMF0003_GET_DM_ANL_CAR_REF | 엔드포인트 요청 생성 |  |  |  |
| AC-3bd07547 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5660 | try | DATA_OP | request.Parameters["p_from_yyyymmdd"] | fromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-f425482e | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5661 | try | DATA_OP | request.Parameters["p_to_yyyymmdd"] | toYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-9562c589 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5662 | try | DATA_OP | request.Parameters["p_car_maker"] | sMakerName | 행/컬럼 값 대입 |  |  |  |
| AC-2ba19ebc | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5663 | try | DATA_OP | request.Parameters["p_car_model"] | sCarModel | 행/컬럼 값 대입 |  |  |  |
| AC-dc84c0fe | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5664 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b4155dcb | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5666 | try | FLAG | dtCar | client.ExecuteDataSet(request).DataSet.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-df3a0a7a | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5666 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-977fdf1e | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5667 | try | FLAG | dtCarTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a2543acc | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5667 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f306520 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5668 | try | FLAG | dtExcelUploadInfo | client.ExecuteDataSet(request).DataSet.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-05a4bea8 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5668 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5aaca9c2 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5675 | try ▸ if (dtCar.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f5a53a7 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5716 | try ▸ for (i <= dtCar.Rows.Count - 4) ▸ for (c <= dtCar.Columns.Count - 3) | GRID_SET | dtCar.Rows[i + 3][c] | newData | 그리드 속성/값 설정 |  |  |  |
| AC-5265f2e8 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5723 | try | GRID_BIND | siSub2.Query | (dtCar) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f57bd875 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5724 | try | GRID_INIT | siSub2.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eef1a1d9 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5725 | try | GRID_LOCK | siSub2.LockColumn2 | (0, dtCar.Columns.Count - 1, true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-36ddfc2c | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5744 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0081_MktFcst_Auto.cboAS_CheckedChanged

진입점: this.cboAS.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f443ee3 | this.cboAS.CheckedChanged | DMF0081_MktFcst_Auto.cs:5171 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-f913283b | this.cboAS.CheckedChanged | DMF0081_MktFcst_Auto.cs:5175 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["… | 화면 필드/플래그 변경 |  |  |  |
| AC-6fe9a004 | this.cboAS.CheckedChanged | DMF0081_MktFcst_Auto.cs:5177 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.cboBucketType_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d77a526d | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4702 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | MESSAGE | MessageHelper.GMessageBox | ("MSG00227") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1285ceed | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4703 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, 0) == CAppSetting.FlagI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.cboBucketType_SelectedIndexChanged

진입점: cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4233d66 | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2300 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-a1a6208c | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2301 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ if (cboBucketType.ControlValues == Bu… | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-964f20e5 | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2309 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues … | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-3fd57028 | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2310 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5111e54a | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2314 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-f0403395 | cboBucketType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2318 | if (siMain != null) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) ▸ else of (cboBucketType.ControlValues … | CALL_EXT | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].ResetBorder | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.cboDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-587d3c71 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2155 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-50e567d1 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2155 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3e025af5 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2156 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-6ccf0267 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2160 |  | STATE | lblEDISender.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1c4f9480 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2162 |  | FLAG | dtEdiSender | GetEdiSender() | 화면 필드/플래그 변경 |  |  |  |
| AC-27834c0b | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2163 |  | LIST_REBIND | clsCtrl.setListBox | (dtEdiSender, clbEDISender, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bdaf2ebf | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2168 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f70fa2f6 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2169 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e50dfe5 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2170 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ee61280c | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2171 | if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a3d9ae28 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2172 | if (sDivision == "40") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-6901e372 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2174 | if (sDivision == "40") | FLAG | dtCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-58d5184c | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2174 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b99388f | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2175 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer40, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4f3d6384 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2180 | if (sDivision == "40") | FLAG | dtSalesSite40 | Data.ScmSitebyEndCustomer40(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba399dc2 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2180 | if (sDivision == "40") | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-80f4f400 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2181 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a20e74e1 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2183 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-37741f62 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2183 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4b58ec56 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2184 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e9e6c3d4 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2191 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1c487ae3 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2193 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-70db045b | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2194 | else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-86124f5f | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2195 | else of (sDivision == "40") | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-c1f75075 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2197 | else of (sDivision == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-84afd8f9 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2197 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43cd64f6 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2198 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9446ba59 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2202 | else of (sDivision == "40") | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-758c4e7d | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2202 | else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6901af27 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2203 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2266fe48 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2205 | else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-9bdfeb7a | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2206 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-92bb868a | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2210 | else of (sDivision == "40") ▸ if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cu… | 목록 컨트롤 재구성 |  |  |  |
| AC-3c09ce72 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2210 | else of (sDivision == "40") ▸ if (sDivision.IndexOf("81") != -1) | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, clbCust… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3891565 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2218 | else of (sDivision == "40") ▸ if (sDivision == "82") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7eaffa5d | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2219 | else of (sDivision == "40") ▸ if (sDivision == "82") | VALUE_CLEAR | clbPlantSite.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-519a0885 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2225 | else of (sDivision == "40") ▸ else of (sDivision == "82") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4851228d | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2229 | else of (sDivision == "40") ▸ else of (sDivision == "82") ▸ if (sDivision == "81") | STATE | lblEDISender.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fcd723a6 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2237 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bffa9389 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2244 |  | VALUE_CLEAR | this.txtProject.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f1dfe9af | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2245 |  | VALUE_CLEAR | this.txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-da8ca377 | clbDivision.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2246 |  | VALUE_CLEAR | this.txtOwner.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0081_MktFcst_Auto.clbCustomer_SelectedIndexChanged

진입점: this.clbCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-318a2dca | this.clbCustomer.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2276 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite(clbDivision.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-f665d213 | this.clbCustomer.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2280 | else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtSalesSite | GetSalesSite40(clbTeam.ControlValues, clbCustomer.ControlValues, UserInfoContext.Current["… | 화면 필드/플래그 변경 |  |  |  |
| AC-871153e2 | this.clbCustomer.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2282 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d974cba | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2256 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb58e864 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2256 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-71803f39 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2257 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ad820f1f | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2259 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-fc67d2a4 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2259 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7329fc96 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2263 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, Us… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-9ba9f0b2 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2263 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8472b903 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2264 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b7ffe84 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2266 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | FLAG | dtSalesSite | Data.Common(Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCus… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 화면 필드/플래그 변경 |  |  |  |
| AC-05307a7d | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2266 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | COMBO_DATA | Data.Common | (Data.Type.SiteByEndCustomer40, false, sDivision, clbTeam.ControlValues, clbCustomer.Contr… ⇒ biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-047f8055 | this.clbTeam.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:2269 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.cmbCarMaker_SelectedIndexChanged

진입점: this.cmbCarMaker.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af933408 | this.cmbCarMaker.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5808 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD") ⇒ DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-d7ad51ad | this.cmbCarMaker.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5809 |  | DATA_OP | request.Parameters["p_EV_TP_CD"] | cmbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b30cf09e | this.cmbCarMaker.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5810 |  | DATA_OP | request.Parameters["p_CUST_CO_CD"] | cmbCarMaker.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bdcc243b | this.cmbCarMaker.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5812 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e03dde24 | this.cmbCarMaker.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5817 | if (response.DataSet != null && response.DataSet.Tables[0] != null && response.DataSet.Tables[0].Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (response.DataSet.Tables[0], cmbCarModel, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.cmbType_SelectedIndexChanged

진입점: this.cmbType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b4f8418 | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5780 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD") ⇒ DM.DMF0081_GET_DDL_DM_YEARLY_MKT_DMD_ANALYSIS_EXCEL_UPLOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-7636c66a | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5781 |  | DATA_OP | request.Parameters["p_EV_TP_CD"] | cmbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8206eb7a | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5782 |  | DATA_OP | request.Parameters["p_CUST_CO_CD"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b31570cd | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5784 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a529a841 | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5789 | if (response.DataSet != null && response.DataSet.Tables[0] != null && response.DataSet.Tables[0].Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (response.DataSet.Tables[0], cmbCarMaker, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7064c749 | this.cmbType.SelectedIndexChanged | DMF0081_MktFcst_Auto.cs:5795 | if (response.DataSet != null && response.DataSet.Tables[1] != null && response.DataSet.Tables[1].Rows.Count > 0) | LIST_REBIND | clsCtrl.setListBox | (response.DataSet.Tables[1], cmbCarModel, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## DMF0081_MktFcst_Auto.contextMenuStrip1_ItemClicked

진입점: this.contextMenuStrip1.ItemClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0df41933 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4820 | if (cellRanges.Length == 0) | MESSAGE | MessageBox.Show | ("선택된 셀이 없습니다.") | 메시지 표시 |  |  |  |
| AC-d9a8a230 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4821 | if (cellRanges.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3ee70f9 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4874 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | liItemId.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ItemId40)).ToStri… | 데이터 객체 조작/조회 |  |  |  |
| AC-daa3a889 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4875 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arScmSiteId.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ScmSiteId40)).ToS… | 데이터 객체 조작/조회 |  |  |  |
| AC-7b928c74 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4879 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | liItemId.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ItemId)).ToString… | 데이터 객체 조작/조회 |  |  |  |
| AC-ae565047 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4880 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arScmSiteId.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.ScmSiteId)).ToStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-e8dc9430 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4883 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arDomExp.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.DomExp)).ToString… | 데이터 객체 조작/조회 |  |  |  |
| AC-bcba9dae | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4884 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arFcstType.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.FcstType)).ToStri… | 데이터 객체 조작/조회 |  |  |  |
| AC-1672d94f | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4885 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arIncoterms.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.Incoterms)).ToStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-f2569dda | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4888 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arPlantSiteId.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.PlantSiteId)).ToS… | 데이터 객체 조작/조회 |  |  |  |
| AC-9f7db776 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4890 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arProjectCode.Add | (siMain.GetValue(cellRanges[i].Row + r, siMain.GetColumnIndex(DefColumns.Project)).ToStrin… | 데이터 객체 조작/조회 |  |  |  |
| AC-7d064bc0 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4895 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | MESSAGE | MessageBox.Show | ("실적 구간이 포함되어 있습니다.") | 메시지 표시 |  |  |  |
| AC-851586b2 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4896 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fe94fc47 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4898 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arYYYYMMDD.Add | (siMain.GetColumnTag(cellRanges[i].Column + c).Replace("D_", "")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b26683cc | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4899 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (siMain.GetColumnTag(cellRa… | DATA_OP | arQty.Add | (siMain.GetValue(cellRanges[i].Row + r, cellRanges[i].Column + c).ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-6de4c2e9 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4921 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (cboBucketType.ControlValue… | MESSAGE | MessageBox.Show | ("일자컬럼에서만 사용가능합니다.") | 메시지 표시 |  |  |  |
| AC-daeff1e3 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4922 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ for (c < cellRanges[i].ColumnCount) ▸ if (cboBucketType.ControlValue… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18ec61a7 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4939 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ if (arQty.Count == 0) | MESSAGE | MessageBox.Show | ("Request 할 내용이 없습니다.") | 메시지 표시 |  |  |  |
| AC-ab3b1946 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4940 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < cellRanges.Length) ▸ if (arQty.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b00599b5 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4945 | if (e.ClickedItem.Name == "Request_PR") ▸ if (liItemId.Distinct<string>().ToList<string>().Count() != liItemId.Count()) | MESSAGE | MessageBox.Show | ("Model 은 중복될 수 없습니다.") | 메시지 표시 |  |  |  |
| AC-5348be4c | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4946 | if (e.ClickedItem.Name == "Request_PR") ▸ if (liItemId.Distinct<string>().ToList<string>().Count() != liItemId.Count()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b883e830 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4953 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < arProjectCode.Count) ▸ if (i < arProjectCode.Count - 1 && arProjectCode[i].ToString() != … | MESSAGE | MessageBox.Show | ("Project 는 동일해야 합니다.") | 메시지 표시 |  |  |  |
| AC-63e65c01 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4954 | if (e.ClickedItem.Name == "Request_PR") ▸ for (i < arProjectCode.Count) ▸ if (i < arProjectCode.Count - 1 && arProjectCode[i].ToString() != … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c16264b3 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4987 | if (e.ClickedItem.Name == "Request_PR") ▸ if (bExit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-234ff761 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4990 | if (e.ClickedItem.Name == "Request_PR") | POPUP | new DMF0003_PRPopup | () | 팝업/폼 생성 |  |  |  |
| AC-460aa0dc | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4991 | if (e.ClickedItem.Name == "Request_PR") | POPUP | popup.Form_Load | (e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType,… | 팝업 초기화(인자 전달) |  |  |  |
| AC-c02bfd3a | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4992 | if (e.ClickedItem.Name == "Request_PR") | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2976d44f | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:4993 | if (e.ClickedItem.Name == "Request_PR") | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a202967f | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5000 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | MESSAGE | MessageBox.Show | (e.ClickedItem.Text + "버튼은 한 개의 셀만 선택할 수 있습니다. ") | 메시지 표시 |  |  |  |
| AC-432936d4 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5001 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0764b9e | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5007 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | MESSAGE | MessageBox.Show | ("BNP In 메저행에서만 사용가능합니다.") | 메시지 표시 |  |  |  |
| AC-29619193 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5008 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ad4daea | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5014 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | MESSAGE | MessageBox.Show | ("일자컬럼에서만 사용가능합니다.") | 메시지 표시 |  |  |  |
| AC-8a44d42b | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5015 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4616d88 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5040 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | new DMF0003_PRHistoryPopup | () | 팝업/폼 생성 |  |  |  |
| AC-42ea82c1 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5041 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | popup.Form_Load | (e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType,… | 팝업 초기화(인자 전달) |  |  |  |
| AC-f1b5b54b | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5042 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d975e9a7 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5043 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0dafdd45 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5047 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | new DMF0003_PRPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3ca66620 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5048 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | popup.Form_Load | (e.ClickedItem.Name, "", sDivision, sProjectCode, sScmSiteId, sItemId, sDomExp, sFcstType,… | 팝업 초기화(인자 전달) |  |  |  |
| AC-e93a1f87 | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5049 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a49c151a | this.contextMenuStrip1.ItemClicked | DMF0081_MktFcst_Auto.cs:5050 | else of (e.ClickedItem.Name == "Request_PR") ▸ if (e.ClickedItem.Name == "View_PR" \|\| e.ClickedItem.Name == "Add_History" \|\| e.ClickedIt… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c322c3bd | this.Load | DMF0081_MktFcst_Auto.cs:532 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-afc019e6 | this.Load | DMF0081_MktFcst_Auto.cs:533 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-05c61b5f | this.Load | DMF0081_MktFcst_Auto.cs:534 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0f22864 | this.Load | DMF0081_MktFcst_Auto.cs:536 |  | GRID_INIT | this.AddSheet | (spdSub1, SpdSheet.shtSub1, SpdSheet.shtSub1, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a6d16da2 | this.Load | DMF0081_MktFcst_Auto.cs:537 |  | FLAG | siSub1 | GetSheetInfo(spdSub1.Name, spdSub1.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-86e512ab | this.Load | DMF0081_MktFcst_Auto.cs:538 |  | GRID_INIT | siSub1.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abfd2d4e | this.Load | DMF0081_MktFcst_Auto.cs:541 |  | GRID_INIT | this.AddSheet | (spdSub2, SpdSheet.shtSub2, SpdSheet.shtSub2, 2, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-906f3c34 | this.Load | DMF0081_MktFcst_Auto.cs:542 |  | FLAG | siSub2 | GetSheetInfo(spdSub2.Name, spdSub2.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0d905508 | this.Load | DMF0081_MktFcst_Auto.cs:543 |  | GRID_INIT | siSub2.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_MktFcst_Auto.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-800904a0 | this.Load | DMF0081_MktFcst_Auto.cs:486 |  | UI_PROP | usrConditionPanel1.Height | 108 | 속성 Height 설정 |  |  |  |
| AC-ed6f474b | this.Load | DMF0081_MktFcst_Auto.cs:488 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-c8dd6aa1 | this.Load | DMF0081_MktFcst_Auto.cs:490 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-93aa03aa | this.Load | DMF0081_MktFcst_Auto.cs:492 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9191388a | this.Load | DMF0081_MktFcst_Auto.cs:493 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-086489fe | this.Load | DMF0081_MktFcst_Auto.cs:494 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-7dda4bac | this.Load | DMF0081_MktFcst_Auto.cs:495 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |
| AC-802394f4 | this.Load | DMF0081_MktFcst_Auto.cs:499 |  | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6f2c44ab | this.Load | DMF0081_MktFcst_Auto.cs:505 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnIncotermsChg.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d9fd6f92 | this.Load | DMF0081_MktFcst_Auto.cs:506 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | STATE | btnIncotermsChg.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-1f7cb257 | this.Load | DMF0081_MktFcst_Auto.cs:507 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-2793971e | this.Load | DMF0081_MktFcst_Auto.cs:508 | switch (UserInfoContext.Current["NowGroupID"]) case "ADMIN": case "DM ADMIN": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-74363898 | this.Load | DMF0081_MktFcst_Auto.cs:511 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | STATE | btnIncotermsChg.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e29152d7 | this.Load | DMF0081_MktFcst_Auto.cs:512 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | STATE | btnIncotermsChg.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-e334e654 | this.Load | DMF0081_MktFcst_Auto.cs:513 | switch (UserInfoContext.Current["NowGroupID"]) case "DM Planner": | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9cb832e6 | this.Load | DMF0081_MktFcst_Auto.cs:516 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnIncotermsChg.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-591678a4 | this.Load | DMF0081_MktFcst_Auto.cs:517 | switch (UserInfoContext.Current["NowGroupID"]) default: | STATE | btnIncotermsChg.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3f8cdbd8 | this.Load | DMF0081_MktFcst_Auto.cs:518 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem6.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d2633be6 | this.Load | DMF0081_MktFcst_Auto.cs:519 | switch (UserInfoContext.Current["NowGroupID"]) default: | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0081_MktFcst_Auto.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5578200c | DeleteButton | DMF0081_MktFcst_Auto.cs:939 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b4995c2 | Dispose | DMF0081_MktFcst_Auto.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0081_MktFcst_Auto.EditButton

진입점: cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (!siMain.IsLock(siMain.SheetName))] / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35dbc057 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:957 | if (this.fps != null) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siM… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2dc7628d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:958 | if (this.fps != null) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95beac57 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:969 | if (this.fps != null) ▸ if (clbDivision.ControlValues == "82") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetColumnInd… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d47d3b0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:970 | if (this.fps != null) ▸ if (clbDivision.ControlValues == "82") ▸ if (siMain.GetColumnIndex(DefColumns.Division) < 0 \|\| siMain.GetColumnInd… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1860969f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:981 | if (this.fps != null) ▸ else of (clbDivision.ControlValues == "82") ▸ if (clbDivision.ControlValues == "40") ▸ if (siMain.GetColumnIndex(Def… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c886043f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:982 | if (this.fps != null) ▸ else of (clbDivision.ControlValues == "82") ▸ if (clbDivision.ControlValues == "40") ▸ if (siMain.GetColumnIndex(Def… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b49539e | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:990 | if (this.fps != null) ▸ if ((dt8Week == null) \|\| (dt8Week.Rows.Count == 0)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00259") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bdad95e0 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:991 | if (this.fps != null) ▸ if ((dt8Week == null) \|\| (dt8Week.Rows.Count == 0)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-deec403f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:994 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6039f00 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:995 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-30c71bea | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1011 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColu… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a595f797 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1014 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColu… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-63229fac | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1021 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (siMain.Ge… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d3d89db7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1038 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-72e72e8d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1041 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-68d5c6df | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1059 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucket… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-426f2066 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1069 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1597fa58 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1077 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-af5d9467 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1080 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e058f89 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1085 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cdca7c83 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1098 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e68fffdc | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1102 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99d2c9c2 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1105 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-81e27e68 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1112 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b1a9c59 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1116 | if (this.fps != null) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboB… | GRID_LOCK | siMain.LockColumn | (iCol, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c67c9a08 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1123 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.Measure), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-039cbf34 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1129 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-07e425d7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1136 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), iRow, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed8b890c | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1140 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Project), iRow, siMain.GetColumnIndex(DefColumns.P… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c4bbe7b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1142 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectName), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-871e5122 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1144 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectStatus), siMain.GetMaxRowIndex(), siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03997157 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1146 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CellType), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-03a4975d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1148 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.BizType), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2657bbf | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1150 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Country), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-125247f7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1152 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CountryName), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9690ea1 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1154 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.City), siMain.GetMaxRowIndex(), siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c82a8734 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1156 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CityName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-181024c5 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1158 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetMaxRowIndex(), siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f245d1d | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1160 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ItemId), iRow, siMain.GetColumnIndex(DefColumns.It… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7e6e6feb | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1162 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.ItemId40), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-24d1b675 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1164 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bdd952b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1166 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ItemType), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aadb9cab | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1169 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.NickName), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bb8e7fc7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1171 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.ProjectOwner), siMain.GetMaxRowIndex(), siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7c875362 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1173 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.VMI_YN), siMain.GetMaxRowIndex(), siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a37a596a | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1175 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Owner), siMain.GetMaxRowIndex(), siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1075d0bc | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1177 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.MeasureGroup), siMain.GetMaxRowIndex(), siMain.GetCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b237053 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1196 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol2, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2bc4badb | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1200 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol2, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-0512f36b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1201 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth2, siMain.GetMaxRowIndex(), iResultMonth2, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-675fb61f | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1210 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-af4550b5 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1211 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-b21df2b8 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1215 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-e2a188ae | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1219 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-ad6ed72b | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1231 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2e4055a9 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1236 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-10e4afae | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1241 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-840b2686 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1246 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-298d5300 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1248 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToStri… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division40), siMain.GetMaxRowIndex(), siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a8d59ee7 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1256 | if (this.fps != null) ▸ if (chkColor.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1, siMain.GetMaxRowIndex(), iResultCol, Co… | 그리드 표시 설정 |  |  |  |
| AC-ea4ef7be | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1259 | if (this.fps != null) ▸ if (chkColor.Checked == true) ▸ if (siMain.GetMaxRowIndex() >= 0) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-754c4dee | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1268 | if (this.fps != null) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) … | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-e9787bd1 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1269 | if (this.fps != null) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-d7369452 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1273 | if (this.fps != null) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex(this_YYYYMMWW) > 0) … | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-b8924502 | cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if… 외 1 | DMF0081_MktFcst_Auto.cs:1277 | if (this.fps != null) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnIndex("D_" + sResultYYYYMM… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35b1b129 | ExcelButton | DMF0081_MktFcst_Auto.cs:1293 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-19f1524a | ExcelButton | DMF0081_MktFcst_Auto.cs:1294 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-55522a0e | ExcelButton | DMF0081_MktFcst_Auto.cs:1295 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-fe74b290 | ExcelButton | DMF0081_MktFcst_Auto.cs:1296 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-08fa6e73 | ExcelButton | DMF0081_MktFcst_Auto.cs:1297 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-08cee79e | ExcelButton | DMF0081_MktFcst_Auto.cs:1298 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-9107f660 | ExcelButton | DMF0081_MktFcst_Auto.cs:1300 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-8b630488 | ExcelButton | DMF0081_MktFcst_Auto.cs:1301 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-2e8effa3 | ExcelButton | DMF0081_MktFcst_Auto.cs:1303 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##0;[Red]-#,##0.##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-dabf8659 | ExcelButton | DMF0081_MktFcst_Auto.cs:1313 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6523da5 | ExcelButton | DMF0081_MktFcst_Auto.cs:1318 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-90c4ff9a | ExcelButton | DMF0081_MktFcst_Auto.cs:1322 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0081_MktFcst_Auto.FileDownLoad

진입점: this.btnManual.Click / this.btnGuide.Click / HelpButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04268cab | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6259 |  | CALL_EXT | System.Net.WebRequest.Create | (sUrl) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81efd7d3 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6275 | try | CALL_EXT | request.GetResponse | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cea24f7d | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6276 | try | CALL_EXT | result.GetResponseStream | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fefefced | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6281 | try | CALL_EXT | ReceiveStream.Read | (buffer, 0, buffer.Length - 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-792330a3 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6283 | try ▸ while ((read = ReceiveStream.Read(buffer, 0, buffer.Length - 1)) > 0) | CALL_EXT | fs.Write | (buffer, 0, read) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97d13b06 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6286 | try | CALL_EXT | System.Diagnostics.Process.Start | (Application.StartupPath + "\\" + sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33ab6fde | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6329 | finally ▸ if (fs != null) | UI_MISC | fs.Close | () | 창 닫기/해제 |  |  |  |
| AC-aec24ea4 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6330 | finally ▸ if (ReceiveStream != null) | UI_MISC | ReceiveStream.Close | () | 창 닫기/해제 |  |  |  |
| AC-0dbc6f1e | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6331 | finally ▸ if (result != null) | CALL_EXT | request.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e8e78d4 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6332 | finally ▸ if (request != null) | CALL_EXT | request.Abort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b541d29 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6339 | if (bSuccess == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00132", new object[] { sFileName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0081_MktFcst_Auto.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b7c42b9 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1336 |  | DATA_OP | _dtTitleSet.Select | ("column_name = 'PROJECT_NAME'" + " AND " + "user_flag ='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa1b71f5 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1339 |  | DATA_OP | _dtTitleSet.Select | ("column_name = 'PROJECT_CODE'" + " AND " + "user_flag ='Y'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a801db63 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1344 | if (cnt1 + cnt2 == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00434") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7b511874 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1345 | if (cnt1 + cnt2 == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8766124 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1350 | else of (cnt1 + cnt2 == 0) ▸ if (cnt1 == 0 && cnt2 != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00435") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84aa673d | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1351 | else of (cnt1 + cnt2 == 0) ▸ if (cnt1 == 0 && cnt2 != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39c3f683 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1355 | else of (cnt1 + cnt2 == 0) ▸ else of (cnt1 == 0 && cnt2 != 0) ▸ if (cnt1 != 0 && cnt2 == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00436") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-215d1d96 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1356 | else of (cnt1 + cnt2 == 0) ▸ else of (cnt1 == 0 && cnt2 != 0) ▸ if (cnt1 != 0 && cnt2 == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4890bb0b | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1361 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-621adcd6 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1372 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0d45d69 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1374 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-920ca65f | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1383 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3a86c26 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1384 | try ▸ if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-08c64417 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1389 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | MESSAGE | MessageHelper.GMessageBox | ("MSG00164") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9ead23bf | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1391 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddYears(2) | 속성 Value2 설정 |  |  |  |
| AC-32032b96 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1393 | try ▸ if (drpPeriod.Value1.AddYears(3) < drpPeriod.Value2) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0368e4e | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1396 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3c95ae8f | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1405 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4ca18bfc | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1407 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3a7065a9 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1411 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_MKT_FCST_DATA") ⇒ DM.DMF0003_GET_MKT_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-dbc48623 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1414 | try ▸ lambda | UI_PROP | request.CommandTimeout | 30 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c8ca4b15 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1416 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-df78683d | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1417 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b41bfd16 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1418 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_site_id"] | clbPlantSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-40880520 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1419 | try ▸ lambda | DATA_OP | request.Parameters["p_team_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a9211350 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1420 | try ▸ lambda | DATA_OP | request.Parameters["p_customer"] | clbCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e9b7b18c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1421 | try ▸ lambda | DATA_OP | request.Parameters["p_biz_type"] | clbBizType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9e5cf8d8 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1422 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | txtProject.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c6c2345d | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1423 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | txtItemId.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1f675221 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1424 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | sPeriod[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d5aabb44 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1425 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | sPeriod[1] | 행/컬럼 값 대입 |  |  |  |
| AC-d09d6e14 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1426 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ba6441c5 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1427 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f86b95e1 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1428 | try ▸ lambda | DATA_OP | request.Parameters["p_item_type"] | clbItemType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7c66d9ff | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1429 | try ▸ lambda | DATA_OP | request.Parameters["p_owner"] | txtOwner.Text.Trim() | 행/컬럼 값 대입 |  |  |  |
| AC-d616881c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1430 | try ▸ lambda | DATA_OP | request.Parameters["p_qty_yn"] | (cboQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-caf5ce98 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1431 | try ▸ lambda | DATA_OP | request.Parameters["p_cell_yn"] | (cboCellQty.Checked == true) ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7c2a3534 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1432 | try ▸ lambda | DATA_OP | request.Parameters["p_invalid_exec"] | sInvalidExec | 행/컬럼 값 대입 |  |  |  |
| AC-f8509b98 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1433 | try ▸ lambda | DATA_OP | request.Parameters["p_as_yn"] | cboAS.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-dd700bc6 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1434 | try ▸ lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f67fbd2 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1435 | try ▸ lambda | DATA_OP | request.Parameters["p_sender_code"] | clbEDISender.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-01e8b2fb | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1437 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54608841 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1439 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-65c5e753 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1445 | try ▸ if (ds.Tables.Count >= 2) | FLAG | dt8Week | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-3c8e5797 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1450 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bbf19dde | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1454 | try ▸ if (ds.Tables[0] != null) | GRID_BIND | siMain.Query | (ds.Tables[0].DataSet) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9fb5d69c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1456 | try ▸ if (ds.Tables[0] != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-478db748 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1457 | try ▸ if (ds.Tables[0] != null) | GRID_LOCK | siMain.LockColumn2 | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금 전환 |  |  |  |
| AC-5751411c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1462 | try ▸ if (ds.Tables[2].Rows.Count > 0) | FLAG | this_YYYYMMWW | ds.Tables[2].Rows[0]["THIS_YYYYMMWW"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4647571f | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1463 | try ▸ if (ds.Tables[2].Rows.Count > 0) | FLAG | iso_week | ds.Tables[2].Rows[0]["ISO_WEEK"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-55fdbfa0 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1470 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-fab7ec50 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1471 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b1cdf8d7 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1477 | try ▸ if (siMain.GetMaxRowIndex() >= 0) | FLAG | count | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-87a47214 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1488 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("W_") == 0 && iso… | FLAG | count | count++ | 화면 필드 증감 |  |  |  |
| AC-f4af87f5 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1495 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (chkColor.Checked == true) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-d81fcb81 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1496 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ if (chkColor.Checked == true) ▸ if (iResultCol > iStartCol) | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-e20a730c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1508 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlVal… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-60b88ed0 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1509 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlVal… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-55da2958 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1513 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ if (cboBucketType.ControlVal… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9daa8388 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1520 | try ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ else of (chkColor.Checked == true) ▸ if (chkColor.Checked == false) ▸ else of (cboBucketType.Contr… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-d99636c7 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1546 | try ▸ if (sDivision == "40" \|\| sDivision == "82") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (sAttr1 != "") ▸ for (i < sarAttr1.Length) … | GRID_STYLE | siMain.SetBGColor | (iRow, iCol, iRow, iCol, cA) | 그리드 표시 설정 |  |  |  |
| AC-9e42b47b | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1560 | try | FLAG | sDefaultDay | Data.Common(Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues).Row… ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 화면 필드/플래그 변경 |  |  |  |
| AC-e90d744f | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1560 | try | COMBO_DATA | Data.Common | (Data.Type.DefaultBucketDay, false, sDivision, cboBucketType.ControlValues) ⇒ biz:CommonData.CommonDataList [code=DefaultBucketDay] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89982843 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1564 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3ee98d6b | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1568 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a6ef7335 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:1570 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0081_MktFcst_Auto.FirstWeeked

진입점: this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ if ((sSeq == "3" \|\| sSeq == "4") && (sPopup_Status == "MODIFY" \|\| sPopup_Status == "READ_OK") && (sColumnNameOfClickCell == …)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2284f431 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … | DMF0081_MktFcst_Auto.cs:5993 |  | RETURN | return (startofFirstWeek.Day >= today.Day) && (today.Day <= endofFirstWeek.Day); |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.fnValidation

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54cf4fd1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4095 |  | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b9906dc0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4237 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | DATA_OP | bInputCnt[iIdex] | iCnt | 행/컬럼 값 대입 |  |  |  |
| AC-e7fb5c7a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4252 | if (iValidation > 1) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-aca9b653 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4256 | else of (iValidation > 1) ▸ if (!bInputCheck) | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |
| AC-8da6627a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4334 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | dtSaveFinal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-186b5d70 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4335 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Division] | dr[DefColumns.Division].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4f87f399 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4336 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Project] | dr[DefColumns.Project].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03e831b2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4337 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.ScmSiteId] | dr[DefColumns.ScmSiteId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9666877f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4338 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.ItemId] | dr[DefColumns.ItemId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-263f998f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4339 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.DomExp] | dr[DefColumns.DomExp].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-010799ae | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4340 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.FcstType] | dr[DefColumns.FcstType].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-01462003 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4341 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Incoterms] | dr[DefColumns.Incoterms].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-83911748 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4342 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Measure] | dr[DefColumns.Measure].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ff1bfd1f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4343 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.PlantSiteId] | dr[DefColumns.PlantSiteId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ad55edd0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4344 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.YYYYMMDD] | dr[DefColumns.YYYYMMDD].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-50bc8cf8 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4345 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Qty] | dr[DefColumns.Qty].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-01336f05 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4347 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.Customer40] | dr[DefColumns.Customer40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfbe4755 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4348 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.ScmSiteId40] | dr[DefColumns.ScmSiteId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f12f6f11 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4349 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | drNew[DefColumns.ItemId40] | dr[DefColumns.ItemId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-54b6b52a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4351 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | dtSaveFinal.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fd88a0d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4352 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbDi… | DATA_OP | dtSaveFinal.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c522850 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4371 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7f0e9e6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4372 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Division] | dr[DefColumns.Division].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2e0ca5fa | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4373 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Project] | dr[DefColumns.Project].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25b6738f | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4374 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ScmSiteId] | dr[DefColumns.ScmSiteId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3200da0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4375 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ItemId] | dr[DefColumns.ItemId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-27ef32a9 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4376 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.DomExp] | dr[DefColumns.DomExp].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ec26398 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4377 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.FcstType] | dr[DefColumns.FcstType].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b1ec39b | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4378 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Incoterms] | dr[DefColumns.Incoterms].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4e730994 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4379 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Measure] | dr[DefColumns.Measure].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f861c51 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4380 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.YYYYMMDD] | dr[DefColumns.YYYYMMDD].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a77d9515 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4381 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Qty] | dr[DefColumns.Qty].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1b5f58c6 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4383 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Customer40] | dr[DefColumns.Customer40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de2c5134 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4384 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ScmSiteId40] | dr[DefColumns.ScmSiteId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-254434e7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4385 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ItemId40] | dr[DefColumns.ItemId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f1cb6059 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4387 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-f81239dc | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4388 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfa845c1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4442 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c4bffd7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4443 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Division] | dr[DefColumns.Division].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6632b71d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4444 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Project] | dr[DefColumns.Customer40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b661080 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4445 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ScmSiteId] | dr[DefColumns.ScmSiteId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-45dc5c3d | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4446 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ItemId] | dr[DefColumns.ItemId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7b93cc7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4447 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.DomExp] | dr[DefColumns.DomExp].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6c34bfb1 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4448 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.FcstType] | dr[DefColumns.FcstType].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f2bb394e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4449 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Incoterms] | dr[DefColumns.Incoterms].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0f01298e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4450 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Measure] | dr[DefColumns.Measure].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-47840ce5 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4451 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.PlantSiteId] | dr[DefColumns.PlantSiteId].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9df2afb0 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4452 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.YYYYMMDD] | dr[DefColumns.YYYYMMDD].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9e861d77 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4453 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Qty] | dr[DefColumns.Qty].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-16557f0a | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4455 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.Customer40] | dr[DefColumns.Customer40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-966bd734 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4456 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ScmSiteId40] | dr[DefColumns.ScmSiteId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-128cfc5e | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4457 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | drNew[DefColumns.ItemId40] | dr[DefColumns.ItemId40].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d7555a2 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4459 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-13079ee3 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4460 | else of (iValidation > 1) ▸ else of (!bInputCheck) ▸ foreach (DataRow dr in dtSave.Rows) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (… | DATA_OP | dtSaveFinal.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dd436832 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0081_MktFcst_Auto.cs:4466 |  | RETURN | return bValidation; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b78b6412 | this.Load | DMF0081_MktFcst_Auto.cs:319 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a24bb7c4 | this.Load | DMF0081_MktFcst_Auto.cs:320 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-eb6ef559 | this.Load | DMF0081_MktFcst_Auto.cs:331 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe45114c | this.Load | DMF0081_MktFcst_Auto.cs:331 | if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82")) | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure) ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0081_MktFcst_Auto.GET_DM_YEARLY_MKT_DMD_ANALYSIS

진입점: this.btnCalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5245946a | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5574 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS") ⇒ DM.DMF0081_GET_DM_YEARLY_MKT_DMD_ANALYSIS | 엔드포인트 요청 생성 |  |  |  |
| AC-5d6c05dd | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5575 | try | DATA_OP | request.Parameters["p_EV_TP_CD"] | cmbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3ad41556 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5576 | try | DATA_OP | request.Parameters["p_CUST_CO_CD"] | cmbCarMaker.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-68806cd9 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5577 | try | DATA_OP | request.Parameters["p_CAR_MDL_ID"] | cmbCarModel.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a5f17088 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5578 | try | DATA_OP | request.Parameters["p_FROM_YYYYMM"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-f1fa3320 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5579 | try | DATA_OP | request.Parameters["p_TO_YYYYMM"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-ed73f251 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5606 | try | DATA_OP | request.Parameters["p_MARKETSHARE"] | v_MARKETSHARE | 행/컬럼 값 대입 |  |  |  |
| AC-72970245 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5607 | try | DATA_OP | request.Parameters["p_BIZPERCAR"] | v_BIZPERCAR | 행/컬럼 값 대입 |  |  |  |
| AC-b3fa8dd3 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5612 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7b657c57 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5614 | try | FLAG | dtCarTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-dc048ca3 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5614 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12790353 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5615 | try | FLAG | dtCar | client.ExecuteDataSet(request).DataSet.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-10f08b28 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5615 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fc899e0d | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5622 | try ▸ if (dtCarTitle.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ec4bda4 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5625 | try | GRID_BIND | siSub2.Query | (dtCar) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f1b2fe60 | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5628 | try | GRID_INIT | siSub2.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-790ecdbe | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5630 | try | GRID_LOCK | siSub2.LockColumn | (0, siSub2.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e695ba5d | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5631 | try | GRID_INIT | siSub2.Freeze | (0, siSub2.GetColumnIndex("MINOR_CAT")+1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-adecc54b | this.btnCalculation.Click | DMF0081_MktFcst_Auto.cs:5635 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0081_MktFcst_Auto.GetBizTypebyDivision

진입점: this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.Division))] / this.Load [else of (sDivision == "40")] / clbDivision.SelectedIndexChanged [else of (sDivision == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8e9c3c6 | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DMF0081_MktFcst_Auto.cs:4653 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d745296e | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DMF0081_MktFcst_Auto.cs:4654 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-380662ec | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DMF0081_MktFcst_Auto.cs:4655 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5334fdfa | this.spdMain.ComboSelChange [if (e.Column == siMain.GetColum… 외 2 | DMF0081_MktFcst_Auto.cs:4657 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6366ecc1 | this.Load | DMF0081_MktFcst_Auto.cs:4588 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DMF0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ab87592f | this.Load | DMF0081_MktFcst_Auto.cs:4589 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0172dcdc | this.Load | DMF0081_MktFcst_Auto.cs:4591 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13060381 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4639 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bc6cbdac | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4640 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-f5b98e00 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4641 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-79122215 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4642 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-efe8d30a | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4644 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetCustomsHandbook

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d59aac68 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5200 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-96e3335e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5201 |  | DATA_OP | request.Parameters["CODE"] | "DM_CUSTOMS_HANDBOOK" | 행/컬럼 값 대입 |  |  |  |
| AC-67bdf10e | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5202 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3874d0fc | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5203 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-02655341 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5204 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8d932918 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5205 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d035c52 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5206 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-65ad0a7f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5207 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3bc1814d | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5209 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.getDayOfWeek

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) ▸ if ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0) ▸ for (iCol <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bdfa4f4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:5076 |  | RETURN | return (int)Convert.ToDateTime(strD2).DayOfWeek; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92b2f0d2 | this.Load | DMF0081_MktFcst_Auto.cs:4519 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-ccd30d3c | this.Load | DMF0081_MktFcst_Auto.cs:4520 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-40def10f | this.Load | DMF0081_MktFcst_Auto.cs:4521 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-4e9fd42a | this.Load | DMF0081_MktFcst_Auto.cs:4523 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e520e70f | this.Load | DMF0081_MktFcst_Auto.cs:4526 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-118ac45c | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4475 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-d64c8dcd | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4477 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-05f76681 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4480 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetEdiSender

진입점: this.Load [else of (sDivision == "40") ▸ else of (sDivision == "82") ▸ if (sDivision == "81")] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7c9c51c | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5218 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-36a5e3c2 | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5219 |  | DATA_OP | request.Parameters["CODE"] | "EDI_SENDER_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-e44f061b | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5220 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53709475 | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5221 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5af2a2f | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5222 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b1fd2b7 | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5223 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0da8a624 | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5224 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-00383fbf | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5225 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dd16f41f | this.Load [else of (sDivision == "40") ▸ else of (sDivision … 외 1 | DMF0081_MktFcst_Auto.cs:5227 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetFcstType

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917872e0 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5089 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-33be6f5a | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5090 |  | DATA_OP | request.Parameters["CODE"] | "FCST_TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-088b2cd3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5091 |  | DATA_OP | request.Parameters["PARAM1"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-90fb6164 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5092 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9676c3e1 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5093 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81671fa5 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5094 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-183c4a3f | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5095 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7019f3b3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5096 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fb8af74 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0081_MktFcst_Auto.cs:5098 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetFirstWed

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4448830d | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5910 |  | CALL_EXT | firstWed.AddMilliseconds | (-1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-499cd149 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5914 | if (DateTime.Compare(DateTime.Now, dateofMon) >= 0 && DateTime.Compare(DateTime.Now, dateofTue) <= 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-db9d0c6a | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:5918 | else of (DateTime.Compare(DateTime.Now, dateofMon) >= 0 && DateTime.Compare(DateTime.Now, dateofTue) <= 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetIncotermsType

진입점: this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId40)) ▸ if (iCol == siMain.GetColumnIndex(DefColumns.ScmSiteId)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(DefColumns.ScmSiteId) != -1)] / this.spdMain.ComboSelChange [else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Customer…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e30cb604 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5111 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-bbe2f09b | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5112 |  | DATA_OP | request.Parameters["CODE"] | "AS_INCOTERMS" | 행/컬럼 값 대입 |  |  |  |
| AC-2d737c50 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5113 |  | DATA_OP | request.Parameters["PARAM1"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-323279d3 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5114 |  | DATA_OP | request.Parameters["PARAM2"] | sScmSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-09b14847 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5115 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4b9c45a | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5116 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-14a5b0f7 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5117 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-92db0297 | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5118 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-caaa620d | this.spdMain.ClipboardPasted [for (iRow < e.CellRange.Row + … 외 1 | DMF0081_MktFcst_Auto.cs:5120 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetItemType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0277c4d9 | this.Load | DMF0081_MktFcst_Auto.cs:4600 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-e0cd7e1b | this.Load | DMF0081_MktFcst_Auto.cs:4601 |  | DATA_OP | request.Parameters["p_lookup_type"] | "ITEM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-f19530aa | this.Load | DMF0081_MktFcst_Auto.cs:4602 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7577925 | this.Load | DMF0081_MktFcst_Auto.cs:4604 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetItemType2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e03b0d | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4613 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-af4b0011 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4614 |  | DATA_OP | request.Parameters["p_lookup_type"] | strCode | 행/컬럼 값 대입 |  |  |  |
| AC-a012a57d | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4615 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f0065e58 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4617 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetPlantSitebyEndCustomer

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ade073 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4504 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER") ⇒ SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | 엔드포인트 요청 생성 |  |  |  |
| AC-16aa52d6 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4505 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fa2e0754 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4506 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-498a5265 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4507 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-7213d8e7 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4508 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4ef4cc5 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4510 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetSalesSite

진입점: this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))] / this.clbCustomer.SelectedIndexChanged [if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19ec610e | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5133 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-708cd93b | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5134 |  | DATA_OP | request.Parameters["CODE"] | "SiteByEndCustomer" | 행/컬럼 값 대입 |  |  |  |
| AC-6b59ffd7 | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5135 |  | DATA_OP | request.Parameters["PARAM1"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-6fb23ced | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5136 |  | DATA_OP | request.Parameters["PARAM2"] | sCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-9b50ef09 | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5137 |  | DATA_OP | request.Parameters["PARAM3"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-20a3d7ae | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5138 |  | DATA_OP | request.Parameters["PARAM4"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-f27af2a3 | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5139 |  | DATA_OP | request.Parameters["PARAM5"] | cboAS.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-4340b51e | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5140 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92a5042a | this.cboAS.CheckedChanged [if ((clbDivision.ControlValues.Su… 외 1 | DMF0081_MktFcst_Auto.cs:5142 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetSalesSite40

진입점: this.cboAS.CheckedChanged [else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))] / this.clbCustomer.SelectedIndexChanged [else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.ControlValues == "82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95c2b697 | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5155 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-1dfcc995 | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5156 |  | DATA_OP | request.Parameters["CODE"] | "SiteByEndCustomer40" | 행/컬럼 값 대입 |  |  |  |
| AC-a495f62a | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5157 |  | DATA_OP | request.Parameters["PARAM1"] | sTeamID | 행/컬럼 값 대입 |  |  |  |
| AC-55be41dd | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5158 |  | DATA_OP | request.Parameters["PARAM2"] | sCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-1bdb243e | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5159 |  | DATA_OP | request.Parameters["PARAM3"] | groupID | 행/컬럼 값 대입 |  |  |  |
| AC-abab052c | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5160 |  | DATA_OP | request.Parameters["PARAM4"] | userId | 행/컬럼 값 대입 |  |  |  |
| AC-71a07a7b | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5161 |  | DATA_OP | request.Parameters["PARAM5"] | cboAS.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-329ab8ed | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5162 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e63cbfac | this.cboAS.CheckedChanged [else of ((clbDivision.ControlValu… 외 1 | DMF0081_MktFcst_Auto.cs:5164 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a7fc76 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4489 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-61d1bc4f | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4490 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8a3904fa | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4491 |  | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-168f1906 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4492 |  | DATA_OP | request.Parameters["p_end_customer"] | sEdnCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3ded0865 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4493 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dc8d5d18 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4495 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80b8fbc9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4535 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_SPREAD_TITLE") ⇒ DM.DMF0081_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-a90e097f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4537 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-ab35df4f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4538 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-71acf9e8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4539 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a2aca99f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4540 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-9394109a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4542 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c6daa63 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4542 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0081_MktFcst_Auto.GetSpdTitle_Car

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1)] / this.btnCalculation.Click [try] / this.Load [if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1)] / clbDivision.SelectedIndexChanged [if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1)] / FindButton [try ▸ if (clbD…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-693e1334 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4571 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD") ⇒ DM.DMF0081_GET_SPREAD_TITLE_EXCEL_UPLOAD | 엔드포인트 요청 생성 |  |  |  |
| AC-885b1bda | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4573 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-d8b02928 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4574 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-17d7c3a5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4575 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3791200d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4576 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-5ad996e5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4578 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-7b2f4a6f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 7 | DMF0081_MktFcst_Auto.cs:4578 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0081_MktFcst_Auto.GetSpdTitle_PSI

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81")] / this.Load [if (clbDivision.ControlValues.Substring(0, 2) == "81")] / clbDivision.SelectedIndexChanged [if (clbDivision.ControlValues.Substring(0, 2) == "81")] / FindButton [try ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-704f3452 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4552 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_SPREAD_TITLE_PSI") ⇒ DM.DMF0081_GET_SPREAD_TITLE_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-afe2a493 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4554 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sMonth[0] | 행/컬럼 값 대입 |  |  |  |
| AC-1c1ede4e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4555 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sMonth[1] | 행/컬럼 값 대입 |  |  |  |
| AC-493bc923 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4556 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8eb0fa00 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4557 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-20a0d3db | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4559 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b22fbc5c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:4559 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## DMF0081_MktFcst_Auto.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b962985e | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4626 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c4776ed3 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4627 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b888d0db | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4628 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8512323 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4630 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.GetTitleSet

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b377f9c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6220 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0002_GET_TITLESET_POPUP") ⇒ DM.DMF0002_GET_TITLESET_POPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-cbc50a82 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6221 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0003" | 행/컬럼 값 대입 |  |  |  |
| AC-f45e12cb | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6222 |  | DATA_OP | request.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-a0b28e57 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6223 |  | DATA_OP | request.Parameters["p_column_type"] | "C" | 행/컬럼 값 대입 |  |  |  |
| AC-feb7d93d | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6224 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-71b9f41c | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6225 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d90f34a2 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6226 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fd3e3425 | FindButton 외 1 | DMF0081_MktFcst_Auto.cs:6227 |  | FLAG | _dtTitleSet | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_MktFcst_Auto.GetWeekNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31970984 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4798 |  | CALL_EXT | Convert.ToInt16 | (sYYYYMMDD.Substring(0, 4)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd0ab6d3 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4799 |  | CALL_EXT | Convert.ToInt16 | (sYYYYMMDD.Substring(4, 2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f09e639c | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4800 |  | CALL_EXT | Convert.ToInt16 | (sYYYYMMDD.Substring(6, 2)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b8974608 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4805 |  | CALL_EXT | calendarCalc.GetWeekOfYear | (calculationDate, CalendarWeekRule.FirstDay, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-80e078d6 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4807 |  | CALL_EXT | calendarCalc.GetWeekOfYear | (standardDate, CalendarWeekRule.FirstDay, DayOfWeek.Monday) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bf19b6c | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:4808 |  | RETURN | return weekNumber; |  | 처리 중단/반환 |  |  |  |

## DMF0081_MktFcst_Auto.HelpButton

진입점: this.btnManual.Click / this.btnGuide.Click / HelpButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3009f34 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6249 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpServer | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-db55b0ff | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6250 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpPort | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fffe4c67 | this.btnManual.Click 외 2 | DMF0081_MktFcst_Auto.cs:6251 |  | CALL_EXT | GSCM.App.Core.GAppSettings.GetHelpPath | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad2d304f | this.Load | DMF0081_MktFcst_Auto.cs:362 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-9fb9523f | this.Load | DMF0081_MktFcst_Auto.cs:362 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69ef5849 | this.Load | DMF0081_MktFcst_Auto.cs:363 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fca4bfaa | this.Load | DMF0081_MktFcst_Auto.cs:366 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-45e6a047 | this.Load | DMF0081_MktFcst_Auto.cs:366 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-78ac26b5 | this.Load | DMF0081_MktFcst_Auto.cs:367 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c0610ac3 | this.Load | DMF0081_MktFcst_Auto.cs:372 |  | STATE | lblEDISender.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d75efe44 | this.Load | DMF0081_MktFcst_Auto.cs:377 | if (sDivision == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0004d93c | this.Load | DMF0081_MktFcst_Auto.cs:377 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7e293fd0 | this.Load | DMF0081_MktFcst_Auto.cs:378 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7ee0b357 | this.Load | DMF0081_MktFcst_Auto.cs:380 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-ed3ae64f | this.Load | DMF0081_MktFcst_Auto.cs:380 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3d57dc74 | this.Load | DMF0081_MktFcst_Auto.cs:382 | if (sDivision == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c1d3e696 | this.Load | DMF0081_MktFcst_Auto.cs:383 | if (sDivision == "40") | STATE | lblPlantSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-66a47fb4 | this.Load | DMF0081_MktFcst_Auto.cs:384 | if (sDivision == "40") | STATE | btnProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d9ca0d67 | this.Load | DMF0081_MktFcst_Auto.cs:385 | if (sDivision == "40") | STATE | cboCellQty.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2e8e9c5f | this.Load | DMF0081_MktFcst_Auto.cs:391 | else of (sDivision == "40") | FLAG | dtBizType | GetBizTypebyDivision(sDivision) | 화면 필드/플래그 변경 |  |  |  |
| AC-82a2eb26 | this.Load | DMF0081_MktFcst_Auto.cs:392 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-03c08231 | this.Load | DMF0081_MktFcst_Auto.cs:394 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d79fb543 | this.Load | DMF0081_MktFcst_Auto.cs:394 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-175db164 | this.Load | DMF0081_MktFcst_Auto.cs:396 | else of (sDivision == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1652a378 | this.Load | DMF0081_MktFcst_Auto.cs:397 | else of (sDivision == "40") | STATE | lblPlantSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-823dc66b | this.Load | DMF0081_MktFcst_Auto.cs:398 | else of (sDivision == "40") | STATE | btnProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d19abfbf | this.Load | DMF0081_MktFcst_Auto.cs:399 | else of (sDivision == "40") | STATE | cboCellQty.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a456d6f4 | this.Load | DMF0081_MktFcst_Auto.cs:400 | else of (sDivision == "40") | VALUE_SET | cboCellQty.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6fba7d1e | this.Load | DMF0081_MktFcst_Auto.cs:415 | else of (sDivision == "40") ▸ else of (sDivision == "82") ▸ if (sDivision == "81") | STATE | lblEDISender.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ab483199 | this.Load | DMF0081_MktFcst_Auto.cs:417 | else of (sDivision == "40") ▸ else of (sDivision == "82") ▸ if (sDivision == "81") | FLAG | dtEdiSender | GetEdiSender() | 화면 필드/플래그 변경 |  |  |  |
| AC-bd4fce0f | this.Load | DMF0081_MktFcst_Auto.cs:418 | else of (sDivision == "40") ▸ else of (sDivision == "82") ▸ if (sDivision == "81") | LIST_REBIND | clsCtrl.setListBox | (dtEdiSender, clbEDISender, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-09ef831c | this.Load | DMF0081_MktFcst_Auto.cs:426 |  | STATE | lblBizType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-196ca138 | this.Load | DMF0081_MktFcst_Auto.cs:427 |  | VALUE_SET | chkColor.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-28ef43d5 | this.Load | DMF0081_MktFcst_Auto.cs:428 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4b75dbb2 | this.Load | DMF0081_MktFcst_Auto.cs:430 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-2a637ab7 | this.Load | DMF0081_MktFcst_Auto.cs:433 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f721ee90 | this.Load | DMF0081_MktFcst_Auto.cs:433 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d611bf6b | this.Load | DMF0081_MktFcst_Auto.cs:434 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-167b2ee4 | this.Load | DMF0081_MktFcst_Auto.cs:438 | if (sDivision.IndexOf("81") != -1) | FLAG | dtPlantSite | Data.UserPlantSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-0480194e | this.Load | DMF0081_MktFcst_Auto.cs:438 | if (sDivision.IndexOf("81") != -1) | COMBO_DATA | Data.UserPlantSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3aa47fb0 | this.Load | DMF0081_MktFcst_Auto.cs:439 | if (sDivision.IndexOf("81") != -1) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSite, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c21a8c28 | this.Load | DMF0081_MktFcst_Auto.cs:442 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-849cf781 | this.Load | DMF0081_MktFcst_Auto.cs:443 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f4890539 | this.Load | DMF0081_MktFcst_Auto.cs:445 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-aa60269c | this.Load | DMF0081_MktFcst_Auto.cs:446 |  | VALUE_SET | drpPeriod1.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-5a4bb918 | this.Load | DMF0081_MktFcst_Auto.cs:451 |  | VALUE_SET | rdoSimulation3.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6b5a1b09 | this.Load | DMF0081_MktFcst_Auto.cs:454 |  | UI_PROP | btnToggle.Tag | "Visible_False" | 속성 Tag 설정 |  |  |  |
| AC-b39ca1ac | this.Load | DMF0081_MktFcst_Auto.cs:456 |  | FLAG | dtItemType | GetItemType() | 화면 필드/플래그 변경 |  |  |  |
| AC-232f420b | this.Load | DMF0081_MktFcst_Auto.cs:457 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, clbItemType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9213c49a | this.Load | DMF0081_MktFcst_Auto.cs:460 |  | CALL_EXT | toolTip1.SetToolTip | (btnColumn, "Column Show") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3c5286f | this.Load | DMF0081_MktFcst_Auto.cs:461 |  | CALL_EXT | toolTip1.SetToolTip | (btnMeasure, "Measure") | ⚠ 의미 확인 필요 |  |  |  |
| AC-42062400 | this.Load | DMF0081_MktFcst_Auto.cs:466 |  | UI_PROP | splitContainer2.SplitterDistance | (int)(splitContainer2.ClientSize.Height * 0.42) | 속성 SplitterDistance 설정 |  |  |  |
| AC-13023e87 | this.Load | DMF0081_MktFcst_Auto.cs:468 |  | UI_PROP | this.btnCalculation.LookAndFeel.Style | DevExpress.LookAndFeel.LookAndFeelStyle.UltraFlat | 속성 Style 설정 |  |  |  |
| AC-6bf4c85c | this.Load | DMF0081_MktFcst_Auto.cs:469 |  | UI_PROP | this.btnCalculation.LookAndFeel.UseDefaultLookAndFeel | false | 속성 UseDefaultLookAndFeel 설정 |  |  |  |
| AC-46c25433 | this.Load | DMF0081_MktFcst_Auto.cs:470 |  | UI_PROP | this.btnCalculation.Appearance.BackColor | Color.FromArgb(0, 150, 149) | 속성 BackColor 설정 |  |  |  |
| AC-d02ef7f8 | this.Load | DMF0081_MktFcst_Auto.cs:471 |  | UI_PROP | this.btnCalculation.Appearance.ForeColor | Color.White | 속성 ForeColor 설정 |  |  |  |
| AC-9505c8cc | this.Load | DMF0081_MktFcst_Auto.cs:472 |  | UI_PROP | this.btnCalculation.Appearance.FontStyleDelta | FontStyle.Bold | 속성 FontStyleDelta 설정 |  |  |  |
| AC-1efb3560 | this.Load | DMF0081_MktFcst_Auto.cs:473 |  | UI_PROP | this.btnCalculation.Appearance.Options.UseBackColor | true | 속성 UseBackColor 설정 |  |  |  |
| AC-dea06233 | this.Load | DMF0081_MktFcst_Auto.cs:478 |  | UI_PROP | layoutControlItem7.ContentVisible | false | 속성 ContentVisible 설정 |  |  |  |

## DMF0081_MktFcst_Auto.InitSaveDataTable

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9be78dee | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:882 |  | FLAG | dtSave | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-13b6407f | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:883 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-03f752b1 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:884 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5c834bb | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:885 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-706b360e | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:886 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1f470ed | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:887 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b38f6e93 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:888 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd4d953e | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:889 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-611a8da0 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:890 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0b5cbd8 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:891 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5004a44 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:892 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlantSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b3a306d | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:893 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5de6c1f | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:894 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d30062fa | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:896 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Customer40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f820f5ee | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:897 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSiteId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1565c5ec | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:898 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ItemId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b829b54e | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:900 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.AS_FROM_SITE, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1385ba6b | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:902 |  | FLAG | dtSaveFinal | new DataTable("MktFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-acd9f5fa | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:903 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11f3274d | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:904 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Project, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bad79eea | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:905 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ScmSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47f4da35 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:906 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ItemId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f2e005 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:907 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.DomExp, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b67a59 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:908 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0e020b9 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:909 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.FcstType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1401d051 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:910 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5657e5db | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:911 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.PlantSiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-483b08a7 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:912 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-81a30226 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:913 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Qty, typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43d42412 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:915 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.Customer40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7781f939 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:916 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ScmSiteId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3784cc96 | this.Load 외 1 | DMF0081_MktFcst_Auto.cs:917 |  | DATA_OP | dtSaveFinal.Columns.Add | (DefColumns.ItemId40, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0081_MktFcst_Auto.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / clbDivision.SelectedIndexChanged / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf93fab | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:551 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-b20e9ad2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:555 | if (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | splitContainer2.SplitterDistance | 314 | 속성 SplitterDistance 설정 |  |  |  |
| AC-aed7d654 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:556 | if (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | splitContainer2.Panel1Collapsed | false | 속성 Panel1Collapsed 설정 |  |  |  |
| AC-ba79ce03 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:557 | if (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | tableLayoutPanel1.Height | 16 | 속성 Height 설정 |  |  |  |
| AC-7f597350 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:559 | if (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | btnUpDown.ImageOptions.Image | up | 속성 Image 설정 |  |  |  |
| AC-d1bc4a21 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:563 | else of (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | splitContainer2.Panel1Collapsed | true | 속성 Panel1Collapsed 설정 |  |  |  |
| AC-bea2db22 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:564 | else of (clbDivision.ControlValues.Substring(0, 2) == "81") | UI_PROP | tableLayoutPanel1.Height | 0 | 속성 Height 설정 |  |  |  |
| AC-660a6d2b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:573 | if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |
| AC-77bd2115 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:579 | if (clbDivision.ControlValues.Substring(0, 2) == "81") | GRID_INIT | siSub1.CreateSheetHeaderColumn | (siSub1, 3, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-40e200ac | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:587 | if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |
| AC-fcf0445e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:592 | else of (clbDivision.ControlValues.Substring(0, 2) == "81") | CALL_EXT | siMain.RemoveRowAll | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-06a21298 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:598 | if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1) | GRID_INIT | siSub2.CreateSheetHeaderColumn | (siSub2, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-e85b6e36 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:605 | if (clbDivision.ControlValues.Substring(0, 2) == "81" && siSub2.GetMaxRowIndex() == -1) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) | FLAG | dtTitle | null | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_MktFcst_Auto.InitSpread_Car

진입점: this.btnCalculation.Click [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08f64554 | this.btnCalculation.Click [try] 외 1 | DMF0081_MktFcst_Auto.cs:5864 | for (i <= dtCarTitle.Rows.Count - 1) | DATA_OP | dtTitle.Rows.Add | (new object[] { "DMF0081", "Car Fcst", PLAN_YYYYMM, PLAN_YYYYMM.Substring(4, 2)+"월", 30 + … | 데이터 객체 조작/조회 |  |  |  |
| AC-0b0c9581 | this.btnCalculation.Click [try] 외 1 | DMF0081_MktFcst_Auto.cs:5867 |  | GRID_INIT | siSub2.CreateSheetHeaderColumn | (siSub2, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0081_MktFcst_Auto.InitSpreadFooterSum

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (r…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-459eff6a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:613 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e16c99ca | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:614 |  | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, 1].Value | "Sum" | 그리드 속성/값 설정 |  |  |  |
| AC-029ece36 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:622 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationFormat | (0, iCol, "{0:#,##0.###}") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e487223 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:623 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | CALL_EXT | siMain.ActiveSheet.ColumnFooter.SetAggregationType | (0, iCol, FarPoint.Win.Spread.Model.AggregationType.SumIgnoreHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6bb0b9e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:624 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-1aa7fb13 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:625 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("M_") == … | GRID_SET | siMain.ActiveSheet.ColumnFooter.Cells[0, iCol].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d545cf33 | InsertButton | DMF0081_MktFcst_Auto.cs:1786 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eac9c3cd | InsertButton | DMF0081_MktFcst_Auto.cs:1787 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5759a0e8 | InsertButton | DMF0081_MktFcst_Auto.cs:1798 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_SET | siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.Project)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-560bf2b8 | InsertButton | DMF0081_MktFcst_Auto.cs:1800 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_SET | siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-0a0942a7 | InsertButton | DMF0081_MktFcst_Auto.cs:1802 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if ((clbDivision.ControlValues… | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Division), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-10b20283 | InsertButton | DMF0081_MktFcst_Auto.cs:1807 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of ((clbDivision.ControlV… | GRID_SET | siMain.ActiveSheet.Cells[iActRow, siMain.GetColumnIndex(DefColumns.ItemId40)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-f5f96592 | InsertButton | DMF0081_MktFcst_Auto.cs:1809 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of ((clbDivision.ControlV… | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Division40), clbDivision.ControlValues) | 그리드 값 설정 |  |  |  |
| AC-b1541419 | InsertButton | DMF0081_MktFcst_Auto.cs:1813 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of ((clbDivision.ControlV… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.DomExp), dtCustomsHandbook) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ff9dbfb5 | InsertButton | DMF0081_MktFcst_Auto.cs:1817 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cf5c80a7 | InsertButton | DMF0081_MktFcst_Auto.cs:1828 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5babc16f | InsertButton | DMF0081_MktFcst_Auto.cs:1832 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.FcstType), dtWarrType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0eb8795c | InsertButton | DMF0081_MktFcst_Auto.cs:1843 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", sTeam, UserInfoContext.Current["NowGroupID"… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9e3a6de0 | InsertButton | DMF0081_MktFcst_Auto.cs:1844 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5250a77 | InsertButton | DMF0081_MktFcst_Auto.cs:1851 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-93c599bc | InsertButton | DMF0081_MktFcst_Auto.cs:1853 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Customer40), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-fbdc3317 | InsertButton | DMF0081_MktFcst_Auto.cs:1855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") ▸ if (s… | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e40d9042 | InsertButton | DMF0081_MktFcst_Auto.cs:1860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0f7a79 | InsertButton | DMF0081_MktFcst_Auto.cs:1860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7862d304 | InsertButton | DMF0081_MktFcst_Auto.cs:1861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e67d5a0f | InsertButton | DMF0081_MktFcst_Auto.cs:1865 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa2fb7cd | InsertButton | DMF0081_MktFcst_Auto.cs:1866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ffdc944 | InsertButton | DMF0081_MktFcst_Auto.cs:1873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") ▸ … | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Team), dtTeamAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e3e6dc6e | InsertButton | DMF0081_MktFcst_Auto.cs:1875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") ▸ … | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Customer), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cb634abb | InsertButton | DMF0081_MktFcst_Auto.cs:1877 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") ▸ … | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-db81ff9c | InsertButton | DMF0081_MktFcst_Auto.cs:1883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, Us… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-8fc10865 | InsertButton | DMF0081_MktFcst_Auto.cs:1883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d792a10 | InsertButton | DMF0081_MktFcst_Auto.cs:1884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-74ed5d37 | InsertButton | DMF0081_MktFcst_Auto.cs:1887 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.SetValue | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), "MKT_FCST_RP") | 그리드 값 설정 |  |  |  |
| AC-21fbe586 | InsertButton | DMF0081_MktFcst_Auto.cs:1892 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.Division), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8963af0c | InsertButton | DMF0081_MktFcst_Auto.cs:1894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.Division40), iRowCount, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-adc8077e | InsertButton | DMF0081_MktFcst_Auto.cs:1896 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.BizType), iRowCount, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9e198e6 | InsertButton | DMF0081_MktFcst_Auto.cs:1898 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.SoldToCustomer), iRowCount, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-aaa68168 | InsertButton | DMF0081_MktFcst_Auto.cs:1900 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.CountryName), iRowCount, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-26473870 | InsertButton | DMF0081_MktFcst_Auto.cs:1902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.CityName), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd841870 | InsertButton | DMF0081_MktFcst_Auto.cs:1904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ProjectName), iRowCount, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b86ed992 | InsertButton | DMF0081_MktFcst_Auto.cs:1906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ProjectStatus), iRowCount, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d77ce6c | InsertButton | DMF0081_MktFcst_Auto.cs:1908 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ProjectOwner), iRowCount, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f66c4850 | InsertButton | DMF0081_MktFcst_Auto.cs:1910 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ItemName), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-538eca64 | InsertButton | DMF0081_MktFcst_Auto.cs:1912 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.NickName), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b1f4cdf | InsertButton | DMF0081_MktFcst_Auto.cs:1914 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ItemType), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5a5fe4a | InsertButton | DMF0081_MktFcst_Auto.cs:1916 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP), iRowCount, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ddb97520 | InsertButton | DMF0081_MktFcst_Auto.cs:1918 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.CUST_GROUP_DTL), iRowCount, siMain.GetColumnInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a286d29c | InsertButton | DMF0081_MktFcst_Auto.cs:1920 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.Owner), iRowCount, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a9ab096 | InsertButton | DMF0081_MktFcst_Auto.cs:1922 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.APPLICATION), iRowCount, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a0671e0 | InsertButton | DMF0081_MktFcst_Auto.cs:1924 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.ROUTE), iRowCount, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-026c5a09 | InsertButton | DMF0081_MktFcst_Auto.cs:1926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.MDM_PROJECT_NAME), iRowCount, siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abe56bdf | InsertButton | DMF0081_MktFcst_Auto.cs:1928 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.MIN_CAPACITY), iRowCount, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca1e8700 | InsertButton | DMF0081_MktFcst_Auto.cs:1930 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_BIZ_TYPE), iRowCount, siMain.GetC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b4522bb | InsertButton | DMF0081_MktFcst_Auto.cs:1932 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.CellType), iRowCount, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f50caac | InsertButton | DMF0081_MktFcst_Auto.cs:1934 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_MODEL), iRowCount, siMain.Ge… | 그리드 편집 잠금/해제 |  |  |  |
| AC-92e3f181 | InsertButton | DMF0081_MktFcst_Auto.cs:1936 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_CELL_PACK_COUNT), iRowCount, siMa… | 그리드 편집 잠금/해제 |  |  |  |
| AC-766ae51a | InsertButton | DMF0081_MktFcst_Auto.cs:1938 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.FORECAST_INFO_SPEC), iRowCount, siMain.GetColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcc80797 | InsertButton | DMF0081_MktFcst_Auto.cs:1940 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.VMI_YN), iRowCount, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a7c3c0e | InsertButton | DMF0081_MktFcst_Auto.cs:1942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.DMS_SALES), iRowCount, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c432dfb3 | InsertButton | DMF0081_MktFcst_Auto.cs:1944 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowCount, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9be83da | InsertButton | DMF0081_MktFcst_Auto.cs:1947 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.AS_FROM_SITE), iRowCount, siMain.GetColumnIndex… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8d670115 | InsertButton | DMF0081_MktFcst_Auto.cs:1950 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), iRowCount, siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f11bc995 | InsertButton | DMF0081_MktFcst_Auto.cs:1952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), iRowCount, siMain.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e594c1c | InsertButton | DMF0081_MktFcst_Auto.cs:1954 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.SENDER_CODE), iRowCount, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fbf88833 | InsertButton | DMF0081_MktFcst_Auto.cs:1956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnIndex(DefC… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.SENDER_NAME), iRowCount, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce5a82bc | InsertButton | DMF0081_MktFcst_Auto.cs:1959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetText(iActRow, si… | GRID_LOCK | siMain.LockRange | (iActRow, siMain.GetColumnIndex(DefColumns.Measure), siMain.GetMaxRowIndex(), siMain.GetCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f48bb175 | InsertButton | DMF0081_MktFcst_Auto.cs:1984 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (chkColor.Checked == true) … | GRID_LOCK | siMain.LockRange | (iRow, iStartCol, iRow, iResultCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f3dc9b02 | InsertButton | DMF0081_MktFcst_Auto.cs:1986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (chkColor.Checked == true) … | GRID_STYLE | siMain.SetBGColor | (0, iStartCol, siMain.GetMaxRowIndex(), iResultCol, Color.Gainsboro) | 그리드 표시 설정 |  |  |  |
| AC-c9212a9f | InsertButton | DMF0081_MktFcst_Auto.cs:1987 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (chkColor.Checked == true) … | GRID_STYLE | siMain.SetBGColor | (0, iResultMonth, siMain.GetMaxRowIndex(), iResultMonth, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-81fa029e | InsertButton | DMF0081_MktFcst_Auto.cs:1999 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (chkColor.Checked == t… | FLAG | sResult_YYYYMMWW | "W_" + sResultYYYYMMDD.Substring(0, 6) + iso_week | 화면 필드/플래그 변경 |  |  |  |
| AC-bc58cf0e | InsertButton | DMF0081_MktFcst_Auto.cs:2000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (chkColor.Checked == t… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(sResult_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-66a3e5e9 | InsertButton | DMF0081_MktFcst_Auto.cs:2004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (chkColor.Checked == t… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(this_YYYYMMWW)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-11de8477 | InsertButton | DMF0081_MktFcst_Auto.cs:2009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (chkColor.Checked == t… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("D_" + sResultYYYYMMDD)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-beb536d2 | InsertButton | DMF0081_MktFcst_Auto.cs:2023 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3d1c1583 | InsertButton | DMF0081_MktFcst_Auto.cs:2034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e3e754ca | InsertButton | DMF0081_MktFcst_Auto.cs:2054 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-de5a08dd | InsertButton | DMF0081_MktFcst_Auto.cs:2075 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2935e915 | InsertButton | DMF0081_MktFcst_Auto.cs:2087 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-877da2e0 | InsertButton | DMF0081_MktFcst_Auto.cs:2096 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d95cb2f2 | InsertButton | DMF0081_MktFcst_Auto.cs:2099 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee633e52 | InsertButton | DMF0081_MktFcst_Auto.cs:2103 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-148e346a | InsertButton | DMF0081_MktFcst_Auto.cs:2116 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e0a17f70 | InsertButton | DMF0081_MktFcst_Auto.cs:2119 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4630f9df | InsertButton | DMF0081_MktFcst_Auto.cs:2122 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-77570ef8 | InsertButton | DMF0081_MktFcst_Auto.cs:2128 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a58d03f6 | InsertButton | DMF0081_MktFcst_Auto.cs:2132 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iCol <= siMain.GetMaxColu… | GRID_LOCK | siMain.LockRange | (iRow, iCol, iRow, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d49cb702 | InsertButton | DMF0081_MktFcst_Auto.cs:2138 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0081_MktFcst_Auto.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1900ea22 | OnShown | DMF0081_MktFcst_Auto.cs:341 | if (UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)") | VALUE_SET | cboAS.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b7424e40 | OnShown | DMF0081_MktFcst_Auto.cs:342 | if (UserInfoContext.Current["NowGroupID"] == "DM Planner (W/S)") | STATE | cboAS.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51cc5fe9 | OnShown | DMF0081_MktFcst_Auto.cs:349 | if (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-bf2314c5 | OnShown | DMF0081_MktFcst_Auto.cs:353 | else of (sDivision == "82") | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.rdoSimulation_SelectedIndexChanged

진입점: this.rdoSimulation1.CheckedChanged / this.rdoSimulation2.CheckedChanged / this.rdoSimulation3.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33964963 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6082 | if (siSub1 != null) ▸ switch (sCase) case "3": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_03": case "PRODUCT_0… | GRID_INIT | siSub1.VisibleColumns | (i, true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-17b5de8b | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6091 | if (siSub1 != null) ▸ switch (sCase) case "3": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_06": case "PRODUCT_0… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5e6a7155 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6100 | if (siSub1 != null) ▸ switch (sCase) case "3": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_12": case "PRODUCT_1… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e3c74a62 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6119 | if (siSub1 != null) ▸ switch (sCase) case "6": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_03": case "PRODUCT_0… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9a73c7f2 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6128 | if (siSub1 != null) ▸ switch (sCase) case "6": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_06": case "PRODUCT_0… | GRID_INIT | siSub1.VisibleColumns | (i, true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f37a8ac | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6137 | if (siSub1 != null) ▸ switch (sCase) case "6": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_12": case "PRODUCT_1… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e6c409ee | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6156 | if (siSub1 != null) ▸ switch (sCase) case "12": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_03": case "PRODUCT_… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9992fa6c | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6165 | if (siSub1 != null) ▸ switch (sCase) case "12": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_06": case "PRODUCT_… | GRID_INIT | siSub1.VisibleColumns | (i, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85106155 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6174 | if (siSub1 != null) ▸ switch (sCase) case "12": ▸ for (i <= siSub1.GetMaxColumnIndex()) ▸ switch (sColumnName) case "SUM_12": case "PRODUCT_… | GRID_INIT | siSub1.VisibleColumns | (i, true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-13da05fa | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6204 | if (siSub1 != null) ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.RESULT), sData) | 그리드 값 설정 |  |  |  |
| AC-f9bbfd63 | this.rdoSimulation1.CheckedChanged 외 2 | DMF0081_MktFcst_Auto.cs:6205 | if (siSub1 != null) ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.MKT_DP), sData) | 그리드 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c54a5494 | SaveButton | DMF0081_MktFcst_Auto.cs:1606 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation(out bInputCh… | MESSAGE | MessageHelper.GMessageBox | ("MSG00043") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2206877 | SaveButton | DMF0081_MktFcst_Auto.cs:1607 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!fnValidation(out bInputCh… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae88d70c | SaveButton | DMF0081_MktFcst_Auto.cs:1612 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | MESSAGE | MessageHelper.GMessageBox | ("MSG00034") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df1f3ebf | SaveButton | DMF0081_MktFcst_Auto.cs:1613 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!bInputCheck) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9907e1bf | SaveButton | DMF0081_MktFcst_Auto.cs:1682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboAS.Checked == true && s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00366") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2def684a | SaveButton | DMF0081_MktFcst_Auto.cs:1683 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (cboAS.Checked == true && s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae23fcec | SaveButton | DMF0081_MktFcst_Auto.cs:1696 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0003_SAVE_MKT_FCST | 엔드포인트 요청 생성 |  |  |  |
| AC-28012129 | SaveButton | DMF0081_MktFcst_Auto.cs:1697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c88402b9 | SaveButton | DMF0081_MktFcst_Auto.cs:1698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-64e4fb36 | SaveButton | DMF0081_MktFcst_Auto.cs:1699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-84f85795 | SaveButton | DMF0081_MktFcst_Auto.cs:1700 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-90269f5f | SaveButton | DMF0081_MktFcst_Auto.cs:1701 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-eea8851e | SaveButton | DMF0081_MktFcst_Auto.cs:1702 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dom_exp"] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-15a069ba | SaveButton | DMF0081_MktFcst_Auto.cs:1703 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_fcst_type"] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-d75828f6 | SaveButton | DMF0081_MktFcst_Auto.cs:1704 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-fc2ed4d1 | SaveButton | DMF0081_MktFcst_Auto.cs:1705 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-1b591dee | SaveButton | DMF0081_MktFcst_Auto.cs:1706 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_site_id"] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3a66caef | SaveButton | DMF0081_MktFcst_Auto.cs:1707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-a246523b | SaveButton | DMF0081_MktFcst_Auto.cs:1708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_qty"] | sQty | 행/컬럼 값 대입 |  |  |  |
| AC-bdae5087 | SaveButton | DMF0081_MktFcst_Auto.cs:1709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-e4fa3546 | SaveButton | DMF0081_MktFcst_Auto.cs:1710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_as_from_site"] | sASFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-358bac64 | SaveButton | DMF0081_MktFcst_Auto.cs:1712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | UI_PROP | request.CommandTimeout | 1000 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-4f67a78e | SaveButton | DMF0081_MktFcst_Auto.cs:1714 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9f7fe191 | SaveButton | DMF0081_MktFcst_Auto.cs:1720 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8b783a6 | SaveButton | DMF0081_MktFcst_Auto.cs:1725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | POPUP | new DMF0003_SspSyncPopUp | () | 팝업/폼 생성 |  |  |  |
| AC-1982546d | SaveButton | DMF0081_MktFcst_Auto.cs:1726 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | CALL_EXT | popup.LoadData | (response.DataSet.Tables[1], "40") | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa13ecc1 | SaveButton | DMF0081_MktFcst_Auto.cs:1727 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cd05b4a9 | SaveButton | DMF0081_MktFcst_Auto.cs:1728 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-058ba44a | SaveButton | DMF0081_MktFcst_Auto.cs:1734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57ca65bb | SaveButton | DMF0081_MktFcst_Auto.cs:1735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55cc43bf | SaveButton | DMF0081_MktFcst_Auto.cs:1737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-aad4871f | SaveButton | DMF0081_MktFcst_Auto.cs:1738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | FLAG | base.IsChange | false | 화면 필드/플래그 변경 |  |  |  |
| AC-99843a5e | SaveButton | DMF0081_MktFcst_Auto.cs:1744 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6a7d156 | SaveButton | DMF0081_MktFcst_Auto.cs:1748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ finally | STATE_RESET | dtSaveFinal.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bf5d2c4c | SaveButton | DMF0081_MktFcst_Auto.cs:1753 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00034") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0081_MktFcst_Auto.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cef3318 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3654 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2537597f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3662 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b61db639 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3667 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sItemId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b7e3e262 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3672 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sDivision.Substring(0, 2) == "81" && sPlantSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6509a444 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3680 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sEndCustomer40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4da2926 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3685 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sScmSiteId40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71b16f4d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3690 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) ▸ if (sItemId40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6ac7c16 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3697 | if (sIncoterms == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf86f86a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3702 | if (sFcstType == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9cc3420 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3707 | if (((sDivision == "40") \|\| (sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) && (sDomExp == "")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30616ab2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3712 | if (sMeasure == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2627445d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3716 | if (sYYYYMMDD.Length != 8) | MESSAGE | MessageBox.Show | ("YYYYMMDD형식이 맞지 않습니다.") | 메시지 표시 |  |  |  |
| AC-496debc2 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3717 | if (sYYYYMMDD.Length != 8) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e95867d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3741 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-63ff83d1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3745 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed4be1b1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3746 | if (drFind.Length == 0) | DATA_OP | drNew["Action"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-f27e87aa | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3747 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a6f725d5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3748 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Project] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-bc5d4f01 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3749 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId] | sSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-f2357adc | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3750 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-4e4b6f89 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3751 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DomExp] | sDomExp | 행/컬럼 값 대입 |  |  |  |
| AC-99a1d6bf | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3752 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.FcstType] | sFcstType | 행/컬럼 값 대입 |  |  |  |
| AC-036532b8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3753 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-9210b222 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3754 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-60a46dbe | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3755 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlantSiteId] | sPlantSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-d852643f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3756 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-52f36a7c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3757 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-413a5ba3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3759 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Customer40] | sEndCustomer40 | 행/컬럼 값 대입 |  |  |  |
| AC-7b67ffab | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3760 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSiteId40] | sScmSiteId40 | 행/컬럼 값 대입 |  |  |  |
| AC-04d621b9 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3761 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ItemId40] | sItemId40 | 행/컬럼 값 대입 |  |  |  |
| AC-ac0151bc | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3763 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.AS_FROM_SITE] | sAsFromSite | 행/컬럼 값 대입 |  |  |  |
| AC-524e7252 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3766 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-979ab208 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3767 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e581587 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3771 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.Qty] | iQty | 행/컬럼 값 대입 |  |  |  |
| AC-36d1a87f | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3772 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0081_MktFcst_Auto.SetSaveDataRemove

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) ▸ else of ((sBucketType == BucketType.Weekly) && sColName.IndexOf("W_") == 0) ▸ else of (sBucketType == BucketType.Monthly && sColName.IndexOf("M_") == 0) ▸ else of ((sBucketType == BucketType.Weekly \|\| sBucketType == BucketType.Monthly) && (sColName.IndexOf("D_") == 0)) ▸ if (sColName.IndexOf("D_") != 0 && sColName.IndexOf("W_") != 0 && sColName.IndexOf("M_") != 0 && sColName.Trim() != "COLMERG…) ▸ if (siMain.GetText(e.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e419649 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3783 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea87b91c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3791 | if (sDivision != "40") ▸ if (sSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa7f2155 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3796 | if (sDivision != "40") ▸ if (sItemId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c933c8f1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3801 | if (sDivision != "40") ▸ if (sDivision.Substring(0, 2) == "81" && sPlantSiteId == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6b6b3ebd | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3809 | else of (sDivision != "40") ▸ if (sEndCustomer40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16d3916e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3814 | else of (sDivision != "40") ▸ if (sScmSiteId40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea81f886 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3819 | else of (sDivision != "40") ▸ if (sItemId40 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b13cc2e4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3826 | if (sIncoterms == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87dcc93c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3831 | if (sFcstType == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91065498 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3836 | if (sDomExp == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9500e57c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3841 | if (sMeasure == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-186482a4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3860 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f0f3072 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3866 | if (drFind.Length > 0) ▸ for (i < drFind.Length) | DATA_OP | dtSave.Rows.Remove | (drFind[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-a85bb365 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3867 | if (drFind.Length > 0) ▸ for (i < drFind.Length) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0081_MktFcst_Auto.SetSaveSheetColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4275d174 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:1768 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_SET | siMain.SetText | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), "") | 그리드 값 설정 |  |  |  |
| AC-471fbbcc | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:1769 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_STYLE | siMain.SetBGColor | (iRow, siMain.GetColumnIndex(CAppSetting.StringAction), iRow, siMain.GetColumnIndex(CAppSe… | 그리드 표시 설정 |  |  |  |
| AC-da690e01 | (진입점 미연결) | DMF0081_MktFcst_Auto.cs:1770 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringM \|\… | GRID_LOCK | siMain.LockRange2 | (iRow, siMain.GetColumnIndex(DefColumns.Measure) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금 전환 |  |  |  |

## DMF0081_MktFcst_Auto.SetSpreadColumn

진입점: this.chkColor.CheckedChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try ▸ if (siMain.GetMaxRowIndex() >= 0)] / SaveBu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f4b6c96 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4025 |  | FLAG | sResultYYYYMMDD | dateTime2.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-c6c5846e | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4033 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("D_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-139615ed | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4036 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-64a2475a | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4041 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9d0783b | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4043 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-eacdc801 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4046 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e9686c8c | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4051 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0b31133d | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4053 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3385774e | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4062 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-313305a0 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4063 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-39ff43ac | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4064 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ if (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siMain.G… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Width | 60 | 그리드 속성/값 설정 |  |  |  |
| AC-ad276249 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4071 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-c41c5935 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4072 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-8ab04e96 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4079 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ForeColor | Color.Green | 그리드 속성/값 설정 |  |  |  |
| AC-8efadab7 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4080 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (chkColor.Checked == false) ▸ else of (siMain.GetColumnTag(iCol).IndexOf("M_") == 0) ▸ if (siM… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[iCol].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |
| AC-a98b1f77 | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4087 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | GRID_STYLE | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetForeColor | () | 그리드 표시 설정 |  |  |  |
| AC-d47f88fb | this.chkColor.CheckedChanged [if (siMain != null)] 외 8 | DMF0081_MktFcst_Auto.cs:4088 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (chkColor.Checked == false) ▸ if (chkColor.Checked == true) | CALL_EXT | siMain.ActiveSheet.ColumnHeader.Columns[iCol].ResetFont | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.SetSpreadHeaderSpan

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / this.Load [if (dtTitle != null && dtTitle.Rows.Count > 0)] / clbDivision.SelectedIndexChanged [if (dtTitle != null && dtTitle.Rows.Count > 0)] / FindButton [try ▸ if (dtTitle != null && dtTitle.Rows.Count > 0)] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (r…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25b378ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:657 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f3b2801 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:665 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-643fe460 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:678 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ … | GRID_SET | siMain.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cdd8cb7f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:688 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04a5254d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:689 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1298f850 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:694 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94c9c81f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:695 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-778db477 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:702 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b74d2a4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:703 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74a962b2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:714 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b183a2d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:715 |  | GRID_INIT | siMain.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-354c57d2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:716 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b46b2295 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:717 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e627537 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:719 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.Measure) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed8c466e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:721 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_MktFcst_Auto.SetSpreadHeaderSpan_SUB1

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (clbDivision.ControlValues.Substring(0, 2) == "81")] / this.Load [if (clbDivision.ControlValues.Substring(0, 2) == "81") ▸ if (dtTitle != null && dtTitle.Rows.Count > 0) ▸ if (clbDivision.ControlV…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e949563a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:754 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M3_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 6, 1, 2, 20, "M-3", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87cded05 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:755 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M3_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 6, 2, 1, 20, "Cust.FCST", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c755430 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:756 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M3_CUST_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38f929f5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:759 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M3_MKT_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 7, 2, 1, 20, "MKT.FCST(DP)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1ad14e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:760 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M3_MKT_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b07bce66 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:763 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M2_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 8, 1, 2, 20, "M-2", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d794ed6d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:764 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M2_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 8, 2, 1, 20, "Cust.FCST", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77d87b32 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:765 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M2_CUST_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ba7d8997 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:768 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M2_MKT_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 9, 2, 1, 20, "MKT.FCST(DP)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc7436d3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:769 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M2_MKT_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-484c2df4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:772 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M1_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 10, 1, 2, 20, "M-1", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3536a29a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:773 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M1_CUST_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 10, 2, 1, 20, "Cust.FCST", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cdc72f6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:774 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M1_CUST_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-78e68283 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:777 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M1_MKT_FCST_QTY": | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 11, 2, 1, 20, "MKT.FCST(DP)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb99504d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:778 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) case "M1_MKT_FCST_QTY": | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a400c03 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:781 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= 14) ▸ switch (sColumnName) default: | GRID_INIT | siSub1.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8dc9c781 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:791 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db4b623e | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:802 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ else of (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) ▸ if (dr[DefCo… | GRID_SET | siSub1.Sheet().ColumnHeader.Cells[2, iCellCnt].ForeColor | dr[DefColumns.DayCode].ToString() == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-27f8b31a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:810 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siSub1.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c4ca252 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:815 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siSub1.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a56d9d46 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:822 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabel… | GRID_INIT | siSub1.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f009c2b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:845 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= 14) ▸ switch (sColumnName) case "SUM_06": case "SUM_12": case "PRODUCT_06": case "PRO… | GRID_INIT | siSub1.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d159db1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:855 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 14, 2, 1, 20, "ⓑ(SUM)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfa88bbb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:856 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 15, 2, 1, 20, "ⓑ(SUM)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9debd39 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:857 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 16, 2, 1, 20, "ⓑ(SUM)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87303d71 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:858 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 17, 1, 9, 20, "Customer", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc2625aa | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:859 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (1, 26, 1, 9, 20, "LGES", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6791d375 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:860 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 14, 1, 21, 20, "Analysis of demand changes by factors", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb489374 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:861 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 35, 3, 1, 20, "ⓒResult (ⓐ+ⓑ)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6bea1794 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:862 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 36, 3, 1, 20, "ⓓMKT.FCST (DP)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6dea931b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:863 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 37, 3, 1, 20, "GAP (ⓒ-ⓓ)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fac67b3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:864 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 38, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b6691f1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:865 |  | GRID_INIT | siSub1.ColumnHeaderSpan | (0, 39, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1eece04a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | DMF0081_MktFcst_Auto.cs:868 |  | GRID_INIT | siSub1.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d9de010 | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4770 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PlantSiteId) \|\| sDivision.Substring(0… | FLAG | dtPlantSite | Data.Common(Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 화면 필드/플래그 변경 |  |  |  |
| AC-fb53cf6f | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4770 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PlantSiteId) \|\| sDivision.Substring(0… | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByItem, false, "", sDivision, sProject, sItem) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByItem] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3a077e48 | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4771 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PlantSiteId) \|\| sDivision.Substring(0… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4ae75d0c | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4784 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (sDivision == "82") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure) && si… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sScmSite, sProject, UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e0df9290 | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4784 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (sDivision == "82") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure) && si… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivision, sScmSite, sProject, UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-53d2e6fa | this.spdMain.CellClick | DMF0081_MktFcst_Auto.cs:4785 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (sDivision == "82") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Measure) && si… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a233c845 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2527 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1c8b954 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2605 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35fd7002 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2612 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16cfb5e3 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2621 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-904d9eda | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2627 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0169fb0 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2632 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-901ee5e5 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2637 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ddec297 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2642 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4c32e2a9 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2648 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b704b567 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2653 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45acebb3 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2658 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d377915d | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2663 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f5df4f8 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2668 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.Inde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d19e4bcd | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2691 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, "", UserInfoContext.C… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-286879ac | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2691 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, "", UserInfoContext.Current.User… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c254e45a | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2693 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, sProjectCode, UserInf… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-5fb7452c | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2693 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivision, sSiteId, sProjectCode, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4f8596ff | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2694 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-07f99de2 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2705 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | FLAG | dt_VMI_YN | Data.Common(Data.Type.DM_VMI_YN, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_VMI_YN] | 화면 필드/플래그 변경 |  |  |  |
| AC-1e72cd49 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2705 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | COMBO_DATA | Data.Common | (Data.Type.DM_VMI_YN, false, sDivision, sSiteId, "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_VMI_YN] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42e32b62 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2714 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VMI_YN), sVmiYn) | 그리드 값 설정 |  |  |  |
| AC-691c2084 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2718 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of ((sBucketType == BucketType.Daily && sColName… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.VMI_STD_DIO), sVmi_std_dio) | 그리드 값 설정 |  |  |  |
| AC-baf285f3 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2741 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ if (sDivi… | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-b27fcbfe | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2741 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ if (sDivi… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-82c282ee | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2742 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ if (sDivi… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-33551518 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2750 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ else of (… | FLAG | dtPlantSite | Data.Common(Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 화면 필드/플래그 변경 |  |  |  |
| AC-737bf9b2 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2750 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ else of (… | COMBO_DATA | Data.Common | (Data.Type.SalesPlant, false, "", sDivision, sProjectCode, sItemId) ⇒ biz:CommonData.CommonDataList [code=SalesPlant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-47b0af42 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2751 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sDivision != null && sDivision != "") ▸ else of (… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PlantSiteId), dtPlantSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e5c3ed40 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2893 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CApp… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-abbed33a | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2895 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CApp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ad03243 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2896 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(CApp… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eaf9fb03 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2910 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | CALL_EXT | strBucket.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebdf2c4d | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2913 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ for (i < 7) | DATA_OP | dBucket.Add | (i, sarBucket[i].ToString() == "1" ? true : false) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cb9f2a9 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2947 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-2c38d43b | dsdm.Changed | DMF0081_MktFcst_Auto.cs:2971 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sBucketType == BucketType.Daily && sColName.Index… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-70f654d5 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3017 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, e.Column, iWkSum_Sync.ToString()) | 그리드 값 설정 |  |  |  |
| AC-0eb12f63 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3018 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d92b2e5b | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3109 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-800d2568 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3118 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-7b54e931 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3136 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-f0c448ed | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3145 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetValue | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-398c99de | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3169 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-64d8fa88 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3197 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-d0ece3c4 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3209 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iSetCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-57925e1f | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3239 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-701a007d | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3318 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00225") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7dd5e921 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3319 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94ca509f | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3352 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-39e8cd56 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3361 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-dcb87b81 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3382 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-10933553 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3391 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-72032d92 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3419 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |
| AC-564e7728 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3456 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ef72e554 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3462 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, iDailyQty.ToString()) | 그리드 값 설정 |  |  |  |
| AC-e4ca0667 | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3492 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iWeekCol, iWeeklySum.ToString().Replace(",", "")) | 그리드 값 설정 |  |  |  |
| AC-5faf659f | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3526 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iWeeklySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-ce5e7fdc | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3553 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iStartCol - 1, iMonthlySum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-f3de1cae | dsdm.Changed | DMF0081_MktFcst_Auto.cs:3624 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sBucketType == BucketType.Daily && sColName.… | GRID_SET | siMain.SetText | (e.Row, iCol, "") | 그리드 값 설정 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e59cff4c | this.spdMain.ClipboardPasted | DMF0081_MktFcst_Auto.cs:4732 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-de6f0729 | this.spdMain.ClipboardPasted | DMF0081_MktFcst_Auto.cs:4732 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1f15003d | this.spdMain.ClipboardPasted | DMF0081_MktFcst_Auto.cs:4733 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ if (iCol == siMain.GetColu… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-024b1642 | this.spdMain.ClipboardPasted | DMF0081_MktFcst_Auto.cs:4744 | for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRange.Column + e.CellRange.ColumnCount) ▸ else of (iCol == siMain.Ge… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1de36e13 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2345 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | FLAG | dtTeamSpr | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-2c2bc141 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2345 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1be25642 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2347 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Team) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Team), dtTeamSpr) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a650e258 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2354 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-25f9a104 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2354 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5cdbf5f7 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2355 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4664a693 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2366 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | FLAG | dtCustomer40 | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-edcc275d | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2366 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-49d0b512 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2367 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Customer40) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-09f91a43 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2373 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.Cont… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c38dfc | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2373 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.Cont… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-603c3656 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2374 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision.Cont… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aef0b4f8 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2378 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision… | FLAG | dtSalesSite40 | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-97dbe2b2 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2378 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b742ad83 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2379 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of ((clbDivision.ControlValues.Substring(0, 2) == "81") \|\| (clbDivision… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite40) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-17e6e7fa | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2387 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtBizType | GetBizTypebyDivision(clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6f8df44 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2388 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0c856b7c | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2391 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == "81") | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-38bd09b7 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2393 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (sDivision != null && sDivision != "" && sDivision.Substring(0, 2) == … | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.PlantSiteId), siMain.ActiveRowInd… | 그리드 편집 잠금/해제 |  |  |  |
| AC-593b4c38 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2402 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, Us… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-99333f2a | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2402 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63a38b41 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2403 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division) != -1 && siMain.GetColumnIndex(… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-da8e532f | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2411 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-64311b0e | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2411 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-019a4b49 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2412 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (siMain.GetColumnIndex(DefColumns.Division40) != -1 && siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e700e697 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2422 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a3299f1 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2422 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40b30ecd | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2423 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-509a9902 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2426 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-ba797da1 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2426 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-126ae7cd | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2427 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f10671df | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2440 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a8e0af84 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2440 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b77497d0 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2443 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.Customer40), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-391be134 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2446 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-ae80cf30 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2446 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aa51da0c | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2447 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (siMain.GetC… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e5980ecf | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2456 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | FLAG | dtSalesSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-25b50a75 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2456 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2388db77 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2457 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ if (e.Colu… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d32c9170 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2465 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-0615eb67 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2465 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-876fd34a | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2466 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSiteId40), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0f547007 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2472 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Project), "") | 그리드 값 설정 |  |  |  |
| AC-6ba94e30 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2475 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectName), "") | 그리드 값 설정 |  |  |  |
| AC-9d6e47b4 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2478 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ProjectStatus), "") | 그리드 값 설정 |  |  |  |
| AC-2889ce61 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2481 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.BizType), "") | 그리드 값 설정 |  |  |  |
| AC-d039840a | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2489 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, Us… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-e6c06174 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2489 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, sProjectCode, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-127a905b | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2490 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5f4d1c1f | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2493 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Incoterms), dtIncotermsType) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3fe32c39 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2505 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | FLAG | dtMeasure | Data.Common(Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoCont… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 화면 필드/플래그 변경 |  |  |  |
| AC-632a2b3d | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2505 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | COMBO_DATA | Data.Common | (Data.Type.MktFcstEditMeasure, false, sDivisionID, sScmSiteID, "", UserInfoContext.Current… ⇒ biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-256879c3 | this.spdMain.ComboSelChange | DMF0081_MktFcst_Auto.cs:2506 | else of (e.Column == siMain.GetColumnIndex(DefColumns.Division)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.Team)) ▸ else of (e… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Measure), dtMeasure) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c36429d8 | this.spdMain.EditChange | DMF0081_MktFcst_Auto.cs:4710 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f041149f | this.spdMain.EditChange | DMF0081_MktFcst_Auto.cs:4712 |  | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3cbcbb7 | this.spdMain.KeyUp | DMF0081_MktFcst_Auto.cs:3890 | if (siMain.GetColumnIndex(DefColumns.Measure) >= siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8ca130f | this.spdMain.KeyUp | DMF0081_MktFcst_Auto.cs:3894 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | CALL_EXT | spdMain.ActiveSheet.ClipboardPaste | (ClipboardPasteOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |
| AC-526dd153 | this.spdMain.KeyUp | DMF0081_MktFcst_Auto.cs:3896 | if (e.Control == true && e.KeyCode == Keys.V \|\| e.Control == false && e.KeyCode == Keys.V) | FLAG | bPasteContinue | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4678611c | this.spdMain.KeyUp | DMF0081_MktFcst_Auto.cs:3901 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-97d8f51f | this.spdMain.KeyUp | DMF0081_MktFcst_Auto.cs:3902 | if (e.Control == true && e.KeyCode == Keys.C \|\| e.Control == false && e.KeyCode == Keys.C) | CALL_EXT | spdMain.Sheets[0].ClipboardCopy | (ClipboardCopyOptions.AsStringSkipHidden) | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-629fab5a | this.spdMain.TopChange | DMF0081_MktFcst_Auto.cs:3876 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_MktFcst_Auto.spdSub1_CellClick

진입점: this.spdSub1.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1478f523 | this.spdSub1.CellClick | DMF0081_MktFcst_Auto.cs:5254 | if (siSub1.GetMaxRowIndex() > -1) ▸ if ((sSeq == "3" \|\| sSeq == "4") && (sPopup_Status == "MODIFY" \|\| sPopup_Status == "READ_OK") && (sC… | POPUP | popup.Form_Load | (pDivision, pEndCustomer, pProjectCode, pPLAN_YYYYMM, pEdiQty, pMeasure, pMktFcst, FirstWe… | 팝업 초기화(인자 전달) |  |  |  |
| AC-420fabd0 | this.spdSub1.CellClick | DMF0081_MktFcst_Auto.cs:5255 | if (siSub1.GetMaxRowIndex() > -1) ▸ if ((sSeq == "3" \|\| sSeq == "4") && (sPopup_Status == "MODIFY" \|\| sPopup_Status == "READ_OK") && (sC… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ed326ed2 | this.spdSub1.CellClick | DMF0081_MktFcst_Auto.cs:5256 | if (siSub1.GetMaxRowIndex() > -1) ▸ if ((sSeq == "3" \|\| sSeq == "4") && (sPopup_Status == "MODIFY" \|\| sPopup_Status == "READ_OK") && (sC… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0081_MktFcst_Auto.spdSub1_DATA_BINDING

진입점: this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ if ((sSeq == "3" \|\| sSeq == "4") && (sPopup_Status == "MODIFY" \|\| sPopup_Status == "READ_OK") && (sColumnNameOfClickCell == …) ▸ if (popup.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [else of (e.ColumnHeader)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b3f1512 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5273 | if (string.IsNullOrEmpty(P_DIVISION_ID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00437") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbd2ae38 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5274 | if (string.IsNullOrEmpty(P_DIVISION_ID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c630e0e2 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5280 | if (string.IsNullOrEmpty(P_END_CUSTOMER)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00438") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-deb72217 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5281 | if (string.IsNullOrEmpty(P_END_CUSTOMER)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52737897 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5287 | if (string.IsNullOrEmpty(P_PROJECT_CODE)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00439") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6bbfc34 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5288 | if (string.IsNullOrEmpty(P_PROJECT_CODE)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a74e6a2 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5291 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9e57c82a | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5294 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-aae9380b | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5300 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0081_GET_DM_ANL_MKT_PSI_DATA") ⇒ DM.DMF0081_GET_DM_ANL_MKT_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-ff5c762d | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5302 | try | DATA_OP | request.Parameters["p_division_id"] | P_DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-5a2abd75 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5303 | try | DATA_OP | request.Parameters["p_end_customer"] | P_END_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-a102933e | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5304 | try | DATA_OP | request.Parameters["p_project_code"] | P_PROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-6c3315fb | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5306 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62b582ab | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5308 | try | FLAG | dtPSI | response.DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-11c4d766 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5309 | try | DATA_OP | siSub1.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7d7c97a | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5310 | try | GRID_BIND | siSub1.Query | (dtPSI) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7eb19142 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5311 | try | GRID_LOCK | siSub1.LockColumn | (0, siSub1.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1da005a3 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5312 | try | GRID_INIT | siSub1.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c12d2c11 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5318 | try | GRID_STYLE | spdSub1.SetViewportTopRow | (0, siSub1.GetMaxRowIndex()) | 그리드 표시 설정 |  |  |  |
| AC-23368666 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5327 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.Measure)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-912154fa | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5328 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-89d5a4ea | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5329 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-7baacc85 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5330 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-5d76e0fc | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5331 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-9c90e9fa | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5332 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-313c1199 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5333 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-b03f2129 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5334 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-39f41b58 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5335 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-9416985b | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5336 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-ad44d2a6 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5337 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-46498afb | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5338 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-a58ec286 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5339 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-34d80f78 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5340 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-bcf82be0 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5341 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-d066e5a7 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5342 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-c06aa275 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5343 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-9492a25a | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5344 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-3da3e81b | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5345 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-34e84588 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5346 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-081a7ca0 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5347 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-c81caf81 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5348 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-41d9ef83 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5349 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.RESULT)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-d651f6ef | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5350 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MKT_DP)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-8c6508ed | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5351 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.GAP)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-3cfde341 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5356 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUM_03), siSub1.GetText(i, siSub1.GetColumnIndex(DefC… | 그리드 값 설정 |  |  |  |
| AC-25e3c9ce | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5357 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUM_06), siSub1.GetText(i, siSub1.GetColumnIndex(DefC… | 그리드 값 설정 |  |  |  |
| AC-0a996142 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5358 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUM_12), siSub1.GetText(i, siSub1.GetColumnIndex(DefC… | 그리드 값 설정 |  |  |  |
| AC-5adef509 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5359 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.PRODUCT_03), siSub1.GetText(i, siSub1.GetColumnIndex(… | 그리드 값 설정 |  |  |  |
| AC-5d80da08 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5360 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.PRODUCT_06), siSub1.GetText(i, siSub1.GetColumnIndex(… | 그리드 값 설정 |  |  |  |
| AC-71505df8 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5361 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.PRODUCT_12), siSub1.GetText(i, siSub1.GetColumnIndex(… | 그리드 값 설정 |  |  |  |
| AC-1ca7ac50 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5362 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SALE_03), siSub1.GetText(i, siSub1.GetColumnIndex(Def… | 그리드 값 설정 |  |  |  |
| AC-e047b873 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5363 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SALE_06), siSub1.GetText(i, siSub1.GetColumnIndex(Def… | 그리드 값 설정 |  |  |  |
| AC-d9f008a0 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5364 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SALE_12), siSub1.GetText(i, siSub1.GetColumnIndex(Def… | 그리드 값 설정 |  |  |  |
| AC-82670719 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5365 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.INVENTORY_03), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-0df20b78 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5366 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.INVENTORY_06), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-b8bd43a4 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5367 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.INVENTORY_12), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-c49de340 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5368 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_03), siSub1.GetText(i, siSub1.GetColumnIn… | 그리드 값 설정 |  |  |  |
| AC-510780a1 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5369 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_06), siSub1.GetText(i, siSub1.GetColumnIn… | 그리드 값 설정 |  |  |  |
| AC-c3f789fd | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5370 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_12), siSub1.GetText(i, siSub1.GetColumnIn… | 그리드 값 설정 |  |  |  |
| AC-4af3dd9d | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5371 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_03), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-465b32ed | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5372 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_06), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-dbccd6d5 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5373 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_12), siSub1.GetText(i, siSub1.GetColumnInde… | 그리드 값 설정 |  |  |  |
| AC-bcce0255 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5374 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_03), siSub1.GetText(i, siSub1.GetColumnI… | 그리드 값 설정 |  |  |  |
| AC-f244f44b | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5375 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_06), siSub1.GetText(i, siSub1.GetColumnI… | 그리드 값 설정 |  |  |  |
| AC-9886ec6e | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5376 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "1") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_12), siSub1.GetText(i, siSub1.GetColumnI… | 그리드 값 설정 |  |  |  |
| AC-5f667eda | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5410 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.Measure)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-af790aa0 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5411 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-a284c486 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5412 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-efad1c45 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5413 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-91800558 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5414 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-03cbc70e | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5415 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-1b075adb | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5416 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.PRODUCT_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-1e0cca0b | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5417 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-b0ec582f | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5418 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-4ced1325 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5419 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SALE_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-64a0f288 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5420 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-9e424c70 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5421 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-fdf41d37 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5422 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.INVENTORY_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-88e295c8 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5423 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-70815500 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5424 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-040844c6 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5425 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.TIME_ADJUST_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-f618d542 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5426 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-e3deea81 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5427 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-79cb7293 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5428 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MODEL_MIX_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-05c847e6 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5429 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_03)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-6bd08a29 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5430 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_06)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-05314920 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5431 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUPPLY_ISSUE_12)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-c5946fe0 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5432 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.RESULT)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-0e8cacdb | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5433 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.MKT_DP)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-dacc886f | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5434 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.GAP)].BackColor | Color.LightYellow | 그리드 속성/값 설정 |  |  |  |
| AC-001b4640 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5458 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.RESULT), sData) | 그리드 값 설정 |  |  |  |
| AC-224390a8 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5459 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "2") | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.MKT_DP), sData) | 그리드 값 설정 |  |  |  |
| AC-a601e04e | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5466 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status != "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_03)].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-2bdf1009 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5467 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status != "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_06)].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-524441cd | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5468 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status != "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_12)].BackColor | Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-2d823d32 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5474 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status == "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_03)].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-37de6616 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5475 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status == "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_06)].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-312d518d | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5476 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if ((seq == "3" \|\| seq == "4") && popup_status == "MODIFY") | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.SUM_12)].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-36ad30df | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5497 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "3" \|\| seq == "4") ▸ if (gapint < 0) | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-0d4aedb1 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5498 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "3" \|\| seq == "4") ▸ if (gapint < 0) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-bfe60fa6 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5502 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "3" \|\| seq == "4") ▸ else of (gapint < 0) | GRID_SET | siSub1.SetText | (i, siSub1.GetColumnIndex(DefColumns.GAP), gapstr) | 그리드 값 설정 |  |  |  |
| AC-c506790d | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5503 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (seq == "3" \|\| seq == "4") ▸ else of (gapint < 0) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.GAP)].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-4808281f | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5510 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M3_CUST_FCST_QTY)].BackColor | Color.FromArgb(255, 226, 240, 217) | 그리드 속성/값 설정 |  |  |  |
| AC-9317f267 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5511 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M3_MKT_FCST_QTY)].BackColor | Color.FromArgb(255, 222, 235, 247) | 그리드 속성/값 설정 |  |  |  |
| AC-1a5dfa06 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5512 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M2_CUST_FCST_QTY)].BackColor | Color.FromArgb(255, 226, 240, 217) | 그리드 속성/값 설정 |  |  |  |
| AC-2b474dee | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5513 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M2_MKT_FCST_QTY)].BackColor | Color.FromArgb(255, 222, 235, 247) | 그리드 속성/값 설정 |  |  |  |
| AC-7131ce13 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5514 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M1_CUST_FCST_QTY)].BackColor | Color.FromArgb(255, 226, 240, 217) | 그리드 속성/값 설정 |  |  |  |
| AC-2cb39ae4 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5515 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.M1_MKT_FCST_QTY)].BackColor | Color.FromArgb(255, 222, 235, 247) | 그리드 속성/값 설정 |  |  |  |
| AC-24de1b80 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5516 | try ▸ for (i <= siSub1.GetMaxRowIndex()) ▸ if (true) | GRID_SET | siSub1.ActiveSheet.Cells[i, siSub1.GetColumnIndex(DefColumns.EDI_QTY)].BackColor | Color.FromArgb(255, 226, 240, 217) | 그리드 속성/값 설정 |  |  |  |
| AC-f8a20d45 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5525 | try | VALUE_SET | rdoSimulation1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-286321d5 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5526 | try | VALUE_SET | rdoSimulation2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-c423a9ce | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5527 | try | VALUE_SET | rdoSimulation3.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-beae8a01 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5528 | try | VALUE_SET | rdoSimulation1.Checked | rdo1 | 컨트롤 값 설정 |  |  |  |
| AC-dc0e9e9a | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5529 | try | VALUE_SET | rdoSimulation2.Checked | rdo2 | 컨트롤 값 설정 |  |  |  |
| AC-9028bbe1 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5530 | try | VALUE_SET | rdoSimulation3.Checked | rdo3 | 컨트롤 값 설정 |  |  |  |
| AC-e29646f1 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5536 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec306678 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5540 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f465e021 | this.spdSub1.CellClick [if (siSub1.GetMaxRowIndex() > -1) ▸ … 외 1 | DMF0081_MktFcst_Auto.cs:5541 | finally | UI_MISC | siSub1.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0081_MktFcst_Auto.spdSub1_TextTipFetch

진입점: this.spdSub1.TextTipFetch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10af1875 | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6363 |  | UI_PROP | app.BackColor | System.Drawing.SystemColors.ButtonShadow | 속성 BackColor 설정 |  |  |  |
| AC-68c919fa | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6364 |  | UI_PROP | app.Font | new Font("맑은 고딕", 10) | 속성 Font 설정 |  |  |  |
| AC-a32502f0 | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6365 |  | UI_PROP | app.ForeColor | System.Drawing.SystemColors.Window | 속성 ForeColor 설정 |  |  |  |
| AC-e780b030 | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6367 |  | UI_PROP | spdSub1.TextTipPolicy | FarPoint.Win.Spread.TextTipPolicy.Floating | 속성 TextTipPolicy 설정 |  |  |  |
| AC-15a7f857 | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6368 |  | UI_PROP | spdSub1.TextTipAppearance | app | 속성 TextTipAppearance 설정 |  |  |  |
| AC-f607e642 | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6374 | if (e.RowHeader == false && e.ColumnHeader == true) ▸ if (e.Column == siSub1.GetColumnIndex(DefColumns.Measure)) | UI_PROP | e.ShowTip | true | 속성 ShowTip 설정 |  |  |  |
| AC-bd22c98b | this.spdSub1.TextTipFetch | DMF0081_MktFcst_Auto.cs:6375 | if (e.RowHeader == false && e.ColumnHeader == true) ▸ if (e.Column == siSub1.GetColumnIndex(DefColumns.Measure)) | UI_PROP | e.TipText | "Average Impact(%) : Simulation 구간의 고객수요(Cust.FCST) 比 DP(final)의 변동률 (%)" + "\r\n" + "Simu… | 속성 TipText 설정 |  |  |  |

## DMF0081_MktFcst_Auto.spdSub1_TopChange

진입점: this.spdSub1.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0efe7936 | this.spdSub1.TopChange | DMF0081_MktFcst_Auto.cs:5874 |  | GRID_INIT | siSub1.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0081_MktFcst_Auto.splitContainer2_DoubleClick

진입점: this.splitContainer2.DoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6039cbf2 | this.splitContainer2.DoubleClick | DMF0081_MktFcst_Auto.cs:5928 | if (splitContainer2.SplitterDistance < (int)(splitContainer2.ClientSize.Height * 0.42)) | UI_PROP | splitContainer2.SplitterDistance | (int)(splitContainer2.ClientSize.Height * 0.42) | 속성 SplitterDistance 설정 |  |  |  |
| AC-11c0132f | this.splitContainer2.DoubleClick | DMF0081_MktFcst_Auto.cs:5932 | else of (splitContainer2.SplitterDistance < (int)(splitContainer2.ClientSize.Height * 0.42)) | UI_PROP | splitContainer2.SplitterDistance | 100 | 속성 SplitterDistance 설정 |  |  |  |

## DMF0081_MktFcst_Auto.txtMarketShare_Click

진입점: this.txtMarketShare.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a00e6d | this.txtMarketShare.Click | DMF0081_MktFcst_Auto.cs:5894 |  | UI_PROP | txtMarketShare.SelectionStart | txtMarketShare.Text.Length | 속성 SelectionStart 설정 |  |  |  |
| AC-6a497ece | this.txtMarketShare.Click | DMF0081_MktFcst_Auto.cs:5895 |  | CALL_EXT | txtMarketShare.ScrollToCaret | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0081_MktFcst_Auto.txtMarketShare_KeyDown

진입점: this.txtMarketShare.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-283c5fa4 | this.txtMarketShare.KeyDown | DMF0081_MktFcst_Auto.cs:5888 | if (!isnum) | UI_PROP | e.SuppressKeyPress | true | 속성 SuppressKeyPress 설정 |  |  |  |

## DMF0081_MktFcst_Auto.ValidationCheck

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((sBucketType == BucketType.Daily && sColName.IndexOf("D_") == 0) \|\| (sBucketType == BucketType.Weekly && sColName.IndexO…) ▸ if (sDivision == "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46ae0e99 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3639 | if (bPasteContinue) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { col }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9652375 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3642 |  | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-ce6099ab | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0081_MktFcst_Auto.cs:3644 |  | FLAG | bPasteContinue | false | 화면 필드/플래그 변경 |  |  |  |

