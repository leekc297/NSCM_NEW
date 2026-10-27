# AS-IS 액션 대조표 — FP00611

> 원천: `Doc/asisfacts/screens/FP00611/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 740행 · 메서드 88 · 종류 DATA_OP 197 · UI_PROP 99 · FLAG 75 · GRID_SET 63 · CALL_EXT 57 · VALUE_SET 53 · UI_MISC 32 · RETURN 29 · POPUP 29 · GRID_INIT 22 · MESSAGE 13 · ENDPOINT 13 · COMBO_DATA 12 · STATE 10 · THROW 10 · LIST_REBIND 8 · GRID_STYLE 7 · CALL_BASE 5 · GRID_LOCK 2 · GRID_BIND 2 · LIST_CLEAR 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 62


## FP00611_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba60d82 | .ctor | FP00611_MeasureSetForm_Popup.cs:76 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7b8b67d2 | .ctor | FP00611_MeasureSetForm_Popup.cs:77 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-dc43ce7d | .ctor | FP00611_MeasureSetForm_Popup.cs:78 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2781883f | .ctor | FP00611_MeasureSetForm_Popup.cs:80 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00611_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52c619b2 | Dispose | FP00611_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00611_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff3027c4 | this.Load | FP00611_MeasureSetForm_Popup.cs:104 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00611_MeasureSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e1b6e86 | this.Load | FP00611_MeasureSetForm_Popup.cs:202 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-44a39d1c | this.Load | FP00611_MeasureSetForm_Popup.cs:203 |  | FLAG | measure_val | new bool[measure_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-7a651448 | this.Load | FP00611_MeasureSetForm_Popup.cs:204 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f65ca51 | this.Load | FP00611_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e75228a6 | this.Load | FP00611_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-18a06e6f | this.Load | FP00611_MeasureSetForm_Popup.cs:233 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e4ae1c2 | this.Load | FP00611_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-63238c30 | this.Load | FP00611_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8a1dee9 | this.Load | FP00611_MeasureSetForm_Popup.cs:237 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-c79975ba | this.Load | FP00611_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2893f0d | this.Load | FP00611_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c74b0fb | this.Load | FP00611_MeasureSetForm_Popup.cs:241 |  | DATA_OP | ctrls.Add | (chk_cut) | 데이터 객체 조작/조회 |  |  |  |
| AC-36798a1f | this.Load | FP00611_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-3557a4c4 | this.Load | FP00611_MeasureSetForm_Popup.cs:244 |  | DATA_OP | ctrls.Add | (chk_resultExp) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8738c41 | this.Load | FP00611_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-69670c91 | this.Load | FP00611_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_gapWPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-b21d6afd | this.Load | FP00611_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-9166160e | this.Load | FP00611_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-1eaf2d73 | this.Load | FP00611_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-990efefb | this.Load | FP00611_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e02ebb1 | this.Load | FP00611_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-936d08ee | this.Load | FP00611_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1a1089d | this.Load | FP00611_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8370a58 | this.Load | FP00611_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-ada3de9f | this.Load | FP00611_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_cut_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-567d3b8f | this.Load | FP00611_MeasureSetForm_Popup.cs:264 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-839b66cf | this.Load | FP00611_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_resultExp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-94cd12ad | this.Load | FP00611_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-157cc6f6 | this.Load | FP00611_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_gapWPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-afe5709a | this.Load | FP00611_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_memo_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6cf2105 | this.Load | FP00611_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce9b949f | this.Load | FP00611_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1fac8d9 | this.Load | FP00611_MeasureSetForm_Popup.cs:276 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba5bce1d | this.Load | FP00611_MeasureSetForm_Popup.cs:276 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-8a134e06 | this.Load | FP00611_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-d20917ba | this.Load | FP00611_MeasureSetForm_Popup.cs:287 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |

## FP00611_MeasureSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59871360 | this.Load | FP00611_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d521b6c0 | this.Load | FP00611_MeasureSetForm_Popup.cs:141 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4171c302 | this.Load | FP00611_MeasureSetForm_Popup.cs:142 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b14d3afe | this.Load | FP00611_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-701e69e5 | this.Load | FP00611_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8b8583a3 | this.Load | FP00611_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-89bac290 | this.Load | FP00611_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3b4d1559 | this.Load | FP00611_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b07c2106 | this.Load | FP00611_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_cut.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-92bc1866 | this.Load | FP00611_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-47f0e0d0 | this.Load | FP00611_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_resultExp.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d875c753 | this.Load | FP00611_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-03d0de54 | this.Load | FP00611_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_gapWPP.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4611d49c | this.Load | FP00611_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_uom.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ebba4e61 | this.Load | FP00611_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_cell.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8c15b736 | this.Load | FP00611_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-db69726e | this.Load | FP00611_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c157fe69 | this.Load | FP00611_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-69782550 | this.Load | FP00611_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-18288f14 | this.Load | FP00611_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4a85da31 | this.Load | FP00611_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9394e310 | this.Load | FP00611_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_cut_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-63cb45f8 | this.Load | FP00611_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d1c980ed | this.Load | FP00611_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_resultExp_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8b3bd1d4 | this.Load | FP00611_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1a726ec0 | this.Load | FP00611_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_gapWPP_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2725cfd7 | this.Load | FP00611_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_memo_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3e867aaa | this.Load | FP00611_MeasureSetForm_Popup.cs:182 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b51910cd | this.Load | FP00611_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00611_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c4ed804 | this.Load | FP00611_MeasureSetForm_Popup.cs:91 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-86e35efe | this.Load | FP00611_MeasureSetForm_Popup.cs:99 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00611_MeasureSetForm_Popup.setMeasualFormData

진입점: this.usrButton1.Click / this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caed4c7c | this.usrButton1.Click 외 1 | FP00611_MeasureSetForm_Popup.cs:335 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f9245d15 | this.usrButton1.Click 외 1 | FP00611_MeasureSetForm_Popup.cs:343 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-31c1744e | this.usrButton1.Click 외 1 | FP00611_MeasureSetForm_Popup.cs:343 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-dbc5d65e | this.usrButton1.Click 외 1 | FP00611_MeasureSetForm_Popup.cs:360 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-af5379e0 | this.usrButton1.Click 외 1 | FP00611_MeasureSetForm_Popup.cs:371 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00611_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b93961f1 | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:320 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-2327b325 | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:321 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3e0c3b79 | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:323 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-dcad289d | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:324 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-592104ea | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:326 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-b4ae47ce | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:328 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e7a0e426 | this.usrButton1.Click | FP00611_MeasureSetForm_Popup.cs:329 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00611_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e3194fd | this.usrButton2.Click | FP00611_MeasureSetForm_Popup.cs:304 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-004ac658 | this.usrButton2.Click | FP00611_MeasureSetForm_Popup.cs:305 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ab8eb08c | this.usrButton2.Click | FP00611_MeasureSetForm_Popup.cs:307 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-dd0918f6 | this.usrButton2.Click | FP00611_MeasureSetForm_Popup.cs:308 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00611_PlanBy_Line_Assy..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-664233ca | .ctor | FP00611_PlanBy_Line_Assy.cs:147 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ lambda ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-141b9b61 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2520 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2b1b993c | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2521 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-89e2363b | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2522 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a6c71fc6 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2523 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7ca0a011 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2524 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9ab608b7 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2527 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-16918ed8 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2527 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3db82872 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2528 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-f6e7fe9f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2528 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2015dc9c | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2529 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 화면 필드/플래그 변경 |  |  |  |
| AC-dc954055 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2529 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b850bb11 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2530 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 화면 필드/플래그 변경 |  |  |  |
| AC-56110b27 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2530 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-043d8c38 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2531 |  | FLAG | day2_week_month | Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-7aa3f80b | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2531 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "DAY2_WEEK_MONTH") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fa45b996 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2540 |  | CALL_EXT | DataService.ToLoopParam2 | ("", day2_week_month) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9fc1af5a | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2545 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-3b9630b5 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2546 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-727d73c7 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2547 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-85baad30 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2548 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |
| AC-0f0966b9 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2549 |  | DATA_OP | Filter["DAY2_WEEK_MONTH"] | sDay2_week_month | 행/컬럼 값 대입 |  |  |  |
| AC-8e4de986 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2550 |  | DATA_OP | Filter["CURR_DATE_COL"] | DataService.ToLoopParam2("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper()… | 행/컬럼 값 대입 |  |  |  |
| AC-35d1c8f5 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2550 |  | CALL_EXT | DataService.ToLoopParam2 | ("", Data_FP.CallGeneralProcedure2(("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d07010e0 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2550 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CURR_DATE_COL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00611_PlanBy_Line_Assy.ApplyReleaseColor

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42c34688 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1696 | if (!dtRelease.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ec4db7b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1697 |  | DATA_OP | dsDataPart.Tables[0].Columns.Contains | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-82c26004 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1698 | if (!dsDataPart.Tables[0].Columns.Contains("DATA_TYPE")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b17c5fc | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1700 | if (calendar == null \|\| calendar.Days == null \|\| calendar.Days.Count <=0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07887ee3 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1707 | foreach (DataRow drRelease in dtRelease.Rows) | CALL_EXT | DateTime.TryParseExact | (date_string, "yyyyMMdd", enUS, System.Globalization.DateTimeStyles.None, out dt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-36640183 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1710 | foreach (DataRow drRelease in dtRelease.Rows) ▸ if (DateTime.TryParseExact(date_string, "yyyyMMdd", enUS, System.Globalization.DateTimeStyle… | DATA_OP | dictRelease.Keys.Contains | (factory) | 데이터 객체 조작/조회 |  |  |  |
| AC-facb924f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1713 | foreach (DataRow drRelease in dtRelease.Rows) ▸ if (DateTime.TryParseExact(date_string, "yyyyMMdd", enUS, System.Globalization.DateTimeStyle… | DATA_OP | dts.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ecc626c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1714 | foreach (DataRow drRelease in dtRelease.Rows) ▸ if (DateTime.TryParseExact(date_string, "yyyyMMdd", enUS, System.Globalization.DateTimeStyle… | DATA_OP | dictRelease.Add | (factory,dts) | 데이터 객체 조작/조회 |  |  |  |
| AC-48bb8e7f | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1719 | foreach (DataRow drRelease in dtRelease.Rows) ▸ if (DateTime.TryParseExact(date_string, "yyyyMMdd", enUS, System.Globalization.DateTimeStyle… | DATA_OP | dts.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb029925 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1734 | if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-c12dbbe4 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1735 | if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-2ea3850d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1740 |  | CALL_EXT | FPExtensions.ColorFromName | ("YYYYYY") | ⚠ 의미 확인 필요 |  |  |  |
| AC-e01e7b2c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1758 | foreach (AmendDate day in calendar.Days.Values) ▸ if (colindex > -1) ▸ for (rowindex < current_src.Rows.Count) ▸ if (row["DATA_TYPE"].SafeSt… | DATA_OP | dictRelease.Keys.Contains | (factory_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-49b9d3e7 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1761 | foreach (AmendDate day in calendar.Days.Values) ▸ if (colindex > -1) ▸ for (rowindex < current_src.Rows.Count) ▸ if (row["DATA_TYPE"].SafeSt… | DATA_OP | reldates.Contains | (day.Date) | 데이터 객체 조작/조회 |  |  |  |
| AC-e842defa | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:1763 | foreach (AmendDate day in calendar.Days.Values) ▸ if (colindex > -1) ▸ for (rowindex < current_src.Rows.Count) ▸ if (row["DATA_TYPE"].SafeSt… | DATA_OP | row[day.Value + colorSuffix] | "#FFFFE6" | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ lambda ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ lambda ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27fb3377 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2556 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-984a3f68 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2562 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["BUCKET_FROM"] = drpPeriod.Value1.ToString("yyyyMM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c456120f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2564 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2b41e3b8 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2565 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-60f34a65 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2581 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3066d339 | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3357 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-1a613614 | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3360 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00611", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-d5adbdbe | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3361 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-955fae12 | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3362 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-a669aaeb | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3363 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e5c56869 | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3367 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-1472b984 | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3379 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5dd8624e | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3388 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good(… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d46dd72e | this.btn_bucket.Click | FP00611_PlanBy_Line_Assy.cs:3392 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cd2de2f | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3182 |  | POPUP | new FP00611_MeasureSetForm_Popup | ("FP00611", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-2127aff4 | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3183 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-db6810f4 | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3184 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5cc7411d | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3185 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b1be6c37 | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3189 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-d4d3146d | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3201 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f017037e | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3210 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cb4102fd | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3215 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8ba83145 | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3221 | else of (frm.DialogResult == DialogResult.OK) ▸ if (frm.DialogResult == DialogResult.Yes) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-206963ef | this.btn_category.Click | FP00611_PlanBy_Line_Assy.cs:3224 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00326c90 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3158 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00611", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-a795f750 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3159 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4c65e696 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3160 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-83987e03 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3167 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx("FP00611", UserInfoContext.Current.UserId, SpdSheet.shtPlanAmen… | 속성 ServerColumns 설정 |  |  |  |
| AC-4081a325 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3167 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | ("FP00611", UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20951d9f | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3168 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-1b2981e6 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3174 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e94b7853 | this.btn_column.Click | FP00611_PlanBy_Line_Assy.cs:3176 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0cf577e | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3498 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-2ff70a9c | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3499 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-75ba2187 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3502 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-04a876a2 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3503 |  | UI_PROP | memoPopup.CanSave | false | 속성 CanSave 설정 |  |  |  |
| AC-451f908f | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3504 |  | UI_PROP | memoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-5b5126b8 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3504 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76367161 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3505 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8734aca3 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3512 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f09de75 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3514 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b3ddefea | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3516 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9b934417 | this.btnMemo.Click | FP00611_PlanBy_Line_Assy.cs:3517 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dda7712f | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3474 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-c098623d | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3475 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f07d3bca | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3478 |  | POPUP | new FPC0106_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e4f61339 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3479 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-f99e1b51 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3479 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-37538e02 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3480 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4857723e | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3480 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-96940e94 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3481 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-b4f03ff7 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3482 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-71b71247 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3484 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-23cf1994 | this.btnPlanInfo.Click | FP00611_PlanBy_Line_Assy.cs:3485 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnSimpleXcel_Click

진입점: this.btnSimpleXcel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ad3bbdf | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:897 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-cfe0baa7 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:898 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-441fee16 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:900 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9bd41665 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:904 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-78986176 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:905 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-52162366 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:906 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-f7b93a0a | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:909 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-4db34a7e | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:910 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-7b19c7d0 | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:911 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-7f22f97c | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:913 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-ec0a369f | this.btnSimpleXcel.Click | FP00611_PlanBy_Line_Assy.cs:914 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e6f9f9a | this.btnSql.Click | FP00611_PlanBy_Line_Assy.cs:1593 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-dcdb2bec | this.btnSql.Click | FP00611_PlanBy_Line_Assy.cs:1594 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a1990494 | this.btnSql.Click | FP00611_PlanBy_Line_Assy.cs:1596 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00611_PLAN_BY_LINE_ASSY") | 데이터 객체 조작/조회 |  |  |  |
| AC-d747702c | this.btnSql.Click | FP00611_PlanBy_Line_Assy.cs:1597 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00611_PlanBy_Line_Assy.btnToggleSave_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee8e3a03 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:3398 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.CheckAndGetMeasure

진입점: this.Load / chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (do_edit_mode)] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (do_edit_mode)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (do_edit_mode)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-917afb1f | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:427 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-44ba37cc | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:427 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-0410b655 | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:430 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-7844a45c | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:431 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-19bda903 | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:432 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7c0593d | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:433 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-53d84c0e | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:434 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc2cc48a | this.Load 외 9 | FP00611_PlanBy_Line_Assy.cs:435 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.chk_hide_zero_CheckedChanged

진입점: chk_hide_zero.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-331f0eb8 | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2985 | try | STATE | chk_hide_zero.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-055a2a6f | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2986 | try | STATE | chk_use_memo.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d4a96565 | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2987 | try | FLAG | on_redraw | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ba6877d6 | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2992 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-a8b7a5e1 | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2996 | finally | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-69a29485 | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2997 | finally | STATE | chk_hide_zero.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e3eeecee | chk_hide_zero.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2998 | finally | STATE | chk_use_memo.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00611_PlanBy_Line_Assy.chk_use_memo_CheckedChanged

진입점: chk_use_memo.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-933f6590 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2963 | try | STATE | chk_hide_zero.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2bb30753 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2964 | try | STATE | chk_use_memo.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1a42ccf7 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2965 | try | FLAG | on_redraw | true | 화면 필드/플래그 변경 |  |  |  |
| AC-60f899c9 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2970 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |
| AC-a0ffce13 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2974 | finally | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-8577e3e2 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2975 | finally | STATE | chk_hide_zero.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b66040f6 | chk_use_memo.CheckedChanged | FP00611_PlanBy_Line_Assy.cs:2976 | finally | STATE | chk_use_memo.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00611_PlanBy_Line_Assy.CreateFilterDataSet

진입점: chk_hide_zero.CheckedChanged [try] / chk_use_memo.CheckedChanged [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98a2916 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1780 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-a7ad101f | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1791 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-0edbe14b | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1792 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-9f715391 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1827 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6911f87 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1831 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bf06922 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1835 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6f40c36 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1839 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-018954fd | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1843 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ee195ad | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1847 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43652212 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1851 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-72e7e55d | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1855 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a99b5ad | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1859 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f56d2ba | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1867 | if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43b22b32 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1876 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0a39ade | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1880 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc57f47b | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1884 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-804bd677 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1888 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cef02e5e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1892 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e80c9b8f | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1896 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-60ad0f17 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1900 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2c46af5 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1904 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_resultExp"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-20e26b94 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1908 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1534011b | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1916 | if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gapWPP"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "DATA", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3903feb2 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1922 | if (measure["chk_memo"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fdd8b7b | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1927 | if (measure["chk_offtime"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "OFFTIME")) | 데이터 객체 조작/조회 |  |  |  |
| AC-33bd821e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1932 | if (measure["chk_cut"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-60b5b06c | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1943 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8ff1df8 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1945 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-95b1304c | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1947 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5ec4c89e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1949 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2de51c7 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1951 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac5714c5 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1953 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc7e6c30 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1955 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-799b02d1 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1957 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-dffe3785 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1959 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5316608 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1961 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e258004 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1963 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-45fe69fa | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1969 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf674b39 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1971 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a1f919e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1973 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba9a0bdd | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1975 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e2c287b | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1977 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-695fa14f | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1979 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4207e54c | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1981 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d19aa8dd | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1983 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd21f91e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1985 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c91781e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1987 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c00fdf33 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1989 | if (measure["chk_total"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL_2", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e830a581 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:1997 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_memo_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("", "TOTAL", MEMO_COLUMN)) | 데이터 객체 조작/조회 |  |  |  |
| AC-933551e6 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2004 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-407af456 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2006 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6720996 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2008 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-57e1e270 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2010 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b52b19de | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2012 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-db878dc5 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2014 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-c641e96e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2016 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cd0d9e9 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2018 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-490a30ec | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2020 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-834ca435 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2022 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e3dec1d | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2024 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_uom"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-657f64f6 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2030 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-04c8d2bb | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2032 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_wpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "W_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeb8f95d | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2034 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fa46ad8 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2036 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_mpp_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "M_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-58065012 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2038 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_inqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-07e8079a | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2040 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_outqty_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "P_OUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1fc2824 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2042 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_result_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-76afcd28 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2044 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_resultExp_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "RESULT_EXP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-617cde86 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2046 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gapWPP_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "GAP_WPP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-67050461 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2048 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_gap_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "GAP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-206fa070 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2050 | if (measure["chk_subTotal"].Value == "true") ▸ if (measure["chk_cell"].Value == "true") ▸ if (measure["chk_cut_tot"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>(cell_or_uom, "TOTAL", "CUT")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ce16f8f | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2054 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | (MainGo, chks_measure_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3da0e97f | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2055 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-023a2f62 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2059 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d9c472e | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2063 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-39f4a378 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2066 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e5f203c | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2068 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fa339e8 | this.Load | FP00611_PlanBy_Line_Assy.cs:387 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-81375207 | this.Load | FP00611_PlanBy_Line_Assy.cs:388 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-2777c086 | this.Load | FP00611_PlanBy_Line_Assy.cs:389 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00611_PlanBy_Line_Assy.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-505c6fa0 | DeleteButton | FP00611_PlanBy_Line_Assy.cs:1576 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00611_PlanBy_Line_Assy.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3288c45b | Dispose | FP00611_PlanBy_Line_Assy.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00611_PlanBy_Line_Assy.DrawHeader

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf2fe878 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3230 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-5d171c5a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3234 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-8d3b383b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3235 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36bf3d1e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3236 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3bfa1b43 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3237 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-414264aa | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3238 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-cae5c5e6 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3242 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa8a114 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3243 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e9b47387 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3244 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-0d708ed9 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3245 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-69f701f0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3251 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-4daf6b46 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3252 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1867ad2 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3285 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, "FP00611_Main", DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fbab661f | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3290 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | DayColumnCount | siMain.SetAmendHeaderColumn_FP(calendar, use_month, use_week, use_day, 2, FPExtensions.Dat… | 화면 필드/플래그 변경 |  |  |  |
| AC-79b88db8 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3290 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExtens… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d2f683f | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3293 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-008ad957 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3294 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f09d025 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3295 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-5747d302 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3297 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-1bad7d4b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3299 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-fb372a7e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3300 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ada8a7b2 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 1 | FP00611_PlanBy_Line_Assy.cs:3305 | if (last_col < 0) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af535b2e | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3027 | if (sender == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b2fd3d60 | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3034 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ba2b070 | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3042 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aaae17fd | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3059 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-67425245 | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3060 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ if (dtPeriod_Plan.Rows.Count > 0) ▸ if (string.IsNul… | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |
| AC-726302e1 | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3084 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | MESSAGE | MessageBox.Show | ("It cannot be exceeded 100 days") | 메시지 표시 |  |  |  |
| AC-e5c3c863 | drpPeriod.ValueChanged | FP00611_PlanBy_Line_Assy.cs:3085 | if (getTypeName == "System.Windows.Forms.MaskedTextBox") ▸ if (dtPeriod_Plan != null) ▸ else of (dtPeriod_Plan.Rows.Count > 0) ▸ if (dayCoun… | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(100) | 속성 Value2 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e196bf6 | EditButton | FP00611_PlanBy_Line_Assy.cs:1584 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00611_PlanBy_Line_Assy.Excel_Export

진입점: this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == DialogResult.OK)] / ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95408294 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:869 | if (exportOption == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eccf75b1 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:873 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bad4d5ac | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:877 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-3e0f0342 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:881 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9744ce94 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:891 |  | FLAG | base.ExcelOption | ExcelExportOption.SeperatedRows | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30d75529 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:840 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-9d4fea87 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:841 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-011a0f85 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:843 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7701ccd8 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:847 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-51962981 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:848 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-1f86ea0b | ExcelButton | FP00611_PlanBy_Line_Assy.cs:849 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-ce791acf | ExcelButton | FP00611_PlanBy_Line_Assy.cs:852 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-433f5c5e | ExcelButton | FP00611_PlanBy_Line_Assy.cs:853 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-9628e564 | ExcelButton | FP00611_PlanBy_Line_Assy.cs:854 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-8366c09e | ExcelButton | FP00611_PlanBy_Line_Assy.cs:856 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2500b4ed | ExcelButton | FP00611_PlanBy_Line_Assy.cs:857 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.ExportExcelSimple

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3150ed1 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1031 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7505f03b | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1032 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-72d544b5 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1045 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b80b2f4b | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1049 | try ▸ if (myarray.Length == 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e3dec6c5 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1050 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8716000 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1054 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-646933fe | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1097 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0320b01 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1097 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d5d30b2e | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1108 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.ReferenceStyle | FarPoint.Win.Spread.Model.ReferenceStyle.A1 | 속성 ReferenceStyle 설정 |  |  |  |
| AC-d76e2060 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1122 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Columns[i].Visible == false) | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-85c5c902 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1126 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ if (RemoveActionCell == tr… | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-5760e9f9 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1130 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | DATA_OP | newSheet.Columns.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-614e94f1 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1142 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-3c60059d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1143 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-9c821509 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1152 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].CellType | new FarPoint.Win.Spread.CellType.TextCellType() | 그리드 속성/값 설정 |  |  |  |
| AC-04467c3d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1153 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Cells[idx.Index, i].Text | sText | 그리드 속성/값 설정 |  |  |  |
| AC-52d987f2 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1172 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ else of (newSheet.Columns[i].Visible == false) ▸ else of (RemoveActionCell … | GRID_SET | newSheet.Columns[i].Formula | "" | 그리드 속성/값 설정 |  |  |  |
| AC-6c4b159e | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1181 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) | CALL_EXT | f.IsRowFilteredOut | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f10c4f18 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1183 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (i >= 0) ▸ if (newSheet.Rows[i].Visible == false \|\| (f != null && f.IsRowFilteredOut… | DATA_OP | newSheet.Rows.Remove | (i, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-37e66e96 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1186 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | UI_PROP | newSheet.FrozenColumnCount | FrozenColumnCount | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-97c19d5c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1195 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (ignoreDepth > 0) ▸ for (i < newSheet.RowCount) ▸ for (j < collen) ▸ if (newSheet.Cells… | GRID_SET | newSheet.Cells[i, j].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-4340f8ed | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1206 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ if (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol].Dat… | UI_PROP | newSheet.FrozenColumnCount | iCol | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-f6dc7f83 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1215 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ for (iCol >= 0) ▸ else of (newSheet.Columns[iCol].Tag == null) ▸ if (newSheet.Columns[iCol… | UI_PROP | newSheet.FrozenColumnCount | iCol + 1 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-68fddef6 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1224 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | DATA_OP | sp.Sheets.Add | (newSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-a65cfb34 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1231 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | UI_PROP | si.MaxRightMerge | 50 | 속성 MaxRightMerge 설정 |  |  |  |
| AC-8028cabe | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1232 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.Casecaded: | CALL_EXT | si.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9eae73c0 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1237 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) ▸ if (si != null) ▸ switch (ExcelOption) case ExcelExportOption.SeperatedRows: case ExcelExp… | CALL_EXT | si.UnMerge | (newSheet) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7360554f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1244 | try | UI_PROP | siNew.Border | new FarPoint.Win.LineBorder(Color.Black, 0, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-b78e707d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1246 | try | UI_PROP | newSheet.DefaultStyle | siNew | 속성 DefaultStyle 설정 |  |  |  |
| AC-313397ae | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1250 | try | UI_PROP | siNewColHeader.Border | new FarPoint.Win.LineBorder(Color.Black, 1, true, true, true, true) | 속성 Border 설정 |  |  |  |
| AC-102f2f82 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1252 | try | GRID_SET | newSheet.ColumnHeader.DefaultStyle | siNewColHeader | 그리드 속성/값 설정 |  |  |  |
| AC-8d15b7d3 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1255 | try ▸ if (!bFrozenCheck) | UI_PROP | newSheet.FrozenColumnCount | 0 | 속성 FrozenColumnCount 설정 |  |  |  |
| AC-cd8a048e | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1257 | try | UI_PROP | sp.TabStripPolicy | TabStripPolicy.Always | 속성 TabStripPolicy 설정 |  |  |  |
| AC-e9a1f187 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1262 | try ▸ for (iSheetIndex < sp.Sheets.Count) | GRID_SET | sp.Sheets[iSheetIndex].Protect | false | 그리드 속성/값 설정 |  |  |  |
| AC-06b2e2c5 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1277 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb72de2c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1283 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.InnerException.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ed29339b | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1288 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00611_PlanBy_Line_Assy.ExportExcelSimple2

진입점: this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == DialogResult.OK)] / ExcelButton [if (select_popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39ded44a | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:928 | try ▸ if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77f6c271 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:929 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-46590ee4 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:945 | try | CALL_EXT | spSpread.Sheets.CopyTo | (myarray, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ee85289 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:949 | try ▸ if (myarray.Length == 0) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0ce710a1 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:950 | try ▸ if (myarray.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-676a922f | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:954 | try | CALL_EXT | sp.Sheets.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfcfd4a4 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1000 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.LoadObjectXml | (typeof(FarPoint.Win.Spread.SheetView), FarPoint.Win.Serializer.GetObjectXml(sv, "CopyShee… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8317fe1f | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1000 | try ▸ for (iSheetIndex < spSpread.Sheets.Count) | CALL_EXT | FarPoint.Win.Serializer.GetObjectXml | (sv, "CopySheet") | ⚠ 의미 확인 필요 |  |  |  |
| AC-93a760f8 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1006 | try | CALL_EXT | spSpread.SaveExcel | (sFileName, gesfDefaultExeclSaveFlg \| FarPoint.Excel.ExcelSaveFlags.UseOOXMLFormat) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f5f4a22 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1012 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a29f849 | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1018 | catch ((Exception e)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { e.InnerException.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c797f0da | this.btnSimpleXcel.Click [if (select_popup.ShowDialog() == D… 외 1 | FP00611_PlanBy_Line_Assy.cs:1023 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00611_PlanBy_Line_Assy.Find_Memo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e4b3d6f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2469 | try | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP00611_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "MEA_MEMO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-adc08736 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2470 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5360ac95 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2476 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00611_PlanBy_Line_Assy.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98f40b1 | FindButton | FP00611_PlanBy_Line_Assy.cs:1553 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-283d4ece | FindButton | FP00611_PlanBy_Line_Assy.cs:1554 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1865a62 | FindButton | FP00611_PlanBy_Line_Assy.cs:1558 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00611_PlanBy_Line_Assy.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY")] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ lambda] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ lambda] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-048389e4 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2499 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = null; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c2f56ce | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2501 | try ▸ lambda | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-fe5334ff | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2507 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00611_PLAN_BY_LINE_ASSY", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0e311095 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2509 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-47179e3f | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 3 | FP00611_PlanBy_Line_Assy.cs:2513 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00611_PlanBy_Line_Assy.FindTotalColorStart

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.T…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfafe500 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:821 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-975b8fdf | this.Load | FP00611_PlanBy_Line_Assy.cs:190 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00611_PlanBy_Line_Assy.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-705344d5 | this.Load | FP00611_PlanBy_Line_Assy.cs:251 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").To… | 화면 필드/플래그 변경 |  |  |  |
| AC-07cf784c | this.Load | FP00611_PlanBy_Line_Assy.cs:251 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00611_PlanBy_Line_Assy.GetFilter

진입점: popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY") ▸ try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-095adec3 | popSql.OnSql [if (programID == "PR_UI_FP00611_PLAN_BY_LINE_A… 외 4 | FP00611_PlanBy_Line_Assy.cs:2329 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.GetPlanGroup

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebbb26ec | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2337 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4cb844bc | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2338 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4381d7a9 | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2338 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1f080b33 | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2340 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-e85f8dfa | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2342 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dec5ae0a | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2345 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-1bdeaece | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2346 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-6b763eac | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2346 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-a626591e | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2347 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c97722d9 | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2348 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8acd867e | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2349 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0bed74cb | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2353 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00611_PlanBy_Line_Assy.GetPlanPeriod

진입점: this.Load [else of (!MessageService.Require(Filter, "INSTANCE_ID", "Plan Group(Assy)"))] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e59aa66f | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2360 |  | FLAG | dtPlanPeriod | Data_FP.Common_FP(Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab9ca0bb | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2360 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dcbd5230 | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2362 |  | UI_PROP | drpPeriod.Text1 | dtPlanPeriod.Rows[0]["START_DATE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-b2b89685 | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2363 |  | UI_PROP | drpPeriod.Text2 | dtPlanPeriod.Rows[0]["END_DATE"].ToString() | 속성 Text2 설정 |  |  |  |
| AC-663c58e1 | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2365 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-19b98592 | this.Load [else of (!MessageService.Require(Filter, "INSTANC… 외 1 | FP00611_PlanBy_Line_Assy.cs:2366 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.GetProdType

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fee0b6f1 | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2371 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e43ea69 | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2371 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41c11c3e | this.Load 외 1 | FP00611_PlanBy_Line_Assy.cs:2372 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, clbProdType, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00611_PlanBy_Line_Assy.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b70a313 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2385 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00611_PlanBy_Line_Assy.GoEditMode

진입점: chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good())] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good())] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == Dial…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed83503d | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2192 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-279fdf96 | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2194 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b287499d | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2228 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-bc43f819 | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2229 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-0033159f | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2251 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8be2d2d | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2252 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor2 | (rowindex, rowindex, rowindex, rowindex, color) | 그리드 표시 설정 |  |  |  |
| AC-199d10e8 | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2282 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ if (day_measure !… | CALL_EXT | FPExtensions.ColorFromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2e22c5f4 | chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good(… 외 8 | FP00611_PlanBy_Line_Assy.cs:2283 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ if (day_measure !… | GRID_STYLE | siMain.SetBGColor2 | (rowindexs, index, rowindexs, index, color) | 그리드 표시 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa5bd0a3 | this.Load | FP00611_PlanBy_Line_Assy.cs:205 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-964be1ea | this.Load | FP00611_PlanBy_Line_Assy.cs:209 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-da985e4e | this.Load | FP00611_PlanBy_Line_Assy.cs:210 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fc554742 | this.Load | FP00611_PlanBy_Line_Assy.cs:214 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-7aa5a457 | this.Load | FP00611_PlanBy_Line_Assy.cs:217 |  | VALUE_SET | chk_hide_zero.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-fe1ebea3 | this.Load | FP00611_PlanBy_Line_Assy.cs:218 |  | VALUE_SET | chk_use_memo.Checked | false | 컨트롤 값 설정 |  |  |  |
| AC-9b039f1a | this.Load | FP00611_PlanBy_Line_Assy.cs:221 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-83abaa18 | this.Load | FP00611_PlanBy_Line_Assy.cs:238 |  | CALL_EXT | MessageService.Require | (Filter, "INSTANCE_ID", "Plan Group(Assy)") | ⚠ 의미 확인 필요 |  |  |  |

## FP00611_PlanBy_Line_Assy.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8696e9f1 | this.Load | FP00611_PlanBy_Line_Assy.cs:345 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d34a0f28 | this.Load | FP00611_PlanBy_Line_Assy.cs:346 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-67236618 | this.Load | FP00611_PlanBy_Line_Assy.cs:347 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6a455981 | this.Load | FP00611_PlanBy_Line_Assy.cs:348 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-9821d5b2 | this.Load | FP00611_PlanBy_Line_Assy.cs:349 |  | UI_PROP | clbOperation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-3a51de0d | this.Load | FP00611_PlanBy_Line_Assy.cs:350 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7ff3dbc7 | this.Load | FP00611_PlanBy_Line_Assy.cs:351 |  | UI_PROP | clbProdType.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.InitSpread

진입점: this.Load / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25153d7b | this.Load 외 3 | FP00611_PlanBy_Line_Assy.cs:401 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-173fbf9a | this.Load 외 3 | FP00611_PlanBy_Line_Assy.cs:402 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b9f4d56 | this.Load 외 3 | FP00611_PlanBy_Line_Assy.cs:406 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00611_PlanBy_Line_Assy.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61733d83 | InsertButton | FP00611_PlanBy_Line_Assy.cs:1568 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00611_PlanBy_Line_Assy.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c01fec66 | memo_menu.Click | FP00611_PlanBy_Line_Assy.cs:2595 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fffbc414 | memo_menu.Click | FP00611_PlanBy_Line_Assy.cs:2598 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c732124 | memo_menu.Click | FP00611_PlanBy_Line_Assy.cs:2602 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00611_PlanBy_Line_Assy.OpenLineMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7006e5b | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2616 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-57ae333a | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2617 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-1549ed02 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2618 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ac1305e4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2618 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b680fb6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2619 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ebcf08ef | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2620 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8142bd04 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2621 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ca35c728 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2626 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-625030fb | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2629 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.OpenMaterialMemo

진입점: memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60e573b8 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2635 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-31342aa9 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2636 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-de2bddf6 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2637 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-a7bfc385 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2637 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7e0a41b4 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2638 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c909fb0f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2639 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-06034b6f | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2640 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-42edcc82 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2645 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2f4a7f7 | memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ i… 외 1 | FP00611_PlanBy_Line_Assy.cs:2648 | if (frm.DialogResult == DialogResult.OK) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.OpenMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b67b6a26 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2653 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-f21f56cb | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2654 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-3ba4cf54 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2655 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-ed9c6237 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2655 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c9cb49c8 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2656 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-c933307b | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2657 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fa82932f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2658 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-606fc4e2 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2662 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-aa76366a | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:2664 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00611_PlanBy_Line_Assy.Query

진입점: this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo != null)] / chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f458a8c | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:449 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-c0a7a90d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:449 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4bc5641d | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:450 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3aa4050 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:450 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-da3ad95b | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:451 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-7b865ae6 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:451 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b5ee524 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:454 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e0e9e33e | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:461 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-68673b30 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:466 |  | CALL_EXT | MemoService.ApplyMemoTextLine | (data, dsMemoInfo,calendar, dictCategory,MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-86be3823 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:467 |  | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3a512015 | this.Load [try ▸ else of (monthInfo == null) ▸ if (monthInfo… 외 9 | FP00611_PlanBy_Line_Assy.cs:469 |  | CALL_EXT | MemoService.ApplyMemoTagLine | (siMain, dsMainFiltered, dsMemoInfo,calendar,MEMO_COLUMN,DAY_SUFFIX,false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00611_PlanBy_Line_Assy.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / chk_hide_zero.CheckedChanged [try ▸ if (dsMainFiltered.Good())] / chk_use_memo.CheckedChanged [try ▸ if (dsMainFiltered.Good())] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].Saf…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c00c197 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:476 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b97a46ad | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:477 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2256f6c3 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:478 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-926ed9b3 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:479 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-3824af8c | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:493 | if (monthInfo != null) ▸ if (!on_redraw) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f3176c0 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:496 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-aadff1b8 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:497 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3d15bd04 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:499 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9f5af59 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:500 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |
| AC-987d4211 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:501 | if (monthInfo != null) ▸ if (!on_redraw) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f417a9d9 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:503 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe42e245 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:504 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60b00e60 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:505 | if (monthInfo != null) ▸ if (!on_redraw) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-194a9307 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:506 | if (monthInfo != null) ▸ if (!on_redraw) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count | 그리드 속성/값 설정 |  |  |  |
| AC-ee5985a8 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:510 | if (monthInfo != null) ▸ else of (!on_redraw) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-da824972 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:513 | if (monthInfo != null) | UI_PROP | siMain.MergeVerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-96b5ef5d | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:514 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec7e6f1d | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:522 | if (monthInfo != null) | UI_PROP | mct.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-29796e26 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:531 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) | UI_PROP | objCellType.Multiline | true | 속성 Multiline 설정 |  |  |  |
| AC-840fd456 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:532 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) | UI_PROP | objCellType.ScrollBars | ScrollBars.Both | 속성 ScrollBars 설정 |  |  |  |
| AC-3215531d | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:533 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) | UI_PROP | objCellType.MaxLength | 32767 | 속성 MaxLength 설정 |  |  |  |
| AC-8553e72f | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:534 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) | UI_PROP | objCellType.AllowEditorVerticalAlign | true | 속성 AllowEditorVerticalAlign 설정 |  |  |  |
| AC-32eae402 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:550 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sD… | GRID_SET | siMain.ActiveSheet.Cells[row_idx, froz, row_idx, last_col - 1].CellType | objCellType | 그리드 속성/값 설정 |  |  |  |
| AC-2831d169 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:551 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sD… | GRID_SET | siMain.ActiveSheet.Cells[row_idx, froz, row_idx, last_col - 1].VerticalAlignment | CellVerticalAlignment.Top | 그리드 속성/값 설정 |  |  |  |
| AC-6a46dd72 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:552 | if (monthInfo != null) ▸ if (bUseNote==false) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sD… | GRID_SET | siMain.ActiveSheet.Cells[row_idx, froz, row_idx, last_col - 1].HorizontalAlignment | CellHorizontalAlignment.Left | 그리드 속성/값 설정 |  |  |  |
| AC-0764558c | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:560 | if (monthInfo != null) ▸ else of (bUseNote==false) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-76ad405f | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:563 | if (monthInfo != null) ▸ else of (bUseNote==false) ▸ if (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,###.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a321af18 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:567 | if (monthInfo != null) ▸ else of (bUseNote==false) ▸ else of (bHideZero) | CALL_EXT | siMain.SetFormat | ("#,##0.##", siMain.ActiveSheet.FrozenColumnCount, -1, bHideZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21d5be83 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:572 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afe1264b | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:573 | if (monthInfo != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-fbf4254c | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:608 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor2 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-85d254b3 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:627 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-369b7c34 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:631 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-557303e4 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:633 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-08fb03ad | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:637 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-16e7de54 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:652 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-6e0f8982 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:667 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor2 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-0cb2d0f5 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:672 | if (monthInfo != null) | CALL_EXT | MemoService.ShowMemoLine | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter,DAY_SUFFIX, dtCategoryInfo,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b6fb035 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:695 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d3ee267 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:696 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac2f4016 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:697 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6792c82e | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:698 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-44290035 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:699 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-89fb3860 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:700 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4dfc7822 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:701 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-401d7205 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:702 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a9c0537 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:703 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | DATA_OP | each_row.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ad39d5a1 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:722 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | GRID_SET | siMain.ActiveSheet.Cells[row_idx, colidx, row_idx, colidx].Note | memo | 그리드 속성/값 설정 |  |  |  |
| AC-6b69261d | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:723 | if (monthInfo != null) ▸ if (bUseNote==true) ▸ if (dsMainFiltered.Tables[0].Rows.Count > 0) ▸ foreach (DataRow row in dsMainFiltered.Tables[… | GRID_SET | siMain.ActiveSheet.Cells[row_idx, colidx, row_idx, colidx].NoteStyle | FarPoint.Win.Spread.NoteStyle.StickyNote | 그리드 속성/값 설정 |  |  |  |
| AC-3fb0bc62 | this.Load [try ▸ else of (monthInfo == null)] 외 9 | FP00611_PlanBy_Line_Assy.cs:781 |  | FLAG | on_redraw | false | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.RefreshHeaderOnly

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9afa2e8c | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:788 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-168f3505 | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:789 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-5193e7af | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:790 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa51ec71 | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:791 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d52a1a98 | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:792 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00611_PlanBy_Line_Assy.RefreshSpreadSheet

진입점: chk_hide_zero.CheckedChanged [try] / chk_use_memo.CheckedChanged [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63a21d72 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2157 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6e9422fa | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2161 |  | FLAG | bHideZero | chk_hide_zero.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-4ba4f639 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2162 |  | FLAG | bUseNote | chk_use_memo.Checked | 화면 필드/플래그 변경 |  |  |  |
| AC-16398eac | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2164 | if (!dsMain.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-666526d4 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2171 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-a61cc139 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2178 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c72acae5 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:2185 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00611_PlanBy_Line_Assy.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f00c3ba3 | popSql.OnSql | FP00611_PlanBy_Line_Assy.cs:2452 | if (programID == "PR_UI_FP00611_PLAN_BY_LINE_ASSY") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-b567dbd2 | popSql.OnSql | FP00611_PlanBy_Line_Assy.cs:2454 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.SaveSimplexcel

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb6393fb | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1314 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("W0") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ecf2cf0 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1319 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < spSheet.Columns.Count) | DATA_OP | spSheet.Columns[i].DataField.ToUpper().Contains | ("D0") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6767d42 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1335 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | spSheet.ColumnHeader.Columns[j].Width / 9 | 행/컬럼 값 대입 |  |  |  |
| AC-95fe8447 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1337 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-969ed752 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1342 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Bottom | 그리드 속성/값 설정 |  |  |  |
| AC-3ef90375 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1345 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-4ba1b30c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1348 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-7151315c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1351 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Middle | 그리드 속성/값 설정 |  |  |  |
| AC-5b2ea5bb | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1354 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-8f6d7aca | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1357 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-a3df573c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1360 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.VerticalAl… | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-e68ccf17 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1367 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-e7bccfea | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1370 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Center | 그리드 속성/값 설정 |  |  |  |
| AC-11fa6480 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1373 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.None | 그리드 속성/값 설정 |  |  |  |
| AC-d4293711 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1376 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.General | 그리드 속성/값 설정 |  |  |  |
| AC-a4e0bf79 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1379 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Justify | 그리드 속성/값 설정 |  |  |  |
| AC-35ccbc17 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1382 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ switch (cell.Horizontal… | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Right | 그리드 속성/값 설정 |  |  |  |
| AC-1c7db864 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1386 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].ColSpan | cell.ColumnSpan | 그리드 속성/값 설정 |  |  |  |
| AC-24effc4d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1387 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].RowSpan | cell.RowSpan | 그리드 속성/값 설정 |  |  |  |
| AC-f4a90a00 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1388 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-b84d31a9 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1390 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-3a231378 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1396 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[i, j].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-d0af1f81 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1396 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7dbb71ca | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1402 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-2eb32274 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1405 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (cell.Font != null) | GRID_SET | xSheet.Cells[i, j].FontSize | (int)cell.Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-5f402598 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1408 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < headerrowcount) ▸ for (j < headercolcount) ▸ else of (cell.Font != n… | GRID_SET | xSheet.Cells[i, j].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-5b05897d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1430 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e55129ba | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1431 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-6d69cd18 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1439 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-a9cce03b | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1440 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-243f9c14 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1445 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-69036125 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1446 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-fbe9fa7c | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1452 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-60a3a578 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1458 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8f868b82 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1468 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-97fc9a83 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1469 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-fee01211 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1475 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-c04e9710 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1476 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-6356f385 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1481 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-931ee645 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1485 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Value != nu… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-28d2fadc | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1492 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].TextColor | Simplexcel.Color.FromArgb(fg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-bba9c75f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1492 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!fg.IsEmpty) | CALL_EXT | fg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3f2528fc | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1496 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.FromArgb(bg.ToArgb()) | 그리드 속성/값 설정 |  |  |  |
| AC-6a18e1e3 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1496 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (!bg.IsEmpty) | CALL_EXT | bg.ToArgb | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-763d5e3f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1500 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (!bg.IsEmpty) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-4ccb3a38 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1505 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].FontSize | (int)spSheet.Cells[i, j].Font.Size | 그리드 속성/값 설정 |  |  |  |
| AC-c190b399 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1507 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Bold | true | 그리드 속성/값 설정 |  |  |  |
| AC-79a08e01 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1509 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ if (spSheet.Cells[i, j].Font != nul… | GRID_SET | xSheet.Cells[id, jd].Italic | true | 그리드 속성/값 설정 |  |  |  |
| AC-66415a42 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1512 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) ▸ else of (spSheet.Cells[i, j].Font !… | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-a479161d | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1514 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) ▸ for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-d4599615 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1519 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | GRID_INIT | xSheet.FreezeTopLeft | (spSheet.ColumnHeader.RowCount, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b8547ae | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1520 | foreach (FarPoint.Win.Spread.SheetView spSheet in sp.Sheets) | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-9212e540 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1534 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-2dd6255f | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1535 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-48c09218 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1537 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetChangeControl

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged / clbProdType.SelectedIndexChanged / chk_allLine.CheckedChanged / chk_inActive.CheckedChanged / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aad69fb8 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:275 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9581fb5 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:275 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-24173119 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:284 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1cc1049f | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:285 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b52cd62 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:285 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-15028af2 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:286 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-463d11c0 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:292 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-290023c2 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:293 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-03356a35 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:293 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-58505f76 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:294 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9cd43c24 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:300 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-38dabc7c | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:301 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f276af35 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:301 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-abc8c392 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:302 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-5161de2a | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:308 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fa8e071f | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:309 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-012a36cd | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:309 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3dec9f42 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:310 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8d962c5b | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:317 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-583e9841 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:318 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-77961eef | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:318 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-41d75a9a | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:319 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb022fb1 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:325 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, clbOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-84652912 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:326 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-afadacdf | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:326 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fc36201f | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:327 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fbab9d4e | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:333 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-071e9a7d | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:337 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, clbProdType.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-5393ecf6 | this.Load 외 12 | FP00611_PlanBy_Line_Assy.cs:337 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, clbProdType.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetColumnsFormat

진입점: chk_hide_zero.CheckedChanged [try] / chk_use_memo.CheckedChanged [try] / memo_menu.Click [try ▸ if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4c164a1 | chk_hide_zero.CheckedChanged [try] 외 8 | FP00611_PlanBy_Line_Assy.cs:3315 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6fb513f | this.Load | FP00611_PlanBy_Line_Assy.cs:157 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b5c52de | this.Load | FP00611_PlanBy_Line_Assy.cs:159 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-fd0a19ea | this.Load | FP00611_PlanBy_Line_Assy.cs:160 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lciHideZero.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6055c960 | this.Load | FP00611_PlanBy_Line_Assy.cs:161 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lciNoteMemo.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-744e9928 | this.Load | FP00611_PlanBy_Line_Assy.cs:162 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSimpleXcel.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-59b70dc3 | this.Load | FP00611_PlanBy_Line_Assy.cs:166 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-08d40e46 | this.Load | FP00611_PlanBy_Line_Assy.cs:167 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lciHideZero.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-963e4e00 | this.Load | FP00611_PlanBy_Line_Assy.cs:168 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lciNoteMemo.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d156fabd | this.Load | FP00611_PlanBy_Line_Assy.cs:169 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSimpleXcel.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a97a8ab7 | this.Load | FP00611_PlanBy_Line_Assy.cs:171 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbOperation.Selec…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c84c7aee | this.Load 외 20 | FP00611_PlanBy_Line_Assy.cs:2324 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetInitMemo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-575364a0 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1613 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-f582ca19 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1614 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-305bf4d3 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1615 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-545d5c17 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1616 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-0af01165 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1628 | foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | dsResult.Tables[0].Columns[sColName].ChangeType | (typeof(string)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3c181d7 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1645 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8cb2baec | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1652 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8f015ade | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1654 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "0" | 행/컬럼 값 대입 |  |  |  |
| AC-dfa6b4cd | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1658 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | String.Format("{0}", m) | 행/컬럼 값 대입 |  |  |  |
| AC-81bf76e6 | (진입점 미연결) | FP00611_PlanBy_Line_Assy.cs:1665 | foreach (AmendDate a in calendar.Days.Values) ▸ if (dsResult.Tables[0].Rows.Count > 0) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (row["… | DATA_OP | row[sColName] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.SetSpreadInit

진입점: this.Load [try] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ try] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null) ▸ try ▸ try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d77ff980 | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:414 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5103df33 | this.Load [try] 외 3 | FP00611_PlanBy_Line_Assy.cs:415 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7a37522 | this.spdMain.ButtonClicked | FP00611_PlanBy_Line_Assy.cs:3466 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86798db0 | this.spdMain.CellClick | FP00611_PlanBy_Line_Assy.cs:2888 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-c5863399 | this.spdMain.CellClick | FP00611_PlanBy_Line_Assy.cs:2889 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-64f8ebbe | this.spdMain.CellClick | FP00611_PlanBy_Line_Assy.cs:2891 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-f720fec6 | this.spdMain.CellClick | FP00611_PlanBy_Line_Assy.cs:2900 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a9668e0 | this.spdMain.CellDoubleClick | FP00611_PlanBy_Line_Assy.cs:2745 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-154bfefb | this.spdMain.CellDoubleClick | FP00611_PlanBy_Line_Assy.cs:2752 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7052cad | this.spdMain.ChildControlDeactivated | FP00611_PlanBy_Line_Assy.cs:3423 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7af308e | this.spdMain.DragFillBlockCompleted | FP00611_PlanBy_Line_Assy.cs:3433 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0704d69d | this.spdMain.EditChange | FP00611_PlanBy_Line_Assy.cs:2704 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e771ef2c | this.spdMain.EditModeOff | FP00611_PlanBy_Line_Assy.cs:3451 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54d2ae1c | this.spdMain.EditModeOn | FP00611_PlanBy_Line_Assy.cs:3457 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-82cb203a | this.spdMain.EditModeOn | FP00611_PlanBy_Line_Assy.cs:3458 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6e5e8b5 | this.spdMain.EditorFocused | FP00611_PlanBy_Line_Assy.cs:3445 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9b7d433 | this.spdMain.Enter | FP00611_PlanBy_Line_Assy.cs:3408 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7995c026 | this.spdMain.Leave | FP00611_PlanBy_Line_Assy.cs:3403 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d5c41d8 | this.spdMain.SubEditorClosed | FP00611_PlanBy_Line_Assy.cs:3439 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991feb71 | this.spdMain.SubEditorOpening | FP00611_PlanBy_Line_Assy.cs:3428 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7734d81 | this.spdMain.TableChanged | FP00611_PlanBy_Line_Assy.cs:2692 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ea31e1d | this.spdMain.TableChanged | FP00611_PlanBy_Line_Assy.cs:2694 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7233e191 | this.spdMain.TextChanged | FP00611_PlanBy_Line_Assy.cs:2675 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e075091c | this.spdMain.TextChanged | FP00611_PlanBy_Line_Assy.cs:2677 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e38f89f4 | this.spdMain.Validated | FP00611_PlanBy_Line_Assy.cs:3413 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e02ab5f | this.spdMain.Validating | FP00611_PlanBy_Line_Assy.cs:3418 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.SwitchMemo

진입점: memo_menu.Click [try ▸ if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a97c2dc0 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2763 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0976dd6e | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2780 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-9e1e504a | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2811 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-649a20e1 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2812 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-0ba6cb3b | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2814 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8baa1a50 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2845 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bed8ca53 | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2846 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-6289e9bc | memo_menu.Click [try ▸ if (day != null)] 외 1 | FP00611_PlanBy_Line_Assy.cs:2848 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00611_PlanBy_Line_Assy.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77341515 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3105 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a30a14da | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3109 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c0ab2a5 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3110 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 65) | 데이터 객체 조작/조회 |  |  |  |
| AC-67a99ca5 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3111 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-50e35af0 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3112 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 50) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7e77894 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3113 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 120) | 데이터 객체 조작/조회 |  |  |  |
| AC-d9fd6ef3 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3114 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-af6c8197 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3119 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-10598602 | tbNickName.BeforeOpenSearch | FP00611_PlanBy_Line_Assy.cs:3120 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00611_PlanBy_Line_Assy.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-014c4279 | tbNickName.OnSearchConditionChanged | FP00611_PlanBy_Line_Assy.cs:3129 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-364d171e | tbNickName.OnSearchConditionChanged | FP00611_PlanBy_Line_Assy.cs:3130 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5e06b458 | tbNickName.OnSearchConditionChanged | FP00611_PlanBy_Line_Assy.cs:3136 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-7e07f48d | tbNickName.OnSearchConditionChanged | FP00611_PlanBy_Line_Assy.cs:3139 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cc2ae78b | tbNickName.OnSearchConditionChanged | FP00611_PlanBy_Line_Assy.cs:3141 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00611_PlanBy_Line_Assy.UIFindData

진입점: this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btn_category.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f7f1a90 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2077 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-011b448b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2087 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-136e7574 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2088 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-70d03c60 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2091 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f4fb76b0 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2095 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5f447e98 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2096 | try | FLAG | dtRelease | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1a77d1d9 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2097 | try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5cbe69fc | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2100 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-33816048 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2111 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-56e83dd9 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2113 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3617893a | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2113 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f205e4ec | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2123 | try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2293121b | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2126 | try ▸ if (dsMain.Good()) ▸ if (dsMain.Tables.Count > 1) | FLAG | dtRelease | dsMain.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-477dfdf5 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2129 | try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-42c4900e | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2130 | try | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_MM_", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7bdfd7 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2138 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e2774f3 | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2144 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-42de5f0d | this.btn_bucket.Click [if (frm.DialogResult == DialogResult.… 외 2 | FP00611_PlanBy_Line_Assy.cs:2146 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

