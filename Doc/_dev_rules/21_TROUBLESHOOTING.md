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
| 메뉴 클릭 시 빈 화면 / `No matching route` / MDI 탭만 열리고 비어있음 | `SCM_ADM_MNU_M.MNU_URL` ↔ FE `route-paths.ts` slug 불일치 (1차) → 권한 (3차) | hook `menu-not-displayed-debug.md` 5단계 의무 (1=URL, 2=라우터, 3=메뉴권한, 4=부모권한, 5=런타임) |
| 조회 버튼 클릭 시 `ORA-06550 PLS-00306: 인수의 갯수나 유형이 잘못되었습니다` | `SCM_ADM_PROC_M` (PROC 메타) 미등록 → BE 가 파라미터 0개로 SP 호출 | 룰 08 §4.4 의 자동 변환 SQL 로 `ALL_ARGUMENTS` → `SCM_ADM_PROC_M` INSERT. 신규 화면 등록 시 BLOCK 4 절대 누락 금지 |
| ORA-06550 PLS-00306 이 **SP body 변경 직후** 발생 | dual/triple cursor 변환 후 PROC_M O_RESULT_CURSOR 누락 | §15.1 + 메모리 `feedback_proc_m_sync_after_sp_body_change.md` |
| BE 로그 `ORA-20001: 오류가 발생했습니다. ORA-06512 at line N` 만 보임 (실제 사고 위치 추적 불가) | EXCEPTION OTHERS 가 generic raise 로 SQLERRM 가림 | §15.5 + hook `sp-exception-handler-debug-friendly.md` 진단 절차 (임시 patch → root cause → 복원) |
| Repair grid 더블클릭 시 ORA-20001 / 실제 원인 `ORA-06533 Subscript beyond count` | `UTL_CALL_STACK.SUBPROGRAM(1)(2)` 안전 체크 누락 | §15.4 + hook `sp-utl-call-stack-safety.md` |
| 브라우저 `사이트에 연결할 수 없음` + curl 도 outbound HTTP=000 | Windows TCP/IP buffer / non-paged pool 일시 고갈 | §15.6 (60-120초 대기 자동 회복 / netsh winsock reset 수동 회복) |

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

## §10. 로컬 Docker Oracle 사고 묶음 (2026-05-30 추가)

> 룰 [29_LOCAL_DB_CSV_IMPORT.md](29_LOCAL_DB_CSV_IMPORT.md) 와 짝. 본 §은 발생한 ORA 에러별 진단/복구 절차.

### §10.1 ORA-12954 / ORA-01109 — Oracle Free Edition 12 GB 한도 초과

**증상**:
- BE bootRun: `[DBCP: nscm_oracle(oracle)] Failed to initialize pool: ORA-01109: database not open`
- sqlplus: `ALTER PLUGGABLE DATABASE FREEPDB1 OPEN` 시 `ORA-12954: The request exceeds the maximum allowed database size of 12 GB.`
- `SELECT name, open_mode FROM v$pdbs;` 결과 `FREEPDB1 = MOUNTED` (READ WRITE 아님)

**원인**: PDB datafile (특히 `temp01.dbf` / `undotbs01.dbf` / `ts_scm_d01.dbf`) 의 control file 등록 logical size 합산이 12 GB 초과. Oracle Free 라이센스 체크가 PDB OPEN 시점에 실패.

**시도해도 안 되는 것**:
- OS level `truncate` (logical size 가 그대로라 한도 체크 통과 X)
- `ALTER PLUGGABLE DATABASE OPEN UPGRADE` (한도 체크 동일)
- `ALTER DATABASE DATAFILE ... RESIZE` (PDB MOUNT 상태에서 PDB datafile 접근 불가, ORA-01516)
- `ALTER SESSION SET CONTAINER = FREEPDB1` (MOUNT 상태에서 컨테이너 전환 불가)

**유일한 복구 = 컨테이너 재구성 (D 옵션)**:
```bash
cd C:\Projects\NSCM\_artifacts\local-docker-oracle
docker compose down -v      # 볼륨까지 삭제
docker compose up -d
# 5~10분 대기 (DATABASE IS READY TO USE)
.\load_all.ps1              # DDL 재적재
# 그 후 CSV 재적재 + 사용자 시드 재적용
```

**사고 회피**:
- 일상 작업 시 `TEMP` tablespace 사이즈 모니터링 (대형 sort/hash 작업 후 truncate).
- 디스크 사용량 정기 점검: `docker exec nscm-oracle du -sh /opt/oracle/oradata/FREE/FREEPDB1/`

### §10.2 화면 조회 결과 0건 — 5단계 진단

> **금지**: "데이터 자체가 없다" 단정. anti-simplification 룰 — 데이터 source 정확 추적.

#### 진단 5단계 (순서대로)

```
[1] BE log 에서 호출 SP 식별
    Get-Content $beLog | Select-String "PKG_DMF{화면ID}|/DMF{화면ID}/.+/call-proc"
    → exception="" 이면 SP 실행 성공 + 결과 0

[2] SP body 에서 사용 테이블 추출 (FROM/JOIN 모두)
    SELECT line, text FROM dba_source WHERE name='PKG_DMF{화면ID}' AND type='PACKAGE BODY'
      AND line BETWEEN <proc_start> AND <proc_end>
    → anti-simplification: 200 lines 만으로는 부족, procedure 전체 추출 의무

[3] 각 테이블 row count 확인
    SELECT 'tbl='||COUNT(*) FROM SCM_MGR.<tbl>;
    → 0 이거나 dependency synonym 깨졌으면 그 테이블이 원인

[4] CSV/DDL 폴더에서 누락 테이블 매칭
    ls /c/TRANFILE/DB/DATA/ | grep -i <tbl>
    → 있으면 적재 (룰 29 §2 의 200MB 임계 적용)

[5] SP 동적 SQL 의 WHERE 조건 검증 (위 1~4 후에도 0 일 때)
    - PLAN_WEEK 자동 계산: SP 가 `SCM_SYS_CALENDAR_M.ISO_YYYYWW` 기반 → 데이터 의 MAX PLAN_WEEK 과 불일치 시 0
    - 권한 JOIN: PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID) — `P_MENU_ID` 가 NULL 이면 결과 0 (§10.3 참조)
```

#### 사례
- **DMF0007 (Customer FCST)**: `DM_MST_CUSTOMER_FCST` 미적재 → CSV 200MB 미만이라 전체 + 82 row 도 보강. PLAN_WEEK='202622' 부재 → 202621 복제로 생성.
- **DMF0006 (Customer Model)**: `DM_MST_CUSTOMER_MODEL` 미적재 → CSV 25 KB 라 전체 적재.

### §10.3 SP 호출 결과 0건 / 권한 fail — PROC_M COL_NM 정확성

**증상**:
- SP 호출은 정상 (exception=""), 결과만 0건
- 또는 `No Permission` 메시지
- 직접 SQL 으로 같은 조건 실행 시 결과 있음

**원인**: `SCM_ADM_PROC_M` 의 `COL_NM` 이 BE 자동 채움 키와 매칭 안 됨 → BE 가 그 자리에 NULL 전달 → SP 내부 권한 JOIN (`PR_SCM_EDIT_YN`, UGA cross 등) 실패.

**BE 가 자동 채우는 PROC_M COL_NM** (FE 가 별도 명시 안 해도 BE 가 session 에서 자동 매핑):
| COL_NM | 값 |
|---|---|
| `sesUserId` | 로그인 사용자 ID |
| `sesLangCd` | 세션 언어 코드 |
| `mnuId` | 현재 메뉴 ID (** `menuId` 아님**) |

**금지된 COL_NM** (BE 가 자동 채움 안 함):
- `menuId` (BE 는 `mnuId` 매칭)
- `userInfo` (BE 는 `sesUserId` 매칭)
- `P_USER_ID` / `P_MENU_ID` 같은 SP signature 변수명 그대로 (BE 는 camelCase JSON key 매칭)

**fix 절차**:
1. 잘 동작하는 SP (예: `PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA`) 의 PROC_M COL_NM 확인하여 9번째 위치 = `mnuId` 패턴 학습.
2. 신규 SP 의 PROC_M 시드 시 동일 패턴 적용.
3. PROC_M 의 PK = (PROC_NM, COL_NM, COL_TP_CD) 라 `UPDATE` 시 PK 충돌 → `DELETE` + `INSERT` 패턴 사용.

**사고 사례**: 2026-05-30 DMF0007 `customerPsi/SEARCH` redirect 시 PROC_M 의 9번째 COL_NM 을 `menuId` 로 잘못 시드 → BE 가 `mnuId` 매칭 → NULL 전달 → SP 내부 `PR_SCM_EDIT_YN(P_USER_ID, NULL)` 결과 0 → 화면 빈 결과.

### §10.4 BE 캐시 `Query is not exist` — `SCM_ADM_CMBO_SQL_M` reload 후

**증상**: dropdown / lookup combo 가 빈 결과. BE log `EXCEPTION: LookupController.retrieveCombo() | Message: Query is not exist.`

**원인**: BE 가 시작 시점에 `SCM_ADM_CMBO_SQL_M` 의 combo SQL 들을 cache. 그 후 row 가 추가/변경되어도 BE cache 에 반영 안 됨.

**해결**: BE 재기동 → 사용자 시크릿 창 재로그인.

**같은 패턴이 적용되는 메타 테이블** (변경 후 BE 재기동 권장):
- `SCM_ADM_CMBO_SQL_M`, `SCM_MST_SHEET_COLUMNS`, `SCM_ADM_API_M`, `SCM_ADM_PROC_M`, `SCM_ADM_MNU_M`

---

## §11. PowerShell / Windows 환경 사고 묶음 (2026-05-30 추가)

이번 세션의 Figma fetch + 백업 자동화 작업에서 발견한 Windows PowerShell 동작 차이/사고들.

### §11.1 PowerShell AMSI crash — Antimalware Scan Interface 메모리 오류

**증상**:
```
Unhandled Exception: System.AccessViolationException: Attempted to read or write protected memory.
   at System.Management.Automation.AmsiUtils.AmsiNativeMethods.AmsiScanBuffer(...)
   at System.Management.Automation.AmsiUtils.ScanContent(...)
   at System.Management.Automation.CompiledScriptBlockData.PerformSecurityChecks()
```
- `.ps1` 스크립트 실행 도중 갑자기 PowerShell 프로세스 자체가 crash
- 같은 스크립트를 다시 실행하면 종종 성공 (재현성 낮음)

**원인**: Windows Defender / 사내 보안 에이전트의 AMSI scanning 이 PowerShell 의 script block compilation 도중 native memory 접근 충돌. 일시적 (시스템 메모리 압박 / Defender 갱신 직후).

**우회 (가장 안정적)**:
1. **bash 으로 작업 이전** (Git Bash 가 NSCM 환경에 항상 있음):
   ```bash
   # 예: figma_link.md 397 이관 — PowerShell migrate-figma-md.ps1 가 crash → bash 우회
   find /c/Projects/NSCM/Doc/_analysis -name "figma_link.md" -type f | while read f; do
     raw=$(basename "$(dirname "$f")")
     sid=$(echo "$raw" | sed -E 's/\.(UIL|designer|cs)$//' | tr -d ' ')
     cp "$f" "/c/Projects/NSCM/Doc/_figma/screens/${sid}.md"
   done
   ```
2. **`powershell -NoProfile -ExecutionPolicy Bypass -File <script>`** 로 별도 instance 실행 (AMSI re-init):
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\path\script.ps1
   ```
3. 같은 스크립트 재시도 (often 통과)

**예방 (시도 가치)**:
- 스크립트 길이 줄이기 — AMSI scan 부담 ↓
- 모듈/dot-source 분리

### §11.2 PowerShell `Invoke-RestMethod` foreground vs background 일관성 차이

**증상**: 같은 URL + 같은 token 인데 foreground 에서 200 OK 받고 background 에서 404/429.

**사례** (2026-05-30 Figma fetch):
- foreground `Invoke-RestMethod -Uri "https://api.figma.com/v1/files/c9V...?depth=2"` → 200 OK, 1.2 MB JSON 수신
- background (같은 PowerShell tool, run_in_background:true) 같은 호출 → 404 Not Found

**원인**: PowerShell tool 의 새 instance 가 spawn 될 때 (1) DNS cache 다름 (2) `[Net.ServicePointManager]::SecurityProtocol` 기본 다름 (TLS 1.0 fallback?) (3) 같은 환경 변수 (proxy 등) 다르게 정의 가능. 또는 Figma 의 rate limit 가 호출별로 다르게 적용.

**우회 (가장 안정적)**:
1. **`curl` (bash 또는 cmd /c) 사용** — TLS / proxy 동작이 PowerShell 보다 일관성 있음:
   ```bash
   TOKEN=$(tr -d '\r\n ' < /c/Projects/NSCM/.figma_token)
   curl -s -H "X-Figma-Token: $TOKEN" "https://api.figma.com/v1/files/..." -o /tmp/resp.json
   ```
2. **PowerShell 안에서 curl 호출**:
   ```powershell
   $tmpJson = "$env:TEMP\resp.json"
   & cmd /c "curl -s -H `"X-Figma-Token: $Token`" `"$endpoint`" -o `"$tmpJson`" --max-time 60"
   $resp = Get-Content $tmpJson -Raw | ConvertFrom-Json
   ```
3. 또는 PowerShell 코드 시작에서 명시적으로:
   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   ```

### §11.3 `$ErrorActionPreference = "Stop"` + `2>&1` + native exe = NativeCommandError

**증상**: `docker compose up`, `git push` 등 native exe 가 정상 동작 (exit code 0) 인데도 PowerShell 이 즉시 throw 하고 스크립트 중단.

**원인**: PowerShell 5.1 에서 `2>&1` 가 native exe stderr 의 모든 line 을 ErrorRecord 로 wrap → `$?` = false → `ErrorActionPreference = "Stop"` 가 throw. 정상 stderr (예: docker 의 warning 메시지, sqlplus 의 SP2-XXXX 정보 메시지) 도 fatal 처리.

**우회**:
- `$ErrorActionPreference = "Continue"` (전역)
- `2>&1 | Out-Null` → `*> $null` (모든 스트림 무시)
- 정상 exit code 만 `$LASTEXITCODE` 로 검사

**사례**: start-all.ps1 / backup-all.ps1 / restore-all.ps1 모두 이 패턴으로 fix 완료 (commit `0232676`, `ff27edb`).

### §11.4 `.gitignore` 의 `**/*.log` 가 메타 백업 log 까지 차단

**증상**: `_backup_metadata/.../oracle-full.log` 가 commit 에 안 들어감 (git status 도 안 보임).

**원인**: `.gitignore` 의 line 59 `**/*.log` 가 모든 log 차단.

**해결**: 예외 패턴 `!_backup_metadata/**/*.log` 추가.
```
**/*.log
!_backup_metadata/**/*.log
```

같은 패턴이 적용 가능한 다른 디렉토리:
- `_artifacts/` 안의 검증용 log (필요 시 케이스 별 예외)

### §11.5 `Doc/_figma/` 폴더 통째 ignore 가 README + screens 도 차단

**증상**: `Doc/_figma/README.md`, `screens/{화면ID}.md` 가 commit 에 안 들어감.

**원인**: `.gitignore` 의 `Doc/_figma/` 가 폴더 통째 ignore.

**해결**: 세분화 — track 대상 (README + screens/) 은 명시적으로 ignore 해제, 산출물 (_api_cache/ + _images/ + CSV) 만 ignore.
```
# Doc/_figma/_api_cache/
# Doc/_figma/_images/
# Doc/_figma/_figma_screen_mapping*.csv
# (Doc/_figma/README.md + screens/ 는 자동으로 track)
```

---

**본 가이드는 발생한 이슈를 기록·재현·예방하는 살아있는 문서입니다. 새로운 이슈 발생 시 본 문서에 추가하세요.**

## §12. DMF0043 DB 오류 사고 묶음 (2026-06-01 추가)

> ⭐⭐ **진실 source (DB 오류 진단 주제) — 이 주제는 여기만 변경.**
> 룰 24 §6.5 / hook `db-error-asis-cross-check.md` 는 이 절을 link only 참조.

DMF0043 작업 중 발견한 DB 오류 11종. **동일 패턴은 다른 PIVOT/동적 SP 화면에도 발생 가능** — 재발 방지 의무.

### §12.1 ORA-06504 (Return types of Result Set variables or query do not match)
- **원인**: TITLE SP O_RC1 default 분기에 `EDIT_YN` 23번째 컬럼 — caller 22-var FETCH 와 불일치
- **Fix**: SELECT 의 추가 컬럼 제거 (`_artifacts/55`)
- **재발 방지**: SP `OPEN ... FOR SELECT` 의 컬럼 수 = caller `FETCH ... INTO 변수` 수 cross-check

### §12.2 caller 가 잘못된 OUT cursor FETCH
- **원인**: TITLE SP default 분기가 `OPEN O_RC3 FOR ...` 인데 caller 는 `v_rc1` (O_RC1) FETCH
- **Fix**: SP 본문 `O_RC3` → `O_RC1` (`_artifacts/54`)
- **재발 방지**: caller FETCH cursor 이름 = SP OPEN cursor 이름 일치 의무

### §12.3 ORA-01427 (single-row subquery > 1 row)
- **원인**: `SCM_MST_SHEET_COLUMNS` seed 중복 (8 컬럼 × 2 dup)
- **Fix**: PARTITION BY ROW_NUMBER dedupe + PK index UNIQUE→NON-UNIQUE (`_artifacts/57`)
- **재발 방지**: 화면 작업 전 `SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DIVISION_ID)` 중복 grep

### §12.4 ORA-01489 (result of string concatenation is too long)
- **원인**: `LISTAGG('[' || col || '],')` 동적 컬럼 168개 × ~30자 > VARCHAR2(4000)
- **Fix**: LISTAGG → CURSOR LOOP + CLOB concat (`_artifacts/58`)
- **재발 방지**: PIVOT/동적 컬럼 SP 의 LISTAGG 잔존 시 CLOB 패턴

### §12.5 ORA-00936 (missing expression — dynamic SQL)
- **원인**: MSSQL `[col]` 식별자 + PIVOT IN 절 Oracle 비호환
- **Fix**: `[col]` → `"col"` + PIVOT IN `'val' AS "alias"` (`_artifacts/61`)
- **재발 방지**: To-Be SP body 의 `[A-Z_]` 패턴 grep 으로 변환 누락 사전 검출

### §12.6 ORA-00904 (invalid identifier — SITE_ITEM.PRODUCT_GROUP)
- **원인**: To-Be 마이그레이션에서 `REPORT_GROUP3` 컬럼 자체 누락
- **Fix**: As-Is DB 컬럼 cross-check → ALTER TABLE ADD + dim 데이터 import + JOIN 복원 (`_artifacts/63`)
- **재발 방지**: 컬럼 누락 진단 시 룰 24 §6.5 As-Is DB 직접 조회 의무

### §12.7 ORA-56907 (PIVOT 중복 alias)
- **원인**: TITLE SP 의 GTT (GT_GMST_TEMP_2 / GT_GMST_TEMP2_2) DELETE 없이 INSERT만 → BE pool session 재사용 시 row 누적
- **Fix**: SP 시작에 `DELETE FROM GTT` 추가 (`_artifacts/65`)
- **재발 방지**: 모든 GTT 사용 SP 의 시작부에 명시적 DELETE 의무

### §12.8 ORA-01400 (CREATED_BY NULL)
- **원인**: `callSettersOnNulls=true` 활성화 후 `CustomMap.put` 의 `value.getClass()` NPE → exception 처리 중 sesUserId NULL 상태로 sys_log INSERT
- **Fix**: `CustomMap.java` null guard (`if (value == null) return super.put(key, null);`)
- **재발 방지**: MyBatis `callSettersOnNulls=true` 활성화 시 모든 typeHandler / CustomMap subclass NULL 처리 검토

### §12.9 ORA-06502 (PL/SQL 문자열 버퍼 너무 작음)
- **원인**: SAVE SP line 113 `v_in_para_data VARCHAR2(4000) := JSON_OBJECT(...)` — 96 row × 다수 컬럼 = 수만 char
- **Fix**: `v_in_para_data CLOB` + `JSON_OBJECT(... RETURNING CLOB)`
- **재발 방지**: bulk save SP (^ 구분 string) 의 JSON_OBJECT / 변수 선언 CLOB 의무

### §12.10 ORA-01722 (invalid number — SUBSTR offset 0 bug)
- **원인**: MSSQL → Oracle 변환 시 `SUBSTR(str, 0, idx)` 그대로 — Oracle offset 0 == 1 + length=idx → ^ 포함 추출
- **Fix**: `SUBSTR(str, 0, idx)` → `SUBSTR(str, 1, idx - 1)` 13곳 일괄 (`_artifacts/68`)
- **재발 방지**: To-Be SP body 의 `SUBSTR(.., 0, v_index_..)` 패턴 grep 후 `1, idx-1` 치환

### §12.11 BE → SP IN parameter NULL (callMutationProc array wrap)
- **원인**: `useProcMutation.mutate` array signature → `apiClient.callMutationProc` 가 `{data: [...]}` wrap → BE 의 `BaseService.makeProcedure` 가 `params.activeFlag` top-level lookup → 못 찾음
- **Fix**: `apiClient.post('/{menuId}/{sheet}/{action}/call-proc', {top-level fields})` 직접 호출
- **재발 방지**: bulk save (^ 구분, single payload) 화면은 `mutate` 우회 + `apiClient.post` 직접. Row-by-row 만 `mutate(array)`

### §12.Q Quick Decision Tree

| 증상 | 1차 의심 | §12.X |
|---|---|---|
| 화면 0건 (SP exception=NULL) | TITLE SP OPEN cursor 이름 / SHEET_COLUMNS 중복 / dim 0건 | §12.1~3, §12.6 |
| ORA-01489 / 문자열 한도 | LISTAGG / VARCHAR2(4000) | §12.4, §12.9 |
| ORA-00936 dynamic SQL | MSSQL `[col]` / PIVOT IN | §12.5 |
| ORA-56907 PIVOT alias | GTT 누적 (DELETE 누락) | §12.7 |
| ORA-01400 NULL FK | callSettersOnNulls 후 NPE | §12.8 |
| ORA-01722 invalid number | SUBSTR offset 0 bug | §12.10 |
| 저장 OK + 실제 DB 미변경 | mutate array wrap + BE top-level lookup | §12.11 |
| **POPUP 데이터 미조회** | **SHEET_COLUMNS duplicate / 권한 / activeFlag mismatch** | **§13** |
| **wrapper SP `ALL → ''` 변환** | **메인 SP 'ALL' 비교 미일치** | **§14** |

---

## ⭐ §13. POPUP 데이터 미조회 5단계 진단 (2026-06-02 신설 — DMF0072 Model/Nickname Popup 사고)

### §13.0 배경

DMF0072 진입 후 Model/Nickname Popup 클릭 시 **데이터 0건 표시**. 5단계 진단으로 root cause 발견 = `SCM_MST_SHEET_COLUMNS` duplicate.

> "권한 누락" 단정 금지 (메뉴 미표시 hook 과 동일 anti-pattern).

### §13.1 5단계 진단 (sequential)

```sql
-- 1단계 — BTN_MPG 등록 확인
SELECT MNU_ID || '|' || SHT_NM || '|' || MNU_BTN_CD || '|' || API_ID
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='{POPUP_MENU_ID}';

-- 2단계 — API_M URL (PROC_NM 가 실제 존재 SP 인지)
SELECT API_ID || '|' || API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID='{API_ID}';

-- 3단계 — PROC_M signature (FE 인자 ↔ COL_NM 정합)
SELECT COL_NM, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{API_URL}' ORDER BY SORT_ORD;

-- 4단계 — SP 직접 호출 (FE 인자 그대로)
DECLARE V_RC SYS_REFCURSOR; ... BEGIN
  SCM_MGR.{PKG}.{SP}(<인자>, V_RC); -- row count
END; /

-- 5단계 — SCM_MST_SHEET_COLUMNS duplicate
SELECT 'distinct' AS K, COUNT(DISTINCT COLUMN_NAME) AS V FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='{POPUP_MENU_ID}' AND SHEET_NAME='{POPUP_SHEET_NAME}'
UNION ALL
SELECT 'total', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='{POPUP_MENU_ID}' AND SHEET_NAME='{POPUP_SHEET_NAME}';
-- total > distinct → duplicate
```

**Fix (5단계 duplicate 발견 시)**:
```sql
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
 WHERE X.PROGRAM_ID = '{POPUP_MENU_ID}'
   AND X.SHEET_NAME = '{POPUP_SHEET_NAME}'
   AND X.ROWID NOT IN (
     SELECT MIN(Y.ROWID) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS Y
      WHERE Y.PROGRAM_ID = '{POPUP_MENU_ID}' AND Y.SHEET_NAME = '{POPUP_SHEET_NAME}'
      GROUP BY Y.COLUMN_NAME
   );
COMMIT;
```

### §13.2 적용 사례

| 사례 | 화면 | 진단 단계 | 원인 | Fix |
|---|---|---|---|---|
| 2026-06-02 | DMF0072 Model/Nickname Popup (COM0008) | 5단계 — 34 = 17 × 2 | INSERT 2회 실행, 메모리 룰 `feedback_sql_idempotent_insert_all` 위반 | `_artifacts/56_COM0008_sheet_columns_dedupe.sql` |

### §13.3 cross-ref

- 메모리 `feedback_sql_idempotent_insert_all`
- hook `menu-not-displayed-debug.md`

---

## ⭐ §14. Wrapper SP 의 `'ALL' → ''` 변환 안티 패턴 (2026-06-02 신설 — DMF0072 격차 A 사고)

### §14.0 사고 패턴

```sql
-- ❌ wrapper 가 'ALL' → '' 변환 후 메인 SP 호출
PKG_XXX.P_MAIN_SP(
    CASE WHEN P_DEPT_ID='ALL' THEN '' ELSE P_DEPT_ID END, ...
);
```

메인 SP 가 `'ALL'` 직접 비교 (As-Is 표준):
```sql
AND CASE WHEN P_DEPT_ID = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END
    IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DEPT_ID, ',')) ...)
```

→ wrapper 가 `''` 빈 string 전달 → `UF_FX_STRING_SPLIT('', ',')` = **0 rows** → **모든 메인 데이터 0건 매칭**.

### §14.1 Fix

```sql
-- ✅ wrapper 는 인자 그대로 + sesUserId/mnuId 전달
PKG_XXX.P_MAIN_SP(P_DEPT_ID, P_USER_ID, P_MENU_ID, O_RC1, ...);
```

### §14.2 적용 사례

- DMF0072 `DMF0072_GET_NNMASTER_MAPPING_WRAPPER` (`_artifacts/52`) — sesUserId/mnuId 추가 + ALL 변환 제거 → 메인 조회 정상

### §14.3 cross-ref

- 메모리 `feedback_wrapper_sp_no_all_transform.md`
- 룰 24 §6.5 As-Is DB cross-check

---

## ⭐ §15. DMF0008 사고 묶음 (2026-06-10 신설)

> 사용자 보고: "조회 시 sql error" / "Repair 더블클릭 시 sql error" / "사이트에 연결할 수 없음" / "PKG/SP 다시 보완".
> 5 사고 root cause 분석 + fix + 재발 방지 절차.
> 진실 source: 본 §15. hook `sp-utl-call-stack-safety.md` / `sp-exception-handler-debug-friendly.md` 는 link only.

### §15.1 ORA-06550 PLS-00306 — PROC_M O_RESULT_CURSOR 누락 (3 SP 일괄)

- **원인**: 2026-06-09 이후 SP body 가 dual-cursor (O_RC1 + O_RESULT_CURSOR) 또는 triple-cursor (O_RC1 + O_RC3 + O_RESULT_CURSOR) 패턴으로 변환됐으나 SCM_ADM_PROC_M 메타 미동기화
- **검출**: 메모리 `feedback_proc_m_sync_after_sp_body_change.md` §진단 SQL
- **Fix**: NOT EXISTS 멱등 INSERT (메모리 §Fix 패턴)
- **DMF0008 대상**: SUMMARY (5 IN + 3 OUT) / REPAIR (7 IN + 2 OUT) / SALES_SITE_PROJECT_MODEL (5 IN + 2 OUT)
- **artifact**: `_artifacts/_deploy_packages/DMF0008/03_META/100_DMF0008_PROC_M_O_RESULT_CURSOR_boost.sql`

### §15.2 cursor 덮어쓰기 (SP body line 132 OPEN O_RC1 FOR DUMMY)

- **원인**: SUMMARY SP body 가 line 66 메인 OPEN O_RC1 후 line 132 에서 `OPEN O_RC1 FOR SELECT NULL AS DUMMY` 로 덮어쓰기 — 메인 결과 → DUMMY 변경
- **검출**: SP body `OPEN O_RC1` 다중 발생 + 두 번째가 DUMMY 패턴 grep
- **Fix**: 두 번째 OPEN O_RC1 line 주석 처리 (O_RC3 OPEN 은 유지 — top-level OPEN 없으면 cursor 미할당)
- **메모리**: `feedback_sp_cursor_reassignment_overwrite.md`

### §15.3 NVL(EXCEPTION_FLAG, NULL) != 'Y' anti-pattern

- **원인**: `NVL(x, NULL) != 'Y'` 또는 bare `x != 'Y'` — NULL 비교 시 UNKNOWN → row 제외. 대부분 EXCEPTION_FLAG IS NULL 인 source 데이터 → 모든 row 제외
- **검출**: `NVL(.*, NULL)` 또는 EXCEPTION_FLAG 단독 `!= 'Y'` grep
- **Fix**: `NVL(EXCEPTION_FLAG, 'N') != 'Y'`
- **메모리**: `feedback_isnull_to_nvl_null_handling.md`

### §15.4 UTL_CALL_STACK.SUBPROGRAM(1)(2) 안전 체크 누락 (ORA-06533 Subscript beyond count)

- **원인**: line 53 `IF UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL THEN` → 첫 element 존재만 보장. line 54 의 (2) 인덱스 접근 시 top-level 호출 시 폭발
- **검출**: hook `sp-utl-call-stack-safety.md` §4 자동 grep (`SUBPROGRAM(1)(2)` + `.COUNT >=` 부재)
- **Fix**: `IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN ... (1)(2) ... ELSE $$PLSQL_UNIT END IF`
- **자매 reference**: DMF0008_GET_SALES_SITE_PROJECT_MODEL line 57 (정확 패턴) vs DMF0008_GET_SALES_SITE line 53 (안티 패턴)
- **메모리**: `feedback_sp_utl_call_stack_safe_pattern.md`

### §15.5 EXCEPTION OTHERS 가 SQLERRM 가림 + SCM_SYS_LOG 미존재 cascade fail

- **Symptom**: BE 로그 `ORA-20001: 오류가 발생했습니다. ORA-06512 at line N` (N = EXCEPTION 안 RAISE_APPLICATION_ERROR 위치). 진짜 사고 원인 추적 불가
- **2 단계 사고**: (1) RAISE_APPLICATION_ERROR generic 메시지로 SQLERRM 손실 (2) SCM_SYS_LOG 테이블 미존재 시 PR_SCM_SYS_LOG_BATCH 자체 raise → cascade
- **진단 절차**: hook `sp-exception-handler-debug-friendly.md` §4 (임시 patch → root cause → 복원)
- **Fix 예 (개발 환경)**:
  ```sql
  EXCEPTION WHEN OTHERS THEN
    -- PR_SCM_SYS_LOG_BATCH(...);
    RAISE_APPLICATION_ERROR(-20001,
      'SQLCODE=' || TO_CHAR(SQLCODE) || ' SQLERRM=' || SQLERRM ||
      ' BACKTRACE=' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 800));
  END;
  ```
- **메모리**: `feedback_exception_handler_hiding_real_error.md`

### §15.6 Windows TCP/IP buffer ENOBUFS (`사이트에 연결할 수 없음`)

- **Symptom**: vite proxy 로그 `AggregateError [ENOBUFS]` + `No buffer space available` + curl 로 outbound 도 HTTP=000 (lge.com 도 응답 없음)
- **원인**: 24초 걸리는 SP 호출 (SSPM) + vite proxy → BE 사이 연결 누적 → Windows 의 dynamic port range 또는 non-paged pool 일시 고갈
- **진단**: `netstat -an | awk '/TIME_WAIT/...'` + `netsh int ipv4 show dynamicport tcp`
- **자동 회복**: 60~120초 대기 — TIME_WAIT 자동 정리
- **수동 회복**:
  1. 다른 port 로 vite 재기동 (`vite --port 5174`)
  2. `netsh winsock reset` + `netsh int ip reset` (관리자 + 재부팅 필요)
  3. SP 자체 튜닝 (SSPM 24초 → ms 단위)

### §15.7 cross-ref

- 메모리 `feedback_proc_m_sync_after_sp_body_change.md` / `feedback_sp_cursor_reassignment_overwrite.md` / `feedback_isnull_to_nvl_null_handling.md` / `feedback_sp_utl_call_stack_safe_pattern.md` / `feedback_exception_handler_hiding_real_error.md`
- hook `sp-utl-call-stack-safety.md` / `sp-exception-handler-debug-friendly.md`
- 룰 v2 hook `proc-meta-signature-match.md` — PROC_M signature PR 머지 게이트
- 패키지 보강: `_artifacts/_deploy_packages/DMF0008/_README_2026-06-10_PATCH.md`
