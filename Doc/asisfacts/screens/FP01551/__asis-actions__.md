# AS-IS 액션 대조표 — FP01551

> 원천: `Doc/asisfacts/screens/FP01551/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1049행 · 메서드 195 · 종류 DATA_OP 293 · FLAG 147 · UI_PROP 85 · RETURN 72 · UI_MISC 63 · VALUE_SET 62 · GRID_INIT 62 · MESSAGE 49 · ENDPOINT 39 · CALL_EXT 34 · POPUP 34 · COMBO_DATA 20 · LIST_REBIND 17 · GRID_LOCK 16 · GRID_SET 14 · STATE 14 · GRID_STYLE 8 · THROW 6 · GRID_BIND 5 · CALL_BASE 3 · VALUE_CLEAR 2 · LIST_CLEAR 2 · FOCUS 1 · EXCEL 1 · ⚠ 의미 확인 필요 37


## FP01551_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a0f10bd | .ctor | FP01551_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-21ba9f30 | .ctor | FP01551_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-8ee62287 | .ctor | FP01551_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-4c9a4e75 | .ctor | FP01551_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01551_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8bdf0a | Dispose | FP01551_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-057cc2f5 | this.Load | FP01551_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01551_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03b92c46 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:137 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-4137b377 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:143 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-f5b67d0d | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-c40b9254 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bf76559 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5e2bab8 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-97514003 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-67e7e955 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-abf83109 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01551_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbeead63 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-8d391cdb | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d0540602 | this.Load 외 1 | FP01551_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01551_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f99e9fb | (진입점 미연결) | FP01551_BucketSetForm_Popup.cs:224 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-0d56d4b0 | (진입점 미연결) | FP01551_BucketSetForm_Popup.cs:235 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5db5a60 | (진입점 미연결) | FP01551_BucketSetForm_Popup.cs:246 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01551_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd713c07 | this.Load | FP01551_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-89bdd6c7 | this.Load | FP01551_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12849107 | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-f7192cb9 | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-f209f70b | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-99145527 | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-69fc4b15 | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3a0cfd26 | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-830564ac | this.usrButton1.Click | FP01551_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01551_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e36cc58 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-dd27a3e8 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-406e2e70 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-5fbf7cc1 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-ad8eb742 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-0fea1690 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-78c65495 | this.usrButton2.Click | FP01551_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_CalculationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f830746 | .ctor | FP01551_CalculationPopup.cs:128 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-b1fa51b2 | .ctor | FP01551_CalculationPopup.cs:130 |  | FLAG | this.bCtlEnable | true | 화면 필드/플래그 변경 |  |  |  |
| AC-bb60db54 | .ctor | FP01551_CalculationPopup.cs:131 |  | FLAG | this.bMulltiSelect | true | 화면 필드/플래그 변경 |  |  |  |

## FP01551_CalculationPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c3a39a0 | this.btnButtonList.UsrButtonList_Click_Detected | FP01551_CalculationPopup.cs:646 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-df2a2773 | this.btnButtonList.UsrButtonList_Click_Detected | FP01551_CalculationPopup.cs:649 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_CalculationPopup.clbDivision_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-591a0c8d | (진입점 미연결) | FP01551_CalculationPopup.cs:618 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7b9fd75 | (진입점 미연결) | FP01551_CalculationPopup.cs:621 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-3185738f | (진입점 미연결) | FP01551_CalculationPopup.cs:621 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e5e04f06 | (진입점 미연결) | FP01551_CalculationPopup.cs:622 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4e6f664 | (진입점 미연결) | FP01551_CalculationPopup.cs:626 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-80f2a3b4 | (진입점 미연결) | FP01551_CalculationPopup.cs:629 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-07ccdb09 | (진입점 미연결) | FP01551_CalculationPopup.cs:629 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fb75327a | (진입점 미연결) | FP01551_CalculationPopup.cs:630 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_CalculationPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ad8da9b | clbDivision.SelectedIndexChanged | FP01551_CalculationPopup.cs:208 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01551_CalculationPopup.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-991cfb24 | clbPlant.SelectedIndexChanged | FP01551_CalculationPopup.cs:197 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01551_CalculationPopup.clbSite_SelectedIndexChanged

진입점: clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e68c77ae | clbSite.SelectedIndexChanged | FP01551_CalculationPopup.cs:202 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01551_CalculationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95dc74f1 | this.Load | FP01551_CalculationPopup.cs:252 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-805bb4b2 | this.Load | FP01551_CalculationPopup.cs:253 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-248dcfef | this.Load | FP01551_CalculationPopup.cs:254 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_CalculationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-659e65f3 | this.Load | FP01551_CalculationPopup.cs:240 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_CalculationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84f05b7f | Dispose | FP01551_CalculationPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_CalculationPopup.EditButton

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton / EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7880fb68 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP01551_CalculationPopup.cs:337 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-36f00aee | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 3 | FP01551_CalculationPopup.cs:342 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME)… | 그리드 편집 잠금/해제 |  |  |  |

## FP01551_CalculationPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52ab3c81 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:373 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a99c2b64 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:374 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-99cf7bb9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:377 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-0918072c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:379 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { DataSet ret = Data_FP.CallGeneralProcedure("PR_UI_FP01551_ETC", Filter, CurrentUs… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ff8e3fe | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:381 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01551_ETC", Filter, CurrentUser, "SELECT", "CALCULATION_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1b636746 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:382 | lambda | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2e3b2637 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:386 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a0f54ad1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:391 | if (ds.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9cac622 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:394 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-7850d0ea | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:396 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d73bd0d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 2 | FP01551_CalculationPopup.cs:403 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_CalculationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-560036ea | this.Load | FP01551_CalculationPopup.cs:142 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-292cc7e2 | this.Load | FP01551_CalculationPopup.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_CalculationPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b0c9a6e | this.Load | FP01551_CalculationPopup.cs:215 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-13befb40 | this.Load | FP01551_CalculationPopup.cs:215 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-63533dbf | this.Load | FP01551_CalculationPopup.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_CalculationPopup.GetPlant

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb497d8f | this.Load 외 1 | FP01551_CalculationPopup.cs:232 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-75db9607 | this.Load 외 1 | FP01551_CalculationPopup.cs:232 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE_ID… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6eb27c61 | this.Load 외 1 | FP01551_CalculationPopup.cs:234 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_CalculationPopup.GetSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cafea580 | this.Load 외 1 | FP01551_CalculationPopup.cs:222 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-caba727c | this.Load 외 1 | FP01551_CalculationPopup.cs:222 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b255d17b | this.Load 외 1 | FP01551_CalculationPopup.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_CalculationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a207a22e | this.Load | FP01551_CalculationPopup.cs:162 |  | VALUE_SET | drpFixDate.Value | DateTime.ParseExact("19990101", "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-db3ae1f7 | this.Load | FP01551_CalculationPopup.cs:163 |  | VALUE_CLEAR | drpFixDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-48031faa | this.Load | FP01551_CalculationPopup.cs:166 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8729ed74 | this.Load | FP01551_CalculationPopup.cs:166 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-4bcb9b89 | this.Load | FP01551_CalculationPopup.cs:176 |  | VALUE_SET | clbDivision.ControlValues | pDivisionID | 컨트롤 값 설정 |  |  |  |
| AC-b9625399 | this.Load | FP01551_CalculationPopup.cs:177 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c980924b | this.Load | FP01551_CalculationPopup.cs:181 |  | VALUE_SET | clbSite.ControlValues | pSiteID | 컨트롤 값 설정 |  |  |  |
| AC-6ac28938 | this.Load | FP01551_CalculationPopup.cs:182 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-5b2715ae | this.Load | FP01551_CalculationPopup.cs:187 |  | VALUE_SET | clbSite.ControlValues | pPlantID | 컨트롤 값 설정 |  |  |  |
| AC-89043825 | this.Load | FP01551_CalculationPopup.cs:188 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01551_CalculationPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eea4d319 | this.Load | FP01551_CalculationPopup.cs:245 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5182db5f | this.Load | FP01551_CalculationPopup.cs:246 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01551_CalculationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b16003a8 | this.Load | FP01551_CalculationPopup.cs:267 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-63606cd6 | this.Load | FP01551_CalculationPopup.cs:269 |  | GRID_INIT | siMain.AddCheckColumn | ("CHK", DefColumns._CHK_ITEM, FPMerge.None, 30, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5223be64 | this.Load | FP01551_CalculationPopup.cs:270 |  | GRID_INIT | siMain.AddTextColumn | ("Company", DefColumns.COMPANY_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42c21c18 | this.Load | FP01551_CalculationPopup.cs:271 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36d32fb8 | this.Load | FP01551_CalculationPopup.cs:272 |  | GRID_INIT | siMain.AddTextColumn | ("Site", DefColumns.SITE_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b052acf | this.Load | FP01551_CalculationPopup.cs:273 |  | GRID_INIT | siMain.AddTextColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d65e241 | this.Load | FP01551_CalculationPopup.cs:274 |  | GRID_INIT | siMain.AddTextColumn | ("Cell Item", DefColumns.CELL_ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70cc1ddd | this.Load | FP01551_CalculationPopup.cs:275 |  | GRID_INIT | siMain.AddTextColumn | ("Nick Name", DefColumns.NICK_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d94cdbe9 | this.Load | FP01551_CalculationPopup.cs:283 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Cell… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-4b2e636e | this.Load | FP01551_CalculationPopup.cs:284 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Valu… | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4d4bea8 | this.Load | FP01551_CalculationPopup.cs:285 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Bord… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-436c7ba6 | this.Load | FP01551_CalculationPopup.cs:289 |  | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-ebe2ebdf | this.Load | FP01551_CalculationPopup.cs:291 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_CalculationPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce41749b | (진입점 미연결) | FP01551_CalculationPopup.cs:312 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_CalculationPopup.Save_Data

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save:] / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0541c4d1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:408 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ddbccefc | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:410 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13f41af1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:415 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-163c4559 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:416 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fcf428c4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:419 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3d173358 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:432 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-de059898 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:435 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-85a7a2d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:439 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-aa0c1f15 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:441 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f61dd26c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:442 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel… | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7f4b5dc9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:449 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-6ef39f6e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:453 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-aad4e2d9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:459 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (save_success == true) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-65a4354d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:464 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7b406490 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:468 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5a080164 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:469 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-42f0f581 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:473 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01551_CalculationPopup.Save_Data_Execute

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Save: ▸ try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12927467 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:486 | try | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-9fef9799 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:487 | try | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8f446a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:488 | try | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e38f6af1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:489 | try | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-aeece110 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:490 | try | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-762fbd03 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:491 | try | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-959a1351 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:492 | try | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b2ca803 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:493 | try | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-45920b80 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:494 | try | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-360e6806 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:506 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ba741c08 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:508 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-910a8f88 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:509 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-43f8df47 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:510 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd0782a6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:511 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["COMPANY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-791d8a1e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:512 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["SITE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b53dbed0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:513 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLANT_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ea69fc53 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:514 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["CELL_ITEM_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3d91460b | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:515 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-df2d95c6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:517 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf415439 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:522 | try | DATA_OP | Filter["BASIS_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-88921936 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:523 | try | DATA_OP | Filter["CREATE_PLAN_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-5fc9450a | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:527 | try ▸ if (drpFixDate.Value.ToString("yyyyMMdd") == "19990101") | DATA_OP | Filter["FIX_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-b736d579 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:530 | try ▸ else of (drpFixDate.Value.ToString("yyyyMMdd") == "19990101") | DATA_OP | Filter["FIX_DATE"] | drpFixDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-27d43306 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:533 | try | DATA_OP | Filter["COPY_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-c37802e5 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:534 | try | DATA_OP | Filter["TARGET_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-754776f0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:539 | try ▸ if (siMain.GetMaxRowIndex() == dt.Rows.Count) | DATA_OP | Filter["CAL_OPTION"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-f6fffead | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:541 | try ▸ if (siMain.GetMaxRowIndex() == dt.Rows.Count) | ENDPOINT | DataService.FP_RunProcedure | ("FP01551_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-17112f7e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:553 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01551_PlanAmend", "save_CalculationList", dt, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_CalculationList] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-f12142f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:559 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") | DATA_OP | Filter["CAL_OPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-dcb05e41 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:563 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01551_PlanAmend", "execute_psiCalcul", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Comm… | 엔드포인트 호출 |  |  |  |
| AC-883b6c76 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:570 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-9c46af90 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:590 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-143665a0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_CalculationPopup.cs:593 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP01551_CalculationPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-631b5b67 | SaveButton | FP01551_CalculationPopup.cs:350 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_CalculationPopup.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0b50d13 | (진입점 미연결) | FP01551_CalculationPopup.cs:297 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9779e35e | (진입점 미연결) | FP01551_CalculationPopup.cs:298 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-23b8f374 | (진입점 미연결) | FP01551_CalculationPopup.cs:302 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01551_CalculationPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ce6ea77 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:660 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-36ecfdd1 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:673 | if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d833f15 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:697 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9a4e9441 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:707 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-3527a316 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:711 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ if (chk_item.Equals("1")) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns._CHK_ITEM), false) | 그리드 값 설정 |  |  |  |
| AC-6bbc02b8 | this.spdMain.CellClick | FP01551_CalculationPopup.cs:715 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ else of (chk_item.Equals("1… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns._CHK_ITEM), true) | 그리드 값 설정 |  |  |  |

## FP01551_ConfirmHisPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfda8aed | this.Load | FP01551_ConfirmHisPopup.cs:96 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e4344a99 | this.Load | FP01551_ConfirmHisPopup.cs:97 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-125861f2 | this.Load | FP01551_ConfirmHisPopup.cs:98 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_ConfirmHisPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2749daec | this.Load | FP01551_ConfirmHisPopup.cs:86 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-a75fdced | this.Load | FP01551_ConfirmHisPopup.cs:91 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |

## FP01551_ConfirmHisPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bffd642f | Dispose | FP01551_ConfirmHisPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_ConfirmHisPopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64023679 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:134 |  | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP01551_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "CONFI… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1d09e9b6 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:136 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-38ada338 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:137 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-27dcbf48 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:140 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_ConfirmHisPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dcf562b | this.Load | FP01551_ConfirmHisPopup.cs:71 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_ConfirmHisPopup.InitSpread

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9e64045 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:105 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-081fc7eb | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:107 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm Date", DefColumns.CONFIRM_DATE, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f129aad | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:108 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm ID", DefColumns.CONFIRM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e4fcc90 | this.Load 외 2 | FP01551_ConfirmHisPopup.cs:109 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm Ver.", DefColumns.CONFIRM_PLAN_ID, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_ConfirmHisPopup.OkButtonClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-910572d8 | (진입점 미연결) | FP01551_ConfirmHisPopup.cs:164 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_ConfirmHisPopup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ba45545 | (진입점 미연결) | FP01551_ConfirmHisPopup.cs:171 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_In_House_Request_Plan..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-741bd3d1 | .ctor | FP01551_In_House_Request_Plan.cs:134 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8c5dd9 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1779 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3bb875d2 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1780 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9b67b432 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1781 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-badd97aa | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1782 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6b623961 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1783 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-8aab169e | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1786 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP01551_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP01… | 화면 필드/플래그 변경 |  |  |  |
| AC-c50c61c4 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1786 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01551_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP01… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-666bff3f | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1787 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP01551_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP01… | 화면 필드/플래그 변경 |  |  |  |
| AC-a711208d | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1787 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01551_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP01… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b8dab100 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1788 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP01551_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-6cca14ee | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1788 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01551_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2596cd07 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1789 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP01551_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP01… | 화면 필드/플래그 변경 |  |  |  |
| AC-c3ab2022 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1789 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01551_PlanAmend", "find_BukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Common\FP01… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a8286cda | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1801 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-7aef67ac | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1802 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-ba87fb34 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1803 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-bf3ca2a4 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1804 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab33f148 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1812 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-daa6e559 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1818 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["BUCKET_FROM"] = drpPeriod.Value1.ToString("yyyyMM… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4003b4f6 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1820 | lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-2183713c | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1821 | lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-8ddbf9c4 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1822 | lambda | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d6e5ef70 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1826 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboPlanId.SelectedIndex >= 0) { Filter["PLAN_ID"] = c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-429e0c77 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1830 | lambda ▸ if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-963f6888 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1835 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04d9e769 | this.btnBucket.Click | FP01551_In_House_Request_Plan.cs:2490 |  | POPUP | new FP01551_BucketSetForm_Popup | ("FP01551", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-6ff12ef5 | this.btnBucket.Click | FP01551_In_House_Request_Plan.cs:2492 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-a9d27cbd | this.btnBucket.Click | FP01551_In_House_Request_Plan.cs:2493 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f1c93015 | this.btnBucket.Click | FP01551_In_House_Request_Plan.cs:2494 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e7d790a1 | this.btnBucket.Click | FP01551_In_House_Request_Plan.cs:2498 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.btnCalculation_Click

진입점: this.btnCalculation2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ebed23 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2534 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-923785db | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2535 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85801666 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2541 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-52af81dd | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2542 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-991a0109 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2545 |  | POPUP | new FP01551_CalculationPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fe7e03bf | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2547 |  | VALUE_SET | calPop.Text | "Calculation" | 컨트롤 값 설정 |  |  |  |
| AC-03cb5e1f | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2548 |  | DATA_OP | calPop.Filter["MASTER_ID"] | calPop.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-721442ae | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2548 |  | DATA_OP | calPop.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-27119e38 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2549 |  | DATA_OP | calPop.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-05ff7ffc | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2550 |  | DATA_OP | calPop.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5a0e84c4 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2551 |  | DATA_OP | calPop.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8a4ee651 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2552 |  | DATA_OP | calPop.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c8a81203 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2553 |  | DATA_OP | calPop.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-c9201f5a | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2554 |  | DATA_OP | calPop.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-e175c808 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2555 |  | DATA_OP | calPop.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-2de99196 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2557 |  | DATA_OP | calPop.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a0e54522 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2558 |  | UI_PROP | calPop.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-29185d5a | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2559 |  | UI_PROP | calPop.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-da6024a1 | this.btnCalculation2.Click | FP01551_In_House_Request_Plan.cs:2560 |  | POPUP | calPop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a99544ce | this.btnCategory.Click | FP01551_In_House_Request_Plan.cs:2457 |  | POPUP | new FP01551_MeasureSetForm_Popup | ("FP01551", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-f7faf869 | this.btnCategory.Click | FP01551_In_House_Request_Plan.cs:2459 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-5758e1fd | this.btnCategory.Click | FP01551_In_House_Request_Plan.cs:2460 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-61431653 | this.btnCategory.Click | FP01551_In_House_Request_Plan.cs:2461 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b7531355 | this.btnCategory.Click | FP01551_In_House_Request_Plan.cs:2465 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61e5825c | this.btnColumn.Click | FP01551_In_House_Request_Plan.cs:2439 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP01551", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-358c5788 | this.btnColumn.Click | FP01551_In_House_Request_Plan.cs:2440 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-200529fb | this.btnColumn.Click | FP01551_In_House_Request_Plan.cs:2441 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.btnConfirm_Click

진입점: this.btnConfirm2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b53a2529 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:2574 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ca732930 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:2575 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71aea5b7 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:2581 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-b0ca46c2 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:2582 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-38c6734e | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:2588 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.btnConfirmHis_Click

진입점: this.btnConfirmHis2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0ad243b | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2637 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-e73ab3ed | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2638 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04a91975 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2641 |  | POPUP | new FP01551_ConfirmHisPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ef8108a6 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2643 |  | VALUE_SET | verPop.Text | "Confirm History" | 컨트롤 값 설정 |  |  |  |
| AC-01c1bbe9 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2644 |  | DATA_OP | verPop.Filter["MASTER_ID"] | verPop.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-11c78647 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2644 |  | DATA_OP | verPop.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fc4e7cfb | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2645 |  | DATA_OP | verPop.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ead10145 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2646 |  | DATA_OP | verPop.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8a540ac4 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2648 |  | UI_PROP | verPop.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-bc87bd8e | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2649 |  | UI_PROP | verPop.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-d0d40692 | this.btnConfirmHis2.Click | FP01551_In_House_Request_Plan.cs:2650 |  | POPUP | verPop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9234d51 | this.btnSql.Click | FP01551_In_House_Request_Plan.cs:1224 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e2407753 | this.btnSql.Click | FP01551_In_House_Request_Plan.cs:1225 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-988deb73 | this.btnSql.Click | FP01551_In_House_Request_Plan.cs:1227 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee7058af | this.btnSql.Click | FP01551_In_House_Request_Plan.cs:1228 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f73b88ca | this.btnToggleSave.Click | FP01551_In_House_Request_Plan.cs:2523 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP01551_In_House_Request_Plan.btnVersion_Click

진입점: this.btnVersion2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9b9a290 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2600 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-69d8d1da | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2601 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15543522 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2607 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-be94d16c | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2608 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b070572 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2611 |  | POPUP | new FP01551_VersionUp_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-e3405d9c | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2613 |  | VALUE_SET | verPop.Text | "Version Up" | 컨트롤 값 설정 |  |  |  |
| AC-ace5b54f | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2614 |  | DATA_OP | verPop.Filter["MASTER_ID"] | verPop.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8d2575c | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2614 |  | DATA_OP | verPop.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7a72e41 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2615 |  | DATA_OP | verPop.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-458130ff | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2616 |  | DATA_OP | verPop.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-28bea6b7 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2617 |  | DATA_OP | verPop.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aefa7be6 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2618 |  | DATA_OP | verPop.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-744f28c7 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2619 |  | DATA_OP | verPop.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-d424387b | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2620 |  | DATA_OP | verPop.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-3b4a20f3 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2621 |  | DATA_OP | verPop.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b6ec476 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2622 |  | DATA_OP | verPop.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6a26e567 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2624 |  | UI_PROP | verPop.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f9e68363 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2625 |  | UI_PROP | verPop.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-3d1ed633 | this.btnVersion2.Click | FP01551_In_House_Request_Plan.cs:2626 |  | POPUP | verPop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.cboPlanId_changed

진입점: this.Load / cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea2dff01 | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2266 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-da8df9ef | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2267 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f28da406 | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2290 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-81b8b623 | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2291 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-b6ac7ae9 | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2295 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-cb3eae5a | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:2296 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(55) | 속성 Value2 설정 |  |  |  |

## FP01551_In_House_Request_Plan.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ede2e71 | this.Load | FP01551_In_House_Request_Plan.cs:377 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-956fb502 | this.Load | FP01551_In_House_Request_Plan.cs:377 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-b40ec048 | this.Load | FP01551_In_House_Request_Plan.cs:379 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01551_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a7581193 | this.Load | FP01551_In_House_Request_Plan.cs:379 |  | POPUP | new FP01551_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a7e8359c | this.Load | FP01551_In_House_Request_Plan.cs:380 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01551_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-454832a4 | this.Load | FP01551_In_House_Request_Plan.cs:380 |  | POPUP | new FP01551_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-cf6851a3 | this.Load | FP01551_In_House_Request_Plan.cs:383 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c8bc7c4 | this.Load | FP01551_In_House_Request_Plan.cs:384 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee5939c6 | this.Load | FP01551_In_House_Request_Plan.cs:385 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8ae7fd9 | this.Load | FP01551_In_House_Request_Plan.cs:386 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-c2b97109 | this.Load | FP01551_In_House_Request_Plan.cs:387 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-e21fc3c9 | this.Load | FP01551_In_House_Request_Plan.cs:388 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.chk_Info_CheckedChanged

진입점: chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-baa24e32 | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2347 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblInsertId.Text | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-62d7e964 | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2348 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblInsertTime.Text | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-ca22ab81 | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2349 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblFixDate.Text | dtPlanId.Rows[0]["FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-2928612f | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2350 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblDescription.Text | dtPlanId.Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d936a701 | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2351 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConfirmPlanId.Text | dtPlanId.Rows[0]["CONFIRM_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9c17bc1a | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2352 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConId.Text | dtPlanId.Rows[0]["CONFIRM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-02c45ffe | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2353 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConDate.Text | dtPlanId.Rows[0]["CONFIRM_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d07d476a | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2359 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a381ab5 | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2359 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10fe08fd | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2365 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-ab1ec7ee | chk_Info.CheckedChanged | FP01551_In_House_Request_Plan.cs:2366 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP01551_In_House_Request_Plan.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c3c4bf5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2210 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-e457c700 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2211 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1eaf414 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2212 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5953770 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2213 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-09d6ae16 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2214 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-52e8c7ff | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2215 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-093cdd75 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2216 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c61a148 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2217 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d9ae583 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2218 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-30d13351 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2219 |  | DATA_OP | dt.Columns.Add | (new DataColumn("STORAGE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca9393f7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2220 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SOC_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-83bc7a12 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2221 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f47c419 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2222 |  | DATA_OP | dt.Columns.Add | (new DataColumn("REQUIRE_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9543f73c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2223 |  | DATA_OP | dt.Columns.Add | (new DataColumn("REQUIRE_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b70d7677 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2226 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORIG_REQUIRE_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c2ee75e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2229 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6b27b72 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2235 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c8ebedf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:2238 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.CreateFilterDataSet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b692558 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1279 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-4555606a | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1290 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-8b3bb50f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1291 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-b928bce1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1303 | if (measure["chk_s"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8666e447 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1307 | if (measure["chk_p"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c8ce648 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1311 | if (measure["chk_ship_result"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("DATA", "SS")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe74e3e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1315 | if (measure["chk_i"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(+Intransit)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fea35fe4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1319 | if (measure["chk_avail"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Available)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8e29749 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1323 | if (measure["chk_hold"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Hold)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-23dcdb26 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1329 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fe42355b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1330 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-e106e18d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1331 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SS")) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3b7729b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1332 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(+Intransit)", "TOTAL_2", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-259fffbc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1333 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Available)", "TOTAL_2", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3fe04eef | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1334 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Hold)", "TOTAL_2", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-0207894f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1337 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | (MainGo, chks_measure_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d04e863d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1338 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-165e7b3c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1342 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-1176d704 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1346 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-356600f1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1349 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-78787593 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1351 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2ce3a9c | this.Load | FP01551_In_House_Request_Plan.cs:322 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-79156941 | this.Load | FP01551_In_House_Request_Plan.cs:323 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f072206 | this.Load | FP01551_In_House_Request_Plan.cs:324 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_In_House_Request_Plan.dCalendar_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-372d88c1 | drpPeriod.ValueChanged | FP01551_In_House_Request_Plan.cs:2407 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48003131 | drpPeriod.ValueChanged | FP01551_In_House_Request_Plan.cs:2414 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-f42fda28 | drpPeriod.ValueChanged | FP01551_In_House_Request_Plan.cs:2415 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP01551_In_House_Request_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72dcc348 | DeleteButton | FP01551_In_House_Request_Plan.cs:659 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01551_In_House_Request_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c064ad8e | Dispose | FP01551_In_House_Request_Plan.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_In_House_Request_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efdcf03a | EditButton | FP01551_In_House_Request_Plan.cs:667 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |

## FP01551_In_House_Request_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87c84675 | ExcelButton | FP01551_In_House_Request_Plan.cs:1513 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01551_In_House_Request_Plan.FindMainData

진입점: popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN")] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ff94c90 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1759 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-f65c0ab8 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1763 | try | FLAG | dtCellAssyYN | DataService.FP_ExecuteQuery2("FP01551_PlanAmend", "find_CellAssyYN", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_CellAssyYN] \| FP\Common\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-fde14cff | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1763 | try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP01551_PlanAmend", "find_CellAssyYN", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_CellAssyYN] \| FP\Common\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a40ca990 | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1765 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6565ab9b | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1767 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-19edeb0b | popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUE… 외 7 | FP01551_In_House_Request_Plan.cs:1772 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01551_In_House_Request_Plan.FindTotalColorStart

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82ac9b7b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:574 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.FindTotalValue

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a12f5b1c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1735 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01551_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-82433229 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1736 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-aff61302 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1740 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01551_In_House_Request_Plan.fn_menuChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c649f2 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2662 | if (flo.Visible == false) ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-f17bc042 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2676 | if (flo.Visible == false) ▸ if (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnConfirm2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6fbf881d | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2677 | if (flo.Visible == false) ▸ if (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnCalculation2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7959437e | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2680 | if (flo.Visible == false) ▸ else of (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnConfirm2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5524d470 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2681 | if (flo.Visible == false) ▸ else of (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnCalculation2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b3885aa0 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2686 | if (flo.Visible == false) ▸ if (Int32.Parse(drpPlanDate.DateTime.ToString("yyyyMMdd")) < Int32.Parse(dtCurrDate.Rows[0]["CURR_DATE"].ToStrin… | STATE | btnVersion2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f5da1962 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:2690 | if (flo.Visible == false) ▸ else of (Int32.Parse(drpPlanDate.DateTime.ToString("yyyyMMdd")) < Int32.Parse(dtCurrDate.Rows[0]["CURR_DATE"].To… | STATE | btnVersion2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01551_In_House_Request_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-172bbc7d | this.Load | FP01551_In_House_Request_Plan.cs:178 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_In_House_Request_Plan.FP01551_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f3e436a | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1840 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.GetBasisTime

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-175cdf79 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3135 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-1603dc98 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3135 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01551_In_House_Request_Plan.GetConfirmFlag

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ed73fd4 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3106 |  | FLAG | dtConfirmFlag | Data_FP.CallGeneralProcedure2(("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-eb1b1ea3 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3106 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CONFIRM_FLAG") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01551_In_House_Request_Plan.GetConfrimInfo

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6e0f38d | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3118 |  | FLAG | dtConfirmInfo | Data_FP.CallGeneralProcedure2(("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-c0ee1eec | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3118 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CONFIRM_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-df0710d3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3122 | if (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmID.Text | dtConfirmInfo.Rows[0]["CONFIRM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3b5a90a1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3123 | if (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmDate.Text | dtConfirmInfo.Rows[0]["CONFIRM_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-464a06c7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3127 | else of (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmID.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-1b2b1288 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:3128 | else of (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmDate.Text | "-" | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.GetCurrDate

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-578c8405 | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:3113 |  | FLAG | dtCurrDate | Data_FP.Common_FP(Data_FP.Type.CURR_UTDATE, false, CurrentUser, _sNonAuth, _sSaveAuth, Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURR_UTDATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-da7f347f | this.Load 외 1 | FP01551_In_House_Request_Plan.cs:3113 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURR_UTDATE, false, CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURR_UTDATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP01551_In_House_Request_Plan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1535d5e6 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3065 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filte… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-658112e5 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3065 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"],… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab94b5b0 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3067 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6e2e17b | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3089 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 화면 필드/플래그 변경 |  |  |  |
| AC-80354296 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3089 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE_AMEND, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INST… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a0e63449 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3094 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.GetFilter

진입점: this.Load [if (dtPlanId.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / popSql.OnSql [if (programID == "PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN") ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == D…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3881ed17 | this.Load [if (dtPlanId.Good())] 외 11 | FP01551_In_House_Request_Plan.cs:3029 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.GetFpPlandId

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f6557fa | this.Load 외 3 | FP01551_In_House_Request_Plan.cs:3048 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-6b4419fe | this.Load 외 3 | FP01551_In_House_Request_Plan.cs:3048 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "RELEASE_PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c447f61f | this.Load 외 3 | FP01551_In_House_Request_Plan.cs:3049 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |
| AC-5341f6a7 | this.Load 외 3 | FP01551_In_House_Request_Plan.cs:3052 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-04cff903 | this.Load 외 3 | FP01551_In_House_Request_Plan.cs:3057 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.GetFpPlanId

진입점: this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK)] / this.btnConfirm2.Click [if (save_success == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e812c22 | this.btnVersion2.Click [if (verPop.ShowDialog() == DialogRes… 외 2 | FP01551_In_House_Request_Plan.cs:3100 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3a374bd | this.btnVersion2.Click [if (verPop.ShowDialog() == DialogRes… 외 2 | FP01551_In_House_Request_Plan.cs:3100 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01551_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "RELEASE_PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-65ee42ac | this.btnVersion2.Click [if (verPop.ShowDialog() == DialogRes… 외 2 | FP01551_In_House_Request_Plan.cs:3101 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.GetPlanGroup

진입점: this.Load / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendM…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97003613 | this.Load 외 8 | FP01551_In_House_Request_Plan.cs:3038 |  | FLAG | dtInstance | Data_FP.Common_FP(Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth ,… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d0b2d74 | this.Load 외 8 | FP01551_In_House_Request_Plan.cs:3039 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.AMEND_INSTANCE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=AMEND_INSTANCE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6d8e07ab | this.Load 외 8 | FP01551_In_House_Request_Plan.cs:3043 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad1fff84 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3080 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-a1e56679 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3080 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf621cad | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3082 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b99b4f8 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3073 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["I… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b26ea572 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3073 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , Filter["INSTANCE_ID"], nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5a69f95e | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:3075 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01551_In_House_Request_Plan.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3287bf8f | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1622 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP01551_In_House_Request_Plan.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bba57d37 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:674 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5be1f57 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:676 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-46047464 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:718 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20b0f4ff | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:719 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-0dd4c03e | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:748 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-81a7c59a | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:749 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-a696ccd0 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:778 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-74061992 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:779 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-67a0a20f | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:794 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01551_In_House_Request_Plan.GoEditMode

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d25961 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:800 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-65422f23 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:817 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-edcf0afa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:827 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-b9a14913 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:828 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-66b735ae | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:859 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bda30260 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:878 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (CHK_YN.Equals("Y")) ▸ if (colindex > -1) ▸ if… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font.Name, acell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-47bfab87 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:882 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (CHK_YN.Equals("Y")) ▸ if (colindex > -1) ▸ el… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font.Name, siMain.SpreadObject.Font.Size, Font… | 속성 Font 설정 |  |  |  |
| AC-d13f8559 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:891 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2ff49e27 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:892 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4b33bd9f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:904 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b1d5596 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:905 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-377d08d7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:922 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-e8d8ee13 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:939 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-d644fd97 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:945 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14597ecb | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:946 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01551_In_House_Request_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0aecc3b | this.Load | FP01551_In_House_Request_Plan.cs:193 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-275789ee | this.Load | FP01551_In_House_Request_Plan.cs:197 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-10704895 | this.Load | FP01551_In_House_Request_Plan.cs:198 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3609a859 | this.Load | FP01551_In_House_Request_Plan.cs:202 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-8ac89a26 | this.Load | FP01551_In_House_Request_Plan.cs:207 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-07b29987 | this.Load | FP01551_In_House_Request_Plan.cs:210 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-00afb6fd | this.Load | FP01551_In_House_Request_Plan.cs:212 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-8e93a4c5 | this.Load | FP01551_In_House_Request_Plan.cs:216 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e319b9bc | this.Load | FP01551_In_House_Request_Plan.cs:219 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7773a11d | this.Load | FP01551_In_House_Request_Plan.cs:220 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-1291ff0a | this.Load | FP01551_In_House_Request_Plan.cs:220 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b2a19cba | this.Load | FP01551_In_House_Request_Plan.cs:224 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-63089c33 | this.Load | FP01551_In_House_Request_Plan.cs:225 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP01551_In_House_Request_Plan.InitEditingBuf

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e27f5f2 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1852 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-9ae0ed2e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1853 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-53765c40 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1854 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-c004f344 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1855 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a637fde0 | this.Load | FP01551_In_House_Request_Plan.cs:291 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-6d516642 | this.Load | FP01551_In_House_Request_Plan.cs:292 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a6b40017 | this.Load | FP01551_In_House_Request_Plan.cs:293 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-92d75245 | this.Load | FP01551_In_House_Request_Plan.cs:294 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01551_In_House_Request_Plan.InitSpread

진입점: this.Load / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ tr…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a41a37b9 | this.Load 외 7 | FP01551_In_House_Request_Plan.cs:334 | try | DATA_OP | Filter["PROGRAM_ID"] | "FP01551" | 행/컬럼 값 대입 |  |  |  |
| AC-4cfd5634 | this.Load 외 7 | FP01551_In_House_Request_Plan.cs:335 | try | DATA_OP | Filter["SHEET_NAME"] | "AMEND" | 행/컬럼 값 대입 |  |  |  |
| AC-e486c639 | this.Load 외 7 | FP01551_In_House_Request_Plan.cs:350 | try | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cd45ae56 | this.Load 외 7 | FP01551_In_House_Request_Plan.cs:351 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-1b1a58fb | this.Load 외 7 | FP01551_In_House_Request_Plan.cs:356 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP01551_In_House_Request_Plan.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8da04ef5 | InsertButton | FP01551_In_House_Request_Plan.cs:627 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-850239c3 | InsertButton | FP01551_In_House_Request_Plan.cs:635 | if (row != null) | POPUP | new FP01551_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-f482466e | InsertButton | FP01551_In_House_Request_Plan.cs:636 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-5473229e | InsertButton | FP01551_In_House_Request_Plan.cs:636 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-421a86c9 | InsertButton | FP01551_In_House_Request_Plan.cs:637 | if (row != null) | UI_PROP | popup.FilterDateMap | dateMap | 속성 FilterDateMap 설정 |  |  |  |
| AC-4aa99084 | InsertButton | FP01551_In_House_Request_Plan.cs:639 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cb582395 | InsertButton | FP01551_In_House_Request_Plan.cs:640 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dd8a7df1 | InsertButton | FP01551_In_House_Request_Plan.cs:651 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP01551_In_House_Request_Plan.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46a2c530 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1582 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01551_In_House_Request_Plan.PasteAuto

진입점: this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7934c414 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP01551_In_House_Request_Plan.cs:2808 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0ea1502 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP01551_In_House_Request_Plan.cs:2809 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |

## FP01551_In_House_Request_Plan.planday_changed

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c962264 | this.Load 외 2 | FP01551_In_House_Request_Plan.cs:2331 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.RefreshHeader

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32210cac | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:395 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-b7e3f859 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:396 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-9246bfaa | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:397 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-ad980978 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:398 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-7dac8a73 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:414 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-463cae44 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:417 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-d80523a3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:418 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2726f339 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:419 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40f965c3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:420 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c00bfe0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:423 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92656792 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:424 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc0a324c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:426 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-8c165c31 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:428 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-220dabe9 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:431 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (22) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9f13da7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:433 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-351e75e7 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:469 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-ad0bf857 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:488 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0d04940 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:492 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-9db41d8e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:494 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d3c1258 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:498 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c885d8ba | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:513 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-0137ca25 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 8 | FP01551_In_House_Request_Plan.cs:528 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP01551_In_House_Request_Plan.RefreshHeaderOnly

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-184522ff | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01551_In_House_Request_Plan.cs:541 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-5098a607 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01551_In_House_Request_Plan.cs:542 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("MEASURE_ID") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-5aa00a61 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01551_In_House_Request_Plan.cs:543 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72bc643e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01551_In_House_Request_Plan.cs:544 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab094de3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01551_In_House_Request_Plan.cs:545 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_In_House_Request_Plan.RefreshSpreadSheet

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != null)] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.Activ…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0f9a8f5 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1492 |  | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-0b98c384 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1494 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-47fb90cf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 7 | FP01551_In_House_Request_Plan.cs:1500 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP01551_In_House_Request_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be96dcb | popSql.OnSql | FP01551_In_House_Request_Plan.cs:1718 | if (programID == "PR_UI_FP01551_IN_HOUSE_REQUEST_PLAN") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-4db7a349 | popSql.OnSql | FP01551_In_House_Request_Plan.cs:1720 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.Save_Confirm

진입점: this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f7b67b3 | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1171 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e55249e | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1172 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2ca5bc0e | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1178 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-57d38f36 | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1195 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01551_PlanAmend", "execute_confirm", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-a8a817f7 | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1199 | try ▸ catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-37e0fd85 | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1202 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP01551_PlanAmend", "execute_planSend", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-e7793669 | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1208 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-1503c4eb | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1209 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ca37b55e | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1213 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0b4934bf | this.btnConfirm2.Click [try ▸ if (MessageBox.Show("Do you wa… | FP01551_In_House_Request_Plan.cs:1218 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6de826c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:966 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ddbf2e6f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:976 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8234c895 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:977 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-000bc076 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:983 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-eeac1125 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:986 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-244a9fa2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:991 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-3e489e4b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:992 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0d5d59c4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:993 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0865a9fa | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1015 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a36afbd6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1023 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f96f7d0c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1024 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-daa9941b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1025 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-27c59fed | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1026 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-2e567d33 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1027 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b4305661 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1028 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfdf9a18 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1029 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfa5afc2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1030 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("STORAGE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-42b2e3bd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1031 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SOC_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-511f9a7d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1032 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc74c220 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1033 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("REQUIRE_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7762c908 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1034 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ef0cbd4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1021 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-53781e71 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1060 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-709600fd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1065 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["REQUIRE_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-c226bc48 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1066 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-82a88ecc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1078 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-08ddad36 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1080 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-34e57303 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1081 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-9a20cb0e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1082 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-172e8a3e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1083 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ca1c1cbf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1084 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8cc7be14 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1085 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2bdcb41b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1086 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3c3dc45 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1087 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["STORAGE_ID"] | enum_row_from_Saving["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0e0f00d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1088 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SOC_ID"] | enum_row_from_Saving["SOC_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-146e4d17 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1089 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8539dcc5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1090 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["REQUIRE_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-65b06d25 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1091 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5ce19156 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1092 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CELL_ITEM_ID"] | enum_row_from_Saving["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b2e9f5df | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1096 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["REQUIRE_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-fde19c67 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1097 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORIG_REQUIRE_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-6ac3a698 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1100 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-7da107c2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1102 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2bf0992 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1120 | try | DATA_OP | objDs.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e27ee6b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1122 | try ▸ if (!objDs.Columns.Contains("USER_ID")) | DATA_OP | objDs.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-51fbc2d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1125 | try ▸ if (!objDs.Columns.Contains("USER_ID")) ▸ foreach (DataRow dr in objDs.Rows) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5ef81468 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1129 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP01551_PlanAmend", "merge_data", objDs.DataSet, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] \| FP\Common\FP01551… | 엔드포인트 호출 |  |  |  |
| AC-c1d24e41 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1151 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-48976d22 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1152 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f7916bbc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1156 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fcdcd160 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01551_In_House_Request_Plan.cs:1158 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54372b0a | SaveButton | FP01551_In_House_Request_Plan.cs:955 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9def14c7 | SaveButton | FP01551_In_House_Request_Plan.cs:957 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01551_In_House_Request_Plan.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f2fd11 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1248 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6832f5f8 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1249 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f6f10d5 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1254 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-2aadda1e | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1260 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-176c0308 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1261 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-df732fb7 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1262 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4d1026 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1263 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0f254ce8 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1264 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-67c42b9a | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1265 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac5e0e1 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1266 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-263db154 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1267 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f08def3 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:1271 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / cboPlanId.SelectedIndexChanged [if (old_plan_type != Filter["PLAN_TYPE"].SafeString())] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5139d803 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:242 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7789053e | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:242 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-32645a76 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:251 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-27df7d07 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:251 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c3dd32f9 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:252 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-850e2082 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:258 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d6f071b0 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:259 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c48c217e | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:259 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e3b66e2a | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:260 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e4d9f26f | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:266 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-af2e40f6 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:267 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-21eba9b0 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:267 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7ad823e9 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:268 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-873d6e94 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:274 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-e0f1266b | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:275 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-3cfaf646 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:275 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-2a932455 | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:276 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-489f8cdb | this.Load 외 6 | FP01551_In_House_Request_Plan.cs:282 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4356078 | this.Load | FP01551_In_House_Request_Plan.cs:144 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3c130db | this.Load | FP01551_In_House_Request_Plan.cs:146 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-0f603bbf | this.Load | FP01551_In_House_Request_Plan.cs:147 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bddcf906 | this.Load | FP01551_In_House_Request_Plan.cs:148 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-1ebbfadd | this.Load | FP01551_In_House_Request_Plan.cs:152 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-78c994d1 | this.Load | FP01551_In_House_Request_Plan.cs:153 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3901e14f | this.Load | FP01551_In_House_Request_Plan.cs:154 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d8296fdb | this.Load | FP01551_In_House_Request_Plan.cs:156 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-5901c1d3 | this.Load | FP01551_In_House_Request_Plan.cs:157 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dca8626e | this.Load | FP01551_In_House_Request_Plan.cs:159 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-69374582 | this.Load | FP01551_In_House_Request_Plan.cs:160 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-71bd9a65 | this.Load | FP01551_In_House_Request_Plan.cs:161 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-92a7848b | this.Load | FP01551_In_House_Request_Plan.cs:165 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-b1357f2e | this.Load | FP01551_In_House_Request_Plan.cs:166 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a286c6b9 | this.Load | FP01551_In_House_Request_Plan.cs:167 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01551_In_House_Request_Plan.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4624e14 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP01551_In_House_Request_Plan.cs:3170 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.SetFilter

진입점: this.Load / cboInstance.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboPlanId.SelectedIndexChanged [if (dtPlanId.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTAN…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d291901 | this.Load 외 19 | FP01551_In_House_Request_Plan.cs:3024 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01551_In_House_Request_Plan.SetPlanOut

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ddb52cb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1865 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-36810806 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1870 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-b4de2352 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1876 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-ab2179f5 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1909 | if (dsMainFiltered.Good()) ▸ if (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | EditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-3ccf3a94 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1910 | if (dsMainFiltered.Good()) ▸ if (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-019d1453 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1920 | if (dsMainFiltered.Good()) ▸ else of (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62468d19 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1929 | if (dsMainFiltered.Good()) ▸ if (Clipboard && org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-199cfe02 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1933 | if (dsMainFiltered.Good()) ▸ if (Clipboard) | DATA_OP | clicked_row[ColumnName_Buf] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-6c4c4d69 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:1962 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c3e34a01 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2071 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_avail") | 데이터 객체 조작/조회 |  |  |  |
| AC-17cbd04a | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2078 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_avail")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-76547868 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2083 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_avail")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PLANT_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-8d93e38f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2113 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_avail")) ▸ if (rowDay.Length > 0) ▸ if (rowInventory.Length > 0) ▸ while (!st… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |
| AC-992ef432 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2135 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_i") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6e53f9c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2142 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_i")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b3e2c14 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2147 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_i")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PLANT_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-301bf8e0 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01551_In_House_Request_Plan.cs:2177 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_i")) ▸ if (rowDay.Length > 0) ▸ if (rowInventory.Length > 0) ▸ while (!string… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-627963a7 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:364 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-365142b8 | (진입점 미연결) | FP01551_In_House_Request_Plan.cs:365 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78138110 | this.spdMain.ButtonClicked | FP01551_In_House_Request_Plan.cs:3008 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d749ed07 | this.spdMain.CellClick | FP01551_In_House_Request_Plan.cs:2924 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a1548c0 | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3190 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | POPUP | new FP01551_ItemCMA_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-3d106694 | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3192 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e964f86a | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3193 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f1b1a08e | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3194 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-33104d4d | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3195 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["STORAGE_ID"] | row["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c0be4760 | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3196 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c90a5b3c | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3198 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-5ca6e17e | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3199 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-53e8f575 | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3200 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e2aafb3 | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3202 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | UI_PROP | cmaPopup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f6f5073a | this.spdMain.CellDoubleClick | FP01551_In_House_Request_Plan.cs:3203 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | POPUP | cmaPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35df178b | this.spdMain.Change | FP01551_In_House_Request_Plan.cs:3002 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a88d04e8 | this.spdMain.ChildControlDeactivated | FP01551_In_House_Request_Plan.cs:2954 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9566f8f | this.spdMain.ClipboardPasted | FP01551_In_House_Request_Plan.cs:2869 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-adcbced3 | this.spdMain.ClipboardPasted | FP01551_In_House_Request_Plan.cs:2874 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-74dd87ba | this.spdMain.ClipboardPasted | FP01551_In_House_Request_Plan.cs:2878 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5012ccc0 | this.spdMain.ClipboardPasted | FP01551_In_House_Request_Plan.cs:2880 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08eda16a | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2708 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-7ecdb439 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2709 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1948d803 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2711 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a62d45bf | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2714 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ed9f363 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2716 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3bad195e | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2720 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-55dd164a | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2736 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-05cfbe48 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2747 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) ▸ for (i < ClipRowCount) ▸ for (j < cells.Length) | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-438b097e | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2759 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9592f69d | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2760 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-82d371dc | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2765 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dfe356e8 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2780 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | GRID_SET | siMain.ActiveSheet.Cells[startrow, startcol].Value | src_copy | 그리드 속성/값 설정 |  |  |  |
| AC-ea6f2170 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2785 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a317852c | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2788 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a276b185 | this.spdMain.ClipboardPasting | FP01551_In_House_Request_Plan.cs:2790 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2ccbd24 | this.spdMain.DragFillBlockCompleted | FP01551_In_House_Request_Plan.cs:2964 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1b6456c | this.spdMain.EditChange | FP01551_In_House_Request_Plan.cs:2919 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82a57262 | this.spdMain.EditModeOff | FP01551_In_House_Request_Plan.cs:2982 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b5e82aa | this.spdMain.EditModeOn | FP01551_In_House_Request_Plan.cs:2988 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-0648ea92 | this.spdMain.EditModeOn | FP01551_In_House_Request_Plan.cs:2989 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db0061ad | this.spdMain.EditorFocused | FP01551_In_House_Request_Plan.cs:2976 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82db8754 | this.spdMain.Enter | FP01551_In_House_Request_Plan.cs:2939 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a8e27c8 | this.spdMain.Leave | FP01551_In_House_Request_Plan.cs:2934 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b0f3555 | this.spdMain.SubEditorClosed | FP01551_In_House_Request_Plan.cs:2970 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab48ebb8 | this.spdMain.SubEditorOpening | FP01551_In_House_Request_Plan.cs:2959 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081440a2 | this.spdMain.TableChanged | FP01551_In_House_Request_Plan.cs:2907 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cfa2188c | this.spdMain.TableChanged | FP01551_In_House_Request_Plan.cs:2909 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e2fcb3 | this.spdMain.TextChanged | FP01551_In_House_Request_Plan.cs:2890 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-03546a43 | this.spdMain.TextChanged | FP01551_In_House_Request_Plan.cs:2892 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad49fc92 | this.spdMain.Validated | FP01551_In_House_Request_Plan.cs:2944 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288108b7 | this.spdMain.Validating | FP01551_In_House_Request_Plan.cs:2949 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01551_In_House_Request_Plan.UIFindData

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnVersion2.Click [if (verPop.ShowDialog() == DialogResult.OK)] / this.btnCalculation2.Click [if (calPop.ShowDialog() == DialogResult.OK)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton [if (save_success == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34d3addf | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1362 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13df3b09 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1363 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4abadb0 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1366 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-90173626 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1370 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-1dd6c9b1 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1374 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-86abdea4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1375 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46f61e9c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1379 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d3e0a4e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1400 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-65a90920 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1404 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-35b6a200 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1405 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a1b0511b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1409 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1a0fb63b | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1419 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-07de1a19 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1421 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-18888f59 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1421 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5bbb6d1c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1427 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-c384c605 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1429 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-2689a11e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1432 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c47278dc | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1445 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6cde7e3f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1449 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e09d53f4 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1455 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ae21c8e3 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1459 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4c85da6f | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1467 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4d967e2e | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1473 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-06482097 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 6 | FP01551_In_House_Request_Plan.cs:1477 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01551_In_House_Request_Plan.UISaveConfirm

진입점: this.btnConfirm2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12b35c26 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:1554 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-85b044c1 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:1557 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4f3f0b3f | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:1559 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98392be4 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:1566 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-26f45e56 | this.btnConfirm2.Click | FP01551_In_House_Request_Plan.cs:1571 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_In_House_Request_Plan.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0bc1490f | SaveButton | FP01551_In_House_Request_Plan.cs:1523 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-4b95a18d | SaveButton | FP01551_In_House_Request_Plan.cs:1526 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-38a69a53 | SaveButton | FP01551_In_House_Request_Plan.cs:1528 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c10933a | SaveButton | FP01551_In_House_Request_Plan.cs:1535 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-be4ed0e5 | SaveButton | FP01551_In_House_Request_Plan.cs:1540 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_ItemCMA_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a3718f4 | this.Load | FP01551_ItemCMA_Popup.cs:140 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe0d26d9 | this.Load | FP01551_ItemCMA_Popup.cs:141 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6e3b797 | this.Load | FP01551_ItemCMA_Popup.cs:142 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_ItemCMA_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-826ce81a | this.Load | FP01551_ItemCMA_Popup.cs:135 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_ItemCMA_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d1d5bba | Dispose | FP01551_ItemCMA_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_ItemCMA_Popup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c7d214c | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:210 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-86db887f | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:211 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1192b7d2 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:213 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2cfdec2a | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:214 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7d895a8e | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:215 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e262d866 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:216 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-639a448d | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:219 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f018e02e | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:221 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { string bulk_info = DataService.ToLoopParam("", bukInfo); Filter["BUCKET"] = bulk_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4308def1 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:224 | lambda | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-82efc03f | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:226 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP01551_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-321268b5 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:228 | lambda | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-eac34cf8 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:232 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-912a304a | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:233 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-bf9dbc9a | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:234 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4c7450d2 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:237 |  | GRID_INIT | siMain.SetSheetHeaderDateColumn_FP | (calendar, false, false, true, 2, DateColumnType.QTY) | 그리드 재구성/초기화 |  |  |  |
| AC-209554b3 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:239 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4989cbac | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:241 |  | GRID_LOCK | siMain.LockColumn | (0, max_col - added, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d164f003 | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:244 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-3ffa82bd | this.Load 외 1 | FP01551_ItemCMA_Popup.cs:248 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_ItemCMA_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8047c96c | this.Load | FP01551_ItemCMA_Popup.cs:107 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4e6073f | this.Load | FP01551_ItemCMA_Popup.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-eb9cf3af | this.Load | FP01551_ItemCMA_Popup.cs:117 |  | DATA_OP | Filter["BUCKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-ab22c0ea | this.Load | FP01551_ItemCMA_Popup.cs:119 |  | DATA_OP | Filter["BUCKET_TO"] | DateUtil.GetDateAdd(Filter["BUCKET_FROM"], 55, "D") | 행/컬럼 값 대입 |  |  |  |

## FP01551_ItemCMA_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d9046dc | this.Load | FP01551_ItemCMA_Popup.cs:152 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-585a572f | this.Load | FP01551_ItemCMA_Popup.cs:153 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_ItemCMA_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0781d4d9 | (진입점 미연결) | FP01551_ItemCMA_Popup.cs:172 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_ItemCMA_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19439859 | this.Load | FP01551_ItemCMA_Popup.cs:159 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-124ff9e6 | this.Load | FP01551_ItemCMA_Popup.cs:160 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-33bde56d | this.Load | FP01551_ItemCMA_Popup.cs:164 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01551_ItemCMA_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-437cf99f | this.spdMain.CellClick | FP01551_ItemCMA_Popup.cs:273 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-248f40da | this.spdMain.CellClick | FP01551_ItemCMA_Popup.cs:274 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a3a8f9f7 | this.spdMain.CellClick | FP01551_ItemCMA_Popup.cs:277 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01551_ItemCMA_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-867c1bbe | this.spdMain.CellDoubleClick | FP01551_ItemCMA_Popup.cs:283 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-355f23d5 | this.spdMain.CellDoubleClick | FP01551_ItemCMA_Popup.cs:284 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3ae0d81d | this.spdMain.CellDoubleClick | FP01551_ItemCMA_Popup.cs:287 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-6cba1d1d | this.spdMain.CellDoubleClick | FP01551_ItemCMA_Popup.cs:290 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1cb4f81 | this.spdMain.CellDoubleClick | FP01551_ItemCMA_Popup.cs:300 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-922768a4 | this.btnButtonList.UsrButtonList_Click_Detected | FP01551_ItemPopup.cs:264 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-74d947ca | this.btnButtonList.UsrButtonList_Click_Detected | FP01551_ItemPopup.cs:267 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-32634c3e | this.btnButtonList.UsrButtonList_Click_Detected | FP01551_ItemPopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-967483f2 | this.Load | FP01551_ItemPopup.cs:136 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-514e7d23 | this.Load | FP01551_ItemPopup.cs:137 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-52ae2ea2 | this.Load | FP01551_ItemPopup.cs:138 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a12d1ab | this.Load | FP01551_ItemPopup.cs:131 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-394fbf44 | Dispose | FP01551_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-137b9bd3 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:207 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8762c428 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:211 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d839f140 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:213 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { Filter["ITEM_ID"] = txtItem.Text; Filter["CELL_ITEM_ID"] = txtItem.Text; Filter["… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b98a05ce | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:215 | lambda | DATA_OP | Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d7731c3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:216 | lambda | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-36e82cc0 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:217 | lambda | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-0dc3664c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:221 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01551_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ddb48a13 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:223 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-d1669a05 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:227 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f3369731 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:230 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eb53666e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01551_ItemPopup.cs:232 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01551_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a53a94c | this.Load | FP01551_ItemPopup.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-39df25ef | this.Load | FP01551_ItemPopup.cs:103 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29425535 | this.Load | FP01551_ItemPopup.cs:148 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eaa1d235 | this.Load | FP01551_ItemPopup.cs:149 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-463843cc | (진입점 미연결) | FP01551_ItemPopup.cs:168 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0851cb6d | this.Load | FP01551_ItemPopup.cs:155 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-750fea7f | this.Load | FP01551_ItemPopup.cs:156 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-a5afb4be | this.Load | FP01551_ItemPopup.cs:160 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01551_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d214a7c | this.spdMain.CellClick | FP01551_ItemPopup.cs:279 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ae052451 | this.spdMain.CellClick | FP01551_ItemPopup.cs:280 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-13ef4427 | this.spdMain.CellClick | FP01551_ItemPopup.cs:283 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01551_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-969a7c06 | this.spdMain.CellDoubleClick | FP01551_ItemPopup.cs:289 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-d72fef53 | this.spdMain.CellDoubleClick | FP01551_ItemPopup.cs:290 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1d4a0b7a | this.spdMain.CellDoubleClick | FP01551_ItemPopup.cs:293 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-91a0a4ff | this.spdMain.CellDoubleClick | FP01551_ItemPopup.cs:296 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-213d268e | this.spdMain.CellDoubleClick | FP01551_ItemPopup.cs:306 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6cacd32 | .ctor | FP01551_LineAddPopup.cs:98 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-11574802 | .ctor | FP01551_LineAddPopup.cs:99 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP01551_LineAddPopup.btnCellItem_Click

진입점: this.btnCellItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed5f0cf2 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:520 |  | POPUP | new FP01551_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-41582b39 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:521 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-e6f77b5e | this.btnCellItem.Click | FP01551_LineAddPopup.cs:523 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c977e5c1 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:524 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cba9adfe | this.btnCellItem.Click | FP01551_LineAddPopup.cs:525 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-994c3982 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:526 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3099045a | this.btnCellItem.Click | FP01551_LineAddPopup.cs:527 |  | DATA_OP | popup.Filter["CELL_ITEM_ID"] | Filter["CELL_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f7b7c835 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:528 |  | DATA_OP | popup.Filter["NICK_NAME"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-8f97a194 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:530 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-632929aa | this.btnCellItem.Click | FP01551_LineAddPopup.cs:532 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f26e8794 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:537 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["COMPANY_ID"] | data["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d848970 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:538 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["DIVISION_ID"] | data["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8d20609a | this.btnCellItem.Click | FP01551_LineAddPopup.cs:539 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["SITE_ID"] | data["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ced652b7 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:540 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-68cf1b65 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:541 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["MARKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-13bb2364 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:542 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4cac5312 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:543 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text = data["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-312dfc37 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:543 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["CELL_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-b55d2896 | this.btnCellItem.Click | FP01551_LineAddPopup.cs:545 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["STORAGE_ID"] | txtSloc.Text = string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-547d37ba | this.btnCellItem.Click | FP01551_LineAddPopup.cs:545 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtSloc.Text | string.Empty | 컨트롤 값 비움 |  |  |  |

## FP01551_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-651667b1 | this.btnClose.Click | FP01551_LineAddPopup.cs:243 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc9e4319 | this.btnSave.Click | FP01551_LineAddPopup.cs:236 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01551_LineAddPopup.btnSloc_Click

진입점: this.btnSloc.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3f407cc | this.btnSloc.Click | FP01551_LineAddPopup.cs:487 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert Cell Item value") | 메시지 표시 |  |  |  |
| AC-0f3af9cf | this.btnSloc.Click | FP01551_LineAddPopup.cs:488 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0030a96b | this.btnSloc.Click | FP01551_LineAddPopup.cs:490 |  | POPUP | new FP01551_StoragePopup | () | 팝업/폼 생성 |  |  |  |
| AC-e8f1d04a | this.btnSloc.Click | FP01551_LineAddPopup.cs:491 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-6da49d35 | this.btnSloc.Click | FP01551_LineAddPopup.cs:493 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d0ec5b99 | this.btnSloc.Click | FP01551_LineAddPopup.cs:494 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-88ff626a | this.btnSloc.Click | FP01551_LineAddPopup.cs:495 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e05534d8 | this.btnSloc.Click | FP01551_LineAddPopup.cs:496 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef193f16 | this.btnSloc.Click | FP01551_LineAddPopup.cs:497 |  | DATA_OP | popup.Filter["CELL_ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-a955e131 | this.btnSloc.Click | FP01551_LineAddPopup.cs:498 |  | DATA_OP | popup.Filter["MARKET"] | Filter["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-56d329aa | this.btnSloc.Click | FP01551_LineAddPopup.cs:499 |  | DATA_OP | popup.Filter["STORAGE_ID"] | Filter["STORAGE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bbd806ef | this.btnSloc.Click | FP01551_LineAddPopup.cs:501 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a41529ed | this.btnSloc.Click | FP01551_LineAddPopup.cs:503 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d19ef32b | this.btnSloc.Click | FP01551_LineAddPopup.cs:508 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["STORAGE_ID"] | txtSloc.Text = data["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e96f4ee2 | this.btnSloc.Click | FP01551_LineAddPopup.cs:508 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtSloc.Text | data["STORAGE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP01551_LineAddPopup.cboTransport_changed

진입점: cboTransport.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0316726 | cboTransport.SelectedIndexChanged | FP01551_LineAddPopup.cs:226 |  | DATA_OP | Filter["TRANSPORT"] | CString.GetCheckedListValue(dtTransport, cboTransport.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01551_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8fc7c696 | this.btnSave.Click | FP01551_LineAddPopup.cs:255 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Select Cell Code") | 메시지 표시 |  |  |  |
| AC-4d83f596 | this.btnSave.Click | FP01551_LineAddPopup.cs:256 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ca059aa0 | this.btnSave.Click | FP01551_LineAddPopup.cs:261 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | MESSAGE | MessageBox.Show | ("You need to select ERP Sloc.") | 메시지 표시 |  |  |  |
| AC-56f09eb1 | this.btnSave.Click | FP01551_LineAddPopup.cs:262 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d8664e46 | this.btnSave.Click | FP01551_LineAddPopup.cs:267 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | MESSAGE | MessageBox.Show | ("You need to select Transport") | 메시지 표시 |  |  |  |
| AC-7b780dc1 | this.btnSave.Click | FP01551_LineAddPopup.cs:268 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-091c4c79 | this.btnSave.Click | FP01551_LineAddPopup.cs:273 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-4bb4806e | this.btnSave.Click | FP01551_LineAddPopup.cs:274 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9725c50f | this.btnSave.Click | FP01551_LineAddPopup.cs:282 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-f4e23f5b | this.btnSave.Click | FP01551_LineAddPopup.cs:283 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-68282729 | this.btnSave.Click | FP01551_LineAddPopup.cs:288 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01551_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af60f52 | Dispose | FP01551_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_LineAddPopup.dpPlanDate_ValueChanged

진입점: dpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ffd5206 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:435 | try | DATA_OP | dtDateMap.Select("IS_PLAN = 'Y' ", "_DATE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34eb4388 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:435 | try | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' ", "_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e3c24cb0 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:440 | try | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' AND _DATE = '" + dpPlanDate.Value.ToString("yyyMMdd") + "'", "_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7d44779 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:444 | try ▸ if (isYN) | DATA_OP | Filter["DATE"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-6c303018 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:451 | try ▸ else of (isYN) | MESSAGE | MessageBox.Show | ("Out of plan period '" + sStartDate + "' ~ '" + sEndDate + "'") | 메시지 표시 |  |  |  |
| AC-46c530d4 | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:452 | try ▸ else of (isYN) | VALUE_SET | dpPlanDate.Text | Filter["DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-4a08b08e | dpPlanDate.ValueChanged | FP01551_LineAddPopup.cs:460 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01551_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97814c72 | this.Load | FP01551_LineAddPopup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2661252 | this.Load | FP01551_LineAddPopup.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f8e21c8c | this.Load | FP01551_LineAddPopup.cs:121 |  | FLAG | dtSave | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-5e6c9bc7 | this.Load | FP01551_LineAddPopup.cs:123 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e71f9533 | this.Load | FP01551_LineAddPopup.cs:124 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bdcfec11 | this.Load | FP01551_LineAddPopup.cs:125 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-86be68c5 | this.Load | FP01551_LineAddPopup.cs:126 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc9dc8e1 | this.Load | FP01551_LineAddPopup.cs:127 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ea75e60c | this.Load | FP01551_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-58b9d39d | this.Load | FP01551_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8287d22 | this.Load | FP01551_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("STORAGE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-a14fda45 | this.Load | FP01551_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SOC_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-14379935 | this.Load | FP01551_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-97c88ddc | this.Load | FP01551_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b4a225e1 | this.Load | FP01551_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3a3a15e | this.Load | FP01551_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-9b3d8a83 | this.Load | FP01551_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2ffad3e | this.Load | FP01551_LineAddPopup.cs:137 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP01551_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc8b6256 | this.Load | FP01551_LineAddPopup.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0628ff5 | this.Load | FP01551_LineAddPopup.cs:151 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-9f0c3064 | this.Load | FP01551_LineAddPopup.cs:152 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-f7329d9c | this.Load | FP01551_LineAddPopup.cs:153 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c6b0c5f1 | this.Load | FP01551_LineAddPopup.cs:157 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-81efb0c9 | this.Load | FP01551_LineAddPopup.cs:159 |  | DATA_OP | Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-3e41b3c5 | this.Load | FP01551_LineAddPopup.cs:160 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-860ad47a | this.Load | FP01551_LineAddPopup.cs:163 |  | DATA_OP | dtDateMap.Select("IS_PLAN = 'Y' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6ada861b | this.Load | FP01551_LineAddPopup.cs:163 |  | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-54c435ca | this.Load | FP01551_LineAddPopup.cs:165 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-e1d4a3e3 | this.Load | FP01551_LineAddPopup.cs:169 |  | FLAG | dtTransport | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01551_LineAddPopup", "TRANSPORT_T… | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b8b456 | this.Load | FP01551_LineAddPopup.cs:169 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01551_LineAddPopup", "TRANSPORT_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-17efadf3 | this.Load | FP01551_LineAddPopup.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransport, cboTransport, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c0f18fab | this.Load | FP01551_LineAddPopup.cs:193 |  | VALUE_SET | txtItem.Text | Filter["CELL_ITEM_ID"] = InitRow["CELL_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-cc7d1bfc | this.Load | FP01551_LineAddPopup.cs:193 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ddc82061 | this.Load | FP01551_LineAddPopup.cs:195 |  | DATA_OP | Filter["COMPANY_ID"] | InitRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-36f37ba7 | this.Load | FP01551_LineAddPopup.cs:196 |  | DATA_OP | Filter["DIVISION_ID"] | InitRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-feaefa3d | this.Load | FP01551_LineAddPopup.cs:197 |  | DATA_OP | Filter["SITE_ID"] | InitRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-594b05da | this.Load | FP01551_LineAddPopup.cs:198 |  | DATA_OP | Filter["PLANT_ID"] | InitRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-72567f32 | this.Load | FP01551_LineAddPopup.cs:199 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29f5d978 | this.Load | FP01551_LineAddPopup.cs:201 |  | DATA_OP | Filter["TRANSPORT"] | CString.GetCheckedListValue(dtTransport, cboTransport.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-251fefcf | this.Load | FP01551_LineAddPopup.cs:202 |  | DATA_OP | Filter["MARKET"] | "D" | 행/컬럼 값 대입 |  |  |  |

## FP01551_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0d24094 | this.btnSave.Click | FP01551_LineAddPopup.cs:295 |  | DATA_OP | Filter["SOC_ID"] | Filter["TRANSPORT"] | 행/컬럼 값 대입 |  |  |  |
| AC-568dcbef | this.btnSave.Click | FP01551_LineAddPopup.cs:296 |  | DATA_OP | Filter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-fa861598 | this.btnSave.Click | FP01551_LineAddPopup.cs:297 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-03cedad1 | this.btnSave.Click | FP01551_LineAddPopup.cs:299 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | ("PR_UI_FP01551_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b1e73e00 | this.btnSave.Click | FP01551_LineAddPopup.cs:303 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Cell Code or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-bb9ab31f | this.btnSave.Click | FP01551_LineAddPopup.cs:304 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ada1a510 | this.btnSave.Click | FP01551_LineAddPopup.cs:317 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b08b29ed | this.btnSave.Click | FP01551_LineAddPopup.cs:318 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f88e8e84 | this.btnSave.Click | FP01551_LineAddPopup.cs:319 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-60ec04a9 | this.btnSave.Click | FP01551_LineAddPopup.cs:320 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-16c47ee5 | this.btnSave.Click | FP01551_LineAddPopup.cs:321 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8e1499cf | this.btnSave.Click | FP01551_LineAddPopup.cs:322 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-802a63f7 | this.btnSave.Click | FP01551_LineAddPopup.cs:323 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-440ce64d | this.btnSave.Click | FP01551_LineAddPopup.cs:324 |  | DATA_OP | dtSave.SetFirst | ("CELL_ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f1013c44 | this.btnSave.Click | FP01551_LineAddPopup.cs:325 |  | DATA_OP | dtSave.SetFirst | ("STORAGE_ID", txtSloc.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-517af4ce | this.btnSave.Click | FP01551_LineAddPopup.cs:326 |  | DATA_OP | dtSave.SetFirst | ("SOC_ID", Filter["SOC_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-80d9484b | this.btnSave.Click | FP01551_LineAddPopup.cs:327 |  | DATA_OP | dtSave.SetFirst | ("MARKET", "D") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-20abc357 | this.btnSave.Click | FP01551_LineAddPopup.cs:328 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f7c12ce5 | this.btnSave.Click | FP01551_LineAddPopup.cs:329 |  | DATA_OP | dtSave.SetFirst | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c350f9c6 | this.btnSave.Click | FP01551_LineAddPopup.cs:338 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-0783077b | this.btnSave.Click | FP01551_LineAddPopup.cs:339 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7cf2fdc | this.btnSave.Click | FP01551_LineAddPopup.cs:341 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6c4bc549 | this.btnSave.Click | FP01551_LineAddPopup.cs:350 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01551_PlanAmend", "add_cell_code", dtSave, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=add_cell_code] \| FP\Common\FP01… | 엔드포인트 호출 |  |  |  |
| AC-1bbee418 | this.btnSave.Click | FP01551_LineAddPopup.cs:359 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24e275c2 | this.btnSave.Click | FP01551_LineAddPopup.cs:363 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-5592e159 | this.btnSave.Click | FP01551_LineAddPopup.cs:370 | try ▸ else of (dtResult == null) ▸ else of (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f489b7e1 | this.btnSave.Click | FP01551_LineAddPopup.cs:375 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01551_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc73a4f3 | .ctor | FP01551_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-a40bbd18 | .ctor | FP01551_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-8f5c30f3 | .ctor | FP01551_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-e70252a4 | .ctor | FP01551_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01551_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-603e0d21 | Dispose | FP01551_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-797f6953 | this.Load | FP01551_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01551_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7bfab56 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:152 |  | FLAG | data_val | new bool[data_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-4cf29fdb | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:153 |  | FLAG | total_val | new bool[total_set.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-abeab9d6 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:180 |  | DATA_OP | ctrls.Add | (chk_s) | 데이터 객체 조작/조회 |  |  |  |
| AC-40b300af | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:181 |  | DATA_OP | ctrls.Add | (chk_p) | 데이터 객체 조작/조회 |  |  |  |
| AC-97a8c62b | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:182 |  | DATA_OP | ctrls.Add | (chk_ship_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-d55209ce | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:184 |  | DATA_OP | ctrls.Add | (chk_i) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9817c50 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:185 |  | DATA_OP | ctrls.Add | (chk_avail) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f9e924c | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:188 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-667423d8 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:192 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-a94b729a | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:192 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-82f070e2 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:199 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-167373b9 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:203 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-eb0fb4ea | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:207 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01551_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ba8dabd | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:122 |  | VALUE_SET | chk_s.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b71b0f8c | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:123 |  | VALUE_SET | chk_p.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-89bde03d | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:124 |  | VALUE_SET | chk_ship_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-0baef6c0 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:126 |  | VALUE_SET | chk_i.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2c6d1c35 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_avail.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-294957b4 | this.Load 외 1 | FP01551_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01551_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11bb7a65 | (진입점 미연결) | FP01551_MeasureSetForm_Popup.cs:267 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-de70f9cf | (진입점 미연결) | FP01551_MeasureSetForm_Popup.cs:278 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-497b4974 | (진입점 미연결) | FP01551_MeasureSetForm_Popup.cs:289 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01551_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-964eae42 | this.Load | FP01551_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-5fdc19cb | this.Load | FP01551_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e67113b9 | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:251 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-21c16f3b | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:251 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-5130705a | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:253 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-e7c08734 | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:257 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-cbe2233c | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:258 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-ed06c6ff | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:260 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f22c2378 | this.usrButton1.Click | FP01551_MeasureSetForm_Popup.cs:262 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01551_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-500de396 | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:225 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-6145f6d2 | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:225 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-e835834f | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:227 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-d482d34d | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:231 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-46716b5a | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:232 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-aca3bfeb | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:233 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-ca358250 | this.usrButton2.Click | FP01551_MeasureSetForm_Popup.cs:234 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_StoragePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9beb736 | (진입점 미연결) | FP01551_StoragePopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7977b70b | (진입점 미연결) | FP01551_StoragePopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-515c0f62 | (진입점 미연결) | FP01551_StoragePopup.cs:259 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_StoragePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a530ea78 | this.Load | FP01551_StoragePopup.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0358c80f | this.Load | FP01551_StoragePopup.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-abe73801 | this.Load | FP01551_StoragePopup.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01551_StoragePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32afbb0e | this.Load | FP01551_StoragePopup.cs:129 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01551_StoragePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8178a0a5 | Dispose | FP01551_StoragePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_StoragePopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ed626a7 | this.Load 외 2 | FP01551_StoragePopup.cs:205 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3bc95e42 | this.Load 외 2 | FP01551_StoragePopup.cs:209 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-9be031b1 | this.Load 외 2 | FP01551_StoragePopup.cs:211 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { return Data_FP.CallGeneralProcedure("PR_UI_FP01551_ETC", Filter, UserInfoContext.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f251eed | this.Load 외 2 | FP01551_StoragePopup.cs:213 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01551_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "STORAGE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-15fa279d | this.Load 외 2 | FP01551_StoragePopup.cs:213 | lambda | RETURN | return Data_FP.CallGeneralProcedure("PR_UI_FP01551_ETC", Filter, UserInfoContext… |  | 처리 중단/반환 |  |  |  |
| AC-fb85d11e | this.Load 외 2 | FP01551_StoragePopup.cs:218 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-48c3cf4a | this.Load 외 2 | FP01551_StoragePopup.cs:221 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-65eb8b9a | this.Load 외 2 | FP01551_StoragePopup.cs:223 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01551_StoragePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1be8fc05 | this.Load | FP01551_StoragePopup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f428c902 | this.Load | FP01551_StoragePopup.cs:101 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01551_StoragePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b82e4311 | this.Load | FP01551_StoragePopup.cs:146 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b655a7e6 | this.Load | FP01551_StoragePopup.cs:147 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_StoragePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc54fc38 | (진입점 미연결) | FP01551_StoragePopup.cs:166 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01551_StoragePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cf863da | this.Load | FP01551_StoragePopup.cs:153 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d574646 | this.Load | FP01551_StoragePopup.cs:154 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-aa28f49c | this.Load | FP01551_StoragePopup.cs:158 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01551_StoragePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc8889fd | this.spdMain.CellClick | FP01551_StoragePopup.cs:270 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0e3088b0 | this.spdMain.CellClick | FP01551_StoragePopup.cs:271 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c920a268 | this.spdMain.CellClick | FP01551_StoragePopup.cs:274 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01551_StoragePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-076db623 | this.spdMain.CellDoubleClick | FP01551_StoragePopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-e2ac3383 | this.spdMain.CellDoubleClick | FP01551_StoragePopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5d016e82 | this.spdMain.CellDoubleClick | FP01551_StoragePopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-5ba9ad7b | this.spdMain.CellDoubleClick | FP01551_StoragePopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4f97f26 | this.spdMain.CellDoubleClick | FP01551_StoragePopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_VersionUp_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c136df37 | .ctor | FP01551_VersionUp_Popup.cs:67 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-824345f3 | .ctor | FP01551_VersionUp_Popup.cs:68 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-fb873766 | .ctor | FP01551_VersionUp_Popup.cs:69 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b10998c9 | .ctor | FP01551_VersionUp_Popup.cs:71 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.btnVerClose_Click

진입점: this.btnVerClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30262832 | this.btnVerClose.Click | FP01551_VersionUp_Popup.cs:174 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_VersionUp_Popup.btnVerSave_Click

진입점: this.btnVerSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c082ee38 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:167 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-86adbe67 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:168 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01551_VersionUp_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9775ce5 | Dispose | FP01551_VersionUp_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01551_VersionUp_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6aa86c3 | this.Load | FP01551_VersionUp_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6aa9c3c | this.Load | FP01551_VersionUp_Popup.cs:82 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-60accb75 | this.Load | FP01551_VersionUp_Popup.cs:90 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-959c4e13 | this.Load | FP01551_VersionUp_Popup.cs:94 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.rdoMoving_Click

진입점: rdoMoving.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-496e244e | rdoMoving.CheckedChanged | FP01551_VersionUp_Popup.cs:140 | if (loaded) | FLAG | Selection | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-79ada005 | rdoMoving.CheckedChanged | FP01551_VersionUp_Popup.cs:141 | if (loaded) | FLAG | sCalOption | "M" | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.rdoPack_Click

진입점: rdoPack.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-838a1979 | rdoPack.CheckedChanged | FP01551_VersionUp_Popup.cs:151 | if (loaded) | FLAG | Selection | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-ea0601f8 | rdoPack.CheckedChanged | FP01551_VersionUp_Popup.cs:152 | if (loaded) | FLAG | sCalOption | "R" | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.rdoRequest_Click

진입점: rdoRequest.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1af3ab16 | rdoRequest.CheckedChanged | FP01551_VersionUp_Popup.cs:128 | if (loaded) | FLAG | Selection | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-4c10046c | rdoRequest.CheckedChanged | FP01551_VersionUp_Popup.cs:129 | if (loaded) | FLAG | sCalOption | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-4694ea9c | rdoRequest.CheckedChanged | FP01551_VersionUp_Popup.cs:133 |  | FLAG | loaded | true | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.Save_Data

진입점: this.btnVerSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05730dab | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:183 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0cbff9c2 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:184 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4e410698 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:187 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4d7428ef | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:192 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-30a398de | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:195 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ad925a13 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:199 | try ▸ try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-40c7f808 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:201 | try ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7b2b5e54 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:209 | try ▸ catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-2ff240b4 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:213 | try ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-48e39fd6 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:219 | try ▸ if (save_success == true) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-eaee8fe2 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:226 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-894ed005 | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:227 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-53d95adc | this.btnVerSave.Click | FP01551_VersionUp_Popup.cs:231 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01551_VersionUp_Popup.Save_Data_Execute

진입점: this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70ff033c | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:244 | try | FLAG | dtCurrDate | Data_FP.CallGeneralProcedure2(("PR_UI_FP01551_ETC").ToUpper(), Filter, UserInfoContext.Cur… | 화면 필드/플래그 변경 |  |  |  |
| AC-21feaa3f | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:244 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01551_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "SITE_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-967369e1 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:248 | try | DATA_OP | Filter["BASIS_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5987ace3 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:249 | try | DATA_OP | Filter["CREATE_PLAN_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-788da884 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:250 | try | DATA_OP | Filter["CAL_OPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-3b349a8e | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:251 | try | DATA_OP | Filter["FIX_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-1949c188 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:252 | try | DATA_OP | Filter["COPY_FLAG"] | sCalOption | 행/컬럼 값 대입 |  |  |  |
| AC-129ff3d9 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:253 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7532eed1 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:254 | try | DATA_OP | Filter["TARGET_DATE"] | dtCurrDate.Rows[0]["CUR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-29ff0967 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:257 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP01551_PlanAmend", "execute_version", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_version] \| FP\Common… | 엔드포인트 호출 |  |  |  |
| AC-87e160d3 | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:262 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-de363bed | this.btnVerSave.Click [try ▸ try ▸ if (MessageBox.Show("Do y… | FP01551_VersionUp_Popup.cs:265 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01551_VersionUp_Popup.SetOption

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ed3671 | (진입점 미연결) | FP01551_VersionUp_Popup.cs:106 | if (index == 0) | VALUE_SET | rdoRequest.Text | option_name | 컨트롤 값 설정 |  |  |  |
| AC-79c2e450 | (진입점 미연결) | FP01551_VersionUp_Popup.cs:108 | else of (index == 0) ▸ if (index == 1) | VALUE_SET | rdoMoving.Text | option_name | 컨트롤 값 설정 |  |  |  |

