# Hook — Oracle SP 변환 성능 안티패턴 (MSSQL → Oracle)

> ⚠ **반드시 지켜야 할 룰 — MSSQL 에서 OK 였던 패턴이 Oracle 에서 급격한 속도저하 유발.**
> SP/View/Function 변환 작업 + Oracle SQL 직접 작성 시 의무 적용.

작성: 2026-06-16 (사용자 명시 요구 — DMF0003 GT_GGET_SITE_ITEM_ALL INSERT 22,095초 사고 후)
상위 룰: `anti-simplification.md`
관련 룰: `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` / `02_SP_CONVERSION_PIPELINE.md`
상위 hook: `oracle-db-workflow.md`

---

## §0. 사용자 명시 (2026-06-16)

> "MSSQL 에서는 사용해두 문제가 없던 문장이 ORACLE에서는 급격한 속도저하가 발생할 수 도 있습니다.
> 이부분에 대해서 반드시 지켜야할 RULE로 설정해서 MD, HOOK 파일 보완 요청 합니다."

**근거 사고:** DMF0003 메인 grid `INSERT INTO GT_GGET_SITE_ITEM_ALL` (SP body line 959-1057):
- LISTAGG correlated subquery (SELECT column 안 `F.OWNER` 참조 + REGEXP_SUBSTR + CONNECT BY) → 50K row × hierarchical query = slow-by-slow
- 분리자 (`,`) split → INNER JOIN `(SELECT REGEXP_SUBSTR ... CONNECT BY ...)` LIKE 패턴 → cartesian-product 폭발
- 총 elapsed time **22,095초** (~368분 누적, 17회 호출 평균 21.7분) — 99% bottleneck

→ MSSQL `STRING_SPLIT` / `STRING_AGG` / `CROSS APPLY` 는 옵티마이저가 set-based 처리. Oracle `REGEXP_SUBSTR + CONNECT BY` 는 동일 패턴이지만 옵티마이저가 row-by-row 처리 + 인덱스 활용 어려움 → 성능 급락.

---

## §1. 트리거 (작업 키워드 자동 적용)

| 트리거 | 적용 시점 | 적용 룰 |
|---|---|---|
| AS-IS MSSQL SP/View → Oracle 변환 (T08 / T18 / T19) | PRE-WRITE + WRITE + POST-WRITE 의무 | 1~5 전체 |
| Oracle SP / Function / View 신규 작성 | PRE-WRITE + POST-WRITE | 1~5 전체 |
| `REGEXP_SUBSTR` 사용 작성 시 | POST-WRITE grep 의무 | 1 + 2 |
| `CONNECT BY` 사용 작성 시 | POST-WRITE grep 의무 | 1 + 2 |
| `LISTAGG` 사용 작성 시 | POST-WRITE grep 의무 | 1 |
| `LIKE '%'` 패턴 사용 | POST-WRITE grep 의무 | 2 + 5 |
| `CREATE GLOBAL TEMPORARY TABLE` | PRE-WRITE 의무 | 4 |
| MASTER 명칭 lookup (`SELECT X FROM Y WHERE`) column 내부 | POST-WRITE grep 의무 | 3 |
| WHERE / ON 조건의 함수 (`NVL/TRIM/UPPER/SUBSTR/TO_CHAR`) 컬럼 적용 | POST-WRITE grep 의무 | 5 |
| 매개변수 'ALL' / '%' / NULL / '' 가능성 (FE store default) | PRE-WRITE 매핑 의무 | 6 |
| GT INSERT + 매개변수 splittable | INSERT WHERE skip 조건 추가 의무 | 6 |
| SP 호출 elapsed > 5 sec 발견 | 본 hook 1차 검토 | 1~6 모두 |

⚠ 본 hook 은 다른 트리거에 **우선**. SP 작성 시 본 hook 통과 후 후속 작업.

---

## §2. 룰 1 — Correlated Subquery 의 REGEXP_SUBSTR / CONNECT BY → FROM 절로 이동

### 2.1 절대 금지 패턴 (Before)

**SELECT column 안에 hierarchical query 가 들어가고, outer row 의 컬럼을 참조:**

```sql
-- ❌ 금지 — F.OWNER 참조 correlated subquery + CONNECT BY
SELECT F.DIVISION_ID, F.PROJECT_CODE
     , ( SELECT LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
         FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
         WHERE  ZA.USER_ID IN (
             SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))    -- ⚠ outer F.OWNER 참조
             FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
         )
       ) AS OWNER_NAME
FROM   SCM_MGR.SCM_MST_SITE_ITEM F
...
```

**문제점:**
- Oracle 옵티마이저가 **outer row 마다** hierarchical CONNECT BY query 실행 → row-by-row (50K row 시 50K 회 호출)
- 옵티마이저가 view merge / unnesting 불가 (correlated + CONNECT BY 결합)
- DBMS_PROFILER 측정 시 해당 column 의 LISTAGG 가 가장 비싼 operation 으로 식별

### 2.2 권장 패턴 (After)

**FROM 절 inline view 또는 WITH clause 으로 분리 + 사전 집계 + LEFT JOIN:**

```sql
-- ✅ 권장 — FROM 절 inline view 사전 집계
SELECT F.DIVISION_ID, F.PROJECT_CODE
     , OW.OWNER_NAME     -- ⭐ FROM 절 OW inline view 의 column 참조
FROM   SCM_MGR.SCM_MST_SITE_ITEM F
LEFT   JOIN (
    SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
         , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
    FROM (
        SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
             , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
        FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
        CROSS  JOIN ( SELECT LEVEL AS LV
                      FROM DUAL CONNECT BY LEVEL <= 30 ) HIER   -- 안전 한도 token 30
        WHERE  FF.DIVISION_ID = P_DIVISION_ID                    -- 사전 필터 의무
          AND  FF.OWNER IS NOT NULL
          AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
    ) OT
    JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
    GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
) OW
  ON   F.DIVISION_ID  = OW.DIVISION_ID
 AND   F.PROJECT_CODE = OW.PROJECT_CODE
 AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
 AND   F.ITEM_ID      = OW.ITEM_ID
...
```

**효과:**
- 옵티마이저가 set-based 처리 (1회 GROUP BY) → row-by-row 제거
- CROSS JOIN hierarchical generator (DUAL CONNECT BY LEVEL) 으로 token 미리 전개
- LEFT JOIN 으로 OWNER NULL row 보존 (의미 1:1 보존)
- PK 4 컬럼 매핑으로 정확한 row 매핑

### 2.3 분리 변환 절차 (의무 5 단계)

```
Step 1: SELECT column 의 subquery 식별
   grep -nE "REGEXP_SUBSTR\b|CONNECT BY" {SP_BODY} | grep -B 2 "SELECT.*FROM"

Step 2: outer 컬럼 참조 확인 (correlated 여부)
   subquery 안에 outer alias (예: F.OWNER, A.PROJECT_CODE) 가 있으면 correlated.

Step 3: outer 의 PK / unique key 식별 → JOIN key 결정

Step 4: inline view 작성
   - subquery 안 hierarchical CONNECT BY → CROSS JOIN LEVEL hierarchical generator
   - LISTAGG 등 aggregate → GROUP BY outer PK
   - 사전 필터 (P_DIVISION_ID 같은 매개변수) 적용 의무

Step 5: SELECT column → inline view alias 참조 (예: OW.OWNER_NAME)
```

### 2.4 PRE-WRITE 자기 점검

- [ ] SELECT column 안 subquery 중 `REGEXP_SUBSTR` 또는 `CONNECT BY` 포함?
- [ ] 그 subquery 가 outer table 의 컬럼 참조 (correlated)?
- [ ] 사전 집계 가능한가 (outer PK 으로 GROUP BY)?
- [ ] CROSS JOIN LEVEL 안전 한도 (token max 수) 검증?
- [ ] LEFT JOIN 으로 NULL row 보존?

### 2.5 POST-WRITE grep

```bash
# 1) SELECT column 안 REGEXP_SUBSTR + CONNECT BY 결합 검출 (Top 위험)
grep -nE "SELECT.*FROM.*REGEXP_SUBSTR" {SP_BODY} | grep -i "CONNECT BY"

# 2) Correlated subquery 의심 — column 안 outer alias 참조
grep -B 5 "CONNECT BY REGEXP_SUBSTR" {SP_BODY} | grep -E "F\.|A\.|T1\.|T2\."

# 3) LISTAGG inline correlated 패턴
grep -nE "LISTAGG.*WITHIN GROUP" {SP_BODY} -A 5 | grep -E "REGEXP_SUBSTR.*F\.|REGEXP_SUBSTR.*A\."
```

---

## §3. 룰 2 — 분리자 split JOIN → 사전 TEMP TABLE (GT/GTT) 적재 + JOIN

### 3.1 절대 금지 패턴 (Before)

**SELECT 안 inline split + INNER JOIN (또는 LEFT JOIN) 으로 사용:**

```sql
-- ❌ 금지 — 매번 split + LIKE JOIN cartesian-product
SELECT F.*
FROM   SCM_MGR.SCM_MST_SITE_ITEM F
JOIN (
    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
    FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
JOIN (
    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
    FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
) C ON (F.PROJECT_CODE LIKE C.TST OR T3.PROJECT_NAME LIKE C.TST)
...
```

**문제점:**
- Leading wildcard `LIKE '%' || token || '%'` → B-tree 인덱스 영원히 사용 불가
- INNER JOIN 형태 → 옵티마이저 cost 추정 오류 (사실상 WHERE 절)
- OR 조건 → hash join 강제 + full scan
- DISTINCT 안 LIKE 매트릭스 → 추가 sort 비용
- 매번 호출마다 split 재실행 → CPU 낭비

### 3.2 권장 패턴 (After)

**사전 TEMP TABLE (GT — Global Temporary Table 또는 GTT — Global Temp Table) 에 split 결과 적재 + SELECT 에서 JOIN 만 사용:**

```sql
-- ✅ 권장 — 사전 TEMP TABLE 적재
-- Step 1: 기존 GTT 존재 확인 + 없으면 신규 생성 (DDL 일회성)
--   GT 이름 표준: GT_GGET_SPLIT_{변수명} 또는 GT_GGET_FILTER_{변수명}
--   세션 종료 시 자동 정리 (ON COMMIT PRESERVE ROWS, SYS$SESSION)

-- 사전 적재 (SP body 안에서 호출 시점):
DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) AS TOK
FROM DUAL
WHERE P_ITEM_ID NOT IN ('ALL', '%')
  AND P_ITEM_ID IS NOT NULL
  AND P_ITEM_ID <> ''
CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

-- 사용 위치 (SELECT 절):
SELECT F.*
FROM   SCM_MGR.SCM_MST_SITE_ITEM F
JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2 ON F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
WHERE  ( P_ITEM_ID IN ('ALL', '%')
         OR EXISTS (
              SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
              WHERE F.ITEM_ID LIKE '%' || B.TOK || '%'
                 OR T2.NICK_NAME LIKE '%' || B.TOK || '%'
         ) )
...
```

**효과:**
- split 1회만 실행 (INSERT 시점) → SELECT 내 매번 split 제거
- TEMP TABLE 의 인덱스 활용 가능 (필요 시 추가)
- 옵티마이저가 set-based 처리 + cost 추정 정확
- 'ALL' / '%' 분기로 0 row drop 회피
- INNER JOIN cartesian 회피 → EXISTS 또는 LEFT JOIN

### 3.3 GT (Global Temporary Table) 표준 명명 + DDL

**명명 규약** — `GT_GGET_SPLIT_{소스 변수명 UPPER_SNAKE}`:

| 소스 변수 | GT 이름 |
|---|---|
| `P_ITEM_ID` | `GT_GGET_SPLIT_ITEM_ID` |
| `P_PROJECT_CODE` | `GT_GGET_SPLIT_PROJECT_CODE` |
| `P_OWNER` | `GT_GGET_SPLIT_OWNER` |
| `P_CUSTOMER` | `GT_GGET_SPLIT_CUSTOMER` |
| `P_BIZ_TYPE` | `GT_GGET_SPLIT_BIZ_TYPE` |

**기존 GT 사용 vs 신규 생성 결정 흐름**:

```
1. all_tables WHERE OWNER='SCM_MGR' AND TABLE_NAME='GT_GGET_SPLIT_{X}' 검색
2. 존재 → 컬럼 (TOK + 필요 시 SORT_ORDER_NO/PARAM_NAME) 일치 확인
3. 일치 → 그대로 재사용
4. 불일치 → 별도 신규 GT 명 (GT_GGET_SPLIT_{X}_V2) 또는 ALTER (DDL 변경 위험 → 사용자 승인)
5. 미존재 → 신규 CREATE
```

**표준 DDL** (신규 생성 시):

```sql
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_GGET_SPLIT_ITEM_ID (
    TOK             VARCHAR2(400 CHAR) NOT NULL,
    SORT_ORDER_NO   NUMBER DEFAULT 1   NOT NULL
) ON COMMIT PRESERVE ROWS;

-- 권한 부여 (SCMD_APP 사용계정)
GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.GT_GGET_SPLIT_ITEM_ID TO SCMD_APP;
CREATE OR REPLACE SYNONYM SCMD_APP.GT_GGET_SPLIT_ITEM_ID FOR SCM_MGR.GT_GGET_SPLIT_ITEM_ID;

-- 인덱스 (TOK 빠른 lookup 시)
CREATE INDEX SCM_MGR.IDX01_GT_GGET_SPLIT_ITEM_ID ON SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK);
```

**ON COMMIT 동작**:
- `ON COMMIT PRESERVE ROWS` (SYS$SESSION) — session 유지 (기본 권장)
- `ON COMMIT DELETE ROWS` (SYS$TRANSACTION) — commit 후 자동 비움 (사용 시 SP body 내 COMMIT 위치 신중 검토 의무)

### 3.4 변환 절차 (의무 6 단계)

```
Step 1: inline split JOIN 패턴 식별
   grep -nE "JOIN \(.*REGEXP_SUBSTR.*CONNECT BY" {SP_BODY}

Step 2: 소스 매개변수 (P_X / LP_X) 식별
   매개변수 별 GT_GGET_SPLIT_{X} 이름 결정

Step 3: 기존 GT 존재 확인
   SELECT table_name FROM all_tables WHERE owner='SCM_MGR' AND table_name LIKE 'GT_GGET_SPLIT_%';
   존재 → 컬럼 정합성 검증 → 재사용 결정
   미존재 → §3.3 표준 DDL 생성

Step 4: SP body 안 적재 SQL 작성
   - DELETE GT (멱등)
   - INSERT GT FROM hierarchical split
   - 'ALL'/'%' 시 INSERT skip (성능 + 정합성)

Step 5: SELECT 안 JOIN → EXISTS 또는 LEFT JOIN 으로 변경
   - 'ALL'/'%' 시 short-circuit OR 조건

Step 6: 검증 — 적재 row 수 측정 + 메인 SELECT row count 비교 (변환 전후 동일)
```

### 3.5 PRE-WRITE 자기 점검

- [ ] inline split JOIN 안에 `REGEXP_SUBSTR` 또는 `CONNECT BY` 포함?
- [ ] 매개변수 별 GT 이름 결정 (`GT_GGET_SPLIT_{X}` 표준)?
- [ ] 기존 GT 인벤토리 확인 (all_tables grep)?
- [ ] 기존 GT 재사용 가능 vs 신규 생성 결정?
- [ ] 'ALL' / '%' / NULL / '' 4 패턴 모두 분기 처리?
- [ ] EXISTS 또는 LEFT JOIN 으로 cartesian-product 회피?
- [ ] 변환 전후 row count 동일성 검증 SQL 작성?

### 3.6 POST-WRITE grep

```bash
# 1) inline split JOIN 잔존 검출 (변환 미완료)
grep -nE "JOIN \(" {SP_BODY} -A 3 | grep -E "REGEXP_SUBSTR.*CONNECT BY"

# 2) GT_GGET_SPLIT_ 사용 확인 (변환 완료 신호)
grep -nE "GT_GGET_SPLIT_" {SP_BODY}

# 3) 'ALL' / '%' 분기 누락 검출
grep -B 1 -A 5 "EXISTS.*GT_GGET_SPLIT_" {SP_BODY} | grep -E "P_\w+ IN \('ALL'|P_\w+ = 'ALL'|P_\w+ IS NULL"
```

---

## §3.5. 룰 3 — MASTER 명칭 lookup → FROM 절 TABLE/SUB QUERY 으로 분리

### 3.5.1 절대 금지 패턴 (Before)

**SELECT column 안 MASTER 명칭 lookup (1:N row 마다 single SELECT 호출):**

```sql
-- ❌ 금지 — column 마다 MASTER 명칭 lookup correlated subquery
SELECT A.PROJECT_CODE
     , ( SELECT B.PROJECT_NAME
         FROM   SCM_MGR.SCM_MST_PROJECT B
         WHERE  B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE ) AS PROJECT_NAME
     , ( SELECT C.SITE_NAME
         FROM   SCM_MGR.SCM_MST_SITE C
         WHERE  C.DIVISION_ID = A.DIVISION_ID AND C.SCM_SITE_ID = A.SCM_SITE_ID ) AS SITE_NAME
     , ( SELECT D.ITEM_NAME
         FROM   SCM_MGR.SCM_MST_ITEM_SN D
         WHERE  D.DIVISION_ID = A.DIVISION_ID AND D.ITEM_ID = A.ITEM_ID ) AS ITEM_NAME
     , ( SELECT E.NAME FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL E
         WHERE E.LOOKUP_TYPE = 'CELL_TYPE' AND E.SEGMENT1 = A.CELL_TYPE ) AS CELL_TYPE_NAME
FROM   SCM_MGR.DM_PLN_MKT_FCST A
WHERE  ...
```

**문제점:**
- 매 row 마다 (50K row × 4 lookup = 200K) MASTER SELECT 호출 → row-by-row
- 옵티마이저가 view merge / unnesting 어려움 (correlated)
- MASTER index 사용 가능하지만 매번 single-row lookup → buffer cache hit 빈도 낮음
- 코드 가독성 ↓ + 유지보수 어려움

### 3.5.2 권장 패턴 (After) — FROM 절 LEFT JOIN

```sql
-- ✅ 권장 — FROM 절 LEFT JOIN 으로 set-based 처리
SELECT A.PROJECT_CODE
     , B.PROJECT_NAME
     , C.SITE_NAME
     , D.ITEM_NAME
     , LOOK.NAME AS CELL_TYPE_NAME
FROM   SCM_MGR.DM_PLN_MKT_FCST A
LEFT   JOIN SCM_MGR.SCM_MST_PROJECT B
  ON   B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE
LEFT   JOIN SCM_MGR.SCM_MST_SITE C
  ON   C.DIVISION_ID = A.DIVISION_ID AND C.SCM_SITE_ID = A.SCM_SITE_ID
LEFT   JOIN SCM_MGR.SCM_MST_ITEM_SN D
  ON   D.DIVISION_ID = A.DIVISION_ID AND D.ITEM_ID = A.ITEM_ID
-- LOOKUP_MASTER_DETAIL 같은 다중 LOOKUP_TYPE 가진 마스터는 사전 inline view 권장
LEFT   JOIN ( SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
              FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
              WHERE  LOOKUP_TYPE = 'CELL_TYPE' ) LOOK
  ON   LOOK.CODE = A.CELL_TYPE
WHERE  ...
```

**효과:**
- 옵티마이저가 hash join 또는 nested loop 의 set-based 처리
- MASTER 측 PK / unique index 활용 최대화
- 코드 가독성 + 유지보수 향상
- LEFT JOIN 으로 MASTER 미매치 row 도 보존 (정합)

### 3.5.3 변환 절차 (의무 4 단계)

```
Step 1: SELECT column 안 single-table SELECT subquery 식별
   grep -nE "SELECT\s+\w+\.\w+\s+FROM\s+\w+\.\w+\s+WHERE" {SP_BODY}

Step 2: outer alias 참조 확인 (correlated 여부)

Step 3: outer table 의 JOIN 가능 key 식별

Step 4: SELECT subquery → FROM 절 LEFT JOIN 으로 이동
   - WHERE 조건 → ON 절로
   - 결과 column → SELECT 의 alias 참조
```

### 3.5.4 PRE-WRITE 자기 점검

- [ ] SELECT column 안 `SELECT X FROM Y WHERE` 패턴 (1줄 lookup) 존재?
- [ ] outer alias 참조 (correlated)?
- [ ] FROM 절로 이동 시 LEFT JOIN 으로 NULL row 보존?
- [ ] WHERE 조건 → ON 절로 변환?
- [ ] 다중 row 가능성 시 OUTER APPLY 또는 GROUP BY 처리?

### 3.5.5 POST-WRITE grep

```bash
# SELECT column 안 single-table subquery 검출
grep -nE ",\s*\(\s*SELECT\s+\w+\.?\w*\s+FROM\s+SCM_MGR\." {SP_BODY}
```

---

## §3.6. 룰 4 — TEMP TABLE (GT/GTT) MAIN KEY COLUMN INDEX 의무

### 3.6.1 절대 금지 패턴 (Before)

**GT 사용하지만 INDEX 0건 → JOIN 시 full scan:**

```sql
-- ❌ 금지 — GT 에 INDEX 부재로 매번 full scan
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_GGET_SPLIT_ITEM_ID (
    TOK VARCHAR2(400 CHAR) NOT NULL
) ON COMMIT PRESERVE ROWS;

-- 사용 시
SELECT F.* FROM SCM_MGR.SCM_MST_SITE_ITEM F
JOIN SCM_MGR.GT_GGET_SPLIT_ITEM_ID B ON F.ITEM_ID LIKE '%' || B.TOK || '%'   -- ⚠ B 측 full scan
```

**문제점:**
- GT 의 row 수가 작아도 매번 full scan → buffer logical reads 누적
- 옵티마이저가 hash join 강제 (NL join 가능했더라도)
- GT 의 통계 (gather_table_stats) 부재 → 옵티마이저 cost 잘못 추정

### 3.6.2 권장 패턴 (After)

**GT 의 MAIN KEY COLUMN 에 INDEX 추가 + 통계 갱신:**

```sql
-- ✅ 권장 — GT 의 lookup key 컬럼에 INDEX 추가
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_GGET_SPLIT_ITEM_ID (
    TOK             VARCHAR2(400 CHAR) NOT NULL,
    SORT_ORDER_NO   NUMBER DEFAULT 1 NOT NULL
) ON COMMIT PRESERVE ROWS;

-- 룰 4: MAIN KEY (조회/JOIN 사용) 컬럼 INDEX 의무
CREATE INDEX SCM_MGR.IDX01_GT_GGET_SPLIT_ITEM_ID ON SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK);

-- 다중 컬럼 GT 의 composite index (JOIN/WHERE 순서 따라)
CREATE INDEX SCM_MGR.IDX02_GT_GGET_FILTER_ITEM ON SCM_MGR.GT_GGET_FILTER_ITEM (DIVISION_ID, ITEM_ID);

-- 통계 (선택 — 19c+ 는 자동 dynamic sampling)
BEGIN
  DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', 'GT_GGET_SPLIT_ITEM_ID',
                              'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
END;
/
```

### 3.6.3 INDEX 결정 표

| GT 사용 패턴 | INDEX 권장 |
|---|---|
| Single token lookup (`WHERE TOK = ?`) | `(TOK)` single col |
| JOIN ON (`b.TOK = outer.X`) | `(TOK)` single col |
| LIKE prefix (`TOK LIKE 'abc%'`) | `(TOK)` single col + function-based 필요 시 |
| Composite key (`DIV + ITEM_ID`) | `(DIV, ITEM_ID)` composite leading order |
| Range scan (`WHERE TOK BETWEEN ? AND ?`) | `(TOK)` single col |

### 3.6.4 PRE-WRITE 자기 점검

- [ ] GT 의 MAIN KEY (조회/JOIN 사용) 컬럼 식별?
- [ ] 해당 컬럼에 `CREATE INDEX` 작성?
- [ ] composite key 시 leading column 순서 (옵티마이저 cost 영향) 결정?
- [ ] 19c+ 환경에서 GLOBAL_TEMP_TABLE_STATS = 'SESSION' 설정?

### 3.6.5 POST-WRITE grep + 검증 SQL

```bash
# 1) GT 생성 SQL 옆에 INDEX 부재 검출
grep -nE "CREATE GLOBAL TEMPORARY TABLE" {SQL_FILE} -A 10 | grep -L "CREATE INDEX"

# 2) 사내 사후 검증
```

```sql
SELECT t.table_name,
       (SELECT COUNT(*) FROM all_indexes i
         WHERE i.table_owner=t.owner AND i.table_name=t.table_name) AS idx_cnt
  FROM all_tables t
 WHERE t.owner='SCM_MGR' AND t.table_name LIKE 'GT_GGET_%'
 ORDER BY idx_cnt, t.table_name;
-- idx_cnt = 0 인 GT 는 룰 4 위반
```

---

## §3.7. 룰 5 — WHERE 조건의 함수/문자 조합으로 INDEX 미수행 → SARGable 변환

### 3.7.1 절대 금지 패턴 (Before)

**WHERE / ON / JOIN 조건의 컬럼에 함수 적용 또는 문자열 조합 → INDEX 사용 불가:**

```sql
-- ❌ 금지 #1 — NVL 함수로 인덱스 미사용
WHERE NVL(A.STATUS, '') = 'OK'
-- ❌ 금지 #2 — TRIM 함수
WHERE TRIM(A.NAME) = P_NAME
-- ❌ 금지 #3 — UPPER 함수
WHERE UPPER(A.EMAIL) = UPPER(P_EMAIL)
-- ❌ 금지 #4 — TO_CHAR / TO_NUMBER 묵시 변환
WHERE TO_CHAR(A.YYYYMMDD) BETWEEN '20260101' AND '20260131'
-- ❌ 금지 #5 — 산술/문자 조합
WHERE A.DIVISION_ID || '-' || A.PROJECT_CODE = P_DIV || '-' || P_PROJECT_CODE
-- ❌ 금지 #6 — Leading wildcard
WHERE A.ITEM_NAME LIKE '%token%'
-- ❌ 금지 #7 — SUBSTR
WHERE SUBSTR(A.PHONE, 1, 3) = '010'
-- ❌ 금지 #8 — NVL JOIN
LEFT JOIN B ON NVL(A.X, '') = B.Y
```

**문제점:**
- 옵티마이저가 컬럼 측 인덱스 사용 불가 → full table scan
- 함수 결과 cost 추정 부정확 → cardinality estimation 오류
- 큰 테이블 (>100K row) 일수록 영향 큰

### 3.7.2 권장 패턴 (After) — SARGable 변환

```sql
-- ✅ #1 — NVL 제거 (NULL 분기 OR 추가)
WHERE A.STATUS = 'OK' OR ( A.STATUS IS NULL AND 'OK' = '' )
-- 또는 (실용) 같은 의미
WHERE A.STATUS = 'OK'

-- ✅ #2 — TRIM 제거 (데이터 측 사전 정리 + WHERE 평이)
WHERE A.NAME = P_NAME   -- 데이터 정합성 의무
-- 또는 function-based index 생성: CREATE INDEX ... ON A (TRIM(NAME))

-- ✅ #3 — UPPER → 양측 캐스팅 회피 + function-based index
CREATE INDEX IDX_A_EMAIL_UPPER ON A (UPPER(EMAIL));
WHERE UPPER(A.EMAIL) = UPPER(P_EMAIL)   -- index 사용 OK

-- ✅ #4 — TO_CHAR 제거 (YYYYMMDD 가 VARCHAR2 면 직접 비교)
WHERE A.YYYYMMDD BETWEEN '20260101' AND '20260131'

-- ✅ #5 — 산술 분리
WHERE A.DIVISION_ID = P_DIV AND A.PROJECT_CODE = P_PROJECT_CODE

-- ✅ #6 — Leading wildcard 회피 (가능한 한 prefix 매치)
WHERE A.ITEM_NAME LIKE 'token%'   -- 첫 char known 시 prefix 매치 (B-tree index seek)
-- 또는 inverted index / context index (대용량 텍스트 검색)

-- ✅ #7 — SUBSTR 제거 (column 사전 분리 또는 function-based index)
CREATE INDEX IDX_A_PHONE_PFX ON A (SUBSTR(PHONE, 1, 3));
-- 또는 column 추가: ALTER TABLE A ADD PHONE_PFX VARCHAR2(3); UPDATE A SET PHONE_PFX = SUBSTR(PHONE, 1, 3);

-- ✅ #8 — NVL JOIN 제거 (OR 절 분리)
LEFT JOIN B ON A.X = B.Y OR (A.X IS NULL AND B.Y IS NULL)
-- 또는 LEFT JOIN 시 NULL 처리 (실용)
LEFT JOIN B ON A.X = B.Y
```

### 3.7.3 SARGable 변환 결정 표

| 비-SARGable 패턴 | SARGable 변환 | 추가 조치 |
|---|---|---|
| `NVL(col, '')` = value | `col = value` (NULL 무시) | 또는 OR 분기 |
| `TRIM(col) = value` | `col = value` (사전 trim) | data cleaning |
| `UPPER(col) = value` | function-based index | DDL CREATE INDEX |
| `TO_CHAR(num_col)` | 직접 비교 (type 일치 시) | type 검토 |
| `TO_DATE(varchar_col)` | varchar 직접 비교 (8자리 YYYYMMDD) | type 검토 |
| `col1 || col2 = X` | `col1 = X1 AND col2 = X2` | 분리 |
| `col LIKE '%X%'` | `LIKE 'X%'` (prefix) | 또는 inverted/context index |
| `SUBSTR(col, 1, n) = X` | function-based index | DDL |
| `col + n` (산술) | function-based index | DDL |
| `NVL(A.X, '') = B.Y` | `A.X = B.Y` (NULL 무시) | OR 분기 |

### 3.7.4 PRE-WRITE 자기 점검

- [ ] WHERE / ON / JOIN 조건 컬럼에 함수 적용?
- [ ] 문자열 조합 (`||`) 으로 비교?
- [ ] Leading wildcard `'%' || X`?
- [ ] 묵시 type 변환 (TO_CHAR / TO_NUMBER / TO_DATE)?
- [ ] SARGable 변환 가능한가?
- [ ] function-based index 추가 가능한가?

### 3.7.5 POST-WRITE grep

```bash
# 1) WHERE/ON 조건의 함수 적용 검출
grep -nE "(WHERE|ON|AND|OR)\s.*?(NVL|TRIM|UPPER|LOWER|SUBSTR|TO_CHAR|TO_NUMBER|TO_DATE)\s*\(\s*\w+\.\w+" {SP_BODY}

# 2) Leading wildcard 검출
grep -nE "LIKE\s+['\"]%" {SP_BODY}

# 3) 문자열 조합 비교
grep -nE "[A-Z]\.\w+\s*\|\|.*\s*=\s*" {SP_BODY}

# 4) 묵시 type 변환 의심 (TO_CHAR + numeric column)
grep -nE "TO_CHAR\s*\(\s*\w+\.\w+\s*\)\s*BETWEEN|TO_CHAR.*\s*=" {SP_BODY}
```

### 3.7.6 INDEX 신규 추가 판단

함수 사용 WHERE 절을 변환 못 할 때 (의미 보존 위해) **Function-Based Index** 추가:

```sql
-- 1. 사용 빈도 높은 WHERE function 패턴 식별
-- 2. function-based index 생성 (사내 운영자 승인 후)
CREATE INDEX SCM_MGR.IDX_X_UPPER ON SCM_MGR.X (UPPER(NAME));
CREATE INDEX SCM_MGR.IDX_X_TRIM ON SCM_MGR.X (TRIM(EMAIL));
CREATE INDEX SCM_MGR.IDX_X_SUBSTR ON SCM_MGR.X (SUBSTR(PHONE, 1, 3));
-- 3. 통계 갱신
EXEC DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR', 'X', cascade=>TRUE);
```

---

## §3.8. 룰 6 — 'ALL' / '' / NULL 매개변수 시 TEMP TABLE INSERT skip + JOIN 조건 short-circuit

### 3.8.1 사용자 명시 요구 (2026-06-16)

> "조건 입력 시 TEMP TABLE 사용하는 변수에 대해서 'ALL' 이거나 '' 값을 전달해서 전체을 대상으로 할 때는 TEMP TABLE 에 값 넣지 않고, JOIN 시 조건에 전체 대상으로 추가하는 것도 하나의 방법입니다. 전체를 TEMP TABLE 에 넣는 것보다 속도가 더 빠를 수 있으니, 이것도 RULE 로 적용해서 반영될 수 있도록 추가해주세요."

→ 룰 2 (GT 적재 + JOIN) 의 **성능 최적화 보강**. 'ALL' / '' / NULL 시 GT INSERT 자체 skip + SELECT 의 JOIN 조건에 short-circuit OR 분기.

### 3.8.2 절대 금지 패턴 (Before — 룰 2 보강 없이 매번 INSERT)

```sql
-- ❌ 비효율 — 'ALL' 시에도 INSERT (의미 없음, INSERT 자체 cost)
DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL))
FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;
-- ↑ P_ITEM_ID = 'ALL' 일 때 → GT 에 ['ALL'] 1 row 적재. 후속 LIKE '%ALL%' 매치 → 0 row → 메인 SELECT 0 row drop.

-- 또는 동일 비효율 — 모든 ITEM_ID 적재 시도 (cartesian)
INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
SELECT ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN WHERE DIVISION_ID = P_DIVISION_ID;
-- ↑ 50K row 적재 + 후속 JOIN 의 hash 비용

-- 후속 SELECT (B 의 join)
... JOIN SCM_MGR.GT_GGET_SPLIT_ITEM_ID B ON F.ITEM_ID LIKE '%' || B.TOK || '%'
```

### 3.8.3 권장 패턴 (After — 룰 6 적용)

**GT INSERT 자체 skip + SELECT 의 OR 분기 추가:**

```sql
-- ✅ 권장 — 'ALL'/'%'/'' 시 INSERT skip
DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL))
FROM   DUAL
WHERE  P_ITEM_ID IS NOT NULL
  AND  P_ITEM_ID NOT IN ('ALL', '%', '')   -- ⭐ skip 조건
CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

-- 후속 SELECT — OR 분기로 short-circuit
SELECT ...
FROM   SCM_MGR.SCM_MST_SITE_ITEM F
WHERE  ...
  AND  ( P_ITEM_ID IS NULL
         OR P_ITEM_ID IN ('ALL', '%', '')                    -- ⭐ short-circuit (전체 대상)
         OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                     WHERE F.ITEM_ID LIKE '%' || B.TOK || '%') )
```

**핵심 동작:**
1. **INSERT 단계**: `WHERE P_X NOT IN ('ALL','%','')` 추가 → 'ALL' 시 INSERT 0 row (GT 비어 있음)
2. **SELECT 단계**: `P_X IN ('ALL','%','') OR P_X IS NULL OR EXISTS (...)` — 옵티마이저 short-circuit:
   - 'ALL' 시 OR 첫 분기 TRUE → EXISTS 평가 skip → GT scan 0 (이미 비어 있음)
   - 'specific' 시 첫 분기 FALSE → EXISTS GT scan

**성능 효과:**
- 'ALL' 시: GT INSERT 0 cost + EXISTS skip → 거의 0 cost
- 'specific' 시: 룰 2 와 동일 (GT 적재 + EXISTS)

### 3.8.4 적용 매개변수 인벤토리 (DMF0003 예)

| 매개변수 | 'ALL' 가능 | '%' 가능 | NULL 가능 | 권장 분기 |
|---|:-:|:-:|:-:|---|
| `P_ITEM_ID` | ✅ | ✅ | ✅ | `IN ('ALL','%','') OR IS NULL` |
| `P_PROJECT_CODE` / `LP_PROJECT_CODE` | ✅ | ✅ | ✅ | 동일 |
| `P_CUSTOMER` | ✅ | ❌ | ❌ | `= 'ALL'` |
| `P_BIZ_TYPE` | ✅ | ❌ | ❌ | `= 'ALL'` |
| `P_ITEM_TYPE` | ✅ | ❌ | ❌ | `= 'ALL'` |
| `P_OWNER` | ✅ (사고 후) | ❌ | ✅ | `IN ('ALL','') OR IS NULL` |
| `P_SCM_SITE_ID` | ✅ | ❌ | ❌ | `= 'ALL'` |
| `P_PLANT_SITE_ID` | ✅ | ❌ | ❌ | `= 'ALL'` |
| `P_TEAM_ID` | ✅ | ❌ | ❌ | `= 'ALL'` |

### 3.8.5 변환 절차 (의무 5 단계)

```
Step 1: 매개변수 별 'ALL'/'%'/'' /NULL 가능성 식별
   - AS-IS .cs / FE store / 매개변수 사용처 cross-check
   - 각 매개변수의 default / 빈 값 처리 패턴 확인

Step 2: GT INSERT 의 WHERE 절에 skip 조건 추가
   WHERE P_X NOT IN ('ALL','%','') AND P_X IS NOT NULL

Step 3: SELECT 의 WHERE / ON 절에 OR short-circuit 추가
   AND ( P_X IN ('ALL','%','') OR P_X IS NULL OR EXISTS (...) )

Step 4: 옵티마이저가 short-circuit 활용 확인
   EXPLAIN PLAN — 'ALL' 시 GT scan 없는 plan 인지 검증

Step 5: 검증 — 'ALL' 호출 + 'specific' 호출 row count 동등성
```

### 3.8.6 PRE-WRITE 자기 점검

- [ ] 매개변수의 'ALL' / '%' / NULL / '' 가능성 cross-check?
- [ ] INSERT 의 WHERE 절에 skip 조건 추가?
- [ ] SELECT 의 OR 분기 추가?
- [ ] 옵티마이저 short-circuit 활용 가능성 확인 (EXPLAIN PLAN)?
- [ ] 변환 전후 'ALL' / 'specific' 결과 row count 동등성?

### 3.8.7 POST-WRITE grep

```bash
# 1) INSERT GT_GGET_SPLIT_ 의 skip 조건 누락 검출
grep -B 1 -A 8 "INSERT INTO SCM_MGR.GT_GGET_SPLIT_" {SP_BODY} | grep -L "NOT IN.*'ALL'\|<>.*'ALL'"

# 2) SELECT 의 OR 분기 누락 검출
grep -B 2 -A 4 "EXISTS.*GT_GGET_SPLIT_" {SP_BODY} | grep -L "IN \(.*'ALL'\|= 'ALL'"
```

### 3.8.8 anti-pattern 사고 사례

#### DMF0003 룰 2 적용 후 성능 차이 (2026-06-16 예상)

| 호출 패턴 | 룰 2 (skip 없음) | 룰 6 (skip 적용) |
|---|---:|---:|
| `P_ITEM_ID='ALL'` | GT INSERT 1 row ('ALL') + EXISTS scan + LIKE '%ALL%' 매치 0 | GT INSERT 0 + EXISTS skip → 0 cost |
| `P_ITEM_ID='SKU001,SKU002'` | GT INSERT 2 row + EXISTS scan + LIKE 매치 | 동일 (skip 조건 false) |

→ 'ALL' 시 GT INSERT 자체 비용 + 후속 join 비용 제거 → 대용량 데이터일수록 효과 큼.

---

## §4. 종합 변환 예시 (DMF0003 GT_GGET_SITE_ITEM_ALL INSERT)

### Before (22,095초 — 99% bottleneck)

```sql
INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
     -- 🔴 룰 1 위반 — column 안 correlated subquery + CONNECT BY
     , ( SELECT LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
         FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
         WHERE  ZA.USER_ID IN (
             SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
             FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL ) ) AS OWNER
     ...
FROM SCM_MGR.SCM_MST_SITE_ITEM F
-- 🔴 룰 2 위반 — inline split JOIN + LIKE cartesian
JOIN (
    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) || '%' TST
    FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL
) B ON (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
JOIN (
    SELECT DISTINCT '%' || TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) || '%' TST
    FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL
) C ON (F.PROJECT_CODE LIKE C.TST OR T3.PROJECT_NAME LIKE C.TST)
...
```

### After (룰 1+2 적용)

```sql
-- 룰 2: 사전 GT 적재 (P_ITEM_ID, LP_PROJECT_CODE)
DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL))
FROM DUAL
WHERE P_ITEM_ID NOT IN ('ALL','%') AND P_ITEM_ID IS NOT NULL AND P_ITEM_ID <> ''
CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL;

DELETE FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE;
INSERT INTO SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE (TOK)
SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL))
FROM DUAL
WHERE LP_PROJECT_CODE NOT IN ('ALL','%') AND LP_PROJECT_CODE IS NOT NULL AND LP_PROJECT_CODE <> ''
CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL;

-- 메인 INSERT
INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
     -- 룰 1 적용 — FROM 절 OW 의 column 참조
     , OW.OWNER_NAME  AS OWNER
     ...
FROM SCM_MGR.SCM_MST_SITE_ITEM F
JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T2 ON F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
JOIN SCM_MGR.SCM_MST_PROJECT T3 ON F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
-- 룰 1 적용 — FROM 절 inline view 사전 집계 (correlated 제거)
LEFT JOIN (
    SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
         , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
    FROM (
        SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
             , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
        FROM SCM_MGR.SCM_MST_SITE_ITEM FF
        CROSS JOIN (SELECT LEVEL AS LV FROM DUAL CONNECT BY LEVEL <= 30) HIER
        WHERE FF.DIVISION_ID = P_DIVISION_ID
          AND FF.OWNER IS NOT NULL
          AND TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
    ) OT
    JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
    GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
) OW
  ON F.DIVISION_ID = OW.DIVISION_ID
 AND F.PROJECT_CODE = OW.PROJECT_CODE
 AND F.SCM_SITE_ID = OW.SCM_SITE_ID
 AND F.ITEM_ID = OW.ITEM_ID
WHERE F.DIVISION_ID = P_DIVISION_ID
  -- 룰 2 적용 — GT 사전 적재 + EXISTS + 'ALL'/'%' short-circuit
  AND ( P_ITEM_ID IN ('ALL','%')
        OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                    WHERE F.ITEM_ID LIKE '%' || B.TOK || '%'
                       OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
  AND ( LP_PROJECT_CODE IN ('ALL','%') OR LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE = ''
        OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE C
                    WHERE F.PROJECT_CODE LIKE '%' || C.TOK || '%'
                       OR T3.PROJECT_NAME LIKE '%' || C.TOK || '%') )
...
```

---

## §5. MSSQL vs Oracle 변환 함정 — 추가 발견 패턴

| MSSQL 패턴 | Oracle 변환 시 함정 | 대응 |
|---|---|---|
| `STRING_SPLIT(@P, ',')` | `REGEXP_SUBSTR + CONNECT BY` 변환 → row-by-row | 룰 2 (GT 적재) |
| `STRING_AGG(col, ',') WITHIN GROUP (ORDER BY col)` | `LISTAGG` 동일 함수 — 다만 correlated 위치는 룰 1 |
| `CROSS APPLY (SELECT ...)` | Oracle 12c+ `CROSS APPLY` 지원 | OK / 또는 inline view |
| `WITH cte AS (...) SELECT ... FROM cte` | Oracle 동일 지원 | OK |
| `OPENJSON` | Oracle `JSON_TABLE` | 1:1 동등 |
| `PIVOT (X FOR Y IN (z1, z2, ...))` | Oracle 동일 지원 | OK / 다만 동적 PIVOT 제한 |
| `LEFT(col, n)` | Oracle `SUBSTR(col, 1, n)` | 1:1 변환 |
| `CHARINDEX(',', col)` | Oracle `INSTR(col, ',')` | 1:1 변환 |
| `ISNULL(a, b)` | Oracle `NVL(a, b)` | 1:1 변환 |
| `IIF(cond, t, f)` | Oracle `CASE WHEN cond THEN t ELSE f END` | 1:1 변환 |
| `DATEADD(WEEK, n, d)` | Oracle `d + n*7` | type-cast 주의 |
| `WITH (NOLOCK)` | Oracle 트랜잭션 일관성 자동 (제거) | 단순 제거 |

⚠ **MSSQL OK, Oracle 성능 결함:**
1. `CHARINDEX + LIKE '%' + token` 다중 token IN → Oracle 에서 nested loop full scan
2. `STRING_AGG` correlated → Oracle `LISTAGG` correlated 가 row-by-row
3. `STRING_SPLIT` LATERAL JOIN → Oracle 변환 시 inline split 다수 반복 호출

→ 본 hook 의 룰 1 + 룰 2 모두 적용 의무.

---

## §6. anti-pattern 사고 사례

### 6.1 DMF0003 GT_GGET_SITE_ITEM_ALL INSERT — 22,095초 (2026-06-16)

**증상:**
- SP `DMF0003_GET_MKT_FCST_DATA` 호출 시 timeout (10분+)
- DBMS_PROFILER 측정 결과 INSERT GT_GGET_SITE_ITEM_ALL 가 99% 시간 차지

**근본 원인:**
- 룰 1 위반: SELECT column 안 LISTAGG correlated subquery + CONNECT BY (line 968~975)
- 룰 2 위반: INNER JOIN inline split + LIKE B/C (line 1009~1016)

**fix 결과 (적용 보류 상태이지만 분석 검증):**
- 룰 1 + 룰 2 적용 시 매트릭스 cartesian-product 회피 + correlated row-by-row 제거 → 예상 elapsed time 1/100 이하

### 6.2 (잠재) DMF0007 / DMF0008 / DMF0020 메인 SP — 동일 패턴 의심

본 hook 적용 의무 화면들 (변환 시 grep 으로 점검):
- `Doc/_legacy_source/...DMF*.cs` AS-IS MSSQL 호출
- `_artifacts/_deploy_packages/*/04_PKG_SP/*.sql` TO-BE Oracle SP

---

## §7. Cross-ref

### 룰 v2
- `_tobe/04_store.md` / `_tobe/12_metadata_sql.md` (FE 측 'ALL' 처리 비대칭 참조)
- `hooks/oracle-db-workflow.md` (Oracle SP/DB 작업 단일 진입점 — 본 hook 의 상위)
- `hooks/anti-simplification.md` (최우선 룰 — 본 hook 의 상위)

### DB 변환 룰
- `Doc/_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md` 새 섹션 7 (성능 안티패턴) 추가 예정
- `Doc/_analysis/db_migration/02_SP_CONVERSION_PIPELINE.md` Stage 4 (성능 검증) 보강

### 메모리 / 사고 기록
- DMF0003 GT_GGET_SITE_ITEM_ALL 22,095초 사고 (2026-06-16)
- DMF0008 SUMMARY SP TRUNCATE GTT 사고 (2026-06-05)

---

## §8. 위반 시 대응

- PRE-SUBMIT 시 §2.4 + §3.5 체크리스트 + §2.5 + §3.6 grep 모두 통과 의무
- 1건이라도 위반 = PR 머지 차단
- AS-IS .cs / SP body 의 inline split / correlated subquery 변환 누락 = anti-simplification 위반 동등
- DBMS_PROFILER 측정 시 step elapsed > 30 sec 발견 시 본 hook 1차 검토 의무

---

## §9. 변경 이력

- 2026-06-16: 신규 작성 (사용자 명시 요구 — DMF0003 GT_GGET_SITE_ITEM_ALL 22,095초 사고 후).
  - **룰 1**: SELECT column 안 REGEXP_SUBSTR + CONNECT BY → FROM 절 inline view 분리
  - **룰 2**: 분리자 split JOIN → 사전 GT/GTT 적재 + JOIN
  - **룰 3**: MASTER 명칭 lookup → FROM 절 TABLE/SUB QUERY 분리 (LEFT JOIN)
  - **룰 4**: TEMP TABLE (GT/GTT) MAIN KEY COLUMN INDEX 의무
  - **룰 5**: WHERE 조건의 함수/문자 조합 → SARGable 변환 (또는 function-based index)
  - **룰 6**: 'ALL' / '' / NULL 매개변수 시 TEMP TABLE INSERT skip + SELECT OR short-circuit 분기 (사용자 명시 추가, 2026-06-16)
  - MSSQL → Oracle 변환 함정 13 패턴 정리
  - 사고 사례 §6.1 DMF0003 + §6.2 잠재 의심 화면 인벤토리
