# AS-IS 액션 대조표 — FPC0109

> 원천: `Doc/asisfacts/screens/FPC0109/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 93행 · 메서드 13 · 종류 VALUE_SET 45 · FLAG 33 · UI_MISC 9 · UI_PROP 6 · ⚠ 의미 확인 필요 0


## FPC0109_ExcelSelect_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdc92188 | .ctor | FPC0109_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-44348315 | .ctor | FPC0109_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-dfa16d11 | .ctor | FPC0109_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9eb61d25 | .ctor | FPC0109_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b9897a | .ctor | FPC0109_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-494a24a8 | .ctor | FPC0109_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-8335496e | .ctor | FPC0109_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2e31dc70 | .ctor | FPC0109_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |
| AC-f04441f3 | .ctor | FPC0109_ExcelSelect_Popup.cs:62 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7b8031 | .ctor | FPC0109_ExcelSelect_Popup.cs:63 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-fbedc7dd | .ctor | FPC0109_ExcelSelect_Popup.cs:64 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-3d13e8e6 | .ctor | FPC0109_ExcelSelect_Popup.cs:66 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e67fbe79 | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:187 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-737d0c8d | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:188 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5cf3f750 | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:187 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e56dda0b | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:188 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-d82badee | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:187 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-f4f1841b | this.btnOK.Click | FPC0109_ExcelSelect_Popup.cs:188 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FPC0109_ExcelSelect_Popup.CbHide_CheckedChanged

진입점: cbHide2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-298ae97f | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:113 | if (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.HideZero | 화면 필드/플래그 변경 |  |  |  |
| AC-aef371cb | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:115 | else of (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.ShowZero | 화면 필드/플래그 변경 |  |  |  |
| AC-e76f93f8 | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:113 | if (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.HideZero | 화면 필드/플래그 변경 |  |  |  |
| AC-32815c31 | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:115 | else of (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.ShowZero | 화면 필드/플래그 변경 |  |  |  |
| AC-51b695db | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:113 | if (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.HideZero | 화면 필드/플래그 변경 |  |  |  |
| AC-8c24dbb8 | cbHide2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:115 | else of (cbHide2.Checked) | FLAG | ZeroSelection | ZeroOption.ShowZero | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43bbb321 | Dispose | FPC0109_ExcelSelect_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-ce56b803 | Dispose | FPC0109_ExcelSelect_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-e6f8da1c | Dispose | FPC0109_ExcelSelect_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FPC0109_ExcelSelect_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a639f835 | this.Load | FPC0109_ExcelSelect_Popup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7cf5314f | this.Load | FPC0109_ExcelSelect_Popup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3a22c37 | this.Load | FPC0109_ExcelSelect_Popup.cs:130 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2225987d | this.Load | FPC0109_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4be665d2 | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-d09e090b | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-2eaa58e5 | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-bd6119ec | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-582da3a0 | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-897d397d | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-916e6f3f | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4376282e | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b0be514c | this.Load | FPC0109_ExcelSelect_Popup.cs:96 | if (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-e732ca1d | this.Load | FPC0109_ExcelSelect_Popup.cs:98 | else of (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-4d6e9b30 | this.Load | FPC0109_ExcelSelect_Popup.cs:100 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-9131381f | this.Load | FPC0109_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-74b58f25 | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-990d7d1e | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-49f93988 | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-2be57c7c | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-33633fbe | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-4312b502 | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-8ff271b7 | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ca12a6da | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-76cee744 | this.Load | FPC0109_ExcelSelect_Popup.cs:96 | if (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-8e5a4079 | this.Load | FPC0109_ExcelSelect_Popup.cs:98 | else of (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9f746948 | this.Load | FPC0109_ExcelSelect_Popup.cs:100 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-75e56503 | this.Load | FPC0109_ExcelSelect_Popup.cs:77 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-568423d5 | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-b5957734 | this.Load | FPC0109_ExcelSelect_Popup.cs:86 | if (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-efbd8eb8 | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-34aad188 | this.Load | FPC0109_ExcelSelect_Popup.cs:88 | else of (MergeSelection == ExcelMergeOption.Casecaded) | VALUE_SET | rbOpt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-2037ba77 | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-1fdd51bc | this.Load | FPC0109_ExcelSelect_Popup.cs:91 | if (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-6c0e5e55 | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt1.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-44cf9fb7 | this.Load | FPC0109_ExcelSelect_Popup.cs:93 | else of (LineSelection == ExcelBorderOption.All) | VALUE_SET | rb2_Opt2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-ba2292fa | this.Load | FPC0109_ExcelSelect_Popup.cs:96 | if (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-06e139da | this.Load | FPC0109_ExcelSelect_Popup.cs:98 | else of (ZeroSelection == ZeroOption.HideZero) | VALUE_SET | cbHide2.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-ab4f808c | this.Load | FPC0109_ExcelSelect_Popup.cs:100 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FPC0109_ExcelSelect_Popup.Rb2_Opt1_CheckedChanged

진입점: rb2_Opt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddcc2264 | rb2_Opt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:120 |  | FLAG | LineSelection | ExcelBorderOption.All | 화면 필드/플래그 변경 |  |  |  |
| AC-597dba39 | rb2_Opt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:120 |  | FLAG | LineSelection | ExcelBorderOption.All | 화면 필드/플래그 변경 |  |  |  |
| AC-6678fb13 | rb2_Opt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:120 |  | FLAG | LineSelection | ExcelBorderOption.All | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.Rb2_Opt2_CheckedChanged

진입점: rb2_Opt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96894a00 | rb2_Opt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:125 |  | FLAG | LineSelection | ExcelBorderOption.None | 화면 필드/플래그 변경 |  |  |  |
| AC-8681c41e | rb2_Opt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:125 |  | FLAG | LineSelection | ExcelBorderOption.None | 화면 필드/플래그 변경 |  |  |  |
| AC-eecd3337 | rb2_Opt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:125 |  | FLAG | LineSelection | ExcelBorderOption.None | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.rbOpt1_Click

진입점: rbOpt1.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bcd1bc4b | rbOpt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:172 |  | FLAG | MergeSelection | ExcelMergeOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-b96d5ac8 | rbOpt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:172 |  | FLAG | MergeSelection | ExcelMergeOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |
| AC-5cf2bc07 | rbOpt1.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:172 |  | FLAG | MergeSelection | ExcelMergeOption.Casecaded | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.rbOpt2_Click

진입점: rbOpt2.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bab273c | rbOpt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:177 |  | FLAG | MergeSelection | ExcelMergeOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-be67d37a | rbOpt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:177 |  | FLAG | MergeSelection | ExcelMergeOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |
| AC-2b66f734 | rbOpt2.CheckedChanged | FPC0109_ExcelSelect_Popup.cs:177 |  | FLAG | MergeSelection | ExcelMergeOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FPC0109_ExcelSelect_Popup.SetCascadeOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a3a4925 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:137 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-4869ea18 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:139 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-a891d18b | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:137 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-a40e4c60 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:139 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-2adfb46c | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:137 | if (index == 0) | VALUE_SET | rbOpt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-b373d941 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:139 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rbOpt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

## FPC0109_ExcelSelect_Popup.SetLineOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcdb6e8c | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:145 | if (index == 0) | VALUE_SET | rb2_Opt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-f392ad0a | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:147 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rb2_Opt2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-c248cd7e | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:145 | if (index == 0) | VALUE_SET | rb2_Opt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-438cd677 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:147 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rb2_Opt2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-0aa34aff | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:145 | if (index == 0) | VALUE_SET | rb2_Opt1.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-231a4cc6 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:147 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rb2_Opt2.Text | option_name | 컨트롤 값 설정 |  |  |  |

## FPC0109_ExcelSelect_Popup.SetZeroOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099e0986 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:152 |  | VALUE_SET | cbHide2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-3883bf4c | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:152 |  | VALUE_SET | cbHide2.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-119a6083 | (진입점 미연결) | FPC0109_ExcelSelect_Popup.cs:152 |  | VALUE_SET | cbHide2.Text | option_name | 컨트롤 값 설정 |  |  |  |

