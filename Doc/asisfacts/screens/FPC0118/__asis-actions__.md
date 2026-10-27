# AS-IS 액션 대조표 — FPC0118

> 원천: `Doc/asisfacts/screens/FPC0118/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 62행 · 메서드 10 · 종류 FLAG 27 · UI_MISC 7 · RETURN 7 · VALUE_SET 6 · POPUP 4 · UI_PROP 4 · CALL_EXT 4 · MESSAGE 2 · VALIDATE 1 · ⚠ 의미 확인 필요 4


## FPC0118_CateColorEditPopup.btnAdvColor_Click

진입점: this.btnAdvColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b49131d | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:419 |  | POPUP | new ColorDialog | () | 팝업/폼 생성 |  |  |  |
| AC-d1963b60 | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:420 |  | UI_PROP | MyDialog.AllowFullOpen | true | 속성 AllowFullOpen 설정 |  |  |  |
| AC-1017095b | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:422 |  | UI_PROP | MyDialog.ShowHelp | true | 속성 ShowHelp 설정 |  |  |  |
| AC-1afad951 | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:424 |  | UI_PROP | MyDialog.Color | cpUserColor.Value | 속성 Color 설정 |  |  |  |
| AC-335df947 | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:427 |  | POPUP | MyDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-13d3ef71 | this.btnAdvColor.Click | FPC0118_CateColorEditPopup.cs:429 | if (MyDialog.ShowDialog() == DialogResult.OK) | VALUE_SET | cpUserColor.Value | MyDialog.Color | 컨트롤 값 설정 |  |  |  |

## FPC0118_CateColorEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ea00521 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:274 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-b1988035 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:277 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0118_CateColorEditPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16140898 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:386 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input Param Name") | 메시지 표시 |  |  |  |
| AC-a374d7d3 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:387 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c852db53 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:391 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input UI Description") | 메시지 표시 |  |  |  |
| AC-21f039bc | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:392 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26a607de | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:400 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (cpUserColor.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4d548c1d | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:401 |  | CALL_EXT | cpUserColor.Value.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-94aa74d3 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:403 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (tmp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a52f784 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:404 |  | FLAG | ColorDesc | colorTxt | 화면 필드/플래그 변경 |  |  |  |
| AC-2d91fb20 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:405 |  | FLAG | ParamName | txtName.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-a6756499 | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:406 |  | FLAG | ParamDesc | txtDescription.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-d5e0a39c | this.btnOK.Click | FPC0118_CateColorEditPopup.cs:408 |  | FLAG | IsDefault | cbDef.Checked | 화면 필드/플래그 변경 |  |  |  |

## FPC0118_CateColorEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3e266b1 | this.Load | FPC0118_CateColorEditPopup.cs:213 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0118_CateColorEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0588af55 | Dispose | FPC0118_CateColorEditPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0118_CateColorEditPopup.FindData

진입점: this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !string.IsNullOrWhiteSpace(_UserId))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc9be41d | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0118_CateColorEditPopup.cs:227 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4047c131 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0118_CateColorEditPopup.cs:234 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-ea899fdc | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0118_CateColorEditPopup.cs:234 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de2c2b79 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0118_CateColorEditPopup.cs:240 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c691f3c2 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0118_CateColorEditPopup.cs:252 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0118_CateColorEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f31c780 | this.Load | FPC0118_CateColorEditPopup.cs:163 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6f69d22 | this.Load | FPC0118_CateColorEditPopup.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-68eea654 | this.Load | FPC0118_CateColorEditPopup.cs:173 | if (IsDefault) | VALUE_SET | cbDef.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-036909d2 | this.Load | FPC0118_CateColorEditPopup.cs:177 | else of (IsDefault) | VALUE_SET | cbDef.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-907ec2b1 | this.Load | FPC0118_CateColorEditPopup.cs:182 | try | VALUE_SET | cpUserColor.Value | System.Drawing.ColorTranslator.FromHtml(ColorDesc) | 컨트롤 값 설정 |  |  |  |
| AC-08de6fe0 | this.Load | FPC0118_CateColorEditPopup.cs:182 | try | CALL_EXT | System.Drawing.ColorTranslator.FromHtml | (ColorDesc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-975ed719 | this.Load | FPC0118_CateColorEditPopup.cs:185 |  | VALUE_SET | txtName.Text | ParamName | 컨트롤 값 설정 |  |  |  |
| AC-83e0c209 | this.Load | FPC0118_CateColorEditPopup.cs:186 |  | VALUE_SET | txtDescription.Text | ParamDesc | 컨트롤 값 설정 |  |  |  |

## FPC0118_CateColorEditPopup.SetUserInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23a840f9 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:322 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9776d8e6 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:323 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b36c358 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:325 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-455b25a6 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:326 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c61370ce | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:327 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b79b2e6a | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:328 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1c7d0e28 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:329 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-7492169a | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:330 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-67580014 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:331 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-97fb5e00 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:332 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d173bab3 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:333 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7d388da | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:334 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-722fc6d3 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:337 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0118_CateColorEditPopup.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d25252b7 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4e4e7c6 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:289 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0118_CateColorEditPopup.spdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-722448a3 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:293 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-4b35ff9a | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:295 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2df8fac9 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:297 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-792845e5 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:298 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f5752f8 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:299 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2cdda0e4 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:300 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-872008f3 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:301 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d6421010 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:302 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0cc41de1 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:303 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b26af9a5 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:304 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a19f03c8 | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:305 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a6900c | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:306 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-efbd272a | (진입점 미연결) | FPC0118_CateColorEditPopup.cs:311 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

