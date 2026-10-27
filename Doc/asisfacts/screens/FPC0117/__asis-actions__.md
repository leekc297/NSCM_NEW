# AS-IS 액션 대조표 — FPC0117

> 원천: `Doc/asisfacts/screens/FPC0117/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 59행 · 메서드 10 · 종류 FLAG 27 · RETURN 8 · UI_MISC 7 · POPUP 4 · UI_PROP 4 · MESSAGE 3 · CALL_EXT 3 · VALUE_SET 2 · VALIDATE 1 · ⚠ 의미 확인 필요 3


## FPC0117_ColorEditPopup.btnAdvColor_Click

진입점: this.btnAdvColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7781b0a | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:403 |  | POPUP | new ColorDialog | () | 팝업/폼 생성 |  |  |  |
| AC-d2173a37 | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:404 |  | UI_PROP | MyDialog.AllowFullOpen | true | 속성 AllowFullOpen 설정 |  |  |  |
| AC-6bd0c187 | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:406 |  | UI_PROP | MyDialog.ShowHelp | true | 속성 ShowHelp 설정 |  |  |  |
| AC-6def741c | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:408 |  | UI_PROP | MyDialog.Color | cpUserColor.Value | 속성 Color 설정 |  |  |  |
| AC-e780920f | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:411 |  | POPUP | MyDialog.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bb02c8eb | this.btnAdvColor.Click | FPC0117_ColorEditPopup.cs:413 | if (MyDialog.ShowDialog() == DialogResult.OK) | VALUE_SET | cpUserColor.Value | MyDialog.Color | 컨트롤 값 설정 |  |  |  |

## FPC0117_ColorEditPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a0fb8ae | (진입점 미연결) | FPC0117_ColorEditPopup.cs:260 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-8b023e14 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:263 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0117_ColorEditPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5af82d49 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:372 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input Param Name") | 메시지 표시 |  |  |  |
| AC-954b3eb5 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:373 | if (string.IsNullOrWhiteSpace(txtName.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ad560352 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:377 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input Param Description") | 메시지 표시 |  |  |  |
| AC-a2c3617a | this.btnOK.Click | FPC0117_ColorEditPopup.cs:378 | if (string.IsNullOrWhiteSpace(txtDescription.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd7ac6a6 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:382 | if (string.IsNullOrWhiteSpace(txtUIDesc.Text.Trim())) | MESSAGE | MessageBox.Show | ("Input UI Description") | 메시지 표시 |  |  |  |
| AC-abc10818 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:383 | if (string.IsNullOrWhiteSpace(txtUIDesc.Text.Trim())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93e460d3 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:386 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (cpUserColor.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a95ea647 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:387 |  | CALL_EXT | cpUserColor.Value.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3a3486e0 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:389 |  | CALL_EXT | System.Drawing.ColorTranslator.ToHtml | (tmp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7e3e099 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:390 |  | FLAG | ColorDesc | colorTxt | 화면 필드/플래그 변경 |  |  |  |
| AC-8715340b | this.btnOK.Click | FPC0117_ColorEditPopup.cs:391 |  | FLAG | ParamName | txtName.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-1faac3af | this.btnOK.Click | FPC0117_ColorEditPopup.cs:392 |  | FLAG | ParamDesc | txtDescription.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-35e1f268 | this.btnOK.Click | FPC0117_ColorEditPopup.cs:393 |  | FLAG | UIDesc | txtUIDesc.Text | 화면 필드/플래그 변경 |  |  |  |

## FPC0117_ColorEditPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4ca566f | this.Load | FPC0117_ColorEditPopup.cs:199 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0117_ColorEditPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ae4da4a | Dispose | FPC0117_ColorEditPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0117_ColorEditPopup.FindData

진입점: this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !string.IsNullOrWhiteSpace(_UserId))] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28c38cca | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0117_ColorEditPopup.cs:213 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5cd25922 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0117_ColorEditPopup.cs:220 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4c2c2350 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0117_ColorEditPopup.cs:220 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5144a77 | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0117_ColorEditPopup.cs:226 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-920c8f4b | this.Load [if (!string.IsNullOrWhiteSpace(_UserId) \|\| !str… 외 1 | FPC0117_ColorEditPopup.cs:238 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FPC0117_ColorEditPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5710012a | this.Load | FPC0117_ColorEditPopup.cs:163 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e492846a | this.Load | FPC0117_ColorEditPopup.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-70447985 | this.Load | FPC0117_ColorEditPopup.cs:173 | if (!string.IsNullOrWhiteSpace(_UserId)) | VALUE_SET | txtName.Text | _UserId | 컨트롤 값 설정 |  |  |  |

## FPC0117_ColorEditPopup.SetUserInfo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e36b65cd | (진입점 미연결) | FPC0117_ColorEditPopup.cs:308 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0c4e1c31 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:309 | if (iClick_Row < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea5725b3 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:311 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1672aafa | (진입점 미연결) | FPC0117_ColorEditPopup.cs:312 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-cbdc9e03 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:313 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5c09f8e9 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:314 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c4d38c8c | (진입점 미연결) | FPC0117_ColorEditPopup.cs:315 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-eac9c8d7 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:316 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-162c30e5 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:317 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8c50d5ff | (진입점 미연결) | FPC0117_ColorEditPopup.cs:318 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c3bd1212 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:319 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-23ea7bf8 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:320 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d5e6b171 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:323 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0117_ColorEditPopup.spdMain_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00fd9096 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:273 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d138c32a | (진입점 미연결) | FPC0117_ColorEditPopup.cs:275 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FPC0117_ColorEditPopup.spdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-368abe47 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:279 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-744d021d | (진입점 미연결) | FPC0117_ColorEditPopup.cs:281 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a292fbc | (진입점 미연결) | FPC0117_ColorEditPopup.cs:283 |  | FLAG | _CompanyId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.COMPANY)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9d805bd3 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:284 |  | FLAG | _DivisionId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DIVISION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f8634f79 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:285 |  | FLAG | _CorporationId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.CORPORATION)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-828e477a | (진입점 미연결) | FPC0117_ColorEditPopup.cs:286 |  | FLAG | _PlantId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PLANT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-5b79783f | (진입점 미연결) | FPC0117_ColorEditPopup.cs:287 |  | FLAG | _Department | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.DEPARTMENT)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-81081c51 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:288 |  | FLAG | _UserId | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_ID)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-102d2586 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:289 |  | FLAG | _UserName | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_NAME)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-f6d5b81e | (진입점 미연결) | FPC0117_ColorEditPopup.cs:290 |  | FLAG | _UserGradeCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.USER_GRAD_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-d36c9883 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:291 |  | FLAG | _IP | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.IP_ADRESS)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-80d07e76 | (진입점 미연결) | FPC0117_ColorEditPopup.cs:292 |  | FLAG | _PassCode | siMain.GetValue(iClick_Row, siMain.GetColumnIndex(DefColumns.PASS_CODE)).ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0485b74e | (진입점 미연결) | FPC0117_ColorEditPopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

