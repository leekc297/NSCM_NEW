# AS-IS 액션 대조표 — DMF0071

> 원천: `Doc/asisfacts/screens/DMF0071/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 196행 · 메서드 14 · 종류 DATA_OP 70 · FLAG 25 · ENDPOINT 20 · MESSAGE 14 · RETURN 13 · UI_MISC 10 · VALUE_SET 10 · UI_PROP 8 · LIST_REBIND 6 · GRID_INIT 6 · POPUP 4 · CALL_EXT 2 · VALUE_CLEAR 2 · GRID_BIND 2 · GRID_LOCK 2 · COMBO_DATA 2 · ⚠ 의미 확인 필요 2


## DMF0071_BPCutOffPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ed24b1f | .ctor | DMF0071_BPCutOffPopup.cs:95 |  | FLAG | sDivision | pDiv | 화면 필드/플래그 변경 |  |  |  |
| AC-04d1a6eb | .ctor | DMF0071_BPCutOffPopup.cs:92 |  | FLAG | sDivision | pDiv | 화면 필드/플래그 변경 |  |  |  |

## DMF0071_BPCutOffPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afae6d36 | this.btnButtonList.UsrButtonList_Click_Detected | DMF0071_BPCutOffPopup.cs:305 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e640b04b | this.btnButtonList.UsrButtonList_Click_Detected | DMF0071_BPCutOffPopup.cs:300 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## DMF0071_BPCutOffPopup.clbDivision_SelectedIndexChanged_1

진입점: this.clbDivision.SelectedIndexChanged / this.drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36efec14 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:359 |  | CALL_EXT | clbFCST_Ver.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eb2a361 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:360 |  | VALUE_CLEAR | txtRTFVer.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e0add285 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:375 |  | ENDPOINT | new FoxDataRequest | ("DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP") ⇒ DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-89dc58f3 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:376 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-501784ab | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:377 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-213b9bd8 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:378 |  | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-be75eb06 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:379 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-2325a44a | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:381 |  | DATA_OP | request.Parameters["p_version_type"] | strVerType | 행/컬럼 값 대입 |  |  |  |
| AC-36d5f0e2 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:382 |  | DATA_OP | request.Parameters["p_version_no"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9d98bcd5 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:383 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e449fb3 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:385 |  | DATA_OP | response.DataSet.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5ff05bc | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:386 |  | DATA_OP | dt.Rows.Remove | (dt.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-635fdf8d | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:389 |  | LIST_REBIND | clsCtrl.setListBox | (dt, clbFCST_Ver, false, "CODE", "VERSION_NO") | 목록 컨트롤 재구성 |  |  |  |
| AC-3beee69c | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:397 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_GET_RTF_VERSION") ⇒ DM.DMF0071_GET_RTF_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-b815faab | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:398 |  | DATA_OP | request.Parameters["P_DIVISION_ID"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7a404094 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:400 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0784f22f | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:407 | if (response.DataSet.Tables[0].Rows.Count > 0) | VALUE_SET | txtRTFVer.Text | response.DataSet.Tables[0].Rows[0]["RTF_VER_TXT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5e4844d8 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:408 | if (response.DataSet.Tables[0].Rows.Count > 0) | FLAG | strRTF_VER_PARAM | response.DataSet.Tables[0].Rows[0]["RTF_VER_PARAM"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d8811c97 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:354 |  | CALL_EXT | clbFCST_Ver.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-26384eb1 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:355 |  | VALUE_CLEAR | txtRTFVer.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1d08a503 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:370 |  | ENDPOINT | new FoxDataRequest | ("DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP") ⇒ DM.SCM0002_GET_VERSIONBYWATERFALLPOPUP | 엔드포인트 요청 생성 |  |  |  |
| AC-41fbb874 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:371 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-330b4402 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:372 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-185eeade | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:373 |  | DATA_OP | request.Parameters["p_created_by"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9db88f40 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:374 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1e384894 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:376 |  | DATA_OP | request.Parameters["p_version_type"] | strVerType | 행/컬럼 값 대입 |  |  |  |
| AC-b075c16b | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:377 |  | DATA_OP | request.Parameters["p_version_no"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-38fdb0b2 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:378 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f454856f | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:380 |  | DATA_OP | response.DataSet.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-20f9b4b8 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:381 |  | DATA_OP | dt.Rows.Remove | (dt.Rows[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0da00f30 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:384 |  | LIST_REBIND | clsCtrl.setListBox | (dt, clbFCST_Ver, false, "CODE", "VERSION_NO") | 목록 컨트롤 재구성 |  |  |  |
| AC-4b96f300 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:392 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_GET_RTF_VERSION") ⇒ DM.DMF0071_GET_RTF_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-d9968b6b | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:393 |  | DATA_OP | request.Parameters["P_DIVISION_ID"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0ca71f04 | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:395 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4a2704fa | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:402 | if (response.DataSet.Tables[0].Rows.Count > 0) | VALUE_SET | txtRTFVer.Text | response.DataSet.Tables[0].Rows[0]["RTF_VER_TXT"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-894d7c5a | this.clbDivision.SelectedIndexChanged 외 1 | DMF0071_BPCutOffPopup.cs:403 | if (response.DataSet.Tables[0].Rows.Count > 0) | FLAG | strRTF_VER_PARAM | response.DataSet.Tables[0].Rows[0]["RTF_VER_PARAM"].ToString() | 화면 필드/플래그 변경 |  |  |  |

## DMF0071_BPCutOffPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ea9c75a | this.Load | DMF0071_BPCutOffPopup.cs:180 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c695965f | this.Load | DMF0071_BPCutOffPopup.cs:181 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-78b164ab | this.Load | DMF0071_BPCutOffPopup.cs:182 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e7bd7890 | this.Load | DMF0071_BPCutOffPopup.cs:177 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a85a1bc2 | this.Load | DMF0071_BPCutOffPopup.cs:178 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-48745726 | this.Load | DMF0071_BPCutOffPopup.cs:179 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0071_BPCutOffPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1979d9c | this.Load | DMF0071_BPCutOffPopup.cs:175 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-ca3497f7 | this.Load | DMF0071_BPCutOffPopup.cs:172 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## DMF0071_BPCutOffPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9796770 | Dispose | DMF0071_BPCutOffPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-659e8289 | Dispose | DMF0071_BPCutOffPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0071_BPCutOffPopup.FindData

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d167515a | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:247 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14482c88 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:248 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1da29212 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:253 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a742a273 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:257 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_GET_BPCUTOFF_LIST") ⇒ DM.DMF0071_GET_BPCUTOFF_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-d1335a90 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:258 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-71b60997 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:259 | lambda | DATA_OP | request.Parameters["P_FROMDT"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d8cd8dc7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:260 | lambda | DATA_OP | request.Parameters["P_TODT"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-46bb6ae7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:261 | lambda | DATA_OP | request.Parameters["P_FCST_VER"] | strFCST_VER | 행/컬럼 값 대입 |  |  |  |
| AC-3f761214 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:262 | lambda | DATA_OP | request.Parameters["P_RTF_VER"] | strRTFVer | 행/컬럼 값 대입 |  |  |  |
| AC-aa9b661c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:263 | lambda | DATA_OP | request.Parameters["P_DESC"] | strDes | 행/컬럼 값 대입 |  |  |  |
| AC-df7faf4b | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:264 | lambda | DATA_OP | request.Parameters["P_BPYEAR"] | strBPYear | 행/컬럼 값 대입 |  |  |  |
| AC-f21bd993 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:265 | lambda | DATA_OP | request.Parameters["P_CUTOFF_YEAR"] | strCutOffYear | 행/컬럼 값 대입 |  |  |  |
| AC-34be1320 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:266 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be4650b3 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:268 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ddf7953e | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:272 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a8425a32 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:273 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ef6cc39d | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:242 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3942afb7 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:243 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fccf929 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:248 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-321ca625 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:252 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_GET_BPCUTOFF_LIST") ⇒ DM.DMF0071_GET_BPCUTOFF_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-1ffcb627 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:253 | lambda | DATA_OP | request.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-62f8d423 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:254 | lambda | DATA_OP | request.Parameters["P_FROMDT"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-d00d0cd3 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:255 | lambda | DATA_OP | request.Parameters["P_TODT"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-d5148976 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:256 | lambda | DATA_OP | request.Parameters["P_FCST_VER"] | strFCST_VER | 행/컬럼 값 대입 |  |  |  |
| AC-608a5bd2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:257 | lambda | DATA_OP | request.Parameters["P_RTF_VER"] | strRTFVer | 행/컬럼 값 대입 |  |  |  |
| AC-81116fa9 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:258 | lambda | DATA_OP | request.Parameters["P_DESC"] | strDes | 행/컬럼 값 대입 |  |  |  |
| AC-70751e26 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:259 | lambda | DATA_OP | request.Parameters["P_BPYEAR"] | strBPYear | 행/컬럼 값 대입 |  |  |  |
| AC-be854549 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:260 | lambda | DATA_OP | request.Parameters["P_CUTOFF_YEAR"] | strCutOffYear | 행/컬럼 값 대입 |  |  |  |
| AC-c85bdc9b | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:261 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fab06797 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:263 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5375e68c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:267 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b89343b4 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:268 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## DMF0071_BPCutOffPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cadcf8f | this.Load | DMF0071_BPCutOffPopup.cs:104 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-79559d1c | this.Load | DMF0071_BPCutOffPopup.cs:105 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-41717213 | this.Load | DMF0071_BPCutOffPopup.cs:113 |  | FLAG | sCode | _Code | 화면 필드/플래그 변경 |  |  |  |
| AC-49e5710f | this.Load | DMF0071_BPCutOffPopup.cs:114 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-0846a1e7 | this.Load | DMF0071_BPCutOffPopup.cs:115 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-1edccae3 | this.Load | DMF0071_BPCutOffPopup.cs:116 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |
| AC-67606066 | this.Load | DMF0071_BPCutOffPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb734aa2 | this.Load | DMF0071_BPCutOffPopup.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0146a1e7 | this.Load | DMF0071_BPCutOffPopup.cs:110 |  | FLAG | sCode | _Code | 화면 필드/플래그 변경 |  |  |  |
| AC-0e8a7bf6 | this.Load | DMF0071_BPCutOffPopup.cs:111 |  | FLAG | bMulltiSelect | _bMultiSelect | 화면 필드/플래그 변경 |  |  |  |
| AC-46f93fc7 | this.Load | DMF0071_BPCutOffPopup.cs:112 |  | FLAG | sDivision | _DivisionID | 화면 필드/플래그 변경 |  |  |  |
| AC-8800f4b5 | this.Load | DMF0071_BPCutOffPopup.cs:113 |  | VALUE_SET | drpPeriod.InitValue | sStartDate + ":" + sEndDate | 컨트롤 값 설정 |  |  |  |

## DMF0071_BPCutOffPopup.GetSpdTitle

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0312d53f | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:508 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b8e17f02 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:509 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4391c491 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:510 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5ef70aed | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:511 |  | DATA_OP | request.Parameters["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-01eeeb0e | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:512 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0071" | 행/컬럼 값 대입 |  |  |  |
| AC-95c5b7ac | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:513 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-146fbff5 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:514 |  | DATA_OP | request.Parameters["p_division_id"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-65d02cf2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:516 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0788135c | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:518 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0071_BPCutOffPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0e91b9f | this.Load | DMF0071_BPCutOffPopup.cs:124 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-616b76b6 | this.Load | DMF0071_BPCutOffPopup.cs:124 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-03c84409 | this.Load | DMF0071_BPCutOffPopup.cs:125 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb810a5c | this.Load | DMF0071_BPCutOffPopup.cs:127 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-0ae31bc7 | this.Load | DMF0071_BPCutOffPopup.cs:143 |  | DATA_OP | dtBPYear.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f7c3a4d | this.Load | DMF0071_BPCutOffPopup.cs:144 |  | DATA_OP | dtBPYear.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-da7ffeff | this.Load | DMF0071_BPCutOffPopup.cs:148 | for (i < 3) | DATA_OP | dtBPYear.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-961aab19 | this.Load | DMF0071_BPCutOffPopup.cs:150 | for (i < 3) | DATA_OP | row["CODE"] | row["NAME"] = DateTime.Now.AddYears(i).Year.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8442f576 | this.Load | DMF0071_BPCutOffPopup.cs:150 | for (i < 3) | DATA_OP | row["NAME"] | DateTime.Now.AddYears(i).Year.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6cc429d4 | this.Load | DMF0071_BPCutOffPopup.cs:152 | for (i < 3) | DATA_OP | dtBPYear.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-b64e3345 | this.Load | DMF0071_BPCutOffPopup.cs:155 |  | LIST_REBIND | clsCtrl.setListBox | (dtBPYear, cboBPYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ebbba704 | this.Load | DMF0071_BPCutOffPopup.cs:157 |  | VALUE_SET | cboBPYear.SelectedValue | DateTime.Now.AddYears(1).Year | 컨트롤 값 설정 |  |  |  |
| AC-664a4bdb | this.Load | DMF0071_BPCutOffPopup.cs:161 |  | VALUE_SET | txtCutOffYear.Text | DateTime.Now.Year.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3b9c17d2 | this.Load | DMF0071_BPCutOffPopup.cs:164 |  | UI_PROP | drpPeriod.Text1 | DateTime.Now.AddMonths(-1).ToString("yyyyMMdd") | 속성 Text1 설정 |  |  |  |
| AC-2cc93297 | this.Load | DMF0071_BPCutOffPopup.cs:165 |  | UI_PROP | drpPeriod.Text2 | DateTime.Now.AddMonths(6).ToString("yyyyMMdd") | 속성 Text2 설정 |  |  |  |
| AC-54cbc6ca | this.Load | DMF0071_BPCutOffPopup.cs:121 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-39215cd9 | this.Load | DMF0071_BPCutOffPopup.cs:121 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bac31774 | this.Load | DMF0071_BPCutOffPopup.cs:122 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-196e7dda | this.Load | DMF0071_BPCutOffPopup.cs:124 |  | VALUE_SET | clbDivision.ControlValues | sDivision | 컨트롤 값 설정 |  |  |  |
| AC-f40e4e2b | this.Load | DMF0071_BPCutOffPopup.cs:140 |  | DATA_OP | dtBPYear.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-730dfdd0 | this.Load | DMF0071_BPCutOffPopup.cs:141 |  | DATA_OP | dtBPYear.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f84f8bc | this.Load | DMF0071_BPCutOffPopup.cs:145 | for (i < 3) | DATA_OP | dtBPYear.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed9b3c10 | this.Load | DMF0071_BPCutOffPopup.cs:147 | for (i < 3) | DATA_OP | row["CODE"] | row["NAME"] = DateTime.Now.AddYears(i).Year.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a21f6170 | this.Load | DMF0071_BPCutOffPopup.cs:147 | for (i < 3) | DATA_OP | row["NAME"] | DateTime.Now.AddYears(i).Year.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ecdd40c6 | this.Load | DMF0071_BPCutOffPopup.cs:149 | for (i < 3) | DATA_OP | dtBPYear.Rows.Add | (row) | 데이터 객체 조작/조회 |  |  |  |
| AC-43082f9c | this.Load | DMF0071_BPCutOffPopup.cs:152 |  | LIST_REBIND | clsCtrl.setListBox | (dtBPYear, cboBPYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c6756a9f | this.Load | DMF0071_BPCutOffPopup.cs:154 |  | VALUE_SET | cboBPYear.SelectedValue | DateTime.Now.AddYears(1).Year | 컨트롤 값 설정 |  |  |  |
| AC-957d7be0 | this.Load | DMF0071_BPCutOffPopup.cs:158 |  | VALUE_SET | txtCutOffYear.Text | DateTime.Now.Year.ToString() | 컨트롤 값 설정 |  |  |  |
| AC-11f703d2 | this.Load | DMF0071_BPCutOffPopup.cs:161 |  | UI_PROP | drpPeriod.Text1 | DateTime.Now.AddMonths(-1).ToString("yyyyMMdd") | 속성 Text1 설정 |  |  |  |
| AC-294b4a56 | this.Load | DMF0071_BPCutOffPopup.cs:162 |  | UI_PROP | drpPeriod.Text2 | DateTime.Now.AddMonths(6).ToString("yyyyMMdd") | 속성 Text2 설정 |  |  |  |

## DMF0071_BPCutOffPopup.InitSpread

진입점: this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.Keys.Enter)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e1bd509 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:190 |  | FLAG | dtTitle | GetSpdTitle(siMain.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-e548eba2 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:191 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-d1a3bbe6 | this.txtDes.KeyDown [if (e.KeyCode == System.Windows.Forms.K… 외 3 | DMF0071_BPCutOffPopup.cs:189 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## DMF0071_BPCutOffPopup.MakeCutOff

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.OK:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80a854b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:438 | if (String.IsNullOrEmpty(clbFCST_Ver.ControlValues) \|\| String.IsNullOrEmpty(txtCutOffYear.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6fd27b9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:439 | if (String.IsNullOrEmpty(clbFCST_Ver.ControlValues) \|\| String.IsNullOrEmpty(txtCutOffYear.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30fac1af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:445 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6523c69f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:446 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea85bb30 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:449 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-36fda2b6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:452 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6bf54895 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:456 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_SAVE_BPCUTOFF") ⇒ DM.DMF0071_SAVE_BPCUTOFF | 엔드포인트 요청 생성 |  |  |  |
| AC-8179dc55 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:459 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a4bbd954 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:463 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-1bb2d1ab | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:465 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-9e634509 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:466 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_FROMDT"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-92ee7534 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:467 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_TODT"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b678c97c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:468 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_FCST_VER"] | clbFCST_Ver.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e85c3171 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:469 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_RTF_VER"] | strRTF_VER_PARAM | 행/컬럼 값 대입 |  |  |  |
| AC-d27514a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:470 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_BPYEAR"] | cboBPYear.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-25048b5b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:471 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_CUTOFF_YEAR"] | txtCutOffYear.Text | 행/컬럼 값 대입 |  |  |  |
| AC-cfeb9e80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:472 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_DESC"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-450efe51 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:473 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f3b039d8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:475 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4af0351 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:480 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) ▸ if (result.Tables[result.Tables.Count-1].Rows[0]["result_code"].ToStr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de73bcb1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:484 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) ▸ else of (result.Tables[result.Tables.Count-1].Rows[0]["result_code"].… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1cbb031e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:493 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-119f5b9a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:497 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bcb8fb5c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:433 | if (String.IsNullOrEmpty(clbFCST_Ver.ControlValues) \|\| String.IsNullOrEmpty(txtCutOffYear.Text)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23b2a4be | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:434 | if (String.IsNullOrEmpty(clbFCST_Ver.ControlValues) \|\| String.IsNullOrEmpty(txtCutOffYear.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-513c14fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:440 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b228d62 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:441 | if (int.Parse(sPeriod[0]) > int.Parse(sPeriod[1])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f90ff67d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:444 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1205a74b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:447 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00183") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47d65667 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:451 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("DM.DMF0071_SAVE_BPCUTOFF") ⇒ DM.DMF0071_SAVE_BPCUTOFF | 엔드포인트 요청 생성 |  |  |  |
| AC-21bdf77e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:454 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-25232da0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:458 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b06b6e6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:460 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-15cd9979 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:461 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_FROMDT"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cdd4d709 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:462 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_TODT"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-e68bf683 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:463 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_FCST_VER"] | clbFCST_Ver.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7a34a52d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:464 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_RTF_VER"] | strRTF_VER_PARAM | 행/컬럼 값 대입 |  |  |  |
| AC-f3946436 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:465 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_BPYEAR"] | cboBPYear.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34115ca3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:466 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_CUTOFF_YEAR"] | txtCutOffYear.Text | 행/컬럼 값 대입 |  |  |  |
| AC-fee72577 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:467 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_DESC"] | txtDes.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c418003c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:468 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | DATA_OP | request.Parameters["P_USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a7c17ad6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:470 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3cb19ba2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:475 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) ▸ if (result.Tables[result.Tables.Count-1].Rows[0]["result_code"].ToStr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-155cd132 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:479 | try ▸ if (MessageHelper.GMessageBox("MSG00183") == DialogResult.Yes) ▸ else of (result.Tables[result.Tables.Count-1].Rows[0]["result_code"].… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4c31f4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:488 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-196a09cb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | DMF0071_BPCutOffPopup.cs:492 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0071_BPCutOffPopup.SetItem

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23ee4b65 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:319 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ba59bbe | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:321 |  | FLAG | sPeriod | drpPeriod.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-020cda22 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:334 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-8680e773 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:338 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | sVersions + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-461cbe8f | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:345 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4defd2f8 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:350 | else of (bMulltiSelect) | FLAG | sVersions | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-90e16724 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:314 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dc97906 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:316 |  | FLAG | sPeriod | drpPeriod.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-2473efd5 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:329 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a8b4c2b6 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:333 | if (bMulltiSelect) ▸ if (cellRange.LongLength > 0) ▸ foreach (FarPoint.Win.Spread.Model.CellRange cr in cellRange) ▸ for (iRow < cr.Row + cr… | FLAG | sVersions | sVersions + "," + siMain.GetText(iRow, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |
| AC-6091e0ac | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:340 | if (bMulltiSelect) ▸ else of (cellRange.LongLength > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cdafce92 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:345 | else of (bMulltiSelect) | FLAG | sVersions | siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VERSION_NO)) | 화면 필드/플래그 변경 |  |  |  |

## DMF0071_BPCutOffPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fea7ab3 | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:313 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9d9fcc6f | this.spdMain.CellDoubleClick | DMF0071_BPCutOffPopup.cs:308 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

