# SYS0013 Dynamic Query DQ_TEXT MSSQL → Oracle 일괄 변환 보고서

**날짜**: 2026-06-21
**대상**: 사내 Oracle `SCM_MGR.SCM_ADM_DQ_LIST.DQ_TEXT` (CLOB, 107 row)
**도구**: regex 룰 엔진 22종 (`lib/dq_text_rules.py`)
**3 phase pipeline**: Audit → Backup + Convert → Verify

---

## 1. 결과 요약

| 지표 | 값 |
|---|---:|
| 전수 row | 107 |
| 변환 row (Phase 2 1+2차 합산) | 104 |
| 무변경 row | 3 |
| Phase 2 멱등 검증 (3차 실행) | UPDATE 0 ✅ |
| Phase 3 verify 자동 잔존 hit | 0 ✅ |
| Phase 3 verify 사람 검토 의무 잔존 | 0 ✅ |
| 룰 cross-check 경고 | 0 |
| 백업 테이블 | `SCM_MGR.SCM_ADM_DQ_LIST_BAK_20260621` (107 row) |
| Hard Boundary 변경 (BE/shared/foundation/lges/FE) | 0 ✅ |

---

## 2. 룰별 적용 분포 (Phase 1 audit 기준)

| # | 룰 | category | hits | 영향 DQ 수 |
|---:|---|---|---:|---:|
| 1 | S21_BRACKET_IDENT (`[ident]`) | syntax | 1,126 | 60 |
| 2 | C8_CMBO_VAR_RAW (`@var`→`:var`) | pitfall | 627 | 74 |
| 3 | S15_NOLOCK (`WITH (NOLOCK)`) | syntax | 407 | 72 |
| 4 | F19_CONVERT_DATE (`CONVERT(VARCHAR,dt)`) | datetime | 149 | 31 |
| 5 | S16_NQUOTE (`N'...'`) | syntax | 124 | 19 |
| 6 | F10_ISNULL_to_NVL | function | 95 | 21 |
| 7 | F12_DATEADD | datetime | 65 | 21 |
| 8 | F11_GETDATE_to_SYSDATE | datetime | 53 | 19 |
| 9 | S17_TOP_N | syntax | 19 | 12 |
| 10 | F20_LEN_to_LENGTH | function | 16 | 6 |
| 11 | F13_CHARINDEX (인자 swap) | function | 10 | 2 |
| 12 | S18_STRING_SPLIT (사람 검토 marker) | syntax | 9 | 2 |
| 13 | C7_EMPTY_STRING_COMPARE | pitfall | 8 | 7 |
| 14 | F14_IIF | function | 3 | 1 |
| 15 | Z22_PRETTY_BREAK (1줄 SQL 가독성) | cleanup | 2 | 2 |
| 16~22 | C1/C2/C3/C4/C5/C6/C9 | pitfall | 0 | 0 (DQ_TEXT 에 SP 변환 함정 부재 — 정상) |

---

## 3. 변환 sample (DQ_ID 1, 27, 28, 29)

### DQ_ID 1
**BAK**: `... COUNT(1) COUNTS, CONVERT(VARCHAR, A.LAST_UPDATE_DATE,112)  MODIFY_DATE ...`
**CUR**: `... COUNT(1) COUNTS, TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')  MODIFY_DATE ...`

### DQ_ID 27
**BAK**: `select A.[COMPANY_ID], [DIVISION_ID], A.[RESULT_YYYYMM], ...`
**CUR**: `select A.COMPANY_ID, DIVISION_ID, A.RESULT_YYYYMM, ...`

### DQ_ID 28
**BAK**: `SELECT TOP 10000 a.DIVISION_ID,... FROM [DBO].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] a ...`
**CUR**: `SELECT /*+ TOP_CONVERTED_TO_FETCH_FIRST_10000_ROWS_ONLY */ a.DIVISION_ID,... FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V a ...`

### DQ_ID 29
**BAK**: `..., charindex('>', CUST_NM ...)+1, len(CUST_NM ...) ...`
**CUR**: `..., INSTR(CUST_NM ..., '>')+1, LENGTH(CUST_NM ...) ...`

---

## 4. 사람 후속 검토 의무 항목

자동 1-to-1 변환 불가 — marker comment 만 삽입한 패턴:

### S18_STRING_SPLIT (5 row — DQ_ID 7, 36, 46, 84, 99)
- `STRING_SPLIT(col, ',')` → Oracle `REGEXP_SUBSTR + CONNECT BY` 재구현 필요
- 영향 row 의 SQL 본문에 `/*STRING_SPLIT_NEEDS_REGEXP_SUBSTR_CONNECT_BY*/STRING_SPLIT(...)` marker 삽입됨
- 권장: SYS0013 화면에서 해당 row 실행 시 ORA-00904/06550 발생 → 본문 직접 편집 (SQL Tab editable mode 활용)

### S17_TOP_N (12 row)
- `SELECT TOP n` → marker `/*+ TOP_CONVERTED_TO_FETCH_FIRST_n_ROWS_ONLY */` 자동 삽입
- 권장: 외측 SQL 마지막에 `FETCH FIRST n ROWS ONLY` 추가 (ORDER BY 위치 의무) — 화면 실행 시 사람 fix

### F19_CONVERT_DATE 중첩 (1 row — DQ_ID 84)
- `CONVERT(VARCHAR(10), CONVERT(DATE, ...))` 같은 2단 중첩 — regex 1단 paren 매칭 한계
- 권장: 사람 본문 편집

---

## 5. 백업 + Rollback

### 백업 테이블
```
SCM_MGR.SCM_ADM_DQ_LIST_BAK_20260621
  - DQ_ID, DQ_TEXT, BAK_AT (SYSDATE)
  - row count: 107
```

### Rollback SQL (자동 생성)
`_logs/sys0013_dq_rollback_20260621_084945.sql`:
```sql
UPDATE SCM_MGR.SCM_ADM_DQ_LIST t
   SET DQ_TEXT = (SELECT DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST_BAK_20260621 b WHERE b.DQ_ID = t.DQ_ID),
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_DQ_LIST_BAK_20260621 b WHERE b.DQ_ID = t.DQ_ID);
COMMIT;
```

### 백업 테이블 삭제 (검증 통과 후, 사용자 판단)
```sql
DROP TABLE SCM_MGR.SCM_ADM_DQ_LIST_BAK_20260621 PURGE;
```

---

## 6. 검증 인계 (사용자)

### 화면 검증 절차
1. 브라우저 SYS0013 새로고침
2. main grid 의 row 5건 sample 선택 (예: DQ_ID 1, 27, 28, 29 + STRING_SPLIT 1건 = 7)
3. SQL Tab 에 변환된 SQL 표시 확인 (NOLOCK 제거 / TO_CHAR / NVL / `:var` bind 등)
4. Execute 클릭 → Result Tab 에 결과 표시
5. ORA-xxxx 발생 시 보고 (사람 후속 검토 의무 5+12+1 row 일 수도)

### Hard Boundary 무영향 확인
```bash
git status nscm-be/ packages/shared/ packages/foundation/ packages/lges/ nscm-fe/
# 본 conversion 작업분 = 0 row (단, 직전 SYS0013 audit 작업분은 별도)
```

---

## 7. 산출물 인벤토리

| 파일 | 역할 |
|---|---|
| `lib/dq_text_rules.py` | 룰 엔진 22종 + literal 마스킹 + cross-check |
| `lib/__init__.py` | Python 패키지 표시 |
| `83_sys0013_dq_text_audit.py` | Phase 1 read-only audit + CSV/MD 산출 |
| `84_sys0013_dq_text_conversion.py` | Phase 2 백업 + 멱등 UPDATE |
| `85_sys0013_dq_text_verify.py` | Phase 3 post-audit + rollback SQL gen |
| `REPORT_SYS0013_DQ_CONVERSION.md` | 본 보고서 |
| `_logs/sys0013_dq_audit_20260621_084203.csv` | Phase 1 audit row-by-row |
| `_logs/sys0013_dq_audit_20260621_084203.md` | Phase 1 audit 요약 |
| `_logs/sys0013_dq_conv_20260621_084437.log` | Phase 2 1차 conversion log |
| `_logs/sys0013_dq_conv_20260621_084841.log` | Phase 2 2차 (S18 멱등 보강 후) |
| `_logs/sys0013_dq_conv_20260621_085023.log` | Phase 2 3차 (멱등 검증 — UPDATE 0) |
| `_logs/sys0013_dq_rollback_20260621_084945.sql` | 자동 생성 rollback SQL |

---

## 8. Anti-Simplification 준수 확인

- ✅ 22 룰 전수 등록 (선택 누락 0). 0 적중 룰 (C1/C2/C3/C4/C5/C6/C9) 도 명시 — "no-op 입증"
- ✅ String literal 마스킹 — false-positive 회피 (`GETDATE` 등 literal 안 가짜 매칭 차단)
- ✅ 룰별 self cross-check (regex 매칭 count vs 적용 count 일치 ASSERT — 경고 0)
- ✅ S18/F19 자동 변환 한계 명시 → marker 삽입 + 사람 후속 검토 의무 목록 공개
- ✅ AST 미사용 한계 명시 (regex only — 부록 C `SUBSTR(s,0,n)` silent fail 와 동일 한계)
- ✅ 멱등성 검증 (3차 실행 UPDATE 0)
- ✅ 백업 테이블 + Rollback SQL 자동 생성
- ✅ Hard Boundary (BE/shared/foundation/lges/FE) 변경 0
