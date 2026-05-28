# 14. 에러 처리 (BaseException + Alert/Toast + RFC 7807)

> 클라이언트(React) ↔ Backend(Spring) ↔ DB(Oracle) 전 계층의 에러 처리 표준.
> NSCM 실제 구현 위치 + 표준 코드 + UI 매핑. 화면별 분석의 `E-XXX` 코드는 본 문서 §3 참조.
>
> ⭐ **선행 룰**: `04_BE_RULES.md` §에러 처리 / `03_FE_RULES.md` §에러 처리 / `21_TROUBLESHOOTING.md`
> ⭐ **연관**: `10_API_DYNAMIC_PROC.md` (동적 호출 에러), `12_GRID_COMMON.md` (Grid 검증 에러)
>
> 이력: 2026-05-08 Phase 2-Z 초안 (`Doc/_archive/_vibe_coding/error_handling.md`) → 2026-05-21 정식 룰 승격 (NSCM 실제 구현 위치 보강)

---

## 1. 에러 분류 매트릭스

| 분류 | HTTP | NSCM Exception | UI 표시 | 사용 빈도 |
|---|---|---|---|---|
| **검증 오류** (사용자 입력) | 422 | `BusinessException` | 인라인 (필드 옆 빨간 메시지) | 최다 |
| **권한 오류** | 401 / 403 | (Spring Security handler) | 401 → 로그인 리다이렉트 / 403 → 모달 | 자주 |
| **충돌** (낙관적 락) | 409 | `BusinessException` | 모달 ("다른 사용자가 변경 — 새로고침?") | 가끔 |
| **리소스 없음** | 404 | `BusinessException` | 페이지/모달 ("데이터를 찾을 수 없음") | 가끔 |
| **DB / SP 오류** | 500 | `SqlException` | 토스트 ("잠시 후 다시 시도") + 운영 로그 | 가끔 |
| **외부 시스템 (NERP/SAP)** | 502 / 503 | `ConnectorException` | 토스트 ("외부 시스템 일시 불통") | 드묾 |
| **서버 일반 오류** | 500 | `SystemException` | 토스트 + Sentry | 드묾 |
| **네트워크 오류** | (응답 없음) | (axios interceptor) | 토스트 + 자동 재시도 | 드묾 |
| **클라이언트 버그** | (JS exception) | (ErrorBoundary) | 토스트 + 화면 리로드 옵션 | 드묾 |

---

## 2. NSCM 실제 구현 위치

### 2.1 Backend (예외 클래스)

```
nscm-be/src/main/java/com/lgcns/nscm/framework/
├── exception/
│   ├── BaseException.java          ← 추상 부모, 모든 NSCM 예외의 root
│   ├── BusinessException.java      ← 4xx 비즈니스 검증/권한/충돌
│   ├── SqlException.java           ← DB / MyBatis / PL/SQL 에러 wrap
│   ├── SystemException.java        ← 500 일반 서버 에러
│   └── ConnectorException.java     ← 외부 시스템 (NERP/SAP/SOAP) 에러
├── handler/
│   └── GlobalExceptionHandler.java ← @RestControllerAdvice, RFC 7807 응답 생성
└── security/
    ├── filter/ExceptionHandlingFilter.java
    └── handler/
        ├── AccessDeniedExceptionHandler.java     ← 403
        └── AuthenticationExceptionHandler.java   ← 401
```

### 2.2 Frontend (UI 컴포넌트 + 인터셉터)

```
nscm-fe/packages/
├── foundation/src/apis/
│   ├── axios.ts                          ← apiClient 인스턴스
│   └── axios-interceptors.ts             ← 응답 인터셉터 (401/403/422/5xx 분기)
├── foundation/src/models/common/
│   └── api-response.ts                   ← BaseResponse<T> 타입
└── shared/src/components/organisms/
    ├── alert/Alert.tsx                   ← 모달 (Confirm 포함)
    └── toast-message/ToastMessage.tsx    ← 토스트
```

> ❌ **금지**: 페이지에서 `alert()` / `confirm()` 브라우저 기본 API 호출. 항상 `Alert.tsx` / `ToastMessage.tsx` 사용.

---

## 3. 표준 에러 코드 (E-N-NNN)

화면별 분석 MD (`Doc/_analysis/domain_*/screens/*/error_handling.md`) 의 표준 참조.

### E-V (Validation, 422)
| 코드 | 의미 | 화면 표시 |
|---|---|---|
| E-V-001 | 필수 입력 누락 | 인라인 빨간 메시지 |
| E-V-002 | 형식 오류 (날짜/숫자) | 인라인 |
| E-V-003 | 범위 초과 | 인라인 |
| E-V-004 | 마스터 코드 무효 | 인라인 + 마스터 picker 권장 |
| E-V-009 | 합계 불일치 | 토스트 + 헤더 강조 |
| E-V-010 | 기간 잘못 | 인라인 |
| E-V-012 | 마감 후 수정 | 모달 (확인 필요) |

### E-A (Authorization, 401/403)
| 코드 | 의미 | 화면 |
|---|---|---|
| E-A-001 | 미인증 (세션 만료) | 로그인 페이지 (axios interceptor) |
| E-A-002 | 권한 부족 (메뉴/버튼) | 모달 "권한이 없습니다" |
| E-A-003 | 사업부 권한 부족 | 모달 또는 비활성화 |

### E-C (Conflict, 409)
| 코드 | 의미 | 화면 |
|---|---|---|
| E-C-001 | 동시 편집 충돌 (LAST_UPDATE_DATE 불일치) | 모달 "새로고침?" |
| E-C-002 | 리소스 잠금 | 토스트 |

### E-S (Server, 5xx)
| 코드 | 의미 | NSCM Exception | 화면 |
|---|---|---|---|
| E-S-001 | 일반 서버 오류 | `SystemException` | 토스트 |
| E-S-002 | DB / SP 오류 | `SqlException` | 토스트 + 운영 로그 |
| E-S-003 | 외부 시스템 (NERP/SAP) 일시 불통 | `ConnectorException` | 토스트 |
| E-S-004 | 엔진/배치 실행 실패 | `SystemException` | 모달 + 로그 링크 |

### E-N (Network, 응답 없음)
| 코드 | 의미 | 화면 |
|---|---|---|
| E-N-001 | 네트워크 연결 끊김 | 토스트 + 자동 재시도 (axios) |
| E-N-002 | 타임아웃 | 토스트 + 재시도 버튼 |

---

## 4. NSCM 표준 응답과 BaseResponse 의 관계

NSCM 의 성공 응답은 `BaseResponse<T>` 로 wrap:

```jsonc
// 성공 (Controller 가 successResponseEntity(data) 호출)
{ "code": "0", "message": "success", "result": {...} }
```

에러 응답은 `GlobalExceptionHandler` 가 RFC 7807 `ProblemDetail` 변형으로 생성:

```jsonc
// 에러 (BusinessException 던질 때)
{
  "type": "/errors/validation/E-V-001",
  "title": "검증 실패",
  "status": 422,
  "code": "E-V-001",
  "detail": "사업부 필수입니다",
  "instance": "/api/v1/demand/dmf0099/main",
  "errors": [
    { "field": "division", "code": "required", "message": "사업부 필수" }
  ],
  "traceId": "abc-123"
}
```

> ❌ **금지**: Controller 에서 `ResponseEntity.status(400).body(...)` 직접 반환. 항상 `throw new BusinessException(E_V_001, "...")` 후 핸들러가 처리.

---

## 5. Backend 처리 패턴 (Spring Boot)

### 5.1 ServiceImpl 에서 던지기

```java
@Override
public List<Dmf0099Response> retrieveMain(String userId, Dmf0099Request dto) throws Exception {
    if (StringUtils.isBlank(dto.getDivisionId())) {
        throw new BusinessException("E-V-001", "사업부는 필수입니다", "division");
    }
    try {
        Map<String, Object> result = selectList(nameSpace + "retrieveMain", params);
        // ...
    } catch (DataAccessException e) {
        throw new SqlException("E-S-002", "조회 실패", e);
    }
}
```

### 5.2 GlobalExceptionHandler 변환

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ProblemDetail> handle(BusinessException ex) {
        // ProblemDetail + status 422
    }

    @ExceptionHandler(SqlException.class)
    public ResponseEntity<ProblemDetail> handle(SqlException ex) {
        log.error("SQL error traceId={}", MDC.get("traceId"), ex);
        // ProblemDetail + status 500
    }
    // ConnectorException → 502, SystemException → 500, 등
}
```

> 실제 구현: `nscm-be/src/main/java/com/lgcns/nscm/framework/handler/GlobalExceptionHandler.java`

---

## 6. Frontend 처리 패턴

### 6.1 axios 인터셉터 (전역)

axios 응답 인터셉터에서 HTTP status 별 분기 — 페이지 코드는 일반 케이스만 처리:

```ts
// foundation/src/apis/axios-interceptors.ts (요약)
api.interceptors.response.use(
  res => res,
  err => {
    const status = err.response?.status;
    if (status === 401) return window.location.assign('/login');
    if (status === 403) { showAlert('권한이 없습니다'); return Promise.reject(err); }
    if (status >= 500) { showToast('서버 오류 — 잠시 후 다시 시도'); }
    // 422/409 는 페이지 단에서 처리하도록 그대로 reject
    return Promise.reject(err);
  }
);
```

### 6.2 페이지 단 처리 (useProcMutation)

```ts
const { mutate } = useProcMutation<MENU_ID>({
  menuId, sheetName, tabId,
  onError: err => {
    if (err.status === 422 && err.errors) {
      // 필드별 인라인 표시
      err.errors.forEach(e => formMethods.setError(e.field, { message: e.message }));
    } else if (err.status === 409) {
      showConfirm('다른 사용자가 변경했습니다. 새로고침 하시겠습니까?', () => refetch());
    } else {
      // 인터셉터가 5xx 토스트 이미 처리. 422/409 외엔 noop.
    }
  },
});
```

### 6.3 Alert / Toast / Confirm 호출

```ts
import { showAlert, showConfirm } from '@shared/components/organisms/alert';
import { showToast } from '@shared/components/organisms/toast-message';

showAlert('저장이 완료되었습니다');                       // 일반 모달
showConfirm('삭제하시겠습니까?', () => deleteRow());      // 확인 모달
showToast('잠시 후 다시 시도하세요', { type: 'error' });   // 토스트
```

---

## 7. DB / PL/SQL 에러 처리

SP 마지막 `EXCEPTION` 블록 표준:

```sql
EXCEPTION
    WHEN VALUE_ERROR THEN
        RAISE_APPLICATION_ERROR(-20001, 'E-V-002: 형식 오류');
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'E-C-001: 중복');
    WHEN OTHERS THEN
        ROLLBACK;
        -- 로그 (PR_SCM_SYS_LOG_BATCH 호출)
        PR_SCM_SYS_LOG_BATCH(
            p_program_name => $$PLSQL_UNIT,
            p_log_type     => 'ERROR',
            p_log_message  => SQLERRM
        );
        RAISE_APPLICATION_ERROR(-20999, 'E-S-002: ' || SQLERRM);
```

> `$$PLSQL_UNIT` 사용 (`v_program_name` 하드코딩 금지) — `hooks/post-write.md` §4 참조.

---

## 8. 로깅 / 모니터링

| 계층 | 도구 | 무엇을 |
|---|---|---|
| 클라이언트 | (선택) Sentry / Datadog RUM | JS exception, 사용자 ID, traceId |
| Application | Logback (NSCM 기본) | 에러 메시지, traceId, MDC X-Request-ID |
| DB | `PR_SCM_SYS_LOG_BATCH` + 표준 SP | SP 이름, 파라미터, 시간, 오류 |
| Cross | X-Request-ID 헤더 | 클라이언트 → API → DB 전 계층 추적 |

**traceId** 는 axios 인터셉터에서 생성, `X-Request-ID` 헤더로 BE 전달, MDC 로 SP 까지 전파.

→ 상세: ⚠️ `16_LOGGING_AUDIT.md` (작성 예정) / 임시 `04_BE_RULES.md` §로깅

---

## 9. 사용자 친화 메시지 가이드

- ❌ 기술 용어 노출 금지: "SQL Exception" → ✅ "잠시 후 다시 시도하세요"
- ✅ 행동 가능한 다음 단계 제시: "새로고침 하시겠습니까?" 버튼
- ✅ 자동 복구 시 가벼운 알림: "재연결되었습니다" 토스트
- ❌ 영문 메시지 직접 노출 → ✅ `t('msg.MSG####')` 다국어 코드 사용

i18n 메시지 코드는 ⚠️ `13_I18N_MESSAGES.md` (작성 예정) / 임시 `08_SCREEN_REGISTRATION.md` §3 참조.

---

## 10. 자기 점검 체크리스트

신규 화면/기능 작성 후:

```
[ ] BE: BusinessException / SqlException / ConnectorException 적절히 분리 사용
[ ] BE: try-catch swallow (catch 후 무시) 없음 — 항상 wrap & throw
[ ] BE: Controller 에서 ResponseEntity 직접 작성 없음 (successResponseEntity 만)
[ ] FE: alert() / confirm() 브라우저 기본 API 호출 없음 (Alert/Confirm/Toast 컴포넌트)
[ ] FE: 422 onError 에서 필드별 setError 처리
[ ] FE: 5xx 토스트 메시지를 페이지에서 중복 표시하지 않음 (인터셉터가 처리)
[ ] SP: WHEN OTHERS 에 ROLLBACK + PR_SCM_SYS_LOG_BATCH + RAISE_APPLICATION_ERROR
[ ] SP: $$PLSQL_UNIT 사용 (하드코딩 금지)
[ ] 사용자 메시지 한글, 다국어는 t('msg.MSG####') 사용
```
