# 11. 인증 / 인가 / 세션 / SSO

> NSCM 의 사용자 인증·인가 아키텍처. Spring Security + JSON 로그인 필터 + 세션 + `@LoginUser` 파라미터 주입 + `@AuthCheck` 메서드 권한 + 메뉴/버튼 권한 2 테이블.
>
> ⭐ **선행 룰**: [`04_BE_RULES.md`](04_BE_RULES.md), [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) (호출 흐름), [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) (401/403 표시)
> ⭐ **연관**: 메모리 `reference_scm_adm_user_gr_btn_mpg_m.md` (권한 2 테이블 등록 룰)

---

## 1. 한 줄 요약

```
[FE] /user/login (POST {userId})
  ↓ JsonLoginFilter → CustomAuthenticationProvider → CustomUserDetailsService
  ↓ LoginSuccessHandler → JSESSIONID 발급 + UserSession 세션 저장
[BE] 후속 요청은 JSESSIONID 쿠키
  ↓ CustomAuthorizationManager.check()
  ↓ ① @AuthCheck(NONE)  → 통과
  ↓ ② @AuthCheck(LOGIN) → 세션 있나? Y/N
  ↓ ③ @AuthCheck(ALL)   → AuthService.checkMenuBtnAuth(userId, mnuId, shtNm, mnuBtnCd)
  ↓     ↳ SCM_ADM_USER_GR_MNU_MPG_M (메뉴 권한) ⨝ SCM_ADM_USER_GR_MNU_BTN_MPG_M (버튼 권한)
[BE Controller] @LoginUser UserSession userSession
  ↓ LoginUserArgumentResolver → SecurityUtil.getUserSession() 주입
[Service] userSession.getUserId(), .getLangCd(), .getMenus()
```

---

## 2. 핵심 컴포넌트 위치

### 2.1 Backend

```
nscm-be/src/main/java/com/lgcns/nscm/framework/
├── config/SecurityConfig.java                ← @EnableWebSecurity 메인 설정
├── annotation/
│   ├── LoginUser.java                        ← @LoginUser 파라미터 주입
│   └── AuthCheck.java                        ← @AuthCheck(Type.NONE/LOGIN/ALL) 메서드
├── resolver/LoginUserArgumentResolver.java   ← @LoginUser → UserSession 변환
├── security/
│   ├── CustomAuthenticationProvider.java     ← 인증 전략 (userId 기반)
│   ├── CustomAuthorizationManager.java       ← 인가 (@AuthCheck 처리 + URL 권한 매칭)
│   ├── CustomUserDetails.java                ← Principal
│   ├── CustomUserDetailsService.java         ← 사용자 정보 로드
│   ├── SsoService.java / SsoService2.java    ← LG SSO 연동 (개발 진행 / QA 환경 재개)
│   ├── filter/
│   │   ├── JsonLoginFilter.java              ← JSON {userId} 로그인 필터
│   │   └── ExceptionHandlingFilter.java      ← 예외 전파 (500)
│   └── handler/
│       ├── LoginSuccessHandler.java          ← 200 + UserSession
│       ├── LoginFailureHandler.java          ← 401
│       ├── LogoutResponseHandler.java
│       ├── AuthenticationExceptionHandler.java   ← 401 (미인증)
│       └── AccessDeniedExceptionHandler.java     ← 403 (미인가)
├── utils/SecurityUtil.java                   ← getUserSession() / getCurrentUserId()
└── utils/SessionUtils.java
```

### 2.2 Frontend

```
nscm-fe/packages/shared/src/stores/
├── useSessionStore.ts                        ← 세션 정보 + login()/logout()/fetchSession()
└── useAuthStore.ts                           ← (현재 미니멀, useSessionStore 우선 사용)

nscm-fe/packages/foundation/src/
├── apis/axios-interceptors.ts                ← 401 → 로그인 리다이렉트
└── models/common/session.ts                  ← UserSession 타입
```

### 2.3 DB

```
SCM_ADM_USER_M                  ← 사용자 마스터 (USER_ID 기본키)
SCM_ADM_USER_GR_M               ← 사용자 그룹 마스터
SCM_ADM_USER_GR_USER_MPG_M      ← 사용자 ↔ 그룹 매핑 (N:M)
SCM_ADM_USER_GR_MNU_MPG_M       ← 그룹 × 메뉴 권한 (메뉴 접근 가능 여부)
SCM_ADM_USER_GR_MNU_BTN_MPG_M   ← 그룹 × 메뉴 × 버튼 권한 (조회/저장/엑셀/...)
```

---

## 3. `@LoginUser` — Controller 파라미터 주입

### 3.1 표준 사용

```java
@Slf4j
@Tag(name = "Demand. DMF0099")
@RestController
@RequiredArgsConstructor
public class Dmf0099Controller extends BaseController {

    @SystemLog(LogType.BUTTON)
    @AuthCheck(Type.ALL)
    @Operation(summary = "메인 데이터 조회")
    @PostMapping(value = "/demand/dmf0099/main", produces = "application/json; charset=UTF-8")
    public ResponseEntity<BaseResponse<List<Dmf0099Response>>> retrieveMain(
            @LoginUser UserSession userSession,                     // ★ 세션 주입
            @RequestBody @Valid Dmf0099Request dto) throws Exception {
        return successResponseEntity(
            dmf0099Service.retrieveMain(userSession.getUserId(), dto));
    }
}
```

### 3.2 `UserSession` 의 멤버

```java
public class UserSession implements Serializable {
    private String userId;        // 'minyonglee1' 등
    private String userNm;        // 한글 이름
    private String userEngNm;     // 영문 이름
    private String langCd;        // 'KO' / 'EN' / 'CN'
    private List<MenuDto> menus;  // 로그인 시점의 메뉴 트리
}
```

> ❌ **금지**: Controller 에서 `SecurityContextHolder.getContext().getAuthentication()` 직접 호출. 항상 `@LoginUser UserSession` 사용.
> ❌ **금지**: Service / DAO 에 `@LoginUser` 사용. **Controller 파라미터에만**.

### 3.3 Service 로 userId 전달
```java
// Controller
dmf0099Service.retrieveMain(userSession.getUserId(), dto);

// ServiceImpl
public List<...> retrieveMain(String userId, Dmf0099Request dto) {
    params.put("userId", userId);   // SP 의 P_USER_ID 로 전달
    ...
}
```

---

## 4. `@AuthCheck` — 메서드 권한 체크

### 4.1 3 단계 Type

| Type | 의미 | 예시 |
|---|---|---|
| `NONE` | 세션/권한 모두 미확인 | 로그인 페이지, 헬스체크 |
| `LOGIN` (기본값) | 세션만 확인 (인증 = 로그인 여부) | 메뉴 트리 조회, 공통 API |
| **`ALL`** | 세션 + 권한 (메뉴+버튼 매핑) 확인 | **화면별 비즈니스 API (call-proc)** |

### 4.2 표준 사용 패턴

```java
@AuthCheck(Type.NONE)
@GetMapping("/admin/sso/login-page")  // 로그인 페이지 (인증 전)
...

@AuthCheck(Type.LOGIN)               // 기본값과 동일, 생략 가능
@GetMapping("/admin/menu/tree")
...

@AuthCheck(Type.ALL)                 // 권한 체크 (대부분의 비즈니스 API)
@PostMapping("/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc")
...
```

### 4.3 `Type.ALL` 의 동작

`CustomAuthorizationManager._authorize()` 가 URL 패턴을 파싱:
- `/*/*/*/call-proc` 또는 `/*/*/*/excel-upload` 만 권한 체크
- URL 의 (mnuId, shtNm, mnuBtnCd) 추출
- `AuthService.checkMenuBtnAuth(userId, mnuId, shtNm, mnuBtnCd)` 호출
- false → `AccessDeniedException` → 403

→ 권한 체크 SQL: `SCM_ADM_USER_GR_MNU_MPG_M` ⨝ `SCM_ADM_USER_GR_MNU_BTN_MPG_M`

---

## 5. 권한 2 테이블 (메뉴 + 버튼)

신규 화면 등록 시 BLOCK 7 에 **반드시 2 테이블 모두** INSERT.

### 5.1 메뉴 권한 (`SCM_ADM_USER_GR_MNU_MPG_M`)

해당 사용자 그룹이 메뉴에 접근 가능한가?

```sql
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, ...)
SELECT USER_GR_ID, 'DMF0099', 'Y', ...
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = '{형제_메뉴_ID}'  -- 동적 복제 (같은 도메인의 형제 메뉴 기준)
 GROUP BY USER_GR_ID;
```

### 5.2 버튼 권한 (`SCM_ADM_USER_GR_MNU_BTN_MPG_M`)

해당 사용자 그룹이 메뉴의 버튼 (조회/저장/엑셀/...) 을 사용 가능한가?

```sql
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, MNU_BTN_CD, USE_YN, ...)
SELECT USER_GR_ID, 'DMF0099', MNU_BTN_CD, 'Y', ...
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = '{형제_메뉴_ID}'
   AND USE_YN = 'Y';
```

> 메뉴 권한만 등록하고 버튼 권한 누락 → 'No Permission' 오류. **둘 다 INSERT**.
> 하드코딩 그룹 (`'GR_ADMIN'`) 대신 형제 메뉴에서 **동적 복제** (메모리 `reference_scm_adm_user_gr_btn_mpg_m.md`).

---

## 6. 세션 관리

### 6.1 BE 세션
- **Spring Security HttpSession** 기반 (`HttpSessionSecurityContextRepository`).
- 쿠키: `JSESSIONID` (HttpOnly, Secure 옵션은 환경별 설정).
- 로그아웃: `POST /user/logout` → `invalidateHttpSession(true)` + 쿠키 삭제.

### 6.2 FE 세션 (useSessionStore)

```ts
import { useSessionStore } from '@shared/stores';

// 로그인 직후
await useSessionStore.getState().login(userId);

// 페이지에서 세션 사용
const userId = useSessionStore(state => state.session.userId);
const langCd = useSessionStore(state => state.session.langCd);
const menus = useSessionStore(state => state.session.menus);

// 로그아웃
useSessionStore.getState().logout();
```

> ❌ `useAuthStore` 는 미니멀 stub. 실제 세션은 **`useSessionStore`**.

### 6.3 axios 인터셉터 (401 처리)

```ts
// foundation/src/apis/axios-interceptors.ts
api.interceptors.response.use(
  res => res,
  err => {
    if (err.response?.status === 401) {
      useSessionStore.getState().reset();
      window.location.assign('/login');
    }
    return Promise.reject(err);
  }
);
```

---

## 7. SSO (LG SSO 연동)

| 클래스 | 용도 |
|---|---|
| `framework/security/SsoService.java` | 1차 SSO 연동 (개발 진행 중) |
| `framework/security/SsoService2.java` | 2차 SSO 연동 (QA 환경 재개 시) |

> 현재 개발 단계: JSON 로그인 (`/user/login` + `{userId}`) 가 기본. SSO 는 QA 환경에서 재활성화 예정.

---

## 8. 표준 헤더 / 보안 옵션 (SecurityConfig)

```
CSRF: disabled (REST API + 쿠키 세션)
formLogin: disabled (JSON 로그인 필터로 대체)
X-Frame-Options: DENY (클릭재킹 방지)
CSP: default-src 'self' + script-src 'self' + img-src 'self' data:
CORS: CorsConfig 빈에서 환경별 origin 화이트리스트
```

> ❌ **금지**: 위 옵션을 화면 단에서 override. 보안 정책 변경은 `SecurityConfig` PR 로만.

---

## 9. 다국어 / 권한 분기 (사업부 등)

```java
// Service 에서 사용자 사업부 권한 분기
if (Set.of("40", "81", "82").contains(divisionId)) {
    // 사업부별 분기 로직
}
```

- **사업부 분기**: 40 / 81 / 82 등 코드별 분기. 통합하지 말고 그대로 보존 (`09_WIJMO_VALIDATION_EXPRESSION.md` §6 의 As-Is 분기 룰과 동일).
- **언어 코드**: `userSession.getLangCd()` → SP 의 `P_LANG_CD` 로 전달 → `SCM_ADM_MSG_M.LANG_CD` 조회.

---

## 10. 자기 점검 체크리스트

신규 Controller / 화면 작성 후:

```
[ ] Controller 에 @SystemLog(...) + @AuthCheck(Type.ALL) 부착 (call-proc 류는 ALL)
[ ] @LoginUser UserSession userSession 파라미터 (Service 로 userId 전달)
[ ] Service / DAO 에 @LoginUser 사용 0건
[ ] SecurityContextHolder 직접 호출 0건 (SecurityUtil.getUserSession() 또는 @LoginUser)
[ ] DB 권한 2 테이블 모두 INSERT (SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M)
[ ] BLOCK 7 은 형제 메뉴에서 동적 복제 (하드코딩 GR_ADMIN 등 금지)
[ ] FE: useSessionStore 만 사용 (useAuthStore 직접 set 금지)
[ ] FE: 401 처리는 axios 인터셉터에 위임 (페이지에서 중복 처리 X)
```

---

## 11. 관련 문서

| 룰 | 주제 |
|---|---|
| [`04_BE_RULES.md`](04_BE_RULES.md) | BE 패키지 구조 + Controller 표준 |
| [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) | BLOCK 7 권한 등록 패턴 |
| [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) | call-proc URL 패턴 ↔ 권한 매핑 |
| [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) | 401/403 응답 + FE 표시 |
| [`16_LOGGING_AUDIT.md`](16_LOGGING_AUDIT.md) | @SystemLog + 사용자 활동 로그 |
| 메모리 `user_login_id.md` | 테스트 USER_ID = `minyonglee1` |
| 메모리 `reference_scm_adm_user_gr_btn_mpg_m.md` | 권한 2 테이블 동적 복제 룰 |
