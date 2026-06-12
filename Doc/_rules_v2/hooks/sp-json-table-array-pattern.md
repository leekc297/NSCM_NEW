# Hook — SAVE SP 의 JSON_TABLE array 처리 표준 ('$[*]' + cursor FOR LOOP)

> ⚠ **SAVE SP 작성·수정 시 필수 적용**
> FE `useProcMutation mutate(array)` 는 BE 가 P_DATA CLOB 으로 array JSON 그대로 전달.
> SP body 가 `JSON_TABLE(P_DATA, '$' ...)` + `SELECT INTO V_*` 패턴이면 **단일 row 만 처리** → 다중 row 저장 사고.
> entry SP 만 fix 시 HIST sub SP 가 단일 row 처리 → NULL INSERT → ORA-01400 → 전체 rollback.
> HIST sub SP 도 동시에 fix 의무.

작성: 2026-06-12 (SYS0010 4 SAVE SP 다중 row 사고 + cursor FOR LOOP fix 검증 후)
관련 룰: `_tobe/11_be_controller_service.md`, `_tobe/12_metadata_sql.md`
관련 메모리:
- `feedback_sp_json_table_array_cursor_loop.md`
- `feedback_sp_body_no_rewrite.md` — minimal change 원칙
- `feedback_asis_to_tobe_sp_no_omission.md`
- `feedback_sp_substr_zero_index_pitfall.md` — 다른 NextSCM Pilot 결함

---

## §0. 트리거

| 트리거 | 적용 시점 |
|---|---|
| 신규 SAVE SP 작성 (T08) | PRE-WRITE + PRE-SUBMIT |
| AS-IS → To-Be SP 변환 (T19) | PRE-WRITE (NextSCM Pilot 결함 검출) |
| 사용자 "다중 row 저장 안 됨" 보고 | 진단 의무 |
| SAVE SP audit / 사내 적용 (T18) | POST-WRITE |

---

## §1. 표준 패턴 — `'$[*]'` + cursor FOR LOOP

### 1.1 array path `'$[*]'` 의무

```sql
FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (...))   -- ⭐ '$[*]' = array 전체
```

⚠ `'$'` 만 사용 시 **단일 object 만 매칭** (또는 array 받으면 0 row).

### 1.2 패턴 3종 (복잡도 별 선택)

#### 패턴 1 — bulk INSERT/UPDATE (가장 깔끔, SYS0014 표준)
```sql
INSERT INTO TABLE_X (...)
SELECT V_X1, V_X2, ...
  FROM JSON_TABLE(P_DATA, '$[*]'
    COLUMNS (
      V_SHT_NM    VARCHAR2(30) PATH '$.SHT_NM',
      V_CRUD_TYPE VARCHAR2(1)  PATH '$.CRUD_TYPE',
      V_X1        VARCHAR2(...) PATH '$.X1',
      ...
    )
  )
 WHERE V_SHT_NM = '...' AND V_CRUD_TYPE = 'I';

MERGE INTO TABLE_X T USING (
  SELECT V_X1, V_X2, ... FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(...))
  WHERE V_CRUD_TYPE = 'M'
) S ON (T.PK = S.V_PK)
 WHEN MATCHED THEN UPDATE SET ...;

DELETE FROM TABLE_X
 WHERE PK IN (
   SELECT V_PK FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(...)) WHERE V_CRUD_TYPE='D'
 );
```

#### 패턴 2 — cursor FOR LOOP (minimal change, SYS0010 표준)
```sql
FOR JT IN (
  SELECT JT.X1 AS V_X1, JT.X2 AS V_X2, ...
    FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(...)) JT
) LOOP
  V_X1 := JT.V_X1;
  V_X2 := JT.V_X2;
  ...
  IF V_CRUD_TYPE = 'I' THEN INSERT INTO ... VALUES (V_*, ...);
  ELSE UPDATE ... SET ... = V_* WHERE PK = V_PK; END IF;
END LOOP;
```

#### 패턴 3 — explicit cursor + LOOP (변환 복잡 시)
```sql
DECLARE CURSOR c_data IS
  SELECT JT.X1, JT.X2, ... FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS(...)) JT;
  rec c_data%ROWTYPE;
BEGIN
  FOR rec IN c_data LOOP
    -- 같은 처리
  END LOOP;
END;
```

### 1.3 entry + HIST sub SP 동시 fix 의무

⚠ entry SP loop 진입 **전** 에 HIST sub SP 호출 (`P_xxx_SAVE_HIST(P_DATA, ...)`) 시:
- HIST sub SP 가 single-row 패턴 (`'$'`) 이면 P_DATA=array → JSON_TABLE 매칭 0 → V_PK NULL → `INSERT INTO TABLE_H ... VALUES (NULL, ...)` ORA-01400 → entry SP EXCEPTION OTHERS → ROLLBACK → 0 row 영향

**의무**: entry SP + HIST sub SP **둘 다** 같은 패턴 fix. 또는 HIST 호출을 loop 안 (single-row JSON 으로) 으로 이동.

---

## §2. ❌ 금지 패턴 — 단일 row 처리

### 2.1 path '$' + SELECT INTO
```sql
-- ❌ array 의 first object 만 매칭 (또는 0)
SELECT JT.X1, JT.X2, ... INTO V_X1, V_X2, ...
  FROM JSON_TABLE(P_DATA, '$' COLUMNS(...)) JT;
IF V_FLAG = 'I' THEN INSERT ... ELSE UPDATE ... END IF;
```

### 2.2 entry SP 만 fix + HIST sub SP 단일 row
```sql
-- entry SP cursor loop 적용 했지만 HIST 호출 위치 그대로
FOR JT IN (...) LOOP V_X := JT.X; END LOOP;
P_xxx_SAVE_HIST(P_DATA, ...);  -- ⚠ HIST sub SP가 '$' 패턴 → ORA-01400 → 전체 rollback
```

---

## §3. PRE-WRITE 자기 점검

- [ ] JSON_TABLE 의 path = `'$[*]'` (array 의무)
- [ ] SAVE 패턴 3종 중 선택 (bulk INSERT/MERGE/cursor LOOP)
- [ ] HIST sub SP 도 같은 패턴 fix
- [ ] EXCEPTION OTHERS 의 ROLLBACK + RAISE 보존
- [ ] LOG_BATCH START/END 위치 (loop 밖 권장)
- [ ] COMMIT 위치 (loop 밖, 1번)

---

## §4. POST-WRITE 자동 검증

### 4.1 변경된 SP 컴파일 + STATUS
```sql
SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OBJECT_NAME = 'PKG_{...}' AND OWNER = 'SCM_MGR';
-- 기대: VALID

SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_{...}' AND TYPE = 'PACKAGE BODY';
-- 기대: 0 rows
```

### 4.2 다중 row 직접 호출 검증 (의무)
```python
# Python ora.py 사용
import oracledb, json
data = json.dumps([
  {'CRUD_TYPE':'M', 'PK':'val1', ...},
  {'CRUD_TYPE':'M', 'PK':'val2', ...},
])
oc = cur.var(oracledb.DB_TYPE_CURSOR)
cur.callproc('SCM_MGR.PKG_X.P_X_SAVE', [data, 'tester', oc])
rc = oc.getvalue()
print(rc.fetchall())  # 기대: [('0', 'SUCCESS', '2')] — EVENT=2 row 처리

cur.execute("SELECT COUNT(*) FROM TABLE_X WHERE PK IN ('val1','val2')")
print(cur.fetchone())  # 기대: (2,)
```

### 4.3 전 시스템 audit (단일 row 패턴 검출)
```sql
SELECT NAME, TYPE, LINE, TEXT
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR'
   AND TYPE IN ('PACKAGE BODY', 'PROCEDURE')
   AND REGEXP_LIKE(TEXT, 'JSON_TABLE\s*\(\s*\w+\s*,\s*''\$''[^[]', 'i')
 ORDER BY NAME, LINE;
-- 기대: 0 rows (또는 GET 용 single object 처리는 OK — SAVE 만 fix 필요)
```

---

## §5. 진단 절차 (다중 row 저장 안 됨)

1. **BE log 의 SP 호출 P_DATA 확인** — `'[{...},{...}]'` array 인지
   ```bash
   tail -10000 nscm-be/logs/start-all_be.out | grep -E "P_XXX_SAVE"
   ```

2. **SP body grep** — 단일 row 패턴 검출
   ```bash
   grep -nE "JSON_TABLE.*'\\\$'[^[]|SELECT.*INTO.*V_" deploy/PKG_BODY.sql
   ```

3. **SP 직접 호출 테스트** — array 2 row 호출 → ORA-01400 / cursor 결과 확인
   ```python
   cur.callproc('SCM_MGR.PKG_X.P_X_SAVE', [json.dumps([row1, row2]), 'tester', oc])
   ```

4. **HIST sub SP 위치 확인** — entry SP loop 진입 전 호출이면 같이 fix 필요

5. **EXCEPTION OTHERS 메시지 확인** — `ORA-01400` 발견 시 HIST sub SP 단일 row 패턴 사고 확정

---

## §6. anti-pattern 사고 사례

### 6.1 (실제) SYS0010 4 SP 단일 row 패턴 (2026-06-12)
- AS-IS 1:1 변환 자동도구 (NextSCM Pilot) 4 SAVE SP 모두 `'$'` + `SELECT INTO V_*` 패턴
- 사용자 보고: "2 row 수정 시 첫 row 만 저장"
- 진단: SP 직접 호출 → cursor `(0, SUCCESS, 1)` (1 row 만 처리) — 또는 HIST 호출에서 `ORA-01400 LOOKUP_TYPE NULL`
- fix: 4 SP 모두 cursor FOR LOOP (`'$[*]'`) 적용 → 검증 후 `(0, SUCCESS, 2)` 정상
- 참조: `_artifacts/_apply_corporate/53_sys0010_save_sp_cursor_loop_fix.sql`

### 6.2 (실제) entry SP 만 fix + HIST 그대로 (SYS0010 중간 상태, 2026-06-12)
- entry SP cursor loop 적용 후에도 `ORA-01400`
- 원인: entry SP loop 진입 전 HIST 호출 (single-row 패턴 HIST 가 array 받음 → V_LOOKUP_TYPE NULL → INSERT 시 ORA-01400)
- fix: HIST sub SP 도 같이 cursor loop 적용

### 6.3 (가능성) AS-IS 1:1 변환 자동도구 광범위 결함
- NextSCM Pilot 다른 결함 family: `feedback_sp_substr_zero_index_pitfall` (SUBSTR pos=0) / `feedback_sp_truncate_gtt_grant` (TRUNCATE GTT)
- 신규 변환 SP 작성 시 §4.3 audit SQL 의무 실행

---

## §7. Cross-ref

### 룰 v2
- `_tobe/11_be_controller_service.md §3.1` — dual cursor
- `_tobe/12_metadata_sql.md §2.4.1` — PROC_M cursor 표준

### Hook
- `oracle-db-workflow.md` — Oracle SP/DB 통합 진입
- `sp-body-minimal-change.md` — minimal change 원칙
- `sp-no-fake-data-extraction.md` — 가짜 구현 금지
- `sp-substr-zero-index-audit.md` — 다른 NextSCM Pilot 결함

### 메모리
- `feedback_sp_json_table_array_cursor_loop.md` (이 hook 짝)
- `feedback_asis_to_tobe_sp_no_omission.md`
- `feedback_sp_body_no_rewrite.md`
- `feedback_sp_substr_zero_index_pitfall.md`
- `feedback_save_sp_bulk_payload_apiclient_post.md`

---

## §8. 위반 시 대응

- 신규/수정 SAVE SP 의 `'$'` 패턴 사용 = PR 머지 차단
- entry + HIST sub SP 동시 fix 누락 = 검증 fail
- §4.2 직접 호출 검증 누락 = 사용자 검증 단계 사고 위험
- anti-simplification 위반 (자동 변환 도구 1회 통과 채택) = 도구 사용 중단
