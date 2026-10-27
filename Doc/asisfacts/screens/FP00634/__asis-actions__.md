# AS-IS 액션 대조표 — FP00634

> 원천: `Doc/asisfacts/screens/FP00634/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 583행 · 메서드 95 · 종류 DATA_OP 221 · FLAG 67 · UI_PROP 43 · RETURN 37 · VALUE_SET 30 · UI_MISC 23 · GRID_INIT 22 · MESSAGE 19 · COMBO_DATA 17 · CALL_EXT 16 · ENDPOINT 16 · LIST_REBIND 16 · POPUP 14 · STATE 8 · GRID_SET 8 · CALL_BASE 6 · GRID_LOCK 6 · THROW 6 · GRID_STYLE 4 · GRID_BIND 3 · EXCEL 1 · ⚠ 의미 확인 필요 22


## FP00634_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-173bc871 | .ctor | FP00634_MeasureSetForm_Popup.cs:104 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-08f33e19 | .ctor | FP00634_MeasureSetForm_Popup.cs:105 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-648fad26 | .ctor | FP00634_MeasureSetForm_Popup.cs:106 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-edd1b095 | .ctor | FP00634_MeasureSetForm_Popup.cs:108 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00634_MeasureSetForm_Popup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89f3893b | this.btnOK.Click | FP00634_MeasureSetForm_Popup.cs:363 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-9e735038 | this.btnOK.Click | FP00634_MeasureSetForm_Popup.cs:364 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-179d5e03 | this.btnOK.Click | FP00634_MeasureSetForm_Popup.cs:371 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-b33a5061 | this.btnOK.Click | FP00634_MeasureSetForm_Popup.cs:372 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00634_MeasureSetForm_Popup.btnSet_Click

진입점: this.btnSet.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82861373 | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:334 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-d098e01f | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:335 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-780d9eb8 | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:337 |  | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-81048fda | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:338 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6c24df4 | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:340 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-f7913f51 | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:341 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-7adf65ea | this.btnSet.Click | FP00634_MeasureSetForm_Popup.cs:342 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00634_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a9fa035 | Dispose | FP00634_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00634_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d245dda6 | this.Load | FP00634_MeasureSetForm_Popup.cs:131 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00634_MeasureSetForm_Popup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32c02ef7 | this.Load | FP00634_MeasureSetForm_Popup.cs:199 |  | FLAG | dtCategory | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "select_measure", "FP00603_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-d6f51b63 | this.Load | FP00634_MeasureSetForm_Popup.cs:199 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "select_measure", "FP00603_Main") ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c229d2d | this.Load | FP00634_MeasureSetForm_Popup.cs:201 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-610f1777 | this.Load | FP00634_MeasureSetForm_Popup.cs:202 |  | FLAG | measure_val | new bool[measure_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-19c1aa35 | this.Load | FP00634_MeasureSetForm_Popup.cs:203 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-fca86ff7 | this.Load | FP00634_MeasureSetForm_Popup.cs:230 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d4823fc | this.Load | FP00634_MeasureSetForm_Popup.cs:231 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-862027fd | this.Load | FP00634_MeasureSetForm_Popup.cs:232 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4fba746 | this.Load | FP00634_MeasureSetForm_Popup.cs:234 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f05d5e | this.Load | FP00634_MeasureSetForm_Popup.cs:235 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-112bf1c2 | this.Load | FP00634_MeasureSetForm_Popup.cs:236 |  | DATA_OP | ctrls.Add | (chk_offtime) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e1cf5b3 | this.Load | FP00634_MeasureSetForm_Popup.cs:238 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-603ad809 | this.Load | FP00634_MeasureSetForm_Popup.cs:239 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-32f4c29a | this.Load | FP00634_MeasureSetForm_Popup.cs:240 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-27eb3b63 | this.Load | FP00634_MeasureSetForm_Popup.cs:242 |  | DATA_OP | ctrls.Add | (chk_gap) | 데이터 객체 조작/조회 |  |  |  |
| AC-36b204bb | this.Load | FP00634_MeasureSetForm_Popup.cs:243 |  | DATA_OP | ctrls.Add | (chk_cut) | 데이터 객체 조작/조회 |  |  |  |
| AC-7dabca40 | this.Load | FP00634_MeasureSetForm_Popup.cs:246 |  | DATA_OP | ctrls.Add | (chk_uom) | 데이터 객체 조작/조회 |  |  |  |
| AC-eac45bf3 | this.Load | FP00634_MeasureSetForm_Popup.cs:247 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-b99c9d3d | this.Load | FP00634_MeasureSetForm_Popup.cs:250 |  | DATA_OP | ctrls.Add | (chk_wpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d28eee79 | this.Load | FP00634_MeasureSetForm_Popup.cs:251 |  | DATA_OP | ctrls.Add | (chk_wpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-2154cd27 | this.Load | FP00634_MeasureSetForm_Popup.cs:252 |  | DATA_OP | ctrls.Add | (chk_gap_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-36696950 | this.Load | FP00634_MeasureSetForm_Popup.cs:254 |  | DATA_OP | ctrls.Add | (chk_mpp_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a89ac452 | this.Load | FP00634_MeasureSetForm_Popup.cs:255 |  | DATA_OP | ctrls.Add | (chk_mpp_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-86dadcc7 | this.Load | FP00634_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_cut_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8d54e76 | this.Load | FP00634_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f43ba744 | this.Load | FP00634_MeasureSetForm_Popup.cs:259 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-79f9ddf3 | this.Load | FP00634_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-558f0c5d | this.Load | FP00634_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-e802c8dd | this.Load | FP00634_MeasureSetForm_Popup.cs:263 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1b8cac3 | this.Load | FP00634_MeasureSetForm_Popup.cs:266 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe0d4251 | this.Load | FP00634_MeasureSetForm_Popup.cs:266 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-be39eeb7 | this.Load | FP00634_MeasureSetForm_Popup.cs:273 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-2ff35aa1 | this.Load | FP00634_MeasureSetForm_Popup.cs:277 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-0c3fb930 | this.Load | FP00634_MeasureSetForm_Popup.cs:281 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00634_MeasureSetForm_Popup.InitNames

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9f8075b | this.Load | FP00634_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_wpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-738d42f0 | this.Load | FP00634_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_wpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1aecda25 | this.Load | FP00634_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e1a7c75b | this.Load | FP00634_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_mpp_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ba4c75fb | this.Load | FP00634_MeasureSetForm_Popup.cs:149 |  | VALUE_SET | chk_mpp_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-aa758472 | this.Load | FP00634_MeasureSetForm_Popup.cs:150 |  | VALUE_SET | chk_offtime.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ed8d36bc | this.Load | FP00634_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_inqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-72d3e21e | this.Load | FP00634_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_outqty.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-65162d81 | this.Load | FP00634_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_memo.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-745f0db3 | this.Load | FP00634_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_gap.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8a497d2f | this.Load | FP00634_MeasureSetForm_Popup.cs:157 |  | VALUE_SET | chk_cut.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-65333825 | this.Load | FP00634_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_uom.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-449e7b31 | this.Load | FP00634_MeasureSetForm_Popup.cs:162 |  | VALUE_SET | chk_cell.Text | measure_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-68a631d9 | this.Load | FP00634_MeasureSetForm_Popup.cs:166 |  | VALUE_SET | chk_wpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e9ee7f89 | this.Load | FP00634_MeasureSetForm_Popup.cs:167 |  | VALUE_SET | chk_wpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b1d377bc | this.Load | FP00634_MeasureSetForm_Popup.cs:168 |  | VALUE_SET | chk_gap_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9a784b7a | this.Load | FP00634_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_mpp_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4804dc08 | this.Load | FP00634_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_mpp_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8597a420 | this.Load | FP00634_MeasureSetForm_Popup.cs:172 |  | VALUE_SET | chk_cut_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-253fa04e | this.Load | FP00634_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_inqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e3c70252 | this.Load | FP00634_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_outqty_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-94b256cb | this.Load | FP00634_MeasureSetForm_Popup.cs:176 |  | VALUE_SET | chk_result_tot.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6f5d2f2f | this.Load | FP00634_MeasureSetForm_Popup.cs:178 |  | VALUE_SET | chk_subTotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-55b6e37c | this.Load | FP00634_MeasureSetForm_Popup.cs:179 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00634_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d4e3b14 | this.Load | FP00634_MeasureSetForm_Popup.cs:118 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a33c097c | this.Load | FP00634_MeasureSetForm_Popup.cs:126 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00634_MeasureSetForm_Popup.setMeasualFormData

진입점: this.btnSet.Click / this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f491978 | this.btnSet.Click 외 1 | FP00634_MeasureSetForm_Popup.cs:378 |  | FLAG | _bSearchFlag | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9cbb66fc | this.btnSet.Click 외 1 | FP00634_MeasureSetForm_Popup.cs:386 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-15e349f4 | this.btnSet.Click 외 1 | FP00634_MeasureSetForm_Popup.cs:386 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-1a343539 | this.btnSet.Click 외 1 | FP00634_MeasureSetForm_Popup.cs:403 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (dtCategory != null) ▸ for (i < dtCategory.Rows.Count) ▸ if (eachCheckName.Equ… | FLAG | _bSearchFlag | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9eb0ba20 | this.btnSet.Click 외 1 | FP00634_MeasureSetForm_Popup.cs:414 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |

## FP00634_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed62595e | .ctor | FP00634_PlanInfoPopup.cs:116 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-687c3985 | .ctor | FP00634_PlanInfoPopup.cs:117 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00634_PlanInfoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-659e1673 | this.btnClose.Click | FP00634_PlanInfoPopup.cs:328 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00634_PlanInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a794f684 | this.Load | FP00634_PlanInfoPopup.cs:154 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8086c771 | this.Load | FP00634_PlanInfoPopup.cs:155 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-977262bc | this.Load | FP00634_PlanInfoPopup.cs:156 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00634_PlanInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d947508 | this.Load | FP00634_PlanInfoPopup.cs:149 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00634_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2f00ba6 | Dispose | FP00634_PlanInfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00634_PlanInfoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-abc4c05c | FindButton | FP00634_PlanInfoPopup.cs:189 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-88ba02ff | FindButton | FP00634_PlanInfoPopup.cs:190 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-78c20660 | FindButton | FP00634_PlanInfoPopup.cs:192 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00634_PlanInfoPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d2ba6be | this.Load 외 1 | FP00634_PlanInfoPopup.cs:226 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-a602ae9a | this.Load 외 1 | FP00634_PlanInfoPopup.cs:226 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5504d43d | this.Load 외 1 | FP00634_PlanInfoPopup.cs:230 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-88a89826 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:231 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c4025330 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:238 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-657954f0 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:261 | try ▸ if (Filter["RELEASE_FLAG"] == "Y") | DATA_OP | Filter["CTRL_WHERE"] | " WHERE 1=0\r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-b36a83c7 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:262 | try ▸ if (Filter["RELEASE_FLAG"] == "Y") | DATA_OP | Filter["CTRL_AND"] | " AND 1=1\r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-a2c36740 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:266 | try ▸ else of (Filter["RELEASE_FLAG"] == "Y") | DATA_OP | Filter["CTRL_WHERE"] | " WHERE 1=1\r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-8fc2f962 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:267 | try ▸ else of (Filter["RELEASE_FLAG"] == "Y") | DATA_OP | Filter["CTRL_AND"] | " AND 1=0\r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-4bc7c018 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:270 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "find_planInfo_p", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo_p] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-18cbad99 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:272 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ea1c5e9 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:274 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fb102b60 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:275 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1d63d9a9 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:285 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f580a1a | this.Load 외 1 | FP00634_PlanInfoPopup.cs:288 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dd23bc42 | this.Load 외 1 | FP00634_PlanInfoPopup.cs:289 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00634_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be7b4bfb | this.Load | FP00634_PlanInfoPopup.cs:125 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-09ae4436 | this.Load | FP00634_PlanInfoPopup.cs:127 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00634_PlanInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f9172d9 | this.Load | FP00634_PlanInfoPopup.cs:165 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-e97e310f | this.Load | FP00634_PlanInfoPopup.cs:168 | if (Filter["CONFIRM_AREA"].ToString() != "BUILDING") | GRID_INIT | siMain.SetColumnHeader | (0, 1, "Plan Group") | 그리드 재구성/초기화 |  |  |  |

## FP00634_PlanInfoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a03a9c6 | (진입점 미연결) | FP00634_PlanInfoPopup.cs:180 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00634_PlanInfoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f6b21c4 | this.Load | FP00634_PlanInfoPopup.cs:174 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d5be0be | this.Load | FP00634_PlanInfoPopup.cs:175 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00634_Tray_Simulation..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee280d85 | .ctor | FP00634_Tray_Simulation.cs:180 |  | FLAG | _CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00634_Tray_Simulation.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e90cc764 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1081 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-11d7ab6e | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1082 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-78d77cce | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1083 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cdabb709 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1084 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ba285937 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1085 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d671358b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1088 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9e8b557 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1088 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9942c53c | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1089 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-21eca379 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1089 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fa0be42b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1090 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-8213c070 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1090 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b3f9b4b1 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1091 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-989aa73b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1091 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3a02d8ae | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1098 |  | DATA_OP | Filter["DAY_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-685c7cbd | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1099 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-42be1334 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1100 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-8f352a7f | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1101 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634") ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-873b6b11 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1107 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { DataTable dt = null; DataTable dtWeekMonth = null; string… | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa5d4d30 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1116 | lambda ▸ if (Filter["INSTANCE_ID"] == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtIns… | ⚠ 의미 확인 필요 |  |  |  |
| AC-8fc5b010 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1118 | lambda ▸ if (Filter["INSTANCE_ID"] == "") ▸ lambda | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-85573815 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1122 | lambda | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; //Filter["PLAN_DATE"] = sC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-61d0229b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1126 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | rp_plan_period.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c2bc9b61 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1127 | lambda ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | rp_plan_period.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8ce72e6c | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1130 | lambda ▸ lambda | DATA_OP | Filter["TOP_ITEM_ID"] | txt_group_id.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f30f7a27 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1137 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_day2WeekAndMonth", Filter["BUCKET_FROM"], Filter["BUCKET_TO… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ea158506 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1204 | lambda | DATA_OP | Filter["DAY2WEEK"] | sWeekColumn | 행/컬럼 값 대입 |  |  |  |
| AC-f88775a1 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1205 | lambda | DATA_OP | Filter["DAY2MONTH"] | sMonthColumn | 행/컬럼 값 대입 |  |  |  |
| AC-abc0992d | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1207 | lambda | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_currDateCol", Filter["INSTANCE_ID"], Filter["BUCKET_FROM"],… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae6746d1 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1210 | lambda ▸ if (dt != null) ▸ if (dt.Rows.Count > 0) | DATA_OP | Filter["CURR_DATE"] | dt.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43118f6a | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1212 | lambda ▸ if (dt != null) ▸ else of (dt.Rows.Count > 0) | DATA_OP | Filter["CURR_DATE"] | "-999" | 행/컬럼 값 대입 |  |  |  |
| AC-e169df54 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1214 | lambda ▸ else of (dt != null) | DATA_OP | Filter["CURR_DATE"] | "-999" | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.btnBucket_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f39e75d0 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2124 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-08759e3e | (진입점 미연결) | FP00634_Tray_Simulation.cs:2127 |  | POPUP | new FP00599_BucketSetForm_Popup | ("FP00603", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-69526039 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2128 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2c604952 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2129 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f792644 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2135 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00634_Tray_Simulation.btnCatagory_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47206405 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2088 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-48231b04 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2091 |  | POPUP | new FP00634_MeasureSetForm_Popup | ("FP00603", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-e7bcc63b | (진입점 미연결) | FP00634_Tray_Simulation.cs:2092 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-366cbce9 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2093 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ef93e493 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2100 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00634_Tray_Simulation.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7da39b3c | this.btnColumn.Click | FP00634_Tray_Simulation.cs:2064 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-47668e68 | this.btnColumn.Click | FP00634_Tray_Simulation.cs:2067 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00634", SpdSheet.shtMain, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-154381ab | this.btnColumn.Click | FP00634_Tray_Simulation.cs:2068 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b4b6675d | this.btnColumn.Click | FP00634_Tray_Simulation.cs:2069 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00634_Tray_Simulation.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5fe8a59 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2149 | if (!Filter["INSTANCE_ID"].Good()) | MESSAGE | MessageBox.Show | ("you need Instace Value.!") | 메시지 표시 |  |  |  |
| AC-f13f5ded | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2150 | if (!Filter["INSTANCE_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16cb1c58 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2156 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-8ad15d72 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2159 |  | POPUP | new FP00634_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-850dbde6 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2160 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-d7e7f48f | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2160 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-84404e76 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2161 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-55973173 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2161 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-285365bc | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2162 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-f2f443a2 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2163 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-dfe5be33 | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2165 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c800d83f | this.btnPlanInfo.Click | FP00634_Tray_Simulation.cs:2166 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00634_Tray_Simulation.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3004fc11 | this.btnSql.Click | FP00634_Tray_Simulation.cs:2176 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-878fb1bb | this.btnSql.Click | FP00634_Tray_Simulation.cs:2179 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-88250119 | this.btnSql.Click | FP00634_Tray_Simulation.cs:2180 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f38c4998 | this.btnSql.Click | FP00634_Tray_Simulation.cs:2182 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00634_FIND_FP00634") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6b2d7c4 | this.btnSql.Click | FP00634_Tray_Simulation.cs:2184 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00634_Tray_Simulation.cbo_fpplanid_changed

진입점: cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e8e7197 | cbo_fpplanid.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1912 |  | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = CString.GetCheckedListValue(dtInstance, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c3e16fc1 | cbo_fpplanid.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1912 |  | DATA_OP | Filter["FP_PLAN_ID"] | CString.GetCheckedListValue(dtInstance, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.cbo_plan_group_changed

진입점: cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-450e9b76 | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1891 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-4ab8f8da | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1896 | if (Filter["INSTANCE_ID"] != "") | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-64bbc1a5 | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1897 | if (Filter["INSTANCE_ID"] != "") | DATA_OP | Filter["FACTORY_YN"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["FACTORY_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dec85b47 | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1900 |  | DATA_OP | Filter["CURR_DATE"] | dtPastInfo.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4045f3d9 | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1901 |  | DATA_OP | Filter["PLAN_DATE"] | dtPastInfo.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06148c92 | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1902 |  | DATA_OP | Filter["BUCKET_FROM"] | dtPastInfo.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-20a9abfb | cbo_plan_group.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1903 |  | DATA_OP | Filter["BUCKET_TO"] | dtPastInfo.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.cbo_site_changed

진입점: cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91835b5d | cbo_site.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1934 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.chk_allLine_CheckedChanged

진입점: this.chk_all_line.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc7fd703 | this.chk_all_line.CheckedChanged | FP00634_Tray_Simulation.cs:1970 |  | DATA_OP | Filter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.chk_sub_op_CheckedChanged

진입점: this.chk_sub_op.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b6f909c | this.chk_sub_op.CheckedChanged | FP00634_Tray_Simulation.cs:2443 |  | DATA_OP | Filter["AMEND_MAIN_FLAG"] | chk_sub_op.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.chkInAct_CheckedChanged

진입점: this.chk_rel.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba11b3b6 | this.chk_rel.CheckedChanged | FP00634_Tray_Simulation.cs:2005 |  | DATA_OP | Filter["RELEASE_FLAG"] | chk_rel.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-de7a7cf8 | this.chk_rel.CheckedChanged | FP00634_Tray_Simulation.cs:2008 | if (Filter["RELEASE_FLAG"] == "Y") | FLAG | dtPlanId | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f608f1eb | this.chk_rel.CheckedChanged | FP00634_Tray_Simulation.cs:2009 | if (Filter["RELEASE_FLAG"] == "Y") | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.CreateFilterDataSet

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f28c36b4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1327 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-9e52def2 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1332 | lambda | DATA_OP | x.Field | ("DEGAS_BEFORE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-927ae3cf | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1332 | lambda | DATA_OP | x.Field | ("CATEGORY_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-c76685fe | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1334 | lambda | DATA_OP | x.Field | ("DEGAS_BEFORE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbbf2d63 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1335 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3512e0a | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1336 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-777cc8ca | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1337 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-63aa8134 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1340 | lambda | DATA_OP | x.Field | ("DEGAS_BEFORE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0e8e04b0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1341 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7662fb8d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1342 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bfabf95b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1343 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc150c5b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1346 | lambda | DATA_OP | x.Field | ("DEGAS_BEFORE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9fff95a1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1347 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f3fe62e | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1350 | lambda | DATA_OP | x.Field | ("PSI") | 데이터 객체 조작/조회 |  |  |  |
| AC-10cfef01 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1350 | lambda | DATA_OP | x.Field | ("DEGAS_BEFORE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c001df4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1357 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4c9eb708 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1361 | if (dtTmp != null) | DATA_OP | dsData.Tables.Add | (dtTmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7a7d087 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1363 |  | RETURN | return dsData; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1239aff | this.Load | FP00634_Tray_Simulation.cs:621 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-27bcfbfb | this.Load | FP00634_Tray_Simulation.cs:622 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2166b4d | this.Load | FP00634_Tray_Simulation.cs:623 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00634_Tray_Simulation.dCalendarPlanrange_changed

진입점: rp_plan_period.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e36c348 | rp_plan_period.ValueChanged | FP00634_Tray_Simulation.cs:2034 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07ed7f7b | rp_plan_period.ValueChanged | FP00634_Tray_Simulation.cs:2038 | if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | MESSAGE | MessageBox.Show | ("The End date can not be later than the planned date.") | 메시지 표시 |  |  |  |
| AC-815ef147 | rp_plan_period.ValueChanged | FP00634_Tray_Simulation.cs:2039 | if (Convert.ToDecimal(arrRetStart) > Convert.ToDecimal(arrRetEnd)) | UI_PROP | rp_plan_period.Value2 | rp_plan_period.Value1.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-23fe3002 | rp_plan_period.ValueChanged | FP00634_Tray_Simulation.cs:2050 |  | DATA_OP | Filter["BUCKET_FROM"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-fc1a1f55 | rp_plan_period.ValueChanged | FP00634_Tray_Simulation.cs:2051 |  | DATA_OP | Filter["BUCKET_TO"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-928b7bc5 | DeleteButton | FP00634_Tray_Simulation.cs:848 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3612acdd | DeleteButton | FP00634_Tray_Simulation.cs:849 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb721b69 | Dispose | FP00634_Tray_Simulation.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00634_Tray_Simulation.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97713daa | EditButton | FP00634_Tray_Simulation.cs:855 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecf093fc | EditButton | FP00634_Tray_Simulation.cs:856 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-66110587 | ExcelButton | FP00634_Tray_Simulation.cs:877 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00634_Tray_Simulation.FilterInstanceID

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dp_plan_date.ValueChanged / this.chk_rel.CheckedChanged [if (Filter["RELEASE_FLAG"] == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64093759 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:484 | if (dtPlanId.Good() && idx >= 0) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = CString.GetCheckedListValue(dtPlanId, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ab367262 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:484 | if (dtPlanId.Good() && idx >= 0) | DATA_OP | Filter["FP_PLAN_ID"] | CString.GetCheckedListValue(dtPlanId, cbo_fpplanid.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ae3f8183 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:485 | if (dtPlanId.Good() && idx >= 0) | UI_PROP | rp_plan_period.Text1 | dtPlanId.Rows[idx]["DEFAULT_START_DATE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-84c2a3af | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:486 | if (dtPlanId.Good() && idx >= 0) | UI_PROP | rp_plan_period.Text2 | dtPlanId.Rows[idx]["DEFAULT_END_DATE"].ToString() | 속성 Text2 설정 |  |  |  |
| AC-920ccfc4 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:523 | else of (dtPlanId.Good() && idx >= 0) | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-e4f990c6 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:523 | else of (dtPlanId.Good() && idx >= 0) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a7c36f3 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:528 | else of (dtPlanId.Good() && idx >= 0) | UI_PROP | rp_plan_period.Text1 | sStart | 속성 Text1 설정 |  |  |  |
| AC-fac85ae8 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:529 | else of (dtPlanId.Good() && idx >= 0) | UI_PROP | rp_plan_period.Text2 | sEnd | 속성 Text2 설정 |  |  |  |
| AC-ead76eb4 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:541 |  | DATA_OP | Filter["BUCKET_FROM"] | sStart | 행/컬럼 값 대입 |  |  |  |
| AC-c0bd2463 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:542 |  | DATA_OP | Filter["BUCKET_TO"] | sEnd | 행/컬럼 값 대입 |  |  |  |
| AC-b3d73ef1 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:543 |  | DATA_OP | Filter["FP_SITE_ID"] | sFPSite | 행/컬럼 값 대입 |  |  |  |
| AC-8791fabe | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:544 |  | DATA_OP | Filter["DESCRIPTION"] | sDesc | 행/컬럼 값 대입 |  |  |  |
| AC-82c27b3b | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:545 |  | DATA_OP | Filter["PLAN_TYPE"] | planType | 행/컬럼 값 대입 |  |  |  |
| AC-f89aaaf9 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:546 |  | DATA_OP | Filter["READ_ONLY"] | readOnly | 행/컬럼 값 대입 |  |  |  |
| AC-724fc7a4 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:547 |  | DATA_OP | Filter["PLAN_NAME"] | planName | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b68fa556 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:955 | try ▸ if (chk_rel.Checked) | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-51bf2817 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:956 | try ▸ if (chk_rel.Checked) | DATA_OP | Filter["PLAN_TYPE"] | "RELEASE" | 행/컬럼 값 대입 |  |  |  |
| AC-6e841163 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:960 | try ▸ else of (chk_rel.Checked) | DATA_OP | Filter["RELEASE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ba349081 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:961 | try ▸ else of (chk_rel.Checked) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bfc3d85b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:965 | try ▸ else of (chk_rel.Checked) ▸ if (dtPlanId.Rows.Count > 0) | CALL_EXT | dtPlanId.Lookup | ("PLAN_ID", Filter["PLAN_ID"].ToString(), "PLAN_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f785d0b | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:968 | try ▸ else of (chk_rel.Checked) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sPType == "RELEASE") | DATA_OP | Filter["RELEASE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-01258ffb | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:969 | try ▸ else of (chk_rel.Checked) ▸ if (dtPlanId.Rows.Count > 0) ▸ if (sPType == "RELEASE") | DATA_OP | Filter["PLAN_TYPE"] | "RELEASE" | 행/컬럼 값 대입 |  |  |  |
| AC-ad22fc49 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:973 | try ▸ else of (chk_rel.Checked) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sPType == "RELEASE") | DATA_OP | Filter["RELEASE_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-5ec2251d | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:974 | try ▸ else of (chk_rel.Checked) ▸ if (dtPlanId.Rows.Count > 0) ▸ else of (sPType == "RELEASE") | DATA_OP | Filter["PLAN_TYPE"] | "PRE" | 행/컬럼 값 대입 |  |  |  |
| AC-de906a70 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:978 | try | DATA_OP | Filter["CHK_PLANID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d5c76b59 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:983 | try ▸ if (Filter["DIVISION_ID"] == "") | MESSAGE | MessageBox.Show | ("Please selet Division") | 메시지 표시 |  |  |  |
| AC-2356a71e | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:984 | try ▸ if (Filter["DIVISION_ID"] == "") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1017ae31 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:988 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ if (Filter["FACTORY_ID"] == "") | MESSAGE | MessageBox.Show | ("Please select Building") | 메시지 표시 |  |  |  |
| AC-da417904 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:989 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ if (Filter["FACTORY_ID"] == "") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5ee062d3 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:993 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ if (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLAG"] !… | MESSAGE | MessageBox.Show | ("FP Plan ID is required") | 메시지 표시 |  |  |  |
| AC-bb127f30 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:994 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ if (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLAG"] !… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-bf48b160 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:998 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | MESSAGE | MessageBox.Show | ("FP Plan ID is required") | 메시지 표시 |  |  |  |
| AC-b4711a4f | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:999 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e96965e8 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1003 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | MESSAGE | MessageBox.Show | ("Plant is required") | 메시지 표시 |  |  |  |
| AC-f7885e15 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1004 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-83fd3d80 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1008 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | MESSAGE | MessageBox.Show | ("Date is required") | 메시지 표시 |  |  |  |
| AC-493d8a74 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1009 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-05fe5244 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1013 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | MESSAGE | MessageBox.Show | ("Line is required") | 메시지 표시 |  |  |  |
| AC-61fe119e | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1014 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e484eff8 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1018 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | MESSAGE | MessageBox.Show | ("Operation is required") | 메시지 표시 |  |  |  |
| AC-12be1814 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1019 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-90eae9d9 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1023 | try ▸ else of (Filter["DIVISION_ID"] == "") ▸ else of (Filter["FACTORY_ID"] == "") ▸ else of (Filter["PLAN_ID"] == "" && Filter["RELEASE_FLA… | DATA_OP | Filter["CHK_PLANID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-d9da09e8 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1055 | try ▸ if (bukInfo.Good()) | DATA_OP | Filter["BUCKET"] | cate_str | 행/컬럼 값 대입 |  |  |  |
| AC-c4eaf0b4 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1059 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["DAY2WEEK"] = ""; Filter["MONTH2WEEK"] = ""; Filte… | ⚠ 의미 확인 필요 |  |  |  |
| AC-07aa3b76 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1061 | try ▸ lambda | DATA_OP | Filter["DAY2WEEK"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2d02cd9f | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1062 | try ▸ lambda | DATA_OP | Filter["MONTH2WEEK"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9b5659af | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1063 | try ▸ lambda | DATA_OP | Filter["USER_ID"] | _CurrentUser | 행/컬럼 값 대입 |  |  |  |
| AC-4e1ff180 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1064 | try ▸ lambda | DATA_OP | Filter["GROUP_TRAY_ID"] | txt_group_id.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0ab33663 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1069 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00634_FIND_FP00634", Filter, _CurrentUser, pSysType) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-73757f31 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1071 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-66e21876 | popSql.OnSql [if (programID == "PR_UI_FP00634_FIND_FP00634")… 외 2 | FP00634_Tray_Simulation.cs:1075 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59f2ff78 | (진입점 미연결) | FP00634_Tray_Simulation.cs:883 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.fn_calTray

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97c8b821 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2463 | try | RETURN | return nTrayQty * nChk; |  | 처리 중단/반환 |  |  |  |
| AC-387046f7 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2466 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35e365e6 | this.Load | FP00634_Tray_Simulation.cs:193 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00634_Tray_Simulation.GetBasisTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (!dtPlanId.Good())] / cbo_fpplanid.SelectedIndexChanged / dp_plan_date.ValueChanged [if (!dtPlanId.Good())] / this.chk_rel.CheckedChanged [else of (Filter["RELEASE_FLAG"] == "Y") ▸ if (!dtPlanId.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5e651f3 | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:314 |  | FLAG | dtBaseTime | DataService.FP_ExecuteQuery2("PRAMEND_planamend", "findBasisTime", Filter.Dictionary, "Com… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] \| FP\Common\PRA… | 화면 필드/플래그 변경 |  |  |  |
| AC-f5857584 | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:314 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PRAMEND_planamend", "findBasisTime", Filter.Dictionary, "Common") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBasisTime] \| FP\Common\PRA… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2c311c26 | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:317 | if (dtBaseTime.Good()) | DATA_OP | Filter["BASIS_START_TIME"] | dtBaseTime.Rows[0]["BASIS_TIME"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.GetDivision

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged [if (!dtPlanId.Good())] / cbo_fpplanid.SelectedIndexChanged / dp_plan_date.ValueChanged [if (!dtPlanId.Good())] / this.chk_rel.CheckedChanged [else of (Filter["RELEASE_FLAG"] == "Y") ▸ if (!dtPlanId.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8d2d46b | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:323 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, this._CurrentUser, _sNonAuth, _sSaveAuth ,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdec9ffc | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:323 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, this._CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fcd37732 | this.Load [try] 외 4 | FP00634_Tray_Simulation.cs:325 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetFactory

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcbc2d4a | this.Load [try] | FP00634_Tray_Simulation.cs:347 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, _CurrentUser, _sNonAuth, _sSaveA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-640fe338 | this.Load [try] | FP00634_Tray_Simulation.cs:347 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1ce4b848 | this.Load [try] | FP00634_Tray_Simulation.cs:352 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetFpPlanId

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged / dp_plan_date.ValueChanged / this.chk_rel.CheckedChanged [else of (Filter["RELEASE_FLAG"] == "Y")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4718606a | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:297 | if (Filter["PLAN_DATE"] != "") | DATA_OP | Filter["CTRL_INSTANCE_DATE"] | "AND A.INSTANCE_DATE='" + Filter["PLAN_DATE"] + "' \r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-5be8b09b | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:298 | if (Filter["PLAN_DATE"] != "") | DATA_OP | Filter["CTRL_START_TIME"] | "AND CONVERT(VARCHAR(8), PLAN_START_TIME, 112) ='" + Filter["PLAN_DATE"] + "' \r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-0b33602f | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:301 | if (Filter["INSTANCE_ID"] != "") | DATA_OP | Filter["CTRL_INSTANCE"] | "AND A.INSTANCE_ID='" + Filter["INSTANCE_ID"] + "' \r\n" | 행/컬럼 값 대입 |  |  |  |
| AC-dd2cf4a5 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:302 |  | FLAG | dtPlanId | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "findFpPlan_info", Filter.Dictiona… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-dcee72a3 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:302 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "findFpPlan_info", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findFpPlan_info] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cbb7338b | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:303 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetInstance

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8277ff2b | this.Load [try] | FP00634_Tray_Simulation.cs:281 |  | FLAG | dtInstance | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "findInstanceList_common", Filter.… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList_common] \| FP\… | 화면 필드/플래그 변경 |  |  |  |
| AC-50cc3a8e | this.Load [try] | FP00634_Tray_Simulation.cs:281 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "findInstanceList_common", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findInstanceList_common] \| FP\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-98b57d36 | this.Load [try] | FP00634_Tray_Simulation.cs:283 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-7986661d | this.Load [try] | FP00634_Tray_Simulation.cs:285 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetInstanceTime

진입점: this.Load [try] / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af24a802 | this.Load [try] 외 1 | FP00634_Tray_Simulation.cs:290 |  | FLAG | dtPastInfo | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "find_isPast", Filter.Dictionary, … ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPast] \| FP\Planning\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-1cb633d4 | this.Load [try] 외 1 | FP00634_Tray_Simulation.cs:290 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "find_isPast", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPast] \| FP\Planning\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00634_Tray_Simulation.GetLine

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d0aa134 | this.Load [try] | FP00634_Tray_Simulation.cs:375 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dabd3919 | this.Load [try] | FP00634_Tray_Simulation.cs:381 |  | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-97a96968 | this.Load [try] | FP00634_Tray_Simulation.cs:396 | if (sInst != "" && sInst != null) | DATA_OP | Filter2["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91cbf5a7 | this.Load [try] | FP00634_Tray_Simulation.cs:414 | if (sInst != "" && sInst != null) | DATA_OP | Filter2["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-fcafe33d | this.Load [try] | FP00634_Tray_Simulation.cs:419 |  | DATA_OP | Filter2["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ba7318a | this.Load [try] | FP00634_Tray_Simulation.cs:432 |  | DATA_OP | Filter2["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-3b070250 | this.Load [try] | FP00634_Tray_Simulation.cs:434 |  | DATA_OP | Filter2["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-7883870c | this.Load [try] | FP00634_Tray_Simulation.cs:436 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "findLineCode_List", Filter2.Dicti… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-921b6b43 | this.Load [try] | FP00634_Tray_Simulation.cs:436 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "findLineCode_List", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d71b94f | this.Load [try] | FP00634_Tray_Simulation.cs:437 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetModel

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a7bbff1 | this.Load [try] | FP00634_Tray_Simulation.cs:443 |  | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_R" | 행/컬럼 값 대입 |  |  |  |
| AC-cfa0ae73 | this.Load [try] | FP00634_Tray_Simulation.cs:444 |  | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-57e2eca4 | this.Load [try] | FP00634_Tray_Simulation.cs:445 |  | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7a8dad8a | this.Load [try] | FP00634_Tray_Simulation.cs:446 |  | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7e398099 | this.Load [try] | FP00634_Tray_Simulation.cs:447 |  | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-7002d98f | this.Load [try] | FP00634_Tray_Simulation.cs:451 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_PLAN_FORM_H" | 행/컬럼 값 대입 |  |  |  |
| AC-0617da1f | this.Load [try] | FP00634_Tray_Simulation.cs:452 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-ddce78d0 | this.Load [try] | FP00634_Tray_Simulation.cs:453 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_PLAN_FORM_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-2c7945e0 | this.Load [try] | FP00634_Tray_Simulation.cs:454 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_PLAN_FORM_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-5858b16c | this.Load [try] | FP00634_Tray_Simulation.cs:455 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_PLAN_FORM_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-db579728 | this.Load [try] | FP00634_Tray_Simulation.cs:457 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-347a7b17 | this.Load [try] | FP00634_Tray_Simulation.cs:467 |  | FLAG | dtModel | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "find_Model_List", Filter2.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Model_List] \| FP\Planning… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f989a0b | this.Load [try] | FP00634_Tray_Simulation.cs:467 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "find_Model_List", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Model_List] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00634_Tray_Simulation.GetOperation

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b9fe5c1 | this.Load [try] | FP00634_Tray_Simulation.cs:368 |  | DATA_OP | Filter["CTRL_AMEND"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-99a55512 | this.Load [try] | FP00634_Tray_Simulation.cs:369 |  | FLAG | dtOperation | DataService.FP_ExecuteQuery2("FP00634_Tray_Simulation", "findOperationCode_common", Filter… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findOperationCode_common] \| FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-89e8ce2c | this.Load [try] | FP00634_Tray_Simulation.cs:369 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "findOperationCode_common", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findOperationCode_common] \| FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3a5c59cd | this.Load [try] | FP00634_Tray_Simulation.cs:370 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetPlant

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f04d0a8 | this.Load [try] | FP00634_Tray_Simulation.cs:339 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-128100a7 | this.Load [try] | FP00634_Tray_Simulation.cs:339 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e65bbe4 | this.Load [try] | FP00634_Tray_Simulation.cs:341 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetSite

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e7fdd51 | this.Load [try] | FP00634_Tray_Simulation.cs:330 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-c2e1f6bd | this.Load [try] | FP00634_Tray_Simulation.cs:330 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1de14d60 | this.Load [try] | FP00634_Tray_Simulation.cs:332 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00634_Tray_Simulation.GetToDay

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fed114d | (진입점 미연결) | FP00634_Tray_Simulation.cs:2412 |  | FLAG | _sToDay | dtDay.Date.ToString("yyyyMMdd") | 화면 필드/플래그 변경 |  |  |  |
| AC-dfc4a237 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2413 |  | RETURN | return _sToDay; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.GoEditMode

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try ▸ if (dsMainFiltered.Good())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6f0e665 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1533 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-92bb320c | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1553 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-7c41f18b | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1564 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null) | CALL_EXT | calendar.Days.Last | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b82131d1 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1567 | if (do_edit_mode) ▸ if (current_src != null) | GRID_STYLE | siMain.SetBGColor | (0, 0, current_src.Rows.Count - 1, day_start - 1, eoh_color) | 그리드 표시 설정 |  |  |  |
| AC-196057ba | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1583 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ switch (CATEGORY_ID) case "I_EOH": case "I_EOH_IN… | GRID_STYLE | siMain.SetBGColor | (rowindex, day_start, rowindex, day_end, eoh_color) | 그리드 표시 설정 |  |  |  |
| AC-1ec94e7d | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1596 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ for (i < (day_end - day_s… | GRID_LOCK | siMain.LockRange | (rowindex, colindex, rowindex, colindex, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-33855cc4 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1613 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-99bbb8c0 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1625 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.LockRange | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8dfbc37 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1626 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2908a122 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1638 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On && calendar != null) ▸ foreach (var week_item in calen… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightGreen) | 그리드 표시 설정 |  |  |  |
| AC-deabaff6 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1654 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On && calendar != null) ▸ if (month_measure != null && mo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00634_Tray_Simulation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-752da868 | this.Load | FP00634_Tray_Simulation.cs:256 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-152414ee | this.Load | FP00634_Tray_Simulation.cs:259 | try | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f9cd8d1 | this.Load | FP00634_Tray_Simulation.cs:261 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-90e02e62 | this.Load | FP00634_Tray_Simulation.cs:262 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-cb173350 | this.Load | FP00634_Tray_Simulation.cs:264 | try | DATA_OP | Filter["AMEND_INSTANCE"] | "PSI_AMEND_FORM" | 행/컬럼 값 대입 |  |  |  |
| AC-e2077632 | this.Load | FP00634_Tray_Simulation.cs:265 | try | DATA_OP | Filter["CTRL_SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c545e34b | this.Load | FP00634_Tray_Simulation.cs:266 | try | DATA_OP | Filter["SITE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-53833e7e | this.Load | FP00634_Tray_Simulation.cs:267 | try | DATA_OP | Filter["MASTER_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-60381461 | this.Load | FP00634_Tray_Simulation.cs:275 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00634_Tray_Simulation.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ee3e20c | this.Load | FP00634_Tray_Simulation.cs:231 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-081859aa | this.Load | FP00634_Tray_Simulation.cs:232 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fdd72e4e | this.Load | FP00634_Tray_Simulation.cs:233 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-059464e1 | this.Load | FP00634_Tray_Simulation.cs:234 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fdaf98a7 | this.Load | FP00634_Tray_Simulation.cs:235 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00634_Tray_Simulation.InitSpread

진입점: this.Load / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a400d5 | this.Load 외 2 | FP00634_Tray_Simulation.cs:635 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aedabaa7 | this.Load 외 2 | FP00634_Tray_Simulation.cs:636 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-622c8f44 | this.Load 외 2 | FP00634_Tray_Simulation.cs:638 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3cd977f5 | this.Load 외 2 | FP00634_Tray_Simulation.cs:642 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00634_Tray_Simulation.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e66ed6e2 | InsertButton | FP00634_Tray_Simulation.cs:840 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67ae7886 | InsertButton | FP00634_Tray_Simulation.cs:841 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.lfn_setActivated

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44de0b94 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2517 | lambda | DATA_OP | x.Field | ("TRAY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cc338b0 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2518 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9bd708f1 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2519 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a383e9af | this.spdMain.Change | FP00634_Tray_Simulation.cs:2520 | lambda | DATA_OP | x.Field | ("GROUP_TRAY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f880d280 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2521 | lambda | DATA_OP | x.Field | ("TRAY_FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1a773d87 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2522 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b759727 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2515 | lambda | RETURN | return ( x.Field<string>("TRAY_ID") == sTray && x.Field<string>("ITEM_ID") == sI… |  | 처리 중단/반환 |  |  |  |
| AC-d1f637d5 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2544 | if (ds_ListData != null) ▸ for (i < day_index + day_count) | GRID_SET | current_src.Rows[row_0_index][colname] | nVal - nOffSet | 그리드 속성/값 설정 |  |  |  |
| AC-24fa45d3 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2545 | if (ds_ListData != null) ▸ for (i < day_index + day_count) | GRID_SET | current_src.Rows[row_0_index + 1][colname] | nTrayQty | 그리드 속성/값 설정 |  |  |  |

## FP00634_Tray_Simulation.lfn_setInventory

진입점: this.spdMain.Change [if (ds_ListData != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ switch (CATEGORY_ID) case "I_EOH": ▸ if (day_end >= day_start)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ switch (CATEGORY_I…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b6f163 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1695 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-343d111f | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1696 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfb2cf7e | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1697 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-19ae3ae8 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1693 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-29cf6ae2 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1706 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8285f297 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1707 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7be59e2 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1708 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-548f3bdc | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1704 | if (sType != "X") ▸ if (sType == "D") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-438ba9b9 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1720 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4780fe70 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1721 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f57933f | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1722 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3335189e | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1722 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-557050a2 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1723 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fdb91ea7 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1718 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-1c5b4e3c | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1733 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e38584aa | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1734 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccfa4461 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1735 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-676e00ee | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1731 | if (sType != "X") ▸ else of (sType == "D") ▸ if (sType == "E") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-2d6f702f | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1747 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4a5111c6 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1748 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-35fd5a68 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1749 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-417ddc30 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1749 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f240b39 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1750 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c6d67199 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1745 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-0c8a3820 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1760 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bbc303e | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1761 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-6219acb8 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1762 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c2e17eb5 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1758 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ if (sType == "A") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-86719b70 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1774 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c10ccdaf | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1775 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-abc9bad6 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1776 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-38efcbb1 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1772 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-e42960c6 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1785 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4a3db0a | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1786 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-376eaef7 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1787 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd806b5d | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1783 | if (sType != "X") ▸ else of (sType == "D") ▸ else of (sType == "E") ▸ else of (sType == "A") ▸ if (sType == "X") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-76b89ce1 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1797 | if (sType != "X") ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7b3ee8c2 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1798 | if (sType != "X") ▸ lambda | DATA_OP | x.Field | ("GROUP_IDX") | 데이터 객체 조작/조회 |  |  |  |
| AC-86c4f81c | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1799 | if (sType != "X") ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca7d1f02 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1795 | if (sType != "X") ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == sDivision_Id && x.Field<long>("GROUP_… |  | 처리 중단/반환 |  |  |  |
| AC-79c96db3 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1834 | if (sType != "X") ▸ if (i_eoh_row >= 0) ▸ if (ds_totalValue != null && ds_ListData != null) ▸ for (i < index_of_start_day + day_count) | GRID_SET | current_src.Rows[i_eoh_row][colname] | nEoh | 그리드 속성/값 설정 |  |  |  |
| AC-b359db61 | this.spdMain.Change [if (ds_ListData != null)] 외 3 | FP00634_Tray_Simulation.cs:1835 | if (sType != "X") ▸ if (i_eoh_row >= 0) ▸ if (ds_totalValue != null && ds_ListData != null) ▸ for (i < index_of_start_day + day_count) | GRID_SET | current_src.Rows[i_eoh_row + 1][colname] | nInt | 그리드 속성/값 설정 |  |  |  |

## FP00634_Tray_Simulation.mcbo_division_changed

진입점: mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e9cacae | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1919 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.mcbo_factory_changed

진입점: mcbo_factory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c04e31 | mcbo_factory.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1946 |  | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.mcbo_line_changed

진입점: mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b1c6f3b | mcbo_line.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1965 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.mcbo_operation_changed

진입점: mcbo_operation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00644b95 | mcbo_operation.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1954 | try | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.mcbo_plant_changed

진입점: mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c909e7c5 | mcbo_plant.SelectedIndexChanged | FP00634_Tray_Simulation.cs:1940 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.planday_changed

진입점: dp_plan_date.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3e5a586 | dp_plan_date.ValueChanged | FP00634_Tray_Simulation.cs:2026 |  | DATA_OP | Filter["PLAN_DATE"] | dp_plan_date.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.RefreshHeader

진입점: this.Load [try ▸ else of (monthInfo == null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ try ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try ▸ if (dsMainFiltered.Good())] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-233efb7b | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1260 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-31e403ba | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1261 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-737f6cd9 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1262 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-8143ed44 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1263 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-960ac06c | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1269 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, bUse_month, bUse_week, bUse_day, 2, FPExtensions.DateColumnType.TYPEZERO, FPExt… | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d7ad01c | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1276 | if (monthInfo != null) ▸ if (tray_factory_idx >= 0) ▸ if (Filter["FACTORY_YN"].ToString().Equals("N")) | DATA_OP | siMain.ActiveSheet.ColumnHeader.Columns.Remove | (tray_factory_idx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bea4af0 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1280 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-4d44d6b0 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1284 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-55d7d599 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1289 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-952bd35f | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1291 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-70515f7e | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1292 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31169998 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1293 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e7502359 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1295 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-159243a2 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1296 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da862826 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1299 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3bc12a26 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1301 | if (monthInfo != null) | GRID_BIND | siMain.Query | (dsMainFiltered, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-155e5090 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1302 | if (monthInfo != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ee35e2f | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1305 | if (monthInfo != null) ▸ if (idx >= 0) | CALL_EXT | siMain.SetColumnFormat | (idx, 1, "#,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b5427c8 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1308 | if (monthInfo != null) ▸ if (idx >= 0) | CALL_EXT | siMain.SetColumnFormat | (idx, 1, "#,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e5df8ae | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1311 | if (monthInfo != null) ▸ if (idx >= 0) | CALL_EXT | siMain.SetColumnFormat | (idx, 1, "#,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f5794cc | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1314 | if (monthInfo != null) ▸ if (idx >= 0) | CALL_EXT | siMain.SetColumnFormat | (idx, 1, "#,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d96eb7ac | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1317 | if (monthInfo != null) ▸ if (idx >= 0) | CALL_EXT | siMain.SetColumnFormat | (idx, 1, "#,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aa0dd103 | this.Load [try ▸ else of (monthInfo == null)] 외 3 | FP00634_Tray_Simulation.cs:1319 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00634_Tray_Simulation.RefreshHeaderOnly

진입점: this.Load [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6a2a8bf | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:662 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-6300553b | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:670 | if (monthInfo == null) ▸ if (tray_factory_idx >= 0) ▸ if (Filter["FACTORY_YN"].ToString().Equals("N")) | DATA_OP | siMain.ActiveSheet.ColumnHeader.Columns.Remove | (tray_factory_idx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-614674e5 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:673 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-6458f4f9 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:674 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f175183 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:675 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92d5658b | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:676 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70970fd3 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:683 |  | UI_PROP | spdMain.HorizontalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-6923a433 | this.Load [try] 외 3 | FP00634_Tray_Simulation.cs:684 |  | UI_PROP | spdMain.VerticalScrollBarPolicy | FarPoint.Win.Spread.ScrollBarPolicy.Always | 속성 VerticalScrollBarPolicy 설정 |  |  |  |

## FP00634_Tray_Simulation.RefreshSpreadSheet

진입점: this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ec2d018 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1226 | try | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-3a476528 | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1233 | try ▸ if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9e7ac49f | this.btnColumn.Click [if (frm.DialogResult == DialogResult.O… 외 2 | FP00634_Tray_Simulation.cs:1244 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00634_Tray_Simulation.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-456ba14c | popSql.OnSql | FP00634_Tray_Simulation.cs:2422 | if (programID == "PR_UI_FP00634_FIND_FP00634") | RETURN | return FindMainData("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-a3eecb6f | popSql.OnSql | FP00634_Tray_Simulation.cs:2425 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a490412 | SaveButton | FP00634_Tray_Simulation.cs:862 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f9296300 | SaveButton | FP00634_Tray_Simulation.cs:863 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00634_Tray_Simulation.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2820df9 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1854 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c51e8699 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1855 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d363d5c | (진입점 미연결) | FP00634_Tray_Simulation.cs:1860 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7baace5 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1865 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d763931 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1866 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-84acfd55 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1867 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b5637541 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1868 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5c87155b | (진입점 미연결) | FP00634_Tray_Simulation.cs:1869 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4eda78b8 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1870 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbcaf30b | (진입점 미연결) | FP00634_Tray_Simulation.cs:1871 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-42af2067 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1872 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ad314f7 | (진입점 미연결) | FP00634_Tray_Simulation.cs:1876 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetChangeControl

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab60174b | this.Load [try] | FP00634_Tray_Simulation.cs:557 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-37cd4d7a | this.Load [try] | FP00634_Tray_Simulation.cs:561 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e93d51f9 | this.Load [try] | FP00634_Tray_Simulation.cs:563 |  | DATA_OP | Filter["FACTORY_YN"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["FACTORY_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-abf47ce0 | this.Load [try] | FP00634_Tray_Simulation.cs:567 |  | DATA_OP | Filter["CURR_DATE"] | dtPastInfo.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f573f409 | this.Load [try] | FP00634_Tray_Simulation.cs:568 |  | DATA_OP | Filter["PLAN_DATE"] | dtPastInfo.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c582a55c | this.Load [try] | FP00634_Tray_Simulation.cs:569 |  | DATA_OP | Filter["BUCKET_FROM"] | dtPastInfo.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ccab931 | this.Load [try] | FP00634_Tray_Simulation.cs:570 |  | DATA_OP | Filter["BUCKET_TO"] | dtPastInfo.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4b01e7fc | this.Load [try] | FP00634_Tray_Simulation.cs:581 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3564c3bd | this.Load [try] | FP00634_Tray_Simulation.cs:586 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fb55250f | this.Load [try] | FP00634_Tray_Simulation.cs:589 |  | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c90417e6 | this.Load [try] | FP00634_Tray_Simulation.cs:592 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-41ae5029 | this.Load [try] | FP00634_Tray_Simulation.cs:595 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8cc19e11 | this.Load [try] | FP00634_Tray_Simulation.cs:603 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-94d267af | this.Load [try] | FP00634_Tray_Simulation.cs:605 |  | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2", Filter, "") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eb2f71b6 | this.Load [try] | FP00634_Tray_Simulation.cs:606 |  | FLAG | bukInfo | bukList | 화면 필드/플래그 변경 |  |  |  |
| AC-7f44e61e | this.Load [try] | FP00634_Tray_Simulation.cs:607 |  | VALUE_SET | dp_plan_date.Text | Filter["PLAN_DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-cb28bc4b | this.Load [try] | FP00634_Tray_Simulation.cs:608 |  | UI_PROP | rp_plan_period.Text1 | Filter["BUCKET_FROM"] | 속성 Text1 설정 |  |  |  |
| AC-83d231f3 | this.Load [try] | FP00634_Tray_Simulation.cs:609 |  | UI_PROP | rp_plan_period.Text2 | Filter["BUCKET_TO"] | 속성 Text2 설정 |  |  |  |

## FP00634_Tray_Simulation.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09a9273d | this.Load | FP00634_Tray_Simulation.cs:216 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c6136675 | this.Load | FP00634_Tray_Simulation.cs:217 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-cb696829 | this.Load | FP00634_Tray_Simulation.cs:218 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-0f0babef | this.Load | FP00634_Tray_Simulation.cs:222 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c0750089 | this.Load | FP00634_Tray_Simulation.cs:223 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b2562ba5 | this.Load | FP00634_Tray_Simulation.cs:224 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00634_Tray_Simulation.SetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e8d642e | (진입점 미연결) | FP00634_Tray_Simulation.cs:2241 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-96aae8dc | (진입점 미연결) | FP00634_Tray_Simulation.cs:2241 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"]) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cbc37d55 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2242 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4251a1cc | (진입점 미연결) | FP00634_Tray_Simulation.cs:2244 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetFactory

진입점: mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78d3a92f | mcbo_plant.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2272 |  | FLAG | dtFactoryAmend | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findFactoryCode_amend_comm… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e82eba13 | mcbo_plant.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2272 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findFactoryCode_amend_common", Filter["INSTANCE_ID"], Filter["PL… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-04d19921 | mcbo_plant.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2275 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55ded95d | mcbo_plant.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2283 |  | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetLine

진입점: mcbo_operation.SelectedIndexChanged [try] / this.chk_all_line.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe3e0fe7 | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2313 |  | FLAG | dtLine | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00603_findLineCode_List", Filter… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-e9a1f6f7 | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2313 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_findLineCode_List", Filter["INSTANCE_ID"], Filter["PLAN_ID"] , F… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9011c90e | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2317 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-63cd7e77 | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2319 |  | FLAG | dtActLine | dtLine.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5a4f2c34 | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2319 |  | DATA_OP | dtLine.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6417a0d0 | mcbo_operation.SelectedIndexChanged [try] 외 1 | FP00634_Tray_Simulation.cs:2327 |  | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetOperation

진입점: mcbo_factory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e471e78 | mcbo_factory.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2289 |  | FLAG | dtOperation | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00594_findOperationCode_common",… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-28e7d3dd | mcbo_factory.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2289 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00594_findOperationCode_common", Filter["INSTANCE_ID"] , Filter["DIVIS… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d23d3378 | mcbo_factory.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2291 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-06748de9 | mcbo_factory.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2295 |  | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetPlanDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf1c2ca5 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2332 |  | DATA_OP | Filter["PLAN_DATE"] | GetToDay() | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetPlanGroup

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ede3a7c8 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2224 |  | FLAG | dtInstance | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00603_findInstanceList_common", … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-0ec9ffb7 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2224 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_findInstanceList_common", lv_amendInstance, _sSaveAuth) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe6c2b9d | (진입점 미연결) | FP00634_Tray_Simulation.cs:2225 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a489abc1 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2227 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-dd366892 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2230 | if (dtInstance.Rows.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[0]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-910ddf99 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2232 | else of (dtInstance.Rows.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-63ea0523 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2234 |  | DATA_OP | Filter["FACTORY_YN"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["FACTORY_YN"].ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetPlanPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90c59afd | (진입점 미연결) | FP00634_Tray_Simulation.cs:2343 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLAN_PERIOD_PLAN_RESULT_AMEND, false, _CurrentUser, _sNonAuth, _sSaveAuth, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLAN_PERIOD_PLAN_RESULT_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94276497 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2358 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | rp_plan_period.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-405288af | (진입점 미연결) | FP00634_Tray_Simulation.cs:2359 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ if (string.IsNullOrEmpty(sStartDate)) | UI_PROP | rp_plan_period.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-f1366b88 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2363 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | rp_plan_period.Value2 | dDefalultEndDate | 속성 Value2 설정 |  |  |  |
| AC-e6399915 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2364 | if (dtPeriod != null) ▸ if (dtPeriod.Rows.Count > 0) ▸ else of (string.IsNullOrEmpty(sStartDate)) | UI_PROP | rp_plan_period.Value1 | dDefalultStartDate | 속성 Value1 설정 |  |  |  |
| AC-d0fdb64b | (진입점 미연결) | FP00634_Tray_Simulation.cs:2370 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | rp_plan_period.Value2 | DateTime.Now.AddDays(56) | 속성 Value2 설정 |  |  |  |
| AC-fd05e816 | (진입점 미연결) | FP00634_Tray_Simulation.cs:2371 | if (dtPeriod != null) ▸ else of (dtPeriod.Rows.Count > 0) | UI_PROP | rp_plan_period.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |

## FP00634_Tray_Simulation.SetPlant

진입점: cbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-671801ae | cbo_site.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2261 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter[… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-f6bd75bc | cbo_site.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2261 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, _CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3d5327c1 | cbo_site.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2263 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-775060b4 | cbo_site.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2265 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetProdType

진입점: mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab5e9531 | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2300 |  | FLAG | dtProdType | DataCommon.GetPlannnigUserFormCodeData(_FormProcedure, "FP00603_find_FPProdType", Filter["… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 화면 필드/플래그 변경 |  |  |  |
| AC-6d989ade | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2300 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00603_find_FPProdType", Filter["INSATNCE_ID"], Filter["DIVISION_ID"]) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00634_Tray_Simulation.SetSite

진입점: mcbo_division.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cee64fa | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2250 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-4df24ad0 | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2250 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, _CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1380a301 | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2251 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cbo_site, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f635bbb3 | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2254 | if (dtSite.Rows.Count == 1) | VALUE_SET | cbo_site.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-bb53bd1d | mcbo_division.SelectedIndexChanged | FP00634_Tray_Simulation.cs:2256 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.SetSpreadInit

진입점: this.Load [try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d15bf53d | this.Load [try] 외 2 | FP00634_Tray_Simulation.cs:650 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a1a32060 | this.Load [try] 외 2 | FP00634_Tray_Simulation.cs:651 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00634_Tray_Simulation.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2703a1ac | this.spdMain.CellDoubleClick | FP00634_Tray_Simulation.cs:2199 | try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef0af5b8 | this.spdMain.CellDoubleClick | FP00634_Tray_Simulation.cs:2204 | try ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-49eaf9c9 | this.spdMain.CellDoubleClick | FP00634_Tray_Simulation.cs:2211 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00634_Tray_Simulation.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-614c52c9 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2566 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ef7a602c | this.spdMain.Change | FP00634_Tray_Simulation.cs:2572 |  | CALL_EXT | colindexstr.SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a501d2e1 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2579 |  | DATA_OP | row[colname] | old_value | 행/컬럼 값 대입 |  |  |  |
| AC-dc919672 | this.spdMain.Change | FP00634_Tray_Simulation.cs:2586 | if (rowindex + 1 < current_src.Rows.Count) | GRID_SET | current_src.Rows[rowindex + 1][colname] | nTrayQty | 그리드 속성/값 설정 |  |  |  |
| AC-50b9c6ff | this.spdMain.Change | FP00634_Tray_Simulation.cs:2588 |  | DATA_OP | row.Table.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-30fe057d | this.spdMain.Change | FP00634_Tray_Simulation.cs:2594 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00634_Tray_Simulation.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71d6ebe2 | this.spdMain.EditModeOn | FP00634_Tray_Simulation.cs:2599 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00634_Tray_Simulation.TxtModel_TextChanged

진입점: txt_group_id.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-421ffcbf | txt_group_id.TextChanged | FP00634_Tray_Simulation.cs:2021 |  | DATA_OP | Filter["TOP_ITEM_ID"] | txt_group_id.Text | 행/컬럼 값 대입 |  |  |  |

## FP00634_Tray_Simulation.UIFindData

진입점: FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a799bf54 | FindButton 외 1 | FP00634_Tray_Simulation.cs:711 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4a12cf3d | FindButton 외 1 | FP00634_Tray_Simulation.cs:712 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93afebc4 | FindButton 외 1 | FP00634_Tray_Simulation.cs:715 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3c68fa05 | FindButton 외 1 | FP00634_Tray_Simulation.cs:718 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae7f4df2 | FindButton 외 1 | FP00634_Tray_Simulation.cs:721 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | measure | null | 화면 필드/플래그 변경 |  |  |  |
| AC-542fc498 | FindButton 외 1 | FP00634_Tray_Simulation.cs:724 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!chk_rel.Checked) | DATA_OP | Filter["CHK_PLANID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-e462d20c | FindButton 외 1 | FP00634_Tray_Simulation.cs:725 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!chk_rel.Checked) | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00634_Tray_Simulation", "chk_PlanId", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=chk_PlanId] \| FP\Planning\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9352ec45 | FindButton 외 1 | FP00634_Tray_Simulation.cs:728 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!chk_rel.Checked) ▸ if (dtChkPlan.Good()) | MESSAGE | MessageBox.Show | ("Assy Plan release version exists.\nDo you want to include it ? ", "Check release", Messa… | 메시지 표시 |  |  |  |
| AC-e5523e3f | FindButton 외 1 | FP00634_Tray_Simulation.cs:731 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (!chk_rel.Checked) ▸ if (dtChkPlan.Good()) ▸ if (MessageBox.Show("Assy Plan… | DATA_OP | Filter["CHK_PLANID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-0a8e8bac | FindButton 외 1 | FP00634_Tray_Simulation.cs:740 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (prg == null) | FLAG | prg | new GSCM.Windows.Forms.UI.ProgressForm() | 화면 필드/플래그 변경 |  |  |  |
| AC-f3be684c | FindButton 외 1 | FP00634_Tray_Simulation.cs:740 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (prg == null) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0ed545bc | FindButton 외 1 | FP00634_Tray_Simulation.cs:747 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (string.IsNullOrWhiteSpace(sDivision)) | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues, "CODE") | 행/컬럼 값 대입 |  |  |  |
| AC-2080f01d | FindButton 외 1 | FP00634_Tray_Simulation.cs:751 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ffdc5991 | FindButton 외 1 | FP00634_Tray_Simulation.cs:752 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b885a3a2 | FindButton 외 1 | FP00634_Tray_Simulation.cs:754 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6b8bbbf2 | FindButton 외 1 | FP00634_Tray_Simulation.cs:757 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cc4dd4ee | FindButton 외 1 | FP00634_Tray_Simulation.cs:758 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-edc88850 | FindButton 외 1 | FP00634_Tray_Simulation.cs:761 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-378af9db | FindButton 외 1 | FP00634_Tray_Simulation.cs:770 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f48d3310 | FindButton 외 1 | FP00634_Tray_Simulation.cs:772 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData() ) | 화면 필드/플래그 변경 |  |  |  |
| AC-9558ace2 | FindButton 외 1 | FP00634_Tray_Simulation.cs:772 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData() ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e02a6ea4 | FindButton 외 1 | FP00634_Tray_Simulation.cs:782 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ if (dsMain.Good()) | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f78a8fcd | FindButton 외 1 | FP00634_Tray_Simulation.cs:808 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a19a9ab8 | FindButton 외 1 | FP00634_Tray_Simulation.cs:814 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | prg.Hide | () | 창 닫기/해제 |  |  |  |
| AC-37e7b8ca | FindButton 외 1 | FP00634_Tray_Simulation.cs:816 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9e0ca9df | FindButton 외 1 | FP00634_Tray_Simulation.cs:827 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-13672862 | FindButton 외 1 | FP00634_Tray_Simulation.cs:831 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

