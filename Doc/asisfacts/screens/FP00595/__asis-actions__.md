# AS-IS 액션 대조표 — FP00595

> 원천: `Doc/asisfacts/screens/FP00595/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 3361행 · 메서드 333 · 종류 DATA_OP 1391 · RETURN 268 · UI_PROP 254 · FLAG 251 · CALL_EXT 164 · UI_MISC 144 · VALUE_SET 143 · MESSAGE 143 · STATE 102 · ENDPOINT 99 · GRID_INIT 92 · POPUP 78 · GRID_SET 57 · COMBO_DATA 26 · CALL_BASE 24 · GRID_STYLE 24 · VALUE_CLEAR 22 · THROW 21 · GRID_LOCK 15 · LIST_REBIND 13 · FOCUS 11 · GRID_BIND 10 · LIST_BIND 5 · EXCEL 3 · STATE_RESET 1 · ⚠ 의미 확인 필요 188


## FP00595_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a7d3982 | .ctor | FP00595_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-0f0ad8e2 | .ctor | FP00595_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-7355263a | .ctor | FP00595_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-69675dc8 | .ctor | FP00595_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00595_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: this.chk_week.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43084a63 | this.chk_week.CheckedChanged | FP00595_BucketSetForm_Popup.cs:236 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fd015685 | this.chk_week.CheckedChanged | FP00595_BucketSetForm_Popup.cs:238 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00595_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c34a301 | Dispose | FP00595_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9716692 | this.Load | FP00595_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00595_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74d05df8 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-baedd582 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc33c4f3 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-87bdeda0 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-68083319 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-e11b49ca | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-6b322df1 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-2d708b94 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-747a155f | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00595_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef73a599 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e664ef93 | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-908e885d | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-aec9ca2f | this.Load 외 1 | FP00595_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00595_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74dec5d5 | (진입점 미연결) | FP00595_BucketSetForm_Popup.cs:228 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8f12f615 | (진입점 미연결) | FP00595_BucketSetForm_Popup.cs:230 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6c89c55 | this.Load | FP00595_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c8c8648b | this.Load | FP00595_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1bc82574 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d6446ee2 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-aa861289 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-9b2643ba | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-24b040f3 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ec7b269d | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-faab8cd2 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-d8a30d2a | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:222 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-886088c4 | this.usrButton1.Click | FP00595_BucketSetForm_Popup.cs:223 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fb51dc6 | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-aabc8152 | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d100ffe4 | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-5109cdd3 | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-c1fe0d6f | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-981287ce | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-712f7bca | this.usrButton2.Click | FP00595_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_CapaSync_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5196a190 | (진입점 미연결) | FP00595_CapaSync_Popup.cs:324 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d65b4ba5 | (진입점 미연결) | FP00595_CapaSync_Popup.cs:327 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0aa494a6 | (진입점 미연결) | FP00595_CapaSync_Popup.cs:328 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_CapaSync_Popup.btnCapaSync_Click

진입점: this.btnCapaSync.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9de0c5b | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:394 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(start_date)) | MESSAGE | MessageBox.Show | ("Enter[Start Date].") | 메시지 표시 |  |  |  |
| AC-7869ef34 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:395 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(start_date)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a87fded | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:399 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(end_date)) | MESSAGE | MessageBox.Show | ("Enter[End Date].") | 메시지 표시 |  |  |  |
| AC-84d9a552 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:400 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(end_date)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13f54990 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:409 | if (CanSave == false) | MESSAGE | MessageBox.Show | ("Select the line to run.") | 메시지 표시 |  |  |  |
| AC-326e87da | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:410 | if (CanSave == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cd4d8acc | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:426 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_isEngineRunning", Filter.Dictionary , "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isEngineRunning] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a51443c0 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:430 | if (dsRunning.Good()) | MESSAGE | MessageBox.Show | ("Engine is Running.\r\n: " + dsRunning.Tables[0].Rows[0]["PLAN_ID"].ToString()) | 메시지 표시 |  |  |  |
| AC-adb0272d | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:431 | if (dsRunning.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fac547d3 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:434 |  | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1beb0db9 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:442 | for (i> 0) ▸ if (yn == "N") | DATA_OP | updateTable.Rows.RemoveAt | (i - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c397e87 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:446 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["ACTIVE_FLAG"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-b0044e60 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:447 | for (i> 0) ▸ else of (yn == "N") | CALL_EXT | DateUtil_FP.GetDigitDate | (row["START_DATE"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f748443f | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:448 | for (i> 0) ▸ else of (yn == "N") | CALL_EXT | DateUtil_FP.GetDigitDate | (row["END_DATE"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-add7a128 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:449 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["START_DATE"] | start_date | 행/컬럼 값 대입 |  |  |  |
| AC-43447768 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:450 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["END_DATE"] | end_date | 행/컬럼 값 대입 |  |  |  |
| AC-6d7c168f | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:455 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_row", "update_capaSync_1", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_capaSync_1] \| FP\Pla… | 엔드포인트 호출 |  |  |  |
| AC-a45e6830 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:456 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00595_row", "update_capaSync_2", updateTable, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_capaSync_2] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-20e1f153 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:457 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP00595_row", "execute_capaSync", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_capaSync] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-d0f516ff | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:461 | catch ((Exception exce)) | MESSAGE | MessageBox.Show | (exce.ToString()) | 메시지 표시 |  |  |  |
| AC-25731bb9 | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:462 | catch ((Exception exce)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-263eec0e | this.btnCapaSync.Click | FP00595_CapaSync_Popup.cs:466 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FP00595_CapaSync_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c34137e8 | this.Load | FP00595_CapaSync_Popup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d16326f | this.Load | FP00595_CapaSync_Popup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5032be50 | this.Load | FP00595_CapaSync_Popup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_CapaSync_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-059e73d2 | this.Load | FP00595_CapaSync_Popup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_CapaSync_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c685eefe | Dispose | FP00595_CapaSync_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_CapaSync_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d86ed32 | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:259 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_capaSync", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_capaSync] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b5f41796 | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:269 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ try | DATA_OP | row["START_DATE"] | date | 행/컬럼 값 대입 |  |  |  |
| AC-9b437590 | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:278 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ try | DATA_OP | row["END_DATE"] | date | 행/컬럼 값 대입 |  |  |  |
| AC-7d78e53e | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:283 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ if (row["ACTIVE_FLAG"].ToString() == "1") | DATA_OP | row["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7492334b | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:285 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ else of (row["ACTIVE_FLAG"].ToString() == "1") | DATA_OP | row["ACTIVE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d0141c73 | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:289 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-df55fb9c | this.Load [try ▸ lambda] 외 2 | FP00595_CapaSync_Popup.cs:293 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_CapaSync_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f512e9c1 | this.Load 외 2 | FP00595_CapaSync_Popup.cs:211 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-145ff3e2 | this.Load 외 2 | FP00595_CapaSync_Popup.cs:221 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6d482e8c | this.Load 외 2 | FP00595_CapaSync_Popup.cs:228 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b83262ca | this.Load 외 2 | FP00595_CapaSync_Popup.cs:232 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SwitchLock | (6,8) | 그리드 편집 잠금 전환 |  |  |  |
| AC-522661f3 | this.Load 외 2 | FP00595_CapaSync_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a4ad9330 | this.Load 외 2 | FP00595_CapaSync_Popup.cs:243 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-aee60377 | this.Load 외 2 | FP00595_CapaSync_Popup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00595_CapaSync_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5e74394 | this.Load | FP00595_CapaSync_Popup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-77004d00 | this.Load | FP00595_CapaSync_Popup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_CapaSync_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a928ae37 | this.Load | FP00595_CapaSync_Popup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a6767a9 | this.Load | FP00595_CapaSync_Popup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_CapaSync_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67639500 | (진입점 미연결) | FP00595_CapaSync_Popup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_CapaSync_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e05b0ab | this.Load | FP00595_CapaSync_Popup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-febb05e8 | this.Load | FP00595_CapaSync_Popup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-3da52589 | this.Load | FP00595_CapaSync_Popup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_CapaSync_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83449324 | this.spdMain.CellClick | FP00595_CapaSync_Popup.cs:339 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-99418d00 | this.spdMain.CellClick | FP00595_CapaSync_Popup.cs:340 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e1da4801 | this.spdMain.CellClick | FP00595_CapaSync_Popup.cs:343 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_CapaSync_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5f21e4a | this.spdMain.CellDoubleClick | FP00595_CapaSync_Popup.cs:349 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d414e166 | this.spdMain.CellDoubleClick | FP00595_CapaSync_Popup.cs:350 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-471652a7 | this.spdMain.CellDoubleClick | FP00595_CapaSync_Popup.cs:353 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-1cd4791e | this.spdMain.CellDoubleClick | FP00595_CapaSync_Popup.cs:356 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_CapaSync_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange / spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5100e1b0 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:492 | if (planDate == null) | MESSAGE | MessageBox.Show | ("I need Plan Date") | 메시지 표시 |  |  |  |
| AC-01ba645f | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:493 | if (planDate == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b7b5e68 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:512 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter Start Date") | 메시지 표시 |  |  |  |
| AC-bc5a5312 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:518 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (startDate.V… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-7c432136 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:524 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_start_date | 컨트롤 값 설정 |  |  |  |
| AC-14a6dd22 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:545 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter [Start Date]") | 메시지 표시 |  |  |  |
| AC-c96b33f6 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:551 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (string.IsNull… | MESSAGE | MessageBox.Show | ("Enter [End Date]") | 메시지 표시 |  |  |  |
| AC-2e2cbe60 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:557 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (string.I… | MESSAGE | MessageBox.Show | ("It cannot be less than [Start Date].") | 메시지 표시 |  |  |  |
| AC-3da7c292 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:562 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (string.I… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-3391ca1c | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:568 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_end_date | 컨트롤 값 설정 |  |  |  |
| AC-dd0a8f7d | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:595 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter [Start Date]") | 메시지 표시 |  |  |  |
| AC-87869357 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:601 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (string.IsN… | MESSAGE | MessageBox.Show | ("Enter [End Date]") | 메시지 표시 |  |  |  |
| AC-e14adf9f | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:607 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (strin… | MESSAGE | MessageBox.Show | ("It cannot be less than [Start Date].") | 메시지 표시 |  |  |  |
| AC-539c5da9 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:612 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (strin… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-ad82c003 | this.spdMain.EditChange 외 1 | FP00595_CapaSync_Popup.cs:619 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_yn | 컨트롤 값 설정 |  |  |  |

## FP00595_EquipmentPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-227fdad3 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_EquipmentPopup.cs:257 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-c8284f64 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_EquipmentPopup.cs:260 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9279f5f8 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_EquipmentPopup.cs:261 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_EquipmentPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-305d6a54 | this.Load | FP00595_EquipmentPopup.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d297f733 | this.Load | FP00595_EquipmentPopup.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-13bf42d0 | this.Load | FP00595_EquipmentPopup.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_EquipmentPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da0856a8 | this.Load | FP00595_EquipmentPopup.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_EquipmentPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d872cb6 | Dispose | FP00595_EquipmentPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_EquipmentPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c64baa0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:204 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0ca27255 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:207 |  | DATA_OP | Filter["FACTORY_ID"] | txtFactory.Text | 행/컬럼 값 대입 |  |  |  |
| AC-3f9b8bbf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:208 |  | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text | 행/컬럼 값 대입 |  |  |  |
| AC-824b8b37 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:209 |  | DATA_OP | Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6e5d46ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:210 |  | DATA_OP | Filter["EQUIPMENT_ID"] | txtEquipment.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7f15bdf5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:213 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00595_EQUIPMENT", Filter, UserInfoContext.Cur… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2f502726 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:214 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00595_EQUIPMENT", Filter, UserInfoContext.Current.UserId, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-29b6aaaf | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:220 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e3aaf7cd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:223 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7a74e611 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:225 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-49b85915 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_EquipmentPopup.cs:229 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_EquipmentPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5b8f845 | this.Load | FP00595_EquipmentPopup.cs:103 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0305a4b | this.Load | FP00595_EquipmentPopup.cs:105 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_EquipmentPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c18a0ab2 | this.Load | FP00595_EquipmentPopup.cs:120 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-20e69e44 | this.Load | FP00595_EquipmentPopup.cs:121 |  | VALUE_SET | txtOperation.Text | Filter["OPERATION_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-50e6619b | this.Load | FP00595_EquipmentPopup.cs:122 |  | VALUE_SET | txtLine.Text | Filter["LINE_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00595_EquipmentPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35b59f77 | this.Load | FP00595_EquipmentPopup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b39fcef | this.Load | FP00595_EquipmentPopup.cs:146 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_EquipmentPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6da0bde | (진입점 미연결) | FP00595_EquipmentPopup.cs:165 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_EquipmentPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f893ff60 | this.Load | FP00595_EquipmentPopup.cs:152 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-999f8e11 | this.Load | FP00595_EquipmentPopup.cs:153 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-090e0cba | this.Load | FP00595_EquipmentPopup.cs:157 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_EquipmentPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-657371f5 | this.spdMain.CellClick | FP00595_EquipmentPopup.cs:272 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-39c0bb13 | this.spdMain.CellClick | FP00595_EquipmentPopup.cs:273 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ec329e48 | this.spdMain.CellClick | FP00595_EquipmentPopup.cs:276 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_EquipmentPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1fc0cb | this.spdMain.CellDoubleClick | FP00595_EquipmentPopup.cs:282 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-fc50de33 | this.spdMain.CellDoubleClick | FP00595_EquipmentPopup.cs:283 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cc458f59 | this.spdMain.CellDoubleClick | FP00595_EquipmentPopup.cs:286 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-5199db75 | this.spdMain.CellDoubleClick | FP00595_EquipmentPopup.cs:289 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-be8df0d5 | this.spdMain.CellDoubleClick | FP00595_EquipmentPopup.cs:299 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4546eaef | .ctor | FP00595_ExcelPopup.cs:152 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-cb948382 | .ctor | FP00595_ExcelPopup.cs:153 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ac59494b | .ctor | FP00595_ExcelPopup.cs:154 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-4d459fe0 | .ctor | FP00595_ExcelPopup.cs:155 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c48bd2ac | .ctor | FP00595_ExcelPopup.cs:156 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00595_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4637c6b2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:230 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8e4d8157 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:231 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e8aa56c2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:232 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f583a797 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:233 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5432c3a8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:235 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-a2d5f292 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:235 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6a33f99b | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:236 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-084a2dc9 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:236 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e6bcbfdb | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:237 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b8acf63 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:237 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4650e148 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:238 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1ac12c9 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2907c0d2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:247 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-ca972272 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:248 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-4958e533 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:249 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-e7a8b996 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_ExcelPopup.cs:250 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00595_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3d7a00a | this.btnClose.Click | FP00595_ExcelPopup.cs:1011 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-351bae8a | this.btnDownload.Click | FP00595_ExcelPopup.cs:993 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-70f6b18c | this.btnDownload.Click | FP00595_ExcelPopup.cs:994 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00595_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a77aa5b | this.btnFind.Click | FP00595_ExcelPopup.cs:984 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b420103b | this.btnFind.Click | FP00595_ExcelPopup.cs:985 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42b8266a | this.Load | FP00595_ExcelPopup.cs:278 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41be6a07 | this.Load | FP00595_ExcelPopup.cs:279 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb3cab70 | this.Load | FP00595_ExcelPopup.cs:280 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_ExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96247dd | dateRange.ValueChanged | FP00595_ExcelPopup.cs:1016 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b1dabf18 | dateRange.ValueChanged | FP00595_ExcelPopup.cs:1017 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00595_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cd3b2a8 | (진입점 미연결) | FP00595_ExcelPopup.cs:947 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa58191e | (진입점 미연결) | FP00595_ExcelPopup.cs:947 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00595_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-641be269 | this.Load | FP00595_ExcelPopup.cs:273 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4229c213 | Dispose | FP00595_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55af3c7e | (진입점 미연결) | FP00595_ExcelPopup.cs:832 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1750d671 | FindButton | FP00595_ExcelPopup.cs:321 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e7ef60e7 | FindButton | FP00595_ExcelPopup.cs:322 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f3248639 | FindButton | FP00595_ExcelPopup.cs:324 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebf8fabb | this.Load 외 2 | FP00595_ExcelPopup.cs:351 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-792e1ffd | this.Load 외 2 | FP00595_ExcelPopup.cs:352 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-0d27143e | this.Load 외 2 | FP00595_ExcelPopup.cs:352 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-91e92e65 | this.Load 외 2 | FP00595_ExcelPopup.cs:356 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb2d298 | this.Load 외 2 | FP00595_ExcelPopup.cs:357 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-65fcdcba | this.Load 외 2 | FP00595_ExcelPopup.cs:359 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e606b92e | this.Load 외 2 | FP00595_ExcelPopup.cs:360 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cf7c14f6 | this.Load 외 2 | FP00595_ExcelPopup.cs:361 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-42347cb6 | this.Load 외 2 | FP00595_ExcelPopup.cs:362 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-23417cde | this.Load 외 2 | FP00595_ExcelPopup.cs:363 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4463067f | this.Load 외 2 | FP00595_ExcelPopup.cs:364 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-af0716b6 | this.Load 외 2 | FP00595_ExcelPopup.cs:371 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ed21f78 | this.Load 외 2 | FP00595_ExcelPopup.cs:376 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-48a66856 | this.Load 외 2 | FP00595_ExcelPopup.cs:378 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-f9adafb8 | this.Load 외 2 | FP00595_ExcelPopup.cs:379 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-08daa4ae | this.Load 외 2 | FP00595_ExcelPopup.cs:380 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-bc987000 | this.Load 외 2 | FP00595_ExcelPopup.cs:382 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5a506d8a | this.Load 외 2 | FP00595_ExcelPopup.cs:385 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b1feab2 | this.Load 외 2 | FP00595_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f07b18e | this.Load 외 2 | FP00595_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ad68de44 | this.Load 외 2 | FP00595_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-5a23efeb | this.Load 외 2 | FP00595_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a6059764 | this.Load 외 2 | FP00595_ExcelPopup.cs:390 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b74eba24 | this.Load 외 2 | FP00595_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-ce57bb7f | this.Load 외 2 | FP00595_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-50736d7f | this.Load 외 2 | FP00595_ExcelPopup.cs:400 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-b10b3957 | this.Load 외 2 | FP00595_ExcelPopup.cs:401 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-54cda8ec | this.Load 외 2 | FP00595_ExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-22946c3e | this.Load 외 2 | FP00595_ExcelPopup.cs:408 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e0242fd | this.Load 외 2 | FP00595_ExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1689698 | this.Load 외 2 | FP00595_ExcelPopup.cs:413 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f700c7d7 | this.Load 외 2 | FP00595_ExcelPopup.cs:422 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e816787 | this.Load 외 2 | FP00595_ExcelPopup.cs:425 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-519bf3a4 | this.Load 외 2 | FP00595_ExcelPopup.cs:428 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e8762a8 | this.Load 외 2 | FP00595_ExcelPopup.cs:432 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16f415b4 | this.Load 외 2 | FP00595_ExcelPopup.cs:434 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-bfa528c0 | this.Load 외 2 | FP00595_ExcelPopup.cs:439 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-538ac2c2 | this.Load 외 2 | FP00595_ExcelPopup.cs:441 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-1ed6c27f | this.Load 외 2 | FP00595_ExcelPopup.cs:447 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ba612fc | this.Load 외 2 | FP00595_ExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ffed730 | this.Load 외 2 | FP00595_ExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fc94e8e0 | this.Load 외 2 | FP00595_ExcelPopup.cs:460 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-50be99d4 | this.Load 외 2 | FP00595_ExcelPopup.cs:461 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-337db6d8 | this.Load 외 2 | FP00595_ExcelPopup.cs:462 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1ab424fb | this.Load 외 2 | FP00595_ExcelPopup.cs:463 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cb5c2d53 | this.Load 외 2 | FP00595_ExcelPopup.cs:464 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00595_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28656492 | this.Load | FP00595_ExcelPopup.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-800e1b70 | this.Load | FP00595_ExcelPopup.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8047b6a | this.Load | FP00595_ExcelPopup.cs:206 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-7f5028f4 | this.Load | FP00595_ExcelPopup.cs:207 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-50d0e54f | this.Load | FP00595_ExcelPopup.cs:211 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-8bd3eb78 | this.Load | FP00595_ExcelPopup.cs:212 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-7e8f9fd9 | this.Load | FP00595_ExcelPopup.cs:215 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6ef1470b | this.Load | FP00595_ExcelPopup.cs:216 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0c03faae | this.Load | FP00595_ExcelPopup.cs:220 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00595_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0b1157f | this.Load | FP00595_ExcelPopup.cs:290 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebd8dd7f | this.Load | FP00595_ExcelPopup.cs:291 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-940f35e0 | (진입점 미연결) | FP00595_ExcelPopup.cs:311 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c11aa4dd | this.btnUpload.Click | FP00595_ExcelPopup.cs:844 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-feb7344d | this.btnUpload.Click | FP00595_ExcelPopup.cs:844 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d0cf3bd | this.btnUpload.Click | FP00595_ExcelPopup.cs:845 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f4b84d8 | this.btnUpload.Click | FP00595_ExcelPopup.cs:846 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f8cf74a9 | this.btnUpload.Click | FP00595_ExcelPopup.cs:847 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d42287f | this.btnUpload.Click | FP00595_ExcelPopup.cs:849 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-41873110 | this.btnUpload.Click | FP00595_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-009e39b9 | this.btnUpload.Click | FP00595_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1de12e5d | this.btnUpload.Click | FP00595_ExcelPopup.cs:861 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de79b96d | this.btnUpload.Click | FP00595_ExcelPopup.cs:862 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a8c37955 | this.btnUpload.Click | FP00595_ExcelPopup.cs:865 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a96f612f | this.btnUpload.Click | FP00595_ExcelPopup.cs:866 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4bc96057 | this.btnUpload.Click | FP00595_ExcelPopup.cs:871 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b39bbd2 | this.btnUpload.Click | FP00595_ExcelPopup.cs:872 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ef0321e | this.btnUpload.Click | FP00595_ExcelPopup.cs:884 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1bf8ceb | this.btnUpload.Click | FP00595_ExcelPopup.cs:888 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-29ded010 | this.btnUpload.Click | FP00595_ExcelPopup.cs:900 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-daf4bc72 | this.btnUpload.Click | FP00595_ExcelPopup.cs:903 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6386198 | this.btnUpload.Click | FP00595_ExcelPopup.cs:906 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3985af23 | this.btnUpload.Click | FP00595_ExcelPopup.cs:910 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0fc33873 | this.btnUpload.Click | FP00595_ExcelPopup.cs:912 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-ddb41e26 | this.btnUpload.Click | FP00595_ExcelPopup.cs:917 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c98244b1 | this.btnUpload.Click | FP00595_ExcelPopup.cs:919 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-aac3088f | this.btnUpload.Click | FP00595_ExcelPopup.cs:925 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3d065abf | this.btnUpload.Click | FP00595_ExcelPopup.cs:930 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-a253a8e2 | this.btnUpload.Click | FP00595_ExcelPopup.cs:934 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c44b952e | this.btnUpload.Click | FP00595_ExcelPopup.cs:935 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1e1cad20 | this.btnUpload.Click | FP00595_ExcelPopup.cs:938 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00595_ExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9334235f | this.radioMPP.CheckedChanged | FP00595_ExcelPopup.cs:1023 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b32bdbb4 | this.radioMPP.CheckedChanged | FP00595_ExcelPopup.cs:1025 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00595_ExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-133478a7 | this.radioWPP.CheckedChanged | FP00595_ExcelPopup.cs:1032 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c90480c5 | this.radioWPP.CheckedChanged | FP00595_ExcelPopup.cs:1034 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00595_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1e32972 | this.btnSave.Click | FP00595_ExcelPopup.cs:567 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (radioMPP.Checked == true) | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-9596471f | this.btnSave.Click | FP00595_ExcelPopup.cs:569 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-463c42e7 | this.btnSave.Click | FP00595_ExcelPopup.cs:573 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec38f90e | this.btnSave.Click | FP00595_ExcelPopup.cs:578 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-b9ae4560 | this.btnSave.Click | FP00595_ExcelPopup.cs:579 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee7e78f4 | this.btnSave.Click | FP00595_ExcelPopup.cs:583 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-71a39237 | this.btnSave.Click | FP00595_ExcelPopup.cs:584 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97c5dadd | this.btnSave.Click | FP00595_ExcelPopup.cs:588 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-bcbbdef3 | this.btnSave.Click | FP00595_ExcelPopup.cs:588 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7d349cb | this.btnSave.Click | FP00595_ExcelPopup.cs:593 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c282916e | this.btnSave.Click | FP00595_ExcelPopup.cs:594 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0d4d9e08 | this.btnSave.Click | FP00595_ExcelPopup.cs:595 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c89cf3a | this.btnSave.Click | FP00595_ExcelPopup.cs:596 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-29b5bd0d | this.btnSave.Click | FP00595_ExcelPopup.cs:597 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7511aeeb | this.btnSave.Click | FP00595_ExcelPopup.cs:598 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c2f38c4e | this.btnSave.Click | FP00595_ExcelPopup.cs:606 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38538065 | this.btnSave.Click | FP00595_ExcelPopup.cs:609 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9108dd4f | this.btnSave.Click | FP00595_ExcelPopup.cs:611 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-30ef91f2 | this.btnSave.Click | FP00595_ExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-98830eb7 | this.btnSave.Click | FP00595_ExcelPopup.cs:619 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-601f46f9 | this.btnSave.Click | FP00595_ExcelPopup.cs:620 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-51575c28 | this.btnSave.Click | FP00595_ExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-b5d5ac1a | this.btnSave.Click | FP00595_ExcelPopup.cs:628 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-05db72c6 | this.btnSave.Click | FP00595_ExcelPopup.cs:629 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c4bddc45 | this.btnSave.Click | FP00595_ExcelPopup.cs:630 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b9a6a01e | this.btnSave.Click | FP00595_ExcelPopup.cs:631 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-53d74626 | this.btnSave.Click | FP00595_ExcelPopup.cs:632 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4aeff2ac | this.btnSave.Click | FP00595_ExcelPopup.cs:633 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e24424a | this.btnSave.Click | FP00595_ExcelPopup.cs:634 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d61dbeba | this.btnSave.Click | FP00595_ExcelPopup.cs:637 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-17d752ee | this.btnSave.Click | FP00595_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b66e4a1 | this.btnSave.Click | FP00595_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3433d459 | this.btnSave.Click | FP00595_ExcelPopup.cs:675 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e2d61f4 | this.btnSave.Click | FP00595_ExcelPopup.cs:677 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4621d7ab | this.btnSave.Click | FP00595_ExcelPopup.cs:680 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-e6a0bb25 | this.btnSave.Click | FP00595_ExcelPopup.cs:685 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-35474f25 | this.btnSave.Click | FP00595_ExcelPopup.cs:687 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c531ea4 | this.btnSave.Click | FP00595_ExcelPopup.cs:690 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e2308297 | this.btnSave.Click | FP00595_ExcelPopup.cs:694 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-23836b62 | this.btnSave.Click | FP00595_ExcelPopup.cs:696 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8cecb08b | this.btnSave.Click | FP00595_ExcelPopup.cs:699 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f619f881 | this.btnSave.Click | FP00595_ExcelPopup.cs:703 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6dd40e26 | this.btnSave.Click | FP00595_ExcelPopup.cs:716 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-eff691b1 | this.btnSave.Click | FP00595_ExcelPopup.cs:718 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e033c3e | this.btnSave.Click | FP00595_ExcelPopup.cs:720 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a6e7b11 | this.btnSave.Click | FP00595_ExcelPopup.cs:724 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-44c7d8c2 | this.btnSave.Click | FP00595_ExcelPopup.cs:740 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1977d481 | this.btnSave.Click | FP00595_ExcelPopup.cs:745 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-f6fbba11 | this.btnSave.Click | FP00595_ExcelPopup.cs:746 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ce7ad263 | this.btnSave.Click | FP00595_ExcelPopup.cs:752 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-18eff527 | this.btnSave.Click | FP00595_ExcelPopup.cs:759 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-27f0577f | this.btnSave.Click | FP00595_ExcelPopup.cs:790 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce16322d | this.btnSave.Click | FP00595_ExcelPopup.cs:792 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-652d198b | this.btnSave.Click | FP00595_ExcelPopup.cs:793 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-12e7504d | this.btnSave.Click | FP00595_ExcelPopup.cs:804 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:" + e.Message)) | 메시지 표시 |  |  |  |
| AC-51152457 | this.btnSave.Click | FP00595_ExcelPopup.cs:805 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1d71de31 | this.btnSave.Click | FP00595_ExcelPopup.cs:810 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-626d07f9 | this.btnSave.Click | FP00595_ExcelPopup.cs:811 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7d814c49 | this.btnSave.Click | FP00595_ExcelPopup.cs:812 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-af08e1bd | this.btnSave.Click | FP00595_ExcelPopup.cs:813 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3a140af7 | this.btnSave.Click | FP00595_ExcelPopup.cs:814 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-743b16a0 | this.btnSave.Click | FP00595_ExcelPopup.cs:815 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00595_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8139788e | this.Load | FP00595_ExcelPopup.cs:303 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f8fb879 | this.Load | FP00595_ExcelPopup.cs:304 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00595_ExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026cb6ea | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:258 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e62c298d | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:259 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f8d1757d | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:260 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-749ba0ee | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:264 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e0aec0df | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:265 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-197c587e | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_ExcelPopup.cs:266 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00595_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9cb4261 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_ItemPopup.cs:250 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-80da46f0 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_ItemPopup.cs:253 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1113dac9 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_ItemPopup.cs:254 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53926231 | this.Load | FP00595_ItemPopup.cs:129 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89e90d39 | this.Load | FP00595_ItemPopup.cs:130 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-15b4304e | this.Load | FP00595_ItemPopup.cs:131 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-914c515e | this.Load | FP00595_ItemPopup.cs:124 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8027e459 | Dispose | FP00595_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ed1c4bc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:200 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9188680f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:203 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |
| AC-36a5caf6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:204 |  | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-53951567 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:207 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => Data_FP.CallGeneralProcedure("PR_UI_FP00595_ITEM", Filter, UserInfoContext.Current.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2d2bed32 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:208 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00595_ITEM", Filter, UserInfoContext.Current.UserId, "SELECT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cefe5e22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:213 | if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6a4702fb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:216 | if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-93913922 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:218 | if (ds.Tables[0].Rows.Count > 0) | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-684aadcb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP00595_ItemPopup.cs:222 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7f220c0 | this.Load | FP00595_ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2158d6fb | this.Load | FP00595_ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e92797d | this.Load | FP00595_ItemPopup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cdfa38c | this.Load | FP00595_ItemPopup.cs:142 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02e97658 | (진입점 미연결) | FP00595_ItemPopup.cs:161 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-746325ad | this.Load | FP00595_ItemPopup.cs:148 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93fc6f39 | this.Load | FP00595_ItemPopup.cs:149 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-efa458a5 | this.Load | FP00595_ItemPopup.cs:153 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58d05848 | this.spdMain.CellClick | FP00595_ItemPopup.cs:265 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0ffa9ca1 | this.spdMain.CellClick | FP00595_ItemPopup.cs:266 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b07557b4 | this.spdMain.CellClick | FP00595_ItemPopup.cs:269 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bef647c5 | this.spdMain.CellDoubleClick | FP00595_ItemPopup.cs:275 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d6b3b636 | this.spdMain.CellDoubleClick | FP00595_ItemPopup.cs:276 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dfbb19ba | this.spdMain.CellDoubleClick | FP00595_ItemPopup.cs:279 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-c1fda157 | this.spdMain.CellDoubleClick | FP00595_ItemPopup.cs:282 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0bec6ff | this.spdMain.CellDoubleClick | FP00595_ItemPopup.cs:292 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_LineAddPopup._isPDSType

진입점: this.Load / cbo_market.SelectedIndexChanged / cbo_prodtype.SelectedIndexChanged / this.btnVersion.Click / this.btnLine.Click / this.btnMaterial.Click / this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc30f87d | this.Load 외 6 | FP00595_LineAddPopup.cs:306 | if (dtPdsType.Rows.Count > 0) | DATA_OP | dtPdsType.Select | ("FP_PRODUCTION_TYPE = '" + sProdType + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-adf3131e | this.Load 외 6 | FP00595_LineAddPopup.cs:309 | if (dtPdsType.Rows.Count > 0) ▸ if (res.Length > 0) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a60d5d1f | this.Load 외 6 | FP00595_LineAddPopup.cs:311 | if (dtPdsType.Rows.Count > 0) ▸ else of (res.Length > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-83883804 | this.Load 외 6 | FP00595_LineAddPopup.cs:314 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f81bf6 | .ctor | FP00595_LineAddPopup.cs:98 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-e2b0d4c9 | .ctor | FP00595_LineAddPopup.cs:99 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP00595_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7db4635 | this.btnClose.Click | FP00595_LineAddPopup.cs:507 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_LineAddPopup.btnLine_Click

진입점: this.btnLine.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-554c3313 | this.btnLine.Click | FP00595_LineAddPopup.cs:1182 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | MESSAGE | MessageBox.Show | (rtnMsg) | 메시지 표시 |  |  |  |
| AC-75e1c96e | this.btnLine.Click | FP00595_LineAddPopup.cs:1183 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12229507 | this.btnLine.Click | FP00595_LineAddPopup.cs:1188 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-d99c4591 | this.btnLine.Click | FP00595_LineAddPopup.cs:1189 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8dc64f3 | this.btnLine.Click | FP00595_LineAddPopup.cs:1193 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26a7fde1 | this.btnLine.Click | FP00595_LineAddPopup.cs:1199 | if (dtCurrWeek != null) ▸ if (dtCurrWeek.Rows.Count > 0) | DATA_OP | Filter["RELEASE_VALUE"] | dtCurrWeek.Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c334ac4 | this.btnLine.Click | FP00595_LineAddPopup.cs:1205 |  | POPUP | new FP00595_LinePopup | () | 팝업/폼 생성 |  |  |  |
| AC-f657032e | this.btnLine.Click | FP00595_LineAddPopup.cs:1206 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-312182f2 | this.btnLine.Click | FP00595_LineAddPopup.cs:1207 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-545f11ae | this.btnLine.Click | FP00595_LineAddPopup.cs:1207 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-442829b8 | this.btnLine.Click | FP00595_LineAddPopup.cs:1209 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-afccf140 | this.btnLine.Click | FP00595_LineAddPopup.cs:1210 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c2aa5dd0 | this.btnLine.Click | FP00595_LineAddPopup.cs:1212 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-36c47dce | this.btnLine.Click | FP00595_LineAddPopup.cs:1217 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | data.Table.Columns.Contains | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bdce39b7 | this.btnLine.Click | FP00595_LineAddPopup.cs:1218 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) ▸ if (data.Table.Columns.Contains("PLANT_ID")) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-57f8cdd2 | this.btnLine.Click | FP00595_LineAddPopup.cs:1219 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = data["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75b32369 | this.btnLine.Click | FP00595_LineAddPopup.cs:1219 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtBuilding.Text | data["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-42161824 | this.btnLine.Click | FP00595_LineAddPopup.cs:1220 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text = data["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c7f2b4e4 | this.btnLine.Click | FP00595_LineAddPopup.cs:1220 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtOperation.Text | data["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-43e210ba | this.btnLine.Click | FP00595_LineAddPopup.cs:1221 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LINE_ID"] | txtLine.Text = data["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-32c859a1 | this.btnLine.Click | FP00595_LineAddPopup.cs:1221 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtLine.Text | data["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-af46b23b | this.btnLine.Click | FP00595_LineAddPopup.cs:1222 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ELECTRODE_TYPE"] | txtElectrodType.Text = data["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ab98f5af | this.btnLine.Click | FP00595_LineAddPopup.cs:1222 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtElectrodType.Text | data["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-658a6ad5 | this.btnLine.Click | FP00595_LineAddPopup.cs:1223 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["LOCATION"] | data["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-96db666b | this.btnLine.Click | FP00595_LineAddPopup.cs:1224 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PROD_VERSION_TYPE"] | data["PROD_VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0305cb04 | this.btnLine.Click | FP00595_LineAddPopup.cs:1226 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["EQUIPMENT_ID"] | txtEquipment.Text = data["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac6a6662 | this.btnLine.Click | FP00595_LineAddPopup.cs:1226 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtEquipment.Text | data["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-39394f3d | this.btnLine.Click | FP00595_LineAddPopup.cs:1228 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["WORK_REQUEST_MODEL_ID"] | txtWorkSheetModel.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-2688a837 | this.btnLine.Click | FP00595_LineAddPopup.cs:1228 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtWorkSheetModel.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1aa78d59 | this.btnLine.Click | FP00595_LineAddPopup.cs:1229 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["VERSION"] | txtVersion.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc72e3c2 | this.btnLine.Click | FP00595_LineAddPopup.cs:1229 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-97a242f3 | this.btnLine.Click | FP00595_LineAddPopup.cs:1230 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PROD_SEQ"] | txtDegree.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-8c74927f | this.btnLine.Click | FP00595_LineAddPopup.cs:1230 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtDegree.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5a2b7e79 | this.btnLine.Click | FP00595_LineAddPopup.cs:1231 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLM_EC_NO"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00595_LineAddPopup.btnMaterial_Click

진입점: this.btnMaterial.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce9cc306 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1120 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | MESSAGE | MessageBox.Show | (rtnMsg) | 메시지 표시 |  |  |  |
| AC-5f51c184 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1121 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e41874a7 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1124 |  | POPUP | new FP00595_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-45efc21e | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1125 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-2d85931c | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1126 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-4325b04b | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1127 |  | DATA_OP | popup.Filter["AMEND_INSTANCE"] | Filter["AMEND_INSTANCE"] | 행/컬럼 값 대입 |  |  |  |
| AC-adc5b30f | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1128 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-575d05b3 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1129 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ba30eede | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1130 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6550d666 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1132 |  | DATA_OP | popup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-adb7425c | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1133 |  | DATA_OP | popup.Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6c7024f5 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1135 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a6e72dc3 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1137 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-756a4c58 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1143 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = data["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0257741 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1143 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-43d704f9 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1144 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7561ae18 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1144 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtNickName.Text | data["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b9af3e1d | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1145 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["ITEM_TYPE"] | txtItemType.Text = data["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d4dd11f7 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1145 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItemType.Text | data["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1a9f08ae | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1147 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtBuilding.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-2edbf105 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1148 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtOperation.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-b2ec641d | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1149 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtLine.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-82f301cd | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1150 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtElectrodType.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-bf3b61fb | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1151 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtEquipment.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-d099c808 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1152 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtWorkSheetModel.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-b41ff7ba | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1153 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtVersion.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-c5217ac5 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1154 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtDegree.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-21dafe21 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1156 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-878bf65f | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1157 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b4ea3de7 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1158 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("LINE_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8a79e3ec | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1159 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-96e0fbf1 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1160 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b7aa6035 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1161 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("WORK_REQUEST_MODEL_ID" , "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1b76fc79 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1162 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("VERSION" , "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d7b4f8e6 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1163 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("PROD_SEQ" , "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ae38b048 | this.btnMaterial.Click | FP00595_LineAddPopup.cs:1164 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO" , "") | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00595_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ce53d88 | this.btnSave.Click | FP00595_LineAddPopup.cs:500 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf932123 | this.btnSql.Click | FP00595_LineAddPopup.cs:1246 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-071ef22e | this.btnSql.Click | FP00595_LineAddPopup.cs:1249 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6a3e40f5 | this.btnSql.Click | FP00595_LineAddPopup.cs:1250 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d193acbc | this.btnSql.Click | FP00595_LineAddPopup.cs:1252 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00622_LINE_ADD_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-38e8d66c | this.btnSql.Click | FP00595_LineAddPopup.cs:1254 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_LineAddPopup.btnVersion_Click

진입점: this.btnVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-015e4962 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1631 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | MESSAGE | MessageBox.Show | (rtnMsg) | 메시지 표시 |  |  |  |
| AC-fe93d28e | this.btnVersion.Click | FP00595_LineAddPopup.cs:1632 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90706ff0 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1638 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert material value") | 메시지 표시 |  |  |  |
| AC-9834bef3 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1639 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-567a1d68 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1643 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("Please insert line value") | 메시지 표시 |  |  |  |
| AC-cb0beccf | this.btnVersion.Click | FP00595_LineAddPopup.cs:1644 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c63a7201 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1649 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | cbo_prodtype.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ed9b5a2f | this.btnVersion.Click | FP00595_LineAddPopup.cs:1650 |  | DATA_OP | Filter["MARKET"] | cbo_market.Text | 행/컬럼 값 대입 |  |  |  |
| AC-85465a44 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1654 |  | POPUP | new FP00595_VersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0bdfd6fd | this.btnVersion.Click | FP00595_LineAddPopup.cs:1655 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-5425ba00 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1656 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-559f1fa7 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1656 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c977b81 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1658 |  | DATA_OP | popup.Filter["LINE_ID"] | txtLine.Text | 행/컬럼 값 대입 |  |  |  |
| AC-e8ab8491 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1659 |  | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d8b993d6 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1660 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3dba752d | this.btnVersion.Click | FP00595_LineAddPopup.cs:1662 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-93e00233 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1674 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | data.Table.Columns.Contains | ("VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee5739a5 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1677 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) ▸ if (data.Table.Columns.Contains("VERSION_TYPE")) | DATA_OP | Filter["SEL_VERSION_TYPE"] | sel_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-0f9b7d16 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1680 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["WORK_REQUEST_MODEL_ID"] | txtWorkSheetModel.Text = data["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-02de3ad8 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1680 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtWorkSheetModel.Text | data["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f9388104 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1681 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["VERSION"] | txtVersion.Text = data["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6e0576e | this.btnVersion.Click | FP00595_LineAddPopup.cs:1681 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtVersion.Text | data["VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-26ddaeed | this.btnVersion.Click | FP00595_LineAddPopup.cs:1682 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PROD_SEQ"] | txtDegree.Text = data["PROD_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0ef5fca | this.btnVersion.Click | FP00595_LineAddPopup.cs:1682 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtDegree.Text | data["PROD_SEQ"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f84a9695 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1683 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLM_EC_NO"] | txtPdsID.Text = "-" | 행/컬럼 값 대입 |  |  |  |
| AC-09bc32c9 | this.btnVersion.Click | FP00595_LineAddPopup.cs:1683 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtPdsID.Text | "-" | 컨트롤 값 설정 |  |  |  |

## FP00595_LineAddPopup.CbMPP_CheckedChanged

진입점: cbMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17120624 | cbMPP.CheckedChanged | FP00595_LineAddPopup.cs:335 | if (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-91593222 | cbMPP.CheckedChanged | FP00595_LineAddPopup.cs:336 | if (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-29a3f965 | cbMPP.CheckedChanged | FP00595_LineAddPopup.cs:340 | else of (cbMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-4aad6bda | cbMPP.CheckedChanged | FP00595_LineAddPopup.cs:341 | else of (cbMPP.Checked == true) | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00595_LineAddPopup.cbo_market_changed

진입점: cbo_market.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4923f5 | cbo_market.SelectedIndexChanged | FP00595_LineAddPopup.cs:376 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | MESSAGE | MessageBox.Show | (rtnMsg) | 메시지 표시 |  |  |  |
| AC-e4310ead | cbo_market.SelectedIndexChanged | FP00595_LineAddPopup.cs:379 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | VALUE_SET | cbo_market.SelectedValue | Filter["MARKET"] | 컨트롤 값 설정 |  |  |  |
| AC-777cab1e | cbo_market.SelectedIndexChanged | FP00595_LineAddPopup.cs:382 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4c1a2c6 | cbo_market.SelectedIndexChanged | FP00595_LineAddPopup.cs:385 |  | DATA_OP | Filter["MARKET"] | CString.GetCheckedListValue(dtMarket, cbo_market.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00595_LineAddPopup.cbo_prodtype_changed

진입점: cbo_prodtype.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0446674 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:393 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | POPUP | new FP00595_pdsItemLinePop | () | 팝업/폼 생성 |  |  |  |
| AC-2cdb9d77 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:394 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-9157220e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:396 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8654694f | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:397 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["PLAN_DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1140e591 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:398 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["PRODUCTION_TYPE"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-ab6d5a7f | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:400 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["USER_ID"] | Filter["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-db9f2942 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:401 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["PLAN_TYPE"] | Filter["PLAN_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f02fcdb | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:402 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ba501cb | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:403 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | popup.Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-c0a5522e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:404 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d2daeac1 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:406 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3b077968 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:411 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["COMPANY_ID"] | popup.rtnRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc4b52dd | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:412 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["DIVISION_ID"] | popup.rtnRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f67b203e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:413 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["SITE_ID"] | popup.rtnRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b3bd929e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:414 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["PLANT_ID"] | popup.rtnRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6a6bb65 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:415 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["FACTORY_ID"] | txtBuilding.Text = popup.rtnRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18ee09ef | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:415 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtBuilding.Text | popup.rtnRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-558f9d15 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:416 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["OPERATION_ID"] | txtOperation.Text = popup.rtnRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbcffece | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:416 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtOperation.Text | popup.rtnRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-736fdb26 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:417 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["LINE_ID"] | txtLine.Text = popup.rtnRow["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5888a37a | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:417 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtLine.Text | popup.rtnRow["LINE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-00885395 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:418 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["ELECTRODE_TYPE"] | txtElectrodType.Text = popup.rtnRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e67ecf73 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:418 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtElectrodType.Text | popup.rtnRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2ce02919 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:419 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["LOCATION"] | popup.rtnRow["LOCATION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1d5fef78 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:421 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["ITEM_ID"] | txtItem.Text = popup.rtnRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f6fe93a | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:421 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtItem.Text | popup.rtnRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5b0de8dc | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:422 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text = popup.rtnRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-af666336 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:422 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtNickName.Text | popup.rtnRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-dc3d70ca | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:423 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["ITEM_TYPE"] | txtItemType.Text = popup.rtnRow["ITEM_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb16d539 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:423 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtItemType.Text | popup.rtnRow["ITEM_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ec629eaa | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:424 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["PLM_EC_NO"] | txtPdsID.Text = popup.rtnRow["PLM_EC_NO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e0a1c507 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:424 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtPdsID.Text | popup.rtnRow["PLM_EC_NO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-15c10d70 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:425 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["VERSION"] | txtVersion.Text = popup.rtnRow["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0de99c36 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:425 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtVersion.Text | popup.rtnRow["VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5680af2c | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:426 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["EQUIPMENT_ID"] | txtEquipment.Text = popup.rtnRow["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5494f3a7 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:426 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtEquipment.Text | popup.rtnRow["EQUIPMENT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b8274577 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:428 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["WORK_REQUEST_MODEL_ID"] | txtWorkSheetModel.Text = popup.rtnRow["MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b470fac | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:428 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtWorkSheetModel.Text | popup.rtnRow["MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8bafdfe6 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:429 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["VERSION"] | txtVersion.Text = popup.rtnRow["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-745e3b7f | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:429 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtVersion.Text | popup.rtnRow["VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-fc7bc924 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:430 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["PROD_SEQ"] | txtDegree.Text = popup.rtnRow["PROD_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40afcfb6 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:430 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtDegree.Text | popup.rtnRow["PROD_SEQ"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-02f52460 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:431 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["PLM_EC_NO"] | txtPdsID.Text = popup.rtnRow["PLM_EC_NO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4813651f | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:431 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | txtPdsID.Text | popup.rtnRow["PLM_EC_NO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a94b9e5e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:432 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["PROD_VERSION_TYPE"] | popup.rtnRow["PROD_VERSION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b53ca9e | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:435 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | DATA_OP | Filter["MARKET"] | cbo_market.Text = popup.rtnRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ce961c0a | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:435 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ if… | VALUE_SET | cbo_market.Text | popup.rtnRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a2faa261 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:443 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ else of (popup.ShowDialog() == DialogResult.OK) | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-7a4100d1 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:450 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | Filter["PLM_EC_NO"] | txtPdsID.Text = "-" | 행/컬럼 값 대입 |  |  |  |
| AC-90d29ea3 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:450 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | VALUE_SET | txtPdsID.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-fe439ce4 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:451 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | Filter["VERSION"] | txtVersion.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-7879db4d | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:451 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | VALUE_CLEAR | txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-572a9241 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:452 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | Filter["WORK_REQUEST_MODEL_ID"] | txtWorkSheetModel.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-42177a60 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:452 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | VALUE_CLEAR | txtWorkSheetModel.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-86d44e6d | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:453 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | Filter["PROD_SEQ"] | txtDegree.Text = "" | 행/컬럼 값 대입 |  |  |  |
| AC-2b578116 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:453 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | VALUE_CLEAR | txtDegree.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b5c67a1a | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:455 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", "-") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f44e49d1 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:456 | else of (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | DATA_OP | dtSave.SetFirst | ("VERSION", "") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bb72198 | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:459 |  | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-c6ff01fd | cbo_prodtype.SelectedIndexChanged | FP00595_LineAddPopup.cs:460 |  | DATA_OP | Filter["PRODUCTION_TYPE"] | CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00595_LineAddPopup.CbWPP_CheckedChanged

진입점: cbWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d11715 | cbWPP.CheckedChanged | FP00595_LineAddPopup.cs:355 | if (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b186affa | cbWPP.CheckedChanged | FP00595_LineAddPopup.cs:356 | if (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-e4c7130a | cbWPP.CheckedChanged | FP00595_LineAddPopup.cs:360 | else of (cbWPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-4f805309 | cbWPP.CheckedChanged | FP00595_LineAddPopup.cs:361 | else of (cbWPP.Checked == true) | VALUE_SET | cbMPP.Checked | true | 컨트롤 값 설정 |  |  |  |

## FP00595_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6247edc | this.btnSave.Click | FP00595_LineAddPopup.cs:524 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | MESSAGE | MessageBox.Show | ("You need to select line data") | 메시지 표시 |  |  |  |
| AC-16001e3c | this.btnSave.Click | FP00595_LineAddPopup.cs:525 | if (string.IsNullOrWhiteSpace(txtLine.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8455f947 | this.btnSave.Click | FP00595_LineAddPopup.cs:529 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-6a784131 | this.btnSave.Click | FP00595_LineAddPopup.cs:530 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c56b85b9 | this.btnSave.Click | FP00595_LineAddPopup.cs:537 | try ▸ if (value >=50) | MESSAGE | MessageBox.Show | ("QTY over 50") | 메시지 표시 |  |  |  |
| AC-6f58f5ca | this.btnSave.Click | FP00595_LineAddPopup.cs:538 | try ▸ if (value >=50) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-275553c9 | this.btnSave.Click | FP00595_LineAddPopup.cs:543 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-19be106e | this.btnSave.Click | FP00595_LineAddPopup.cs:544 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-888f7414 | this.btnSave.Click | FP00595_LineAddPopup.cs:564 | if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9f2a4b1 | this.btnSave.Click | FP00595_LineAddPopup.cs:565 | if (!string.IsNullOrEmpty(sMsg)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ce4b00bb | this.btnSave.Click | FP00595_LineAddPopup.cs:568 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf498db0 | Dispose | FP00595_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_LineAddPopup.FindYieldInfo

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caac3ad7 | this.btnSave.Click | FP00595_LineAddPopup.cs:1402 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dbcd7e40 | this.btnSave.Click | FP00595_LineAddPopup.cs:1404 |  | DATA_OP | Filter2["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6dae4045 | this.btnSave.Click | FP00595_LineAddPopup.cs:1405 |  | DATA_OP | Filter2["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-042e992f | this.btnSave.Click | FP00595_LineAddPopup.cs:1406 |  | DATA_OP | Filter2["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-119c9f3b | this.btnSave.Click | FP00595_LineAddPopup.cs:1407 |  | DATA_OP | Filter2["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-185b2e48 | this.btnSave.Click | FP00595_LineAddPopup.cs:1408 |  | DATA_OP | Filter2["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aff67d76 | this.btnSave.Click | FP00595_LineAddPopup.cs:1409 |  | DATA_OP | Filter2["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a01d1ca | this.btnSave.Click | FP00595_LineAddPopup.cs:1410 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4237a175 | this.btnSave.Click | FP00595_LineAddPopup.cs:1411 |  | DATA_OP | Filter2["PLAN_DATE"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1b637f47 | this.btnSave.Click | FP00595_LineAddPopup.cs:1412 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_yieldInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4f2476a2 | this.btnSave.Click | FP00595_LineAddPopup.cs:1418 | if (ret.Good()) ▸ if (cell_rate > 0) | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |
| AC-c4171b56 | this.btnSave.Click | FP00595_LineAddPopup.cs:1420 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d07708a6 | this.Load | FP00595_LineAddPopup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb344d55 | this.Load | FP00595_LineAddPopup.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7ca9649d | this.Load | FP00595_LineAddPopup.cs:122 |  | FLAG | dtSave | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a9fe067 | this.Load | FP00595_LineAddPopup.cs:123 |  | UI_PROP | dtSave.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-d935c187 | this.Load | FP00595_LineAddPopup.cs:124 |  | DATA_OP | dtSave.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae6ce32 | this.Load | FP00595_LineAddPopup.cs:125 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d68a184 | this.Load | FP00595_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80913e61 | this.Load | FP00595_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9672faeb | this.Load | FP00595_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86aa2ecf | this.Load | FP00595_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0433e346 | this.Load | FP00595_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d24c9933 | this.Load | FP00595_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.SafeAdd | ("DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd700a50 | this.Load | FP00595_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88f0faba | this.Load | FP00595_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d7cb66f | this.Load | FP00595_LineAddPopup.cs:136 |  | DATA_OP | dtSave.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eee91ca1 | this.Load | FP00595_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c93a92ad | this.Load | FP00595_LineAddPopup.cs:138 |  | DATA_OP | dtSave.Columns.SafeAdd | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae6c24bd | this.Load | FP00595_LineAddPopup.cs:139 |  | DATA_OP | dtSave.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2e1840a | this.Load | FP00595_LineAddPopup.cs:140 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb91e7f | this.Load | FP00595_LineAddPopup.cs:141 |  | DATA_OP | dtSave.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6873ef68 | this.Load | FP00595_LineAddPopup.cs:142 |  | DATA_OP | dtSave.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2cde849 | this.Load | FP00595_LineAddPopup.cs:143 |  | DATA_OP | dtSave.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-94d48db7 | this.Load | FP00595_LineAddPopup.cs:144 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2f559bf | this.Load | FP00595_LineAddPopup.cs:145 |  | DATA_OP | dtSave.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf3b8347 | this.Load | FP00595_LineAddPopup.cs:146 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbd0d52 | this.Load | FP00595_LineAddPopup.cs:147 |  | DATA_OP | dtSave.Columns.SafeAdd | ("QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-24fc676d | this.Load | FP00595_LineAddPopup.cs:149 |  | DATA_OP | dtSave.Columns.SafeAdd | ("WORK_REQUEST_MODEL_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58dae867 | this.Load | FP00595_LineAddPopup.cs:150 |  | DATA_OP | dtSave.Columns.SafeAdd | ("VERSION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4100ce00 | this.Load | FP00595_LineAddPopup.cs:151 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PROD_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-835cca84 | this.Load | FP00595_LineAddPopup.cs:152 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PLM_EC_NO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9251f2b | this.Load | FP00595_LineAddPopup.cs:155 |  | DATA_OP | dtSave.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd627335 | this.Load | FP00595_LineAddPopup.cs:156 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1586ded | this.Load | FP00595_LineAddPopup.cs:157 |  | DATA_OP | dtSave.Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-389e10b1 | this.Load | FP00595_LineAddPopup.cs:158 |  | DATA_OP | dtSave.Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7cce772 | this.Load | FP00595_LineAddPopup.cs:160 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-47933c94 | this.Load | FP00595_LineAddPopup.cs:160 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP00595_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e0c409f | this.Load | FP00595_LineAddPopup.cs:176 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8465241f | this.Load | FP00595_LineAddPopup.cs:180 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-eb22e2b7 | this.Load | FP00595_LineAddPopup.cs:181 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-a20095ea | this.Load | FP00595_LineAddPopup.cs:182 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e38fc0b | this.Load | FP00595_LineAddPopup.cs:186 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["FP_PLAN_DATE"] | Filter["PLAN_DATE"] = DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-ef3967b6 | this.Load | FP00595_LineAddPopup.cs:186 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-20fe56a2 | this.Load | FP00595_LineAddPopup.cs:188 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-5d05fc05 | this.Load | FP00595_LineAddPopup.cs:190 |  | VALUE_SET | txtNickName.Text | Filter["NICK_NAME"] = InitRow["NICK_NAME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-997b2375 | this.Load | FP00595_LineAddPopup.cs:190 |  | DATA_OP | Filter["NICK_NAME"] | InitRow["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0a19be01 | this.Load | FP00595_LineAddPopup.cs:191 |  | VALUE_SET | txtOperation.Text | Filter["OPERATON_ID"] = InitRow["OPERATION_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ba846ecf | this.Load | FP00595_LineAddPopup.cs:191 |  | DATA_OP | Filter["OPERATON_ID"] | InitRow["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3ab8d912 | this.Load | FP00595_LineAddPopup.cs:192 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-a1ff66e4 | this.Load | FP00595_LineAddPopup.cs:198 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-5c0a160c | this.Load | FP00595_LineAddPopup.cs:198 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_PRODTYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_PRODTYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2735aaf3 | this.Load | FP00595_LineAddPopup.cs:202 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cbo_prodtype, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-a86d56eb | this.Load | FP00595_LineAddPopup.cs:204 |  | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"]= InitRow["PRODUCTION_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-36044c1a | this.Load | FP00595_LineAddPopup.cs:204 |  | DATA_OP | Filter["PRODTYPE_ID"] | InitRow["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c11fe2b1 | this.Load | FP00595_LineAddPopup.cs:208 |  | VALUE_SET | txtItem.Text | Filter["ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8d3fa9d2 | this.Load | FP00595_LineAddPopup.cs:208 |  | DATA_OP | Filter["ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5916f43d | this.Load | FP00595_LineAddPopup.cs:209 |  | VALUE_SET | txtBuilding.Text | Filter["FACTORY_ID"] = InitRow["FACTORY_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a26b749b | this.Load | FP00595_LineAddPopup.cs:209 |  | DATA_OP | Filter["FACTORY_ID"] | InitRow["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d726265 | this.Load | FP00595_LineAddPopup.cs:210 |  | VALUE_SET | txtElectrodType.Text | Filter["ELECTRODE_TYPE"] = InitRow["ELECTRODE_TYPE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-a8a888bd | this.Load | FP00595_LineAddPopup.cs:210 |  | DATA_OP | Filter["ELECTRODE_TYPE"] | InitRow["ELECTRODE_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5311fe0 | this.Load | FP00595_LineAddPopup.cs:213 |  | VALUE_SET | txtWorkSheetModel.Text | Filter["WORK_REQUEST_MODEL_ID"] = InitRow["PC_MODEL_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-1e8de45c | this.Load | FP00595_LineAddPopup.cs:213 |  | DATA_OP | Filter["WORK_REQUEST_MODEL_ID"] | InitRow["PC_MODEL_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-128414cf | this.Load | FP00595_LineAddPopup.cs:214 |  | VALUE_SET | txtVersion.Text | Filter["VERSION"] = InitRow["VERSION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-383b4ec6 | this.Load | FP00595_LineAddPopup.cs:214 |  | DATA_OP | Filter["VERSION"] | InitRow["VERSION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d566b141 | this.Load | FP00595_LineAddPopup.cs:215 |  | VALUE_SET | txtDegree.Text | Filter["PROD_SEQ"] = InitRow["PROD_SEQ"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-829c0276 | this.Load | FP00595_LineAddPopup.cs:215 |  | DATA_OP | Filter["PROD_SEQ"] | InitRow["PROD_SEQ"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3da44cb0 | this.Load | FP00595_LineAddPopup.cs:217 |  | VALUE_SET | txtPdsID.Text | Filter["PLM_EC_NO"] = InitRow["PLM_EC_NO"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-6ff52b2a | this.Load | FP00595_LineAddPopup.cs:217 |  | DATA_OP | Filter["PLM_EC_NO"] | InitRow["PLM_EC_NO"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e1053fd | this.Load | FP00595_LineAddPopup.cs:222 | if (Filter["PLAN_TYPE"] == "RELEASE") | VALUE_SET | labelTitle.Text | " Add Line - MPP WPP" | 컨트롤 값 설정 |  |  |  |
| AC-dda16bca | this.Load | FP00595_LineAddPopup.cs:223 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b61172b6 | this.Load | FP00595_LineAddPopup.cs:224 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f0db4d12 | this.Load | FP00595_LineAddPopup.cs:225 | if (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9785d9be | this.Load | FP00595_LineAddPopup.cs:229 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbWPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-2f7448b7 | this.Load | FP00595_LineAddPopup.cs:230 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbMPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-4e9602de | this.Load | FP00595_LineAddPopup.cs:234 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbWPP.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-81aef5ec | this.Load | FP00595_LineAddPopup.cs:235 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (Filter["MPP_WPP"] == "MPP") | VALUE_SET | cbMPP.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-aef61486 | this.Load | FP00595_LineAddPopup.cs:243 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | layoutControlItem36.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2d32dfc1 | this.Load | FP00595_LineAddPopup.cs:244 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcMPP.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-df6aaf0a | this.Load | FP00595_LineAddPopup.cs:245 | else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | lcWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-753cdcd7 | this.Load | FP00595_LineAddPopup.cs:248 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c1bb2498 | this.Load | FP00595_LineAddPopup.cs:249 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-77ec267d | this.Load | FP00595_LineAddPopup.cs:250 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c39cad99 | this.Load | FP00595_LineAddPopup.cs:252 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2a3b3394 | this.Load | FP00595_LineAddPopup.cs:253 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f28940fc | this.Load | FP00595_LineAddPopup.cs:254 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0603b6a9 | this.Load | FP00595_LineAddPopup.cs:255 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-219962f6 | this.Load | FP00595_LineAddPopup.cs:256 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f8b8ec09 | this.Load | FP00595_LineAddPopup.cs:257 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0ab7191f | this.Load | FP00595_LineAddPopup.cs:258 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3c2c85d2 | this.Load | FP00595_LineAddPopup.cs:259 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", Filter["PRODUCTION_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4ad42d14 | this.Load | FP00595_LineAddPopup.cs:260 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ed63b25b | this.Load | FP00595_LineAddPopup.cs:261 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", Filter["OPERATION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bd973a40 | this.Load | FP00595_LineAddPopup.cs:262 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", Filter["LINE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fdf04788 | this.Load | FP00595_LineAddPopup.cs:263 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", Filter["ELECTRODE_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dadd864a | this.Load | FP00595_LineAddPopup.cs:264 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", Filter["EQUIPMENT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b0587032 | this.Load | FP00595_LineAddPopup.cs:269 |  | FLAG | dtMarket | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00594_LineAddPopup", "MARKET_TYPE… | 화면 필드/플래그 변경 |  |  |  |
| AC-77be8b5b | this.Load | FP00595_LineAddPopup.cs:269 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00594_LineAddPopup", "MARKET_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c66d34d1 | this.Load | FP00595_LineAddPopup.cs:278 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cbo_market, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8047ada9 | this.Load | FP00595_LineAddPopup.cs:279 |  | VALUE_SET | cbo_market.SelectedValue | Filter["MARKET"] = InitRow["MARKET"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2bb70154 | this.Load | FP00595_LineAddPopup.cs:279 |  | DATA_OP | Filter["MARKET"] | InitRow["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99ed3518 | this.Load | FP00595_LineAddPopup.cs:285 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-96ccccad | this.Load | FP00595_LineAddPopup.cs:286 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd1c082b | this.Load | FP00595_LineAddPopup.cs:287 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-293147db | this.Load | FP00595_LineAddPopup.cs:291 |  | FLAG | dtPdsType | DataService.FP_ExecuteQuery2("FP00595_addline", "find_pdsType", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsType] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-113a568e | this.Load | FP00595_LineAddPopup.cs:291 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_addline", "find_pdsType", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsType] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4e3be13e | this.Load | FP00595_LineAddPopup.cs:296 | if (_isPDSType(cbo_prodtype.ControlValues.ToString())) | VALUE_SET | cbo_prodtype.SelectedValue | Filter["PRODTYPE_ID"] = Filter["PRODUCTION_TYPE"] = "MASS" | 컨트롤 값 설정 |  |  |  |
| AC-12be8b6f | this.Load | FP00595_LineAddPopup.cs:296 | if (_isPDSType(cbo_prodtype.ControlValues.ToString())) | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = "MASS" | 행/컬럼 값 대입 |  |  |  |
| AC-4cca6a80 | this.Load | FP00595_LineAddPopup.cs:296 | if (_isPDSType(cbo_prodtype.ControlValues.ToString())) | DATA_OP | Filter["PRODUCTION_TYPE"] | "MASS" | 행/컬럼 값 대입 |  |  |  |
| AC-0b4d4b67 | this.Load | FP00595_LineAddPopup.cs:297 | if (_isPDSType(cbo_prodtype.ControlValues.ToString())) | VALUE_CLEAR | txtVersion.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c9a5f452 | this.Load | FP00595_LineAddPopup.cs:298 | if (_isPDSType(cbo_prodtype.ControlValues.ToString())) | VALUE_CLEAR | txtPdsID.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00595_LineAddPopup.lfn_getYieldInfo

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c7f35a1 | this.btnSave.Click | FP00595_LineAddPopup.cs:1392 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-29b04951 | this.btnSave.Click | FP00595_LineAddPopup.cs:1393 |  | DATA_OP | yf["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1230fff7 | this.btnSave.Click | FP00595_LineAddPopup.cs:1394 |  | DATA_OP | yf["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f5fc7538 | this.btnSave.Click | FP00595_LineAddPopup.cs:1396 |  | FLAG | YieldRate | FindYieldInfo(yf, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-d9e62b86 | this.btnSave.Click | FP00595_LineAddPopup.cs:1396 |  | RETURN | return YieldRate = FindYieldInfo(yf, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.lfn_setExchangeBatch

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-049a9ba3 | this.btnSave.Click | FP00595_LineAddPopup.cs:1445 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-dc26195e | this.btnSave.Click | FP00595_LineAddPopup.cs:1451 |  | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0a859fd | this.btnSave.Click | FP00595_LineAddPopup.cs:1492 |  | CALL_EXT | dsYieldChild.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39571526 | this.btnSave.Click | FP00595_LineAddPopup.cs:1497 | else of (nExcRow == -1) | DATA_OP | dsYieldChild.Tables[0].getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f8fb71dd | this.btnSave.Click | FP00595_LineAddPopup.cs:1504 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.lfn_setExchangeBatch_Detail

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51d33ffb | this.btnSave.Click | FP00595_LineAddPopup.cs:1523 |  | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee7b07d1 | this.btnSave.Click | FP00595_LineAddPopup.cs:1620 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77e931cc | popSql.OnSql | FP00595_LineAddPopup.cs:1269 | if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add( "SQL","INSERT_ADD_MPPWPP"); |  | 처리 중단/반환 |  |  |  |
| AC-176da230 | popSql.OnSql | FP00595_LineAddPopup.cs:1274 | if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return Save_Data_Add("SQL", "INSERT_ADD_LINE"); |  | 처리 중단/반환 |  |  |  |
| AC-973909c9 | popSql.OnSql | FP00595_LineAddPopup.cs:1281 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fe0c804 | this.btnSave.Click | FP00595_LineAddPopup.cs:582 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_addline", "find_addPdsValidation", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_addPdsValidation] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8d6e225c | this.btnSave.Click | FP00595_LineAddPopup.cs:589 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (dtValid.Rows.Count == 0) | MESSAGE | MessageBox.Show | (rtnMsg) | 메시지 표시 |  |  |  |
| AC-d3fe1efe | this.btnSave.Click | FP00595_LineAddPopup.cs:590 | if (_isPDSType(CString.GetCheckedListValue(dtProdType, cbo_prodtype.ControlValues, true))) ▸ if (dtValid.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f75cd329 | this.btnSave.Click | FP00595_LineAddPopup.cs:596 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f98c9d96 | this.btnSave.Click | FP00595_LineAddPopup.cs:597 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["LOCATION"] | Filter["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-f777ebba | this.btnSave.Click | FP00595_LineAddPopup.cs:598 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f365d88 | this.btnSave.Click | FP00595_LineAddPopup.cs:603 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!string.IsNullOrWhiteSpace(dpPlanDate.Text)) | DATA_OP | Filter["DATE"] | newVal | 행/컬럼 값 대입 |  |  |  |
| AC-a42abd06 | this.btnSave.Click | FP00595_LineAddPopup.cs:606 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_addline", "find_dup_MPPWPP", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dup_MPPWPP] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c31eb567 | this.btnSave.Click | FP00595_LineAddPopup.cs:608 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_mppwpp", "find_targetInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_targetInfo] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f32f0bd3 | this.btnSave.Click | FP00595_LineAddPopup.cs:612 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07e23767 | this.btnSave.Click | FP00595_LineAddPopup.cs:613 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["LOCATION"] | Filter["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-2bc7cd04 | this.btnSave.Click | FP00595_LineAddPopup.cs:614 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-91f4f683 | this.btnSave.Click | FP00595_LineAddPopup.cs:619 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!string.IsNullOrWhiteSpace(dpPlanDate.Text)) | DATA_OP | Filter["DATE"] | newVal | 행/컬럼 값 대입 |  |  |  |
| AC-1f770d48 | this.btnSave.Click | FP00595_LineAddPopup.cs:622 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_addline", "find_dup", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dup] \| FP\Planning\FP0059… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ae7d37b4 | this.btnSave.Click | FP00595_LineAddPopup.cs:623 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_addline", "find_targetInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_targetInfo] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3958af94 | this.btnSave.Click | FP00595_LineAddPopup.cs:629 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Line or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-a6910b47 | this.btnSave.Click | FP00595_LineAddPopup.cs:630 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64b0078c | this.btnSave.Click | FP00595_LineAddPopup.cs:647 | if ((target_info.Good() && (target_info.Rows[0]["MSG3"].ToString() != string.Empty \|\| target_info.Rows[0]["MSG4"].ToString()…) | MESSAGE | MessageBox.Show | ("No Model Measure Conversion data found.\r\n" + "Check the data below in the 'Model meaus… | 메시지 표시 |  |  |  |
| AC-ba340578 | this.btnSave.Click | FP00595_LineAddPopup.cs:651 | if ((target_info.Good() && (target_info.Rows[0]["MSG3"].ToString() != string.Empty \|\| target_info.Rows[0]["MSG4"].ToString()…) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebb699be | this.btnSave.Click | FP00595_LineAddPopup.cs:660 | if (Filter["PLAN_TYPE"] == "RELEASE") | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_isCurrWeek", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter["SITE… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8d01e0ef | this.btnSave.Click | FP00595_LineAddPopup.cs:667 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString().Equals("Y")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b62ff31f | this.btnSave.Click | FP00595_LineAddPopup.cs:669 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!dtIsCurrWeek.Rows[0]["IS_LATEST_PLAN"].ToString().Equals("Y")) | RETURN | return ; |  | 처리 중단/반환 |  |  |  |
| AC-fe38ae74 | this.btnSave.Click | FP00595_LineAddPopup.cs:673 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "find_Amend_Save_Check", Filter["INSTANCE_ID"], Filter["PLAN_ID"], Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9fb08bcb | this.btnSave.Click | FP00595_LineAddPopup.cs:685 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + strMsg) | 메시지 표시 |  |  |  |
| AC-a60d6d18 | this.btnSave.Click | FP00595_LineAddPopup.cs:686 | if (dtCheckSave != null) ▸ if (dtCheckSave.Rows.Count > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa9a867f | this.btnSave.Click | FP00595_LineAddPopup.cs:690 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d36274db | this.btnSave.Click | FP00595_LineAddPopup.cs:691 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c0f2da46 | this.btnSave.Click | FP00595_LineAddPopup.cs:693 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8aa201d1 | this.btnSave.Click | FP00595_LineAddPopup.cs:694 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7c5174dd | this.btnSave.Click | FP00595_LineAddPopup.cs:695 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-938da4a4 | this.btnSave.Click | FP00595_LineAddPopup.cs:696 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b0ee99ef | this.btnSave.Click | FP00595_LineAddPopup.cs:697 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d32ba0e5 | this.btnSave.Click | FP00595_LineAddPopup.cs:698 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1a1ace91 | this.btnSave.Click | FP00595_LineAddPopup.cs:699 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1b9dcc66 | this.btnSave.Click | FP00595_LineAddPopup.cs:700 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3f9223be | this.btnSave.Click | FP00595_LineAddPopup.cs:701 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d39b1264 | this.btnSave.Click | FP00595_LineAddPopup.cs:702 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b1bc0147 | this.btnSave.Click | FP00595_LineAddPopup.cs:703 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e1f5c0fb | this.btnSave.Click | FP00595_LineAddPopup.cs:704 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a5d3afb3 | this.btnSave.Click | FP00595_LineAddPopup.cs:705 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", txtEquipment.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d28189f2 | this.btnSave.Click | FP00595_LineAddPopup.cs:707 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", cbo_prodtype.SelectedValue.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-03df7aad | this.btnSave.Click | FP00595_LineAddPopup.cs:708 |  | DATA_OP | dtSave.SetFirst | ("MARKET", cbo_market.SelectedValue.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3dac9095 | this.btnSave.Click | FP00595_LineAddPopup.cs:709 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-42b47466 | this.btnSave.Click | FP00595_LineAddPopup.cs:710 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d994a1a3 | this.btnSave.Click | FP00595_LineAddPopup.cs:711 |  | DATA_OP | dtSave.SetFirst | ("LOCATION", Filter["LOCATION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-00c3c563 | this.btnSave.Click | FP00595_LineAddPopup.cs:712 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", Filter["PLAN_DATE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-eebc06a1 | this.btnSave.Click | FP00595_LineAddPopup.cs:713 |  | DATA_OP | dtSave.SetFirst | ("FP_PLAN_ID", Filter["FP_PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8fa6eb1b | this.btnSave.Click | FP00595_LineAddPopup.cs:715 |  | DATA_OP | dtSave.SetFirst | ("WORK_REQUEST_MODEL_ID", Filter["WORK_REQUEST_MODEL_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c12aea5e | this.btnSave.Click | FP00595_LineAddPopup.cs:716 |  | DATA_OP | dtSave.SetFirst | ("VERSION", Filter["VERSION"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d00ada1 | this.btnSave.Click | FP00595_LineAddPopup.cs:717 |  | DATA_OP | dtSave.SetFirst | ("PROD_SEQ", Filter["PROD_SEQ"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bed5cf7d | this.btnSave.Click | FP00595_LineAddPopup.cs:718 |  | DATA_OP | dtSave.SetFirst | ("PLM_EC_NO", Filter["PLM_EC_NO"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bf261a81 | this.btnSave.Click | FP00595_LineAddPopup.cs:751 |  | DATA_OP | dtSave.Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83a16846 | this.btnSave.Click | FP00595_LineAddPopup.cs:753 |  | DATA_OP | dtSave.Columns.SafeAdd | (sOut_BATCH, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da38587e | this.btnSave.Click | FP00595_LineAddPopup.cs:754 |  | DATA_OP | dtSave.Columns.SafeAdd | (sOut_M, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-580d7301 | this.btnSave.Click | FP00595_LineAddPopup.cs:755 |  | DATA_OP | dtSave.Columns.SafeAdd | (sOut_CELL, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec64b639 | this.btnSave.Click | FP00595_LineAddPopup.cs:756 |  | DATA_OP | dtSave.Columns.SafeAdd | (sOut_JR, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37c3ef60 | this.btnSave.Click | FP00595_LineAddPopup.cs:757 |  | DATA_OP | dtSave.Columns.SafeAdd | (sIn_BATCH, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc0d9eca | this.btnSave.Click | FP00595_LineAddPopup.cs:758 |  | DATA_OP | dtSave.Columns.SafeAdd | (sIn_M, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-29e8db24 | this.btnSave.Click | FP00595_LineAddPopup.cs:759 |  | DATA_OP | dtSave.Columns.SafeAdd | (sIn_CELL, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c3c6eb2 | this.btnSave.Click | FP00595_LineAddPopup.cs:760 |  | DATA_OP | dtSave.Columns.SafeAdd | (sIn_JR, typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a772d074 | this.btnSave.Click | FP00595_LineAddPopup.cs:762 |  | DATA_OP | ds_ListDataR["PROD_VERSION_TYPE"] | Filter["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5fc47327 | this.btnSave.Click | FP00595_LineAddPopup.cs:763 |  | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-205191af | this.btnSave.Click | FP00595_LineAddPopup.cs:793 | if (nIn_M == 0 \|\| nIn_CELL == 0 \|\| nIn_JR == 0) | MESSAGE | MessageBox.Show | ("Check the model measure conversion info.\r\n : converted QTY = 0") | 메시지 표시 |  |  |  |
| AC-506422a5 | this.btnSave.Click | FP00595_LineAddPopup.cs:794 | if (nIn_M == 0 \|\| nIn_CELL == 0 \|\| nIn_JR == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9bbaaa5a | this.btnSave.Click | FP00595_LineAddPopup.cs:798 |  | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-6eafbbdc | this.btnSave.Click | FP00595_LineAddPopup.cs:799 |  | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-6d6de844 | this.btnSave.Click | FP00595_LineAddPopup.cs:800 |  | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-a975404d | this.btnSave.Click | FP00595_LineAddPopup.cs:802 |  | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-cfca13e6 | this.btnSave.Click | FP00595_LineAddPopup.cs:803 |  | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-4d69c33f | this.btnSave.Click | FP00595_LineAddPopup.cs:814 |  | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-c1cecbc4 | this.btnSave.Click | FP00595_LineAddPopup.cs:820 |  | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-21d61cb0 | this.btnSave.Click | FP00595_LineAddPopup.cs:826 |  | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-bdd4fc7d | this.btnSave.Click | FP00595_LineAddPopup.cs:828 |  | DATA_OP | dtSave.Columns.SafeAdd | ("IN_QTY_BATCH" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-457c2740 | this.btnSave.Click | FP00595_LineAddPopup.cs:829 |  | DATA_OP | dtSave.Columns.SafeAdd | ("IN_QTY_M" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-77edf9a8 | this.btnSave.Click | FP00595_LineAddPopup.cs:830 |  | DATA_OP | dtSave.Columns.SafeAdd | ("IN_QTY_CELL" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a0759a9 | this.btnSave.Click | FP00595_LineAddPopup.cs:831 |  | DATA_OP | dtSave.Columns.SafeAdd | ("IN_QTY_JR" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fb8e1f1 | this.btnSave.Click | FP00595_LineAddPopup.cs:832 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OUT_QTY_BATCH" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c795cb | this.btnSave.Click | FP00595_LineAddPopup.cs:833 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OUT_QTY_M" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-03cc1dd0 | this.btnSave.Click | FP00595_LineAddPopup.cs:834 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OUT_QTY_CELL" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-476f0823 | this.btnSave.Click | FP00595_LineAddPopup.cs:835 |  | DATA_OP | dtSave.Columns.SafeAdd | ("OUT_QTY_JR" , typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a3a6e7 | this.btnSave.Click | FP00595_LineAddPopup.cs:837 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY_BATCH" , "WPP_IN_QTY_BATCH") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-419b8a4e | this.btnSave.Click | FP00595_LineAddPopup.cs:838 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY_M" , "WPP_IN_QTY_M") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1fe18160 | this.btnSave.Click | FP00595_LineAddPopup.cs:839 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY_CELL" , "WPP_IN_QTY_CELL") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-00fd5486 | this.btnSave.Click | FP00595_LineAddPopup.cs:840 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY_JR" , "WPP_IN_QTY_JR") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d369a4d2 | this.btnSave.Click | FP00595_LineAddPopup.cs:841 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY_BATCH" , "WPP_OUT_QTY_BATCH") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2e9df3d7 | this.btnSave.Click | FP00595_LineAddPopup.cs:842 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY_M" , "WPP_OUT_QTY_M") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b050fe87 | this.btnSave.Click | FP00595_LineAddPopup.cs:843 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY_CELL" , "WPP_OUT_QTY_CELL") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-69697a98 | this.btnSave.Click | FP00595_LineAddPopup.cs:844 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY_JR" , "WPP_OUT_QTY_JR") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b5065098 | this.btnSave.Click | FP00595_LineAddPopup.cs:848 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY_BATCH" , "MPP_IN_QTY_BATCH") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0e036631 | this.btnSave.Click | FP00595_LineAddPopup.cs:849 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY_M" , "MPP_IN_QTY_M") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e4310034 | this.btnSave.Click | FP00595_LineAddPopup.cs:850 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY_CELL" , "MPP_IN_QTY_CELL") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b770c855 | this.btnSave.Click | FP00595_LineAddPopup.cs:851 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY_JR" , "MPP_IN_QTY_JR") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-95522cc2 | this.btnSave.Click | FP00595_LineAddPopup.cs:852 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY_BATCH" , "MPP_OUT_QTY_BATCH") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d626e528 | this.btnSave.Click | FP00595_LineAddPopup.cs:853 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY_M" , "MPP_OUT_QTY_M") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aa1b9c25 | this.btnSave.Click | FP00595_LineAddPopup.cs:854 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY_CELL" , "MPP_OUT_QTY_CELL") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9a531499 | this.btnSave.Click | FP00595_LineAddPopup.cs:855 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY_JR" , "MPP_OUT_QTY_JR") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-52e3451c | this.btnSave.Click | FP00595_LineAddPopup.cs:865 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-cb06c067 | this.btnSave.Click | FP00595_LineAddPopup.cs:866 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddd84e8b | this.btnSave.Click | FP00595_LineAddPopup.cs:868 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e5ce0347 | this.btnSave.Click | FP00595_LineAddPopup.cs:894 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_addline", "insert_Line_MPPWPP", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Line_MPPWPP] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-c6497877 | this.btnSave.Click | FP00595_LineAddPopup.cs:897 | if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.ReadResult | (resInsert) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8ba17d6 | this.btnSave.Click | FP00595_LineAddPopup.cs:902 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r1.Success) | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a49a8fa8 | this.btnSave.Click | FP00595_LineAddPopup.cs:903 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r1.Success) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-329cc73d | this.btnSave.Click | FP00595_LineAddPopup.cs:915 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-def9b35d | this.btnSave.Click | FP00595_LineAddPopup.cs:920 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_addline", "insert_Line", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Line] \| FP\Planning\FP00… | 엔드포인트 호출 |  |  |  |
| AC-061e4fdc | this.btnSave.Click | FP00595_LineAddPopup.cs:921 | else of (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_addline", "insert_Log", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Log] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-f1d7d0c6 | this.btnSave.Click | FP00595_LineAddPopup.cs:923 | else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.ReadResult | (resInsert) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19ae7d66 | this.btnSave.Click | FP00595_LineAddPopup.cs:924 | else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.ReadResult | (resLog) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10f8708a | this.btnSave.Click | FP00595_LineAddPopup.cs:928 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r1.Success) | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-abdb5f65 | this.btnSave.Click | FP00595_LineAddPopup.cs:929 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r1.Success) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-914f975c | this.btnSave.Click | FP00595_LineAddPopup.cs:934 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r2.Success) | MESSAGE | MessageBox.Show | (errorMsg, "SAVE ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-b34e57cf | this.btnSave.Click | FP00595_LineAddPopup.cs:935 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (!r2.Success) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a04b1d2f | this.btnSave.Click | FP00595_LineAddPopup.cs:939 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ try | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4ea3b61 | this.btnSave.Click | FP00595_LineAddPopup.cs:940 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00595", "execute_psiCalcul", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-0d72a8cf | this.btnSave.Click | FP00595_LineAddPopup.cs:944 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-82f16879 | this.btnSave.Click | FP00595_LineAddPopup.cs:945 | else of (Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b5484a4 | this.btnSave.Click | FP00595_LineAddPopup.cs:947 | else of (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { r1.Count }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4673c6a | this.btnSave.Click | FP00595_LineAddPopup.cs:971 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-3486351e | this.btnSave.Click | FP00595_LineAddPopup.cs:972 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_LineAddPopup.Save_Data_Add

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f2640c8 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1017 | try | ENDPOINT | new FoxDataRequest | ("FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE") ⇒ FP_Planning.PR_UI_FP00622_LINE_ADD_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-47a94a47 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1018 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c21d2ce | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1020 | try | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-bf17bfd0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1021 | try | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-693c0258 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1022 | try | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-d0108235 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1023 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-954f0c35 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1025 | try | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-27d18fea | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1026 | try | DATA_OP | req.Parameters["p_plan_date"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-da9ab6aa | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1027 | try | DATA_OP | req.Parameters["p_plan_id"] | p_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-ebac79f4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1028 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-130200b0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1029 | try | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-8d8a8edc | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1030 | try | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4d30a107 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1031 | try | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-bab9de88 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1033 | try | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a51fc33 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1034 | try | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-dc575224 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1035 | try | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-957f8b64 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1036 | try | DATA_OP | req.Parameters["p_top_item_id"] | p_top_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-24969efd | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1037 | try | DATA_OP | req.Parameters["p_item_type"] | p_item_type | 행/컬럼 값 대입 |  |  |  |
| AC-1f326689 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1038 | try | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-1f2c53d9 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1041 | try | DATA_OP | req.Parameters["p_prod_type"] | p_prod_type | 행/컬럼 값 대입 |  |  |  |
| AC-c45164ba | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1042 | try | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-35a94947 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1043 | try | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-52f1079d | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1044 | try | DATA_OP | req.Parameters["p_confirm_area"] | p_confirm_area | 행/컬럼 값 대입 |  |  |  |
| AC-e583fb9f | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1045 | try | DATA_OP | req.Parameters["p_release_value"] | p_release_value | 행/컬럼 값 대입 |  |  |  |
| AC-2fdc3a5c | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1047 | try | DATA_OP | req.Parameters["p_in_qty"] | p_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ccaa203b | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1048 | try | DATA_OP | req.Parameters["p_out_qty"] | p_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-eeb349f2 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1049 | try | DATA_OP | req.Parameters["p_cell_in_qty"] | p_cell_in_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d2af5ed0 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1050 | try | DATA_OP | req.Parameters["p_cell_out_qty"] | p_cell_out_qty | 행/컬럼 값 대입 |  |  |  |
| AC-94c1b1d8 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1051 | try | DATA_OP | req.Parameters["p_qty"] | p_qty | 행/컬럼 값 대입 |  |  |  |
| AC-c9385b05 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1054 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b4ac4f8 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1055 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-30eb3bfa | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1062 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineAddPopup.SetSaveDataTable

진입점: popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE") ▸ if (Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d714c7e2 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1285 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db1f861a | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1286 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-63830872 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1288 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0621f996 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1289 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ae4b677c | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1290 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5c128483 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1291 |  | DATA_OP | dtSave.SetFirst | ("FACTORY_ID", Filter["FACTORY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b5f6294 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1292 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-016eb033 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1293 |  | DATA_OP | dtSave.SetFirst | ("ITEM_ID", Filter["ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d5747f11 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1294 |  | DATA_OP | dtSave.SetFirst | ("NICK_NAME", Filter["NICK_NAME"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3d7284f4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1295 |  | DATA_OP | dtSave.SetFirst | ("ITEM_TYPE", Filter["ITEM_TYPE"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2aa65b90 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1296 |  | DATA_OP | dtSave.SetFirst | ("TOP_ITEM_ID", Filter["TOP_ITEM_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f5b0723d | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1297 |  | DATA_OP | dtSave.SetFirst | ("ELECTRODE_TYPE", txtElectrodType.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4c08224e | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1298 |  | DATA_OP | dtSave.SetFirst | ("OPERATION_ID", txtOperation.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ba7a0e17 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1299 |  | DATA_OP | dtSave.SetFirst | ("LINE_ID", txtLine.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c2e97dd8 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1300 |  | DATA_OP | dtSave.SetFirst | ("EQUIPMENT_ID", txtEquipment.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e81909ba | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1302 |  | DATA_OP | dtSave.SetFirst | ("PRODUCTION_TYPE", cbo_prodtype.SelectedItem.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7706c092 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1303 |  | DATA_OP | dtSave.SetFirst | ("MARKET", cbo_market.SelectedItem.ToString()) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4c1aa65a | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1304 |  | DATA_OP | dtSave.SetFirst | ("PLAN_DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-54057c27 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1306 |  | DATA_OP | dtSave.SetFirst | ("IN_QTY", "WPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f9b9bde7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1307 |  | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "WPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b955b1ff | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1308 |  | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "WPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c5ebfbe9 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1309 |  | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "WPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-52e7ff35 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1313 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | Filter["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-715f2e0b | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1315 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("IN_QTY", "MPP_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b039d051 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1316 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("OUT_QTY", "MPP_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3bcbccf3 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1317 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_IN_QTY", "MPP_CELL_IN_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-74e28955 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1318 | if (Filter["MPP_WPP"] == "MPP") | DATA_OP | dtSave.SetFirst | ("CELL_OUT_QTY", "MPP_CELL_OUT_QTY") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-738a8bb7 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1328 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-53ae95e4 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1329 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfc103f5 | popSql.OnSql [if (programID == "PR_UI_FP00622_LINE_ADD_SAVE"… | FP00595_LineAddPopup.cs:1331 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |

## FP00595_LineCopy_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b973b1cf | this.Load | FP00595_LineCopy_Popup.cs:148 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c1344650 | this.Load | FP00595_LineCopy_Popup.cs:149 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a7f8fe7 | this.Load | FP00595_LineCopy_Popup.cs:150 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_LineCopy_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2a6a07a | this.Load | FP00595_LineCopy_Popup.cs:143 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_LineCopy_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2a3e3ac | Dispose | FP00595_LineCopy_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_LineCopy_Popup.Find_Data_Line

진입점: this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f8daad2 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:265 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_addline", "find_instanceType", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceType] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b06230d | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:268 | try ▸ if (dsK.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dsK.getColumn(0, "CONFIRM_AREA").ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-054cd07a | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:268 | try ▸ if (dsK.Good()) | DATA_OP | dsK.getColumn | (0, "CONFIRM_AREA") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-61965026 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:269 | try ▸ if (dsK.Good()) | DATA_OP | Filter["CTRL_CONFIRM_AREA"] | " LEFT OUTER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-e995cb53 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:272 | try ▸ if (dsK.Good()) ▸ if (confirm_area == "PLAN GROUP") | DATA_OP | Filter["CTRL_CONFIRM_AREA"] | " INNER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-7747d531 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:275 | try ▸ if (dsK.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_linecopyllist", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_linecopyllist] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9da5ee8 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:277 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-943c9359 | this.Load [try] 외 1 | FP00595_LineCopy_Popup.cs:281 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_LineCopy_Popup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa1fdc7f | this.Load 외 1 | FP00595_LineCopy_Popup.cs:217 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fc1cdcf9 | this.Load 외 1 | FP00595_LineCopy_Popup.cs:229 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-973bf7ea | this.Load 외 1 | FP00595_LineCopy_Popup.cs:236 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-3e66ca2c | this.Load 외 1 | FP00595_LineCopy_Popup.cs:244 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-1c1202ff | this.Load 외 1 | FP00595_LineCopy_Popup.cs:249 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7d98ae56 | this.Load 외 1 | FP00595_LineCopy_Popup.cs:250 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-6767b94f | this.Load 외 1 | FP00595_LineCopy_Popup.cs:254 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_LineCopy_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b107f67c | this.Load | FP00595_LineCopy_Popup.cs:94 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1f6a3e8 | this.Load | FP00595_LineCopy_Popup.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-77a7cc9a | this.Load | FP00595_LineCopy_Popup.cs:107 |  | UI_PROP | range_plan.ValueStart | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 ValueStart 설정 |  |  |  |
| AC-d3c65924 | this.Load | FP00595_LineCopy_Popup.cs:108 |  | UI_PROP | range_plan.ValueEnd | range_plan.ValueStart.AddDays(day_add - 1) | 속성 ValueEnd 설정 |  |  |  |
| AC-bdcf75c2 | this.Load | FP00595_LineCopy_Popup.cs:112 |  | STATE | edt_material.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-d67f597b | this.Load | FP00595_LineCopy_Popup.cs:113 |  | STATE | edt_line.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-a40ab5ee | this.Load | FP00595_LineCopy_Popup.cs:114 |  | VALUE_SET | edt_line.Text | dtFindData.getColumn(0, "LINE_ID").ToString() | 컨트롤 값 설정 |  |  |  |
| AC-58958350 | this.Load | FP00595_LineCopy_Popup.cs:114 |  | DATA_OP | dtFindData.getColumn | (0, "LINE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-19ece63c | this.Load | FP00595_LineCopy_Popup.cs:115 |  | VALUE_SET | edt_material.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00595_LineCopy_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d1cb7ed | this.Load | FP00595_LineCopy_Popup.cs:160 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5027cfd3 | this.Load | FP00595_LineCopy_Popup.cs:161 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_LineCopy_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be72540e | (진입점 미연결) | FP00595_LineCopy_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_LineCopy_Popup.Range_plan_ValueChanged

진입점: range_plan.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1567b1c4 | range_plan.ValueChanged | FP00595_LineCopy_Popup.cs:123 | if (range_plan.ValueStart < plan_date) | MESSAGE | MessageBox.Show | ("The start date can not be less than the plan date.") | 메시지 표시 |  |  |  |
| AC-99efe637 | range_plan.ValueChanged | FP00595_LineCopy_Popup.cs:124 | if (range_plan.ValueStart < plan_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-997163b2 | range_plan.ValueChanged | FP00595_LineCopy_Popup.cs:128 | else of (range_plan.ValueStart < plan_date) ▸ if (range_plan.ValueEnd < range_plan.ValueStart) | UI_PROP | range_plan.ValueEnd | range_plan.ValueStart.AddDays(day_add - 1) | 속성 ValueEnd 설정 |  |  |  |

## FP00595_LineCopy_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de6eef8e | this.Load | FP00595_LineCopy_Popup.cs:167 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50e05f80 | this.Load | FP00595_LineCopy_Popup.cs:168 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-efc2030b | this.Load | FP00595_LineCopy_Popup.cs:172 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_LineCopy_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcebbed7 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:308 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-c4f7c2b1 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:309 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9dfa3a46 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:312 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-44f4a3a9 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:313 | if (row != null) | MESSAGE | MessageBox.Show | ("Do you want Line Change", "", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-2f49b233 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:316 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_LineCopy_Validation", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineCopy_Validation] \| FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fe0bde26 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:319 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good()) | DATA_OP | validation.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f120fff3 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:320 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good()) | CALL_EXT | val.SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c47f0438 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:323 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good())… | MESSAGE | MessageBox.Show | ("Priority 0 or 9 exists within the period.") | 메시지 표시 |  |  |  |
| AC-eb370e48 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:325 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good())… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf3d6a8a | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:331 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | UI_PROP | batch.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-9dfea784 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:332 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | dsBatch.Tables.Add | (batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-e91f53af | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:362 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7c633cd | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:363 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-167bd940 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:364 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f2fca8e | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:365 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e723316 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:366 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16b4ae7d | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:367 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34e2e9dd | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:368 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d78e94ca | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:369 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5b94138 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:370 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac2a8a2c | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:371 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc4d7fda | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:372 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e49a7da | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:373 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-914300d5 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:374 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-173b7e82 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:375 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d99a1f6 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:376 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LINE_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d75e0468 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:377 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-afaee7d8 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:378 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-36aa5786 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:380 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3047a71a | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:381 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6068be69 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:382 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17ae9aea | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:384 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PROG_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdd23ec1 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:385 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("BUCKET_FROM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dcdb719f | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:386 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("BUCKET_TO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f50b26cf | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:388 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("COPY_FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-125ec067 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:389 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("COPY_LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f265515c | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:392 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.CopyData | (dtFindData, batch) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e0d299e | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:394 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.SITE_ID >=", "SITE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4353ade | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:395 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.PLANT_ID >=", "PLANT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6811261 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:396 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.OPERATION_ID >=", "OPERATION_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b99b5fa9 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:401 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["COPY_FACTORY_ID"] | bRow["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e69cce4 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:402 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["COPY_LINE_ID"] | bRow["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2078cf3d | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:404 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-538e82c3 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:406 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c821fbc0 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:407 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1f3763b | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:408 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8bd1308a | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:409 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a61b2082 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:410 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7a10f423 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:411 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca3d60ac | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:412 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-44dbe2b6 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:414 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PRODUCTION_TYPE"] | Filter["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c014f3b1 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:415 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-70204db5 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:416 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["NICK_NAME"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-bc2f5d96 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:417 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["TOP_ITEM_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b199e715 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:418 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["EQUIPMENT_ID"] | Filter["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2aab4109 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:419 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["MARKET"] | Filter["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-77962e68 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:421 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PROG_TYPE"] | "LINE_COPY" | 행/컬럼 값 대입 |  |  |  |
| AC-2b4c05e3 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:422 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["BUCKET_FROM"] | range_plan.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-26c10121 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:423 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["BUCKET_TO"] | range_plan.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f81bb3d1 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:426 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_SITE_ID"] | Filter["CTRL_SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa4274bf | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:427 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_PLANT_ID"] | Filter["CTRL_PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-753dc767 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:428 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_OPERATION_ID"] | Filter["CTRL_OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3f9f3450 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:432 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_row", "merge_LineCopy", batch, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_LineCopy] \| FP\Planning\F… | 엔드포인트 호출 |  |  |  |
| AC-e5fe1abf | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:435 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | dtRes.getColumn | (0, "RESULT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0a103fb4 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:437 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | DATA_OP | dtRes.getColumn | (0, "EXCEPTION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cccf3115 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:438 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | DATA_OP | dtRes.getColumn | (0, "COUNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-80032d51 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:440 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | (message) | 메시지 표시 |  |  |  |
| AC-b649308a | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:443 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | ("0 data saved") | 메시지 표시 |  |  |  |
| AC-92c285cd | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:447 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | ("unknown") | 메시지 표시 |  |  |  |
| AC-55e95410 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:449 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3fda865c | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:453 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-733ab2af | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:454 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4c147293 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:455 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | ENDPOINT | DataService.FP_RunProcedure | ("FP00595_row", "execute_psiCalcul", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-c4861263 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:456 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bb90171b | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:458 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-bc139218 | this.spdMain.CellDoubleClick | FP00595_LineCopy_Popup.cs:466 | if (row != null) ▸ if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_LinePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05fa8e82 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_LinePopup.cs:371 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ae31a6de | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_LinePopup.cs:374 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-79fd603a | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_LinePopup.cs:375 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_LinePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-223b407e | this.Load | FP00595_LinePopup.cs:138 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a89ca8ea | this.Load | FP00595_LinePopup.cs:139 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fcc1032 | this.Load | FP00595_LinePopup.cs:140 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_LinePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7bce9f5 | this.Load | FP00595_LinePopup.cs:133 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_LinePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5001c3ef | Dispose | FP00595_LinePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_LinePopup.Find_Data_Line

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db17b28b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:258 | try | DATA_OP | Filter["CTRL_CONFIRM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-104477a9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:262 | try ▸ if (confirm_area == "PLAN GROUP") | DATA_OP | Filter["CTRL_CONFIRM"] | "INNER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-2687f209 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:266 | try ▸ else of (confirm_area == "PLAN GROUP") | DATA_OP | Filter["CTRL_CONFIRM"] | "LEFT OUTER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-3f25fac8 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:269 | try | DATA_OP | Filter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2033b2b5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:270 | try | DATA_OP | Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-89293e66 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:271 | try | CALL_EXT | DataService.LkTool | (Filter, "CTRL","LINE", "AND A.LINE_ID", "AND A.LINE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8d29c1bd | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:273 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_addline", "find_LineList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineList] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-14eefa20 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:274 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-748146c5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:340 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_LinePopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8030de5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:213 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-50356864 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:223 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-380c85a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:230 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4916635c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:233 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a529a954 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-c000185f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:243 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-60b24501 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_LinePopup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00595_LinePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98348698 | this.Load | FP00595_LinePopup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a979cec | this.Load | FP00595_LinePopup.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_LinePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f5e71de | this.Load | FP00595_LinePopup.cs:124 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-c4a5e054 | this.Load | FP00595_LinePopup.cs:125 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-c016e047 | this.Load | FP00595_LinePopup.cs:126 |  | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4e3738a2 | this.Load | FP00595_LinePopup.cs:127 |  | STATE | txtMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00595_LinePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1732cff0 | this.Load | FP00595_LinePopup.cs:150 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e78f69a5 | this.Load | FP00595_LinePopup.cs:151 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_LinePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-906409d2 | (진입점 미연결) | FP00595_LinePopup.cs:172 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_LinePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb238114 | this.Load | FP00595_LinePopup.cs:157 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b3e5969 | this.Load | FP00595_LinePopup.cs:158 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-def09656 | this.Load | FP00595_LinePopup.cs:162 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2080ef47 | this.Load | FP00595_LinePopup.cs:165 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-3314bcdf | this.Load | FP00595_LinePopup.cs:166 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.SITE_ID), false) | 그리드 표시 설정 |  |  |  |
| AC-f9142e06 | this.Load | FP00595_LinePopup.cs:167 |  | GRID_STYLE | spdMain.Sheets[0].SetColumnVisible | (siMain.GetColumnIndex(DefColumns.PLANT_ID), false) | 그리드 표시 설정 |  |  |  |

## FP00595_LinePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35aa9263 | this.spdMain.CellClick | FP00595_LinePopup.cs:386 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ee934575 | this.spdMain.CellClick | FP00595_LinePopup.cs:387 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-80d4365c | this.spdMain.CellClick | FP00595_LinePopup.cs:390 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_LinePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20319284 | this.spdMain.CellDoubleClick | FP00595_LinePopup.cs:396 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-44a1f04e | this.spdMain.CellDoubleClick | FP00595_LinePopup.cs:397 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a1f5c5b8 | this.spdMain.CellDoubleClick | FP00595_LinePopup.cs:400 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-34413977 | this.spdMain.CellDoubleClick | FP00595_LinePopup.cs:403 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ed46708 | this.spdMain.CellDoubleClick | FP00595_LinePopup.cs:413 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7bf0e2b | .ctor | FP00595_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-17297638 | .ctor | FP00595_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-73749bd4 | .ctor | FP00595_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-48635bcd | .ctor | FP00595_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00595_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb30e8a2 | Dispose | FP00595_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c499b27b | this.Load | FP00595_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00595_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea90f815 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:201 |  | FLAG | data_val | new bool[data_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f8431ad1 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:202 |  | FLAG | measure_val | new bool[uom_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6afe163 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:203 |  | FLAG | total_val | new bool[total_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-acfcb1e0 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-5032ef98 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-04dc2dc4 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-37cf6bac | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc5a5893 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d21994ac | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c73f242 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-afd8c96c | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bd3b264 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4dffe21 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_engine_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d68d9f16 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_engine_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e7dce0b | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-90e55e48 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba2a463a | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-e25cdfc1 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-7af3bc7d | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb0391e | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f233cb98 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-25d2535d | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-2babf716 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca61608 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-74d82a63 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e033ddf1 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b36a819 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ac74ef8 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bb3e086 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-281beae1 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e07025c | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-d946baab | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_engine_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-106cf886 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_engine_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-867a35cb | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_sim) | 데이터 객체 조작/조회 |  |  |  |
| AC-81edb108 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-a78a204f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-fac3d779 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:278 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e2eb85f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:278 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-d491ca53 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:285 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-62cf3393 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:289 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-0a43099b | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:293 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00595_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc81a7ab | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_wpp_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b65cedd9 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_wpp_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-55e66d85 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_result_in.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-96b7ead2 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_mpp_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d12909b4 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_mpp_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6c2214b3 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_result_out.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3c121d01 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6951ed7f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8522650d | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_seq.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-db83581d | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_engine_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a3c8f455 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_engine_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-dc5fef15 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_memo.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-591f89e6 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_pc.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4c8009f7 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_jr.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-162bb230 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_cell.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-522b806b | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_batch.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0056d130 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c66907aa | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9e3c5f5f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_result_in_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-df836aee | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0d41def1 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-631742c8 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_result_out_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4aee3f3a | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-462bc5c7 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5a26214 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_memo_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d4af0cf8 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_off.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5012418b | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_setup.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3648d990 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_capa.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1f807195 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_engine_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4f4e242f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_engine_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1466ff5e | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_sim.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5249e4c3 | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_subTotal.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2008494f | this.Load 외 1 | FP00595_MeasureSetForm_Popup.cs:181 |  | VALUE_SET | chk_total.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |

## FP00595_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b9648c | (진입점 미연결) | FP00595_MeasureSetForm_Popup.cs:353 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-fab0b34c | (진입점 미연결) | FP00595_MeasureSetForm_Popup.cs:355 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3e9a734 | this.Load | FP00595_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4463b9ee | this.Load | FP00595_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a93ffd39 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-0255e1a6 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-6e77d7b1 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:339 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0d606001 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:343 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-1d466637 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:344 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-f6664ec5 | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:346 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fcdffdf | this.usrButton1.Click | FP00595_MeasureSetForm_Popup.cs:348 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00595_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-262a5dc0 | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-c9f0707c | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-92d4d35b | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:313 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-dc436c4d | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:317 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-b41bc4f2 | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:318 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-bc1c5170 | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:319 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-c66b928f | this.usrButton2.Click | FP00595_MeasureSetForm_Popup.cs:320 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_pdsItemLinePop.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac0fe283 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_pdsItemLinePop.cs:283 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3ee5fc0 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_pdsItemLinePop.cs:286 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-efbf90f3 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_pdsItemLinePop.cs:287 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_pdsItemLinePop.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13b0102d | this.Load | FP00595_pdsItemLinePop.cs:133 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a18181f | this.Load | FP00595_pdsItemLinePop.cs:134 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7486ec8a | this.Load | FP00595_pdsItemLinePop.cs:135 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_pdsItemLinePop.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1433c16f | this.Load | FP00595_pdsItemLinePop.cs:128 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_pdsItemLinePop.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54afe5a6 | Dispose | FP00595_pdsItemLinePop.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_pdsItemLinePop.FindData

진입점: this.Load / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3fe7d48 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:204 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a3af64ea | this.Load 외 2 | FP00595_pdsItemLinePop.cs:206 |  | DATA_OP | Filter["CTRL_NICK"] | Filter["CTRL_ITEM"] = Filter["CTRL_LINE"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-9db84c09 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:206 |  | DATA_OP | Filter["CTRL_ITEM"] | Filter["CTRL_LINE"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-e26ab512 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:206 |  | DATA_OP | Filter["CTRL_LINE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-46abc1e4 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:225 | if (dtLine.Good()) ▸ if (arrSplt.Length > 0) | DATA_OP | Filter["CTRL_LINE"] | "AND F.LINE_ID IN (" + lineVal + ")" | 행/컬럼 값 대입 |  |  |  |
| AC-8b37d63f | this.Load 외 2 | FP00595_pdsItemLinePop.cs:230 | if (!string.IsNullOrEmpty(txtMaterial.Text)) | DATA_OP | Filter["CTRL_ITEM"] | "AND E.ITEM_ID LIKE '%' + '" + txtMaterial.Text + "' + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-03aef557 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:234 | if (!string.IsNullOrEmpty(txtNickName.Text)) | DATA_OP | Filter["CTRL_NICK"] | "AND E.NICK_NAME LIKE '%' + '" + txtNickName.Text + "' + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-d4fcc452 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:238 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1588b298 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:240 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-571685a6 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:243 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_addline", "find_pdsItemLineList", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_pdsItemLineList] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c6e0f1de | this.Load 외 2 | FP00595_pdsItemLinePop.cs:246 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d49f4ea | this.Load 외 2 | FP00595_pdsItemLinePop.cs:249 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-60aa11a3 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:251 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-0120e198 | this.Load 외 2 | FP00595_pdsItemLinePop.cs:255 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_pdsItemLinePop.findLineCode_List

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-688e1fc9 | this.Load | FP00595_pdsItemLinePop.cs:332 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2946fc1f | this.Load | FP00595_pdsItemLinePop.cs:333 |  | DATA_OP | LocalFilter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ae90a84a | this.Load | FP00595_pdsItemLinePop.cs:348 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5bee3ed3 | this.Load | FP00595_pdsItemLinePop.cs:366 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-96691241 | this.Load | FP00595_pdsItemLinePop.cs:371 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc629b66 | this.Load | FP00595_pdsItemLinePop.cs:384 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-6f166698 | this.Load | FP00595_pdsItemLinePop.cs:386 |  | DATA_OP | LocalFilter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-85eaf2b1 | this.Load | FP00595_pdsItemLinePop.cs:387 |  | DATA_OP | LocalFilter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfd58b0b | this.Load | FP00595_pdsItemLinePop.cs:406 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-5aca1e22 | this.Load | FP00595_pdsItemLinePop.cs:406 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-04cb61cd | this.Load | FP00595_pdsItemLinePop.cs:407 |  | RETURN | return dtLine; |  | 처리 중단/반환 |  |  |  |

## FP00595_pdsItemLinePop.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6a9b7b3 | this.Load | FP00595_pdsItemLinePop.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3c221824 | this.Load | FP00595_pdsItemLinePop.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_pdsItemLinePop.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c820a7f4 | this.Load | FP00595_pdsItemLinePop.cs:121 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9d169d9c | this.Load | FP00595_pdsItemLinePop.cs:122 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00595_pdsItemLinePop.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75fdc8af | this.Load | FP00595_pdsItemLinePop.cs:145 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a999f39 | this.Load | FP00595_pdsItemLinePop.cs:146 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_pdsItemLinePop.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26f7c7f2 | (진입점 미연결) | FP00595_pdsItemLinePop.cs:165 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_pdsItemLinePop.mcbo_line_changed

진입점: mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8f56a4f | mcbo_line.SelectedIndexChanged | FP00595_pdsItemLinePop.cs:414 | if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00595_pdsItemLinePop.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f36b72e | this.Load | FP00595_pdsItemLinePop.cs:152 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52c5c818 | this.Load | FP00595_pdsItemLinePop.cs:153 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-437bf8cd | this.Load | FP00595_pdsItemLinePop.cs:157 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_pdsItemLinePop.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3881370 | this.spdMain.CellClick | FP00595_pdsItemLinePop.cs:298 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-6e58ed01 | this.spdMain.CellClick | FP00595_pdsItemLinePop.cs:299 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ab2b33f3 | this.spdMain.CellClick | FP00595_pdsItemLinePop.cs:302 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_pdsItemLinePop.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1bf492d | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:310 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-cb47cad8 | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:311 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-032011a1 | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:314 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-17e71d03 | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:317 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f1a9d08 | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:319 |  | FLAG | rtnRow | row | 화면 필드/플래그 변경 |  |  |  |
| AC-38d0edeb | this.spdMain.CellDoubleClick | FP00595_pdsItemLinePop.cs:323 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69e8410e | .ctor | FP00595_Plan_Amend_Line_Elec.cs:176 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-6fded848 | .ctor | FP00595_Plan_Amend_Line_Elec.cs:177 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2e7f257 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4520 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3f6c8338 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4521 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0f2918ee | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4522 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-31219322 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4523 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-43bacf92 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4524 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ad1a60c9 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4527 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-4d5a91f5 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4527 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-039d1c32 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4536 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c8303fbe | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4537 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ab4a993 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4539 | if (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-b73d0a17 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4539 | if (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fae8a22d | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4543 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44432623 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4544 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb33c9a1 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4546 | else of (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-4209896a | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4546 | else of (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9ed5ed4f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4548 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d3e8b3a7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4549 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6bded2ae | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4563 | if (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-7a4b2ef0 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4565 | else of (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2fb7acd5 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4566 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-005b4c93 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4567 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-9eb5ee8e | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4568 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6f6612e | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4574 | if (LocalFilter["INSTANCE_ID"] == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { LocalFilter["INSTANCE_ID"] = CString.GetCheckedListValue(… | ⚠ 의미 확인 필요 |  |  |  |
| AC-19221103 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4576 | if (LocalFilter["INSTANCE_ID"] == "") ▸ lambda | DATA_OP | LocalFilter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-2de10dee | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4581 |  | DATA_OP | LocalFilter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-290b8ebc | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4582 |  | DATA_OP | LocalFilter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-97c17cde | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4583 |  | DATA_OP | LocalFilter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-7846add6 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4585 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { LocalFilter["PLAN_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-02beb451 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4589 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | LocalFilter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-abc32fe8 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4609 |  | DATA_OP | LocalFilter["MASTER_ID"] | LocalFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acffd28f | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8690 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-677fe9e4 | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8695 |  | POPUP | new FP00595_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-845ce81b | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8696 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3c14e543 | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8697 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-53973e49 | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8698 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cd727574 | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8702 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-aa3b5d4b | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8704 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"] != null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-34cdcfd8 | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8719 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b5432f9e | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8721 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4b6e62aa | this.btn_bucket.Click | FP00595_Plan_Amend_Line_Elec.cs:8730 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnCapa_Click

진입점: this.btnCapaSync.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e31163 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8859 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a868cb93 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8860 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b62d9454 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8866 | if (Filter["FP_PLAN_ID"] == "") | MESSAGE | MessageBox.Show | ("inserts FP Plan ID.") | 메시지 표시 |  |  |  |
| AC-9fe476f9 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8867 | if (Filter["FP_PLAN_ID"] == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51a9dd59 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8869 |  | POPUP | new FP00595_CapaSync_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-93643f74 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8870 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c2cbd02b | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8870 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eba67560 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8871 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-557cf566 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8872 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-fafd2c5f | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8873 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-84e59b23 | this.btnCapaSync.Click | FP00595_Plan_Amend_Line_Elec.cs:8876 | if (popup.DialogResult == DialogResult.OK) | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2a51d94 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8655 |  | POPUP | new FP00595_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-67459bd4 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8656 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-a7d05e92 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8657 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8e351df6 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8658 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5decef40 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8662 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-5e2c91fe | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8674 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25c0e639 | this.btn_category.Click | FP00595_Plan_Amend_Line_Elec.cs:8683 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0755b7f7 | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8633 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-aba1117f | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8634 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-98c3280d | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8635 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2903e0ca | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8642 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-cc5ffaee | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8642 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a5dd49d4 | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8643 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-5f7a8b5c | this.btn_column.Click | FP00595_Plan_Amend_Line_Elec.cs:8649 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnCreatePlan_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e2e3bd2 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8934 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-48b6dac6 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8935 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-feabc2b3 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8942 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c8e7756 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8943 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cfff6b8 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8953 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP00602_FIND_FP0060 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8921d25e | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8955 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-79c8ab2f | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8961 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00b4ae8a | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8962 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-314f8fbe | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8967 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3738ea06 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8968 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5047fbb5 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8971 |  | DATA_OP | dtParam.Columns.SafeAdd | ("AMEND_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c58dbfb4 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8972 |  | DATA_OP | dtParam.Columns.SafeAdd | ("FIX_DATE_SYNC", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53d4c2f2 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8973 |  | DATA_OP | dtParam.Columns.SafeAdd | ("SYNC_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c24265c0 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8979 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8e777d36 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8982 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-52256c89 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8983 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-73624716 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8984 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e696c0a7 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8985 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-373cb176 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8986 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ed9aba14 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8995 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-759c964b | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8995 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-8dc54486 | this.usrButton1.Click | FP00595_Plan_Amend_Line_Elec.cs:8999 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cbo_fpplanid.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6ece32d | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9381 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-9f76b2f9 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9382 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e5042bc8 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9390 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43abba04 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9391 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49644dbc | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9395 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-840a071a | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9396 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5dfda58d | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9400 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-0a357520 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9401 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e733c50 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9406 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-87e9a9f3 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9407 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-51a35463 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9412 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-ec7a60d6 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9413 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-accb0e22 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9416 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-25736b07 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9417 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-252dc786 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9417 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c8d97550 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9418 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "ELEC" | 행/컬럼 값 대입 |  |  |  |
| AC-efcd98f3 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9419 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-367a343e | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9419 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ade47a7 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9420 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-840358fa | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9421 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a579630e | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9422 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b5f702f | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9423 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a841c4f6 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9424 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6a5e2171 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9425 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-473b3b98 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9426 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-41532351 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9427 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7d15626 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9428 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f531fce5 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9430 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8f54cd93 | this.btnDppWppCopyDwSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9431 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnDwSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5547faa4 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9319 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-fb20f10e | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9320 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-833fd4b5 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9328 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9dbc23f0 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9329 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9fe532e0 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9333 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2ac075ce | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9334 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8fb0cd44 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9337 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-049bd682 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9338 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97c78ff7 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9343 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-68b12f80 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9344 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-588e0756 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9349 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-d386a1b3 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9350 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b09f9a0b | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9355 |  | UI_PROP | DwSubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-9a874898 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9355 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3f2585d0 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9356 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "ELEC" | 행/컬럼 값 대입 |  |  |  |
| AC-f7ce63a8 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9357 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7582f068 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9357 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-15ab2c02 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9358 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-c03bbee0 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9359 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-32770418 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9360 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-daf7df66 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9361 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd684b9e | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9362 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-99e0ddcb | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9363 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-57bda447 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9364 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-180e5da5 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9365 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b45b4837 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9366 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6fc02dc0 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9368 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bddd4e70 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9369 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0e668000 | this.btnDWSubmit.Click | FP00595_Plan_Amend_Line_Elec.cs:9372 | if (DwSubmit.ShowDialog() == DialogResult.OK) | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca7a1370 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4619 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df4ada8f | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4620 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-405388dd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4626 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-c67dd4aa | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4627 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31fbd7b6 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4629 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-387c9fdb | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4630 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c1549e7 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4631 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d910d2f3 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4632 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0940c64d | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4639 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00595_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-130a546a | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4642 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-9fa6d59b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4642 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a5cd8706 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4645 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f35c970 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4647 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (dtPeriod_Plan.Good()) | DATA_OP | colPopup.Filter["UI_END_DATE"] | dtPeriod_Plan.Rows[0]["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-77574479 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4649 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ else of (dtPeriod_Plan.Good()) | DATA_OP | colPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2ff6d34f | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4650 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.FP00595 | 속성 DateColumnType 설정 |  |  |  |
| AC-f70ef648 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4651 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.HeaderLineCount | 3 | 속성 HeaderLineCount 설정 |  |  |  |
| AC-ec9e8152 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4653 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-663143a2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4654 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-62162688 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4655 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-512b45bd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4656 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-cfbd2b84 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4657 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c702ec2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4658 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-364d8d50 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4659 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9b336003 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4660 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de7973bc | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4661 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0dd0e373 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4664 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (sVERSION_YN == "Y") | GRID_SET | colPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f6df5d76 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4665 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (sVERSION_YN == "Y") | GRID_SET | colPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-18aad52b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4670 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | colPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9c7d74be | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4671 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2230100b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4672 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e501c4d2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4676 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-b9790609 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4677 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-60d8cee1 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4678 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-396a7dd0 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4679 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-4fa6f9a6 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4680 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-046ab406 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4681 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-7e26f6c3 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4682 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-49fd30c4 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4683 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-e2873ec1 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4684 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equiment" | 행/컬럼 값 대입 |  |  |  |
| AC-8383b68e | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4685 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-d50081e2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4686 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-6fda9b47 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4687 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-5004ece8 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4688 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-b3dbc413 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4689 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | colPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-61181b42 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4690 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-6c65048b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4691 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-9658ef6b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4693 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-ebfd90e6 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4694 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-a1441f73 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4695 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-1c417491 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4696 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-a46d3cf7 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4697 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoImportData | call_Excel_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-8de5f7f5 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4698 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-677e0dc1 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4708 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00595_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-64158439 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4711 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-cc9df5e8 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4711 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a91bcbe2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4714 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-590585c4 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4716 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (dtPeriod_Plan.Good()) | DATA_OP | rowPopup.Filter["UI_END_DATE"] | dtPeriod_Plan.Rows[0]["END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2cb6cf6c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4718 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ else of (dtPeriod_Plan.Good()) | DATA_OP | rowPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9ef0e1f8 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4719 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.Filter["FACTORY_LT"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8efe2222 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4721 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-5c9e82dd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4722 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-347b6ae3 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4723 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-89b6990e | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4724 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3490ac08 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4725 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c5bd516c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4727 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-21cbd176 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4728 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9d287a34 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4729 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-158c3fe0 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4730 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c2f246e | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4734 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-72ac35df | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4735 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-965cd1a5 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4738 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | rowPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d3171c74 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4739 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-95b90df5 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4740 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-03e83bb3 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4741 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-10ba98e4 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4743 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ADJUST_IN_QTY_BATCH"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a7fefe16 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4744 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SEQ"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8dd9d1f1 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4747 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-3c455b2d | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4748 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-1b8d1634 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4749 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-b6bd0e14 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4750 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-67cbf8fd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4751 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-70d074fb | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4753 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-3ba2f8fb | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4754 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-b88d66ba | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4755 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-8d439294 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4756 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipmnent" | 행/컬럼 값 대입 |  |  |  |
| AC-7bab578d | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4757 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-0b748dfd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4759 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-227f524b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4760 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-235ffe5c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4761 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-8541b84f | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4762 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-000fe25c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4763 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-4b6df73c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4764 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-d59b0edb | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4765 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-bf742acf | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4767 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_M"] | "M(P/C)" | 행/컬럼 값 대입 |  |  |  |
| AC-9ce2b817 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4768 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_CELL"] | "Cell" | 행/컬럼 값 대입 |  |  |  |
| AC-33ea4139 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4769 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_JR"] | "M(J/R)" | 행/컬럼 값 대입 |  |  |  |
| AC-b4239a0c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4770 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_BATCH"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-7b3ec492 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4771 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SEQ"] | "Seq" | 행/컬럼 값 대입 |  |  |  |
| AC-6d3cf6a2 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4772 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-d31a0d5d | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4774 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["DIVISION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0d16349c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4775 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SITE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-334b19ef | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4776 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLANT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-f8c22b74 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4777 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["FACTORY_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-4db1c522 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4778 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["OPERATION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-3cc40215 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4780 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["LINE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-a1ad6163 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4782 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ELECTRODE_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-52c2ad55 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4783 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["EQUIPMENT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-1659b610 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4784 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ITEM_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b445f371 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4785 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PC_MODEL_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-4e418c95 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4786 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["VERSION"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-41ff27ce | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4787 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnColor["PLM_EC_NO"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-7e40fedd | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4789 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PRODUCTION_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-cd4a377c | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4790 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["MARKET"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0368eec4 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4791 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLAN_DATE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-4472aef9 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4793 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ADJUST_IN_QTY_BATCH"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-35805390 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4794 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SEQ"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-31a6b6dc | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4825 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnWidth["COMPANY_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-79970eb8 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4828 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-05c5c408 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4830 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-277cae8b | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4831 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-7850f908 | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4832 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoImportData | call_Excel_Row_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-b4761c1a | this.btnExcelImport.Click | FP00595_Plan_Amend_Line_Elec.cs:4833 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76ae5de4 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9198 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-3a9149a2 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9199 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-a7ed7f08 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9207 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc378668 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9208 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d2e23007 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9213 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-e8b86663 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9214 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-064e872e | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9217 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bbdbee00 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9218 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-4c699134 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9219 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-65d20ddf | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9219 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3403234 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9220 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-a629be61 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9221 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-244fafbe | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9222 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-177fd1cd | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9222 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1b5889aa | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9223 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f44a960 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9224 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc27c561 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9225 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1b4690c | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9226 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9910bbe4 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9227 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ebcc7262 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9228 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9741cbe7 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9229 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0e48ea71 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9230 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-26c40cd8 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9231 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ac004315 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9233 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-111c54be | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9234 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-e758953f | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9235 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-d4ce6af7 | this.btnMemo.Click | FP00595_Plan_Amend_Line_Elec.cs:9236 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-284828ff | this.btnMenu.Click | FP00595_Plan_Amend_Line_Elec.cs:9439 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-eaff1010 | this.btnMenu.Click | FP00595_Plan_Amend_Line_Elec.cs:9439 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-377fb690 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8886 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f2615fc0 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8887 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-b5e294d9 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8895 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-81e4bacf | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8896 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af0b203b | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8900 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4877e8b8 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8901 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-67676daf | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8904 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-03669d7b | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8905 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce74803f | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8910 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-b416ec03 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8911 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4bd3bb8 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8916 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-e5659a83 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8917 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-34d960d1 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8921 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-60dbaf86 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8922 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62da0854 | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8923 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-250b467d | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8924 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-b2eabefd | this.btnMRP.Click | FP00595_Plan_Amend_Line_Elec.cs:8926 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1042597a | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9042 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-cf25e801 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9043 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-bb978557 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9050 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-03c08f69 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9051 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01851ff6 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9055 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-73ce8bd4 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9056 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f5356c6c | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9059 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-3534276f | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9060 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22328584 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9073 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-484f5f3e | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9074 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1cc59bcc | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9080 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d13807fa | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9081 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62dd3a6d | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9088 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e83590e | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9089 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f0e227f1 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9092 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e62db2a2 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9093 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-810676c0 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9095 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ead090fb | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9101 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-850b3be9 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9102 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-84a3323a | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9106 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d13506cb | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9110 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-93dfcaac | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9111 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bdec6d12 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9118 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67622706 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9119 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66444bdc | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9132 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ebac9f60 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9135 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-20330a1b | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9137 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-39d4b242 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9143 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a2e264f0 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9144 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d1162f35 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9157 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb1349e6 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9158 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c0526f72 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9170 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-93a43f3b | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9173 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-fc834f64 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9174 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-291a1f4b | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9175 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-88382da1 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9176 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7e0ec1df | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9184 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-7feee320 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9187 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-ad37e270 | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9188 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-6d032d5f | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9189 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d65c583e | this.btnRelease2.Click | FP00595_Plan_Amend_Line_Elec.cs:9190 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnReplan_Click

진입점: this.btnReplan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c890deeb | this.btnReplan.Click | FP00595_Plan_Amend_Line_Elec.cs:9033 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-79a96ed5 | this.btnReplan.Click | FP00595_Plan_Amend_Line_Elec.cs:9034 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnSetupColor_Click

진입점: this.btnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0606c592 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9246 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-12c9ea00 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9247 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-a676bb4f | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9250 |  | POPUP | new FP00595_SetupColor_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-98813b54 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9251 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-1df05b03 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9251 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-235213f2 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9252 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-4f5220c2 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9253 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-5832eca8 | this.btnSetupColor.Click | FP00595_Plan_Amend_Line_Elec.cs:9254 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa36c097 | this.btnSql.Click | FP00595_Plan_Amend_Line_Elec.cs:2535 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-56d67b31 | this.btnSql.Click | FP00595_Plan_Amend_Line_Elec.cs:2536 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0d49751f | this.btnSql.Click | FP00595_Plan_Amend_Line_Elec.cs:2538 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP00595_ROW_FIND_FP00595_ROW") | 데이터 객체 조작/조회 |  |  |  |
| AC-8204d3ec | this.btnSql.Click | FP00595_Plan_Amend_Line_Elec.cs:2539 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e04a399 | this.btnToggleSave.Click | FP00595_Plan_Amend_Line_Elec.cs:8740 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-9fe0fc93 | this.btnToggleSave.Click | FP00595_Plan_Amend_Line_Elec.cs:8742 |  | STATE | panelLog.Visible | !panelLog.Visible | 컨트롤 상태 Visible |  |  |  |

## FP00595_Plan_Amend_Line_Elec.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a07f7a9 | this.button1.Click | FP00595_Plan_Amend_Line_Elec.cs:9463 | if (flo2 != null) | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-996980de | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5055 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3600d5b1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5055 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-37e70b6e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5059 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea7320ce | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5060 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc1149d7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5070 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b7b46b5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5070 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-a65cf9c3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5072 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a3ad018 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5073 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a74ebec | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5091 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-62cd2708 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5094 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-2c7efe90 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5098 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-27ad87fe | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5109 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1db6791 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5112 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-798bec22 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5116 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-c4709b88 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5125 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-e95e5763 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5125 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-77441e85 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5125 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ac56cd28 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5126 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-254941fb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5126 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c1a4c927 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5130 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-be6527ff | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5130 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-7f60a856 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5131 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-8955fb14 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5147 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-84175b16 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5147 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-b09825f6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5147 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5dc756ee | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5148 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-92f1d1a7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5148 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4fb391c4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5152 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-5b8ca28f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5152 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-acea5eac | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5153 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-abc3b4e8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5191 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-45c4287b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5192 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a10bd69b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5193 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3d95eb81 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5197 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-6694354a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5198 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e8cea494 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5199 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4118f4eb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5206 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-d5c22366 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5224 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-48619d01 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5225 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-b82d4805 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5226 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-2afcbe3f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5237 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-566ae0da | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5237 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23f0008f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5765 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e385da75 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5321 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-96c65918 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5327 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-c0a14210 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5328 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9f206044 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5331 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-755373b2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5332 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-f84e7f1a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5332 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-55210f5c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5335 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93b4a407 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5336 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93d89dba | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5337 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("SEQ", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16c0736c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5339 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-461084ce | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5340 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf675090 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5341 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1fce5ad | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5342 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0aabf69f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5344 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f5750c6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5345 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22c5d849 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5346 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-92d1731d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5347 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-965e513a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5349 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bd6b159 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5350 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5df1ad31 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5351 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-04186ea6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5352 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-579875a2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5380 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10cf128a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5381 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c2c4f0e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5383 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3d07a6c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5384 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e79db0d3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5385 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-4b5dd872 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5386 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b1f546af | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5388 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7745c827 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5389 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6890b55f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5390 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-17c21189 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5391 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c8eea4f7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5392 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["OPERATION_ID"] | row["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4be07ed | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5394 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_ID"] | row["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-130f4be4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5395 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_NAME"] | row["LINE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-7d3b2a33 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5396 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-43c76111 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5397 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["EQUIPMENT_ID"] | row["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-60aa3a75 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5398 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4b97e5c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5400 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["NICK_NAME"] | row["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-1f669d5b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5401 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a4853e28 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5402 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LOCATION"] | row["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-8808bf28 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5403 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-1d56c0d6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5404 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["TOP_ITEM_ID"] | row["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f64a2cb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5406 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["USER_ID"] | row["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3522b55e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5408 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PC_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-12599e87 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5409 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-40ada819 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5410 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["VERSION"] | row["VERSION"] | 행/컬럼 값 대입 |  |  |  |
| AC-8e0aec70 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5411 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLM_EC_NO"] | row["PLM_EC_NO"] | 행/컬럼 값 대입 |  |  |  |
| AC-89aedf97 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5414 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-3ce456ab | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5416 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-1f02fb91 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5418 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-5a0f3a86 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5420 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-292f7f6d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5423 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-f481aec0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5425 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-d2f082ff | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5427 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-396d7c22 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5429 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-45f5bce0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5431 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SEQ"] | RoundValue(row[sSeqCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-5d921ce1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5482 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-e017b2dc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5483 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-7425b54f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5484 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9692c8aa | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5484 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-042a46b5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5486 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9227f498 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5486 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c08ea61 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4858 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b2df3051 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4861 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "EQUIPMENT_ID", "DIVISION_ID", "SITE_ID", "PLA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-487d6622 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4865 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-d016caa8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4874 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2c4eb4f7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4875 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-22ccba19 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4878 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7be88da2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4882 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-40aeb6e9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4885 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e44c2465 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5759 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Row_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83fb54f2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6081 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-99c6ebc4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6081 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-5161dab7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6085 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44c27e52 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6086 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8420451 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6096 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0b676b8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6096 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-47a1e103 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6098 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ceea56d7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6099 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c752063 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6117 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-9be71a8e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6120 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-8107483e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6124 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-78bbdf8c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6135 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c447c3f9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6138 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7c8953d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6142 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-e9635c9a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6151 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-b09effeb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6151 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-c53784fd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6151 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b9416d47 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6152 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-a46f603c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6152 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4e4e5df8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6156 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-2a1405ce | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6156 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-364a533a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6157 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-0b1c196a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6173 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-56767001 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6173 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-c83aa5ee | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6173 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6e4c2b1d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6174 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-c990a358 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6174 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a5f3a307 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6178 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-48e25a7b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6178 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-7ed44db6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6179 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-51f9f36a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6218 | foreach (DataRow row in data.Tables[0].Rows) ▸ if (nInValueOrg == DBNull.Value) | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-a6e16c0b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6222 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ if (nInValueOrg is string && string.IsNullOrWhiteSpac… | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-9a67ada0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6229 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-2eac22e3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6247 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-e91fa9a1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6248 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-34899f0c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6249 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-a7bd029f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6260 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d88540a9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6260 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6da28e0a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5819 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e116e063 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5824 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-e32e5657 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5825 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-021e76b6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5842 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f75f441 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5843 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4d0d2ce | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5844 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b92f8e57 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5845 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d368a071 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5846 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-003c17b4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5847 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17a6d4bf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5848 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bc4aed1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5855 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5d2d4e4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5856 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ea395b7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5857 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8102d825 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5858 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd0e4c00 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5859 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b5e0ae0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5861 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-be3369d5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5862 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc6612b2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5863 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-188f84b2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5864 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f7c4015 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5865 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cccfa69e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5866 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-84a2437d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5873 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-7448e1a4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5874 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-99114275 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5875 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seql | 행/컬럼 값 대입 |  |  |  |
| AC-3370b190 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5876 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["ROUND_POINT"] | round_point | 행/컬럼 값 대입 |  |  |  |
| AC-40bd0f5a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5879 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (qty_val == null) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-911e9b16 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5881 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-fa9b8f17 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5883 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-6464ac3f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5886 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-58ac2789 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5887 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-0f8f58a1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5888 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-63728859 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5889 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-2cb95574 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5890 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-4d8300b3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5891 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-37402920 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5892 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-c20703b8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5893 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-c0533987 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5894 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-fe04eb2d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5895 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c85c9f47 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5899 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-98895ddf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5900 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-11d8fe03 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5901 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-d40404d4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5902 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-b79b80a7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5903 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-f6904e31 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5904 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-958a5f7c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5905 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-5cd9c865 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5906 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-22b7f7fc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5907 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-4b251e68 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5908 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a035b36a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5918 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-0c4bcc45 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5919 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-9dce3896 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5920 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-7d12b023 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5921 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-9dc2efdd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5922 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-bca4d359 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5923 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-5c6d46cd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5924 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | popup.Filter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-2c80f622 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5926 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b73bde8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5933 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-a45b56d1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5935 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e43cc80 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5935 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-cb6dbf8d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5940 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9061b54 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5940 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |
| AC-f739d9a0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5948 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ed606393 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5950 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-835dca58 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5951 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTA… | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52193d71 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5952 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ab570a9f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5953 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PL… | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcc6d0c9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5956 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ec1157a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5957 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3dccb217 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5964 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-d970ed2b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5965 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-cc9ae36f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5966 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fcfd956 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5966 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-bd190b15 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5968 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-a4abddc7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5973 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-053d60b1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5973 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-5d459080 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5977 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-713d90ee | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5977 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b29cc752 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5784 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c141e56 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5787 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8011f94 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5790 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-bc09726c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5796 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-1fa3141b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5797 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-6c802299 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5798 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-15f1b852 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5799 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-131a901d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5801 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_EXCEL_2_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cb335280 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5804 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d8e276c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5807 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-5d8a9e66 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5810 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94995a99 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6273 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ee7e527 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6277 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-10a327f7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6280 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-094142f3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6282 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-c360ca6e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6283 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("CELL")) | DATA_OP | data.Tables[0].Columns.Add | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31df047a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6284 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bc8f2c2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6285 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-802e50a0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6286 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ea1b70b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6287 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c22f120 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6288 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ddfe3a53 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6289 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | data.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68e862bf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6292 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["CELL"] | row["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-91ed81cc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6293 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7cd4e5a3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6294 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-222ec3a1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6295 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-3626e2de | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6304 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["QTY"] | row["ADJUST_IN_QTY_BATCH"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ff613f5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6308 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-79a5e2b1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6323 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_MPPWPP", "delete_Excel_buffer", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-b2b844e6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6325 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00595_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-4ae6e9f9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6344 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | popup.Filter["INSTANCE_COND"] | tmp_sql | 행/컬럼 값 대입 |  |  |  |
| AC-b8644a65 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6346 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_MPPWPP", "find_Excel_buffer_validation", popup.Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4539e840 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6363 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-2b3b86d4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6392 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6d3173fe | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6395 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.CheckAndGetMeasure

진입점: this.Load / popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanT…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1795870 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:648 | switch (measureId) default: ▸ if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b06a956 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:648 | switch (measureId) default: ▸ if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-f9420b1c | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:650 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00595_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec93a9dd | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:650 | switch (measureId) default: | POPUP | new FP00595_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-77fdab70 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:651 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00595_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9e62f3b8 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:651 | switch (measureId) default: | POPUP | new FP00595_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5ee9206b | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:653 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-e968a457 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:654 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-45e9dccf | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:655 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-cea378a5 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:656 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-5bf035ce | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:657 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-74d9e48c | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:658 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-09f4f58c | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:659 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f56fbd1 | this.Load 외 11 | FP00595_Plan_Amend_Line_Elec.cs:660 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.chk_Info_CheckedChanged_1

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7080276e | this.chk_Info.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9447 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7688513 | this.chk_Info.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9447 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cce3ed5 | this.chk_Info.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9453 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-42a52529 | this.chk_Info.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9454 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.chk_omit_zero_CheckedChanged

진입점: chk_omit_zero.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43b8647f | chk_omit_zero.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9632 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-77d17025 | chk_omit_zero.CheckedChanged | FP00595_Plan_Amend_Line_Elec.cs:9634 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1e8e217 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8320 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-cc63a2ca | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8322 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3728a771 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8323 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ea4d362 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8324 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4487a2a9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8325 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6de201a0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8326 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d64cda7c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8327 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe6f43e4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8328 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-94fe2ee9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8329 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ea1a3d5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8330 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aae40487 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8331 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-23244201 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8332 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c33320cd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8333 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e409d243 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8334 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-50f1cccc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8335 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ad3ac8c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8336 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c583cdc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8337 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-301a0a79 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8338 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9691d8d1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8339 |  | DATA_OP | dt.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32666c08 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8340 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a16abd3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8341 |  | DATA_OP | dt.Columns.SafeAdd | ("BOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6439ec32 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8342 |  | DATA_OP | dt.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f20ca977 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8343 |  | DATA_OP | dt.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86871e06 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8344 |  | DATA_OP | dt.Columns.SafeAdd | ("SALES_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a08f8195 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8345 |  | DATA_OP | dt.Columns.SafeAdd | ("EOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b93ae3b7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8346 |  | DATA_OP | dt.Columns.SafeAdd | ("YIELD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac6b48d1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8349 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8affc8db | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8350 |  | DATA_OP | dt.Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-069e53ed | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8351 |  | DATA_OP | dt.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b9a30b0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8353 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98b32d52 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8354 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f076d56f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8355 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-65719651 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8356 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-11666302 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8358 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c25f92c8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8359 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad51b68b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8360 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cf08ec3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8361 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e03a4d6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8363 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-687607ad | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8364 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60ef486b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8365 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d963a26e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8366 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-210cd67c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8368 |  | DATA_OP | dt.Columns.SafeAdd | ("EIDX", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6304a03f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8369 |  | DATA_OP | dt.Columns.SafeAdd | ("EQTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9142f90 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8370 |  | DATA_OP | dt.Columns.SafeAdd | ("EDATE", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32de8744 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8372 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5433448b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8373 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e24b9d4e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8378 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9819590d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8381 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.CreateEditDataGridDataSetTmp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-430180f2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8205 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-1cc958cc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8207 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe8a6e4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8208 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ad46fc5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8209 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19a515c1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8210 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e75dacb3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8211 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-89049189 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8213 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-45dc14e6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8215 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5792daf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8216 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c8cea2a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8217 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-660a7372 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8218 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1972a4a5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8219 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12498796 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8220 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d12145fd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8221 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba35f262 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8222 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-731e1102 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8224 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-279541a6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8225 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc53479b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8226 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c4d383c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8227 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c82efa36 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8228 |  | DATA_OP | dt.Columns.SafeAdd | ("IS_PREV_SCHEDULE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de7e1133 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8231 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57925a34 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8232 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22bb781f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8233 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1b937d0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8234 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d33c9dd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8236 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7333503a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8237 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-654852f1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8238 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07cd343b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8239 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10e77f4c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8242 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cf096e7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8243 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d00c1189 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8244 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd623b5e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8245 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99d8858c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8246 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a9966c1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8248 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4fc2c11d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8249 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-691eaa2f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8250 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e88e72f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8251 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9e99747 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8252 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-42320f52 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8254 |  | DATA_OP | dt.Columns.SafeAdd | ("TOTAL_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-83fb93df | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8256 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8009d3c6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8257 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c5ce9b65 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8258 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4483775e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8259 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-21b33b48 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8260 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6c0bfff | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8262 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bcae6a7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8263 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b3d1f1f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8264 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6f5ad7f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8265 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-40e0c5a5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8266 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee03eaad | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8268 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93305889 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8269 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1904eca1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8270 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-51e4f7a3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8271 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a4da21d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8272 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1073c21 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8274 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-347e4056 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8275 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3a5edd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8276 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-80474b47 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8277 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3628805 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8278 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-977c93eb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8280 |  | DATA_OP | dt.Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e044095 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8306 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79d5845f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8307 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1595490a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8312 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee44c741 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8315 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ec185c9 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:2576 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-859849a8 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:2587 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-add9abaf | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:2588 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b91103ac | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3590 |  | DATA_OP | dsResult.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-08d2bba2 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3593 | for (i < rows.Length) | DATA_OP | rows[i]["_MM_"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-479db1ee | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3599 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-402bdc0b | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3603 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c330a930 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3606 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-7a4f995c | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3608 | else of (t != null) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6aa06ab6 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3608 | else of (t != null) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-d7cdba6a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3609 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d94820a8 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:602 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3d5ac858 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:603 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea1b56c7 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:604 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.dCalendar_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8135c901 | dCalendar_planrange.ValueChanged | FP00595_Plan_Amend_Line_Elec.cs:8602 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64a12d48 | dCalendar_planrange.ValueChanged | FP00595_Plan_Amend_Line_Elec.cs:8609 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-4ba6e619 | dCalendar_planrange.ValueChanged | FP00595_Plan_Amend_Line_Elec.cs:8610 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d90fe16 | DeleteButton | FP00595_Plan_Amend_Line_Elec.cs:1664 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4759ae13 | Dispose | FP00595_Plan_Amend_Line_Elec.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.b…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1563a741 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:995 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-bb9baffb | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:999 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-39113198 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1000 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41267362 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1001 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46ee0c8c | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1002 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57dd3b51 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1003 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-eca15f5a | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1007 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-aa954875 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1008 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-22b60fab | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1009 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ff255e92 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1010 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a8a72aab | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1023 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1afde04 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1024 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ac3ce57 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1030 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-eb8a6d19 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1060 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1001f04 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1066 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f5010f9 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1068 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-118aa807 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1069 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89a64b39 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1070 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-4ab99e2e | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1074 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | froz | 그리드 속성/값 설정 |  |  |  |
| AC-2b28602d | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1076 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-1fdca153 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:1077 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / thi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4528ace7 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1086 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5ddab18a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1089 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b5cc424 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1090 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1fa720f6 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1099 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-334e4879 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1105 | if (dsMainFiltered.Good()) ▸ if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-34f852f0 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1109 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.ds_List01_cancolumnchange

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (clicked_row != null)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61591cbc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7193 | if (clicked_row == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2246f545 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7195 | if (clicked_row["CATEGORY_ID"].ToString() == "SIM_SETUP") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-c929f5be | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7202 | if (bM != -1 && bC != -1 && bJ != -1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-804e2bdd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7204 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.dwCheck

진입점: line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d32b486 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:9660 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-49c0fd42 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:9663 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c7a8bc64 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:9667 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-f131489a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:9671 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f64126ce | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:9676 | else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00595_Plan_Amend_Line_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79ee3197 | EditButton | FP00595_Plan_Amend_Line_Elec.cs:1672 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-c78c244f | EditButton | FP00595_Plan_Amend_Line_Elec.cs:1674 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b5da10d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7211 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0ece13c3 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7212 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-c24a79f9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7213 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-746ceb5e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7215 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b5a3fc0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7227 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-62d1fd53 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00595_Plan_Amend_Line_Elec.cs:7228 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46417f0a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7269 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8dd869be | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7270 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1899c77 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7271 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a824e7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7273 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cb2c757 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7281 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-3578e6b5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7282 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b0e63ab | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7287 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0b376f3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7238 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44fbcf04 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7240 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-fcbc0a60 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7241 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-99477be6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7243 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fa29096 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7253 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb96a658 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7259 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d25df02 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7261 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Excel_Export

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed189d75 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3737 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.Casecaded | 속성 Merge 설정 |  |  |  |
| AC-183fc9e1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3738 |  | UI_PROP | exportOption.Border | ExcelBorderOption.None | 속성 Border 설정 |  |  |  |
| AC-8954f1c1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3740 | if (omitZero) | UI_PROP | exportOption.AmendZeroOption | ZeroOption.HideZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-e28672ec | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3742 | else of (omitZero) | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-060f393d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3745 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e8c85df8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3746 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-60b71be4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3747 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-6c9e54b4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3749 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2c50d0b9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3750 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-e0daf5b1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3757 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f9dbbfd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3761 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-2e6b0df1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3765 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6aaef37e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3772 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88a38a3f | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3681 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-056c1534 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3682 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-09075770 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3684 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8a06055e | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3688 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-7faee44a | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3689 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-32980e2c | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3690 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-8c956db3 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3693 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-5836bf6d | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3694 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-d3a2d474 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3695 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-1ee39285 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3697 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-67f7a434 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3698 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-a5e3545d | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3701 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-2feca72c | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3713 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ffc24306 | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3717 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b990dced | ExcelButton | FP00595_Plan_Amend_Line_Elec.cs:3721 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW")] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb8c72b9 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4411 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = ""; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ed77594 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4413 | try ▸ lambda | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e7d034f7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4430 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_ROW_FIND_FP00595_ROW", Filter.Copy(), p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-02f0fc78 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4430 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afdbd607 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4497 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = Filter["FP_PLAN_ID"] = Filter["PLAN_ID"]… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fbc4ba8 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4499 | try ▸ lambda | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] = Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-404a09a8 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4499 | try ▸ lambda | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f1b7fee4 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4508 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-59fb5024 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4514 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_ListData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53644ed7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4348 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cada6af3 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4357 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_ListData", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4a4124a7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4358 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_Prod_Version_Type

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try ▸ lambda] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a336465 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4370 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-18a29732 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4375 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_Prod_Version_Type", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a7620a8d | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4376 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_UOMInfo

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try ▸ lambda] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-176709f5 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4328 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4e31a403 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4337 | if (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9fa46e6f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4338 | if (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |
| AC-8f45c770 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4342 | else of (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo_ASIS", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9ae9afa | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4343 | else of (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_version_data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7b1fe2d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5246 |  | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-40420169 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5262 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-030e2932 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5278 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", prodtype, sTxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b53280b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5289 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-583a6056 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5308 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12d7a737 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5311 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_versionType

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try ▸ lambda] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1c69638 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4363 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9664efc0 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4365 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_versionType", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c35391a7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4366 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Find_YieldInfo_All

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try ▸ lambda] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab29798f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:7146 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c1ccd53f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:7147 |  | DATA_OP | Filter2["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-3ff77e22 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:7148 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_yieldInfo_ALL", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-74e275d2 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:7149 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.find_YieldInfo_Child

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try ▸ lambda] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / th…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0a84fcd | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4312 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-360d3bb6 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4320 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEM", "AND A.ITEM_ID ", "AND A.ITEM_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-39ff25e2 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4322 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_YieldInfo_Child", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-407ba686 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4323 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.FindBaseData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8474e2eb | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4381 |  | FLAG | dsListData | find_ListData(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-10cb1989 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4384 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsListData.Tables[0].Select | ("RELEASE_TYPE='MPP' OR RELEASE_TYPE='WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-beca2b74 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4392 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = dsListData.Tables[0]; dsUOMInfo = fin… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e32a8a5 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4394 | lambda | LIST_BIND | dgEdit.DataSource | dsListData.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-88b21fac | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4395 | lambda | FLAG | dsUOMInfo | find_UOMInfo(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b7bc9e82 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4396 | lambda | FLAG | dsYieldInfoChild | find_YieldInfo_Child(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-32ddad3f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4397 | lambda | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c38725cb | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4397 | lambda | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c671572a | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4398 | lambda | FLAG | dsProdVersionType | find_Prod_Version_Type(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-be929778 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4399 | lambda | FLAG | dsVersionType | find_versionType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1daf46b6 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:4400 | lambda | FLAG | dsYieldAll | Find_YieldInfo_All(Filter) | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.findLineCode_List

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73678701 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:523 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-83c19931 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:524 |  | DATA_OP | LocalFilter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-389913ec | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:540 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6560c07a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:558 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-a6dfbd23 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:563 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1696daef | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:576 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-c09475d3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:578 |  | DATA_OP | LocalFilter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7fde349f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:579 |  | DATA_OP | LocalFilter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8cdaf9f4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:593 | if (LocalFilter["ALL_LINE"] != "Y") | DATA_OP | LocalFilter["CTRL_LINE_LT"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-d99bb0a0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:596 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-508a790a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:596 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08d70681 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:597 |  | RETURN | return dtLine; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.FindSubTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b953ef9a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1208 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84338b1b | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1196 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-f925fa8e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1203 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e5cfcc7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4279 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-aca56bc9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4281 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_TOTALVALUE", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-362bac09 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4282 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-603fb284 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4288 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.FindYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / zero_line_menu.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3af2708 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7154 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3216a169 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7156 |  | DATA_OP | Filter2["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cbff0990 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7157 |  | DATA_OP | Filter2["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c47e4b21 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7158 |  | DATA_OP | Filter2["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-852e7984 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7159 |  | DATA_OP | Filter2["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9f3fc14 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7161 |  | DATA_OP | Filter2["OPERATION_ID"] | "E2000" | 행/컬럼 값 대입 |  |  |  |
| AC-7bb43c8d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7162 |  | DATA_OP | Filter2["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-424c797c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7163 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f85bd6eb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7164 |  | DATA_OP | Filter2["PLAN_DATE"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-76b3a9c7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7165 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_yieldInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c054e70 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7172 | if (ret.Good()) ▸ if (cell_rate > 0) | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |
| AC-9977fe02 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7174 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87ff2ecf | this.Load | FP00595_Plan_Amend_Line_Elec.cs:211 |  | STATE | panelLog.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e4d04acc | this.Load | FP00595_Plan_Amend_Line_Elec.cs:219 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetAmendTable

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f0906e6 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3876 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-22af67ea | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3877 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-630fbdd7 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3878 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-2c2d8f95 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3879 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-c2d5b189 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3880 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-4f32bb6f | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3881 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_H" | 행/컬럼 값 대입 |  |  |  |
| AC-c3b6de98 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3885 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-f884d551 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3886 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-418d0b0a | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3887 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7bc0d7f5 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3888 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b321cece | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3889 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-bf98d1e6 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3890 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_R" | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3b1b240 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:265 |  | FLAG | dtPeriod | DataService.FP_ExecuteProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime")… | 화면 필드/플래그 변경 |  |  |  |
| AC-47bde26b | this.Load | FP00595_Plan_Amend_Line_Elec.cs:265 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetFilter

진입점: line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9aa9fed2 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3850 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetFpPlanId

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.ValueChanged / this.cbo_fpplanid.DropDown / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f4582ec | this.Load 외 4 | FP00595_Plan_Amend_Line_Elec.cs:4016 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-44754b92 | this.Load 외 4 | FP00595_Plan_Amend_Line_Elec.cs:4023 |  | FLAG | dtPlanId | dtPlanIdRet | 화면 필드/플래그 변경 |  |  |  |
| AC-6ee0cbf9 | this.Load 외 4 | FP00595_Plan_Amend_Line_Elec.cs:4024 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetMppWpp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffcccfc4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2470 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d9cc1307 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2480 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-762464b7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2481 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7c4e248 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2482 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-533abf10 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2483 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9880043c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2484 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c29322f9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2485 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-acf44dc4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2486 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c958ae9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2487 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05773553 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2488 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d4b4d13 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2489 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a37597d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2490 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5955203 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2491 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3279ed56 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2492 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fafd7824 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2478 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-84c1068c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2508 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_M_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-2f20f385 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2511 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_M_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-4538c30c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2516 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_W_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-26eaa2b1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2518 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_W_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-76c35454 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2523 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetPlanDate

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60e07fbd | this.Load | FP00595_Plan_Amend_Line_Elec.cs:285 |  | UI_PROP | dCalendar_planrange.Value1 | start | 속성 Value1 설정 |  |  |  |
| AC-5a290e14 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:286 |  | UI_PROP | dCalendar_planrange.Value2 | end | 속성 Value2 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6f60a31 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:3993 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f78c6757 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:3994 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-206aadc2 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:3994 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4caca954 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:3996 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-9cc66607 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:3998 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ab80fd8a | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4001 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-d730afe0 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4002 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-1a381796 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4002 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-4ff4b485 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4003 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7863a7d7 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4004 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71c5fb3b | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4005 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b8fb01fa | this.Load | FP00595_Plan_Amend_Line_Elec.cs:4009 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetPlanner

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-536323e5 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3940 |  | FLAG | dtPlanner | DataService.FP_ExecuteQuery2("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-2033a5fc | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3940 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a6587151 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3941 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b082547 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8197 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-24041a4b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:8198 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetProdType

진입점: this.Load / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d0ce7c7 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:4148 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6471e3b0 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:4148 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4c6c7b9 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:4149 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GetRoundPoint

진입점: popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db0c40bd | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3855 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "find_getRoundPoint", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ce5df57 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3858 | if (dtRound.Good()) | FLAG | RoundPoint | dtRound.Rows[0][0].SafeZeroInt() | 화면 필드/플래그 변경 |  |  |  |
| AC-20844cbe | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3860 | if (dtRound.Good()) ▸ if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-1c00f707 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3861 | if (dtRound.Good()) | FLAG | RoundTen | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-a66425ec | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3865 | if (dtRound.Good()) ▸ while (rwork > 0) | FLAG | RoundTen | *= 10 | 화면 필드/플래그 변경 |  |  |  |
| AC-cc4ca455 | popSql.OnSql [if (programID == "PR_UI_FP00595_ROW_FIND_FP005… 외 10 | FP00595_Plan_Amend_Line_Elec.cs:3869 |  | DATA_OP | Filter["ROUND_POINT"] | string.Format("{0}", RoundPoint) | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ace2fb12 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4163 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GoDrawCellColor

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29fd8a62 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1680 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0110bbb | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1715 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-576c22b8 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1716 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-a07668ea | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1720 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8de6a0a5 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1721 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, bg) | 그리드 표시 설정 |  |  |  |
| AC-02dd446e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1750 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e809713f | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1751 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-3d13a9de | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1780 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c6a3cb6 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1781 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (se…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71eb7514 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1827 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-815e70cf | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1828 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-ff610f82 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1864 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49da1e2a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1888 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eeb00d79 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1921 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-e512d8e4 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1946 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-82e33ed2 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1962 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitAmendLineELec

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13663a16 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:233 |  | DATA_OP | Filter["AMEND_INSTANCE"] | lv_amendInstance | 행/컬럼 값 대입 |  |  |  |
| AC-6b074cb0 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:234 |  | DATA_OP | Filter["PLAN_DATE"] | DateUtil_FP.gfn_today() | 행/컬럼 값 대입 |  |  |  |
| AC-c29df082 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:234 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc60bcee | this.Load | FP00595_Plan_Amend_Line_Elec.cs:235 |  | DATA_OP | Filter["AMEND_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-cd3631ed | this.Load | FP00595_Plan_Amend_Line_Elec.cs:236 |  | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-1e3e9a7d | this.Load | FP00595_Plan_Amend_Line_Elec.cs:237 |  | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-30e394a1 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:238 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitControlFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beb3390f | this.Load | FP00595_Plan_Amend_Line_Elec.cs:304 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-f1954165 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:308 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-765171a3 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:310 |  | DATA_OP | Filter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-3ddb4da8 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:314 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-d7c5e2ea | this.Load | FP00595_Plan_Amend_Line_Elec.cs:315 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-acfc99df | this.Load | FP00595_Plan_Amend_Line_Elec.cs:345 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-8f1fad85 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:347 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-b0e16e95 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:384 |  | VALUE_SET | chk_omit_zero.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1e09d7c2 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:385 |  | DATA_OP | Filter["OMIT_ZERO"] | "Y" | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29a64bc | this.Load | FP00595_Plan_Amend_Line_Elec.cs:244 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e99c3d97 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:247 | try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ad1a0b99 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:249 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-1716461f | this.Load | FP00595_Plan_Amend_Line_Elec.cs:250 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c4f20cb9 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:254 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitEditingBuf

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fca506b | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:7134 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-34ff5e03 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:7136 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-ab5c4142 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:7137 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ef3f097 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:476 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-879e8706 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:477 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6d108a04 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:478 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-10287568 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:479 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b6cc7118 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:480 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b9d62f04 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:481 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f65d59c9 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:482 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-b257a276 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:483 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59c8b7a9 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:617 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7aef6d98 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:618 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-54ca8bfa | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:620 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1cb7bdb8 | this.Load 외 14 | FP00595_Plan_Amend_Line_Elec.cs:624 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-278d2152 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1616 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-35f292f3 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1617 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d89d828b | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1623 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a07a2ac1 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1628 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | MESSAGE | MessageBox.Show | ("Please select row with model first") | 메시지 표시 |  |  |  |
| AC-5f8b2bd0 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1629 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e69e7fb6 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1631 | if (row != null) | POPUP | new FP00595_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-1b5cf04d | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1633 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-29386ca8 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1633 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74eaa612 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1634 | if (row != null) | UI_PROP | popup.dsUOMInfo | dsUOMInfo | 속성 dsUOMInfo 설정 |  |  |  |
| AC-13161a8f | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1635 | if (row != null) | UI_PROP | popup.dsVersionType | dsVersionType | 속성 dsVersionType 설정 |  |  |  |
| AC-c0801dbb | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1636 | if (row != null) | UI_PROP | popup.dsYieldChild | dsYieldChild | 속성 dsYieldChild 설정 |  |  |  |
| AC-9db4dc46 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1638 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e5b3b0a5 | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1639 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa80e0ab | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1640 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eed5428a | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1644 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-78b8c45d | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1645 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0663784f | InsertButton | FP00595_Plan_Amend_Line_Elec.cs:1656 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae084515 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:3821 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00595_Plan_Amend_Line_Elec.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ab52fb8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4897 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4b470510 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4899 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-2c1d023c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4901 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-fbc78311 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4902 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0eb627 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4907 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9d4f9b7c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4909 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a65e92b3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4911 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6924b40a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4913 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b274dfc6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4915 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5cdc7bbe | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4917 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-2f6bba73 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4919 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a088228f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4923 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b9eeb7f2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4926 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-ed1db3ac | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4928 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_getExchangeBatch_Validation

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (clicked_row != null)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5521eeb5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8116 | switch (cate) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-6e1a5661 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8127 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-081c7280 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8128 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-b08c1529 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8129 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-23283212 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8130 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5151409d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8131 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-8bf822b5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8132 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e30b76bb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8125 | if (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-25184643 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8142 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-16c298ec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8143 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-d74163f2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8145 | if (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-5acab728 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8155 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-07ccdb01 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8156 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcf0761f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8157 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2aebe97c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8158 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e524356 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8159 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("PROD_VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a86195d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8153 | else of (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-92f95f48 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8169 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-d4f45ca5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8170 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-b7eee78c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8172 | else of (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_getYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / zero_line_menu.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccda9a1d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7179 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f0c4fe9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7180 |  | DATA_OP | yf["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9007a21 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7181 |  | DATA_OP | yf["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1e2946a7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7182 |  | DATA_OP | yf["FACTORY_ID"] | clicked_row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5a9ddb52 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7184 |  | FLAG | YieldRate | FindYieldInfo(yf, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c202f73 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7184 |  | RETURN | return YieldRate = FindYieldInfo(yf, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_setExchangeBatch

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / zero_line_menu.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c41f6e0d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7930 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-a5ba9d62 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7971 |  | CALL_EXT | dsYieldChild.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e582e40 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7976 | else of (nExcRow == -1) | DATA_OP | dsYieldChild.Tables[0].getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f7657886 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7983 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_setExchangeBatch_Detail

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / zero_line_menu.Click [if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75e1f21f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8002 |  | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30323080 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:8099 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_settingValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ce8aef5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4950 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) | DATA_OP | row.Table.Columns.Contains | (sQtyCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ea16888 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4957 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-39ac1992 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4958 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c81625be | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4959 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7d7d64df | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4960 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sQtyCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-418d56a4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:4961 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a4bf0b0e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5025 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ else of (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSe… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-65cd871c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5037 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-78feb2a4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5038 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-daf5f39a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5041 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c2a3b026 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5043 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d3b20e7f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5044 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.lfn_settingValidRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-daa9098a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6031 | else of (!IsNumber(row[sQtyCol])) | DATA_OP | row[sQtyCol] | x | 행/컬럼 값 대입 |  |  |  |
| AC-61494368 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6063 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-1a0070d0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6064 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-25e1f201 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6067 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-42132aec | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6069 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-34fa301a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6070 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9a73b9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:970 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-844a8ad6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:974 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.mcbo_planner_changed

진입점: this.Load / mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8cac7cf | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:8475 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-36a4b26c | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:8477 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8663906f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6847 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b94a9b6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6850 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee1e391a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6854 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14c61c8d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6858 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-5890c627 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6858 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-841c3863 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6860 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-a74083cd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6861 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-fff451e9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6861 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0e8a9a94 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6862 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-fef280cf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6863 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-257a284c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6864 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-75302673 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6869 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff279df0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6871 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-cf54faeb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6876 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onLineChangeMenu

진입점: line_change_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0406379 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6807 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e8ca104 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6810 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dca7c795 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6812 |  | POPUP | new FP00595_LineCopy_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0a86b017 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6813 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ec798d8a | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6813 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-339338ad | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6815 |  | DATA_OP | frm.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea91c6d4 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6816 |  | DATA_OP | frm.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e6667ff1 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6817 |  | DATA_OP | frm.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8a5d7bc9 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6818 |  | DATA_OP | frm.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29ca2be2 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6819 |  | DATA_OP | frm.Filter["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08e67c33 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6820 |  | DATA_OP | frm.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80984f00 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6821 |  | DATA_OP | frm.Filter["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c4d60e3d | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6823 |  | DATA_OP | frm.Filter["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e544bfe | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6825 |  | DATA_OP | frm.Filter["NICK_NAME"] | row["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69f4cc30 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6826 |  | DATA_OP | frm.Filter["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4febf909 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6827 |  | DATA_OP | frm.Filter["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73c51b62 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6828 |  | DATA_OP | frm.Filter["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-75564776 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6833 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9a694596 | line_change_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6834 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71452bb4 | memo_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6884 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-37796258 | memo_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6887 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-682a674e | memo_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6891 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13c921a7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7077 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7e8bd6e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7080 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90c7c9d9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7098 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-fc5884ef | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7099 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f80761dd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7099 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bf0c5b20 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7100 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4097c162 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7101 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-63406006 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7102 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-48a67b4d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7103 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onZeroAllMenu

진입점: zero_all_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d32b49b | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6716 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35c4cc54 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6719 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4b41494 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6723 | if (dsMainFiltered.Good()) | MESSAGE | MessageBox.Show | ("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warn… | 메시지 표시 |  |  |  |
| AC-81695ac4 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6725 | if (dsMainFiltered.Good()) ▸ if (MessageBox.Show("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warnin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92bd7e62 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6727 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ba3a7311 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6728 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7241759c | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6750 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ( "DATA_TYPE='DATA'" ) | 데이터 객체 조작/조회 |  |  |  |
| AC-a04e5d90 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6783 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH") ▸ for (k < DayColumnCount) | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-51a58440 | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6796 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e7ccc5af | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6799 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-253a3d8c | zero_all_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6800 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23cea07b | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6404 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cbd00f4 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6407 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f082ab98 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6424 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-414bb085 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6425 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bf0e3124 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6436 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") &&… | DATA_OP | row_to_test["CATEGORY_ID"].ToString().Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-83408fc0 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6463 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-efb0845f | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6464 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-146fce18 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6465 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4362a4 | bucke_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6468 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onZeroLineMenu

진입점: zero_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3faa542 | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6592 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-717f2337 | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6595 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29d03662 | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6599 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8acc37e1 | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6600 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bb70dde3 | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6622 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" //+ " AND OPERATION_ID='" … | 데이터 객체 조작/조회 |  |  |  |
| AC-aee8725f | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6677 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-6dc174ca | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6705 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cac27a5a | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6708 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-60aafcac | zero_line_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6709 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.onZeroMaterialMenu

진입점: zero_mat_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fb5247c | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6480 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ea42954 | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6483 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aaf05ddc | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6487 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aba3c5ef | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6488 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bbb97914 | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6509 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-3df0a7de | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6553 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-5db5f89e | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6581 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7653aba4 | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6585 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-529e6059 | zero_mat_menu.Click | FP00595_Plan_Amend_Line_Elec.cs:6586 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Sele…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cc572ac | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10019 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4829a01 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10019 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-287fa18d | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10021 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-f4d1928b | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10022 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e5e413f3 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10022 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-02a0a43e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10023 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-26e98102 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10024 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f55dd852 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10025 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-166ddaa2 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10029 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-718d0c1d | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10031 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d4856280 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10036 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82c8c773 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9977 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-1916b912 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9978 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-72d3128b | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9979 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-fb66a498 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9979 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eebad5ef | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9980 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-549a420d | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9981 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-77451ce2 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9982 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ae6084fb | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9987 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e017f0f | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9990 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3469d99a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9996 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-63224006 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9997 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-a170f540 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9998 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-0b54dfb2 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9998 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dbf77677 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9999 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-289a2ff5 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10000 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a4fe5717 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10001 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6f8977e9 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10005 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a380cf76 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 1 | FP00595_Plan_Amend_Line_Elec.cs:10007 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2323492 | sCalendar_planday.ValueChanged | FP00595_Plan_Amend_Line_Elec.cs:8521 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Query

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / thi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee334a3a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1128 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-5d916d75 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1128 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2fc8fad3 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1129 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bbf2c2f5 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1134 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-31be7ca9 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1157 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-05048e8d | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1163 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-0814d765 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1163 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-510b775f | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1164 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-757d1f9a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1164 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38fdb390 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1167 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e8ffa990 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1174 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-35315d2a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1179 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72aa8acf | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1180 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { siMain.EditQuery(dsMainFiltered); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cc50d4a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1182 | lambda | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71195282 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:1187 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69f071c0 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:760 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { siMain.SpreadObject.SuspendLayout(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c74e48d7 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:762 | try ▸ lambda | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1c2d8a66 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:779 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4cb2c2aa | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:783 | finally | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { siMain.SpreadObject.ResumeLayout(); })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59897703 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:785 | finally ▸ lambda | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day !=…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ce56d0 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3670 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-a924cc4e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:3676 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.RoundValue

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04fd5840 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:9644 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-55c341a1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:9645 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-9158c076 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:9649 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-be207a70 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:9650 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-61737a7b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:9653 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc7d357d | popSql.OnSql | FP00595_Plan_Amend_Line_Elec.cs:4264 | if (programID == "PR_UI_FP00595_ROW_FIND_FP00595_ROW") | RETURN | return Find_Data_Amend(false); |  | 처리 중단/반환 |  |  |  |
| AC-d94b43ec | popSql.OnSql | FP00595_Plan_Amend_Line_Elec.cs:4266 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18e4cc3a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:1991 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0a46c91d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2013 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-243880ea | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2014 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-02540152 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2020 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-153a3ee9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2031 | try | CALL_EXT | dt2.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b15ba09 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2300 | try ▸ else of (dt.Good()) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-ebbaa8b0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2301 | try ▸ else of (dt.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-90015f73 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2308 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-72e62ebd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2315 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fb7d0286 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2319 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-8c0cc1ab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2320 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-066fb82e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2326 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-38d83206 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2327 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-58d32bee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2328 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f93495e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2329 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-814b0d62 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2331 | try | FLAG | dsBoh | DataService.FP_ExecuteProcedure("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 화면 필드/플래그 변경 |  |  |  |
| AC-73fbdd1c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2331 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-580d02d7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2335 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cd213c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2336 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-17759b50 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2337 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-78bda4e4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2338 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-63f0e702 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2339 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88501b43 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2341 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-66994b3f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2342 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3540328b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2343 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-54269bfb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2344 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc3897ba | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2345 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c16837b9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2347 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-cda52732 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2348 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'MPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fb3f68a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2349 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9867aada | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2350 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8fd0992 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2353 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-aec11527 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2354 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-1e7552cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2355 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-8a95f539 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2356 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-df42738f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2357 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-e697dda1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2358 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-68aec8d5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2359 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-8d66869e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2360 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-ebf9f6d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2361 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-b4caf6ca | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2362 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-96016dfb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2367 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-d70b0a6a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2368 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-fbd3cd4e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2369 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-8c94d697 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2370 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-82f0a8f1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2371 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-59ba3e37 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2372 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-e50bebf8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2373 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-99d613a1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2374 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-c9249424 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2375 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-fd1673f7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2376 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-733a9a48 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2379 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (wpps, wpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-832e6cd2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2380 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (mpps, mpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3f0463a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2390 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", mpp, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-8b4c3e01 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2391 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-045d062f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2397 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", wpp, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-c423e845 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2398 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | CALL_EXT | DataService.ReadResult | (res2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22d6ba66 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2427 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr != null && !dr.Success) | THROW | throw new Exception(dr.Message); |  | 예외 발생 |  |  |  |
| AC-06570180 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2429 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr2 != null && !dr2.Success) | THROW | throw new Exception(dr2.Message); |  | 예외 발생 |  |  |  |
| AC-b5c09c6a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2430 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) | THROW | throw new Exception("There is no data to save"); |  | 예외 발생 |  |  |  |
| AC-1b0c0d1c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2437 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-cc9d7977 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2438 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-a9de07fc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2439 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-8f9789da | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2440 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-919cbcd4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2441 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-33bc5a1e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2442 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-f20eb302 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2443 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | GetFilter("FP_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-4762255e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2444 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b57f7ae9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2445 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-fdb7b0de | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2452 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-4fff739f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2457 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-59cdec5d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00595_Plan_Amend_Line_Elec.cs:2459 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9e3f810 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2527 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f08a1615 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1975 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-151f704e | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1976 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93fe94cf | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1979 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a9cd8dc3 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1980 |  | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fca597a0 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1982 |  | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb5fdb0e | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:1984 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f15cb26 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5499 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popupFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-29408350 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5503 | if (ISRELEASE) ▸ if (nSeq.Good()) | DATA_OP | popupFilter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bf477171 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5510 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2218812 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5511 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc9599d5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5512 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6542273d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5513 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-70a0bfe5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5514 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b93fea6 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5519 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["JOB_ORDER"] | ii | 그리드 속성/값 설정 |  |  |  |
| AC-dd77dca1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5520 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 그리드 속성/값 설정 |  |  |  |
| AC-318c7d84 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5527 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_MPPWPP", "delete_Excel_buffer", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-a87b5406 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5528 | if (ISRELEASE) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00595_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-f72b95ce | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5530 | if (ISRELEASE) | CALL_EXT | DataService.ReadResult | (dtRes) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9330be93 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5534 | if (ISRELEASE) ▸ if (!dr.Success) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6535db2a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5571 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_MPPWPP", "find_Excel_buffer_validation", popupFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dbe7eefa | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5577 | if (ISRELEASE) ▸ if (validation.Good()) | CALL_EXT | validation.Tables[0].FindRowExpr | ("_VALID='N'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4eb1f612 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5581 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | MESSAGE | MessageBox.Show | ("There are invalid data.", "Error") | 메시지 표시 |  |  |  |
| AC-00cfc045 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5583 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | new FP00602_InvalidExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-80dd5c47 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5584 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | UI_PROP | popup.ErrorData | validation | 속성 ErrorData 설정 |  |  |  |
| AC-cb05d8c5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5585 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b931e3e8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5587 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eb2e4342 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5609 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-896cd6cd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5610 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc59733c | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5611 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0eff65ca | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5612 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8863124 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5613 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8effa1a7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5614 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4b7540e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5615 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-898e8819 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5623 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5f7dcbc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5624 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-508a6b04 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5625 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-080faef2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5626 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-736dc117 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5627 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a691dacf | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5629 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e70c77ee | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5630 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4fd0f75 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5631 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f222b40d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5632 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-df50fd31 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5633 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31a0aa66 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5634 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e5b64b2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5640 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-8bfe4322 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5641 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popupFilter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd074a3a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5642 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-0e451c34 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5643 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["ROUND_POINT"] | Filter["ROUND_POINT"] | 행/컬럼 값 대입 |  |  |  |
| AC-a926e8a5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5646 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-881e405d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5647 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-f83bc08e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5648 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-a270242d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5649 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-66a0223e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5650 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-46f9b4bb | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5651 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-d74d36c0 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5652 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-f8d7d3b5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5653 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-64abc756 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5654 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-4dbe1d9f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5655 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-05574498 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5656 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-fd3e2909 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5657 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a22caa17 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5663 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-bbcbbac7 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5664 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-6d19e7aa | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5665 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-785fba98 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5666 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-0696c744 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5667 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-271a6549 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5668 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-8d3b7a76 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5669 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-e14dcdc8 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5670 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-2235bfdc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5671 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-06035ede | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5672 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-dce8a2e1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5673 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-bd8779d9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5674 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a19a2d0a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5681 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-76ba0021 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5686 | if (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-2c920805 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5687 | if (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-632f0496 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5688 | if (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-2843096f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5689 | if (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-17884a5e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5690 | if (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-9dcdd873 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5691 | if (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-cae54777 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5692 | if (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-2f592c99 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5695 | if (ISRELEASE) | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12585ad3 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5697 | if (ISRELEASE) | RETURN | return do_save; |  | 처리 중단/반환 |  |  |  |
| AC-4f6c21f9 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5702 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_DATE"] | popupFilter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-dc0dbd8e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5703 | else of (ISRELEASE) | DATA_OP | BohSet["MASTER_ID"] | popupFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0463781b | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5704 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_ID"] | popupFilter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad02aa71 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5705 | else of (ISRELEASE) | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-d21292c1 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5708 | else of (ISRELEASE) ▸ if (string.IsNullOrWhiteSpace(popupFilter["FP_PLAN_ID"])) | DATA_OP | BohSet["PLAN_ID"] | data.Tables[0].Rows[0]["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a1c06b91 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5717 | else of (ISRELEASE) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-acabff6d | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5722 | else of (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-95420436 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5723 | else of (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-1b90cc0e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5724 | else of (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-1673e2d2 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5725 | else of (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-a92343f5 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5726 | else of (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-3e8a0a73 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5727 | else of (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-be3acd80 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5728 | else of (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-03b11b18 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5731 | else of (ISRELEASE) | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-51d598cd | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5736 | else of (ISRELEASE) ▸ if (do_save) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-85efcdde | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:5742 | else of (ISRELEASE) ▸ else of (do_save) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0280b6b4 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:2571 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetCalendarFormat

진입점: chk_omit_zero.CheckedChanged [if (siMain != null)] / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2b8a588 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9553 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-17e4b17f | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9555 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdb17a70 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9558 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e812aba7 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9582 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd06e691 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9584 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5517133e | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9587 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e137f8b | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9613 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ca6ede7 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9615 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7db9eca7 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9618 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30f8812e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:874 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-183d201e | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:878 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-d7f0e7aa | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:880 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a763c71d | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:884 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-d635d8be | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:908 | if (calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-64046805 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:923 | if (calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetChangeControl

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_all_line.CheckedChanged / usrCheckBox1.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.cbo_fpplanid.Dr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eb6e0d3 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:394 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-934b97ec | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:394 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0e01e09a | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:403 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-379cb901 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:403 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a489de33 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:404 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c4d8470 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:410 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7b2b34ff | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:411 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e5859ae | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:411 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-81fce925 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:412 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f687c455 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:418 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d6699c44 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:419 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7cce928 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:419 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7fcb13fa | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:420 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d03880ef | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:426 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-428069fd | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:427 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-d2a65a8c | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:427 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7889621c | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:428 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8cc67c38 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:435 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-37018d82 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:437 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-7926da1e | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:438 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3cafffd | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:439 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b771284a | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:440 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ab01cc3 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:441 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-c1c6ed5d | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:442 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-7752bdf5 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:444 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-34d2c5bd | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:450 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-eb09b61c | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:451 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2e94b975 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:451 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-045289e4 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:452 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1a1cfec6 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:458 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-bd4f8699 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:462 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_LT"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8ddba12b | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:465 | switch (triggerControl) case DefColumns.PLANNER_ID: | DATA_OP | Filter["PLANNER_ID"] | CString.GetCheckedListValue(dtPlanner, mcbo_planner.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6ccd2636 | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:468 | switch (triggerControl) case DefColumns.FP_PLAN_ID: | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = CString.GetCheckedListValue(dtPlanId, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2aa42dcc | this.Load 외 15 | FP00595_Plan_Amend_Line_Elec.cs:468 | switch (triggerControl) case DefColumns.FP_PLAN_ID: | DATA_OP | Filter["FP_PLAN_ID"] | CString.GetCheckedListValue(dtPlanId, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetColumnsFormat

진입점: chk_omit_zero.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == n…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a85b39f | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9493 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4f98a5b | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9499 | if (siMain != null) ▸ if (colIndex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a567b95 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9503 | if (siMain != null) ▸ if (colIndex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,##0", "0", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99a2e348 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9508 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#00", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-00a48a41 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9511 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-286c40a9 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9514 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-074b55e8 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9517 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fc91c13 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9520 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09368709 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9523 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "##,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e08c2649 | chk_omit_zero.CheckedChanged 외 14 | FP00595_Plan_Amend_Line_Elec.cs:9526 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0.###", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef63ab18 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:188 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b308e8d | this.Load | FP00595_Plan_Amend_Line_Elec.cs:190 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-77eb23d0 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:194 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-a5bbba8a | this.Load | FP00595_Plan_Amend_Line_Elec.cs:196 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-fedec6f5 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:197 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19645954 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:199 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-68e4adf3 | this.Load | FP00595_Plan_Amend_Line_Elec.cs:203 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-490a8f6f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 16 | FP00595_Plan_Amend_Line_Elec.cs:9470 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetFilter

진입점: this.Load [if (dtPeriod.Good())] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cbo_fpplanid.SelectedIndexChanged [if (dtPlanId.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (t…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a53dc4a1 | this.Load [if (dtPeriod.Good())] 외 27 | FP00595_Plan_Amend_Line_Elec.cs:3845 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetFpPlanId

진입점: this.Load / cbo_fpplanid.SelectedIndexChanged / this.cbo_fpplanid.DropDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8d76cf1 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4041 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | sPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-b224237c | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4042 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | sPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-fe77a1ae | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4043 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | sPlanType | 행/컬럼 값 대입 |  |  |  |
| AC-b3d322e2 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4044 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8779e443 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4058 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-597f4213 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4059 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-4c3a376f | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4060 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-31e5861c | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4061 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-aa63e3bb | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4062 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-f064a1fa | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4080 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a1f45741 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4082 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-939f9769 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4083 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-749e52bb | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4084 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3bbb4e2f | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4085 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48e1a304 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4089 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ccfcacc8 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4091 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3ec81ebe | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4092 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e8d1815e | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4093 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e88794af | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4094 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2707e4a8 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4101 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[selected]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9246f851 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4102 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[selected]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd8cd16b | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4104 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(start_date, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-4afc18a0 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4105 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value2 | DateTime.ParseExact(end_date, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-60c72401 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4106 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a2d6f345 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4107 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1603598a | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4114 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-6a8efb58 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4115 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-11fead29 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4122 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d8de88cd | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4123 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4a36870a | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4124 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-778f514d | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4125 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fe0549dd | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4127 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-0110a95c | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4128 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-b3203785 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4134 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-d20bf31e | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4135 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-beebf494 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4136 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9b99a10a | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4137 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7f2760c7 | this.Load 외 2 | FP00595_Plan_Amend_Line_Elec.cs:4138 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd0d470f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6953 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-6b000ffc | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6973 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-35a7699e | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6975 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | bcell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-b3377a0f | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:6993 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-e95fe358 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7018 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(siMain.SP.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-ce8fdd78 | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7020 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(System.Drawing.SystemFonts.DefaultFont, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-c0a73e9a | (진입점 미연결) | FP00595_Plan_Amend_Line_Elec.cs:7024 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(memo_cell.Font.Name, memo_cell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetPlannerFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57ab7a9d | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3957 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0d1869ea | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3961 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0de0d752 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3976 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-136da231 | this.Load 외 1 | FP00595_Plan_Amend_Line_Elec.cs:3981 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00a8349f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7306 | if (string.IsNullOrWhiteSpace(ColumnName_Buf)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-debe092f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7328 | if (!can_change) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-49f33403 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7329 | if (!can_change) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-22dcf5b2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7330 | if (!can_change) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9467e3cd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7348 | if (new_value != round_value) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | round_value | 그리드 속성/값 설정 |  |  |  |
| AC-c01ad769 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7351 | if (new_value != round_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8f7bbfd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7386 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-5cc95cf8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7431 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-31712cd2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7432 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-283d536d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7433 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fe63cfc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7434 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-76fdf86d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7435 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c2efedd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7436 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6b857f01 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7437 | lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e8fb72e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7438 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-87656543 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7439 | lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-762a05a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7440 | lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-24c6d6e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7441 | lambda | DATA_OP | x.Field | ("RELEASE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-76d7b868 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7442 | lambda | DATA_OP | x.Field | ("WORK_REQUEST_MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c05f4fa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7443 | lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-47938b29 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7444 | lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8d982ce | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7447 | lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-33ff600c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7463 | else of (m.Count() > 0) | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-62aa55db | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7472 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-8f4685f7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7477 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-c37dd9d8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7481 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-98b94590 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7483 | else of (m.Count() > 0) | DATA_OP | newRow["INSTANCE_ID"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1d668cbb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7484 | else of (m.Count() > 0) | DATA_OP | newRow["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b046472b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7485 | else of (m.Count() > 0) | DATA_OP | newRow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-44940926 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7486 | else of (m.Count() > 0) | DATA_OP | newRow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-7aedfa3c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7487 | else of (m.Count() > 0) | DATA_OP | newRow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-1c23e3cd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7488 | else of (m.Count() > 0) | DATA_OP | newRow["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-18378d46 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7489 | else of (m.Count() > 0) | DATA_OP | newRow["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-16ffcdb8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7490 | else of (m.Count() > 0) | DATA_OP | newRow["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-2bffe71d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7491 | else of (m.Count() > 0) | DATA_OP | newRow["EQUIPMENT_ID"] | sEqup | 행/컬럼 값 대입 |  |  |  |
| AC-35a4febe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7492 | else of (m.Count() > 0) | DATA_OP | newRow["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-2723f177 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7493 | else of (m.Count() > 0) | DATA_OP | newRow["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-6bf0688c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7494 | else of (m.Count() > 0) | DATA_OP | newRow["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-2e4e1770 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7495 | else of (m.Count() > 0) | DATA_OP | newRow["ITEM_ID"] | sItem | 행/컬럼 값 대입 |  |  |  |
| AC-a6ec180b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7497 | else of (m.Count() > 0) | DATA_OP | newRow["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-efeef2c1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7498 | else of (m.Count() > 0) | DATA_OP | newRow["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-cc959bc2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7499 | else of (m.Count() > 0) | DATA_OP | newRow["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-f867b582 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7500 | else of (m.Count() > 0) | DATA_OP | newRow["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-7ab1ad2a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7501 | else of (m.Count() > 0) | DATA_OP | newRow["WORK_REQUEST_MODEL_ID"] | sTopm | 행/컬럼 값 대입 |  |  |  |
| AC-b5465e34 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7502 | else of (m.Count() > 0) | DATA_OP | newRow["VERSION"] | sVers | 행/컬럼 값 대입 |  |  |  |
| AC-1e1a7477 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7503 | else of (m.Count() > 0) | DATA_OP | newRow["PROD_SEQ"] | sProS | 행/컬럼 값 대입 |  |  |  |
| AC-cf244dc4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7504 | else of (m.Count() > 0) | DATA_OP | newRow["PLM_EC_NO"] | sPlmE | 행/컬럼 값 대입 |  |  |  |
| AC-4c82ab94 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7507 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c3e3191 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7522 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-7d4116ed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7523 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["SEQ"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-53718e59 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7528 | else of (sCate == "P_SEQ") | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-0a42b640 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7535 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-3390f5f4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7540 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-45f6f939 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7541 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12350f48 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7570 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_M] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-dae4f967 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7572 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-6c47cd09 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7573 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-5f85b927 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7574 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-6f1a9a4e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7576 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-7cf21093 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7577 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-9cfde3b7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7593 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_CELL] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-2a89d5d7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7599 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_JR] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e6eb612d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7614 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-6a219990 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7616 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-e31b9822 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7617 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-f5a06353 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7618 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-be483ce5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7620 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-c17f1d8f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7621 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-c25d8c47 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7637 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-97cadbd9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7643 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-9487caee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7659 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-993684d6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7677 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-6deb1beb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7683 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-3ad80f7f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7704 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-0b1541ac | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7712 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-502a819e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7732 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-1722477b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7744 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-406b1123 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7763 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-a0e327c4 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7770 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-13ac6c74 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7789 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-26d77b34 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7796 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-d8055edc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7816 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) ▸ if (res != nul… | DATA_OP | res[0][ColumnName_Buf] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-9d2207db | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7823 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-fe78ba64 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7842 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) ▸ if (res != nu… | DATA_OP | res[0][ColumnName_Buf] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-757d6eec | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7851 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-7b258989 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7879 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if (Filter["PLAN_TYPE"] != "RELEASE") ▸ if (res… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-e2bc0adc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7884 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | CALL_EXT | dsMainFiltered.Tables[0].Rows[idx]["SEQ"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-df6dd760 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00595_Plan_Amend_Line_Elec.cs:7890 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if ((nInValue > 0) && oldseq == 0) ▸ if (res !=… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetReleaseProcess

진입점: line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId))…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfcd4fd9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3622 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-19a89e2f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3628 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) | FLAG | DbCurrentDate | DateTime.ParseExact(curr_date, "yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a45dba3 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3633 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < DbCurre… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e1989624 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3637 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < Db… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b1596d87 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3643 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-243e1679 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3644 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-720e995a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3645 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-39680b30 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3646 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnSetupColor.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-795653dd | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3648 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-539797a2 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3649 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["RELEASE_VALUE"] | ds_isCurrWeek.Tables[0].Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2313b664 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3654 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7ebccb1 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:3655 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ swit…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d07d6bb2 | this.Load [try] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:632 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f242480 | this.Load [try] 외 14 | FP00595_Plan_Amend_Line_Elec.cs:633 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / line_change_menu.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80e4f822 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:821 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL": | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, total_color) | 그리드 표시 설정 |  |  |  |
| AC-73e409a5 | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:824 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL_2": | GRID_STYLE | siMain.SetBGColor3 | (line, substart, line, last_col, sub_total_color) | 그리드 표시 설정 |  |  |  |
| AC-f92d241a | memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (s… 외 13 | FP00595_Plan_Amend_Line_Elec.cs:831 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if (idx_version > -1 && sMaxVer… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd415c2f | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9872 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bf3d8bbc | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9873 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fb6be60 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9896 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-10b15698 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9897 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-c1cfabf6 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9899 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d646076 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9918 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-a987525e | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9919 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-7ff65c40 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9921 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-24b67c5a | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9930 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bd79365 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9935 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_line_menu.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-d9d789fb | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9936 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-c17e3ebf | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9938 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-676686ca | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9942 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_mat_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-39ca6755 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9943 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_mat_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-39368383 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9945 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_mat_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-a34043c3 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9949 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_all_line_menu.Text | "Zero Setting(All Line)" | 컨트롤 값 설정 |  |  |  |
| AC-7963f358 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9950 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_all_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-b8c9e3ff | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9952 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_all_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdd14db8 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9956 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | line_change_menu.Text | "Line Change" | 컨트롤 값 설정 |  |  |  |
| AC-edeab5e9 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9957 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | line_change_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-6c0fa437 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9959 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (line_change_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2dcba44 | this.spdMain.CellClick | FP00595_Plan_Amend_Line_Elec.cs:9967 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7958f4 | this.spdMain.CellDoubleClick | FP00595_Plan_Amend_Line_Elec.cs:9716 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-2d77c5ea | this.spdMain.CellDoubleClick | FP00595_Plan_Amend_Line_Elec.cs:9723 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65cfcf65 | this.spdMain.ClipboardPasted | FP00595_Plan_Amend_Line_Elec.cs:8773 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fc44de7 | this.spdMain.ClipboardPasted | FP00595_Plan_Amend_Line_Elec.cs:8781 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3bb0527a | this.spdMain.ClipboardPasted | FP00595_Plan_Amend_Line_Elec.cs:8782 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f0566b3 | this.spdMain.ClipboardPasted | FP00595_Plan_Amend_Line_Elec.cs:8784 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c0d48e7 | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8748 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-99f85705 | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8749 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-72c7fdbd | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8749 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-30a888de | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8753 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-b76f26b1 | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8753 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f617024 | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8757 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-113ed7a4 | this.spdMain.ClipboardPasting | FP00595_Plan_Amend_Line_Elec.cs:8759 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89bbacb2 | this.spdMain.EditModeOn | FP00595_Plan_Amend_Line_Elec.cs:8831 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb70f492 | this.spdMain.KeyDown | FP00595_Plan_Amend_Line_Elec.cs:8389 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-ad8af770 | this.spdMain.KeyDown | FP00595_Plan_Amend_Line_Elec.cs:8393 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54cf4f4e | this.spdMain.KeyDown | FP00595_Plan_Amend_Line_Elec.cs:8394 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.SwitchMemo

진입점: memo_menu.Click [if (day != null) ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52be8444 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9734 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c3b8a95 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9751 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-66544676 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9776 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-829f4c74 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9802 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0fe6d2f2 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9804 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-1fcb8191 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9807 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-46a118e1 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9809 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-04a875ed | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9809 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3e67938 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9810 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-9939acda | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9812 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-c7b48847 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9814 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-77b32d6c | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9826 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cdc1a7e | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9826 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ef4f5ce | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9846 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e97eae30 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9847 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-346a5750 | memo_menu.Click [if (day != null) ▸ if (day != null)] 외 1 | FP00595_Plan_Amend_Line_Elec.cs:9849 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e57b1601 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8537 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f31923b6 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8542 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-e40e3927 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8543 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-f049e853 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8544 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc1906dd | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8545 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 70) | 데이터 객체 조작/조회 |  |  |  |
| AC-17466648 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8546 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 200) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f99ea8 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8547 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-827133a2 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8552 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-ef3bbab6 | tbNickName.BeforeOpenSearch | FP00595_Plan_Amend_Line_Elec.cs:8553 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6340852f | tbNickName.OnSearchConditionChanged | FP00595_Plan_Amend_Line_Elec.cs:8560 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICKNAME", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46626e72 | tbNickName.OnSearchConditionChanged | FP00595_Plan_Amend_Line_Elec.cs:8561 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e28d4d7d | tbNickName.OnSearchConditionChanged | FP00595_Plan_Amend_Line_Elec.cs:8567 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-e1329e00 | tbNickName.OnSearchConditionChanged | FP00595_Plan_Amend_Line_Elec.cs:8571 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.TextValue | 행/컬럼 값 대입 |  |  |  |
| AC-e61e1d8c | tbNickName.OnSearchConditionChanged | FP00595_Plan_Amend_Line_Elec.cs:8573 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.UIFindData

진입점: line_change_menu.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd453e7d | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1245 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9249e740 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1246 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7652d1a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1249 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ec1d2257 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1254 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f31c3d05 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1258 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d6400176 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1264 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3167f680 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1265 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0edba9fb | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1268 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2a2deff5 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1277 | try | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-4a0cdd54 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1277 | try | DATA_OP | Filter["FP_PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-7ed3fdd5 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1285 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-86bf6ce8 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1288 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88477527 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1301 | try ▸ try | FLAG | sVERSION_YN | dtInstance.Lookup("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN").ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d9264ff4 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1301 | try ▸ try | CALL_EXT | dtInstance.Lookup | ("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6139bea | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1302 | try ▸ try | DATA_OP | Filter["VERSION_YN"] | sVERSION_YN | 행/컬럼 값 대입 |  |  |  |
| AC-e64bdd83 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1305 | try ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595", "find_isPDS", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] \| FP\Planning\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-90e54041 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1306 | try ▸ try | DATA_OP | Filter["IS_PDS"] | (dtPDS.getColumn(0, "IS_PDS")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-01b96f51 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1306 | try ▸ try | DATA_OP | dtPDS.getColumn | (0, "IS_PDS") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6293fab4 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1316 | try ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-07ddcb47 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1322 | try ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3e1ae459 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1323 | try ▸ try | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6752a34a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1328 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1b738a1a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1329 | try ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-acc92a1c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1333 | try ▸ try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78f7bb9c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1339 | try ▸ try | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-7e8dea73 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1347 | try ▸ try | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d64abde | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1348 | try ▸ try | DATA_OP | Filter2["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef5272b0 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1349 | try ▸ try | DATA_OP | Filter2["CTRL_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fdb76053 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1350 | try ▸ try | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67ac6c2b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1352 | try ▸ try ▸ if (Filter2["PROD_TYPE"] == "") | DATA_OP | Filter2["PROD_TYPE"] | Filter2["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ffa880fb | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1354 | try ▸ try ▸ if (Filter2["TOP_ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | " AND A.TOP_ITEM_ID LIKE '%' + @TOP_ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-9439c839 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1356 | try ▸ try ▸ if (Filter2["ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_ITEM_ID"] | " AND A.ITEM_ID LIKE '%' + @ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-8bfbdf46 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1361 | try ▸ try | UI_PROP | asyncProxy_Nick.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b6cbfc8b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1383 | try ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-809495f2 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1385 | try ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-23781cd4 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1400 | try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8e4c02fd | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1401 | try ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a4b97d8 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1401 | try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f76393b9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1410 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_MM_", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b598c491 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1411 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53126070 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1412 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-66fbe899 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1413 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98888d42 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1414 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-137e8c88 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1415 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd59f33b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1417 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9104cd9f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1418 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e1361d6 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1419 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d018ba56 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1420 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bf66564 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1421 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-41ac4687 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1423 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0b2a75f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1424 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-28fc9a38 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1425 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d15feb8 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1426 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fafdb992 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1427 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9401ac55 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1428 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e6a3888 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1429 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-134d03cf | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1430 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b49b81b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1432 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b961ccca | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1433 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a594d09f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1434 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18cdf36b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1435 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fefad9a4 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1436 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7aceb49 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1437 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5853d362 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1438 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec07c3ff | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1439 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ad227f5 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1441 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14195ec9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1442 | try ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c55c170 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1449 | try ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) case "P_MPP_IN_BATCH": | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7287b3cf | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1452 | try ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) case "P_WPP_IN_BATCH": | DATA_OP | row["RELEASE_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-47c5ece8 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1455 | try ▸ try ▸ if (dsMain.Good()) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) default: | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-95e106f9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1483 | try ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8b31b6ba | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1491 | try ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-471741a2 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1496 | try ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8c041cb3 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1497 | try ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b3b98925 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1506 | try ▸ try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a396fd8c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1510 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-04282bcd | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1512 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e830223c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1513 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-caa20144 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1514 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-498defd9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1515 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e9fa9702 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1519 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-596cf6c5 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1521 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c2a4e24 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1522 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d6fe780b | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1523 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4c18bd9c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1524 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-819b81b9 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1542 | try ▸ try ▸ try ▸ if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3008640f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1563 | try ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25f38d12 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1567 | try ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-46b1561c | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1573 | try ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0990169a | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1580 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a908615d | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1581 | try ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4920a260 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1592 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1c8b062f | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1598 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c0bfbff | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1602 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-43ced388 | line_change_menu.Click [if (frm.DialogResult == DialogResult… 외 9 | FP00595_Plan_Amend_Line_Elec.cs:1606 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00595_Plan_Amend_Line_Elec.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-809a7f5a | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3785 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-27585be2 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3787 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-72e90bf4 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3788 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c31a299e | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3792 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_success == true) | MESSAGE | MessageBox.Show | ("Data saved", "Save result") | 메시지 표시 |  |  |  |
| AC-3b9ef7c0 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3796 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ else of (save_success == t… | MESSAGE | MessageBox.Show | ("Data not saved", "Save result") | 메시지 표시 |  |  |  |
| AC-10e19d58 | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3804 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-da6d8b8f | SaveButton | FP00595_Plan_Amend_Line_Elec.cs:3808 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0e6242e | .ctor | FP00595_RowExcelPopup.cs:158 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-60d3e07b | .ctor | FP00595_RowExcelPopup.cs:159 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c2383d56 | .ctor | FP00595_RowExcelPopup.cs:160 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-b4021f54 | .ctor | FP00595_RowExcelPopup.cs:161 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-94ff9fb8 | .ctor | FP00595_RowExcelPopup.cs:162 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00595_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a57fda4f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:236 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c00eff48 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:237 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-070c96ad | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:238 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e41a4f37 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:239 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bb3f0316 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:241 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-7438f4a0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:241 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0881c3b7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:242 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-746907c6 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:242 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-59d30d50 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:243 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-624b6271 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:243 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d3d92b2c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:244 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6229ec3 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:244 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-94953ee6 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:253 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-a4b157cd | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:254 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-8f75910a | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:255 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-1f9d56d8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00595_RowExcelPopup.cs:256 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00595_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1404f73 | this.btnClose.Click | FP00595_RowExcelPopup.cs:929 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d31ceb8 | this.btnDownload.Click | FP00595_RowExcelPopup.cs:909 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-41d0e099 | this.btnDownload.Click | FP00595_RowExcelPopup.cs:910 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00595_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28c227c7 | this.btnFind.Click | FP00595_RowExcelPopup.cs:900 | if (string.IsNullOrWhiteSpace(sStartDate) \|\| int.Parse(sStartDate) > int.Parse(dateRange.Value1.Date.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-52410736 | this.btnFind.Click | FP00595_RowExcelPopup.cs:901 | if (string.IsNullOrWhiteSpace(sStartDate) \|\| int.Parse(sStartDate) > int.Parse(dateRange.Value1.Date.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e29b4f75 | this.Load | FP00595_RowExcelPopup.cs:284 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-515e6e9c | this.Load | FP00595_RowExcelPopup.cs:285 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8f42733f | this.Load | FP00595_RowExcelPopup.cs:286 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_RowExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be52693 | dateRange.ValueChanged | FP00595_RowExcelPopup.cs:934 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a84ac37b | dateRange.ValueChanged | FP00595_RowExcelPopup.cs:935 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00595_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0da386d | (진입점 미연결) | FP00595_RowExcelPopup.cs:864 |  | CALL_EXT | ExcelService.CommonDefaultLineCheckReleaseExcept | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83f1ec03 | (진입점 미연결) | FP00595_RowExcelPopup.cs:864 |  | RETURN | return ExcelService.CommonDefaultLineCheckReleaseExcept(row, KeyColumnList, Colu… |  | 처리 중단/반환 |  |  |  |

## FP00595_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9020ea75 | this.Load | FP00595_RowExcelPopup.cs:279 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90c70043 | Dispose | FP00595_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba5d7c5d | (진입점 미연결) | FP00595_RowExcelPopup.cs:750 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00595_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1930fe98 | FindButton | FP00595_RowExcelPopup.cs:327 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f1ed0b41 | FindButton | FP00595_RowExcelPopup.cs:328 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9b1922fd | FindButton | FP00595_RowExcelPopup.cs:330 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cf21093 | this.Load 외 2 | FP00595_RowExcelPopup.cs:357 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c37e201e | this.Load 외 2 | FP00595_RowExcelPopup.cs:358 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-40774690 | this.Load 외 2 | FP00595_RowExcelPopup.cs:358 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c774cd7 | this.Load 외 2 | FP00595_RowExcelPopup.cs:362 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-19040b5b | this.Load 외 2 | FP00595_RowExcelPopup.cs:363 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b2762bae | this.Load 외 2 | FP00595_RowExcelPopup.cs:365 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-88264eab | this.Load 외 2 | FP00595_RowExcelPopup.cs:366 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5478e807 | this.Load 외 2 | FP00595_RowExcelPopup.cs:367 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-16be68d7 | this.Load 외 2 | FP00595_RowExcelPopup.cs:368 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ae4a9cf9 | this.Load 외 2 | FP00595_RowExcelPopup.cs:369 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-45d2d425 | this.Load 외 2 | FP00595_RowExcelPopup.cs:370 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d9371e15 | this.Load 외 2 | FP00595_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c1b8235 | this.Load 외 2 | FP00595_RowExcelPopup.cs:382 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-583f2637 | this.Load 외 2 | FP00595_RowExcelPopup.cs:384 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-a5e69db0 | this.Load 외 2 | FP00595_RowExcelPopup.cs:385 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-819b7061 | this.Load 외 2 | FP00595_RowExcelPopup.cs:386 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-028d0dd7 | this.Load 외 2 | FP00595_RowExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a28440e3 | this.Load 외 2 | FP00595_RowExcelPopup.cs:391 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88c95336 | this.Load 외 2 | FP00595_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-309241e2 | this.Load 외 2 | FP00595_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ccbece65 | this.Load 외 2 | FP00595_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-7ae6ea5e | this.Load 외 2 | FP00595_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ad6c94e | this.Load 외 2 | FP00595_RowExcelPopup.cs:394 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderFromDataSource(siMain, set, Co… | ⚠ 의미 확인 필요 |  |  |  |
| AC-08404ca6 | this.Load 외 2 | FP00595_RowExcelPopup.cs:396 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-20bb5835 | this.Load 외 2 | FP00595_RowExcelPopup.cs:396 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-4c21f0f7 | this.Load 외 2 | FP00595_RowExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-f17d1d7b | this.Load 외 2 | FP00595_RowExcelPopup.cs:403 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-79bb4b1e | this.Load 외 2 | FP00595_RowExcelPopup.cs:404 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-c10422fc | this.Load 외 2 | FP00595_RowExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8de3b002 | this.Load 외 2 | FP00595_RowExcelPopup.cs:410 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a445d97 | this.Load 외 2 | FP00595_RowExcelPopup.cs:414 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1a4fa9a5 | this.Load 외 2 | FP00595_RowExcelPopup.cs:417 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f279467c | this.Load 외 2 | FP00595_RowExcelPopup.cs:420 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3b843f2 | this.Load 외 2 | FP00595_RowExcelPopup.cs:423 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-780a953d | this.Load 외 2 | FP00595_RowExcelPopup.cs:426 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c742858 | this.Load 외 2 | FP00595_RowExcelPopup.cs:438 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set.Good() && ColumnColor.Count > 0) ▸ foreach (var m in ColumnColor.Data) ▸ if (c!=null) ▸ i… | GRID_STYLE | siMain.SetBGColor | (0, colIndex, rowcount-1, colIndex, c) | 그리드 표시 설정 |  |  |  |
| AC-1bdf8279 | this.Load 외 2 | FP00595_RowExcelPopup.cs:442 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-43541975 | this.Load 외 2 | FP00595_RowExcelPopup.cs:451 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-651e2185 | this.Load 외 2 | FP00595_RowExcelPopup.cs:454 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9fa6db3c | this.Load 외 2 | FP00595_RowExcelPopup.cs:455 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1cd44858 | this.Load 외 2 | FP00595_RowExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bcd5aa97 | this.Load 외 2 | FP00595_RowExcelPopup.cs:457 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-25be5ef7 | this.Load 외 2 | FP00595_RowExcelPopup.cs:458 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0542ebf8 | this.Load 외 2 | FP00595_RowExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00595_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d885fc2b | this.Load | FP00595_RowExcelPopup.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb879f57 | this.Load | FP00595_RowExcelPopup.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44fcd049 | (진입점 미연결) | FP00595_RowExcelPopup.cs:724 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-d249a028 | (진입점 미연결) | FP00595_RowExcelPopup.cs:725 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-8217f106 | (진입점 미연결) | FP00595_RowExcelPopup.cs:726 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-df44baa3 | (진입점 미연결) | FP00595_RowExcelPopup.cs:727 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-fe6fbb68 | (진입점 미연결) | FP00595_RowExcelPopup.cs:728 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-0b1442b5 | (진입점 미연결) | FP00595_RowExcelPopup.cs:729 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-7f27c609 | (진입점 미연결) | FP00595_RowExcelPopup.cs:730 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-683b297f | (진입점 미연결) | FP00595_RowExcelPopup.cs:732 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-a1016053 | (진입점 미연결) | FP00595_RowExcelPopup.cs:733 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-613c45cf | (진입점 미연결) | FP00595_RowExcelPopup.cs:737 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c8ccc07b | (진입점 미연결) | FP00595_RowExcelPopup.cs:738 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00595_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28d9cc42 | this.Load | FP00595_RowExcelPopup.cs:212 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-10e27900 | this.Load | FP00595_RowExcelPopup.cs:213 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-84e9de2e | this.Load | FP00595_RowExcelPopup.cs:217 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-78294a77 | this.Load | FP00595_RowExcelPopup.cs:218 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-6ac8bfec | this.Load | FP00595_RowExcelPopup.cs:221 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b387105c | this.Load | FP00595_RowExcelPopup.cs:222 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0960abab | this.Load | FP00595_RowExcelPopup.cs:226 |  | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00595_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba6346ff | this.Load | FP00595_RowExcelPopup.cs:296 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e543e6d | this.Load | FP00595_RowExcelPopup.cs:297 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-232a9573 | (진입점 미연결) | FP00595_RowExcelPopup.cs:317 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d415a5c0 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:762 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-86134975 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:762 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ebdf25b | this.btnUpload.Click | FP00595_RowExcelPopup.cs:764 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d427b922 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:765 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-df9a47a4 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:766 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc0d84d4 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:768 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-df1da26e | this.btnUpload.Click | FP00595_RowExcelPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c64e3ab | this.btnUpload.Click | FP00595_RowExcelPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9676dbf0 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:780 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-668a97c1 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:782 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8485ee67 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:785 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-644ceeda | this.btnUpload.Click | FP00595_RowExcelPopup.cs:786 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2db1bfb5 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:790 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1b1e207 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:791 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bac96536 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:803 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4f59b28 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:807 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3f02ed4c | this.btnUpload.Click | FP00595_RowExcelPopup.cs:819 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaa0376f | this.btnUpload.Click | FP00595_RowExcelPopup.cs:822 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d7f2997 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:825 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8889fdb | this.btnUpload.Click | FP00595_RowExcelPopup.cs:829 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aa13945 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:831 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-073aaee8 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:836 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-998822dc | this.btnUpload.Click | FP00595_RowExcelPopup.cs:838 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-4b40b5f5 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:844 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ec739af0 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:849 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-77aab3e2 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:853 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5d93851e | this.btnUpload.Click | FP00595_RowExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4f175f46 | this.btnUpload.Click | FP00595_RowExcelPopup.cs:857 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00595_RowExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-849af076 | this.radioMPP.CheckedChanged | FP00595_RowExcelPopup.cs:941 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-64a41592 | this.radioMPP.CheckedChanged | FP00595_RowExcelPopup.cs:943 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00595_RowExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7357f5a | this.radioWPP.CheckedChanged | FP00595_RowExcelPopup.cs:950 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-790adbbc | this.radioWPP.CheckedChanged | FP00595_RowExcelPopup.cs:952 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00595_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9865ded0 | this.btnSave.Click | FP00595_RowExcelPopup.cs:473 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (radioMPP.Checked == true) | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c642a743 | this.btnSave.Click | FP00595_RowExcelPopup.cs:475 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-89fbdb70 | this.btnSave.Click | FP00595_RowExcelPopup.cs:479 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb6c25e1 | this.btnSave.Click | FP00595_RowExcelPopup.cs:484 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-2d2c05b0 | this.btnSave.Click | FP00595_RowExcelPopup.cs:485 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ab47a48 | this.btnSave.Click | FP00595_RowExcelPopup.cs:489 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-0549f195 | this.btnSave.Click | FP00595_RowExcelPopup.cs:490 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-331dc207 | this.btnSave.Click | FP00595_RowExcelPopup.cs:494 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a700306 | this.btnSave.Click | FP00595_RowExcelPopup.cs:494 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-811d3a39 | this.btnSave.Click | FP00595_RowExcelPopup.cs:499 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93a03bc8 | this.btnSave.Click | FP00595_RowExcelPopup.cs:500 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-784f1846 | this.btnSave.Click | FP00595_RowExcelPopup.cs:501 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f5077587 | this.btnSave.Click | FP00595_RowExcelPopup.cs:502 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4a0f86fc | this.btnSave.Click | FP00595_RowExcelPopup.cs:503 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4491bc26 | this.btnSave.Click | FP00595_RowExcelPopup.cs:504 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b595494d | this.btnSave.Click | FP00595_RowExcelPopup.cs:512 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d674f5d | this.btnSave.Click | FP00595_RowExcelPopup.cs:515 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1424940 | this.btnSave.Click | FP00595_RowExcelPopup.cs:517 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-1752e593 | this.btnSave.Click | FP00595_RowExcelPopup.cs:520 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-2505fb20 | this.btnSave.Click | FP00595_RowExcelPopup.cs:525 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-60053228 | this.btnSave.Click | FP00595_RowExcelPopup.cs:526 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-4ca0d02d | this.btnSave.Click | FP00595_RowExcelPopup.cs:533 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-85c7cbef | this.btnSave.Click | FP00595_RowExcelPopup.cs:534 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6843e93d | this.btnSave.Click | FP00595_RowExcelPopup.cs:535 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b9b34257 | this.btnSave.Click | FP00595_RowExcelPopup.cs:536 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-487b3179 | this.btnSave.Click | FP00595_RowExcelPopup.cs:537 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a9021e5 | this.btnSave.Click | FP00595_RowExcelPopup.cs:538 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-603d8ff3 | this.btnSave.Click | FP00595_RowExcelPopup.cs:539 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fda21eb1 | this.btnSave.Click | FP00595_RowExcelPopup.cs:540 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bfb2a92f | this.btnSave.Click | FP00595_RowExcelPopup.cs:543 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ef513caa | this.btnSave.Click | FP00595_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac12f807 | this.btnSave.Click | FP00595_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-369a10a3 | this.btnSave.Click | FP00595_RowExcelPopup.cs:582 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-f014b531 | this.btnSave.Click | FP00595_RowExcelPopup.cs:584 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-732e7673 | this.btnSave.Click | FP00595_RowExcelPopup.cs:587 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-14f8a267 | this.btnSave.Click | FP00595_RowExcelPopup.cs:589 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) … | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f029e0f | this.btnSave.Click | FP00595_RowExcelPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e79d9995 | this.btnSave.Click | FP00595_RowExcelPopup.cs:596 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e320b33 | this.btnSave.Click | FP00595_RowExcelPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8dd1a10b | this.btnSave.Click | FP00595_RowExcelPopup.cs:603 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6296de91 | this.btnSave.Click | FP00595_RowExcelPopup.cs:605 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e615bec5 | this.btnSave.Click | FP00595_RowExcelPopup.cs:608 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-49767b26 | this.btnSave.Click | FP00595_RowExcelPopup.cs:612 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c8ec8fa | this.btnSave.Click | FP00595_RowExcelPopup.cs:625 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe8aa1a | this.btnSave.Click | FP00595_RowExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e61a5d6 | this.btnSave.Click | FP00595_RowExcelPopup.cs:629 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcd0d5f8 | this.btnSave.Click | FP00595_RowExcelPopup.cs:633 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-115c0ce8 | this.btnSave.Click | FP00595_RowExcelPopup.cs:648 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-7a76ccaf | this.btnSave.Click | FP00595_RowExcelPopup.cs:649 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0da661f4 | this.btnSave.Click | FP00595_RowExcelPopup.cs:653 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-4af991f5 | this.btnSave.Click | FP00595_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f5a80fe6 | this.btnSave.Click | FP00595_RowExcelPopup.cs:660 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-5d33200e | this.btnSave.Click | FP00595_RowExcelPopup.cs:682 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-74c3ccbf | this.btnSave.Click | FP00595_RowExcelPopup.cs:683 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-66dc8e6a | this.btnSave.Click | FP00595_RowExcelPopup.cs:684 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-296d5c3e | this.btnSave.Click | FP00595_RowExcelPopup.cs:690 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-ee365873 | this.btnSave.Click | FP00595_RowExcelPopup.cs:694 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-51abb790 | this.btnSave.Click | FP00595_RowExcelPopup.cs:700 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:"+e.Message )) | 메시지 표시 |  |  |  |
| AC-001c89a9 | this.btnSave.Click | FP00595_RowExcelPopup.cs:701 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-500919f2 | this.btnSave.Click | FP00595_RowExcelPopup.cs:706 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-542b3e98 | this.btnSave.Click | FP00595_RowExcelPopup.cs:707 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-815567d4 | this.btnSave.Click | FP00595_RowExcelPopup.cs:708 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2de59421 | this.btnSave.Click | FP00595_RowExcelPopup.cs:709 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-83a19764 | this.btnSave.Click | FP00595_RowExcelPopup.cs:710 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5afdb8ad | this.btnSave.Click | FP00595_RowExcelPopup.cs:711 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00595_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b4fc112 | this.Load | FP00595_RowExcelPopup.cs:309 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eab7f0aa | this.Load | FP00595_RowExcelPopup.cs:310 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00595_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10fe097d | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:264 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-bd911df1 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:265 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0948f618 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:266 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-e17ee1f8 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:270 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-2e0839c8 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:271 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-6b8820db | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00595_RowExcelPopup.cs:272 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00595_SetupColor_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-143fa322 | (진입점 미연결) | FP00595_SetupColor_Popup.cs:332 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ccc305a8 | (진입점 미연결) | FP00595_SetupColor_Popup.cs:335 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a6fdec37 | (진입점 미연결) | FP00595_SetupColor_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_SetupColor_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e492527 | this.Load | FP00595_SetupColor_Popup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d013e383 | this.Load | FP00595_SetupColor_Popup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-91f65d39 | this.Load | FP00595_SetupColor_Popup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_SetupColor_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3ee7990 | this.Load | FP00595_SetupColor_Popup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_SetupColor_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a9d5331 | Dispose | FP00595_SetupColor_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_SetupColor_Popup.Find_Data_Line

진입점: this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e2d0e68 | this.Load [try] 외 2 | FP00595_SetupColor_Popup.cs:277 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_SetupColor_P", Filter.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-55f872c4 | this.Load [try] 외 2 | FP00595_SetupColor_Popup.cs:307 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-044417c8 | this.Load [try] 외 2 | FP00595_SetupColor_Popup.cs:311 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_SetupColor_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2043031b | this.Load 외 2 | FP00595_SetupColor_Popup.cs:211 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a347e5f3 | this.Load 외 2 | FP00595_SetupColor_Popup.cs:230 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-aac45d87 | this.Load 외 2 | FP00595_SetupColor_Popup.cs:231 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-96d8a981 | this.Load 외 2 | FP00595_SetupColor_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) | GRID_SET | siMain.ActiveSheet.Cells[i, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-aa3ea94e | this.Load 외 2 | FP00595_SetupColor_Popup.cs:241 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) ▸ if (bgColor.Good()) | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4108c99 | this.Load 외 2 | FP00595_SetupColor_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) ▸ if (bgColor.Good()) | GRID_STYLE | siMain.SetBGColor | (i, 1, i, 1, bg) | 그리드 표시 설정 |  |  |  |
| AC-15886273 | this.Load 외 2 | FP00595_SetupColor_Popup.cs:245 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-161cfd0f | this.Load 외 2 | FP00595_SetupColor_Popup.cs:267 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00595_SetupColor_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aefd0558 | this.Load | FP00595_SetupColor_Popup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e1d5faa4 | this.Load | FP00595_SetupColor_Popup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_SetupColor_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc01dc2 | this.Load | FP00595_SetupColor_Popup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5afe0b0d | this.Load | FP00595_SetupColor_Popup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_SetupColor_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a6d3a1d | (진입점 미연결) | FP00595_SetupColor_Popup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_SetupColor_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-802dee24 | this.Load | FP00595_SetupColor_Popup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cba0aa2b | this.Load | FP00595_SetupColor_Popup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-9b93d0e0 | this.Load | FP00595_SetupColor_Popup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_SetupColor_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-639a935c | this.spdMain.CellClick | FP00595_SetupColor_Popup.cs:347 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-95d498a4 | this.spdMain.CellClick | FP00595_SetupColor_Popup.cs:348 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ec08ef41 | this.spdMain.CellClick | FP00595_SetupColor_Popup.cs:351 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_SetupColor_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88e95e8b | this.spdMain.CellDoubleClick | FP00595_SetupColor_Popup.cs:357 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-36f65dcf | this.spdMain.CellDoubleClick | FP00595_SetupColor_Popup.cs:358 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8859802e | this.spdMain.CellDoubleClick | FP00595_SetupColor_Popup.cs:361 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-679643d7 | this.spdMain.CellDoubleClick | FP00595_SetupColor_Popup.cs:364 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00595_VersionPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a2c3f95 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_VersionPopup.cs:337 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-8b3728b7 | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_VersionPopup.cs:340 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-982c43dd | this.btnButtonList.UsrButtonList_Click_Detected | FP00595_VersionPopup.cs:341 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00595_VersionPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0b6ffed | this.Load | FP00595_VersionPopup.cs:141 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-af7eedc9 | this.Load | FP00595_VersionPopup.cs:142 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7fa312d5 | this.Load | FP00595_VersionPopup.cs:143 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00595_VersionPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91a51b0a | this.Load | FP00595_VersionPopup.cs:136 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00595_VersionPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4de8ab01 | Dispose | FP00595_VersionPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00595_VersionPopup.Find_Data_Line

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find: ▸ try ▸ lambda] / this.Load [try ▸ lambda] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5b4f148 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:301 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_addline", sSql, Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_VersionList \|\| find_Vers… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f4a17cd4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:302 | try | RETURN | return dsLines; |  | 처리 중단/반환 |  |  |  |
| AC-5d38b1de | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:306 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00595_VersionPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d957f1ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:216 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70e14f22 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:226 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bbe876e2 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:233 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9f30b90e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:236 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a696c36 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a3c12e41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:246 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-b4967f58 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP00595_VersionPopup.cs:252 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00595_VersionPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9d507a2 | this.Load | FP00595_VersionPopup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d0a52e8 | this.Load | FP00595_VersionPopup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00595_VersionPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7169eaf3 | this.Load | FP00595_VersionPopup.cs:125 |  | VALUE_SET | txtFactory.Text | Filter["FACTORY_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-b1743255 | this.Load | FP00595_VersionPopup.cs:126 |  | VALUE_SET | txtMaterial.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-662f12c5 | this.Load | FP00595_VersionPopup.cs:127 |  | VALUE_SET | txtLine.Text | Filter["LINE_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-fe818351 | this.Load | FP00595_VersionPopup.cs:128 |  | STATE | txtFactory.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-79df98c2 | this.Load | FP00595_VersionPopup.cs:129 |  | STATE | txtMaterial.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e940408c | this.Load | FP00595_VersionPopup.cs:130 |  | STATE | txtLine.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00595_VersionPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67e98ed8 | this.Load | FP00595_VersionPopup.cs:153 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6628521 | this.Load | FP00595_VersionPopup.cs:154 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_VersionPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a01a03a5 | (진입점 미연결) | FP00595_VersionPopup.cs:175 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00595_VersionPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dfd84d1 | this.Load | FP00595_VersionPopup.cs:160 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfcd0b8d | this.Load | FP00595_VersionPopup.cs:161 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-fbfc2f69 | this.Load | FP00595_VersionPopup.cs:165 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00595_VersionPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1da5817e | this.spdMain.CellClick | FP00595_VersionPopup.cs:352 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-73af701b | this.spdMain.CellClick | FP00595_VersionPopup.cs:353 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-24bc54f6 | this.spdMain.CellClick | FP00595_VersionPopup.cs:356 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00595_VersionPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3fdc368 | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:362 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b1955e52 | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:363 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b4be35bc | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:366 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-6037b780 | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:369 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc4b38e5 | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:374 | if (this.dtFindData.Rows[e.Row][DefColumns.ACTIVE_FLAG].ToString() != "Y") | MESSAGE | MessageBox.Show | ("The inactive version cannot be selected.") | 메시지 표시 |  |  |  |
| AC-6591f20d | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:375 | if (this.dtFindData.Rows[e.Row][DefColumns.ACTIVE_FLAG].ToString() != "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1816abd0 | this.spdMain.CellDoubleClick | FP00595_VersionPopup.cs:385 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

