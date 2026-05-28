# 16. 로깅 / 감사 (System Log + traceId + MDC)

> NSCM 의 통합 로그 시스템. Slf4j 표준 로깅 + `@SystemLog` 어노테이션 기반 감사 로그 + ULID `traceId` + Logback MDC + `SCM_SYS_LOG` 테이블.
>
> ⭐ **선행 룰**: [`04_BE_RULES.md`](04_BE_RULES.md), [`11_AUTH_SECURITY.md`](11_AUTH_SECURITY.md), [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md)
> ⭐ **연관**: [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) (call-proc 단위 BUTTON 로그)

---

## 1. 한 줄 요약

```
[FE] axios → POST /DMF0099/main/SEARCH/call-proc
         X-Request-ID: 01H... (ULID, FE 측 traceId)
  ↓
[BE] LogInterceptor.preHandle()
     ① traceId 추출 (없으면 ULID 생성)
     ② MDC.put: traceId / userId / requestUrl / clientIp / serverStTm
  ↓
[BE] @SystemLog(LogType.BUTTON) → SystemLogAspect.systemLog()
     ③ MDC.put: typeCd / menuId / shtNm / buttonCd
     ④ log.info("START: {}.{}() | Params: {}", ...)
  ↓
[BE] @Around 으로 NCommonDAO 호출 트래픽 → MDC.put: sqlStTm / sqlEdTm
  ↓
[BE] LogInterceptor.afterCompletion()
     ⑤ logParam 조립 → insertSystemLog (비동기) → SCM_SYS_LOG INSERT
     ⑥ MDC.clear() — 스레드 풀 환경 필수
```

---

## 2. 핵심 컴포넌트 위치

```
nscm-be/src/main/java/com/lgcns/nscm/framework/
├── annotation/SystemLog.java                  ← @SystemLog(LogType.XXX)
├── aspect/SystemLogAspect.java                ← AOP @Around (DB 트래픽 + Method 트래픽)
├── interceptor/
│   ├── LogInterceptor.java                    ← HandlerInterceptor (traceId 시작/종료)
│   └── QueryLogInterceptor.java               ← MyBatis 쿼리 로그 (log4jdbc)
└── (logback-spring.xml)                       ← 로그 패턴 + MDC %X{} 출력 설정

nscm-be/src/main/resources/sql/admin/SystemLog.xml   ← SCM_SYS_LOG INSERT 매퍼
```

---

## 3. `@SystemLog` — 감사 로그 어노테이션

### 3.1 8 가지 LogType

```java
public enum LogType {
    LOGIN,        // 로그인
    LOGOUT,       // 로그아웃
    MENU,         // 메뉴 클릭
    BUTTON,       // 화면 버튼 (SEARCH/SAVE/EXCEL/...)   ← 가장 흔함
    SYSTEM,       // (기본값) 일반 시스템 작업
    LOOKUP,       // 마스터 룩업 조회
    COMBO,        // 콤보박스 조회
    EXCELUPLOAD,  // 엑셀 업로드
}
```

### 3.2 표준 사용

```java
@SystemLog(LogType.BUTTON)                     // 가장 자주 사용
@AuthCheck(Type.ALL)
@PostMapping("/{mnuId}/{shtNm}/{mnuBtnCd}/call-proc")
public ResponseEntity callProc(...) { ... }

@SystemLog(LogType.LOGIN)
@PostMapping("/user/login")
public ResponseEntity login(...) { ... }
```

### 3.3 BUTTON 로그의 자동 매핑

`@SystemLog(LogType.BUTTON)` 부착 메서드는 `SystemLogAspect` 가 자동으로 `mnuId/shtNm/buttonCd` 추출:

```java
// SystemLogAspect.java 발췌
if (annoType.equals("BUTTON")) {
    if (className.equals("GeneralController")) {
        MDC.put("menuId",  args[2].toString());   // PathVariable mnuId
        MDC.put("shtNm",   args[3].toString());   // PathVariable shtNm
        MDC.put("buttonCd",args[4].toString());   // PathVariable mnuBtnCd
    }
}
```

→ `GeneralController.callProc` 시그니처에 의존. 다른 Controller 가 BUTTON 로그 남기려면 동일 시그니처 (`(userSession, params, mnuId, shtNm, mnuBtnCd)`) 권장.

---

## 4. `traceId` — ULID 기반 분산 추적

### 4.1 traceId 생성 / 전파

```
[FE] axios interceptor → X-Request-ID 헤더 자동 생성 (ULID)
  ↓
[BE] LogInterceptor.preHandle()
  String traceId = request.getHeader("x-request-id");
  if (traceId == null) traceId = UlidCreator.getUlid().toString();
  MDC.put("traceId", traceId);
  ↓
[BE→DB] 쿼리 로그에 traceId 포함 (logback %X{traceId})
  ↓
[Response] (선택) X-Request-ID 헤더로 echo
```

### 4.2 ULID 선택 이유
- UUID 보다 짧음 (26자 vs 36자)
- **시간순 정렬 가능** (앞 10자 = millisecond 타임스탬프) → log 검색 효율
- `Ulid.from(traceId).getTime()` 로 클라이언트 요청 시각 복원 → 네트워크 지연 추정

### 4.3 FE 측 traceId
```ts
// foundation/src/apis/axios-interceptors.ts (요약)
api.interceptors.request.use(config => {
  config.headers['X-Request-ID'] = generateUlid();
  return config;
});
```

---

## 5. Logback MDC — 컨텍스트 전파

MDC (Mapped Diagnostic Context) 에 저장되는 키들:

| 키 | 설정 시점 | 출처 |
|---|---|---|
| `traceId` | preHandle | X-Request-ID 헤더 또는 신규 ULID |
| `userId` | preHandle | UserSession.userId (없으면 'GUEST') |
| `typeCd` | SystemLogAspect | `@SystemLog` 값 (BUTTON/LOGIN/...) |
| `requestUrl` | preHandle | request.getRequestURI() |
| `clientIp` | preHandle | X-Forwarded-For / Proxy-Client-IP / remoteAddr |
| `menuId` / `shtNm` / `buttonCd` | SystemLogAspect (BUTTON 시) | PathVariable |
| `params` | SystemLogAspect | 메서드 args JSON (4000B 자름) |
| `clientStTm` | preHandle | Ulid.getTime() |
| `serverStTm` | preHandle | System.currentTimeMillis() |
| `sqlStTm` / `sqlEdTm` | SystemLogAspect (DAO) | NCommonDAO 호출 시간 |
| `exception` | catch block | className.methodName: message |

> ❌ **금지**: MDC 키 임의 추가. 위 표준 키만 사용. 스레드 풀 환경에서 `MDC.clear()` 필수 (이미 `afterCompletion` 에서 처리).

### 5.1 Logback 패턴 (`logback-spring.xml`)

```xml
<pattern>
  %d{yyyy-MM-dd HH:mm:ss.SSS} [%X{traceId:-}] [%X{userId:-}] %-5level %logger{36} - %msg%n
</pattern>
```

`%X{traceId:-}` = MDC traceId 값 (없으면 빈 문자열).

---

## 6. `SCM_SYS_LOG` 테이블 — 영구 감사 로그

### 6.1 컬럼
- `TRACE_ID` (PK, ULID, 26자)
- `USER_ID`, `TYPE_CD` ('BUTTON' / 'LOGIN' / ...), `MENU_ID`, `SHT_NM`, `BUTTON_CD`
- `REQUEST_URL`, `CLIENT_IP`, `PARAMS` (4000B), `EXCEPTION`
- `CLIENT_ST_TM`, `SERVER_ST_TM`, `SQL_ST_TM`, `SQL_ED_TM`, `SERVER_ED_TM`, `CLIENT_ED_TM`

### 6.2 INSERT 비동기

`LogInterceptor.afterCompletion` 의 `insertSystemLog(logParam)` 은 `@Async` 로 비동기. 메인 요청 응답 시간에 영향 없음.

```java
@Async
public void insertSystemLog(Map<String, Object> logParam) {
    try {
        ncommondao.insertSysLog(logParam);
    } catch (Exception e) {
        log.error("System log insert failed: traceId={}", logParam.get("traceId"), e);
        // 로그 INSERT 실패해도 사용자 요청에는 영향 X
    }
}
```

> ❌ **금지**: 로그 INSERT 실패를 throw. 사용자 요청 흐름을 방해하면 안 됨.

---

## 7. Slf4j 로깅 표준 (모든 클래스)

### 7.1 표준 패턴

```java
@Slf4j     // Lombok
public class Dmf0099ServiceImpl extends BaseService {

    public List<...> retrieveMain(String userId, Dmf0099Request dto) throws Exception {
        log.info("retrieveMain start: userId={}, divisionId={}", userId, dto.getDivisionId());
        // ...
        log.debug("query result rows: {}", data.size());
        return result;
    }
}
```

### 7.2 레벨 가이드

| 레벨 | 사용 시점 | 운영 출력 |
|---|---|---|
| `ERROR` | Exception 발생 — 사용자 영향 있음 | ✅ 항상 |
| `WARN` | 비정상이지만 복구 가능 (재시도 등) | ✅ 항상 |
| `INFO` | 주요 비즈니스 이벤트 (로그인, 화면 진입, 저장 성공) | ✅ 운영 |
| `DEBUG` | 디버깅용 (쿼리 결과 건수, 분기 흐름) | 개발만 |
| `TRACE` | 매우 상세한 흐름 | 비활성 |

### 7.3 ❌ 금지 사항

```java
// ❌ System.out.println — 로그 표준 무시
System.out.println("userId=" + userId);

// ❌ String concat — 로그 비활성 시에도 문자열 생성 비용 발생
log.debug("userId=" + userId + ", division=" + divisionId);

// ❌ Sensitive 데이터 로깅
log.info("password={}", password);
log.info("resident={}", residentNumber);

// ❌ Exception 정보 누락
log.error("failed");  // throwable 누락 → stack trace 안 찍힘

// ✅ Parameterized + throwable 명시
log.info("retrieveMain: userId={}, division={}", userId, divisionId);
log.error("retrieveMain failed: userId={}", userId, exception);  // exception 마지막 인자
```

---

## 8. DB / PL/SQL 로깅 (`PR_SCM_SYS_LOG_BATCH`)

SP 의 `WHEN OTHERS` 블록에서 운영 로그 INSERT:

```sql
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(
            p_program_name => $$PLSQL_UNIT,   -- ★ 하드코딩 금지
            p_log_type     => 'ERROR',
            p_log_message  => SQLERRM,
            p_user_id      => p_user_id
        );
        RAISE_APPLICATION_ERROR(-20999, 'E-S-002: ' || SQLERRM);
```

> `$$PLSQL_UNIT` 사용 — `v_program_name := 'PKG_DMF0099'` 하드코딩 금지 (`hooks/post-write.md` §4).

---

## 9. 운영 로그 활용

### 9.1 traceId 로 한 요청 추적

```bash
# Logback 파일에서
grep "01H8K..." application.log    # traceId 26자

# SCM_SYS_LOG 에서
SELECT * FROM SCM_SYS_LOG WHERE TRACE_ID = '01H8K...';
```

### 9.2 화면별 사용 통계
```sql
SELECT MENU_ID, COUNT(*) AS CALL_CNT,
       AVG(EXTRACT(SECOND FROM (SERVER_ED_TM - SERVER_ST_TM)) +
           EXTRACT(MINUTE FROM (SERVER_ED_TM - SERVER_ST_TM))*60) AS AVG_SEC
  FROM SCM_SYS_LOG
 WHERE TYPE_CD = 'BUTTON'
   AND BUTTON_CD = 'SEARCH'
   AND SERVER_ST_TM >= TRUNC(SYSDATE) - 7
 GROUP BY MENU_ID
 ORDER BY CALL_CNT DESC;
```

### 9.3 사용자별 활동
```sql
SELECT USER_ID, MENU_ID, BUTTON_CD, COUNT(*)
  FROM SCM_SYS_LOG
 WHERE USER_ID = 'minyonglee1'
   AND SERVER_ST_TM >= TRUNC(SYSDATE)
 GROUP BY USER_ID, MENU_ID, BUTTON_CD;
```

---

## 10. log4jdbc / SQL 로깅

`framework/interceptor/QueryLogInterceptor.java` + `log4jdbc-log4j2` 라이브러리:
- 모든 MyBatis 쿼리의 실행 SQL + 바인딩 파라미터 출력
- `application.yml` 의 `logging.level.jdbc` 로 활성/비활성 제어
- ⚠ 운영에서는 INFO 이상으로 제한 (DEBUG 시 로그 폭증)

---

## 11. 자기 점검 체크리스트

```
[ ] Controller 에 @SystemLog(LogType.XXX) 부착 (감사 대상 메서드)
[ ] System.out.println 사용 0건 (log.info/error 만)
[ ] String concat 로깅 0건 (parameterized {} 사용)
[ ] Sensitive 데이터 로깅 0건 (password, resident, 카드번호)
[ ] Exception 로깅 시 throwable 마지막 인자 (log.error("...", e))
[ ] SP WHEN OTHERS 에 PR_SCM_SYS_LOG_BATCH + $$PLSQL_UNIT
[ ] FE axios 요청에 X-Request-ID 자동 생성
[ ] traceId 가 한 요청 내 BE 로그 + SCM_SYS_LOG 양쪽에 동일
[ ] MDC 키는 표준 (traceId/userId/typeCd/menuId/shtNm/buttonCd/...)
[ ] @Async insertSystemLog 실패가 사용자 응답에 영향 X
```

---

## 12. 관련 문서

| 룰 | 주제 |
|---|---|
| [`04_BE_RULES.md`](04_BE_RULES.md) | Slf4j @Slf4j 표준 어노테이션 |
| [`10_API_DYNAMIC_PROC.md`](10_API_DYNAMIC_PROC.md) | GeneralController.callProc 시그니처 (BUTTON 로그 매핑) |
| [`11_AUTH_SECURITY.md`](11_AUTH_SECURITY.md) | @LoginUser UserSession → MDC userId |
| [`14_ERROR_HANDLING.md`](14_ERROR_HANDLING.md) | Exception → log.error + traceId |
| [`hooks/post-write.md`](hooks/post-write.md) §4 | $$PLSQL_UNIT 사용 검증 |
