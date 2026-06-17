# Hook — PIVOT dynamic 컬럼 NULL → NVL wrap 의무

> ⚠️ **PIVOT + 동적 컬럼 SP 작성 시 SELECT list NVL wrap 의무**
> MyBatis 의 기본 설정 (`callSettersOnNulls=false`) 환경에서 cursor 첫 row 의 NULL column setter 호출 skip → JSON 응답 키 누락.
> 클라우드 BE 빌드 시점 차이로 인한 사고 빈번 — SP 측에서 fallback 보장 필요.

작성: 2026-06-17 (DMF0043 dynamic 컬럼 클라우드 응답 누락 사고 후)
관련 메모리: `feedback_shared_global_prop_change_forbidden.md`, `feedback_be_no_modification_rule.md`
상위 룰: `anti-simplification.md`

---

## §0. 배경 — DMF0043 사고 (2026-06-17)

| 항목 | 사내 | 클라우드 |
|---|---|---|
| MyBatis `callSettersOnNulls=true` | ✅ commit eb1686c (2026-06-01) | ❌ commit 이전 빌드 |
| SP cursor 129 컬럼 | ✅ | ✅ (동일) |
| 응답 JSON Y#/M# 키 | 포함 ✅ | **누락 ❌** |

**근본 원인**: DMF0043 SP 의 동적 SELECT list 가 `CAST("col" AS NUMBER(5,2))` 으로 wrap → PIVOT 결과 NULL 가능. callSettersOnNulls=false BE 가 NULL column setter 호출 skip → result Map 에 key 누락 → JSON 응답에서 빠짐.

**비교 — DMF0020 (같은 클라우드에서 정상)**:
- L988: `SUM(NVL(PRICE, 0))` → PIVOT 입력값 0 보장 → 결과 NULL 거의 없음
- → 모든 dynamic 컬럼이 첫 row 에 값 보유 → setter 호출 → key 응답 포함

---

## §1. 적용 시점

다음 SP 작성/변경 시 **SELECT list NVL wrap 의무**:

| 트리거 | 예 |
|---|---|
| 동적 PIVOT IN list 사용 | `PIVOT (MAX(col) FOR x IN (' || v_list || '))` |
| 동적 SELECT 컬럼 생성 | `'CAST("' || r.col || '" AS NUMBER) AS "' || r.col || '"'` |
| EXECUTE IMMEDIATE 안 PIVOT | `v_query := '... PIVOT ...'; OPEN o_rc FOR v_query;` |
| dynamic CURSOR 의 column metadata | 클라이언트가 컬럼 개수 모르고 받는 모든 SP |

---

## §2. 절대 금지 패턴 (사고 재현)

```sql
-- ❌ PIVOT 입력값 NVL 없음
PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_pivot_list || '))

-- ❌ 동적 SELECT list NVL 없음
v_seg := 'CAST("' || r.COLUMN_NAME || '" AS NUMBER(5,2)) AS "' || r.COLUMN_NAME || '"';
v_seg := '"' || r.COLUMN_NAME || '"';
```

→ NULL 결과 가능 → callSettersOnNulls=false BE 가 key skip.

---

## §3. 의무 패턴 (cloud-safe)

### 3.1 동적 SELECT list — 모든 dynamic 컬럼 NVL wrap

```sql
-- ✅ NUMBER 컬럼
v_seg := 'NVL(CAST("' || r.COLUMN_NAME || '" AS NUMBER(5,2)), 0) AS "' || r.COLUMN_NAME || '"';

-- ✅ VARCHAR 컬럼
v_seg := 'NVL("' || r.COLUMN_NAME || '", ''-'') AS "' || r.COLUMN_NAME || '"';

-- ✅ DATE 컬럼 (필요 시)
v_seg := 'NVL("' || r.COLUMN_NAME || '", DATE ''1900-01-01'') AS "' || r.COLUMN_NAME || '"';
```

### 3.2 PIVOT 입력값 — 가능 시 NVL 우선

```sql
-- ✅ DMF0020 패턴 (PIVOT 입력값 미리 0 변환)
PIVOT (MAX(NVL(PRICE, 0)) FOR YYYYMMDD IN (' || v_list || '))
PIVOT (SUM(NVL(PRICE, 0)) FOR YYYYMMDD IN (' || v_list || '))
```

→ PIVOT 입력에서 NULL 제거하면 outer SELECT NVL 불필요. 두 방법 중 하나만 적용해도 충분.

---

## §4. 검증 절차

### 4.1 첫 row NULL 카운트 직접 측정

진단 스크립트 (Python):

```python
# _artifacts/_diagnostics/test_{sp_name}_first_row_null.py
import os, oracledb
with oracledb.connect(user=..., password=..., dsn=...) as con:
    cur = con.cursor()
    rc = con.cursor()
    cur.callproc("<SP_NAME>", [..., rc])
    cols = [c[0] for c in rc.description]
    dyn = [(i, c) for i, c in enumerate(cols) if c.startswith('Y#') or c.startswith('M#') or c.startswith('W_')]
    rows = rc.fetchmany(1)
    null_cnt = sum(1 for i, _ in dyn if rows[0][i] is None)
    print(f"First row dynamic NULL count: {null_cnt} / {len(dyn)}")
```

기대값: **NULL count = 0** (모든 dynamic 컬럼이 첫 row 에 값 보유).

### 4.2 비교 기준선 — DMF0020 SP body

DMF0020 (`DMF0020_GET_SCM_MST_FUTURE_PRICE`) L988-989 + L1113/1130 = NVL 적용된 표준 패턴.

### 4.3 PR 직전 자동 grep

```bash
# 신규/변경 SP 안 PIVOT + NVL 누락 검출
grep -nE "PIVOT\s*\(\s*(MAX|SUM)\s*\(\s*[A-Z_]+\s*\)" path/to/sp.sql | grep -v "NVL"

# 동적 SELECT list 안 NVL 누락
grep -nE "CAST\(.*AS NUMBER.*\) AS" path/to/sp.sql | grep -v "NVL"
```

→ 결과 0 row 가 기대값.

---

## §5. 화면 의미 영향 — NULL vs 0 구분

NVL 적용 후 **NULL (미등록)** 과 **0 (등록된 0 값)** 시각 구분 사라짐. 화면별 검토:

| 화면 | NULL 의미 | 0 의미 | 통합 영향 |
|---|---|---|---|
| DMF0043 | 기여율 미등록 | 0% 기여율 | 화면이 이미 NULL 시 미표시 → NVL=0 으로 변환 시 동작 동일 |
| DMF0020 | (이미 NVL 적용) | - | - |
| DMF0008 | 미등록 forecast | 0 수량 | 검토 필요 |

→ 화면 비즈니스 의미 검토 후 NVL 의 default 값 결정. 일반적으로:
- 숫자 컬럼: `NVL(..., 0)`
- 코드/string 컬럼: `NVL(..., '-')`
- 날짜: `NVL(..., DATE '1900-01-01')`

---

## §6. 사고 사례 — DMF0043 첫 row NULL 검증 결과

### Before fix (NVL 미적용)

```
First row dynamic col NULL count:
  Y# total=9 NULL=일부  valued=일부
  M# total=108 NULL=일부 valued=일부
→ 클라우드 응답 JSON 에서 Y#/M# 키 누락
```

### After fix (NVL 적용, 2 줄 변경)

```
First row dynamic col NULL count:
  Y# total=9 NULL=0 valued=9   ✅
  M# total=108 NULL=0 valued=108 ✅
→ 클라우드 응답 JSON 에 모든 키 포함
```

---

## §7. 관련 룰

- `sp-body-minimal-change.md` — SP 변경 시 minimal change 의무
- `sp-no-fake-data-extraction.md` — SP 데이터 추출 시 정밀 작업
- `oracle-db-workflow.md` — Oracle 작업 전반 진입점
- `anti-simplification.md` — DDL/SP body 추측 금지
- 메모리 `feedback_be_no_modification_rule.md` — BE 변경 금지 정책 안에서 SP fix 우선
