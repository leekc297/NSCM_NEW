# 21. 트러블슈팅 가이드 — Oracle / DBeaver / Wijmo / PowerShell / Vite

> 2026-05-18 ~ 2026-05-22 DMF0007 빈 결과 / DMF0020 등록 / DMF0020 dayjs locale / Wijmo finishEditing / 한글 모지바케 등 실제 발생 이슈를 분류·진단·해결 패턴으로 정리.
> 다른 화면에서 동일 증상 발생 시 본 문서의 진단 SQL/패턴을 즉시 활용 가능.

## §0. 빠른 진단 분기 (Quick Decision Tree)

| 증상 | 1차 의심 | 룰 |
|---|---|---|
| FE 콘솔 `TypeError: Failed to resolve module specifier 'dayjs/locale/...'` | Vite + design-system dynamic import | §6 / 룰 26 |
| FE 콘솔 `fallback on English locale` | dayjs locale 미등록 | §6 |
| FE 화면 첫 오픈 시 빈 화면 + 다른 화면은 정상 | Vite 동적 모듈 resolve 실패 (locale 외 다른 패키지도 동일 패턴 가능) | §6 |
| 검색 시 alert 없이 빈 그리드 | Oracle SP 빈 결과 (권한/메타 누락) | §1 |
| `POST /api/{MENU}/{sheet}/{action}/call-proc 500` | BE 측 오류 (메타 미등록 / SP INVALID / 파라미터 mismatch) | §7 |
| DBeaver 실행 시 `ORA-00922` / `ORA-00933` | DBeaver SQL 에 `/`, `SET DEFINE`, `PROMPT`, 다중 `;` 포함 | 룰 08 §7.1 |
| AS-IS 의 동적 visibility 가 신규 화면에 미반영 | Designer.cs + .cs 동적 배치 누락 | 룰 24 / 룰 25 §4 |

## §1. Oracle SP 빈 결과 진단 (DMF0007 사례)

### 1.1 증상

- FE 검색 시 alert 없이 빈 그리드 표시
- BE Network 응답: `{ code: "0", message: "success", result: { o_rc1: [] } }`
- SP 호출 자체는 성공, 행만 0건

### 1.2 단계적 격리 진단 SQL

```sql
-- A. 현재 ISO 주차 + 데이터 분포
SELECT C.ISO_YYYYWW AS CURRENT_WEEK
  FROM SCM_MGR.SCM_SYS_CALENDAR_M C
 WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD');

SELECT PLAN_WEEK, COUNT(*) FROM SCM_MGR.DM_MST_CUSTOMER_FCST
 WHERE MEASURE_GROUP = '{화면별 필터값}'
 GROUP BY PLAN_WEEK ORDER BY PLAN_WEEK DESC FETCH FIRST 10 ROWS ONLY;

-- B. 권한 함수 단독 호출 (★ DMF0007 의 1차 원인)
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(USER, '{MENU_ID}'));
-- 0건이면 → 사용자가 메뉴 권한 미보유. SCM_ADM_USER_GR_MNU_MPG_M 확인

-- C. SP 단독 호출 + 결과 행수 (DBMS_SQL 로 generic fetch)
DECLARE
    v_rc1 SYS_REFCURSOR;
    v_res SYS_REFCURSOR;
    v_cursor_id INTEGER;
    v_col_cnt INTEGER;
    v_desc DBMS_SQL.DESC_TAB;
    v_rows PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_{MENU_ID}.P_{화면별_SP}(/* params... */, v_rc1, v_res);
    v_cursor_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(v_cursor_id, v_col_cnt, v_desc);
    DBMS_OUTPUT.PUT_LINE('컬럼 수: '||v_col_cnt);
    WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP v_rows := v_rows + 1; END LOOP;
    DBMS_OUTPUT.PUT_LINE('반환 행수: '||v_rows);
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
END;
```

### 1.3 원인별 처치

| 시나리오 | 원인 | 처치 |
|---|---|---|
| A 에서 데이터 0건 | 현재 주차 데이터 미적재 | `DM_MST_CUSTOMER_FCST` 적재 또는 SP 의 `V_PLAN_WEEK` 로직을 `NVL(P_PLAN_WEEK, V_PLAN_WEEK)` 로 보정 |
| B 에서 0건 | 사용자에게 메뉴 권한 미부여 | `SCM_ADM_USER_GR_MNU_MPG_M` 에 `(USER_GR_ID, MENU_ID)` 등록 — 본 룰 §2 BLOCK 7 |
| C 에서 SP INVALID | PKG 컴파일 실패 | §2.2 ORA-06575 진단 |
| C 에서 컬럼 0 | SP OUT cursor 미정의 | SP 시그니처 점검 |

### 1.4 V_SQL_TEXT 디버그 활용

동적 SQL 사용 SP 는 본문에 `PKG_*.P_PR_PRINT_CLOB('V_SQL_TEXT', V_SQL_TEXT)` 라인이 있으면 DBMS Output 패널에 실제 실행 SQL 이 출력됨. 그 SQL 을 복사하여 단독 실행하면 어느 필터가 행을 0건으로 만드는지 격리 가능.

---

## §1.5 DBeaver PL/SQL 익명 블록 `-1` / `"Updated Rows: -1"` 반환 (2026-05-22 추가)

### 증상
DBeaver 에서 `BEGIN ... END;` PL/SQL 익명 블록 실행 시 결과 영역에 `-1` 또는 `Updated Rows: -1` 표시됨.

### 의미
✅ **오류 없이 정상 종료**. 다음 두 가지 이유로 `-1` 표시:
1. Oracle PL/SQL **익명 블록은 row count 를 반환하지 않음** (`SQL%ROWCOUNT` 는 블록 내부에서만 유효).
2. DBeaver / SQL Developer / DataGrip 등 IDE 가 row count 를 알 수 없어 `-1` 또는 `N/A` 로 표기.

### 실제 데이터 삽입 여부 확인 의무

`-1` 은 "에러 없음" 만 의미. 실제 데이터가 들어갔는지는 **별도 검증** 필요:

**옵션 1 — Verify SQL (권장)**:
```
20_{MENU_ID}_Registration_DBeaver_Verify.sql 전체 선택 → Ctrl+Enter
```
결과 7 행 모두 `CNT ≥ EXPECT_MIN` 이어야 통과.

**옵션 2 — 직접 빠른 검증**:
```sql
SELECT '1.MSG'   AS K, COUNT(*) FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_{ID}' OR MSG_ID LIKE 'MSG_API_{ID}\_%' ESCAPE '\'
UNION ALL SELECT '2.MNU',     COUNT(*) FROM SCM_ADM_MNU_M               WHERE MNU_ID = '{ID}'
UNION ALL SELECT '4.API',     COUNT(*) FROM SCM_ADM_API_M               WHERE API_ID LIKE '{ID}\_%' ESCAPE '\'
UNION ALL SELECT '5.BTN_MPG', COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M       WHERE MNU_ID = '{ID}'
UNION ALL SELECT '6.UI_COL',  COUNT(*) FROM SCM_MST_SHEET_COLUMNS       WHERE PROGRAM_ID = '{ID}'
UNION ALL SELECT '7a.AUTH_M', COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M   WHERE MNU_ID = '{ID}'
UNION ALL SELECT '7b.AUTH_B', COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '{ID}';
```

### `-1` 외 DBeaver 가 보일 수 있는 다른 결과

| 결과 표시 | 의미 |
|---|---|
| `-1` / `Updated Rows: -1` | PL/SQL 익명 블록 정상 종료 (row count 없음) |
| `0 rows affected` | INSERT 가 WHERE NOT EXISTS 조건으로 인해 idempotent 동작 — 이미 데이터 존재 |
| `15 rows affected` | 단일 DML 의 영향 row 수 (PL/SQL 외부 실행) |
| `ORA-XXXXX` | 에러 — §2 참조 |

### 함정 — `-1` 받았지만 실제 0 행인 경우

PL/SQL 블록 안의 `INSERT INTO ... SELECT ... WHERE NOT EXISTS (...)` 패턴은 **이미 데이터가 있으면 silent 하게 0 행 INSERT**. `-1` 정상 종료 + 실제 0 행 — Verify 가 필수인 이유.

예: BLOCK 2 의 `SCM_ADM_MNU_M` INSERT 가 이미 DMF0020 행이 있으면 `NOT EXISTS` 조건으로 SKIP. 정상.

---

## §2. Oracle ORA-XXXXX 에러 분류

| 에러 코드 | 메시지 | 원인 | 처치 |
|---|---|---|---|
| **ORA-00911** | invalid character | DBeaver 에서 `END;` 뒤 `/` 단독 라인 전송 | `/` 제거 |
| **ORA-00922** | missing or invalid option | DBeaver 에서 SQL\*Plus 명령 (`SET DEFINE`, `DEFINE`, `PROMPT`, `UNDEFINE`) 전송 | DBeaver 호환 버전 사용 (§2.1) |
| **ORA-06508** | could not find program unit being called | PKG SPEC 있으나 BODY 미배포/INVALID | BODY 컴파일 + 의존 객체 점검 (§2.2) |
| **ORA-06550 PLS-00103** | 심볼 "SELECT" 를 만났습니다 | DBeaver 1 파일 내 PL/SQL + SELECT 혼재 — 파서가 SELECT 를 블록 일부로 해석 | 파일 분리 (§2.1) |
| **ORA-06550 PLS-00201** | 식별자가 정의되어야 합니다 | 호출 대상 PKG/함수 미존재 | 의존 PKG/함수 배포 또는 자기완결형 패턴 사용 |
| **ORA-06575** | 패키지/함수 부적합한 상태 | PKG INVALID (의존 객체 누락) | `SHOW ERRORS` 로 컴파일 에러 확인 (§2.3) |

### 2.1 DBeaver 호환 SQL 규칙

NSCM 메타 등록 SQL 은 4-파일 세트로 작성:

```
{name}.sql                    — SQL*Plus / SQLcl (DEFINE/&V_X/PROMPT/UNDEFINE/`/` OK)
{name}_DBeaver.sql            — DBeaver 등록 PL/SQL (statement 1개만)
{name}_DBeaver_Verify.sql     — DBeaver 검증 SELECT (statement 1개만)
{name}_DBeaver_Diagnose.sql   — DBeaver 진단 PL/SQL (statement 1개만)
```

DBeaver 파일 금지 사항:
- `SET DEFINE` / `SET SERVEROUTPUT` / `DEFINE V_X = ...` / `&V_X`
- `PROMPT` / `UNDEFINE`
- `END;` 뒤 `/` 종결자
- 단일 파일 내 PL/SQL 블록 + SELECT 혼재

→ 상세 룰: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` §7.1

### 2.2 ORA-06508 진단 SQL

```sql
-- PKG 상태
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OBJECT_NAME = '{PKG_NAME}';
-- → 2건 (PACKAGE + PACKAGE BODY) 모두 VALID 여야 정상

-- BODY 컴파일 에러
SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME='{PKG_NAME}' ORDER BY SEQUENCE;
```

### 2.3 ORA-06575 진단 (INVALID 상태)

```sql
-- 강제 재컴파일 시도
ALTER PACKAGE SCM_MGR.{PKG_NAME} COMPILE;
ALTER PACKAGE SCM_MGR.{PKG_NAME} COMPILE BODY;
SHOW ERRORS PACKAGE BODY SCM_MGR.{PKG_NAME};

-- 의존 객체 점검
SELECT REFERENCED_NAME, REFERENCED_TYPE, REFERENCED_OWNER
  FROM ALL_DEPENDENCIES
 WHERE NAME = '{PKG_NAME}' AND OWNER = 'SCM_MGR';

-- INVALID 객체 일괄 재컴파일
BEGIN DBMS_UTILITY.COMPILE_SCHEMA('SCM_MGR', FALSE); END;
```

**DMF0007 사례**: `FN_SCM_GET_WHERE_SQL` 함수 미배포 → PKG_DMF0007 BODY 컴파일 실패 → SP 실행 시 ORA-06575.

---

## §3. Wijmo FlexGrid 런타임 에러

### 3.1 `Cannot read properties of null (reading 'finishEditing')`

**증상**: 검색 버튼 클릭 시 콘솔에 TypeError, 데이터 표시 실패 가능

**원인**: 검색 핸들러에서 `gridRef.current?.invalidate()` 가 React re-render 와 경합하여 finishEditing 내부 상태가 null 일 때 호출됨

**금지 패턴 (DMF0007 가 가졌던 코드)**:
```ts
const handleSearch = () => {
    setFilter();
    fetchDateColumns();
    editTrackerRef.current?.clearChanges();
    gridRef.current?.invalidate();   // ← 제거 대상
};
```

**권장 패턴**:
```ts
const handleSearch = () => {
    fetchDateColumns();              // 1) 컬럼 먼저 안정화
    setFilter();                     // 2) 데이터 갱신
    editTrackerRef.current?.clearChanges();
    // gridRef.invalidate() 제거 — React re-render 가 자동 처리
};
```

**대안 (꼭 invalidate 가 필요한 경우)**:
```ts
// A. 안전 가드
if (gridRef.current?.hostElement) {
    gridRef.current.finishEditing(true);  // 강제 편집 종료
    gridRef.current.invalidate();
}

// B. 다음 frame 으로 지연
queueMicrotask(() => gridRef.current?.invalidate());
```

### 3.2 부수 권장: optional chaining 2단

```ts
// 위험: data 가 객체지만 o_rc1 미정의일 때 TypeError
dataCount={fcstData?.o_rc1.length ?? 0}

// 안전
dataCount={fcstData?.o_rc1?.length ?? 0}
```

---

## §4. PowerShell 한글 모지바케 (Claude Code / VS Code 환경)

### 4.1 증상

PowerShell 도구 출력에서 한글이 "???먭린?꾧껐??" 같은 모지바케로 표시. 파일 자체는 정상 UTF-8.

### 4.2 원인

| 단계 | 인코딩 |
|---|---|
| 파일 (UTF-8 saved) | ✅ UTF-8 |
| PowerShell 신규 프로세스 spawn | 기본 OutputEncoding = CP949 (한국어 시스템 로캘) |
| `Get-Content` (인코딩 미명시) | CP949 로 해석 → 모지바케 |
| Claude Code → VS Code 전달 | 깨진 바이트 그대로 |

Claude Code 의 PowerShell 도구는 **매 호출마다 새 프로세스 spawn** (shell state 미보존) → 매번 기본 인코딩으로 초기화.

### 4.3 해결 (AI 측 책임 — 사용자 환경 변경 불필요)

모든 PowerShell 도구 호출의 첫 줄에 prelude prepend:

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = [System.Text.Encoding]::UTF8;
# 실제 명령
Get-Content $path -Encoding UTF8 ...
```

추가 룰:
- 파일 읽기: `Get-Content -Encoding UTF8`
- 파일 쓰기: `Set-Content -Encoding UTF8` / `Out-File -Encoding utf8`
- Select-String: `Get-Content -Encoding UTF8 | Select-String ...`

→ 영구 메모리: `feedback_powershell_utf8.md`

### 4.4 사용자 환경 영구 해결 (선택)

```
Windows 설정 → 시간 및 언어 → 언어 및 지역 →
관리용 언어 설정 → 시스템 로캘 변경 →
✅ "전 세계 언어 지원을 위해 Beta: Unicode UTF-8 사용" → 재부팅
```

→ 모든 ANSI 콘솔/앱이 UTF-8 동작. 단, 일부 한글 전용 레거시 프로그램 영향 가능.

### 4.5 VS Code Claude Code 패널 자체가 모지바케

위 4.3 적용 후에도 깨진다면:
1. 이전 대화 메시지 (prelude 적용 전) 가 영구 깨진 상태로 남음 — 새 메시지부터 정상
2. VS Code Claude Code 패널 폰트가 한글/이모지 미지원 → 폰트 변경 (`Cascadia Code`, `D2Coding`, `JetBrains Mono`)

---

## §5. 자주 발생하는 패턴 요약

| 증상 | 1차 의심 | 확인 SQL/명령 | 본 문서 절 |
|---|---|---|---|
| 화면 빈 데이터 + 에러 없음 | 권한 함수 0건 또는 데이터 0건 | `PR_SCM_EDIT_YN(USER, MENU_ID)` | §1 |
| ORA-00922 in DBeaver | SQL\*Plus 명령 사용 | 파일에서 `SET DEFINE` 검색 | §2.1 |
| ORA-00911 in DBeaver | `/` 단독 라인 | `grep "^/$" file.sql` | §2.1 |
| ORA-06550 PLS-00103 in DBeaver | 1 파일에 PL/SQL + SELECT | 파일 분리 | §2.1 |
| ORA-06508 | PKG BODY INVALID | `SELECT STATUS FROM ALL_OBJECTS` | §2.2 |
| ORA-06575 | PKG INVALID | `SHOW ERRORS` | §2.3 |
| TypeError finishEditing | gridRef.invalidate() 직접 호출 | 검색 핸들러 점검 | §3 |
| 한글 ???먭린 모지바케 | PowerShell OutputEncoding | PowerShell prelude 누락 | §4 |
| `Failed to resolve module specifier 'dayjs/locale/ko'` | Vite + design-system dynamic import | `dayjs-setup.ts` + esbuild plugin | §6 |
| `POST /api/.../call-proc 500` | BE 메타 미등록 / SP INVALID | DevTools Response body 확인 | §7 |

---

## §6. Vite + @lges/design-system dayjs/locale dynamic import 해결 (DMF0020 사례)

### 6.1 증상

- DMF0020 또는 DatePickerCalendar 사용 화면 첫 오픈 시 콘솔:
  ```
  Uncaught (in promise) TypeError: Failed to resolve module specifier 'dayjs/locale/ko'
    at @lges_design-system.js?v=XXXXX:94547
  ```
- 같이 보이는 경고:
  ```
  Your locale has not been found. ... fallback on English locale
  ```

### 6.2 원인

`@lges/design-system@1.0.17` 의 DatePicker 5곳에서 `import(\`dayjs/locale/${X}\`)` 변수 보간 dynamic import 사용. Vite 정적 분석 불가 → bare specifier 가 그대로 브라우저로 노출 → resolve 실패.

### 6.3 해결 (3 파일)

1. **`apps/web/src/dayjs-setup.ts`** 신규 — `import 'dayjs/locale/{ko,en,zh-cn}'` 정적 등록 + `dayjs.locale('ko')`
2. **`apps/web/src/index.tsx`** 최상단 첫 줄 `import './dayjs-setup';`
3. **`apps/web/vite.config.ts`** 의 `optimizeDeps.esbuildOptions.plugins` 에 `lgesDayjsLocalePatch` 추가하여 `lib-main.mjs` 의 dynamic import 5건을 `Promise.resolve()` 로 치환 + `optimizeDeps.include` 에 dayjs 와 3개 locale 추가

상세: **`Doc/_dev_rules/26_VITE_DAYJS_LOCALE.md`**

### 6.4 검증

```
Remove-Item -Recurse -Force apps/web/node_modules/.vite
pnpm dev
# DMF0020 오픈 → 콘솔에서 'Failed to resolve' 사라짐
```

이관 패키지: `_artifacts/dayjs-locale-fix_20260522.zip`

---

## §7. BE 동적 SP 호출 500 진단 (`/api/{MENU}/{sheet}/{action}/call-proc`)

### 7.1 증상

- FE 콘솔: `POST http://localhost:3000/api/DMF0020/main/SEARCH/call-proc 500 (Internal Server Error)`
- FE 의 `axios-interceptors.ts:46` 가 500 응답을 swallow 해서 throw 안 함 → DevTools Network 의 Response body 에 BE 의 stack trace 가 들어있음

### 7.2 응답 본문 확인 방법

```
브라우저 DevTools (F12) → Network 탭
→ POST .../call-proc (빨간색) 클릭
→ Response (또는 Preview) 탭
→ JSON 의 message / code / 또는 stack trace 확인
```

### 7.3 흔한 원인 5종

| # | 원인 | 확인 방법 |
|---:|---|---|
| 1 | `SCM_ADM_API_M` 메타 미등록 (MENU_ID + SHEET_NM + ACTION 조합 누락) | `SELECT * FROM SCM_ADM_API_M WHERE MENU_ID='{X}' AND SHEET_NM='{sheet}' AND ACTION='{ACTION}'` |
| 2 | Oracle SP 미배포 또는 INVALID 상태 | `SELECT object_name, status FROM USER_OBJECTS WHERE object_name LIKE 'PKG_{MENU}%'` |
| 3 | 파라미터 mismatch — FE 가 배열 (`deptIds: string[]`) 을 그대로 전송, BE/SP 는 단일 String 기대 | DevTools Payload 탭의 필드 타입 vs SP IN 파라미터 비교 |
| 4 | 권한 미부여 (`USER_GR_MNU_BTN_MPG_M`) — 단 500 이라기보단 403 응답 일반적 | `SELECT * FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MENU_ID='{X}'` |
| 5 | 세션/인증 NPE (`@LoginUser` injection 실패) | 다른 화면도 동일 증상이면 BE 전체 장애 |

### 7.4 격리 진단 순서

1. **다른 화면 (예: `MNF0010` 메뉴 관리) 조회** 가 정상 동작하는지 확인 → BE 전체 vs 본 화면 한정 분기
2. **DevTools Network → Response body** 의 message / code 직접 확인 — 사용자 추측 금지 (anti-simplification)
3. 4-파일 SQL 세트 (`_DBeaver_Verify.sql`) 실행하여 메타 등록 검증
4. BE 로그 (cloud BE 접근 가능 시) 의 X-Request-ID (FE 에서 ULID 생성 후 헤더 전송) 로 BE 측 stack trace 추적

---

## §8. 로컬 Docker Oracle 환경 SP/POPUP 미조회·hang 진단 (2026-05-28 추가, DMF0005/DMF0006 사례)

> ⭐ **로컬 한정**. 클라우드 Oracle 은 동일 SP/데이터로도 정상 동작. 본 절의 보강 사항은 **운영 이관 X**.

### 8.1 증상 5종 & 진단 분기

| # | 증상 | 1차 의심 |
|---:|---|---|
| 1 | popup 클릭 시 무한 spinner / 30s 초과 | FE axios timeout 30s 기본값 |
| 2 | popup 빠르게 닫혔는데 데이터 0건 | BE 응답 0건 OR 캐시 stale |
| 3 | 화면 진입 직후 컬럼 헤더 안 보임 | column 메타 endpoint timeout |
| 4 | BE 로그 `HikariPool-1 - Connection is not available` 다발 | 동시 무거운 SP 호출로 pool 고갈 |
| 5 | BE 재시작 후 401 + `ClassCastException: String → CustomUserDetails` | stale JSESSIONID 의 anonymous principal |

### 8.2 진단 순서 (Anti-Simplification 의무)

**LLM 추측 금지.** 본 절의 1~4단계를 반드시 순서대로 진행.

**1단계 — BE 로그 endpoint 확인** (~5초):
```bash
tail -c 500000 nscm-be/logs/nscm.log | grep -aoE 'requestUrl":"[^"]+"' | sort -u
tail -c 500000 nscm-be/logs/nscm.log | grep -aE "Authorization error|HikariPool" | tail -10
```
- 호출 0건 → FE 도달 X (auth/router/`enabled: !!filters`)
- `Authorization error` 다발 → stale session → **시크릿 창 재로그인**
- `HikariPool 고갈` → §8.5 pool 늘리기

**2단계 — SP 직접 timing** (`DBMS_SQL.TO_CURSOR_NUMBER` 패턴):
```sql
DECLARE v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; ...
BEGIN PKG_XXX.P_XXX(..., v_rc1, v_rc2);
  v_sql_cur := DBMS_SQL.TO_CURSOR_NUMBER(v_rc1);
  DBMS_SQL.DESCRIBE_COLUMNS(v_sql_cur, v_col_count, v_desctab);
  FOR i IN 1..v_col_count LOOP DBMS_SQL.DEFINE_COLUMN(v_sql_cur, i, ...); END LOOP;
  WHILE DBMS_SQL.FETCH_ROWS(v_sql_cur) > 0 LOOP v_cnt := v_cnt + 1; END LOOP;
END;
```
- 0건 → §8.4 시드 검토
- 느림 → §8.3 인덱스/통계 검토
- 정상 → FE 측 (filter / type cast / staticColumns)

**3단계 — JOIN chain 단계별 카운트** (단순 카운트 SQL 로 끊김 지점 식별):
```sql
SELECT COUNT(*) FROM A;
SELECT COUNT(*) FROM A JOIN B ON ...;
SELECT COUNT(*) FROM A JOIN B JOIN C ON ...;
```
중간 단계에서 0이 되면 그 JOIN 의 조건이 시드 부족/매칭 실패.

**4단계 — `v$sqlarea` SQL_ID 확인** (sysdba 권한 필요):
```sql
SELECT sql_id, sql_profile, plan_hash_value, ROUND(elapsed_time/1000000,1) SEC, rows_processed
FROM v$sqlarea WHERE parsing_schema_name='SCM_MGR' AND sql_text LIKE '%식별%'
ORDER BY elapsed_time DESC FETCH FIRST 5 ROWS ONLY;
```

### 8.3 인덱스/통계 보강 패턴

**대상 식별**: SP body 의 LEFT JOIN chain + GROUP BY CTE.
- `SELECT index_name, column_name FROM user_ind_columns WHERE table_name='XXX'` 로 인덱스 부재 확인
- SYNONYM (예: `SCM_MST_ITEM_SN → FP_MGR.SCM_ITEM_M`) 의 경우 **실제 소유자 스키마에서 INDEX 생성** (SCM_MGR 권한 부족 시 `/ as sysdba` 사용)

**통계 갱신** (⚠ AUTO_SAMPLE_SIZE 권장):
```sql
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCHEMA','TABLE',
  estimate_percent=>DBMS_STATS.AUTO_SAMPLE_SIZE,
  cascade=>TRUE,
  method_opt=>'FOR ALL COLUMNS SIZE AUTO');
```
- **금지: `estimate_percent=>100`** — DMF0005 사례에서 plan 악화 (6분 → 8분). AUTO 가 안전.

**Covering 인덱스** (GROUP BY CTE 가속용):
```sql
CREATE INDEX IDX_..._COVER ON XXX(group_keys, aggregated_cols);
```

**SQL Profile** (force_match=TRUE, 운영 SP 수정 회피):
```sql
DECLARE
    l_sql_text CLOB;
    l_hints SYS.SQLPROF_ATTR;
BEGIN
    SELECT sql_fulltext INTO l_sql_text FROM v$sqlarea WHERE sql_id='...' AND ROWNUM=1;
    l_hints := SYS.SQLPROF_ATTR(q'[LEADING(...)]', q'[USE_NL(...)]', q'[INDEX(...)]');
    DBMS_SQLTUNE.IMPORT_SQL_PROFILE(sql_text=>l_sql_text, profile=>l_hints,
        name=>'PRF_...', force_match=>TRUE, replace=>TRUE);
END;
```

### 8.4 시드 데이터 보강 (popup 0건 해결)

**핵심 원리**: 권한 SP (`PR_CHECK_*`) 와 popup SP (예: COM0004 OWNER) 가 모두 `SCM_ADM_USER_M` (FXU) 의 admin 사용자 필터를 거침. 로컬 환경에서 SCM_ADM_USER_M 시드 부족이 가장 흔한 원인.

**UGA 매핑 사용자 → USER_M 일괄 시드** (NOT EXISTS, minyonglee1 의 패턴 그대로):
```sql
INSERT INTO SCM_ADM_USER_M (USER_ID, USER_NM, USER_ENG_NM, DEPT_ID, LANG_CD,
    ACNT_LOK_YN, TMZ_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, PERM_KEP_CNC_YN)
SELECT SU.USER_ID, NVL(SU.USER_NAME, SU.USER_ID), SU.USER_NAME_EN, SU.DEPT_ID,
       'KO', 'Y', 'AS054', 'Y', 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE, 'N'
FROM (SELECT DISTINCT USER_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M) U
JOIN SCM_MST_SSO_USER_INFO SU ON SU.USER_ID = U.USER_ID
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_M x WHERE x.USER_ID = SU.USER_ID);
COMMIT;
```

**OWNER popup (COM0004) 특수 조건** — popup SP final SELECT 가:
- `FXU.DEPT_ID IN TMP_DEPT` (= `SCM_MST_SITE_ITEM` OWNER 부서)
- `AND FXU.DEPT_ID NOT IN ('LESIC')`

→ 로그인 사용자가 LESIC 부서인 경우 본인은 결과에서 제외 (정상). 다른 admin 사용자가 OWNER 부서에 등록되어야 popup 결과 노출.

### 8.5 BE/FE 인프라 보강 (로컬 한정)

**FE axios timeout** — `nscm-fe/apps/web/.env.local` (gitignored):
```
VITE_API_TIMEOUT=600000   # 10분
```

**BE HikariCP pool** — `nscm-be/src/main/resources/config/config-local.yml`:
```yaml
datasources[0]:
  maxPoolSize: 30   # 기본 10 → 30
  minIdel: 5        # 기본 10 → 5
```

**Spring Security stale session 가드** — `CustomAuthorizationManager._authorize`:
```java
if (!_isValidAuthentication(auth) || !(auth.getPrincipal() instanceof CustomUserDetails)) {
    return new AuthorizationDecision(false);
}
String userId = ((CustomUserDetails) auth.getPrincipal()).getUserId();
```
적용 후에도 BE 재시작 시 사용자에게 **시크릿 창 재로그인** 안내 의무.

### 8.6 절대 금지

1. ❌ 추측으로 `PKG_*` SP body 수정 — 운영 코드 분기 위험. SQL Profile / 인덱스 / 시드 우선.
2. ❌ 동시 SQL 다발 (여러 백그라운드 `docker exec sqlplus`) → Oracle 큐잉/lock 경합으로 hang
3. ❌ BE/Oracle 컨테이너 사용자 작업 중 무단 재시작 — 사용자 확인 후 진행
4. ❌ `DBMS_STATS estimate_percent=>100` — plan 악화 사례 (DMF0005). AUTO 권장.

### 8.7 산출물 (`_artifacts/`)

- `grant_minyonglee1_full_admin.sql` — minyonglee1 ADMIN UGA + 누락 메뉴/버튼 보강
- `seed_user_m_from_uga_for_popups.sql` — USER_M 일괄 시드 (NOT EXISTS)
- `perf_boost_dmf0005_sysdba.sql` — 인덱스 + 통계 (sysdba)
- `perf_revert_stats.sql` — AUTO_SAMPLE_SIZE 로 복원 + flush
- `sql_profile_dmf0005_v2.sql` — SQL Profile (force_match=TRUE)

---

## §9. Wijmo / FE Runtime / VSCode 인코딩 (2026-05-28 추가)

### 9.1 Wijmo Grid 컬럼 헤더 세로 머지 미작동 — `mergeManager === null`

**증상**:
- `DataGrid` 의 `allowMerging={AllowMerging.ColumnHeaders}` + `handleInitialized` 에서 `grid.mergeManager = new CustomMergeManager(grid)` 정상 실행됨에도 머지 동작 안 함
- DevTools: `grid.mergeManager === null` (undefined 아님)
- `grid.allowDragging === 0` 등 다른 설정은 정상 → handleInitialized 는 실행됨

**근본 원인**: `nscm-fe/node_modules/node_modules/` 잔존 디렉토리 — pnpm 재설치 후 이전 설치 잔존본이 별도 `.pnpm` 저장소를 보유하여 `@mescius/wijmo.grid` 의 `MergeManager` 클래스가 두 인스턴스로 분리됨. setter 의 `instanceof MergeManager` 검사가 실패하여 null 강제 저장.

**검출 명령**:
```bash
ls C:/Projects/NSCM/nscm-fe/node_modules/node_modules 2>/dev/null && echo "DUPLICATE EXISTS"
```

**보완 절차**: `27_WIJMO_PIVOT_AND_MODULE.md §A` + `hooks/module-duplication-check.md` 참조. 핵심:
```bash
rm -rf nscm-fe/node_modules/node_modules
rm -rf nscm-fe/apps/web/node_modules/.vite
# Vite 재기동
```

### 9.2 Wijmo PivotGrid Column / Row Field 미표시

**증상**: `<PivotGrid itemsSource={data}>` 으로 raw 배열 전달 + `initialized` 에서 fields 설정했는데 row/column field 가 화면에 안 보임.

**원인**: React wrapper 가 data 변경 시 내부 engine 의 itemsSource 를 갱신하는 과정에서 fields 가 reset 됨. `useEffect` 마다 `fields.clear() + push` 호출도 매번 reset 의 원인.

**해결 패턴** (`27_WIJMO_PIVOT_AND_MODULE.md §C`):
- `useMemo(() => new PivotEngine(), [])` 로 engine 인스턴스 1회 생성
- `useEffect` 에서 itemsSource 만 갱신, fields 는 **`rowFields.length === 0 && fields.length > 0` 가드** 하에 1회만 push
- `<PivotGrid itemsSource={engine}>` 으로 engine 인스턴스 직접 전달

### 9.3 BE SP 동적 PIVOT vs raw — FE 일자 column 빈 셀

**증상**: DMF0007 의 customerPSI 탭에서 `D_YYYYMMDD` 일자 column 모두 빈 셀.

**원인**:
- FCST SP (`PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA`) 는 `V_ITERATION` 동적 SQL 로 PIVOT 컬럼 (`D_20260525` 등) 생성 → row 에 키 존재
- PSI SP (`P_DMF0007_GET_CUST_PSI_DATA`) 는 PIVOT 로직 없음 → row 에 `D_*` 키 없음 → FE 의 dateColumns binding 이 매칭 실패 → undefined → 빈 셀

**해결 옵션**:
1. PSI SP 에 PIVOT 로직 추가 (FCST 패턴 복제) — wide format
2. 신규 stand-alone SP 로 raw long-format 반환 + 클라이언트 PivotGrid 사용 (DMF0007 PSI Pivot 탭이 채택)

### 9.4 VSCode 한글 깨짐 — `files.encoding` 누락

**증상**: VSCode 에서 한글 주석/문자열이 mojibake (`?` / `□`).

**원인**: `.vscode/settings.json` 에 `files.encoding` 누락 시 Windows 한국어 환경의 시스템 기본 (cp949) 으로 파일 열림. 터미널 `chcp 65001` 만 설정해서는 파일 인코딩 자체 미해결.

**보완**: `hooks/encoding-check.md` 참조. 핵심:
```jsonc
{
  "files.encoding": "utf8",
  "files.autoGuessEncoding": true,
  "[sql]": { "files.encoding": "utf8" },
  "[powershell]": { "files.encoding": "utf8bom" }
}
```
+ `.editorconfig` 의 `charset = utf-8` 추가.

### 9.5 신규 sheet 등록 시 ORA-01403 (PR_GET_PROC_INFO_LIST)

**증상**: FE 가 `POST /<MNU_ID>/<sheetName>/SEARCH/call-proc` 호출 시 BE 로그에 `ORA-01403: no data found at PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST`.

**원인**: `SCM_ADM_MNU_BTN_MPG_M` 에 (MNU_ID, SHT_NM, MNU_BTN_CD) 매핑 누락.

**보완**: 신규 sheet 등록은 **5종 테이블 모두** 시드 필요 (`27_WIJMO_PIVOT_AND_MODULE.md §D`):
1. `SCM_MST_SHEET_COLUMNS` (시트 컬럼 메타)
2. `SCM_ADM_API_M` (API_ID → SP)
3. `SCM_ADM_PROC_M` (SP 파라미터 메타)
4. `SCM_ADM_MNU_BTN_MPG_M` (메뉴-시트-버튼 → API)
5. `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (그룹 권한)

추가: **sheet name 대소문자 완전 일치** 필수 (FE enum vs BE SHT_NM). `customerPsi` vs `customerPSI` 같은 한 글자 차이로 매칭 실패.

### 9.6 SQL*Plus `SQL%ROWCOUNT` ORA-00911

**증상**: 시드 SQL 실행 시 UPDATE 직후 `SELECT TO_CHAR(SQL%ROWCOUNT) AS UPDATED FROM DUAL` 에서 `ORA-00911: %: invalid character`.

**원인**: `SQL%ROWCOUNT` 는 PL/SQL 블록 내부에서만 사용 가능. SQL*Plus 의 standalone SELECT 에서는 인식 안 됨.

**부작용 가중**: `WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK` 가 설정되어 있으면 검증 SELECT 의 에러로 트랜잭션 전체 롤백 → UPDATE 도 되돌려짐.

**해결**: 검증용 row count 가 필요하면 PL/SQL 블록으로 감싸기, 또는 단순 `SELECT COUNT(*)` 로 변경.

---

**본 가이드는 발생한 이슈를 기록·재현·예방하는 살아있는 문서입니다. 새로운 이슈 발생 시 본 문서에 추가하세요.**
