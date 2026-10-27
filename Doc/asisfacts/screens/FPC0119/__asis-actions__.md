# AS-IS 액션 대조표 — FPC0119

> 원천: `Doc/asisfacts/screens/FPC0119/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 18행 · 메서드 7 · 종류 FLAG 9 · UI_MISC 4 · UI_PROP 3 · VALUE_SET 2 · ⚠ 의미 확인 필요 0


## FPC0119_MemoSelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-264cb5e2 | .ctor | FPC0119_MemoSelect_Popup.cs:74 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-1e75ee57 | .ctor | FPC0119_MemoSelect_Popup.cs:75 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9eea714a | .ctor | FPC0119_MemoSelect_Popup.cs:76 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-cc6ce629 | .ctor | FPC0119_MemoSelect_Popup.cs:78 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FPC0119_MemoSelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a549b879 | Dispose | FPC0119_MemoSelect_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0119_MemoSelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72fbbed1 | this.Load | FPC0119_MemoSelect_Popup.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0119_MemoSelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-172f7d85 | this.Load | FPC0119_MemoSelect_Popup.cs:89 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-63022c29 | this.Load | FPC0119_MemoSelect_Popup.cs:97 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-a048332a | this.Load | FPC0119_MemoSelect_Popup.cs:100 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FPC0119_MemoSelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a1e4837 | rbOpt1.CheckedChanged | FPC0119_MemoSelect_Popup.cs:134 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-65ecb08b | rbOpt1.CheckedChanged | FPC0119_MemoSelect_Popup.cs:135 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-af654270 | rbOpt1.CheckedChanged | FPC0119_MemoSelect_Popup.cs:136 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-43e32058 | rbOpt1.CheckedChanged | FPC0119_MemoSelect_Popup.cs:138 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FPC0119_MemoSelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-321cbd63 | rbOpt2.CheckedChanged | FPC0119_MemoSelect_Popup.cs:145 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-24ef52d4 | rbOpt2.CheckedChanged | FPC0119_MemoSelect_Popup.cs:146 | if (loaded) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-6af740cc | rbOpt2.CheckedChanged | FPC0119_MemoSelect_Popup.cs:147 | if (loaded) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0119_MemoSelect_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8deed84a | (진입점 미연결) | FPC0119_MemoSelect_Popup.cs:112 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-24a27af4 | (진입점 미연결) | FPC0119_MemoSelect_Popup.cs:114 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

