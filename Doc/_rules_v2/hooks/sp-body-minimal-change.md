# Hook — Oracle SP body minimal change (원본 1바이트도 변경 금지)

> ⚠ **dual cursor 추가 / EXCEPTION 보강 등 SP signature 변경 작업 시 의무 hook**
> 작성: 2026-06-06 (DMF0020 `ORA-04024 핀 커서 self-deadlock` 사고 후)
> 상위 룰: `Doc/_rules_v2/anti-simplification.md`
> Cross-ref: 메모리 `feedback_sp_body_no_rewrite.md`, `feedback_asis_to_tobe_sp_no_omission.md`

---

## §0. 적용 시점

| 시점 | 행위 |
|---|---|
| **PRE-WRITE** | SP body 변경 의도 명세 작성 — "원본 + 추가 N 줄" 형식만 허용 |
| **WRITE** | DBMS_METADATA.GET_DDL 원본 추출 → 최소 변경 (signature 1줄 + body 1줄) |
| **POST-WRITE** | SP status VALID + audit PASS + 화면 진입 동작 정상 3축 검증 |
| **PRE-SUBMIT** | 위 3축 모두 ✓ 인 경우만 commit |

---

## §1. 의무 절차 (모두 ✓ 필수)

### 1.1 원본 추출

```sql
-- 도커 컨테이너 안에서 SQL*Plus 으로 dump
SET LONG 100000 LONGCHUNKSIZE 32767 PAGESIZE 0 LINESIZE 32767
SET FEEDBACK OFF HEADING OFF VERIFY OFF TRIMSPOOL ON
SPOOL /tmp/{sp_name}.sql
SELECT DBMS_METADATA.GET_DDL('PROCEDURE','{SP_NAME}','SCM_MGR') FROM DUAL;
SPOOL OFF
```

→ docker host 로 `docker cp nscm-oracle:/tmp/{sp_name}.sql ./` 가져와 review.

### 1.2 변경 범위 한정

**허용**:
- ✅ Signature 의 OUT parameter 1줄 추가 (예: `O_RESULT_CURSOR OUT SYS_REFCURSOR`)
- ✅ END 직전 1~2줄 추가 (예: `OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;`)
- ✅ EXCEPTION 블록 추가 (5~10줄 wrapper, 기존 body 변경 X)
- ✅ Header comment 의 History 라인 1줄 추가

**금지**:
- ❌ `DBMS_LOB.APPEND` / `V_SQL` 등 동적 SQL string 변경
- ❌ `OPEN ... FOR V_SQL` 의 `USING` 바인드 변수 변경
- ❌ WHERE 조건 / JOIN / SELECT 절 변경
- ❌ 변수 이름 rename (`P_DEPT_ID` → `P_DEPT` 등)
- ❌ 공백 / 들여쓰기 / 주석 의 임의 정리

**판정 기준**: 변경분이 5줄 초과 시 작업 분리 + 별도 사용자 검토.

### 1.3 적용

```sql
-- /tmp/{sp_name}.sql 원본 + 위 1.2 의 minimal change 만 반영
-- 끝에 `/` terminator 추가
CREATE OR REPLACE EDITIONABLE PROCEDURE SCM_MGR.{SP_NAME}
( ...원본 IN... ,
  O_RC1            OUT SYS_REFCURSOR,
  O_RESULT_CURSOR  OUT SYS_REFCURSOR     -- ⭐ 추가 1줄
) AS
BEGIN
  ...원본 body 그대로...

  OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;  -- ⭐ 추가 1줄
END {SP_NAME};
/
```

### 1.4 PROC_M 동반 보강

```sql
INSERT INTO SCM_MGR.SCM_ADM_PROC_M
  (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT '{SP_NAME}', 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', {N+1}, 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M
                    WHERE PROC_NM='{SP_NAME}' AND COL_NM='O_RESULT_CURSOR' AND COL_TP_CD='OUT');
COMMIT;
```

---

## §2. POST-WRITE 3축 검증 의무

### 2.1 SP status

```sql
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME='{SP_NAME}' AND OBJECT_TYPE='PROCEDURE';
-- STATUS = 'VALID' 의무
```

### 2.2 PROC_M ↔ SP signature 매칭

```sql
SELECT P.PROC_NM, COUNT(*) AS PROC_M_ROWS,
       (SELECT COUNT(*) FROM ALL_ARGUMENTS A WHERE A.OWNER='SCM_MGR' AND A.OBJECT_NAME=P.PROC_NM AND A.PACKAGE_NAME IS NULL) AS SP_ARGS
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM='{SP_NAME}'
 GROUP BY P.PROC_NM;
-- PROC_M_ROWS = SP_ARGS 의무 (PLS-00306 방지)
```

### 2.3 화면 진입 동작 (PR 머지 게이트)

⚠️ **audit PASS 만으로 fix 완료 보고 금지**. 사용자가 화면 직접 진입 + 조회 정상 동작 확인 필요.

- BE 로그 `[selectList] Error` 0건
- BE 로그 `ORA-XXXXX` 0건 (특히 `ORA-04024` 핀 커서 self-deadlock — SP body 결함 의심 시그널)
- FE grid 데이터 정상 표시

---

## §3. 사고 사례 (2026-06-06)

### 사례 1: DMF0020 SP body 임의 재작성 → ORA-04024

**파일**: `_artifacts/88_axis3b_dmf0020_future_m_dual_cursor.sql` (DEPRECATED)

**원인**: `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_M` (200 라인 PIVOT 동적 SQL SP) 의 dual cursor 추가 작업 시 원본 정밀 참조 없이 BASE 서브쿼리 / JOIN / WHERE 조건 / USING 바인드 변수 모두 다르게 임의 작성.

**증상**: `ORA-04024: 핀 커서 self-deadlock 감지` + 화면 조회 0건.

**fix**: `_artifacts/89_axis3b_dmf0020_ROLLBACK_original_body.sql` — 원본 SP body (DBMS_METADATA.GET_DDL 결과 그대로) 복원 + PROC_M O_RESULT_CURSOR row DELETE.

**룰화**: 88 sql 헤더에 ⚠️ DEPRECATED 표시 + 메모리 `feedback_sp_body_no_rewrite.md` 신규 + 본 hook 신규.

---

## §4. POST-WRITE grep 검증 (자동)

```bash
# 작업 SP 의 _artifacts/*.sql 파일에서 원본 보존 여부 확인
# 'CREATE OR REPLACE' 1회만 + 원본 dump 와 diff 5줄 초과 시 경고

ORIGINAL=/tmp/{sp_name}.sql      # DBMS_METADATA.GET_DDL 결과
FIX=_artifacts/{NN}_{purpose}.sql

# 1. CREATE OR REPLACE 횟수 (1회 의무)
grep -cE "^CREATE OR REPLACE" "$FIX"

# 2. 원본 대비 diff line count
diff <(grep -A99999 "CREATE OR REPLACE" "$ORIGINAL") <(grep -A99999 "CREATE OR REPLACE" "$FIX") | grep -cE "^[<>]"
# > 5 시 경고 (이상적 = 2~3, signature + END 직전 추가만)
```

---

## §5. Cross-ref

- 메모리 `feedback_sp_body_no_rewrite.md` — minimal change 표준 + 사고 사례
- 메모리 `feedback_asis_to_tobe_sp_no_omission.md` — AS-IS → TO-BE 변환 1:1 의무
- `Doc/_rules_v2/anti-simplification.md` — 최우선 단순화 금지 룰
- `Doc/_rules_v2/hooks/proc-meta-signature-match.md` — PROC_M ↔ SP signature 일치 의무
- `Doc/_rules_v2/_tobe/12_metadata_sql.md §2.4.1` — Dual OUT Cursor 표준
