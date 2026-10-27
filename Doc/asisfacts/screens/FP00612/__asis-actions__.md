# AS-IS 액션 대조표 — FP00612

> 원천: `Doc/asisfacts/screens/FP00612/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 584행 · 메서드 79 · 종류 DATA_OP 144 · UI_PROP 76 · FLAG 57 · GRID_SET 57 · VALUE_SET 47 · CALL_EXT 42 · POPUP 29 · RETURN 26 · UI_MISC 17 · MESSAGE 16 · GRID_INIT 15 · COMBO_DATA 13 · ENDPOINT 13 · THROW 9 · LIST_REBIND 8 · GRID_STYLE 5 · CALL_BASE 4 · STATE 2 · LIST_CLEAR 1 · STATE_RESET 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 46


## FP00612_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bc19f20 | .ctor | FP00612_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-13622a5a | .ctor | FP00612_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b2babfca | .ctor | FP00612_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-5048ec2d | .ctor | FP00612_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00612_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d86bd52 | Dispose | FP00612_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00612_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73873856 | this.Load | FP00612_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00612_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cc02479 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:213 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8063b53d | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:214 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e48cf4c | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:215 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f9258b0 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:217 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a88e5f | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:218 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f350692 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:219 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-8223eff4 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:221 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fa47df5 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:222 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd59426d | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:223 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d1896aa | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:225 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e4ba436 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:226 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ee6e98e | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:227 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fc69538 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-256bd457 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6077bec | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-890f0d19 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-53b91e2d | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d991ca63 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fc982f3 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-82493b40 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-89aeefdd | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-dce52fa6 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1630f3d0 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbbf44c4 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4cdf33e | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-861702bb | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:251 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ee6cfde | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:251 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-6d37eef9 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:258 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-bccccfb1 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:262 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00612_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59773cd7 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5e07d7f | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:131 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-376a8d16 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b185e24a | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-12fa2bd2 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4fddae0e | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ae47a20a | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:138 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b87b7f63 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-43c18c2d | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2710af46 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3c5f23c4 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-77443c93 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f777ad48 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c298a49b | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4c9b556c | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:151 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-97ebb05e | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c22f2bd3 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-86677339 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-85af232d | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-883a31f2 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bdfed708 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-70945db6 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6c504a96 | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0995c69c | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e905214a | this.Load 외 1 | FP00612_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00612_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82baa611 | (진입점 미연결) | FP00612_MeasureSetForm_Popup.cs:324 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-fb75a7d3 | (진입점 미연결) | FP00612_MeasureSetForm_Popup.cs:335 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afcd2357 | (진입점 미연결) | FP00612_MeasureSetForm_Popup.cs:346 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00612_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33b7636 | this.Load | FP00612_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-decdb18b | this.Load | FP00612_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00612_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d03b3998 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:309 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-57286de8 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:309 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-374adb26 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-3c6b16a0 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:315 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-765bdeb4 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:316 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-595a5cd7 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:318 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ef83411 | this.usrButton1.Click | FP00612_MeasureSetForm_Popup.cs:320 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00612_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-564c69f4 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-01181e84 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-10628699 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:285 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-62d2c062 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:289 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-a4e54044 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:290 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-dabe745f | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:291 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-76166184 | this.usrButton2.Click | FP00612_MeasureSetForm_Popup.cs:292 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00612_PlanBy_Line_Pack..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4575883d | .ctor | FP00612_PlanBy_Line_Pack.cs:137 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_PACK") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb6bb56f | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2040 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d9f72a48 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2041 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-72b8a5e7 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2042 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9cb57036 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2043 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cbdf30ee | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2044 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2dcd4fc6 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2046 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-81fef54b | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2046 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e8b59551 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2047 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-b1389e4c | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2047 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c5bac876 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2048 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 화면 필드/플래그 변경 |  |  |  |
| AC-1883a942 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2048 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-63a3f7ef | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2049 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-7e98b2c4 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2049 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5a42dbf2 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2050 |  | FLAG | day2_week_month | Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b1980681 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2050 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00612_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "DAY2_WEEK_MONTH") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-08579319 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2059 |  | CALL_EXT | DataService.ToLoopParam2 | ("", day2_week_month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04fcd3da | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2064 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-f527e31b | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2065 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-948d5b1c | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2066 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-624debf8 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2067 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-68953bc5 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2068 |  | DATA_OP | Filter["DAY2_WEEK_MONTH"] | sDay2_week_month | 행/컬럼 값 대입 |  |  |  |
| AC-9b650b24 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2069 |  | DATA_OP | Filter["CURR_DATE_COL"] | DataService.ToLoopParam2("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper()… | 행/컬럼 값 대입 |  |  |  |
| AC-5439adf7 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2069 |  | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00612_ETC").ToUpper(), Filter, CurrentUser, "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-081a8bf0 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2069 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00612_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00612_PlanBy_Line_Pack.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_PACK") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ce838fb | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2073 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-99125b72 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2080 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-38175f6a | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2081 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7e62870e | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2082 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07d9dbd7 | this.btn_bucket.Click | FP00612_PlanBy_Line_Pack.cs:2673 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00612", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-c9ab5ac7 | this.btn_bucket.Click | FP00612_PlanBy_Line_Pack.cs:2675 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-6f820d0c | this.btn_bucket.Click | FP00612_PlanBy_Line_Pack.cs:2676 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f2376134 | this.btn_bucket.Click | FP00612_PlanBy_Line_Pack.cs:2677 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2cebce9c | this.btn_bucket.Click | FP00612_PlanBy_Line_Pack.cs:2681 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bbaf33d | this.btn_category.Click | FP00612_PlanBy_Line_Pack.cs:2639 |  | POPUP | new FP00612_MeasureSetForm_Popup | ("FP00612", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-4af4d40d | this.btn_category.Click | FP00612_PlanBy_Line_Pack.cs:2640 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-516f5211 | this.btn_category.Click | FP00612_PlanBy_Line_Pack.cs:2641 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0a989065 | this.btn_category.Click | FP00612_PlanBy_Line_Pack.cs:2642 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5458bf5a | this.btn_category.Click | FP00612_PlanBy_Line_Pack.cs:2646 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40e1e2d1 | this.btn_column.Click | FP00612_PlanBy_Line_Pack.cs:2621 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00612", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-b413366a | this.btn_column.Click | FP00612_PlanBy_Line_Pack.cs:2622 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-288a853c | this.btn_column.Click | FP00612_PlanBy_Line_Pack.cs:2623 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26b60924 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2803 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-248b7c15 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2804 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8d9e16e | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2807 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eea1b8cc | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2808 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-3673452e | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2809 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-22533e23 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2809 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e4e0e878 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2810 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-735faf71 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2811 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a805a1f | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2812 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-83ddf779 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2812 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4316c681 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2813 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4984fb52 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2814 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c68e01af | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2815 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a11a691 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2816 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eb83b8db | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2817 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b96c4af3 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2818 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b424d583 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2819 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-80370f99 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2820 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2539c68b | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2821 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-59f71c26 | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2823 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e4d3621d | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2825 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b30ad3fc | this.btnMemo.Click | FP00612_PlanBy_Line_Pack.cs:2826 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0ddafd | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2782 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-73ad9257 | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2783 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a31107f | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2786 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-97a1b49c | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2787 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-cd10570c | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2787 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ece6bb64 | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2788 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b8a072b6 | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2788 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b59265de | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2789 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-ec44633e | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2790 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-38728bae | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2792 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-048e1db0 | this.btnPlanInfo.Click | FP00612_PlanBy_Line_Pack.cs:2793 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67b4a0d6 | this.btnSql.Click | FP00612_PlanBy_Line_Pack.cs:1601 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0508457e | this.btnSql.Click | FP00612_PlanBy_Line_Pack.cs:1602 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-79283165 | this.btnSql.Click | FP00612_PlanBy_Line_Pack.cs:1604 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00612_PLAN_BY_LINE_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f22291 | this.btnSql.Click | FP00612_PlanBy_Line_Pack.cs:1605 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.btnToggleSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ded56664 | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:2706 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7d5484c | this.Load | FP00612_PlanBy_Line_Pack.cs:461 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-9e75882d | this.Load | FP00612_PlanBy_Line_Pack.cs:461 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-3af72edd | this.Load | FP00612_PlanBy_Line_Pack.cs:463 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00612_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a8be0ac6 | this.Load | FP00612_PlanBy_Line_Pack.cs:463 |  | POPUP | new FP00612_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-65513208 | this.Load | FP00612_PlanBy_Line_Pack.cs:464 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00599_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3cc461a6 | this.Load | FP00612_PlanBy_Line_Pack.cs:464 |  | POPUP | new FP00599_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-5f7d34c2 | this.Load | FP00612_PlanBy_Line_Pack.cs:467 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-7686c37c | this.Load | FP00612_PlanBy_Line_Pack.cs:468 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-3109a11c | this.Load | FP00612_PlanBy_Line_Pack.cs:469 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4951f0e | this.Load | FP00612_PlanBy_Line_Pack.cs:470 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0a230cc | this.Load | FP00612_PlanBy_Line_Pack.cs:471 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-33969503 | this.Load | FP00612_PlanBy_Line_Pack.cs:472 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.CreateFilterDataSet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42a9f13b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1620 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-83bb96d6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1631 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-ccfdb24e | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1632 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-403d5de1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1662 | if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-26c3d35a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1666 | if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0fc7422 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1670 | if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc4a80b4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1674 | if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e1232fd | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1678 | if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-63de5409 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1682 | if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a7dbff66 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1686 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5e14cfa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1690 | if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeb272de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1694 | if (measure["chk_gap"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-85ebd70c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1698 | if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-201499ff | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1703 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "MEMO")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab4ee2fc | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1708 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-674f6523 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1715 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2b22d41 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1717 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2171a627 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1719 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-444c0fdf | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1721 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-636a6d5b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1723 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-65b470c5 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1725 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e18eaaa | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1727 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d65503c6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1729 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-841eb4d1 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1731 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-651ef9e7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1733 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e71d2419 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1739 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52421a6a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1741 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6c75886 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1743 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d5d6f09 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1745 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc2d4ba7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1747 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaa7906b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1749 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eecd1c4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1751 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-74b8e01f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1753 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b9f95e43 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1755 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-41804d0f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1757 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f501fc3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1759 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-94bb6c43 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1762 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | (MainGo, chks_measure_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2fec16de | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1763 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bb5817f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1767 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-32473e1b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1771 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fdcbf08b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1774 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea02f743 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1776 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb446efb | this.Load | FP00612_PlanBy_Line_Pack.cs:421 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfe57ff6 | this.Load | FP00612_PlanBy_Line_Pack.cs:422 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ec92fa6 | this.Load | FP00612_PlanBy_Line_Pack.cs:423 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00612_PlanBy_Line_Pack.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49f6d451 | DeleteButton | FP00612_PlanBy_Line_Pack.cs:1434 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00612_PlanBy_Line_Pack.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52e93aed | Dispose | FP00612_PlanBy_Line_Pack.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00612_PlanBy_Line_Pack.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a883f3ee | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2467 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0da6b40c | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2473 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ef27c56 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2475 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2e72a5ff | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2492 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-8e8f0439 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2493 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-79cd5eb0 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2517 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-6b944832 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2518 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-9b5f3df8 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2525 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-78470de0 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2526 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ else of (da… | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-8e0def2d | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2537 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | MESSAGE | MessageBox.Show | ("Period MAX 365 days.") | 메시지 표시 |  |  |  |
| AC-62229692 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2538 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ if (dayCount > 365) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |
| AC-572a7e36 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2545 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date(undefined).") | 메시지 표시 |  |  |  |
| AC-bd7e28e7 | drpPeriod.ValueChanged | FP00612_PlanBy_Line_Pack.cs:2546 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ else of (dtPeriod_Plan != null) ▸ else of (dayCount > 365) ▸ if (dayCount > 28 * … | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(27 * 3) | 속성 Value2 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29672a9a | EditButton | FP00612_PlanBy_Line_Pack.cs:1442 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00612_PlanBy_Line_Pack.Excel_Export

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6ccdd47 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:785 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6451197f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:789 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-13fe0482 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:793 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-94a1fee9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:797 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bd58e743 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:806 |  | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c422c53 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:756 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3016d261 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:757 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-830db281 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:759 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2b41b92 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:763 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-cb6bfcb3 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:764 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-330b5d48 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:765 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-5d08dda0 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:768 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-e3660c36 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:769 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-5c46cf2a | ExcelButton | FP00612_PlanBy_Line_Pack.cs:770 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-d4b604dc | ExcelButton | FP00612_PlanBy_Line_Pack.cs:772 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2d8470c6 | ExcelButton | FP00612_PlanBy_Line_Pack.cs:773 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.ExportExcelSimple

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec5d7ee2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:812 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2314bc80 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:815 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5f44673 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:821 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-5c0d80b0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:829 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-970c7c21 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:833 | try ▸ if (myarray.Length == 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ae87ac1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:834 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-888143ad | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:838 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c610cec | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:880 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-20a0c87f | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:880 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-75d2c16d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:886 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-bc2a1dc4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:900 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-96ca5dd0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:904 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e4add3b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:908 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-665576f8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:920 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-2bf8670a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:921 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-488045b0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:930 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-39ffd9e3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:931 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-5290978b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:937 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-e2d9c72a | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:946 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-54212bf9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:948 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e09e5be4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:951 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.FrozenColumnCount | FrozenColumnCount | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-5a7d1b95 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:960 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-87638ed0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:971 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-d1010c31 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:980 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-a9f5f718 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:989 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce8e5c4c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:996 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | UI_PROP | si.MaxRightMerge | 50 | 속성 MaxRightMerge 설정 |  |  |  |
| AC-cefa36ae | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:997 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0b5235ba | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1002 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57ac5f84 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1009 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-34ca8ead | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1011 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-adf1ddcd | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1015 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-fcdd9e43 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1017 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-9be590d9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1020 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-87ac740e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1022 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-091fe903 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1027 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-af239237 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1042 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f43aba43 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1048 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953a87f5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1052 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00612_PlanBy_Line_Pack.Find_Memo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ff6795 | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1988 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP00612_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-580d3452 | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1989 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-9152c965 | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1995 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00612_PlanBy_Line_Pack.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_PACK")] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-975170ad | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2018 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = null; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79e4e234 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2020 | try ▸ lambda | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-34854f06 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2027 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00612_PLAN_BY_LINE_PACK", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f596561 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2029 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-eb2775eb | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 3 | FP00612_PlanBy_Line_Pack.cs:2033 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00612_PlanBy_Line_Pack.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.spdMain.Ce…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-244136bb | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:737 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8424db88 | this.Load | FP00612_PlanBy_Line_Pack.cs:168 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00612_PlanBy_Line_Pack.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-183246ea | this.Load | FP00612_PlanBy_Line_Pack.cs:241 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-82e79335 | this.Load | FP00612_PlanBy_Line_Pack.cs:241 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00612_PlanBy_Line_Pack.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_PACK") ▸ try ▸ lambda] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc7c8b35 | popSql.OnSql [if (programID == "PR_UI_FP00612_PLAN_BY_LINE_P… 외 4 | FP00612_PlanBy_Line_Pack.cs:1839 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.GetPlanGroup

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17787973 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1847 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-98192316 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1848 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb8520fb | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1848 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7356ed77 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1850 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-47739be6 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1852 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1f769cd2 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1855 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-05740ac6 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1856 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-62284f46 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1856 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-19a4c0e0 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1857 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d65c26c | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1858 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bfc894df | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1859 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0e995ca5 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1863 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00612_PlanBy_Line_Pack.GetPlanPeriod

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c0c8ed6 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1870 |  | FLAG | dtPlanPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-5234e968 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1870 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7f83cbdf | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1871 |  | UI_PROP | drpPeriod.Text1 | dtPlanPeriod.Rows[0]["START_DATE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-c58ffbfb | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1872 |  | UI_PROP | drpPeriod.Text2 | dtPlanPeriod.Rows[0]["END_DATE"].ToString() | 속성 Text2 설정 |  |  |  |
| AC-5e04b500 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1874 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-fcb24123 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1875 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.GetProdType

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15996742 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1880 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-accf86e2 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1880 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-997494f8 | this.Load 외 1 | FP00612_PlanBy_Line_Pack.cs:1881 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00612_PlanBy_Line_Pack.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5abb6daa | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1904 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00612_PlanBy_Line_Pack.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d51bb8ec | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1449 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6af6c8a | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1451 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fcf839ac | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1514 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7efd8e87 | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1515 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-decc823e | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:1591 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00612_PlanBy_Line_Pack.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b89023c | this.Load | FP00612_PlanBy_Line_Pack.cs:183 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c48845c5 | this.Load | FP00612_PlanBy_Line_Pack.cs:187 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4c462777 | this.Load | FP00612_PlanBy_Line_Pack.cs:188 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ac5da854 | this.Load | FP00612_PlanBy_Line_Pack.cs:192 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-4b7342cd | this.Load | FP00612_PlanBy_Line_Pack.cs:196 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b7f58be | this.Load | FP00612_PlanBy_Line_Pack.cs:201 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e7895c8a | this.Load | FP00612_PlanBy_Line_Pack.cs:220 |  | FLAG | dtPlanPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-79b5f695 | this.Load | FP00612_PlanBy_Line_Pack.cs:220 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e36195ce | this.Load | FP00612_PlanBy_Line_Pack.cs:222 |  | UI_PROP | drpPeriod.Text1 | dtPlanPeriod.Rows[0]["START_DATE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-7a8e825f | this.Load | FP00612_PlanBy_Line_Pack.cs:223 |  | UI_PROP | drpPeriod.Text2 | dtPlanPeriod.Rows[0]["END_DATE"].ToString() | 속성 Text2 설정 |  |  |  |
| AC-7047d2a7 | this.Load | FP00612_PlanBy_Line_Pack.cs:225 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0aa69deb | this.Load | FP00612_PlanBy_Line_Pack.cs:226 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75e6fcf5 | this.Load | FP00612_PlanBy_Line_Pack.cs:384 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-77b28359 | this.Load | FP00612_PlanBy_Line_Pack.cs:385 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f0a106f8 | this.Load | FP00612_PlanBy_Line_Pack.cs:386 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-106179dd | this.Load | FP00612_PlanBy_Line_Pack.cs:387 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7d787d6b | this.Load | FP00612_PlanBy_Line_Pack.cs:388 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a35c73be | this.Load | FP00612_PlanBy_Line_Pack.cs:389 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6aaa4b88 | this.Load | FP00612_PlanBy_Line_Pack.cs:390 |  | UI_PROP | clbProdType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.InitSpread

진입점: this.Load / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca5a5947 | this.Load 외 3 | FP00612_PlanBy_Line_Pack.cs:435 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a718be0c | this.Load 외 3 | FP00612_PlanBy_Line_Pack.cs:436 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-27fa3624 | this.Load 외 3 | FP00612_PlanBy_Line_Pack.cs:440 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00612_PlanBy_Line_Pack.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a22400ea | InsertButton | FP00612_PlanBy_Line_Pack.cs:1426 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00612_PlanBy_Line_Pack.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b71c8fc3 | memo_menu.Click | FP00612_PlanBy_Line_Pack.cs:2091 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-335841f1 | memo_menu.Click | FP00612_PlanBy_Line_Pack.cs:2094 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c93887ca | memo_menu.Click | FP00612_PlanBy_Line_Pack.cs:2098 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00612_PlanBy_Line_Pack.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-626c2744 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2158 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-5ebf17d0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2159 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-617f1c3c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2160 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-79ce9df4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2160 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-84a1212a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2161 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-d35e27d8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2162 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-80264593 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2163 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c2393e69 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2168 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec1e6c3c | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2171 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a485180 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2177 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-824b6b32 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2178 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-85db7da2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2179 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-a49b73b6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2179 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3ca97748 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2180 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-9263f0b0 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2181 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-899dded8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2182 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d499c133 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2186 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-84e0df02 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00612_PlanBy_Line_Pack.cs:2188 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00612_PlanBy_Line_Pack.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (m…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54bfe04d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:486 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-74d5a936 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:486 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d005fb25 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:487 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-ca8b146e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:487 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f76fc60 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:488 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d87879f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:488 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6349ce14 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:491 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f66ef010 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:498 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-8d4cd2bc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:503 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b21c5440 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:504 |  | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-502e886b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 6 | FP00612_PlanBy_Line_Pack.cs:506 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00612_PlanBy_Line_Pack.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.btn_bucket.Click [if (frm.DialogR…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5b79855 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:513 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-37e3aca3 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:514 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-34a80754 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:515 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-bc25e158 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:516 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-a9d73302 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:532 | if (monthInfo != null) ▸ if (!on_redraw) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "_QTY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4499df33 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:535 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-35038e28 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:539 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fb304248 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:540 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71ca8ecc | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:542 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c77a25da | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:543 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1467f848 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:545 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count | 그리드 속성/값 설정 |  |  |  |
| AC-4df11c95 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:552 | if (monthInfo != null) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-26c1bad8 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:553 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf1ab555 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:558 | if (monthInfo != null) | UI_PROP | mct.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-93557da8 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:579 | if (monthInfo != null) ▸ else of (bUseNote == false) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-99a838ff | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:582 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ if (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,###.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82ba615e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:586 | if (monthInfo != null) ▸ else of (bUseNote == false) ▸ else of (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,##0.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94bb8454 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:591 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ee6ca36 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:592 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bc8bbe0 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:628 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-0aa123be | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:647 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-154943b1 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:651 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-4385997c | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:653 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9a714a7 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:657 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c2ad4e8c | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:672 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-76297ed8 | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:687 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-16f8f24e | this.Load [try ▸ else of (monthInfo == null)] 외 6 | FP00612_PlanBy_Line_Pack.cs:697 |  | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.RefreshHeaderOnly

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null)] / this.btn_column.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c84f407 | this.Load [try] 외 4 | FP00612_PlanBy_Line_Pack.cs:704 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-81eb3bef | this.Load [try] 외 4 | FP00612_PlanBy_Line_Pack.cs:705 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-7c96a992 | this.Load [try] 외 4 | FP00612_PlanBy_Line_Pack.cs:706 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-036a4f73 | this.Load [try] 외 4 | FP00612_PlanBy_Line_Pack.cs:707 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9dd80861 | this.Load [try] 외 4 | FP00612_PlanBy_Line_Pack.cs:708 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00612_PlanBy_Line_Pack.RefreshSpreadSheet

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null)] / this.btn…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc95451b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1786 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-30d42ce3 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1790 |  | FLAG | bHideZero | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0b738963 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1791 |  | FLAG | bUseNote | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fc340326 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1793 | if (!dsMain.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5169025 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1799 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-d923ca35 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1803 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-497301b2 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 5 | FP00612_PlanBy_Line_Pack.cs:1805 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00612_PlanBy_Line_Pack.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47cf72b9 | popSql.OnSql | FP00612_PlanBy_Line_Pack.cs:1971 | if (programID == "PR_UI_FP00612_PLAN_BY_LINE_PACK") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-f8dc0061 | popSql.OnSql | FP00612_PlanBy_Line_Pack.cs:1973 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.SaveSimplexcel

진입점: ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6415b17e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1078 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("W0") | 데이터 객체 조작/조회 |  |  |  |
| AC-25e32a9b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1083 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("D0") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e9d4336 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1099 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | spSheet.ColumnHeader.Columns[j].Width / 9 | 행/컬럼 값 대입 |  |  |  |
| AC-1c4b84b0 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1101 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-1cbd0fd8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1106 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Bottom | 그리드 속성/값 설정 |  |  |  |
| AC-ff3044c2 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1109 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-4a104dc8 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1112 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-f3d41754 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1115 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-2b3bf101 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1118 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-8bac3160 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1121 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-fc9e41ca | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1124 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-27f1f6ad | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1131 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-6a6d8efc | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1134 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Center | 그리드 속성/값 설정 |  |  |  |
| AC-a9919b24 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1137 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.None | 그리드 속성/값 설정 |  |  |  |
| AC-226a2b15 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1140 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.General | 그리드 속성/값 설정 |  |  |  |
| AC-4c1f66f5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1143 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-27129521 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1146 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-c983a4e5 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1150 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].ColSpan | cell.ColumnSpan | 그리드 속성/값 설정 |  |  |  |
| AC-9bbc0de3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1151 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].RowSpan | cell.RowSpan | 그리드 속성/값 설정 |  |  |  |
| AC-884492ae | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1152 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-a5b78ad9 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1154 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-673ca32e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1160 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[i, j].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-748a7916 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1160 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-86c01adb | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1166 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-c812aeb3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1169 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (cell.Font != null) | GRID_SET | xSheet.Cells[i, j].FontSize | (int)cell.Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-2a6ebcf3 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1172 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ else of (cell.Font != n… | GRID_SET | xSheet.Cells[i, j].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-d45bbb6e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1194 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-17aa153d | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1195 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-34787118 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1203 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c43a8481 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1204 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-1343989e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1209 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-23806d93 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1210 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-5e43227e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1216 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-d67d24ef | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1222 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5662f8ac | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1232 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-248ba3e1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1233 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-07e55418 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1239 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b565a5f1 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1240 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-71ad471e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1245 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-cedcafac | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1249 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5aad41e4 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1256 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-b4e3de5e | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1256 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2946e183 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1260 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.FromArgb(bg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-71935135 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1260 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | CALL_EXT | bg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-82d70da7 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1264 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-8bc65511 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1269 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].FontSize | (int)spSheet.Cells[i, j].Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-87b20593 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1271 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Bold | true | 그리드 속성/값 설정 |  |  |  |
| AC-07205747 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1273 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Italic | true | 그리드 속성/값 설정 |  |  |  |
| AC-c9c0c83c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1276 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (spSheet.Cells[i, j].Font !… | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-afbdb100 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1278 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-f05b8333 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1283 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | GRID_INIT | xSheet.FreezeTopLeft | (spSheet.ColumnHeader.RowCount, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ff1901b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1284 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b32197b | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1298 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-700eba41 | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1299 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-baa26e4c | ExcelButton [if (select_popup.ShowDialog() == DialogResult.O… | FP00612_PlanBy_Line_Pack.cs:1301 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00612_PlanBy_Line_Pack.SetChangeControl

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / clbProdType.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_inActive.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-999120b5 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:312 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-04718bba | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:312 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c5bf2a4a | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:321 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-126123c8 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:322 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-82621d34 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:322 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0b6f524c | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:323 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff441707 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:329 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f3c00187 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:330 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-619798fd | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:330 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0db1ecd0 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:331 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b70d1cd3 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:337 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7d20b81c | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:338 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-d84e39b3 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:338 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-65826ef2 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:339 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f1cdbb00 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:345 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-96a01bf4 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:346 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-a91e2ffb | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:346 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-548e8e03 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:347 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d042c1fb | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:354 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ce97a089 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:355 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-79ee035c | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:355 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5987eb8a | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:356 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-610265a6 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:362 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-643628b9 | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:363 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1cf6fcea | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:363 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-03305bfc | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:364 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c865eab | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:370 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-0a99c7ba | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:374 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, clbProdType.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3b68712b | this.Load 외 12 | FP00612_PlanBy_Line_Pack.cs:374 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, clbProdType.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42092461 | this.Load | FP00612_PlanBy_Line_Pack.cs:147 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53699874 | this.Load | FP00612_PlanBy_Line_Pack.cs:149 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-d328d93e | this.Load | FP00612_PlanBy_Line_Pack.cs:150 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-fb9e70ed | this.Load | FP00612_PlanBy_Line_Pack.cs:154 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e4367391 | this.Load | FP00612_PlanBy_Line_Pack.cs:155 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-19bf71a9 | this.Load | FP00612_PlanBy_Line_Pack.cs:157 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.SetDirty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdbb711e | (진입점 미연결) | FP00612_PlanBy_Line_Pack.cs:2347 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.SetFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbOperation.Selec…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95486176 | this.Load 외 20 | FP00612_PlanBy_Line_Pack.cs:1834 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.SetSpreadInit

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1272e5aa | this.Load [try] 외 3 | FP00612_PlanBy_Line_Pack.cs:448 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49e02314 | this.Load [try] 외 3 | FP00612_PlanBy_Line_Pack.cs:449 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec24a022 | this.spdMain.ButtonClicked | FP00612_PlanBy_Line_Pack.cs:2774 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d2f63ec | this.spdMain.CellClick | FP00612_PlanBy_Line_Pack.cs:2378 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-588f2155 | this.spdMain.CellClick | FP00612_PlanBy_Line_Pack.cs:2379 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-c35fdd03 | this.spdMain.CellClick | FP00612_PlanBy_Line_Pack.cs:2381 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4b8e850 | this.spdMain.CellClick | FP00612_PlanBy_Line_Pack.cs:2390 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07cf4d4b | this.spdMain.CellDoubleClick | FP00612_PlanBy_Line_Pack.cs:2333 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-287efc9a | this.spdMain.CellDoubleClick | FP00612_PlanBy_Line_Pack.cs:2340 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89bf8f21 | this.spdMain.ChildControlDeactivated | FP00612_PlanBy_Line_Pack.cs:2731 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56847f0b | this.spdMain.DragFillBlockCompleted | FP00612_PlanBy_Line_Pack.cs:2741 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c387a48 | this.spdMain.EditChange | FP00612_PlanBy_Line_Pack.cs:2145 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2fc1ae4 | this.spdMain.EditModeOff | FP00612_PlanBy_Line_Pack.cs:2759 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ead6d8f | this.spdMain.EditModeOn | FP00612_PlanBy_Line_Pack.cs:2765 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-2d6ba801 | this.spdMain.EditModeOn | FP00612_PlanBy_Line_Pack.cs:2766 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e652ebc1 | this.spdMain.EditorFocused | FP00612_PlanBy_Line_Pack.cs:2753 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d23c2959 | this.spdMain.Enter | FP00612_PlanBy_Line_Pack.cs:2716 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12dcc0c0 | this.spdMain.Leave | FP00612_PlanBy_Line_Pack.cs:2711 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca6e2d1c | this.spdMain.SubEditorClosed | FP00612_PlanBy_Line_Pack.cs:2747 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-798f8dc5 | this.spdMain.SubEditorOpening | FP00612_PlanBy_Line_Pack.cs:2736 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e09a18d2 | this.spdMain.TableChanged | FP00612_PlanBy_Line_Pack.cs:2133 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-135c5d72 | this.spdMain.TableChanged | FP00612_PlanBy_Line_Pack.cs:2135 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c68e2aa5 | this.spdMain.TextChanged | FP00612_PlanBy_Line_Pack.cs:2116 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-94e6782a | this.spdMain.TextChanged | FP00612_PlanBy_Line_Pack.cs:2118 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-279cfa33 | this.spdMain.Validated | FP00612_PlanBy_Line_Pack.cs:2721 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1806bfc3 | this.spdMain.Validating | FP00612_PlanBy_Line_Pack.cs:2726 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0045fd02 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2198 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30f7fb93 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2215 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-944251d9 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2246 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-6a8ca993 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2247 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-9743b7d0 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2249 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b21bf033 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2280 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-38409289 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2281 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-793ae1fb | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00612_PlanBy_Line_Pack.cs:2283 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00612_PlanBy_Line_Pack.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d820658 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2567 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d524c0f3 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2572 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-ece205ab | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2573 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-a412adb8 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2574 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-28996798 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2575 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9878d32 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2576 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-f49d0ebe | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2577 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bede6c4 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2582 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-03fc6d36 | tbNickName.BeforeOpenSearch | FP00612_PlanBy_Line_Pack.cs:2583 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00612_PlanBy_Line_Pack.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5518d980 | tbNickName.OnSearchConditionChanged | FP00612_PlanBy_Line_Pack.cs:2592 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f0db5121 | tbNickName.OnSearchConditionChanged | FP00612_PlanBy_Line_Pack.cs:2593 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1ba821a8 | tbNickName.OnSearchConditionChanged | FP00612_PlanBy_Line_Pack.cs:2599 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-2afa01cd | tbNickName.OnSearchConditionChanged | FP00612_PlanBy_Line_Pack.cs:2602 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3656c1c6 | tbNickName.OnSearchConditionChanged | FP00612_PlanBy_Line_Pack.cs:2604 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00612_PlanBy_Line_Pack.UIFindData

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e8bdb34 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1314 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13c8904c | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1315 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bf0363c3 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1318 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-df1251df | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1321 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a78eb4ef | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1329 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-600940aa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1339 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-708c2960 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1340 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18b09037 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1343 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cef65a89 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1347 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-bfaeb29e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1348 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5a911d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1361 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-bee9e07a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1363 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-86ba69dd | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1363 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b8ffe62 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1370 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e1bb5fa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1376 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4673a665 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1386 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | SetSearchCount | (dsMain) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c4d932b6 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1391 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62a4e8af | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1397 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b200b557 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1399 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5e54e154 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1405 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-fc3a1264 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1412 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f7e04fa8 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00612_PlanBy_Line_Pack.cs:1416 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

