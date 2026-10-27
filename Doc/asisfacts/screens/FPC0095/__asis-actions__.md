# AS-IS 액션 대조표 — FPC0095

> 원천: `Doc/asisfacts/screens/FPC0095/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 39행 · 메서드 10 · 종류 FLAG 21 · UI_MISC 7 · VALUE_SET 6 · UI_PROP 5 · ⚠ 의미 확인 필요 0


## FPC0095_ExcelSelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb4aa484 | .ctor | FPC0095_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7a59ca3f | .ctor | FPC0095_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-90a6229a | .ctor | FPC0095_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a99d2464 | .ctor | FPC0095_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-5fe7bf8b | .ctor | FPC0095_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7709b4aa | .ctor | FPC0095_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-a75b97af | .ctor | FPC0095_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2fd9de08 | .ctor | FPC0095_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ae2720d | this.btnOK.Click | FPC0095_ExcelSelect_Popup.cs:166 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-44dc6da7 | this.btnOK.Click | FPC0095_ExcelSelect_Popup.cs:167 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0095_ExcelSelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0a23a06 | Dispose | FPC0095_ExcelSelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-b5d96b01 | Dispose | FPC0095_ExcelSelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0095_ExcelSelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66a6d034 | this.Load | FPC0095_ExcelSelect_Popup.cs:93 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f093b347 | this.Load | FPC0095_ExcelSelect_Popup.cs:97 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5a96a23 | this.Load | FPC0095_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-531d53e6 | this.Load | FPC0095_ExcelSelect_Popup.cs:85 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-a69183e0 | this.Load | FPC0095_ExcelSelect_Popup.cs:88 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d3404201 | this.Load | FPC0095_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-edfcd8f2 | this.Load | FPC0095_ExcelSelect_Popup.cs:84 |  | VALUE_SET | rbOpt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-578c9e09 | this.Load | FPC0095_ExcelSelect_Popup.cs:85 |  | VALUE_SET | rbOptLine1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6ed2098a | this.Load | FPC0095_ExcelSelect_Popup.cs:86 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-31f7e4ec | this.Load | FPC0095_ExcelSelect_Popup.cs:92 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-551c2405 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:122 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-0a9a94f8 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:123 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-2c8c7819 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:124 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-493976e9 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:126 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c00a0936 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:127 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d7d9bbd6 | rbOpt1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:129 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f8e6636 | rbOpt2.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:133 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-896c172a | rbOpt2.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:134 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-a6abdd0b | rbOpt2.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:135 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-309fce35 | rbOpt2.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:154 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.rbOptLine1_Click

진입점: rbOptLine1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19d13b5f | rbOptLine1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:145 | if (loaded) | FLAG | Selection2 | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-c42b64c4 | rbOptLine1.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:147 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.rbOptLine2_Click

진입점: rbOptLine2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97303d0 | rbOptLine2.CheckedChanged | FPC0095_ExcelSelect_Popup.cs:136 | if (loaded) | FLAG | Selection2 | 1 | 화면 필드/플래그 변경 |  |  |  |

## FPC0095_ExcelSelect_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee2e6e81 | (진입점 미연결) | FPC0095_ExcelSelect_Popup.cs:100 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-85fc9c14 | (진입점 미연결) | FPC0095_ExcelSelect_Popup.cs:102 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-3b8ec3e4 | (진입점 미연결) | FPC0095_ExcelSelect_Popup.cs:104 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-0e3f480a | (진입점 미연결) | FPC0095_ExcelSelect_Popup.cs:106 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

