# AS-IS 액션 대조표 — FPC0120

> 원천: `Doc/asisfacts/screens/FPC0120/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 62행 · 메서드 10 · 종류 FLAG 27 · UI_MISC 7 · RETURN 7 · VALUE_SET 6 · POPUP 4 · UI_PROP 4 · CALL_EXT 4 · MESSAGE 2 · VALIDATE 1 · ⚠ 의미 확인 필요 4


## FPC0120_CateColorDayEditPopup.btnAdvColor_Click

진입점: this.btnAdvColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28aa31af | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:419 |  | POPUP | new ColorDialog | () | 팝업/폼 생성 |  |  |  |
| AC-00157945 | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:420 |  | UI_PROP | MyDialog.AllowFullOpen | true | 속성 AllowFullOpen 설정 |  |  |  |
| AC-d56e43b2 | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:422 |  | UI_PROP | MyDialog.ShowHelp | true | 속성 ShowHelp 설정 |  |  |  |
| AC-ebb03d68 | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:424 |  | UI_PROP | MyDialog.Color | cpUserColor.Value | 속성 Color 설정 |  |  |  |
| AC-b9c29e0c | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:427 |  | POPUP | MyDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a1dcb699 | this.btnAdvColor.Click | FPC0120_CateColorDayEditPopup.cs:429 | if (MyDialog.ShowDialog() == DialogResult.OK) | VALUE_SET | cpUserColor.Value | MyDialog.Color | 컨트롤 값 설정 |  |  |  |

## FPC0120_CateColorDayEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66219f30 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:274 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-742b29eb | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:277 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0120_CateColorDayEditPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaa75471 | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:386 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input Param Name") | 메시지 표시 |  |  |  |
| AC-eaa1a90c | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:387 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-982dcccd | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:391 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input UI Description") | 메시지 표시 |  |  |  |
| AC-fc92987c | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:392 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f134d92c | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:400 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (cpUserColor.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34f1e1a0 | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:401 |  | CALL_EXT | cpUserColor.Value.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3dc3218 | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:403 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (tmp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-648ad70a | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:404 |  | FLAG | ColorDesc | colorTxt | 화면 필드/플래그 변경 |  |  |  |
| AC-1176067f | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:405 |  | FLAG | ParamName | txtName.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-e971b572 | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:406 |  | FLAG | ParamDesc | txtDescription.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-2b18e94a | this.btnOK.Click | FPC0120_CateColorDayEditPopup.cs:408 |  | FLAG | IsDefault | cbDef.Checked | 화면 필드/플래그 변경 |  |  |  |

## FPC0120_CateColorDayEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56d97458 | this.Load | FPC0120_CateColorDayEditPopup.cs:213 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0120_CateColorDayEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1b47ca5 | Dispose | FPC0120_CateColorDayEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0120_CateColorDayEditPopup.FindData

진입점: this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !string.IsNullOrWhiteSpace(_UserId))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3639109 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0120_CateColorDayEditPopup.cs:227 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8256b289 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0120_CateColorDayEditPopup.cs:234 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-02648125 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0120_CateColorDayEditPopup.cs:234 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0a87733d | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0120_CateColorDayEditPopup.cs:240 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a2b6813c | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0120_CateColorDayEditPopup.cs:252 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0120_CateColorDayEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac5cc5d0 | this.Load | FPC0120_CateColorDayEditPopup.cs:163 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-03c29560 | this.Load | FPC0120_CateColorDayEditPopup.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-16fe4fd2 | this.Load | FPC0120_CateColorDayEditPopup.cs:173 | if (IsDefault) | VALUE_SET | cbDef.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-d60d6c5e | this.Load | FPC0120_CateColorDayEditPopup.cs:177 | else of (IsDefault) | VALUE_SET | cbDef.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-943e3f41 | this.Load | FPC0120_CateColorDayEditPopup.cs:182 | try | VALUE_SET | cpUserColor.Value | System.Drawing.ColorTranslator.FromHtml(ColorDesc) | 컨트롤 값 설정 |  |  |  |
| AC-dc035737 | this.Load | FPC0120_CateColorDayEditPopup.cs:182 | try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (ColorDesc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1d1eb86 | this.Load | FPC0120_CateColorDayEditPopup.cs:185 |  | VALUE_SET | txtName.Text | ParamName | 컨트롤 값 설정 |  |  |  |
| AC-bfd0a964 | this.Load | FPC0120_CateColorDayEditPopup.cs:186 |  | VALUE_SET | txtDescription.Text | ParamDesc | 컨트롤 값 설정 |  |  |  |

## FPC0120_CateColorDayEditPopup.SetUserInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9a00561 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:322 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-500f319c | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:323 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfa25f80 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:325 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b15dfdbe | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:326 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6267b122 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:327 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-874275f9 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:328 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-213281ee | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:329 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-644cfcb3 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:330 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1e4522b | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:331 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-97aa195d | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:332 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a0814b | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:333 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1b2e781c | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:334 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2f651837 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:337 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0120_CateColorDayEditPopup.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b06bd2cc | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07cec6d4 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:289 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0120_CateColorDayEditPopup.spdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d2fb056 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:293 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-b097d0c7 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:295 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b2461f3 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:297 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a91fd2b3 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:298 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-56741393 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:299 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2bb55766 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:300 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e8992b | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:301 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c716886 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:302 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f9e6fab | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:303 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c09cc1ea | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:304 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-299f35c1 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:305 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0c33a211 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:306 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e0ed1738 | (진입점 미연결) | FPC0120_CateColorDayEditPopup.cs:311 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

