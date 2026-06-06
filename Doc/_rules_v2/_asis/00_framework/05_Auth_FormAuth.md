# AS-IS Framework — 권한 / 인증 / 사용자 컨텍스트 정밀 분석

> **source 분포**:
> - BaseForm.cs §7 (FormAuth enum + SecurityContext + bEnable + SetDivisionAuthCheck)
> - DataService.cs (`_SAVE_AUTH` 플래그 + EncryptUserID)
> - **App.Core/Security/UserInfoContext.cs** (201 lines, 전체 read)
> - **App.Core/GAppSettings.cs** (100 lines, 전체 read)

---

## §0 메타

| 항목 | 값 |
|---|---|
| Source | 4 파일 통합 분석 |
| 진행도 | **100%** (UserInfoContext + GAppSettings 전체 + BaseForm §7 + DataService 부분) |
| 권한 모델 | 4-layer (사용자 → 권한그룹 → 메뉴/버튼 → 부서) |

---

## §1 권한 4-layer 구조

```
[Layer 1: 사용자 인증]
  UserInfoContext (FoxUserInfoContext 상속)
  ├─ UserId / EMail / UserName / UserName_E
  ├─ Dept_ID / Dept_Name
  ├─ Language / TimeZone
  └─ NewUserID/Name/Dept (impersonation — admin 대리 작업)

[Layer 2: 권한 그룹]
  ├─ DefaultGroupID — 기본 그룹
  └─ NowGroupID — 현재 활성 그룹 (전환 가능)

[Layer 3: 메뉴/버튼 권한 (SecurityContext)]
  ViewModel.SecurityContext (FoxSecurityContext 상속)
  ├─ CanSelect (F5 Find)
  ├─ CanInsert (F8 Insert)
  ├─ CanUpdate (F2 Edit)
  ├─ CanDelete (F9 Delete)
  └─ CanSave (F7 Save)
  
  source: FoxBizClient → "Authentication.GetSecurityACL" SP (BaseForm.CreateSecurityContext line 865)

[Layer 4: 부서 권한 (DivisionAuth)]
  SCM_ADM_USER_GR_UNIT_AUTH_MPG_M (사용자별 Division 권한)
  사용: BaseForm.SetDivisionAuthCheck (line 5995) — 권한 없는 division → 화면 disable
```

---

## §2 UserInfoContext (App.Core/Security/UserInfoContext.cs)

### §2.1 핵심 properties (21 개)

| Property | 의미 | TO-BE 매핑 |
|---|---|---|
| `UserId` (상속) | 사용자 ID (예: minyonglee1) | `@LoginUser.userId` |
| `EMail` | 이메일 | `userInfo.email` |
| `UserName` | 이름 (한국어) | `userInfo.userName` |
| `UserName_E` | 이름 (영어) | `userInfo.userNameE` |
| `Dept_ID` | 부서 코드 | `userInfo.deptId` |
| `Dept_Name` | 부서명 | `userInfo.deptName` |
| `Language` | 사용자 기본 언어 | `userInfo.lang` (i18next 설정) |
| `TimeZone` | 사용자 타임존 | `userInfo.timezone` |
| `FuncCode` | = `DefaultGroupID` | (deprecated, alias) |
| `DefaultGroupID` | 기본 권한 그룹 | `userInfo.defaultGrId` |
| **`NowGroupID` ⭐** | **현재 활성 권한 그룹** | `userInfo.currentGrId` |
| `NewUserID` 등 6 종 (impersonation) | admin 대리 작업 사용자 정보 | **격차**: TO-BE 미구현 |

### §2.2 호출 패턴 (BaseForm + DataService 안)

```csharp
// 모든 SP 호출에 USER_ID 자동 주입
filter["USER_ID"] = UserInfoContext.Current.UserId;
filter["GROUP_ID"] = UserInfoContext.Current["NowGroupID"];

// 메시지 표시 시 언어 결정
GAppSettings.LanguageCode = UserInfoContext.Current.Language;

// 화면 안에서 부서 ID 사용
string deptId = UserInfoContext.Current.Dept_ID;
```

### §2.3 ⚠️ Impersonation (격차 후보 G7)

```csharp
// admin 이 다른 user 대신 작업 가능
NewUserID / NewUserName / NewDeptID 등 7 properties
```

- AS-IS 는 admin 이 다른 user 권한으로 화면 진입 가능
- TO-BE 미구현
- 사용 빈도 확인 필요 → **G7 후보** (사용자 결정)

---

## §3 GAppSettings (App.Core/GAppSettings.cs)

### §3.1 환경 설정

| Property/Method | 의미 | TO-BE 매핑 |
|---|---|---|
| `LAUNCHER_TYPE` ("DEV"/"LIVE") | 환경 구분 | Spring profile (`local/dev/prod`) |
| `LanguageCode` (static) | 현재 언어 (KO/EN/CN) | i18next `lng` |
| `GetLauncherType()` | env 설정 읽기 | `@Profile` annotation |
| `GetHelpServer / Port / Path` | 도움말 서버 URL | (TO-BE 별도 / 격차 가능) |
| `GetSaveSCPPath()` | SCP 저장 경로 | (TO-BE 별도 미사용) |
| `GetUpdateServer()` | 업데이트 서버 | (TO-BE 별도 미사용) |

### §3.2 ⚠️ 보안 위험 (TO-BE 이관 시 의무 제거)

```csharp
// ⛔ GAppSettings.cs 안 hardcoded — 절대 TO-BE 로 이관 금지
public const string AESKey    = "ThisIsIkepSecurityKey";  // ⛔ AES 키 hardcoded
public const string AESVector = "ThisIsIkepSecurityKey";  // ⛔
public const string saveSCPPath_dev = "server=165.244.95.223;uid=scp_mgr_dev;pwd=1234qwer;database=LGCE_SCMDEV;";  // ⛔
public const string saveSCPPath_prd = "server=10.34.220.88,7433;uid=scp_mgr_prod;pwd=@gscm2018elql;database=LGCE_SCMPROD;";  // ⛔
```

**TO-BE 이관 의무**:
- AES 키 → Spring Boot `Jasypt` 또는 Vault/AWS Secrets Manager
- DB connection → `config-local.yml` (gitignore) + 환경변수 / Vault
- 절대 source code 에 hardcoding 금지 (룰 28 `.gitignore` 강화)

→ Phase 4 `_tobe/11_be_controller_service.md` §보안 섹션에 명문화.

---

## §4 FormAuth enum (BaseForm:5395)

```csharp
public enum FormAuth { None, Disable, Inquiry, Update, All }
```

| 값 | 의미 | bEnable[] |
|---|---|---|
| `None` | 권한 미지정 (초기) | (default) |
| `Disable` | 모든 UI disabled | 모두 false |
| `Inquiry` | 조회만 (F5) | [F=T, I=F, U=F, D=F, S=F, X=T, C=T] |
| `Update` | 조회 + 편집 (F2/F5/F7/F8/F9) | [F=T, I=T, U=T, D=T, S=T, X=T, C=T] |
| `All` | 전체 | 모두 true |

### §4.1 사용 패턴

```csharp
// 화면 InitForm 안에서 결정
protected void InitForm() {
    // ... (검색)
    
    if (resultEmpty) {
        formauth = FormAuth.None;
        bEnable[0] = false;  // Find disabled
        bEnable[1] = false;  // Insert disabled
        // ...
        SetDivisionAuthCheck(usrLayout1, true);  // MSG00097
    } else {
        formauth = FormAuth.Update;
    }
}
```

### §4.2 TO-BE 매핑

- `FormAuth` enum 자체는 **폐기** (TO-BE 더 합리적인 메뉴/버튼 권한 조합)
- `bEnable[]` → `hotkeyConfig.{xxx}: false` (숨김) / 자동 (활성) / 함수 (활성 + 호출)
- `SetDivisionAuthCheck` → BE Division dropdown filter (`SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` cross-check)

---

## §5 SecurityContext (BaseForm:865)

### §5.1 동작

```csharp
protected override FoxSecurityContext CreateSecurityContext() {
    using (var client = new FoxBizClient("GSCM", "GSCM.BizService.WSL/FoxBizService.svc")) {
        var request = new FoxBizRequest("Authentication", "GetSecurityACL");
        request.Parameters["groupId"] = UserInfoContext.Current["NowGroupID"];
        request.Parameters["userId"]  = this.UserInfo.UserId;
        request.Parameters["menuId"]  = this.ViewModel.MenuId;
        var response = client.Execute(request);
        string acl = (string)response.Result;
        return new SecurityContext(acl);
    }
}
```

→ 화면 진입 시 ACL 문자열 받음. `SecurityContext.CanSelect/CanInsert/CanUpdate/CanDelete/CanSave` boolean parse.

### §5.2 ACL 문자열 형식 (추정)

```
"CanSelect=Y;CanInsert=Y;CanUpdate=N;CanDelete=N;CanSave=Y;..."
```

또는 비트 마스크. SP `Authentication.GetSecurityACL` 의 body 분석 필요 (다음 세션 AS-IS DB cross-check).

### §5.3 TO-BE 매핑

| AS-IS | TO-BE | 격차 |
|---|---|---|
| `SecurityContext.CanSelect` | `SCM_ADM_USER_GR_MNU_BTN_MPG_M.BTN_ID='FIND'` 권한 | OK |
| `CanInsert` | `BTN_ID='INSERT'` | OK |
| `CanUpdate` | `BTN_ID='EDIT'` | OK |
| `CanDelete` | `BTN_ID='DELETE'` | OK |
| `CanSave` | `BTN_ID='SAVE'` | OK |
| `Authentication.GetSecurityACL` SP | `MenuController.getButtonPermission(menuId)` (이미 구현) | OK |

→ TO-BE 메뉴/버튼 권한 2 테이블이 더 세밀한 모델. 추가 작업 불필요.

---

## §6 SetDivisionAuthCheck (BaseForm:5995)

```csharp
public void SetDivisionAuthCheck(UsrLayoutControl usrLayoutControl, bool bFlag = true) {
    if (bFlag) MessageHelper.GMessageBox("MSG00097");  // "권한을 가진 Division이 없습니다."
    usrLayoutControl.Enabled = false;
}
```

### §6.1 호출 패턴

```csharp
// 화면 안에서 (DMF0004 예)
DataTable dt = DataService.GetDMInnerTable("MyDivision", filter);
if (dt.Rows.Count == 0) {
    SetDivisionAuthCheck(usrLayout1, true);  // MSG00097 + disable
    return;
}
```

### §6.2 TO-BE 매핑

- AS-IS: `MyDivision` lookup 결과 0 건 → 전체 화면 disable
- TO-BE: 
  - BE 가 `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` 에서 권한 있는 division 만 반환 (이미 구현)
  - FE 의 Division CustomDropdown 이 자동으로 권한 있는 것만 표시
  - 0 건 시 `setAlert(t('MSG00097'))` + Division dropdown disable

→ TO-BE 가 더 세밀 (전체 화면 disable 대신 Division dropdown 만 disable). 추가 작업 불필요.

---

## §7 EncryptUserID (DataService:619)

### §7.1 동작

```csharp
public static Dictionary<string, object> EncryptUserID(IDictionary<string, object> dictParam) {
    // dictParam 안의 USER_ID 를 AES 128 로 암호화
    // BE 가 복호화 후 권한 검증
}
```

`AESEncrypter` 클래스 (GAppSettings.AESKey + AESVector 사용).

### §7.2 TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| USER_ID AES 암호화 → BE 복호화 | JWT session 에서 BE 가 user_id 자동 주입 (`@LoginUser`) |
| AES 키 hardcoded (⛔ 보안 위험) | JWT secret = Vault / 환경 변수 |

→ TO-BE 가 더 안전. 추가 작업 불필요.

---

## §8 `_SAVE_AUTH` 플래그 (DataService)

### §8.1 패턴

```csharp
// 화면 InitForm 안
FilterDataSet filter = new FilterDataSet();
filter["_SAVE_AUTH"] = "Y";  // 저장 권한 (SecurityContext.CanSave 의 SP 인자 전달)
filter["_AUTH"] = "Y";       // 일반 권한
filter["USER_ID"] = UserInfoContext.Current.UserId;
DataTable dt = DataService.GetDMInnerTable("MyDivision", filter);
```

→ SP body 에서 `WHERE USER_ID = @USER_ID AND _SAVE_AUTH = 'Y'` 형식으로 필터링.

### §8.2 TO-BE 매핑

- AS-IS: 명시적 `_SAVE_AUTH = 'Y'` 플래그를 SP 에 전달
- TO-BE: BE 가 메뉴/버튼 권한 cross-check 후 SP 호출 (BE 가 자동 권한 검증)

→ TO-BE 더 합리적. 추가 작업 불필요.

---

## §9 TO-BE 매핑 종합

| AS-IS 메커니즘 | TO-BE 등가물 | 격차 | 위치 |
|---|---|---|---|
| `UserInfoContext.Current.UserId` | `@LoginUser UserInfo` (자동 주입) | OK | `_tobe/11_be_controller_service.md` |
| `UserInfoContext["NowGroupID"]` | `@LoginUser.currentGrId` | OK | 동일 |
| `UserInfoContext.Dept_ID` | `userInfo.deptId` | OK | 동일 |
| `UserInfoContext.Language` | i18next `lng` (자동) | OK | `_tobe/05_constants.md` |
| `UserInfoContext.NewXxx` (impersonation) | (TO-BE 미구현) | **G7 격차 후보** (사용 빈도 확인) | `_mapping/asis_to_tobe.md` |
| `GAppSettings.LanguageCode` | i18next `lng` | OK | - |
| `GAppSettings.AESKey/AESVector` (⛔ hardcoded) | Jasypt / Vault / 환경변수 | **이관 의무 (보안)** | `_tobe/11_be_controller_service.md` §보안 |
| `GAppSettings.saveSCPPath_dev/prd` (⛔ DB 비번 hardcoded) | `config-local.yml` (gitignore) | **이관 의무 (보안)** | 동일 |
| `FormAuth` enum (None/Disable/Inquiry/Update/All) | (폐기) 메뉴/버튼 권한 조합 | OK | (메모리 deprecation 기록) |
| `bEnable[7]` | `hotkeyConfig.{xxx}` (false / 함수 / 생략) | OK | `_tobe/09_subtitle_hotkey.md` |
| `SecurityContext.CanSelect/Insert/Update/Delete/Save` | 메뉴/버튼 권한 2 테이블 | OK (이미 구현) | `_tobe/11_be_controller_service.md` |
| `Authentication.GetSecurityACL` SP | `MenuController.getButtonPermission(menuId)` | OK | 동일 |
| `SetDivisionAuthCheck(usrLayout, true)` | BE Division dropdown filter | OK (이미 구현) | 동일 |
| `MSG00097` "권한 Division 없음" | `setAlert(t('MSG00097'))` | OK | `_tobe/14_error_handling.md` |
| `EncryptUserID` AES + 자동 주입 | JWT session + `@LoginUser` | OK | `_tobe/11_be_controller_service.md` |
| `_SAVE_AUTH = "Y"` SP 플래그 | BE 자동 권한 검증 | OK | 동일 |

---

## §10 격차 후보 G7 (impersonation)

| 항목 | AS-IS | TO-BE 현재 |
|---|---|---|
| Admin 대리 작업 (Switch User) | UserInfoContext.NewUserID/NewUserName/NewDept... 7 properties | 미구현 |

### §10.1 사용 사례 (추정)

- Admin 이 특정 사용자의 권한으로 화면 진입 (트러블슈팅용)
- Audit log 시 원본 사용자 + impersonator 둘 다 기록

### §10.2 사용 빈도

- BaseForm/DataService 안에서 `NewUserID` 등의 직접 사용 0 건 (UserInfoContext 만 정의, 호출 없음)
- → 실제 사용 빈도 매우 낮음 추정
- → **G7 결정**: (a) 격차 유지 권장 / (b) 신규 구현

**Default 결정 (auto mode)**: **(a) 격차 유지** — 사용 빈도 거의 0. 필요 시 사용자가 (b) 결정.

---

## §11 룰셋 v2 반영

- `_tobe/11_be_controller_service.md` (Phase 4 작성)
  - §1 권한: 메뉴/버튼 권한 2 테이블
  - §2 @LoginUser annotation 자동 주입
  - §3 Division dropdown 자동 필터 (SCM_ADM_USER_GR_UNIT_AUTH_MPG_M)
  - §4 **보안 의무**: AES 키 / DB 비번 절대 hardcoding 금지 → Jasypt + 환경변수
  - §5 (G7) impersonation 미구현 (격차 유지)

- 메모리 신규 작성: `feedback_secrets_no_hardcoding.md` — AS-IS GAppSettings 의 hardcoded 보안 정보 (AESKey/DB pwd) 가 TO-BE 로 절대 이관되지 않도록 의무화. `.gitignore` cross-check (룰 28).

---

## §12 진행 / 추가 분석

- ✅ UserInfoContext 21 properties 인벤토리
- ✅ GAppSettings 환경 설정 인벤토리 + 보안 위험 식별
- ✅ FormAuth + SecurityContext + bEnable 권한 4-layer
- ✅ TO-BE 매핑 종합 (대부분 이미 구현 — 추가 작업 G7 만 결정 보류)
- ⏳ Pending: `FoxUserInfoContext` (TheOne lib) 상속 부모 클래스의 method (UserId 외)
- ⏳ Pending: `FoxSecurityContext` 상속 부모 (ACL parse 패턴)
- ⏳ Pending: AS-IS DB cross-check — `Authentication.GetSecurityACL` SP body
