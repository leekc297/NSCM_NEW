# AS-IS 액션 대조표 — FP00609

> 원천: `Doc/asisfacts/screens/FP00609/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 852행 · 메서드 126 · 종류 DATA_OP 308 · FLAG 95 · RETURN 73 · UI_PROP 61 · CALL_EXT 48 · VALUE_SET 42 · MESSAGE 37 · ENDPOINT 32 · UI_MISC 30 · GRID_INIT 22 · STATE 20 · POPUP 18 · GRID_STYLE 12 · GRID_SET 12 · GRID_LOCK 11 · THROW 8 · LIST_REBIND 7 · COMBO_DATA 4 · CALL_BASE 4 · LIST_BIND 2 · STATE_RESET 2 · VALUE_CLEAR 1 · EXCEL 1 · LIST_CLEAR 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 52


## FP00609_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b0d3fe8 | .ctor | FP00609_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-df1a8785 | .ctor | FP00609_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-16e4fa77 | .ctor | FP00609_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-c18f062c | .ctor | FP00609_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00609_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7b0c867 | Dispose | FP00609_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00609_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a5734db | this.Load | FP00609_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00609_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8978142f | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:137 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-f0089d3d | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:143 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-285675f7 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-d38a8ca1 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-91fcb1f6 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-5c7dfdd3 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-2a47cce1 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-52256045 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-9655c64d | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00609_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a0f5a37 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-94fbb502 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4c5fefd1 | this.Load 외 1 | FP00609_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00609_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c596db3 | (진입점 미연결) | FP00609_BucketSetForm_Popup.cs:225 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-c8b1a0f5 | (진입점 미연결) | FP00609_BucketSetForm_Popup.cs:236 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6ddfdb88 | (진입점 미연결) | FP00609_BucketSetForm_Popup.cs:247 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00609_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7feae0e | this.Load | FP00609_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f035f76d | this.Load | FP00609_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00609_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70569503 | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-9c297595 | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-f0afbf6a | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-e020bf0b | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-baa34830 | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-5b4a6337 | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-946389c8 | this.usrButton1.Click | FP00609_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00609_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e503907 | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-ffb0ca07 | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d4928041 | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-bef9e4a6 | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-055b8a3f | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-cedb6fd1 | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5161b17f | this.usrButton2.Click | FP00609_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00609_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6a538c9 | .ctor | FP00609_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-21470885 | .ctor | FP00609_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-2a20b09c | .ctor | FP00609_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-99203918 | .ctor | FP00609_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00609_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-690baa52 | Dispose | FP00609_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00609_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a104b11a | this.Load | FP00609_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00609_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3d22e8e | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:156 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-af1ddbc4 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:157 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-37b186c2 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:184 |  | DATA_OP | ctrls.Add | (chk_assy) | 데이터 객체 조작/조회 |  |  |  |
| AC-8439a0c2 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:185 |  | DATA_OP | ctrls.Add | (chk_post) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdc4e2ec | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:187 |  | DATA_OP | ctrls.Add | (chk_coaterBatch) | 데이터 객체 조작/조회 |  |  |  |
| AC-f972be1b | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:188 |  | DATA_OP | ctrls.Add | (chk_coater) | 데이터 객체 조작/조회 |  |  |  |
| AC-98ef87bf | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:190 |  | DATA_OP | ctrls.Add | (chk_inv) | 데이터 객체 조작/조회 |  |  |  |
| AC-9239cead | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:193 |  | DATA_OP | ctrls.Add | (chk_subtotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-22a691e7 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:194 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-8956163c | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:197 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7baa001 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:197 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-6a93aa26 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:204 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-6ee966dd | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:208 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-1ab38487 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:212 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00609_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9baa882b | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:124 |  | VALUE_SET | chk_assy.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-89997117 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:125 |  | VALUE_SET | chk_post.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-77d8e2c4 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_coaterBatch.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0b5657a0 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:128 |  | VALUE_SET | chk_coater.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1ec2d5dd | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_inv.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0fd9eaf3 | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:135 |  | VALUE_SET | chk_subtotal.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0c5713dc | this.Load 외 1 | FP00609_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_total.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00609_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1babf906 | (진입점 미연결) | FP00609_MeasureSetForm_Popup.cs:272 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-222ab26f | (진입점 미연결) | FP00609_MeasureSetForm_Popup.cs:283 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aeff20e1 | (진입점 미연결) | FP00609_MeasureSetForm_Popup.cs:294 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP00609_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dd745f2 | this.Load | FP00609_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6355b22a | this.Load | FP00609_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00609_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db5c5ba9 | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:256 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-6b76f31a | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:256 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-614e8169 | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:258 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-ac39d371 | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:262 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-d6609b69 | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:263 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6bd5d4d0 | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:265 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e58f716a | this.usrButton1.Click | FP00609_MeasureSetForm_Popup.cs:267 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00609_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e12e21fe | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:230 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-715c4fab | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:230 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-15576fa1 | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:232 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-0fa4659b | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:236 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-7f8e4c7d | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:237 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-71557d07 | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:238 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-e8cbd39c | this.usrButton2.Click | FP00609_MeasureSetForm_Popup.cs:239 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34dfc8cb | .ctor | FP00609_Pancake_Simul_By_Bld_Elec.cs:160 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / InsertButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8962bcce | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2472 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-09ff15d4 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2473 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8fd40f25 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2474 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cc32070a | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2475 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6fa29e70 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2476 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-19551059 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2479 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00609_Pancake_Simul_By_Bld_Elec", "find_WeekCnt", Filter.Di… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-687737bb | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2479 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00609_Pancake_Simul_By_Bld_Elec", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2258922c | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2480 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00609_Pancake_Simul_By_Bld_Elec", "find_DateMap", Filter.Di… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-954aa687 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2480 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00609_Pancake_Simul_By_Bld_Elec", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b4fdb458 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2481 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00609_Pancake_Simul_By_Bld_Elec", "find_MonthCnt", Filter.D… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-00fde7bb | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2481 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00609_Pancake_Simul_By_Bld_Elec", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9d76368a | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2482 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00609_Pancake_Simul_By_Bld_Elec", "find_BukInfo", Filter.Di… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f857fb9 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2482 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00609_Pancake_Simul_By_Bld_Elec", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f85a2a9e | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2494 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-1f753942 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2495 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-42a64234 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2496 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-b427700e | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2497 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / InsertButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2155cf80 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2502 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (GetFilter("INSTANCE_ID") == "") { SetFilter("INSTANCE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2d1b8e30 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2510 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-15c9be89 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2511 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-412d0e54 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2512 | lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-1ea4e403 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2517 | lambda ▸ if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-24d746af | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2520 | lambda | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-47ee853e | this.btnBucket.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3646 |  | POPUP | new FP00609_BucketSetForm_Popup | ("FP00609", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-dadb920b | this.btnBucket.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3648 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-22db889b | this.btnBucket.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3649 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ef4049e0 | this.btnBucket.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3650 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3c254916 | this.btnBucket.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3654 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24055b89 | this.btnCategory.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3613 |  | POPUP | new FP00609_MeasureSetForm_Popup | ("FP00609", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-e9b8ae4d | this.btnCategory.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3615 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-b583bc18 | this.btnCategory.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3616 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9614f2ab | this.btnCategory.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3617 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-310bc245 | this.btnCategory.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3621 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f25a528e | this.btnColumn.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3595 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP00609", SpdSheet.shtPlanAmendMA, true, clbBuilding.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-0f4c7725 | this.btnColumn.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3596 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a67837fa | this.btnColumn.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3597 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b78c5dd | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3687 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다.") | 메시지 표시 |  |  |  |
| AC-e278754f | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3688 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a1ca5e2 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3691 |  | POPUP | new FP00609_PlanInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a92e414e | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3692 |  | UI_PROP | planInfoPopup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-c9851248 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3692 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10d3d3a6 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3693 |  | DATA_OP | planInfoPopup.Filter["MASTER_ID"] | planInfoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-06700049 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3693 |  | DATA_OP | planInfoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ab3e553f | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3694 |  | DATA_OP | planInfoPopup.Filter["CONFIRM_AREA"] | Filter["CONFIRM_AREA"] | 행/컬럼 값 대입 |  |  |  |
| AC-5429a549 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3695 |  | DATA_OP | planInfoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-195fd6d9 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3697 |  | DATA_OP | planInfoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-7f1cbb03 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3698 |  | DATA_OP | planInfoPopup.Filter["RELEASE_FLAG"] | Filter["RELEASE_FLAG"] | 행/컬럼 값 대입 |  |  |  |
| AC-74dad9ca | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3699 |  | DATA_OP | planInfoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b502d39 | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3700 |  | DATA_OP | planInfoPopup.Filter["PROG_ID"] | "FP00609" | 행/컬럼 값 대입 |  |  |  |
| AC-bb63d8bd | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3702 |  | UI_PROP | planInfoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d775777f | this.btnPlanInfo.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3703 |  | POPUP | planInfoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-499dde19 | this.btnSql.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:1617 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0967d5e6 | this.btnSql.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:1618 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ddd2bb03 | this.btnSql.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:1620 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd47d980 | this.btnSql.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:1621 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5c2d59d | this.btnToggleSave.Click | FP00609_Pancake_Simul_By_Bld_Elec.cs:3679 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.cboInstance_changed

진입점: cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ced10be | cboInstance.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3376 |  | STATE | chk_rel.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1e57be5d | cboInstance.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3377 |  | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b69013c5 | cboInstance.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3390 | if (chk_rel.Checked) | STATE | drpPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f018dada | cboInstance.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3391 | if (chk_rel.Checked) | STATE | cboPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-15f8455e | cboInstance.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3393 | if (chk_rel.Checked) | VALUE_CLEAR | cboPlanId.SelectedIndex | -1 | 컨트롤 값 비움 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.cboPlanId_changed

진입점: cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a18fbeb | cboPlanId.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3410 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7664c33c | cboPlanId.SelectedIndexChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3411 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75b76034 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:419 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e2eb3fa | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:419 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-0d864ff5 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:421 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00609_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cdd28611 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:421 |  | POPUP | new FP00609_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-23e752fa | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:422 |  | CALL_EXT | MeasureService.MakeDefault | (new FP00609_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7dea46f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:422 |  | POPUP | new FP00609_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-783ef011 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:424 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-11479298 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:425 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-f676ebb8 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:426 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf9bd80 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:427 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-d34fe914 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:428 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-359ce36a | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:429 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.chk_omit_zero_CheckedChanged

진입점: chk_omit_zero.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30477dfe | chk_omit_zero.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:4315 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3f812282 | chk_omit_zero.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:4317 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.chk_rel_CheckedChanged

진입점: chk_rel.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2fa1a96 | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3469 | if (chk_rel.Checked) | STATE | cboPlanId.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aed20761 | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3481 | if (chk_rel.Checked) | STATE | drpPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-78fa5465 | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3482 | if (chk_rel.Checked) | DATA_OP | Filter["BUCKET_FROM"] | Filter["CURR_DATE"] = Filter["PLAN_DATE"] = dtCurrDate.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-844aea8c | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3482 | if (chk_rel.Checked) | DATA_OP | Filter["CURR_DATE"] | Filter["PLAN_DATE"] = dtCurrDate.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9f73b497 | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3482 | if (chk_rel.Checked) | DATA_OP | Filter["PLAN_DATE"] | dtCurrDate.Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7375960b | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3484 | if (chk_rel.Checked) | VALUE_SET | drpPlanDate.Value | drpPeriod.Value1 = DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-6490454d | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3484 | if (chk_rel.Checked) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-5f222559 | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3488 | else of (chk_rel.Checked) | STATE | cboPlanId.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68bc7dbe | chk_rel.CheckedChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3489 | else of (chk_rel.Checked) | STATE | drpPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-521b02b9 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3285 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-31a385e7 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3287 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0df9eea | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3288 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f288a878 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3289 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-caf70e92 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3290 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ec332ea5 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3291 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3df9437 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3292 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a0b534c | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3293 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b7878dec | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3294 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cedb200b | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3295 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bb72161 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3296 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-96fe73e2 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3297 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd6182b4 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3298 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-50a55249 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3299 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbe202ea | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3300 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-920d7cf3 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3301 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b00bcde1 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3302 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53d75d14 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3303 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1476bfde | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3304 |  | DATA_OP | dt.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-92eb7db9 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3305 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a03afc37 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3306 |  | DATA_OP | dt.Columns.SafeAdd | ("BOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5af0a73f | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3307 |  | DATA_OP | dt.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e87693cb | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3308 |  | DATA_OP | dt.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-303be79a | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3309 |  | DATA_OP | dt.Columns.SafeAdd | ("SALES_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b70b6b51 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3310 |  | DATA_OP | dt.Columns.SafeAdd | ("EOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b213618 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3311 |  | DATA_OP | dt.Columns.SafeAdd | ("YIELD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b4086c8 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3314 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8abf07d5 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3315 |  | DATA_OP | dt.Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f98aa06 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3316 |  | DATA_OP | dt.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-732cd759 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3318 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e92d2251 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3319 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d475e21 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3320 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a8a9058f | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3321 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdebce01 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3323 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e9727a4 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3324 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f0cfdb3 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3325 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0e3781ec | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3326 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-35d9dd11 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3328 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9a881494 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3329 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-315f1839 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3330 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b37ea60 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3331 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-79d6cd4d | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3333 |  | DATA_OP | dt.Columns.SafeAdd | ("EIDX", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f92bc49c | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3334 |  | DATA_OP | dt.Columns.SafeAdd | ("EQTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f853ed84 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3335 |  | DATA_OP | dt.Columns.SafeAdd | ("EDATE", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2322806d | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3337 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-14c757ee | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3338 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f620eb69 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3343 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8edd457 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:3346 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.CreateFilterDataSet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb97e54e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1635 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-c85b85bf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1646 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-d2f0eff4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1647 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-30e5a93a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1657 | if (measure["chk_assy"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "ASSY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d3b0165 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1661 | if (measure["chk_post"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "POST")) | 데이터 객체 조작/조회 |  |  |  |
| AC-51bac7bb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1665 | if (measure["chk_coaterBatch"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "COATER_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce784126 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1669 | if (measure["chk_coater"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "COATER")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fa247a2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1673 | if (measure["chk_shipment"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-678c2198 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1677 | if (measure["chk_shipmentIn"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SHIP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-903afa4a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1681 | if (measure["chk_inv"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "INV")) | 데이터 객체 조작/조회 |  |  |  |
| AC-91c14eb5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1687 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "ASSY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e503b8c7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1688 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "POST")) | 데이터 객체 조작/조회 |  |  |  |
| AC-99e1c859 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1689 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "COATER_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-175efb74 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1690 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "COATER")) | 데이터 객체 조작/조회 |  |  |  |
| AC-404c8ae1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1691 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b6bb3ab | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1692 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "SHIP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbd9c88b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1693 | if (measure["chk_subtotal"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL", "INV")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc3de14b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1699 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "ASSY")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb5e488d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1700 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "POST")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a067fda | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1701 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "COATER_BATCH")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a169d6df | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1702 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "COATER")) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ac5f1bf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1703 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SHIP")) | 데이터 객체 조작/조회 |  |  |  |
| AC-d35b7190 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1704 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SHIP_IN")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fdb67b5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1705 | if (measure["chk_total"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "INV")) | 데이터 객체 조작/조회 |  |  |  |
| AC-b65a4825 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1709 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5394b327 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1713 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-be263e18 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1717 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34cf2b5d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1720 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-49ae8b6c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1722 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40019d45 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:291 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8d7a2973 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:292 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-84216b0f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:293 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ea810eb | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:296 |  | FLAG | dtListData | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-367458f3 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:297 |  | DATA_OP | dtListData.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fb17420 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:298 |  | DATA_OP | dtListData.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-39e9fd0e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:299 |  | DATA_OP | dtListData.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7efd1b64 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:300 |  | DATA_OP | dtListData.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-81787a05 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:301 |  | DATA_OP | dtListData.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ceb8d849 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:302 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-29126e40 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:303 |  | DATA_OP | dtListData.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5231e864 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:304 |  | DATA_OP | dtListData.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fac6fad9 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:305 |  | DATA_OP | dtListData.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0168b56e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:306 |  | DATA_OP | dtListData.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b06c40bf | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:307 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2179d642 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:308 |  | DATA_OP | dtListData.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e00076c2 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:309 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60019d72 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:310 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fec6662 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:311 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba02a57e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:312 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-72492dd3 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:313 |  | DATA_OP | dtListData.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8aa36519 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:314 |  | DATA_OP | dtListData.Columns.SafeAdd | ("IS_PREV_SCHEDULE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-33cbea0c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:316 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9abf1783 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:317 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_IN_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49c72048 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:318 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-018df9c9 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:319 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82834b43 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:321 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c6f35a5 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:322 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_OUT_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-916a999e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:323 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-59ae3cd2 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:324 |  | DATA_OP | dtListData.Columns.SafeAdd | ("PLAN_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de6d62aa | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:326 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de1af3fd | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:327 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-598aaaa4 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:328 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea018a4c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:329 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1d65e77 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:330 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2cccc454 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:332 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bae5cf6 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:333 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13f42ebf | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:334 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cf94207 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:335 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eab277c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:336 |  | DATA_OP | dtListData.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-004e60c6 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:338 |  | DATA_OP | dtListData.Columns.SafeAdd | ("TOTAL_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-76f73b54 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:340 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0f4fa27 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:341 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_IN_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1f253e4 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:342 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c0ae325 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:343 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd866720 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:344 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c5f1ca3 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:346 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a4d8291 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:347 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_OUT_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e56b0c54 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:348 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea6345ee | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:349 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-df0ac65d | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:350 |  | DATA_OP | dtListData.Columns.SafeAdd | ("MPP_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9db676b0 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:352 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-91d21919 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:353 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_IN_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-013fb452 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:354 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6699655 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:355 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b329ac1 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:356 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad3d7325 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:358 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-48181949 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:359 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_OUT_QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-831a0b4d | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:360 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb9a7516 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:361 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-846b5a4d | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:362 |  | DATA_OP | dtListData.Columns.SafeAdd | ("WPP_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-13463966 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:364 |  | DATA_OP | dtListData.Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-72560cd5 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:366 |  | LIST_BIND | dgEdit.DataSource | dtListData | 목록/그리드 데이터 원천 연결 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d677053 | DeleteButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:967 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8be24dfc | Dispose | FP00609_Pancake_Simul_By_Bld_Elec.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-443f56ad | drpPeriod.ValueChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3565 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-467582c7 | drpPeriod.ValueChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3572 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-32e21697 | drpPeriod.ValueChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3573 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.ds_List01_cancolumnchange

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ if (!Clipboard)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < co…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97a55964 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3056 | if (clicked_row == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d139b24a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3064 | if (bM != -1 && bC != -1 && bJ != -1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b323b29e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3066 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25a9b504 | EditButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:975 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-7a383e29 | EditButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:977 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1108ae60 | ExcelButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2130 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / InsertButton [if (row != null) ▸ if (popup…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ba4b9f1 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2389 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-89a64804 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2395 | try ▸ if (!chk_rel.Checked) | FLAG | dtChkPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-ef0362c4 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2395 | try ▸ if (!chk_rel.Checked) | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CHK_PLAN_ID") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7f97d35d | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2399 | try ▸ if (!chk_rel.Checked) ▸ if (dtChkPlanId.Good()) | MESSAGE | MessageBox.Show | ("Assy Plan release version exists.\nDo you want to include it?", "Assy plan", MessageBoxB… | 메시지 표시 |  |  |  |
| AC-b4741512 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2402 | try ▸ if (!chk_rel.Checked) ▸ if (dtChkPlanId.Good()) ▸ if (MessageBox.Show("Assy Plan release version exists.\nDo you want to include it?",… | FLAG | sPlanInfo | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0bf9cac | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2407 | try ▸ if (!chk_rel.Checked) ▸ if (dtChkPlanId.Good()) ▸ else of (MessageBox.Show("Assy Plan release version exists.\nDo you want to include … | FLAG | sPlanInfo | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-6b3755b3 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2412 | try ▸ if (!chk_rel.Checked) ▸ else of (dtChkPlanId.Good()) | FLAG | sPlanInfo | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-0c299908 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2417 | try ▸ else of (!chk_rel.Checked) | FLAG | sPlanInfo | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-37595a97 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2423 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00609_Pancake_Simul_By_Bld_Elec", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-54b86fa0 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2426 | try ▸ if (p_sys_type == "Select") | DATA_OP | ret.Tables[0].Columns.Add | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-85d834b3 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2428 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { lblCoaterPlan.Text = Filter["PLAN_NAME"]; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4f755fd | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2430 | try ▸ lambda | VALUE_SET | lblCoaterPlan.Text | Filter["PLAN_NAME"] | 컨트롤 값 설정 |  |  |  |
| AC-4ee4c7dc | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2434 | try | STATE_RESET | dtListData.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-23e45192 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2438 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2708b252 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2443 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-56016339 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2445 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.FindTotalColorStart

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c6285d1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:733 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.FindTotalValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1259557 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2365 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7a57130e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2366 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-3265c3fa | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2370 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-06195794 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2372 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.FindYieldInfo

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH")] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d970fd12 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3035 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4040a3e7 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:204 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.FP01552_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdc75e31 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2527 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetCellType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f606806f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4063 |  | FLAG | dtCellType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e3a1d37 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4063 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CELL_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0f18dc69 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4064 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellType, cboCellType, false, "CODE", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f02b848c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4068 | if (dtCellType.Good()) | DATA_OP | Filter["CELL_TYPE"] | dtCellType.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-040d002d | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4069 | if (dtCellType.Good()) | VALUE_SET | cboCellType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b36b0967 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4073 | else of (dtCellType.Good()) | DATA_OP | Filter["CELL_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetElecFactory

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05996123 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4171 |  | FLAG | dtBuilding | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-dca54c0c | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4171 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "ELEC_FACTORY") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7437039e | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4173 | if (bVal) | LIST_REBIND | clsCtrl.setListBox | (dtBuilding, clbBuilding, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetFilter

진입점: this.Load [if (dtCurrDate.Good())] / cboInstance.SelectedIndexChanged [if (dtCurrDate.Good())] / drpPlanDate.DateTimeChanged / chk_rel.CheckedChanged [if (chk_rel.Checked)] / popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]))] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"]))] / F…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2304fd8b | this.Load [if (dtCurrDate.Good())] 외 10 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4058 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetFpPlandId

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / chk_rel.CheckedChanged [else of (chk_rel.Checked)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96e08291 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4180 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-c3a2f850 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4180 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "FP_PLAN_ID") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0a746c53 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4181 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "PLAN_ID", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b34890de | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4185 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1dffac59 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4186 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c03b0cb | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4187 | if (dtPlanId.Good()) | DATA_OP | Filter["DESCRIPTION"] | dtPlanId.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b63d3ef5 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4188 | if (dtPlanId.Good()) | DATA_OP | Filter["READ_ONLY"] | dtPlanId.Rows[0]["READ_ONLY"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-efcd21f8 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4189 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_NAME"] | dtPlanId.Rows[0]["CODE_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f9a8d81f | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4196 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[0]["DEFAULT_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-85c58780 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4197 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["DEFAULT_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-26dfd277 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4201 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-85539a50 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4202 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b7f13641 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4203 | else of (dtPlanId.Good()) | DATA_OP | Filter["DESCRIPTION"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-e362d376 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4204 | else of (dtPlanId.Good()) | DATA_OP | Filter["READ_ONLY"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a0925af6 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4205 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a48a665b | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4216 | else of (dtPlanId.Good()) | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b71c3d07 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4217 | else of (dtPlanId.Good()) | CALL_EXT | DateUtil_FP.gfn_addDate | (sStart, 20) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ede8fa4 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4218 | else of (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | sStart | 행/컬럼 값 대입 |  |  |  |
| AC-5eb4b4da | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4219 | else of (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | sEnd | 행/컬럼 값 대입 |  |  |  |
| AC-44c119a4 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4222 |  | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-76794b19 | this.Load 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4223 |  | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetListData

진입점: popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / InsertButton [if (…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1432afd3 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2456 | try | FLAG | dtUomInfo | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-b500f437 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2456 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "UOM_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-20d14057 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2457 | try | FLAG | dtYieldInfo | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-86e3652a | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2457 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "YIELD_INFO_CHILD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-defacba0 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2458 | try | FLAG | dtProdVersionType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-8134369a | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2458 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PROD_VERSION_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-20a72877 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2459 | try | FLAG | dtPostYield | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-874945d9 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2459 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "POST_YIELD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7cac7e7a | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2460 | try | FLAG | dtVersionType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-51ce36e9 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2460 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "VERSION_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9eebc723 | popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2464 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetPancakeType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64a0188e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4078 |  | FLAG | dtPancakeType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-dabea9c5 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4078 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PANCAKE_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1b486bb8 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4079 |  | LIST_REBIND | clsCtrl.setListBox | (dtPancakeType, cboPancakeType, false, "CODE", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ea626861 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4083 | if (dtPancakeType.Good()) | DATA_OP | Filter["PANCAKE_TYPE"] | dtPancakeType.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cc45ddbe | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4084 | if (dtPancakeType.Good()) | VALUE_SET | cboPancakeType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-625e20d9 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4088 | else of (dtPancakeType.Good()) | DATA_OP | Filter["PANCAKE_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetPlanGroup

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec03648 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4149 |  | FLAG | dtInstance | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1d45cc | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4149 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "INSTANCE_ID") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-dc76e6c7 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4151 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-0537cd24 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4153 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE_ID", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1473a6b8 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4157 | if (cboInstance.Good()) ▸ if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-f95129f9 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4159 | if (cboInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = dtInstance.Rows[0]["CODE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d66f403 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4159 | if (cboInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | dtInstance.Rows[0]["CODE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e9e14447 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4160 | if (cboInstance.Good()) | DATA_OP | Filter["ROUND_POINT"] | dtInstance.Rows[0]["ROUND_POINT"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7acc647a | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4161 | if (cboInstance.Good()) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[0]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c32d550 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4165 | else of (cboInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-d91c8117 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4165 | else of (cboInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetUnit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0d6f917 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4109 |  | FLAG | dtUnit | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-371a891c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4109 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "UNIT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f8d51520 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4110 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, false, "CODE", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bd8a1c79 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4114 | if (dtUnit.Good()) | DATA_OP | Filter["UNIT"] | dtUnit.Rows[0]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e236fe93 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4115 | if (dtUnit.Good()) | VALUE_SET | cboUnit.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-47aa329d | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4119 | else of (dtUnit.Good()) | DATA_OP | Filter["UNIT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GetUOMType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c190b08f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4093 |  | FLAG | dtUOMType | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-06daaddd | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4093 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "UOM_TYPE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-782b6280 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4094 |  | LIST_REBIND | clsCtrl.setListBox | (dtUOMType, cboUOMType, false, "CODE", "CODE_NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-63c85e00 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4099 | if (dtUOMType.Good()) | DATA_OP | Filter["UOM_TYPE"] | dtUOMType.Rows[1]["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b5d0b804 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4100 | if (dtUOMType.Good()) | VALUE_SET | cboUOMType.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-7b59a244 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:4104 | else of (dtUOMType.Good()) | DATA_OP | Filter["UOM_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.gfn_Msg

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ if (!Clipboard) ▸ if (!can_change)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62fdf075 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4309 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d0573f4 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:983 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d74aef0 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:985 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e3b9058e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1027 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0738187a | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1028 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-15374771 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1057 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f5bcd8d | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1058 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-870c82dc | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1087 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-127e990f | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1088 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-ae76f3ad | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1103 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.GoEditMode

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / InsertButton [if (row != null) ▸ if (p…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9ec6214 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1109 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-f26dfb9a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1135 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-b44e9cb5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1136 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-cff3f342 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1216 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(255, 186, 133)) | 그리드 표시 설정 |  |  |  |
| AC-b8909879 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1221 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(255, 229, 194)) | 그리드 표시 설정 |  |  |  |
| AC-1ad85922 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1227 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(245, 255, 225)) | 그리드 표시 설정 |  |  |  |
| AC-7c2840a2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1235 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-32a7c3d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1243 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(sRedTmp, sGrnTmp, s… | 그리드 표시 설정 |  |  |  |
| AC-09169351 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1259 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b18b635b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1272 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-811a93bf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1290 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-7eaf443e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1307 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor3 | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-2431765f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1313 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b40b661 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:219 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f463e927 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:223 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-de018d9c | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:224 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-fe5f0b73 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:228 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-1a355659 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:235 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InitEditingBuf

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-046bbe33 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2539 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9049df8f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2540 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-7bf02016 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2541 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-17885ab3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2542 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aad0c5e0 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:261 |  | UI_PROP | clbBuilding.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InitSpread

진입점: this.Load / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPl…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afd90036 | this.Load 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:376 | try | DATA_OP | Filter["PROGRAM_ID"] | "FP00609" | 행/컬럼 값 대입 |  |  |  |
| AC-0d2ef8c7 | this.Load 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:377 | try | DATA_OP | Filter["SHEET_NAME"] | "AMEND" | 행/컬럼 값 대입 |  |  |  |
| AC-9c28d229 | this.Load 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:392 | try | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e3f0f4a7 | this.Load 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:393 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d2cd9da5 | this.Load 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:398 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a423093 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:893 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-b25b7abc | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:894 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e861b492 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:898 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9baeb752 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:903 | if (row != null) ▸ if (Filter["PLAN_TYPE"] == "RELEASE" \|\| Filter["RELEASE_FLAG"] == "Y") | MESSAGE | MessageBox.Show | ("Cannot be run in release plan.") | 메시지 표시 |  |  |  |
| AC-a8787552 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:904 | if (row != null) ▸ if (Filter["PLAN_TYPE"] == "RELEASE" \|\| Filter["RELEASE_FLAG"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5fce53f | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:909 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | MESSAGE | MessageBox.Show | ("Can not be selected [Total] Row.") | 메시지 표시 |  |  |  |
| AC-7df39907 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:910 | if (row != null) ▸ if (row["DATA_TYPE"].ToString().ToUpper() == "TOTAL" \|\| row["DATA_TYPE"].ToString().ToUpper() == "TOTAL_2") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ee67994f | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:913 | if (row != null) | POPUP | new FP00595_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-3992f61b | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:915 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-4a27f5b6 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:915 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2dc1e5b7 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:921 | if (row != null) | DATA_OP | dtUomInfo.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-929428b6 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:922 | if (row != null) | DATA_OP | dtVersionType.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a8ef3e77 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:923 | if (row != null) | DATA_OP | dtYieldInfo.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-62c998e7 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:925 | if (row != null) | DATA_OP | dsUOMInfo.Tables.Add | (dtuomtmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-bd65b316 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:926 | if (row != null) | DATA_OP | dsVersionType.Tables.Add | (dtvertmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-e032e80e | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:927 | if (row != null) | DATA_OP | dsYieldChild.Tables.Add | (dtyieldtmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-e75a23ec | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:929 | if (row != null) | UI_PROP | popup.dsUOMInfo | dsUOMInfo | 속성 dsUOMInfo 설정 |  |  |  |
| AC-b853ea39 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:930 | if (row != null) | UI_PROP | popup.dsVersionType | dsVersionType | 속성 dsVersionType 설정 |  |  |  |
| AC-1025af6f | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:931 | if (row != null) | UI_PROP | popup.dsYieldChild | dsYieldChild | 속성 dsYieldChild 설정 |  |  |  |
| AC-8eb67367 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:938 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cdbde9fd | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:939 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-279f7770 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:942 | if (row != null) | DATA_OP | popup.Filter["LINE_ID"] | row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e17acd91 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:943 | if (row != null) | DATA_OP | popup.Filter["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8b70890f | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:947 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-01b89011 | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:948 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-61c6cd4c | InsertButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:958 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-357a66d2 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2235 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.lfn_getExchangeBatch_Validation

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ if (!Clipboard)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < co…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12f5c9ca | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3083 | switch (cate) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-7cacccda | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3092 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c8b2c86 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3093 | lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-a926d8d0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3094 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d17e7ce1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3095 | lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-42dcc0e6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3096 | lambda | DATA_OP | x.Field | ("PROD_VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae24f802 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3090 | lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-3b8687fc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3105 | if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-40a7d9a4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3106 | if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-0702cd6a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3108 |  | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.lfn_getYieldInfo

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH")] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f49c1f21 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3013 |  | FLAG | YieldRate | FindYieldInfo(clicked_row, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-9c8d4320 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3013 |  | RETURN | return YieldRate = FindYieldInfo(clicked_row, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.lfn_setExchangeBatch

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH")] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-095ec54b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3135 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-85569828 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3141 |  | CALL_EXT | dtVersionType.Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-85b7ff3c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3174 |  | CALL_EXT | dtYieldInfo.FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fde78555 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3179 | else of (nExcRow == -1) | DATA_OP | dtYieldInfo.getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-73660b27 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3185 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.lfn_setExchangeBatch_Detail

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH")] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00422cdb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3216 | if (nExcRow == -1) | CALL_EXT | dtUomInfo.FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eed306d5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3247 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dtVersionType.Lookup | ("PRODUCTION_TYPE", sProdType, sTxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d649b21f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3258 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dtUomInfo.FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5012d24f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3276 | if (nExcRow == -1) | CALL_EXT | dtUomInfo.FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70d08c55 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:3279 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.lfn_setPostQty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH")] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i <…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-967f4f89 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2935 | if (rowPost == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bfe69da | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2945 | lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7083c0d6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2946 | lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a096a4e1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2947 | lambda | DATA_OP | x.Field | ("ITEM_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-6957ceeb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2943 | lambda | RETURN | return ( x.Field<string>("DATA_TYPE") == "DATA" && x.Field<string>("CATEGORY_ID"… |  | 처리 중단/반환 |  |  |  |
| AC-36f979ab | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2978 |  | DATA_OP | rowPost[sCol] | nPostQty | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.PasteAuto

진입점: this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f15b3584 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP00609_Pancake_Simul_By_Bld_Elec.cs:3828 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8700d28d | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP00609_Pancake_Simul_By_Bld_Elec.cs:3829 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42f5ff8b | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP00609_Pancake_Simul_By_Bld_Elec.cs:3867 | if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1) ▸ if (ClipboardRange.Length > 0) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.planday_changed

진입점: drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-156c9467 | drpPlanDate.DateTimeChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3454 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.RefreshHeader

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / InsertButton [if (row != null) ▸ if (p…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d59e17e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:436 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-ca4234e9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:437 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2e1783fb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:438 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-2619649c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:439 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4ef6aad1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:455 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c6644b9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:458 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-37ccc3b1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:459 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2f3df1a1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:460 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2fb7f0eb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:461 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f1b4cf0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:464 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dedc981b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:465 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5492db17 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:467 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-538dcf16 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:472 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f77f1b6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:474 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (22) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ffad573 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:475 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c078cd1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:512 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-2706f873 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:531 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-29e20058 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:535 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-4d30bcd5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:537 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8c352979 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:541 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-95bc367f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:556 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-63de19af | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:571 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.RefreshHeaderOnly

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-230bfe98 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:584 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-3b1387b6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:585 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("PSI") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-7286b2da | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:586 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb728ecd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:587 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f01629d6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:588 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.RefreshSpreadSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f116f87b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1738 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-ccd13f3b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1744 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-18b9d61a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1750 | if (dsMainFiltered.Good()) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.RoundValue

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e15fe699 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4327 | if (roundPoint < 1 \|\| roundPoint > 11) | FLAG | roundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-90da76ec | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4328 | if (roundPoint < 1 \|\| roundPoint > 11) | FLAG | RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-1dff210e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4332 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fafd26d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4333 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-9c7576c7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4336 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c62faa44 | popSql.OnSql | FP00609_Pancake_Simul_By_Bld_Elec.cs:2348 | if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-f0610e68 | popSql.OnSql | FP00609_Pancake_Simul_By_Bld_Elec.cs:2350 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Save_Confirm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5908fa19 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1499 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2427a322 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1500 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f4cbdec2 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1506 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-87059f1e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1522 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00609_Pancake_Simul_By_Bld_Elec", "execute_confirm", Filter.Dictionary, null, "Plannin… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-37e69ccb | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1526 | try ▸ catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0b674650 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1529 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP00609_Pancake_Simul_By_Bld_Elec", "execute_planSend", Filter.Dictionary, null,"Plannin… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-31bc9612 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1535 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ca2dc9cb | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1536 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6ccd2322 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1540 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-562c854d | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1545 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f06849f9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1342 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-35f33f0b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1352 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecf916e8 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1353 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-40c693ae | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1358 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f3da5a11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1359 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b183730b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1362 | try ▸ if (!r.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-f9ecbf75 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1363 | try ▸ if (!r.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f6223b50 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1364 | try ▸ if (!r.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-79d35b12 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1368 | try | CALL_EXT | dt2.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-11dcff54 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1369 | try | UI_PROP | dt.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-25dab403 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1421 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-790de4fa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1428 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c7b2497 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1432 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-52b5ef1b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1433 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9452e0d7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1449 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP00609_Pancake_Simul_By_Bld_Elec", "merge_data", dt, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] \| FP\Planning\FP006… | 엔드포인트 호출 |  |  |  |
| AC-2cd9df34 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1458 | try ▸ if (updateResult.Rows[0]["RESULT"].ToString() == "SUCCESS") ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00609_Pancake_Simul_By_Bld_Elec", "execute_psiCalcul", Filter.Dictionary, null, "Plann… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-caefc0d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1463 | try ▸ if (updateResult.Rows[0]["RESULT"].ToString() == "SUCCESS") ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-d53dac9a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1464 | try ▸ if (updateResult.Rows[0]["RESULT"].ToString() == "SUCCESS") ▸ catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e1146acf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1467 | try ▸ if (updateResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | STATE_RESET | dtListData.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e1a27e90 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1472 | try ▸ else of (updateResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-963c841d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1479 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-1179ce11 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1483 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ff413337 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00609_Pancake_Simul_By_Bld_Elec.cs:1486 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.Save_VersionUp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b8da4e7 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1558 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c4db34ff | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1559 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5ee4bc52 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1565 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9be4a491 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1581 | try | DATA_OP | Filter["BASIS_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5639425e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1582 | try | DATA_OP | Filter["CREATE_PLAN_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ca3791cc | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1583 | try | DATA_OP | Filter["CAL_OPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-06bb8411 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1584 | try | DATA_OP | Filter["FIX_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-b600aaa7 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1585 | try | DATA_OP | Filter["COPY_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-43016a4e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1586 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ddd39d41 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1587 | try | DATA_OP | Filter["TARGET_DATE"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d899ab8b | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1591 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP00609_Pancake_Simul_By_Bld_Elec", "execute_version", Filter.Dictionary, null, "Plannin… ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_version] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-1e384333 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1595 | try ▸ catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-73ba9553 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1602 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-18f92349 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1603 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2521a61d | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1607 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-db516c53 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:1612 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eefac4b2 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:1324 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-c5bebc06 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:1325 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d3e136b8 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:1328 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-724369d7 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:1331 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetColumnsFormat

진입점: chk_omit_zero.CheckedChanged / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetNam…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11727baf | chk_omit_zero.CheckedChanged 외 7 | FP00609_Pancake_Simul_By_Bld_Elec.cs:601 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-41420302 | chk_omit_zero.CheckedChanged 외 7 | FP00609_Pancake_Simul_By_Bld_Elec.cs:651 | if (siMain != null) ▸ if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) | CALL_EXT | siMain.SetFormat | ("#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetCurrDate_Default

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2eb03896 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4126 |  | FLAG | dtCurrDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-de10f04c | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4126 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CURR_DATE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e1184656 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4127 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.ParseExact(dtCurrDate.Rows[0]["CURR_DATE"].ToString(), "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-7227f783 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4131 | if (dtCurrDate.Good()) | DATA_OP | Filter["CURR_DATE"] | Filter["PLAN_DATE"] = drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8659d7b6 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4131 | if (dtCurrDate.Good()) | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-654fe4b3 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4132 | if (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtCurrDate.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6e0a9617 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4133 | if (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtCurrDate.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-73a08a96 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4135 | if (dtCurrDate.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-6a107718 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4136 | if (dtCurrDate.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-3ecd06e9 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4140 | else of (dtCurrDate.Good()) | DATA_OP | Filter["CURR_DATE"] | Filter["PLAN_DATE"] = "" | 행/컬럼 값 대입 |  |  |  |
| AC-de66f273 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4140 | else of (dtCurrDate.Good()) | DATA_OP | Filter["PLAN_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8e5b8ba9 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4141 | else of (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_FROM"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8eae52b3 | this.Load 외 1 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4142 | else of (dtCurrDate.Good()) | DATA_OP | Filter["BUCKET_TO"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bd005db | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:170 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a40e34a7 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:172 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-ed0c0daf | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:173 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f4538b9f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:174 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-eb006fd6 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:178 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-fd42094a | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:179 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0196b9ca | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:180 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ee52f956 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:182 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-023f5f87 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:183 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82c924cf | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:185 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-2499786e | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:186 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-508a2cde | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:187 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a4f9c6d1 | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:191 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-0d7070da | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:192 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4400342f | this.Load | FP00609_Pancake_Simul_By_Bld_Elec.cs:193 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a9da0ae | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 3 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4261 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged [if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / chk_rel.CheckedChanged [if (chk_rel.Checked)] / clbBuilding.SelectedIndexChanged / cboCellType.SelectedIndexChanged / cboPancakeType.SelectedIndexChanged / cboUOMType.SelectedIndexChanged / cboUnit.SelectedIndexChanged / txtModel.TextChanged / txtModelNickName.TextChanged / txtMaterial.TextChanged / txtNickName.TextChanged / drpPeriod.ValueChanged / popSql.OnSql [if (programID == "PR_UI_FP00609_Pancake_Simul_By_Bld_Elec") ▸ try ▸ if (!chk_rel.Checked) ▸ if (dtChkPlanI…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88f64483 | this.Load 외 20 | FP00609_Pancake_Simul_By_Bld_Elec.cs:4053 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetInventory

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / FindButton [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c9656a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1773 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "START_END") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-78c7cf07 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1787 | if (!bIsCurr) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d740544 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1793 |  | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-5318836c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1794 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-6baeb84d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1795 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-57bc4f33 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1796 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c00ad4ec | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1813 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("ITEM_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-4121371c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1811 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ lambda | RETURN | return ( x.Field<Int64>("ITEM_RANK") == (long)row["ITEM_RANK"] ); |  | 처리 중단/반환 |  |  |  |
| AC-0847dc39 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1828 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.ASSY.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8a2e881 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1831 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.POST.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-9971e58b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1834 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.COATER.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b831b95 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1837 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.SHIP.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-da802253 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1840 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV") ▸ foreach (DataRow related_row in relating… | DATA_OP | loc.SHIP_IN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-37098266 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1866 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("MODEL_ITEM_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-74c03b92 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1867 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ lambda | DATA_OP | x.Field | ("DATA_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b8b757ae | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1864 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ lambda | RETURN | return ( x.Field<Int64>("MODEL_ITEM_RANK") == (long)row["MODEL_ITEM_RANK"] && x.… |  | 처리 중단/반환 |  |  |  |
| AC-c2784df2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1882 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ foreach (DataRow related_row in relatin… | DATA_OP | loc.ASSY.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-15b8fa2c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1885 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ foreach (DataRow related_row in relatin… | DATA_OP | loc.POST.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-93099b01 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1888 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ foreach (DataRow related_row in relatin… | DATA_OP | loc.COATER.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-866df93d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1891 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ foreach (DataRow related_row in relatin… | DATA_OP | loc.SHIP.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-4676b199 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:1894 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV") ▸ foreach (DataRow related_row in relatin… | DATA_OP | loc.SHIP_IN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetInventory_Detail

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try ▸ try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" && sItemRank == sRankTmp)] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10f5d401 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 9 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2027 | if (relating_rows.Count() > 0) ▸ foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | Convert.ToInt16 | (sColName.Substring(1, lastIndex - 1)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ff09815 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 9 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2051 | if (relating_rows.Count() > 0) ▸ foreach (AmendDate a in calendar.Days.Values) | DATA_OP | invRow[sColName] | Convert.ToDecimal(nInv) | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetInventoryTotal_Detail

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV")] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL" && sCategory == "INV")] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ foreach (DataRow row in dsResult.Tables[0…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-547e04f3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2085 | if (relating_rows.Count() > 0) ▸ foreach (AmendDate a in calendar.Days.Values) | CALL_EXT | Convert.ToInt16 | (sColName.Substring(1, lastIndex - 1)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62908909 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2115 | if (relating_rows.Count() > 0) ▸ foreach (AmendDate a in calendar.Days.Values) | DATA_OP | invRow[sColName] | Convert.ToDecimal(nInv) | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetPlanOut

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].Tag.SafeString() ==…) ▸ try] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a55c9f3d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2546 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-5d8a0d25 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2559 | if (!Clipboard) ▸ if (!can_change) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-f77b9903 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2560 | if (!Clipboard) ▸ if (!can_change) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b99edd49 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2566 | if (!Clipboard) ▸ if (o_new == null && CurrentInputValue == null) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | null | 그리드 속성/값 설정 |  |  |  |
| AC-4547249c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2567 | if (!Clipboard) ▸ if (o_new == null && CurrentInputValue == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efcfd4d6 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2574 | if (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-36250810 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2575 | if (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcb10db7 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2584 | else of (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-adfd4562 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2585 | else of (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-251a8804 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2596 | if (new_value != xx) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | xx | 그리드 속성/값 설정 |  |  |  |
| AC-d7b0e4d4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2603 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-1e469de1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2608 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f26d22f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2615 | if (Clipboard && org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43b8fddd | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2619 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-44414cb1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2656 | try ▸ if (sCate == "COATER_BATCH") ▸ if (new_value >= 50) ▸ if (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-3adc6f8a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2657 | try ▸ if (sCate == "COATER_BATCH") ▸ if (new_value >= 50) ▸ else of (Clipboard) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | CurrentInputValue | 그리드 속성/값 설정 |  |  |  |
| AC-f593cfc0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2659 | try ▸ if (sCate == "COATER_BATCH") ▸ if (new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-1e37cc3d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2660 | try ▸ if (sCate == "COATER_BATCH") ▸ if (new_value >= 50) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e9481c40 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2669 | try ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ad79b8c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2671 | try ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-69f9ccee | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2672 | try ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbfc2f08 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2673 | try ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce180671 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2674 | try ▸ lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-583442ca | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2675 | try ▸ lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-af5ab707 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2676 | try ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-17888271 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2677 | try ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-93e0e0d4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2678 | try ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1d72c53 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2679 | try ▸ lambda | DATA_OP | x.Field | ("RELEASE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3b38495e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2680 | try ▸ lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-f12d4590 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2691 | try ▸ else of (m.Count() > 0) | DATA_OP | dtListData.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6a83a5d2 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2693 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["INSTANCE_ID"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5882b8ee | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2694 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6d58bf5e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2695 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-39c010ac | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2696 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-fcfe4164 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2698 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-ddb7f323 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2699 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-778a1dd3 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2700 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-2c85c47b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2701 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["EQUIPMENT_ID"] | sEqup | 행/컬럼 값 대입 |  |  |  |
| AC-c65be426 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2702 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-f9f98c59 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2703 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-bfa2d4fb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2704 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-f3327d5a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2705 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["ITEM_ID"] | sItem | 행/컬럼 값 대입 |  |  |  |
| AC-a81b9103 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2706 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-9d574693 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2708 | try ▸ else of (m.Count() > 0) | DATA_OP | newRow["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-ec989923 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2711 | try ▸ else of (m.Count() > 0) | DATA_OP | dtListData.Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f0c1c29 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2750 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-278e780a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2751 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-e4f066bc | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2752 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-cc782e35 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2755 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-4d2cd758 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2756 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-05f6afe4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2760 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-4a477af0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2766 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-d9351df8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2772 | try ▸ if (sCate == "COATER_BATCH") | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-d4defec8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2775 | try ▸ if (sCate == "COATER_BATCH") | LIST_BIND | dgEdit.DataSource | dtListData | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-04ae18f1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2818 | try ▸ if (sCate == "COATER_BATCH") ▸ if (rowTmp != null) | DATA_OP | rowTmp[ColumnName_Buf] | nUomVal | 행/컬럼 값 대입 |  |  |  |
| AC-bacf88ec | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2844 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | x.Field | ("ITEM_RANK") | 데이터 객체 조작/조회 |  |  |  |
| AC-06641e94 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2842 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | RETURN | return ( x.Field<Int64>("ITEM_RANK") == sItemRank ); |  | 처리 중단/반환 |  |  |  |
| AC-016ee31c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2859 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | loc.ASSY.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3d0c2ad | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2862 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | loc.POST.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-94cbecb0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2865 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | loc.COATER.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-64ea6d6c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2868 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | loc.SHIP.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |
| AC-71ce6336 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP00609_Pancake_Simul_By_Bld_Elec.cs:2871 | try ▸ if (sCate == "COATER_BATCH") ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (sDataType == "DATA" && sCategory == "INV" … | DATA_OP | loc.SHIP_IN.Add | (row_index) | 데이터 객체 조작/조회 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29e4530e | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:406 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33887b53 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:407 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5683e9e | this.spdMain.ButtonClicked | FP00609_Pancake_Simul_By_Bld_Elec.cs:4037 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f8f3a5f | this.spdMain.CellClick | FP00609_Pancake_Simul_By_Bld_Elec.cs:3952 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe03cd47 | this.spdMain.ChildControlDeactivated | FP00609_Pancake_Simul_By_Bld_Elec.cs:3982 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-219e8a18 | this.spdMain.ClipboardPasted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3889 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-03f11b3b | this.spdMain.ClipboardPasted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3899 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1d223f35 | this.spdMain.ClipboardPasted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3908 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-67a4a2be | this.spdMain.ClipboardPasted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3909 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0241f92b | this.spdMain.ClipboardPasted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3912 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2654b8d1 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3718 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-9c1f8d83 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3719 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-701c5fe5 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3721 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9db972bf | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3724 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-497ed316 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3726 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4e33b15 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3730 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0d1774b | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3745 | if (data.GetDataPresent(typeof(System.String))) ▸ if (ClipRowCount == 0 && ClipColCount == 0) | FLAG | ClipData | new string[1, 1] | 화면 필드/플래그 변경 |  |  |  |
| AC-bf641b3f | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3746 | if (data.GetDataPresent(typeof(System.String))) ▸ if (ClipRowCount == 0 && ClipColCount == 0) | DATA_OP | ClipData[0, 0] | src_string | 행/컬럼 값 대입 |  |  |  |
| AC-a7026fad | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3750 | if (data.GetDataPresent(typeof(System.String))) ▸ else of (ClipRowCount == 0 && ClipColCount == 0) ▸ if (MaxColCount > 0 && ClipRowCount > 0… | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-68a33201 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3761 | if (data.GetDataPresent(typeof(System.String))) ▸ else of (ClipRowCount == 0 && ClipColCount == 0) ▸ if (MaxColCount > 0 && ClipRowCount > 0… | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-5e8b1bf0 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3773 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8197806e | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3774 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52bb17c0 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3779 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f81ee9f | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3794 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | GRID_SET | siMain.ActiveSheet.Cells[startrow, startcol].Value | src_copy | 그리드 속성/값 설정 |  |  |  |
| AC-b2ec31d5 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3801 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | MESSAGE | MessageBox.Show | (ee.ToString()) | 메시지 표시 |  |  |  |
| AC-ead9348a | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3805 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19a01ca5 | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3808 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a830432c | this.spdMain.ClipboardPasting | FP00609_Pancake_Simul_By_Bld_Elec.cs:3810 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b17ed62 | this.spdMain.DragFillBlockCompleted | FP00609_Pancake_Simul_By_Bld_Elec.cs:3992 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b51ce0f3 | this.spdMain.EditChange | FP00609_Pancake_Simul_By_Bld_Elec.cs:3947 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fdcec3b | this.spdMain.EditModeOff | FP00609_Pancake_Simul_By_Bld_Elec.cs:4010 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0effee0f | this.spdMain.EditModeOn | FP00609_Pancake_Simul_By_Bld_Elec.cs:4016 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-e9f62474 | this.spdMain.EditModeOn | FP00609_Pancake_Simul_By_Bld_Elec.cs:4017 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6088c0ba | this.spdMain.EditorFocused | FP00609_Pancake_Simul_By_Bld_Elec.cs:4004 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7597f5c | this.spdMain.Enter | FP00609_Pancake_Simul_By_Bld_Elec.cs:3967 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bccb52d | this.spdMain.Leave | FP00609_Pancake_Simul_By_Bld_Elec.cs:3962 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb6aae06 | this.spdMain.SubEditorClosed | FP00609_Pancake_Simul_By_Bld_Elec.cs:3998 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f19db1c5 | this.spdMain.SubEditorOpening | FP00609_Pancake_Simul_By_Bld_Elec.cs:3987 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55cee245 | this.spdMain.TableChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3938 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a16b32ea | this.spdMain.TableChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3940 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7236fc5 | this.spdMain.TextChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3925 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7776a80 | this.spdMain.TextChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3927 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c565aa61 | this.spdMain.Validated | FP00609_Pancake_Simul_By_Bld_Elec.cs:3972 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-015b0e37 | this.spdMain.Validating | FP00609_Pancake_Simul_By_Bld_Elec.cs:3977 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.tbModelNickNameList_BeforeOpenSearch

진입점: tbModelNickNameList.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c8c7933 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3516 |  | CALL_EXT | tbModelNickNameList.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-474fc32a | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3520 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-731ae180 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3521 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0cb712d | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3522 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-6149e498 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3523 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f9ba858 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3524 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3ca12b1 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3525 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffff7745 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3530 |  | UI_PROP | tbModelNickNameList.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-51e98749 | tbModelNickNameList.BeforeOpenSearch | FP00609_Pancake_Simul_By_Bld_Elec.cs:3531 |  | UI_PROP | tbModelNickNameList.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.tbModelNickNameList_OnSearchConditionChanged

진입점: tbModelNickNameList.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3aad00f8 | tbModelNickNameList.OnSearchConditionChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3541 | if (tbModelNickNameList.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "MODEL_NICK_NAME_TOP", tbModelNickNameList.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-96373aa5 | tbModelNickNameList.OnSearchConditionChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3543 | if (tbModelNickNameList.IsInMode == true) | DATA_OP | Filter["MODEL_NICK_NAME_LIST"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b33a79f2 | tbModelNickNameList.OnSearchConditionChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3547 | else of (tbModelNickNameList.IsInMode == true) | DATA_OP | Filter["MODEL_NICK_NAME_TOP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5dc63002 | tbModelNickNameList.OnSearchConditionChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3551 | else of (tbModelNickNameList.IsInMode == true) ▸ if (tbModelNickNameList.Selected.Count > 0) | DATA_OP | Filter["MODEL_NICK_NAME_LIST"] | tbModelNickNameList.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-bb3dc492 | tbModelNickNameList.OnSearchConditionChanged | FP00609_Pancake_Simul_By_Bld_Elec.cs:3555 | else of (tbModelNickNameList.IsInMode == true) ▸ else of (tbModelNickNameList.Selected.Count > 0) | DATA_OP | Filter["MODEL_NICK_NAME_LIST"] | tbModelNickNameList.TextValue | 행/컬럼 값 대입 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton [if (save_success == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2d87978 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:759 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7345e0cd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:760 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4051560 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:763 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a94574e4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:769 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) ▸ if (GetFilter("RELEASE_FLAG") == "N") | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-e5157f8d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:770 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) ▸ if (GetFilter("RELEASE_FLAG") == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-783be7f0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:778 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-768c7064 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:800 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d011c4e4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:804 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-be08c058 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:805 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3c66fc79 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:809 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | roundPoint | Convert.ToInt32(Filter["ROUND_POINT"]) | 화면 필드/플래그 변경 |  |  |  |
| AC-136e814d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:814 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ while (rwork > 0) | FLAG | RoundTen | *= 10 | 화면 필드/플래그 변경 |  |  |  |
| AC-1cb2a30a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:818 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0d6d9c33 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:827 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e8b84c99 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:829 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-5654ef76 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:829 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c6689d97 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:835 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-76108326 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:840 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-936594fd | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:853 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0968cc69 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:857 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d10bb23 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:863 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ae452b60 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:867 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b3a699ad | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:874 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e4471a0f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:880 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-161ee1ba | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 5 | FP00609_Pancake_Simul_By_Bld_Elec.cs:884 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.UISaveConfirm

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7812fcc9 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2177 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-d8be5f83 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2180 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-48a669af | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2181 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-23fef335 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2188 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-c979ccbe | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2193 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a517de21 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2136 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6487c2d2 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2140 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-c826cd17 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2142 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4f4bacf5 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2143 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eae9aaaf | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2147 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_success == true) | MESSAGE | MessageBox.Show | ("Data saved", "Save result") | 메시지 표시 |  |  |  |
| AC-10e583c0 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2151 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ else of (save_success == t… | MESSAGE | MessageBox.Show | ("Data not saved", "Save result") | 메시지 표시 |  |  |  |
| AC-5402a9d9 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2159 | catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-9dea1808 | SaveButton | FP00609_Pancake_Simul_By_Bld_Elec.cs:2163 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00609_Pancake_Simul_By_Bld_Elec.UISaveVersionUp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7dff22f7 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2207 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-501fcee8 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2210 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ea55ff82 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2212 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6fac2725 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2219 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-fa260104 | (진입점 미연결) | FP00609_Pancake_Simul_By_Bld_Elec.cs:2224 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00609_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e1733aa | .ctor | FP00609_PlanInfoPopup.cs:117 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-e25d9f5d | .ctor | FP00609_PlanInfoPopup.cs:118 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00609_PlanInfoPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bbd40e0a | this.btnClose.Click | FP00609_PlanInfoPopup.cs:300 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00609_PlanInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49aa7d58 | this.Load | FP00609_PlanInfoPopup.cs:155 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-53d84be0 | this.Load | FP00609_PlanInfoPopup.cs:156 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e9529524 | this.Load | FP00609_PlanInfoPopup.cs:157 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00609_PlanInfoPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52a3117c | this.Load | FP00609_PlanInfoPopup.cs:150 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00609_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3c5eea4 | Dispose | FP00609_PlanInfoPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00609_PlanInfoPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b3af931 | FindButton | FP00609_PlanInfoPopup.cs:190 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-16e87735 | FindButton | FP00609_PlanInfoPopup.cs:191 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d7f8b6c7 | FindButton | FP00609_PlanInfoPopup.cs:193 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00609_PlanInfoPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bedff83 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:227 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-88a0c885 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:227 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3257d08a | this.Load 외 1 | FP00609_PlanInfoPopup.cs:231 |  | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b161d116 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:232 |  | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-65ca8354 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:239 | try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7c197ca | this.Load 외 1 | FP00609_PlanInfoPopup.cs:242 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP00609_ETC").ToUpper(), Filter, Filter["USER_ID"], "SELECT", "PLAN_INFO_POPUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a878e238 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:244 | try | CALL_BASE | this.Invoke | (new Action(delegate () { siMain.Query(set, true); siMain.LockColumn(0, siMain.GetMaxColum… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5780833 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:246 | try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a2627891 | this.Load 외 1 | FP00609_PlanInfoPopup.cs:247 | try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-76872aad | this.Load 외 1 | FP00609_PlanInfoPopup.cs:257 | finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-2234e3dd | this.Load 외 1 | FP00609_PlanInfoPopup.cs:260 | finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a5f3c90d | this.Load 외 1 | FP00609_PlanInfoPopup.cs:261 | finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00609_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc6263b2 | this.Load | FP00609_PlanInfoPopup.cs:126 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-46093234 | this.Load | FP00609_PlanInfoPopup.cs:128 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00609_PlanInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c931e303 | this.Load | FP00609_PlanInfoPopup.cs:166 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-0ab52131 | this.Load | FP00609_PlanInfoPopup.cs:169 | if (Filter["CONFIRM_AREA"].ToString() != "BUILDING") | GRID_INIT | siMain.SetColumnHeader | (0, 1, "Plan Group") | 그리드 재구성/초기화 |  |  |  |

## FP00609_PlanInfoPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a28a2ed0 | (진입점 미연결) | FP00609_PlanInfoPopup.cs:181 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00609_PlanInfoPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87bf0902 | this.Load | FP00609_PlanInfoPopup.cs:175 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53dfb7f9 | this.Load | FP00609_PlanInfoPopup.cs:176 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

