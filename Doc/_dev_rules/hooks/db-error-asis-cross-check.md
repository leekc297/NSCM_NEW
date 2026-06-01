# Hook — DB 오류 시 AS-IS DB 직접 cross-check 의무

> ⭐ **2026-06-01 신규.** DB 오류 발생 또는 데이터 미일치 시 추측 금지 — As-Is MSSQL DB 에 직접 연결하여 원본 cross-check.

작성: 2026-06-01 (DMF0043 작업 중 11종 DB 오류 사고 후 사용자 요구)

상위 룰: 룰 24 §6.5 / 룰 21 §12 / 메모리 `feedback_asis_to_tobe_sp_no_omission.md`

---

## §0. 트리거 조건 (1개 이상 해당 시 본 hook 적용)

| 트리거 | 예 |
|---|---|
| ORA-XXXXX 오류 발생 | ORA-01400/01427/01489/01722/06502/56907 등 |
| 화면 데이터 0건 / 일부 누락 / 값 불일치 | DMF0043 Trend Power_01 DTL 96 건 누락 |
| To-Be 결과 row 수가 As-Is 와 다름 | DMF0043 As-Is 11 건 → To-Be 0 건 |
| SP / Table / Column 스키마 의문 | REPORT_GROUP3 컬럼 존재 여부 |
| 사용자가 "As-Is 확인 후 진행" 명시 요청 | "AS-IS 소스 확인 부탁드립니다" |

---

## §1. 연결 정보

### 1.1 `.env.asis` (gitignored, `.gitignore` `.env.*` 패턴)

```
ASIS_DB_HOST=165.244.95.223
ASIS_DB_PORT=1433
ASIS_DB_NAME=LGCE_SCMDEV       # ⚠ LGCD 아님 — D vs E 주의
ASIS_DB_USER=scp_mgr_dev
ASIS_DB_PASS=(env)
```

### 1.2 sqlcmd 명령 (Git Bash)

```bash
source .env.asis 2>/dev/null
sqlcmd -S "${ASIS_DB_HOST},${ASIS_DB_PORT}" -d "${ASIS_DB_NAME}" \
  -U "${ASIS_DB_USER}" -P "${ASIS_DB_PASS}" -C -W \
  -Q "SET NOCOUNT ON; <SQL>"
```

---

## §2. 의무 절차

### 2.1 DB 오류 발생 시

1. **BE 로그**에서 SQLERRM 메시지 추출
2. **로컬 SP body** 확인 (오류 line 근처)
3. **AS-Is 동일 SP body** 추출 (`SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('<SP_NAME>')`)
4. **변환 누락/오류 식별** — MSSQL → Oracle 변환 패턴 (SUBSTR offset / `[col]` / LISTAGG 한도 / JSON_OBJECT 한도 등)
5. **`_artifacts/{seq}_{SP}_Fix.sql` 작성** + 적용 + 단위 호출 검증
6. 룰 21 §12 의 사고 사례에 추가

### 2.2 데이터 불일치 발생 시

1. **AS-Is 동일 쿼리 실행** — row 수 비교
2. **AS-Is 에서 누락 row export** (CSV 또는 INSERT 문)
3. **`_artifacts/{seq}_{TABLE}_Import.sql` 작성** + 적용 + 카운트 검증

### 2.3 스키마 의문 발생 시

```sql
-- AS-IS 테이블 컬럼 인벤토리
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME='<T>' 
ORDER BY ORDINAL_POSITION

-- AS-Is 인덱스 / FK 정의
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('<T>')
```

To-Be 로컬과 비교하여 컬럼 누락 / 타입 차이 / 제약 차이 식별.

---

## §3. 자주 사용하는 진단 쿼리

```sql
-- 1. SP body 추출
SELECT definition FROM sys.sql_modules WHERE object_id = OBJECT_ID('<SP_NAME>')

-- 2. row 수 cross-check (As-Is vs Local)
-- As-Is: SQL Server
SELECT COUNT(*) FROM <table> WHERE <key>='<v>'
-- Local: Oracle
SELECT COUNT(*) FROM SCM_MGR.<table> WHERE <key>='<v>'

-- 3. 컬럼 차이
-- As-Is: INFORMATION_SCHEMA.COLUMNS
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='<T>'
-- Local: USER_TAB_COLUMNS
SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME='<T>'

-- 4. SP 실행 결과 sample
EXEC dbo.<SP_NAME> @p1='...', @p2='...'   -- SELECT only, side-effect 없음 확인
```

---

## §4. 금지 사항

- ❌ DB 오류 발생 시 추측 fix 적용 (예: 가설 변경 후 SP 재컴파일)
- ❌ As-Is 확인 없이 fallback / NULL 처리만 추가
- ❌ "SP body 가 비슷할 것" 가정 — 반드시 byte-level diff
- ❌ DB 오류 발생 사실을 룰 21 §12 에 추가 안 함 (재발 방지 누적 자료)

---

## §5. PR 머지 게이트 자기 점검

- [ ] DB 오류 / 데이터 불일치 fix 시 `_artifacts/{seq}_*.sql` 생성
- [ ] 같은 오류가 룰 21 §12 에 등재됨
- [ ] As-Is SP / table / row 검증 명령이 PR description 에 첨부
- [ ] 단순 fallback (NULL 처리 / try-catch silent) 사용 안 함

---

## §6. 사고 사례 (2026-06-01 DMF0043 11종)

룰 21 §12.1~12.11 참조. 모두 As-Is DB 직접 조회로 원인 확정 + Fix 적용.

| 사고 | As-Is 진단 명령 | Fix |
|---|---|---|
| 화면 0건 | `SELECT COUNT(*) FROM SCM_MST_SITE_ITEM WHERE ATTRIBUTE1 IS NOT NULL AND DIVISION_ID='40'` (18건) | `_artifacts/63/64` import |
| DTL 누락 | `SELECT COUNT(*) FROM DM_MST_CONTRIBUTE_RATIO_DTL WHERE END_CUST_REPORT='Trend Power_01' AND VER_SEQ=12` (96건) | `_artifacts/66` import |
| SP `[col]` 변환 누락 | `SELECT definition FROM sys.sql_modules ...` 직접 비교 | `_artifacts/61` 재변환 |
| SUBSTR offset bug | As-Is `SUBSTRING(s,1,idx-1)` vs To-Be `SUBSTR(s,0,idx)` | `_artifacts/68` 13곳 fix |
