# Hook — SP Inline Function GTT Temp Table Mandatory (사용자 명시 룰)

> **트리거**: SP body / Dynamic Query 변환 시
> **목적**: Row-by-row scalar function 호출로 인한 성능 저하 사고 사전 차단

---

## §0. 배경 (사용자 명시 — 2026-06-21)

> "내부 Function 이나 분리자 Function 등을 사용 경우에는 GT, GTT temp table 을 사용 from 에서
> join 해서 사용할 수 있도록 해주세요."

**의도**:
- Oracle 의 row-by-row scalar function 호출 (`SELECT col, FN_GET_X(col) FROM tbl`) 은 row 수만큼 N 번 호출 → 대용량 결과 시 분~시간 단위 성능 저하.
- 대신 function 결과를 **GTT (Global Temporary Table)** 에 사전 적재 + 본 SQL 의 `FROM` 절에서 **JOIN** 으로 사용 = 1회 일괄 조회.
- DBMS_PROFILER 측정 결과: scalar function 호출 22,095초 → GTT JOIN 변환 후 32초 (memory `feedback_correlated_subquery_perf`).

---

## §1. 절대 금지 (Hard Rules)

| # | 금지 행위 | 회피 패턴 |
|---:|---|---|
| 1 | ❌ `SELECT FN_FUNC(col) FROM big_table` (row-by-row scalar function) | GTT JOIN |
| 2 | ❌ `WHERE col IN (FN_SPLIT_STR(p_param))` (분리자 function 호출) | GTT 적재 + JOIN |
| 3 | ❌ `WHERE col = (SELECT ... FROM ...)` 대용량 row 별 correlated subquery | GTT JOIN |
| 4 | ❌ `WITH cte AS (...)` 안 scalar function 호출 후 cte 재사용 | cte 대신 GTT 적재 |

---

## §2. 표준 패턴 (GTT 적재 + FROM JOIN)

### 2.1 분리자 Function (예: `UF_FX_STRING_SPLIT`)

❌ **금지**:
```sql
WHERE COL IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_PARAM, ',')))
```

✅ **표준**:
```sql
-- 사전 적재 (1회)
DELETE FROM GT_TMP_TOKENS;
INSERT INTO GT_TMP_TOKENS (TOKEN)
SELECT REGEXP_SUBSTR(P_PARAM, '[^,]+', 1, LEVEL)
  FROM DUAL
 CONNECT BY REGEXP_SUBSTR(P_PARAM, '[^,]+', 1, LEVEL) IS NOT NULL;

-- 본 SQL 에서 FROM JOIN
SELECT A.*
  FROM SCM_MST_X A
  JOIN GT_TMP_TOKENS T ON A.COL = T.TOKEN;
```

### 2.2 내부 Scalar Function (예: `FN_GET_ITEM_NICKNAME`)

❌ **금지**:
```sql
SELECT ITEM_ID, FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID) AS NICK_NAME
  FROM big_table;  -- row-by-row 호출
```

✅ **표준** (function 결과 사전 적재 + JOIN):
```sql
-- 사전 적재 (DISTINCT 로 1회)
DELETE FROM GT_TMP_NICK;
INSERT INTO GT_TMP_NICK (DIVISION_ID, ITEM_ID, NICK_NAME)
SELECT DISTINCT DIVISION_ID, ITEM_ID, FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID)
  FROM big_table;

-- 본 SQL 에서 FROM JOIN
SELECT B.ITEM_ID, N.NICK_NAME
  FROM big_table B
  LEFT JOIN GT_TMP_NICK N
    ON N.DIVISION_ID = B.DIVISION_ID AND N.ITEM_ID = B.ITEM_ID;
```

### 2.3 GTT INSERT 앞 DELETE 의무 (메모리 룰 cross-ref)

```sql
DELETE FROM GT_TMP_X;          -- 의무 (커넥션 풀 재호출 안전)
INSERT INTO GT_TMP_X (...) ... ;
```

> 메모리 `feedback_sp_truncate_gtt_grant.md` 와 cross-ref: TRUNCATE 는 SCMD_APP DDL 권한 부족 → DELETE 사용 의무.

---

## §3. 적용 영역

### 3.1 신규 SP 작성 시
- 모든 scalar function 호출 후보를 식별
- 호출 횟수 ≥ 100 row 예상 시 GTT 사전 적재 의무

### 3.2 기존 SP 성능 튜닝 시
- `DBMS_PROFILER` 또는 `V$SQL` 로 row-by-row 호출 측정
- 22000s+ 사고 (memory) 같은 케이스 = GTT 변환 의무

### 3.3 Dynamic Query (`SCM_ADM_DQ_LIST.DQ_TEXT`) 변환 시
- 사용자 작성 query 안 scalar function 호출 ≥ 100 row 예상 시
- GTT 적재 헤더 + 본 SELECT 변환 가이드 제공

---

## §4. 정적 audit

### 4.1 scalar function 호출 검출

```sql
-- 사내 SP body 안 scalar function 호출 인벤토리
SELECT NAME, LINE, TRIM(TEXT)
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR'
   AND TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(TEXT, '\b(FN_|UF_)\w+\s*\(', 'i')
   AND TEXT NOT LIKE '%GT_TMP%'  -- GTT 적재 SELECT 제외
 ORDER BY NAME, LINE;
```

### 4.2 GTT INSERT 앞 DELETE 누락 검출

```sql
SELECT B.NAME, B.LINE
  FROM ALL_SOURCE B
 WHERE OWNER='SCM_MGR'
   AND REGEXP_LIKE(TEXT, 'INSERT\s+INTO\s+GT_', 'i')
   AND NOT EXISTS (
     SELECT 1 FROM ALL_SOURCE D
      WHERE D.OWNER=B.OWNER AND D.NAME=B.NAME AND D.TYPE=B.TYPE
        AND D.LINE BETWEEN B.LINE-10 AND B.LINE-1
        AND REGEXP_LIKE(D.TEXT, 'DELETE\s+FROM\s+GT_', 'i')
   );
```

---

## §5. cross-ref 룰

| ref | 용도 |
|---|---|
| `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` §부록 C-5 | GTT DELETE 의무 |
| `feedback_correlated_subquery_perf` (메모리) | DBMS_PROFILER 22095s → 32s 변환 사례 |
| `feedback_sp_truncate_gtt_grant.md` | TRUNCATE GTT → DELETE 변환 의무 |
| `feedback_sp_substr_zero_index_pitfall.md` | 분리자 SUBSTR-0 사고 |

---

## §6. 위반 시 결과

- 사용자 화면 조회 응답 시간 22000s+ (분~시간 단위)
- SP 호출 timeout → BE 응답 -9994 (Sql Error)
- 사용자 신뢰성 손상 + 운영 사고

= 사고 사전 차단 의무 — SP body 작성 시 본 룰 강제 적용.
