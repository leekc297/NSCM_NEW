# Hook — PKG/SP 데이터 추출 가짜 구현 절대 금지

> 적용 trigger: T08 (BE/SP 신규/변경) + T19 (AS-IS → TO-BE SP 변환) + T10 (조회 데이터 0/이상치 진단)
> 신설 일자: 2026-06-11 (사용자 명시 요구 — DMF0043_01 / DMF0008 silent 0 rows 사고 누적 후)
> 상위 룰: `anti-simplification.md` (속도/편의 단순화 절대 금지)
> 관련 메모리: `feedback_sp_no_fake_extraction.md` (신설)
> 짝 hook: `sp-exception-handler-debug-friendly.md` (silent EXCEPTION fallback)
>          `sp-body-minimal-change.md` (원본 SP body 보존 의무)
>          `asis-coverage-check.md` (AS-IS 1:1 매핑)

---

## §0 사고 사례 (누적 — 2026-05~06)

| # | SP | 가짜 구현 | 사용자 영향 |
|---|---|---|---|
| 1 | DMF0043_GET_CONTRIBUTION_SALES_LIST | `OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0` (EXCEPTION fallback) | silent 0 rows + "데이터 없음" 표시 |
| 2 | DMF0043_GET_CONTRIBUTE_MAIN_DATA | `OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL` (placeholder cursor) | SUMMARY/REPAIR 분기 silent fail |
| 3 | DMF0008_GET_EDI_MST_SUMMARY | `OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL` (placeholder) | dual-cursor 사고 family |
| 4 | NextSCM Pilot 변환 SP body | `BEGIN ... END;` stub만 + 원본 logic 미변환 | "VALID 컴파일" 가짜 보고 |
| 5 | DM_MST_ITEM_SINGLE_V 추가 view | hardcoded `'N' AS PRODUCT_GROUP` (사내 schema 차이 회피) | JOIN 불일치 silent 0 rows |
| 6 | 메타 fallback SP | `RETURN CURSOR (SELECT 0 AS CNT FROM DUAL)` (compatibilityYn != 'Y' 분기) | UI 카운트 항상 0 (의도된 동작이나 운영에서 혼동) |

**공통 패턴**: SP 가 컴파일 PASS + 호출 성공 + "데이터 0/이상치" 반환 → BE/FE 는 정상 응답으로 인식 → silent fail.

---

## §1 절대 금지 (Hard Rules)

### 1.1 SP body 안의 가짜 데이터 패턴

| # | 금지 패턴 | 사유 |
|---:|---|---|
| 1 | ❌ `OPEN cur FOR SELECT NULL AS DUMMY FROM DUAL` (단독, EXCEPTION 분기 외) | 데이터 미반환 가짜 cursor — 사용자 "데이터 없음" 오해석 |
| 2 | ❌ `OPEN cur FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0` | 빈 cursor — 동일 |
| 3 | ❌ `OPEN cur FOR SELECT 0 AS CNT FROM DUAL` (의미 없는 0) | 카운트 가짜 — 사용자가 실 0 으로 인식 |
| 4 | ❌ 신규 SP 의 `BEGIN NULL; END;` 빈 body | stub — 운영 적용 시 침묵 fail |
| 5 | ❌ AS-IS SP 변환 시 `RETURN;` 만으로 logic 생략 | 변환 완료 가짜 보고 |
| 6 | ❌ hardcoded `'N'` / `''` / `0` 으로 컬럼 채움 (실 source 미조회) | 데이터 추출 가짜 — 운영 데이터 손실 |
| 7 | ❌ AS-IS source 가 join 5단계인데 to-be 가 2단계로 단순화 | 누락 fail |
| 8 | ❌ EXCEPTION OTHERS THEN NULL (silent swallow) | 가짜 SUCCESS 응답 |

### 1.2 메타 (PROC_M / API_M / SHEET_COLUMNS) 안의 가짜 구현

| # | 금지 행위 | 사유 |
|---:|---|---|
| 9 | ❌ `API_URL` 미존재 SP 명 등록 (PLS-00201 유발) | 자가 진단 우회 |
| 10 | ❌ `PROC_M` 의 IN/OUT 갯수가 SP signature 와 불일치 (PLS-00306) | 컴파일 PASS 가짜, 실호출 fail |
| 11 | ❌ `SHEET_COLUMNS.COLUMN_NAME` 이 SP 결과 alias 와 case-insensitive mismatch | 빈 셀 표시 |
| 12 | ❌ default 0 / NULL 로 메타 row 위장 등록 | 실제 의미 없음 — 잘못된 운영 표시 |

### 1.3 자동화 변환기 (NextSCM Pilot 등) 의 가짜 변환

| # | 금지 행위 |
|---:|---|
| 13 | ❌ 변환기 1회 통과 결과 = 정상으로 채택 (검증 없이) |
| 14 | ❌ MSSQL `ISNULL(x, '')` → Oracle `NVL(x, NULL)` 잘못 변환 그대로 보존 (NULL→UNKNOWN 사고) |
| 15 | ❌ MSSQL `STRING_SPLIT` → Oracle `UF_FX_STRING_SPLIT` (PIPELINED PL/SQL, context switch 비용) 그대로 사용 |
| 16 | ❌ MSSQL `TRUNCATE TABLE GT_*` → Oracle `EXECUTE IMMEDIATE TRUNCATE` (DDL 권한 부족) 그대로 사용 |
| 17 | ❌ MSSQL `SUBSTR(s, 0, n)` → Oracle (position=0→1 정규화로 `^` 포함 token) 그대로 사용 |
| 18 | ❌ MSSQL `ORDER BY A.col` (UNION ALL 끝) → Oracle ORA-00904 그대로 사용 |

---

## §2 의무 (Hard Requirements)

### 2.1 SP body — 실제 데이터 추출 의무

| # | 의무 | 검증 방법 |
|---:|---|---|
| 1 | ✅ AS-IS PKG body 의 모든 JOIN / 필터 / CASE / PIVOT / 권한 logic 을 to-be 에 1:1 보존 | `__asis-mapping__.md` (라인 단위 매핑) |
| 2 | ✅ 변환 후 실 데이터 row 수 = AS-IS row 수 (사내 schema 차이 영향분 명시 보고) | `_artifacts/_diagnostics/row_count_diff.sh` |
| 3 | ✅ 모든 OPEN cursor 가 실 SQL 결과 반환 (DUMMY/WHERE 1=0 절대 금지) | grep 검증 (§4 참조) |
| 4 | ✅ 변환 불가 항목 (예: SCM_MST_SITE_ITEM.REPORT_GROUP3 dropped) → 사용자 명시 보고 + 결정 받음 | `feedback_corporate_schema_dropped_col_save_default.md` |
| 5 | ✅ 가짜 구현 → 실 추출 로직 교체 시 backup → diff → 검증 3 단계 의무 | `_artifacts/_diagnostics/{SP}_before_*.sql` 백업 + diff |

### 2.2 EXCEPTION 핸들러 — 가짜 SUCCESS 금지

```sql
-- ❌ 절대 금지: silent swallow + 빈 cursor fallback
BEGIN
  OPEN p_cursor_main FOR <complex_query>;
EXCEPTION WHEN OTHERS THEN
  BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;
        EXCEPTION WHEN OTHERS THEN NULL; END;
END;
```

위 패턴 = "가짜 데이터 추출" 의 대표 사례. 다음 중 택1:
- A) EXCEPTION 제거 — 진짜 사고 시 BE 가 ORA-XXX 받아 진단 가능
- B) 디버그 임시 — `sp-exception-handler-debug-friendly.md` 의 RAISE_APPLICATION_ERROR(SQLCODE/SQLERRM/BACKTRACE) 패턴
- C) 운영 — `_DEBUG_VSQL` 같은 진단 테이블에 v_sql_text + SQLERRM 기록 후 cursor 반환

⚠ **A/B/C 어느 것도 안 하면 silent fail** → 사용자 시간 낭비 + 신뢰성 손상.

### 2.3 메타 (PROC_M) — SP signature 1:1 정합 의무

```bash
# PRE-DEPLOY 검증 (필수)
SELECT a.OBJECT_NAME, a.arg_cnt sig_args, NVL(p.proc_m_cnt,0) proc_m_args,
       a.arg_cnt - NVL(p.proc_m_cnt,0) diff
  FROM (SELECT OBJECT_NAME, COUNT(*) arg_cnt FROM USER_ARGUMENTS
         WHERE OBJECT_NAME LIKE '<MENU_ID>%' AND PACKAGE_NAME IS NULL
         GROUP BY OBJECT_NAME) a
  LEFT JOIN (SELECT PROC_NM, COUNT(*) proc_m_cnt FROM SCM_ADM_PROC_M
              WHERE PROC_NM LIKE '<MENU_ID>%'
              GROUP BY PROC_NM) p ON a.OBJECT_NAME = p.PROC_NM
 WHERE diff != 0;
-- 결과 0 row 의무
```

### 2.4 BE auto-fill 키 통일 의무

- `sesUserId` (P_USER_ID 자동 채움)
- `mnuId` (P_MENU_ID 자동 채움) — ⚠️ `menuId` (X)

PROC_M.COL_NM 가 `menuId` 면 BE 가 NULL 전달 → SP 의 `PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(NULL)` 권한 조인 실패 → 0 rows.

---

## §3 발견 시 즉시 대응 (Fix Mandatory)

가짜 구현 패턴 발견 시 다음 순서:

1. **Backup** — `_artifacts/_diagnostics/{SP_NAME}_before_<purpose>_<ts>.sql` 의 백업 의무
2. **AS-IS source 검증** — `Doc/_legacy_source/` 또는 AS-IS DB 직접 cross-check
3. **실 추출 logic 작성** — AS-IS 1:1 매핑 (단순화 절대 금지)
4. **CREATE OR REPLACE** + STATUS=VALID 확인
5. **검증** — 직접 callproc 또는 row count diff 로 실 데이터 반환 확인
6. **메모리 + hook 갱신** — 이 hook 의 `§0 사고 사례` 표에 추가
7. **사용자 보고** — 어떤 가짜 구현 → 어떤 실 추출 로 교체했는지 명시

---

## §4 자동 검증 (PRE-DEPLOY + POST-WRITE 의무)

### 4.1 가짜 DUMMY cursor 검출

```bash
# 단독 OPEN ... DUAL DUMMY (EXCEPTION 분기 외) 검출
grep -nE "OPEN\s+\w+\s+FOR\s+SELECT\s+NULL\s+AS\s+DUMMY\s+FROM\s+DUAL" \
     <SP_BODY_FILE> | grep -v "EXCEPTION"
# 결과 0 줄 의무 (있으면 가짜 구현)
```

### 4.2 빈 SP body 검출

```sql
SELECT NAME FROM USER_SOURCE
 WHERE TYPE='PROCEDURE'
   AND NAME LIKE '<MENU_ID>%'
 GROUP BY NAME
HAVING COUNT(*) < 10   -- 본문 < 10 줄 = stub 의심
   AND NOT EXISTS (SELECT 1 FROM USER_SOURCE us2
                    WHERE us2.NAME = NAME AND us2.TYPE='PROCEDURE'
                      AND UPPER(us2.TEXT) LIKE '%SELECT%FROM%');
```

### 4.3 hardcoded sentinel 검출

```sql
SELECT NAME, LINE, TEXT FROM USER_SOURCE
 WHERE TYPE='PROCEDURE'
   AND NAME LIKE '<MENU_ID>%'
   AND (REGEXP_LIKE(TEXT, '''''\s*AS\s+\w+', 'i')                  -- '' AS X
        OR REGEXP_LIKE(TEXT, '''N''\s*AS\s+PRODUCT_GROUP', 'i')     -- 'N' AS PRODUCT_GROUP
        OR REGEXP_LIKE(TEXT, 'SELECT\s+0\s+AS\s+CNT', 'i'));        -- SELECT 0 AS CNT
-- AS-IS source 와 cross-check 의무
```

### 4.4 PROC_M ↔ SP signature 정합

§2.3 의 SQL — diff != 0 row 가 있으면 fail.

### 4.5 BE auto-fill 키 통일

```sql
SELECT PROC_NM, COL_NM FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE '<MENU_ID>%'
   AND COL_NM IN ('menuId', 'menu_id', 'MENU_ID');
-- 결과 0 row 의무 (반드시 mnuId)
```

### 4.6 NextSCM Pilot 변환 안티패턴 잔존

```sql
SELECT NAME, LINE, TEXT FROM USER_SOURCE
 WHERE TYPE='PROCEDURE'
   AND NAME LIKE '<MENU_ID>%'
   AND (UPPER(TEXT) LIKE '%TRUNCATE TABLE GT%'                     -- TRUNCATE GTT (script 07 family)
        OR REGEXP_LIKE(TEXT, 'NVL\(\w*\.?EXCEPTION_FLAG\s*,\s*NULL\)', 'i')  -- NVL(.., NULL) (script 28 family)
        OR REGEXP_LIKE(TEXT, 'EXCEPTION_FLAG\s*!=\s*''Y''', 'i') AND TEXT NOT LIKE '%NVL%'  -- bare != 'Y' (script 29 family)
        OR UPPER(TEXT) LIKE '%UF_FX_STRING_SPLIT%'                  -- PIPELINED PL/SQL (script 13 family)
        OR REGEXP_LIKE(TEXT, 'SUBSTR\(\w+\s*,\s*0\s*,', 'i')        -- SUBSTR position=0 (script 08 family)
        OR UPPER(TEXT) LIKE '%ORDER BY A.%');                       -- UNION ALL ORDER BY alias (script 19 family)
```

---

## §5 사용자 명시 요구 (2026-06-11)

> "DB 작업 시 PKG, SP 에 들어가는 데이터 추출의 경우에 가짜로 구현하는 케이스는 만들면 안됩니다.
> 이전에 실수로 만들어진 로직이 있더라도 삭제하고 실제 데이터 추출로 변경해주세요."

위 요구는 **anti-simplification.md 의 SP 측 구현**. 이전 사고로 만들어진 가짜 로직 (DUMMY cursor, hardcoded sentinel, stub body, NVL(.., NULL), bare != 'Y' 등) 은 **발견 즉시 §3 절차로 실 추출 변경 의무**.

---

## §6 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-11 | 신규 작성 — 사용자 명시 요구 + DMF0043/DMF0008 누적 사고 사례 6건 기반 |
