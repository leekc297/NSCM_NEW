# AS-IS 액션 대조표 — SCM0007

> 원천: `Doc/asisfacts/screens/SCM0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 340행 · 메서드 36 · 종류 DATA_OP 72 · GRID_INIT 42 · RETURN 40 · UI_PROP 28 · MESSAGE 27 · ENDPOINT 24 · CALL_EXT 20 · FLAG 20 · GRID_SET 15 · GRID_LOCK 13 · UI_MISC 9 · VALUE_SET 9 · LIST_REBIND 8 · GRID_BIND 4 · POPUP 4 · VALIDATE 3 · STATE_RESET 2 · ⚠ 의미 확인 필요 20


## SCM0007_PopContent.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f402cf48 | this.btnButtonList.UsrButtonList_Click_Detected | SCM0007_PopContent.cs:202 | else of (buttonItem.UserType == ButtonListType.OK) ▸ if (buttonItem.UserType == ButtonListType.Cancel) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCM0007_PopContent.ChkContent

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee386c22 | (진입점 미연결) | SCM0007_PopContent.cs:229 | try ▸ if (rtxtContent.Text.Length > 0) | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d503a44 | (진입점 미연결) | SCM0007_PopContent.cs:232 | try ▸ if (rtxtContent.Text.Length > 0) ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) <= 80) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-63d77f12 | (진입점 미연결) | SCM0007_PopContent.cs:237 | try ▸ if (rtxtContent.Text.Length > 0) ▸ else of (Encoding.Default.GetByteCount(rtxtContent.Text) <= 80) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-35db6819 | (진입점 미연결) | SCM0007_PopContent.cs:244 | try ▸ else of (rtxtContent.Text.Length > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36c0270b | (진입점 미연결) | SCM0007_PopContent.cs:245 | try ▸ else of (rtxtContent.Text.Length > 0) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |
| AC-afca8c41 | (진입점 미연결) | SCM0007_PopContent.cs:250 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-9e51a4c4 | (진입점 미연결) | SCM0007_PopContent.cs:251 | catch ((Exception ex)) | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0007_PopContent.Define

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90cf0c0e | this.Load | SCM0007_PopContent.cs:97 | if (UseTypeCode == "MAIL") | FLAG | sMaxTextLength | "4000" | 화면 필드/플래그 변경 |  |  |  |
| AC-f03d4de8 | this.Load | SCM0007_PopContent.cs:98 | if (UseTypeCode == "MAIL") | UI_PROP | rtxtContent.MaxLength | 3700 | 속성 MaxLength 설정 |  |  |  |
| AC-4a2dbaff | this.Load | SCM0007_PopContent.cs:102 | else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") | FLAG | sMaxTextLength | "80" | 화면 필드/플래그 변경 |  |  |  |
| AC-21e600ce | this.Load | SCM0007_PopContent.cs:103 | else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") | UI_PROP | rtxtContent.MaxLength | 80 | 속성 MaxLength 설정 |  |  |  |
| AC-7fe11340 | this.Load | SCM0007_PopContent.cs:107 | else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") | FLAG | sMaxTextLength | "1000" | 화면 필드/플래그 변경 |  |  |  |
| AC-95e89711 | this.Load | SCM0007_PopContent.cs:108 | else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") | UI_PROP | rtxtContent.MaxLength | 800 | 속성 MaxLength 설정 |  |  |  |

## SCM0007_PopContent.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee4db749 | Dispose | SCM0007_PopContent.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0007_PopContent.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c5b673b | this.Load | SCM0007_PopContent.cs:84 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-efdf22c8 | this.Load | SCM0007_PopContent.cs:86 |  | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |

## SCM0007_PopContent.RtxtContent_TextChanged

진입점: rtxtContent.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2aca6a7 | rtxtContent.TextChanged | SCM0007_PopContent.cs:120 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04217ac5 | rtxtContent.TextChanged | SCM0007_PopContent.cs:123 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b20894a | rtxtContent.TextChanged | SCM0007_PopContent.cs:124 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | VALUE_SET | rtxtContent.Text | _sTempContent | 컨트롤 값 설정 |  |  |  |
| AC-4c560822 | rtxtContent.TextChanged | SCM0007_PopContent.cs:125 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ if (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-677b4479 | rtxtContent.TextChanged | SCM0007_PopContent.cs:128 | if (rtxtContent.Text.Length > 0) ▸ if (UseTypeCode == "MAIL") ▸ else of (Encoding.Default.GetByteCount(rtxtContent.Text) >= 3700) | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-c5d8e6b8 | rtxtContent.TextChanged | SCM0007_PopContent.cs:131 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-690d82fa | rtxtContent.TextChanged | SCM0007_PopContent.cs:134 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxtConte… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-06d7bf3b | rtxtContent.TextChanged | SCM0007_PopContent.cs:135 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxtConte… | VALUE_SET | rtxtContent.Text | _sTempContent | 컨트롤 값 설정 |  |  |  |
| AC-7420d9b6 | rtxtContent.TextChanged | SCM0007_PopContent.cs:136 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxtConte… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63884e14 | rtxtContent.TextChanged | SCM0007_PopContent.cs:139 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ if (UseTypeCode == "SMS") ▸ else of (Encoding.Default.GetByteCount(rtxt… | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-1c82d796 | rtxtContent.TextChanged | SCM0007_PopContent.cs:143 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") | CALL_EXT | Encoding.Default.GetByteCount | (rtxtContent.Text) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74a6f922 | rtxtContent.TextChanged | SCM0007_PopContent.cs:146 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5680fb1 | rtxtContent.TextChanged | SCM0007_PopContent.cs:147 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxt… | VALUE_SET | rtxtContent.Text | _sTempContent | 컨트롤 값 설정 |  |  |  |
| AC-89a8f542 | rtxtContent.TextChanged | SCM0007_PopContent.cs:148 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") ▸ if (Encoding.Default.GetByteCount(rtxt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa9e9d66 | rtxtContent.TextChanged | SCM0007_PopContent.cs:151 | if (rtxtContent.Text.Length > 0) ▸ else of (UseTypeCode == "MAIL") ▸ else of (UseTypeCode == "SMS") ▸ else of (Encoding.Default.GetByteCount… | FLAG | _sTempContent | rtxtContent.Text | 화면 필드/플래그 변경 |  |  |  |

## SCM0007_PopContent.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a48d974 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0007_PopContent.cs:181 | try | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e585483b | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0007_PopContent.cs:182 | try | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-08243672 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0007_PopContent.cs:186 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2953670a | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCM0007_PopContent.cs:187 | catch ((Exception ex)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0007_PopContent.SetTextBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7680305d | (진입점 미연결) | SCM0007_PopContent.cs:212 |  | UI_PROP | rtxtContent.Font | new Font("굴림", 9) | 속성 Font 설정 |  |  |  |

## SCM0007_SMS_Setup.All_Receiver_EditChange

진입점: All_Receiver.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18a33c3d | All_Receiver.EditChange | SCM0007_SMS_Setup.cs:1479 | if (e.Column == siAllReceiver.GetColumnIndex(DefColumns.SMS_PHONE)) ▸ if (!b) | GRID_SET | siAllReceiver.SetValue | (e.Row, e.Column, str) | 그리드 값 설정 |  |  |  |

## SCM0007_SMS_Setup.All_Receiver_KeyPress

진입점: All_Receiver.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3b006b7 | All_Receiver.KeyPress | SCM0007_SMS_Setup.cs:1488 |  | CALL_EXT | All_Receiver.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6803848 | All_Receiver.KeyPress | SCM0007_SMS_Setup.cs:1500 | if (!String.IsNullOrEmpty(strState) && (strState == "I" \|\| strState == "M")) ▸ if (siAllReceiver.GetColumnIndex(DefColumns.SMS_PHONE) == A… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-843a4c83 | All_Receiver.KeyPress | SCM0007_SMS_Setup.cs:1502 | if (!String.IsNullOrEmpty(strState) && (strState == "I" \|\| strState == "M")) ▸ if (siAllReceiver.GetColumnIndex(DefColumns.SMS_PHONE) == A… | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

## SCM0007_SMS_Setup.BtnRAdd_Click

진입점: this.btnRAdd.Click / All_Receiver.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-363d04b9 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1441 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88c5d88b | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1442 | if (siAllReceiver.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bef3e697 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1445 |  | CALL_EXT | siAllReceiver.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e75c1b65 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1450 | if (!String.IsNullOrEmpty(strState) && (strState == "I" \|\| strState == "D" \|\| strState == "E")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40aa114b | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1453 | if (dtAllReceiver != null) | STATE_RESET | dtAllReceiver.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f4b311cd | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1455 |  | FLAG | dtAllReceiver | (siAllReceiver.SpreadObject.DataSource as DataSet).Tables[0].Clone() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b065f89 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1455 |  | DATA_OP | (siAllReceiver.SpreadObject.DataSource as DataSet).Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0007_SMS_Setup.BtnRDel_Click

진입점: this.btnRDel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb56273 | this.btnRDel.Click | SCM0007_SMS_Setup.cs:1516 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-acc9b6c7 | this.btnRDel.Click | SCM0007_SMS_Setup.cs:1517 | if (siSelReceiver.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dc4cc938 | this.btnRDel.Click | SCM0007_SMS_Setup.cs:1519 |  | DATA_OP | siSelReceiver.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f4bd2c1e | this.btnRDel.Click | SCM0007_SMS_Setup.cs:1528 | if (dtAllReceiver.Rows.Count > 0) ▸ foreach (DataRow dr in dtAllReceiver.Rows) | DATA_OP | dt.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-1dce1578 | this.btnRDel.Click | SCM0007_SMS_Setup.cs:1533 | if (dtAllReceiver.Rows.Count > 0) | STATE_RESET | dtAllReceiver.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## SCM0007_SMS_Setup.CboModule_SelectedIndexChanged

진입점: cboModule.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f90cb5b | cboModule.SelectedIndexChanged | SCM0007_SMS_Setup.cs:1604 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM, cboModule.SelectedValue.T… ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |

## SCM0007_SMS_Setup.ChkCategoryValidation

진입점: SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf45e619 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1360 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ if (strMain == "MONTH" \|\| strMain == "… | MESSAGE | MessageHelper.GMessageBox | ("MSG00122", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e6d1ce8 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1372 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (!string.IsNullOrEmpty(strMain)) ▸ else of (strMain == "MONTH" \|\| strMain… | MESSAGE | MessageHelper.GMessageBox | ("MSG00123", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0bfca697 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1381 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ else of (!string.IsNullOrEmpty(strMain)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00124", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1ebf1e4 | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1416 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | CALL_EXT | siCategory.GetColumnText | (0, siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fcd5fbdc | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1420 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5a8658b | SaveButton [if (siCategory != null && siCategory.IsLock(siCa… | SCM0007_SMS_Setup.cs:1435 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0007_SMS_Setup.ChkMsgValidation

진입점: SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69ba68c9 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0007_SMS_Setup.cs:1188 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (string.IsNullOrWhiteSpace(str)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b32cfd68 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0007_SMS_Setup.cs:1189 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (string.IsNullOrWhiteSpace(str)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e75183b7 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0007_SMS_Setup.cs:1228 | try ▸ for (i < cnt) ▸ if (!string.IsNullOrEmpty(strAction)) ▸ if (cntDuplicate > 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6ba5a24 | SaveButton [if (siMessage != null && siMessage.IsLock(siMess… | SCM0007_SMS_Setup.cs:1242 |  | RETURN | return isRst; |  | 처리 중단/반환 |  |  |  |

## SCM0007_SMS_Setup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3869222d | this.Load | SCM0007_SMS_Setup.cs:178 |  | GRID_INIT | this.AddSheet | (Category, SpdSheet.siCategory, SpdSheet.siCategory, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31ede603 | this.Load | SCM0007_SMS_Setup.cs:179 |  | FLAG | siCategory | GetSheetInfo(Category.Name, Category.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-22fbe8e1 | this.Load | SCM0007_SMS_Setup.cs:181 |  | GRID_INIT | this.AddSheet | (Message, SpdSheet.siMessage, SpdSheet.siMessage, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae849bf5 | this.Load | SCM0007_SMS_Setup.cs:182 |  | FLAG | siMessage | GetSheetInfo(Message.Name, Message.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2affe12 | this.Load | SCM0007_SMS_Setup.cs:184 |  | GRID_INIT | this.AddSheet | (All_Receiver, SpdSheet.siAllReceiver, SpdSheet.siAllReceiver, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ccd2bf6 | this.Load | SCM0007_SMS_Setup.cs:185 |  | FLAG | siAllReceiver | GetSheetInfo(All_Receiver.Name, All_Receiver.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-553e4d71 | this.Load | SCM0007_SMS_Setup.cs:187 |  | GRID_INIT | this.AddSheet | (Sel_Receiver, SpdSheet.siSelReceiver, SpdSheet.siSelReceiver, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8e93e8d | this.Load | SCM0007_SMS_Setup.cs:188 |  | FLAG | siSelReceiver | GetSheetInfo(Sel_Receiver.Name, Sel_Receiver.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6daca18b | this.Load | SCM0007_SMS_Setup.cs:190 |  | GRID_INIT | siCategory.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0007_SMS_Setup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8afb93a1 | this.Load | SCM0007_SMS_Setup.cs:159 |  | VALUE_SET | lcGroupName.Text | MessageHelper.GetTerm(lcGroupName.Text) | 컨트롤 값 설정 |  |  |  |
| AC-3626d1ff | this.Load | SCM0007_SMS_Setup.cs:160 |  | VALUE_SET | lcCallPhone.Text | MessageHelper.GetTerm(lcCallPhone.Text) | 컨트롤 값 설정 |  |  |  |

## SCM0007_SMS_Setup.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba6b02ad | DeleteButton | SCM0007_SMS_Setup.cs:280 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | DATA_OP | siCategory.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-871ea19a | DeleteButton | SCM0007_SMS_Setup.cs:283 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-efc9dbbe | DeleteButton | SCM0007_SMS_Setup.cs:285 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siAllRece… | DATA_OP | siAllReceiver.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-161fd3a3 | DeleteButton | SCM0007_SMS_Setup.cs:287 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ else of (fps.Name == SpdSheet.siAl… | DATA_OP | siSelReceiver.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCM0007_SMS_Setup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b55e1cc | Dispose | SCM0007_SMS_Setup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0007_SMS_Setup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09a3b17b | EditButton | SCM0007_SMS_Setup.cs:297 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | GRID_LOCK | siCategory.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-65b2ebea | EditButton | SCM0007_SMS_Setup.cs:298 | if (fps != null) ▸ if (fps.Name == SpdSheet.siCategory) | GRID_LOCK | siCategory.LockColumn | (siCategory.GetColumnIndex(DefColumns.MODULE_CODE), siCategory.GetColumnIndex(DefColumns.S… | 그리드 편집 잠금/해제 |  |  |  |
| AC-abd4b4b5 | EditButton | SCM0007_SMS_Setup.cs:302 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c8e678bb | EditButton | SCM0007_SMS_Setup.cs:303 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockColumn | (siMessage.GetColumnIndex(DefColumns.CATEGORY_ID), siMessage.GetColumnIndex(DefColumns.LAN… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ee0eb33d | EditButton | SCM0007_SMS_Setup.cs:307 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siAllRece… | GRID_LOCK | siAllReceiver.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-c1ae905f | EditButton | SCM0007_SMS_Setup.cs:311 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ else of (fps.Name == SpdSheet.siAl… | GRID_LOCK | siSelReceiver.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-fad07fa1 | EditButton | SCM0007_SMS_Setup.cs:312 | if (fps != null) ▸ else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ else of (fps.Name == SpdSheet.siAl… | GRID_LOCK | siSelReceiver.LockColumn | (siSelReceiver.GetColumnIndex(DefColumns.CATEGORY_ID), true) | 그리드 편집 잠금/해제 |  |  |  |

## SCM0007_SMS_Setup.FindData_AllReceiver

진입점: this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / FindButton [if (fps != null && fps.Name == SpdSheet.siAllReceiver)] / SaveButton [if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80cd439 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:376 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a57e541 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:380 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0007_GET_RECIPIENT_SMS_GROUP_LIST") ⇒ SCM.SCM0007_GET_RECIPIENT_SMS_GROUP_LIST | 엔드포인트 요청 생성 |  |  |  |
| AC-7bd0d7fb | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:381 | lambda | DATA_OP | request.Parameters["p_group"] | this.txtGroup.Text | 행/컬럼 값 대입 |  |  |  |
| AC-54686426 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:382 | lambda | DATA_OP | request.Parameters["p_phone"] | this.txtPhone.Text | 행/컬럼 값 대입 |  |  |  |
| AC-55e0d844 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:383 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a7ff5173 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:385 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e42f8d39 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:390 |  | GRID_BIND | siAllReceiver.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-42cfe4b7 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:391 |  | GRID_LOCK | siAllReceiver.LockColumn | (0, siAllReceiver.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c017f49 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:394 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2c23f4f4 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 2 | SCM0007_SMS_Setup.cs:397 |  | GRID_INIT | siAllReceiver.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0007_SMS_Setup.FindData_Main

진입점: FindButton [else of (fps != null && fps.Name == SpdSheet.siAllReceiver)] / SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19ac9e29 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:331 |  | CALL_EXT | CString.GetComboBoxValue | (cboModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-281d51df | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:332 |  | CALL_EXT | CString.GetComboBoxValue | (cboSubModule.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe9fd9c8 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:333 |  | CALL_EXT | CString.GetComboBoxValue | (cboActive.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53d1da5e | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:337 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4eee632 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:341 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MASTER") ⇒ SCM.SCM0006_GET_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-0cc8bfdb | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:342 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-08ee25fc | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:343 | lambda | DATA_OP | request.Parameters["p_module"] | Module | 행/컬럼 값 대입 |  |  |  |
| AC-4c08d3be | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:344 | lambda | DATA_OP | request.Parameters["p_submodule"] | SubMod | 행/컬럼 값 대입 |  |  |  |
| AC-73903ae5 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:345 | lambda | DATA_OP | request.Parameters["p_active"] | Active | 행/컬럼 값 대입 |  |  |  |
| AC-86aa0385 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:347 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dfe55145 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:349 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-83b83b3b | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:353 |  | GRID_BIND | siCategory.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c15dedc5 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:354 |  | GRID_LOCK | siCategory.LockColumn | (0, siCategory.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b86c0cc6 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:357 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c3f24489 | FindButton [else of (fps != null && fps.Name == SpdSheet.siA… 외 1 | SCM0007_SMS_Setup.cs:360 |  | GRID_INIT | siCategory.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0007_SMS_Setup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a0d2f9c | this.Load | SCM0007_SMS_Setup.cs:147 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0007_SMS_Setup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7c7f707 | this.Load | SCM0007_SMS_Setup.cs:165 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-19aa3f06 | this.Load | SCM0007_SMS_Setup.cs:167 |  | LIST_REBIND | cboModule.DataBind | (Data.Type.Module, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=Module] | 목록 컨트롤 재구성 |  |  |  |
| AC-15189df0 | this.Load | SCM0007_SMS_Setup.cs:168 |  | LIST_REBIND | cboSubModule.DataBind | (Data.Type.SubModule, true, CConstVariable.SMS_MAIL_SEND_SYSTEM) ⇒ biz:CommonData.CommonDataList [code=SubModule] | 목록 컨트롤 재구성 |  |  |  |
| AC-f78e9779 | this.Load | SCM0007_SMS_Setup.cs:169 |  | LIST_REBIND | cboActive.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-60cfaa34 | this.Load | SCM0007_SMS_Setup.cs:171 |  | VALUE_SET | cboActive.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |

## SCM0007_SMS_Setup.InitSpread

진입점: this.Load / this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / FindButton [if (fps != null && fps.Name == SpdSheet.siAllReceiver)] / SaveButton [if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a08f6c9 | this.Load 외 3 | SCM0007_SMS_Setup.cs:200 |  | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-aa36f75e | this.Load 외 3 | SCM0007_SMS_Setup.cs:204 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48d812ef | this.Load 외 3 | SCM0007_SMS_Setup.cs:205 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.None, 100, false, dtModule, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20ce953f | this.Load 외 3 | SCM0007_SMS_Setup.cs:206 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Module*", DefColumns.MODULE_CODE, FPMerge.Restricted, 100, true, dtModule, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4eb4d59a | this.Load 외 3 | SCM0007_SMS_Setup.cs:207 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub Module*", DefColumns.SUB_MODULE_CODE, FPMerge.Restricted, 100, true, dtSubModule, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a835366 | this.Load 외 3 | SCM0007_SMS_Setup.cs:208 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd42a6ca | this.Load 외 3 | SCM0007_SMS_Setup.cs:209 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddTextColumn | ("Category*", DefColumns.CATEGORY_DESC, FPMerge.Restricted, 300, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc013e44 | this.Load 외 3 | SCM0007_SMS_Setup.cs:210 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Active", DefColumns.ACTIVE_FLAG, FPMerge.Restricted, 100, true, dtYesOrNo, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f572fc0 | this.Load 외 3 | SCM0007_SMS_Setup.cs:212 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Main*", DefColumns.CYCLE_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycle, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ee4e833 | this.Load 외 3 | SCM0007_SMS_Setup.cs:213 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub1", DefColumns.DETAIL_CLASS_CODE, FPMerge.Restricted, 100, true, dtCycleSub1, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9aabb974 | this.Load 외 3 | SCM0007_SMS_Setup.cs:214 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.AddComboColumn | ("Sub2", DefColumns.SEND_TIME_TEXT, FPMerge.Restricted, 100, true, dtCycleSub2, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bfc092a8 | this.Load 외 3 | SCM0007_SMS_Setup.cs:217 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.USE_TYPE_CODE), 2, 1, 25, "USE_TYPE_CODE", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-202e43d3 | this.Load 외 3 | SCM0007_SMS_Setup.cs:218 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.MODULE_CODE), 2, 1, 25, "Module*", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffd6a79a | this.Load 외 3 | SCM0007_SMS_Setup.cs:219 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.SUB_MODULE_CODE), 2, 1, 25, "Sub Module*", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce57793b | this.Load 외 3 | SCM0007_SMS_Setup.cs:220 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.CATEGORY_DESC), 2, 1, 25, "Category*", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-918f2254 | this.Load 외 3 | SCM0007_SMS_Setup.cs:221 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.ColumnHeaderSpan | (0, spreadInfo.GetColumnIndex(DefColumns.ACTIVE_FLAG), 2, 1, 25, "Active", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-495086d2 | this.Load 외 3 | SCM0007_SMS_Setup.cs:222 | if (spreadInfo.SheetName == SpdSheet.siCategory) | CALL_EXT | clsCtrl.HeaderSpan | (spreadInfo, 0, DefColumns.CYCLE_CLASS_CODE, 1, 3, "Period") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7375a787 | this.Load 외 3 | SCM0007_SMS_Setup.cs:223 | if (spreadInfo.SheetName == SpdSheet.siCategory) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cda270bf | this.Load 외 3 | SCM0007_SMS_Setup.cs:228 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1577286c | this.Load 외 3 | SCM0007_SMS_Setup.cs:229 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("USE_TYPE_CODE", DefColumns.USE_TYPE_CODE, FPMerge.Restricted, 100, false, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ba73532 | this.Load 외 3 | SCM0007_SMS_Setup.cs:230 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Restricted, 100, false, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d16d552 | this.Load 외 3 | SCM0007_SMS_Setup.cs:231 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_DESC, FPMerge.Always, 300, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c25914bc | this.Load 외 3 | SCM0007_SMS_Setup.cs:232 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddComboColumn | ("Language*", DefColumns.LANGUAGE_CODE, FPMerge.None, 100, true, dtLang, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ca003f84 | this.Load 외 3 | SCM0007_SMS_Setup.cs:233 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.AddTextColumn | ("SMS Content*", DefColumns.MESSAGE_CONTENT, FPMerge.None, 400, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cae32a92 | this.Load 외 3 | SCM0007_SMS_Setup.cs:234 | if (spreadInfo.SheetName == SpdSheet.siMessage) | CALL_EXT | spreadInfo.AutoRowHeight | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f9b5e57 | this.Load 외 3 | SCM0007_SMS_Setup.cs:235 | if (spreadInfo.SheetName == SpdSheet.siMessage) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-69cfa219 | this.Load 외 3 | SCM0007_SMS_Setup.cs:240 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-80b118a8 | this.Load 외 3 | SCM0007_SMS_Setup.cs:241 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Group Name*", DefColumns.SMS_GROUP_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22dd2ebb | this.Load 외 3 | SCM0007_SMS_Setup.cs:242 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("CellPhoneNum*", DefColumns.SMS_PHONE, FPMerge.Restricted, 100, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51c99ee2 | this.Load 외 3 | SCM0007_SMS_Setup.cs:243 | if (spreadInfo.SheetName == SpdSheet.siAllReceiver) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f8d04e51 | this.Load 외 3 | SCM0007_SMS_Setup.cs:248 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2abdf380 | this.Load 외 3 | SCM0007_SMS_Setup.cs:249 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.CATEGORY_ID, FPMerge.Always, 200, false, FPHAlign.Center, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16af448b | this.Load 외 3 | SCM0007_SMS_Setup.cs:250 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("Group Name", DefColumns.SMS_GROUP_NAME, FPMerge.Restricted, 100, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41e8739f | this.Load 외 3 | SCM0007_SMS_Setup.cs:251 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.AddTextColumn | ("CellPhoneNum", DefColumns.SMS_PHONE, FPMerge.Restricted, 100, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74623bc3 | this.Load 외 3 | SCM0007_SMS_Setup.cs:252 | if (spreadInfo.SheetName == SpdSheet.siSelReceiver) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0007_SMS_Setup.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b36c7a4b | InsertButton | SCM0007_SMS_Setup.cs:776 | if (fps.Name == SpdSheet.siCategory) | DATA_OP | siCategory.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1cd02d87 | InsertButton | SCM0007_SMS_Setup.cs:779 | if (fps.Name == SpdSheet.siCategory) | DATA_OP | defaultData.Add | (DefColumns.ACTIVE_FLAG, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-8178869c | InsertButton | SCM0007_SMS_Setup.cs:781 | if (fps.Name == SpdSheet.siCategory) | GRID_SET | siCategory.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-41094984 | InsertButton | SCM0007_SMS_Setup.cs:786 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | siMessage.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e4ac7cd3 | InsertButton | SCM0007_SMS_Setup.cs:789 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.USE_TYPE_CODE, UseTypeCode) | 데이터 객체 조작/조회 |  |  |  |
| AC-19523271 | InsertButton | SCM0007_SMS_Setup.cs:790 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.CATEGORY_ID, strCategory) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c68428a | InsertButton | SCM0007_SMS_Setup.cs:791 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | DATA_OP | defaultData.Add | (DefColumns.CATEGORY_DESC, strCategoryDESC) | 데이터 객체 조작/조회 |  |  |  |
| AC-1539992e | InsertButton | SCM0007_SMS_Setup.cs:793 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_SET | siMessage.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-3242ebda | InsertButton | SCM0007_SMS_Setup.cs:794 | else of (fps.Name == SpdSheet.siCategory) ▸ if (fps.Name == SpdSheet.siMessage) | GRID_LOCK | siMessage.LockRange | (insCell, siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC), siMessage.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8efbf6e1 | InsertButton | SCM0007_SMS_Setup.cs:798 | else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siAllReceiver) | DATA_OP | siAllReceiver.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a29e5e32 | InsertButton | SCM0007_SMS_Setup.cs:801 | else of (fps.Name == SpdSheet.siCategory) ▸ else of (fps.Name == SpdSheet.siMessage) ▸ if (fps.Name == SpdSheet.siAllReceiver) | GRID_SET | siAllReceiver.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCM0007_SMS_Setup.Message_EditChange

진입점: Message.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6288cb37 | Message.EditChange | SCM0007_SMS_Setup.cs:1131 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ccb3bf3 | Message.EditChange | SCM0007_SMS_Setup.cs:1137 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) | CALL_EXT | Encoding.Default.GetByteCount | (sContent) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78b7fb70 | Message.EditChange | SCM0007_SMS_Setup.cs:1140 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | MESSAGE | MessageHelper.GMessageBox | ("MSG00165", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a27d2456 | Message.EditChange | SCM0007_SMS_Setup.cs:1141 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | GRID_SET | siMessage.SetValue | (e.Row, e.Column, sContentTemp) | 그리드 값 설정 |  |  |  |
| AC-c34ed0d1 | Message.EditChange | SCM0007_SMS_Setup.cs:1142 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (Encod… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-550fa9e0 | Message.EditChange | SCM0007_SMS_Setup.cs:1145 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (… | FLAG | sContentTemp | sContent | 화면 필드/플래그 변경 |  |  |  |

## SCM0007_SMS_Setup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02dd0c93 | SaveButton | SCM0007_SMS_Setup.cs:427 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) | VALIDATE | DataUtil.checkRequiredOfSpread | (siCategory) | 프레임워크 검증 |  |  |  |
| AC-ff088942 | SaveButton | SCM0007_SMS_Setup.cs:427 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (!DataUt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9aff03aa | SaveButton | SCM0007_SMS_Setup.cs:429 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (!ChkCat… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1486e3c5 | SaveButton | SCM0007_SMS_Setup.cs:466 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00121") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8dda9d76 | SaveButton | SCM0007_SMS_Setup.cs:466 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4a0de64 | SaveButton | SCM0007_SMS_Setup.cs:468 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MASTER") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MASTER | 엔드포인트 요청 생성 |  |  |  |
| AC-c8ba6461 | SaveButton | SCM0007_SMS_Setup.cs:473 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b5934d07 | SaveButton | SCM0007_SMS_Setup.cs:477 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cfefad26 | SaveButton | SCM0007_SMS_Setup.cs:478 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-5453bd7b | SaveButton | SCM0007_SMS_Setup.cs:479 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_module"] | p_module | 행/컬럼 값 대입 |  |  |  |
| AC-c6c85890 | SaveButton | SCM0007_SMS_Setup.cs:480 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_submodule"] | p_submodule | 행/컬럼 값 대입 |  |  |  |
| AC-66bb7bed | SaveButton | SCM0007_SMS_Setup.cs:481 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-4dc5a59b | SaveButton | SCM0007_SMS_Setup.cs:482 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_category_desc"] | p_category_desc | 행/컬럼 값 대입 |  |  |  |
| AC-aac4bd49 | SaveButton | SCM0007_SMS_Setup.cs:483 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_cycle_class_code"] | p_cycle_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-b672ee35 | SaveButton | SCM0007_SMS_Setup.cs:484 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_detail_class_code"] | p_detail_class_code | 행/컬럼 값 대입 |  |  |  |
| AC-f186aa64 | SaveButton | SCM0007_SMS_Setup.cs:485 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_send_time_text"] | p_send_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-e8ff7dac | SaveButton | SCM0007_SMS_Setup.cs:486 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_send_min_time_text"] | p_send_min_time_text | 행/컬럼 값 대입 |  |  |  |
| AC-bc4dd3e1 | SaveButton | SCM0007_SMS_Setup.cs:487 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_active"] | p_active | 행/컬럼 값 대입 |  |  |  |
| AC-e69402a3 | SaveButton | SCM0007_SMS_Setup.cs:488 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-db739baa | SaveButton | SCM0007_SMS_Setup.cs:489 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-4a992823 | SaveButton | SCM0007_SMS_Setup.cs:490 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-e4ca76c8 | SaveButton | SCM0007_SMS_Setup.cs:492 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49feb68b | SaveButton | SCM0007_SMS_Setup.cs:492 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-9249fadb | SaveButton | SCM0007_SMS_Setup.cs:501 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b33d63ed | SaveButton | SCM0007_SMS_Setup.cs:510 | if (siCategory != null && siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.SheetName == SpdSheet.siCategory) ▸ if (iCount … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2818e463 | SaveButton | SCM0007_SMS_Setup.cs:534 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMessage) | 프레임워크 검증 |  |  |  |
| AC-9fef6192 | SaveButton | SCM0007_SMS_Setup.cs:534 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (!DataUtil.ch… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-035d2d11 | SaveButton | SCM0007_SMS_Setup.cs:537 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (!ChkMsgValid… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61f5ece0 | SaveButton | SCM0007_SMS_Setup.cs:564 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_SAVE_RECIPIENT_MESSAGE") ⇒ SCM.SCM0006_SAVE_RECIPIENT_MESSAGE | 엔드포인트 요청 생성 |  |  |  |
| AC-1f094e02 | SaveButton | SCM0007_SMS_Setup.cs:569 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-603efd3b | SaveButton | SCM0007_SMS_Setup.cs:573 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-52b69a6e | SaveButton | SCM0007_SMS_Setup.cs:574 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_use_type"] | p_use_type | 행/컬럼 값 대입 |  |  |  |
| AC-71d212be | SaveButton | SCM0007_SMS_Setup.cs:575 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-49d27834 | SaveButton | SCM0007_SMS_Setup.cs:576 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_language"] | p_language | 행/컬럼 값 대입 |  |  |  |
| AC-10770780 | SaveButton | SCM0007_SMS_Setup.cs:577 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_title"] | p_title | 행/컬럼 값 대입 |  |  |  |
| AC-76e6b410 | SaveButton | SCM0007_SMS_Setup.cs:578 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_content"] | p_content | 행/컬럼 값 대입 |  |  |  |
| AC-dc6215ea | SaveButton | SCM0007_SMS_Setup.cs:579 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-dc4db5b4 | SaveButton | SCM0007_SMS_Setup.cs:580 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-309f03ab | SaveButton | SCM0007_SMS_Setup.cs:581 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-648a1e65 | SaveButton | SCM0007_SMS_Setup.cs:583 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39f8bf22 | SaveButton | SCM0007_SMS_Setup.cs:583 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-c82506df | SaveButton | SCM0007_SMS_Setup.cs:592 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f537003 | SaveButton | SCM0007_SMS_Setup.cs:601 | if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) … | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e02b93dc | SaveButton | SCM0007_SMS_Setup.cs:622 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | VALIDATE | DataUtil.checkRequiredOfSpread | (siAllReceiver) | 프레임워크 검증 |  |  |  |
| AC-ef1cdbee | SaveButton | SCM0007_SMS_Setup.cs:622 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38e39612 | SaveButton | SCM0007_SMS_Setup.cs:625 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d7a2908d | SaveButton | SCM0007_SMS_Setup.cs:647 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | ENDPOINT | new FoxDataRequest | ("SCM.SCM0007_SAVE_RECIPIENT_SMS_GROUP") ⇒ SCM.SCM0007_SAVE_RECIPIENT_SMS_GROUP | 엔드포인트 요청 생성 |  |  |  |
| AC-d32520be | SaveButton | SCM0007_SMS_Setup.cs:651 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52675608 | SaveButton | SCM0007_SMS_Setup.cs:655 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-d3bdb93f | SaveButton | SCM0007_SMS_Setup.cs:656 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_sms_group_name"] | p_sms_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-0b0dec93 | SaveButton | SCM0007_SMS_Setup.cs:657 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_sms_phone"] | p_sms_phone | 행/컬럼 값 대입 |  |  |  |
| AC-4f56d0dc | SaveButton | SCM0007_SMS_Setup.cs:658 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-efa7f720 | SaveButton | SCM0007_SMS_Setup.cs:659 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-af81d15a | SaveButton | SCM0007_SMS_Setup.cs:660 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-849f11d0 | SaveButton | SCM0007_SMS_Setup.cs:662 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fdfa25d4 | SaveButton | SCM0007_SMS_Setup.cs:662 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e775e03c | SaveButton | SCM0007_SMS_Setup.cs:671 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cbbe46b6 | SaveButton | SCM0007_SMS_Setup.cs:673 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | VALUE_SET | this.txtPhone.Text | p_sms_phone | 컨트롤 값 설정 |  |  |  |
| AC-eafea2cd | SaveButton | SCM0007_SMS_Setup.cs:682 | if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d426397 | SaveButton | SCM0007_SMS_Setup.cs:729 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | new FoxDataRequest | ("SCM.SCM0007_SAVE_RECIPIENT_SMS_ASSIGN") ⇒ SCM.SCM0007_SAVE_RECIPIENT_SMS_ASSIGN | 엔드포인트 요청 생성 |  |  |  |
| AC-46188be3 | SaveButton | SCM0007_SMS_Setup.cs:734 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b39ce7ae | SaveButton | SCM0007_SMS_Setup.cs:738 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-338d232e | SaveButton | SCM0007_SMS_Setup.cs:739 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_category_id"] | p_category_id | 행/컬럼 값 대입 |  |  |  |
| AC-d92c8c2b | SaveButton | SCM0007_SMS_Setup.cs:740 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_sms_group_name"] | p_sms_group_name | 행/컬럼 값 대입 |  |  |  |
| AC-61b9ce90 | SaveButton | SCM0007_SMS_Setup.cs:741 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_sms_phone"] | p_sms_phone | 행/컬럼 값 대입 |  |  |  |
| AC-928affb8 | SaveButton | SCM0007_SMS_Setup.cs:742 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-badcefc2 | SaveButton | SCM0007_SMS_Setup.cs:743 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-4ddb0231 | SaveButton | SCM0007_SMS_Setup.cs:744 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | DATA_OP | request.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-f0305d5e | SaveButton | SCM0007_SMS_Setup.cs:746 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-68731b9e | SaveButton | SCM0007_SMS_Setup.cs:746 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-64b9f05e | SaveButton | SCM0007_SMS_Setup.cs:755 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-408b4ea0 | SaveButton | SCM0007_SMS_Setup.cs:764 | if (siSelReceiver != null && siSelReceiver.IsLock(siSelReceiver.SheetName) == false) ▸ if (siSelReceiver.SheetName == SpdSheet.siSelReceiver… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0007_SMS_Setup.SetSelData

진입점: this.btnRAdd.Click / All_Receiver.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79f2a329 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1544 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (TartgetSp.IsLock… | GRID_LOCK | TartgetSp.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-96bb2252 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1563 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | (TartgetSp.SpreadObject.DataSource as DataSet).Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1670b165 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1573 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d91dbaed | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1574 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6fe87f8d | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1578 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | TartgetSp.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7623a28c | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1580 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.CATEGORY_… | strRCategory | 그리드 속성/값 설정 |  |  |  |
| AC-e11e4a3c | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1581 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.SMS_GROUP… | objGroupName.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-2c7e7db5 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1582 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | GRID_SET | TartgetSp.ActiveSheet.Cells[range.Row.Index, TartgetSp.GetColumnIndex(DefColumns.SMS_PHONE… | objPhone.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-a07604f8 | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1584 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ f… | DATA_OP | siAllreciverDellist.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-925e192a | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1590 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | CALL_EXT | siAllreciverDellist.OrderByDescending | (c => c.ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfbeb74c | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1594 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | DATA_OP | dtAllReceiver.ImportRow | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-82736b8b | this.btnRAdd.Click 외 1 | SCM0007_SMS_Setup.cs:1595 | if (SourceSp.GetMaxRowIndex() >= 0 && SourceSp.ActiveSheet.ActiveRowIndex > -1 && !string.IsNullOrEmpty(strCategory)) ▸ if (crs != null) ▸ i… | DATA_OP | SourceSp.ActiveSheet.Rows.Remove | (iRow,1) | 데이터 객체 조작/조회 |  |  |  |

## SCM0007_SMS_Setup.ShowMessage

진입점: this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / SaveButton [if (siMessage != null && siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.SheetName == SpdSheet.siMessage) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed968693 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1258 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e904633f | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1262 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0006_GET_RECIPIENT_MESSAGE") ⇒ SCM.SCM0006_GET_RECIPIENT_MESSAGE | 엔드포인트 요청 생성 |  |  |  |
| AC-e3d4e74c | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1263 | lambda | DATA_OP | request.Parameters["p_use_type"] | UseTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-4971a18d | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1264 | lambda | DATA_OP | request.Parameters["p_categoryID"] | strCategory | 행/컬럼 값 대입 |  |  |  |
| AC-70d76e98 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1266 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f99fbdc | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1268 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-aa126d93 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1272 |  | GRID_BIND | siMessage.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4d8bff3a | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1273 |  | GRID_LOCK | siMessage.LockColumn | (0, siMessage.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0f121ea | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1276 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-44cb123b | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1279 |  | GRID_INIT | siMessage.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0007_SMS_Setup.ShowReceiver

진입점: this.Category.CellDoubleClick [else of (siCategory.IsLock(siCategory.SheetName) == false)] / SaveButton [if (siAllReceiver != null && siAllReceiver.IsLock(siAllReceiver.SheetName) == false) ▸ if (siAllReceiver.SheetName == SpdSheet.siAllReceiver) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b13444c6 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1297 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-adde531b | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1302 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0007_GET_RECIPIENT_SMS_ASSIGN") ⇒ SCM.SCM0007_GET_RECIPIENT_SMS_ASSIGN | 엔드포인트 요청 생성 |  |  |  |
| AC-42a42ef9 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1304 | lambda | DATA_OP | request.Parameters["p_categoryID"] | strCategory | 행/컬럼 값 대입 |  |  |  |
| AC-4e57102c | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1306 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42a152ba | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1308 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-93b9f45a | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1312 |  | GRID_BIND | siSelReceiver.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7fc9f189 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1313 |  | GRID_LOCK | siSelReceiver.LockColumn | (0, siSelReceiver.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f02015d | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1316 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c41e4999 | this.Category.CellDoubleClick [else of (siCategory.IsLock(si… 외 1 | SCM0007_SMS_Setup.cs:1319 |  | GRID_INIT | siSelReceiver.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0007_SMS_Setup.SprCategory_CellClick

진입점: this.Category.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69ef578a | this.Category.CellClick | SCM0007_SMS_Setup.cs:813 | if (this.siCategory.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6889986 | this.Category.CellClick | SCM0007_SMS_Setup.cs:818 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fd0c13b | this.Category.CellClick | SCM0007_SMS_Setup.cs:820 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a11669c | this.Category.CellClick | SCM0007_SMS_Setup.cs:823 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04cbcac2 | this.Category.CellClick | SCM0007_SMS_Setup.cs:839 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31e906ba | this.Category.CellClick | SCM0007_SMS_Setup.cs:840 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-6eb6cc41 | this.Category.CellClick | SCM0007_SMS_Setup.cs:845 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba398572 | this.Category.CellClick | SCM0007_SMS_Setup.cs:847 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-c0070081 | this.Category.CellClick | SCM0007_SMS_Setup.cs:849 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSubModule.ToTable(), strSubModule, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-76badb08 | this.Category.CellClick | SCM0007_SMS_Setup.cs:849 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-56e77cfc | this.Category.CellClick | SCM0007_SMS_Setup.cs:864 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7b7159e | this.Category.CellClick | SCM0007_SMS_Setup.cs:865 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-11bf1e2f | this.Category.CellClick | SCM0007_SMS_Setup.cs:870 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-239abd60 | this.Category.CellClick | SCM0007_SMS_Setup.cs:872 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-997ac527 | this.Category.CellClick | SCM0007_SMS_Setup.cs:874 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub1.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-05a2f434 | this.Category.CellClick | SCM0007_SMS_Setup.cs:874 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e47fdaa | this.Category.CellClick | SCM0007_SMS_Setup.cs:887 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "DAY" … | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-333dba25 | this.Category.CellClick | SCM0007_SMS_Setup.cs:901 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0007_SMS_Setup.SprCategory_CellDoubleClick

진입점: this.Category.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdcf5afe | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:932 | if (e.Column != siCategory.GetColumnIndex(DefColumns.CATEGORY_DESC)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-25868c90 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:936 | if (this.siCategory.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c5e6bbc | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:941 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfca9b42 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:943 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (siCategory.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction) == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc7f0ee0 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:946 | if (siCategory.IsLock(siCategory.SheetName) == false) | CALL_EXT | siCategory.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c46aa30 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:962 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00111", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e37f31bc | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:963 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ if (String.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-afd44573 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:968 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dtSubModule.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7c49de50 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:970 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | UI_PROP | dvNewSubModule.RowFilter | string.Format("SYSTEM_CODE = '{0}'", strModule) | 속성 RowFilter 설정 |  |  |  |
| AC-ec98a218 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:972 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSubModule.ToTable(), strSubModule, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-cfe0addd | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:972 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.SUB_MODULE_CODE)) ▸ else of (St… | DATA_OP | dvNewSubModule.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-440360a7 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:987 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | MESSAGE | MessageHelper.GMessageBox | ("MSG00112", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a8c651c | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:988 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ if (String.IsNullO… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-d2d9a670 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:993 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dtCycleSub1.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ed263ef0 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:995 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | UI_PROP | dvNewSub1.RowFilter | string.Format("CYCLE_CODE = '{0}'", strMain) | 속성 RowFilter 설정 |  |  |  |
| AC-2ddafd61 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:997 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | LIST_REBIND | siCategory.LoadCombo | (e.Row, e.Column, dvNewSub1.ToTable(), strCurr, false, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6f53401e | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:997 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("DETAIL_CLASS_CODE")) ▸ else of (String.Is… | DATA_OP | dvNewSub1.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b663e6b9 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1010 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (e.Column == siCategory.GetColumnIndex("SEND_TIME_TEXT")) ▸ if (strMain == "DAY" … | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-a0e077a2 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1024 | if (siCategory.IsLock(siCategory.SheetName) == false) ▸ if (String.IsNullOrEmpty(strState) \|\| strState == "M" \|\| strState == "D") ▸ if (… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-bf1b2134 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1038 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strCategory | (objCategory == null) ? string.Empty : objCategory.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f25020ab | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1041 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strCategoryDESC | (objCategoryDESC == null) ? string.Empty : objCategoryDESC.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c81e9f2 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1044 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | sContentTemp | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cab91118 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1049 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strRCategory | (objCategory == null) ? string.Empty : objCategory.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c8c97c79 | this.Category.CellDoubleClick | SCM0007_SMS_Setup.cs:1050 | else of (siCategory.IsLock(siCategory.SheetName) == false) | FLAG | strRCategoryDESC | (objCategoryDESC == null) ? string.Empty : objCategoryDESC.ToString() | 화면 필드/플래그 변경 |  |  |  |

## SCM0007_SMS_Setup.SprCategory_ComboSelChange

진입점: this.Category.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc6dc8e | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:914 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-753aee6c | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:915 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.DETAIL_CLASS_CODE), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-723793fb | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:917 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-eb7134f9 | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:918 | if (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-9679d02f | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:922 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetValue | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-7d3e8492 | this.Category.ComboSelChange | SCM0007_SMS_Setup.cs:923 | else of (e.Column == siCategory.GetColumnIndex(DefColumns.CYCLE_CLASS_CODE)) ▸ if (e.Column == siCategory.GetColumnIndex(DefColumns.DETAIL_C… | GRID_SET | siCategory.SetText | (e.Row, siCategory.GetColumnIndex(DefColumns.SEND_TIME_TEXT), string.Empty) | 그리드 값 설정 |  |  |  |

## SCM0007_SMS_Setup.SprMessage_CellClick

진입점: this.Message.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bb6de68 | this.Message.CellClick | SCM0007_SMS_Setup.cs:1070 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (siMessage.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8a1fc313 | this.Message.CellClick | SCM0007_SMS_Setup.cs:1072 | if (this.siMessage.IsLock(siMessage.SheetName) == false) | CALL_EXT | siMessage.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f70c617e | this.Message.CellClick | SCM0007_SMS_Setup.cs:1080 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ if (e.Column == siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-fe484c22 | this.Message.CellClick | SCM0007_SMS_Setup.cs:1084 | if (this.siMessage.IsLock(siMessage.SheetName) == false) ▸ else of (e.Column == siMessage.GetColumnIndex(DefColumns.CATEGORY_DESC)) ▸ if (e.… | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |

## SCM0007_SMS_Setup.SprMessage_CellDoubleClick

진입점: this.Message.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3084f4a4 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1095 | if (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) | UI_PROP | e.Cancel | true | 속성 Cancel 설정 |  |  |  |
| AC-c7022669 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1099 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | POPUP | new POPUP.SCM0007_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-98481258 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1100 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | UI_PROP | pop.UseTypeCode | UseTypeCode | 속성 UseTypeCode 설정 |  |  |  |
| AC-6828ea42 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1101 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | VALUE_SET | pop.Text | "SMS Content 입력" | 컨트롤 값 설정 |  |  |  |
| AC-ba58deb4 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1103 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-6020d97f | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1105 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |
| AC-a4f52008 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1107 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | GRID_SET | Message.ActiveSheet.Cells[e.Row, e.Column].Text | pop.Content | 그리드 속성/값 설정 |  |  |  |
| AC-5fd20353 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1108 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ if (this.siMessage.IsLock(siMessage.SheetName) == false && e.Co… | FLAG | sContentTemp | pop.Content | 화면 필드/플래그 변경 |  |  |  |
| AC-cbf4b4ce | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1116 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | POPUP | new POPUP.SCM0007_PopContent | () | 팝업/폼 생성 |  |  |  |
| AC-16cf7af5 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1117 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | UI_PROP | pop.UseTypeCode | UseTypeCode | 속성 UseTypeCode 설정 |  |  |  |
| AC-372e663a | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1118 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | UI_PROP | pop.Content | Message.ActiveSheet.Cells[e.Row, e.Column].Text | 속성 Content 설정 |  |  |  |
| AC-2a370fcc | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1119 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | UI_PROP | pop.SaveDiasable | false | 속성 SaveDiasable 설정 |  |  |  |
| AC-4e6c366e | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1120 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | VALUE_SET | pop.Text | "SMS Content" | 컨트롤 값 설정 |  |  |  |
| AC-b36100f6 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1121 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | CALL_EXT | pop.SetTextBold | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9780de2 | this.Message.CellDoubleClick | SCM0007_SMS_Setup.cs:1122 | else of (e.Column != siMessage.GetColumnIndex(DefColumns.MESSAGE_CONTENT)) ▸ else of (this.siMessage.IsLock(siMessage.SheetName) == false &&… | POPUP | pop.ShowDialog | (this) | 팝업/폼 열기 |  |  |  |

