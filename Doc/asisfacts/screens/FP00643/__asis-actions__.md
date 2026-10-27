# AS-IS 액션 대조표 — FP00643

> 원천: `Doc/asisfacts/screens/FP00643/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 3137행 · 메서드 309 · 종류 DATA_OP 1301 · RETURN 251 · UI_PROP 247 · FLAG 235 · CALL_EXT 183 · UI_MISC 127 · MESSAGE 118 · STATE 95 · ENDPOINT 91 · VALUE_SET 88 · GRID_INIT 84 · POPUP 74 · GRID_SET 74 · GRID_STYLE 28 · THROW 26 · CALL_BASE 22 · COMBO_DATA 18 · VALUE_CLEAR 17 · GRID_LOCK 15 · LIST_REBIND 12 · FOCUS 11 · GRID_BIND 9 · LIST_BIND 5 · EXCEL 5 · STATE_RESET 1 · ⚠ 의미 확인 필요 205


## FP00643_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d825fe4 | .ctor | FP00643_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7e5ab46a | .ctor | FP00643_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-def76eee | .ctor | FP00643_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e02faef4 | .ctor | FP00643_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00643_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: this.chk_week.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e104affa | this.chk_week.CheckedChanged | FP00643_BucketSetForm_Popup.cs:236 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-49fba9aa | this.chk_week.CheckedChanged | FP00643_BucketSetForm_Popup.cs:238 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00643_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50362f80 | Dispose | FP00643_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99289ec8 | this.Load | FP00643_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00643_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-599eacda | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-40e76675 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce302d7a | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e1e5e1f | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0bb6469 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d718403 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-410af35e | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-dd869fc8 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-db7de75a | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00643_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c509afe3 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d0f8d150 | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-89c745cf | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-60aa7d5e | this.Load 외 1 | FP00643_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00643_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b36f33c | (진입점 미연결) | FP00643_BucketSetForm_Popup.cs:228 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-1246e814 | (진입점 미연결) | FP00643_BucketSetForm_Popup.cs:230 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-debd201b | this.Load | FP00643_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aaebc399 | this.Load | FP00643_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70feb4ec | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-79445141 | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-827bbacc | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-d2604448 | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-70e2828d | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-4b3b4abb | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e45f9079 | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-a05da066 | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:222 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-1a0e3550 | this.usrButton1.Click | FP00643_BucketSetForm_Popup.cs:223 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-686fd014 | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-52f063cb | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-961aeb75 | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-2193b5c5 | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-219750ed | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-927fc351 | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-bef5eb4a | this.usrButton2.Click | FP00643_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_CapaSync_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc73ff6 | (진입점 미연결) | FP00643_CapaSync_Popup.cs:324 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ff59bce3 | (진입점 미연결) | FP00643_CapaSync_Popup.cs:327 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-77de0b06 | (진입점 미연결) | FP00643_CapaSync_Popup.cs:328 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_CapaSync_Popup.btnCapaSync_Click

진입점: this.btnCapaSync.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4d11b07 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:394 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(start_date)) | MESSAGE | MessageBox.Show | ("Enter[Start Date].") | 메시지 표시 |  |  |  |
| AC-6db15996 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:395 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(start_date)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d60a6678 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:399 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(end_date)) | MESSAGE | MessageBox.Show | ("Enter[End Date].") | 메시지 표시 |  |  |  |
| AC-b6eebc14 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:400 | for (i< cnt) ▸ if (row !=null) ▸ if (yn == "Y") ▸ if (string.IsNullOrWhiteSpace(end_date)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ae6fda0 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:409 | if (CanSave == false) | MESSAGE | MessageBox.Show | ("Select the line to run.") | 메시지 표시 |  |  |  |
| AC-892db86d | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:410 | if (CanSave == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8579080c | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:426 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_isEngineRunning", Filter.Dictionary , "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isEngineRunning] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a747ffa3 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:430 | if (dsRunning.Good()) | MESSAGE | MessageBox.Show | ("Engine is Running.\r\n: " + dsRunning.Tables[0].Rows[0]["PLAN_ID"].ToString()) | 메시지 표시 |  |  |  |
| AC-56ba7146 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:431 | if (dsRunning.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-611c5261 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:434 |  | DATA_OP | dtFindData.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e9ea32f3 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:442 | for (i> 0) ▸ if (yn == "N") | DATA_OP | updateTable.Rows.RemoveAt | (i - 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ec4aebe | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:446 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["ACTIVE_FLAG"] | "1" | 행/컬럼 값 대입 |  |  |  |
| AC-53572b7b | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:447 | for (i> 0) ▸ else of (yn == "N") | CALL_EXT | DateUtil_FP.GetDigitDate | (row["START_DATE"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2a8091d1 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:448 | for (i> 0) ▸ else of (yn == "N") | CALL_EXT | DateUtil_FP.GetDigitDate | (row["END_DATE"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3f42298 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:449 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["START_DATE"] | start_date | 행/컬럼 값 대입 |  |  |  |
| AC-ba33ef23 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:450 | for (i> 0) ▸ else of (yn == "N") | DATA_OP | row["END_DATE"] | end_date | 행/컬럼 값 대입 |  |  |  |
| AC-3b0a9fb9 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:455 | try | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_row", "update_capaSync_1", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=update_capaSync_1] \| FP\Pla… | 엔드포인트 호출 |  |  |  |
| AC-43eb344a | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:456 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00595_row", "update_capaSync_2", updateTable, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_capaSync_2] \| FP\Plannin… | 엔드포인트 호출 |  |  |  |
| AC-b1ca8e5d | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:457 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP00595_row", "execute_capaSync", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_capaSync] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-e7489480 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:461 | catch ((Exception exce)) | MESSAGE | MessageBox.Show | (exce.ToString()) | 메시지 표시 |  |  |  |
| AC-88719a87 | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:462 | catch ((Exception exce)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72af60aa | this.btnCapaSync.Click | FP00643_CapaSync_Popup.cs:466 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## FP00643_CapaSync_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0677a8f | this.Load | FP00643_CapaSync_Popup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f0dfcbb9 | this.Load | FP00643_CapaSync_Popup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3a48adf | this.Load | FP00643_CapaSync_Popup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_CapaSync_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e142efb | this.Load | FP00643_CapaSync_Popup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_CapaSync_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e682d656 | Dispose | FP00643_CapaSync_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_CapaSync_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfea7a3a | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:259 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_capaSync", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_capaSync] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38187f2c | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:269 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ try | DATA_OP | row["START_DATE"] | date | 행/컬럼 값 대입 |  |  |  |
| AC-5a96b2cd | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:278 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ try | DATA_OP | row["END_DATE"] | date | 행/컬럼 값 대입 |  |  |  |
| AC-92d6f677 | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:283 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ if (row["ACTIVE_FLAG"].ToString() == "1") | DATA_OP | row["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-c299652b | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:285 | try ▸ if (ret.Good()) ▸ foreach (DataRow row in ret.Tables[0].Rows) ▸ else of (row["ACTIVE_FLAG"].ToString() == "1") | DATA_OP | row["ACTIVE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c3a893bb | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:289 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-6f967069 | this.Load [try ▸ lambda] 외 2 | FP00643_CapaSync_Popup.cs:293 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_CapaSync_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fcfd61f | this.Load 외 2 | FP00643_CapaSync_Popup.cs:211 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1967ee90 | this.Load 외 2 | FP00643_CapaSync_Popup.cs:221 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e254de5 | this.Load 외 2 | FP00643_CapaSync_Popup.cs:228 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-317cc3b3 | this.Load 외 2 | FP00643_CapaSync_Popup.cs:232 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.SwitchLock | (6,8) | 그리드 편집 잠금 전환 |  |  |  |
| AC-e00519eb | this.Load 외 2 | FP00643_CapaSync_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-362530b7 | this.Load 외 2 | FP00643_CapaSync_Popup.cs:243 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-6979bfe1 | this.Load 외 2 | FP00643_CapaSync_Popup.cs:249 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00643_CapaSync_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e089d11f | this.Load | FP00643_CapaSync_Popup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-83b2b318 | this.Load | FP00643_CapaSync_Popup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_CapaSync_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f32e5af0 | this.Load | FP00643_CapaSync_Popup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3168d86 | this.Load | FP00643_CapaSync_Popup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_CapaSync_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dd1e8ee | (진입점 미연결) | FP00643_CapaSync_Popup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_CapaSync_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2196937 | this.Load | FP00643_CapaSync_Popup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd95bca8 | this.Load | FP00643_CapaSync_Popup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-c9cf1bdf | this.Load | FP00643_CapaSync_Popup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00643_CapaSync_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a90f6101 | this.spdMain.CellClick | FP00643_CapaSync_Popup.cs:339 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-92a11719 | this.spdMain.CellClick | FP00643_CapaSync_Popup.cs:340 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a81e937d | this.spdMain.CellClick | FP00643_CapaSync_Popup.cs:343 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00643_CapaSync_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-563602ab | this.spdMain.CellDoubleClick | FP00643_CapaSync_Popup.cs:349 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e996a3 | this.spdMain.CellDoubleClick | FP00643_CapaSync_Popup.cs:350 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3ad2be30 | this.spdMain.CellDoubleClick | FP00643_CapaSync_Popup.cs:353 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-bb1f46d3 | this.spdMain.CellDoubleClick | FP00643_CapaSync_Popup.cs:356 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_CapaSync_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange / spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7c694f3 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:492 | if (planDate == null) | MESSAGE | MessageBox.Show | ("I need Plan Date") | 메시지 표시 |  |  |  |
| AC-f661e812 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:493 | if (planDate == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3004313e | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:512 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter Start Date") | 메시지 표시 |  |  |  |
| AC-65c10b5c | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:518 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (startDate.V… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-f91912a3 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:524 | if (row != null) ▸ switch (colName) case "START_DATE": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_start_date | 컨트롤 값 설정 |  |  |  |
| AC-fe6ecf6d | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:545 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter [Start Date]") | 메시지 표시 |  |  |  |
| AC-ba8e5f9f | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:551 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (string.IsNull… | MESSAGE | MessageBox.Show | ("Enter [End Date]") | 메시지 표시 |  |  |  |
| AC-aeb15af2 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:557 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (string.I… | MESSAGE | MessageBox.Show | ("It cannot be less than [Start Date].") | 메시지 표시 |  |  |  |
| AC-b4a4a03e | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:562 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (string.I… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-0f9c5a0e | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:568 | if (row != null) ▸ switch (colName) case "END_DATE": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_end_date | 컨트롤 값 설정 |  |  |  |
| AC-ea9e7311 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:595 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ if (string.IsNullOrEmpty(start_date) \|\| startDate == null) | MESSAGE | MessageBox.Show | ("Enter [Start Date]") | 메시지 표시 |  |  |  |
| AC-26962f2b | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:601 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ if (string.IsN… | MESSAGE | MessageBox.Show | ("Enter [End Date]") | 메시지 표시 |  |  |  |
| AC-ca69a92a | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:607 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (strin… | MESSAGE | MessageBox.Show | ("It cannot be less than [Start Date].") | 메시지 표시 |  |  |  |
| AC-fae637a6 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:612 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ else of (string.IsNullOrEmpty(start_date) \|\| startDate == null) ▸ else of (strin… | MESSAGE | MessageBox.Show | ("You can choose from the start date of the plan.") | 메시지 표시 |  |  |  |
| AC-da5685f8 | this.spdMain.EditChange 외 1 | FP00643_CapaSync_Popup.cs:619 | if (row != null) ▸ switch (colName) case "ACTIVE_FLAG": ▸ if (revert) | VALUE_SET | e.EditingControl.Text | org_yn | 컨트롤 값 설정 |  |  |  |

## FP00643_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88f7c787 | .ctor | FP00643_ExcelPopup.cs:152 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f337c36 | .ctor | FP00643_ExcelPopup.cs:153 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0bc13814 | .ctor | FP00643_ExcelPopup.cs:154 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-bef0b4ff | .ctor | FP00643_ExcelPopup.cs:155 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ff762337 | .ctor | FP00643_ExcelPopup.cs:156 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00643_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-708852de | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:230 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-28b63ba6 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:231 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bee67749 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:232 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2ea81c71 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:233 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4fac23 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:235 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-7b55c96e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:235 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f9c4ac2f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:236 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-5fc64da0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:236 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6e921d81 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:237 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-b3a31f5b | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:237 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2b445bb0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:238 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-c61c89f1 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e60be49a | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:247 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-fb82bae8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:248 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-d8a7e10d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:249 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-e040e326 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_ExcelPopup.cs:250 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00643_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-575fd273 | this.btnClose.Click | FP00643_ExcelPopup.cs:1011 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdf9e90a | this.btnDownload.Click | FP00643_ExcelPopup.cs:993 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-db15b87b | this.btnDownload.Click | FP00643_ExcelPopup.cs:994 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00643_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-125138e0 | this.btnFind.Click | FP00643_ExcelPopup.cs:984 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b0abd56 | this.btnFind.Click | FP00643_ExcelPopup.cs:985 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5212bf02 | this.Load | FP00643_ExcelPopup.cs:278 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-70dfee41 | this.Load | FP00643_ExcelPopup.cs:279 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9657bb29 | this.Load | FP00643_ExcelPopup.cs:280 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_ExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df0850e4 | dateRange.ValueChanged | FP00643_ExcelPopup.cs:1016 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-aa6189ed | dateRange.ValueChanged | FP00643_ExcelPopup.cs:1017 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00643_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-491bd26b | (진입점 미연결) | FP00643_ExcelPopup.cs:947 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbae3cb8 | (진입점 미연결) | FP00643_ExcelPopup.cs:947 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00643_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5863a02f | this.Load | FP00643_ExcelPopup.cs:273 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a881ca71 | Dispose | FP00643_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bdbc1f7 | (진입점 미연결) | FP00643_ExcelPopup.cs:832 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1612857 | FindButton | FP00643_ExcelPopup.cs:321 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c0c6121c | FindButton | FP00643_ExcelPopup.cs:322 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4be161c2 | FindButton | FP00643_ExcelPopup.cs:324 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-033e9e6e | this.Load 외 2 | FP00643_ExcelPopup.cs:351 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44ea3493 | this.Load 외 2 | FP00643_ExcelPopup.cs:352 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-f4da2184 | this.Load 외 2 | FP00643_ExcelPopup.cs:352 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1922fd52 | this.Load 외 2 | FP00643_ExcelPopup.cs:356 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2c2cb106 | this.Load 외 2 | FP00643_ExcelPopup.cs:357 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cd8e8925 | this.Load 외 2 | FP00643_ExcelPopup.cs:359 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-37bc4739 | this.Load 외 2 | FP00643_ExcelPopup.cs:360 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-886231d1 | this.Load 외 2 | FP00643_ExcelPopup.cs:361 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-16329160 | this.Load 외 2 | FP00643_ExcelPopup.cs:362 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0a6669d9 | this.Load 외 2 | FP00643_ExcelPopup.cs:363 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f8441cc7 | this.Load 외 2 | FP00643_ExcelPopup.cs:364 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-21fad6fb | this.Load 외 2 | FP00643_ExcelPopup.cs:371 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-28177d45 | this.Load 외 2 | FP00643_ExcelPopup.cs:376 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a0ddc18 | this.Load 외 2 | FP00643_ExcelPopup.cs:378 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-386f1c55 | this.Load 외 2 | FP00643_ExcelPopup.cs:379 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-75a64619 | this.Load 외 2 | FP00643_ExcelPopup.cs:380 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7904c1f2 | this.Load 외 2 | FP00643_ExcelPopup.cs:382 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-afff80da | this.Load 외 2 | FP00643_ExcelPopup.cs:385 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4094817c | this.Load 외 2 | FP00643_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-4847f378 | this.Load 외 2 | FP00643_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9a7672bd | this.Load 외 2 | FP00643_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-0e57b148 | this.Load 외 2 | FP00643_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4bf618d4 | this.Load 외 2 | FP00643_ExcelPopup.cs:390 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7f1c380f | this.Load 외 2 | FP00643_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-aa223adc | this.Load 외 2 | FP00643_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3a8cbfc | this.Load 외 2 | FP00643_ExcelPopup.cs:400 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-7fd955a8 | this.Load 외 2 | FP00643_ExcelPopup.cs:401 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-a2d34d44 | this.Load 외 2 | FP00643_ExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-5274f553 | this.Load 외 2 | FP00643_ExcelPopup.cs:408 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-74929d54 | this.Load 외 2 | FP00643_ExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b41f280 | this.Load 외 2 | FP00643_ExcelPopup.cs:413 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ea268813 | this.Load 외 2 | FP00643_ExcelPopup.cs:422 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20de85aa | this.Load 외 2 | FP00643_ExcelPopup.cs:425 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf4a1280 | this.Load 외 2 | FP00643_ExcelPopup.cs:428 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d569aead | this.Load 외 2 | FP00643_ExcelPopup.cs:432 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7183ca10 | this.Load 외 2 | FP00643_ExcelPopup.cs:434 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-2a38b0a2 | this.Load 외 2 | FP00643_ExcelPopup.cs:439 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c66e1605 | this.Load 외 2 | FP00643_ExcelPopup.cs:441 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-9380afee | this.Load 외 2 | FP00643_ExcelPopup.cs:447 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f0812d5 | this.Load 외 2 | FP00643_ExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-19e3ff02 | this.Load 외 2 | FP00643_ExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7c6f329f | this.Load 외 2 | FP00643_ExcelPopup.cs:460 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e6a3173c | this.Load 외 2 | FP00643_ExcelPopup.cs:461 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c1ca5ac3 | this.Load 외 2 | FP00643_ExcelPopup.cs:462 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0620758a | this.Load 외 2 | FP00643_ExcelPopup.cs:463 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d3e0bd7b | this.Load 외 2 | FP00643_ExcelPopup.cs:464 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00643_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea48b075 | this.Load | FP00643_ExcelPopup.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d99b3ef5 | this.Load | FP00643_ExcelPopup.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cae8f19d | this.Load | FP00643_ExcelPopup.cs:206 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-8c3e4856 | this.Load | FP00643_ExcelPopup.cs:207 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-3b7f4221 | this.Load | FP00643_ExcelPopup.cs:211 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-5b21e957 | this.Load | FP00643_ExcelPopup.cs:212 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-9a301650 | this.Load | FP00643_ExcelPopup.cs:215 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-eaa452a6 | this.Load | FP00643_ExcelPopup.cs:216 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-806024e3 | this.Load | FP00643_ExcelPopup.cs:220 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00643_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d59dade | this.Load | FP00643_ExcelPopup.cs:290 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-54c40591 | this.Load | FP00643_ExcelPopup.cs:291 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b319ed5b | (진입점 미연결) | FP00643_ExcelPopup.cs:311 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07f94c86 | this.btnUpload.Click | FP00643_ExcelPopup.cs:844 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-36c7e863 | this.btnUpload.Click | FP00643_ExcelPopup.cs:844 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d4881ae | this.btnUpload.Click | FP00643_ExcelPopup.cs:845 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d012ddaa | this.btnUpload.Click | FP00643_ExcelPopup.cs:846 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-82bb8ff9 | this.btnUpload.Click | FP00643_ExcelPopup.cs:847 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15ce84c9 | this.btnUpload.Click | FP00643_ExcelPopup.cs:849 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-30d0c591 | this.btnUpload.Click | FP00643_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-68cf530f | this.btnUpload.Click | FP00643_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8e5c2bb | this.btnUpload.Click | FP00643_ExcelPopup.cs:861 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3dd722b1 | this.btnUpload.Click | FP00643_ExcelPopup.cs:862 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1dc46caa | this.btnUpload.Click | FP00643_ExcelPopup.cs:865 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-de251e88 | this.btnUpload.Click | FP00643_ExcelPopup.cs:866 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-29907c65 | this.btnUpload.Click | FP00643_ExcelPopup.cs:871 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-102e8252 | this.btnUpload.Click | FP00643_ExcelPopup.cs:872 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52503f1d | this.btnUpload.Click | FP00643_ExcelPopup.cs:884 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33ef2bf0 | this.btnUpload.Click | FP00643_ExcelPopup.cs:888 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a2bab58c | this.btnUpload.Click | FP00643_ExcelPopup.cs:900 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b6c09bc | this.btnUpload.Click | FP00643_ExcelPopup.cs:903 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfeefb07 | this.btnUpload.Click | FP00643_ExcelPopup.cs:906 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dafcc4e8 | this.btnUpload.Click | FP00643_ExcelPopup.cs:910 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51a3a4a5 | this.btnUpload.Click | FP00643_ExcelPopup.cs:912 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-caf243dc | this.btnUpload.Click | FP00643_ExcelPopup.cs:917 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.##########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fc5aa1f | this.btnUpload.Click | FP00643_ExcelPopup.cs:919 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-dbb32a63 | this.btnUpload.Click | FP00643_ExcelPopup.cs:925 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ab36e242 | this.btnUpload.Click | FP00643_ExcelPopup.cs:930 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-4d3000e8 | this.btnUpload.Click | FP00643_ExcelPopup.cs:934 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2eddc31d | this.btnUpload.Click | FP00643_ExcelPopup.cs:935 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-34b05515 | this.btnUpload.Click | FP00643_ExcelPopup.cs:938 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00643_ExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-805822e7 | this.radioMPP.CheckedChanged | FP00643_ExcelPopup.cs:1023 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-885a7e81 | this.radioMPP.CheckedChanged | FP00643_ExcelPopup.cs:1025 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00643_ExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5964299 | this.radioWPP.CheckedChanged | FP00643_ExcelPopup.cs:1032 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ccd337f4 | this.radioWPP.CheckedChanged | FP00643_ExcelPopup.cs:1034 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00643_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95d11839 | this.btnSave.Click | FP00643_ExcelPopup.cs:567 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (radioMPP.Checked == true) | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-573a26b6 | this.btnSave.Click | FP00643_ExcelPopup.cs:569 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-db896ed1 | this.btnSave.Click | FP00643_ExcelPopup.cs:573 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3f65a2c4 | this.btnSave.Click | FP00643_ExcelPopup.cs:578 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-0c36d130 | this.btnSave.Click | FP00643_ExcelPopup.cs:579 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffdba95b | this.btnSave.Click | FP00643_ExcelPopup.cs:583 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-1ea10bfc | this.btnSave.Click | FP00643_ExcelPopup.cs:584 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40981e8b | this.btnSave.Click | FP00643_ExcelPopup.cs:588 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-330ec5ca | this.btnSave.Click | FP00643_ExcelPopup.cs:588 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-36d209cb | this.btnSave.Click | FP00643_ExcelPopup.cs:593 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f27a970e | this.btnSave.Click | FP00643_ExcelPopup.cs:594 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e58e1a8d | this.btnSave.Click | FP00643_ExcelPopup.cs:595 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3cc4f2e0 | this.btnSave.Click | FP00643_ExcelPopup.cs:596 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-58267e92 | this.btnSave.Click | FP00643_ExcelPopup.cs:597 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-91648c6c | this.btnSave.Click | FP00643_ExcelPopup.cs:598 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-43270564 | this.btnSave.Click | FP00643_ExcelPopup.cs:606 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-124d2909 | this.btnSave.Click | FP00643_ExcelPopup.cs:609 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f8f719c | this.btnSave.Click | FP00643_ExcelPopup.cs:611 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-156b0379 | this.btnSave.Click | FP00643_ExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8941258 | this.btnSave.Click | FP00643_ExcelPopup.cs:619 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-d34afec0 | this.btnSave.Click | FP00643_ExcelPopup.cs:620 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-23eb3c9f | this.btnSave.Click | FP00643_ExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-57cba198 | this.btnSave.Click | FP00643_ExcelPopup.cs:628 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-915f16dc | this.btnSave.Click | FP00643_ExcelPopup.cs:629 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4c848c2b | this.btnSave.Click | FP00643_ExcelPopup.cs:630 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7d63a76b | this.btnSave.Click | FP00643_ExcelPopup.cs:631 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c6529e69 | this.btnSave.Click | FP00643_ExcelPopup.cs:632 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-57c9f7a7 | this.btnSave.Click | FP00643_ExcelPopup.cs:633 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-def35222 | this.btnSave.Click | FP00643_ExcelPopup.cs:634 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41fa5c5c | this.btnSave.Click | FP00643_ExcelPopup.cs:637 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5e0f6509 | this.btnSave.Click | FP00643_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a25788f | this.btnSave.Click | FP00643_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-39623270 | this.btnSave.Click | FP00643_ExcelPopup.cs:675 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-fddcebb2 | this.btnSave.Click | FP00643_ExcelPopup.cs:677 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-136cf2ba | this.btnSave.Click | FP00643_ExcelPopup.cs:680 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-19254c22 | this.btnSave.Click | FP00643_ExcelPopup.cs:685 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-85ef6c53 | this.btnSave.Click | FP00643_ExcelPopup.cs:687 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a3d75c2 | this.btnSave.Click | FP00643_ExcelPopup.cs:690 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3bda577f | this.btnSave.Click | FP00643_ExcelPopup.cs:694 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5c46453 | this.btnSave.Click | FP00643_ExcelPopup.cs:696 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-301044ad | this.btnSave.Click | FP00643_ExcelPopup.cs:699 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf6f0b81 | this.btnSave.Click | FP00643_ExcelPopup.cs:703 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-adaca948 | this.btnSave.Click | FP00643_ExcelPopup.cs:716 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-95b4ec21 | this.btnSave.Click | FP00643_ExcelPopup.cs:718 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a89cee0 | this.btnSave.Click | FP00643_ExcelPopup.cs:720 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-92a52b0c | this.btnSave.Click | FP00643_ExcelPopup.cs:724 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-226fa872 | this.btnSave.Click | FP00643_ExcelPopup.cs:740 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-65534690 | this.btnSave.Click | FP00643_ExcelPopup.cs:745 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-3f8ebd3c | this.btnSave.Click | FP00643_ExcelPopup.cs:746 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d0bbe963 | this.btnSave.Click | FP00643_ExcelPopup.cs:752 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-f1553aa2 | this.btnSave.Click | FP00643_ExcelPopup.cs:759 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-3697e8fe | this.btnSave.Click | FP00643_ExcelPopup.cs:790 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-1eeed1fa | this.btnSave.Click | FP00643_ExcelPopup.cs:792 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-627740f5 | this.btnSave.Click | FP00643_ExcelPopup.cs:793 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-897cf87a | this.btnSave.Click | FP00643_ExcelPopup.cs:804 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:" + e.Message)) | 메시지 표시 |  |  |  |
| AC-3f4ad0c3 | this.btnSave.Click | FP00643_ExcelPopup.cs:805 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-66b194fa | this.btnSave.Click | FP00643_ExcelPopup.cs:810 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c618eddc | this.btnSave.Click | FP00643_ExcelPopup.cs:811 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-222b5866 | this.btnSave.Click | FP00643_ExcelPopup.cs:812 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e7368a5 | this.btnSave.Click | FP00643_ExcelPopup.cs:813 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-05d2f409 | this.btnSave.Click | FP00643_ExcelPopup.cs:814 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-78c51835 | this.btnSave.Click | FP00643_ExcelPopup.cs:815 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00643_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1766402 | this.Load | FP00643_ExcelPopup.cs:303 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d027b4c2 | this.Load | FP00643_ExcelPopup.cs:304 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00643_ExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d81e1b08 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:258 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9912ba08 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:259 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8ce7bc70 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:260 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-abcc52e5 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:264 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e81fe826 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:265 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b89b784b | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_ExcelPopup.cs:266 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00643_InvDetail_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e14deb0 | (진입점 미연결) | FP00643_InvDetail_Popup.cs:340 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d00d585f | (진입점 미연결) | FP00643_InvDetail_Popup.cs:343 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ec913628 | (진입점 미연결) | FP00643_InvDetail_Popup.cs:344 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_InvDetail_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-448cf55a | this.Load | FP00643_InvDetail_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2925a948 | this.Load | FP00643_InvDetail_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eeb7cda9 | this.Load | FP00643_InvDetail_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_InvDetail_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dc82fa4 | this.Load | FP00643_InvDetail_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_InvDetail_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3f5d252 | Dispose | FP00643_InvDetail_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_InvDetail_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24b6f270 | ExcelButton | FP00643_InvDetail_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00643_InvDetail_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb35a55f | this.Load [try ▸ lambda] 외 2 | FP00643_InvDetail_Popup.cs:268 | try ▸ if (Filter["POP_TYPE"].ToString() == "RECEIPT") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_BOH_Detail_Receipt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail_Receipt] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-22bb3193 | this.Load [try ▸ lambda] 외 2 | FP00643_InvDetail_Popup.cs:272 | try ▸ else of (Filter["POP_TYPE"].ToString() == "RECEIPT") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_BOH_Detail", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOH_Detail] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0cab7407 | this.Load [try ▸ lambda] 외 2 | FP00643_InvDetail_Popup.cs:305 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2354504e | this.Load [try ▸ lambda] 외 2 | FP00643_InvDetail_Popup.cs:309 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_InvDetail_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-516efeff | this.Load 외 2 | FP00643_InvDetail_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-faa22406 | this.Load 외 2 | FP00643_InvDetail_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-769d8940 | this.Load 외 2 | FP00643_InvDetail_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6b9a2dea | this.Load 외 2 | FP00643_InvDetail_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-96e66746 | this.Load 외 2 | FP00643_InvDetail_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab69bedb | this.Load 외 2 | FP00643_InvDetail_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-d55ba687 | this.Load 외 2 | FP00643_InvDetail_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00643_InvDetail_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-802acec9 | this.Load | FP00643_InvDetail_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b65fe70b | this.Load | FP00643_InvDetail_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_InvDetail_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e20cafc | this.Load | FP00643_InvDetail_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-77d3d915 | this.Load | FP00643_InvDetail_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_InvDetail_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55665610 | (진입점 미연결) | FP00643_InvDetail_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_InvDetail_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf68a38d | this.Load | FP00643_InvDetail_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f74be3c | this.Load | FP00643_InvDetail_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-a3c10dc9 | this.Load | FP00643_InvDetail_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00643_InvDetail_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f94f3163 | this.spdMain.CellClick | FP00643_InvDetail_Popup.cs:355 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-5d0cb6b8 | this.spdMain.CellClick | FP00643_InvDetail_Popup.cs:356 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-153ef84b | this.spdMain.CellClick | FP00643_InvDetail_Popup.cs:359 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00643_InvDetail_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d747ad7f | this.spdMain.CellDoubleClick | FP00643_InvDetail_Popup.cs:365 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-bdd5e667 | this.spdMain.CellDoubleClick | FP00643_InvDetail_Popup.cs:366 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1c69121f | this.spdMain.CellDoubleClick | FP00643_InvDetail_Popup.cs:369 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-fe562d17 | this.spdMain.CellDoubleClick | FP00643_InvDetail_Popup.cs:372 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_InvDetail_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c392229 | this.spdMain.EditChange | FP00643_InvDetail_Popup.cs:499 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_LineCopy_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d884255f | this.Load | FP00643_LineCopy_Popup.cs:148 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3af4cf4a | this.Load | FP00643_LineCopy_Popup.cs:149 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c5950ee4 | this.Load | FP00643_LineCopy_Popup.cs:150 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_LineCopy_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14700988 | this.Load | FP00643_LineCopy_Popup.cs:143 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_LineCopy_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e77b1c94 | Dispose | FP00643_LineCopy_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_LineCopy_Popup.Find_Data_Line

진입점: this.Load [try] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7291d287 | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:265 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_addline", "find_instanceType", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceType] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-92753fe1 | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:268 | try ▸ if (dsK.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dsK.getColumn(0, "CONFIRM_AREA").ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-de09d7da | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:268 | try ▸ if (dsK.Good()) | DATA_OP | dsK.getColumn | (0, "CONFIRM_AREA") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-def54c62 | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:269 | try ▸ if (dsK.Good()) | DATA_OP | Filter["CTRL_CONFIRM_AREA"] | " LEFT OUTER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-f9a9c19d | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:272 | try ▸ if (dsK.Good()) ▸ if (confirm_area == "PLAN GROUP") | DATA_OP | Filter["CTRL_CONFIRM_AREA"] | " INNER JOIN " | 행/컬럼 값 대입 |  |  |  |
| AC-a85339e9 | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:275 | try ▸ if (dsK.Good()) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_linecopyllist", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_linecopyllist] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-73013427 | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:277 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-c2ff5e8b | this.Load [try] 외 1 | FP00643_LineCopy_Popup.cs:281 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_LineCopy_Popup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8ee0b4a | this.Load 외 1 | FP00643_LineCopy_Popup.cs:217 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-41e8db7d | this.Load 외 1 | FP00643_LineCopy_Popup.cs:229 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9ed28778 | this.Load 외 1 | FP00643_LineCopy_Popup.cs:236 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-852efe2f | this.Load 외 1 | FP00643_LineCopy_Popup.cs:244 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-e3c588dd | this.Load 외 1 | FP00643_LineCopy_Popup.cs:249 | catch ((Exception ex)) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-943e8b76 | this.Load 외 1 | FP00643_LineCopy_Popup.cs:250 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-27387124 | this.Load 외 1 | FP00643_LineCopy_Popup.cs:254 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_LineCopy_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8117fdf1 | this.Load | FP00643_LineCopy_Popup.cs:94 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b32c318 | this.Load | FP00643_LineCopy_Popup.cs:96 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a9e14fa9 | this.Load | FP00643_LineCopy_Popup.cs:107 |  | UI_PROP | range_plan.ValueStart | DateTime.ParseExact(Filter["BUCKET_FROM"], "yyyyMMdd", null) | 속성 ValueStart 설정 |  |  |  |
| AC-f094c90e | this.Load | FP00643_LineCopy_Popup.cs:108 |  | UI_PROP | range_plan.ValueEnd | range_plan.ValueStart.AddDays(day_add - 1) | 속성 ValueEnd 설정 |  |  |  |
| AC-921183ea | this.Load | FP00643_LineCopy_Popup.cs:112 |  | STATE | edt_material.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-9e19bcad | this.Load | FP00643_LineCopy_Popup.cs:113 |  | STATE | edt_line.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |
| AC-bd886a35 | this.Load | FP00643_LineCopy_Popup.cs:114 |  | VALUE_SET | edt_line.Text | dtFindData.getColumn(0, "LINE_ID").ToString() | 컨트롤 값 설정 |  |  |  |
| AC-59b089a2 | this.Load | FP00643_LineCopy_Popup.cs:114 |  | DATA_OP | dtFindData.getColumn | (0, "LINE_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9d8c1dd3 | this.Load | FP00643_LineCopy_Popup.cs:115 |  | VALUE_SET | edt_material.Text | Filter["ITEM_ID"] | 컨트롤 값 설정 |  |  |  |

## FP00643_LineCopy_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d50237 | this.Load | FP00643_LineCopy_Popup.cs:160 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49ad0806 | this.Load | FP00643_LineCopy_Popup.cs:161 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_LineCopy_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29eff329 | (진입점 미연결) | FP00643_LineCopy_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_LineCopy_Popup.Range_plan_ValueChanged

진입점: range_plan.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa6943a2 | range_plan.ValueChanged | FP00643_LineCopy_Popup.cs:123 | if (range_plan.ValueStart < plan_date) | MESSAGE | MessageBox.Show | ("The start date can not be less than the plan date.") | 메시지 표시 |  |  |  |
| AC-b3718a99 | range_plan.ValueChanged | FP00643_LineCopy_Popup.cs:124 | if (range_plan.ValueStart < plan_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05c1da76 | range_plan.ValueChanged | FP00643_LineCopy_Popup.cs:128 | else of (range_plan.ValueStart < plan_date) ▸ if (range_plan.ValueEnd < range_plan.ValueStart) | UI_PROP | range_plan.ValueEnd | range_plan.ValueStart.AddDays(day_add - 1) | 속성 ValueEnd 설정 |  |  |  |

## FP00643_LineCopy_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5555d56d | this.Load | FP00643_LineCopy_Popup.cs:167 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3b34e003 | this.Load | FP00643_LineCopy_Popup.cs:168 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7a1c6353 | this.Load | FP00643_LineCopy_Popup.cs:172 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00643_LineCopy_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08e93151 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:308 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-86046aec | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:309 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8f376fd7 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:312 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-b96c23d6 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:313 | if (row != null) | MESSAGE | MessageBox.Show | ("Do you want Line Change", "", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-7ecfc9b5 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:316 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_row", "find_LineCopy_Validation", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineCopy_Validation] \| FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5df39498 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:319 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good()) | DATA_OP | validation.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-85c81e20 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:320 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good()) | CALL_EXT | val.SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7dfb6ce | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:323 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good())… | MESSAGE | MessageBox.Show | ("Priority 0 or 9 exists within the period.") | 메시지 표시 |  |  |  |
| AC-efbed839 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:325 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (validation.Good())… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c337d8b | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:331 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | UI_PROP | batch.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-b653fa22 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:332 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | dsBatch.Tables.Add | (batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4acc2b9 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:362 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6601ae20 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:363 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0de7de22 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:364 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d8275f8 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:365 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-98d112be | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:366 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff90e09c | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:367 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b06a1205 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:368 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58c4ebfb | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:369 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-64fc9bd3 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:370 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1343479 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:371 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13cad2b6 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:372 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a42781e4 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:373 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("NICK_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6910868d | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:374 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f82b779 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:375 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-99996c27 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:376 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("LINE_NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60ea1e4b | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:377 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6700cc1 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:378 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5901693b | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:380 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a5cf7af4 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:381 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8b073ec5 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:382 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("CTRL_OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a091087 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:384 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("PROG_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e701bb72 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:385 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("BUCKET_FROM", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38bc2c90 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:386 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("BUCKET_TO", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7533840c | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:388 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("COPY_FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e37cbfb2 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:389 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | batch.Columns.SafeAdd | ("COPY_LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de128458 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:392 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.CopyData | (dtFindData, batch) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1cc73658 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:394 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.SITE_ID >=", "SITE_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e820e563 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:395 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.PLANT_ID >=", "PLANT_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1079ea9 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:396 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | CALL_EXT | DataService.NullTool | (Filter, "CTRL_", "SA.OPERATION_ID >=", "OPERATION_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3497ea5 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:401 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["COPY_FACTORY_ID"] | bRow["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-47002171 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:402 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["COPY_LINE_ID"] | bRow["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9922267d | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:404 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0551b340 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:406 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4dd11935 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:407 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6810a16e | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:408 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-af63fe11 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:409 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a3b47cbd | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:410 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d16bfb6 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:411 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9123c7a5 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:412 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-444d46a2 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:414 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PRODUCTION_TYPE"] | Filter["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-23c90313 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:415 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["FP_PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-247c5db3 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:416 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["NICK_NAME"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-d6600429 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:417 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["TOP_ITEM_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2e429bb | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:418 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["EQUIPMENT_ID"] | Filter["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bd84f84d | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:419 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["MARKET"] | Filter["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-4fb6ecff | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:421 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["PROG_TYPE"] | "LINE_COPY" | 행/컬럼 값 대입 |  |  |  |
| AC-df424d64 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:422 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["BUCKET_FROM"] | range_plan.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6e0ac750 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:423 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["BUCKET_TO"] | range_plan.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d5454892 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:426 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_SITE_ID"] | Filter["CTRL_SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ccab877 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:427 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_PLANT_ID"] | Filter["CTRL_PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-02351955 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:428 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ foreach (DataRow bRow … | DATA_OP | bRow["CTRL_OPERATION_ID"] | Filter["CTRL_OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-378e698e | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:432 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_row", "merge_LineCopy", batch, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_LineCopy] \| FP\Planning\F… | 엔드포인트 호출 |  |  |  |
| AC-70a8fda6 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:435 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) | DATA_OP | dtRes.getColumn | (0, "RESULT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3a909db2 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:437 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | DATA_OP | dtRes.getColumn | (0, "EXCEPTION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6e0e1460 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:438 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | DATA_OP | dtRes.getColumn | (0, "COUNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e23fe45c | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:440 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | (message) | 메시지 표시 |  |  |  |
| AC-21e7c549 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:443 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | ("0 data saved") | 메시지 표시 |  |  |  |
| AC-8c60c05b | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:447 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | MESSAGE | MessageBox.Show | ("unknown") | 메시지 표시 |  |  |  |
| AC-7e44d3c0 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:449 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ if (dtRes.getColumn(0,… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-80fe4555 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:453 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bbc841b6 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:454 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2483f1cf | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:455 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | ENDPOINT | DataService.FP_RunProcedure | ("FP00595_row", "execute_psiCalcul", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-4f544428 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:456 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a65c69b9 | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:458 | if (row != null) ▸ if (MessageBox.Show("Do you want Line Change", "", MessageBoxButtons.YesNo) == DialogResult.Yes) ▸ else of (dtRes.getColu… | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-cd53b4cf | this.spdMain.CellDoubleClick | FP00643_LineCopy_Popup.cs:466 | if (row != null) ▸ if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3647c3ab | .ctor | FP00643_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-3d9f614e | .ctor | FP00643_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-0e125929 | .ctor | FP00643_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-502b4c88 | .ctor | FP00643_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00643_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc2d8131 | Dispose | FP00643_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab28ef5e | this.Load | FP00643_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00643_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa924f3 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:201 |  | FLAG | data_val | new bool[data_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-47cac771 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:202 |  | FLAG | measure_val | new bool[uom_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-185496b0 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:203 |  | FLAG | total_val | new bool[total_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-9d6646d9 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-820be046 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-b35e3e89 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_result_in) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bcfae74 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ccaeb9d | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9f15a02 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_result_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-b25d3c35 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-a80eed67 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-57e7ffcb | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_seq) | 데이터 객체 조작/조회 |  |  |  |
| AC-cea934e6 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_engine_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4a71a67 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_engine_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-9421b9ba | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-682409d8 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-dca37fa1 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:248 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-35a510cf | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:249 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec965d4f | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-304ebbd3 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:253 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-415076f0 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-920dc962 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_result_in_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f25d326 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-21f6d566 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-fffd6099 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_result_out_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1477242d | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d06d290e | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-38ce9f69 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-eef9d8de | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_off) | 데이터 객체 조작/조회 |  |  |  |
| AC-65174c34 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_setup) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4f9eb2d | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2231275 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_engine_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-24fedf15 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:270 |  | DATA_OP | ctrls.Add | (chk_engine_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-5838c8e1 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_sim) | 데이터 객체 조작/조회 |  |  |  |
| AC-03a3e136 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7f81031 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-283a6284 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:278 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-33d1abd3 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:278 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-39e2c3e3 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:285 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-5a1e2f82 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:289 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-77506ac4 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:293 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00643_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84e6754 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_wpp_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8859fdaf | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_wpp_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d59c271e | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_result_in.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ef29330d | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_mpp_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-56f54be3 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_mpp_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d5feb667 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_result_out.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-89368b0a | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6c04d94a | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0bf324f6 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_seq.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8b05ca48 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_engine_inqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a1227c50 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_engine_outqty.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8ef81c17 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_memo.Text | data_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cc5e6f07 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_pc.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9be167a4 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_jr.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2d3401da | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_cell.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0a1bf4de | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_batch.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-199a7db2 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-485bf7d1 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d3264409 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_result_in_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7f2e307f | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-17f80860 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2658313d | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_result_out_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a9e7d9d2 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3c0385ed | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3f5fb932 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_memo_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6b1010c1 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_off.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8d063bb6 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_setup.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9ab4ed46 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_capa.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-99c5ed6b | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_engine_inqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a0f5833c | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:177 |  | VALUE_SET | chk_engine_outqty_tot.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4f391cb2 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_sim.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b06b6708 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_subTotal.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-be195d15 | this.Load 외 1 | FP00643_MeasureSetForm_Popup.cs:181 |  | VALUE_SET | chk_total.Text | total_p[index++] | 컨트롤 값 설정 |  |  |  |

## FP00643_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c762796 | (진입점 미연결) | FP00643_MeasureSetForm_Popup.cs:353 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ff1158d5 | (진입점 미연결) | FP00643_MeasureSetForm_Popup.cs:355 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fd15d12 | this.Load | FP00643_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1cc3464e | this.Load | FP00643_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48811aca | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d5f66771 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:337 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-fb3d2cb0 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:339 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-1bd92c57 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:343 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-89a71394 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:344 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-aed1ece5 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:346 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6420f308 | this.usrButton1.Click | FP00643_MeasureSetForm_Popup.cs:348 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00643_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5791646f | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-d77e4791 | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-9ef32bea | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:313 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-12900ed8 | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:317 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a45add1b | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:318 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-c9a1e668 | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:319 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7276b976 | this.usrButton2.Click | FP00643_MeasureSetForm_Popup.cs:320 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9d25a72 | .ctor | FP00643_Plan_Amend_Line_PSI_Elec.cs:159 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-c4077496 | .ctor | FP00643_Plan_Amend_Line_PSI_Elec.cs:160 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.ApplyAmendCalendarCondition

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-417950b0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4325 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d83dd702 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4326 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e8088287 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4327 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6d7ec0b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4328 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d40a0465 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4329 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3a29edd3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4332 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-2c77738a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4332 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-12276eb4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4341 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b1a0739e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4342 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-365e0f7b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4344 | if (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-4eef06f8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4344 | if (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-44278579 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4348 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c5a0ca1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4349 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23f3db82 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4351 | else of (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-73c8d9cf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4351 | else of (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ee4fd929 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4353 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-94a5bc7c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4354 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-c11869b1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4368 | if (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-3c4a0dc8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4370 | else of (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-534012f4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4371 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-99728e4b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4372 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-0e0b6fd4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4373 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.ApplySearchCondition

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d473d5e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4379 | if (LocalFilter["INSTANCE_ID"] == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { LocalFilter["INSTANCE_ID"] = CString.GetCheckedListValue(… | ⚠ 의미 확인 필요 |  |  |  |
| AC-21d0988c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4381 | if (LocalFilter["INSTANCE_ID"] == "") ▸ lambda | DATA_OP | LocalFilter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-53fb0886 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4387 |  | DATA_OP | LocalFilter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-15179487 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4388 |  | DATA_OP | LocalFilter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-04e03900 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4389 |  | DATA_OP | LocalFilter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-24180df7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4392 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cbo_fpplanid.SelectedIndex >= 0) { LocalFilter["PLAN_… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8423c2ba | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4396 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | LocalFilter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-ed68a23a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4418 |  | DATA_OP | LocalFilter["MASTER_ID"] | LocalFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.ApplySearchCondition_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a163c48c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10529 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a69be9eb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10530 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b7b01633 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10532 |  | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b47ed3f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10536 | if (Filter["RELEASE_FLAG"] == "Y" \|\| Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["TABLE_NAME"] | "FP_AMEND_SIM_CELL_PACK_H" | 행/컬럼 값 대입 |  |  |  |
| AC-48f99fd6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10540 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ed58834 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10542 |  | DATA_OP | Filter["CHK_PLAN_ID"] | "N" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8306cf6 | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8774 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cc1ddb99 | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8779 |  | POPUP | new FP00643_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-b3231aea | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8780 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0fe49747 | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8781 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-f786068d | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8782 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-397b296b | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8786 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-ad346b11 | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8788 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"] != null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-08e406aa | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8804 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0a5e0326 | this.btn_bucket.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8813 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnCapa_Click

진입점: this.btnCapaSync.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6652238 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8942 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-000091c3 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8943 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07745461 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8949 | if (Filter["FP_PLAN_ID"] == "") | MESSAGE | MessageBox.Show | ("inserts FP Plan ID.") | 메시지 표시 |  |  |  |
| AC-1b5a690a | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8950 | if (Filter["FP_PLAN_ID"] == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e80b12cd | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8952 |  | POPUP | new FP00643_CapaSync_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-4945f229 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8953 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c7a8224c | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8953 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af9864f3 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8954 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-9aa0844f | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8955 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-dd3f3cbb | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8956 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-37c2e482 | this.btnCapaSync.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8959 | if (popup.DialogResult == DialogResult.OK) | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c3ed0ea | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8739 |  | POPUP | new FP00643_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-72168d16 | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8740 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-785cd1a7 | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8741 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-346751d7 | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8742 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7670f25f | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8746 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-da587d84 | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8758 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-56cd56f3 | this.btn_category.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8767 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991ca1cc | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8717 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-40a6cf27 | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8718 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b86e36b5 | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8719 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8f2493a1 | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8726 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-f0e9fb3a | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8726 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85ca4ceb | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8727 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-277de8dc | this.btn_column.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8733 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnCreatePlan_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2015e28 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9018 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-b695871a | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9019 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-8b8d315b | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9026 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ab2b9f99 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9027 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d84b86d | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9037 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP00602_FIND_FP0060 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a4120ba | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9039 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7f60e03b | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9045 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f4809c7 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9046 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddd245c4 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9051 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1bfcd66 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9052 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d8375c22 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9055 |  | DATA_OP | dtParam.Columns.SafeAdd | ("AMEND_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae21a3de | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9056 |  | DATA_OP | dtParam.Columns.SafeAdd | ("FIX_DATE_SYNC", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fec5dd2d | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9057 |  | DATA_OP | dtParam.Columns.SafeAdd | ("SYNC_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c03ca31 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9063 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-54c31132 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9066 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-64933c60 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9067 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-a3013b2a | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9068 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-2c82a07d | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9069 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2586ca2b | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9070 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-80d5721a | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9079 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-9de7ab16 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9079 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-5fc0f4af | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9080 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | FLAG | dtPlanId | DataService.FP_ExecuteProcedure2("PR_UI_" + "FP00602" + "_" + "findFpPlan_info", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-652a0807 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9080 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_" + "FP00602" + "_" + "findFpPlan_info", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b594012 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9081 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4dd75c07 | this.usrButton1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9084 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cbo_fpplanid.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f33f68a | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9462 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-c01c735d | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9463 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-cd61d09d | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9471 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-71eb97e4 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9472 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f961ce8f | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9476 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2e65b9f9 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9477 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-325628e2 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9480 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-e5614b2b | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9481 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e7c7aec | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9486 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-f39c8eea | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9487 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f43455e | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9492 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-c71d1f70 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9493 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa78923e | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9496 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5683921d | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9497 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ee972797 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9497 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-126aa092 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9498 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "ELEC" | 행/컬럼 값 대입 |  |  |  |
| AC-4a1cd3fe | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9499 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-312c1177 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9499 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a63f8d7 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9500 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-4b966bcf | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9501 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-9388b048 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9502 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eee6c6e1 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9503 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-235ffb78 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9504 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5f5870df | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9505 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-50a4b4af | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9506 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e70337d2 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9507 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4ded5ea1 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9508 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-903702e6 | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9510 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ac7a015e | this.btnDppWppCopyDwSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9511 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnDwSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae10988d | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9400 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2a5d6440 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9401 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-edf24e41 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9409 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05e922e9 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9410 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8802d062 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9414 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6a0f3145 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9415 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ea27acc0 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9418 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-be2c32e1 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9419 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6753114 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9424 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-ae300df3 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9425 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09228157 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9430 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-3e560af3 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9431 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfb92500 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9436 |  | UI_PROP | DwSubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-6b4deb2c | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9436 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4bfa3de | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9437 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "ELEC" | 행/컬럼 값 대입 |  |  |  |
| AC-a72cf786 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9438 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-924480fd | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9438 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0ffb2bf1 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9439 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-42de9282 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9440 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-05961cdf | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9441 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7a04afe | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9442 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fc15fab8 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9443 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-263270b8 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9444 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a0ccfb20 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9445 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-dce3daac | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9446 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2509cc2a | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9447 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2d84a378 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9449 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5241ce8a | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9450 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6e996a05 | this.btnDWSubmit.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9453 | if (DwSubmit.ShowDialog() == DialogResult.OK) | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-133962d4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4428 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aeb9651c | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4429 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47a386b0 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4435 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-88d0de1b | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4436 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1906bdb | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4438 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3fa4fd96 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4439 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-86ca50d3 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4440 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8462a1b | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4441 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fa2bee22 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4448 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00643_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-0cae62da | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4451 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f13de5b0 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4451 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-17f5ff5b | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4453 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-be291321 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4454 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.FP00595 | 속성 DateColumnType 설정 |  |  |  |
| AC-5c06f6fe | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4455 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.HeaderLineCount | 3 | 속성 HeaderLineCount 설정 |  |  |  |
| AC-9ef80dfa | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4457 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b2c6481a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4458 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fe577f7a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4459 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-687e8693 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4460 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8d45a779 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4461 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8f34f5dd | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4462 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9f8035ca | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4463 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-47e058f5 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4464 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fcc6383e | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4465 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1cb6903e | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4466 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-000096a5 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4467 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1bd62740 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4468 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | colPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1b35f676 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4469 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2e98c90e | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4470 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0ddb4416 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4474 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-ca5087db | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4475 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-15c28cb8 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4476 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-82e0438a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4477 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-e99fcae1 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4478 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-fda816ec | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4479 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-3ab367a3 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4480 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-a983160d | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4481 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-7a6cf725 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4482 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equiment" | 행/컬럼 값 대입 |  |  |  |
| AC-e6d6cd61 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4483 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-c852e0b4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4484 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-d79cd6ee | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4485 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-580519ef | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4486 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-e140dbd8 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4487 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | colPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-86672b39 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4488 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-e1917cd1 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4489 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-403967a9 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4491 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-15805db6 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4492 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-86a5989f | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4493 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-8280a9f2 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4494 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-4eda9651 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4495 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoImportData | call_Excel_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-a39dcf21 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4496 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4cfa9efa | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4506 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00643_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-fe597366 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4509 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c0ca8e88 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4509 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-66f4f76e | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4512 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4ff134c0 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4513 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.Filter["FACTORY_LT"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-07129529 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4515 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-133d1b17 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4516 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3cdd97c6 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4517 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6a2af2c4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4518 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4a26dedd | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4519 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-23d60ca9 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4521 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-acfbdabc | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4522 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f89759b0 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4523 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-6db41ec0 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4524 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-88a31d44 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4528 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-51c30f88 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4529 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-514bcf12 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4532 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | rowPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-e7e65979 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4533 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f5325d78 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4534 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ade5a12a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4535 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-424dc923 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4537 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ADJUST_IN_QTY_BATCH"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-60f420e4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4538 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SEQ"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-aeb8f23d | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4541 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-4079929b | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4542 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-3bdafad3 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4543 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-2e4891da | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4544 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-72901776 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4545 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-8055fe7a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4547 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-e747dc40 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4548 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-24abf241 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4549 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-847e0456 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4550 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipmnent" | 행/컬럼 값 대입 |  |  |  |
| AC-cf2818a4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4551 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-457cbcfa | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4553 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-f3b492a1 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4554 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-18fdc504 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4555 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-8d68f057 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4556 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-38d964bd | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4557 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-7ae1dd37 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4558 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-2c4cd0a9 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4559 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-d5d5897a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4561 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_M"] | "M(P/C)" | 행/컬럼 값 대입 |  |  |  |
| AC-655201ec | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4562 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_CELL"] | "Cell" | 행/컬럼 값 대입 |  |  |  |
| AC-b8eff4de | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4563 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_JR"] | "M(J/R)" | 행/컬럼 값 대입 |  |  |  |
| AC-c035fa38 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4564 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_BATCH"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-c575008a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4565 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SEQ"] | "Seq" | 행/컬럼 값 대입 |  |  |  |
| AC-720f67ef | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4566 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-93557f09 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4568 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["DIVISION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-9e076829 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4569 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SITE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0a5b20a3 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4570 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLANT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0d483e47 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4571 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["FACTORY_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-59719560 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4572 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["OPERATION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-bd94aca6 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4574 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["LINE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-5eaaaa59 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4576 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ELECTRODE_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-f5be2018 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4577 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["EQUIPMENT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0ded331a | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4578 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ITEM_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-e28f18ca | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4579 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PC_MODEL_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-ec0f44e5 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4580 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["VERSION"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0a9fc6b9 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4581 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnColor["PLM_EC_NO"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-2875b1dd | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4583 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PRODUCTION_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-5ee3eba4 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4584 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["MARKET"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-7529c641 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4585 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLAN_DATE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-1c33d018 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4587 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ADJUST_IN_QTY_BATCH"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-5d1f282d | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4588 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SEQ"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-dfbc7c9c | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4619 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnWidth["COMPANY_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-78ea2565 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4622 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-810a90ab | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4624 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-18f9894b | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4625 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-8c27e06d | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4626 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoImportData | call_Excel_Row_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-e49d5139 | this.btnExcelImport.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:4627 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-766e6e16 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9279 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-3ec4f357 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9280 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-a5088320 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9288 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5cb804d | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9289 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f74c3845 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9294 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-2cca46bc | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9295 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66c6fefe | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9298 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7bbc19d3 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9299 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-0cf93fd4 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9300 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-50e7a69f | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9300 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-539d0c0e | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9301 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-2172271a | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9302 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7d4cb63 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9303 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ec86cb5 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9303 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5b86adc2 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9304 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c40a1dc | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9305 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fe169067 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9306 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-98c38e51 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9307 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-441b5d2c | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9308 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6196d421 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9309 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1a018cbb | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9310 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d399492 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9311 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-61821ba3 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9312 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7ae10270 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9314 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c33627b4 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9315 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-a74b7cff | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9316 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-14cb5b92 | this.btnMemo.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9317 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45309323 | this.btnMenu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9519 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-a36da407 | this.btnMenu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9519 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-231fcb91 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8969 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ffab203f | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8970 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-330138bd | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8978 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92785820 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8979 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6fca7f1 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8984 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-22c2ec84 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8985 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8725b334 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8988 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-d5e75dff | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8989 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49cc62a7 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8994 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-858eccdc | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8995 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95682f43 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9000 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-40ae932f | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9001 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fc60cea | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9005 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-5f87203b | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9006 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c94b39f5 | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9007 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-45c210fc | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9008 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-491bdfaa | this.btnMRP.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9010 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b0a4cfb | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9123 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-183b4d30 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9124 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-d8a1d139 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9131 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f871ca4 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9132 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-306ab811 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9136 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9a196383 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9137 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5af7aca3 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9140 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-518cab27 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9141 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5741982 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9154 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e1ff5b1b | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9155 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b02dd105 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9161 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4fa2983c | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9162 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7f3418e | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9169 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c189c155 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9170 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3add9826 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9173 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-79485784 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9174 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d9ebac50 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9176 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bffb1fa0 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9182 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e1c7c15 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9183 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1762ac5 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9187 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-383f01fa | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9191 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4c11b13 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9192 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3379381 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9199 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73450423 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9200 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b6be04d | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9213 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54549370 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9216 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9599a5f2 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9218 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-135d533f | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9224 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66a2ebd0 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9225 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fee0777 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9238 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1d02f6 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9239 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c697cde | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9251 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a906e953 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9254 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-2604b1a6 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9255 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-3b90767e | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9256 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4e73926c | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9257 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-02105afa | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9265 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-ad904013 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9268 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-2770fafa | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9269 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f99bd851 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9270 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4c218950 | this.btnRelease2.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9271 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnReplan_Click

진입점: this.btnReplan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-158fe948 | this.btnReplan.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9114 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-9f17c524 | this.btnReplan.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9115 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnSetupColor_Click

진입점: this.btnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3be856ae | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9327 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-646f2882 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9328 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-09d5ece3 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9331 |  | POPUP | new FP00643_SetupColor_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-cc32d924 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9332 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e1c09027 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9332 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25e5fc66 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9333 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f684b85d | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9334 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-a98af0c1 | this.btnSetupColor.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9335 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnSimulColumn_Click

진입점: this.btnSimulColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e4c888a | this.btnSimulColumn.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:11135 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00643", SpdSheet.shtSimul, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-84f58a89 | this.btnSimulColumn.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:11137 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-305a9297 | this.btnSimulColumn.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:11138 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a77e18fa | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2439 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-01fdf25d | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2440 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-29253082 | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2443 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP00643_ROW_FIND_FP00643_ROW") | 데이터 객체 조작/조회 |  |  |  |
| AC-c24f60f4 | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2444 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6c28022 | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2445 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY") | 데이터 객체 조작/조회 |  |  |  |
| AC-43045c3e | this.btnSql.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:2446 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f163bed | this.btnToggleSave.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8823 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-e4b0aafc | this.btnToggleSave.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:8825 |  | STATE | panelLog.Visible | !panelLog.Visible | 컨트롤 상태 Visible |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.BuildStockVersion

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0) ▸ try ▸ try] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-440b8922 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10972 |  | CALL_EXT | dsSimulBoh.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-69cb134f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10974 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b111957e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10975 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e07ab9bd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10976 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-856826f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10977 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-2651aea8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10978 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd6091d3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10983 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION_ALL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c8e0d0b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10984 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("WM_VERSION_ALL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d71de1e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10985 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION_SEL", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5139d695 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10989 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION0", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e6bd531 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10990 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION1", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdb3f787 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10991 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION2", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b43eaa6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10992 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION3", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-32234495 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10993 |  | DATA_OP | dsSimulDate.Tables[0].Columns.Add | (new DataColumn("STOCK_VERSION4", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-530602ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11014 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) | DATA_OP | eachVersionLines.Contains | (aver) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eadd0f8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11016 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) ▸ if (!eachVersionLines.Contains(aver)) | DATA_OP | eachVersionLines.Add | (aver) | 데이터 객체 조작/조회 |  |  |  |
| AC-df0dcf3c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11017 | foreach (var group_version in group3) ▸ foreach (var group_rows in group_version) ▸ if (!eachVersionLines.Contains(aver)) | DATA_OP | VersionVsWorkModel.Add | (aver, wm) | 데이터 객체 조작/조회 |  |  |  |
| AC-f10df82b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11028 | foreach (var group_version in group3) ▸ foreach (KeyValuePair<string, string> kvp in VersionVsWorkModel) | DATA_OP | ms.Add | (kvp.Key + ":" + kvp.Value) | 데이터 객체 조작/조회 |  |  |  |
| AC-4660871b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11031 | foreach (var group_version in group3) | CALL_EXT | dsSimulDate.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["… | (r => { r["STOCK_VERSION_ALL"] = v_all; r["STOCK_VERSION_SEL"] = v_all; r["WM_VERSION_ALL"… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b984bf84 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11033 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f90966f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11034 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a65ce1bc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11035 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-254de9f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11036 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc78e707 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11037 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c2fb598 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11042 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["STOCK_VERSION_ALL"] | v_all | 행/컬럼 값 대입 |  |  |  |
| AC-8d745fe1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11043 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["STOCK_VERSION_SEL"] | v_all | 행/컬럼 값 대입 |  |  |  |
| AC-9349d73c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11044 | foreach (var group_version in group3) ▸ lambda | DATA_OP | r["WM_VERSION_ALL"] | match | 행/컬럼 값 대입 |  |  |  |
| AC-ef2b54d3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11050 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0a2e311 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11051 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78fbdc1e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11052 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5cf5c208 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11053 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c17b92c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11054 | foreach (var group_version in group3) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5b9ea36 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11066 | foreach (var group_version in group3) ▸ foreach (DataRow eR in categoryLines) | CALL_EXT | eR["CATEGORY_ID"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e0e00f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11067 | foreach (var group_version in group3) ▸ foreach (DataRow eR in categoryLines) | DATA_OP | cates.Add | (idx, eR) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd97ab1b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11115 | foreach (var group_version in group3) ▸ for (i < lenVersionLines) | DATA_OP | cates.ContainsKey | (cateFinder) | 데이터 객체 조작/조회 |  |  |  |
| AC-f06bfbcc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11122 | foreach (var group_version in group3) ▸ for (i < lenVersionLines) ▸ if (row != null) | DATA_OP | row[colname] | eachVersionLines[i] | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45c444bf | this.button1.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:9543 | if (flo2 != null) | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6605c3a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4849 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-71f06570 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4849 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-28d4551a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4853 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69062c43 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4854 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68a7378f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4864 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-32bea4b7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4864 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-dd81f100 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4866 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-976698c2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4867 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52723b6e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4885 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d36e6c6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4888 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-2de02048 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4892 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cac81324 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4903 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-44a2c869 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4906 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d5693ac3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4910 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-96dffe09 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4919 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-1f269935 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4919 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-7fa61da6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4919 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9c11c674 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4920 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-3ce13b69 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4920 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-00b35003 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4924 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-2a04a028 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4924 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-727e6d71 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4925 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-f1a0ff8e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4941 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-8a11c2f8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4941 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-dd10ae63 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4941 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aef2ddb5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4942 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-0d6dc3a6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4942 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-21a0ec66 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4946 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-a30f8f31 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4946 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-d5ba56fd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4947 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-f4b722de | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4985 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-53bfa674 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4986 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-68c47be9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4987 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-686d5260 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4991 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c611b6f9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4992 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-0a489469 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4993 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-694e82a1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5000 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-025ea116 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5018 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-31f7bebf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5019 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-2243dd9c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5020 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-49b16a4d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5031 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d74d8567 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5031 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18d28c49 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5585 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aab39a58 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5114 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-48d7079b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5120 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-fc632fa0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5121 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-afcf9593 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5124 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-91c163b8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5125 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf4ccede | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5125 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b86ba55f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5128 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c19ca182 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5129 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7bea3ec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5130 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("SEQ", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bf2c277 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5132 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5b47293 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5133 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5493a303 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5134 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae5ce1c2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5135 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd826008 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5137 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-02ae480f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5138 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31447b0f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5139 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2457e59 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5140 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-54a88224 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5142 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-67ca21d9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5143 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32fccd2f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5144 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6255273e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5145 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ef13430d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5173 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7390f27 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5174 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-63cd5410 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5176 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ee785865 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5177 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-08c1b15f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5178 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-d226a1be | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5179 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-f69a3fe0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5181 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-445c59cf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5182 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-559bd2d6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5183 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bf0e2639 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5184 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d13e9a83 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5185 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["OPERATION_ID"] | row["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c399488 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5187 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_ID"] | row["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a201975 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5188 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_NAME"] | row["LINE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-e23e5f58 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5189 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e587227e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5190 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["EQUIPMENT_ID"] | row["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce657a2a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5191 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0af78d3c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5193 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["NICK_NAME"] | row["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-11e68a98 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5194 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b1a8e59d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5195 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LOCATION"] | row["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-7791372c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5196 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-3d9ed63b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5197 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["TOP_ITEM_ID"] | row["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4a08295d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5199 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["USER_ID"] | row["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2e48939e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5201 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PC_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-85788cf4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5202 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-52258cde | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5203 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["VERSION"] | row["VERSION"] | 행/컬럼 값 대입 |  |  |  |
| AC-19662c9c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5204 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLM_EC_NO"] | row["PLM_EC_NO"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce7517c1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5207 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-a7e9f435 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5209 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-490c1328 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5211 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-c523858c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5213 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-9753c00e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5216 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-12be6ba3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5218 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-66138a4a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5220 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-995c0b83 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5222 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-82d1add1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5224 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SEQ"] | RoundValue(row[sSeqCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-2692c60f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5275 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-441d83b6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5276 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-f35d1fb8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5277 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dcd01705 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5277 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-c92e851e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5279 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d512002 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5279 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88685a7a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4652 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9f940f87 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4655 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "EQUIPMENT_ID", "DIVISION_ID", "SITE_ID", "PLA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-36215aea | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4659 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-51b67d06 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4668 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-88ba5078 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4669 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c12161b9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4672 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-45298809 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4676 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-3e367380 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4679 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6e2c858 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5579 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Row_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0aab5016 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5903 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b7dc931 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5903 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-7d07ec68 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5907 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-928b4c9d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5908 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8ab0fe5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5918 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f274460d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5918 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-c9998c8b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5920 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fc93ed3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5921 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-26cb7487 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5939 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c79afb62 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5942 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-1da72e84 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5946 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc522653 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5957 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-249f7439 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5960 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3a89f402 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5964 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-ec867aec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5973 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-2dce4610 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5973 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-e8c80794 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5973 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4cadef59 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5974 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-b4236f10 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5974 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-527f9b0f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5978 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-65980fd4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5978 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-cf3e2c52 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5979 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-f170317a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5995 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-7d5bc8d8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5995 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-1bff7957 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5995 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d4de429 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5996 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-92f36f28 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5996 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4613e7c8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6000 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-d1cd2adf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6000 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-75c11821 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6001 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-565e5566 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6040 | foreach (DataRow row in data.Tables[0].Rows) ▸ if (nInValueOrg == DBNull.Value) | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-7b07b4f2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6044 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ if (nInValueOrg is string && string.IsNullOrWhiteSpac… | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-bb29e9a7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6051 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-ae41fb88 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6069 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-21dc3a90 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6070 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-07b43372 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6071 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-f5fe518e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6082 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-10472b29 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6082 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41c24b04 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5639 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3767e4e5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5644 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-9d94b6b6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5645 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a30e5d43 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5662 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3f195a7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5663 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce2a7a27 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5664 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85bdc4ac | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5665 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6a26a2d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5666 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e99d29ff | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5667 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-425a7eec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5668 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4875777 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5675 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-132fa443 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5676 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18f76361 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5677 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-20e6d9ff | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5678 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5044359e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5679 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62da2675 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5681 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdcb49f1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5682 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b6e0097 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5683 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8a6baa3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5684 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d212167 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5685 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d39dc026 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5686 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f88f971 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5693 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-dbf1e72d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5694 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | mpp_wpp | 행/컬럼 값 대입 |  |  |  |
| AC-13c0cf25 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5695 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | new_seql | 행/컬럼 값 대입 |  |  |  |
| AC-fb0dd77d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5696 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["ROUND_POINT"] | round_point | 행/컬럼 값 대입 |  |  |  |
| AC-9d270c89 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5699 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (qty_val == null) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-086a5647 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5701 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-82d98378 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5703 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b22fd91e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5706 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-108467e1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5707 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-cc2ec6f2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5708 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-eff7a00f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5709 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-6b306562 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5710 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a70367ca | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5711 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-4ec6a3ee | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5712 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-2911a136 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5713 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-447924a2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5714 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-37f60409 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5715 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a9ea8985 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5719 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-41a639e4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5720 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-3b4de7dd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5721 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-26968138 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5722 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-c07a1ed8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5723 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-29b44c9b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5724 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-c349332a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5725 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-0224527d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5726 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-f3ecd1b0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5727 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-97c7653a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5728 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-51942e61 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5736 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0689f7fa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5740 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-0cf9af84 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5741 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-8b865437 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5742 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-b9b85209 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5743 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-6feaa26a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5744 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-05f32da2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5745 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-411f9bd6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5746 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | popup.Filter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-603761e9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5748 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1df6ce2d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5755 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-6c0d7676 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5757 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e2cf595 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5757 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-3bacab15 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5762 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c4c40d8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5762 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |
| AC-b76b56c4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5770 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc3a5bbe | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5772 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e0ddc4eb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5773 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTA… | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-143dbef6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5774 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f64e75e7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5775 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PL… | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-470b11ad | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5778 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-365f295e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5779 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f4f1f1cb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5786 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-af88c43a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5787 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-babc9270 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5788 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-756f3689 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5788 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-db7c9d93 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5790 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-f52942b7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5795 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bed7d72a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5795 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-595f6bd5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5799 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0944df2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5799 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaa012d5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5604 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-df41690c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5607 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e2553b0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5610 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-63161954 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5616 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-dae0b725 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5617 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0c23883d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5618 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c626e447 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5619 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-9dd25a5e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5621 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_EXCEL_2_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c71df848 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5624 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-61d91162 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5627 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-f2dc915b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5630 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e1c7b4a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6095 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5c8efd25 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6099 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-a769ae6d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6102 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-18400a57 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6104 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9145ccb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6105 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("CELL")) | DATA_OP | data.Tables[0].Columns.Add | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f465403b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6106 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7955ca91 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6107 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc30cfcd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6108 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e72682e6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6109 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f2b9f78 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6110 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a02d401 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6111 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | data.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd274703 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6114 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["CELL"] | row["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-7bd203b0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6115 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-049c87d1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6116 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e95a173 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6117 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-909e3dd8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6126 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["QTY"] | row["ADJUST_IN_QTY_BATCH"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3e9d9e4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6130 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf54e665 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6145 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_MPPWPP", "delete_Excel_buffer", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-40cb3d84 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6146 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch | ("FP00595_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-15ccbd3a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6165 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | popup.Filter["INSTANCE_COND"] | tmp_sql | 행/컬럼 값 대입 |  |  |  |
| AC-6c3aefe5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6167 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_MPPWPP", "find_Excel_buffer_validation", popup.Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-65095344 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6184 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-b4035277 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6209 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9cfd41c1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6212 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5fe10f3 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8420 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5b26fe8f | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8423 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f415a5e2 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8424 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5f0d0362 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8425 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5093b80b | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8426 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4ed5ada7 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8427 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f5154ae3 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8430 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1efc1911 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8470 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-801f7eb3 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8472 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0918fa0b | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8473 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6b1194c3 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8474 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5e8ee731 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8475 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-76bcf5ad | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8479 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-686f765e | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8481 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c515cb8 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8482 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8cda3c19 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8483 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-03205350 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8484 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a7c1ea3 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8494 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[selected]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d85cab9 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8495 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[selected]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf859ec2 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8497 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(start_date, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-eec5dda7 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8498 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value2 | DateTime.ParseExact(end_date, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-7c74bb4f | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8499 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f78be79b | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8500 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f966871d | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8507 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e130d896 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8508 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-711769b6 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8515 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-c9cbe6e2 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8516 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-1031ae71 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8517 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-be482648 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8518 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-6ad58a46 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8519 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-f734e93a | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8524 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-c2f20861 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8525 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-901713d8 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8531 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a828a19d | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8532 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0fa808b2 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8533 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6306aeb2 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8534 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7c35a367 | cbo_fpplanid.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8535 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.cbo_plan_group_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2dc089b0 | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8369 | if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | Filter["MASTER_ID"] = instance_id = CString.GetCheckedListValue(dtInstance, cbo_plan_group… | 행/컬럼 값 대입 |  |  |  |
| AC-b418996c | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8369 | if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | instance_id = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-4f2b2062 | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8370 | if (dtInstance.Good()) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6f0aa07e | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8371 | if (dtInstance.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d615d47a | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8372 | if (dtInstance.Good()) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c1ca88b4 | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8381 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1cac7c52 | cbo_plan_group.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8385 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.cboUomType_changed

진입점: cboUomType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fde6bff | cboUomType.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:11433 | if (dsSimulDate != null) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CheckAndGetMeasure

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-129c0b37 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:561 | switch (measureId) default: ▸ if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa772d5a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:561 | switch (measureId) default: ▸ if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-c25085e8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:563 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00643_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bfea71e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:563 | switch (measureId) default: | POPUP | new FP00643_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-d9ae8a8b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:564 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00643_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01cb0266 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:564 | switch (measureId) default: | POPUP | new FP00643_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-c7ebae66 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:566 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-d61ffb51 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:567 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-3ac8aa7b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:568 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-16fbd6f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:569 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-e3dfbd6f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:570 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa028fa1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:571 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-8c76e66f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:572 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-de8538ee | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:573 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.chk_Info_CheckedChanged_1

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9911341 | this.chk_Info.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9527 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-4b86cae4 | this.chk_Info.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9527 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a022d1b | this.chk_Info.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9533 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7cb0d694 | this.chk_Info.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9534 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.chk_omit_zero_CheckedChanged

진입점: chk_omit_zero.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f971e866 | chk_omit_zero.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9709 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a03dc40d | chk_omit_zero.CheckedChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:9711 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CommaList

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ foreach (var group_version in group3) ▸ if (!set_to_empty)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ foreach (var group_version in group3) ▸ if (!set_to_empty)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ foreach (var group_version in group3) ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1398db1b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10565 | if (string.IsNullOrWhiteSpace(list_src)) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-781b25de | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10568 | if (spl == null \|\| spl.Length < 1) | RETURN | return res; |  | 처리 중단/반환 |  |  |  |
| AC-6a3ecf18 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10573 | for (i < spl.Length) ▸ if (!string.IsNullOrWhiteSpace(spl[i])) | DATA_OP | res.Add | (spl[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-99007e7f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10575 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CommaStr

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ foreach (var group_version in group3)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ foreach (var group_version in group3)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ foreach (var group_version in group3)] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e45c8f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10585 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-307328d4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8223 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-25b17dc9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8225 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7d5f763 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8226 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-517057ec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8227 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-afe1acec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8228 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-02754daa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8229 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-964e35fc | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8230 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d226dfd6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8231 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-061fb6e1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8232 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d431d1c1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8233 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb6846d6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8234 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1672f5f0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8235 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-566f1c5b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8236 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f9efc2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8237 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6f5285c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8238 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca61ae35 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8239 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b340ba5d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8240 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bfc131fa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8241 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-91d643dd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8242 |  | DATA_OP | dt.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f13f0c0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8243 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d67c6f12 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8244 |  | DATA_OP | dt.Columns.SafeAdd | ("BOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a776128 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8245 |  | DATA_OP | dt.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5d859e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8246 |  | DATA_OP | dt.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc806b68 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8247 |  | DATA_OP | dt.Columns.SafeAdd | ("SALES_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ee0d00d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8248 |  | DATA_OP | dt.Columns.SafeAdd | ("EOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6264b8f1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8249 |  | DATA_OP | dt.Columns.SafeAdd | ("YIELD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1b5e8a7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8252 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f68fd38 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8253 |  | DATA_OP | dt.Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-74f5cb93 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8254 |  | DATA_OP | dt.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da97b5dc | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8256 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-38544060 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8257 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4953529b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8258 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57cfd69b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8259 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7ad869c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8261 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0499c3aa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8262 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2d974bf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8263 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c7065e7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8264 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1d6ea3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8266 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b69a4fed | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8267 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d07ee32 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8268 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-da42b177 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8269 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9111f040 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8271 |  | DATA_OP | dt.Columns.SafeAdd | ("EIDX", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bbaf582 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8272 |  | DATA_OP | dt.Columns.SafeAdd | ("EQTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-06740f1e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8273 |  | DATA_OP | dt.Columns.SafeAdd | ("EDATE", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1089755 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8275 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d6fdd18 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8276 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0ed2590 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8281 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fd8f931 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8284 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CreateEditDataGridDataSetTmp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-847deb79 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8108 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-77e09d51 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8110 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e1b1b5a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8111 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-05b114ae | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8112 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc5a56be | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8113 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16472cf6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8114 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2db97025 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8116 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82e86874 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8118 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf48e5fd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8119 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e96bef7b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8120 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1cd400b3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8121 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ca224cb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8122 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d09d827 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8123 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-37fde2b4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8124 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc3ab14d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8125 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac7ba3b4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8127 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-945d79ce | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8128 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7fed9b0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8129 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e3816a0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8130 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6e26b49 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8131 |  | DATA_OP | dt.Columns.SafeAdd | ("IS_PREV_SCHEDULE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6af240f7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8134 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-228af4f3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8135 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3478168 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8136 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-748779c7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8137 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c7f77754 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8139 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-470cd602 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8140 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-06622c22 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8141 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82047734 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8142 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49e67af7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8145 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-569b58af | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8146 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b70f63bf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8147 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58de6720 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8148 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad334f23 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8149 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-379f5d1e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8151 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-192641ef | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8152 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-36b606af | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8153 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f435f3d4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8154 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab6d8654 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8155 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec89bbe8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8157 |  | DATA_OP | dt.Columns.SafeAdd | ("TOTAL_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d89fc82f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8159 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a2c3fb9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8160 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-347c66c9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8161 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c802a7d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8162 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a25acd25 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8163 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9840fb19 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8165 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a71ba633 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8166 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9d5c883 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8167 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aac57928 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8168 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-03be4bb5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8169 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34a32213 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8171 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f313751 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8172 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-941c03bf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8173 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-228afcb9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8174 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab2b183c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8175 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-77947577 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8177 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b72df1e7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8178 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-16511395 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8179 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-604fa9ce | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8180 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3701311 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8181 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60e84f5b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8183 |  | DATA_OP | dt.Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f062f67 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8209 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d38b947 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8210 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4973d968 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8215 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-9750c0a7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8218 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CreateFilterDataSet

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1c57ce4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:2485 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-cd74f47b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:2496 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-d036377f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:2497 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-d953cb61 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3498 |  | DATA_OP | dsResult.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d652830 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3501 | for (i < rows.Length) | DATA_OP | rows[i]["_MM_"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-43f2eab1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3507 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-6abddbef | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3511 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e003326f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3514 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-21a0bd4f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3516 | else of (t != null) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-556288b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3516 | else of (t != null) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-2e2542bd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3517 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fd5397e | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:505 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d45caf7e | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:506 |  | GRID_INIT | this.AddSheet | (spdSimul, SpdSheet.shtSimul, SpdSheet.shtSimul, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00e274c8 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:507 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-b5c317d0 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:508 |  | FLAG | siSimul | GetSheetInfo(spdSimul.Name, SpdSheet.shtSimul) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3192fcd | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:509 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d015a951 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:510 |  | GRID_INIT | siSimul.ChangeSheet | (SpdSheet.shtSimul) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.dCalendar_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ab44e64 | dCalendar_planrange.ValueChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8686 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36f7f663 | dCalendar_planrange.ValueChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8693 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-56906622 | dCalendar_planrange.ValueChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8694 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b5b9599 | DeleteButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1569 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11dd4be3 | Dispose | FP00643_Plan_Amend_Line_PSI_Elec.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.DrawHeader

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == Dial…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da549c00 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:900 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-19becf12 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:904 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-123aa609 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:905 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-914e4829 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:906 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2713e92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:907 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1cf9a8ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:908 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-ad80564d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:912 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-62f5cd13 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:913 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2857f4cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:914 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ef688b04 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:915 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-788e70e0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:928 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5ec95e7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:929 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-65de4d92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:935 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-d434f510 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:964 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-268005a7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:970 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-617b7cbe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:972 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d45af724 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:973 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73c9270d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:974 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-38a95062 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:976 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-aa8cd0ff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:978 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-845f89f6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:979 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.DrawHeader_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ if (!dsSimulDate.Good()) ▸ try ▸ if (monthInfo == null \|\| dsSimulDate == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (!dsSimulDate.Good()) ▸ try ▸ if (monthInfo == null \|\| dsSimulDate == null)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-268ab0c8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10927 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-265005be | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10928 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-caa5b245 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10929 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2dc6f2de | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10930 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-2855bfde | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10942 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.SetSheetHeaderColumn_FP | (siSimul, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-47791a5f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10943 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ce2f4e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10944 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ef44d203 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10945 | if (monthInfo != null) ▸ if (with_day_part == false) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-73051e1c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10950 | if (monthInfo != null) ▸ else of (with_day_part == false) | CALL_EXT | siSimul.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-848d71c3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10953 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_INIT | siSimul.SetSheetHeaderFromDataSource | (siSimul, dsSimulFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-58ad2f4d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10954 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_BIND | siSimul.Query | (dsSimulFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8ef10143 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10958 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a245015 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10959 | if (monthInfo != null) ▸ else of (with_day_part == false) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5a93249 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10961 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-589dcc27 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10962 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_INIT | siSimul.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba86ccf1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 19 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10964 | if (monthInfo != null) ▸ else of (with_day_part == false) | GRID_SET | siSimul.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.DrawSheet

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a75eed6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:988 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-df264a17 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:991 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-427c8a22 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:992 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dffc445 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1001 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c10a21e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1007 | if (dsMainFiltered.Good()) ▸ if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-24ce7f00 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1011 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.DrawSheet_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ if (!dsSimulDate.Good()) ▸ try ▸ else of (monthInfo == null \|\| dsSimulDate == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (!dsSimulDate.Good()) ▸ try ▸ else of (monthInfo == null \|\| dsSimulDate == null)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-421cdcbb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10620 |  | UI_PROP | numCell.DecimalPlaces | 1 | 속성 DecimalPlaces 설정 |  |  |  |
| AC-4ae2a719 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10621 |  | UI_PROP | numCell.Separator | "," | 속성 Separator 설정 |  |  |  |
| AC-6bf11c37 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10622 |  | UI_PROP | numCell.ShowSeparator | true | 속성 ShowSeparator 설정 |  |  |  |
| AC-d751c96e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10624 |  | CALL_EXT | siSimul.SetRightMerge | (siSimul.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-83089c39 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10630 | if (idx > 0) | CALL_EXT | siSimul.SetRightMerge | (idx, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e827cc5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10633 |  | GRID_BIND | siSimul.Query | (dsSimulFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-414f2975 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10634 |  | CALL_EXT | siSimul.SetMergeRange | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5225beae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10645 |  | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1fb78d8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10657 | if (dsSimulFiltered.Good()) ▸ if (!siSimul.SpreadObject.IsLayoutSuspended) | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ba1c9b0e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10665 | if (dsSimulFiltered.Good()) ▸ for (i < 5) | DATA_OP | version_colname[i] | string.Format("STOCK_VERSION{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-08d54bbf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10666 | if (dsSimulFiltered.Good()) ▸ for (i < 5) | DATA_OP | version_colidx[i] | siSimul.GetColumnIndex(version_colname[i]) | 행/컬럼 값 대입 |  |  |  |
| AC-5cd20166 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10677 | if (dsSimulFiltered.Good()) | CALL_EXT | FPExtensions.ColorFromName | (selColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c08f4f5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10678 | if (dsSimulFiltered.Good()) | CALL_EXT | FPExtensions.ColorFromName | (deColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-380e0152 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10696 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (all_match != nu… | DATA_OP | VerisonVsWorkModel.ContainsKey | (kv[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-221d638e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10698 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (all_match != nu… | DATA_OP | VerisonVsWorkModel.Add | (kv[0], kv[1]) | 데이터 객체 조작/조회 |  |  |  |
| AC-533c655e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10712 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | DATA_OP | sel_version.Contains | (curversion) | 데이터 객체 조작/조회 |  |  |  |
| AC-616384e4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10714 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetBGColor2 | (rowindex, colidx, rowindex, colidx, colorS) | 그리드 표시 설정 |  |  |  |
| AC-1223444d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10718 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetBGColor2 | (rowindex, colidx, rowindex, colidx, colorD) | 그리드 표시 설정 |  |  |  |
| AC-121116a8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10719 | if (dsSimulFiltered.Good()) ▸ if (current_src != null && calendar != null) ▸ foreach (DataRow row in current_src.Rows) ▸ for (i < 5) ▸ if (c… | GRID_STYLE | siSimul.SetFGColor2 | (rowindex, colidx, rowindex, colidx, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-e9318004 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10748 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-42e3cc94 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10752 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | GRID_SET | siSimul.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-1075cc9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10754 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b94871ba | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10758 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if… | GRID_SET | siSimul.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-19ea9e87 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10773 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸… | GRID_STYLE | siSimul.SetBGColor3 | (0, index, dsSimulFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(… | 그리드 표시 설정 |  |  |  |
| AC-9085adf3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10788 | if (calendar != null && dsSimulFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Month… | GRID_STYLE | siSimul.SetBGColor3 | (0, index, dsSimulFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink… | 그리드 표시 설정 |  |  |  |
| AC-3803ecf3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10794 |  | DATA_OP | Filter2["DIVISION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3ff1d3e0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10795 |  | DATA_OP | Filter2["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-88e1f3a9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10796 |  | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e2d7a8c3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10797 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("DIO", "list_dio", Filter2.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_dio] \| FP\MASTER\DIO#list… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2a77b5be | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10825 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | DATA_OP | lookup.Tables[0].Select | ("DIVISION_ID = '" + division_id + "' AND " + "SITE_ID = '" + site_id + "' AND " + "ITEM_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-8c0845e9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10894 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].ForeColor | red | 그리드 속성/값 설정 |  |  |  |
| AC-8dcbb434 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10895 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | grey | 그리드 속성/값 설정 |  |  |  |
| AC-f325e6c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10899 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | grey | 그리드 속성/값 설정 |  |  |  |
| AC-aa583946 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10903 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | orangeLight | 그리드 속성/값 설정 |  |  |  |
| AC-b19c40d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10907 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | orange | 그리드 속성/값 설정 |  |  |  |
| AC-a80db6e2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10911 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].BackColor | red | 그리드 속성/값 설정 |  |  |  |
| AC-febb0927 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10914 | if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ foreach (FarPoint.Win.Spread.Row arow in siSimul.Active… | GRID_SET | siSimul.ActiveSheet.Cells[arow.Index, colidx].CellType | numCell | 그리드 속성/값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.ds_List01_cancolumnchange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (clicked_row != null)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57053c28 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7009 | if (clicked_row == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4d62efff | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7011 | if (clicked_row["CATEGORY_ID"].ToString() == "SIM_SETUP") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6c2997b1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7018 | if (bM != -1 && bC != -1 && bJ != -1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-a9159d8c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7020 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.dwCheck

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0) ▸ try ▸ try] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d61ec916 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9737 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DW_TABLE"] | "HIS_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-80002c46 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9740 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_dwSubmit_check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_dwSubmit_check] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cf84227b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9744 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-c745decf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9748 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (dsTmp.Tables[0].Rows[0]["IS_SUBMIT"].ToString() == "Y") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-50b1f7bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9753 | else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | txtReleaseAlert.Visible | false | 컨트롤 상태 Visible |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288868c3 | EditButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1577 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-d8bda1f1 | EditButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1579 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb108975 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7027 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cd35b08 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7028 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-3151f426 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7029 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-4876afb6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7031 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-082c6a77 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7043 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-a2ced51a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00643_Plan_Amend_Line_PSI_Elec.cs:7044 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991bfe84 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7085 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1aab02f7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7086 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-46c7e338 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7087 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b196467 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7089 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddbc8067 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7097 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-f4067f45 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7098 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6177e4d1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:7103 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.EditByFunc

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (new_value != round_value)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")]…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23fda5dc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7054 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-349cff7d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7056 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-fae7bcbd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7057 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-637af413 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7059 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed347096 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7069 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75549345 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7075 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-521fdcd0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7077 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Excel_Export

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d32a82c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3647 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.Casecaded | 속성 Merge 설정 |  |  |  |
| AC-78855ac7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3648 |  | UI_PROP | exportOption.Border | ExcelBorderOption.None | 속성 Border 설정 |  |  |  |
| AC-a28527b9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3650 | if (omitZero) | UI_PROP | exportOption.AmendZeroOption | ZeroOption.HideZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-49f59150 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3652 | else of (omitZero) | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-9b56c3be | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3655 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e8d4b7e9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3656 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-164a7b17 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3657 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-afab4ffa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3659 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-71e0f162 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3660 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-d7069742 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3667 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6ed394a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3671 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7c9999d0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3675 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-10545804 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3682 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85d4defc | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3591 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e427c40a | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3592 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-9e200d1d | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3594 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5a20864f | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3598 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-880bdb98 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3599 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-a26bb17b | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3600 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-7359e140 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3603 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-86ca8668 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3604 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-494d876c | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3605 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-e3a0cedf | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3607 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-04c302e5 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3608 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-0549a17b | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3611 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-b862ae10 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3623 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41268bd1 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3627 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-65a99204 | ExcelButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3631 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Find_Data_Amend

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.Selec…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a33b0a2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10157 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = ""; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e90f630 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10159 | try ▸ lambda | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f6e647d2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10171 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00643_ROW_FIND_FP00643_ROW", Filter.Copy(), p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0a9dccf9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10171 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6cc4ea0f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10172 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = Filter["FP_PLAN_ID"] = Filter["PLAN_ID"]… | ⚠ 의미 확인 필요 |  |  |  |
| AC-60a30ff3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10174 | try ▸ lambda | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] = Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-b40b84b2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10174 | try ▸ lambda | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-70afc4bb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10177 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-1202c38f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10181 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_ListData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50298c41 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4266 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49911205 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4275 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00643", "find_ListData", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b3182890 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4276 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_PostYield

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c18594d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4239 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-355712db | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4241 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00643", "find_PostYield", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_PostYield] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2077e705 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4242 |  | RETURN | return postYield; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_Prod_Version_Type

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1f7f0b8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4288 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6946f53 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4293 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_Prod_Version_Type", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cd763556 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4294 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_UOMInfo

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35301024 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4246 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-045a381d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4255 | if (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-db17b8c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4256 | if (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |
| AC-aa5b9e7b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4260 | else of (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo_ASIS", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2400c724 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4261 | else of (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_version_data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6446b81 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5040 |  | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca80e782 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5056 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bff950d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5072 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", prodtype, sTxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fea508e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5083 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ac636f01 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5102 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-308d0fed | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5105 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_versionType

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fd3c8e2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4281 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b3b649c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4283 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_versionType", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6d1d5bab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4284 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Find_YieldInfo_All

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f279543c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6963 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3068bd0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6964 |  | DATA_OP | Filter2["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-75801275 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6965 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_yieldInfo_ALL", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-373e9280 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6966 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.find_YieldInfo_Child

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (d…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09cbe983 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4223 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a1f7c824 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4231 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEM", "AND A.ITEM_ID ", "AND A.ITEM_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2e3c0ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4233 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_YieldInfo_Child", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0448f0b3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4234 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindBaseData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a68d3fc6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4299 |  | FLAG | dsListData | find_ListData(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9f0892af | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4302 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsListData.Tables[0].Select | ("RELEASE_TYPE='MPP' OR RELEASE_TYPE='WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd0d2320 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4310 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = dsListData.Tables[0]; dsUOMInfo = fin… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cad1fe07 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4312 | lambda | LIST_BIND | dgEdit.DataSource | dsListData.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-132f2b31 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4313 | lambda | FLAG | dsUOMInfo | find_UOMInfo(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b67ab5da | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4314 | lambda | FLAG | dsYieldInfoChild | find_YieldInfo_Child(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9901d598 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4315 | lambda | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2035c2e5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4315 | lambda | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a1a9838 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4316 | lambda | FLAG | dsProdVersionType | find_Prod_Version_Type(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-559a274c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4317 | lambda | FLAG | dsVersionType | find_versionType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-02aef83a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4318 | lambda | FLAG | dsYieldAll | Find_YieldInfo_All(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1671c265 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4319 | lambda | FLAG | dsPostYield | find_PostYield(Filter) | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindBohData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.Selec…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9d18209 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10552 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC_BODY", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-db01d264 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10553 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-f646ef1a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10557 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.findLineCode_List

진입점: this.Load [try] / mcbo_operation.SelectedIndexChanged [try] / chk_all_line.CheckedChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a505bf1c | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:426 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9179a65f | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:427 |  | DATA_OP | LocalFilter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-38997d54 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:443 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-24aa5861 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:461 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-15f79e4d | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:466 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ebed8a1f | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:479 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-22e3f3e8 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:481 |  | DATA_OP | LocalFilter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e7fb94ae | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:482 |  | DATA_OP | LocalFilter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0a3e66e4 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:496 | if (LocalFilter["ALL_LINE"] != "Y") | DATA_OP | LocalFilter["CTRL_LINE_LT"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-73885a46 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:499 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-8732e348 | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:499 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e1c5256b | this.Load [try] 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:500 |  | RETURN | return dtLine; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindSimulData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.Selec…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74878619 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10513 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00623_PANCAKE_SIMUL_ELEC", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ecc23dcc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10515 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-661e8a83 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 10 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10519 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindSubTotalColorStart

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (me…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfb10309 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1107 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindTotalColorStart

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (me…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6574a81d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1095 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-82c75af8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1102 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dd0d29c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4188 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-ef23c835 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4190 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_TOTALVALUE", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5ae98da6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4191 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-01d35da0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4197 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FindYieldInfo

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9aeb204 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6971 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e63d3696 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6973 |  | DATA_OP | Filter2["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b76bf704 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6974 |  | DATA_OP | Filter2["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71636951 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6975 |  | DATA_OP | Filter2["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d529b135 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6976 |  | DATA_OP | Filter2["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b2ecdd3c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6977 |  | DATA_OP | Filter2["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-601f8a58 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6978 |  | DATA_OP | Filter2["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-46e1911d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6979 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b992243a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6980 |  | DATA_OP | Filter2["PLAN_DATE"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69a63bd7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6981 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_yieldInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7b7af892 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6988 | if (ret.Good()) ▸ if (cell_rate > 0) | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |
| AC-ffc35d0f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6990 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a04002bf | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:194 |  | STATE | panelLog.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-e38e6924 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:202 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.FreeNote

진입점: this.spdSimul.MouseMove [if (col == -1 \|\| row == -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0267277 | this.spdSimul.MouseMove [if (col == -1 \|\| row == -1)] | FP00643_Plan_Amend_Line_PSI_Elec.cs:11583 | try | GRID_SET | siSimul.ActiveSheet.Cells[row, col].Note | "" | 그리드 속성/값 설정 |  |  |  |
| AC-3efc0dbb | this.spdSimul.MouseMove [if (col == -1 \|\| row == -1)] | FP00643_Plan_Amend_Line_PSI_Elec.cs:11584 | try | GRID_SET | siSimul.ActiveSheet.Cells[row, col].NoteStyle | NoteStyle.Hidden | 그리드 속성/값 설정 |  |  |  |
| AC-8fffd72d | this.spdSimul.MouseMove [if (col == -1 \|\| row == -1)] | FP00643_Plan_Amend_Line_PSI_Elec.cs:11585 | try | FLAG | last_over_row | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-648081b5 | this.spdSimul.MouseMove [if (col == -1 \|\| row == -1)] | FP00643_Plan_Amend_Line_PSI_Elec.cs:11586 | try | FLAG | last_over_col | -1 | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetAmendTable

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-007d45a8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3793 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-b412a732 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3794 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-38c624e3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3795 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-4eab81c2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3796 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-68cfd696 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3797 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-f69856e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3798 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_H" | 행/컬럼 값 대입 |  |  |  |
| AC-822f46bd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3802 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-426202b0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3803 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-d7acc3ff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3804 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-3f977118 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3805 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-4ea0cc91 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3806 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b65efb67 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3807 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_R" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a897548 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:265 |  | FLAG | dtPeriod | DataService.FP_ExecuteProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime")… | 화면 필드/플래그 변경 |  |  |  |
| AC-112e5bfb | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:265 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetDivision

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17972fad | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3765 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ed481f3 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3765 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2d91596f | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3767 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetFactory

진입점: this.Load / cbo_fpplanid.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ddd1389 | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3998 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-5b3c4529 | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3998 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6a30aa8b | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4003 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetFilter

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0) ▸ try ▸ try] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c3aba9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 11 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3760 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetFpPlanId

진입점: this.cbo_fpplanid.DropDown / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK)] / this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaecf087 | this.cbo_fpplanid.DropDown 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3921 |  | FLAG | dtPlanId | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(… | 화면 필드/플래그 변경 |  |  |  |
| AC-346b83bb | this.cbo_fpplanid.DropDown 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3921 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b127cfb | this.cbo_fpplanid.DropDown 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3923 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetLine

진입점: this.Load / mcbo_operation.SelectedIndexChanged / chk_all_line.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5035c423 | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4041 | try | FLAG | dtLine | findLineCode_List() | 화면 필드/플래그 변경 |  |  |  |
| AC-28f1b39f | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4042 | try | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-0c5a8a36 | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4048 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetMppWpp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2608d94a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2374 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-73ef3b5f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2384 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc4ca7b4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2385 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7afa42ea | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2386 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc9c8637 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2387 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-40957fd3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2388 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fdd116f1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2389 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f20f067c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2390 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-71c47321 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2391 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-94ad90ee | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2392 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-43cf7060 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2393 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7ea508f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2394 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb0721a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2395 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-36a65a18 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2396 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-26bc6944 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2382 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-45695e4f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2412 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_M_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-268e7bcc | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2415 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_M_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-96689507 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2420 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_W_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-5cf14313 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2422 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_W_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-a1053e68 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2427 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetNickName

진입점: mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc195b25 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3814 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76a7251d | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3820 |  | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-612fe8e6 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3828 |  | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-79a2fb5c | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3829 |  | DATA_OP | Filter2["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1916495a | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3830 |  | DATA_OP | Filter2["CTRL_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ed3f22e8 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3831 |  | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d3003ff9 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3833 | if (Filter2["PROD_TYPE"] == "") | DATA_OP | Filter2["PROD_TYPE"] | Filter2["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd72dca8 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3835 | if (Filter2["TOP_ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | " AND A.TOP_ITEM_ID LIKE '%' + @TOP_ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-1c871017 | mcbo_line.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:3837 | if (Filter2["ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_ITEM_ID"] | " AND A.ITEM_ID LIKE '%' + @ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetOperation

진입점: this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.Load / mcbo_factory.SelectedIndexChanged / usrCheckBox1.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ed5e3a | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4008 |  | DATA_OP | Filter["AMEND_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-21d326c8 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4009 |  | DATA_OP | Filter["AMEND_MAIN_FLAG"] | usrCheckBox1.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-cba7ed46 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4011 |  | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-978a2d9f | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4012 |  | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5aa95145 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4013 |  | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2578fd22 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4014 |  | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-63cb5ac5 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4015 |  | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-c605e57f | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4016 |  | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-4af8c743 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 4 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4024 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetPlanDate

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fefebae0 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:285 |  | UI_PROP | dCalendar_planrange.Value1 | start | 속성 Value1 설정 |  |  |  |
| AC-8f52afd4 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:286 |  | UI_PROP | dCalendar_planrange.Value2 | end | 속성 Value2 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aef9dae | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3910 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… | 화면 필드/플래그 변경 |  |  |  |
| AC-76b5ee69 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3911 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0360746e | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3915 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetPlanner

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04048e54 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3857 |  | FLAG | dtPlanner | DataService.FP_ExecuteQuery2("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-3f6a951c | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3857 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ed3fc630 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3858 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetPlant

진입점: this.Load / mcbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f58ae59 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3989 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-9912d497 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3989 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-703e44bc | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3991 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5212292 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8100 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-46196e0c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:8101 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetProdType

진입점: this.Load / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a544d5c8 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4029 |  | FLAG | dtProdType | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00599" + "_" + "find_FPProdType").ToUpper(… | 화면 필드/플래그 변경 |  |  |  |
| AC-13289a0f | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4029 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00599" + "_" + "find_FPProdType").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e60a8e48 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:4030 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetRoundPoint

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ lambda ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ lambda ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d147bca | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3772 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "find_getRoundPoint", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b8ef2b03 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3775 | if (dtRound.Good()) | FLAG | RoundPoint | dtRound.Rows[0][0].SafeZeroInt() | 화면 필드/플래그 변경 |  |  |  |
| AC-7250574a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3777 | if (dtRound.Good()) ▸ if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-b54b7f53 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3778 | if (dtRound.Good()) | FLAG | RoundTen | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-440c214f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3782 | if (dtRound.Good()) ▸ while (rwork > 0) | FLAG | RoundTen | *= 10 | 화면 필드/플래그 변경 |  |  |  |
| AC-7bee2240 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 12 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3786 |  | DATA_OP | Filter["ROUND_POINT"] | string.Format("{0}", RoundPoint) | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GetSite

진입점: this.Load / mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17acbaac | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3982 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-0b7bdf76 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3982 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a5e21d61 | this.Load 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3984 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-228f51d1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4062 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GoDrawCellColor

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (me…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9271166 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1585 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b545af7a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1620 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b37bdcad | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1621 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-49fbf3cc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1625 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d64c866 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1626 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, bg) | 그리드 표시 설정 |  |  |  |
| AC-d492feaf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1655 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ce04830 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1656 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-8373dd1d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1685 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b04c9ebe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1686 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor3 | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.GoEditMode

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good()) ▸ if (Filter["DONOTEDIT"] != "Y")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoI…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c344e51 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1732 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-43b482ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1733 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-0d93ac5f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1769 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e10aa9f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1793 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-46e8186a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1826 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-a98798c6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1851 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-65c199d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1867 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitAmendLineELec

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-551c9fed | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:216 |  | DATA_OP | Filter["AMEND_INSTANCE"] | lv_amendInstance | 행/컬럼 값 대입 |  |  |  |
| AC-2be135ba | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:217 |  | DATA_OP | Filter["PLAN_DATE"] | DateUtil_FP.gfn_today() | 행/컬럼 값 대입 |  |  |  |
| AC-0793258c | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:217 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2c770280 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:218 |  | DATA_OP | Filter["AMEND_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-25dae954 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:219 |  | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-bf1cb512 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:220 |  | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-dfeafc40 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:221 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitControlFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aabc72c9 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:303 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-c67eaeb9 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:307 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9dab3997 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:309 |  | DATA_OP | Filter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f51edc47 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:313 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-940aa9bb | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:314 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-8a554ad4 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:332 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-6c4a3612 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:334 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-dfd91cc1 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:369 |  | DATA_OP | Filter["PRODTYPE_ID"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7595af64 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:371 |  | VALUE_SET | chk_omit_zero.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6620fc28 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:372 |  | DATA_OP | Filter["OMIT_ZERO"] | "Y" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a4df440 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:227 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-17d31447 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:230 | try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-14affcd5 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:232 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d15836b7 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:233 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c9ebea65 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:237 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-6e1e3428 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:242 |  | FLAG | dtUomType | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP00643_PLAN_AMEND_LINE_PSI_ELEC", … | 화면 필드/플래그 변경 |  |  |  |
| AC-d0e3f856 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:242 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP00643_PLAN_AMEND_LINE_PSI_ELEC", "UOM_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaed9676 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtUomType, cboUomType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitEditingBuf

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b76d467 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6951 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a618560b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6953 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-ad910c21 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6954 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67a1e10b | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:377 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fc0db3f5 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:378 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-00b1c350 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:379 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a2e4df81 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:380 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-24d9dd46 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:381 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-09ca97b8 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:382 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-46462484 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:383 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-66fe8502 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:384 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InitSpread

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showEx…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee1d752 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:525 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e982a6f5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:526 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10e4e042 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:528 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4358868 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:531 | try | GRID_INIT | siSimul.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-855b1c7c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:532 | try | GRID_INIT | siSimul.ChangeActiveSheet | (SpdSheet.shtSimul) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03f1e887 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:533 | try | GRID_LOCK | siSimul.SetLockFlag | (SpdSheet.shtSimul, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e2ede04b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:537 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-919cf24b | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1521 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-4c6472e7 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1522 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f757335 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1528 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cb53e078 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1533 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | MESSAGE | MessageBox.Show | ("Please select row with model first") | 메시지 표시 |  |  |  |
| AC-1c04043c | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1534 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94fb31e2 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1536 | if (row != null) | POPUP | new FP00595_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-29e3f02b | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1538 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c1bb630a | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1538 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d48fcd | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1539 | if (row != null) | UI_PROP | popup.dsUOMInfo | dsUOMInfo | 속성 dsUOMInfo 설정 |  |  |  |
| AC-d2bb69d1 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1540 | if (row != null) | UI_PROP | popup.dsVersionType | dsVersionType | 속성 dsVersionType 설정 |  |  |  |
| AC-ba057a15 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1541 | if (row != null) | UI_PROP | popup.dsYieldChild | dsYieldChild | 속성 dsYieldChild 설정 |  |  |  |
| AC-721349ed | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1543 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-437988cd | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1544 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a8ed2d0 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1545 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f7bb2ad | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1549 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a85d109 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1550 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1239f509 | InsertButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1561 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ee68cc5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:3731 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6dff8338 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4691 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-4485926c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4693 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-da532246 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4695 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-08bc7ec5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4696 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea60d640 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4701 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8d34b4eb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4703 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-31878a06 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4705 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-eaa091ed | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4707 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-190e5428 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4709 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7187dffb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4711 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ac99939b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4713 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7359f8dd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4717 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-30601cbf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4720 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-1441505a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4722 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_getExchangeBatch_Validation

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (clicked_row != null)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-418977c8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8019 | switch (cate) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-1da00b84 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8030 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc3bd41f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8031 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-2f94d372 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8032 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e2baea1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8033 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57b82a1d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8034 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-eb488666 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8035 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-0535f34c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8028 | if (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-59122896 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8045 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-961cad59 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8046 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-81c1629a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8048 | if (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-ab0c1d35 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8058 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a382fb8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8059 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-dff255a5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8060 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e9e4b77 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8061 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8df26292 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8062 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("PROD_VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2af0202e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8056 | else of (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-e630b45c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8072 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-55b2b9ed | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8073 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-df0c52df | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8075 | else of (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_getYieldInfo

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef0ef731 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6995 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3855ecd1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6996 |  | DATA_OP | yf["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-11550f93 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6997 |  | DATA_OP | yf["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7a839622 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:6998 |  | DATA_OP | yf["FACTORY_ID"] | clicked_row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18a100b8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7000 |  | FLAG | YieldRate | FindYieldInfo(yf, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-39e977e4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7000 |  | RETURN | return YieldRate = FindYieldInfo(yf, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_setExchangeBatch

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ca6aa85 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7834 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-086fb6d9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7874 |  | CALL_EXT | dsYieldChild.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f385ebbe | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7879 | else of (nExcRow == -1) | DATA_OP | dsYieldChild.Tables[0].getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-987b1a46 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7886 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_setExchangeBatch_Detail

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked &…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3256ed4f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7905 |  | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d9592d3e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:8002 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_settingValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a513954f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4744 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) | DATA_OP | row.Table.Columns.Contains | (sQtyCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dec819e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4751 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-41a9c219 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4752 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3b3c26b3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4753 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-df49b6ec | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4754 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sQtyCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-18d2bafa | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4755 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-107f16b6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4819 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ else of (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSe… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e68c2874 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4831 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-a12e6865 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4832 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-4979ece7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4835 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e40e391d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4837 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0ab1a353 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:4838 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.lfn_settingValidRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd282d5a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5853 | else of (!IsNumber(row[sQtyCol])) | DATA_OP | row[sQtyCol] | x | 행/컬럼 값 대입 |  |  |  |
| AC-804d64de | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5885 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-0c7ab029 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5886 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-3c9ed21e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5889 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-decc779b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5891 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-7180b693 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5892 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18469a74 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:875 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-cf400f49 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:879 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.mcbo_planner_changed

진입점: mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36af5015 | mcbo_planner.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8409 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-fa796402 | mcbo_planner.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8411 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.mcbo_prodtype_changed

진입점: mcbo_prodtype.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-434dd0ba | mcbo_prodtype.SelectedIndexChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8556 |  | DATA_OP | Filter["PRODTYPE_LT"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90194922 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6664 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9711d93f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6667 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f388f052 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6671 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20f2fd85 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6675 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1fecfc2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6675 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c6e22fe | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6677 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-b65c412d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6678 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-5fcd09b7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6678 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ee58bd00 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6679 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e9b145ad | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6680 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2dd2b396 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6681 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-babb5ee6 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6686 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d0e2d1d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6688 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-3c69ff9f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6693 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onLineChangeMenu

진입점: line_change_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f274af9d | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6624 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1ce94cd | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6627 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a6c0630 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6629 |  | POPUP | new FP00643_LineCopy_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3afb3f23 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6630 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-307bf812 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6630 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-693ae8de | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6632 |  | DATA_OP | frm.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2b96867c | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6633 |  | DATA_OP | frm.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-18c4e97a | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6634 |  | DATA_OP | frm.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e87ce7f7 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6635 |  | DATA_OP | frm.Filter["FACTORY_ID"] | row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7e27d21 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6636 |  | DATA_OP | frm.Filter["OPERATION_ID"] | row["OPERATION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d968f23a | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6637 |  | DATA_OP | frm.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3a77dfd9 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6638 |  | DATA_OP | frm.Filter["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a3d3fd41 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6640 |  | DATA_OP | frm.Filter["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1053261b | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6642 |  | DATA_OP | frm.Filter["NICK_NAME"] | row["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87a6cda2 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6643 |  | DATA_OP | frm.Filter["TOP_ITEM_ID"] | row["TOP_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-30473689 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6644 |  | DATA_OP | frm.Filter["EQUIPMENT_ID"] | row["EQUIPMENT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4512b27a | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6645 |  | DATA_OP | frm.Filter["MARKET"] | row["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86dfe891 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6650 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-029ae9d6 | line_change_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6651 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-311f36fd | memo_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6701 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfc14540 | memo_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6704 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16fb2abd | memo_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6708 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41d0dd78 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6894 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee39d081 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6897 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c84713db | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6915 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-ec6f7e09 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6916 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-fbd7e838 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6916 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f21b87f9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6917 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4c5abf0e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6918 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa025611 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6919 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a63f3c9f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6920 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onZeroAllMenu

진입점: zero_all_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8bc86f3 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6533 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77114f89 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6536 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce3e0af2 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6540 | if (dsMainFiltered.Good()) | MESSAGE | MessageBox.Show | ("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warn… | 메시지 표시 |  |  |  |
| AC-caca1e64 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6542 | if (dsMainFiltered.Good()) ▸ if (MessageBox.Show("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warnin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ebeae09 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6544 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-45a4cafa | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6545 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b59c62c9 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6567 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ( "DATA_TYPE='DATA'" ) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc1cb734 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6600 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH") ▸ for (k < DayColumnCount) | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-50da4ef6 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6613 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6a1dbf7c | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6616 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-471f0708 | zero_all_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6617 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e53e876f | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6221 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-261a0e9b | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6224 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4bbf541a | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6241 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6a1c19dc | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6242 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c69e7603 | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6253 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") &&… | DATA_OP | row_to_test["CATEGORY_ID"].ToString().Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-58a1db0c | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6280 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8c4f253e | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6281 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-99cc7efc | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6282 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c7bc115c | bucke_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6285 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onZeroLineMenu

진입점: zero_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b50216 | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6409 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-017630f4 | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6412 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6324978 | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6416 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6d693a44 | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6417 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8e18b85e | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6439 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" //+ " AND OPERATION_ID='" … | 데이터 객체 조작/조회 |  |  |  |
| AC-8a7b2deb | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6494 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-361d10fe | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6522 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e1f071e | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6525 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-546540ec | zero_line_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6526 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.onZeroMaterialMenu

진입점: zero_mat_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bc7d3ad | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6297 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82ea77cc | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6300 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b749d94e | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6304 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-19c0a5a7 | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6305 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4448b634 | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6326 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-17a8509d | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6370 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba4ec045 | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6398 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-989cdcda | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6402 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b2c6758c | zero_mat_menu.Click | FP00643_Plan_Amend_Line_PSI_Elec.cs:6403 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.OpenAlarmMemo

진입점: this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Sele…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96d882ed | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10127 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-c5ff3d02 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10127 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-56d661e9 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10129 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-7aaddc9f | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10130 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ddb6bfd6 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10130 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b326833 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10131 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-6721c4e5 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10132 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9254f0c5 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10133 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6ecdd1fb | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10137 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-233561a5 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10139 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-20d712f5 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10144 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.OpenLineMemo

진입점: this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be955665 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10085 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-d9dac1bb | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10086 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-7cc80b7f | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10087 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c86430a3 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10087 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76cc8b9b | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10088 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d8e6c752 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10089 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1dc471ea | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10090 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b2c12200 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10095 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94afc534 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10098 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.OpenMaterialMemo

진입점: this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / memo_menu.Click [if (day != null) ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb019990 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10104 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-c9af9a4b | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10105 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-1283b8d0 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10106 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-03c7a91e | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10106 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dd63ad0c | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10107 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e0a53b91 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10108 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0bc848b9 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10109 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-4dbb4e8a | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10113 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c18ca2d0 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10115 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-617d3b12 | sCalendar_planday.ValueChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8594 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Query

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8c7984 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1032 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-48991b5e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1032 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-98738488 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1033 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a999fe79 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1038 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-6699c55e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1061 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-f2193823 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1067 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-2aed423b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1067 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38fc2b5d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1068 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d9d1354 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1068 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-463d6a37 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1071 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-b486c16a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1078 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-691bef3a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1083 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40f29f70 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1084 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b50acbf6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1086 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RefreshHeadAndBody

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f17fee0b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:673 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5cc1dccc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:688 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-d382d25e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:692 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RefreshHeadAndBody_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ if (!dsSimulDate.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (!dsSimulDate.Good())] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ if (!dsSimulDate.Good())] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4766af63 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10592 | try | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3f79e3b2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10607 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-163b796c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10611 | finally | UI_MISC | siSimul.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RefreshSpreadSheet

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2852039c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3578 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-70a3d63a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3584 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RefreshSpreadSheet_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-097c3e0b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10191 | if (!dsSimulDate.Good()) | FLAG | dsSimulFiltered | dsSimulDate.Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-d007bfae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10191 | if (!dsSimulDate.Good()) | DATA_OP | dsSimulDate.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0998ca84 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10193 | if (!dsSimulDate.Good()) | GRID_LOCK | siSimul.LockColumn | (0, siSimul.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-35bd747a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10194 | if (!dsSimulDate.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1488a7d8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10196 |  | DATA_OP | this.dsSimulDate.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b00839f8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10211 | if (uom_cell) ▸ for (i < daymax) | DATA_OP | colname_src[i] | string.Format("D{0}_CELL", i) | 행/컬럼 값 대입 |  |  |  |
| AC-7c928667 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10212 | if (uom_cell) ▸ for (i < daymax) | DATA_OP | colname_tar[i] | string.Format("D{0}", i) | 행/컬럼 값 대입 |  |  |  |
| AC-e2128bf4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10222 | if (uom_cell) ▸ for (j < rowscnt) ▸ for (i < daymax) | DATA_OP | row[colname_tar[i]] | row[colname_src[i]] | 행/컬럼 값 대입 |  |  |  |
| AC-716927e7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10229 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7213420 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10230 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0a47055 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10231 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GOOD_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-467e43a5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10233 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4cd29876 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10234 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6cbf0e24 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10235 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("QMS_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-42a85bd3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10237 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_STOCK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fe4fad3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10238 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_REWORK_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-727d3685 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10239 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("GMES_BOFORE_NT_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c2002fe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10241 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("PANCAKE_GOOD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e7798b9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10242 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("PANCAKE_GOOD_QTY_SUM2", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-048cc02e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10244 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("RECEIPT_GOOD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-06bfccbb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10245 |  | DATA_OP | simulData.Tables[0].Columns.SafeAdd | ("RECEIPT_HOLD_QTY_SUM", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1bd5d70 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10247 |  | CALL_EXT | simulData.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-bdfc212d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10249 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5cec2b83 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10250 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-964f9d08 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10251 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-73dd0138 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10252 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f691c19c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10253 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd0a772b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10254 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4aff61aa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10266 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_GOOD_QTY_SUM"] | row["RECEIPT_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-ba5a42cb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10267 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_HOLD_QTY_SUM"] | row["RECEIPT_HOLD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-9abba6f0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10269 | if (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["PANCAKE_GOOD_QTY_SUM2"] | row["RECEIPT_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-68f02a8e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10276 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_GOOD_QTY_SUM"] | row["RECEIPT_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-fca8332d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10277 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["RECEIPT_HOLD_QTY_SUM"] | row["RECEIPT_HOLD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-198c656a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10279 | else of (uom_cell) ▸ foreach (DataRow row in simulData.Tables[0].Rows) | DATA_OP | row["PANCAKE_GOOD_QTY_SUM2"] | row["RECEIPT_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-724830fb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10301 | foreach (var group_version in group3) ▸ if (fRow != null) | CALL_EXT | simulData.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["CO… | (r => { r["GOOD_STOCK_QTY_SUM"] = 0; r["GOOD_REWORK_QTY_SUM"] = 0; r["GOOD_BOFORE_NT_QTY_S… | ⚠ 의미 확인 필요 |  |  |  |
| AC-18e120c9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10303 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac97bf53 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10304 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6adbcd6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10305 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4551ef5d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10306 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-5857b14e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10307 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-308c1983 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10308 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df6d4270 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10312 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-9de2c3b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10313 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-6cc2a5c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10314 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GOOD_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b2026fbc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10316 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-249da9a9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10317 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-d17a472a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10318 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["QMS_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-5e02e7db | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10320 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_STOCK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-75fd652c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10321 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_REWORK_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-6a6b3fd9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10322 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["GMES_BOFORE_NT_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-85ceaf9e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10324 | foreach (var group_version in group3) ▸ if (fRow != null) ▸ lambda | DATA_OP | r["PANCAKE_GOOD_QTY_SUM"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-2c93abcc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10336 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) | CALL_EXT | dsSimulBoh.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == c["COMP… | (r => { if (uom_cell) { c["GOOD_STOCK_QTY_SUM"] = c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fd26c802 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10338 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9494ef89 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10339 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b3bd7e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10340 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-efd634bf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10341 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-525eb2cf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10342 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f691c646 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10343 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | version_all.Contains | (x.Field<string>("VERSION")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f65af2b3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10343 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-db693060 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10349 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_STOCK_QTY_SUM"] | c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r["GOOD_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-417dc2dc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10350 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_REWORK_QTY_SUM"] | c["GOOD_REWORK_QTY_SUM"].SafeDouble() + r["GOOD_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-f747d03f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10351 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GOOD_BOFORE_NT_QTY_SUM"] | c["GOOD_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GOOD_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-18d7466b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10353 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_STOCK_QTY_SUM"] | c["QMS_STOCK_QTY_SUM"].SafeDouble() + r["QMS_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-9f985ad2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10354 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_REWORK_QTY_SUM"] | c["QMS_REWORK_QTY_SUM"].SafeDouble() + r["QMS_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a8371c82 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10355 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["QMS_BOFORE_NT_QTY_SUM"] | c["QMS_BOFORE_NT_QTY_SUM"].SafeDouble() + r["QMS_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a3158b68 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10357 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_STOCK_QTY_SUM"] | c["GMES_STOCK_QTY_SUM"].SafeDouble() + r["GMES_STOCK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-6bb63514 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10358 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_REWORK_QTY_SUM"] | c["GMES_REWORK_QTY_SUM"].SafeDouble() + r["GMES_REWORK_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a0f97e08 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10359 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["GMES_BOFORE_NT_QTY_SUM"] | c["GMES_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GMES_BOFORE_NT_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-03b80a83 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10363 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM"] | c["PANCAKE_GOOD_QTY_SUM"].SafeDouble() + r["PANCAKE_GOOD_CELL_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-24b76891 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10364 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ if (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM2"] | c["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() + r["PANCAKE_GOOD_CELL_QTY2"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-445e1bb6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10369 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_STOCK_QTY_SUM"] | c["GOOD_STOCK_QTY_SUM"].SafeDouble() + r["GOOD_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-fc137414 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10370 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_REWORK_QTY_SUM"] | c["GOOD_REWORK_QTY_SUM"].SafeDouble() + r["GOOD_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-7729aee9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10371 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GOOD_BOFORE_NT_QTY_SUM"] | c["GOOD_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GOOD_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a7313921 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10373 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_STOCK_QTY_SUM"] | c["QMS_STOCK_QTY_SUM"].SafeDouble() + r["QMS_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-ef565bd6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10374 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_REWORK_QTY_SUM"] | c["QMS_REWORK_QTY_SUM"].SafeDouble() + r["QMS_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-b4bd74e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10375 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["QMS_BOFORE_NT_QTY_SUM"] | c["QMS_BOFORE_NT_QTY_SUM"].SafeDouble() + r["QMS_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a7868a3c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10377 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_STOCK_QTY_SUM"] | c["GMES_STOCK_QTY_SUM"].SafeDouble() + r["GMES_STOCK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-a4503a70 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10378 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_REWORK_QTY_SUM"] | c["GMES_REWORK_QTY_SUM"].SafeDouble() + r["GMES_REWORK_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-e27cf365 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10379 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["GMES_BOFORE_NT_QTY_SUM"] | c["GMES_BOFORE_NT_QTY_SUM"].SafeDouble() + r["GMES_BOFORE_NT_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-0534d1d9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10382 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM"] | c["PANCAKE_GOOD_QTY_SUM"].SafeDouble() + r["PANCAKE_GOOD_QTY"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-46c04a26 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10383 | foreach (var group_version in group3) ▸ if (!set_to_empty) ▸ foreach (var group_rows in group_version) ▸ lambda ▸ else of (uom_cell) | DATA_OP | c["PANCAKE_GOOD_QTY_SUM2"] | c["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() + r["PANCAKE_GOOD_QTY2"].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-7d3cbbcf | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10392 |  | CALL_EXT | simulData.Tables[0].AsEnumerable().GroupBy | (x => new { COMPANY_ID = x.Field<string>("COMPANY_ID"), DIVISION_ID = x.Field<string>("DIV… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f751417 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10394 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9e241e8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10395 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-872110ff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10396 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b609cea8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10397 | lambda | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-04d898ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10398 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-54085f23 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10432 | foreach (var triple in dateworker) | CALL_EXT | DateTime.TryParseExact | (plan_date, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out pDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0a9af92 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10444 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) | DATA_OP | DIO_Row[day_colname] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-47ed7bbd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10449 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (d.Date == pDat… | DATA_OP | Inventory_Row[day_colname] | Assy_Row["PANCAKE_GOOD_QTY_SUM2"].SafeDouble() - Assy_Row[day_colname].SafeDouble() + Coat… | 행/컬럼 값 대입 |  |  |  |
| AC-0bbf7f6d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10457 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (d.Date ==… | DATA_OP | Inventory_Row[day_colname] | Inventory_Row[prev_day_colname].SafeDouble() - Assy_Row[day_colname].SafeDouble() + Coater… | 행/컬럼 값 대입 |  |  |  |
| AC-e936680b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10465 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ i… | DATA_OP | DIO_Row[day_colname] | 365 | 행/컬럼 값 대입 |  |  |  |
| AC-920ea083 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10467 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ e… | DATA_OP | DIO_Row[day_colname] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-596e0f19 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10469 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ if (assy == 0) ▸ e… | DATA_OP | DIO_Row[day_colname] | -365 | 행/컬럼 값 대입 |  |  |  |
| AC-fcee1500 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10472 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | DATA_OP | DIO_Row[day_colname] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-810328f9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10476 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | CALL_EXT | Math.Truncate | (dio * 10.0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b91f7fc4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10477 | foreach (var triple in dateworker) ▸ if (calendar != null && calendar.Days != null) ▸ foreach (var kv in calendar.Days) ▸ else of (assy == 0… | DATA_OP | DIO_Row[day_colname] | dio | 행/컬럼 값 대입 |  |  |  |
| AC-35373bf4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10497 |  | FLAG | dsSimulFiltered | simulData | 화면 필드/플래그 변경 |  |  |  |
| AC-b909346f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 18 | FP00643_Plan_Amend_Line_PSI_Elec.cs:10501 | if (dsSimulFiltered.Good()) | GRID_LOCK | siSimul.LockColumn | (0, siSimul.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RestoreColumnWidth_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fa837c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11474 | if (view == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05d5346a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11478 | if (columnWidthStoreSimul == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7f723d66 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11485 | foreach (KeyValuePair<int, float> eachWidth in columnWidthStoreSimul) ▸ if (idx < view.Columns.Count && idx >= 0) | GRID_SET | view.Columns[idx].Width | width | 그리드 속성/값 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RestoreTopRow_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE") ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ebc45b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11517 | if (siSimul == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-343209d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11519 | if (ViewportTopRow_Simul < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1927320b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11522 | try | GRID_STYLE | siSimul.SpreadObject.SetViewportTopRow | (0, ViewportTopRow_Simul) | 그리드 표시 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RestoreView_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ebe8137 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11497 | try | UI_MISC | siSimul.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RoundValue

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22cdbf01 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9721 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c4699b7b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9722 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-3dbfc94a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9726 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7769329 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9727 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-532bbe59 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9730 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3a55671 | popSql.OnSql | FP00643_Plan_Amend_Line_PSI_Elec.cs:4164 | if (programID == "PR_UI_FP00643_ROW_FIND_FP00643_ROW") | RETURN | return Find_Data_Amend(false); |  | 처리 중단/반환 |  |  |  |
| AC-5689152b | popSql.OnSql | FP00643_Plan_Amend_Line_PSI_Elec.cs:4168 | else of (programID == "PR_UI_FP00643_ROW_FIND_FP00643_ROW") ▸ if (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") | RETURN | return FindSimulData(false); |  | 처리 중단/반환 |  |  |  |
| AC-1153c62d | popSql.OnSql | FP00643_Plan_Amend_Line_PSI_Elec.cs:4172 | else of (programID == "PR_UI_FP00643_ROW_FIND_FP00643_ROW") ▸ else of (programID == "PR_UI_FP00623_PANCAKE_SIMUL_ELEC") ▸ if (programID == "… | RETURN | return FindBohData(false); |  | 처리 중단/반환 |  |  |  |
| AC-fe3b58ad | popSql.OnSql | FP00643_Plan_Amend_Line_PSI_Elec.cs:4175 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d48edb1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:1896 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f25cbb8a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:1918 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-59e5112d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:1919 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-620c53ca | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:1925 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-35f95e46 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:1936 | try | CALL_EXT | dt2.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-36d7147b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2205 | try ▸ else of (dt.Good()) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-6fb05662 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2206 | try ▸ else of (dt.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-731d3d0c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2213 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-44f50b29 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2220 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-03242cc5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2224 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-0b5e93a3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2225 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-20a1bc65 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2231 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e4ea110 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2232 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-327c2c7b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2233 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-efac6377 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2234 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2824ba8a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2236 | try | FLAG | dsBoh | DataService.FP_ExecuteProcedure("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ad5273f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2236 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c1d5001c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2240 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e954792 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2241 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cda9444 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2242 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c103c6f8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2243 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b9b282d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2244 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32951f16 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2246 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb8fba64 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2247 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-90f7d242 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2248 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2f15c94 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2249 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3961c778 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2250 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62eedb0e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2251 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce17dd76 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2252 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'MPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc243e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2253 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afc23a79 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2254 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4d0100 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2257 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-5e8c5ee4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2258 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-5b43d425 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2259 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-32d43b96 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2260 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-2909c854 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2261 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d2ec3af2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2262 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-5c66b736 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2263 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-a1ff133b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2264 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-6c13ba9c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2265 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-6bef6604 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2266 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-4b6d76e3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2271 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-57076f38 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2272 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-ab9242fb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2273 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-d5861866 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2274 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-7091995c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2275 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c16357f0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2276 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-634c3277 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2277 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-a231670d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2278 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-2327f5df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2279 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-b1dc10d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2280 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9d3d79e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2283 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (wpps, wpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4646df7a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2284 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (mpps, mpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98234b6e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2294 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", mpp, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-c51bd39b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2295 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-371abf27 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2301 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", wpp, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-465bd4ee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2302 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | CALL_EXT | DataService.ReadResult | (res2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33191a07 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2331 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr != null && !dr.Success) | THROW | throw new Exception(dr.Message); |  | 예외 발생 |  |  |  |
| AC-f853e250 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2333 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr2 != null && !dr2.Success) | THROW | throw new Exception(dr2.Message); |  | 예외 발생 |  |  |  |
| AC-262e9bb0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2334 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) | THROW | throw new Exception("There is no data to save"); |  | 예외 발생 |  |  |  |
| AC-c7df63c1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2341 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-a835b7d4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2342 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-cbd12fb2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2343 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-73462d9d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2344 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-a0f4f2a8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2345 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-361b8764 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2346 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-9bc99826 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2347 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | GetFilter("FP_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-fed4624d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2348 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-115ab8e8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2349 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-7643ba1f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2356 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d65b878b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2361 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e02f713e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00643_Plan_Amend_Line_PSI_Elec.cs:2363 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d43c65d2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2431 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28e08db5 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1880 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-d603bbee | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1881 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87a9eee6 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1884 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-49386814 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1885 |  | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e2f85d5e | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1887 |  | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3e436ea3 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:1889 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SaveColumnWith_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49789e89 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11458 | if (view == null) | FLAG | columnWidthStoreSimul | null | 화면 필드/플래그 변경 |  |  |  |
| AC-910df483 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11459 | if (view == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-59185084 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11462 | if (columnWidthStoreSimul == null) | FLAG | columnWidthStoreSimul | new Dictionary<int, float>() | 화면 필드/플래그 변경 |  |  |  |
| AC-abfbbaf7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11465 | for (i < view.Columns.Count) | DATA_OP | columnWidthStoreSimul[i] | view.Columns[i].Width | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b6e9d05 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5292 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popupFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3057db1a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5296 | if (ISRELEASE) ▸ if (nSeq.Good()) | DATA_OP | popupFilter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-035a2b4f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5303 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c646ef83 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5304 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14e7ac83 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5305 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9a01ddc | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5306 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-61bb8d1a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5307 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b31c08a2 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5312 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["JOB_ORDER"] | ii | 그리드 속성/값 설정 |  |  |  |
| AC-2e75036e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5313 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 그리드 속성/값 설정 |  |  |  |
| AC-d90e5028 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5320 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_MPPWPP", "delete_Excel_buffer", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-e10896d7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5321 | if (ISRELEASE) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00595_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-1ac5c56b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5323 | if (ISRELEASE) | CALL_EXT | DataService.ReadResult | (dtRes) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3df68d86 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5327 | if (ISRELEASE) ▸ if (!dr.Success) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1a657218 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5364 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_MPPWPP", "find_Excel_buffer_validation", popupFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-be72bf63 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5370 | if (ISRELEASE) ▸ if (validation.Good()) | CALL_EXT | validation.Tables[0].FindRowExpr | ("_VALID='N'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b23731f0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5374 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | MESSAGE | MessageBox.Show | ("There are invalid data.", "Error") | 메시지 표시 |  |  |  |
| AC-049223e3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5376 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | new FP00602_InvalidExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d1d5b814 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5377 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | UI_PROP | popup.ErrorData | validation | 속성 ErrorData 설정 |  |  |  |
| AC-3b455a6d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5378 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0001eb3b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5380 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2983f831 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5388 | if (ISRELEASE) ▸ if (validation.Good()) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c68583a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5390 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (!validation.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | validation.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a9792de | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5393 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (!validation.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in validation.Tables[… | DATA_OP | dr["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-04d9549d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5398 | if (ISRELEASE) ▸ else of (validation.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1bf3aa18 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5406 | if (ISRELEASE) ▸ if (validation.Good()) ▸ foreach (DataRow ro in validation.Tables[0].Rows) ▸ if (ro.RowState == DataRowState.Unchanged) | CALL_EXT | ro.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6572bf97 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5418 | if (ISRELEASE) ▸ if (valid == false) | MESSAGE | MessageBox.Show | ("There are invalid data.", "Error") | 메시지 표시 |  |  |  |
| AC-e7bf695d | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5421 | if (ISRELEASE) ▸ if (valid == false) | POPUP | new FP00602_InvalidExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a3b042f8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5422 | if (ISRELEASE) ▸ if (valid == false) | UI_PROP | popup.ErrorData | validation | 속성 ErrorData 설정 |  |  |  |
| AC-b896cf77 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5423 | if (ISRELEASE) ▸ if (valid == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9b4038e4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5426 | if (ISRELEASE) ▸ if (valid == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1829b671 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5430 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-be047551 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5431 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-41667320 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5432 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5dad2316 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5433 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7cb013a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5434 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-acbf64f4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5435 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-167bf06f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5436 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-212dd6e4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5443 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b2d2ad7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5444 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7971c7ae | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5445 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4e3a321 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5446 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f038b1f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5447 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed8f7c18 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5449 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13ca2f41 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5450 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e66148c4 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5451 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5d05ccb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5452 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de797781 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5453 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3227b9c5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5454 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d698ab8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5460 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-937e085b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5461 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popupFilter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-487cc47f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5462 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-9000d8a3 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5463 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["ROUND_POINT"] | Filter["ROUND_POINT"] | 행/컬럼 값 대입 |  |  |  |
| AC-99a84f20 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5466 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-c1d1735b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5467 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-89c33463 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5468 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-acc0489b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5469 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-e9d26a31 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5470 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-0051f5b0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5471 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-7565c53c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5472 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-df9b38f0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5473 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-ba3f0682 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5474 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-08d1f538 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5475 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-7ca65ec9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5476 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-e2df8e52 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5477 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c6603a1b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5483 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-b646f9ce | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5484 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-05a19478 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5485 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-0e68cf73 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5486 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-7663885e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5487 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-abda730c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5488 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-9aa09ec0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5489 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-0fa93813 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5490 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-7271b8b7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5491 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-d9f234fb | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5492 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-92688255 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5493 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-45bc9cf0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5494 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-360ea13c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5501 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-495539ea | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5506 | if (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-9d38be23 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5507 | if (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-cf326bf1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5508 | if (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-5f3949d8 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5509 | if (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-dde01cfd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5510 | if (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-76b214d1 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5511 | if (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-52a349c9 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5512 | if (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-162352fe | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5515 | if (ISRELEASE) | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5633fcc0 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5517 | if (ISRELEASE) | RETURN | return do_save; |  | 처리 중단/반환 |  |  |  |
| AC-03c4599b | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5522 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_DATE"] | popupFilter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3fec2ffd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5523 | else of (ISRELEASE) | DATA_OP | BohSet["MASTER_ID"] | popupFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-30e0d4dd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5524 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_ID"] | popupFilter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2890ce2c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5525 | else of (ISRELEASE) | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-ee595b27 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5528 | else of (ISRELEASE) ▸ if (string.IsNullOrWhiteSpace(popupFilter["FP_PLAN_ID"])) | DATA_OP | BohSet["PLAN_ID"] | data.Tables[0].Rows[0]["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-688da67a | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5537 | else of (ISRELEASE) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-525b967e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5542 | else of (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-a3cbfb19 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5543 | else of (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-49a67743 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5544 | else of (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-dbf08525 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5545 | else of (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-476593fd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5546 | else of (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-57200286 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5547 | else of (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-d7248003 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5548 | else of (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-51afc905 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5551 | else of (ISRELEASE) | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce9cdbc7 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5556 | else of (ISRELEASE) ▸ if (do_save) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-3d70662f | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:5562 | else of (ISRELEASE) ▸ else of (do_save) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SaveTopRow_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0310c79a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11503 | if (siSimul == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88659174 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11507 | try | FLAG | ViewportTopRow_Simul | siSimul.SpreadObject.GetViewportTopRow(0) | 화면 필드/플래그 변경 |  |  |  |
| AC-51ec6745 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11507 | try | CALL_EXT | siSimul.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5eb00baa | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11511 | catch () | FLAG | ViewportTopRow_Simul | -1 | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SaveView_Simul

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.spdSimul.CellDoubleClick [try ▸ if (colname.ToUpper().Contai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ecb9f2e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 17 | FP00643_Plan_Amend_Line_PSI_Elec.cs:11446 |  | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e1f8f61 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:2480 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetCalendarFormat

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f51218ec | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9630 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e8a990a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9632 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2bfb5ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9635 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9118ee4f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9659 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a61d9c7e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9661 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec7f36e9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9664 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4a1925e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9690 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-801f4ed4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9692 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98211918 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9695 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetCalenderColor

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (me…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3227a5d6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:779 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6628f2ae | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:783 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-2a55fdcc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:785 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4e765015 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:789 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-75203534 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:813 | if (calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-6962ff2f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:828 | if (calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetColumnsFormat

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae9054d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9570 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2c8646c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9576 | if (siMain != null) ▸ if (colIndex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1ee4cac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9580 | if (siMain != null) ▸ if (colIndex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,##0", "0", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4f83dee | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9585 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#00", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92bb3b4c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9588 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-edc580ec | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9591 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-89244d48 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9594 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d815d60e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9597 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0faf894b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9600 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "##,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8305088c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9603 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0.###", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc3aca9 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:171 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7957ce39 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:173 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-330a1215 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:177 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-fcf83e6c | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:179 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-cd64cfd5 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:180 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0e1cfd8a | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:182 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-675e1d55 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:186 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetDirty

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ finally] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ finally] / this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62ccab4f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 16 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9550 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetFilter

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision))] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d282fad4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 24 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3755 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetFpPlanIdFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c36a0db8 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3932 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5358460c | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3933 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d2a20add | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3934 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-08337307 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3935 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b6065c42 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3945 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-88df8552 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3946 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-ceef9572 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3947 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-d2df0bf4 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3948 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-1a144f7b | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3949 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-d57b396e | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3952 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-e0faf90e | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3954 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d398002 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3955 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-126a4b14 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3961 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-41f29fbf | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3962 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4da7e0c1 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3963 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-daa30be3 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3964 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bc6c6011 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3968 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-29d2975c | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3969 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-279cc91b | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3970 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5822a0ae | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3971 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-72904f4b | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3972 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-5951f5d9 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3975 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e22f912 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6770 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-64d6fa9e | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6790 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-ea323ecd | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6792 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | bcell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-546bb9bf | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6810 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-2c1e4f0c | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6835 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(siMain.SP.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-a22ac213 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6837 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(System.Drawing.SystemFonts.DefaultFont, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-82217ba5 | (진입점 미연결) | FP00643_Plan_Amend_Line_PSI_Elec.cs:6841 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(memo_cell.Font.Name, memo_cell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetNote

진입점: this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (fRow != null) ▸ if (!string.IsNullOrWhiteSpace(curversion)) ▸ if (!string.IsNullOrWhiteSpace(curversion)) ▸ if (VerisonVsWorkModel.ContainsKey(curversion)) ▸ else of (siSimul.ActiveSheet.Cells[row, col].NoteStyle == NoteStyle.StickyNote)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1686fde | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11559 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | GRID_SET | siSimul.ActiveSheet.Cells[last_over_row, last_over_col].Note | "" | 그리드 속성/값 설정 |  |  |  |
| AC-5c54785a | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11560 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | GRID_SET | siSimul.ActiveSheet.Cells[last_over_row, last_over_col].NoteStyle | NoteStyle.Hidden | 그리드 속성/값 설정 |  |  |  |
| AC-c270e66e | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11567 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | GRID_SET | siSimul.ActiveSheet.Cells[row, col].Note | note | 그리드 속성/값 설정 |  |  |  |
| AC-105f1e76 | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11568 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | GRID_SET | siSimul.ActiveSheet.Cells[row, col].NoteStyle | NoteStyle.StickyNote | 그리드 속성/값 설정 |  |  |  |
| AC-d4b9c501 | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11569 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | FLAG | last_over_row | row | 화면 필드/플래그 변경 |  |  |  |
| AC-a3bdf97e | this.spdSimul.MouseMove [try ▸ if (colname.ToUpper().Contain… | FP00643_Plan_Amend_Line_PSI_Elec.cs:11570 | else of (row == -1 \|\| col == -1) ▸ else of (last_over_row == row && last_over_col == col) ▸ try | FLAG | last_over_col | col | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetPlanGroupFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7306e4c9 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3865 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b29033c7 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3866 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-f555ff63 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3866 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-b4c69f42 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3867 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78844658 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3868 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21c8aefd | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3869 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9eee0db5 | this.Load | FP00643_Plan_Amend_Line_PSI_Elec.cs:3873 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetPlannerFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a228cbb | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3888 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3d77ca2 | this.Load 외 2 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3892 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetPlanOutCell

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3a1f760 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7122 | if (string.IsNullOrWhiteSpace(ColumnName_Buf)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbbd4974 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7144 | if (!can_change) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-e8b48b03 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7145 | if (!can_change) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-38048792 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7146 | if (!can_change) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c349070 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7164 | if (new_value != round_value) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | round_value | 그리드 속성/값 설정 |  |  |  |
| AC-e317b0f6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7167 | if (new_value != round_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-441ed91c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7176 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-ef6019bf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7221 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd2a3fd7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7222 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-e378573a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7223 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-02bf1574 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7224 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-42630169 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7225 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-28070039 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7226 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3f27d8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7227 | lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-73477acd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7228 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8471dba0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7229 | lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-77d12728 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7230 | lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-150ce1f7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7231 | lambda | DATA_OP | x.Field | ("RELEASE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b791bc0d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7232 | lambda | DATA_OP | x.Field | ("WORK_REQUEST_MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc46426 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7233 | lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-701e533a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7234 | lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-3683c61f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7237 | lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-86ad88b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7253 | else of (m.Count() > 0) | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f16a74e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7262 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-efe0244f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7267 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-1768e7aa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7271 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d010b96a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7273 | else of (m.Count() > 0) | DATA_OP | newRow["INSTANCE_ID"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ab861fd0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7274 | else of (m.Count() > 0) | DATA_OP | newRow["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0b3396f2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7275 | else of (m.Count() > 0) | DATA_OP | newRow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-7e3b8044 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7276 | else of (m.Count() > 0) | DATA_OP | newRow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-643ada5b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7277 | else of (m.Count() > 0) | DATA_OP | newRow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-fedc276e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7278 | else of (m.Count() > 0) | DATA_OP | newRow["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-9f1497f1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7279 | else of (m.Count() > 0) | DATA_OP | newRow["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-2a6bda6b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7280 | else of (m.Count() > 0) | DATA_OP | newRow["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-0a2ae2e2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7281 | else of (m.Count() > 0) | DATA_OP | newRow["EQUIPMENT_ID"] | sEqup | 행/컬럼 값 대입 |  |  |  |
| AC-170e97d8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7282 | else of (m.Count() > 0) | DATA_OP | newRow["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-d4834442 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7283 | else of (m.Count() > 0) | DATA_OP | newRow["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-96d0a975 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7284 | else of (m.Count() > 0) | DATA_OP | newRow["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-7834a453 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7285 | else of (m.Count() > 0) | DATA_OP | newRow["ITEM_ID"] | sItem | 행/컬럼 값 대입 |  |  |  |
| AC-5f0ea014 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7287 | else of (m.Count() > 0) | DATA_OP | newRow["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-7613811c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7288 | else of (m.Count() > 0) | DATA_OP | newRow["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-34e41f67 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7289 | else of (m.Count() > 0) | DATA_OP | newRow["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-9aeb0902 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7290 | else of (m.Count() > 0) | DATA_OP | newRow["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-6f821217 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7291 | else of (m.Count() > 0) | DATA_OP | newRow["WORK_REQUEST_MODEL_ID"] | sTopm | 행/컬럼 값 대입 |  |  |  |
| AC-830afc81 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7292 | else of (m.Count() > 0) | DATA_OP | newRow["VERSION"] | sVers | 행/컬럼 값 대입 |  |  |  |
| AC-5c8deb55 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7293 | else of (m.Count() > 0) | DATA_OP | newRow["PROD_SEQ"] | sProS | 행/컬럼 값 대입 |  |  |  |
| AC-fa25a5d4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7294 | else of (m.Count() > 0) | DATA_OP | newRow["PLM_EC_NO"] | sPlmE | 행/컬럼 값 대입 |  |  |  |
| AC-d308067d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7297 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-73f513ef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7312 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-f7ad894f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7313 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["SEQ"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-4b160227 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7318 | else of (sCate == "P_SEQ") | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-7d77b3c8 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7325 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-86dcd824 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7330 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-736a6269 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7331 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (new_value >= 50) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-230329a7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7366 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_M] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-7b1ca7c9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7368 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-dcf24f9e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7369 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-5647212e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7370 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-56d3a3de | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7372 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-34ee8d87 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7373 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-0a2ff54b | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7389 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_CELL] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-b2c88936 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7395 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_JR] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-ef694aa2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7408 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-ece2b986 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7410 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-b91605ef | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7411 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-3a07869c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7412 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-a04923fa | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7414 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-001c02cf | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7415 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-46467515 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7426 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-2933bfc9 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7432 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ else of (nInValue == 0) | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-239efb7a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7462 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-8a9d8441 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7480 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_jr"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-5ca8400c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7486 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-0e5185b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7505 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_pc"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-5e3a4839 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7513 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-80ff0737 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7533 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_cell"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-f82f9076 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7545 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-bf47cba2 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7564 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-19d093b5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7571 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-b8d75971 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7590 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) ▸ if (res != null … | DATA_OP | res[0][ColumnName_Buf] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-5e18fc30 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7597 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-bd80a600 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7617 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) ▸ if (res != nul… | DATA_OP | res[0][ColumnName_Buf] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-69acf078 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7624 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-30e7e3dc | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7643 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) ▸ if (res != nu… | DATA_OP | res[0][ColumnName_Buf] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-af7e9f5e | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7652 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-11ee5e1a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7680 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if (Filter["PLAN_TYPE"] != "RELEASE") ▸ if (res… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-8b573fe4 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7685 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) | CALL_EXT | dsMainFiltered.Tables[0].Rows[idx]["SEQ"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-47a52083 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7691 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (measure["chk_seq"].On) ▸ if ((nInValue > 0) && oldseq == 0) ▸ if (res !=… | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetPostyield

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6420f1dd | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7728 |  | CALL_EXT | dsPostYield.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71ef99ca | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7743 |  | CALL_EXT | dsPostYield.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51516f9c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7752 |  | RETURN | return rtn; |  | 처리 중단/반환 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetReleaseProcess

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ try] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0) ▸ try ▸ try] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-675f77b1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3530 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0576f0b4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3536 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) | FLAG | DbCurrentDate | DateTime.ParseExact(curr_date, "yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-c834c775 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3541 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < DbCurre… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-f59a56b2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3545 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < Db… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-896c6f46 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3551 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-93f8d1f3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3552 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0759d5ac | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3553 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e858f1a7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3554 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnSetupColor.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ac71b5b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3556 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-512ede2a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3557 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["RELEASE_VALUE"] | ds_isCurrWeek.Tables[0].Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3741164 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3562 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c892d5c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:3563 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetSimulValue

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH")) ▸ if (Filter["PLAN_TYPE"].ToString() != "RELEASE")] / bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eacf09f0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7762 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc7d1a08 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7763 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-edcee62a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7764 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d21287b7 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7766 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2de9f6b6 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7767 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cef12aba | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7761 | lambda | RETURN | return( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString() … |  | 처리 중단/반환 |  |  |  |
| AC-cc73e843 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7775 | foreach (DataRow related_row in relating_rows) | DATA_OP | related_row[ColumnName_Buf] | related_row[ColumnName_Buf].SafeDouble() + nOut_M_Gap | 행/컬럼 값 대입 |  |  |  |
| AC-473c3f72 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7776 | foreach (DataRow related_row in relating_rows) | DATA_OP | related_row[ColumnName_Buf + "_CELL"] | related_row[ColumnName_Buf + "_CELL"].SafeDouble() + nOut_CELL_Gap | 행/컬럼 값 대입 |  |  |  |
| AC-ef5da3c0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7784 | lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e3796d1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7785 | lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a09cf751 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7786 | lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1861a2f0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7788 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64c9bf4f | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7789 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-82430bf5 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7783 | lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-8456ab9a | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7798 | foreach (DataRow related_row in relating_rows) | DATA_OP | related_row[ColumnName_Buf] | related_row[ColumnName_Buf].SafeDouble() + nOut_M_Post_Gap | 행/컬럼 값 대입 |  |  |  |
| AC-cc4427a1 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7799 | foreach (DataRow related_row in relating_rows) | DATA_OP | related_row[ColumnName_Buf + "_CELL"] | related_row[ColumnName_Buf + "_CELL"].SafeDouble() + nOut_CELL_Post_Gap | 행/컬럼 값 대입 |  |  |  |
| AC-6d463564 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… 외 5 | FP00643_Plan_Amend_Line_PSI_Elec.cs:7807 |  | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetSpreadInit

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d83111e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:545 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-85c3c8a0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 14 | FP00643_Plan_Amend_Line_PSI_Elec.cs:546 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SetTotalColor

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK) ▸ try ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (me…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd9a59ea | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:727 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL": | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, total_color) | 그리드 표시 설정 |  |  |  |
| AC-1b947856 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:730 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL_2": | GRID_STYLE | siMain.SetBGColor3 | (line, substart, line, last_col, sub_total_color) | 그리드 표시 설정 |  |  |  |
| AC-5bf39eb6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 13 | FP00643_Plan_Amend_Line_PSI_Elec.cs:737 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if (idx_version > -1 && sMaxVer… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbf3ca28 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9980 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7c0964d | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9981 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6629ea1f | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10004 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-d8b0303b | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10005 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-2899e3fc | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10007 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f5d30bc | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10026 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-9931d030 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10027 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-45460def | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10029 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f23e5f7 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10038 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4076a522 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10043 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_line_menu.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-e6fb474b | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10044 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-ca86c945 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10046 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-553169f1 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10050 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_mat_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-aee19665 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10051 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_mat_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-68d985b3 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10053 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_mat_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-72730ba2 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10057 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_all_line_menu.Text | "Zero Setting(All Line)" | 컨트롤 값 설정 |  |  |  |
| AC-75c3350d | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10058 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_all_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-a346723d | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10060 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_all_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc363038 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10064 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | line_change_menu.Text | "Line Change" | 컨트롤 값 설정 |  |  |  |
| AC-8c373174 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10065 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | line_change_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-e47f5c07 | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10067 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (line_change_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-6957d72c | this.spdMain.CellClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:10075 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1df6be47 | this.spdMain.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9809 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ else of (day != null) ▸ if (row != null && siSimul != null) ▸ foreach (FarPoint.Win.Spread.… | GRID_STYLE | siSimul.SpreadObject.SetViewportTopRow | (0, rRow.Index) | 그리드 표시 설정 |  |  |  |
| AC-34ec84ac | this.spdMain.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9810 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ else of (day != null) ▸ if (row != null && siSimul != null) ▸ foreach (FarPoint.Win.Spread.… | GRID_INIT | siSimul.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e81b711 | this.spdMain.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9811 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ else of (day != null) ▸ if (row != null && siSimul != null) ▸ foreach (FarPoint.Win.Spread.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-990371ef | this.spdMain.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9824 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-d0b02146 | this.spdMain.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:9831 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51abec3f | this.spdMain.ClipboardPasted | FP00643_Plan_Amend_Line_PSI_Elec.cs:8856 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c72ac8e | this.spdMain.ClipboardPasted | FP00643_Plan_Amend_Line_PSI_Elec.cs:8864 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5f7eee70 | this.spdMain.ClipboardPasted | FP00643_Plan_Amend_Line_PSI_Elec.cs:8865 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2db62aee | this.spdMain.ClipboardPasted | FP00643_Plan_Amend_Line_PSI_Elec.cs:8867 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f40c4a3 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8831 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-58017783 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8832 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-db05ed45 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8832 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc832857 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8836 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-0044be09 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8836 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3d04205 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8840 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a358c924 | this.spdMain.ClipboardPasting | FP00643_Plan_Amend_Line_PSI_Elec.cs:8842 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a08ec6ea | this.spdMain.EditModeOn | FP00643_Plan_Amend_Line_PSI_Elec.cs:8914 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ae0be0c | this.spdMain.KeyDown | FP00643_Plan_Amend_Line_PSI_Elec.cs:8292 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-e50297cf | this.spdMain.KeyDown | FP00643_Plan_Amend_Line_PSI_Elec.cs:8296 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24f985ac | this.spdMain.KeyDown | FP00643_Plan_Amend_Line_PSI_Elec.cs:8297 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdSimul_CellDoubleClick

진입점: this.spdSimul.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffe145bb | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11217 | try | DATA_OP | colname.ToUpper().Contains | ("STOCK_VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-52f42927 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11229 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) | DATA_OP | all_v_list.Contains | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-996192fd | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11231 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Contains | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-41397aea | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11234 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Remove | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c9894bb | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11239 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | sell_v_list.Add | (toggle_version) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dcd9a79 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11243 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | CALL_EXT | dsSimulDate.Tables[0].AsEnumerable() .Where(x => ( x.Field<string>("COMPANY_ID") == fRow["… | (r => { r["STOCK_VERSION_SEL"] = sell_list; } ) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbce7b27 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11245 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c9a11b54 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11246 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3274ddc2 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11247 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c3c95b43 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11248 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("PROD_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-45e6b07b | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11249 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d697570a | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11253 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (!string.IsNullOrWhiteSpace(toggle_version)) ▸ if (all_v_list.Contains(toggle_ve… | DATA_OP | r["STOCK_VERSION_SEL"] | sell_list | 행/컬럼 값 대입 |  |  |  |
| AC-8cab221a | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11269 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.CreateManualSearchCondtion | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea09f252 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11270 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_division", row["DIVISION_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-795cf7a9 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11271 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "cbo_site", row["SITE_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-553e7c7f | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11272 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_EXT | BaseForm.SetManualCondition | (Msc, "txtItemID", row["ITEM_ID"].SafeString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f19d050 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11273 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | CALL_BASE | openSubMenu | ("FPC0623", true, true, Msc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1097f4d7 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11281 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9c26efe3 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11282 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87e278ac | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11283 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ebc31214 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11284 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36d3b6ad | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11285 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-514d16df | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11296 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter["DAY_VALUE"] | aDay | 행/컬럼 값 대입 |  |  |  |
| AC-06d6a137 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11303 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | POPUP | new FP00643_receipt_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-21677e2b | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11304 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-743706b8 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11304 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7708fac5 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11305 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-0693c6c1 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11306 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2db8a71a | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11307 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (colname.ToUpper().StartsWith("D")) ▸ if (row["CATEGORY_ID"].ToString() == … | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b3eb7541 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11317 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fe4aa5d | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11318 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-4662ae36 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11319 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GOOD_BOFORE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ec8d881 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11320 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ed551d0 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11321 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-b94aef13 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11322 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("QMS_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-c672ff19 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11323 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-966be95c | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11324 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ad4625 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11325 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("GMES_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2a2a8e8 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11326 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) | DATA_OP | colname.ToUpper().Contains | ("PANCAKE_GOOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d97098a | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11332 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["POP_TYPE"] | "BOH" | 행/컬럼 값 대입 |  |  |  |
| AC-fd0313a3 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11333 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85d6f9f5 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11334 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3e0b674b | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11335 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5f125421 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11336 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ae4f2610 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11337 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c72aaa3 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11340 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3930a81 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11340 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-8a3ac63c | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11341 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7633994 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11341 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-1794bb2b | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11342 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GOOD_BOFORE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba0aa075 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11342 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-9a6e1b1f | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11343 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e37c3b1 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11343 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-1d9f12b1 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11344 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-a2b4c5ee | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11344 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-83c516af | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11345 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("QMS_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bac75c7 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11345 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.QMS_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-1b1842e6 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11346 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-631dd890 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11346 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_ELEC_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-d9c4c655 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11347 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_REWORK") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad899efc | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11347 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_RW_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-0ffc4a70 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11348 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("GMES_BOFORE_NT") | 데이터 객체 조작/조회 |  |  |  |
| AC-40fdeec2 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11348 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GMES_ASSY_QTY > 0" | 행/컬럼 값 대입 |  |  |  |
| AC-9b6a5b76 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11349 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | colname.ToUpper().Contains | ("PANCAKE_GOOD") | 데이터 객체 조작/조회 |  |  |  |
| AC-30dfa6d3 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11349 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND A.GOOD_ELEC_QTY + A.GOOD_RW_QTY + A.GOOD_ASSY_QTY > 0 AND A.LANE = 1" | 행/컬럼 값 대입 |  |  |  |
| AC-4df1e0f9 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11367 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_VERSION_LT"] | "AND A.VERSION IN ( " + sVer + " )" | 행/컬럼 값 대입 |  |  |  |
| AC-aa594f1a | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11371 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter["CTRL_VERSION_LT"] | "AND A.VERSION IS NULL" | 행/컬럼 값 대입 |  |  |  |
| AC-ae64c037 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11375 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | POPUP | new FP00643_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-47bde85e | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11376 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-9016e475 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11376 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e317a57f | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11377 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-70c2d8f1 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11378 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-e1bcbd98 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11379 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ if ((colname.ToUpper().Contains(… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e0adb569 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11388 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_GOOD_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-be2fc01d | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11389 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_HOLD_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-17164396 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11394 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["POP_TYPE"] | "RECEIPT" | 행/컬럼 값 대입 |  |  |  |
| AC-164684f5 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11395 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["INSTANCE_ID"] | Filter["INSTANCE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-82d5184d | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11396 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["PLAN_DATE"] | Filter["PLAN_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-90c13693 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11397 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["DIVISION_ID"] | clicked_row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-109335e2 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11398 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["SITE_ID"] | clicked_row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4cac6fd1 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11399 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d75f114 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11402 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_GOOD_QTY_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-52dbccd0 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11402 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND B.STOCK_TYPE = 'GOOD'" | 행/컬럼 값 대입 |  |  |  |
| AC-a0388735 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11403 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | colname.ToUpper().Contains | ("RECEIPT_HOLD_QTY_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c6b2c8b | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11403 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter["CTRL_QTY_CONDITION_LT"] | "AND B.STOCK_TYPE = 'GOOD'" | 행/컬럼 값 대입 |  |  |  |
| AC-8b3288cb | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11405 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | POPUP | new FP00643_InvDetail_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-895fab54 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11406 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.Filter | inputFilter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-b3adb653 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11406 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | DATA_OP | inputFilter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6ad15ba | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11407 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-8d3e4ef4 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11408 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-6bab0844 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11409 | try ▸ else of (colname.ToUpper().Contains("STOCK_VERSION")) ▸ else of (colname.ToUpper().StartsWith("D")) ▸ else of ((colname.ToUpper().Cont… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-cfafc096 | this.spdSimul.CellDoubleClick | FP00643_Plan_Amend_Line_PSI_Elec.cs:11421 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.spdSimul_MouseMove

진입점: this.spdSimul.MouseMove

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1167688f | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11595 |  | CALL_EXT | spdSimul.HitTest | (e.X, e.Y) | ⚠ 의미 확인 필요 |  |  |  |
| AC-695f9c5e | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11597 | if (h == null \|\| h.ViewportInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2c59332b | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11604 | if (col == -1 \|\| row == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fce6b62 | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11609 | try | DATA_OP | colname.ToUpper().Contains | ("STOCK_VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-98c52d06 | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11627 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (fRow != null) ▸ if (!string.IsNullOrWhiteSpace(curversion)) ▸ if (all_match != … | DATA_OP | VerisonVsWorkModel.ContainsKey | (kv[0]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b627bb71 | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11629 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (fRow != null) ▸ if (!string.IsNullOrWhiteSpace(curversion)) ▸ if (all_match != … | DATA_OP | VerisonVsWorkModel.Add | (kv[0], kv[1]) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ccdaa03 | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11636 | try ▸ if (colname.ToUpper().Contains("STOCK_VERSION")) ▸ if (fRow != null) ▸ if (!string.IsNullOrWhiteSpace(curversion)) ▸ if (!string.IsNul… | DATA_OP | VerisonVsWorkModel.ContainsKey | (curversion) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d06c9ac | this.spdSimul.MouseMove | FP00643_Plan_Amend_Line_PSI_Elec.cs:11654 | catch ((Exception ee)) | THROW | throw ee; |  | 예외 발생 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.SwitchMemo

진입점: this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())] / memo_menu.Click [if (day != null) ▸ if (day != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2125a7f1 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9842 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad913b37 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9859 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-69472ee3 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9884 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d0fa7b2 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9910 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-0e0b36ff | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9912 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-1e34a459 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9915 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-591a8d66 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9917 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-05af3092 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9917 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-352c4a57 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9918 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-89d1deed | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9920 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-a258451e | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9922 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1e58b92e | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9934 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc82e506 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9934 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-7908af90 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9954 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-facb2da1 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9955 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-f5f15e97 | this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equ… 외 1 | FP00643_Plan_Amend_Line_PSI_Elec.cs:9957 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4436ca9a | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8611 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e1cbb8db | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8616 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f05ad90 | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8617 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-c94845a2 | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8618 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-01a11bfe | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8619 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 70) | 데이터 객체 조작/조회 |  |  |  |
| AC-576a0e34 | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8620 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 200) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc8162fd | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8621 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-94e1f5af | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8626 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-d0c078d3 | tbNickName.BeforeOpenSearch | FP00643_Plan_Amend_Line_PSI_Elec.cs:8627 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6e8e6ac | tbNickName.OnSearchConditionChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8633 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICKNAME", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ea30387 | tbNickName.OnSearchConditionChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8634 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-97a8a64c | tbNickName.OnSearchConditionChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8640 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-2db9662c | tbNickName.OnSearchConditionChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8644 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.TextValue | 행/컬럼 값 대입 |  |  |  |
| AC-1a0d555b | tbNickName.OnSearchConditionChanged | FP00643_Plan_Amend_Line_PSI_Elec.cs:8646 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.btnCapaSync.Click [if (popup.DialogResult == DialogResult.OK)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.usrButton1.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0)] / this.btn_bucket.Click [if (frm.DialogResult ==…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-687633ee | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1124 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16d8b921 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1125 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eafc1873 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1128 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-679ec11c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1133 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0d50fe72 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1137 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a75b5c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1143 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f648316d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1144 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05c6130c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1147 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b59954 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1156 | try | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-80d6d149 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1156 | try | DATA_OP | Filter["FP_PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-2d528fce | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1164 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-0a32c398 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1180 | try ▸ try | FLAG | sVERSION_YN | dtInstance.Lookup("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN").ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4757f38 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1180 | try ▸ try | CALL_EXT | dtInstance.Lookup | ("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dd56189 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1181 | try ▸ try | DATA_OP | Filter["VERSION_YN"] | sVERSION_YN | 행/컬럼 값 대입 |  |  |  |
| AC-23813bd4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1184 | try ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595", "find_isPDS", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] \| FP\Planning\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8b7281e4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1185 | try ▸ try | DATA_OP | Filter["IS_PDS"] | (dtPDS.getColumn(0, "IS_PDS")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0cc58c52 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1185 | try ▸ try | DATA_OP | dtPDS.getColumn | (0, "IS_PDS") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7127a537 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1193 | try ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1deda774 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1199 | try ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-51cf06d5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1200 | try ▸ try | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-af48341b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1202 | try ▸ try | FLAG | dsSimulBoh | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c479163f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1203 | try ▸ try | FLAG | dsSimulDate | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e2ba2d5e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1209 | try ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b3f2f6cd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1210 | try ▸ try | UI_MISC | siSimul.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-55d79753 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1211 | try ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0cedca1c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1215 | try ▸ try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d1ef797 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1221 | try ▸ try | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-82f2d783 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1229 | try ▸ try | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-378fd6b8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1230 | try ▸ try | DATA_OP | Filter2["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6c5efe35 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1231 | try ▸ try | DATA_OP | Filter2["CTRL_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-20021dd2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1232 | try ▸ try | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-89ef757a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1234 | try ▸ try ▸ if (Filter2["PROD_TYPE"] == "") | DATA_OP | Filter2["PROD_TYPE"] | Filter2["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-528b6953 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1236 | try ▸ try ▸ if (Filter2["TOP_ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | " AND A.TOP_ITEM_ID LIKE '%' + @TOP_ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-6b9bcbf5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1238 | try ▸ try ▸ if (Filter2["ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_ITEM_ID"] | " AND A.ITEM_ID LIKE '%' + @ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-a587bed6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1243 | try ▸ try | UI_PROP | asyncProxy_Nick.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-47b24c27 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1245 | try ▸ try | FLAG | dtNickName | await asyncProxy_Nick.ExecuteAsync<DataTable>(() => DataService.FP_ExecuteQuery2("FP00595_… | 화면 필드/플래그 변경 |  |  |  |
| AC-f0715c90 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1245 | try ▸ try | ENDPOINT | asyncProxy_Nick.ExecuteAsync | (() => DataService.FP_ExecuteQuery2("FP00595_ROW", "find_FPNickName", Filter2.Dictionary, … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3fa25df0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1247 | try ▸ try ▸ lambda | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "find_FPNickName", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FPNickName] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-682e7cce | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1265 | try ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5b0847c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1267 | try ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c762c7d9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1272 | try ▸ try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-ffcecc68 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1273 | try ▸ try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b29d61c4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1279 | try ▸ try ▸ if (sInstance == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-165b89a5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1280 | try ▸ try ▸ if (sInstance == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2abbc406 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1294 | try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5d43ed0c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1295 | try ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-68d227fe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1295 | try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e51379b1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1298 | try ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-12deae8b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1299 | try ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-342d9468 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1301 | try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b85ea28d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1302 | try ▸ try | FLAG | dsSimulDate | await asyncProxy.ExecuteAsync<DataSet>(() => FindSimulData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-24573250 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1302 | try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindSimulData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7c9472d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1305 | try ▸ try | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0609f3b5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1306 | try ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ac74dba3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1308 | try ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e84d088c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1309 | try ▸ try | FLAG | dsSimulBoh | await asyncProxy.ExecuteAsync<DataSet>(() => FindBohData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-c01a60a8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1309 | try ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindBohData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d8d4cbdb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1315 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_MM_", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9961d76 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1316 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2dddb00 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1317 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e175320 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1318 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-235df024 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1319 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5ce4836 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1320 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-12c88dd6 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1322 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-67af6ce3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1323 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-200931c9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1324 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b403746 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1325 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a91397b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1326 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dd6ae0d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1328 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a388323d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1329 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0343f1a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1330 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0667fa3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1331 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47684017 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1332 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93cf3eca | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1333 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-136d4f9f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1334 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c03a458e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1335 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd0ebbc7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1337 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9f8b639 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1338 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-699937a5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1339 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6bf7046f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1340 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c32063b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1341 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f4ce808 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1342 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82a8eb45 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1343 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-908b82bb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1344 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-490bbaf7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1346 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-28b140b2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1347 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5dacb30d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1354 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) case "P_MPP_IN_B… | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-b918c71b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1357 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) case "P_WPP_IN_B… | DATA_OP | row["RELEASE_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-2a33a9f4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1360 | try ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow row in dsMain.Tables[0].Rows) ▸ switch (cate) default: | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-70f5a903 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1389 | try ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c59a5a7c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1397 | try ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dca7d7da | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1402 | try ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0aae093c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1403 | try ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-55434111 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1412 | try ▸ try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6a86d999 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1416 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-068eb28d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1418 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cf71c295 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1419 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2d15b4d9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1420 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b5d60f16 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1421 | try ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f0066d24 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1425 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ce057f44 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1427 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-79b7f684 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1428 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba08cc9f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1429 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-560c1a5e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1430 | try ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-aad2918a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1448 | try ▸ try ▸ try ▸ if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b7c3cf65 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1470 | try ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8d60cfd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1474 | try ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0a25b66a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1480 | try ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1aef952e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1487 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5bd4b38f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1488 | try ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-50ed0687 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1499 | try | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2954f213 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1506 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-100cefa5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1510 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3f027c74 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 9 | FP00643_Plan_Amend_Line_PSI_Elec.cs:1514 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00643_Plan_Amend_Line_PSI_Elec.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b715b6d | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3695 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-463aacdf | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3697 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-df13e41d | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3698 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-03cde2fe | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3702 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_success == true) | MESSAGE | MessageBox.Show | ("Data saved", "Save result") | 메시지 표시 |  |  |  |
| AC-1dd732f0 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3706 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ else of (save_success == t… | MESSAGE | MessageBox.Show | ("Data not saved", "Save result") | 메시지 표시 |  |  |  |
| AC-c91ec969 | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3714 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-236f058d | SaveButton | FP00643_Plan_Amend_Line_PSI_Elec.cs:3718 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_receipt_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12991ff8 | (진입점 미연결) | FP00643_receipt_Popup.cs:332 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f9c12379 | (진입점 미연결) | FP00643_receipt_Popup.cs:335 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-172a354a | (진입점 미연결) | FP00643_receipt_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_receipt_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a8f12b6 | this.Load | FP00643_receipt_Popup.cs:143 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ecb7235 | this.Load | FP00643_receipt_Popup.cs:144 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-534c2824 | this.Load | FP00643_receipt_Popup.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_receipt_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d01f435 | this.Load | FP00643_receipt_Popup.cs:138 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_receipt_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a233ca4 | Dispose | FP00643_receipt_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_receipt_Popup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5490119e | ExcelButton | FP00643_receipt_Popup.cs:207 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00643_receipt_Popup.Find_Data_Line

진입점: this.Load [try ▸ lambda] / FindButton [try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b37b65f | this.Load [try ▸ lambda] 외 2 | FP00643_receipt_Popup.cs:265 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00623", "find_intransit_Detail", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_intransit_Detail] \| FP\Pl… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aa1e1740 | this.Load [try ▸ lambda] 외 2 | FP00643_receipt_Popup.cs:297 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-b5a0109a | this.Load [try ▸ lambda] 외 2 | FP00643_receipt_Popup.cs:301 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_receipt_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a2ea004 | this.Load 외 2 | FP00643_receipt_Popup.cs:222 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-84979b7e | this.Load 외 2 | FP00643_receipt_Popup.cs:228 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_Line("SELECT", pSysFlag) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8105eac9 | this.Load 외 2 | FP00643_receipt_Popup.cs:235 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-1989734b | this.Load 외 2 | FP00643_receipt_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bd8c851b | this.Load 외 2 | FP00643_receipt_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | FLAG | dtFindData | dsMain.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-a970406a | this.Load 외 2 | FP00643_receipt_Popup.cs:250 | try ▸ else of (dsMain.Tables[0].Rows.Count > 0) | LIST_BIND | spdMain.DataSource | dsMain.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-ef70db3c | this.Load 외 2 | FP00643_receipt_Popup.cs:256 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00643_receipt_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd1283ad | this.Load | FP00643_receipt_Popup.cs:115 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b8d1678 | this.Load | FP00643_receipt_Popup.cs:117 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_receipt_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cd35092 | this.Load | FP00643_receipt_Popup.cs:155 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f83b67fb | this.Load | FP00643_receipt_Popup.cs:156 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_receipt_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c99c99 | (진입점 미연결) | FP00643_receipt_Popup.cs:177 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_receipt_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e5058e7 | this.Load | FP00643_receipt_Popup.cs:162 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-edee637a | this.Load | FP00643_receipt_Popup.cs:163 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5ecdb656 | this.Load | FP00643_receipt_Popup.cs:167 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00643_receipt_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e285629 | this.spdMain.CellClick | FP00643_receipt_Popup.cs:347 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-744a9bcb | this.spdMain.CellClick | FP00643_receipt_Popup.cs:348 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4e68f77b | this.spdMain.CellClick | FP00643_receipt_Popup.cs:351 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00643_receipt_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-882161a3 | this.spdMain.CellDoubleClick | FP00643_receipt_Popup.cs:357 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-69ccb8bb | this.spdMain.CellDoubleClick | FP00643_receipt_Popup.cs:358 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-16d096ee | this.spdMain.CellDoubleClick | FP00643_receipt_Popup.cs:361 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-7e093232 | this.spdMain.CellDoubleClick | FP00643_receipt_Popup.cs:364 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_receipt_Popup.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31a3089 | this.spdMain.EditChange | FP00643_receipt_Popup.cs:491 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf97c88a | .ctor | FP00643_RowExcelPopup.cs:158 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-55fc8509 | .ctor | FP00643_RowExcelPopup.cs:159 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c39723b | .ctor | FP00643_RowExcelPopup.cs:160 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c8d07521 | .ctor | FP00643_RowExcelPopup.cs:161 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-5122133f | .ctor | FP00643_RowExcelPopup.cs:162 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00643_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0968205 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:236 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-4bc60453 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:237 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f5a75251 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:238 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2d556da8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:239 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dd974872 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:241 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3764b43 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:241 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-791adea5 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:242 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-8ce10386 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:242 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fbef75b4 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:243 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-9f014d03 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:243 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-47d5be93 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:244 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-f26d6b99 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:244 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-087a372f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:253 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-cec90483 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:254 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-3b69d6e8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:255 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-6f0de09f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00643_RowExcelPopup.cs:256 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00643_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f0af2d8 | this.btnClose.Click | FP00643_RowExcelPopup.cs:931 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b196cfbc | this.btnDownload.Click | FP00643_RowExcelPopup.cs:911 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-6e7ac48b | this.btnDownload.Click | FP00643_RowExcelPopup.cs:912 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00643_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59286186 | this.btnFind.Click | FP00643_RowExcelPopup.cs:902 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-68f7ec21 | this.btnFind.Click | FP00643_RowExcelPopup.cs:903 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00643_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52817afa | this.Load | FP00643_RowExcelPopup.cs:284 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5aa85a0d | this.Load | FP00643_RowExcelPopup.cs:285 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f0bad4a7 | this.Load | FP00643_RowExcelPopup.cs:286 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_RowExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27818cbb | dateRange.ValueChanged | FP00643_RowExcelPopup.cs:936 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-9ae98922 | dateRange.ValueChanged | FP00643_RowExcelPopup.cs:937 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00643_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e02d253f | (진입점 미연결) | FP00643_RowExcelPopup.cs:865 |  | CALL_EXT | ExcelService.CommonDefaultLineCheckReleaseExcept | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3102ab5 | (진입점 미연결) | FP00643_RowExcelPopup.cs:865 |  | RETURN | return ExcelService.CommonDefaultLineCheckReleaseExcept(row, KeyColumnList, Colu… |  | 처리 중단/반환 |  |  |  |

## FP00643_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61b1d078 | this.Load | FP00643_RowExcelPopup.cs:279 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41238101 | Dispose | FP00643_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1032cd1 | (진입점 미연결) | FP00643_RowExcelPopup.cs:750 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00643_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69f82ccd | FindButton | FP00643_RowExcelPopup.cs:327 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dd62e496 | FindButton | FP00643_RowExcelPopup.cs:328 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-066576da | FindButton | FP00643_RowExcelPopup.cs:330 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0415323d | this.Load 외 2 | FP00643_RowExcelPopup.cs:357 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-19b97a83 | this.Load 외 2 | FP00643_RowExcelPopup.cs:358 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-81261692 | this.Load 외 2 | FP00643_RowExcelPopup.cs:358 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e5898bbd | this.Load 외 2 | FP00643_RowExcelPopup.cs:362 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2273bd | this.Load 외 2 | FP00643_RowExcelPopup.cs:363 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aac78887 | this.Load 외 2 | FP00643_RowExcelPopup.cs:365 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c0668c48 | this.Load 외 2 | FP00643_RowExcelPopup.cs:366 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1577b738 | this.Load 외 2 | FP00643_RowExcelPopup.cs:367 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cd985cb2 | this.Load 외 2 | FP00643_RowExcelPopup.cs:368 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e5ac5751 | this.Load 외 2 | FP00643_RowExcelPopup.cs:369 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9f59c69d | this.Load 외 2 | FP00643_RowExcelPopup.cs:370 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d311d11 | this.Load 외 2 | FP00643_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c50997a6 | this.Load 외 2 | FP00643_RowExcelPopup.cs:382 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-1ed29b1e | this.Load 외 2 | FP00643_RowExcelPopup.cs:384 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-4f2c23a8 | this.Load 외 2 | FP00643_RowExcelPopup.cs:385 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-4176ac97 | this.Load 외 2 | FP00643_RowExcelPopup.cs:386 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-d1b8c42f | this.Load 외 2 | FP00643_RowExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68c93096 | this.Load 외 2 | FP00643_RowExcelPopup.cs:391 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-995d93d4 | this.Load 외 2 | FP00643_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-43a2be28 | this.Load 외 2 | FP00643_RowExcelPopup.cs:392 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-61acb4fe | this.Load 외 2 | FP00643_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-9fa95bd8 | this.Load 외 2 | FP00643_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-54227ab5 | this.Load 외 2 | FP00643_RowExcelPopup.cs:394 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderFromDataSource(siMain, set, Co… | ⚠ 의미 확인 필요 |  |  |  |
| AC-95dbd6b8 | this.Load 외 2 | FP00643_RowExcelPopup.cs:396 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-de40c0dc | this.Load 외 2 | FP00643_RowExcelPopup.cs:396 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-2c8f9472 | this.Load 외 2 | FP00643_RowExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-8c404b85 | this.Load 외 2 | FP00643_RowExcelPopup.cs:403 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-f44efe8c | this.Load 외 2 | FP00643_RowExcelPopup.cs:404 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9beabbc8 | this.Load 외 2 | FP00643_RowExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b1db4b3d | this.Load 외 2 | FP00643_RowExcelPopup.cs:410 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85be38dc | this.Load 외 2 | FP00643_RowExcelPopup.cs:414 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-17e0613a | this.Load 외 2 | FP00643_RowExcelPopup.cs:417 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dd349bb8 | this.Load 외 2 | FP00643_RowExcelPopup.cs:420 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4702ad3d | this.Load 외 2 | FP00643_RowExcelPopup.cs:423 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b4c1359e | this.Load 외 2 | FP00643_RowExcelPopup.cs:426 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4908116e | this.Load 외 2 | FP00643_RowExcelPopup.cs:438 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set.Good() && ColumnColor.Count > 0) ▸ foreach (var m in ColumnColor.Data) ▸ if (c!=null) ▸ i… | GRID_STYLE | siMain.SetBGColor | (0, colIndex, rowcount-1, colIndex, c) | 그리드 표시 설정 |  |  |  |
| AC-602b6be9 | this.Load 외 2 | FP00643_RowExcelPopup.cs:442 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0a4bce4 | this.Load 외 2 | FP00643_RowExcelPopup.cs:451 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9f764d2 | this.Load 외 2 | FP00643_RowExcelPopup.cs:454 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-317e0033 | this.Load 외 2 | FP00643_RowExcelPopup.cs:455 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-407c8299 | this.Load 외 2 | FP00643_RowExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8819af38 | this.Load 외 2 | FP00643_RowExcelPopup.cs:457 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-47cc39ef | this.Load 외 2 | FP00643_RowExcelPopup.cs:458 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1dffac86 | this.Load 외 2 | FP00643_RowExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00643_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9e7bf74 | this.Load | FP00643_RowExcelPopup.cs:170 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b6347d2 | this.Load | FP00643_RowExcelPopup.cs:172 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-197bd124 | (진입점 미연결) | FP00643_RowExcelPopup.cs:724 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-63e77d2a | (진입점 미연결) | FP00643_RowExcelPopup.cs:725 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-4c5dbe26 | (진입점 미연결) | FP00643_RowExcelPopup.cs:726 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-20a8800b | (진입점 미연결) | FP00643_RowExcelPopup.cs:727 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-5fdb9398 | (진입점 미연결) | FP00643_RowExcelPopup.cs:728 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-05ecfdce | (진입점 미연결) | FP00643_RowExcelPopup.cs:729 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-d49292c1 | (진입점 미연결) | FP00643_RowExcelPopup.cs:730 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-276b96ea | (진입점 미연결) | FP00643_RowExcelPopup.cs:732 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-6834d7c5 | (진입점 미연결) | FP00643_RowExcelPopup.cs:733 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-2d57c1bc | (진입점 미연결) | FP00643_RowExcelPopup.cs:737 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-a59df767 | (진입점 미연결) | FP00643_RowExcelPopup.cs:738 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00643_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c288524 | this.Load | FP00643_RowExcelPopup.cs:212 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-636a2155 | this.Load | FP00643_RowExcelPopup.cs:213 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-7ef5aa6f | this.Load | FP00643_RowExcelPopup.cs:217 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-0b790fc0 | this.Load | FP00643_RowExcelPopup.cs:218 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-94013779 | this.Load | FP00643_RowExcelPopup.cs:221 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6c443ee0 | this.Load | FP00643_RowExcelPopup.cs:222 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c14e65e5 | this.Load | FP00643_RowExcelPopup.cs:226 |  | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00643_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8665edf5 | this.Load | FP00643_RowExcelPopup.cs:296 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e12c38f0 | this.Load | FP00643_RowExcelPopup.cs:297 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-033d5c17 | (진입점 미연결) | FP00643_RowExcelPopup.cs:317 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec98837f | this.btnUpload.Click | FP00643_RowExcelPopup.cs:762 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-86f3e021 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:762 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a75ddd4 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:764 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-622890ef | this.btnUpload.Click | FP00643_RowExcelPopup.cs:765 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-81b4dd89 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:766 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10ecb3c1 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:768 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1db83044 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-14fba112 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:773 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2349135a | this.btnUpload.Click | FP00643_RowExcelPopup.cs:780 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-715b5916 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:782 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b0a748ad | this.btnUpload.Click | FP00643_RowExcelPopup.cs:785 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d3060420 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:786 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-413b622e | this.btnUpload.Click | FP00643_RowExcelPopup.cs:790 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bb7ca34 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:791 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67b382e6 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:803 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38b13db9 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:807 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e94ce882 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:819 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20005823 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:822 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c90128c | this.btnUpload.Click | FP00643_RowExcelPopup.cs:825 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d762be71 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:829 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f511ca8 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:831 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-cbea3b9b | this.btnUpload.Click | FP00643_RowExcelPopup.cs:836 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2dad6f53 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:838 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-ee056241 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:844 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-412bb150 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:849 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-514716c3 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:853 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1e5f5727 | this.btnUpload.Click | FP00643_RowExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bd1b62fc | this.btnUpload.Click | FP00643_RowExcelPopup.cs:857 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00643_RowExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c92170ec | this.radioMPP.CheckedChanged | FP00643_RowExcelPopup.cs:943 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-39953e74 | this.radioMPP.CheckedChanged | FP00643_RowExcelPopup.cs:945 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00643_RowExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f20b221 | this.radioWPP.CheckedChanged | FP00643_RowExcelPopup.cs:952 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c68df238 | this.radioWPP.CheckedChanged | FP00643_RowExcelPopup.cs:954 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00643_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-babd25b4 | this.btnSave.Click | FP00643_RowExcelPopup.cs:473 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (radioMPP.Checked == true) | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-a9bdbbd8 | this.btnSave.Click | FP00643_RowExcelPopup.cs:475 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-2c5e3357 | this.btnSave.Click | FP00643_RowExcelPopup.cs:479 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-87442292 | this.btnSave.Click | FP00643_RowExcelPopup.cs:484 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-e56ba7d5 | this.btnSave.Click | FP00643_RowExcelPopup.cs:485 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e08aa3c | this.btnSave.Click | FP00643_RowExcelPopup.cs:489 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-92144a14 | this.btnSave.Click | FP00643_RowExcelPopup.cs:490 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0066a13 | this.btnSave.Click | FP00643_RowExcelPopup.cs:494 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-f32abe23 | this.btnSave.Click | FP00643_RowExcelPopup.cs:494 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5eebeb4 | this.btnSave.Click | FP00643_RowExcelPopup.cs:499 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c6934203 | this.btnSave.Click | FP00643_RowExcelPopup.cs:500 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8e74ad01 | this.btnSave.Click | FP00643_RowExcelPopup.cs:501 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e43764c3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:502 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-541fa7b3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:503 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a48b5ff7 | this.btnSave.Click | FP00643_RowExcelPopup.cs:504 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5dec1e23 | this.btnSave.Click | FP00643_RowExcelPopup.cs:512 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-baf26709 | this.btnSave.Click | FP00643_RowExcelPopup.cs:515 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-25d78e5e | this.btnSave.Click | FP00643_RowExcelPopup.cs:517 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4c6f7a3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:520 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-5cb010e5 | this.btnSave.Click | FP00643_RowExcelPopup.cs:525 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-5034036c | this.btnSave.Click | FP00643_RowExcelPopup.cs:526 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-43da3a9f | this.btnSave.Click | FP00643_RowExcelPopup.cs:533 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-fb0547a5 | this.btnSave.Click | FP00643_RowExcelPopup.cs:534 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1d008287 | this.btnSave.Click | FP00643_RowExcelPopup.cs:535 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4fc1739e | this.btnSave.Click | FP00643_RowExcelPopup.cs:536 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-106067bb | this.btnSave.Click | FP00643_RowExcelPopup.cs:537 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-99672d59 | this.btnSave.Click | FP00643_RowExcelPopup.cs:538 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8a9b274d | this.btnSave.Click | FP00643_RowExcelPopup.cs:539 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4d9a05b2 | this.btnSave.Click | FP00643_RowExcelPopup.cs:540 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c37762d1 | this.btnSave.Click | FP00643_RowExcelPopup.cs:543 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7c1c19a0 | this.btnSave.Click | FP00643_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-988baef6 | this.btnSave.Click | FP00643_RowExcelPopup.cs:547 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4b39044 | this.btnSave.Click | FP00643_RowExcelPopup.cs:582 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f55a67a | this.btnSave.Click | FP00643_RowExcelPopup.cs:584 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ae9fdad | this.btnSave.Click | FP00643_RowExcelPopup.cs:587 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3da99827 | this.btnSave.Click | FP00643_RowExcelPopup.cs:589 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) … | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-4902603a | this.btnSave.Click | FP00643_RowExcelPopup.cs:594 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a0c41eb | this.btnSave.Click | FP00643_RowExcelPopup.cs:596 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-749123a3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9f0171b4 | this.btnSave.Click | FP00643_RowExcelPopup.cs:603 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-65de4364 | this.btnSave.Click | FP00643_RowExcelPopup.cs:605 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f08ece7 | this.btnSave.Click | FP00643_RowExcelPopup.cs:608 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-69f85b22 | this.btnSave.Click | FP00643_RowExcelPopup.cs:612 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a517870 | this.btnSave.Click | FP00643_RowExcelPopup.cs:625 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-029a7474 | this.btnSave.Click | FP00643_RowExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-da2ecfb3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:629 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-61a53b24 | this.btnSave.Click | FP00643_RowExcelPopup.cs:633 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-8b071d9b | this.btnSave.Click | FP00643_RowExcelPopup.cs:648 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-fb10ee17 | this.btnSave.Click | FP00643_RowExcelPopup.cs:649 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-133e9aee | this.btnSave.Click | FP00643_RowExcelPopup.cs:653 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-8c5b17d3 | this.btnSave.Click | FP00643_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e258fcca | this.btnSave.Click | FP00643_RowExcelPopup.cs:660 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-f361c92e | this.btnSave.Click | FP00643_RowExcelPopup.cs:682 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-84f03c9e | this.btnSave.Click | FP00643_RowExcelPopup.cs:683 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9442fd99 | this.btnSave.Click | FP00643_RowExcelPopup.cs:684 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-03e3822d | this.btnSave.Click | FP00643_RowExcelPopup.cs:690 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-59ac5f2a | this.btnSave.Click | FP00643_RowExcelPopup.cs:694 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-9cb8ac5e | this.btnSave.Click | FP00643_RowExcelPopup.cs:700 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:"+e.Message )) | 메시지 표시 |  |  |  |
| AC-250ff358 | this.btnSave.Click | FP00643_RowExcelPopup.cs:701 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2c847a7d | this.btnSave.Click | FP00643_RowExcelPopup.cs:706 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f446e0ac | this.btnSave.Click | FP00643_RowExcelPopup.cs:707 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-84598562 | this.btnSave.Click | FP00643_RowExcelPopup.cs:708 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8d4b0ad1 | this.btnSave.Click | FP00643_RowExcelPopup.cs:709 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d284b34a | this.btnSave.Click | FP00643_RowExcelPopup.cs:710 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-26213b82 | this.btnSave.Click | FP00643_RowExcelPopup.cs:711 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00643_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f3886c6 | this.Load | FP00643_RowExcelPopup.cs:309 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04aa8117 | this.Load | FP00643_RowExcelPopup.cs:310 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00643_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe804eba | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:264 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-3b27e8ab | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:265 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-9197dee5 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:266 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-291cb880 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:270 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-98d33344 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:271 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-b0a1a1c0 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00643_RowExcelPopup.cs:272 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00643_SetupColor_Popup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d5d2149 | (진입점 미연결) | FP00643_SetupColor_Popup.cs:332 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-ed436150 | (진입점 미연결) | FP00643_SetupColor_Popup.cs:335 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1d97fb76 | (진입점 미연결) | FP00643_SetupColor_Popup.cs:336 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00643_SetupColor_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bae4bf5d | this.Load | FP00643_SetupColor_Popup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b82db58e | this.Load | FP00643_SetupColor_Popup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c03b97e | this.Load | FP00643_SetupColor_Popup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00643_SetupColor_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f22e7c5 | this.Load | FP00643_SetupColor_Popup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00643_SetupColor_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c700c96c | Dispose | FP00643_SetupColor_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00643_SetupColor_Popup.Find_Data_Line

진입점: this.Load [try] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-622f1a61 | this.Load [try] 외 2 | FP00643_SetupColor_Popup.cs:277 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "find_SetupColor_P", Filter.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_SetupColor_P] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-67f0cd40 | this.Load [try] 외 2 | FP00643_SetupColor_Popup.cs:307 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-94ff3212 | this.Load [try] 외 2 | FP00643_SetupColor_Popup.cs:311 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00643_SetupColor_Popup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac4b6d67 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:211 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-1b8c81a6 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:230 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dfe683c0 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:231 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e2c8dbd8 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:238 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) | GRID_SET | siMain.ActiveSheet.Cells[i, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-85f4fbf9 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:241 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) ▸ if (bgColor.Good()) | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-484aa678 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:242 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) ▸ for (i< rowcnt) ▸ if (bgColor.Good()) | GRID_STYLE | siMain.SetBGColor | (i, 1, i, 1, bg) | 그리드 표시 설정 |  |  |  |
| AC-b2cc0449 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:245 | try ▸ if (dsMain.Tables[0].Rows.Count > 0) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-deaf9537 | this.Load 외 2 | FP00643_SetupColor_Popup.cs:267 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## FP00643_SetupColor_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70b52654 | this.Load | FP00643_SetupColor_Popup.cs:108 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd04526d | this.Load | FP00643_SetupColor_Popup.cs:110 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00643_SetupColor_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d31bf274 | this.Load | FP00643_SetupColor_Popup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7003f21d | this.Load | FP00643_SetupColor_Popup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_SetupColor_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c55d5ccf | (진입점 미연결) | FP00643_SetupColor_Popup.cs:170 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00643_SetupColor_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-916a3cab | this.Load | FP00643_SetupColor_Popup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b29bd257 | this.Load | FP00643_SetupColor_Popup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-441d7d6b | this.Load | FP00643_SetupColor_Popup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00643_SetupColor_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1edc1483 | this.spdMain.CellClick | FP00643_SetupColor_Popup.cs:347 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-efdb4555 | this.spdMain.CellClick | FP00643_SetupColor_Popup.cs:348 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ddd4f156 | this.spdMain.CellClick | FP00643_SetupColor_Popup.cs:351 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP00643_SetupColor_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-864a0977 | this.spdMain.CellDoubleClick | FP00643_SetupColor_Popup.cs:357 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1132de8a | this.spdMain.CellDoubleClick | FP00643_SetupColor_Popup.cs:358 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7334818a | this.spdMain.CellDoubleClick | FP00643_SetupColor_Popup.cs:361 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-4f805522 | this.spdMain.CellDoubleClick | FP00643_SetupColor_Popup.cs:364 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

