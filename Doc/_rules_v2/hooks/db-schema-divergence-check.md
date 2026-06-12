# Hook — Docker DB vs 사내 DB Schema 차이 검출

> 작성: 2026-06-10 (사내 적용 중 8가지 schema 차이 발견 후)
> 상위 룰: `anti-simplification.md`
> 관련 hook: `db-corporate-apply.md` / `asis-msg-inventory.md`

---

## §0. 트리거

- 사내 DB 적용 전 PRE-CHECK
- `ORA-01400`/`ORA-00904`/`ORA-00942` 발생 시 근본 원인 식별
- SQL 산출물의 양쪽 DB 호환성 검토

---

## §1. 9가지 검증된 schema 차이 (2026-06-11 기준)

| # | 차이 | Docker | 사내 | 영향 | 대응 |
|---|---|---|---|---|---|
| 1 | `SCM_ADM_MSG_M`.MSG_TP_CD NOT NULL | NULLABLE | NOT NULL | i18n INSERT 시 ORA-01400 | INSERT 시 'MSG' default 명시 |
| 2 | `SCM_ADM_MSG_M`.USE_YN NOT NULL | NULLABLE | NOT NULL | 동일 | 'Y' default 명시 |
| 3 | `SCM_ADM_MSG_M`.CREATED_BY NOT NULL | NULLABLE | NOT NULL | 동일 | 'admin' default 명시 |
| 4 | `SCM_ADM_MSG_M`.LAST_UPDATED_BY NOT NULL | NULLABLE | NOT NULL | 동일 | 'admin' default 명시 |
| 5 | `SCM_COM_MSG_M` 테이블 | ❌ 미존재 | ❌ 미존재 | SYS 화면 i18n INSERT ORA-00942 | i18n MSG 별 SCM_ADM_MSG_M 으로 통합 |
| 6 | `SCM_ADM_MNU_M`.BMK_YN 컬럼 | ✅ 존재 | ❌ 미존재 | MENU INSERT 시 ORA-00904 | DDL 동기화 / 컬럼 제거 |
| 7 | USERS tablespace quota | 여유 | 부족 | ORA-01653 (extend table) | DBA 측 확장 |
| 8 | DBMS_METADATA stylesheet | 정상 | 버그 (`bad stylesheet: kuaudobj`) | SP body backup audit fail | audit-only 영향 — 실제 CREATE OR REPLACE 정상 |
| 9 | `SCM_MST_SITE_ITEM`.REPORT_GROUP3 | ✅ 존재 | ❌ 미존재 | GET SP `'' AS PRODUCT_GROUP` 하드코딩 fallback ↔ FE SAVE `\|\| 'N'` default 불일치 → LEFT JOIN 0 match → silent "데이터 보이지 않음" | GET SP fallback 'N' 통일 + FE default 'N' 통일 (2026-06-11 DMF0043 사고, fix script `09_dmf0043_main_data_product_group_n.py`) — CLOB escape `''N''` (5 char) 주의 |

## §2. PRE-CHECK SQL (적용 전 의무)

### 2.1 NOT NULL 컬럼 비교
```sql
SELECT TABLE_NAME, COLUMN_NAME, NULLABLE FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME IN ('SCM_ADM_MSG_M','SCM_ADM_MNU_M','SCM_ADM_API_M','SCM_ADM_PROC_M','SCM_MST_SHEET_COLUMNS','SCM_ADM_MNU_BTN_MPG_M','SCM_ADM_USER_GR_MNU_MPG_M','SCM_ADM_USER_GR_MNU_BTN_MPG_M')
 ORDER BY TABLE_NAME, COLUMN_ID;
```

### 2.2 테이블 존재 여부
```sql
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, OWNER FROM ALL_OBJECTS
 WHERE OBJECT_NAME IN ('SCM_ADM_MSG_M','SCM_COM_MSG_M', ...) AND OBJECT_TYPE IN ('TABLE','SYNONYM','VIEW')
 ORDER BY OBJECT_NAME, OBJECT_TYPE, OWNER;
```

### 2.3 tablespace quota
```sql
SELECT TABLESPACE_NAME, USED_PERCENT, USED_SPACE, TABLESPACE_SIZE
  FROM DBA_TABLESPACE_USAGE_METRICS
 WHERE TABLESPACE_NAME='USERS';
```

---

## §3. 신규 SQL 작성 시 호환성 의무

### 3.1 INSERT INTO MSG_M 필수 명시 컬럼
```sql
INSERT INTO SCM_MGR.SCM_ADM_MSG_M
  (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, NEW.MSG_DESC,
       'MSG' AS MSG_TP_CD, 'Y' AS USE_YN,         -- 사내 NOT NULL 보강
       'admin' AS CREATED_BY, SYSDATE,
       'admin' AS LAST_UPDATED_BY, SYSDATE
  FROM (...) NEW
WHERE NOT EXISTS (...);
```

### 3.2 SCM_COM_MSG_M 사용 금지
- SYS 화면 메타 SQL 의 `INSERT INTO SCM_COM_MSG_M` 은 양쪽 DB 미존재
- **SCM_ADM_MSG_M 으로 통합 의무** — `MSG_CTN` 컬럼 사용 시 `MSG_NM` 으로 매핑

### 3.3 BMK_YN 컬럼 회피
- `INSERT INTO SCM_ADM_MNU_M (..., BMK_YN, ...)` 시 사내 DB 에서 ORA-00904
- 컬럼 리스트에서 BMK_YN 제거 또는 DDL 동기화 (사내 ALTER TABLE ADD COLUMN)

---

## §4. 적용 결과 분석 의무

`db-corporate-apply.md` §4 의 row count diff 후, schema 차이가 원인인 fail row 식별:

| 증상 | 원인 컬럼 | 보강 방법 |
|---|---|---|
| MSG INSERT 0 row | MSG_TP_CD/USE_YN/CREATED_BY/LAST_UPDATED_BY | i18n patch SQL (§3.1) 재실행 |
| MNU INSERT skip | BMK_YN | 컬럼 제거 INSERT 또는 DDL 동기화 |
| 일부 SQL 실행 실패 | tablespace quota | DBA 확장 후 재실행 |

---

## §5. 자기 점검 grep

신규 메타 SQL 작성 후 의무 grep:
```bash
# 사내 호환 INSERT 패턴 확인 — 모두 OK 면 통과
grep -E "MSG_TP_CD|USE_YN|CREATED_BY|LAST_UPDATED_BY" {file}.sql | grep "INSERT" | wc -l

# SCM_COM_MSG_M 사용 0 확인 (양쪽 미존재 테이블)
grep -c "SCM_COM_MSG_M" {file}.sql  # → 0 여야 함

# BMK_YN 사용 0 확인 (사내 미존재 컬럼)
grep -c "BMK_YN" {file}.sql  # → 0 여야 함
```
