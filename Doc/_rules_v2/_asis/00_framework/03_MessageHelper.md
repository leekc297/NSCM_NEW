# AS-IS Framework — `MessageHelper` 정밀 분석

> **source**: `C:\Projects\NSCM\GSCM\01.Framework\GSCM.App.Core\Text\MessageHelper.cs` (405 lines)
>
> **클래스**: `public class MessageHelper` (static utility, App.Core.Text)
>
> **중요성**: 모든 도메인 화면이 `MessageHelper.GMessageBox(MSG_ID)` 호출 — i18n 다국어 메시지 + Icon/Button 자동 결정 + string.Format args. TO-BE i18next 와 1:1 매핑.

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | `01.Framework/GSCM.App.Core/Text/MessageHelper.cs` |
| Lines | 405 |
| 클래스 | `public class MessageHelper` (static) |
| 부속 DTO | `MessageInfo` (MessageID/Ko/En/Ch/Type/Button) / `TermInfo` (TermID/Ko/En/Ch) |
| 저장소 | XML 파일 (`MessageInfo.xml` / `TermInfo.xml`) → `XDocument` |
| 다국어 | 3 언어 (KO / EN / CN) |
| 진행도 | **100% 분석 완료** (파일 전체 read) |

---

## §1 public API 인벤토리

| 라인 | 시그니처 | 책임 |
|---:|---|---|
| 50 | `static void WriteMessageToXML(folderPath, DataSet ds, MessageType type)` | DB 다운로드 → XML 저장 (`MessageInfo.xml` 또는 `TermInfo.xml`) |
| 92 | `static string GetMessageInfo(messageID, languageCode)` | 텍스트만 반환 + `\r\n` `\n\r` escape → newline 변환 |
| 116 | **`static DialogResult GMessageBox(messageID, args=null)` ⭐⭐** | **핵심 API** — Icon/Button 자동 결정 + format args + MessageBox.Show |
| 241 | `static MessageInfo GetMessageInfo(messageID)` (private) | XML LINQ 검색 — `UseYN='Y'` 필터링 |
| 278 | `static string GetTerm(termID)` | 용어 (Term) 텍스트만 반환 |
| 293 | `static TermInfo GetTermInfo(termID)` (private) | TermXDoc LINQ 검색 |
| 322 | `static DialogResult GMessageBoxForException(Exception ex)` | exception 처리 + FaultException 자동 분류 |
| 355 | `static DialogResult GMessageBoxForException(Exception ex, MessageBoxOptions option)` | async progress 위에 표시 변형 |

---

## §2 XML 데이터 구조

### §2.1 MessageInfo.xml (메시지)

```xml
<DataSet>
  <Table>
    <MessageID>MSG00096</MessageID>
    <Ko>사용 권한이 없습니다.</Ko>
    <En>You do not have permission.</En>
    <Ch>没有权限。</Ch>
    <Type>0201004</Type>      <!-- Error -->
    <Button>0202001</Button>  <!-- OK -->
    <UseYN>Y</UseYN>
  </Table>
  <!-- ... 다수 -->
</DataSet>
```

### §2.2 TermInfo.xml (용어 / 레이블)

```xml
<DataSet>
  <Table>
    <TermID>LBL_DIVISION</TermID>
    <Ko>사업부</Ko>
    <En>Division</En>
    <Ch>事业部</Ch>
    <UseYN>Y</UseYN>
  </Table>
</DataSet>
```

### §2.3 누락 처리 (중요)

`GetMessageInfo` 의 LINQ 검색이 결과 0 건이면 **`MessageID` 자체를 텍스트로 반환** (fallback). 즉, MSG00999 가 XML 에 없으면 화면에는 "MSG00999" 표시. TO-BE i18next 동일 fallback 동작 의무.

```csharp
if (messafeInfo == null) {
    messafeInfo = new MessageInfo() {
        MessageID = string.Format("{0}", messageID),
        Ko = string.Format("{0}", messageID),  // ← key 자체 fallback
        En = string.Format("{0}", messageID),
        Ch = string.Format("{0}", messageID),
        Type = string.Empty,
        Button = string.Empty
    };
}
```

---

## §3 `GMessageBox` 핵심 동작 (line 116-175)

### §3.1 시퀀스

```
GMessageBox("MSG00096", new object[]{"Division"})
  → GetMessageInfo("MSG00096", LanguageCode)         // 텍스트 추출
  → string.Format(message, args)                      // args 치환 → "{0}=Division"
  → GetMessageInfo("MSG00096")                        // MessageInfo (Type/Button) 추출
  → Type 코드 → MessageBoxIcon
  → Button 코드 → MessageBoxButtons
  → MessageBox.Show(formattedMsg, "GSCM", buttons, icon)
  → return DialogResult (OK / Yes / No / Cancel / ...)
```

### §3.2 Type 코드 → MessageBoxIcon (line 130-146)

| Type 코드 | MessageBoxIcon | 의미 | TO-BE 매핑 |
|---|---|---|---|
| `0201001` | Information | 정보 | `setAlert({ type: 'info' })` |
| `0201002` | Question | 질문 (YesNo 분기 유도) | `setConfirm({ type: 'question' })` |
| `0201003` | Exclamation | 경고 | `setAlert({ type: 'warning' })` |
| `0201004` | Error | 오류 | `setAlert({ type: 'error' })` |
| (default) | Information | (fallback) | `setAlert({ type: 'info' })` |

### §3.3 Button 코드 → MessageBoxButtons (line 148-171)

| Button 코드 | MessageBoxButtons | DialogResult 분기 | TO-BE 매핑 |
|---|---|---|---|
| `0202001` | OK | OK 만 | `setAlert(msg)` (await 없음) |
| `0202002` | OKCancel | OK / Cancel | `setConfirm(msg)` — Promise<boolean> |
| `0202003` | AbortRetryIgnore | Abort / Retry / Ignore | **⚠️ TO-BE 미구현 격차 후보** |
| `0202004` | YesNoCancel | Yes / No / Cancel | `setConfirm({type:'yesNoCancel'})` 신규 필요 |
| `0202005` | YesNo | Yes / No | `setConfirm(msg)` — Promise<boolean> (Yes=true/No=false) |
| `0202007` | RetryCancel | Retry / Cancel | **⚠️ TO-BE 미구현 격차 후보** |
| (default) | OK | (fallback) | `setAlert(msg)` |

### §3.4 사용 패턴 인벤토리 (BaseForm 안)

| MSG ID | Type | Button | 의미 | 호출 위치 |
|---|---|---|---|---|
| MSG00003 | Error | OK | 일반 오류 (ex.Message 인자) | InitForm catch |
| MSG00007 | Warning | OK | 선택한 Spread 없음 | CheckValidation |
| MSG00008 | Warning | OK | 수정모드 아님 (Insert) | CheckValidation Insert |
| MSG00009 | Warning | OK | 수정모드 아님 (Delete) | CheckValidation Delete |
| MSG00010 | Warning | OK | 수정모드 아님 (Save) | CheckValidation Save |
| MSG00013 | Question | YesNo | 작업중 데이터, 닫으시겠습니까? | FormClosing |
| MSG00042 | Error | OK | 시스템 오류 | GMessageBoxForException |
| MSG00096 | Error | OK | 사용 권한이 없습니다 | OnClickXxx 권한 |
| MSG00097 | Warning | OK | 권한 Division 없음 | SetDivisionAuthCheck |
| MSG00100 | Question | YesNoCancel | 저장하지 않고 바로 열겠습니까? | ExcelButtonWithoutCopy |
| MSG00127 | Question | YesNo | 작업중 데이터, 조회 하시겠습니까? | OnClickFindButton |
| MSG00132 | Warning | OK | 파일이 존재하지 않습니다 | FileDownLoad |
| MSG00133 | Information | OK | 수정한 내용이 없습니다 | OnClickSaveButton |
| MSG00139 | Warning | OK | Sort 상태 수정 불가 | OnClickEditButton |
| MSG00140 | Warning | OK | 수정모드 Sort 불가 | OnClickSortButton |
| MSG00155 | Information | OK | 조회 조건이 저장되었습니다 | SavePanelCondition |
| MSG00162 | Warning | OK | Sort 후 조회 후 수정 가능 | OnClickEditButton |
| MSG00397 | Question | YesNo | 검색조건 초기화 확인 | OnClickResetConditionButton |
| MSG00398 | Information | OK | 검색조건 초기화 완료 | ResetPanelCondition |
| MSG00399 | Error | OK | 검색조건 초기화 오류 | ResetPanelCondition |

---

## §4 `GMessageBoxForException` 분석 (line 322-385)

### §4.1 동작

```csharp
public static DialogResult GMessageBoxForException(Exception ex) {
    String message = ex.Message;
    FaultException<ExceptionDetail> fex = ex as FaultException<ExceptionDetail>;
    if (fex != null) {
        // TheOne.Data.* (Fox*) 예외 → MSG00042 fallback
        if (fex.Detail.InnerException.Type.Contains("Fox")) {
            message = GetMessageInfo("MSG00042", GAppSettings.LanguageCode);
            // "시스템 오류입니다. 담당자에게 화면 캡쳐해서 시스템 담당자에게 전달하세요."
        }
    }
    return MessageBox.Show(message, "GSCM", OK, Error);
}
```

### §4.2 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `GMessageBoxForException(ex)` | axios interceptor → 전역 error handler → setAlert |
| `FaultException<ExceptionDetail>` (WCF SOAP) | axios `error.response.status` (HTTP) + RFC 7807 |
| Fox* 예외 분류 → MSG00042 | TO-BE BE BusinessException → MSG ID 매핑 (이미 구현) |
| 일반 예외 → ex.Message | TO-BE axios → `error.response.data.message` 또는 일반 fallback |

→ 이미 TO-BE 에 구현된 패턴. 추가 작업 불필요.

---

## §5 TO-BE 매핑 종합

### §5.1 핵심 매핑

| AS-IS | TO-BE | 격차 | 위치 |
|---|---|---|---|
| `MessageInfo.xml` (3 lang XML) | `apps/web/public/locales/{ko,en,cn}/translation.json` (i18next) | OK | `_tobe/05_constants.md` §i18n |
| `TermInfo.xml` (3 lang XML) | 동일 (label 도 `LBLxxxxx` key 로 등록) | OK | 동일 |
| `GetMessageInfo(MSG_ID, lang)` | `t(MSG_ID)` (i18next 가 lang 자동) | OK | - |
| `GetTerm(TERM_ID)` | `t(TERM_ID)` (label key) | OK | - |
| `GMessageBox(MSG_ID, args)` Information | `setAlert(t(MSG_ID, args))` (@shared/hooks) | OK | `_tobe/14_error_handling.md` (Phase 4 신규) |
| `GMessageBox(MSG_ID)` Question YesNo | `await setConfirm(t(MSG_ID))` → boolean | OK | 동일 |
| `GMessageBox(MSG_ID)` Question YesNoCancel | **신규 hook 필요**: `setConfirmYesNoCancel` → 'yes'|'no'|'cancel' | **격차 후보** | 동일 |
| `GMessageBox(MSG_ID)` Question OKCancel | `setConfirm` (OK = Yes, Cancel = No) | OK (의미 동등) | 동일 |
| `GMessageBox(MSG_ID)` AbortRetryIgnore | **TO-BE 미구현** | **격차** (거의 사용 안 됨) | 동일 |
| `GMessageBox(MSG_ID)` RetryCancel | **TO-BE 미구현** | **격차** (거의 사용 안 됨) | 동일 |
| MSG ID 없으면 ID 자체 반환 (fallback) | i18next 기본 동작 동일 | OK | - |
| `\r\n` escape 처리 | i18next 자동 (JSON 안 `\n`) | OK | - |
| `GMessageBoxForException(ex)` | axios interceptor (이미 구현) | OK | `_tobe/14_error_handling.md` |

### §5.2 i18n 키 등록 의무 (Phase 4 검증)

AS-IS BaseForm + MessageHelper 에서 사용된 모든 MSG ID + Term ID 가 TO-BE `KO.json / EN.json / CN.json` 에 등록되어야 함. 누락 시 화면에 ID 자체 표시.

**검증 grep**:
```bash
# AS-IS 사용된 모든 MSG ID 추출
rg -oh "MSG\d{5}" GSCM/ | sort -u

# TO-BE locales 에서 cross-check
for msgid in $(rg -oh "MSG\d{5}" GSCM/ | sort -u); do
    if ! grep -q "\"$msgid\":" nscm-fe/apps/web/public/locales/ko/translation.json; then
        echo "MISSING: $msgid"
    fi
done
```

→ Phase 4 룰셋 v2 작성 시 자동 검증 명령 포함.

### §5.3 신규 추가 검토 사항 (격차 후보)

| 격차 후보 | AS-IS 사용 빈도 | 신규 구현 결정 |
|---|---|---|
| `YesNoCancel` (3 옵션) | MSG00100 (Excel save) 등 일부 | **G6 결정 필요** — 신규 `setConfirmYesNoCancel` hook |
| `AbortRetryIgnore` | 거의 사용 안 됨 (검증 필요) | (a) 격차 유지 (b) 신규 — 권장 (a) |
| `RetryCancel` | 거의 사용 안 됨 (검증 필요) | (a) 격차 유지 (b) 신규 — 권장 (a) |
| `GetTerm("LBL_XXX")` 별도 XML | TO-BE 는 통합 i18n JSON | OK (이미 매핑) |

> **G6 결정 필요**: `YesNoCancel` 3옵션 confirm 의 신규 구현. 사용자 결정.

---

## §6 신규 화면 작성 시 i18n 규약 (Phase 4 룰화 예정)

### §6.1 MSG ID 규약

- 형식: `MSG` + 5자리 숫자 (`MSG00001` ~ `MSG99999`)
- 화면 공통: `MSG00001 ~ MSG00400` (BaseForm + MessageHelper 사용)
- 화면 특화: `MSG10000 ~` (도메인별 할당)
- 예외 처리 fallback: `MSG00042` (시스템 오류)

### §6.2 LBL ID 규약 (메모리 `feedback_i18n_lbl_code_pattern.md` 확장)

- 형식: `LBL` + 5자리 숫자
- 신규 라벨은 `KO.json` 의 최대값 +1 부터 100-block 단위 (예: DMF0020 = LBL00501~514)
- 절대 금지: 자유 형식 (`LBL_DMF0020_DIV` 등)

### §6.3 사용 패턴 (TO-BE)

```typescript
// Alert (OK 만)
setAlert(t('MSG00133'));  // "수정한 내용이 없습니다"

// Alert with args
setAlert(t('MSG00002', { fieldName: t('LBL00001') }));  // "{fieldName} 입력 필요"

// Confirm (Yes/No)
const ok = await setConfirm(t('MSG00127'));  // "작업중인 데이터가 있습니다 조회 하시겠습니까?"
if (!ok) return;

// Confirm with reset (Yes/No)
const ok = await setConfirm(t('MSG00397'));  // "검색조건 초기화 확인"
if (ok) resetCondition.mutate();
```

---

## §7 진행 요약

- ✅ `MessageHelper.cs` 405 lines **100% 분석**
- ✅ 모든 public API (8 method) 인벤토리
- ✅ XML 구조 (MessageInfo / TermInfo) 매핑
- ✅ Type 4종 / Button 7종 코드 표
- ✅ 23 MSG ID 사용 패턴 (BaseForm 안)
- ✅ TO-BE 매핑 (i18next + setAlert/setConfirm)
- ✅ 격차 후보 식별: `YesNoCancel` / `AbortRetryIgnore` / `RetryCancel` 3 종

## §8 결정 의무 (사용자)

- **G6 후보**: `YesNoCancel` 3옵션 confirm 의 신규 구현 여부
  - (a) 격차 유지 — YesNo + 별도 처리로 우회
  - (b) 신규 `setConfirmYesNoCancel(msg) → 'yes'|'no'|'cancel'` hook 추가
  - 권장: **(b)** — AS-IS MSG00100 (Excel save) 등 일부 사용 사례 존재

다른 2 격차 (`AbortRetryIgnore` / `RetryCancel`) 는 사용 빈도 거의 0 으로 추정 → (a) 격차 유지 권장. 사용자 확인 필요.

---

> **다음 단계**: Phase 1 의 남은 framework — `04_Logging.md` (SCM_SYS_LOG / UP_FX_SaveMenuExecutionLog) / `05_Auth_FormAuth.md` (SecurityContext / UserInfoContext) / `06_UsrControls.md` (UsrCombo / UsrCheckedList / UsrConditionPanel / UsrDatePicker — 30+ controls) / `07_FoxDataClient.md` (TheOne lib wrapper).
