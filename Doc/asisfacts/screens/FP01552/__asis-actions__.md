# AS-IS 액션 대조표 — FP01552

> 원천: `Doc/asisfacts/screens/FP01552/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 1049행 · 메서드 186 · 종류 DATA_OP 305 · FLAG 125 · UI_PROP 78 · RETURN 76 · VALUE_SET 67 · UI_MISC 64 · GRID_INIT 63 · MESSAGE 52 · ENDPOINT 43 · CALL_EXT 37 · POPUP 26 · COMBO_DATA 18 · GRID_LOCK 18 · LIST_REBIND 15 · GRID_SET 15 · STATE 14 · GRID_STYLE 9 · THROW 7 · GRID_BIND 5 · FOCUS 5 · CALL_BASE 3 · VALUE_CLEAR 2 · EXCEL 1 · LIST_CLEAR 1 · ⚠ 의미 확인 필요 40


## FP01552_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caa6e34b | .ctor | FP01552_BucketSetForm_Popup.cs:70 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-11ee7458 | .ctor | FP01552_BucketSetForm_Popup.cs:71 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-6167ecd4 | .ctor | FP01552_BucketSetForm_Popup.cs:72 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-546b15e7 | .ctor | FP01552_BucketSetForm_Popup.cs:74 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01552_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-728f8d9b | Dispose | FP01552_BucketSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92955268 | this.Load | FP01552_BucketSetForm_Popup.cs:98 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01552_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f325dcc | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:143 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-cdcd827c | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ef25780 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:146 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-02a78998 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-98837d5c | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-a1cadebb | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-543c0aa6 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-12351a65 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01552_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d01a7704 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:115 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-de9e74d4 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-863cbbc9 | this.Load 외 1 | FP01552_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01552_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eae8f3af | (진입점 미연결) | FP01552_BucketSetForm_Popup.cs:225 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-f4ebaefa | (진입점 미연결) | FP01552_BucketSetForm_Popup.cs:236 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4255f124 | (진입점 미연결) | FP01552_BucketSetForm_Popup.cs:247 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01552_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc96dba6 | this.Load | FP01552_BucketSetForm_Popup.cs:85 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fb362fd0 | this.Load | FP01552_BucketSetForm_Popup.cs:93 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-429677ff | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-4223510b | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-d289f7cc | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-ea816985 | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-e5e63936 | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-cfa0eaec | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4663434a | this.usrButton1.Click | FP01552_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01552_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a444b4e | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-2be0d210 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-6f57bac9 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-8f81d7e9 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-7f8fb8c7 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-d2c8cff8 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-d1372490 | this.usrButton2.Click | FP01552_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_CalculationPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-506a3678 | .ctor | FP01552_CalculationPopup.cs:129 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |

## FP01552_CalculationPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d1fe75 | (진입점 미연결) | FP01552_CalculationPopup.cs:644 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-921e8ee6 | (진입점 미연결) | FP01552_CalculationPopup.cs:647 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_CalculationPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97616f8f | this.btnClose.Click | FP01552_CalculationPopup.cs:750 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_CalculationPopup.clbDivision_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3cefb81 | (진입점 미연결) | FP01552_CalculationPopup.cs:616 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-344fec0a | (진입점 미연결) | FP01552_CalculationPopup.cs:619 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ab60078b | (진입점 미연결) | FP01552_CalculationPopup.cs:619 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "", … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c62b10a3 | (진입점 미연결) | FP01552_CalculationPopup.cs:620 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-939fd83a | (진입점 미연결) | FP01552_CalculationPopup.cs:624 |  | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-c76c9a21 | (진입점 미연결) | FP01552_CalculationPopup.cs:627 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-7b914163 | (진입점 미연결) | FP01552_CalculationPopup.cs:627 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, "", "",… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-13b54342 | (진입점 미연결) | FP01552_CalculationPopup.cs:628 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_CalculationPopup.ClbDivision_SelectedIndexChanged

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6454090f | clbDivision.SelectedIndexChanged | FP01552_CalculationPopup.cs:208 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01552_CalculationPopup.ClbPlant_SelectedIndexChanged

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2032967d | clbPlant.SelectedIndexChanged | FP01552_CalculationPopup.cs:197 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01552_CalculationPopup.clbSite_SelectedIndexChanged

진입점: clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-030c7b45 | clbSite.SelectedIndexChanged | FP01552_CalculationPopup.cs:202 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01552_CalculationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5632d8b | this.Load | FP01552_CalculationPopup.cs:252 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-275c175e | this.Load | FP01552_CalculationPopup.cs:253 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2a4ca066 | this.Load | FP01552_CalculationPopup.cs:254 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_CalculationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4789fa54 | this.Load | FP01552_CalculationPopup.cs:240 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_CalculationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1339f3b8 | Dispose | FP01552_CalculationPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_CalculationPopup.EditButton

진입점: this.btnFind.Click / this.Load / FindButton / EditButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5375dc0a | this.btnFind.Click 외 4 | FP01552_CalculationPopup.cs:338 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-62d7afab | this.btnFind.Click 외 4 | FP01552_CalculationPopup.cs:343 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.NICK_NAME)… | 그리드 편집 잠금/해제 |  |  |  |

## FP01552_CalculationPopup.FindData

진입점: this.btnFind.Click / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7129cd3a | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:376 |  | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-17611412 | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:379 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-145a86a2 | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:381 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { DataSet ret = Data_FP.CallGeneralProcedure("PR_UI_FP01552_ETC", Filter, CurrentUs… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-88f91dfc | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:383 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_ETC", Filter, CurrentUser, "SELECT", "CALCULATION_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-30714534 | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:384 | lambda | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-a198a74d | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:388 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-31e69d71 | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:393 | if (ds.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f4bcc2a | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:396 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-623e227e | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:398 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtMain, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4e0d8d44 | this.btnFind.Click 외 3 | FP01552_CalculationPopup.cs:406 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_CalculationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7237946 | this.Load | FP01552_CalculationPopup.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-47e55ea4 | this.Load | FP01552_CalculationPopup.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_CalculationPopup.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78e0e50d | this.Load | FP01552_CalculationPopup.cs:215 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-67b3bd5e | this.Load | FP01552_CalculationPopup.cs:215 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-31816ab4 | this.Load | FP01552_CalculationPopup.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_CalculationPopup.GetPlant

진입점: this.Load / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-751ef6fe | this.Load 외 1 | FP01552_CalculationPopup.cs:232 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-58da0e59 | this.Load 외 1 | FP01552_CalculationPopup.cs:232 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE_ID… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7cfb14e0 | this.Load 외 1 | FP01552_CalculationPopup.cs:234 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_CalculationPopup.GetSite

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78d7911c | this.Load 외 1 | FP01552_CalculationPopup.cs:222 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc7aa58c | this.Load 외 1 | FP01552_CalculationPopup.cs:222 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd1244af | this.Load 외 1 | FP01552_CalculationPopup.cs:224 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_CalculationPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-848d1e8b | this.Load | FP01552_CalculationPopup.cs:162 |  | VALUE_SET | drpFixDate.Value | DateTime.ParseExact("19990101", "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-a36344a1 | this.Load | FP01552_CalculationPopup.cs:163 |  | VALUE_CLEAR | drpFixDate.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-233719e8 | this.Load | FP01552_CalculationPopup.cs:166 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-faace989 | this.Load | FP01552_CalculationPopup.cs:166 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-5c232490 | this.Load | FP01552_CalculationPopup.cs:176 |  | VALUE_SET | clbDivision.ControlValues | pDivisionID | 컨트롤 값 설정 |  |  |  |
| AC-87077512 | this.Load | FP01552_CalculationPopup.cs:177 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-2e4d389f | this.Load | FP01552_CalculationPopup.cs:181 |  | VALUE_SET | clbSite.ControlValues | pSiteID | 컨트롤 값 설정 |  |  |  |
| AC-b3ff1fab | this.Load | FP01552_CalculationPopup.cs:182 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-7a8c95c2 | this.Load | FP01552_CalculationPopup.cs:187 |  | VALUE_SET | clbSite.ControlValues | pPlantID | 컨트롤 값 설정 |  |  |  |
| AC-d7c3c752 | this.Load | FP01552_CalculationPopup.cs:188 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01552_CalculationPopup.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e940e257 | this.Load | FP01552_CalculationPopup.cs:245 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2c7e9cc8 | this.Load | FP01552_CalculationPopup.cs:246 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01552_CalculationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eaadad06 | this.Load | FP01552_CalculationPopup.cs:267 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-176ce005 | this.Load | FP01552_CalculationPopup.cs:269 |  | GRID_INIT | siMain.AddCheckColumn | ("CHK", DefColumns._CHK_ITEM, FPMerge.None, 30, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d99751a | this.Load | FP01552_CalculationPopup.cs:270 |  | GRID_INIT | siMain.AddTextColumn | ("Company", DefColumns.COMPANY_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f88325d | this.Load | FP01552_CalculationPopup.cs:271 |  | GRID_INIT | siMain.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-71d158a0 | this.Load | FP01552_CalculationPopup.cs:272 |  | GRID_INIT | siMain.AddTextColumn | ("Site", DefColumns.SITE_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a98d76ad | this.Load | FP01552_CalculationPopup.cs:273 |  | GRID_INIT | siMain.AddTextColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04415dd2 | this.Load | FP01552_CalculationPopup.cs:274 |  | GRID_INIT | siMain.AddTextColumn | ("Cell Group Code", DefColumns.GROUP_ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31e319bb | this.Load | FP01552_CalculationPopup.cs:275 |  | GRID_INIT | siMain.AddTextColumn | ("Cell Code", DefColumns.CELL_ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b67421c | this.Load | FP01552_CalculationPopup.cs:276 |  | GRID_INIT | siMain.AddTextColumn | ("Nick Name", DefColumns.NICK_NAME, FPMerge.None, 150, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a61b2c5b | this.Load | FP01552_CalculationPopup.cs:284 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Cell… | chk | 그리드 속성/값 설정 |  |  |  |
| AC-91a8d7c2 | this.Load | FP01552_CalculationPopup.cs:285 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Valu… | false | 그리드 속성/값 설정 |  |  |  |
| AC-2e86dd2e | this.Load | FP01552_CalculationPopup.cs:286 |  | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].Bord… | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-9ad83602 | this.Load | FP01552_CalculationPopup.cs:290 |  | UI_PROP | col.MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 속성 MergePolicy 설정 |  |  |  |
| AC-2764ba6d | this.Load | FP01552_CalculationPopup.cs:292 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_CalculationPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33d50d0a | (진입점 미연결) | FP01552_CalculationPopup.cs:313 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_CalculationPopup.Save_Data

진입점: this.btnSave.Click / SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c9af439 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:411 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0224119d | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:413 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef080f2e | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:418 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b7cdc71 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:419 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10f9c474 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:422 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d276aed9 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:435 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bedf2b22 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:442 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-36003423 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:447 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel… | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dfb5dbec | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:454 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-4f74f825 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:466 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (save_success == true) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-e0b225b8 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:472 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9c7a544a | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:476 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0299cb11 | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:477 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-7d1c9c5f | this.btnSave.Click 외 2 | FP01552_CalculationPopup.cs:481 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01552_CalculationPopup.Save_Data_Execute

진입점: this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13010f56 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:494 | try | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-75f94760 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:495 | try | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-f96e8fbf | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:496 | try | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d5b86967 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:497 | try | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-14be2be1 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:498 | try | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c54f999 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:499 | try | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-48421df4 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:500 | try | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-42499898 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:501 | try | DATA_OP | dt.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1087a4e | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:502 | try | DATA_OP | dt.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8dae2b4 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:514 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-066cb8c1 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:516 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3fbe7af | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:517 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-132ac4d9 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:518 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8e68a0f7 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:519 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["COMPANY_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.COMPANY_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fe435a45 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:520 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["SITE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-52302f98 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:521 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["PLANT_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9692007c | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:522 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["CELL_ITEM_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8bc3ef12 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:523 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | newrow["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-841802b3 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:525 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d5b697b | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:530 | try | DATA_OP | Filter["BASIS_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-eed69dcc | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:531 | try | DATA_OP | Filter["CREATE_PLAN_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-ea68e8ea | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:534 | try ▸ if (drpFixDate.Value.ToString("yyyyMMdd") == "19990101") | DATA_OP | Filter["FIX_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-a267e96d | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:538 | try ▸ else of (drpFixDate.Value.ToString("yyyyMMdd") == "19990101") | DATA_OP | Filter["FIX_DATE"] | drpFixDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-c080b95e | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:540 | try | DATA_OP | Filter["COPY_FLAG"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-695d609a | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:541 | try | DATA_OP | Filter["TARGET_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-da515ab4 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:546 | try ▸ if (siMain.GetMaxRowIndex() == dt.Rows.Count) | DATA_OP | Filter["CAL_OPTION"] | "ALL" | 행/컬럼 값 대입 |  |  |  |
| AC-7792e49f | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:548 | try ▸ if (siMain.GetMaxRowIndex() == dt.Rows.Count) | ENDPOINT | DataService.FP_RunProcedure | ("FP01552_In_House_Moving_Plan", "execute_psiCalcul", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-731dbf01 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:560 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01552_In_House_Moving_Plan", "save_CalculationList", dt, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_CalculationList] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-1f0b7c9b | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:566 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") | DATA_OP | Filter["CAL_OPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-754ec413 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:570 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01552_In_House_Moving_Plan", "execute_psiCalcul", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_psiCalcul] \| FP\Plan… | 엔드포인트 호출 |  |  |  |
| AC-4bcc05f3 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:577 | try ▸ else of (siMain.GetMaxRowIndex() == dt.Rows.Count) ▸ else of (resultDT.Rows[0]["RESULT"].ToString() == "FAIL") ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (e.Message) | 메시지 표시 |  |  |  |
| AC-ecaf507c | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:588 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-49fd2bc3 | this.btnSave.Click [try ▸ if (siMain.SheetName == SpdSheet.s… 외 2 | FP01552_CalculationPopup.cs:591 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP01552_CalculationPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b08894b3 | SaveButton | FP01552_CalculationPopup.cs:351 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_CalculationPopup.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d63b432d | (진입점 미연결) | FP01552_CalculationPopup.cs:298 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-daa84259 | (진입점 미연결) | FP01552_CalculationPopup.cs:299 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e3ffb3a8 | (진입점 미연결) | FP01552_CalculationPopup.cs:303 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01552_CalculationPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cee02686 | this.spdMain.CellClick | FP01552_CalculationPopup.cs:658 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-cce48ee6 | this.spdMain.CellClick | FP01552_CalculationPopup.cs:671 | if (e.Row >= 0 && e.ColumnHeader && siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-083475d5 | this.spdMain.CellClick | FP01552_CalculationPopup.cs:695 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a6049305 | this.spdMain.CellClick | FP01552_CalculationPopup.cs:705 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns._CHK_ITEM)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-b038763a | this.spdMain.CellClick | FP01552_CalculationPopup.cs:709 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ if (chk_item.Equals("1")) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns._CHK_ITEM), false) | 그리드 값 설정 |  |  |  |
| AC-ccfaec29 | this.spdMain.CellClick | FP01552_CalculationPopup.cs:713 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.GetColumnTag(e.Column).Equals("_CHK_ITEM")) ▸ else of (chk_item.Equals("1… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns._CHK_ITEM), true) | 그리드 값 설정 |  |  |  |

## FP01552_ConfirmHisPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4179cb2e | this.Load | FP01552_ConfirmHisPopup.cs:96 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85010e1b | this.Load | FP01552_ConfirmHisPopup.cs:97 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ad587b06 | this.Load | FP01552_ConfirmHisPopup.cs:98 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_ConfirmHisPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f53ad171 | this.Load | FP01552_ConfirmHisPopup.cs:86 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-656255f0 | this.Load | FP01552_ConfirmHisPopup.cs:91 |  | DATA_OP | list.Add | (ButtonListType.OK) | 데이터 객체 조작/조회 |  |  |  |

## FP01552_ConfirmHisPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62a04362 | Dispose | FP01552_ConfirmHisPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_ConfirmHisPopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8313f900 | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:134 |  | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP01552_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "CONFI… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c1a6c18b | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:136 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-44f28fce | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:137 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4349889a | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:140 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_ConfirmHisPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a570e7c6 | this.Load | FP01552_ConfirmHisPopup.cs:71 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_ConfirmHisPopup.InitSpread

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0e65db2 | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:105 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-16938172 | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:107 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm Date", DefColumns.CONFIRM_DATE, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-627911ed | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:108 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm ID", DefColumns.CONFIRM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c538435d | this.Load 외 2 | FP01552_ConfirmHisPopup.cs:109 |  | GRID_INIT | siMain.AddTextColumn | ("Confirm Ver.", DefColumns.CONFIRM_PLAN_ID, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_ConfirmHisPopup.OkButtonClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b40e0709 | (진입점 미연결) | FP01552_ConfirmHisPopup.cs:164 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_ConfirmHisPopup.SpdMain_CellDoubleClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c1ccc32 | (진입점 미연결) | FP01552_ConfirmHisPopup.cs:171 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_In_House_Moving_Plan..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16daf73b | .ctor | FP01552_In_House_Moving_Plan.cs:137 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.ApplyAmendCalendarCondition

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82136433 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1954 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-3d2f906f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1955 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7e7e31fb | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1956 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e502a088 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1957 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-990fd72c | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1958 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-19896f32 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1961 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP01552_In_House_Moving_Plan", "find_WeekCnt", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-b78c62d6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1961 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01552_In_House_Moving_Plan", "find_WeekCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-83e639e6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1962 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP01552_In_House_Moving_Plan", "find_DateMap", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-1aea1e77 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1962 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01552_In_House_Moving_Plan", "find_DateMap", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5078bbfd | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1963 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP01552_In_House_Moving_Plan", "find_MonthCnt", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-68015d7f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1963 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01552_In_House_Moving_Plan", "find_MonthCnt", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8c451763 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1964 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP01552_In_House_Moving_Plan", "find_BukInfo", Filter.Diction… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 화면 필드/플래그 변경 |  |  |  |
| AC-2ac0d96d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1964 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP01552_In_House_Moving_Plan", "find_BukInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BukInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-00dbd4bd | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1976 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-5d826a63 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1977 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-95c4bec4 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1978 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-1a588b77 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1979 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.ApplySearchCondition

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05106811 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1986 | if (GetFilter("INSTANCE_ID") == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { SetFilter("INSTANCE_ID", CString.GetCheckedListValue(dtIn… | ⚠ 의미 확인 필요 |  |  |  |
| AC-56a515ed | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1993 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-dcdf0181 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1994 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a5e06ee7 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1995 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f5f12fbf | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1997 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { if (cboPlanId.SelectedIndex >= 0) { Filter["PLAN_ID"] = c… | ⚠ 의미 확인 필요 |  |  |  |
| AC-9f1ff6a7 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:2001 | lambda ▸ if (cboPlanId.SelectedIndex >= 0) | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-45bf6504 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:2006 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.btnBucket_Click

진입점: this.btnBucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5988c0bd | this.btnBucket.Click | FP01552_In_House_Moving_Plan.cs:2719 |  | POPUP | new FP01552_BucketSetForm_Popup | ("FP01552", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-7d43a714 | this.btnBucket.Click | FP01552_In_House_Moving_Plan.cs:2721 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-8f40f111 | this.btnBucket.Click | FP01552_In_House_Moving_Plan.cs:2722 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-10c1a203 | this.btnBucket.Click | FP01552_In_House_Moving_Plan.cs:2723 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c7874de4 | this.btnBucket.Click | FP01552_In_House_Moving_Plan.cs:2727 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.btnCalculation_Click

진입점: this.btnCalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c120ca60 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2759 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-4be9e697 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2760 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-fd9d1dd1 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2768 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8cc47df1 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2769 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-980f3041 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2773 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-38f4773f | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2774 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db1301e2 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2777 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-6d935468 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2778 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5e3b9f3 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2783 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-8838db79 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2784 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4216540b | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2787 |  | POPUP | new FP01552_CalculationPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a713ca3c | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2789 |  | VALUE_SET | calPop.Text | "Calculation" | 컨트롤 값 설정 |  |  |  |
| AC-013c48e0 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2790 |  | DATA_OP | calPop.Filter["MASTER_ID"] | calPop.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5edff677 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2790 |  | DATA_OP | calPop.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aeb61a61 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2791 |  | DATA_OP | calPop.Filter["PACK_INSTANCE_ID"] | Filter["PACK_INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9a2d73ad | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2792 |  | DATA_OP | calPop.Filter["CONFIRM_PACK_PLAN_ID"] | Filter["CONFIRM_PACK_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8adbd17d | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2793 |  | DATA_OP | calPop.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9f7a60bb | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2794 |  | DATA_OP | calPop.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-92ed83bb | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2795 |  | DATA_OP | calPop.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7cd7db34 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2796 |  | DATA_OP | calPop.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7950d0f0 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2797 |  | DATA_OP | calPop.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-1101e508 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2798 |  | DATA_OP | calPop.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-08dde2b2 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2799 |  | DATA_OP | calPop.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-a1288305 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2801 |  | DATA_OP | calPop.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6b12cc4d | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2802 |  | UI_PROP | calPop.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-406e00a8 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2803 |  | UI_PROP | calPop.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-41b48cf8 | this.btnCalculation.Click | FP01552_In_House_Moving_Plan.cs:2804 |  | POPUP | calPop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01552_In_House_Moving_Plan.btnCatagory_Click

진입점: this.btnCategory.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2d419d4 | this.btnCategory.Click | FP01552_In_House_Moving_Plan.cs:2686 |  | POPUP | new FP01552_MeasureSetForm_Popup | ("FP01552", "Main", false, "") | 팝업/폼 생성 |  |  |  |
| AC-26a573c3 | this.btnCategory.Click | FP01552_In_House_Moving_Plan.cs:2688 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-3687ce8c | this.btnCategory.Click | FP01552_In_House_Moving_Plan.cs:2689 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1383df35 | this.btnCategory.Click | FP01552_In_House_Moving_Plan.cs:2690 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c4275822 | this.btnCategory.Click | FP01552_In_House_Moving_Plan.cs:2694 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.btnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af970091 | this.btnColumn.Click | FP01552_In_House_Moving_Plan.cs:2668 |  | POPUP | new FPC0097_ColumnSetForm_Popup | ("FP01552", SpdSheet.shtPlanAmendMA, true, clbDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-e29443d8 | this.btnColumn.Click | FP01552_In_House_Moving_Plan.cs:2669 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d55d4077 | this.btnColumn.Click | FP01552_In_House_Moving_Plan.cs:2670 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01552_In_House_Moving_Plan.btnConfirm_Click

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccbcb564 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2815 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7e0d07b8 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2816 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-1840a7f2 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2824 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1af7b84e | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2825 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20e7c8ad | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2829 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-285a935b | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2830 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8b09d625 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2833 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-2eb0d337 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2834 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6465060 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2839 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-50e31c90 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2840 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a410744 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:2846 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.btnConfirmHis_Click

진입점: this.btnConfirmHis.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-817e1d3a | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2915 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-75ef5597 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2916 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-c9eaf7b0 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2920 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-b6644005 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2921 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a5cd5b9 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2924 |  | POPUP | new FP01552_ConfirmHisPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4db2bac3 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2926 |  | VALUE_SET | verPop.Text | "Confirm History" | 컨트롤 값 설정 |  |  |  |
| AC-e1b9bdad | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2927 |  | DATA_OP | verPop.Filter["MASTER_ID"] | verPop.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8817f71 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2927 |  | DATA_OP | verPop.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-13c89d15 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2928 |  | DATA_OP | verPop.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-959ab8b5 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2929 |  | DATA_OP | verPop.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0c541f52 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2931 |  | UI_PROP | verPop.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-f6861fa2 | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2932 |  | UI_PROP | verPop.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-fd377d6b | this.btnConfirmHis.Click | FP01552_In_House_Moving_Plan.cs:2933 |  | POPUP | verPop.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01552_In_House_Moving_Plan.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12b9d696 | this.btnMenu.Click | FP01552_In_House_Moving_Plan.cs:2941 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-f92dfe9d | this.btnMenu.Click | FP01552_In_House_Moving_Plan.cs:2941 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP01552_In_House_Moving_Plan.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d35bddf1 | this.btnSql.Click | FP01552_In_House_Moving_Plan.cs:1430 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e796c742 | this.btnSql.Click | FP01552_In_House_Moving_Plan.cs:1431 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-be0f28e0 | this.btnSql.Click | FP01552_In_House_Moving_Plan.cs:1433 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP01552_IN_HOUSE_MOVING_PLAN") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f8bc0b2 | this.btnSql.Click | FP01552_In_House_Moving_Plan.cs:1434 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01552_In_House_Moving_Plan.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a875dccd | this.btnToggleSave.Click | FP01552_In_House_Moving_Plan.cs:2752 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.btnVersion_Click

진입점: this.btnVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f4e3bc3 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2856 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-563b63e8 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2857 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-71f38f4c | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2865 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2183bc5d | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2866 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33bf4bac | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2870 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-861f2b5c | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2871 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f177c3cf | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2874 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-4efc6345 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2875 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-909bb249 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:2879 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.cboPlanId_changed

진입점: this.Load / cboPlanId.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42da0212 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2514 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | VALUE_SET | cboPlanId.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-32f23474 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2515 | if (cboPlanId.Items.Count > 0 && cboPlanId.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab368380 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2538 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.ParseExact(GetFilter("BUCKET_FROM"), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-71efe301 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2539 | if (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.ParseExact(GetFilter("BUCKET_TO"), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-f010ec24 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2543 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-bc214edb | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:2544 | else of (dtPlanId.Good()) | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(55) | 속성 Value2 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.CheckAndGetMeasure

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5dd9835 | this.Load | FP01552_In_House_Moving_Plan.cs:378 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-ecda33b1 | this.Load | FP01552_In_House_Moving_Plan.cs:378 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-8e545841 | this.Load | FP01552_In_House_Moving_Plan.cs:380 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01552_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0c9cc8d | this.Load | FP01552_In_House_Moving_Plan.cs:380 |  | POPUP | new FP01552_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-73fcdc39 | this.Load | FP01552_In_House_Moving_Plan.cs:381 |  | CALL_EXT | MeasureService.MakeDefault | (new FP01552_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-962c6a72 | this.Load | FP01552_In_House_Moving_Plan.cs:381 |  | POPUP | new FP01552_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-56c963f1 | this.Load | FP01552_In_House_Moving_Plan.cs:384 |  | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1f8b974 | this.Load | FP01552_In_House_Moving_Plan.cs:385 | if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-7692f3fb | this.Load | FP01552_In_House_Moving_Plan.cs:386 |  | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a2e00c9 | this.Load | FP01552_In_House_Moving_Plan.cs:387 | if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-91597e5a | this.Load | FP01552_In_House_Moving_Plan.cs:388 |  | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-81290ea0 | this.Load | FP01552_In_House_Moving_Plan.cs:389 | if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.chk_Info_CheckedChanged

진입점: chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8df3774d | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2596 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblInsertId.Text | dtPlanId.Rows[0]["INSERT_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f12a2287 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2597 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblInsertTime.Text | dtPlanId.Rows[0]["INSERT_TIME"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-f2f249cc | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2598 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblFixDate.Text | dtPlanId.Rows[0]["FIX_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-5e8dc6d0 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2599 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblDescription.Text | dtPlanId.Rows[0]["DESCRIPTION"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-8914a6bc | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2600 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConfirmPlanId.Text | dtPlanId.Rows[0]["CONFIRM_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-d5c23170 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2601 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConId.Text | dtPlanId.Rows[0]["CONFIRM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-12fad734 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2602 | if (dtPlanId.Good() && chk_Info.Checked) | VALUE_SET | lblConDate.Text | dtPlanId.Rows[0]["CONFIRM_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-7e89ccf7 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2608 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ccca8d3 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2608 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70826c18 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2614 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-132d6f15 | chk_Info.CheckedChanged | FP01552_In_House_Moving_Plan.cs:2615 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP01552_In_House_Moving_Plan.CreateEditDataGridDataSet

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (editDs.Good()) ▸ if (dt == null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-995ac1bd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2458 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-2aaccfd1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2459 |  | DATA_OP | dt.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8b01848 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2460 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4461f2be | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2461 |  | DATA_OP | dt.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-bc3cb6fb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2462 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-be035d87 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2463 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d46a975 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2464 |  | DATA_OP | dt.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-1d0ff543 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2465 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d29a43e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2466 |  | DATA_OP | dt.Columns.Add | (new DataColumn("STORAGE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-70a2d81b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2467 |  | DATA_OP | dt.Columns.Add | (new DataColumn("SOC_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed8f1ea7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2468 |  | DATA_OP | dt.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7d121c9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2469 |  | DATA_OP | dt.Columns.Add | (new DataColumn("CATEGORY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0c9f8ac | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2470 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DELIVERY_DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-88837d84 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2471 |  | DATA_OP | dt.Columns.Add | (new DataColumn("DELIVERY_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-feea9cde | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2474 |  | DATA_OP | dt.Columns.Add | (new DataColumn("ORG_DELIVERY_QTY", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-139464cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2477 |  | DATA_OP | dt.Columns.Add | (new DataColumn("M", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8ca8edbd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2483 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c15068c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:2486 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.CreateFilterDataSet

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5f698dc | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1485 | if (dsResult == null \|\| dsTotal == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-42934a31 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1496 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-6e7407fb | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1497 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-02111ace | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1510 | if (measure["chk_form"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("P(CMA)", "DATA", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-de7e6213 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1514 | if (measure["chk_cma"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("P(FORM)", "DATA", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-292db94d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1518 | if (measure["chk_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("Result", "DATA", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d6486f5 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1522 | if (measure["chk_prev_req"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("R(Prev Cell Req.)", "DATA", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-cbd61143 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1526 | if (measure["chk_req"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("R(Cell Req.)", "DATA", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-23232c26 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1530 | if (measure["chk_delivery"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("DO(Cell Deli.)", "DATA", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-72e047b0 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1534 | if (measure["chk_shortage"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("Shortage", "DATA", "SS")) | 데이터 객체 조작/조회 |  |  |  |
| AC-500cd073 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1538 | if (measure["chk_ship_result"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("Ship Result", "DATA", "SS")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9bcc9dfc | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1542 | if (measure["chk_eoh"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(+Hold)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb62f33c | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1546 | if (measure["chk_eohAvail"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Available)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-43f1aefe | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1550 | if (measure["chk_meet"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("Meet Qty", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-245d6d54 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1554 | if (measure["chk_eohHold"].Value == "true") | DATA_OP | chks_measure_data_category.Add | (new Tuple<string, string, string>("EOH(Hold)", "DATA", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d02c2b6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1560 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "S")) | 데이터 객체 조작/조회 |  |  |  |
| AC-56aac6e4 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1561 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "P")) | 데이터 객체 조작/조회 |  |  |  |
| AC-f22f9d99 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1562 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "SS")) | 데이터 객체 조작/조회 |  |  |  |
| AC-22fc19d2 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1563 | if (measure["chk_total_2"].Value == "true") | DATA_OP | chks_data_category.Add | (new Tuple<string, string>("TOTAL_2", "I")) | 데이터 객체 조작/조회 |  |  |  |
| AC-bf00a0b1 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1566 |  | CALL_EXT | MeasureService.SetRowVisibleOnMeasureDatatypeCategoryName | (MainGo, chks_measure_data_category, "PSI", "DATA_TYPE", "CATEGORY_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7967e2e | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1567 |  | CALL_EXT | MeasureService.SetRowVisibleOnDatatypeCategory | (MainGo, chks_data_category) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1d1befe | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1571 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fc6908a | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1575 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-42c45568 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1578 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-166907ba | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1580 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc43a5f9 | this.Load | FP01552_In_House_Moving_Plan.cs:323 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-48d8baf4 | this.Load | FP01552_In_House_Moving_Plan.cs:324 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-4040d87c | this.Load | FP01552_In_House_Moving_Plan.cs:325 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_In_House_Moving_Plan.dCalendar_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4927a340 | drpPeriod.ValueChanged | FP01552_In_House_Moving_Plan.cs:2636 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f66a4130 | drpPeriod.ValueChanged | FP01552_In_House_Moving_Plan.cs:2643 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-dbfe45a1 | drpPeriod.ValueChanged | FP01552_In_House_Moving_Plan.cs:2644 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98cd78ef | DeleteButton | FP01552_In_House_Moving_Plan.cs:784 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01552_In_House_Moving_Plan.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-397e8500 | Dispose | FP01552_In_House_Moving_Plan.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_In_House_Moving_Plan.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c6df0da | EditButton | FP01552_In_House_Moving_Plan.cs:792 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-b85a2be8 | EditButton | FP01552_In_House_Moving_Plan.cs:794 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01552_In_House_Moving_Plan.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6be85665 | ExcelButton | FP01552_In_House_Moving_Plan.cs:1615 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP01552_In_House_Moving_Plan.FindMainData

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetN…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1268a7fe | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1892 | try | LIST_CLEAR | dgEdit.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-3786dad1 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1900 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "PACK_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c473fc6a | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1913 | try ▸ if (!sPack_Plan_Id.Equals(sPack_Plan_Id)) | MESSAGE | MessageBox.Show | (msg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-e75f3afc | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1926 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { lblRequestId.Text = Filter["CONFIRM_PACK_PLAN_ID"].ToStri… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f017ba5a | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1928 | try ▸ lambda | VALUE_SET | lblRequestId.Text | Filter["CONFIRM_PACK_PLAN_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-9a3f3122 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1934 | try | FLAG | dtOperationBod | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-74311065 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1934 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "OPERATION_BOD") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7148660c | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1935 | try | FLAG | dtExcept | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-d6bfea71 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1935 | try | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "EXCEPT") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-43021833 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1940 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_IN_HOUSE_MOVING_PLAN", Filter, CurrentUser, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6d3cf4c9 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1942 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-f154cb37 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1947 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01552_In_House_Moving_Plan.FindTotalColorStart

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL":] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) ▸ if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TY…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f57fc5a6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:575 |  | RETURN | return start; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.FindTotalValue

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmen…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8139421b | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:1868 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_ETC", Filter, CurrentUser, p_sys_type, "TOTAL_VALUE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-8f679c78 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:1869 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-fb1e697f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:1873 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP01552_In_House_Moving_Plan.fn_menuChk

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23c94409 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2950 | if (flo.Visible == false) ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-440fd88f | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2966 | if (flo.Visible == false) ▸ if (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnConfirm.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a59cabdc | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2967 | if (flo.Visible == false) ▸ if (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnCalculation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cab64471 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2970 | if (flo.Visible == false) ▸ else of (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnConfirm.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ef542f69 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2971 | if (flo.Visible == false) ▸ else of (dtConfirmFlag.Good() && dtConfirmFlag.Rows[0]["CONFIRM_YN"].ToString() == "Y") | STATE | btnCalculation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-438267e8 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2976 | if (flo.Visible == false) ▸ if (Int32.Parse(drpPlanDate.DateTime.ToString("yyyyMMdd")) < Int32.Parse(dtCurrDate.Rows[0]["CURR_DATE"].ToStrin… | STATE | btnVersion.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-081aefa0 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2980 | if (flo.Visible == false) ▸ else of (Int32.Parse(drpPlanDate.DateTime.ToString("yyyyMMdd")) < Int32.Parse(dtCurrDate.Rows[0]["CURR_DATE"].To… | STATE | btnVersion.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP01552_In_House_Moving_Plan.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11c005dd | this.Load | FP01552_In_House_Moving_Plan.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_In_House_Moving_Plan.FP01552_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8a84eb0 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:2011 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.GetBasisTime

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7ee4858 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:3419 |  | FLAG | dtPeriod | Data_FP.CallGeneralProcedure2(("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter… | 화면 필드/플래그 변경 |  |  |  |
| AC-cbc8867a | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:3419 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_PR_AMEND_PLANAMEND_FINDBASISTIME").ToUpper(), Filter, CurrentUser) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01552_In_House_Moving_Plan.GetConfirmFlag

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4b1f728 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3387 |  | FLAG | dtConfirmFlag | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-7be0d500 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3387 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CONFIRM_FLAG") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP01552_In_House_Moving_Plan.GetConfrimInfo

진입점: this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)] / this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad8d09f4 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3402 |  | FLAG | dtConfirmInfo | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-8ca02349 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3402 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "CONFIRM_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ada8d0d9 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3406 | if (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmID.Text | dtConfirmInfo.Rows[0]["CONFIRM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0b81021e | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3407 | if (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmDate.Text | dtConfirmInfo.Rows[0]["CONFIRM_DATE"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-3fe8e640 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3411 | else of (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmID.Text | "-" | 컨트롤 값 설정 |  |  |  |
| AC-4a4d65c6 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 7 | FP01552_In_House_Moving_Plan.cs:3412 | else of (dtConfirmInfo.Good()) | VALUE_SET | lblConfirmDate.Text | "-" | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.GetCurrDate

진입점: this.Load / cboInstance.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ea0ae84 | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:3394 |  | FLAG | dtCurrDate | Data_FP.Common_FP(Data_FP.Type.CURR_UTDATE, false, CurrentUser, _sNonAuth, _sSaveAuth, Fil… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURR_UTDATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc31843c | this.Load 외 1 | FP01552_In_House_Moving_Plan.cs:3394 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURR_UTDATE, false, CurrentUser, _sNonAuth, _sSaveAuth, Filter["INSTANCE_ID"… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURR_UTDATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP01552_In_House_Moving_Plan.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc3eb5b6 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3358 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e19e67dd | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3358 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-73de3ce5 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3359 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_In_House_Moving_Plan.GetFilter

진입점: this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try] / this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try] / this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e80d9d7 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 11 | FP01552_In_House_Moving_Plan.cs:3320 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.GetFpPlandId

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6662bda | this.Load 외 3 | FP01552_In_House_Moving_Plan.cs:3341 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-4607e0a1 | this.Load 외 3 | FP01552_In_House_Moving_Plan.cs:3341 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "RELEASE_PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d1c97485 | this.Load 외 3 | FP01552_In_House_Moving_Plan.cs:3342 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |
| AC-dee07bc3 | this.Load 외 3 | FP01552_In_House_Moving_Plan.cs:3345 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3901f0da | this.Load 외 3 | FP01552_In_House_Moving_Plan.cs:3350 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.GetFpPlanId

진입점: this.btnConfirm.Click [if (save_success == true)] / this.btnVersion.Click [if (save_success == true)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f729435 | this.btnConfirm.Click [if (save_success == true)] 외 2 | FP01552_In_House_Moving_Plan.cs:3381 |  | FLAG | dtPlanId | Data_FP.CallGeneralProcedure2(("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELEC… | 화면 필드/플래그 변경 |  |  |  |
| AC-402f6691 | this.btnConfirm.Click [if (save_success == true)] 외 2 | FP01552_In_House_Moving_Plan.cs:3381 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | (("PR_UI_FP01552_ETC").ToUpper(), Filter, CurrentUser, "SELECT", "RELEASE_PLAN_INFO") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-692a2421 | this.btnConfirm.Click [if (save_success == true)] 외 2 | FP01552_In_House_Moving_Plan.cs:3382 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cboPlanId, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |

## FP01552_In_House_Moving_Plan.GetPlanGroup

진입점: this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (GetFilter("INSTANCE_ID") == "")] / this.btnBucket.Click [if (frm.DialogResult …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5c62c15 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 8 | FP01552_In_House_Moving_Plan.cs:3327 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9c9a180a | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 8 | FP01552_In_House_Moving_Plan.cs:3328 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3d772560 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 8 | FP01552_In_House_Moving_Plan.cs:3328 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e6955a23 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 8 | FP01552_In_House_Moving_Plan.cs:3330 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-d1ab6870 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 8 | FP01552_In_House_Moving_Plan.cs:3331 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP01552_In_House_Moving_Plan.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6998d0f5 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3371 |  | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-210e1a7c | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3371 |  | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0d773994 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3372 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_In_House_Moving_Plan.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c321fad8 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3365 |  | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-84bf23fd | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3365 |  | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-1d2fe9df | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:3366 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP01552_In_House_Moving_Plan.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e13da8ad | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1755 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP01552_In_House_Moving_Plan.GoDrawCellColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72895bd8 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:800 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d836b6a8 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:802 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-31e8d607 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:844 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f3882ac | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:845 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-6a270415 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:874 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bb4198f | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:875 | if (current_src != null && calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar.Weeks != null) ▸ foreach (var day… | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-8f50924b | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:904 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | CALL_EXT | Color.FromName | (strColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79c4645c | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:905 | if (current_src != null && calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ if (calendar.Months != null) ▸ foreach (var … | GRID_STYLE | siMain.SetFGColor | (rowindex, index, rowindex, index, color) | 그리드 표시 설정 |  |  |  |
| AC-cece59f1 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:920 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01552_In_House_Moving_Plan.GoEditMode

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e2e3f68 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:926 |  | UI_PROP | this.IsEditMode | do_edit_mode | 속성 IsEditMode 설정 |  |  |  |
| AC-4f2c2586 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:943 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a131c44e | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:953 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolnames[i] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-2e878a9d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:954 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (AmendDate day in calendar.Days.Values) | DATA_OP | daycolidxs[i] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-f215876a | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:984 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | CALL_EXT | siMain.LockRangeColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-05fa7f2b | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:991 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | DATA_OP | dtExcept.Select | ("PLANT_ID = '" + row["PLANT_ID"].ToString() + "' AND " + "ITEM_ID = '" + row["ITEM_ID"].T… | 데이터 객체 조작/조회 |  |  |  |
| AC-32fde7bf | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1000 | if (do_edit_mode) ▸ if (current_src != null) ▸ foreach (DataRow row in current_src.Rows) ▸ if (calendar != null) ▸ foreach (AmendDate day in… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, System.Drawing.Color.FromArgb(255, 237, 236)) | 그리드 표시 설정 |  |  |  |
| AC-0b732f9d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1032 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9574ab96 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1033 | if (do_edit_mode) ▸ if (current_src != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2f9b7cdb | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1045 | else of (do_edit_mode) ▸ if (c != null) | CALL_EXT | siMain.LockRangeColor | (0, 0, c.Tables[0].Rows.Count - 1, max - 1, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2434be94 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1046 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-760f2988 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1063 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (calendar != null) ▸ foreach (var week_item in c… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(242, 255, 237)… | 그리드 표시 설정 |  |  |  |
| AC-3489f01c | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1080 | else of (do_edit_mode) ▸ if (c != null) ▸ if (week_measure != null && week_measure.On) ▸ if (month_measure != null && month_measure.On) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (0, index, c.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |
| AC-16d13a50 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1086 | else of (do_edit_mode) ▸ if (c != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-14e57747 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1087 | else of (do_edit_mode) ▸ if (c != null) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01552_In_House_Moving_Plan.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4000453 | this.Load | FP01552_In_House_Moving_Plan.cs:196 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c14face0 | this.Load | FP01552_In_House_Moving_Plan.cs:200 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-87a47cc5 | this.Load | FP01552_In_House_Moving_Plan.cs:201 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4a851399 | this.Load | FP01552_In_House_Moving_Plan.cs:205 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-bd309246 | this.Load | FP01552_In_House_Moving_Plan.cs:212 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-80e36e7a | this.Load | FP01552_In_House_Moving_Plan.cs:216 |  | VALUE_SET | drpPlanDate.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-a7eadf3d | this.Load | FP01552_In_House_Moving_Plan.cs:220 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-6813d21a | this.Load | FP01552_In_House_Moving_Plan.cs:223 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-3394fa71 | this.Load | FP01552_In_House_Moving_Plan.cs:224 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-08dd7b9e | this.Load | FP01552_In_House_Moving_Plan.cs:224 |  | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b4cd96ac | this.Load | FP01552_In_House_Moving_Plan.cs:228 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-edc7f52e | this.Load | FP01552_In_House_Moving_Plan.cs:229 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.InitEditingBuf

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmen…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-735d14a4 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:2023 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-6d9ba22c | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:2024 |  | FLAG | EditingRow | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-cef2482a | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:2025 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-8bb9dfd9 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:2026 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16636f83 | this.Load | FP01552_In_House_Moving_Plan.cs:291 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-1053cb14 | this.Load | FP01552_In_House_Moving_Plan.cs:292 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e806d793 | this.Load | FP01552_In_House_Moving_Plan.cs:294 |  | UI_PROP | cboSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.InitSpread

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmen…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32efaff5 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:335 | try | DATA_OP | Filter["PROGRAM_ID"] | "FP01552" | 행/컬럼 값 대입 |  |  |  |
| AC-b432776e | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:336 | try | DATA_OP | Filter["SHEET_NAME"] | "AMEND" | 행/컬럼 값 대입 |  |  |  |
| AC-0847cc81 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:351 | try | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-852c59e4 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:352 | try | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-c3525e3f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:357 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP01552_In_House_Moving_Plan.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4fcaa0d | InsertButton | FP01552_In_House_Moving_Plan.cs:752 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c3112f36 | InsertButton | FP01552_In_House_Moving_Plan.cs:760 | if (row != null) | POPUP | new FP01552_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-90158d9c | InsertButton | FP01552_In_House_Moving_Plan.cs:761 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-4eba5e7e | InsertButton | FP01552_In_House_Moving_Plan.cs:761 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-96444285 | InsertButton | FP01552_In_House_Moving_Plan.cs:762 | if (row != null) | UI_PROP | popup.FilterDateMap | dateMap | 속성 FilterDateMap 설정 |  |  |  |
| AC-3b8260c5 | InsertButton | FP01552_In_House_Moving_Plan.cs:764 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b3553464 | InsertButton | FP01552_In_House_Moving_Plan.cs:765 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-490b6271 | InsertButton | FP01552_In_House_Moving_Plan.cs:776 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP01552_In_House_Moving_Plan.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5fd2491 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1715 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01552_In_House_Moving_Plan.PasteAuto

진입점: this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74c78548 | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP01552_In_House_Moving_Plan.cs:3099 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f197c22b | this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetNa… | FP01552_In_House_Moving_Plan.cs:3100 | if (ClipData != null) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |

## FP01552_In_House_Moving_Plan.planday_changed

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.DateTimeChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55698c0e | this.Load 외 2 | FP01552_In_House_Moving_Plan.cs:2580 |  | DATA_OP | Filter["PLAN_DATE"] | drpPlanDate.DateTime.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.RefreshHeader

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good())] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good())] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c0c6422 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:396 | if (monthInfo != null) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-d33037b6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:397 | if (monthInfo != null) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-bfbd4ce6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:398 | if (monthInfo != null) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-4a715c53 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:399 | if (monthInfo != null) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-c5356a0f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:415 | if (monthInfo != null) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cbcd5a8 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:418 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, dsMainFiltered, null, null, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-7e775dbc | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:419 | if (monthInfo != null) ▸ if (added_columns_count == -1) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4095719d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:420 | if (monthInfo != null) ▸ if (added_columns_count == -1) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b61adbce | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:421 | if (monthInfo != null) ▸ if (added_columns_count == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b3dac71e | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:424 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3a60a322 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:425 | if (monthInfo != null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-16dacf40 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:427 | if (monthInfo != null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - added_columns_count + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-0aa19ea0 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:430 | if (monthInfo != null) | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5d06f0ea | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:432 | if (monthInfo != null) | CALL_EXT | siMain.SetRightMerge | (22) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70526c71 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:433 | if (monthInfo != null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e71cdd72 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:470 | if (monthInfo != null) ▸ if (dsMainFiltered.Good()) ▸ foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ if (run) | GRID_STYLE | siMain.SetBGColor | (line, start, line, last_col, tmp) | 그리드 표시 설정 |  |  |  |
| AC-64374ae1 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:489 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-981e4484 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:493 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-58984cbd | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:495 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-55049c52 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:499 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_ite… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ad11b178 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:514 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_i… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-4b9c62e6 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 8 | FP01552_In_House_Moving_Plan.cs:529 | if (monthInfo != null) ▸ if (calendar != null && dsMainFiltered.Good()) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var mont… | GRID_STYLE | siMain.SetBGColor | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.RefreshHeaderOnly

진입점: this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ else of (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (dsMain != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0ef17da | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01552_In_House_Moving_Plan.cs:542 | if (monthInfo == null) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-61bbd924 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01552_In_House_Moving_Plan.cs:543 | if (monthInfo == null) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | siMain.GetColumnIndex("PSI") + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-35a1b911 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01552_In_House_Moving_Plan.cs:544 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a3852f6 | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01552_In_House_Moving_Plan.cs:545 | if (monthInfo == null) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce67609c | this.btnBucket.Click [if (frm.DialogResult == DialogResult.O… 외 3 | FP01552_In_House_Moving_Plan.cs:546 | if (monthInfo == null) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_In_House_Moving_Plan.RefreshSpreadSheet

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnVersion.Click [try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain !=null) ▸ if (dsMain != null)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (dsMain != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60efe214 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1596 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-85162c6d | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 7 | FP01552_In_House_Moving_Plan.cs:1602 | if (dsMainFiltered.Good()) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

## FP01552_In_House_Moving_Plan.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a73f2c3 | popSql.OnSql | FP01552_In_House_Moving_Plan.cs:1851 | if (programID == "PR_UI_FP01552_IN_HOUSE_MOVING_PLAN") | RETURN | return FindMainData(false); |  | 처리 중단/반환 |  |  |  |
| AC-d41faea0 | popSql.OnSql | FP01552_In_House_Moving_Plan.cs:1853 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.Save_Confirm

진입점: this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2076d22 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1310 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20e16082 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1311 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-11331bf3 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1317 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-3e22c5a5 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1334 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01552_In_House_Moving_Plan", "execute_confirm", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_confirm] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-507c57b1 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1338 | try ▸ catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-43506cf8 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1341 | try | ENDPOINT | DataService.FP_RunProcedure | ("FP01552_In_House_Moving_Plan", "execute_planSend", Filter.Dictionary, null,"Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_planSend] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-b61e44f6 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1347 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-d0db34a0 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1348 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f7778d3 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1352 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-292d6c92 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1357 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e96f5d1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1107 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9cb3464 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1117 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d373593 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1118 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-070f07af | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1124 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c136fac9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1126 | try | CALL_EXT | siMain.GetChanges | (start, calendar, "D", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-29f4790f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1131 | try ▸ if (!editDs.Good()) | MESSAGE | MessageBox.Show | ("Nothing to save") | 메시지 표시 |  |  |  |
| AC-5e28c35a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1132 | try ▸ if (!editDs.Good()) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6b246084 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1133 | try ▸ if (!editDs.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f100484c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1155 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-22fbbe89 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1163 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9ae59fda | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1164 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f03f520 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1165 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bda45a31 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1166 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c8b99c3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1167 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-326d83cb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1168 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5489eddb | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1169 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("STORAGE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4eab6d26 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1170 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("SOC_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-306417b9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1171 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f93c531 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1172 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("DELIVERY_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd1ddf47 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1173 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1491f2f9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1174 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | DATA_OP | x.Field | ("CATEGORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1bc6c44 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1161 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ lambda | RETURN | return ( x.Field<string>("INSTANCE_ID") == instance_id && x.Field<string>("PLAN_… |  | 처리 중단/반환 |  |  |  |
| AC-f1425b6c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1200 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | dt.Rows.Remove | (selected) | 데이터 객체 조작/조회 |  |  |  |
| AC-d52870bc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1205 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["DELIVERY_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-253c1ef9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1206 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ if (matching_row_from_EditGrid.Count() > 0) ▸ i… | DATA_OP | selected["M"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-95351fbf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1218 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac9dcd56 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1220 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["INSTANCE_ID"] | instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-98a6dce0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1221 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLAN_ID"] | plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-a6f83fd0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1222 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["COMPANY_ID"] | enum_row_from_Saving["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-582c3aa3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1223 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DIVISION_ID"] | enum_row_from_Saving["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-87d1156c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1224 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SITE_ID"] | enum_row_from_Saving["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0404ad93 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1225 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["PLANT_ID"] | enum_row_from_Saving["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34a7c6ab | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1226 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ITEM_ID"] | enum_row_from_Saving["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-59686377 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1227 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["STORAGE_ID"] | enum_row_from_Saving["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3b992e97 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1228 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["SOC_ID"] | enum_row_from_Saving["SOC_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c653a0a0 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1229 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["MARKET"] | enum_row_from_Saving["MARKET"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac11be1f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1230 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DELIVERY_DATE"] | plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-4d54e6b3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1231 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["CATEGORY_ID"] | enum_row_from_Saving["CATEGORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a27558e2 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1235 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["DELIVERY_QTY"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-1a4693e9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1236 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["ORG_DELIVERY_QTY"] | EditingValue | 행/컬럼 값 대입 |  |  |  |
| AC-4e03a5b9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1239 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | newrow["M"] | "I" | 행/컬럼 값 대입 |  |  |  |
| AC-80a2f289 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1241 | try ▸ if (editDs.Good()) ▸ foreach (DataRow enum_row_from_Saving in editDs.Tables[0].Rows) ▸ else of (matching_row_from_EditGrid.Count() > 0… | DATA_OP | dt.Rows.Add | (newrow) | 데이터 객체 조작/조회 |  |  |  |
| AC-effcc288 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1259 | try | DATA_OP | objDs.Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-57575402 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1261 | try ▸ if (!objDs.Columns.Contains("USER_ID")) | DATA_OP | objDs.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-8114ef13 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1264 | try ▸ if (!objDs.Columns.Contains("USER_ID")) ▸ foreach (DataRow dr in objDs.Rows) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-78f6cdb4 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1268 | try | ENDPOINT | DataService.FP_UpdateBatch | ("FP01552_In_House_Moving_Plan", "merge_data", objDs.DataSet, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_data] \| FP\Planning\FP015… | 엔드포인트 호출 |  |  |  |
| AC-607473c1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1290 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2fe8c327 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1291 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-98d3d9a9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1295 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-76c79388 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP01552_In_House_Moving_Plan.cs:1297 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.Save_VersionUp

진입점: this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb1f5117 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1370 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af0fbac4 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1371 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6793bf3f | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1377 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f0527727 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1394 | try | DATA_OP | Filter["BASIS_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fea47822 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1395 | try | DATA_OP | Filter["CREATE_PLAN_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-d869c641 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1396 | try | DATA_OP | Filter["CAL_OPTION"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-c953df4a | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1397 | try | DATA_OP | Filter["FIX_DATE"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-21fbece0 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1398 | try | DATA_OP | Filter["COPY_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-97f35568 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1399 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3d78bf8d | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1400 | try | DATA_OP | Filter["TARGET_DATE"] | Filter["CURR_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-81ef119b | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1404 | try ▸ try | ENDPOINT | DataService.FP_RunProcedure | ("FP01552_In_House_Moving_Plan", "execute_version", Filter.Dictionary, null, "Planning") ⇒ biz:FPCommonDataBLL.GeneralRunProcedure [procedure=execute_version] \| FP\Planni… | 엔드포인트 호출 |  |  |  |
| AC-774d0434 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1408 | try ▸ catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5f76e6d2 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1415 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-6d9853f3 | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1416 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c8c6605b | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1420 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b60b28ea | this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you wan… | FP01552_In_House_Moving_Plan.cs:1425 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b143cf2 | SaveButton | FP01552_In_House_Moving_Plan.cs:1096 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c996b7ce | SaveButton | FP01552_In_House_Moving_Plan.cs:1098 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP01552_In_House_Moving_Plan.SetBohQty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a995c2 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1454 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-54dfef2f | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1455 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-74ca4bc0 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1460 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ if (sDataType == "TOTAL_2") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-bec3e80f | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1466 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-95dabdb5 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1467 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-03460154 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1468 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9386db58 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1469 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-10a88730 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1470 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4fe9f505 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1471 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9498f640 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1472 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bce319c | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1473 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ lambda | DATA_OP | each_row.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b67d129 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:1477 | foreach (DataRow row in dsResult.Tables[0].Rows) ▸ else of (sDataType == "TOTAL_2") ▸ if (sDataType == "TOTAL") ▸ if (result.Count() > 0) | DATA_OP | row["BOH_QTY"] | result.First()["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / cboPlanId.SelectedIndexChanged [if (old_plan_type != Filter["PLAN_TYPE"].SafeString())] / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cee4ca8c | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:250 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4636e38b | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:250 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-97437f2b | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:259 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-569e6968 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:259 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9a26c9f0 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:260 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-71e7cfe6 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:266 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-006f9b12 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:267 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b0f9d9da | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:267 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7d397b67 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:268 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62ae29b5 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:274 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-97453e06 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:275 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee8de731 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:275 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f02693c3 | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:276 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f3fdde8c | this.Load 외 5 | FP01552_In_House_Moving_Plan.cs:282 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cd5ace2 | this.Load | FP01552_In_House_Moving_Plan.cs:147 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-545204e1 | this.Load | FP01552_In_House_Moving_Plan.cs:149 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-6560516c | this.Load | FP01552_In_House_Moving_Plan.cs:150 | if (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-27db19d8 | this.Load | FP01552_In_House_Moving_Plan.cs:151 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-47f8da60 | this.Load | FP01552_In_House_Moving_Plan.cs:155 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-4edfae84 | this.Load | FP01552_In_House_Moving_Plan.cs:156 | else of (UserService.HasExtraRole(CurrentUser)) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-86523e04 | this.Load | FP01552_In_House_Moving_Plan.cs:157 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ceb3fa8b | this.Load | FP01552_In_House_Moving_Plan.cs:159 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-f5310263 | this.Load | FP01552_In_House_Moving_Plan.cs:160 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dad8098b | this.Load | FP01552_In_House_Moving_Plan.cs:162 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-26c0630e | this.Load | FP01552_In_House_Moving_Plan.cs:163 | if (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0df70f8d | this.Load | FP01552_In_House_Moving_Plan.cs:164 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a221c7f4 | this.Load | FP01552_In_House_Moving_Plan.cs:168 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-554678a1 | this.Load | FP01552_In_House_Moving_Plan.cs:169 | else of (UserService.HasSuperRole(CurrentUser)) | STATE | btnToggleSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2359c9ba | this.Load | FP01552_In_House_Moving_Plan.cs:170 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.SetDirty

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f528823 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 1 | FP01552_In_House_Moving_Plan.cs:3454 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.SetFilter

진입점: this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ try ▸ if (cboPlanId.SelectedIndex >= 0)] / this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ if (!sPack_Plan_Id.Equals(sPack_Plan_Id)) ▸ if (MessageBox.Show(msg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes)] / this.btnVersion.Click [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01c50106 | this.btnConfirm.Click [try ▸ if (MessageBox.Show("Do you wan… 외 19 | FP01552_In_House_Moving_Plan.cs:3315 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP01552_In_House_Moving_Plan.SetPlanOut

진입점: this.spdMain.ClipboardPasting [if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipData.GetLength(1) > 0) ▸ if (!string.IsNullOrEmpty(src_copy)) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[startrow, startcol].Locked && siMain.ActiveSheet.Cells[startrow, startcol].BackColor == System…)] / this.spdMain.ClipboardPasted [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (ClipData != null) ▸ for (i < row) ▸ for (j < col) ▸ if (row == 1 && col == 1)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2c30b7f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2036 | if (EditingCol != cCol) | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-3fbf2876 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2041 | if (EditingRow != cRow) | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-f87f0bc8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2047 | if (EditingCol != cCol) | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-a6aeb1e4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2080 | if (dsMainFiltered.Good()) ▸ if (!Clipboard) ▸ if (new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | EditingValue | 그리드 속성/값 설정 |  |  |  |
| AC-97fbedae | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2081 | if (dsMainFiltered.Good()) ▸ if (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3d3983da | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2091 | if (dsMainFiltered.Good()) ▸ else of (!Clipboard) ▸ if (new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e811a9a9 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2100 | if (dsMainFiltered.Good()) ▸ if (Clipboard && org_value == new_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-65183961 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2104 | if (dsMainFiltered.Good()) ▸ if (Clipboard) | DATA_OP | clicked_row[ColumnName_Buf] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-f976695c | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2132 | if (dsMainFiltered.Good()) ▸ if (day == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2adaf647 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2241 | if (dsMainFiltered.Good()) | DATA_OP | bodlt.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9cd42e29 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2242 | if (dsMainFiltered.Good()) | DATA_OP | bodlt.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b28dce60 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2243 | if (dsMainFiltered.Good()) | DATA_OP | bodlt.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fbfe662 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2244 | if (dsMainFiltered.Good()) | DATA_OP | bodlt.Field | ("MOVING_TIME_DAY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b97392fb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2246 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_eohAvail") | 데이터 객체 조작/조회 |  |  |  |
| AC-cd0223e4 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2250 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eohAvail")) | CALL_EXT | Convert.ToInt16 | (BodLt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c587fbdb | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2254 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eohAvail")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1668baf1 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2259 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eohAvail")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PLANT_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-882c7671 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2292 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eohAvail")) ▸ if (rowDay.Length > 0) ▸ if (rowInventory.Length > 0) ▸ while (… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing - delta | 그리드 속성/값 설정 |  |  |  |
| AC-b1cde405 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2314 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_eoh") | 데이터 객체 조작/조회 |  |  |  |
| AC-4cbd906e | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2318 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eoh")) | CALL_EXT | Convert.ToInt16 | (BodLt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f0ad38b | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2322 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eoh")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-65d2466f | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2327 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eoh")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PLANT_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-34472b03 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2358 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_eoh")) ▸ if (rowDay.Length > 0) ▸ if (rowInventory.Length > 0) ▸ while (!stri… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing - delta | 그리드 속성/값 설정 |  |  |  |
| AC-7534cbf8 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2380 | if (dsMainFiltered.Good()) | DATA_OP | measure.Data.ContainsKey | ("chk_meet") | 데이터 객체 조작/조회 |  |  |  |
| AC-60be835d | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2388 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_meet")) | DATA_OP | dateMap.Tables[0].Select | ("D_VALUE = '" + sDate + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e11e1331 | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2393 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_meet")) ▸ if (rowDay.Length > 0) | DATA_OP | dsMainFiltered.Tables[0].Select | ("DATA_TYPE = 'DATA' AND " + " LV1 = '" + row["LV1"].ToString() + "' AND " + " PLANT_ID = … | 데이터 객체 조작/조회 |  |  |  |
| AC-c846e4fd | this.spdMain.ClipboardPasting [if (UseSingleCellPaste && Cli… 외 2 | FP01552_In_House_Moving_Plan.cs:2423 | if (dsMainFiltered.Good()) ▸ if (measure.Data.ContainsKey("chk_meet")) ▸ if (rowDay.Length > 0) ▸ if (rowInventory.Length > 0) ▸ while (!str… | GRID_SET | siMain.ActiveSheet.Cells[nRow, next_col].Value | existing + delta | 그리드 속성/값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9d5c9e9 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:365 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5c3e4f05 | (진입점 미연결) | FP01552_In_House_Moving_Plan.cs:366 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_ButtonClicked

진입점: this.spdMain.ButtonClicked

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15b220b8 | this.spdMain.ButtonClicked | FP01552_In_House_Moving_Plan.cs:3299 |  | VALUE_SET | tbLog.Text | "spdMain_ButtonClicked" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aeb2795d | this.spdMain.CellClick | FP01552_In_House_Moving_Plan.cs:3215 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de7d3311 | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3474 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | POPUP | new FP01552_ItemCMA_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-c33ecd36 | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3476 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0d509e1a | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3477 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7350cc63 | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3478 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-34e21acf | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3479 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["STORAGE_ID"] | row["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5554f323 | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3480 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["ITEM_ID"] | row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1fcff27e | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3482 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f9d3fa6e | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3483 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-88d292eb | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3484 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | DATA_OP | cmaPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c922030 | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3486 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | UI_PROP | cmaPopup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b37ef1dc | this.spdMain.CellDoubleClick | FP01552_In_House_Moving_Plan.cs:3487 | if (dsMainFiltered.Good()) ▸ if (e.Column == siMain.GetColumnIndex("PSI") && row["PSI"].ToString() == "P(CMA)") | POPUP | cmaPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4c5771f | this.spdMain.Change | FP01552_In_House_Moving_Plan.cs:3293 |  | VALUE_SET | tbLog.Text | "spdMain_Change" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_ChildControlDeactivated

진입점: this.spdMain.ChildControlDeactivated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc4a99f7 | this.spdMain.ChildControlDeactivated | FP01552_In_House_Moving_Plan.cs:3245 |  | VALUE_SET | tbLog.Text | "spdMain_ChildControlDeactivated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4433a021 | this.spdMain.ClipboardPasted | FP01552_In_House_Moving_Plan.cs:3160 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fee20b56 | this.spdMain.ClipboardPasted | FP01552_In_House_Moving_Plan.cs:3165 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c158a0b0 | this.spdMain.ClipboardPasted | FP01552_In_House_Moving_Plan.cs:3169 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-89a5766e | this.spdMain.ClipboardPasted | FP01552_In_House_Moving_Plan.cs:3171 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-620a2ead | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:2999 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-5dddc1e8 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3000 |  | ENDPOINT | Clipboard.GetDataObject | () | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ce60726 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3002 |  | COMBO_DATA | data.GetFormats | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-085723a2 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3005 |  | ENDPOINT | data.GetDataPresent | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-12ae6b39 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3007 | if (data.GetDataPresent(typeof(System.String))) | ENDPOINT | data.GetData | (typeof(System.String)) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-819cea86 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3011 | if (data.GetDataPresent(typeof(System.String))) | CALL_EXT | src_string.ToCharArray | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-349033cd | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3027 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) | FLAG | ClipData | new string[ClipRowCount, MaxColCount] | 화면 필드/플래그 변경 |  |  |  |
| AC-28962b10 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3038 | if (data.GetDataPresent(typeof(System.String))) ▸ if (MaxColCount > 0 && ClipRowCount > 0) ▸ for (i < ClipRowCount) ▸ for (j < cells.Length) | DATA_OP | ClipData[i, j] | cell | 행/컬럼 값 대입 |  |  |  |
| AC-dc9dbd2d | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3050 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4ce788e | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3051 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipData.GetLength | (1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b773a98 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3056 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-a2a24329 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3071 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | GRID_SET | siMain.ActiveSheet.Cells[startrow, startcol].Value | src_copy | 그리드 속성/값 설정 |  |  |  |
| AC-26df1085 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3076 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ae05523 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3079 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) ▸ if (ClipData != null && ClipData.GetLength(0) > 0 && ClipDa… | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-dec4fe31 | this.spdMain.ClipboardPasting | FP01552_In_House_Moving_Plan.cs:3081 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | Clipboard.Clear | () | ⚠ 의미 확인 필요 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_DragFillBlockCompleted

진입점: this.spdMain.DragFillBlockCompleted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28dfaa2b | this.spdMain.DragFillBlockCompleted | FP01552_In_House_Moving_Plan.cs:3255 |  | VALUE_SET | tbLog.Text | "spdMain_DragFillBlockCompleted" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d7d21e8 | this.spdMain.EditChange | FP01552_In_House_Moving_Plan.cs:3210 |  | VALUE_SET | tbLog.Text | "spdMain_EditChange" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_EditModeOff

진입점: this.spdMain.EditModeOff

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d514e1a4 | this.spdMain.EditModeOff | FP01552_In_House_Moving_Plan.cs:3273 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOff" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7a76d99 | this.spdMain.EditModeOn | FP01552_In_House_Moving_Plan.cs:3279 |  | VALUE_SET | tbLog.Text | "spdMain_EditModeOn" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |
| AC-60f099ba | this.spdMain.EditModeOn | FP01552_In_House_Moving_Plan.cs:3280 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_EditorFocused

진입점: this.spdMain.EditorFocused

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34d2ec54 | this.spdMain.EditorFocused | FP01552_In_House_Moving_Plan.cs:3267 |  | VALUE_SET | tbLog.Text | "spdMain_EditorFocused" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_Enter

진입점: this.spdMain.Enter

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-686471f2 | this.spdMain.Enter | FP01552_In_House_Moving_Plan.cs:3230 |  | VALUE_SET | tbLog.Text | "spdMain_Enter" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_Leave

진입점: this.spdMain.Leave

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2968de68 | this.spdMain.Leave | FP01552_In_House_Moving_Plan.cs:3225 |  | VALUE_SET | tbLog.Text | "spdMain_Leave" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_SubEditorClosed

진입점: this.spdMain.SubEditorClosed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e640da4f | this.spdMain.SubEditorClosed | FP01552_In_House_Moving_Plan.cs:3261 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorClosed" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_SubEditorOpening

진입점: this.spdMain.SubEditorOpening

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ffa6739 | this.spdMain.SubEditorOpening | FP01552_In_House_Moving_Plan.cs:3250 |  | VALUE_SET | tbLog.Text | "spdMain_SubEditorOpening" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_TableChanged

진입점: this.spdMain.TableChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-949667f5 | this.spdMain.TableChanged | FP01552_In_House_Moving_Plan.cs:3198 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e04be310 | this.spdMain.TableChanged | FP01552_In_House_Moving_Plan.cs:3200 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_TextChanged

진입점: this.spdMain.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a354aa3b | this.spdMain.TextChanged | FP01552_In_House_Moving_Plan.cs:3181 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | dsMainFiltered.FirstRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eac6aa66 | this.spdMain.TextChanged | FP01552_In_House_Moving_Plan.cs:3183 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (row != null) ▸ if (siMain.ActiveSheet.RowC… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_Validated

진입점: this.spdMain.Validated

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8ed9009 | this.spdMain.Validated | FP01552_In_House_Moving_Plan.cs:3235 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.spdMain_Validating

진입점: this.spdMain.Validating

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3869d0d | this.spdMain.Validating | FP01552_In_House_Moving_Plan.cs:3240 |  | VALUE_SET | tbLog.Text | "spdMain_Validated" + "\r\n" + tbLog.Text | 컨트롤 값 설정 |  |  |  |

## FP01552_In_House_Moving_Plan.UIFindData

진입점: this.btnCalculation.Click [if (calPop.ShowDialog() == DialogResult.OK)] / this.btnVersion.Click / this.btnBucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / this.btnCategory.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (measure.NeedLoad && dsMain !=null)] / FindButton / InsertButton [if (row != null) ▸ if (popup.ShowDialog() == DialogResult.OK)] / SaveButton [if (save_success == true)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76da4129 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:601 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0136452f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:602 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39f1d2ba | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:605 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-66b13b45 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:608 | try ▸ if (Filter["PLAN_ID"] == "") | DATA_OP | Filter["PLAN_ID"] | cboPlanId.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-4de4161f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:612 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-2c82c8a2 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:613 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a8fd45f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:617 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9d635c56 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:639 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-680cbb92 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:643 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e75eab4f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:644 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-af153275 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:648 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-5a8eace8 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:659 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-58591030 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:661 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindMainData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b7822a5 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:661 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindMainData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5912b6bf | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:667 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-331ce7ab | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:669 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue() | 화면 필드/플래그 변경 |  |  |  |
| AC-3f1f9047 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:672 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dsMain.Tables[0].Columns.Add | (new DataColumn("_MM_", typeof(bool))) | 데이터 객체 조작/조회 |  |  |  |
| AC-6b7b6580 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:689 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d02c610f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:695 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-76248250 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:699 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d1c8217f | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:705 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8fdf2c85 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:711 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-34778695 | this.btnCalculation.Click [if (calPop.ShowDialog() == Dialog… 외 6 | FP01552_In_House_Moving_Plan.cs:715 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP01552_In_House_Moving_Plan.UISaveConfirm

진입점: this.btnConfirm.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b656355 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:1656 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-5890a194 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:1659 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-360de43e | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:1660 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0b3fd1f | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:1667 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-eceba0b3 | this.btnConfirm.Click | FP01552_In_House_Moving_Plan.cs:1672 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_In_House_Moving_Plan.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9b9414c2 | SaveButton | FP01552_In_House_Moving_Plan.cs:1625 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-fc1fda50 | SaveButton | FP01552_In_House_Moving_Plan.cs:1628 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-def9391d | SaveButton | FP01552_In_House_Moving_Plan.cs:1630 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9db17e84 | SaveButton | FP01552_In_House_Moving_Plan.cs:1637 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-bd9d7d7f | SaveButton | FP01552_In_House_Moving_Plan.cs:1642 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_In_House_Moving_Plan.UISaveVersionUp

진입점: this.btnVersion.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e51e6b2d | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:1687 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-78554f0a | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:1690 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-25036715 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:1692 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a5749ae | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:1699 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-7d25fca5 | this.btnVersion.Click | FP01552_In_House_Moving_Plan.cs:1704 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_ItemCMA_Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5382a1fd | this.Load | FP01552_ItemCMA_Popup.cs:139 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b327548a | this.Load | FP01552_ItemCMA_Popup.cs:140 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-1442d121 | this.Load | FP01552_ItemCMA_Popup.cs:141 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_ItemCMA_Popup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7a4cf6b | this.Load | FP01552_ItemCMA_Popup.cs:134 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_ItemCMA_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71b6fcc1 | Dispose | FP01552_ItemCMA_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_ItemCMA_Popup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d0fe541 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:209 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ecbdc2b5 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:210 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bace666d | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:212 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9d443a86 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:213 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-106203ac | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:214 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7391b0ce | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:215 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendCommon", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\Amen… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4c6bfd99 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:218 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7da60e90 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:220 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { string bulk_info = DataService.ToLoopParam("", bukInfo); Filter["BUCKET"] = bulk_… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25539c65 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:223 | lambda | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-5caf5ab2 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:225 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | (("PR_UI_FP01552_ETC").ToUpper(), Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ec5a87f2 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:227 | lambda | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-a470942a | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:231 |  | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-e2ab3319 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:232 |  | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-91b0fb76 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:233 |  | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-705e18f7 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:236 |  | GRID_INIT | siMain.SetSheetHeaderDateColumn_FP | (calendar, false, false, true, 2, FPExtensions.DateColumnType.QTY) | 그리드 재구성/초기화 |  |  |  |
| AC-cc35e963 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:238 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-43bb62fe | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:240 |  | GRID_LOCK | siMain.LockColumn | (0, max_col - added, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a5cdf5c | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:243 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-b7f6eec7 | this.Load 외 1 | FP01552_ItemCMA_Popup.cs:247 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_ItemCMA_Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-952c9898 | this.Load | FP01552_ItemCMA_Popup.cs:106 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1097ab1c | this.Load | FP01552_ItemCMA_Popup.cs:108 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-17b57e2a | this.Load | FP01552_ItemCMA_Popup.cs:116 |  | DATA_OP | Filter["BUCKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-0c287770 | this.Load | FP01552_ItemCMA_Popup.cs:118 |  | DATA_OP | Filter["BUCKET_TO"] | DateUtil.GetDateAdd(Filter["BUCKET_FROM"], 55, "D") | 행/컬럼 값 대입 |  |  |  |

## FP01552_ItemCMA_Popup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c64193db | this.Load | FP01552_ItemCMA_Popup.cs:151 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d73001d6 | this.Load | FP01552_ItemCMA_Popup.cs:152 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_ItemCMA_Popup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a92e26e | (진입점 미연결) | FP01552_ItemCMA_Popup.cs:171 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_ItemCMA_Popup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f4adbfb | this.Load | FP01552_ItemCMA_Popup.cs:158 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb2db7a7 | this.Load | FP01552_ItemCMA_Popup.cs:159 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-5fca1f9f | this.Load | FP01552_ItemCMA_Popup.cs:163 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01552_ItemCMA_Popup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75f3fadf | this.spdMain.CellClick | FP01552_ItemCMA_Popup.cs:272 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-0148290b | this.spdMain.CellClick | FP01552_ItemCMA_Popup.cs:273 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-8e6a5fbc | this.spdMain.CellClick | FP01552_ItemCMA_Popup.cs:276 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01552_ItemCMA_Popup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae0b9e9c | this.spdMain.CellDoubleClick | FP01552_ItemCMA_Popup.cs:282 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-cef844c1 | this.spdMain.CellDoubleClick | FP01552_ItemCMA_Popup.cs:283 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6f2f04f3 | this.spdMain.CellDoubleClick | FP01552_ItemCMA_Popup.cs:286 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-38804242 | this.spdMain.CellDoubleClick | FP01552_ItemCMA_Popup.cs:289 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f1867a10 | this.spdMain.CellDoubleClick | FP01552_ItemCMA_Popup.cs:299 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_ItemPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5eea3124 | this.btnButtonList.UsrButtonList_Click_Detected | FP01552_ItemPopup.cs:265 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-6f12b1e4 | this.btnButtonList.UsrButtonList_Click_Detected | FP01552_ItemPopup.cs:268 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-2ff5f78d | this.btnButtonList.UsrButtonList_Click_Detected | FP01552_ItemPopup.cs:269 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_ItemPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aa384c4 | this.Load | FP01552_ItemPopup.cs:137 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-733adbf7 | this.Load | FP01552_ItemPopup.cs:138 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a865559 | this.Load | FP01552_ItemPopup.cs:139 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_ItemPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-768920ff | this.Load | FP01552_ItemPopup.cs:132 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_ItemPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68cbe796 | Dispose | FP01552_ItemPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_ItemPopup.FindData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Find:] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16facba1 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:208 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e8d07571 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:212 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b6e229a4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:214 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { Filter["ITEM_ID"] = txtItem.Text; Filter["CELL_ITEM_ID"] = txtItem.Text; Filter["… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-59429fe4 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:216 | lambda | DATA_OP | Filter["ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-d3b700af | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:217 | lambda | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-640a3beb | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:218 | lambda | DATA_OP | Filter["NICK_NAME"] | txtNickName.Text | 행/컬럼 값 대입 |  |  |  |
| AC-885e0b2f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:222 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "ITEM_LIST") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1615ff30 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:224 | lambda | RETURN | return itemList; |  | 처리 중단/반환 |  |  |  |
| AC-457b1709 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:228 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5059d608 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:231 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-94b5fa1f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… 외 1 | FP01552_ItemPopup.cs:233 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01552_ItemPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c079c91d | this.Load | FP01552_ItemPopup.cs:102 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f0c47b7 | this.Load | FP01552_ItemPopup.cs:104 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_ItemPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2cacfe9 | this.Load | FP01552_ItemPopup.cs:149 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cde42ac4 | this.Load | FP01552_ItemPopup.cs:150 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_ItemPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64df64dd | (진입점 미연결) | FP01552_ItemPopup.cs:169 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_ItemPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3150d1c9 | this.Load | FP01552_ItemPopup.cs:156 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d792fdb5 | this.Load | FP01552_ItemPopup.cs:157 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-3522b280 | this.Load | FP01552_ItemPopup.cs:161 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01552_ItemPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7525d3cb | this.spdMain.CellClick | FP01552_ItemPopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-8ba2f69c | this.spdMain.CellClick | FP01552_ItemPopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-13d45e56 | this.spdMain.CellClick | FP01552_ItemPopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01552_ItemPopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4a9771e | this.spdMain.CellDoubleClick | FP01552_ItemPopup.cs:290 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-f6c6e8aa | this.spdMain.CellDoubleClick | FP01552_ItemPopup.cs:291 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-23d57e19 | this.spdMain.CellDoubleClick | FP01552_ItemPopup.cs:294 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-a8879864 | this.spdMain.CellDoubleClick | FP01552_ItemPopup.cs:297 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c4508df | this.spdMain.CellDoubleClick | FP01552_ItemPopup.cs:307 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_LineAddPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c9e7368 | .ctor | FP01552_LineAddPopup.cs:98 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |
| AC-9279ab45 | .ctor | FP01552_LineAddPopup.cs:99 |  | FLAG | this.InitRow | initRow | 화면 필드/플래그 변경 |  |  |  |

## FP01552_LineAddPopup.btnCellItem_Click

진입점: this.btnCellItem.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b600e1a | this.btnCellItem.Click | FP01552_LineAddPopup.cs:522 |  | POPUP | new FP01552_ItemPopup | () | 팝업/폼 생성 |  |  |  |
| AC-30afdfa2 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:523 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-c7bf7ed4 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:525 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0541f561 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:526 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7c04c3e4 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:527 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e71e33f6 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:528 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fc3ac0e8 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:529 |  | DATA_OP | popup.Filter["CELL_ITEM_ID"] | Filter["CELL_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e3a79ad7 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:530 |  | DATA_OP | popup.Filter["NICK_NAME"] | Filter["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-c77e2d49 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:532 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9b1b1b8 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:534 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-04cee745 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:539 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["COMPANY_ID"] | data["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8f28d328 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:540 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["DIVISION_ID"] | data["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9a1c790a | this.btnCellItem.Click | FP01552_LineAddPopup.cs:541 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["SITE_ID"] | data["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-294e4f23 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:542 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["PLANT_ID"] | data["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-90bd2a1d | this.btnCellItem.Click | FP01552_LineAddPopup.cs:543 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["MARKET"] | "D" | 행/컬럼 값 대입 |  |  |  |
| AC-d9b59fd1 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:544 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["NICK_NAME"] | data["NICK_NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a9cfee01 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:545 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["CELL_ITEM_ID"] | txtItem.Text = data["CELL_ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dbce4122 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:545 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtItem.Text | data["CELL_ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-31f82ff2 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:547 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["STORAGE_ID"] | txtSloc.Text = string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-185cbf75 | this.btnCellItem.Click | FP01552_LineAddPopup.cs:547 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_CLEAR | txtSloc.Text | string.Empty | 컨트롤 값 비움 |  |  |  |

## FP01552_LineAddPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ca15102 | this.btnClose.Click | FP01552_LineAddPopup.cs:245 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_LineAddPopup.btnSave_Click

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19ecc0e9 | this.btnSave.Click | FP01552_LineAddPopup.cs:238 | if (Check_Data() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP01552_LineAddPopup.btnSloc_Click

진입점: this.btnSloc.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de3c9196 | this.btnSloc.Click | FP01552_LineAddPopup.cs:489 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Please insert Cell Item value") | 메시지 표시 |  |  |  |
| AC-5632de50 | this.btnSloc.Click | FP01552_LineAddPopup.cs:490 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39bfb72f | this.btnSloc.Click | FP01552_LineAddPopup.cs:492 |  | POPUP | new FP01552_StoragePopup | () | 팝업/폼 생성 |  |  |  |
| AC-6feb390c | this.btnSloc.Click | FP01552_LineAddPopup.cs:493 |  | UI_PROP | popup.Filter | new FilterDataSet() | 속성 Filter 설정 |  |  |  |
| AC-567cab57 | this.btnSloc.Click | FP01552_LineAddPopup.cs:495 |  | DATA_OP | popup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-336eecef | this.btnSloc.Click | FP01552_LineAddPopup.cs:496 |  | DATA_OP | popup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2edb398d | this.btnSloc.Click | FP01552_LineAddPopup.cs:497 |  | DATA_OP | popup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b3332407 | this.btnSloc.Click | FP01552_LineAddPopup.cs:498 |  | DATA_OP | popup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1a158a72 | this.btnSloc.Click | FP01552_LineAddPopup.cs:499 |  | DATA_OP | popup.Filter["CELL_CELL_ITEM_ID"] | txtItem.Text | 행/컬럼 값 대입 |  |  |  |
| AC-7c233564 | this.btnSloc.Click | FP01552_LineAddPopup.cs:500 |  | DATA_OP | popup.Filter["MARKET"] | Filter["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-54a5bdcf | this.btnSloc.Click | FP01552_LineAddPopup.cs:501 |  | DATA_OP | popup.Filter["STORAGE_ID"] | Filter["STORAGE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4417157b | this.btnSloc.Click | FP01552_LineAddPopup.cs:503 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-10d0870e | this.btnSloc.Click | FP01552_LineAddPopup.cs:505 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8d064c6c | this.btnSloc.Click | FP01552_LineAddPopup.cs:510 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | DATA_OP | Filter["STORAGE_ID"] | txtSloc.Text = data["STORAGE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-076052b0 | this.btnSloc.Click | FP01552_LineAddPopup.cs:510 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (data != null) | VALUE_SET | txtSloc.Text | data["STORAGE_ID"].ToString() | 컨트롤 값 설정 |  |  |  |

## FP01552_LineAddPopup.cboTransport_changed

진입점: cboTransport.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8584943 | cboTransport.SelectedIndexChanged | FP01552_LineAddPopup.cs:228 |  | DATA_OP | Filter["TRANSPORT"] | CString.GetCheckedListValue(dtTransport, cboTransport.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP01552_LineAddPopup.Check_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-310bd8da | this.btnSave.Click | FP01552_LineAddPopup.cs:257 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | MESSAGE | MessageBox.Show | ("Select Cell Code") | 메시지 표시 |  |  |  |
| AC-be07b4d4 | this.btnSave.Click | FP01552_LineAddPopup.cs:258 | if (string.IsNullOrWhiteSpace(txtItem.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9fdfff0c | this.btnSave.Click | FP01552_LineAddPopup.cs:263 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | MESSAGE | MessageBox.Show | ("You need to select ERP Sloc.") | 메시지 표시 |  |  |  |
| AC-cec42fdb | this.btnSave.Click | FP01552_LineAddPopup.cs:264 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-00876328 | this.btnSave.Click | FP01552_LineAddPopup.cs:269 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | MESSAGE | MessageBox.Show | ("You need to select Transport") | 메시지 표시 |  |  |  |
| AC-5e42f422 | this.btnSave.Click | FP01552_LineAddPopup.cs:270 | if (string.IsNullOrWhiteSpace(txtSloc.Text)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dc85902f | this.btnSave.Click | FP01552_LineAddPopup.cs:275 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | MESSAGE | MessageBox.Show | ("You need to specify quantity") | 메시지 표시 |  |  |  |
| AC-6f1f29ca | this.btnSave.Click | FP01552_LineAddPopup.cs:276 | if (string.IsNullOrWhiteSpace(txtQty.Text) \|\| txtQty.Text == "0") | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6d8d883f | this.btnSave.Click | FP01552_LineAddPopup.cs:284 | catch () | MESSAGE | MessageBox.Show | ("You shoud insert quantity as number") | 메시지 표시 |  |  |  |
| AC-78c1ff36 | this.btnSave.Click | FP01552_LineAddPopup.cs:285 | catch () | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e3a4cc67 | this.btnSave.Click | FP01552_LineAddPopup.cs:290 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP01552_LineAddPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2693b250 | Dispose | FP01552_LineAddPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_LineAddPopup.dpPlanDate_ValueChanged

진입점: dpPlanDate.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b188b4d | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:437 | try | DATA_OP | dtDateMap.Select("IS_PLAN = 'Y' ", "_DATE").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6c949887 | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:437 | try | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' ", "_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2010a859 | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:442 | try | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' AND _DATE = '" + dpPlanDate.Value.ToString("yyyMMdd") + "'", "_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-17e0cd0d | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:446 | try ▸ if (isYN) | DATA_OP | Filter["DATE"] | dpPlanDate.Text | 행/컬럼 값 대입 |  |  |  |
| AC-1670bb7f | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:453 | try ▸ else of (isYN) | MESSAGE | MessageBox.Show | ("Out of plan period '" + sStartDate + "' ~ '" + sEndDate + "'") | 메시지 표시 |  |  |  |
| AC-a4dd6b76 | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:454 | try ▸ else of (isYN) | VALUE_SET | dpPlanDate.Text | Filter["DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-c2436f9f | dpPlanDate.ValueChanged | FP01552_LineAddPopup.cs:462 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP01552_LineAddPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5aa63769 | this.Load | FP01552_LineAddPopup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f6e9ff6 | this.Load | FP01552_LineAddPopup.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-766eb941 | this.Load | FP01552_LineAddPopup.cs:121 |  | FLAG | dtSave | new DataTable("Table") | 화면 필드/플래그 변경 |  |  |  |
| AC-b08ca7dc | this.Load | FP01552_LineAddPopup.cs:123 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-eee1a508 | this.Load | FP01552_LineAddPopup.cs:124 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-4499c0a3 | this.Load | FP01552_LineAddPopup.cs:125 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("COMPANY_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e75b0dae | this.Load | FP01552_LineAddPopup.cs:126 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DIVISION_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-812a1661 | this.Load | FP01552_LineAddPopup.cs:127 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SITE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc4c4a3 | this.Load | FP01552_LineAddPopup.cs:128 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("PLANT_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-d16001e5 | this.Load | FP01552_LineAddPopup.cs:129 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("CELL_ITEM_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0361a762 | this.Load | FP01552_LineAddPopup.cs:130 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("STORAGE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-696f2828 | this.Load | FP01552_LineAddPopup.cs:131 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("SOC_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-5beb68bd | this.Load | FP01552_LineAddPopup.cs:132 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("MARKET", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b10bcbc4 | this.Load | FP01552_LineAddPopup.cs:133 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("DATE", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f11bed | this.Load | FP01552_LineAddPopup.cs:134 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("QTY", typeof(decimal))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3436c188 | this.Load | FP01552_LineAddPopup.cs:135 |  | DATA_OP | dtSave.Columns.Add | (new DataColumn("USER_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cb450b8 | this.Load | FP01552_LineAddPopup.cs:137 |  | DATA_OP | dtSave.Rows.Add | (dtSave.NewRow()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a513aa7f | this.Load | FP01552_LineAddPopup.cs:137 |  | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |

## FP01552_LineAddPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f31a8b4b | this.Load | FP01552_LineAddPopup.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fa25bbff | this.Load | FP01552_LineAddPopup.cs:151 | if (InitRow== null) | MESSAGE | MessageBox.Show | ("Please select any row before add line") | 메시지 표시 |  |  |  |
| AC-f926aea8 | this.Load | FP01552_LineAddPopup.cs:152 | if (InitRow== null) | UI_MISC | Close | () | 창 닫기/해제 |  |  |  |
| AC-b0bdbb9f | this.Load | FP01552_LineAddPopup.cs:153 | if (InitRow== null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5860a594 | this.Load | FP01552_LineAddPopup.cs:157 | if (string.IsNullOrWhiteSpace(Filter["PLAN_DATE"])) | DATA_OP | Filter["PLAN_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-0f5dc9b6 | this.Load | FP01552_LineAddPopup.cs:159 |  | DATA_OP | Filter["DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2f86822f | this.Load | FP01552_LineAddPopup.cs:160 |  | VALUE_SET | dpPlanDate.Value | DateTime.ParseExact(Filter["PLAN_DATE"], "yyyyMMdd", null) | 컨트롤 값 설정 |  |  |  |
| AC-1067a872 | this.Load | FP01552_LineAddPopup.cs:163 |  | DATA_OP | dtDateMap.Select("IS_PLAN = 'Y' ").CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c0e9799 | this.Load | FP01552_LineAddPopup.cs:163 |  | DATA_OP | dtDateMap.Select | ("IS_PLAN = 'Y' ") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0db59b6 | this.Load | FP01552_LineAddPopup.cs:165 |  | VALUE_SET | txtQty.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-7f890c02 | this.Load | FP01552_LineAddPopup.cs:169 |  | FLAG | dtTransport | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP01551_LINEADDPOPUP", "TRANSPORT_T… | 화면 필드/플래그 변경 |  |  |  |
| AC-92ec9888 | this.Load | FP01552_LineAddPopup.cs:169 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP01551_LINEADDPOPUP", "TRANSPORT_TYPE") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1dc5794c | this.Load | FP01552_LineAddPopup.cs:190 |  | LIST_REBIND | clsCtrl.setListBox | (dtTransport, cboTransport, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fa2385fe | this.Load | FP01552_LineAddPopup.cs:194 |  | VALUE_SET | txtItem.Text | Filter["CELL_ITEM_ID"] = InitRow["ITEM_ID"].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-49d2ac42 | this.Load | FP01552_LineAddPopup.cs:194 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7d64331e | this.Load | FP01552_LineAddPopup.cs:196 |  | DATA_OP | Filter["COMPANY_ID"] | InitRow["COMPANY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78077107 | this.Load | FP01552_LineAddPopup.cs:197 |  | DATA_OP | Filter["DIVISION_ID"] | InitRow["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-990289d3 | this.Load | FP01552_LineAddPopup.cs:198 |  | DATA_OP | Filter["SITE_ID"] | InitRow["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8e686cac | this.Load | FP01552_LineAddPopup.cs:199 |  | DATA_OP | Filter["PLANT_ID"] | InitRow["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-7ec2d9e4 | this.Load | FP01552_LineAddPopup.cs:200 |  | DATA_OP | Filter["CELL_ITEM_ID"] | InitRow["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4e4e7c92 | this.Load | FP01552_LineAddPopup.cs:202 |  | DATA_OP | Filter["TRANSPORT"] | CString.GetCheckedListValue(dtTransport, cboTransport.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-bb2d2759 | this.Load | FP01552_LineAddPopup.cs:203 |  | DATA_OP | Filter["MARKET"] | "D" | 행/컬럼 값 대입 |  |  |  |

## FP01552_LineAddPopup.Save_Data

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ba30302 | this.btnSave.Click | FP01552_LineAddPopup.cs:297 |  | DATA_OP | Filter["SOC_ID"] | Filter["TRANSPORT"] | 행/컬럼 값 대입 |  |  |  |
| AC-8995568c | this.btnSave.Click | FP01552_LineAddPopup.cs:298 |  | DATA_OP | Filter["DATE"] | dpPlanDate.Value.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-d3226180 | this.btnSave.Click | FP01552_LineAddPopup.cs:299 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1df26b1b | this.btnSave.Click | FP01552_LineAddPopup.cs:301 |  | ENDPOINT | Data_FP.CallGeneralProcedure2 | ("PR_UI_FP01552_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "DUP") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b9621ca8 | this.btnSave.Click | FP01552_LineAddPopup.cs:305 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | MESSAGE | MessageBox.Show | ("The Cell Code or detail information is already exists.") | 메시지 표시 |  |  |  |
| AC-45d9bc99 | this.btnSave.Click | FP01552_LineAddPopup.cs:306 | if (dup.Good() && dup.Rows[0]["CNT"].ToString() != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5dd80924 | this.btnSave.Click | FP01552_LineAddPopup.cs:319 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a15bd1e9 | this.btnSave.Click | FP01552_LineAddPopup.cs:320 |  | DATA_OP | dtSave.SetFirst | ("INSTANCE_ID", Filter["INSTANCE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-54e4815c | this.btnSave.Click | FP01552_LineAddPopup.cs:321 |  | DATA_OP | dtSave.SetFirst | ("PLAN_ID", Filter["PLAN_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-001f7f3a | this.btnSave.Click | FP01552_LineAddPopup.cs:322 |  | DATA_OP | dtSave.SetFirst | ("COMPANY_ID", Filter["COMPANY_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9ba441d1 | this.btnSave.Click | FP01552_LineAddPopup.cs:323 |  | DATA_OP | dtSave.SetFirst | ("DIVISION_ID", Filter["DIVISION_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-49fc1dc6 | this.btnSave.Click | FP01552_LineAddPopup.cs:324 |  | DATA_OP | dtSave.SetFirst | ("SITE_ID", Filter["SITE_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-037d2888 | this.btnSave.Click | FP01552_LineAddPopup.cs:325 |  | DATA_OP | dtSave.SetFirst | ("PLANT_ID", Filter["PLANT_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d06461c7 | this.btnSave.Click | FP01552_LineAddPopup.cs:326 |  | DATA_OP | dtSave.SetFirst | ("CELL_ITEM_ID", txtItem.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-4bd9fd32 | this.btnSave.Click | FP01552_LineAddPopup.cs:327 |  | DATA_OP | dtSave.SetFirst | ("STORAGE_ID", txtSloc.Text) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9ef54a48 | this.btnSave.Click | FP01552_LineAddPopup.cs:328 |  | DATA_OP | dtSave.SetFirst | ("SOC_ID", Filter["SOC_ID"]) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-007846bb | this.btnSave.Click | FP01552_LineAddPopup.cs:329 |  | DATA_OP | dtSave.SetFirst | ("MARKET", "D") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cae77fa5 | this.btnSave.Click | FP01552_LineAddPopup.cs:330 |  | DATA_OP | dtSave.SetFirst | ("DATE", dpPlanDate.Value.ToString("yyyyMMdd")) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-207371f3 | this.btnSave.Click | FP01552_LineAddPopup.cs:331 |  | DATA_OP | dtSave.SetFirst | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a958804f | this.btnSave.Click | FP01552_LineAddPopup.cs:340 | catch () | MESSAGE | MessageBox.Show | ("You need valid number of quantity") | 메시지 표시 |  |  |  |
| AC-79caedea | this.btnSave.Click | FP01552_LineAddPopup.cs:341 | catch () | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21f6b82c | this.btnSave.Click | FP01552_LineAddPopup.cs:343 |  | DATA_OP | dtSave.SetFirst | ("QTY", qty) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-48391715 | this.btnSave.Click | FP01552_LineAddPopup.cs:352 | try | ENDPOINT | DataService.FP_UpdateBatch2 | ("FP01552_In_House_Moving_Plan", "insert_Line", dtSave, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Line] \| FP\Planning\FP01… | 엔드포인트 호출 |  |  |  |
| AC-9b6d7b4c | this.btnSave.Click | FP01552_LineAddPopup.cs:361 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-881381d8 | this.btnSave.Click | FP01552_LineAddPopup.cs:365 | try ▸ else of (dtResult == null) ▸ if (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-79f7e6cc | this.btnSave.Click | FP01552_LineAddPopup.cs:372 | try ▸ else of (dtResult == null) ▸ else of (dtResult.Rows[0]["RESULT"].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37204b3e | this.btnSave.Click | FP01552_LineAddPopup.cs:377 | catch () | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP01552_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-495ccb15 | .ctor | FP01552_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-6ab203c2 | .ctor | FP01552_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-dbd8b32d | .ctor | FP01552_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-9f04e94e | .ctor | FP01552_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP01552_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d07565f | Dispose | FP01552_MeasureSetForm_Popup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83202b2d | this.Load | FP01552_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP01552_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-801d0865 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:193 |  | DATA_OP | ctrls.Add | (chk_form) | 데이터 객체 조작/조회 |  |  |  |
| AC-9377ee78 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:194 |  | DATA_OP | ctrls.Add | (chk_cma) | 데이터 객체 조작/조회 |  |  |  |
| AC-d45ca0dc | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:195 |  | DATA_OP | ctrls.Add | (chk_prev_req) | 데이터 객체 조작/조회 |  |  |  |
| AC-96738cac | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:197 |  | DATA_OP | ctrls.Add | (chk_req) | 데이터 객체 조작/조회 |  |  |  |
| AC-58e6acc7 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:198 |  | DATA_OP | ctrls.Add | (chk_delivery) | 데이터 객체 조작/조회 |  |  |  |
| AC-0bfc7b7d | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:200 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-feb5441c | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:201 |  | DATA_OP | ctrls.Add | (chk_shortage) | 데이터 객체 조작/조회 |  |  |  |
| AC-11233489 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:202 |  | DATA_OP | ctrls.Add | (chk_ship_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-876a67c6 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:204 |  | DATA_OP | ctrls.Add | (chk_eoh) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb0b8488 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:205 |  | DATA_OP | ctrls.Add | (chk_eohAvail) | 데이터 객체 조작/조회 |  |  |  |
| AC-aba3a5d0 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:207 |  | DATA_OP | ctrls.Add | (chk_meet) | 데이터 객체 조작/조회 |  |  |  |
| AC-600afb39 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:208 |  | DATA_OP | ctrls.Add | (chk_eohHold) | 데이터 객체 조작/조회 |  |  |  |
| AC-faca27f6 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:211 |  | DATA_OP | ctrls.Add | (chk_total_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3dc1421 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:215 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-62f18bb5 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:215 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-b221fa17 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:222 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-85634a7c | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:226 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-e09bf401 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:230 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP01552_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc5b04a3 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:125 |  | VALUE_SET | chk_form.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b5880b8c | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:126 |  | VALUE_SET | chk_cma.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cefe835e | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:127 |  | VALUE_SET | chk_prev_req.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-73bd4805 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:129 |  | VALUE_SET | chk_req.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-72e2f48d | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:130 |  | VALUE_SET | chk_delivery.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1b1d1047 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:132 |  | VALUE_SET | chk_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fb3bb3fd | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:133 |  | VALUE_SET | chk_shortage.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-c089299c | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:134 |  | VALUE_SET | chk_ship_result.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-baa2ecab | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:136 |  | VALUE_SET | chk_eoh.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f3d6fa61 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:137 |  | VALUE_SET | chk_eohAvail.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f79ee5f5 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:139 |  | VALUE_SET | chk_meet.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e6c09c8a | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:140 |  | VALUE_SET | chk_eohHold.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5e641489 | this.Load 외 1 | FP01552_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_total_2.Text | total_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP01552_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c4e55600 | (진입점 미연결) | FP01552_MeasureSetForm_Popup.cs:289 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-4e567f7b | (진입점 미연결) | FP01552_MeasureSetForm_Popup.cs:300 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (ison == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fc2dd12 | (진입점 미연결) | FP01552_MeasureSetForm_Popup.cs:311 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[other_name].On | true | 속성 On 설정 |  |  |  |

## FP01552_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2407f004 | this.Load | FP01552_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f1afc053 | this.Load | FP01552_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b2ac160 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:274 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-c94a69eb | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:274 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-5fec1393 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:276 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-5785fb68 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:280 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-064f0dc2 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:281 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-b44e44d4 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:283 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62ea6ec2 | this.usrButton1.Click | FP01552_MeasureSetForm_Popup.cs:285 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP01552_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eb86133 | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:248 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-23b72913 | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:248 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-6a539ff9 | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:250 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-6a7fafdb | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:254 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-79a6abad | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:255 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-3f39f850 | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:256 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-6126ae4e | this.usrButton2.Click | FP01552_MeasureSetForm_Popup.cs:257 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_StoragePopup.btnButtonList_UsrButtonList_Click_Detected

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7caa7fd0 | (진입점 미연결) | FP01552_StoragePopup.cs:255 | switch (buttonItem.UserType) case ButtonListType.OK: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f1aa8f28 | (진입점 미연결) | FP01552_StoragePopup.cs:258 | switch (buttonItem.UserType) case ButtonListType.Close: | FLAG | selected | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d3cd97c7 | (진입점 미연결) | FP01552_StoragePopup.cs:259 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP01552_StoragePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92580a39 | this.Load | FP01552_StoragePopup.cs:134 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-151dde9d | this.Load | FP01552_StoragePopup.cs:135 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6820347c | this.Load | FP01552_StoragePopup.cs:136 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP01552_StoragePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24d22e3a | this.Load | FP01552_StoragePopup.cs:129 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP01552_StoragePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c59c6b48 | Dispose | FP01552_StoragePopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP01552_StoragePopup.FindData

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-332eb647 | this.Load 외 2 | FP01552_StoragePopup.cs:205 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-d3b4f7b8 | this.Load 외 2 | FP01552_StoragePopup.cs:209 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-688e6054 | this.Load 외 2 | FP01552_StoragePopup.cs:211 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { return Data_FP.CallGeneralProcedure("PR_UI_FP01552_ETC", Filter, UserInfoContext.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0599f52f | this.Load 외 2 | FP01552_StoragePopup.cs:213 | lambda | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP01552_ETC", Filter, UserInfoContext.Current.UserId, "SELECT", "STORAGE") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ce633bdd | this.Load 외 2 | FP01552_StoragePopup.cs:213 | lambda | RETURN | return Data_FP.CallGeneralProcedure("PR_UI_FP01552_ETC", Filter, UserInfoContext… |  | 처리 중단/반환 |  |  |  |
| AC-6355b237 | this.Load 외 2 | FP01552_StoragePopup.cs:218 |  | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-51793f9a | this.Load 외 2 | FP01552_StoragePopup.cs:221 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b4af79ef | this.Load 외 2 | FP01552_StoragePopup.cs:223 |  | FLAG | dtFindData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |

## FP01552_StoragePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3eddf89 | this.Load | FP01552_StoragePopup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2433f71b | this.Load | FP01552_StoragePopup.cs:101 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP01552_StoragePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b703a862 | this.Load | FP01552_StoragePopup.cs:146 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84808a7d | this.Load | FP01552_StoragePopup.cs:147 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_StoragePopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d0c520d | (진입점 미연결) | FP01552_StoragePopup.cs:166 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP01552_StoragePopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d75197a9 | this.Load | FP01552_StoragePopup.cs:153 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-007062b5 | this.Load | FP01552_StoragePopup.cs:154 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-46a50aae | this.Load | FP01552_StoragePopup.cs:158 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP01552_StoragePopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b28a9e20 | this.spdMain.CellClick | FP01552_StoragePopup.cs:270 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-9b6d5850 | this.spdMain.CellClick | FP01552_StoragePopup.cs:271 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f83c2279 | this.spdMain.CellClick | FP01552_StoragePopup.cs:274 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |

## FP01552_StoragePopup.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81f72806 | this.spdMain.CellDoubleClick | FP01552_StoragePopup.cs:280 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-dd110263 | this.spdMain.CellDoubleClick | FP01552_StoragePopup.cs:281 |  | DATA_OP | siMain.GetBindingRow | (iClick_Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6b93a147 | this.spdMain.CellDoubleClick | FP01552_StoragePopup.cs:284 | if (row != null) | FLAG | selected | row | 화면 필드/플래그 변경 |  |  |  |
| AC-827a4aa9 | this.spdMain.CellDoubleClick | FP01552_StoragePopup.cs:287 | if (this.siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-321c67ab | this.spdMain.CellDoubleClick | FP01552_StoragePopup.cs:297 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

