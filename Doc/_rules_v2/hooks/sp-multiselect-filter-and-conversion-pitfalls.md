# hook: SP 멀티선택 필터 표준(GTT+skip) + 변환 3대 폭발/오정합 함정

> 트리거: AS-IS→TO-BE SP 변환 / SP 조회 0행·hang·폭발 진단 / `IN (split(...))` 필터 / 멀티선택 조회조건
> 계보: DMF0082 SavePricePeriod(Price Batch Input) 재설계 (2026-07-13) — 조회 0행 + div40 폭발(97~594s) → 5966행/~9s
> 상위 진입: `oracle-db-workflow.md`, 안티패턴 `feedback_sp_perf_tuning_methodology`, `feedback_oracle_bulk_clob_buffer`

## A. 멀티선택 필터 표준 룰 (사용자 확정, 앞으로 전 SP 적용)

**원칙**: `컬럼 IN (분리자 split)` 형태 멀티선택 필터는 —
1. **값이 있을 때** = INNER JOIN(LIKE/등가)으로 필터.
2. **`ALL` 또는 빈값일 때** = 조건에서 **제외(skip)** = 조인하지 않거나 OUTER JOIN(match-all)으로 전환.
3. **멀티선택 값은 인라인 split을 반복하지 말고 GTT에 1회 사전 적재** 후 조인.

### A-1. 사전 적재 (SP 시작부, 단일 param split → 1회, 저비용)
```sql
DELETE FROM GT_XXX_SP_FILTER;
INSERT INTO GT_XXX_SP_FILTER (FILTER_TYPE, FILTER_VALUE)
  SELECT 'PROJECT', TOKEN FROM TABLE(fn_string_split(p_project_code, ','))
  WHERE p_project_code IS NOT NULL AND p_project_code <> 'ALL';   -- ALL/빈값 = 미적재
```

### A-2. skip 패턴 조인 (빈값=match-all sentinel → ON TRUE = 전량 통과)
```sql
INNER JOIN ( SELECT '%'||FILTER_VALUE||'%' tst FROM GT_XXX_SP_FILTER WHERE FILTER_TYPE='PROJECT'
             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_project_code IS NULL OR p_project_code='ALL') ) b1
ON  (p_project_code IS NULL OR p_project_code = 'ALL')   -- skip: 값없으면 전량 통과
OR  PJT.PROJECT_CODE LIKE b1.tst
OR  PJT.PROJECT_NAME LIKE b1.tst
```
> GROUP BY가 있으면 멀티토큰 중복은 자동 collapse되어 안전. 없으면 EXISTS(WHERE)로 대체해 행 증식 방지.

### A-3. ⚠️ Oracle `'' = NULL` 함정 (0행의 주범)
- 구코드 `WHERE p_owner = ''` / `AND p_owner <> ''` → Oracle에선 `NULL=NULL`(UNKNOWN) → **항상 0행**.
- FE가 빈값을 `''`로 보내면 `p_owner IS NULL`로 판정됨 → 반드시 `(p IS NULL OR p='ALL')`로 교정.
- `fn_string_split('')`(=NULL) 은 0행 반환 → `INNER JOIN (split(''))` 은 **전량 탈락**. A-2 sentinel로 회피.
- 관련: [[feedback_search_fields_catalog]] 조회조건에서 빈 멀티선택은 FE가 `'ALL'` 전송 권장.

## B. AS-IS→TO-BE SP 변환 3대 폭발/오정합 함정 (V$SQL·실행계획으로 확정)

### B-1. `IN (분리자 split)` 조인 = decorrelate 카테시안 (안티패턴#51)
- `LEFT JOIN U ON U.ID IN (SELECT tok FROM TABLE(fn_split(T.OWNER,',')))` — 행별 파이프라인 함수.
- 격리 실행은 빠르나(0.2s), 큰 집합에 nested/decorrelate되면 **N×M 카테시안**(184M행, cost 78G).
- ❌ OUTER APPLY만으론 부족 — 옵티마이저가 인라인 subquery/CTE(단일참조 MATERIALIZE 무시)를 decorrelate.
- ✅ **물리 GTT에 1회 사전 실현** 후 hash join. `OUTER APPLY TABLE(fn_split(..))` 는 GTT 적재 INSERT 안에서만 사용(격리→정상).
- 진단: `DBMS_XPLAN.DISPLAY_CURSOR` 의 `MERGE JOIN OUTER`/`SORT UNIQUE` 에 수천만~억 Rows.

### B-2. 조인키 부재 = 전체 테이블 카테시안 (마이그레이션 '일단 주석처리' 잔재)
- `LEFT JOIN DEPT TEAM ON TEAM.VALID_YN='Y'` — **조인키 없음**(원본 `C.DEPT_ID=TEAM.DEPT_ID`를 컬럼부재로 주석처리).
- 전체 유효행(2만+)과 카테시안 → **GROUP BY에 그 컬럼이 있으면 출력이 N배 뻥튀기**(성능+정합 동시 사고).
- ✅ 해당 컬럼을 쓰지 않는 분기(div40=PJT.DEPT_ID 사용)는 `AND p_division_id <> '40'` 로 조인 자체를 차단. 나머지 분기는 기존 동작 보존(무회귀).
- grep 게이트: SP 변환 후 `ON .*VALID_YN\s*=\s*'Y'\s*$` (등가키 없는 LEFT JOIN) 전수 점검.

### B-3. INSERT 컬럼목록 ↔ SELECT 순서 어긋남 (변환 시 명시목록 추가하며 오정렬)
- AS-IS `INSERT INTO t SELECT ...`(목록 없음, 테이블 물리순서) → 변환 시 명시 컬럼목록을 **다른 순서로** 추가 → 값이 엉뚱한 컬럼에 저장.
- 증상: `ORA-12899 값이 너무 큼`(넓은 값이 좁은 컬럼 유입) 또는 조용한 데이터 오염(다운스트림 name 참조).
- ✅ INSERT 목록 순서 = SELECT 표현식의 **의미**(예: `A.PROJECT_CODE`→`PROJECT_CODE` 컬럼)에 1:1 정렬. `all_tab_columns` 물리순서와 대조.

## C. 진단 순서 (SP hang/폭발)
1. `V$SQL` (PARSING_SCHEMA_NAME + SQL_TEXT LIKE) → **문장별 elapsed/per-exec** 로 병목 문장 특정 (call_timeout로 중단 후에도 누적치 잔존).
2. `DBMS_XPLAN.DISPLAY_CURSOR(sql_id,child,'BASIC +ROWS +COST')` → 카테시안/Rows 억단위 연산 식별.
3. `DBMS_SQLTUNE.REPORT_SQL_MONITOR(sql_id)` → 실제 SQL 텍스트(바인드 전개) + 연산별 실시간.
4. 물리 GTT 도입 시 **공유 stats 고정**(`GLOBAL_TEMP_TABLE_STATS='SHARED'` + SET_TABLE_STATS + LOCK) — 미고정 시 하드파스마다 dynamic sampling(첫 호출 ~60s).

## D. 재발방지 grep 게이트 (SP 변환 후)
```
❌ WHERE\s+\w+\s*=\s*''          # Oracle ''=NULL → 항상 거짓 (→ IS NULL)
❌ ON\s+\w+\.VALID_YN\s*=\s*'Y'\s*$   # 조인키 없는 LEFT JOIN (카테시안)
❌ IN\s*\(\s*SELECT.*TABLE\(\s*fn_.*split  # 행별 split-in-join (→ 물리 GTT)
✅ INSERT 목록 컬럼수 == SELECT 표현식수, 순서 의미 대조 (all_tab_columns)
```

> 정본 산출물: `_artifacts/_apply_corporate/DMF0082_savePrice_SP_orig.sql` + `DMF0082_savePrice_GTT_setup_20260713.sql`
