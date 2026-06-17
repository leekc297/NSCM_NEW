# Hook — SP patch 파일 종결자 + 의존 순서 + fallback 의무

> ⚠️ **SP 패치 SQL 파일 작성 + 클라우드 적용 시 의무 점검 룰**
> `END;/` 한 줄 사고 + 객체 의존 순서 PLS-00905 사고 + INVALID 잔존 사고 fallback.

작성: 2026-06-17 (DMF0043 patch 적용 시 2 사고 후)
관련 hook: `oracle-db-workflow.md`, `column-meta-rework-checklist.md`
상위 룰: `anti-simplification.md`

---

## §0. 배경 — 2026-06-17 DMF0043 patch 적용 2 사고

### 사고 1 — `END;/` 한 줄 사고

extract_dmf0043_patch.py 의 출력:
```
END;/    ← 한 줄 (newline 없음)
```

→ ora.py 의 exec / 일부 SQL client 가 `/` 를 SP body 의 일부로 인식 → PLS-00103 line 213 또는 849 position 5 → SP INVALID.

### 사고 2 — 객체 의존 순서 PLS-00905

통합 SQL 의 객체 순서:
1. PKG_DMF0043 PACKAGE
2. PKG_DMF0043 BODY
3. DMF0043_GET_CONTRIBUTE_MAIN_DATA ← line 74 에서 DMF0043_GET_MAIN_SPREAD_TITLE 호출
4. DMF0043_GET_MAIN_SPREAD_TITLE
5. ...

→ 객체 3 CREATE 시 객체 4 가 아직 미존재 → PLS-00905 → 객체 3 INVALID 잔존.

---

## §1. 의무 패턴 — patch 파일 작성 (Python / 도구)

### 1.1 종결자 newline 의무

```python
# ❌ 사고 패턴 — END; + / 한 줄
ddl_with_slash = ddl + "/\n"

# ✅ 의무 패턴 — newline 강제
if not ddl.rstrip().endswith(";"):
    ddl = ddl.rstrip() + ";"
ddl_with_slash = ddl.rstrip() + "\n/\n"
```

### 1.2 객체 순서 — 의존 그래프 기준

> wrapper SP → 호출되는 standalone SP 보다 **나중에** CREATE 의무.

순서 결정:
1. PACKAGE spec
2. PACKAGE BODY
3. **호출되는 SP** 들 (leaf)
4. **호출하는 wrapper SP** 들 (root)

### 1.3 fallback ALTER COMPILE 블록 의무

통합 SQL 파일 끝에 다음 블록 의무:

```sql
-- ===================================================================================================
-- FALLBACK: 의존 객체 순서로 인한 INVALID 잔존 시 강제 재컴파일
-- ===================================================================================================
ALTER PROCEDURE SCM_MGR.<wrapper_sp_1> COMPILE;
/
ALTER PROCEDURE SCM_MGR.<wrapper_sp_2> COMPILE;
/
```

---

## §2. 의무 패턴 — patch 파일 적용 (SQL client)

### 2.1 클라우드 SQL client 별 실행 방법

| Client | 권장 방법 | 주의 |
|---|---|---|
| **SQL*Plus** | `@filename.sql` | `/` 단독 라인 정상 인식 |
| **SQLcl** | `@filename.sql` 또는 script execution | `/` 정상 인식 |
| **SQL Developer** | "Run Script" (F5) | "Run Statement" (F9) 사용 금지 — `/` 처리 안 됨 |
| **DBeaver** | "Execute SQL Script" (CTRL+Alt+X) | 일반 "Execute statement" 사용 시 `/` 가 별개 statement 로 해석 |
| **python-oracledb (ora.py)** | exec 명령 — `/` 단독 라인 인식 | `END;/` 한 줄 시 인식 못함 |

### 2.2 적용 직후 의무 검증 (5 query)

```sql
-- (1) INVALID 객체 확인 — 0 row 기대값
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME LIKE '<PREFIX>%' AND STATUS <> 'VALID';

-- (2) USER_ERRORS 확인 — 0 row 기대값
SELECT NAME, LINE, POSITION, TEXT FROM ALL_ERRORS
 WHERE OWNER = 'SCM_MGR' AND NAME LIKE '<PREFIX>%';

-- (3) INVALID 1+ 시 강제 재컴파일
ALTER PROCEDURE SCM_MGR.<sp_name> COMPILE;

-- (4) 재컴파일 후 상태 재확인
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME = '<SP_NAME>';

-- (5) SCMD_APP 권한 유지 확인
SELECT TABLE_NAME, PRIVILEGE FROM ALL_TAB_PRIVS
 WHERE TABLE_SCHEMA='SCM_MGR' AND GRANTEE='SCMD_APP' AND TABLE_NAME LIKE '<PREFIX>%';
```

### 2.3 INVALID 잔존 시나리오별 fix

| USER_ERRORS 메시지 | 원인 | fix |
|---|---|---|
| PLS-00103 line N position 5 (`/` 심볼) | `END;/` 한 줄 사고 | patch 파일 종결자 newline 추가 후 재실행 |
| PLS-00905 (호출 대상 INVALID) | 의존 객체 순서 사고 | 호출 대상 먼저 컴파일 후 wrapper 재컴파일 |
| PLS-00302 (component must be declared) | PACKAGE BODY signature mismatch | PACKAGE spec + BODY 동시 재배포 |
| ORA-00942 (table or view does not exist) | GT/마스터 테이블 부재 | 의존 테이블 확인 + GRANT |
| PLS-00201 (identifier must be declared) | 의존 PKG 부재 | 의존 PKG 배포 |

---

## §3. 자동화 도구 의무

### 3.1 SP 추출 도구 (extract_*.py) 의무

- ALL_SOURCE 추출 후 `END;` 다음 newline 추가 의무
- 의존 그래프 기반 객체 정렬 의무 (호출되는 쪽 먼저)
- 통합 SQL 끝에 fallback ALTER COMPILE 블록 자동 추가

### 3.2 PR 직전 의무 grep

```bash
# patch 파일 안 END;/ 한 줄 패턴 검출
grep -rnE "END\s*;\s*/" _artifacts/_deploy_packages/**/*.sql

# 결과 0 row 가 기대값
```

---

## §4. 사고 사례 — DMF0043 (2026-06-17)

```
[1차 적용] 사용자가 patch SQL 실행 → LAST_DDL 13:34 갱신
[1차 확인] SELECT STATUS → INVALID 2 SP
[1차 진단] ALL_ERRORS → PLS-00103 line 213/846 position 5 (END;/ 사고)
[2차 적용] 별도 ALTER PROCEDURE COMPILE 실행 → 의존 순서로 1 SP 여전 INVALID
[2차 진단] PLS-00905 (DMF0043_GET_MAIN_SPREAD_TITLE invalid)
[3차 fix] 추출 도구 + 통합 SQL 의 fallback ALTER COMPILE 블록 추가
[최종] 2 SP VALID + cursor 129 컬럼 검증
```

→ 이번 사고로 본 hook 신설.

---

## §5. 관련 hook / 메모리

- `oracle-db-workflow.md` — Oracle 작업 전반 진입점
- `column-meta-rework-checklist.md` §2.3 — 본 hook 의 cross-ref
- `sp-body-minimal-change.md` — SP 변경 최소화
- `sp-substr-zero-index-audit.md` — SP 변환 결함 audit
- 메모리 `feedback_sp_body_no_rewrite.md` — SP body 1바이트 변경 금지
