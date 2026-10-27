# FRAMEWORK_REF — AS-IS GSCM 프레임워크 검증 메시지 기준서

- 작성일: 2026-10-22 · 대상 소스: `C:\Projects\NSCM\GSCM\01.Framework` (작성 시점 working tree 원문)
- 메시지 원문: `Doc\asisfacts\db\meta\dbo.TB_FX_MessageInfo.csv` (MessageID / Ko / En / Type / Button / UseYN — 아래 인용 메시지는 전부 UseYN=Y)
- 용도: SCP/SSP 화면 C# 판독 에이전트가 "프레임워크 메서드를 호출하면 어떤 검증·메시지가 나오는가"를 판단하는 공통 기준
- 표기: 경로는 `GSCM.Windows.Forms\` 접두 생략. `DataUtil` = `Class\DataUtil.cs`, `DateUtil` = `Class\DateUtil.cs`, `BaseForm` = `UI\BaseForm.cs`, `SpreadInfo` = `Class\SpreadInfo.cs`, `MainForm` = `GSCM_MainForm.cs`, `MessageHelper` = `..\GSCM.App.Core\Text\MessageHelper.cs`
- 분류: **A 차단**(메시지 후 진행 막음) / **B 보정**(값 바꾸고 계속) / **확인**(Yes/No·YesNoCancel 질의 — 답에 따라 진행/중단) / **정보**(성공 안내 등, 검증 아님) / **예외**(catch 에서 ex.Message 표시, 검증 아님) / **주석**(코드상 비활성)

---

## §0. GMessageBox 자체 동작 (MessageHelper)

| 항목 | 내용 | 근거 |
|---|---|---|
| 시그니처 | `public static DialogResult GMessageBox(string messageID, object[] args = null)` | MessageHelper L116 |
| 문구 | `GetMessageInfo(messageID, GAppSettings.LanguageCode)` → KO/EN/CN 컬럼. 문구 내 리터럴 `\r\n`, `\n\r` 를 실제 개행으로 치환 | L92-108, L118 |
| 인자 | `args != null` 이면 `string.Format(message, args)` | L120-123 |
| 아이콘 | Type 0201001=Information, 0201002=Question, 0201003=Exclamation, 0201004=Error, 그 외 Information | L130-146 |
| 버튼 | Button 0202001=OK, 0202002=OKCancel, 0202003=AbortRetryIgnore, 0202004=YesNoCancel, 0202005=YesNo, 0202007=RetryCancel, 그 외 OK | L148-171 |
| 표시 | `MessageBox.Show(message, "GSCM", buttons, icon)` → DialogResult 반환 (호출부가 반환값을 볼 때만 "확인"형) | L173-174 |
| 메시지 미등록 | MessageID 가 없거나 UseYN≠Y 이면 Ko/En/Ch 모두 **MessageID 문자열 그대로** 표시, 버튼 OK | L241-271 |
| GetTerm | `GetTerm(TermID)` → TermInfo XML 에서 TermID 일치 + UseYN=Y 행의 언어 컬럼. **미등록이면 TermID 문자열 그대로 반환** | L278-319 |
| 주석 | `GMessageBox(string, MessageBoxOptions, object[])` 오버로드는 블록주석 | L178-239 (주석) |
| 참고 | `GMessageBoxForException(ex)` — FaultException 의 InnerException.Type 에 "Fox" 포함 시 MSG00042 문구, 아니면 ex.Message. 항상 Error/OK | L322-351, L355-385 |

---

## §1. 화면 판독자용 요약표

### 1-A. 모든 화면에 자동 적용 (base 흐름을 타면 화면 코드와 무관하게 실행)

> 전제: 화면이 `BaseForm` 상속 + `InitForm()` 호출(툴바 버튼·F키·FormClosing 이벤트 등록이 여기서 됨, BaseForm L702-788). 툴바 버튼/F키는 `AssignShortCut`(L946-965) → `OnClick*Button()` 을 거친 뒤에 화면의 `protected override FindButton()/SaveButton()…` 이 호출된다. **화면이 자체 버튼에서 `FindButton()` 등을 직접 호출하면 아래 base 검사는 건너뛴다.**
> `ViewModel == null`(팝업 등)이면 권한·IsChange·Edit 사전검사 블록(아래 ★)이 통째로 생략된다.

| 메서드(트리거) | 자동/명시 | 검증 내용 (쉬운 한국어) | MSG ID | 분류 | 근거 |
|---|---|---|---|---|---|
| `OnClickFindButton` (F5/Find) ★ | 자동 | 조회 권한(SecurityContext.CanSelect) 없으면 막음 | MSG00096 | A | BaseForm L3607-3611 |
| 〃 ★ | 자동 | `IsChange==true`(편집 중 표시)이면 "작업중인 데이터가 있습니다 조회 하시겠습니까?" → No 면 조회 중단 | MSG00127 | 확인 | L3615-3621 |
| `OnClickEditButton` (F2/Edit) ★ | 자동 | 수정 권한(CanUpdate) 없음 | MSG00096 | A | L3668-3672 |
| 〃 ★ | 자동 | 활성 시트가 AllowGroup 상태면 수정모드 불가 | MSG00115 | A | L3675-3679 |
| 〃 ★ | 자동 | 정렬(IsSort) 상태면 수정모드 불가 | MSG00139 | A | L3682-3686 |
| 〃 ★ | 자동 | 정렬 후(IsSortChange)면 재조회 후 수정모드 가능 | MSG00162 | A | L3689-3693 |
| 〃 → `CheckValidation(Edit)` | 자동 | 선택된 Spread(fps) 없으면 막음 (SpreadInfoList 1개면 자동 선택 후 검사) | MSG00007 | A | L3697-3703, L3941-3946 |
| `OnClickInsertButton` (F8) ★ | 자동 | 입력 권한(CanInsert) 없음 | MSG00096 | A | L3790-3794 |
| 〃 → `CheckValidation(Insert)` | 자동 | fps 없음 / 시트가 잠금(수정모드 아님) | MSG00007 / MSG00008 | A | L3816, L3941-3976 |
| `OnClickDeleteButton` (F9) ★ | 자동 | 삭제 권한(CanDelete) 없음 | MSG00096 | A | L3828-3832 |
| 〃 → `CheckValidation(Delete)` | 자동 | fps 없음 / 시트 잠금 | MSG00007 / MSG00009 | A | L3836, L3941-3976 |
| `OnClickSaveButton` (F7) ★ | 자동 | 저장 권한(CanSave) 없음 | MSG00096 | A | L3844-3848 |
| 〃 | 자동 | fps 없으면 **메시지 없이** 중단 | — | A(무음) | L3854 |
| 〃 → `CheckValidation(Save)` | 자동 | 시트 잠금(수정모드 아님) | MSG00010 | A | L3861, L3954-3955, L3965-3969 |
| 〃 | 자동 | 모든 Spread 의 Action 셀에 값(I/M/D 등)이 하나도 없으면 "수정한 내용이 없습니다" — 화면 SaveButton 미호출 | MSG00133 | A | L3864-3919 |
| `OnClickExcelButton` (F12) | 자동 | fps(선택 Spread) 없으면 막음 | MSG00007 | A | L3925, L3941-3946 |
| `ExcelButton` (virtual, F12 경로) | 자동(override 안 했을 때) | "저장하지 않고 바로 열겠습니까?" Yes=바로 열기/No=저장 후/Cancel=중단 | MSG00100 | 확인 | L4204-4211 |
| `OnClickSortButton` (F3), `SortAsc`, `SortDesc` | 자동 | 수정모드(IsEditMode)면 정렬 불가 | MSG00140 | A | L5268-5275, L5623-5628, L5651-5656 |
| `OnClickConditionButton` (F6) → `SavePanelCondition` | 자동 | 조회조건 저장 성공 안내 | MSG00155 | 정보 | L5237-5243, L2165-2169 |
| `OnClickResetConditionButton` (F10) | 자동 | 저장 조건 초기화 확인 → 성공/실패 안내 | MSG00397 / MSG00398 / MSG00399 | 확인/정보 | L5245-5257, L2201-2210 |
| `HelpButton` (F1) → `FileDownLoad` | 자동(override 안 했을 때) | 도움말 PPT "저장하지 않고 바로 열겠습니까?" / 실패 시 파일 없음 | MSG00100 / MSG00132 | 확인/정보 | L4030-4128 |
| `ChildForm_FormClosing` (화면 닫기) | 자동 | IsChange==true 이고 팝업편집체크 켜짐이면 "작업중인 데이터가 있습니다. 이 화면을 닫으시겠습니까?" No → 닫기 취소 | MSG00013 | 확인 | L967-985 |
| MainForm 메뉴 열기 | 자동(메인프레임) | 동시 화면 수 초과 / 권한 없음(-10120) / FP 인스턴스 권한 없음 | MSG00095 / MSG00096 / MSG00367 | A | MainForm L1665, L1676-1683, L1715-1721, L2218-2225 |
| 각종 base 유틸(Hide/Zoom/Freeze/FilterAdd/Export 등) catch | 자동 | 예외 메시지 표시 | MSG00003 | 예외 | §2 참조 |

### 1-B. 화면이 명시 호출할 때만 적용

| 메서드 | 자동/명시 | 검증 내용 (쉬운 한국어) | MSG ID | 분류 | 근거 |
|---|---|---|---|---|---|
| `DataUtil.checkRequiredOfSearch(ControlCollection)` (`if(!…)return` 형태 다수) | 명시 | ① `UsrConditionPanel` 중 **PanelType=HidePanel** 안의 LayoutControl 만 검사. ② 컨트롤명 `cboDivision`/`clbDivision` 인 항목(UsrCombo/UsrCheckedList)이 값 null 또는 Items 0건 → "권한을 가진 Division이 없습니다" (라벨 * 무관) ③ 라벨이 `*` 로 끝나는 항목만 필수: UsrCheckedList/UsrCheckedListBox/UsrCheckedListFilter/UsrColumnCombo/UsrCombo/UsrRadio/UsrMultiLineEditor/UsrMultiTextBox = 값이 `"ALL"` 또는 공백 → 필수 메시지 + 포커스 / UsrTextBox = Text 공백 / UsrComboBox = SelectedValue 가 `"ALL"` (공백은 검사 안 함, 포커스 없음). **날짜 컨트롤 등 그 외 타입은 * 라도 검사 안 함.** 반환 true=통과 | MSG00097 / MSG00002 / MSG00003(예외) | A | DataUtil L67-92, L370-622 |
| `DataUtil.checkRequired(Control)` | 명시 | checkRequiredOfSearch 와 같은 규칙이나 **PanelType 조건 없이** 넘겨준 컨트롤 하위의 LayoutControl 전부 검사 (`pnlCondition`, `usrConditionPanel1` 등에 사용) | MSG00097 / MSG00002 / MSG00003 | A | DataUtil L95-120, L123-368 |
| `DataUtil.checkRequiredOfSpread(SpreadInfo)` | 명시 | Action 이 **I 또는 M 인 행만**(D·빈값 제외) 1번 컬럼~끝 컬럼 중 **컬럼 Label 에 `*` 가 포함된** 컬럼 값이 공백이면 "{컬럼라벨} 값은 필수 입력입니다" 후 false. 숨김 컬럼도 검사(가시성 조건 없음). 예외 시 메시지 없이 false | MSG00002 | A | DataUtil L23-65 |
| `DateUtil.Check_PeriodDate(UsrDateRangePicker / UsrDateRangePicker3)` | 명시 | 기간 From/To: 형식 오류·빈값 → MSG00049 / From>To → MSG00108 / To ≥ From+1년+7일 → "최대 조회일은 From Date + 371 입니다" | MSG00049 / MSG00108 / MSG00172(371) | A | DateUtil L148-233 |
| `DateUtil.Check_PeriodDate_New(picker, addYear, addMonth)` | 명시 | 위와 동일하되 상한 = From+addYear년+addMonth월+7일. 메시지 {0} 은 인자와 무관하게 고정 **584** | MSG00049 / MSG00108 / MSG00172(584) | A | DateUtil L236-328 |
| `BaseForm.SetDivisionAuthCheck(UsrLayoutControl, bool bFlag=true)` | 명시 (보통 Division 콤보 0건일 때 화면이 호출) | bFlag=true 면 "권한을 가진 Division이 없습니다" 표시, **항상** 해당 LayoutControl 을 Enabled=false (조회조건 전체 비활성) | MSG00097 | A | BaseForm L5995-6003 |
| `SpreadInfo.AllowGroup = true` | 명시 | 시트가 잠금 해제(수정모드)인데 그룹 허용 시도 → 막음 | MSG00115 | A | SpreadInfo L11746-11762 |
| `BaseForm.ExcelButtonWithoutCopy()` | 명시 | fps 없음 → MSG00007, 이후 바로열기 확인 | MSG00007 / MSG00100 | A/확인 | BaseForm L6138-6197 |
| `BaseForm.MenuEtcFileDownButton(fileNm)` | 명시 | "저장하시겠습니까?" Yes 만 진행, 실패 시 파일 없음 | MSG00012 / MSG00132 | 확인/정보 | L6026-6110 |
| `BaseForm.AddHelpButton(fileName)` | 명시 | FileDownLoad 와 동일 | MSG00100 / MSG00132 | 확인/정보 | L4138-4148 |
| `ExcelUpload(CExcel).SaveUploadTemp()` / `SaveUploadTableSet()` | 명시(ExcelUploadForm 경유) | 엑셀 행<2 또는 열수<필수타이틀수 → 데이터 없음 / 첫 타이틀 헤더를 1~2행×1~3열에서 못 찾음 → 헤더 확인 | MSG00451 / MSG00450 | A | CExcel L919-927, L945-953, L1132-1140 |
| `ExcelUploadForm` (공통 업로드 팝업) | 명시(화면이 띄움) | 업로드 결과 Error>0 이면 OK 버튼 비활성(isSaveExceptError 예외) · 저장 성공 안내 · 닫기 확인 | MSG00020 / MSG00195 | 정보/확인 | ExcelUploadForm L183-218 |
| `ExcelUploadForm2` (SSP0018/SCP0005 전용 분기 내장) | 명시 | 행별 검증 결과를 Check 컬럼 "Error-…" 로 표시, OK 시 재검증 실패 → "입력하신 값이 조건에 맞지 않습니다. { 항목 }" | MSG00051 / MSG00195 | A(+리포트) | ExcelUploadForm2 L197-207, L731-1173, L1196-1218 |

---

## §2. 호출별 상세 (전수, 122건 = GSCM.Windows.Forms 내 `GMessageBox(` 전 히트)

### 2-1. DataUtil.cs (27건, 주석 0)

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO 메시지 / {0} | 후속 동작 | 분류 | 주석 |
|---|---|---|---|---|---|---|---|
| DataUtil:54 | `public static bool checkRequiredOfSpread(SpreadInfo siMain)` | 행 action∈{I,M}(L33-36), 컬럼 iCol=1..Max, `col.Label` 에 `'*'` 포함(L42-43), `string.IsNullOrWhiteSpace(siMain.GetValue(iRow,iCol).ToString())` (L45-47) | MSG00002 | "{0} 값은 필수 입력입니다" / {0}=`GetTerm(컬럼 Label 원문)` (Label 에 `*` 포함된 채로 TermID 조회) | `return false` (첫 위반 1건만) | A | - |
| DataUtil:149 | `private static bool RequriedCheck(Control)` (← `checkRequired`) | LayoutControl 항목 ControlName ∈ {cboDivision, clbDivision} && Control is UsrCombo && `(ControlValues == null \|\| Items.Count == 0)` | MSG00097 | "권한을 가진 Division이 없습니다." | bCheckFalg=false, return | A | - |
| DataUtil:161 | 〃 | 위와 동일, Control is UsrCheckedList | MSG00097 | 〃 | 〃 | A | - |
| DataUtil:189 | 〃 | `sName.EndsWith("*")` && UsrCheckedList && `(ControlValues == "ALL" \|\| IsNullOrWhiteSpace(ControlValues))` | MSG00002 | {0}=`GetTerm(ctlItem.CustomizationFormText)` | Focus, return | A | - |
| DataUtil:208 | 〃 | * && UsrCheckedListBox && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:226 | 〃 | * && UsrCheckedListFilter && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:244 | 〃 | * && UsrColumnCombo && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:262 | 〃 | * && UsrCombo && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:280 | 〃 | * && UsrRadio && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:297 | 〃 | * && UsrMultiLineEditor && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:315 | 〃 | * && UsrMultiTextBox && ALL/공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:333 | 〃 | * && UsrTextBox && `IsNullOrWhiteSpace(usrCtl.Text)` ("ALL" 비교 없음) | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:351 | 〃 | * && UsrComboBox && `SelectedValue.ToString() == "ALL"` (공백 비교 없음, SelectedValue null 이면 예외→L364) | MSG00002 | 〃 | return (Focus 없음) | A | - |
| DataUtil:364 | 〃 catch | 위 처리 중 예외 | MSG00003 | "실행중 에러가 발생했습니다.\n\r {0}" / {0}=ex.Message | bCheckFalg 그대로(false) → 호출부 false | 예외 | - |
| DataUtil:401 | `private static bool InitCheck(Control)` (← `checkRequiredOfSearch`/`CheckInitCondition`) | ctl is UsrConditionPanel && `UsrPanelType == HidePanel` → 하위 LayoutControl → cboDivision/clbDivision && UsrCombo && (null \|\| Items 0) | MSG00097 | "권한을 가진 Division이 없습니다." | return | A | - |
| DataUtil:413 | 〃 | 〃 UsrCheckedList | MSG00097 | 〃 | return | A | - |
| DataUtil:441 | 〃 | HidePanel && * && UsrCheckedList && ALL/공백 | MSG00002 | {0}=GetTerm(CustomizationFormText) | Focus, return | A | - |
| DataUtil:460 | 〃 | 〃 UsrCheckedListBox | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:478 | 〃 | 〃 UsrCheckedListFilter | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:496 | 〃 | 〃 UsrColumnCombo | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:514 | 〃 | 〃 UsrCombo | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:532 | 〃 | 〃 UsrRadio | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:549 | 〃 | 〃 UsrMultiLineEditor | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:567 | 〃 | 〃 UsrMultiTextBox | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:585 | 〃 | 〃 UsrTextBox && Text 공백 | MSG00002 | 〃 | Focus, return | A | - |
| DataUtil:603 | 〃 | 〃 UsrComboBox && SelectedValue=="ALL" | MSG00002 | 〃 | return (Focus 없음) | A | - |
| DataUtil:618 | 〃 catch | 예외 | MSG00003 | {0}=ex.Message | false | 예외 | - |

### 2-2. DateUtil.cs (16건, 주석 0) — 4개 메서드 × 4건 동일 구조

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO 메시지 / {0} | 후속 | 분류 |
|---|---|---|---|---|---|---|
| DateUtil:160 | `public static bool Check_PeriodDate(UsrDateRangePicker period)` | `string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)` (date = Text1/Text2 에서 "-" 제거) | MSG00049 | "유효한 날짜 형식이 아닙니다. {0}" / {0}="" | return false | A |
| DateUtil:169 | 〃 | `nDate1 > nDate2` | MSG00108 | "시작일자가 종료일자보다 늦을 수 없습니다." / args={null} | return false | A |
| DateUtil:177 | 〃 | `nDate2 >= Int(GetDateAdd(GetDateAdd(date1,1,"Y"),7,"D"))` | MSG00172 | "최대 조회일은 From Date + {0} 입니다." / {0}="371" | return false | A |
| DateUtil:182 | 〃 catch | 파싱 등 예외 | MSG00049 | {0}="" | return false | A |
| DateUtil:203/213/222/228 | `public static bool Check_PeriodDate(UsrDateRangePicker3 period)` | 위 160/169/177/182 와 동일 | MSG00049/00108/00172("371")/00049 | 동일 | false | A |
| DateUtil:251 | `public static bool Check_PeriodDate_New(UsrDateRangePicker period, string addYear, string addMonth)` | 빈값 | MSG00049 | {0}="" | false | A |
| DateUtil:261 | 〃 | From>To | MSG00108 | | false | A |
| DateUtil:270 | 〃 | `nDate2 >= From + addYear년 + addMonth월 + 7일` | MSG00172 | {0}="584" (=364+7+213, 고정) | false | A |
| DateUtil:276 | 〃 catch | 예외 (addYear/addMonth 숫자 아님 포함) | MSG00049 | {0}="" | false | A |
| DateUtil:298/308/317/323 | `Check_PeriodDate_New(UsrDateRangePicker3, string, string)` | 251/261/270/276 과 동일 | 동일 | 동일 | false | A |

판독 주의(원문 근거):
- `GetDateAdd(date1, …)` 가 빈값 검사(L158)보다 **먼저** 실행된다(L155). date1 이 8자리가 아니면 `GetStringToDate` 가 throw(L65) → catch → MSG00049. 즉 **From 이 비면 L160 이 아니라 L182(catch)에서 MSG00049**, From 정상·To 빈값이면 L160 에서 MSG00049. 사용자 화면에는 같은 메시지.
- 상한 비교는 `>=` 이므로 **허용 최대 To = From + 1년 + 6일** (Check_PeriodDate). `_New` 는 From + addYear년 + addMonth월 + 6일.
- 그 외 DateUtil public 메서드(`GetStringToDate`, `GetDateAdd`, `MonthDiff`, `GetDateString`, `GetDayRange`×2, `GetDayRangeToWeeks`, `GetWeekName`, `GetDateTermInfo`, `GetYYYYMMDD`)는 **메시지 없음**. `GetStringToDate`/`GetDateString` 은 형식 오류 시 `throw new Exception("날짜형식(yyyyMMdd)의 문자열을 입력해 주세요")`(L65, L131) — 화면 catch 가 표시 방식 결정. `GetDayRange(division,…)` 는 SP `SCP.SCM0001_GET_SCP_MONTH_PERIOD` 호출, 예외 시 빈 문자열(L344-358).

### 2-3. BaseForm.cs (46건 = 활성 44 + 주석 2)

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO 메시지 / {0} | 후속 | 분류 | 주석 |
|---|---|---|---|---|---|---|---|
| BaseForm:768 | `public void InitForm()` catch | 툴버튼 생성/InitSpread/DefineEvent 중 예외 | MSG00003 | {0}=ex.Message | 계속 | 예외 | - |
| BaseForm:979 | `void ChildForm_FormClosing(object, FormClosingEventArgs)` (DefineEvent 로 자동 등록 L786) | `IsPopupEditCheck == true && IsChange == true && e.CloseReason != CloseReason.MdiFormClosing` && `!GSCM_MainForm.IsRoleChanged` && 폼 타입명 ∉ {SCM0005_DynamicQueryListPopUp, SCP0039_ValidationMaster, ExcelUploadForm2} | MSG00013 | "작업중인 데이터가 있습니다. 이 화면을 닫으시겠습니까?" (YesNo) | No → `e.Cancel = true` | 확인 | - |
| BaseForm:1860 | `private void InitPanel(Control)` catch (OnShown→CheckInitCondition) | 조건패널 라벨 다국어화·저장조건 복원 중 예외 | MSG00003 | {0}=ex.Message | 계속 | 예외 | - |
| BaseForm:2168 | `private void SavePanelCondition(Control)` (← OnClickConditionButton/F6) | 저장 대상 조건 수 == 성공 수 | MSG00155 | "조회 조건이 저장되었습니다." | 계속 | 정보 | - |
| BaseForm:2176 | 〃 catch | 예외 | MSG00003 | {0}=ex.Message | 계속 | 예외 | - |
| BaseForm:2204 | `private void ResetPanelCondition()` | `ResetSearchCondition` 성공 | MSG00398 | "검색조건이 초기화 되었습니다" | 계속 | 정보 | - |
| BaseForm:2209 | 〃 | 실패 | MSG00399 | "검색조건 초기화중 오류가 발생하였습니다." | 계속 | 정보(오류) | - |
| BaseForm:3393 | `public void HideColumns()` catch | 예외 | MSG00003 | ex.Message | - | 예외 | - |
| BaseForm:3410 | `public void UnHideColumns()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3428 | `public void HideRows()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3445 | `public void UnHideRows()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3463 | `public void ZoomIn()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3481 | `public void ZoomOut()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3499 | `public void Zoom100()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3572 | `public void FindSheetData()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3588 | `public void Freeze()` catch | 〃 | MSG00003 | 〃 | - | 예외 | - |
| BaseForm:3610 | `public void OnClickFindButton()` | `ViewModel != null && !ViewModel.SecurityContext.CanSelect` | MSG00096 | "사용 권한이 없습니다." | return | A | - |
| BaseForm:3618 | 〃 | `ViewModel != null && IsChange == true` | MSG00127 | "작업중인 데이터가 있습니다 조회 하시겠습니까?" (YesNo) | No → return / Yes → IsEditMode·IsSort·IsSortChange=false, AllowGroup 해제, 필터 해제 후 FindButton() | 확인 | - |
| BaseForm:3671 | `public void OnClickEditButton()` | `ViewModel != null && !CanUpdate` | MSG00096 | "사용 권한이 없습니다." | return | A | - |
| BaseForm:3678 | 〃 | `fps != null && fps.ActiveSheet.AllowGroup` | MSG00115 | "Allow Group일 경우 수정모드로 변경할 수 없습니다." | return | A | - |
| BaseForm:3685 | 〃 | `IsSort` | MSG00139 | "Sort 상태에서는 수정모드를 할 수 없습니다." | return | A | - |
| BaseForm:3692 | 〃 | `IsSortChange` | MSG00162 | "Sort 후에는 조회 후 수정모드로 가능합니다." | return | A | - |
| BaseForm:3793 | `public void OnClickInsertButton()` | `ViewModel != null && !CanInsert` | MSG00096 | "사용 권한이 없습니다." | return | A | - |
| BaseForm:3810 | 〃 | (`//` 주석) IsFilter && 해당 시트 필터 존재 | MSG00229 | "필터 설정을 해제한 이후에 입력 가능합니다." | — | 주석 | **주석** (2022-06-09 요청으로 해제) |
| BaseForm:3831 | `public void OnClickDeleteButton()` | `ViewModel != null && !CanDelete` | MSG00096 | "사용 권한이 없습니다." | return | A | - |
| BaseForm:3847 | `public void OnClickSaveButton()` | `ViewModel != null && !CanSave` | MSG00096 | "사용 권한이 없습니다." | return | A | - |
| BaseForm:3919 | 〃 | CheckValidation(Save) 통과 후 `iActionChk == 0` — 각 SpreadInfo(DisplayedSheet.RowCount>0)에서 기본모드는 **0번 컬럼** 값 != null 행 수, `FIX_SMART_MERGE_FILTER_COMPATABLE_MODE` 이면 Action 컬럼 값 != null 행 수. Action 컬럼 없는 시트는 continue | MSG00133 | "수정한 내용이 없습니다." | SaveButton() 미호출 | A | - |
| BaseForm:3944 | `private bool CheckValidation(ButtonType)` | `this.fps == null` | MSG00007 | "선택한 Spread 가 없습니다." | return false | A | - |
| BaseForm:3968 | 〃 | pType∈{Insert,Delete,Save} && fps 와 같은 SpreadName 의 SpreadInfo 에서 `si.IsLock(si.SheetName)` | MSG00008 / MSG00009 / MSG00010 (msgCode 변수) | "수정모드가 아니므로 추가/삭제/저장할 수 없습니다." | return false | A | - |
| BaseForm:4057 | `private void FileDownLoad(string, string)` (← HelpButton/AddHelpButton) | 항상 질의 | MSG00100 | "저장하지 않고 바로 열겠습니까?" (YesNoCancel) | Yes=다운로드 후 실행 / No=저장대화상자 / Cancel=return | 확인 | - |
| BaseForm:4125 | 〃 | 다운로드 예외(bSuccess=false) | MSG00132 | "파일이 존재하지 않습니다. [{0}]" / {0}=파일명 | 종료 | 정보(오류) | - |
| BaseForm:4193 | `protected virtual void ExcelButton()` | (`/* */` 블록 L4191-4201) 서식 포함 질의 | MSG00094 | "서식을 포함하시겠습니까?" | — | 주석 | **주석** |
| BaseForm:4204 | 〃 | 표시 Spread 확보 후 항상 질의 (표시 Spread 0개면 **무음 return** L4183-4187) | MSG00100 | "저장하지 않고 바로 열겠습니까?" (YesNoCancel) | Yes→ExportExcel(true) / No→ExportExcel(false) / Cancel→return | 확인 | - |
| BaseForm:4468 | `protected virtual void ExportExcel(int ignoreDepth=1, bool RemoveActionCell=true, bool RemoveInvisibleCell=true)` catch | 예외 | MSG00003 | e.Message | finally prg.Close | 예외 | - |
| BaseForm:4587 | `protected virtual void ExportExcel2()` catch | 예외 | MSG00003 | e.Message | - | 예외 | - |
| BaseForm:4831 | `protected virtual void ExportExcel(bool isOpen)` catch | 예외 | MSG00003 | e.Message + SCM_SYS_LOG_BATCH 기록 | - | 예외 | - |
| BaseForm:4929 | `protected virtual void ExportExcel3(bool isOpen)` catch | 예외 | MSG00003 | e.Message + 로그 | - | 예외 | - |
| BaseForm:5033 | `public void FilterAdd()` catch | 예외 | MSG00003 | ex.Message | - | 예외 | - |
| BaseForm:5249 | `public void OnClickResetConditionButton()` | `!IsPopup` 일 때 항상 질의 | MSG00397 | "저장된 검색조건을 초기화 하겠습니까?" (YesNo) | Yes→ResetPanelCondition | 확인 | - |
| BaseForm:5274 | `public void OnClickSortButton()` | `IsEditMode` | MSG00140 | "수정모드에서는 Sort를 할 수 없습니다." | return | A | - |
| BaseForm:5626 | `public virtual void SortAsc()` | `fps != null && IsEditMode` | MSG00140 | 〃 | return | A | - |
| BaseForm:5654 | `public virtual void SortDesc()` | 〃 | MSG00140 | 〃 | return | A | - |
| BaseForm:6000 | `public void SetDivisionAuthCheck(UsrLayoutControl usrLayoutControl, bool bFlag = true)` | `bFlag` | MSG00097 | "권한을 가진 Division이 없습니다." | **무조건** `usrLayoutControl.Enabled = false` | A | - |
| BaseForm:6054 | `private void FileDownLoad_AttcFile(string, string)` (← MenuEtcFileDownButton) | 항상 질의 | MSG00012 | "저장하시겠습니까?" (YesNo) | Yes만 진행 | 확인 | - |
| BaseForm:6107 | 〃 | 실패 | MSG00132 | {0}=파일명 | - | 정보(오류) | - |
| BaseForm:6181 | `public void ExcelButtonWithoutCopy()` | CheckValidation(None) 통과 후 항상 | MSG00100 | YesNoCancel | Yes/No→ExportExcel3(true/false) | 확인 | - |

### 2-4. SpreadInfo.cs (1건)

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO | 후속 | 분류 |
|---|---|---|---|---|---|---|
| SpreadInfo:11757 | `public bool AllowGroup { set }` | `value == true && !IsLock(SheetName)` | MSG00115 | "Allow Group일 경우 수정모드로 변경할 수 없습니다." | return (그룹 미적용) | A |

### 2-5. CExcel.cs (3건) — `class ExcelUpload`

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO | 후속 | 분류 |
|---|---|---|---|---|---|---|
| CExcel:925 | `public bool SaveUploadTemp()` | `iRCnt < 2 \|\| iCCnt < sTitleSet.Length` (UsedRange 행/열, 필수타이틀=SegmentTitle `\|` 분할) | MSG00451 | "업로드할 데이터가 Excel 파일에 없습니다" | return false | A |
| CExcel:951 | 〃 | 1~2행 × 1~3열에서 첫 타이틀(대문자·개행/공백 제거) 일치 셀을 못 찾음 (`iFR == 0 \|\| iFC == 0`) | MSG00450 | "엑셀 파일의 Header 정보 확인 후 재 Upload 하세요" | return false | A |
| CExcel:1138 | `public bool SaveUploadTableSet()` (DoSaveUploadTable 지정 시) | 위와 동일(비교 시 "(EN)" 제거) | MSG00450 | 〃 | return false | A |

참고(GMessageBox 아님): `SaveUploadTableSet` 의 행/열 부족은 `MessageBox.Show("CMsg.CommonMsg(CRM-00028)", …)` **리터럴 문자열** 표시(L1110-1114). 두 메서드 모두 iSaveCnt==0 이면 메시지 없이 false(L1009-1014, L1262-1267). 예외는 `MessageBox.Show(ex.Message)`.

### 2-6. ExcelUploadForm.cs (2건)

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO | 후속 | 분류 |
|---|---|---|---|---|---|---|
| ExcelUploadForm:204 | `private void OnSave_Click()` | `xlUpload.SaveUploadData()` 성공 (SP `SCM.PR_SCM_ADM_SAVE_UPLOAD_DATA`) | MSG00020 | "저장 하였습니다." | Close | 정보 |
| ExcelUploadForm:215 | `private void OnClose_Click()` | `btnOK.Enabled && !xlUpload.UploadSaved` | MSG00195 | "취소하시겠습니까?" (YesNo) | No → 닫기 취소 | 확인 |

비메시지 게이트: `OnOpen_Click` 이 업로드 결과(`SCM.PR_SCM_ADM_GET_UPLOAD_RESULT`)의 success_count>0 && (error_count==0 \|\| isSaveExceptError) 일 때만 OK 버튼 활성(L183-189). 즉 **오류 1건이라도 있으면 저장 불가(메시지 없이 버튼 비활성)**, 오류 내역은 Error Detail 시트에 표시.

### 2-7. ExcelUploadForm2.cs (3건 = 활성 2 + 주석 1)

| 파일:라인 | 메서드 | 조건 원문 | MSG | KO / {0} | 후속 | 분류 | 주석 |
|---|---|---|---|---|---|---|---|
| ExcelUploadForm2:354 | `private bool OnSave_Click()` | (`//` 주석) 행 저장 결과 "S" | MSG00004 | "{0}개의 데이터가 저장되었습니다." | — | 주석 | **주석** |
| ExcelUploadForm2:429 | `private void OnClose_Click()` | 항상 | MSG00195 | "취소하시겠습니까?" | No → return | 확인 | - |
| ExcelUploadForm2:1207 | `private void btnOK_Click(object, EventArgs)` | `OnSave_Click()==false && errorMsg == ""` (= 재검증 실패 또는 RowCount 0) | MSG00051 | "입력하신 값이 조건에 맞지 않습니다. {0}" / {0}=`"{ " + errorVal + " }"` (SCP0005: Required/Departure days/L/T Type/TransMode/From Site/To Site/Unique Duplicate/Duplicate/Number 중 마지막 값. SSP0018 은 errorVal 미설정 → "{  }") | 저장 중단 | A | - |

비GMessageBox: 저장 SP 실패 시 `MessageBox.Show(errorMsg = "Error!\nMsg : "+ERR_MESSAGE, errCode)` (L1213), 업로드 단계 빈파일/헤더불일치는 `MessageBox.Show("CMsg.CommonMsg(CRM-00028)")`/`("CMsg.CommonMsg(ERR-00082)")` 리터럴(L529-541). SSP0018/SCP0005 행 검증 상세는 L731-1173(D 검증리포트형: Check 컬럼 "Error-…" + 행 색칠 + Success/Error/Total 집계).

### 2-8. GSCM_MainForm.cs (22건 = 활성 17 + 주석 5) — 메인 프레임

| 파일:라인 | 메서드 | 조건 | MSG | KO | 후속 | 분류 | 화면공통? | 주석 |
|---|---|---|---|---|---|---|---|---|
| MainForm:614 | `NoticealertControl_ButtonClick` | 공지 확인 저장 성공 | MSG00020 | | — | 주석 | - | **주석** |
| MainForm:780 | `UsrCmbMyGroupID_SelectedIndexChanged` | Role 콤보 변경 시 항상 | MSG00309 | "Change Role이 변경되었습니다. 열려있는 화면이 모두 닫힙니다. 변경하시겠습니까?" | No→원복 / Yes→IsRoleChanged=true 후 전체 화면 CloseAll (→ BaseForm MSG00013 생략) | 확인 | 메인 전용 | - |
| MainForm:823 | `LblCtlLogOut_Click` | 로그아웃 | MSG00066 | "로그아웃 하시겠습니까?" | Yes→Exit | 확인 | 메인 전용 | - |
| MainForm:848 | `TsMenuItemAdd_Click` | 즐겨찾기 추가 | MSG00012 | "저장하시겠습니까?" | Yes만 | 확인 | 메인 전용 | - |
| MainForm:871 | 〃 | 성공 | MSG00020 | "저장 하였습니다." | | 정보 | 메인 전용 | - |
| MainForm:883 | `TsMenuItemDelete_Click` | 즐겨찾기 삭제 | MSG00016 | "삭제 하시겠습니까?" | Yes만 | 확인 | 메인 전용 | - |
| MainForm:906 | 〃 | 성공 | MSG00031 | "삭제 하였습니다." | | 정보 | 메인 전용 | - |
| MainForm:1665 | `BtnItem_ItemClick` (리본 메뉴 클릭) | 메뉴ID 가 "FP" 로 시작(FP01886/FP01887 제외) && FP 인스턴스 권한 조회 결과 0행 | MSG00367 | "You have no FP Instance Authority…" | return(화면 안 열림) | A | FP 메뉴만 (SCP/SSP 무관) | - |
| MainForm:1678 | 〃 catch | `ex.Message == "화면을 더 이상 열 수 없습니다. …"` | MSG00095 | "화면을 더 이상 열 수 없습니다. 기존 화면중 하나를 닫고 다시 시도하십시오." | return | A | 전 화면(열기 시) | - |
| MainForm:1680 | 〃 | 영문 동일 메시지 | MSG00095 | 〃 | return | A | 전 화면 | - |
| MainForm:1682 | 〃 | `ex.Message.StartsWith("[CODE : -10120]")` | MSG00096 | "사용 권한이 없습니다." | return | A | 전 화면 | - |
| MainForm:1718 | `navBarItem_LinkClicked` (즐겨찾기 열기) | 화면 수 초과 | MSG00095 | | return | A | 전 화면 | - |
| MainForm:1720 | 〃 | -10120 | MSG00096 | | return | A | 전 화면 | - |
| MainForm:2038 | `WndProc` | 세션 경과 ≥ 480분 | MSG00126 | "8시간 동안 이벤트가 없어 GSCM 세션이 끊겼습니다." | Environment.Exit | 정보(강제종료) | 앱 전역 | - |
| MainForm:2040 | 〃 | (4시간 버전) | MSG00294 | | — | 주석 | - | **주석** |
| MainForm:2177 | `GSCM_MainForm_FormClosing` | 앱 종료 시 항상 | MSG00163 | "종료 하시겠습니까?" | No→취소 | 확인 | 앱 전역 | - |
| MainForm:2220 | `public override void OpenUserMenu(string prgId)` (← BaseForm.openSubMenu, 화면 간 이동) | 화면 수 초과 | MSG00095 | | return | A | 화면이 openSubMenu 호출 시 | - |
| MainForm:2222 | 〃 | 영문 | MSG00095 | | return | A | 〃 | - |
| MainForm:2224 | 〃 | -10120 | MSG00096 | | return | A | 〃 | - |
| MainForm:2280 | 〃 (`/* */` L2250-2307) | | MSG00095 | | — | 주석 | - | **주석** |
| MainForm:2282 | 〃 | | MSG00095 | | — | 주석 | - | **주석** |
| MainForm:2284 | 〃 | | MSG00096 | | — | 주석 | - | **주석** |

판단: MainForm 메시지는 **화면 내부 검증이 아니다**. 화면 판독 행으로 싣지 말고, 화면이 `openSubMenu(...)` 로 다른 화면을 여는 경우에만 MSG00095/MSG00096 을 해당 이벤트에 참고로 기재. 권한(-10120)은 메뉴 권한 메타(DB) 결정.

### 2-9. PersonalSettingPopup.cs (2건, 대상 목록 외 — grep 전수에서 발견)

| 파일:라인 | 메서드 | 조건 | MSG | 후속 | 분류 |
|---|---|---|---|---|---|
| PersonalSettingPopup:73 | `private void SaveData()` | `usrCmbDefaultRole.SelectedValue == null` | MSG00368 "You need more than default role before saving…" (+ 동일 영문 MessageBox.Show 1회 더) | return | A (개인설정 전용, 화면 무관) |
| PersonalSettingPopup:105 | 〃 | 저장 성공 | MSG00020 | - | 정보 |

---

## §3. 화면 판독자용 메서드 상세 해설

### 3-1. `DataUtil.checkRequiredOfSearch(this.Controls)` — 조회조건 필수 검사 (명시 호출, 사용 빈도 최다 ≈372회)
1. `bCheckFalg=false` 후 폼 최상위 컨트롤을 순회하며 `CheckInitCondition`(재귀) → `InitCheck`. (L67-92)
2. `InitCheck` 는 **`UsrConditionPanel` 이고 `UsrPanelType == HidePanel`(기본값, UsrConditionPanel.cs L15)** 인 컨트롤만 처리. 그 하위 직계 `LayoutControl` 마다:
   - (a) **Division 권한**: `LayoutControlItem.ControlName` 이 `cboDivision` 또는 `clbDivision` 이고 컨트롤이 `UsrCombo`/`UsrCheckedList` 일 때 `ControlValues == null || Items.Count == 0` → MSG00097. 라벨 `*` 여부와 **무관**. (L390-416)
   - (b) **필수(*)**: `ctlItem.Text.EndsWith("*")` 인 항목만. (L427) 컨트롤 종류별 판정:

     | 컨트롤 | 실패 조건 | Focus |
     |---|---|---|
     | UsrCheckedList / UsrCheckedListBox / UsrCheckedListFilter / UsrColumnCombo / UsrCombo / UsrRadio / UsrMultiLineEditor / UsrMultiTextBox | `ControlValues == "ALL"` 또는 `IsNullOrWhiteSpace(ControlValues)` | O |
     | UsrTextBox | `IsNullOrWhiteSpace(Text)` ("ALL" 은 통과) | O |
     | UsrComboBox | `SelectedValue.ToString() == "ALL"` (빈값은 통과, null 이면 예외→MSG00003) | X |
     | 그 외(UsrDatePicker/UsrDateRangePicker/UsrMonthPicker/CheckBox/RadioGroup 등) | **검사 안 함** | - |

     - UsrCheckedList 의 `ControlValues`=`ValueList`: 체크 0건이면 `ALL_VIEW` 시 "ALL", 아니면 콤보 Text; 체크가 있으면 선택 코드 콤마목록 (UsrCheckedList.cs L298-322, L1094-1106). → 아무것도 안 고르면(ALL) 필수 실패.
     - 메시지: MSG00002 "{0} 값은 필수 입력입니다", {0} = `GetTerm(ctlItem.CustomizationFormText)` (소스 주석의 "[{0}] 은 필수 입력사항입니다…"는 **현행 DB 문구와 다름** — DB 문구 기준).
   - (c) LayoutControl 하나를 통과하면 `bCheckFalg = true`(L610).
3. **반환 의미**: true = 통과. 메시지가 뜨면 false. **HidePanel 조건패널이 하나도 없으면 메시지 없이 false** (화면은 `if(!…) return;` 이므로 조회가 무음 중단). HidePanel 이 여러 개면 **첫 통과 패널에서 순회 종료**(L74), 앞 패널이 실패해도 뒤 패널이 통과하면 true 가 될 수 있음(실패 시 루프를 끊지 않음 — L74 는 bCheckFalg==true 일 때만 break).
4. 라벨 다국어: `BaseForm.InitPanel`(OnShown 자동)이 `*` 라벨을 `GetTerm(라벨-*) + "*"` 로 바꿔 둠(BaseForm L1179-1195) → EndsWith("*") 판정 유지.

### 3-2. `DataUtil.checkRequired(Control ctl)` (명시, ≈31회: `pnlCondition`, `usrConditionPanel1` 등)
- `ctl.Controls` 를 재귀하며 **LayoutControl 이면 바로** 3-1 의 (a)(b) 와 동일 판정(PanelType 무관, `RequriedCheck` L123-368). LayoutControl 이 없으면 메시지 없이 false.

### 3-3. `DataUtil.checkRequiredOfSpread(SpreadInfo)` (명시, ≈300회)
- 행 0..RowCount-1 중 Action 셀(`GetColumnIndex("Action")` 컬럼 Text) 이 **"I" 또는 "M"** 인 행만(빈값/기타 skip, "D" skip). (L29-36)
- 컬럼 1..ColumnCount-1(0번 제외) 중 `ActiveSheet.Columns[iCol].Label` 에 `'*'` 가 **어디든 포함**된 컬럼. 숨김 여부 무관. (L38-43)
- `GetValue(iRow,iCol)`(null→"") 가 공백/whitespace → MSG00002, {0} = `GetTerm(Label 원문, * 포함)`, **첫 1건에서 false**. (L45-55)
- 예외 시(예: Action 컬럼 부재로 인덱스 오류 가능) **메시지 없이 false** (L62). 숫자 0 은 공백이 아니므로 통과.

### 3-4. DateUtil 기간 검증 (명시, Check_PeriodDate ≈117회 / _New ≈9회)
- 입력: 기간 컨트롤 `Text1`/`Text2` 에서 "-" 제거한 yyyyMMdd.
- 순서: From 형식(8자리·유효일) 오류 → catch MSG00049 / To 빈값 → MSG00049 / From>To → MSG00108 / To ≥ 상한 → MSG00172.
- 상한: `Check_PeriodDate` = From+1년+7일(미만 허용, {0}="371"); `_New` = From+addYear년+addMonth월+7일({0}="584" 고정 — 인자에 따라 실제 상한과 문구 불일치 가능).
- 반환 false 시 화면이 return 하는지는 화면 코드 확인 필요(통상 `if(!…) return`).

### 3-5. BaseForm 버튼 공통 처리 (자동)
- 진입: 리본 버튼 클릭(`Bt_ItemClick`) 또는 F키(`ProcessCmdKey` → `AssignShortCut`, L940-965). F1 Help, F2 Edit, F3 Sort, F4 Filter, F5 Find, F6 조건저장, F7 Save, F8 Insert, F9 Delete, F10 조건초기화, F12 Excel.
- 권한(★): `ViewModel.SecurityContext` = `Authentication.GetSecurityACL(groupId,userId,menuId)` 결과(L865-883). Find=CanSelect, Edit=CanUpdate, Insert=CanInsert, Delete=CanDelete, Save=CanSave → 없으면 MSG00096.
- 편집 상태 플래그 정의:
  - `IsChange`(public 자동속성 L231): **잠금 해제 시트의 셀을 클릭만 해도 true**, 잠금 시트 클릭 시 false(`FpSpread_CellClick` L2860-2871). `SpreadInfo.Modify`/`Delete`/`Insert` 에서 true(SpreadInfo L9425, L9505, Delete 말미, Insert 말미). FormClosed 에서 false. **OnClickFindButton 은 IsChange 를 리셋하지 않음**(L3624-3626 은 IsEditMode/IsSort/IsSortChange 만).
  - `IsEditMode`(public 필드 L657): `SpreadInfo.SwitchLock()`(인자 없음) 이 잠금 해제 시 true, 잠금 시 false (SpreadInfo L9672-9673, L9702-9703). 다른 SwitchLock 오버로드는 미설정. Find/Save 클릭 시 false.
  - `IsSort`: SortAsc/SortDesc/정렬 메뉴에서 true, SortNone 에서 false. `IsSortChange`: 컬럼 헤더 자동정렬(`BaseForm_AutoSortedColumn` L2733-2741) 시 true. Find/Save 시 둘 다 false.
  - 시트 잠금 = `SpreadInfo.IsLock(sheet)`: AddSheet 시 **true(잠금)** 로 등록(SpreadInfo L412, L547), SwitchLock 계열이 토글.
- Save 흐름 순서: 권한 → fps null 무음 return → IsEditMode/IsSort/IsSortChange=false → fps.Focus → CheckValidation(잠금 시 MSG00010) → Action 값 개수 0 이면 MSG00133 → `SaveButton()`(화면 override).
- Edit 흐름: 권한 → AllowGroup(MSG00115) → IsSort(MSG00139) → IsSortChange(MSG00162) → fps 자동선택 → CheckValidation(Edit)=fps null 만 검사 → 필터 해제 → `EditButton()` → 필터 재설정.
- Excel: CheckValidation(None) → fps null 이면 MSG00007(이 경우 ExcelButton 의 "보이는 Spread 자동 포커스" 로직은 도달 불가) → `ExcelButton()`(virtual) → MSG00100.
- `ReadOnlySheetList`(public List<string> L687): 프레임워크 내 사용처는 `SetFilterALLCancel()` 단 1곳 — 목록에 든 시트는 Find/Edit 전 "필터 일시 해제"를 건너뜀(L3752-3756). **편집 차단·메시지 기능은 없음**.
- 화면 닫기: `ChildForm_FormClosing` — IsPopupEditCheck(기본 true, L664)·IsChange 둘 다 true 이고 MDI 전체종료가 아니며 Role 변경 중이 아니고 예외 폼 3종이 아니면 MSG00013. 화면이 `IsPopupEditCheck=false` 로 끄면 생략.
- 팝업(`IsPopup=true`): OnShown 에서 조회조건 저장값 복원 생략, F6/F10 무시(L5239, L5247). ViewModel null 이면 ★ 권한/IsChange 검사 생략.

### 3-6. `SetDivisionAuthCheck(UsrLayoutControl, bool bFlag=true)` (명시, ≈191회)
- 판정 로직은 **없음**: 호출되면 bFlag=true 일 때 MSG00097 표시 + 조회조건 LayoutControl 비활성. "Division 0건이면 호출" 같은 조건은 **화면 코드**에 있음 → 화면 판독 시 호출 조건을 화면에서 찾아 함께 기재.

---

## §4. 편집 제어용 SpreadInfo 메서드 요약 (메시지 없음)

| 메서드(시그니처) | 동작 | 근거 |
|---|---|---|
| `SetReNumerCellType(SpreadInfo siObj, int ColumIndex)` | 컬럼 NumberCellType: 소수 0, Min 0, Max 9,999,999,999, 천단위, 음수 빨강 | SpreadInfo L13772-13784 |
| `SetReNumerCellType(siObj, int ColumIndex, long lMinValue)` | 소수 0, Min=lMinValue, Max 9,999,999,999 | L13793-13806 |
| `SetReNumerCellType(siObj, int ColumIndex, long lMinValue, int iDecimalPlaces)` | 소수 iDecimalPlaces, Min=lMinValue, Max 9,999,999,999 | L13815-13828 |
| `SetReNumerCellType(siObj, int ColumIndex, long lMinValue, int iDecimalPlaces, long lMaxValue)` | Min/Max/소수 지정 (컬럼 단위) | L13838-13851 |
| `SetReNumerCellType(siObj, int RowIndex, int ColumIndex, long lMinValue, int iDecimalPlaces, long lMaxValue)` | 위와 같으나 **셀 단위** | L13862-13879 |
| (공통) | FarPoint NumberCellType 의 Min/Max 는 편집기 입력 범위 제한(범위 밖 처리 방식은 FarPoint 컨트롤 동작 — 프레임워크 메시지 없음) | - |
| `InitSpreadDateColumn(spdInfo, sFromDate, sTodate, long lMinValue=0, long lMaxValue=9999999999, int iDecimal=0)` | 날짜 동적 컬럼 생성 시 숫자 범위 기본값 0~9,999,999,999 (본문 미정밀판독, 시그니처 기준) | L3635 |
| `SetCellTypeNumber(iRow,iCol,bool blFixedPoint=true)` / `SetCellTypeDateTime` / `SetCellTypeCheckBox(iRow,iCol[,bool bLock])` | 셀 타입 지정. CheckBox 의 bLock=true 면 셀 잠금 | L5824-5844 |
| `LockColumn(int iCol1, bool pLock)` | 단일 컬럼 Locked + 배경(LockColor/UnLockColor) | L6910-6920 |
| `LockColumn(int iCol1, int iCol2, bool pLock)` | 범위 컬럼 잠금 후 **Select(체크) 컬럼은 항상 잠금 해제** | L6921-6941 |
| `LockColumn(int iCol1, int iCol2, bool pLock, bool isAlternatingRow)` | ⚠ iCol1/iCol2 무시, **0번 컬럼만** 잠금/해제 (원문 그대로) | L6952-6969 |
| `LockColumn2(iCol1,iCol2,pLock)` / `LockColumn2(…, bool isAlternatingRow)` | 범위 잠금(Select 예외 없음). 4인자판은 배경만 0번 컬럼, Locked 는 범위 | L6977-7029 |
| `LockRange(...)` / `LockRange2(...)` / `LockRange3(...)` 계열 | 셀 범위 Locked. LockRange3 는 배경을 항상 UnLockColor(팝업용 "수정모드처럼 보이되 입력 불가") | L7032-7160 |
| `IsLockCell(iRow,iCol)` | 셀 합성 스타일 Locked 여부 | L6894-6899 |
| `SwitchLock()` | Action 컬럼 보임/숨김 토글: 숨김→보임 = Action+1~끝 컬럼 잠금해제, 시트 LockFlag=false, **I 행 전체 해제**, `OwnerForm.IsEditMode=true` / 반대는 전부 잠금·IsEditMode=false. Select 컬럼은 항상 잠금(LockColumn2) | L9643-9706 |
| `SwitchLock(bool lock_true_unlock_false)` | 지정 방향으로 Action 컬럼 표시·Action+1~끝 잠금·LockFlag (I 행 처리·IsEditMode 없음) | L9534-9553 |
| `SwitchLock(int iStartColIndex)` / `SwitchLock(int iStart, int iEnd)` | 토글하되 잠금 범위를 지정 컬럼부터/범위로 한정 | L9828-9878 |
| `SwitchLockEx()` | SwitchLock() 과 유사, LockColumn 사용(Select 해제 후 다시 Select 잠금), 반환 = 전환 전 Edit 여부 | L9708-9775 |
| `SwitchLockOneRow(int rowIndex)` | 토글 + 지정 행이 I 면 그 행만 해제/잠금 | L9576-9628 |
| `IsLock(string sSheetName)` / `IsLock()` | 시트 LockFlag (AddSheet 시 true 로 시작) — BaseForm CheckValidation 의 수정모드 판정 원천 | L9777-9807, L412, L547 |
| `SetLockFlag(string, bool)` | LockFlag 직접 설정 | L9809-9822 |
| `SetChangeSheetLockColumn` / `SetChangeSheetSwitchLock` / `SetSwitchLockColumn` / `SetColumnMergeLock` | 시트 전환·머지 후 위 잠금 메서드 호출하는 래퍼 | L275-333 |
| `Insert()` 계열 | 시트 LockFlag=true(수정모드 아님)면 **null 반환(무음)**, 아니면 Action="I" 행 추가·잠금 해제·IsChange=true | L8460~ (조건부만 판독) |
| `Delete()` | Action 컬럼 숨김(=수정모드 아님)이면 무음 return. 선택 행: "I"→행 제거, "D"→삭제 취소(Action 비움), 그 외→"D" 표시. IsChange=true | L9163-9296 |
| `Modify(int iRow1, int iCol1, bool)` | 셀 변경 시(BaseForm defaultSheetDataModel_Changed L3114-3182, 잠금 셀·COLMERGE 제외) Action 빈값이면 "M"(CheckBox 형 Action 은 토글) · IsChange=true. Select 컬럼 변경은 무시 | L9445-9524 |
| `AllowGroup` set | 수정모드에서 true 시도 → MSG00115 (§2-4) | L11746-11770 |
| `ReadOnlySheetList` | SpreadInfo 에는 없음. BaseForm 필드이며 필터 해제 스킵 용도뿐 (§3-5) | BaseForm L687, L3752 |

---

## §5. 판독 범위·한계

### 5-1. 전수 확인 방법
- `grep -n "GMessageBox("` 로 GSCM.Windows.Forms 전체 122건(9파일) 위치 확보 → 호출을 포함한 메서드를 Read. 주석 판정은 `//` 접두와 `/* */` 경계 라인(BaseForm L4191-4201, MainForm L2250-2307)을 직접 확인.
- 활성/주석 집계: DataUtil 27/0, DateUtil 16/0, BaseForm 44/2(L3810, L4193), SpreadInfo 1/0, CExcel 3/0, ExcelUploadForm 2/0, ExcelUploadForm2 2/1(L354), GSCM_MainForm 17/5(L614, L2040, L2280, L2282, L2284), PersonalSettingPopup 2/0 → **활성 114 / 주석 8 / 합 122**.
- MessageHelper.cs: GMessageBox 정의 1(활성) + 오버로드 1(블록주석 L178-239).

### 5-2. Read 한 범위
| 파일 | 총 줄 | Read 범위 |
|---|---|---|
| DataUtil.cs | 851 | 전체(L1-851) |
| DateUtil.cs | 493 | 전체(L1-493) |
| MessageHelper.cs | 405 | 전체 |
| BaseForm.cs | 6,329 | L200-260, L690-1862(InitForm/OnShown/FormClosing/FormClosed/InitPanel 전체), L1930-2219(Save/ResetPanelCondition), L2730-2745, L2855-2945, L3110-3210, L3380-4229(버튼·CheckValidation·Help·ExcelButton 전체), L4455-4475·L4578-4592·L4820-4836·L4918-4935(Export catch 부), L5020-5060, L5230-5300, L5612-5695, L5990-6200 |
| SpreadInfo.cs | 14,762 | L270-335, L3635-3660, L5820-5845, L6560-6575, L6670-6685, L6890-7160, L7607-7656, L8460-8590(조건부만 grep), L9163-9300, L9393-9905, L11725-11775, L13765-13905 |
| CExcel.cs | 1,375 | L860-1375(ExcelUpload.SaveUploadTemp/SaveUploadTableSet/GetUploadResult/SaveUploadData 전체) |
| ExcelUploadForm.cs | 234 | L100-234 |
| ExcelUploadForm2.cs | 1,223 | L60-1223(전체 로직) |
| GSCM_MainForm.cs | 2,326 | L594-618, L775-912, L1603-1745, L1995-2060, L2170-2310 |
| PersonalSettingPopup.cs | - | L55-110 |
| 보조 | | CAppSetting.cs(StringALL="ALL" L104, StringAction="Action" L108, FlagI/M/D L149-151), UsrConditionPanel.cs 전체, UsrCheckedList.cs L295-325·L599-630·L1094-1106 |

### 5-3. 미확인·한계 (추측 금지 — 판독 시 각 화면에서 확인할 것)
1. **ExportExcel 계열 본문**(BaseForm L4220-4942)은 catch 부만 확인. 메시지는 catch 의 MSG00003 뿐임을 grep 으로 확인했으나 내부 분기 동작은 미판독.
2. **SpreadInfo 나머지 public 메서드**(약 14,000줄)는 편집 제어 관련 메서드만 판독. GMessageBox 는 L11757 1건뿐임을 grep 으로 확인. SpreadInfo 내 비-GMessageBox `MessageBox.Show` 활성 호출은 L10395(클립보드 합계 안내) 1건(나머지 5건 주석).
3. **BaseForm 의 비-GMessageBox `MessageBox.Show`**(17곳, 예: FindData/MergeColumns/SortAsc 예외 등)는 검증이 아닌 예외 표시로 보고 전수 상세화하지 않음.
4. **CustomizationFormText 값**: MSG00002 의 {0} 은 `GetTerm(ctlItem.CustomizationFormText)` — 이 값은 각 화면 Designer.cs 에 기록되며 `*` 포함 여부·Term 등록 여부에 따라 표시가 달라진다(미등록이면 원문 그대로). 화면별로 Designer.cs 확인 필요.
5. **컨트롤별 `ControlValues` 의미**: UsrCheckedList 만 추적(체크 0건=ALL 또는 콤보 Text). UsrCombo/UsrRadio/UsrColumnCombo/UsrMultiTextBox/UsrMultiLineEditor/UsrCheckedListBox/UsrCheckedListFilter 의 ControlValues 가 "ALL"/공백을 반환하는 조건은 미추적.
6. **SecurityContext(CanSelect 등) 산출**: `Authentication.GetSecurityACL` 서버측(BizService) 미판독 — 권한 메타(DB) 기준.
7. **FarPoint NumberCellType Min/Max 범위 밖 입력 시 동작**(거부/보정/메시지 여부)은 서드파티 컨트롤 동작으로 소스 근거 없음.
8. `checkRequiredOfSpread` 에서 Action 컬럼이 없을 때 `GetText(iRow,-1)` 가 예외를 내는지는 FarPoint 동작 — 원문상 예외면 무음 false.
9. `OnShown` 의 `FindWhenOpen==true` 시 `FindButton()` 직접 호출(L847-848) — 이 경로는 OnClickFindButton 의 권한/IsChange 검사를 거치지 않는다.
10. 소스 주석 메시지 문구(예: DataUtil "[{0}] 은 필수 입력사항입니다.\n\r다시한번 확인해주세요.")는 현행 DB 문구와 다르다. **표시 문구는 항상 TB_FX_MessageInfo 기준**.
