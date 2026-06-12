# Hook — UTL_CALL_STACK.SUBPROGRAM 안전 사용

> 적용 trigger: T08 (BE/SP)
> 신설 일자: 2026-06-10 (DMF0008_GET_SALES_SITE Repair 더블클릭 ORA-20001 사고 후)
> 관련 메모리: `feedback_sp_utl_call_stack_safe_pattern.md` + `feedback_exception_handler_hiding_real_error.md`
> 관련 룰: `_tobe/11_be_controller_service.md` + `_tobe/12_metadata_sql.md`

---

## §0 사고 사례 (DMF0008_GET_SALES_SITE, 2026-06-10)

**Symptom**: Repair grid row 더블클릭 시 `ORA-20001: 오류가 발생했습니다. ORA-06512 at line 201`. BE 로그만 보면 line 201 (RAISE_APPLICATION_ERROR) 에 사고. 실제 사고 위치 추적 불가.

**Root cause** (실제 SQLERRM 노출 후 발견):
```
ORA-06533: Subscript beyond count at line 54
```
Line 54:
```sql
v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
```

Line 53 의 사전 check:
```sql
IF UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL THEN
```

→ `SUBPROGRAM(1)(1)` IS NOT NULL 은 **첫 element 만 확인**. Top-level 호출 시 element 1개만 있어서 `(2)` 인덱스 접근 → ORA-06533.

자매 SP `DMF0008_GET_SALES_SITE_PROJECT_MODEL` 는 **`.COUNT > 1`** 안전 체크 패턴 사용 — 변환 일관성 깨짐.

---

## §1 의무 (모든 SP)

| # | 의무 | 위반 시 |
|---:|---|---|
| 1 | `UTL_CALL_STACK.SUBPROGRAM(1)(N)` (N≥2) 접근 전 `.COUNT >= N` 체크 | top-level 호출 시 ORA-06533 |
| 2 | 안전 패턴: `IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN ... (1)(2) ... ELSE $$PLSQL_UNIT END IF` | — |
| 3 | EXCEPTION OTHERS 핸들러는 SQLCODE/SQLERRM 노출 (개발) 또는 PR_SCM_SYS_LOG_BATCH 정상 동작 보장 (운영) | 사고 진단 불가 |

---

## §2 정확한 패턴 (의무)

```sql
DECLARE
  v_program_name VARCHAR2(200) := $$PLSQL_UNIT;
BEGIN
  -- 안전 체크
  IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN
    v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
  END IF;
  -- ... 본문
END;
```

---

## §3 Anti-pattern (금지)

```sql
-- ❌ 사고 패턴 (DMF0008_GET_SALES_SITE 2026-06-10)
IF UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL THEN
   v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);  -- top-level call 시 ORA-06533
END IF;
```

---

## §4 자동 검증 grep (PR 머지 게이트)

```bash
# SP body 작성/변경 시 SUBPROGRAM(1)(2) 또는 그 이상 접근 패턴 + COUNT 체크 부재 검출
SP_FILE="<path-to-sp-body.sql>"

# 1. SUBPROGRAM(1)(N) (N>=2) 접근 인스턴스
INSTANCES=$(grep -nE 'UTL_CALL_STACK\.SUBPROGRAM\(1\)\([2-9]\)' "$SP_FILE" | wc -l)

# 2. 그 위에 .COUNT >= 체크 있는지
SAFE_CHECKS=$(grep -nE 'UTL_CALL_STACK\.SUBPROGRAM\(1\)\.COUNT\s*>=' "$SP_FILE" | wc -l)

if [ "$INSTANCES" -gt 0 ] && [ "$SAFE_CHECKS" -eq 0 ]; then
  echo "❌ ERROR: SUBPROGRAM(1)(N) 접근 $INSTANCES 건 vs .COUNT 체크 0 건 — 안전 패턴 누락"
  grep -nE 'UTL_CALL_STACK\.SUBPROGRAM' "$SP_FILE"
  exit 1
fi

# 3. (1)(1) IS NOT NULL 안티 패턴 (안전 보장 아님)
ANTI=$(grep -nE 'UTL_CALL_STACK\.SUBPROGRAM\(1\)\(1\)\s+IS\s+NOT\s+NULL' "$SP_FILE" | wc -l)
if [ "$ANTI" -gt 0 ]; then
  echo "⚠️ WARN: SUBPROGRAM(1)(1) IS NOT NULL 패턴 $ANTI 건 검출 — .COUNT >= N 으로 변경 권장"
fi
```

**DB 수준 audit (전체 SP 일괄 검사)**:
```sql
-- 안티 패턴 사용 중인 SP 인벤토리
SELECT NAME, LINE, TEXT FROM ALL_SOURCE
 WHERE TYPE = 'PROCEDURE'
   AND UPPER(TEXT) LIKE '%UTL_CALL_STACK.SUBPROGRAM(1)(1)%IS NOT NULL%'
 ORDER BY NAME, LINE;
```

---

## §5 자매 reference (안전 패턴 사용)

| SP | 라인 | 패턴 |
|---|---|---|
| `DMF0008_GET_SALES_SITE_PROJECT_MODEL` | 57 | ✅ `.COUNT > 1` |
| `DMF0008_GET_SALES_SITE` (fix 전) | 53 | ❌ `(1)(1) IS NOT NULL` |
| `DMF0008_GET_SALES_SITE` (fix 후) | 53 | ✅ `.COUNT > 1` |

→ AS-IS → TO-BE 변환 시 자매 SP cross-check 의무. 한 화면 안에서도 SP 별 변환 일관성 깨질 수 있음.

---

## §6 cross-ref

- 메모리 `feedback_sp_utl_call_stack_safe_pattern.md` — 사고 사례 + fix 패턴
- 메모리 `feedback_exception_handler_hiding_real_error.md` — 본 사고 진단 시 EXCEPTION OTHERS 우회 필요
- 메모리 `feedback_sp_body_no_rewrite.md` — SP body 1바이트 변경 의무 (본 fix 도 line 53 만 1줄 변경)
- 룰 21 (`_dev_rules/21_TROUBLESHOOTING.md`) — Oracle 사고 진단 절차
- hook `proc-meta-signature-match.md` — PROC_M signature 일치 (별개 사고)

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-10 | 신규 | DMF0008_GET_SALES_SITE Repair dblClick ORA-20001 사고 — UTL_CALL_STACK 안전 체크 누락 |
