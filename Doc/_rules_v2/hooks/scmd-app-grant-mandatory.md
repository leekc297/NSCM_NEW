# Hook — SCMD_APP 권한 (BE 사용계정) 의무

> ⭐ **사용자 명시 사고 (2026-06-12)**:
> 사내 SCM_MGR 로는 데이터 조회 OK, BE 실 사용계정 SCMD_APP 로는 -9994 "Sql Error" 발생.
> 신규 화면 작성 시 SP/테이블의 SCMD_APP EXECUTE/SELECT/INSERT/UPDATE/DELETE GRANT + SYNONYM 누락이 반복 사고.
> 6 화면 (SYS0010~15) 점검 결과 SYS0010 4 + SYS0011 13 + SYS0013 9 = **25 SP GRANT 누락** + SCM_ADM_PROGRAM 테이블 4 권한 누락 확인.

작성: 2026-06-12 (SYS0014 클라우드 500 사고 진단 결과)
상위 룰: `anti-simplification.md`
관련 룰: `_tobe/12_metadata_sql.md` / `ui-dynamic-property-management.md`

---

## §0. 트리거

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 풀스택 작성 (T01) | PRE-WRITE + PRE-SUBMIT 의무 |
| 신규 SP 컴파일 (T08 BE) | POST-WRITE 즉시 GRANT |
| 신규 테이블 DDL 작성 | POST-WRITE 즉시 GRANT |
| 클라우드 이관 패키지 작성 (T18) | **deploy SQL 09_GRANT_SCMD_APP.sql 필수 포함** |
| BE 응답 `-9994 "Sql Error"` | PLS-00201 권한 부족 의심 |

---

## §1. NSCM Schema 모델

```
┌─────────────────┐                              ┌─────────────────┐
│  SCM_MGR        │ ────── DDL Owner ──────►     │  SCMD_APP       │
│  (테이블/SP     │                              │  (BE 연결 계정) │
│   소유 + DDL)   │ ────── GRANT EXECUTE ──►     │  (DML/EXECUTE만)│
│                 │ ────── CREATE SYNONYM ─►     │                 │
└─────────────────┘                              └─────────────────┘
                                                          │
                                                          ▼
                                                  BE callProc (no prefix)
                                                  → 권한/SYNONYM 부재 시
                                                    PLS-00201 → -9994
```

| 항목 | SCM_MGR | SCMD_APP |
|---|---|---|
| 역할 | DDL owner / 모든 객체 소유 | BE 실 연결 계정 |
| DDL 권한 | ALL | NONE (사용자 작업) |
| 테이블 권한 | OWNER | SELECT/INSERT/UPDATE/DELETE (GRANT 필요) |
| SP 권한 | OWNER | EXECUTE (GRANT 필요) |
| SYNONYM | 불필요 | 필수 (no-prefix 호출용) |

---

## §2. 신규 화면 작성 시 의무 패턴

### 2.1 SP 컴파일 직후 즉시 GRANT (메모리에 남기지 말 것)

```sql
-- 신규 SP 1개 작성 시 즉시 실행 (SCM_MGR 계정)
CREATE OR REPLACE PROCEDURE P_NEW_SP(...) AS ... END;
/
GRANT EXECUTE ON SCM_MGR.P_NEW_SP TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.P_NEW_SP FOR SCM_MGR.P_NEW_SP;
```

⚠ **사고 패턴**: SP 컴파일만 하고 GRANT 미실행 → 사내 SCM_MGR 로는 동작 → 클라우드 BE 가 SCMD_APP 으로 호출 시 PLS-00201 → -9994 "Sql Error".

### 2.2 신규 테이블 DDL 직후 즉시 GRANT

```sql
CREATE TABLE SCM_MGR.SCM_ADM_NEW (...);
GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.SCM_ADM_NEW TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.SCM_ADM_NEW FOR SCM_MGR.SCM_ADM_NEW;
```

⚠ **사고 패턴**: 신규 테이블 (SCM_ADM_PROGRAM, DM_TMP_DYNAMIC_QUERY_*) 만들고 데이터 import 만 하고 GRANT 누락 → BE INSERT/SELECT 시 ORA-00942.

### 2.3 PKG 작성 시 — Package 자체에 GRANT (member procedure 별 GRANT 불필요)

```sql
CREATE OR REPLACE PACKAGE PKG_NEW AS PROCEDURE P_A(...); PROCEDURE P_B(...); END;
/
CREATE OR REPLACE PACKAGE BODY PKG_NEW AS ... END;
/
GRANT EXECUTE ON SCM_MGR.PKG_NEW TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.PKG_NEW FOR SCM_MGR.PKG_NEW;
```

---

## §3. 이관 패키지 의무 — `09_GRANT_SCMD_APP.sql`

### 3.1 표준 위치

```
{SCREEN}_v1_full/
└─ 03_META/
   ├─ 01_MNU_i18n.sql
   ├─ 02_SHEET_COLUMNS.sql
   ├─ 03_MNU_BTN_MPG.sql
   ├─ 04_API_M.sql
   ├─ 05_PROC_M.sql
   ├─ 06_USER_GR_BTN.sql
   ├─ 07_USER_GR_BTN.sql
   └─ 09_GRANT_SCMD_APP.sql    ⭐ 본 hook 의무 추가
```

### 3.2 표준 SQL 템플릿

```sql
-- {MENU_ID} SCMD_APP 권한 (BE 사용계정)
-- ⚠ SCM_MGR (DDL owner) 에서 실행
-- ⚠ 누락 시 BE 호출 -9994 'Sql Error' (PLS-00201 권한없음)

-- 1) SP EXECUTE GRANT + PUBLIC SYNONYM
GRANT EXECUTE ON SCM_MGR.{SP_NAME_1} TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.{SP_NAME_1} FOR SCM_MGR.{SP_NAME_1};
-- ... (해당 화면의 모든 SP 반복)

-- 2) 신규 테이블 GRANT (해당 화면의 신규 테이블)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.{NEW_TABLE} TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.{NEW_TABLE} FOR SCM_MGR.{NEW_TABLE};

-- 3) 검증
SELECT GRANTEE, PRIVILEGE, TABLE_NAME FROM DBA_TAB_PRIVS
 WHERE GRANTEE='SCMD_APP' AND OWNER='SCM_MGR' AND TABLE_NAME LIKE '%{MENU_ID}%'
 ORDER BY TABLE_NAME, PRIVILEGE;
```

---

## §4. PRE-WRITE 자기 점검

- [ ] 신규 SP 컴파일 직후 `GRANT EXECUTE ... TO SCMD_APP` 실행?
- [ ] 신규 SP `CREATE OR REPLACE SYNONYM SCMD_APP.{SP} FOR SCM_MGR.{SP}` 실행?
- [ ] 신규 테이블 DDL 직후 4 권한 + SYNONYM 실행?
- [ ] 이관 패키지 `03_META/09_GRANT_SCMD_APP.sql` 작성?

---

## §5. POST-WRITE 자동 검증 SQL

### 5.1 사내 권한 인벤토리 (SCM_MGR 로 실행)

```sql
-- 화면별 SP 권한 누락 점검
SELECT mid, sp_name, has_grant FROM (
  SELECT b.MNU_ID mid, SUBSTR(a.API_URL, INSTR(a.API_URL, '.', -1) + 1) sp_name,
         CASE WHEN EXISTS (SELECT 1 FROM DBA_TAB_PRIVS p
                            WHERE p.OWNER='SCM_MGR' AND p.GRANTEE='SCMD_APP'
                              AND p.PRIVILEGE='EXECUTE'
                              AND p.TABLE_NAME = SUBSTR(a.API_URL, INSTR(a.API_URL, '.', -1) + 1)
                          ) THEN 'Y' ELSE 'N' END has_grant
    FROM SCM_ADM_MNU_BTN_MPG_M b
    JOIN SCM_ADM_API_M a ON b.API_ID = a.API_ID
   WHERE b.MNU_ID = '{MENU_ID}'
) WHERE has_grant = 'N';   -- 결과 0 rows 이어야 통과
```

### 5.2 SCMD_APP 로 직접 호출 시도 (가장 정확)

```sql
-- SCMD_APP 로 접속 후
DECLARE c1 SYS_REFCURSOR; c2 SYS_REFCURSOR;
BEGIN P_{NEW_SP}('', c1, c2); END;
/
-- PLS-00201 → GRANT 누락
-- 정상 PRINT → 통과
```

---

## §6. anti-pattern 사고 사례

### 6.1 SYS0010 (Lookup, 2026-06-09)
- 4 SP (P_SYS0010_GET_LOOKUP_MASTER 등) 컴파일 했으나 SCMD_APP GRANT 누락
- 사내 SCM_MGR 로 동작 → 클라우드 BE (SCMD_APP) 에서 -9994

### 6.2 SYS0011 (Auth Request, 2026-06-09) — 가장 심각
- 13 SP GRANT 누락 (P_SCM0008_*, P_SYS0011_* 등 mixed prefix)
- 외부 도메인 SP (P_SCM0008_*) 호출 시 권한 부재 → 화면 진입 시 권한없음 다발

### 6.3 SYS0013 (Dynamic Query, 2026-06-09)
- 8 SP GRANT 누락 (P_SCM0005_*)
- DM_TMP_DYNAMIC_QUERY_* 신규 테이블 4 종 + GRANT 누락 (테이블 자체 사내 미존재)

### 6.4 SYS0015 (Program, 2026-06-09)
- 2 SP GRANT + SYNONYM 누락 — 우연히 다른 작업 시 추가됐을 가능성 (사내 점검 시 GRANT 적용 상태)
- SCM_ADM_PROGRAM 테이블 4 권한 누락 — 신규 테이블이라 GRANT 필요

### 6.5 SYS0014 (Group User, 2026-06-09)
- 4 SP + SYNONYM 사내 OK (16 rows 정상 반환)
- 클라우드 측은 사내 SCM_MGR 작업이 동기화 되지 않아 GRANT 누락 상태

---

## §7. 클라우드 적용 절차

```bash
# 사내 DB
sqlplus SCM_MGR/password@사내DSN @09_GRANT_SCMD_APP.sql

# 클라우드 DB (운영자 또는 DBA 통해)
sqlplus SCM_MGR/password@클라우드DSN @09_GRANT_SCMD_APP.sql
# → 사내 + 클라우드 둘 다 동기화
```

---

## §8. Cross-ref

- 룰 12_metadata_sql §15 — 클라우드 schema 차이 (메모리 `feedback_corporate_schema_8_diffs.md`)
- hook `db-corporate-apply.md` — 사내 적용 패턴
- hook `oracle-db-workflow.md` — Oracle SP/DB 통합 진입
- 메모리 `feedback_sp_truncate_gtt_grant.md` — SCMD_APP DDL 권한 부족 사고 (TRUNCATE → DELETE 대체)
- 메모리 `feedback_corporate_db_apply_pattern.md` — `docker exec sqlplus` 적용 패턴

---

## §9. 위반 시 대응

- 신규 화면 작성 시 `09_GRANT_SCMD_APP.sql` 누락 = anti-simplification 위반 (사내↔클라우드 정합 의무 누락)
- BE 응답 `-9994 "Sql Error"` 의 90% = GRANT 누락 사고
- 도구 사용 중단 (메모리 신뢰성 손상)
