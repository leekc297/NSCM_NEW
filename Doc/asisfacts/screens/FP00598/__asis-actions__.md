# AS-IS 액션 대조표 — FP00598

> 원천: `Doc/asisfacts/screens/FP00598/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 2470행 · 메서드 214 · 종류 DATA_OP 1002 · UI_PROP 207 · RETURN 201 · FLAG 181 · CALL_EXT 150 · UI_MISC 98 · VALUE_SET 92 · MESSAGE 90 · STATE 87 · GRID_SET 80 · ENDPOINT 64 · POPUP 58 · GRID_INIT 29 · CALL_BASE 21 · COMBO_DATA 20 · THROW 18 · VALUE_CLEAR 17 · GRID_STYLE 16 · FOCUS 12 · LIST_REBIND 11 · GRID_LOCK 9 · EXCEL 3 · GRID_BIND 2 · LIST_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 171


## FP00598_BucketSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1724ac48 | .ctor | FP00598_BucketSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-10c5387b | .ctor | FP00598_BucketSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-f9cc631f | .ctor | FP00598_BucketSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-3a422c63 | .ctor | FP00598_BucketSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00598_BucketSetForm_Popup.chk_week_CheckedChanged

진입점: this.chk_week.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff7e22d4 | this.chk_week.CheckedChanged | FP00598_BucketSetForm_Popup.cs:236 | if (chk_week.Checked) | STATE | chk_week_sun.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1067858d | this.chk_week.CheckedChanged | FP00598_BucketSetForm_Popup.cs:238 | else of (chk_week.Checked) | STATE | chk_week_sun.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## FP00598_BucketSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-719c736a | Dispose | FP00598_BucketSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00598_BucketSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac39f096 | this.Load | FP00598_BucketSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00598_BucketSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd8c05a5 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:144 |  | DATA_OP | ctrls.Add | (chk_day) | 데이터 객체 조작/조회 |  |  |  |
| AC-00c878f3 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:145 |  | DATA_OP | ctrls.Add | (chk_week) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c1d9da9 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:147 |  | DATA_OP | ctrls.Add | (chk_month) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6f0fd7c | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:148 |  | DATA_OP | ctrls.Add | (chk_week_sun) | 데이터 객체 조작/조회 |  |  |  |
| AC-11f88805 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:150 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-132b1c2f | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:150 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-eafa2b55 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:157 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-c5131ef2 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:161 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-b69bebef | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:165 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00598_BucketSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93d8edea | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:116 |  | VALUE_SET | chk_day.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1bf59f8e | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:117 |  | VALUE_SET | chk_week.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ed223298 | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:118 |  | VALUE_SET | chk_month.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |
| AC-82e9148a | this.Load 외 1 | FP00598_BucketSetForm_Popup.cs:119 |  | VALUE_SET | chk_week_sun.Text | data_set[index++] | 컨트롤 값 설정 |  |  |  |

## FP00598_BucketSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c9bc420 | (진입점 미연결) | FP00598_BucketSetForm_Popup.cs:228 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-a79a25a3 | (진입점 미연결) | FP00598_BucketSetForm_Popup.cs:230 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_BucketSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6738ea3a | this.Load | FP00598_BucketSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8481a3ca | this.Load | FP00598_BucketSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00598_BucketSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96b9eb4c | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-45fefedf | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:209 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-640b8028 | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:211 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-9e1f007a | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:215 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-8b202beb | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:216 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6e4f032c | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:218 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b20c77c7 | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:220 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |
| AC-50d7979a | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:222 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-72e0ed08 | this.usrButton1.Click | FP00598_BucketSetForm_Popup.cs:223 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_BucketSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecfa1fb8 | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-fb41c98f | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:183 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-788c485f | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:185 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-abdd2271 | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:189 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-4a674df7 | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:190 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-fbe29728 | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:191 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-88dd4dee | this.usrButton2.Click | FP00598_BucketSetForm_Popup.cs:192 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_ExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92c9c07a | .ctor | FP00598_ExcelPopup.cs:152 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-4bf265ac | .ctor | FP00598_ExcelPopup.cs:153 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |
| AC-24f1b6ba | .ctor | FP00598_ExcelPopup.cs:154 |  | FLAG | HeaderLineCount | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-62367d52 | .ctor | FP00598_ExcelPopup.cs:155 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d6fa555f | .ctor | FP00598_ExcelPopup.cs:156 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00598_ExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfc6ecb8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:230 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f1ab71d5 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:231 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-03595db2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:232 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-75d7cab8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:233 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-85c9ca73 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:235 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-4c10c08e | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:235 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b3b80a2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:236 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-dad031c2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:236 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1c6b235c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:237 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-bf9666fe | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:237 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-99c2db55 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:238 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-d49d9f05 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:238 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e4a868f0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:247 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-cd38e1ef | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:248 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-d25ba2a5 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:249 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-6af62df7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_ExcelPopup.cs:250 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00598_ExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa340037 | this.btnClose.Click | FP00598_ExcelPopup.cs:1010 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_ExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b658fe4a | this.btnDownload.Click | FP00598_ExcelPopup.cs:992 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-e7cd41a7 | this.btnDownload.Click | FP00598_ExcelPopup.cs:993 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00598_ExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-273c3abe | this.btnFind.Click | FP00598_ExcelPopup.cs:983 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49d6ae49 | this.btnFind.Click | FP00598_ExcelPopup.cs:984 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_ExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed1d56c5 | this.Load | FP00598_ExcelPopup.cs:278 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-277d6374 | this.Load | FP00598_ExcelPopup.cs:279 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-be4d5767 | this.Load | FP00598_ExcelPopup.cs:280 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00598_ExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371cbb57 | dateRange.ValueChanged | FP00598_ExcelPopup.cs:1015 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b76f8404 | dateRange.ValueChanged | FP00598_ExcelPopup.cs:1016 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00598_ExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92552113 | (진입점 미연결) | FP00598_ExcelPopup.cs:946 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-57a90df3 | (진입점 미연결) | FP00598_ExcelPopup.cs:946 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00598_ExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20b514af | this.Load | FP00598_ExcelPopup.cs:273 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00598_ExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcd88cfd | Dispose | FP00598_ExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00598_ExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6b9006d | (진입점 미연결) | FP00598_ExcelPopup.cs:832 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_ExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e11bda5 | FindButton | FP00598_ExcelPopup.cs:321 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0aa9d955 | FindButton | FP00598_ExcelPopup.cs:322 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-208bdda3 | FindButton | FP00598_ExcelPopup.cs:324 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_ExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04c21900 | this.Load 외 2 | FP00598_ExcelPopup.cs:351 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36a1d215 | this.Load 외 2 | FP00598_ExcelPopup.cs:352 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-ec51b366 | this.Load 외 2 | FP00598_ExcelPopup.cs:352 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-975b6ee0 | this.Load 외 2 | FP00598_ExcelPopup.cs:356 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bd1d4acb | this.Load 외 2 | FP00598_ExcelPopup.cs:357 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f8850517 | this.Load 외 2 | FP00598_ExcelPopup.cs:359 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-708d6f0d | this.Load 외 2 | FP00598_ExcelPopup.cs:360 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-51efcba5 | this.Load 외 2 | FP00598_ExcelPopup.cs:361 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8f2b6d45 | this.Load 외 2 | FP00598_ExcelPopup.cs:362 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-347e6bc9 | this.Load 외 2 | FP00598_ExcelPopup.cs:363 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f5913e6c | this.Load 외 2 | FP00598_ExcelPopup.cs:364 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-13983b98 | this.Load 외 2 | FP00598_ExcelPopup.cs:371 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-53e24e05 | this.Load 외 2 | FP00598_ExcelPopup.cs:376 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-aba5f915 | this.Load 외 2 | FP00598_ExcelPopup.cs:378 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-534f6217 | this.Load 외 2 | FP00598_ExcelPopup.cs:379 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-8f5b9300 | this.Load 외 2 | FP00598_ExcelPopup.cs:380 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-f0982804 | this.Load 외 2 | FP00598_ExcelPopup.cs:382 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6c2489c | this.Load 외 2 | FP00598_ExcelPopup.cs:385 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f44a4c8f | this.Load 외 2 | FP00598_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-a1c1627a | this.Load 외 2 | FP00598_ExcelPopup.cs:387 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5edf9c9c | this.Load 외 2 | FP00598_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-86c54b46 | this.Load 외 2 | FP00598_ExcelPopup.cs:388 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-585e0f41 | this.Load 외 2 | FP00598_ExcelPopup.cs:390 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateC… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ff6ee67 | this.Load 외 2 | FP00598_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetAmendExcelHeaderColumn_FP(Calendar, DateColumnType, set, ColumnWidth.Data, Colum… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3e95073 | this.Load 외 2 | FP00598_ExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda | CALL_EXT | siMain.SetAmendExcelHeaderColumn_FP | (Calendar, DateColumnType, set, ColumnWidth.Data, ColumnTitle.Data, KeyColumns.Data, Heade… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f918c1aa | this.Load 외 2 | FP00598_ExcelPopup.cs:400 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-6739564b | this.Load 외 2 | FP00598_ExcelPopup.cs:401 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-0605796a | this.Load 외 2 | FP00598_ExcelPopup.cs:402 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-de945560 | this.Load 외 2 | FP00598_ExcelPopup.cs:408 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-799b96d5 | this.Load 외 2 | FP00598_ExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-731363de | this.Load 외 2 | FP00598_ExcelPopup.cs:413 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7126f31c | this.Load 외 2 | FP00598_ExcelPopup.cs:422 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3d0ee77 | this.Load 외 2 | FP00598_ExcelPopup.cs:425 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70398bcd | this.Load 외 2 | FP00598_ExcelPopup.cs:428 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a16da7db | this.Load 외 2 | FP00598_ExcelPopup.cs:432 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3dfb88c6 | this.Load 외 2 | FP00598_ExcelPopup.cs:434 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-99a56ae3 | this.Load 외 2 | FP00598_ExcelPopup.cs:439 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e5649d5 | this.Load 외 2 | FP00598_ExcelPopup.cs:441 | if (DoSearchData != null) ▸ try ▸ lambda ▸ foreach (KeyValuePair<string,AmendDate> each_date in Calendar.Days) ▸ if (colindex > -1) ▸ if (ro… | GRID_STYLE | siMain.SetBGColor | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-5cacfe61 | this.Load 외 2 | FP00598_ExcelPopup.cs:447 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ce6e02a4 | this.Load 외 2 | FP00598_ExcelPopup.cs:456 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-733c582a | this.Load 외 2 | FP00598_ExcelPopup.cs:459 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-d23c7bce | this.Load 외 2 | FP00598_ExcelPopup.cs:460 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e508d5a6 | this.Load 외 2 | FP00598_ExcelPopup.cs:461 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c13361b3 | this.Load 외 2 | FP00598_ExcelPopup.cs:462 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2ceff8fc | this.Load 외 2 | FP00598_ExcelPopup.cs:463 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-450899e6 | this.Load 외 2 | FP00598_ExcelPopup.cs:464 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00598_ExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a0dc22b | this.Load | FP00598_ExcelPopup.cs:164 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-37b8c880 | this.Load | FP00598_ExcelPopup.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_ExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfbd232a | this.Load | FP00598_ExcelPopup.cs:206 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-fc91b246 | this.Load | FP00598_ExcelPopup.cs:207 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-cb4b46a9 | this.Load | FP00598_ExcelPopup.cs:211 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-c3968830 | this.Load | FP00598_ExcelPopup.cs:212 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-a9137c9e | this.Load | FP00598_ExcelPopup.cs:215 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5046c7f4 | this.Load | FP00598_ExcelPopup.cs:216 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-a5bb6f1f | this.Load | FP00598_ExcelPopup.cs:220 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00598_ExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e33bed7 | this.Load | FP00598_ExcelPopup.cs:290 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3356ce90 | this.Load | FP00598_ExcelPopup.cs:291 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00598_ExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91a060c1 | (진입점 미연결) | FP00598_ExcelPopup.cs:311 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00598_ExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f414244 | this.btnUpload.Click | FP00598_ExcelPopup.cs:844 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2e1e0ad | this.btnUpload.Click | FP00598_ExcelPopup.cs:844 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-478681c9 | this.btnUpload.Click | FP00598_ExcelPopup.cs:845 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-26e100de | this.btnUpload.Click | FP00598_ExcelPopup.cs:846 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-c9275172 | this.btnUpload.Click | FP00598_ExcelPopup.cs:847 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b44e5cb | this.btnUpload.Click | FP00598_ExcelPopup.cs:849 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-47e5279c | this.btnUpload.Click | FP00598_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-fad6bf70 | this.btnUpload.Click | FP00598_ExcelPopup.cs:854 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d71ff2d4 | this.btnUpload.Click | FP00598_ExcelPopup.cs:861 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-fd014a64 | this.btnUpload.Click | FP00598_ExcelPopup.cs:862 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-cd9cf8b8 | this.btnUpload.Click | FP00598_ExcelPopup.cs:865 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2e00b560 | this.btnUpload.Click | FP00598_ExcelPopup.cs:866 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-cbab25fb | this.btnUpload.Click | FP00598_ExcelPopup.cs:870 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a114720 | this.btnUpload.Click | FP00598_ExcelPopup.cs:871 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44352266 | this.btnUpload.Click | FP00598_ExcelPopup.cs:883 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-06bbe7be | this.btnUpload.Click | FP00598_ExcelPopup.cs:887 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2b5ce38c | this.btnUpload.Click | FP00598_ExcelPopup.cs:899 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49f75798 | this.btnUpload.Click | FP00598_ExcelPopup.cs:902 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2b97480 | this.btnUpload.Click | FP00598_ExcelPopup.cs:905 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8976a2c3 | this.btnUpload.Click | FP00598_ExcelPopup.cs:909 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-78b7b600 | this.btnUpload.Click | FP00598_ExcelPopup.cs:911 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-9aa7af27 | this.btnUpload.Click | FP00598_ExcelPopup.cs:916 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71197f14 | this.btnUpload.Click | FP00598_ExcelPopup.cs:918 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-2869f53e | this.btnUpload.Click | FP00598_ExcelPopup.cs:924 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-635ad4dd | this.btnUpload.Click | FP00598_ExcelPopup.cs:929 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-2f98086d | this.btnUpload.Click | FP00598_ExcelPopup.cs:933 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-74c4fbb3 | this.btnUpload.Click | FP00598_ExcelPopup.cs:934 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a1ba6fa3 | this.btnUpload.Click | FP00598_ExcelPopup.cs:937 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00598_ExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-036e25e5 | this.radioMPP.CheckedChanged | FP00598_ExcelPopup.cs:1022 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-3323e999 | this.radioMPP.CheckedChanged | FP00598_ExcelPopup.cs:1024 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00598_ExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4afecce4 | this.radioWPP.CheckedChanged | FP00598_ExcelPopup.cs:1031 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e4726d32 | this.radioWPP.CheckedChanged | FP00598_ExcelPopup.cs:1033 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |

## FP00598_ExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f6248cf | this.btnSave.Click | FP00598_ExcelPopup.cs:567 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ if (radioMPP.Checked == true) | DATA_OP | this.Filter["MPP_WPP"] | "MPP" | 행/컬럼 값 대입 |  |  |  |
| AC-592dfe7c | this.btnSave.Click | FP00598_ExcelPopup.cs:569 | if (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") ▸ else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-73271cf5 | this.btnSave.Click | FP00598_ExcelPopup.cs:573 | else of (this.Filter["PLAN_TYPE"].ToString() == "RELEASE") | DATA_OP | this.Filter["MPP_WPP"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d708cc96 | this.btnSave.Click | FP00598_ExcelPopup.cs:578 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-ed5b6a05 | this.btnSave.Click | FP00598_ExcelPopup.cs:579 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95b628dc | this.btnSave.Click | FP00598_ExcelPopup.cs:583 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-c72b9778 | this.btnSave.Click | FP00598_ExcelPopup.cs:584 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ca6a6a09 | this.btnSave.Click | FP00598_ExcelPopup.cs:588 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-b5e8848e | this.btnSave.Click | FP00598_ExcelPopup.cs:588 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-90de06ef | this.btnSave.Click | FP00598_ExcelPopup.cs:593 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4e26bd8f | this.btnSave.Click | FP00598_ExcelPopup.cs:594 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-eb55859c | this.btnSave.Click | FP00598_ExcelPopup.cs:595 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-dcf3a26a | this.btnSave.Click | FP00598_ExcelPopup.cs:596 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9d874499 | this.btnSave.Click | FP00598_ExcelPopup.cs:597 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8065da56 | this.btnSave.Click | FP00598_ExcelPopup.cs:598 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-50a31e55 | this.btnSave.Click | FP00598_ExcelPopup.cs:606 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc803877 | this.btnSave.Click | FP00598_ExcelPopup.cs:609 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0e0ed70 | this.btnSave.Click | FP00598_ExcelPopup.cs:611 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-47e351d6 | this.btnSave.Click | FP00598_ExcelPopup.cs:614 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-9908046d | this.btnSave.Click | FP00598_ExcelPopup.cs:619 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-9ae85b86 | this.btnSave.Click | FP00598_ExcelPopup.cs:620 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-a9e2ad07 | this.btnSave.Click | FP00598_ExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-97c025ff | this.btnSave.Click | FP00598_ExcelPopup.cs:628 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-04316111 | this.btnSave.Click | FP00598_ExcelPopup.cs:629 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4bd41faf | this.btnSave.Click | FP00598_ExcelPopup.cs:630 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-e568d833 | this.btnSave.Click | FP00598_ExcelPopup.cs:631 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-30fb6182 | this.btnSave.Click | FP00598_ExcelPopup.cs:632 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68a95f3b | this.btnSave.Click | FP00598_ExcelPopup.cs:633 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8c41fc4e | this.btnSave.Click | FP00598_ExcelPopup.cs:634 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f04174b | this.btnSave.Click | FP00598_ExcelPopup.cs:637 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f4ebca88 | this.btnSave.Click | FP00598_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1dba43c8 | this.btnSave.Click | FP00598_ExcelPopup.cs:641 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a79f1e98 | this.btnSave.Click | FP00598_ExcelPopup.cs:675 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-681c7bca | this.btnSave.Click | FP00598_ExcelPopup.cs:677 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-b89a9119 | this.btnSave.Click | FP00598_ExcelPopup.cs:680 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | dr["NEW_SEQ"] | Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-1ee9e3cd | this.btnSave.Click | FP00598_ExcelPopup.cs:685 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9b3b7faf | this.btnSave.Click | FP00598_ExcelPopup.cs:687 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-72531ffc | this.btnSave.Click | FP00598_ExcelPopup.cs:690 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3372ab4a | this.btnSave.Click | FP00598_ExcelPopup.cs:694 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9e3c08 | this.btnSave.Click | FP00598_ExcelPopup.cs:696 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-677d0123 | this.btnSave.Click | FP00598_ExcelPopup.cs:699 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ce6584fa | this.btnSave.Click | FP00598_ExcelPopup.cs:703 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a2b8f69 | this.btnSave.Click | FP00598_ExcelPopup.cs:716 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-3c3e4997 | this.btnSave.Click | FP00598_ExcelPopup.cs:718 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3bd8722 | this.btnSave.Click | FP00598_ExcelPopup.cs:720 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-c75379d6 | this.btnSave.Click | FP00598_ExcelPopup.cs:724 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-2a484ebe | this.btnSave.Click | FP00598_ExcelPopup.cs:740 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4bdc2459 | this.btnSave.Click | FP00598_ExcelPopup.cs:745 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-37b97a24 | this.btnSave.Click | FP00598_ExcelPopup.cs:746 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-3fdefd47 | this.btnSave.Click | FP00598_ExcelPopup.cs:752 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-17977b5d | this.btnSave.Click | FP00598_ExcelPopup.cs:759 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-bd2e8a02 | this.btnSave.Click | FP00598_ExcelPopup.cs:790 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-1e56ca89 | this.btnSave.Click | FP00598_ExcelPopup.cs:792 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | CALL_EXT | siMain.SetRowColor | (index, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12dce905 | this.btnSave.Click | FP00598_ExcelPopup.cs:793 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ foreach (DataRow valrow in valSrc.Rows) ▸ if (valrow["_V… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-39fff3e1 | this.btnSave.Click | FP00598_ExcelPopup.cs:804 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:" + e.Message)) | 메시지 표시 |  |  |  |
| AC-8065bbe5 | this.btnSave.Click | FP00598_ExcelPopup.cs:805 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-708d580c | this.btnSave.Click | FP00598_ExcelPopup.cs:810 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b051efeb | this.btnSave.Click | FP00598_ExcelPopup.cs:811 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bf5accbe | this.btnSave.Click | FP00598_ExcelPopup.cs:812 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ef7e8410 | this.btnSave.Click | FP00598_ExcelPopup.cs:813 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-1019d19b | this.btnSave.Click | FP00598_ExcelPopup.cs:814 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-00db1269 | this.btnSave.Click | FP00598_ExcelPopup.cs:815 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00598_ExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-097e9d6c | this.Load | FP00598_ExcelPopup.cs:303 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42f368ca | this.Load | FP00598_ExcelPopup.cs:304 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00598_ExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == "RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03dbdc12 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:258 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-f7cdfaa6 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:259 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-7b3eebd4 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:260 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-b2b3cc2c | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:264 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-3d5dca2e | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:265 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bb83f3e7 | this.Load [if (ShowMppWpp == true && Filter["PLAN_TYPE"] == … | FP00598_ExcelPopup.cs:266 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00598_MeasureSetForm_Popup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-736d7660 | .ctor | FP00598_MeasureSetForm_Popup.cs:71 |  | FLAG | _sProgramID | sProgramID | 화면 필드/플래그 변경 |  |  |  |
| AC-7bbd63df | .ctor | FP00598_MeasureSetForm_Popup.cs:72 |  | FLAG | _sSheetName | sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-4c78c8e0 | .ctor | FP00598_MeasureSetForm_Popup.cs:73 |  | FLAG | _sMenuID | _sProgramID + "_" + _sSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-cbcd1f65 | .ctor | FP00598_MeasureSetForm_Popup.cs:75 |  | FLAG | _sDivisionId | sDivisionId | 화면 필드/플래그 변경 |  |  |  |

## FP00598_MeasureSetForm_Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-108498ad | Dispose | FP00598_MeasureSetForm_Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00598_MeasureSetForm_Popup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51f1ee74 | this.Load | FP00598_MeasureSetForm_Popup.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00598_MeasureSetForm_Popup.InitControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4065715e | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:224 |  | FLAG | data_s_val | new bool[data_p_i.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-5911bf32 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:225 |  | FLAG | data_p_i_val | new bool[data_p_i.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-65150d34 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:226 |  | FLAG | total_s_val | new bool[total_s.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f0f4ed0 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:227 |  | FLAG | total_p_i_val | new bool[total_p_i.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-929f18ca | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:228 |  | FLAG | uom_p_val | new bool[uom_p.Count] | 화면 필드/플래그 변경 |  |  |  |
| AC-9904804b | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:256 |  | DATA_OP | ctrls.Add | (chk_S_M) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0036d81 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:257 |  | DATA_OP | ctrls.Add | (chk_S_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcf6e4e9 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:258 |  | DATA_OP | ctrls.Add | (chk_S_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-23027714 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:260 |  | DATA_OP | ctrls.Add | (chk_S_scp) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca813c68 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:261 |  | DATA_OP | ctrls.Add | (chk_past_sales) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d6f459d | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:262 |  | DATA_OP | ctrls.Add | (chk_assy_plan) | 데이터 객체 조작/조회 |  |  |  |
| AC-e66e3997 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:265 |  | DATA_OP | ctrls.Add | (chk_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-cd6f35fd | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:266 |  | DATA_OP | ctrls.Add | (chk_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f5cc87a | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:267 |  | DATA_OP | ctrls.Add | (chk_result) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1fd0696 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:268 |  | DATA_OP | ctrls.Add | (chk_capa) | 데이터 객체 조작/조회 |  |  |  |
| AC-3819a809 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:269 |  | DATA_OP | ctrls.Add | (chk_i) | 데이터 객체 조작/조회 |  |  |  |
| AC-5705cacb | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:271 |  | DATA_OP | ctrls.Add | (chk_inqty_MPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-923a44b1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:272 |  | DATA_OP | ctrls.Add | (chk_outqty_MPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-faa8dc21 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:273 |  | DATA_OP | ctrls.Add | (chk_inqty_WPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-63971f31 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:274 |  | DATA_OP | ctrls.Add | (chk_outqty_WPP) | 데이터 객체 조작/조회 |  |  |  |
| AC-22c5cbe5 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:276 |  | DATA_OP | ctrls.Add | (chk_engine_inqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ba98962 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:277 |  | DATA_OP | ctrls.Add | (chk_engine_outqty) | 데이터 객체 조작/조회 |  |  |  |
| AC-e55961fe | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:278 |  | DATA_OP | ctrls.Add | (chk_memo) | 데이터 객체 조작/조회 |  |  |  |
| AC-aa260713 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:281 |  | DATA_OP | ctrls.Add | (chk_S_M_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-157bad85 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:282 |  | DATA_OP | ctrls.Add | (chk_S_cell_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdb69868 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:283 |  | DATA_OP | ctrls.Add | (chk_S_batch_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-fd10a1af | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:285 |  | DATA_OP | ctrls.Add | (chk_S_scp_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-c3b8ccde | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:286 |  | DATA_OP | ctrls.Add | (chk_past_sales_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-9083c3dc | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:287 |  | DATA_OP | ctrls.Add | (chk_assy_plan_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1f39dd1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:290 |  | DATA_OP | ctrls.Add | (chk_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ef95f27 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:291 |  | DATA_OP | ctrls.Add | (chk_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-059a33b6 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:292 |  | DATA_OP | ctrls.Add | (chk_result_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a780d7d8 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:293 |  | DATA_OP | ctrls.Add | (chk_i_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-7cf0712c | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:295 |  | DATA_OP | ctrls.Add | (chk_inqty_MPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-61d3e7a5 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:296 |  | DATA_OP | ctrls.Add | (chk_outqty_MPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-a37544fd | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:297 |  | DATA_OP | ctrls.Add | (chk_inqty_WPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8838f06 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:298 |  | DATA_OP | ctrls.Add | (chk_outqty_WPP_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-f1ed8cbe | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:300 |  | DATA_OP | ctrls.Add | (chk_engine_inqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-21a5c02a | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:301 |  | DATA_OP | ctrls.Add | (chk_engine_outqty_tot) | 데이터 객체 조작/조회 |  |  |  |
| AC-b71c49b7 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:302 |  | DATA_OP | ctrls.Add | (chk_subTotal) | 데이터 객체 조작/조회 |  |  |  |
| AC-9807c42f | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:303 |  | DATA_OP | ctrls.Add | (chk_total) | 데이터 객체 조작/조회 |  |  |  |
| AC-64c14ac1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:306 |  | DATA_OP | ctrls.Add | (chk_pc) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d47d015 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:307 |  | DATA_OP | ctrls.Add | (chk_jr) | 데이터 객체 조작/조회 |  |  |  |
| AC-b084c92a | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:308 |  | DATA_OP | ctrls.Add | (chk_cell) | 데이터 객체 조작/조회 |  |  |  |
| AC-e097adb6 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:309 |  | DATA_OP | ctrls.Add | (chk_batch) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d7c72d1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:311 |  | DATA_OP | ctrls.Add | (chk_pc_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-07151194 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:312 |  | DATA_OP | ctrls.Add | (chk_jr_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-1071234e | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:313 |  | DATA_OP | ctrls.Add | (chk_cell_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-9775c9a6 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:314 |  | DATA_OP | ctrls.Add | (chk_batch_out) | 데이터 객체 조작/조회 |  |  |  |
| AC-cb769730 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:318 | if (measure == null) | FLAG | measure | MeasureService.GetMeasure(_sMenuID) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbab4f46 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:318 | if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (_sMenuID) | Measure 목록 조회 |  |  |  |
| AC-58a8acf7 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:325 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) | VALUE_SET | eachCheck.Checked | measure[other_name].On | 컨트롤 값 설정 |  |  |  |
| AC-bb5f5e80 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:329 | foreach (Control each in ctrls) ▸ if (eachCheck !=null) ▸ if (!string.IsNullOrWhiteSpace(eachCheckText)) | VALUE_SET | eachCheck.Text | eachCheckText | 컨트롤 값 설정 |  |  |  |
| AC-32721cc7 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:333 |  | VALUE_SET | this.Text | "Measure Setting" | 컨트롤 값 설정 |  |  |  |

## FP00598_MeasureSetForm_Popup.InitNames

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf5d959e | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:143 |  | VALUE_SET | chk_S_M.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d2d792a9 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:144 |  | VALUE_SET | chk_S_cell.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a7ce0f49 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:145 |  | VALUE_SET | chk_S_batch.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-245d05e1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:146 |  | VALUE_SET | chk_S_scp.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-42a8d35e | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:147 |  | VALUE_SET | chk_past_sales.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-972296ff | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:148 |  | VALUE_SET | chk_assy_plan.Text | data_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a9b3d7fa | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:152 |  | VALUE_SET | chk_inqty.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-ee8dc4b7 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:153 |  | VALUE_SET | chk_outqty.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d0d0e1bd | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:154 |  | VALUE_SET | chk_result.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-5f746431 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:155 |  | VALUE_SET | chk_capa.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e6ef77c4 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:156 |  | VALUE_SET | chk_i.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7237f1d0 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:158 |  | VALUE_SET | chk_inqty_MPP.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-9a3f158a | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:159 |  | VALUE_SET | chk_outqty_MPP.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-7814a57d | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:160 |  | VALUE_SET | chk_inqty_WPP.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bc02b544 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:161 |  | VALUE_SET | chk_outqty_WPP.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-bffd6080 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:163 |  | VALUE_SET | chk_engine_inqty.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-99ffbd77 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:164 |  | VALUE_SET | chk_engine_outqty.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-797a86cf | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:165 |  | VALUE_SET | chk_memo.Text | data_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-2a7bf773 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:169 |  | VALUE_SET | chk_S_M_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f010de25 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:170 |  | VALUE_SET | chk_S_cell_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f32a7ed5 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:171 |  | VALUE_SET | chk_S_batch_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-a29d430c | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:173 |  | VALUE_SET | chk_S_scp_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-74e61ecd | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:174 |  | VALUE_SET | chk_past_sales_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d41fe74c | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:175 |  | VALUE_SET | chk_assy_plan_tot.Text | total_s[index++] | 컨트롤 값 설정 |  |  |  |
| AC-1fb6d362 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:180 |  | VALUE_SET | chk_inqty_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3dc1adaa | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:181 |  | VALUE_SET | chk_outqty_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-08ef50b1 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:182 |  | VALUE_SET | chk_result_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-acd48599 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:183 |  | VALUE_SET | chk_i_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-3691f8d0 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:185 |  | VALUE_SET | chk_inqty_MPP_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-6fb10351 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:186 |  | VALUE_SET | chk_outqty_MPP_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-be7c11fc | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:187 |  | VALUE_SET | chk_inqty_WPP_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-fc21713f | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:188 |  | VALUE_SET | chk_outqty_WPP_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-94c76983 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:190 |  | VALUE_SET | chk_engine_inqty_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-b82b1648 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:191 |  | VALUE_SET | chk_engine_outqty_tot.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-e712e3b9 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:192 |  | VALUE_SET | chk_subTotal.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d66b4e62 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:193 |  | VALUE_SET | chk_total.Text | total_p_i[index++] | 컨트롤 값 설정 |  |  |  |
| AC-f1d27086 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:197 |  | VALUE_SET | chk_pc.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-844f7b6f | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:198 |  | VALUE_SET | chk_jr.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-cc8f0d1b | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:199 |  | VALUE_SET | chk_cell.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-4c63b1e2 | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:200 |  | VALUE_SET | chk_batch.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d561bbeb | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:202 |  | VALUE_SET | chk_pc_out.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-d5d9e3ee | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:203 |  | VALUE_SET | chk_jr_out.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-11ec402b | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:204 |  | VALUE_SET | chk_cell_out.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |
| AC-843b4a4e | this.Load 외 1 | FP00598_MeasureSetForm_Popup.cs:205 |  | VALUE_SET | chk_batch_out.Text | uom_p[index++] | 컨트롤 값 설정 |  |  |  |

## FP00598_MeasureSetForm_Popup.MakeAllCheckIfZero

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71e1fe49 | (진입점 미연결) | FP00598_MeasureSetForm_Popup.cs:398 |  | FLAG | measure | in_measure | 화면 필드/플래그 변경 |  |  |  |
| AC-8541b86a | (진입점 미연결) | FP00598_MeasureSetForm_Popup.cs:400 |  | CALL_EXT | MeasureService.DefaultMakeAllCheckIfZero | (in_measure, ctrls) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_MeasureSetForm_Popup.MeasureSetForm_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26125dbc | this.Load | FP00598_MeasureSetForm_Popup.cs:86 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-286a0b59 | this.Load | FP00598_MeasureSetForm_Popup.cs:94 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00598_MeasureSetForm_Popup.usrButton1_Click

진입점: this.usrButton1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-036634ee | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:382 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-81531754 | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:382 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-87192992 | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:384 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-fddfdad4 | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:388 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-f057e4cc | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:389 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-64d04ae6 | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:391 |  | CALL_EXT | MeasureService.UpdateMeasure | (_sMenuID, measure.Items, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-42a09c9c | this.usrButton1.Click | FP00598_MeasureSetForm_Popup.cs:393 |  | MESSAGE | MessageBox.Show | ("Save setting") | 메시지 표시 |  |  |  |

## FP00598_MeasureSetForm_Popup.usrButton2_Click

진입점: this.usrButton2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e9cedaf | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:351 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | VALUE_SET | eachCheck.Checked | measure[eachCheck.Name].On = eachCheck.Checked | 컨트롤 값 설정 |  |  |  |
| AC-db50c51d | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:351 | foreach (Control each in ctrls) ▸ if (eachCheck != null) | UI_PROP | measure[eachCheck.Name].On | eachCheck.Checked | 속성 On 설정 |  |  |  |
| AC-297fd71a | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:353 | foreach (Control each in ctrls) ▸ if (eachCheck != null) ▸ if (string.IsNullOrWhiteSpace(measure[eachCheck.Name].Name) && !string.IsNullOrWh… | UI_PROP | measure[eachCheck.Name].Name | eachCheck.Text | 속성 Name 설정 |  |  |  |
| AC-9374ba16 | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:357 |  | UI_PROP | measure.Menu | _sMenuID | 속성 Menu 설정 |  |  |  |
| AC-bc117eff | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:358 |  | UI_PROP | measure.User | _sUserId | 속성 User 설정 |  |  |  |
| AC-6f4ff5a0 | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:359 |  | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-5a1f8cea | this.usrButton2.Click | FP00598_MeasureSetForm_Popup.cs:360 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21bcae6 | .ctor | FP00598_Plan_Amend_Model_Elec.cs:173 |  | UI_PROP | this.DeleteOperation | DeleteOperationKind.ToZero | 속성 DeleteOperation 설정 |  |  |  |
| AC-e01d891a | .ctor | FP00598_Plan_Amend_Model_Elec.cs:174 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.ApplyAmendCalendarCondition

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1761ebc | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3612 |  | FLAG | calendar | null | 화면 필드/플래그 변경 |  |  |  |
| AC-80601d7c | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3613 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1304cf36 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3614 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5365b56e | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3615 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d2f950e5 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3616 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-921065bf | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3619 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionar… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-3de8cd5c | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3619 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d889f78e | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3630 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-15a94ce7 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3631 | if (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eb511e9a | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3633 | if (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d3d62c6 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3633 | if (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-7ea4c443 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3637 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_DateMap", Filter["PLAN_DATE"].ToString(), Fi… ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c54f4603 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3638 | else of (week_measure_sun != null && week_measure_sun.On) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "find_WeekCnt", Filter["BUCKET_FROM"].ToString(), … ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f8801fc5 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3640 | else of (week_measure_sun != null && week_measure_sun.On) | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictio… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 화면 필드/플래그 변경 |  |  |  |
| AC-3c9b7ebc | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3640 | else of (week_measure_sun != null && week_measure_sun.On) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_PlanAmendLineAssy", "find_bukInfo_sun", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo_sun] \| FP\Common\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d0a8c0ee | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3642 |  | FLAG | dateMap | dtMap.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-66abaa8c | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3643 |  | FLAG | weekInfo | dtWeek.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-ced0a8ab | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3655 | if (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-2e4a07be | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3657 | else of (measure.Month.On) | DATA_OP | Filter["MONTH_INFO"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd733d0c | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3658 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-dff88901 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3659 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |
| AC-037953c8 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3660 |  | DATA_OP | Filter["CATE_INFO"] | cate_info | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.ApplySearchCondition

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ab3218 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3666 | if (LocalFilter["INSTANCE_ID"] == "") | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { LocalFilter["INSTANCE_ID"] = CString.GetCheckedListValue(… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fe56631f | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3668 | if (LocalFilter["INSTANCE_ID"] == "") ▸ lambda | DATA_OP | LocalFilter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-1dbb1904 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3672 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //set["USER_ID"] = "chkim.68"; LocalFilter["BUCKET_FROM"]… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f16d9b6a | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3675 | lambda | DATA_OP | LocalFilter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-b8743081 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3676 | lambda | DATA_OP | LocalFilter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-3cfe77e6 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3677 | lambda | DATA_OP | LocalFilter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-4dbb8b94 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3682 | lambda ▸ if (cbo_fpplanid.SelectedIndex >= 0) | DATA_OP | LocalFilter["PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-c9d42c86 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3704 |  | DATA_OP | LocalFilter["MASTER_ID"] | LocalFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2be4236b | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3705 |  | DATA_OP | LocalFilter["PRODTYPE_LT"] | LocalFilter["PRODTYPE_ID"] | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnBucket_Click

진입점: this.btn_bucket.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6eebc25b | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7677 |  | FLAG | weekSunChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-7f83132d | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7682 |  | POPUP | new FP00598_BucketSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-77d7ca5e | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7683 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-74a5275c | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7684 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-c3b074c4 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7685 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-abcb6ba0 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7689 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-1968f719 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7691 | if (frm.DialogResult == DialogResult.OK) ▸ if (measure["chk_week_sun"] != null && week_sun != measure["chk_week_sun"].On) | FLAG | weekSunChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4c3a38c3 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7704 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-281d613b | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7706 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d583ce7d | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7710 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ i… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-301659a9 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7716 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7600c95d | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7718 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7930e153 | this.btn_bucket.Click | FP00598_Plan_Amend_Model_Elec.cs:7721 | if (frm.DialogResult == DialogResult.OK) ▸ else of (weekSunChanged) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnCapa_Click

진입점: this.btnCapaSync.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-433c8e7a | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7844 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-3c7fa336 | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7845 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-1df87598 | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7853 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-14c1b5d3 | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7854 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c5a3534 | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7860 | if (Filter["FP_PLAN_ID"] == "") | MESSAGE | MessageBox.Show | ("inserts FP Plan ID.") | 메시지 표시 |  |  |  |
| AC-9bad7fe8 | this.btnCapaSync.Click | FP00598_Plan_Amend_Model_Elec.cs:7861 | if (Filter["FP_PLAN_ID"] == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnCatagory_Click

진입점: this.btn_category.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6206e95 | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7641 |  | POPUP | new FP00598_MeasureSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, false, "") | 팝업/폼 생성 |  |  |  |
| AC-40fe4dd6 | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7642 |  | UI_PROP | frm.Measure | measure | 속성 Measure 설정 |  |  |  |
| AC-62728574 | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7643 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8bf880ef | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7644 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b825c041 | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7648 | if (frm.DialogResult == DialogResult.OK) | FLAG | measure | frm.Measure | 화면 필드/플래그 변경 |  |  |  |
| AC-53fb00cc | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7660 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ if (dsMain != null) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b8624fbb | this.btn_category.Click | FP00598_Plan_Amend_Model_Elec.cs:7669 | if (frm.DialogResult == DialogResult.OK) ▸ else of (measure.NeedLoad && dsMain != null) ▸ else of (dsMain != null) ▸ if (dsMainFiltered.Good… | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnColumn_Click

진입점: this.btn_column.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4e8ef59 | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7618 |  | POPUP | new FPC0097_ColumnSetForm_Popup | (SpdSheet.PROGID, SpdSheet.shtPlanAmendMA, true, mcbo_division.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-6aed99c4 | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7619 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2266d1e0 | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7620 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-be895390 | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7627 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.ServerColumns | FPExtensions.GetSpdTitleEx(SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPl… | 속성 ServerColumns 설정 |  |  |  |
| AC-16b90886 | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7627 | if (frm.DialogResult == DialogResult.OK) | CALL_EXT | FPExtensions.GetSpdTitleEx | (SpdSheet.PROGID, UserInfoContext.Current.UserId, SpdSheet.shtPlanAmendMA) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ddfdaac | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7628 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | measure.AmendColumns | null | 속성 AmendColumns 설정 |  |  |  |
| AC-218cc8ca | this.btn_column.Click | FP00598_Plan_Amend_Model_Elec.cs:7634 | if (frm.DialogResult == DialogResult.OK) ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnCreatePlan_Click

진입점: this.btnCreatePlan2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8b5f700 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7930 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-a18e2e8d | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7931 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-97bfc06a | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7938 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-11532c40 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7939 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf2edeb9 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7949 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | (_FormProcedure, "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Master.PR_UI_FP00598_FIND_FP00598 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7ab3e67e | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7951 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-020a7107 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7957 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-acaac795 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7958 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e443b888 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7963 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f40c533f | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7964 |  | DATA_OP | drs.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b22b57ea | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7967 |  | DATA_OP | dtParam.Columns.SafeAdd | ("AMEND_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57466c0e | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7968 |  | DATA_OP | dtParam.Columns.SafeAdd | ("FIX_DATE_SYNC", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-74e3a77d | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7969 |  | DATA_OP | dtParam.Columns.SafeAdd | ("SYNC_YN", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73cba13b | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7975 | if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-427a30b4 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7978 |  | POPUP | new FP00590_PlanTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, dtParam) | 팝업/폼 생성 |  |  |  |
| AC-61c23719 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7979 |  | VALUE_SET | popPlanTotal.Text | "Create Plan" | 컨트롤 값 설정 |  |  |  |
| AC-ead37628 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7980 |  | UI_PROP | popPlanTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-710fefb5 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7981 |  | UI_PROP | popPlanTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-e987e4ba | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7982 |  | POPUP | popPlanTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dbcfc29d | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7991 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] = popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-cc6e4c88 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7991 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | DATA_OP | Filter["PLAN_ID"] | popPlanTotal._NewPlanId | 행/컬럼 값 대입 |  |  |  |
| AC-fd98a891 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7992 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | FLAG | dtPlanId | DataService.FP_ExecuteProcedure2("PR_UI_" + "FP00598" + "_" + "findFpPlan_info", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-185c4c7f | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7992 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR_UI_" + "FP00598" + "_" + "findFpPlan_info", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-920f14fe | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7993 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-759c3636 | this.btnCreatePlan2.Click | FP00598_Plan_Amend_Model_Elec.cs:7996 | if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(pop… | VALUE_SET | cbo_fpplanid.SelectedValue | new_plan | 컨트롤 값 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnDppWppCopyDwSubmit_Click

진입점: this.btnDppWppCopyDwSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89b6c28c | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8373 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-2ae8035a | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8374 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-d2ff98b3 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8382 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57d777e7 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8383 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3cb39e4 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8387 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-03d54eef | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8388 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-577aba83 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8392 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-df945e05 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8393 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87a9b55f | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8398 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-1a6a5828 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8399 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6241d5f9 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8404 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-9efdd5bf | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8405 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94cd4f3a | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8408 |  | POPUP | new FPC0125_MWPPCopyDWSubmitPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0210121b | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8409 |  | UI_PROP | CopySubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-e873713b | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8409 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-92d5e1f9 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8410 |  | DATA_OP | CopySubmit.Filter["SUBMIT_TYPE"] | "ELEC" | 행/컬럼 값 대입 |  |  |  |
| AC-7ffbae1c | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8411 |  | DATA_OP | CopySubmit.Filter["MASTER_ID"] | CopySubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-53b4f358 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8411 |  | DATA_OP | CopySubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-64e22d1d | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8412 |  | DATA_OP | CopySubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-76012165 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8413 |  | DATA_OP | CopySubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-4f109d0b | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8414 |  | DATA_OP | CopySubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d8805f09 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8415 |  | DATA_OP | CopySubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-fdc1fa0b | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8416 |  | DATA_OP | CopySubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3ee1bbc0 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8417 |  | DATA_OP | CopySubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2166427a | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8418 |  | DATA_OP | CopySubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ef64862f | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8419 |  | DATA_OP | CopySubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b381f51c | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8420 |  | DATA_OP | CopySubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-237c1b33 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8422 |  | UI_PROP | CopySubmit.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f5088e7 | this.btnDppWppCopyDwSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8423 |  | POPUP | CopySubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnDwSubmit_Click

진입점: this.btnDWSubmit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cb13910 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8312 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-7828d20b | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8313 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-790f0176 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8321 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e3c8255 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8322 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e4d304ec | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8326 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6f7bcfb1 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8327 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b8e72120 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8330 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-8d9dbe72 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8331 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c020f02d | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8336 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-afaff2e3 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8337 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5de0767c | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8342 | if (Filter["PLAN_TYPE"] != "RELEASE") | MESSAGE | MessageBox.Show | ("Only Release plan can proceed.") | 메시지 표시 |  |  |  |
| AC-a912cfa6 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8343 | if (Filter["PLAN_TYPE"] != "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bfff0b5 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8348 |  | UI_PROP | DwSubmit.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-66961f1e | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8348 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6625a3a | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8349 |  | DATA_OP | DwSubmit.Filter["SUBMIT_TYPE"] | "CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-2e293cf3 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8350 |  | DATA_OP | DwSubmit.Filter["MASTER_ID"] | DwSubmit.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7b1fb1f4 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8350 |  | DATA_OP | DwSubmit.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-720ffbc9 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8351 |  | DATA_OP | DwSubmit.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-474fb139 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8352 |  | DATA_OP | DwSubmit.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-e5f645ad | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8353 |  | DATA_OP | DwSubmit.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-511af500 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8354 |  | DATA_OP | DwSubmit.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e13fa5b | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8355 |  | DATA_OP | DwSubmit.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a9d4452e | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8356 |  | DATA_OP | DwSubmit.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ff4ed00c | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8357 |  | DATA_OP | DwSubmit.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fec35c03 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8358 |  | DATA_OP | DwSubmit.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cf7bd7c4 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8359 |  | DATA_OP | DwSubmit.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0523be85 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8361 |  | UI_PROP | DwSubmit.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-5ffa0929 | this.btnDWSubmit.Click | FP00598_Plan_Amend_Model_Elec.cs:8362 |  | POPUP | DwSubmit.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdb9a11d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3715 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d72e2cf7 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3716 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de63bb37 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3722 | if (!FindDone) | MESSAGE | MessageBox.Show | ("You need to Find(F5) before import excel") | 메시지 표시 |  |  |  |
| AC-f7eca10d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3723 | if (!FindDone) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5997750a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3727 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release plan cannot be uploaded.") | 메시지 표시 |  |  |  |
| AC-050a54cf | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3728 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fab94d3d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3731 |  | POPUP | new FPC0095_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-c7b30f87 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3732 |  | CALL_EXT | select_popup.SetOption | (0, "Column Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-331abf4c | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3733 |  | CALL_EXT | select_popup.SetOption | (1, "Row Date Type") | ⚠ 의미 확인 필요 |  |  |  |
| AC-6ee9139f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3734 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-dfc3f49b | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3741 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | new FP00598_ExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-44b21ee5 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3744 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-09ac5420 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3744 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0c051378 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3746 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-7b2162ba | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3747 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DateColumnType | FPExtensions.DateColumnType.FP00595 | 속성 DateColumnType 설정 |  |  |  |
| AC-33e2d116 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3748 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.HeaderLineCount | 3 | 속성 HeaderLineCount 설정 |  |  |  |
| AC-4a829a4f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3750 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-015f8b76 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3751 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f71e5154 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3752 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b9619106 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3753 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-a284a7be | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3754 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-15d2b391 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3755 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-86cf63c9 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3756 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f2359903 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3757 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0c938010 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3758 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3079be28 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3759 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4c755cfa | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3760 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-0e7fbc62 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3761 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | colPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6ad7434 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3762 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa791980 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3763 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | GRID_SET | colPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9722e868 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3767 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-9c2d321b | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3768 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-7b22b6b8 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3769 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-c9a594e0 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3770 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-8c96970d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3771 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-12a83ced | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3772 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-f9e318f3 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3773 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-9da0eee0 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3774 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-fab3a7cd | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3775 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["EQUIPMENT_ID"] | "Equiment" | 행/컬럼 값 대입 |  |  |  |
| AC-033a2a14 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3776 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-401b983c | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3777 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-ef1b013b | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3778 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-54a3f895 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3779 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-8b9e30f2 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3780 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | colPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-848f2826 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3781 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-47dd0901 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3782 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | DATA_OP | colPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-946add0d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3784 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSearchData | call_Excel_Col_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-acbf62a6 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3785 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoLineCheck | call_Excel_Col_LineCheck | 속성 DoLineCheck 설정 |  |  |  |
| AC-2f3c1147 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3786 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoSaveData | call_Excel_Col_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-bf494bf5 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3787 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoValidationData | call_Excel_Col_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-7397d77a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3788 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | UI_PROP | colPopup.DoImportData | call_Excel_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-f8505c05 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3789 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: | POPUP | colPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-971b6e54 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3799 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | new FP00598_RowExcelPopup |  | 팝업/폼 생성 |  |  |  |
| AC-ffb42d31 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3802 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | FLAG | Filter | Filter.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9df8665 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3802 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-776e0ff4 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3805 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.Filter["UI_END_DATE"] | dCalendar_planrange.Value1.AddDays(56 - 1).ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-16ddc6ac | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3808 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-72e7406d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3809 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7a042289 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3810 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-7e640e9d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3811 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d3ca16fa | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3812 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b59b853f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3814 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["LINE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b208920a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3815 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ELECTRODE_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-ebcbc377 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3816 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-42a9e85e | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3817 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-15dd0fff | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3821 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["PC_MODEL_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-91c3ccb6 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3822 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (sVERSION_YN == "Y") | GRID_SET | rowPopup.KeyColumns["VERSION"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1d9d9c33 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3824 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | GRID_SET | rowPopup.KeyColumns["PLM_EC_NO"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fd1189f0 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3825 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PRODUCTION_TYPE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-123cd20a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3826 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["MARKET"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d05f3495 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3827 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["PLAN_DATE"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de03ef26 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3829 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["ADJUST_IN_QTY_BATCH"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-9b8d3184 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3830 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | GRID_SET | rowPopup.KeyColumns["SEQ"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b16ce943 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3833 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-7aab436a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3834 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-189ce9b8 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3835 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-8128dbf8 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3836 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["FACTORY_ID"] | "Bld." | 행/컬럼 값 대입 |  |  |  |
| AC-44e19288 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3837 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["OPERATION_ID"] | "Oper." | 행/컬럼 값 대입 |  |  |  |
| AC-637f9744 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3839 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_ID"] | "Line" | 행/컬럼 값 대입 |  |  |  |
| AC-3e24261c | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3840 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["LINE_NAME"] | "Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-7a0e87f6 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3841 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ELECTRODE_TYPE"] | "Elec. Type" | 행/컬럼 값 대입 |  |  |  |
| AC-5c02ee38 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3842 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["EQUIPMENT_ID"] | "Equipmnent" | 행/컬럼 값 대입 |  |  |  |
| AC-c7b52265 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3843 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ITEM_ID"] | "Material" | 행/컬럼 값 대입 |  |  |  |
| AC-80fd3ba0 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3845 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["NICK_NAME"] | "Nick Name" | 행/컬럼 값 대입 |  |  |  |
| AC-7c64e48a | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3846 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PC_MODEL_ID"] | "Work Sheet Model" | 행/컬럼 값 대입 |  |  |  |
| AC-e6f57281 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3847 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["VERSION"] | "Version" | 행/컬럼 값 대입 |  |  |  |
| AC-8d2726ce | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3848 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnTitle["PLM_EC_NO"] | "PDS ID" | 행/컬럼 값 대입 |  |  |  |
| AC-403f06e0 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3849 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PRODUCTION_TYPE"] | "Prod Type" | 행/컬럼 값 대입 |  |  |  |
| AC-de316731 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3850 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MARKET"] | "Market" | 행/컬럼 값 대입 |  |  |  |
| AC-c5019493 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3851 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["PLAN_DATE"] | "Plan Date" | 행/컬럼 값 대입 |  |  |  |
| AC-72f493b1 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3853 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_M"] | "M(P/C)" | 행/컬럼 값 대입 |  |  |  |
| AC-716bf804 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3854 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_CELL"] | "Cell" | 행/컬럼 값 대입 |  |  |  |
| AC-67551340 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3855 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_JR"] | "M(J/R)" | 행/컬럼 값 대입 |  |  |  |
| AC-d5820263 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3856 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["ADJUST_IN_QTY_BATCH"] | "Batch" | 행/컬럼 값 대입 |  |  |  |
| AC-24c8065f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3857 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["SEQ"] | "Seq" | 행/컬럼 값 대입 |  |  |  |
| AC-30ef8197 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3858 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnTitle["MESSAGE"] | "Message" | 행/컬럼 값 대입 |  |  |  |
| AC-56e726ce | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3860 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["DIVISION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-89048c7d | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3861 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SITE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-bfaf581c | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3862 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLANT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-e5d6e4a6 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3863 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["FACTORY_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-8ba0991b | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3864 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["OPERATION_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-9fd525c8 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3866 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["LINE_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b35a02cd | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3868 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ELECTRODE_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-ae46da1f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3869 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["EQUIPMENT_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0abab6f3 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3870 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ITEM_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-f5ee9952 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3871 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PC_MODEL_ID"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0aa9d5a2 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3872 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["VERSION"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-13ce35c7 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3873 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: ▸ if (Filter["IS_PDS"] == "Y") | DATA_OP | rowPopup.ColumnColor["PLM_EC_NO"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-7a9440ed | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3874 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PRODUCTION_TYPE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b4fae7aa | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3875 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["MARKET"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-0d4e8e00 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3876 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["PLAN_DATE"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-6d10cae3 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3878 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["ADJUST_IN_QTY_BATCH"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-206425eb | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3879 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnColor["SEQ"] | Color.Yellow | 행/컬럼 값 대입 |  |  |  |
| AC-b350e238 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3882 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | DATA_OP | rowPopup.ColumnWidth["COMPANY_ID"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-953475cd | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3885 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSearchData | call_Excel_Row_Search | 속성 DoSearchData 설정 |  |  |  |
| AC-2b19901f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3887 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoSaveData | call_Excel_Row_Save | 속성 DoSaveData 설정 |  |  |  |
| AC-a38bac82 | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3888 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoValidationData | call_Excel_Row_Validation | 속성 DoValidationData 설정 |  |  |  |
| AC-ed03373f | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3889 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | UI_PROP | rowPopup.DoImportData | call_Excel_Row_After_Import | 속성 DoImportData 설정 |  |  |  |
| AC-38ca1bfb | this.btnExcelImport.Click | FP00598_Plan_Amend_Model_Elec.cs:3890 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 1: | POPUP | rowPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnExportBufferData_Click

진입점: this.btnExportBufferData.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c296a69 | this.btnExportBufferData.Click | FP00598_Plan_Amend_Model_Elec.cs:8650 |  | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0072cbf9 | this.btnExportBufferData.Click | FP00598_Plan_Amend_Model_Elec.cs:8659 | try | CALL_EXT | System.Diagnostics.Process.Start | (sFileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b13b7d9 | this.btnExportBufferData.Click | FP00598_Plan_Amend_Model_Elec.cs:8664 | catch ((Exception eee)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { eee.Message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4bb79b5a | this.btnExportBufferData.Click | FP00598_Plan_Amend_Model_Elec.cs:8668 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnMemo_Click

진입점: this.btnMemo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63b66f7e | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8191 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f181224f | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8192 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-e94f208b | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8200 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8dd08c2 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8201 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-813c0d5b | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8207 | if (!Filter["MASTER_ID"].Good()) | MESSAGE | MessageBox.Show | ("Instace 값은 필수입니다") | 메시지 표시 |  |  |  |
| AC-950818ac | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8208 | if (!Filter["MASTER_ID"].Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7665ae1c | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8211 |  | POPUP | new FPC0104_MemoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ac37222d | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8212 |  | VALUE_SET | memoPopup.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-54c7a937 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8213 |  | DATA_OP | memoPopup.Filter["MASTER_ID"] | memoPopup.Filter["INSTANCE_ID"] = Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8c54950c | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8213 |  | DATA_OP | memoPopup.Filter["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8506b0dd | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8214 |  | DATA_OP | memoPopup.Filter["BUCKET_FROM"] | Filter["BUCKET_FROM"] | 행/컬럼 값 대입 |  |  |  |
| AC-51be2306 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8215 |  | DATA_OP | memoPopup.Filter["BUCKET_TO"] | Filter["BUCKET_TO"] | 행/컬럼 값 대입 |  |  |  |
| AC-576c60ed | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8216 |  | DATA_OP | memoPopup.Filter["MODEL_ID"] | memoPopup.Filter["TOP_ITEM_ID"] = Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-57bdea51 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8216 |  | DATA_OP | memoPopup.Filter["TOP_ITEM_ID"] | Filter["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-d4d20e8f | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8217 |  | DATA_OP | memoPopup.Filter["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4e644b6b | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8218 |  | DATA_OP | memoPopup.Filter["PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-71c67943 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8219 |  | DATA_OP | memoPopup.Filter["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ad770597 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8220 |  | DATA_OP | memoPopup.Filter["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aff6b233 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8221 |  | DATA_OP | memoPopup.Filter["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b81e9e10 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8222 |  | DATA_OP | memoPopup.Filter["OPERATION_ID"] | Filter["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-20af0800 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8223 |  | DATA_OP | memoPopup.Filter["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-70cf175f | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8224 |  | DATA_OP | memoPopup.Filter["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-4bde3e32 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8225 |  | DATA_OP | memoPopup.Filter["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-00df86ea | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8227 |  | DATA_OP | memoPopup.Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8a4a7d91 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8228 |  | UI_PROP | memoPopup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-b4c83eb7 | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8229 |  | UI_PROP | memoPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-84ee6ecb | this.btnMemo.Click | FP00598_Plan_Amend_Model_Elec.cs:8230 |  | POPUP | memoPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnMenu_Click

진입점: this.btnMenu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98060711 | this.btnMenu.Click | FP00598_Plan_Amend_Model_Elec.cs:8431 |  | FLAG | flo | MenuFloater.TogglePanel(flo, this, btnMenu, menuPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-be18c62a | this.btnMenu.Click | FP00598_Plan_Amend_Model_Elec.cs:8431 |  | CALL_EXT | MenuFloater.TogglePanel | (flo, this, btnMenu, menuPanel) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnMRP_Click

진입점: this.btnMRP.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4c8442b | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7881 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-359b8a97 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7882 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-8040959a | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7890 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7329553f | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7891 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6baf5ddd | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7896 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f29b0581 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7897 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c83ea828 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7900 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-9d3d25d9 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7901 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f6cb43b | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7906 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("Please select plan id") | 메시지 표시 |  |  |  |
| AC-36ed550d | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7907 | if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c750f19f | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7912 | if (Filter["PLAN_TYPE"] == "RELEASE") | MESSAGE | MessageBox.Show | ("Release plan can not proceed.") | 메시지 표시 |  |  |  |
| AC-29cb7bfe | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7913 | if (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-499e9026 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7917 |  | MESSAGE | MessageBox.Show | (meg, "Confirm", MessageBoxButtons.YesNo) | 메시지 표시 |  |  |  |
| AC-f254a623 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7918 | if (MessageBox.Show(meg, "Confirm", MessageBoxButtons.YesNo) != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-69ffb575 | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7919 |  | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1a84291d | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7920 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ("XpCommonAmend", "saveAll_MRP_Transit", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-7499d37d | this.btnMRP.Click | FP00598_Plan_Amend_Model_Elec.cs:7922 |  | MESSAGE | MessageBox.Show | ("Saved") | 메시지 표시 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnRelease_Click

진입점: this.btnRelease2.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f51776c1 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8035 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-99ce5dd9 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8036 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-92027756 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8043 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6e2e143 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8044 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4cb8f122 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8048 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_save_chk", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3fb0e5c5 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8049 |  | DATA_OP | ds_saveChk.getColumn | (0, "AUTH_YN") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ce858e68 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8052 | if (sAuthYN == "N") | MESSAGE | MessageBox.Show | ("Please check authority") | 메시지 표시 |  |  |  |
| AC-562e6869 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8053 | if (sAuthYN == "N") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4e730f8 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8066 | if (string.IsNullOrEmpty(sPlanID)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47d208b7 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8067 | if (string.IsNullOrEmpty(sPlanID)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a202388 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8073 | if (sPlanID == "-") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan ID" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa1b74c0 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8074 | if (sPlanID == "-") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-86dfe532 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8081 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "00 Plan cant not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8bf7f38c | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8082 | if (sPlanID.Substring(sPlanID.Length - 2, 2) == "00") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72020bce | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8085 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_instanceInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instanceInfo] \| FP\Common… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-16977baa | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8086 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("XpCommonAmend", "find_planInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_planInfo] \| FP\Common\XpC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3d6fce31 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8088 |  | DATA_OP | Filter["DESCRIPTION"] | dtPlanInfo.Rows[0]["DESCRIPTION"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f35f35c2 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8094 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Release type plan can not be confirm." }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0850e359 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8095 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtPlanInfo.Rows[0]["PLAN_TYPE"].ToString() == "RELEASE") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a529af4 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8099 | if (sPlanGroup.IndexOf("E_POST") == -1) | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findEngineFlag", sPlanGroup, sPlanID) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e27ce254 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8103 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9adca62e | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8104 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ if (dtEngineFlag.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8b1c6913 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8111 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | MESSAGE | MessageHelper.GMessageBox | ("MSG00199") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae1d9ef0 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8112 | if (sPlanGroup.IndexOf("E_POST") == -1) ▸ else of (dtEngineFlag.Rows.Count == 0) ▸ if (dtEngineFlag.Rows[0]["INBOUND"].ToString() != "C" && … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b4dd9ad | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8125 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRelease", sPlanGroup, sPlanDate) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c4704d6d | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8128 |  | COMBO_DATA | DataCommon.GetPlannnigUserFormCodeData | ("FP_Planning.PR_UI_FP_PLAN_FORM_CODE", "FP00590_findIsRunningPlan", sPlanGroup) ⇒ FP_Planning.PR_UI_FP_PLAN_FORM_CODE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8dbd1766 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8130 |  | DATA_OP | dtPlanRunFlag.getColumn | (0, "CNT") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-28d5430d | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8136 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d9b7a70a | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8137 | if (dtPlanRunFlag.getColumn(0, "CNT").SafeZeroInt() > 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d56ef531 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8150 |  | DATA_OP | dtInstance.Select | (string.Format("CODE = '{0}'", sPlanGroup)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0e54a77 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8151 |  | DATA_OP | drs2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4f6fbefa | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8163 | if (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-e33916ba | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8166 | if (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_GroupReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-baa37cf2 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8167 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-eb07d4c8 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8168 | if (sConfirmArea == "PLAN GROUP") | UI_PROP | popGroupTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f6473b25 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8169 | if (sConfirmArea == "PLAN GROUP") | POPUP | popGroupTotal.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-533e2bc9 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8177 | else of (sConfirmArea == "PLAN GROUP") ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-9d458214 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8180 | else of (sConfirmArea == "PLAN GROUP") | POPUP | new FP00590_ReleaseTotalPopup | (sSite, sPlanGroup, sPlanDate, sPlanID, sIsSamePlanID, sDescription) | 팝업/폼 생성 |  |  |  |
| AC-033cda43 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8181 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-10fa2495 | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8182 | else of (sConfirmArea == "PLAN GROUP") | UI_PROP | popReleaseTotal.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-59f0dbad | this.btnRelease2.Click | FP00598_Plan_Amend_Model_Elec.cs:8183 | else of (sConfirmArea == "PLAN GROUP") | POPUP | popReleaseTotal.Show | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnReplan_Click

진입점: this.btnReplan.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e954c739 | this.btnReplan.Click | FP00598_Plan_Amend_Model_Elec.cs:8026 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-77941027 | this.btnReplan.Click | FP00598_Plan_Amend_Model_Elec.cs:8027 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnSetupColor_Click

진입점: this.btnSetupColor.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-958a7a58 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8240 | if (flo != null) | UI_MISC | flo.Hide | () | 창 닫기/해제 |  |  |  |
| AC-f4bba342 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8241 | if (flo != null) | FOCUS | btnMenu.Focus | () | 포커스 이동 |  |  |  |
| AC-d6873ee2 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8243 |  | POPUP | new FP00595_SetupColor_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-54f3c8fd | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8244 |  | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-af784ac0 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8244 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f9913f29 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8245 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-2a38458c | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8246 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterScreen | 속성 StartPosition 설정 |  |  |  |
| AC-2e881438 | this.btnSetupColor.Click | FP00598_Plan_Amend_Model_Elec.cs:8247 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c02fbee1 | this.btnSql.Click | FP00598_Plan_Amend_Model_Elec.cs:2262 | if (true) | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9ab90040 | this.btnSql.Click | FP00598_Plan_Amend_Model_Elec.cs:2263 | if (true) | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-856e08cc | this.btnSql.Click | FP00598_Plan_Amend_Model_Elec.cs:2265 | if (true) | DATA_OP | popSql.Services.Add | ("PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") | 데이터 객체 조작/조회 |  |  |  |
| AC-57e4fe4f | this.btnSql.Click | FP00598_Plan_Amend_Model_Elec.cs:2266 | if (true) | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.btnToggleSave_Click

진입점: this.btnToggleSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13e5cf15 | this.btnToggleSave.Click | FP00598_Plan_Amend_Model_Elec.cs:7731 |  | UI_PROP | splitter.Panel2Collapsed | !cur | 속성 Panel2Collapsed 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.button1_Click

진입점: this.button1.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099b3387 | this.button1.Click | FP00598_Plan_Amend_Model_Elec.cs:8455 | if (flo2 != null) | VALUE_SET | chk_Info.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-589621a7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4381 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-fb3673fc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4381 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-dcc09784 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4385 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d223aa6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4386 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0f3469ce | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4396 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9b42f1d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4396 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-60708046 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4398 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0093e40 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4399 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9fe3af27 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4417 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-475ee9f4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4420 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-78ddec37 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4424 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f2212a31 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4435 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-04cff359 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4438 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a2012a8e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4442 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-0ea8cad0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4451 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-9441b67f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4451 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-e9908a7a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4451 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ebec0a78 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4452 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-b85373a4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4452 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-087dfb7d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4456 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-b8ce51e1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4456 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-a3de2348 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4457 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-64cb3ded | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4473 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-0739e086 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4473 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-a4f18f3c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4473 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-aa138223 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4474 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-ea65e862 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4474 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a33df14c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4478 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-274d8daa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4478 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-bfec1f52 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4479 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-d53281d5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4517 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f7677142 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4518 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7513b03e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4519 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b9fa473d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4523 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9f497287 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4524 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-a76c6819 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4525 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-685d7bcd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4532 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-b05bb4d9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4550 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-a64228b0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4551 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-6213651c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4552 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (KeyValuePair<string, AmendDate> each_day in calendar.D… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-77b25546 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4563 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0c755cea | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4563 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Col_LineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe9f8f23 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5086 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Col_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-315f4a1b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4646 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2c2db9a7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4652 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-4dc1b1df | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4653 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1b84787b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4656 |  | UI_PROP | popup.dsSaveExcelData | new DataSet() | 속성 dsSaveExcelData 설정 |  |  |  |
| AC-1043c2df | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4657 |  | DATA_OP | popup.dsSaveExcelData.Tables.Add | (data.Tables[0].Clone()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b6ba965 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4657 |  | DATA_OP | data.Tables[0].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ef5c3ff9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4660 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d089cf59 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4661 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("QTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1038ae5a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4662 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("SEQ", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffa2b17a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4664 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2bad2bf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4665 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b932d1e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4666 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0d59b22 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4667 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1b4519b4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4669 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c083d1c6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4670 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-47127600 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4671 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-264542cb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4672 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-608c4082 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4674 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e1faa4a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4675 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a5666e4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4676 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-525a7c7a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4677 | if (popup.Calendar != null) | DATA_OP | popup.dsSaveExcelData.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-28b04b54 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4705 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-53669da8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4706 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | popup.dsSaveExcelData.Tables[0].Rows.Add | (pivotLine) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d7c5473 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4708 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["INSTANCE_ID"] | popup.Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a0e098ad | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4709 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FP_PLAN_ID"] | popup.Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-bb864067 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4710 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLAN_DATE"] | aDate.Date.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-240d8cf0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4711 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["QTY"] | row[sQtyCol].SafeDouble() | 행/컬럼 값 대입 |  |  |  |
| AC-dbad5f4e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4713 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["DIVISION_ID"] | row["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f8a32c0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4714 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SITE_ID"] | row["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-1087607e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4715 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLANT_ID"] | row["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-0c3ae900 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4716 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["FACTORY_ID"] | row["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-09103166 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4717 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["OPERATION_ID"] | row["OPERATION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-3062f3e2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4719 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_ID"] | row["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-822701de | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4720 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LINE_NAME"] | row["LINE_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-2d15f9aa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4721 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ELECTRODE_TYPE"] | row["ELECTRODE_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-27a774ee | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4722 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["EQUIPMENT_ID"] | row["EQUIPMENT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-ca00675f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4723 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ITEM_ID"] | row["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-74423a04 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4725 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["NICK_NAME"] | row["NICK_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-cefb75c6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4726 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PRODUCTION_TYPE"] | row["PRODUCTION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-9770df8c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4727 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["LOCATION"] | row["LOCATION"] | 행/컬럼 값 대입 |  |  |  |
| AC-abe49d1f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4728 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["MARKET"] | row["MARKET"] | 행/컬럼 값 대입 |  |  |  |
| AC-cae04450 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4729 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["TOP_ITEM_ID"] | row["TOP_ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-63f19f49 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4731 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["USER_ID"] | row["USER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aed17844 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4732 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PC_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-a3fe40d0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4733 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-76b73d8c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4734 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["VERSION"] | row["VERSION"] | 행/컬럼 값 대입 |  |  |  |
| AC-b18d7944 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4735 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["PLM_EC_NO"] | row["PLM_EC_NO"] | 행/컬럼 값 대입 |  |  |  |
| AC-dfaabc6e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4738 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-f3a4b140 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4740 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-ee109706 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4742 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-6d7847ec | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4744 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_IN_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-e60bdd0c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4747 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_BATCH"] | RoundValue(row[sQtyCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-b3e40db9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4749 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_M"] | RoundValue(row[sMCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-84a0f1c6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4751 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_CELL"] | RoundValue(row[sCellCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-5516ceef | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4753 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["ADJUST_OUT_QTY_JR"] | RoundValue(row[sJRCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-2d9e2222 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4755 | if (popup.Calendar != null) ▸ foreach (DataRow row in data.Tables[0].Rows) ▸ foreach (AmendWeek week in calendar.Weeks.Values) ▸ foreach (Am… | DATA_OP | pivotLine["SEQ"] | RoundValue(row[sSeqCol]) | 행/컬럼 값 대입 |  |  |  |
| AC-3ce700c6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4777 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-8bf1ce93 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4778 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-87d78aca | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4779 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-9230083a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4779 | if (SaveExcelRows(popup.dsSaveExcelData, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-4a5ac97a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4781 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f064da47 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4781 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Col_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-855eb442 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4192 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3e0f42ae | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4195 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("INSTANCE_ID", "FP_PLAN_ID", "COMPANY_ID", "EQUIPMENT_ID", "DIVISION_ID", "SITE_ID", "PLA… | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cf5e26a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4198 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-84617772 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4202 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter, "SQL") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b88beec | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4203 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c70d95b5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4206 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b982e67e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4209 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-784a672b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4212 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Col_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2695a9cf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5080 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Row_After_Import

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdb7db29 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4003 | if (dsItemInfo == null \|\| dsLineInfo == null) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "You don't have necessiry info (Item Info, Line Info)") | ⚠ 의미 확인 필요 |  |  |  |
| AC-80769a26 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4003 | if (dsItemInfo == null \|\| dsLineInfo == null) | RETURN | return DataService.CreateResultDataSet(false, 0, "You don't have necessiry info … |  | 처리 중단/반환 |  |  |  |
| AC-d7a4e46f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4007 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_VALID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d89ae271 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4008 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("_MSG", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-feab5514 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4018 | if (AnyError) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "Validation Error") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f14306bf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4018 | if (AnyError) | RETURN | return DataService.CreateResultDataSet(false, 0, "Validation Error"); |  | 처리 중단/반환 |  |  |  |
| AC-8dc343e1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4020 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("APPLIED_MODEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4d0422a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4021 |  | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PROD_VERSION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f271ffb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4039 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsItemInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-2432c432 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4042 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | rows[0]["APPLIED_MODEL"] | 행/컬럼 값 대입 |  |  |  |
| AC-daefd606 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4046 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["APPLIED_MODEL"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f9cbe18e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4057 | for (i < data.Tables[0].Rows.Count) | DATA_OP | dsLineInfo.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-5917058f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4060 | for (i < data.Tables[0].Rows.Count) ▸ if (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | rows[0]["PROD_VERSION_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-f6d7c802 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4064 | for (i < data.Tables[0].Rows.Count) ▸ else of (rows != null && rows.Length > 0) | DATA_OP | row["PROD_VERSION_TYPE"] | "GENERAL" | 행/컬럼 값 대입 |  |  |  |
| AC-2753d514 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4073 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-58b33569 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4073 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-56f65ba6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4073 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e927de9b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4074 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-8da48ddd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4074 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ if (nVerRow != -1) | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-30bd0454 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4078 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-563c82b4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4078 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-e36400f4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4079 | for (i < data.Tables[0].Rows.Count) ▸ if (sVERSION_YN == "N") ▸ else of (nVerRow != -1) | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-6539d94b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4095 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-15c47300 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4095 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "MODEL_ID") | 행/컬럼 값 대입 |  |  |  |
| AC-8aabdeee | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4095 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "MODEL_ID") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ea060571 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4096 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | dsUOMInfo.Tables[0].getColumn(nVerRow, "VERSION") | 행/컬럼 값 대입 |  |  |  |
| AC-7415b65d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4096 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | dsUOMInfo.Tables[0].getColumn | (nVerRow, "VERSION") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-63d87880 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4100 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] = null | 행/컬럼 값 대입 |  |  |  |
| AC-1c6e884b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4100 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["PC_MODEL_ID"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-19d5e76f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4101 | for (i < data.Tables[0].Rows.Count) ▸ else of (sVERSION_YN == "N") ▸ if (string.IsNullOrWhiteSpace(sVersion_tmp) \|\| sVersion_tmp == "-") ▸… | DATA_OP | row["VERSION"] | null | 행/컬럼 값 대입 |  |  |  |
| AC-e578801d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4140 | foreach (DataRow row in data.Tables[0].Rows) ▸ if (nInValueOrg == DBNull.Value) | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-063e66b6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4144 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ if (nInValueOrg is string && string.IsNullOrWhiteSpac… | THROW | throw new Exception("Validation error"); |  | 예외 발생 |  |  |  |
| AC-74321dd7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4151 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sSeqCol] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-dca6ee68 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4169 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sMCol] | (int)Math.Ceiling((double)nIn_M) | 행/컬럼 값 대입 |  |  |  |
| AC-c40c0874 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4170 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sCellCol] | (int)Math.Ceiling((double)nIn_CELL) | 행/컬럼 값 대입 |  |  |  |
| AC-bff4dc0a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4171 | foreach (DataRow row in data.Tables[0].Rows) ▸ else of (nInValueOrg == DBNull.Value) ▸ else of (nInValueOrg is string && string.IsNullOrWhit… | DATA_OP | row[sJRCol] | (int)Math.Ceiling((double)nIn_JR) | 행/컬럼 값 대입 |  |  |  |
| AC-167e5ce5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4182 |  | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cd46a35 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4182 |  | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Row_Save

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1e913e2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5140 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4810b631 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5145 | if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-d1c31364 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5146 | if (checkSave.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-17763e0b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5163 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cf843a4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5164 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e85240d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5165 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-44a58806 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5166 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e9dafea | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5167 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-325adffb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5168 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4e692e1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5169 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-59374cf4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5176 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-56f602d5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5177 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a73fe8e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5178 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e75de26 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5179 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-81a4f7de | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5180 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfbc95ef | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5182 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0d38cd3c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5183 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e9edbcf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5184 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c5ca93b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5185 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-033d0303 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5186 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f0ae608 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5187 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-86850130 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5191 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-07a70b03 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5192 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popup.Filter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-cce0f83e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5193 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-2ee3b160 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5196 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-f0f7ca8e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5197 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-ebaf030d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5198 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-70fda30f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5199 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-d2768bcd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5200 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-c3379ffa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5201 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-df2e8ac1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5202 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-28922df7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5203 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-aecb3b5d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5204 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-ae3184a6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5205 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-3a471ec6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5209 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-801361da | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5210 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-9979fce5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5211 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-da5d9782 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5212 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-3bbb723e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5213 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-48ad260c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5214 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-c620b8c6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5215 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-df529194 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5216 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-6690dc4d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5217 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-bbdbef2d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5218 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-25a383ca | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5222 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (qty_val == null) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-e32c59a9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5224 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-6d1195f1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5226 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (qty_val == n… | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-52abac59 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5229 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f51c3ab6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5233 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-df08ae91 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5234 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-f90491bc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5235 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-7354efd3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5236 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-4a79a012 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5237 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-6f011dbd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5238 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | popup.Filter | 속성 Filter 설정 |  |  |  |
| AC-9e34a25a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5239 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | popup.Filter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-be687fb9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5241 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a6250bfa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5248 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-e31b5acd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5250 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-454ea647 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5250 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (do_save) ▸ if (popup != null) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-487118b2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5255 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-250ff28e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5255 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (do_save) | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |
| AC-72eb633d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5263 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f1f66c11 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5265 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-17307c57 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5266 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTA… | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fce4df88 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5267 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0570d0f9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5268 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PL… | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9d3d3a2f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5271 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-77dc2eb5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5272 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows… | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8245b23f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5279 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-d5c47aa5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5280 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | UI_PROP | popup.SaveSuccess | true | 속성 SaveSuccess 설정 |  |  |  |
| AC-d9d860d5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5281 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | CALL_EXT | DataService.CreateResultDataSet | (true, 1, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a2834c12 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5281 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try ▸ if (SaveExcelRows(data, popup.Filter, out ref_val) == true) | RETURN | return DataService.CreateResultDataSet(true, 1, ""); |  | 처리 중단/반환 |  |  |  |
| AC-03ab3309 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5283 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ try | UI_PROP | popup.validation | ref_val | 속성 validation 설정 |  |  |  |
| AC-26ba6223 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5288 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | CALL_EXT | DataService.CreateResultDataSet | (false, 0, e.Message) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa67415d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5288 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ catch ((Exception e)) | RETURN | return DataService.CreateResultDataSet(false, 0, e.Message); |  | 처리 중단/반환 |  |  |  |
| AC-6969b570 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5292 |  | CALL_EXT | DataService.CreateResultDataSet | (false, 0, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-7333e2fd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5292 |  | RETURN | return DataService.CreateResultDataSet(false, 0, ""); |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Row_Search

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a7dc0c9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5105 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_MPPWPP_FIND_EXCELIMPORT_2", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bfa4780d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5108 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ccf8dbc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5111 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-3e0d19c0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5117 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-760ef934 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5118 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-04163176 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5119 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-1354254f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5120 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | popup.Calendar | Calendar | 속성 Calendar 설정 |  |  |  |
| AC-19f86d33 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5122 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00595_EXCEL_2_FIND_EXCELIMPORT", popup.Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e9db3dfd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5125 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (m != null && m.Tables != null && m.Tables.Count > 0) | CALL_EXT | m.Tables[0].SetColumnsOrder | ("DIVISION_ID", "SITE_ID", "PLANT_ID", "TOP_ITEM_ID", "ITEM_ID", "NICK_NAME", "ITEM_TYPE",… | ⚠ 의미 확인 필요 |  |  |  |
| AC-657ebe30 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5128 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-cd9a38dd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5131 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.call_Excel_Row_Validation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-452f7627 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5306 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-571e389e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5310 | if (popup.Filter["PLAN_TYPE"] == "RELEASE") ▸ if (nSeq.Good()) | DATA_OP | popup.Filter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-45e0192c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5313 |  | COMBO_DATA | data.Good | () | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74fc71a1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5315 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a112d56 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5316 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("CELL")) | DATA_OP | data.Tables[0].Columns.Add | ("CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3a9150e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5317 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-638d3df2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5318 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07a33f9b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5319 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-531f409b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5320 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | data.Tables[0].Columns.Add | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-40d12bcc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5321 | if (data.Good()) | DATA_OP | data.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-130fd4e9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5322 | if (data.Good()) ▸ if (!data.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | data.Tables[0].Columns.Add | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55117fb2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5325 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["CELL"] | row["QTY"] | 행/컬럼 값 대입 |  |  |  |
| AC-90fd85fb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5326 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["INSTANCE_ID"] | popup.Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6ee4bd90 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5327 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["FP_PLAN_ID"] | popup.Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-f05a958b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5328 | if (data.Good()) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popup.Filter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-9d35a460 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5336 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | column_params.Add | ("USER_ID", CurrentUser) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc1cbec | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5348 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_PseudoBatch | ( "FP00602_MPPWPP", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-e18c7308 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5370 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | popup.Filter["INSTANCE_COND"] | tmp_sql | 행/컬럼 값 대입 |  |  |  |
| AC-960ed15a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5372 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00602_MPPWPP", "find_Excel_buffer_validation", popup.Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ea2833a1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5389 | if (popup != null) ▸ if (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return validation; |  | 처리 중단/반환 |  |  |  |
| AC-bd3f1c60 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5413 | if (popup != null) ▸ else of (popup.Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-1a3d3b50 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5416 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.cbo_fpplanid_changed

진입점: this.Load / cbo_fpplanid.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef31aa2f | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7349 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_SET | cbo_fpplanid.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-bf354ef7 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7352 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-ecf8fc72 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7353 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-559dbab0 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7354 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-b1c37db3 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7355 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-f916437b | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7356 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4325b53c | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7359 | if (cbo_fpplanid.Items.Count > 0 && cbo_fpplanid.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f89124ac | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7400 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-524e989b | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7402 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-77f57486 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7403 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-dbfcb2e5 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7404 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e71ffcb0 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7405 | if (dtPlanId.Good()) ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-56e53139 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7409 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab93f4c | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7411 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3f8877e4 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7412 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e9cf50ba | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7413 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6d5a8606 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7414 | if (dtPlanId.Good()) ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-9e016bdf | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7424 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[selected]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a4124e8d | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7425 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[selected]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2bc56a0 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7427 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value1 | DateTime.ParseExact(start_date, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-0cf623d5 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7428 | if (dtPlanId.Good()) ▸ try | UI_PROP | dCalendar_planrange.Value2 | DateTime.ParseExact(end_date, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-13ba806c | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7429 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5793bb0f | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7430 | if (dtPlanId.Good()) ▸ try | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-cc1ff5fa | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7437 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-e2b98c75 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7438 | if (dtPlanId.Good()) ▸ catch () | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(20) | 속성 Value2 설정 |  |  |  |
| AC-24a901ef | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7445 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-33fc01bd | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7446 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-516b26a8 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7447 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-af71d8dc | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7448 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-a877e8de | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7449 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-8606826a | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7454 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value1 | DateTime.Now | 속성 Value1 설정 |  |  |  |
| AC-6688df35 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7455 | else of (dtPlanId.Good()) | UI_PROP | dCalendar_planrange.Value2 | DateTime.Now.AddDays(27) | 속성 Value2 설정 |  |  |  |
| AC-09a648c8 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7461 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-56c04c82 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7462 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-2e4b1a91 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7463 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-e1ce42b7 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7464 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-1cb027f5 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7465 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.cbo_plan_group_changed

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caeee553 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7310 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-361f65bf | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7314 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.CheckAndGetMeasure

진입점: this.Load / popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8199a36 | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:584 | switch (measureId) default: ▸ if (measure == null) | FLAG | measure | MeasureService.GetMeasure(measureId) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5462974 | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:584 | switch (measureId) default: ▸ if (measure == null) | COMBO_DATA | MeasureService.GetMeasure | (measureId) | Measure 목록 조회 |  |  |  |
| AC-e3681960 | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:586 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00598_MeasureSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9c82155f | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:586 | switch (measureId) default: | POPUP | new FP00598_MeasureSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-02d95eef | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:587 | switch (measureId) default: | CALL_EXT | MeasureService.MakeDefault | (new FP00598_BucketSetForm_Popup(), measure) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b876a728 | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:587 | switch (measureId) default: | POPUP | new FP00598_BucketSetForm_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-b394aa8d | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:589 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week") | 데이터 객체 조작/조회 |  |  |  |
| AC-d96f621a | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:590 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week")) | FLAG | week_measure | measure.Data["chk_week"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b44702fd | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:591 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_day") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d68fdce | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:592 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_day")) | FLAG | day_measure | measure.Data["chk_day"] | 화면 필드/플래그 변경 |  |  |  |
| AC-b5c3058f | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:593 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_month") | 데이터 객체 조작/조회 |  |  |  |
| AC-6a92ff65 | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:594 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_month")) | FLAG | month_measure | measure.Data["chk_month"] | 화면 필드/플래그 변경 |  |  |  |
| AC-7174c11b | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:595 | switch (measureId) default: | DATA_OP | measure.Data.ContainsKey | ("chk_week_sun") | 데이터 객체 조작/조회 |  |  |  |
| AC-ae8800ac | this.Load 외 9 | FP00598_Plan_Amend_Model_Elec.cs:596 | switch (measureId) default: ▸ if (measure.Data.ContainsKey("chk_week_sun")) | FLAG | week_measure_sun | measure.Data["chk_week_sun"] | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.chk_Info_CheckedChanged_1

진입점: this.chk_Info.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a5a69ea | this.chk_Info.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8439 | if (chk_Info.Checked) | FLAG | flo2 | MenuFloater.GoPanel(this, chk_Info, infoPanel) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e4d08d3 | this.chk_Info.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8439 | if (chk_Info.Checked) | CALL_EXT | MenuFloater.GoPanel | (this, chk_Info, infoPanel) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1f9a15e | this.chk_Info.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8445 | else of (chk_Info.Checked) ▸ if (flo2 != null) | UI_MISC | flo2.Hide | () | 창 닫기/해제 |  |  |  |
| AC-9a2f6294 | this.chk_Info.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8446 | else of (chk_Info.Checked) ▸ if (flo2 != null) | FOCUS | chk_Info.Focus | () | 포커스 이동 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.chk_omit_zero_CheckedChanged

진입점: chk_omit_zero.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a199efa | chk_omit_zero.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8619 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8d92e2f9 | chk_omit_zero.CheckedChanged | FP00598_Plan_Amend_Model_Elec.cs:8621 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.CreateEditDataGridDataSet

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ccbc2ca | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7221 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-f29b58ff | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7223 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7abef86d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7224 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fe2595d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7225 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2fbdf5d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7226 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d26dbbb0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7227 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3cb1d6d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7228 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6224a2e2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7229 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb157127 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7230 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-182d8e95 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7231 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e966aff3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7232 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d558a672 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7233 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e9f11d4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7234 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a97b078c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7235 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4eca0a52 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7236 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aaac469a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7237 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fed6d24 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7238 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-878c8eed | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7239 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b228c894 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7240 |  | DATA_OP | dt.Columns.SafeAdd | ("TOP_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-39004d64 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7241 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb3f51cf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7242 |  | DATA_OP | dt.Columns.SafeAdd | ("BOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49c131b5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7243 |  | DATA_OP | dt.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a81a4938 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7244 |  | DATA_OP | dt.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b737db39 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7245 |  | DATA_OP | dt.Columns.SafeAdd | ("SALES_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-04657a02 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7246 |  | DATA_OP | dt.Columns.SafeAdd | ("EOH_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93751361 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7247 |  | DATA_OP | dt.Columns.SafeAdd | ("YIELD", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a564af4c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7250 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31976888 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7251 |  | DATA_OP | dt.Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e869bd66 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7252 |  | DATA_OP | dt.Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ad7eb4bb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7254 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22dd74e6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7255 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7233aef | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7256 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10f1782f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7257 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9ed6c2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7259 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8ce6fee | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7260 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31155481 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7261 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cad828c7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7262 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9cc8801d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7264 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-75cf8159 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7265 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TIME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a02bd0ab | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7266 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32a9d923 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7267 |  | DATA_OP | dt.Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e19b130d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7269 |  | DATA_OP | dt.Columns.SafeAdd | ("EIDX", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dea1d178 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7270 |  | DATA_OP | dt.Columns.SafeAdd | ("EQTY", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6920c3eb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7271 |  | DATA_OP | dt.Columns.SafeAdd | ("EDATE", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7e2c32d6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7273 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a35b1846 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7274 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-25ed5901 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7279 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-3df1a123 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7282 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.CreateEditDataGridDataSetTmp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d8195df | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7106 |  | UI_PROP | dt.TableName | "Table" | 속성 TableName 설정 |  |  |  |
| AC-cb2116a3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7108 |  | DATA_OP | dt.Columns.SafeAdd | ("INSTANCE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-abff9ada | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7109 |  | DATA_OP | dt.Columns.SafeAdd | ("FP_PLAN_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-22872853 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7110 |  | DATA_OP | dt.Columns.SafeAdd | ("COMPANY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-303345e5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7111 |  | DATA_OP | dt.Columns.SafeAdd | ("DIVISION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a450210 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7112 |  | DATA_OP | dt.Columns.SafeAdd | ("SITE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4de349a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7114 |  | DATA_OP | dt.Columns.SafeAdd | ("CATEGORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2986cc6b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7116 |  | DATA_OP | dt.Columns.SafeAdd | ("PLANT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-58ac036e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7117 |  | DATA_OP | dt.Columns.SafeAdd | ("FACTORY_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1028ad4a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7118 |  | DATA_OP | dt.Columns.SafeAdd | ("LOCATION", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2893f65b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7119 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9a7118c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7120 |  | DATA_OP | dt.Columns.SafeAdd | ("OPERATION_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6fbdf0b4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7121 |  | DATA_OP | dt.Columns.SafeAdd | ("LINE_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-69c10410 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7122 |  | DATA_OP | dt.Columns.SafeAdd | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ce6c018 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7123 |  | DATA_OP | dt.Columns.SafeAdd | ("EQUIPMENT_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-00d3d7cb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7125 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d9967df | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7126 |  | DATA_OP | dt.Columns.SafeAdd | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a704b652 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7127 |  | DATA_OP | dt.Columns.SafeAdd | ("PRODUCTION_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6266b9b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7128 |  | DATA_OP | dt.Columns.SafeAdd | ("MARKET", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f043266 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7129 |  | DATA_OP | dt.Columns.SafeAdd | ("IS_PREV_SCHEDULE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e3b02d2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7132 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8c169bb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7133 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68f31e61 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7134 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85c9a107 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7135 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10abc952 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7137 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed39cf0e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7138 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-84df3abb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7139 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e38ce28 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7140 |  | DATA_OP | dt.Columns.SafeAdd | ("PLAN_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9114da43 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7143 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d133db51 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7144 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2d08fd3d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7145 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0860255b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7146 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f57dc298 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7147 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e086ed43 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7149 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb5cd071 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7150 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7f83fde | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7151 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-501364b8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7152 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e4b131a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7153 |  | DATA_OP | dt.Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4cd23b5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7155 |  | DATA_OP | dt.Columns.SafeAdd | ("TOTAL_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf0fb6f5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7157 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ea87710 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7158 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a82b5ca | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7159 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0d59e8c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7160 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2dd1214 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7161 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f79aef7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7163 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e50d7b29 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7164 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-07b2f8aa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7165 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-55525a6e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7166 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4c36c18 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7167 |  | DATA_OP | dt.Columns.SafeAdd | ("MPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-28d3a2d1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7169 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ce72774 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7170 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-025d225e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7171 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed54b8f7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7172 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46753a3c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7173 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-983b3c21 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7175 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fa450e5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7176 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49d7145a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7177 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c8db271c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7178 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a146cf87 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7179 |  | DATA_OP | dt.Columns.SafeAdd | ("WPP_OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-073600e4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7181 |  | DATA_OP | dt.Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-46f18f4d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7207 |  | DATA_OP | dt.Columns.SafeAdd | ("M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c4de6f81 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7208 |  | DATA_OP | dt.Columns.SafeAdd | ("USER_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fbe8035 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7213 | if (dt.DataSet == null) | DATA_OP | ds.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-d7d2aba6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7216 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.CreateFilterDataSet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d5dac64 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2374 | if (dsResult == null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-eb9a10c8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2385 | lambda | DATA_OP | result_row["_MM_"] | false | 행/컬럼 값 대입 |  |  |  |
| AC-e0115f63 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2386 | lambda | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-cf3b35e8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2858 |  | DATA_OP | dsResult.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f820943 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2861 | for (i < rows.Length) | DATA_OP | rows[i]["_MM_"] | true | 행/컬럼 값 대입 |  |  |  |
| AC-0feb57a4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2867 | lambda | DATA_OP | x.Field | ("_MM_") | 데이터 객체 조작/조회 |  |  |  |
| AC-8427ce4d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2871 | if (m != null && m.Count() > 0) | DATA_OP | m.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b475c001 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2874 | if (t != null) | DATA_OP | dsMain.Tables.Add | (t) | 데이터 객체 조작/조회 |  |  |  |
| AC-0b2aa6ca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2876 | else of (t != null) | DATA_OP | dsResult.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cfb75b78 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2876 | else of (t != null) | RETURN | return dsResult.Clone(); |  | 처리 중단/반환 |  |  |  |
| AC-edf7d4a4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2878 |  | RETURN | return dsMain; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d48155c6 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:538 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtPlanAmendMA, SpdSheet.shtPlanAmendMA, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf46a8b7 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:539 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtPlanAmendMA) | 화면 필드/플래그 변경 |  |  |  |
| AC-69994828 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:540 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtPlanAmendMA) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.dCalendar_changed

진입점: dCalendar_planrange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3b12bbb | dCalendar_planrange.ValueChanged | FP00598_Plan_Amend_Model_Elec.cs:7542 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d2081d8 | dCalendar_planrange.ValueChanged | FP00598_Plan_Amend_Model_Elec.cs:7549 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-258fddb9 | dCalendar_planrange.ValueChanged | FP00598_Plan_Amend_Model_Elec.cs:7550 | if (dayCount > 366) | UI_PROP | dCalendar_planrange.Value2 | dCalendar_planrange.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-417b9f35 | DeleteButton | FP00598_Plan_Amend_Model_Elec.cs:1412 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4d07d78 | Dispose | FP00598_Plan_Amend_Model_Elec.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.DrawHeader

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != nul…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-521e101d | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:838 |  | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-7d153d42 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:842 | if (with_day_part == false) | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-abb98366 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:843 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3e5275a | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:844 | if (with_day_part == false) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42794e8b | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:845 | if (with_day_part == false) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0293b978 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:846 | if (with_day_part == false) | FLAG | DayColumnCount | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-540ce803 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:850 | else of (with_day_part == false) | FLAG | calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-c458bb1e | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:851 | else of (with_day_part == false) | UI_PROP | calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-2a829dea | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:852 | else of (with_day_part == false) | UI_PROP | calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-cdceb722 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:853 | else of (with_day_part == false) | UI_PROP | calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-014f913a | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:867 | else of (with_day_part == false) | FLAG | DayColumnCount | calendar.GetColumnCount(use_month, use_week, use_day) | 화면 필드/플래그 변경 |  |  |  |
| AC-37255468 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:868 | else of (with_day_part == false) | CALL_EXT | calendar.GetStartDate | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a704bc25 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:874 | else of (with_day_part == false) ▸ if (sdate != measure.StartDate) | VALUE_SET | measure.StartDate | sdate | 컨트롤 값 설정 |  |  |  |
| AC-a634ace0 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:903 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | MeasureService.LoadAmendColumn | (measure, calendar, SpdSheet.PROGID + "_" + SpdSheet.shtPlanAmendMA, appendix) | ⚠ 의미 확인 필요 |  |  |  |
| AC-550919bb | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:909 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetAmendHeaderColumn_FP | (measure.AmendColumns, calendar, use_month, use_week, use_day, 2, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1e19966 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:911 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (0, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d36be0b4 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:912 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_INIT | siMain.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cb61b74 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:913 | else of (with_day_part == false) ▸ if (refreshColumn) | FLAG | last_col | siMain.GetMaxColumnIndex() | 화면 필드/플래그 변경 |  |  |  |
| AC-12bfff73 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:915 | else of (with_day_part == false) ▸ if (refreshColumn) | GRID_SET | siMain.ActiveSheet.FrozenColumnCount | last_col - DayColumnCount + 1 | 그리드 속성/값 설정 |  |  |  |
| AC-cb282ab3 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:917 | else of (with_day_part == false) ▸ if (refreshColumn) | UI_PROP | siMain.MergeVerticalAlignment | CellVerticalAlignment.Top | 속성 MergeVerticalAlignment 설정 |  |  |  |
| AC-4aba2b75 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:918 | else of (with_day_part == false) ▸ if (refreshColumn) | CALL_EXT | siMain.SetRightMerge | (siMain.ActiveSheet.FrozenColumnCount) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.DrawSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a95cdd8e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:927 | if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-99196936 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:930 | if (!in_Dataset.Good()) | CALL_EXT | siMain.EditQuery | (in_Dataset) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90ca70a5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:931 | if (!in_Dataset.Good()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c684cc98 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:940 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e624e7f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:946 | if (dsMainFiltered.Good()) ▸ if (!siMain.SpreadObject.IsLayoutSuspended) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b4b56c35 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:952 | if (dsMainFiltered.Good()) | CALL_EXT | MemoService.ShowMemo | (siMain, calendar, dsMainFiltered, dsMemoInfo, measure, Filter, DAY_SUFFIX, dtCategoryInfo… | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.ds_List01_cancolumnchange

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (clicked_row != null)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7d35a30 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6211 | if (clicked_row == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ee7401d3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6213 | if (clicked_row["CATEGORY_ID"].ToString() == "SIM_SETUP") | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-ceb17944 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6220 | if (bM != -1 && bC != -1 && bJ != -1) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e89b1ee1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6222 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b7426b1 | EditButton | FP00598_Plan_Amend_Model_Elec.cs:1420 | if (spdMain != null) | MESSAGE | MessageBox.Show | ("You already in edit mode.\r\n(In Plan Amend screen,You always in edit mode while you hav… | 메시지 표시 |  |  |  |
| AC-8950c03a | EditButton | FP00598_Plan_Amend_Model_Elec.cs:1422 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.EditByChange

진입점: this.spdMain.Change [if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acde0387 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6230 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a334a156 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6231 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6a8d6e0 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6232 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-3aae554c | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6234 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bafa2f1d | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6246 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-db7dac39 | this.spdMain.Change [if (siMain.ActiveSheet.SheetName == Spd… | FP00598_Plan_Amend_Model_Elec.cs:6247 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.EditByClipboard

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45aeb74e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6288 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2520cd70 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6289 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-87b2c6b5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6290 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-43181cdd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6292 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7630f5ab | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6300 | if (must_zero_over && new_value < 0) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _old_value_of_cell | 그리드 속성/값 설정 |  |  |  |
| AC-b6074fb0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6301 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-406e99e7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6306 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.EditByFunc

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f4de1f9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6257 | if (cCol < 0 \|\| cRow < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0fc50bdf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6259 |  | FLAG | ColumnName_Buf | siMain.GetColumnTag(cCol) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6bfb354 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6260 |  | FLAG | clicked_row | dsMainFiltered.Tables[0].Rows[cRow] | 화면 필드/플래그 변경 |  |  |  |
| AC-849a50ab | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6262 | if (clicked_row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1566e314 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6272 | if (must_zero_over && new_value < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd867bbe | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6278 | if (new_value == org_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d781d5b8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6280 |  | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | _new_value_function_edit | 그리드 속성/값 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Excel_Export

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83c87cf4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2993 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-401ae208 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2948 |  | POPUP | new FPC0109_ExcelSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a61f7074 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2949 |  | VALUE_SET | select_popup.Text | "SELECT Excel Export Option" | 컨트롤 값 설정 |  |  |  |
| AC-8a4c2a8c | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2951 |  | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c79cad46 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2955 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Merge | select_popup.MergeSelection | 속성 Merge 설정 |  |  |  |
| AC-0ad991ad | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2956 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.Border | select_popup.LineSelection | 속성 Border 설정 |  |  |  |
| AC-0d1cf173 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2957 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendZeroOption | select_popup.ZeroSelection | 속성 AmendZeroOption 설정 |  |  |  |
| AC-ffb3fa45 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2960 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-46606f86 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2961 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-887852de | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2962 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-32c6a9dd | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2964 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-5625a714 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2965 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-df6a5236 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2967 | if (select_popup.ShowDialog() == DialogResult.OK) | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.##########;[red]-#,##0.##########" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-cf8a8509 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2974 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-821fdb75 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2978 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-38094952 | ExcelButton | FP00598_Plan_Amend_Model_Elec.cs:2982 | if (select_popup.ShowDialog() == DialogResult.OK) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_carryOver

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-380f1eff | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3517 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7b1279 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3518 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e340c80 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3519 |  | DATA_OP | Filter2["ITEM_NAME"] | Filter["ITEM_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-e8025206 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3520 |  | DATA_OP | Filter2["ITEMNAME_ID"] | Filter["ITEM_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-ddba090c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3521 |  | DATA_OP | Filter2["PRODTYPE_ID"] | Filter["PRODTYPE_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-255ec9f6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3522 |  | DATA_OP | Filter2["NICKNAME_ID"] | Filter["NICKNAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-6dfabe8e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3532 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEM", "AND A.ITEM_ID ", "AND A.ITEM_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-332f3097 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3533 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEMNAME", "AND B.NICK_NAME", "AND B.NICK_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ffa31ce | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3535 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_carryOver", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_carryOver] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b69b5e11 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3536 |  | RETURN | return dsCarry; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Find_Data_Amend

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER")] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTot…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b32d2ccd | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3573 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = ""; })) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d50fe258 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3575 | try ▸ lambda | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-0130a4f4 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3587 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-c2d1e13a | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3589 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { txtPlanId.Text = Filter["FP_PLAN_ID"] = Filter["PLAN_ID"]… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ac7c289 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3591 | try ▸ lambda | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] = Filter["PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-c25280a4 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3591 | try ▸ lambda | DATA_OP | Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9393c299 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3600 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-308a62a4 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3606 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_ListData

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dbd5f3d | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3484 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-299732f4 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3493 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_ListData", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ListData] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-711a323a | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3494 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_Prod_Version_Type

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14f52a3d | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3506 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e130c453 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3511 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_Prod_Version_Type", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Prod_Version_Type] \| FP\P… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f767d2d5 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3512 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_UOMInfo

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7414778 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3464 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7cae5de1 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3473 | if (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo] \| FP\Planning\FP… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-958786d7 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3474 | if (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |
| AC-0dec1869 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3478 | else of (sVERSION_YN == "Y") | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_UOMInfo_ASIS", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_UOMInfo_ASIS] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e208dd65 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3479 | else of (sVERSION_YN == "Y") | RETURN | return uomInfo; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_version_data

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0ce52a3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4572 |  | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", clicked_row["PRODUCTION_TYPE"].ToString(), "VERSION_TYPE_1") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7948a0c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4588 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f69e1cd0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4604 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsVersionType.Tables[0].Lookup | ("PRODUCTION_TYPE", prodtype, sTxt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5147082 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4615 | if (nExcRow == -1) ▸ while (nCycleTmp < nCycle) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e490518e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4634 | if (nExcRow == -1) | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e315e27c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4637 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_versionType

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ff9fec9 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3499 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6f7c74 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3501 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_versionType", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_versionType] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4d6c408c | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3502 |  | RETURN | return dsListData2; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Find_YieldInfo_All

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fcd83d40 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:6165 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-85803e04 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:6166 |  | DATA_OP | Filter2["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-57dbf191 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:6167 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_yieldInfo_ALL", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo_ALL] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-d8182ad9 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:6168 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.find_YieldInfo_Child

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try ▸ lambda] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try ▸ lambda] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResu…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f2eb948 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3448 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ddcb0ec3 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3456 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEM", "AND A.ITEM_ID ", "AND A.ITEM_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-91492c47 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3458 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_YieldInfo_Child", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YieldInfo_Child] \| FP\Pla… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-5d70d984 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3459 |  | RETURN | return dsListData; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.FindBaseData

진입점: popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3fa0d1af | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3541 |  | FLAG | dsListData | find_ListData(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7d2fb7af | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3544 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | dsListData.Tables[0].Select | ("RELEASE_TYPE='MPP' OR RELEASE_TYPE='WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-75f7be54 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3551 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { dgEdit.DataSource = dsListData.Tables[0]; dsUOMInfo = fin… | ⚠ 의미 확인 필요 |  |  |  |
| AC-40444004 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3553 | lambda | LIST_BIND | dgEdit.DataSource | dsListData.Tables[0] | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-643e79fc | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3554 | lambda | FLAG | dsUOMInfo | find_UOMInfo(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f837832 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3555 | lambda | FLAG | dsYieldInfoChild | find_YieldInfo_Child(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9cc50112 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3556 | lambda | FLAG | dsYieldChild | AmendService.FindYieldInfoChild(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ae6356cc | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3556 | lambda | CALL_EXT | AmendService.FindYieldInfoChild | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e04d0aa3 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3557 | lambda | FLAG | dsProdVersionType | find_Prod_Version_Type(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-51790f72 | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3558 | lambda | FLAG | dsVersionType | find_versionType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a6f6b8f | popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_… 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3559 | lambda | FLAG | dsYieldAll | Find_YieldInfo_All(Filter) | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.findLineCode_List

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a761672 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:459 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7782336c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:460 |  | DATA_OP | LocalFilter["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-cd528602 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:476 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3aeacfe3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:494 | if (sInst != "" && sInst != null) | DATA_OP | LocalFilter["CTRL_INSTANCE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-b4d3d4e6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:499 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5675c571 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:512 |  | DATA_OP | LocalFilter["CTRL_PLAN_TYPE"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-76f9d3b4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:514 |  | DATA_OP | LocalFilter["ALL_LINE"] | chk_all_line.Checked ? "Y" : "N" | 행/컬럼 값 대입 |  |  |  |
| AC-94f371fc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:515 |  | DATA_OP | LocalFilter["CTRL_LINE_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-91af4169 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:529 | if (LocalFilter["ALL_LINE"] != "Y") | DATA_OP | LocalFilter["CTRL_LINE_LT"] | sql | 행/컬럼 값 대입 |  |  |  |
| AC-d025b0a4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:532 |  | FLAG | dtLine | DataService.FP_ExecuteQuery2("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 화면 필드/플래그 변경 |  |  |  |
| AC-2609288a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:532 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findLineCode_List", LocalFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineCode_List] \| FP\Planni… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a50a8da5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:533 |  | RETURN | return dtLine; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.FindSubTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00e91974 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1047 |  | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.FindTotalColorStart

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a76f0002 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1035 | if (op > -1) | RETURN | return op + 1; |  | 처리 중단/반환 |  |  |  |
| AC-51072808 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1042 |  | RETURN | return start + 1; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.FindTotalValue

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else o…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e656306 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3402 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1c76e077 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3403 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-2a760201 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3404 |  | DATA_OP | Filter2["ITEM_NAME"] | Filter["ITEM_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-1bbb6fed | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3405 |  | DATA_OP | Filter2["ITEMNAME_ID"] | Filter["ITEM_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-12900890 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3406 |  | DATA_OP | Filter2["PRODTYPE_ID"] | Filter["PRODTYPE_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-6f03de23 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3407 |  | DATA_OP | Filter2["NICKNAME_ID"] | Filter["NICKNAME_LT"] | 행/컬럼 값 대입 |  |  |  |
| AC-74677bda | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3408 |  | DATA_OP | Filter2["CTRL_PRODUCTION_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0c5ef77e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3411 | if (Filter["PROD_TYPE"] != "") | DATA_OP | Filter2["CTRL_PRODUCTION_TYPE"] | "AND A.PRODUCTION_TYPE = '" + Filter["PROD_TYPE"] + "'" | 행/컬럼 값 대입 |  |  |  |
| AC-a7deb424 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3422 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEM", "AND A.ITEM_ID ", "AND A.ITEM_ID") | ⚠ 의미 확인 필요 |  |  |  |
| AC-90f07a7c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3423 |  | CALL_EXT | DataService.LkTool | (Filter2, "CTRL_", "ITEMNAME", "AND B.NICK_NAME", "AND B.NICK_NAME") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea3430c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3425 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00598_carryOver", "find_totalValue", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_totalValue] \| FP\Planning… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-51b9fdf2 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:3426 |  | RETURN | return dsCarry; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.FindYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ff0ecef | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6173 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-76b0fd51 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6175 |  | DATA_OP | Filter2["DIVISION_ID"] | Filter["DIVISION_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7555ec31 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6176 |  | DATA_OP | Filter2["SITE_ID"] | Filter["SITE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-8b1f51aa | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6177 |  | DATA_OP | Filter2["PLANT_ID"] | Filter["PLANT_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b164ccd5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6178 |  | DATA_OP | Filter2["FACTORY_ID"] | Filter["FACTORY_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-aa0e480a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6180 |  | DATA_OP | Filter2["OPERATION_ID"] | "E2000" | 행/컬럼 값 대입 |  |  |  |
| AC-181c403b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6181 |  | DATA_OP | Filter2["LINE_ID"] | Filter["LINE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e183556e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6182 |  | DATA_OP | Filter2["ITEM_ID"] | Filter["ITEM_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c907ff79 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6183 |  | DATA_OP | Filter2["PLAN_DATE"] | yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ca4d31ee | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6184 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_ROW", "find_yieldInfo", Filter2.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yieldInfo] \| FP\Planning\… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-e9b8c50d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6190 | if (ret.Good()) ▸ if (cell_rate > 0) | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |
| AC-4d560616 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6192 |  | RETURN | return cell_rate; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3c991e | this.Load | FP00598_Plan_Amend_Model_Elec.cs:214 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetAmendTable

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.Dia…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb3ba005 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3096 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_H" | 행/컬럼 값 대입 |  |  |  |
| AC-404713b8 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3097 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_H" | 행/컬럼 값 대입 |  |  |  |
| AC-d33808ac | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3098 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_H" | 행/컬럼 값 대입 |  |  |  |
| AC-4a248bac | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3099 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_H" | 행/컬럼 값 대입 |  |  |  |
| AC-9e142d09 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3100 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_H" | 행/컬럼 값 대입 |  |  |  |
| AC-c79453d9 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3101 | if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_H" | 행/컬럼 값 대입 |  |  |  |
| AC-6f4ae7ad | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3105 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_TABLE"] | "FP_AMEND_DAILY_PLAN_R" | 행/컬럼 값 대입 |  |  |  |
| AC-2b708010 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3106 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-182ceae5 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3107 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_BOR_TABLE"] | "FP_AMEND_DAILY_BOR_R" | 행/컬럼 값 대입 |  |  |  |
| AC-291a7ac9 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3108 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_SALES_TABLE"] | "FP_AMEND_DAILY_SALES_R" | 행/컬럼 값 대입 |  |  |  |
| AC-8e9a1c97 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3109 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_UTIL_TABLE"] | "FP_AMEND_DAILY_UTIL_R" | 행/컬럼 값 대입 |  |  |  |
| AC-9aa0d01a | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3110 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["AMEND_CAPA_TABLE"] | "FP_AMEND_DAILY_CAPA_R" | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetBasisTime

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e18f259 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:260 |  | FLAG | dtPeriod | DataService.FP_ExecuteProcedure2(("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime")… | 화면 필드/플래그 변경 |  |  |  |
| AC-cb2d2eca | this.Load | FP00598_Plan_Amend_Model_Elec.cs:260 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "pr_amend_planamend" + "_" + "findBasisTime").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetFilter

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else o…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83fe8f63 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 8 | FP00598_Plan_Amend_Model_Elec.cs:3071 |  | RETURN | return Filter[key]; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetFpPlanId

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / sCalendar_planday.ValueChanged / this.cbo_fpplanid.DropDown / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b40e8975 | this.Load 외 4 | FP00598_Plan_Amend_Model_Elec.cs:3220 |  | FLAG | dtPlanId | DataService.FP_ExecuteProcedure2(("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(… | 화면 필드/플래그 변경 |  |  |  |
| AC-48b38f66 | this.Load 외 4 | FP00598_Plan_Amend_Model_Elec.cs:3220 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | (("PR_UI_" + "FP00602" + "_" + "findFpPlan_info").ToUpper(), Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-345c57b1 | this.Load 외 4 | FP00598_Plan_Amend_Model_Elec.cs:3222 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanId, cbo_fpplanid, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetMppWpp

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caaae2ab | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2197 | if (!ds.Good()) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-957cfaa7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2207 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7dfd907a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2208 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("COMPANY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b358845 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2209 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fbdacd4c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2210 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4577e896 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2211 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf54a655 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2212 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6e89dc8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2213 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-4eb1c82d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2214 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-35ec346a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2215 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8c89da8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2216 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d157d5f1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2217 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f30facc | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2218 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("TOP_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4dd0bdbf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2219 | if (clicked_row != null) ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-16629268 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2205 | if (clicked_row != null) ▸ lambda | RETURN | return ( x.Field<string>("DIVISION_ID") == clicked_row["DIVISION_ID"].ToString()… |  | 처리 중단/반환 |  |  |  |
| AC-017516af | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2235 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_M_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-4d987ac5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2238 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "M_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_M_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-f6ed6074 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2243 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ if (cell_uom == "CELL") | DATA_OP | ret[order_W_OUT_CELL] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-fd83c618 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2245 | if (clicked_row != null) ▸ foreach (DataRow related_row in relating_rows) ▸ switch (category_id) case "W_OUT": ▸ else of (cell_uom == "CELL"… | DATA_OP | ret[order_W_OUT] | related_row | 행/컬럼 값 대입 |  |  |  |
| AC-2525cc5b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2250 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetNickName

진입점: this.Load / mcbo_line.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58dfa725 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3117 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e17c3395 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3123 |  | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-0a24acbf | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3131 |  | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-66046662 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3132 |  | DATA_OP | Filter2["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dc1d1beb | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3133 |  | DATA_OP | Filter2["CTRL_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-05693e6d | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3134 |  | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c8b315d2 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3136 | if (Filter2["PROD_TYPE"] == "") | DATA_OP | Filter2["PROD_TYPE"] | Filter2["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-661ab185 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3138 | if (Filter2["TOP_ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | " AND A.TOP_ITEM_ID LIKE '%' + @TOP_ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-b84b535b | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3140 | if (Filter2["ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_ITEM_ID"] | " AND A.ITEM_ID LIKE '%' + @ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetPlanDate

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39238fba | this.Load | FP00598_Plan_Amend_Model_Elec.cs:280 |  | UI_PROP | dCalendar_planrange.Value1 | start | 속성 Value1 설정 |  |  |  |
| AC-7864df73 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:281 |  | UI_PROP | dCalendar_planrange.Value2 | end | 속성 Value2 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd551eee | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3167 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7c80aade | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3168 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-102c08b2 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3168 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9c12c83d | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3170 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-b48e70b9 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3171 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cbo_plan_group, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a4c9ad94 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3174 | if (cbo_plan_group.Items.Count > 0) | VALUE_SET | cbo_plan_group.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-475d7b12 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3175 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValu… | 행/컬럼 값 대입 |  |  |  |
| AC-4d4aea4d | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3175 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cbo_plan_group.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-8388a068 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3176 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-28b2a0f6 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3177 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0af1a9f2 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3178 | if (cbo_plan_group.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cbo_plan_group.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-249e2687 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:3182 | else of (cbo_plan_group.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetPlanner

진입점: this.Load / cbo_plan_group.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddc71b02 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3160 |  | FLAG | dtPlanner | DataService.FP_ExecuteQuery2("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planni… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 화면 필드/플래그 변경 |  |  |  |
| AC-8cacb529 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3160 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "findPlanner_List", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findPlanner_List] \| FP\Plannin… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1a9a395f | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3161 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanner, mcbo_planner, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetPrevDXColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5420dace | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7098 | else of (prev_col.StartsWith("W")) ▸ else of (prev_col.StartsWith("D") && !prev_col.StartsWith("DA")) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-8dd86e91 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:7099 |  | RETURN | return prev_col_index; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetProdType

진입점: this.Load / mcbo_plant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1cdfa19 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3280 |  | FLAG | dtProdType | DataService.GetProdType(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ee8fab77 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3280 |  | CALL_EXT | DataService.GetProdType | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6c79d506 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:3281 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, mcbo_prodtype, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GetRoundPoint

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / popSql.OnSql [if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ lambda ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.Dia…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf9f532f | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3075 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595_ROW", "find_getRoundPoint", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_getRoundPoint] \| FP\Plann… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f0e21901 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3078 | if (dtRound.Good()) | FLAG | RoundPoint | dtRound.Rows[0][0].SafeZeroInt() | 화면 필드/플래그 변경 |  |  |  |
| AC-84b4647a | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3080 | if (dtRound.Good()) ▸ if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-c7109a44 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3081 | if (dtRound.Good()) | FLAG | RoundTen | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-5249ade3 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3085 | if (dtRound.Good()) ▸ while (rwork > 0) | FLAG | RoundTen | *= 10 | 화면 필드/플래그 변경 |  |  |  |
| AC-8cc65f92 | this.Load 외 10 | FP00598_Plan_Amend_Model_Elec.cs:3089 |  | DATA_OP | Filter["ROUND_POINT"] | string.Format("{0}", RoundPoint) | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.gfn_Msg

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c5f73ce | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3294 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GoDrawCellColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06e06dac | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1428 | if (string.IsNullOrWhiteSpace(color_appendix)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24084b61 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1462 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | CALL_EXT | FPExtensions.ColorFromName | (bgColor) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c38de5b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1463 | if (current_src != null && calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ if (calendar.Days != null) ▸ foreach (var day_it… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, index, rowindex, index, bg) | 그리드 표시 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.GoEditMode

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76fe846b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1559 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolnames[k] | day.Value + appendix | 행/컬럼 값 대입 |  |  |  |
| AC-31264935 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1560 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | DATA_OP | daycolidxs[k] | siMain.GetColumnIndex(day.Value + appendix) | 행/컬럼 값 대입 |  |  |  |
| AC-a1431104 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1594 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-16f9fe1f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1595 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-7bb963f0 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1619 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | CALL_EXT | siMain.LockRangeNoColor | (rowindex, colindex, rowindex, colindex, false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b25f7e80 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1651 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-2778bfe2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1676 | if (do_edit_mode) ▸ if (current_src != null) ▸ if (calendar != null && calendar.Days != null && calendar.Days.Count > 0) ▸ foreach (AmendDat… | GRID_STYLE | siMain.SetBGColor3 | (rowindex, colindex, rowindex, colindex, Color.White) | 그리드 표시 설정 |  |  |  |
| AC-51f426de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1691 | if (do_edit_mode) ▸ if (current_src != null) | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitAmendModelELec

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8f07961 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:228 |  | DATA_OP | Filter["AMEND_INSTANCE"] | lv_amendInstance | 행/컬럼 값 대입 |  |  |  |
| AC-e4ecc106 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:229 |  | DATA_OP | Filter["PLAN_DATE"] | DateUtil_FP.gfn_today() | 행/컬럼 값 대입 |  |  |  |
| AC-b8e5a47b | this.Load | FP00598_Plan_Amend_Model_Elec.cs:229 |  | CALL_EXT | DateUtil_FP.gfn_today | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e581378 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:230 |  | DATA_OP | Filter["AMEND_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-5cef0637 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:231 |  | DATA_OP | Filter["ALL_LINE"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-00ad4128 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:232 |  | DATA_OP | Filter["AMEND_MAIN_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-c1c8736c | this.Load | FP00598_Plan_Amend_Model_Elec.cs:233 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitControlFilter

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-847c755d | this.Load | FP00598_Plan_Amend_Model_Elec.cs:292 |  | VALUE_SET | sCalendar_planday.DateTime | DateTime.Now | 컨트롤 값 설정 |  |  |  |
| AC-056cde80 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:293 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.DateTime.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-beb6e067 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:311 |  | DATA_OP | Filter["BUCKET_FROM"] | dCalendar_planrange.Value1.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-cd2c9343 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:313 |  | DATA_OP | Filter["BUCKET_TO"] | dCalendar_planrange.Value2.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |
| AC-e277bdab | this.Load | FP00598_Plan_Amend_Model_Elec.cs:327 |  | VALUE_SET | chk_omit_zero.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-668d4945 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:328 |  | DATA_OP | Filter["OMIT_ZERO"] | "Y" | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e905acf | this.Load | FP00598_Plan_Amend_Model_Elec.cs:239 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b58346b0 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:242 | try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c3ee0606 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:244 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-2320dda5 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:245 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-4becf82a | this.Load | FP00598_Plan_Amend_Model_Elec.cs:249 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitEditingBuf

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa7beeeb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:6153 |  | FLAG | clicked_row | null | 화면 필드/플래그 변경 |  |  |  |
| AC-dd72046d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:6155 |  | FLAG | EditingCol | -1 | 화면 필드/플래그 변경 |  |  |  |
| AC-3e98682d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:6156 |  | FLAG | ColumnName_Buf | "" | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2160266a | this.Load | FP00598_Plan_Amend_Model_Elec.cs:412 |  | UI_PROP | mcbo_line.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-60e69564 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:413 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d085ee0c | this.Load | FP00598_Plan_Amend_Model_Elec.cs:414 |  | UI_PROP | mcbo_prodtype.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-c57aeff4 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:415 |  | UI_PROP | mcbo_operation.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7d820758 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:416 |  | UI_PROP | mcbo_factory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-5a19fd94 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:417 |  | UI_PROP | mcbo_plant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d8d6d755 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:418 |  | UI_PROP | mcbo_planner.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8cc4d89c | this.Load | FP00598_Plan_Amend_Model_Elec.cs:419 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InitSpread

진입점: this.Load / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e80faa8b | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:553 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3133dc96 | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:554 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtPlanAmendMA) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e0e8ee2c | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:556 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ed8a147d | this.Load 외 12 | FP00598_Plan_Amend_Model_Elec.cs:560 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7fffd75 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1364 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-ca27c416 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1365 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3e8e55cd | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1371 |  | DATA_OP | siMain.GetBindingRow | (siMain.ActiveRowIndex) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-64908a1d | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1376 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | MESSAGE | MessageBox.Show | ("Please select row with model first") | 메시지 표시 |  |  |  |
| AC-35160574 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1377 | if (row != null) ▸ if (row["TOP_ITEM_ID"].ToString().ToUpper() == "TOTAL") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d4739e1 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1379 | if (row != null) | POPUP | new FP00595_LineAddPopup | (row) | 팝업/폼 생성 |  |  |  |
| AC-5c75c9b4 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1381 | if (row != null) | UI_PROP | popup.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-01dfa8ae | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1381 | if (row != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33760f35 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1382 | if (row != null) | UI_PROP | popup.dsUOMInfo | dsUOMInfo | 속성 dsUOMInfo 설정 |  |  |  |
| AC-7cbf6ea2 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1383 | if (row != null) | UI_PROP | popup.dsVersionType | dsVersionType | 속성 dsVersionType 설정 |  |  |  |
| AC-89597ec6 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1384 | if (row != null) | UI_PROP | popup.dsYieldChild | dsYieldChild | 속성 dsYieldChild 설정 |  |  |  |
| AC-9a5aef58 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1386 | if (row != null) | DATA_OP | popup.Filter["DIVISION_ID"] | row["DIVISION_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-580eb10f | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1387 | if (row != null) | DATA_OP | popup.Filter["SITE_ID"] | row["SITE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c363094a | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1388 | if (row != null) | DATA_OP | popup.Filter["PLANT_ID"] | row["PLANT_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cf74f31a | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1392 | if (row != null) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ab64750b | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1393 | if (row != null) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a2d50734 | InsertButton | FP00598_Plan_Amend_Model_Elec.cs:1404 | else of (row != null) | MESSAGE | MessageBox.Show | ("You must select a line first") | 메시지 표시 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f4bcaf5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3042 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00598_Plan_Amend_Model_Elec.IsEmpty

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9cf6798 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4224 | if (value == null) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-241dca20 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4226 | if (value is string && string.IsNullOrWhiteSpace((string)value)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-eeaf987d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4228 | if (value is DBNull) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-21d087d3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4229 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.IsNumber

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65c16665 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4234 | if (value == null) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0a9af9ca | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4236 | if (value is decimal) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-207b6e6b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4238 | if (value is double) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-493b1f4a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4240 | if (value is Int16) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-75bae397 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4242 | if (value is Int32) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5332f5d2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4244 | if (value is Int64) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-754f2f59 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4246 | if (value is float) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-0f92145a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4250 | if (value is string) ▸ if (string.IsNullOrWhiteSpace((string)value)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5290b831 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4253 | if (value is string) | RETURN | return result; |  | 처리 중단/반환 |  |  |  |
| AC-f7377d86 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4255 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_getExchangeBatch_Validation

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M") ▸ if (clicked_row != null)] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-376dedde | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7017 | switch (cate) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-7f332a4f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7028 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-e8279153 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7029 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcd3a612 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7030 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d10b00b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7031 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bcb51ade | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7032 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1a88826 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7033 | if (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-fb83166d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7026 | if (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-633ea93d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7043 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-f58bc299 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7044 | if (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-c8255f50 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7046 | if (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-232ad6bf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7056 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-78ac7b63 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7057 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("OPERATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-91ff4069 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7058 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b00abd22 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7059 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("CATEGORY") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee45c3a6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7060 | else of (sVERSION_YN == "Y") ▸ lambda | DATA_OP | x.Field | ("PROD_VERSION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f466b32d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7054 | else of (sVERSION_YN == "Y") ▸ lambda | RETURN | return ( x.Field<string>("FACTORY_ID") == clicked_row["FACTORY_ID"].ToString() &… |  | 처리 중단/반환 |  |  |  |
| AC-a33a0bb8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7070 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) ▸ if (pancake_d < 0) | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |
| AC-1a07c2ed | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7071 | else of (sVERSION_YN == "Y") ▸ if (pancake_r != null && pancake_r.Count() > 0) | RETURN | return pancake_d; |  | 처리 중단/반환 |  |  |  |
| AC-be527672 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7073 | else of (sVERSION_YN == "Y") | RETURN | return -1; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_getYieldInfo

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f9cd992 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6197 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3b456902 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6198 |  | DATA_OP | yf["LINE_ID"] | clicked_row["LINE_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-932eed40 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6199 |  | DATA_OP | yf["ITEM_ID"] | clicked_row["ITEM_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-71996cb7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6200 |  | DATA_OP | yf["FACTORY_ID"] | clicked_row["FACTORY_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61962bc1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6202 |  | FLAG | YieldRate | FindYieldInfo(yf, yyyymmdd) | 화면 필드/플래그 변경 |  |  |  |
| AC-02d8f37d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6202 |  | RETURN | return YieldRate = FindYieldInfo(yf, yyyymmdd); |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_setExchangeBatch

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd8879f8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6832 | switch (sType) default: | RETURN | return 0; |  | 처리 중단/반환 |  |  |  |
| AC-01feb1a2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6871 |  | CALL_EXT | dsYieldChild.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-413a97c7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6876 | else of (nExcRow == -1) | DATA_OP | dsYieldChild.Tables[0].getColumn | (nExcRow, "CHILD_YIELD") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dab7376e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6883 |  | RETURN | return (int)nRtnVal; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_setExchangeBatch_Detail

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b5c26f5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6902 |  | CALL_EXT | dsUOMInfo.Tables[0].FindRowExpr | (sExpr) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7271090 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:7000 |  | RETURN | return nExcRow; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_settingValid

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97bf6ccd | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4277 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) | DATA_OP | row.Table.Columns.Contains | (sQtyCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-02052a6a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4283 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sMCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5eec99f6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4284 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sCellCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-d6f4ea36 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4285 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sJRCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8564b31a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4286 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sQtyCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c51fe234 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4287 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ if (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSeqCol]… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2a6fa518 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4351 | foreach (KeyValuePair<string, AmendDate> each_day in calendar.Days) ▸ if (aDate != null) ▸ else of (IsEmpty(row[sQtyCol]) && IsEmpty(row[sSe… | DATA_OP | row[sSeqCol] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-58c0c56b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4363 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-d90ca4e0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4364 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-b1318087 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4367 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-9e6c9db9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4369 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6e4f3fb7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4370 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.lfn_settingValidRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9d08495 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3952 | else of (!IsNumber(row[sQtyCol])) | DATA_OP | row[sQtyCol] | x | 행/컬럼 값 대입 |  |  |  |
| AC-225d65c7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3984 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["_MSG"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-3b61c196 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3985 | if (!string.IsNullOrWhiteSpace(total_message)) | DATA_OP | row["MESSAGE"] | total_message.Substring(1) | 행/컬럼 값 대입 |  |  |  |
| AC-88af66fb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3988 | if (!valid) | DATA_OP | row["_VALID"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-454e5c92 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3990 | else of (!valid) | DATA_OP | row["_VALID"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-07eb7599 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3991 |  | RETURN | return valid; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.MakeMemoBold

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31d672e6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:813 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(acell.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-ca8a46ec | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:817 | if (calendar != null && dsMainFiltered.Good()) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (row_count > 0 && colinde… | UI_PROP | acell.Font | new System.Drawing.Font(siMain.SpreadObject.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.mcbo_planner_changed

진입점: this.Load / mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20723151 | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7338 | if (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-42acda2c | this.Load 외 1 | FP00598_Plan_Amend_Model_Elec.cs:7340 | else of (!dtPlanner.Good()) | VALUE_SET | chk_all_line.Checked | false | 컨트롤 값 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onAlarmMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce08382d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5887 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9ffca2e9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5890 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7962d819 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5894 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { DAY_SUFFIX }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf4222f2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5898 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-1328661c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5898 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c2eccd7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5900 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-d3bedbe6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5901 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-769efdec | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5901 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1e7be1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5902 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-5bc4e5a0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5903 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9298cdf8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5904 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-da760433 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5908 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-da474c2d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5910 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d35b59b3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5915 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onLineChangeMenu

진입점: line_change_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-053be85e | line_change_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5829 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c0214cc | line_change_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5832 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onMemoMenu

진입점: memo_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d69886bf | memo_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5869 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0de9fb62 | memo_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5872 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5ee1266 | memo_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5876 |  | CALL_EXT | calendar.GetDayFromColumn | (siMain.GetColumnTag(arg.Column), new List<string> { "_QTY" }) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onNLFAmendMenu

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb8803f2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6096 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63b8f38d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6099 | if (tag == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f50c3517 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6117 | if (day != null) | POPUP | new FP00602_Nlf_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-7595245b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6118 | if (day != null) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-955b9aa2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6118 | if (day != null) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-848efc51 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6119 | if (day != null) | DATA_OP | frm.Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-17e538db | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6120 | if (day != null) | DATA_OP | frm.Filter["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c128cf7d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6121 | if (day != null) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ecd6f437 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6122 | if (day != null) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onZeroAllMenu

진입점: zero_all_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07a04ce5 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5615 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-99e8e41b | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5618 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2888ca8f | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5622 | if (dsMainFiltered.Good()) | MESSAGE | MessageBox.Show | ("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warn… | 메시지 표시 |  |  |  |
| AC-8cd2f247 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5624 | if (dsMainFiltered.Good()) ▸ if (MessageBox.Show("This will clear all data to zero in screen!\r\nAre you sure to proceed?", "All Zero Warnin… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6dadb19 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5626 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a45c8268 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5627 | if (dsMainFiltered.Good()) | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bea65fea | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5649 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ( "DATA_TYPE='DATA'" ) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d5a2e91 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5682 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH") ▸ for (k < DayColumnCount) | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-11bb0a35 | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5695 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6fb6d57f | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5698 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6b03c03d | zero_all_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5699 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onZeroBucketMenu

진입점: bucke_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d551316c | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5425 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-40c07553 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5428 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da9023d5 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5445 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4578d79 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5446 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-09d3a30a | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5457 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") &&… | DATA_OP | row_to_test["CATEGORY_ID"].ToString().Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-8256caf3 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5484 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a1098a98 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5485 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b5b62afe | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5486 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e5ebf308 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5489 | if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ finally ▸ if (error != null) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-4cf54f03 | bucke_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5495 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onZeroLineMenu

진입점: zero_line_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a13e806 | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5706 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e10a77a | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5709 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ae99d6a7 | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5713 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c2d362dd | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5735 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-cbdfebe6 | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5790 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9f20d98 | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5819 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-585974a3 | zero_line_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5822 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.onZeroMaterialMenu

진입점: zero_mat_menu.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-976131cc | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5502 | if (item == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57129a58 | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5505 | if (row == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b126d8af | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5509 | if (dsMainFiltered.Good()) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-196f8bcb | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5530 | if (dsMainFiltered.Good()) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-e59c7247 | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5574 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == "P_IN_BATCH" \|\| catergory == "P_IN_M" \|\| cat… | DATA_OP | colname.Contains | ("D") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9e05ce6 | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5603 | if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) | DATA_OP | dsMainFiltered.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-73293bca | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5607 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6cb4a2c7 | zero_mat_menu.Click | FP00598_Plan_Amend_Model_Elec.cs:5608 |  | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.OpenAlarmMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (select_popup.Selection == 1) ▸ if (materialRow != null) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST"))] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == 0) ▸ if (s…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199d78de | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9263 | if (day != null) | DATA_OP | prd_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-bf57ba6c | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9263 | if (day != null) | DATA_OP | prd_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0103f76b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9265 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | new FPC0121_AlarmEditPopup | (row, day) | 팝업/폼 생성 |  |  |  |
| AC-d7de6569 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9266 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-18ea6063 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9266 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cde421b8 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9267 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-03f7e16d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9268 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-508854f1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9269 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-22af780b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9273 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7876675d | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9275 | if (day != null) ▸ if (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) ▸ if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-c77f9c43 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9280 | if (day != null) ▸ else of (prd_type.Contains("TEST") \|\| prd_type.Contains("SAMPLE")) | MESSAGE | MessageBox.Show | ("PIC Alarm is suppoted only for SAMPLE, TEST type only") | 메시지 표시 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.OpenLineMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0c458df | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9223 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, true) | 팝업/폼 생성 |  |  |  |
| AC-eb28a6b3 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9224 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-93af3a88 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9225 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-467b7a28 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9225 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9dc18bb7 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9226 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-e3a44519 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9227 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-248c16dc | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9228 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9cd857cd | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9232 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-773e90bf | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9234 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.OpenMaterialMemo

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ else of (memoRow["ITEM_ID"].SafeString() == "-")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a34ef386 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9240 |  | POPUP | new FPC0115_MemoColorEditPopup | (row, date, false) | 팝업/폼 생성 |  |  |  |
| AC-7d0de57e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9241 |  | UI_PROP | frm.Operation | dtOperation | 속성 Operation 설정 |  |  |  |
| AC-9a4f6cca | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9242 |  | UI_PROP | frm.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-dc9257ed | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9242 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b210382 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9243 |  | DATA_OP | frm.Filter["MEMO_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-7d0f3362 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9244 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-83136a86 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9245 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c900bf26 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9249 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2a8230a6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9251 | if (frm.DialogResult == DialogResult.OK) | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.planday_changed

진입점: sCalendar_planday.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b6f872e | sCalendar_planday.ValueChanged | FP00598_Plan_Amend_Model_Elec.cs:7506 |  | DATA_OP | Filter["PLAN_DATE"] | sCalendar_planday.Value.ToString("yyyyMMdd", enUS) | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Query

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null)…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0170aa86 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:971 |  | FLAG | dsMemoInfo | DataService.FP_ExecuteQuery("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 화면 필드/플래그 변경 |  |  |  |
| AC-d8109e0b | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:971 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_memo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_memo] \| FP\Common\AmendMe… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a7a41156 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:972 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendMemo", "list_setup_color_code", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_setup_color_code] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-2581b6b4 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:977 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + d["DIVISION_ID"].SafeStr… | 데이터 객체 조작/조회 |  |  |  |
| AC-6099ae0e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1000 | if (dsSetupColorInfo.Good()) ▸ foreach (DataRow d in dsSetupColorInfo.Tables[0].Rows) ▸ if (fined != null && fined.Length > 0) ▸ for (i < fi… | DATA_OP | m["ATTR1"] | setup_color_code | 행/컬럼 값 대입 |  |  |  |
| AC-175823a1 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1006 |  | FLAG | dtCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 화면 필드/플래그 변경 |  |  |  |
| AC-4f523cb6 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1006 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category] \| FP\Common\PIC… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-782907b5 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1007 |  | FLAG | dtInstanceCategoryInfo | DataService.FP_ExecuteQuery2("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 화면 필드/플래그 변경 |  |  |  |
| AC-6cd09c21 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1007 |  | ENDPOINT | DataService.FP_ExecuteQuery2 | ("PICAlarm", "find_Category_Color", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Category_Color] \| FP\Comm… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1bd87782 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1010 | if (dtCategoryInfo.Good()) | STATE_RESET | dictCategory.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1d78d666 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1017 | if (dtCategoryInfo.Good()) ▸ foreach (DataRow rCate in dtCategoryInfo.Rows) ▸ if (!string.IsNullOrWhiteSpace(key)) | DATA_OP | dictCategory[key] | value | 행/컬럼 값 대입 |  |  |  |
| AC-32255804 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1022 |  | CALL_EXT | MemoService.ApplyMemoText | (data, dsMemoInfo, calendar, dictCategory, MEMO_COLUMN, DAY_SUFFIX) | ⚠ 의미 확인 필요 |  |  |  |
| AC-650bd7ee | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1023 |  | CALL_EXT | siMain.EditQuery | (dsMainFiltered) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a012371 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:1025 |  | CALL_EXT | MemoService.ApplyMemoTag | (siMain, dsMainFiltered, dsMemoInfo, calendar, MEMO_COLUMN, DAY_SUFFIX, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.RefreshHeadAndBody

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f534fd72 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:607 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-65a8a885 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:623 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-724ab91e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:627 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.RefreshSpreadSheet

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good()) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1f6b207 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2937 |  | FLAG | dsMainFiltered | CreateFilterDataSet(dsMain, LastTotalRaw, measure) | 화면 필드/플래그 변경 |  |  |  |
| AC-bb7f9c51 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:2943 | if (maxColumn > 0) | GRID_LOCK | siMain.LockColumn | (0, maxColumn, true) | 그리드 편집 잠금/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.RoundValue

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f02d456 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:8632 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundPoint | 2 | 화면 필드/플래그 변경 |  |  |  |
| AC-2a7ccb11 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:8633 | if (RoundPoint < 1 \|\| RoundPoint > 11) | FLAG | RoundTen | 100 | 화면 필드/플래그 변경 |  |  |  |
| AC-5d4672f6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:8637 | try | CALL_EXT | Math.Truncate | ((double)((decimal)ori * (decimal)RoundTen)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1a40f1a3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:8638 | try | RETURN | return m; |  | 처리 중단/반환 |  |  |  |
| AC-204986d2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:8641 |  | RETURN | return ori; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7a95db8 | popSql.OnSql | FP00598_Plan_Amend_Model_Elec.cs:3395 | if (programID == "PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER") | RETURN | return Find_Data_Amend(false); |  | 처리 중단/반환 |  |  |  |
| AC-8d9ec992 | popSql.OnSql | FP00598_Plan_Amend_Model_Elec.cs:3397 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Save_Data

진입점: SaveButton [try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7249bd1f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:1720 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-81017de7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:1742 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-17818e65 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:1743 | if (blnWork) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-5961249e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:1749 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b1cfc2b7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:1760 | try | CALL_EXT | dt2.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8866b688 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2029 | try ▸ else of (dt.Good()) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-49c2c13d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2030 | try ▸ else of (dt.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b44c8dc1 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2037 | try ▸ if (GetFilter("INSTANCE_ID") == "") | THROW | throw new Exception("Instance ID required"); |  | 예외 발생 |  |  |  |
| AC-108f7c17 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2044 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonCond", "find_AMend_Save_Check", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] \| FP\Co… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-56d87a72 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2048 | try ▸ if (checkSave.Good()) | MESSAGE | MessageBox.Show | ("Save cannot proceed with reason :" + stopType) | 메시지 표시 |  |  |  |
| AC-8e95accf | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2049 | try ▸ if (checkSave.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7e5ac8b5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2055 | try | DATA_OP | BohSet["PLAN_DATE"] | Filter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-867289b7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2056 | try | DATA_OP | BohSet["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cab4d455 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2057 | try | DATA_OP | BohSet["PLAN_ID"] | Filter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-077644e7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2058 | try | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-b7fbf1ee | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2060 | try | FLAG | dsBoh | DataService.FP_ExecuteProcedure("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 화면 필드/플래그 변경 |  |  |  |
| AC-cab06610 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2060 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00599_FIND_LISTDATA_BOH", BohSet) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-cd957e08 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2064 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc373197 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2065 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a4b20a5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2066 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b13b86f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2067 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0da4d7a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2068 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f7caea48 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2070 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a23c8fd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2071 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5262c241 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2072 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2327991a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2073 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d5b9985 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2074 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b3f3857 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2075 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'WPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1c7f8a6e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2076 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Select | ("RELEASE_TYPE = 'MPP'") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bfbf1c9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2077 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e9c9c63 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2078 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | objDs.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b63fe998 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2079 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (wpps, wpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf47eb64 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2080 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | DataService.CopyData | (mpps, mpp) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cd5739f3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2083 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-19eea75c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2084 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-61d5b39d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2085 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-d958df59 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2086 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-da9a5ef5 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2087 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-beae4ee7 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2088 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-cf719777 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2089 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-d6898fa6 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2090 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-51fc4576 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2091 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-a9f3929c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2092 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in wpps) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9b82f05a | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2097 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-914bd252 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2098 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-a1853254 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2099 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-d1df5f37 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2100 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-d1315d81 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2101 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-6312be83 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2102 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-3d82364c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2103 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-3f13cc2e | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2104 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-f7976db3 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2105 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-df149c45 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2106 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ foreach (DataRow row in mpps) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-b427bcbc | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2118 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", mpp) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-58619531 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2119 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (mpp.Good()) | CALL_EXT | DataService.ReadResult | (res) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a3e3356 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2125 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | ENDPOINT | DataService.FP_PseudoBatch2 | ("FP00595_MPPWPP", "merge_data", wpp) ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_data] \| FP\Planning\FP005… | 엔드포인트 호출 |  |  |  |
| AC-5097ba2c | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2126 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (wpp.Good()) | CALL_EXT | DataService.ReadResult | (res2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a033f993 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2154 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr != null && !dr.Success) | THROW | throw new Exception(dr.Message); |  | 예외 발생 |  |  |  |
| AC-c65d8ebd | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2156 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) ▸ if (dr2 != null && !dr2.Success) | THROW | throw new Exception(dr2.Message); |  | 예외 발생 |  |  |  |
| AC-61f70261 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2157 | try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") ▸ else of (success) | THROW | throw new Exception("There is no data to save"); |  | 예외 발생 |  |  |  |
| AC-e2d14301 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2164 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-b038346d | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2165 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.ViewType | ViewType.MODEL | 속성 ViewType 설정 |  |  |  |
| AC-8b455311 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2166 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.SaveType | SaveType.SAVE | 속성 SaveType 설정 |  |  |  |
| AC-7fbdcc16 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2167 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dtSaveData | objDs | 속성 dtSaveData 설정 |  |  |  |
| AC-42f5145f | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2168 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-0442ae64 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2169 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.Filter | Filter | 속성 Filter 설정 |  |  |  |
| AC-c54d0184 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2170 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | UI_PROP | amend.PlanId | GetFilter("FP_PLAN_ID") | 속성 PlanId 설정 |  |  |  |
| AC-2ec562d9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2171 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-02bb6c92 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2172 | try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |
| AC-5f35677b | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2179 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-ce8fe7ad | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2184 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-fd6abff9 | SaveButton [try ▸ if (MessageBox.Show("Do you want to save",… | FP00598_Plan_Amend_Model_Elec.cs:2186 |  | RETURN | return save_result; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.Save_Data_Line

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30f7b7e4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:2254 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6405397 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1704 | if (Filter["DONOTEDIT"] == "Y") | MESSAGE | MessageBox.Show | ("Release Plan Cannot be edited") | 메시지 표시 |  |  |  |
| AC-318cf75b | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1705 | if (Filter["DONOTEDIT"] == "Y") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91bdfe17 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1708 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c20da9c4 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1709 |  | UI_MISC | SaveView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-49cfd87e | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1711 |  | UI_MISC | RestoreView | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-548f56ca | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:1713 |  | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SaveExcelRows

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9184ce0e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4794 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("AmendValidation", "find_save_seq", popupFilter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] \| FP\Common\Ame… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-876de297 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4798 | if (ISRELEASE) ▸ if (nSeq.Good()) | DATA_OP | popupFilter["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-43b3a757 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4801 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("JOB_ORDER", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-52aea5d2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4802 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0b38b91 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4803 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("PLAN_DATE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-93f9586a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4804 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d89bf097 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4805 | if (ISRELEASE) | DATA_OP | data.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a80fe43 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4810 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["JOB_ORDER"] | ii | 그리드 속성/값 설정 |  |  |  |
| AC-dffd47da | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4811 | if (ISRELEASE) ▸ for (ii < data.Tables[0].Rows.Count) | GRID_SET | data.Tables[0].Rows[ii]["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 그리드 속성/값 설정 |  |  |  |
| AC-6edacb10 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4815 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteNonQuery | ("FP00595_MPPWPP", "delete_Excel_buffer", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\P… | 엔드포인트 호출 |  |  |  |
| AC-ea8fb562 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4816 | if (ISRELEASE) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00595_MPPWPP", "insert_Excel_buffer", data, 0, "Planning") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Plann… | 엔드포인트 호출 |  |  |  |
| AC-9246d058 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4818 | if (ISRELEASE) | CALL_EXT | DataService.ReadResult | (dtRes) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6db8414 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4822 | if (ISRELEASE) ▸ if (!dr.Success) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-95dd9b5e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4859 | if (ISRELEASE) | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595_MPPWPP", "find_Excel_buffer_validation", popupFilter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ccf140bf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4865 | if (ISRELEASE) ▸ if (validation.Good()) | CALL_EXT | validation.Tables[0].FindRowExpr | ("_VALID='N'") | ⚠ 의미 확인 필요 |  |  |  |
| AC-2aa8a4c9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4869 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | MESSAGE | MessageBox.Show | ("There are invalid data.", "Error") | 메시지 표시 |  |  |  |
| AC-2a028ea1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4871 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | new FP00602_InvalidExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-99db5121 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4872 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | UI_PROP | popup.ErrorData | validation | 속성 ErrorData 설정 |  |  |  |
| AC-a2514f2b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4873 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-20079d95 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4875 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (rtn > -1) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-38cc8faa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4882 | if (ISRELEASE) ▸ if (validation.Good()) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-36538538 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4884 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (!validation.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | validation.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebd2a2c3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4887 | if (ISRELEASE) ▸ if (validation.Good()) ▸ if (!validation.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in validation.Tables[… | DATA_OP | dr["NEW_SEQ"] | new_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3d849f59 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4892 | if (ISRELEASE) ▸ else of (validation.Good()) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4d7e003d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4900 | if (ISRELEASE) ▸ if (validation.Good()) ▸ foreach (DataRow ro in validation.Tables[0].Rows) ▸ if (ro.RowState == DataRowState.Unchanged) | CALL_EXT | ro.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-17bf2cc9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4912 | if (ISRELEASE) ▸ if (valid == false) | MESSAGE | MessageBox.Show | ("There are invalid data.", "Error") | 메시지 표시 |  |  |  |
| AC-d7235dd9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4915 | if (ISRELEASE) ▸ if (valid == false) | POPUP | new FP00602_InvalidExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-340e5578 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4916 | if (ISRELEASE) ▸ if (valid == false) | UI_PROP | popup.ErrorData | validation | 속성 ErrorData 설정 |  |  |  |
| AC-e473715a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4917 | if (ISRELEASE) ▸ if (valid == false) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-585588b8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4920 | if (ISRELEASE) ▸ if (valid == false) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4015e5b9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4923 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("MPP_WPP", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bcd642a0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4924 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("NEW_SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-029b68f1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4925 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7ddc6e2d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4926 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dbe0a013 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4927 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-03b0a0c3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4928 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("CELL_IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-04a1783e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4929 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ddac315 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4936 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0113d1b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4937 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3d0738e4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4938 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b68a9ac | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4939 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c8aa1a8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4940 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("IN_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8ac1ed0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4942 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_BATCH", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-49197b2c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4943 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_M", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e31be10 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4944 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_CELL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-34335ea4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4945 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY_JR", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d969da62 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4946 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("OUT_QTY", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b1bf632d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4947 | if (ISRELEASE) | DATA_OP | dataLocal.Tables[0].Columns.SafeAdd | ("ROUND_POINT", typeof(decimal)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88583a5f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4953 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["JOB_ORDER"] | i++ | 행/컬럼 값 대입 |  |  |  |
| AC-7656eca9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4954 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["MPP_WPP"] | popupFilter["MPP_WPP"] | 행/컬럼 값 대입 |  |  |  |
| AC-d6383d46 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4955 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["NEW_SEQ"] | popupFilter["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-8d6e93f3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4956 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) | DATA_OP | row["ROUND_POINT"] | Filter["ROUND_POINT"] | 행/컬럼 값 대입 |  |  |  |
| AC-a217abb4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4959 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "WPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-a4a867b2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4960 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_M"] | "WPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-1cd945e8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4961 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "WPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-4b0e3cb8 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4962 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "WPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-a5d79b1d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4963 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-06983678 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4964 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "WPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-5898de39 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4965 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "WPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-429e707a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4966 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "WPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-13b1a6f1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4967 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "WPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-b63a87e0 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4968 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-a8db84da | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4969 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["IN_QTY"] | "WPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-d7757da1 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4970 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (use_wpp) | DATA_OP | row["OUT_QTY"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-aeba2c0e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4976 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_BATCH"] | "MPP_IN_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-d44921ae | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4977 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_M"] | "MPP_IN_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-6df87ab9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4978 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_CELL"] | "MPP_IN_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-a54057d5 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4979 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY_JR"] | "MPP_IN_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-9800cac6 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4980 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-4b013bcf | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4981 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_BATCH"] | "MPP_OUT_QTY_BATCH" | 행/컬럼 값 대입 |  |  |  |
| AC-db07e99d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4982 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_M"] | "MPP_OUT_QTY_M" | 행/컬럼 값 대입 |  |  |  |
| AC-341d1aa3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4983 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_CELL"] | "MPP_OUT_QTY_CELL" | 행/컬럼 값 대입 |  |  |  |
| AC-874ac41b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4984 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY_JR"] | "MPP_OUT_QTY_JR" | 행/컬럼 값 대입 |  |  |  |
| AC-600d0b07 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4985 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-cf07cf45 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4986 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["IN_QTY"] | "MPP_IN_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-335ea685 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4987 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ else of (use_wpp) | DATA_OP | row["OUT_QTY"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-516cd1e2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:4994 | if (ISRELEASE) ▸ foreach (DataRow row in dataLocal.Tables[0].Rows) ▸ if (string.IsNullOrWhiteSpace(qty)) | DATA_OP | row["QTY"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-663e5c54 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5001 | if (ISRELEASE) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cef0995b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5006 | if (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.LINE | 속성 ViewType 설정 |  |  |  |
| AC-ddd384c9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5007 | if (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-61bb2dfb | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5008 | if (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-6589642f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5009 | if (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-23f8782c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5010 | if (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-95ac967e | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5011 | if (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-a7fc746f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5012 | if (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-9c0c9a40 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5015 | if (ISRELEASE) | CALL_EXT | amend.AfterValidation | (amend.dtSaveData.DataSet, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa62a276 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5017 | if (ISRELEASE) | RETURN | return do_save; |  | 처리 중단/반환 |  |  |  |
| AC-1a868ff9 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5022 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_DATE"] | popupFilter["PLAN_DATE"] | 행/컬럼 값 대입 |  |  |  |
| AC-ed5887ae | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5023 | else of (ISRELEASE) | DATA_OP | BohSet["MASTER_ID"] | popupFilter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-23c6eaa3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5024 | else of (ISRELEASE) | DATA_OP | BohSet["PLAN_ID"] | popupFilter["FP_PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-9dfab919 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5025 | else of (ISRELEASE) | DATA_OP | BohSet["AMEND_CUTOFF_BOH_TABLE"] | "FP_AMEND_CUTOFF_BOH_R" | 행/컬럼 값 대입 |  |  |  |
| AC-ed06376b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5028 | else of (ISRELEASE) ▸ if (string.IsNullOrWhiteSpace(popupFilter["FP_PLAN_ID"])) | DATA_OP | BohSet["PLAN_ID"] | data.Tables[0].Rows[0]["FP_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd465d2f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5037 | else of (ISRELEASE) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["WORK_REQUEST_MODEL_ID"] | row["PC_MODEL_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cd0fce27 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5039 | else of (ISRELEASE) ▸ foreach (DataRow row in data.Tables[0].Rows) | DATA_OP | row["QTY"] | row["ADJUST_IN_QTY_BATCH"] | 행/컬럼 값 대입 |  |  |  |
| AC-abf25d2d | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5043 | else of (ISRELEASE) | UI_PROP | amend.ShopType | ShopType.ELEC | 속성 ShopType 설정 |  |  |  |
| AC-94105531 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5044 | else of (ISRELEASE) | UI_PROP | amend.ViewType | ViewType.MODEL | 속성 ViewType 설정 |  |  |  |
| AC-d8fb9401 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5045 | else of (ISRELEASE) | UI_PROP | amend.SaveType | SaveType.EXCEL | 속성 SaveType 설정 |  |  |  |
| AC-3116233c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5046 | else of (ISRELEASE) | UI_PROP | amend.dtSaveData | data.Tables[0] | 속성 dtSaveData 설정 |  |  |  |
| AC-53bc2b61 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5047 | else of (ISRELEASE) | UI_PROP | amend.dsBohData | dsBoh | 속성 dsBohData 설정 |  |  |  |
| AC-11b248e2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5048 | else of (ISRELEASE) | UI_PROP | amend.Filter | popupFilter | 속성 Filter 설정 |  |  |  |
| AC-2e230327 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5049 | else of (ISRELEASE) | UI_PROP | amend.PlanId | popupFilter["FP_PLAN_ID"] | 속성 PlanId 설정 |  |  |  |
| AC-845fc13a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5052 | else of (ISRELEASE) | CALL_EXT | amend.DoAmendValidateAndSave | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-e6752856 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5057 | else of (ISRELEASE) ▸ if (do_save) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-5585c93f | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5063 | else of (ISRELEASE) ▸ else of (do_save) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SaveSimplexcel

진입점: this.btnExportBufferData.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f732a839 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8709 | for (i < headerrowcount) ▸ for (j < headercolcount) ▸ if (i == 0) | DATA_OP | xSheet.ColumnWidths[j] | 20 | 행/컬럼 값 대입 |  |  |  |
| AC-f909b7b2 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8711 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j] | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-0f3cb082 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8734 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].VerticalAlignment | Simplexcel.VerticalAlign.Top | 그리드 속성/값 설정 |  |  |  |
| AC-50970be3 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8741 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].HorizontalAlignment | Simplexcel.HorizontalAlign.Left | 그리드 속성/값 설정 |  |  |  |
| AC-7904ce6c | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8762 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Border | Simplexcel.CellBorder.All | 그리드 속성/값 설정 |  |  |  |
| AC-3342a359 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8764 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-86d3319d | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8776 | for (i < headerrowcount) ▸ for (j < headercolcount) | GRID_SET | xSheet.Cells[i, j].Fill.BackgroundColor | Simplexcel.Color.FromArgb(0, 240, 240, 240) | 그리드 속성/값 설정 |  |  |  |
| AC-0b27c6b4 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8802 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ if (sp.Columns[j].HeaderText == "PLAN_DATE") | GRID_SET | xSheet.Cells[id, jd] | "'" + inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-4d9ad7d0 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8814 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-dd8dc904 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8815 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-df78b147 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8823 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-599e52f4 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8824 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-a7b86eb1 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8829 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-3925d3db | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8830 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-042f8725 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8836 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Value | ss | 그리드 속성/값 설정 |  |  |  |
| AC-770b4017 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8842 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ if (t… | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-4ac50699 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8852 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd] | m | 그리드 속성/값 설정 |  |  |  |
| AC-f2dc98a9 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8853 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-247c1e61 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8859 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-b980681f | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8860 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Format | numformat | 그리드 속성/값 설정 |  |  |  |
| AC-70abde72 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8865 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-9826f609 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8869 | for (i < rowcount) ▸ for (j < colcount) ▸ if (sp.Rows[i].Cells[j].Value != null) ▸ else of (sp.Columns[j].HeaderText == "PLAN_DATE") ▸ else … | GRID_SET | xSheet.Cells[id, jd].Value | inv.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-eb443505 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8886 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].Fill.BackgroundColor | Simplexcel.Color.White | 그리드 속성/값 설정 |  |  |  |
| AC-9a02a4ff | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8898 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontSize | 9 | 그리드 속성/값 설정 |  |  |  |
| AC-8c5cc6cf | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8900 | for (i < rowcount) ▸ for (j < colcount) | GRID_SET | xSheet.Cells[id, jd].FontName | fontName | 그리드 속성/값 설정 |  |  |  |
| AC-d8171a6e | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8905 |  | GRID_INIT | xSheet.FreezeTopLeft | (1, froz) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec0d0a9c | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8906 |  | DATA_OP | workbook.Add | (xSheet) | 데이터 객체 조작/조회 |  |  |  |
| AC-80afc9c8 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8920 |  | UI_PROP | workbook.Title | name | 속성 Title 설정 |  |  |  |
| AC-72fbb977 | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8921 |  | UI_PROP | workbook.Author | "GSCM,FP, logged as " + this.UserInfo.UserId | 속성 Author 설정 |  |  |  |
| AC-2df3c46a | this.btnExportBufferData.Click [try] | FP00598_Plan_Amend_Model_Elec.cs:8923 |  | CALL_EXT | workbook.Save | (fileName) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetBohQty

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewP…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-453e1155 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2324 | if (dsTotal.Good() && dsResult.Good()) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sExpr)) | DATA_OP | dsTotal.Tables[0].Select | (sExpr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bbccfa7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2327 | if (dsTotal.Good() && dsResult.Good()) ▸ for (i < dsResult.Tables[0].Rows.Count) ▸ if (!string.IsNullOrWhiteSpace(sExpr)) ▸ if (matchs != nu… | DATA_OP | row["BOH_QTY"] | matchs[0]["QTY"] | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetCalendarFormat

진입점: chk_omit_zero.CheckedChanged [if (siMain != null)] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (siMain != null)] …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c222c46b | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8542 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExcel… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-beecdc7c | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8544 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (for… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec7317d2 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8547 | if (calendar.Days != null) ▸ foreach (var day_item in calendar.Days) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68380407 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8571 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forExc… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d286638c | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8573 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of (f… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a3495138 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8576 | if (calendar.Weeks != null) ▸ foreach (var day_item in calendar.Weeks) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-709969c5 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8602 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ if (forE… | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,###.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aba44453 | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8604 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ if (omitZero) ▸ else of … | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c3e045b | chk_omit_zero.CheckedChanged [if (siMain != null)] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8607 | if (calendar.Months != null) ▸ foreach (var day_item in calendar.Months) ▸ if (aDay != null) ▸ if (colindex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetFormatDecimalDigit | (3, "#,##0.##########", colindex, 1, omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetCalenderColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-998f6092 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:717 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) | CALL_EXT | date.isSatureDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-2354b557 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:721 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ if (date… | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Blue | 그리드 속성/값 설정 |  |  |  |
| AC-47c5e3bb | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:723 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | CALL_EXT | date.IsSunDay | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9b4f0bb2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:727 | if (calendar != null) ▸ if (day_measure != null && day_measure.On) ▸ foreach (var date_item in calendar.Days) ▸ if (date != null) ▸ else of … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[1, index].ForeColor | System.Drawing.Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-ca90f082 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:751 | if (calendar != null) ▸ if (week_measure != null && week_measure.On) ▸ foreach (var week_item in calendar.Weeks) ▸ if (week != null) ▸ if (i… | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.FromArgb(2… | 그리드 표시 설정 |  |  |  |
| AC-37e6175e | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:766 | if (calendar != null) ▸ if (month_measure != null && month_measure.On) ▸ foreach (var month_item in calendar.Months) ▸ if (month != null) ▸ … | GRID_STYLE | siMain.SetBGColor3 | (0, index, dsMainFiltered.Tables[0].Rows.Count - 1, index, System.Drawing.Color.LightPink) | 그리드 표시 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetChangeControl

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / cbo_fpplanid.SelectedIndexChanged / mcbo_division.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / mcbo_plant.SelectedIndexChanged / mcbo_factory.SelectedIndexChanged / mcbo_operation.SelectedIndexChanged / mcbo_line.SelectedIndexChanged / mcbo_prodtype.SelectedIndexChanged / chk_all_line.CheckedChanged / usrCheckBox1.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-")] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-faf45bfe | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:337 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5baa8821 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:337 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f02ad2c9 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:342 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-8e267921 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:342 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-00402864 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:346 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f519af9 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:346 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6ff111e3 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:347 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, mcbo_division, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ffdf53f1 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:353 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, mcbo_division.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b7e14e0f | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:354 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ebe607b4 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:354 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-74208455 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:355 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b320e904 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:361 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ea4b8557 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:362 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-aa99d8b3 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:362 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-829875dd | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:363 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, mcbo_plant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-697759fd | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:369 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, mcbo_plant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-bad68b4c | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:370 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-5fca3184 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:370 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-4db3aeba | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:371 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, mcbo_factory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d5925ef1 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:378 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, mcbo_factory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3dff17c9 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:380 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef1ed6b | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:381 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca8e3c02 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:382 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1421b940 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:383 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | dtOperation.Rows.Add | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cdc80c03 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:384 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["CODE"] | "E2000" | 그리드 속성/값 설정 |  |  |  |
| AC-611c2016 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:385 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | GRID_SET | dtOperation.Rows[0]["NAME"] | "(E2000)Coating" | 그리드 속성/값 설정 |  |  |  |
| AC-44795088 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:387 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, mcbo_operation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3b18120 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:393 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, mcbo_operation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-513961c5 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:394 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-135724f3 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:394 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a6946e3c | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:395 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, mcbo_line, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a3c9e2e | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:401 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, mcbo_line.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-6162911d | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:405 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODTYPE_ID"] | Filter["PRODUCTION_TYPE"] = Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, … | 행/컬럼 값 대입 |  |  |  |
| AC-f1e358b7 | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:405 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PRODUCTION_TYPE"] | Filter["PROD_TYPE"] = CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-7d019deb | this.Load 외 13 | FP00598_Plan_Amend_Model_Elec.cs:405 | switch (triggerControl) case DefColumns.PRODUCTION_TYPE: | DATA_OP | Filter["PROD_TYPE"] | CString.GetCheckedListValue(dtProdType, mcbo_prodtype.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetColumnsFormat

진입점: chk_omit_zero.CheckedChanged / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals(…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eee8e295 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8482 | if (siMain != null) | CALL_EXT | siMain.InitFormat | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-77bcce5b | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8488 | if (siMain != null) ▸ if (colIndex > -1) ▸ if (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-38487828 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8492 | if (siMain != null) ▸ if (colIndex > -1) ▸ else of (omitZero) | CALL_EXT | siMain.SetColumnFormatDecimalDigit | (3, colIndex, 1, "#,##0", "0", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04facb16 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8497 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#00", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e8832ed2 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8500 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ea9480fc | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8503 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c03c0288 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8506 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85868ff6 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8509 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0", "", false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec0651b1 | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8512 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "##,##0", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |
| AC-420db4ba | chk_omit_zero.CheckedChanged 외 12 | FP00598_Plan_Amend_Model_Elec.cs:8515 | if (siMain != null) ▸ if (colIndex > -1) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "###,##0.###", "", omitZero) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efc975ac | this.Load | FP00598_Plan_Amend_Model_Elec.cs:185 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a3684ca | this.Load | FP00598_Plan_Amend_Model_Elec.cs:187 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-6b1fcf0b | this.Load | FP00598_Plan_Amend_Model_Elec.cs:191 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-dfa9832e | this.Load | FP00598_Plan_Amend_Model_Elec.cs:193 |  | UI_PROP | splitter.Panel2Collapsed | true | 속성 Panel2Collapsed 설정 |  |  |  |
| AC-a3118dc2 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:194 |  | CALL_EXT | UserService.HasSuperRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4812cfc4 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:196 | if (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-51274693 | this.Load | FP00598_Plan_Amend_Model_Elec.cs:200 | else of (UserService.HasSuperRole(CurrentUser)) | UI_PROP | lblData.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetDirty

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f1681d0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 14 | FP00598_Plan_Amend_Model_Elec.cs:8462 |  | FLAG | IsDirty | dirty | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetFilter

진입점: this.Load [if (dtPeriod.Good())] / cbo_plan_group.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_planner.SelectedIndexChanged [if (!dtPlanner.Good() \|\| dtPlanner.Rows.Count < 0)] / cbo_fpplanid.SelectedIndexChanged [if (dtPlanId.Good())] / mcbo_division.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_site.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / mcbo_plant.SelectedIndexChanged [switch (triggerControl) case DefCo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c74ecc0 | this.Load [if (dtPeriod.Good())] 외 24 | FP00598_Plan_Amend_Model_Elec.cs:3066 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetFpPlanIdFilter

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f14d901 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3229 | if (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ec0e40c7 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3230 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | dtPlanId.Rows[0]["PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81ac3858 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3231 | if (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | dtPlanId.Rows[0]["PLAN_TYPE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2afecbb4 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3232 | if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3dcefa8a | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3242 | if (dtPlanId.Good()) | VALUE_SET | txtCreator.Text | sInsertId | 컨트롤 값 설정 |  |  |  |
| AC-41f49848 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3243 | if (dtPlanId.Good()) | VALUE_SET | txtCreation.Text | sInsertTime | 컨트롤 값 설정 |  |  |  |
| AC-b5907e54 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3244 | if (dtPlanId.Good()) | VALUE_SET | txtDesc.Text | sDesc | 컨트롤 값 설정 |  |  |  |
| AC-2d055b0b | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3245 | if (dtPlanId.Good()) | VALUE_SET | txtBasic.Text | sBasicVer | 컨트롤 값 설정 |  |  |  |
| AC-c1d8cb76 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3246 | if (dtPlanId.Good()) | VALUE_SET | txtBuilding.Text | sBuilding | 컨트롤 값 설정 |  |  |  |
| AC-e22796da | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3249 | if (dtPlanId.Good()) | VALUE_SET | txtPlanId.Text | Filter["FP_PLAN_ID"] | 컨트롤 값 설정 |  |  |  |
| AC-4b4ac210 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3251 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_FROM"] | dtPlanId.Rows[0]["PLAN_START_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c065da17 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3252 | if (dtPlanId.Good()) | DATA_OP | Filter["BUCKET_TO"] | dtPlanId.Rows[0]["PLAN_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2836a83c | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3258 | else of (dtPlanId.Good()) | DATA_OP | Filter["FP_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9e582a47 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3259 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0d8e71d2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3260 | else of (dtPlanId.Good()) | DATA_OP | Filter["PLAN_TYPE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-cf8dddf3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3261 | else of (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b947b3e3 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3265 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreator.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-6357e261 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3266 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtCreation.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-a88ee5ea | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3267 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtDesc.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-4410f936 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3268 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBasic.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-9acca767 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3269 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtBuilding.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-c39a0d44 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:3272 | else of (dtPlanId.Good()) | VALUE_CLEAR | txtPlanId.Text | "" | 컨트롤 값 비움 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetMemoCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b32cbb2 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5972 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-cdb9fb24 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5992 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | acell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-e2fa17be | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:5994 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ if (toErase) ▸ if… | UI_PROP | bcell.Font | siMain.SpreadObject.Font | 속성 Font 설정 |  |  |  |
| AC-0c94e161 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6012 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-ccf8c645 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6037 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(siMain.SP.Font, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-466e8177 | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6039 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(System.Drawing.SystemFonts.DefaultFont, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-c16bcefa | (진입점 미연결) | FP00598_Plan_Amend_Model_Elec.cs:6043 | foreach (KeyValuePair<string, AmendDate> keypair in calendar.days) ▸ if (date.Date >= startDate && date.Date <= endDate) ▸ else of (toErase)… | UI_PROP | memo_cell.Font | new System.Drawing.Font(memo_cell.Font.Name, memo_cell.Font.Size, FontStyle.Bold) | 속성 Font 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetPlannerFilter

진입점: this.Load / cbo_plan_group.SelectedIndexChanged / mcbo_planner.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3bb167fd | this.Load 외 2 | FP00598_Plan_Amend_Model_Elec.cs:3197 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ if (row[… | CALL_EXT | mcbo_planner.SetItemChecked | (i, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2dbd749 | this.Load 외 2 | FP00598_Plan_Amend_Model_Elec.cs:3201 | if (dtPlanner.Good()) ▸ foreach (DataRow row in dtPlanner.Rows) ▸ if (mcbo_planner.Items[i].ToString() == row["NAME"].ToString()) ▸ else of … | CALL_EXT | mcbo_planner.SetItemChecked | (i, false) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetPlanOutCell

진입점: bucke_menu.Click [if (select.Count > 0) ▸ if (range != null && dsMainFiltered.Good()) ▸ try ▸ for (i < start_col + col_count) ▸ if (colname.StartsWith("D") && !colname.StartsWith("DI") && !colname.StartsWith("DA")) ▸ for (j < start_row + row_count) ▸ if (row_to_test["CATEGORY_ID"].ToString().Contains("_IN_BATCH")) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ if (!siMain.ActiveSheet.Cells[j, i].Locked && siMain.ActiveSheet.Cells[j, i].Tag.SafeString() == "M")] / zero_line_menu.Click [if (dsMainFiltered.Good()) ▸ if (res.Count() > 0) ▸ for (j < res.Length) ▸ if (catergory == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e503ff98 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6344 | if (!can_change) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-1062a1d2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6345 | if (!can_change) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-f97d4937 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6346 | if (!can_change) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e84ee051 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6363 | if (new_value != round_value) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | round_value | 그리드 속성/값 설정 |  |  |  |
| AC-b25f3763 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6366 | if (new_value != round_value) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcb979e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6394 |  | FLAG | EditingCol | cCol | 화면 필드/플래그 변경 |  |  |  |
| AC-1df5b919 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6400 |  | CALL_EXT | calendar.DateFromText | (ColumnName_Buf) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ec2ae426 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6403 | if (date==null) | MESSAGE | MessageBox.Show | ("Please check date range") | 메시지 표시 |  |  |  |
| AC-5ba94b2d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6404 | if (date==null) | THROW | throw new Exception("Date Column not defined"); |  | 예외 발생 |  |  |  |
| AC-ce150e2c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6446 | lambda | DATA_OP | x.Field | ("FACTORY_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f7a1805 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6447 | lambda | DATA_OP | x.Field | ("LOCATION") | 데이터 객체 조작/조회 |  |  |  |
| AC-76b353bb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6448 | lambda | DATA_OP | x.Field | ("OPERATION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f94d94c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6449 | lambda | DATA_OP | x.Field | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8a81110 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6450 | lambda | DATA_OP | x.Field | ("EQUIPMENT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d0be4fd6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6451 | lambda | DATA_OP | x.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c5286fd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6452 | lambda | DATA_OP | x.Field | ("PLAN_DATE") | 데이터 객체 조작/조회 |  |  |  |
| AC-41997623 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6453 | lambda | DATA_OP | x.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-acc5e7db | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6454 | lambda | DATA_OP | x.Field | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-36c8f371 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6455 | lambda | DATA_OP | x.Field | ("MARKET") | 데이터 객체 조작/조회 |  |  |  |
| AC-6ace937b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6456 | lambda | DATA_OP | x.Field | ("WORK_REQUEST_MODEL_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8867dd5a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6457 | lambda | DATA_OP | x.Field | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-8662b9e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6458 | lambda | DATA_OP | x.Field | ("PLM_EC_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e09b870 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6460 | lambda | DATA_OP | x.Field | ("RELEASE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6a55f2a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6463 | lambda | RETURN | return nn; |  | 처리 중단/반환 |  |  |  |
| AC-2bac9afb | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6476 | else of (m.Count() > 0) | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-918b424d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6479 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.ActiveColumnIndex].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-07824c99 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6480 | else of (m.Count() > 0) ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-e2b77c8e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6483 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-408de097 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6485 | else of (m.Count() > 0) | DATA_OP | newRow["INSTANCE_ID"] | Filter["MASTER_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-e7acef7d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6486 | else of (m.Count() > 0) | DATA_OP | newRow["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-c7479400 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6487 | else of (m.Count() > 0) | DATA_OP | newRow["DIVISION_ID"] | sDivi | 행/컬럼 값 대입 |  |  |  |
| AC-b4b2669f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6488 | else of (m.Count() > 0) | DATA_OP | newRow["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-a4af9a94 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6489 | else of (m.Count() > 0) | DATA_OP | newRow["PLANT_ID"] | sPlat | 행/컬럼 값 대입 |  |  |  |
| AC-5a63cd34 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6490 | else of (m.Count() > 0) | DATA_OP | newRow["FACTORY_ID"] | sFact | 행/컬럼 값 대입 |  |  |  |
| AC-e9ccdce8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6491 | else of (m.Count() > 0) | DATA_OP | newRow["OPERATION_ID"] | sOper | 행/컬럼 값 대입 |  |  |  |
| AC-d2abb1f6 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6492 | else of (m.Count() > 0) | DATA_OP | newRow["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-9eea16e5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6493 | else of (m.Count() > 0) | DATA_OP | newRow["EQUIPMENT_ID"] | sEqup | 행/컬럼 값 대입 |  |  |  |
| AC-71c3c582 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6494 | else of (m.Count() > 0) | DATA_OP | newRow["ELECTRODE_TYPE"] | sElec | 행/컬럼 값 대입 |  |  |  |
| AC-f3e446cc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6495 | else of (m.Count() > 0) | DATA_OP | newRow["PRODUCTION_TYPE"] | sProT | 행/컬럼 값 대입 |  |  |  |
| AC-02be9b29 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6496 | else of (m.Count() > 0) | DATA_OP | newRow["MARKET"] | sMark | 행/컬럼 값 대입 |  |  |  |
| AC-44f9bacd | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6497 | else of (m.Count() > 0) | DATA_OP | newRow["ITEM_ID"] | sItem | 행/컬럼 값 대입 |  |  |  |
| AC-b754291b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6499 | else of (m.Count() > 0) | DATA_OP | newRow["PLAN_DATE"] | sDate | 행/컬럼 값 대입 |  |  |  |
| AC-cacf233d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6500 | else of (m.Count() > 0) | DATA_OP | newRow["LOCATION"] | sLoca | 행/컬럼 값 대입 |  |  |  |
| AC-51a4d162 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6501 | else of (m.Count() > 0) | DATA_OP | newRow["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-4eb243a9 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6502 | else of (m.Count() > 0) | DATA_OP | newRow["SEQ"] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-4a676538 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6503 | else of (m.Count() > 0) | DATA_OP | newRow["WORK_REQUEST_MODEL_ID"] | sTopm | 행/컬럼 값 대입 |  |  |  |
| AC-0f7e0806 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6504 | else of (m.Count() > 0) | DATA_OP | newRow["VERSION"] | sVers | 행/컬럼 값 대입 |  |  |  |
| AC-1b5d5f30 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6505 | else of (m.Count() > 0) | DATA_OP | newRow["PROD_SEQ"] | sProS | 행/컬럼 값 대입 |  |  |  |
| AC-1b994e3b | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6506 | else of (m.Count() > 0) | DATA_OP | newRow["PLM_EC_NO"] | sPlmE | 행/컬럼 값 대입 |  |  |  |
| AC-f537247f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6509 | else of (m.Count() > 0) | DATA_OP | dtEditTmp.Rows.Add | (newRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a6fb5f5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6516 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["RELEASE_TYPE"] | sReleaseType | 행/컬럼 값 대입 |  |  |  |
| AC-00cf34bf | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6517 | if (sCate == "P_SEQ") | DATA_OP | ds_ListDataR["SEQ"] | new_value | 행/컬럼 값 대입 |  |  |  |
| AC-8d3b1a79 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6519 | else of (sCate == "P_SEQ") | DATA_OP | sCate.Contains | ("_IN_BATCH") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6bd33e1 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6522 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | GRID_SET | siMain.ActiveSheet.Cells[cRow, cCol].Value | org_value | 그리드 속성/값 설정 |  |  |  |
| AC-d7403f58 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6523 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | MESSAGE | MessageBox.Show | (error) | 메시지 표시 |  |  |  |
| AC-6a38343a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6524 | else of (sCate == "P_SEQ") ▸ if (sCate.Contains("_IN_BATCH") && new_value >= 50) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-247a7887 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6557 |  | DATA_OP | ds_ListDataR[sIn_M] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-fa81cd7f | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6558 |  | DATA_OP | ds_ListDataR[sIn_CELL] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-667232e7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6559 |  | DATA_OP | ds_ListDataR[sIn_JR] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-91c24b21 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6561 |  | DATA_OP | ds_ListDataR[sOut_BATCH] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-198e8569 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6562 |  | DATA_OP | ds_ListDataR[sIn_BATCH] | nInValue | 행/컬럼 값 대입 |  |  |  |
| AC-6c5ea649 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6568 |  | DATA_OP | ds_ListDataR[sOut_M] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-e814b9c3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6572 |  | DATA_OP | ds_ListDataR[sOut_CELL] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-1a0503c2 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6576 |  | DATA_OP | ds_ListDataR[sOut_JR] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-6718e642 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6582 | if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-0f8982f0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6599 | if (measure["chk_jr"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_JR | 행/컬럼 값 대입 |  |  |  |
| AC-a9c388a8 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6605 | if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-810fc3d3 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6626 | if (measure["chk_pc"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_M | 행/컬럼 값 대입 |  |  |  |
| AC-148e7c89 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6633 | if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-b4c764c0 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6653 | if (measure["chk_cell"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nIn_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-a54b1d91 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6665 | if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-19e1e9bc | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6681 | if (measure["chk_outqty"].On) ▸ if (measure["chk_pc"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nOut_M | 행/컬럼 값 대입 |  |  |  |
| AC-c01eb763 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6688 | if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-20ab185a | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6705 | if (measure["chk_outqty"].On) ▸ if (measure["chk_jr"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nOut_JR | 행/컬럼 값 대입 |  |  |  |
| AC-2074ea46 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6711 | if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-23b34e6c | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6729 | if (measure["chk_outqty"].On) ▸ if (measure["chk_cell"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nOut_CELL | 행/컬럼 값 대입 |  |  |  |
| AC-ada00230 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6735 | if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-004958f7 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6752 | if (measure["chk_outqty"].On) ▸ if (measure["chk_batch"].On) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | nOutValue | 행/컬럼 값 대입 |  |  |  |
| AC-f05a06d5 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6761 | if (measure["chk_seq"].On) | DATA_OP | dsMainFiltered.Tables[0].Select | ("FACTORY_ID='" + sFact + "'" + " AND LOCATION='" + sLoca + "'" + " AND OPERATION_ID='" + … | 데이터 객체 조작/조회 |  |  |  |
| AC-82ed755e | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6789 | if (measure["chk_seq"].On) ▸ if (Filter["PLAN_TYPE"] != "RELEASE") ▸ if (res != null && res.Length > 0) ▸ if (tmp == 0) | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |
| AC-2723b93d | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6794 | if (measure["chk_seq"].On) | CALL_EXT | dsMainFiltered.Tables[0].Rows[idx]["SEQ"].SafeUnInt | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f96e207 | bucke_menu.Click [if (select.Count > 0) ▸ if (range != null … 외 5 | FP00598_Plan_Amend_Model_Elec.cs:6800 | if (measure["chk_seq"].On) ▸ if ((nInValue > 0) && oldseq == 0) ▸ if (res != null && res.Length > 0) | DATA_OP | res[0][ColumnName_Buf] | 1 | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetReleaseProcess

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else o…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8508c61c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2889 | if (Filter["PLAN_TYPE"] == "RELEASE") | ENDPOINT | DataService.FP_ExecuteQuery | ("XpCommonAmend", "find_isCurrWeek", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] \| FP\Common\X… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-b8604422 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2895 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) | FLAG | DbCurrentDate | DateTime.ParseExact(curr_date, "yyyyMMdd", enUS) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e6bd795 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2900 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ if (row_Date < DbCurre… | DATA_OP | row["IS_PLAN"] | "N" | 행/컬럼 값 대입 |  |  |  |
| AC-fadf7568 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2904 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ foreach (DataRow row in dateMap.Tables[0].Rows) ▸ else of (row_Date < Db… | DATA_OP | row["IS_PLAN"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-dfdc8fed | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2910 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-c2199655 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2911 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5dd6c9ad | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2912 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e3d1c47e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2913 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) ▸ if (ds_isCurrWeek.Tables[0].Rows[0]["IS_LATEST_PLAN"].ToString() != "Y") | STATE | btnSetupColor.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-3db00e05 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2915 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["CURR_DATE"] | ds_isCurrWeek.Tables[0].Rows[0]["CURR_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-99562e06 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2916 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (ds_isCurrWeek.Good()) | DATA_OP | Filter["RELEASE_VALUE"] | ds_isCurrWeek.Tables[0].Rows[0]["RELEASE_VALUE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-43c10ae5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2921 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["CURR_DATE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bcc1652d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:2922 | else of (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["RELEASE_VALUE"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetSpreadInit

진입점: this.Load [try] / memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == false) ▸ if (refreshColumn) ▸ try] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (monthInfo == null \|\| dsMain == null) ▸ else of (with_day_part == …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-928c2e83 | this.Load [try] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:568 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0dfab4f | this.Load [try] 외 12 | FP00598_Plan_Amend_Model_Elec.cs:569 | if (sheetName.Equals(SpdSheet.shtPlanAmendMA)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SetTotalColor

진입점: memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len > 0) ▸ if (len == 1) ▸ if (memoRow["ITEM_ID"].SafeString() == "-") ▸ if (frm.DialogResult == DialogResult.OK) ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true) ▸ try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ else of (monthInfo == null \|\| dsMain == null) ▸ if (dsMainFiltered.Good())] / this.spdMain.CellDoubleClick [try ▸ i…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b4204044 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:663 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL": | GRID_STYLE | siMain.SetBGColor3 | (line, start, line, last_col, total_color) | 그리드 표시 설정 |  |  |  |
| AC-8224d5c2 | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:666 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "TOTAL_2": | GRID_STYLE | siMain.SetBGColor3 | (line, substart, line, last_col, sub_total_color) | 그리드 표시 설정 |  |  |  |
| AC-d286935f | memo_menu.Click [if (day != null) ▸ if (showExist) ▸ if (len… 외 11 | FP00598_Plan_Amend_Model_Elec.cs:674 | foreach (DataRow row in dsMainFiltered.Tables[0].Rows) ▸ switch (row["DATA_TYPE"].ToString()) case "DATA": ▸ if (idx_version > -1 && sMaxVer… | GRID_STYLE | siMain.SetBGColor3 | (line, idx_version, line, idx_version, Color.Orange) | 그리드 표시 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f43c982b | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9120 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6970915 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9121 | if (e.Button == MouseButtons.Right) ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9da9aafc | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9142 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | bucke_menu.Text | "Zero Setting(Bucket)" | 컨트롤 값 설정 |  |  |  |
| AC-307f2e80 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9143 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | bucke_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-d74d730d | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9145 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (bucke_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b3261ab | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9164 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | VALUE_SET | memo_menu.Text | "Memo" | 컨트롤 값 설정 |  |  |  |
| AC-695f6fa6 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9165 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | UI_PROP | memo_menu.Tag | new Tuple<DataRow, FarPoint.Win.Spread.CellClickEventArgs>(row, e) | 속성 Tag 설정 |  |  |  |
| AC-995db72b | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9167 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ if (e.Col… | DATA_OP | m.MenuItems.Add | (memo_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-c90fa0eb | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9176 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eaf58830 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9181 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_line_menu.Text | "Zero Setting(Line)" | 컨트롤 값 설정 |  |  |  |
| AC-b744e9c5 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9182 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-d87b9817 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9184 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd2cbe4c | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9188 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_mat_menu.Text | "Zero Setting(Material)" | 컨트롤 값 설정 |  |  |  |
| AC-726333ad | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9189 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_mat_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-bf84d6ef | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9191 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_mat_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e6e1377 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9195 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | zero_all_line_menu.Text | "Zero Setting(All Line)" | 컨트롤 값 설정 |  |  |  |
| AC-1d07b78a | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9196 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | zero_all_line_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-b45367f3 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9198 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (zero_all_line_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-d2acb5e1 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9202 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | VALUE_SET | line_change_menu.Text | "Line Change" | 컨트롤 값 설정 |  |  |  |
| AC-3da07a4e | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9203 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | UI_PROP | line_change_menu.Tag | row | 속성 Tag 설정 |  |  |  |
| AC-b8a1b0bb | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9205 | if (e.Button == MouseButtons.Right) ▸ if (row != null) ▸ if (dsMainFiltered.Good()) ▸ if (row["DATA_TYPE"].ToString() == "DATA") ▸ else of (… | DATA_OP | m.MenuItems.Add | (line_change_menu) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9c88fd3 | this.spdMain.CellClick | FP00598_Plan_Amend_Model_Elec.cs:9213 | if (e.Button == MouseButtons.Right) ▸ if (m.MenuItems.Count > 0) | POPUP | m.Show | (spdMain, new Point(e.X, e.Y)) | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d63a7d4 | this.spdMain.CellDoubleClick | FP00598_Plan_Amend_Model_Elec.cs:8964 | try ▸ else of (!sHeadNameLevel2.Equals("Week Sum")) ▸ for (idx < iWeekCount) | GRID_SET | spdMain.ActiveSheet.Columns[idx].Visible | !spdMain.ActiveSheet.Columns[idx].Visible | 그리드 속성/값 설정 |  |  |  |
| AC-cd0a193a | this.spdMain.CellDoubleClick | FP00598_Plan_Amend_Model_Elec.cs:8971 | catch () | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b2cac93 | this.spdMain.ClipboardPasted | FP00598_Plan_Amend_Model_Elec.cs:7762 | if (e.CellRange == null \|\| ClipData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0848343 | this.spdMain.ClipboardPasted | FP00598_Plan_Amend_Model_Elec.cs:7770 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-383bd8ac | this.spdMain.ClipboardPasted | FP00598_Plan_Amend_Model_Elec.cs:7771 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.PasteAuto | (ClipData, TargetCellDatas, ClipboardRange, spdMain, startcol, startrow, maxcol, maxrow, U… | ⚠ 의미 확인 필요 |  |  |  |
| AC-e38f1592 | this.spdMain.ClipboardPasted | FP00598_Plan_Amend_Model_Elec.cs:7773 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5fdb0f9 | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7737 |  | FLAG | ClipboardRange | spdMain.ActiveSheet.GetSelections() | 화면 필드/플래그 변경 |  |  |  |
| AC-0b2da2ee | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7738 |  | FLAG | ClipData | ClipboardService.GetClipdata() | 화면 필드/플래그 변경 |  |  |  |
| AC-ea2dad92 | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7738 |  | CALL_EXT | ClipboardService.GetClipdata | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3885443f | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7742 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | FLAG | TargetCellDatas | ClipboardService.GetSourceSpread(spdMain, ClipData) | 화면 필드/플래그 변경 |  |  |  |
| AC-71085def | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7742 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_EXT | ClipboardService.GetSourceSpread | (spdMain, ClipData) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7188ee8e | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7746 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | CALL_EXT | ClipboardService.PasteAutoSingleCell | (ClipData, ClipboardRange, spdMain, true, EditByClipboard) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8bd83e50 | this.spdMain.ClipboardPasting | FP00598_Plan_Amend_Model_Elec.cs:7748 | if (UseSingleCellPaste && ClipboardRange != null && ClipboardRange.Length > 0) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_EditModeOn

진입점: this.spdMain.EditModeOn

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab57aa3d | this.spdMain.EditModeOn | FP00598_Plan_Amend_Model_Elec.cs:7820 |  | FLAG | EditingValue | siMain.ActiveSheet.ActiveCell.Value | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b48c1be6 | this.spdMain.KeyDown | FP00598_Plan_Amend_Model_Elec.cs:7290 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-b2546ce1 | this.spdMain.KeyDown | FP00598_Plan_Amend_Model_Elec.cs:7294 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | CALL_EXT | ClipboardService.DeleteRange | (spdMain, true, EditByFunc) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8a2f3e9e | this.spdMain.KeyDown | FP00598_Plan_Amend_Model_Elec.cs:7295 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.SwitchMemo

진입점: memo_menu.Click [if (day != null)] / this.spdMain.CellDoubleClick [try ▸ if (!sHeadNameLevel2.Equals("Week Sum")) ▸ if (day != null) ▸ if (day != null && dsMemoInfo.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2bee12e | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:8982 | if (r == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a00a5b8 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:8999 | if (showExist) | DATA_OP | dsMemoInfo.Tables[0].Select | ( //"COMPANY_ID = '"+ company_id + "' AND " + "DIVISION_ID = '" + division_id + "' AND " +… | 데이터 객체 조작/조회 |  |  |  |
| AC-17f2424a | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9024 | if (showExist) ▸ if (len > 0) ▸ if (len == 1) | DATA_OP | memoRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-42d554d8 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9050 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-bb1e60e7 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9052 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-12fa2f39 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9055 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | materialRow.Table.Columns.Contains | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1076e110 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9057 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-c8d0fc96 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9057 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-39a295bc | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9058 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "PIC Alarm Memo" | 속성 Option2 설정 |  |  |  |
| AC-144f5e38 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9060 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ else of (prod_type.Contains("SAMPLE") \|\| prod_type.Contains("TEST")) | UI_PROP | select_popup.Option2 | "Material Memo" | 속성 Option2 설정 |  |  |  |
| AC-0faa0a7a | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9062 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-65f35fca | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9074 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("SAMPLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b286e6e | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9074 | if (showExist) ▸ if (len > 0) ▸ else of (len == 1) ▸ if (select_popup.ShowDialog() == DialogResult.OK) ▸ else of (select_popup.Selection == … | DATA_OP | prod_type.Contains | ("TEST") | 데이터 객체 조작/조회 |  |  |  |
| AC-4d25af70 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9094 | else of (showExist) | POPUP | new FPC0119_MemoSelect_Popup | () | 팝업/폼 생성 |  |  |  |
| AC-a6992a03 | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9095 | else of (showExist) | VALUE_SET | select_popup.Text | "SELECT Memo" | 컨트롤 값 설정 |  |  |  |
| AC-91ace53b | memo_menu.Click [if (day != null)] 외 1 | FP00598_Plan_Amend_Model_Elec.cs:9097 | else of (showExist) | POPUP | select_popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f30a705e | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7572 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11146441 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7577 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-0aa292c0 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7578 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-f3f92b96 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7579 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 60) | 데이터 객체 조작/조회 |  |  |  |
| AC-1abe4256 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7580 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 70) | 데이터 객체 조작/조회 |  |  |  |
| AC-65b33161 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7581 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 200) | 데이터 객체 조작/조회 |  |  |  |
| AC-e84e9fba | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7582 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-fdb44536 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7587 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-c3216a97 | tbNickName.BeforeOpenSearch | FP00598_Plan_Amend_Model_Elec.cs:7588 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53d94d9 | tbNickName.OnSearchConditionChanged | FP00598_Plan_Amend_Model_Elec.cs:7594 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICKNAME", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6f2ac5be | tbNickName.OnSearchConditionChanged | FP00598_Plan_Amend_Model_Elec.cs:7595 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f1f420fd | tbNickName.OnSearchConditionChanged | FP00598_Plan_Amend_Model_Elec.cs:7601 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-e47e951e | tbNickName.OnSearchConditionChanged | FP00598_Plan_Amend_Model_Elec.cs:7605 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICKNAME_LT"] | tbNickName.TextValue | 행/컬럼 값 대입 |  |  |  |
| AC-3919ac4c | tbNickName.OnSearchConditionChanged | FP00598_Plan_Amend_Model_Elec.cs:7607 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICKNAME"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.UIFindData

진입점: this.btnExcelImport.Click [if (select_popup.ShowDialog() == DialogResult.OK) ▸ switch (selected) case 0: ▸ if (colPopup.SaveSuccess == true)] / this.btnDppWppCopyDwSubmit.Click [if (CopySubmit.ShowDialog() == DialogResult.OK)] / this.btnCreatePlan2.Click [if (popPlanTotal.DialogResult == DialogResult.OK) ▸ if (!string.IsNullOrEmpty(popPlanTotal._NewPlanId)) ▸ if (!string.IsNullOrWhiteSpace(popPlanTotal._NewPlanId)) ▸ if (dtPlanId.Good()) ▸ else of (cbo_fpplanid.SelectedIndex < 0)] / this.btn_bucket.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (weekSunChanged)] / this.btn_category.Click…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80c190e1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1064 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-10c40906 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1065 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-125aac36 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1068 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1993ffab | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1072 | try | DATA_OP | Filter["PLAN_ID"] | Filter["FP_PLAN_ID"] = cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-8dc9ba02 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1072 | try | DATA_OP | Filter["FP_PLAN_ID"] | cbo_fpplanid.SelectedValue as string | 행/컬럼 값 대입 |  |  |  |
| AC-c3374906 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1076 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | MESSAGE | MessageBox.Show | ("You need to select one plan to proceed") | 메시지 표시 |  |  |  |
| AC-2ad35387 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1077 | try ▸ if (string.IsNullOrWhiteSpace(Filter["PLAN_ID"])) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-95168efb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1083 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | SaveTopRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-588a1e1f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1091 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | sVERSION_YN | dtInstance.Lookup("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN").ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-db121d44 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1091 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | dtInstance.Lookup | ("CODE", Filter["INSTANCE_ID"].ToString(), "VERSION_YN") | ⚠ 의미 확인 필요 |  |  |  |
| AC-49d82941 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1092 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["VERSION_YN"] | sVERSION_YN | 행/컬럼 값 대입 |  |  |  |
| AC-21f706f4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1095 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery2 | ("FP00595", "find_isPDS", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isPDS] \| FP\Planning\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4a06f4d1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1096 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["IS_PDS"] | (dtPDS.getColumn(0, "IS_PDS")).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fd350cf1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1096 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | dtPDS.getColumn | (0, "IS_PDS") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6d204481 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1104 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-46645565 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1105 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b01ac82 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1108 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4d1bd26f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1112 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d847dac7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1119 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter2["LINE_ID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-e02c506f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1127 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36d5062b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1128 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter2["TOP_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c13783e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1129 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter2["CTRL_ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1691bafb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1130 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter2["ITEM_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ea0be431 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1132 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter2["PROD_TYPE"] == "") | DATA_OP | Filter2["PROD_TYPE"] | Filter2["PROD_TYPE"] | 행/컬럼 값 대입 |  |  |  |
| AC-4042e30d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1134 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter2["TOP_ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_TOP_ITEM_ID"] | " AND A.TOP_ITEM_ID LIKE '%' + @TOP_ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-535c4758 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1136 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter2["ITEM_ID"] != "") | DATA_OP | Filter2["CTRL_ITEM_ID"] | " AND A.ITEM_ID LIKE '%' + @ITEM_ID + '%'" | 행/컬럼 값 대입 |  |  |  |
| AC-2cc33dff | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1140 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy_NickName.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-449fbd84 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1155 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-5a92e403 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1156 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-0f156f93 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1158 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d64b9cbb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1168 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | LastTotalRaw | FindTotalValue(Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-f75d1a12 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1171 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-15d56ed9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1173 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-f035d3b3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1173 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2c66d9eb | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1185 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("_MM_", typeof(bool)) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bb68838 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1186 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-bb47ea4b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1187 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-420883b7 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1188 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-53acda9b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1189 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8225904 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1190 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_IN_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60fd0a9c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1192 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f91fd75d | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1193 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4af70507 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1194 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0a481b0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1195 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a119698f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1196 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("ADJUST_OUT_QTY_JR", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-412f7f06 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1198 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c9df8f1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1199 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-01a3c83b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1200 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1ab43075 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1201 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0adf8edd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1202 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5651bb69 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1203 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d01e64d3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1204 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5373041f | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1205 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("MPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-212e1dd5 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1207 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ac6c921 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1208 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-dc7de1c3 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1209 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cfd2549 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1210 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_IN_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca89b617 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1211 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_BATCH", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d940c883 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1212 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e76c8a86 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1213 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_M", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3e3295b9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1214 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("WPP_OUT_QTY_CELL", typeof(double)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9af4ee20 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1216 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("RELEASE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-10e069cc | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1217 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) | DATA_OP | dsMain.Tables[0].Columns.SafeAdd | ("SEQ", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b72502fe | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1224 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow… | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-34415463 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1227 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow… | DATA_OP | row["RELEASE_TYPE"] | "WPP" | 행/컬럼 값 대입 |  |  |  |
| AC-ec8cd4c0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1230 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMain != null && dsMain.Tables.Count > 0) ▸ foreach (DataRow… | DATA_OP | row["RELEASE_TYPE"] | "DPP" | 행/컬럼 값 대입 |  |  |  |
| AC-1f5a2033 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1254 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | CALL_EXT | measure.SetLoaded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-86e1b807 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1258 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | DATA_OP | Filter["DONOTEDIT"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-fbe5f159 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1261 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-aae76795 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1262 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_ID"].EndsWith("00")) | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-e1f90671 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1266 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_ID"].EndsWith("00")) | STATE | btnExcelImport.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f7f9f1b8 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1275 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | STATE | btnSetupColor.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cf98ed15 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1279 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | DATA_OP | Filter["DONOTEDIT"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-f2138fd9 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1280 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | true | 화면 필드/플래그 변경 |  |  |  |
| AC-36515ab4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1282 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ed3dfc2c | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1283 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b62bdbb4 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1284 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-32464e59 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1285 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-959be34e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1289 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | FLAG | ISRELEASE | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a77f70bd | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1291 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDWSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-6346dfb1 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1292 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnDppWppCopyDwSubmit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8834e999 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1293 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnRelease2.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-03813e8e | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1294 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ else of (Filter["PLAN_TYPE"] == "RELEASE") | STATE | btnCapaSync.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2358cb7a | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1306 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ try ▸ if (dtPlanId.Good()) | DATA_OP | Filter["UI_END_DATE"] | dtPlanId.Rows[0]["UI_END_DATE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a2250c4b | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1323 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try ▸ if (dsMainFiltered.Good()) | UI_MISC | SetSearchCount | (dsMainFiltered) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-bc6a1b31 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1327 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ try | FLAG | FindDone | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1b9cb459 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1331 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bffbb55 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1336 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8881bd10 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1337 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8be59c76 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1344 | try ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtPlanAmendMA) | CALL_BASE | RestoreRowRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-031aefc0 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1347 | try | GRID_LOCK | siMain.SetLockFlag | (SpdSheet.shtPlanAmendMA, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7dd6f69 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1351 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-b2598491 | this.btnExcelImport.Click [if (select_popup.ShowDialog() == … 외 7 | FP00598_Plan_Amend_Model_Elec.cs:1355 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00598_Plan_Amend_Model_Elec.UISaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ab2ff9a | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3006 | try | MESSAGE | MessageBox.Show | ("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) | 메시지 표시 |  |  |  |
| AC-f8155905 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3008 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9f11fbfd | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3009 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98ffe58c | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3013 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ if (save_success == true) | MESSAGE | MessageBox.Show | ("Data saved", "Save result") | 메시지 표시 |  |  |  |
| AC-2b698298 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3017 | try ▸ if (MessageBox.Show("Do you want to save", "Saving data", MessageBoxButtons.OKCancel) == DialogResult.OK) ▸ else of (save_success == t… | MESSAGE | MessageBox.Show | ("Data not saved", "Save result") | 메시지 표시 |  |  |  |
| AC-69aa81c3 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3025 | catch () | MESSAGE | MessageBox.Show | ("Error on Save") | 메시지 표시 |  |  |  |
| AC-8582e198 | SaveButton | FP00598_Plan_Amend_Model_Elec.cs:3029 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_RowExcelPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63b9a1c2 | .ctor | FP00598_RowExcelPopup.cs:133 |  | FLAG | Filter | new FilterDataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-c308dc77 | .ctor | FP00598_RowExcelPopup.cs:134 |  | FLAG | HeaderLineCount | 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-2f9b7f76 | .ctor | FP00598_RowExcelPopup.cs:135 |  | FLAG | IgnoreColumnsNotInTitle | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9fb7fa8c | .ctor | FP00598_RowExcelPopup.cs:136 |  | FLAG | AutoCHK | false | 화면 필드/플래그 변경 |  |  |  |

## FP00598_RowExcelPopup.ApplyAmendCalendarCondition

진입점: this.Load [if (DoSearchData != null) ▸ try] / this.btnFind.Click [if (DoSearchData != null) ▸ try] / FindButton [if (DoSearchData != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfb5d0e6 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:207 |  | FLAG | weekInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-450d02c8 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:208 |  | FLAG | dateMap | null | 화면 필드/플래그 변경 |  |  |  |
| AC-d3562d4c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:209 |  | FLAG | monthInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-c72453c7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:210 |  | FLAG | bukInfo | null | 화면 필드/플래그 변경 |  |  |  |
| AC-07b0781f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:212 |  | FLAG | weekInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-3cc2b4a6 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:212 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_WeekCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-bf97023b | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:213 |  | FLAG | dateMap | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-a9057a2f | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:213 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_DateMap", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a29facc7 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:214 |  | FLAG | monthInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 화면 필드/플래그 변경 |  |  |  |
| AC-2f5571cc | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:214 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_MonthCnt", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] \| FP\Common\FP0… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-aedca55d | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:215 |  | FLAG | bukInfo | DataService.FP_ExecuteQuery("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 화면 필드/플래그 변경 |  |  |  |
| AC-bd5cdb9c | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:215 |  | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00601_PlanAmend", "find_bukInfo", Filter.Dictionary) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] \| FP\Common\FP00… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f2e01aa0 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:224 |  | DATA_OP | Filter["DATE_INFO"] | date_info | 행/컬럼 값 대입 |  |  |  |
| AC-5b8b1b37 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:225 |  | DATA_OP | Filter["MONTH_INFO"] | month_info | 행/컬럼 값 대입 |  |  |  |
| AC-a2e30ce2 | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:226 |  | DATA_OP | Filter["BUCKET"] | bulk_info | 행/컬럼 값 대입 |  |  |  |
| AC-4aa57ccb | this.Load [if (DoSearchData != null) ▸ try] 외 2 | FP00598_RowExcelPopup.cs:227 |  | DATA_OP | Filter["WEEK_INFO"] | week_info | 행/컬럼 값 대입 |  |  |  |

## FP00598_RowExcelPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-138807f7 | this.btnClose.Click | FP00598_RowExcelPopup.cs:917 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_RowExcelPopup.btnDownload_Click

진입점: this.btnDownload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-15f0a6fa | this.btnDownload.Click | FP00598_RowExcelPopup.cs:899 |  | FOCUS | spdMain.Focus | () | 포커스 이동 |  |  |  |
| AC-188be9f2 | this.btnDownload.Click | FP00598_RowExcelPopup.cs:900 |  | EXCEL | ExportExcel | (0, true) | 엑셀 내보내기/올리기 |  |  |  |

## FP00598_RowExcelPopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7aef8e8 | this.btnFind.Click | FP00598_RowExcelPopup.cs:890 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | MESSAGE | MessageHelper.GMessageBox | ("The start date can not be less than the plan date.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c1fcec0 | this.btnFind.Click | FP00598_RowExcelPopup.cs:891 | if (int.Parse(sStartDate) > int.Parse(dateRange.Value1.ToString("yyyyMMdd"))) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00598_RowExcelPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b913099 | this.Load | FP00598_RowExcelPopup.cs:255 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6c549cfd | this.Load | FP00598_RowExcelPopup.cs:256 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6c19748 | this.Load | FP00598_RowExcelPopup.cs:257 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00598_RowExcelPopup.dateRange_ValueChanged

진입점: dateRange.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ce6eee7 | dateRange.ValueChanged | FP00598_RowExcelPopup.cs:922 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.ValueStart.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6cf32e09 | dateRange.ValueChanged | FP00598_RowExcelPopup.cs:923 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.ValueEnd.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00598_RowExcelPopup.DefaultLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f818dfc3 | (진입점 미연결) | FP00598_RowExcelPopup.cs:853 |  | CALL_EXT | ExcelService.CommonDefaultLineCheck | (row, KeyColumnList, ColumnType, ColumnLength, Filter, AcceptOnlyPositve) | ⚠ 의미 확인 필요 |  |  |  |
| AC-99e300bd | (진입점 미연결) | FP00598_RowExcelPopup.cs:853 |  | RETURN | return ExcelService.CommonDefaultLineCheck(row, KeyColumnList, ColumnType, Colum… |  | 처리 중단/반환 |  |  |  |

## FP00598_RowExcelPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbd6444e | this.Load | FP00598_RowExcelPopup.cs:250 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00598_RowExcelPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-858d6b56 | Dispose | FP00598_RowExcelPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00598_RowExcelPopup.ExcelLineCheck

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb78eebd | (진입점 미연결) | FP00598_RowExcelPopup.cs:722 | if (this.DoLineCheck != null) | CALL_BASE | DoLineCheck | (row, this) | ⚠ 의미 확인 필요 |  |  |  |

## FP00598_RowExcelPopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ad51ef3 | FindButton | FP00598_RowExcelPopup.cs:297 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-89017546 | FindButton | FP00598_RowExcelPopup.cs:298 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f4f6083a | FindButton | FP00598_RowExcelPopup.cs:300 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00598_RowExcelPopup.FindData

진입점: this.Load / this.btnFind.Click / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d8bfeca | this.Load 외 2 | FP00598_RowExcelPopup.cs:339 | if (DoSearchData == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b4c9a01 | this.Load 외 2 | FP00598_RowExcelPopup.cs:340 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-971ab5b4 | this.Load 외 2 | FP00598_RowExcelPopup.cs:340 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ca50b44 | this.Load 외 2 | FP00598_RowExcelPopup.cs:344 | if (DoSearchData != null) | FLAG | this.hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-65929057 | this.Load 외 2 | FP00598_RowExcelPopup.cs:345 | if (DoSearchData != null) | FLAG | this.IsExcelChanged | false | 화면 필드/플래그 변경 |  |  |  |
| AC-cb699d8b | this.Load 외 2 | FP00598_RowExcelPopup.cs:347 | if (DoSearchData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-408d5292 | this.Load 외 2 | FP00598_RowExcelPopup.cs:348 | if (DoSearchData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-021c9dec | this.Load 외 2 | FP00598_RowExcelPopup.cs:349 | if (DoSearchData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cf0618d2 | this.Load 외 2 | FP00598_RowExcelPopup.cs:350 | if (DoSearchData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9ba73d5b | this.Load 외 2 | FP00598_RowExcelPopup.cs:351 | if (DoSearchData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-069979cb | this.Load 외 2 | FP00598_RowExcelPopup.cs:352 | if (DoSearchData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1da23901 | this.Load 외 2 | FP00598_RowExcelPopup.cs:359 | if (DoSearchData != null) ▸ try ▸ if (UserInfoContext.Current == null) | CALL_EXT | FoxUserInfoContext.SetCallContext | (ctx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9bc9f11b | this.Load 외 2 | FP00598_RowExcelPopup.cs:364 | if (DoSearchData != null) ▸ try | FLAG | Calendar | new AmendCalendar() | 화면 필드/플래그 변경 |  |  |  |
| AC-3bce6641 | this.Load 외 2 | FP00598_RowExcelPopup.cs:366 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.MonthInfo | monthInfo | 속성 MonthInfo 설정 |  |  |  |
| AC-a5f3e7ea | this.Load 외 2 | FP00598_RowExcelPopup.cs:367 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.WeekInfo | weekInfo | 속성 WeekInfo 설정 |  |  |  |
| AC-d18c4602 | this.Load 외 2 | FP00598_RowExcelPopup.cs:368 | if (DoSearchData != null) ▸ try | UI_PROP | Calendar.DateMap | dateMap | 속성 DateMap 설정 |  |  |  |
| AC-4298cde2 | this.Load 외 2 | FP00598_RowExcelPopup.cs:370 | if (DoSearchData != null) ▸ try | CALL_BASE | DoSearchData | (Filter.Data, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d96f0aa3 | this.Load 외 2 | FP00598_RowExcelPopup.cs:372 | if (DoSearchData != null) ▸ try ▸ if (set == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6096a352 | this.Load 외 2 | FP00598_RowExcelPopup.cs:374 | if (DoSearchData != null) ▸ try | FLAG | dsItemInfo | DataService.FP_ExecuteQuery("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-89e841bd | this.Load 외 2 | FP00598_RowExcelPopup.cs:374 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_ItemInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_ItemInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-4854b7be | this.Load 외 2 | FP00598_RowExcelPopup.cs:375 | if (DoSearchData != null) ▸ try | FLAG | dsLineInfo | DataService.FP_ExecuteQuery("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-215d7160 | this.Load 외 2 | FP00598_RowExcelPopup.cs:375 | if (DoSearchData != null) ▸ try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00595", "find_LineInfo", Filter.Dictionary, "Planning") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LineInfo] \| FP\Planning\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-ffbb96fa | this.Load 외 2 | FP00598_RowExcelPopup.cs:377 | if (DoSearchData != null) ▸ try | CALL_BASE | this.Invoke | (new Action(delegate () { DictColumn = siMain.SetSheetHeaderFromDataSource(siMain, set, Co… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1163b95f | this.Load 외 2 | FP00598_RowExcelPopup.cs:380 | if (DoSearchData != null) ▸ try ▸ lambda | FLAG | DictColumn | siMain.SetSheetHeaderFromDataSource(siMain, set, ColumnWidth, ColumnTitle, KeyColumns, Aut… | 화면 필드/플래그 변경 |  |  |  |
| AC-c1b1d7cd | this.Load 외 2 | FP00598_RowExcelPopup.cs:380 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_INIT | siMain.SetSheetHeaderFromDataSource | (siMain, set, ColumnWidth, ColumnTitle, KeyColumns, AutoCHK, null, 1, IgnoreColumnsNotInTi… | 그리드 재구성/초기화 |  |  |  |
| AC-69bde145 | this.Load 외 2 | FP00598_RowExcelPopup.cs:386 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-c8354742 | this.Load 외 2 | FP00598_RowExcelPopup.cs:387 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-59323aef | this.Load 외 2 | FP00598_RowExcelPopup.cs:388 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (AutoCHK) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, siMain.GetColumnIndex("CHK")].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-09e33c93 | this.Load 외 2 | FP00598_RowExcelPopup.cs:393 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) | DATA_OP | set.Tables[0].Columns.Contains | ("MESSAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4ac270d | this.Load 외 2 | FP00598_RowExcelPopup.cs:394 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set != null && set.Tables != null && set.Tables.Count > 0) ▸ if (!set.Tables[0].Columns.Conta… | DATA_OP | set.Tables[0].Columns.Add | ("MESSAGE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-31fd0df9 | this.Load 외 2 | FP00598_RowExcelPopup.cs:397 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_BIND | siMain.Query | (set, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6a783f37 | this.Load 외 2 | FP00598_RowExcelPopup.cs:400 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,##0.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aefd5c74 | this.Load 외 2 | FP00598_RowExcelPopup.cs:403 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-233bf24d | this.Load 외 2 | FP00598_RowExcelPopup.cs:406 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48d3df9e | this.Load 외 2 | FP00598_RowExcelPopup.cs:409 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (colIndex > 0) | CALL_EXT | siMain.SetColumnFormat | (colIndex, 1, "#,###.#########", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63f0613e | this.Load 외 2 | FP00598_RowExcelPopup.cs:422 | if (DoSearchData != null) ▸ try ▸ lambda ▸ if (set.Good() && ColumnColor.Count > 0) ▸ foreach (var m in ColumnColor.Data) ▸ if (c!=null) ▸ i… | GRID_STYLE | siMain.SetBGColor | (0, colIndex, rowcount-1, colIndex, c) | 그리드 표시 설정 |  |  |  |
| AC-1ce3059a | this.Load 외 2 | FP00598_RowExcelPopup.cs:426 | if (DoSearchData != null) ▸ try ▸ lambda | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2cc37d78 | this.Load 외 2 | FP00598_RowExcelPopup.cs:435 | if (DoSearchData != null) ▸ finally | CALL_BASE | this.Invoke | (new Action(delegate () { //this.Enabled = false; this.spdMain.Enabled = true; this.btnClo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d23e54d8 | this.Load 외 2 | FP00598_RowExcelPopup.cs:438 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-84f19075 | this.Load 외 2 | FP00598_RowExcelPopup.cs:439 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7216278d | this.Load 외 2 | FP00598_RowExcelPopup.cs:440 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-3d8e6ee2 | this.Load 외 2 | FP00598_RowExcelPopup.cs:441 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f002bb2e | this.Load 외 2 | FP00598_RowExcelPopup.cs:442 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7bd18d34 | this.Load 외 2 | FP00598_RowExcelPopup.cs:443 | if (DoSearchData != null) ▸ finally ▸ lambda | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00598_RowExcelPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb0fcb71 | this.Load | FP00598_RowExcelPopup.cs:144 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ec2bff3 | this.Load | FP00598_RowExcelPopup.cs:146 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00598_RowExcelPopup.GetExcelFileName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54197687 | (진입점 미연결) | FP00598_RowExcelPopup.cs:696 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-746a9833 | (진입점 미연결) | FP00598_RowExcelPopup.cs:697 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-b697f06f | (진입점 미연결) | FP00598_RowExcelPopup.cs:698 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-8ba04421 | (진입점 미연결) | FP00598_RowExcelPopup.cs:699 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-926aac6f | (진입점 미연결) | FP00598_RowExcelPopup.cs:700 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-b0af7c69 | (진입점 미연결) | FP00598_RowExcelPopup.cs:701 | try | UI_PROP | openFile.FileName | FileName | 속성 FileName 설정 |  |  |  |
| AC-69580d49 | (진입점 미연결) | FP00598_RowExcelPopup.cs:702 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5ed42623 | (진입점 미연결) | FP00598_RowExcelPopup.cs:704 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-86b1fb4f | (진입점 미연결) | FP00598_RowExcelPopup.cs:705 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-649d1085 | (진입점 미연결) | FP00598_RowExcelPopup.cs:709 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-680a8be8 | (진입점 미연결) | FP00598_RowExcelPopup.cs:710 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## FP00598_RowExcelPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8ad9745 | this.Load | FP00598_RowExcelPopup.cs:185 |  | UI_PROP | dateRange.Value1 | DateTime.ParseExact(sStartDate, "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-1451ec27 | this.Load | FP00598_RowExcelPopup.cs:186 |  | UI_PROP | dateRange.Value2 | DateTime.ParseExact(sEndDate, "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-68922a0d | this.Load | FP00598_RowExcelPopup.cs:190 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sStartDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value1 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value1 설정 |  |  |  |
| AC-f5038d8e | this.Load | FP00598_RowExcelPopup.cs:191 | if (Filter["PLAN_TYPE"] == "RELEASE") ▸ if (int.Parse(sEndDate) < int.Parse(Filter["CURR_DATE"].ToString())) | UI_PROP | dateRange.Value2 | DateTime.ParseExact(Filter["CURR_DATE"].ToString(), "yyyyMMdd", null) | 속성 Value2 설정 |  |  |  |
| AC-b1b105ca | this.Load | FP00598_RowExcelPopup.cs:194 |  | DATA_OP | Filter["BUCKET_FROM"] | dateRange.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-6098cde7 | this.Load | FP00598_RowExcelPopup.cs:195 |  | DATA_OP | Filter["BUCKET_TO"] | dateRange.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4b543c76 | this.Load | FP00598_RowExcelPopup.cs:197 |  | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00598_RowExcelPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cafdd643 | this.Load | FP00598_RowExcelPopup.cs:267 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3e338549 | this.Load | FP00598_RowExcelPopup.cs:268 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00598_RowExcelPopup.InitSpread_Merge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f04bfa3 | (진입점 미연결) | FP00598_RowExcelPopup.cs:288 |  | GRID_INIT | siMain.Freeze | (0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00598_RowExcelPopup.OpenAndLoadExcelData

진입점: this.btnUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f6ec90a | this.btnUpload.Click | FP00598_RowExcelPopup.cs:734 |  | FLAG | FileName | ExcelService.GetExcelFileName(FileName) | 화면 필드/플래그 변경 |  |  |  |
| AC-f07c6e26 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:734 |  | CALL_EXT | ExcelService.GetExcelFileName | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08574273 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:736 |  | FLAG | hasError | false | 화면 필드/플래그 변경 |  |  |  |
| AC-ff0c928e | this.btnUpload.Click | FP00598_RowExcelPopup.cs:737 |  | FLAG | IsExcelChanged | true | 화면 필드/플래그 변경 |  |  |  |
| AC-65eb0c44 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:738 |  | CALL_EXT | System.IO.File.Exists | (FileName) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41a15c57 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:740 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d1a1c2ad | this.btnUpload.Click | FP00598_RowExcelPopup.cs:745 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | FLAG | hasError | ExcelService.LoadExcelFileDayNumber( FileName, KeyColumns, KeyColumnList, DictColumn, Head… | 화면 필드/플래그 변경 |  |  |  |
| AC-e42b572e | this.btnUpload.Click | FP00598_RowExcelPopup.cs:745 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | CALL_EXT | ExcelService.LoadExcelFileDayNumber | ( FileName, KeyColumns, KeyColumnList, DictColumn, HeaderLineCount, spdMain, siMain, null,… | ⚠ 의미 확인 필요 |  |  |  |
| AC-63a3f393 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:752 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | STATE | dateRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2c1e30a9 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:754 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-0f36d0cc | this.btnUpload.Click | FP00598_RowExcelPopup.cs:757 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a142a1b5 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:758 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-2c5c7bfd | this.btnUpload.Click | FP00598_RowExcelPopup.cs:762 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_BASE | DoImportData | (dsImport, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4817c6b4 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:763 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | DataService.ReadResult | (importResult) | ⚠ 의미 확인 필요 |  |  |  |
| AC-94ca0d88 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:775 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-418e06b4 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:779 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | FLAG | hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-718e2571 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:791 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b394ea0b | this.btnUpload.Click | FP00598_RowExcelPopup.cs:794 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e9d6200 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:797 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c2b4ce9f | this.btnUpload.Click | FP00598_RowExcelPopup.cs:801 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-009ffb33 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:803 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-869e95b3 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:808 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | CALL_EXT | siMain.SetColumnFormat | (colindex, 1, "#,###,##0.###", "", true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-10228f20 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:810 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) ▸ if (DoImportData != nu… | GRID_STYLE | siMain.SetBGColor3 | (0, colindex, rowcount - 1, colindex, Color.Yellow) | 그리드 표시 설정 |  |  |  |
| AC-96a877ea | this.btnUpload.Click | FP00598_RowExcelPopup.cs:816 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ try ▸ if (hasError == false) | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-3b58cd54 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:821 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ catch () | THROW | throw; |  | 예외 발생 |  |  |  |
| AC-5e505f7f | this.btnUpload.Click | FP00598_RowExcelPopup.cs:825 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4c826709 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:826 | if (string.IsNullOrWhiteSpace(FileName) == false && System.IO.File.Exists(FileName)) ▸ finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7f4ee1b0 | this.btnUpload.Click | FP00598_RowExcelPopup.cs:845 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00598_RowExcelPopup.radioMPP_CheckedChanged

진입점: this.radioMPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfe9413f | this.radioMPP.CheckedChanged | FP00598_RowExcelPopup.cs:929 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-9c77690f | this.radioMPP.CheckedChanged | FP00598_RowExcelPopup.cs:931 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00598_RowExcelPopup.radioWPP_CheckedChanged

진입점: this.radioWPP.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f908918d | this.radioWPP.CheckedChanged | FP00598_RowExcelPopup.cs:938 | if (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "MPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |
| AC-80470a3d | this.radioWPP.CheckedChanged | FP00598_RowExcelPopup.cs:940 | else of (radioMPP.Checked == true) | DATA_OP | Filter["MPP_WPP"] | "WPP_OUT_QTY" | 행/컬럼 값 대입 |  |  |  |

## FP00598_RowExcelPopup.SaveToDB

진입점: this.btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f1256db | this.btnSave.Click | FP00598_RowExcelPopup.cs:456 | if (IsExcelChanged == false) | MESSAGE | MessageBox.Show | ("There is no changed to save") | 메시지 표시 |  |  |  |
| AC-e145fa8b | this.btnSave.Click | FP00598_RowExcelPopup.cs:457 | if (IsExcelChanged == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3df0c654 | this.btnSave.Click | FP00598_RowExcelPopup.cs:461 | if (hasError == true) | MESSAGE | MessageBox.Show | ("You have errors to fix") | 메시지 표시 |  |  |  |
| AC-5597ca19 | this.btnSave.Click | FP00598_RowExcelPopup.cs:462 | if (hasError == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-abb8d7a5 | this.btnSave.Click | FP00598_RowExcelPopup.cs:466 |  | FLAG | ctx | FoxUserInfoContext.GetUserInfoContext() | 화면 필드/플래그 변경 |  |  |  |
| AC-5dc9caa0 | this.btnSave.Click | FP00598_RowExcelPopup.cs:466 |  | CALL_EXT | FoxUserInfoContext.GetUserInfoContext | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-760af68f | this.btnSave.Click | FP00598_RowExcelPopup.cs:471 | if (DoSaveData != null) | STATE | this.spdMain.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9a82d313 | this.btnSave.Click | FP00598_RowExcelPopup.cs:472 | if (DoSaveData != null) | STATE | this.btnClose.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-61b437ec | this.btnSave.Click | FP00598_RowExcelPopup.cs:473 | if (DoSaveData != null) | STATE | this.btnFind.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a147f7d9 | this.btnSave.Click | FP00598_RowExcelPopup.cs:474 | if (DoSaveData != null) | STATE | this.btnDownload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-8ccb1d5c | this.btnSave.Click | FP00598_RowExcelPopup.cs:475 | if (DoSaveData != null) | STATE | this.btnUpload.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c9377da1 | this.btnSave.Click | FP00598_RowExcelPopup.cs:476 | if (DoSaveData != null) | STATE | this.btnSave.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bfe61ddb | this.btnSave.Click | FP00598_RowExcelPopup.cs:484 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-164e1403 | this.btnSave.Click | FP00598_RowExcelPopup.cs:487 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("US… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-eeecd210 | this.btnSave.Click | FP00598_RowExcelPopup.cs:489 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) | DATA_OP | main.Tables[0].Columns.Contains | ("JOB_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-676c1874 | this.btnSave.Click | FP00598_RowExcelPopup.cs:492 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ if (!main.Tables[0].Columns.Contains("JO… | DATA_OP | main.Tables[0].Columns.Add | (itemColumn) | 데이터 객체 조작/조회 |  |  |  |
| AC-dae3a21f | this.btnSave.Click | FP00598_RowExcelPopup.cs:497 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["USER_ID"] | UserInfoContext.Current.UserId | 그리드 속성/값 설정 |  |  |  |
| AC-50f64570 | this.btnSave.Click | FP00598_RowExcelPopup.cs:498 | if (DoSaveData != null) ▸ try ▸ if (main != null && main.Tables != null && main.Tables.Count > 0) ▸ for (i < main.Tables[0].Rows.Count) | GRID_SET | main.Tables[0].Rows[i]["JOB_ORDER"] | i | 그리드 속성/값 설정 |  |  |  |
| AC-48158ef5 | this.btnSave.Click | FP00598_RowExcelPopup.cs:505 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | MESSAGE | MessageBox.Show | ("There is no data to save") | 메시지 표시 |  |  |  |
| AC-49c2d62f | this.btnSave.Click | FP00598_RowExcelPopup.cs:506 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-5af429ea | this.btnSave.Click | FP00598_RowExcelPopup.cs:507 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2088313b | this.btnSave.Click | FP00598_RowExcelPopup.cs:508 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b813e5cf | this.btnSave.Click | FP00598_RowExcelPopup.cs:509 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-6e0b6ee0 | this.btnSave.Click | FP00598_RowExcelPopup.cs:510 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ce6c2b78 | this.btnSave.Click | FP00598_RowExcelPopup.cs:511 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-68435304 | this.btnSave.Click | FP00598_RowExcelPopup.cs:512 | if (DoSaveData != null) ▸ try ▸ if (expect_count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b147eef9 | this.btnSave.Click | FP00598_RowExcelPopup.cs:515 | if (DoSaveData != null) ▸ try | FLAG | validation | null | 화면 필드/플래그 변경 |  |  |  |
| AC-48edf81e | this.btnSave.Click | FP00598_RowExcelPopup.cs:519 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | FLAG | validation | DoValidationData(main, this) | 화면 필드/플래그 변경 |  |  |  |
| AC-031d043e | this.btnSave.Click | FP00598_RowExcelPopup.cs:519 | if (DoSaveData != null) ▸ try ▸ if (DoValidationData != null) | CALL_BASE | DoValidationData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a089fea5 | this.btnSave.Click | FP00598_RowExcelPopup.cs:554 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f22f49c | this.btnSave.Click | FP00598_RowExcelPopup.cs:556 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("NEW_SEQ", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-2090e09a | this.btnSave.Click | FP00598_RowExcelPopup.cs:559 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) | DATA_OP | validation.Tables[0].Columns.Contains | ("NEW_SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-7363157c | this.btnSave.Click | FP00598_RowExcelPopup.cs:561 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("NEW_SEQ")) ▸ foreach (DataRow dr in main.Tables[0].Rows) … | DATA_OP | dr["NEW_SEQ"] | validation.Tables[0].Rows[0]["NEW_SEQ"] | 행/컬럼 값 대입 |  |  |  |
| AC-8bce68ee | this.btnSave.Click | FP00598_RowExcelPopup.cs:566 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("INSTANCE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-de646024 | this.btnSave.Click | FP00598_RowExcelPopup.cs:568 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("INSTANCE_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b09399 | this.btnSave.Click | FP00598_RowExcelPopup.cs:571 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("INSTANCE_ID")) ▸ foreach (DataRow dr in main.Tables[0].Ro… | DATA_OP | dr["INSTANCE_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-fa97f68a | this.btnSave.Click | FP00598_RowExcelPopup.cs:575 | if (DoSaveData != null) ▸ try ▸ if (valid) | DATA_OP | main.Tables[0].Columns.Contains | ("FP_PLAN_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-98c6ac45 | this.btnSave.Click | FP00598_RowExcelPopup.cs:577 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) | DATA_OP | main.Tables[0].Columns.Add | (new DataColumn("FP_PLAN_ID", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-851f3d07 | this.btnSave.Click | FP00598_RowExcelPopup.cs:580 | if (DoSaveData != null) ▸ try ▸ if (valid) ▸ if (!main.Tables[0].Columns.Contains("FP_PLAN_ID")) ▸ foreach (DataRow dr in main.Tables[0].Row… | DATA_OP | dr["FP_PLAN_ID"] | Filter["PLAN_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-cf1aba25 | this.btnSave.Click | FP00598_RowExcelPopup.cs:584 | if (DoSaveData != null) ▸ try ▸ if (valid) | CALL_BASE | DoSaveData | (main, this) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c83f35a6 | this.btnSave.Click | FP00598_RowExcelPopup.cs:597 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("RESULT") | 데이터 객체 조작/조회 |  |  |  |
| AC-bbe8c199 | this.btnSave.Click | FP00598_RowExcelPopup.cs:599 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("COUNT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b131546e | this.btnSave.Click | FP00598_RowExcelPopup.cs:601 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try | DATA_OP | result.Tables[0].Columns.Contains | ("EXCEPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-6670606c | this.btnSave.Click | FP00598_RowExcelPopup.cs:605 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (!string.IsNullOrWhiteSpace(exception)) | MESSAGE | MessageBox.Show | ("Validation error :" + exception) | 메시지 표시 |  |  |  |
| AC-e1739a77 | this.btnSave.Click | FP00598_RowExcelPopup.cs:620 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Save Error")) | 메시지 표시 |  |  |  |
| AC-7e10e00c | this.btnSave.Click | FP00598_RowExcelPopup.cs:621 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ if (result_string != "SUCCESS") | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d1c8deda | this.btnSave.Click | FP00598_RowExcelPopup.cs:625 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | MESSAGE | MessageBox.Show | (string.Format("Data Saved")) | 메시지 표시 |  |  |  |
| AC-5d9c0fb7 | this.btnSave.Click | FP00598_RowExcelPopup.cs:627 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ try ▸ else of (result_string != "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-a476ee04 | this.btnSave.Click | FP00598_RowExcelPopup.cs:632 | if (DoSaveData != null) ▸ try ▸ if (result.Good()) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | ("Unknown validation error :" + e.Message) | 메시지 표시 |  |  |  |
| AC-1e96ddaa | this.btnSave.Click | FP00598_RowExcelPopup.cs:654 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | DATA_OP | xlsrow["MESSAGE"] | valrow["_MSG"] | 행/컬럼 값 대입 |  |  |  |
| AC-10fa9dfc | this.btnSave.Click | FP00598_RowExcelPopup.cs:655 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | CALL_EXT | siMain.SetRowColor | (i, System.Drawing.Color.PaleVioletRed) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ccbea27b | this.btnSave.Click | FP00598_RowExcelPopup.cs:656 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) ▸ if (xlsSrc.Rows.Count >= valSrc.Rows.Count) ▸ for (i < v… | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-8cc57da9 | this.btnSave.Click | FP00598_RowExcelPopup.cs:662 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ if (validation != null) | MESSAGE | MessageBox.Show | (string.Format("There are invalid data.")) | 메시지 표시 |  |  |  |
| AC-68938aa0 | this.btnSave.Click | FP00598_RowExcelPopup.cs:666 | if (DoSaveData != null) ▸ try ▸ else of (result.Good()) ▸ else of (validation != null) | MESSAGE | MessageBox.Show | (string.Format("Save Fail")) | 메시지 표시 |  |  |  |
| AC-9e680456 | this.btnSave.Click | FP00598_RowExcelPopup.cs:672 | if (DoSaveData != null) ▸ catch ((Exception e)) | MESSAGE | MessageBox.Show | (string.Format("Save Fail:"+e.Message )) | 메시지 표시 |  |  |  |
| AC-d7f1eebc | this.btnSave.Click | FP00598_RowExcelPopup.cs:673 | if (DoSaveData != null) ▸ catch ((Exception e)) | FLAG | this.hasError | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f6fd819f | this.btnSave.Click | FP00598_RowExcelPopup.cs:678 | if (DoSaveData != null) ▸ finally | STATE | this.spdMain.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-56086e36 | this.btnSave.Click | FP00598_RowExcelPopup.cs:679 | if (DoSaveData != null) ▸ finally | STATE | this.btnClose.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-023971fe | this.btnSave.Click | FP00598_RowExcelPopup.cs:680 | if (DoSaveData != null) ▸ finally | STATE | this.btnFind.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-a1334f63 | this.btnSave.Click | FP00598_RowExcelPopup.cs:681 | if (DoSaveData != null) ▸ finally | STATE | this.btnDownload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-cc4a5d7e | this.btnSave.Click | FP00598_RowExcelPopup.cs:682 | if (DoSaveData != null) ▸ finally | STATE | this.btnUpload.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ad494e8f | this.btnSave.Click | FP00598_RowExcelPopup.cs:683 | if (DoSaveData != null) ▸ finally | STATE | this.btnSave.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## FP00598_RowExcelPopup.SetSpreadInit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70e8fc3f | this.Load | FP00598_RowExcelPopup.cs:280 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1e911332 | this.Load | FP00598_RowExcelPopup.cs:281 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |

## FP00598_RowExcelPopup.ShowMppWppCtrl

진입점: this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="RELEASE")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85a774a1 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:235 | if (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-667d9900 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:236 | if (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-ae5928bd | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:237 | if (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-379cf2d7 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:241 | else of (show_hide) | UI_PROP | lciMpphead.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-d5ccc7e1 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:242 | else of (show_hide) | UI_PROP | lciMpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-5dd593b3 | this.Load [if (ShowMppWpp==true && Filter["PLAN_TYPE"]=="REL… | FP00598_RowExcelPopup.cs:243 | else of (show_hide) | UI_PROP | lciWpp.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

