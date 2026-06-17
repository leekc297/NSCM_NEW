# Hook — Column 속성 재작업 의무 점검 (DMF0008/0020/0043/0043_01 4 화면 + 일반)

> ⚠️ **화면 column 속성 재작업 시 누락 없이 적용해야 할 8 점검 의무**
> 신규 화면이 아닌 기존 화면의 column 메타 + dynamic 컬럼 + admin 메타 동기화 + BE 응답 / FE 매칭 / SP NVL 처리까지 통합 점검.

작성: 2026-06-17 (DMF0043 dynamic 컬럼 사고 회고 — 4 화면 (DMF0008/0020/0043/0043_01) 재작업 의도 반영)
관련 hook: `pivot-dynamic-column-nvl.md`, `ui-category-setup-column-meta.md`, `sheet-columns-binding-match.md`, `screen-completion-gate.md`
상위 룰: `anti-simplification.md`

---

## §0. 적용 시점

다음 트리거 시 모든 점검 의무 수행:

| 트리거 키워드 | 적용 |
|---|---|
| "column 속성 재작업", "그리드 컬럼 변경" | 본 hook 8 점검 |
| "DMF0043 column 추가/삭제/변경" | 본 hook + pivot-dynamic-column-nvl |
| "SHEET_COLUMNS 메타 수정" | 본 hook §2.4 + §2.5 |
| "admin UI Category Setup 작업" | 본 hook + ui-category-setup-column-meta |

---

## §1. 사전 인벤토리 (작업 직전 의무)

### 1.1 SP 인벤토리 — 메인 / popup / save SP

```sql
SELECT DISTINCT PROC_NM
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM LIKE '<MENU_ID>%'
 ORDER BY PROC_NM;
```

→ 결과 = 화면이 호출하는 모든 SP 목록 (DMF0043 = 7~9 개).

### 1.2 SHEET_COLUMNS 인벤토리 — admin 메타

```sql
SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, SORT_ORDER_NO, VISIBLE_FLAG,
       COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD, HORIZONTAL_ALIGN_CODE,
       CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, ATTRIBUTE1, DIVISION_ID
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = '<MENU_ID>'
 ORDER BY SHEET_NAME, SORT_ORDER_NO;
```

→ 정확한 컬럼 정의 + sheet name + division.

### 1.3 FE BASE_COLUMNS 인벤토리 — 컴포넌트의 정적 컬럼

```bash
grep -nE "binding: '[A-Z_#]+'," features/<feature>/src/pages/<page>/components/*.tsx
```

→ FE 가 정의한 fixed 컬럼 명 list.

### 1.4 ✅ 인벤토리 차이 매칭 (모두 통과 의무)

| 점검 | 기대값 |
|---|---|
| `SHEET_COLUMNS.COLUMN_NAME` ↔ `BASE_COLUMNS.binding` 일치 | 0 mismatch |
| `SHEET_COLUMNS.SHEET_NAME` ↔ `META_SHEETS.MAIN` 일치 | 정확 일치 |
| `SHEET_COLUMNS.CELL_COMBO_DATA_TYPE` 의 SQL_ID ↔ `SCM_ADM_CMBO_SQL_M` | 0 미등록 |

---

## §2. 적용 단계별 점검 (8 단계)

### 2.1 PIVOT NULL 처리 (dynamic 컬럼 화면) — ⭐ DMF0043 사고 후 의무

> 적용 화면: PIVOT + 동적 SELECT list 모두

`pivot-dynamic-column-nvl.md` §3 의무 패턴 적용:

- ✅ 동적 SELECT list = `NVL(CAST("col" AS NUMBER), 0)`
- ✅ PIVOT 입력 = `MAX(NVL(value, 0))` 또는 `SUM(NVL(value, 0))`
- ✅ Python script 첫 row NULL 카운트 검증 → 0 row 기대값

### 2.2 SP body minimal change

> `sp-body-minimal-change.md` 의무 — 본문 1 byte 라도 임의 재작성 금지.

SP fix 시 변경 line 수 보고:

```
SP DMF0043_GET_CONTRIBUTE_MAIN_DATA — 변경 2 줄 (L147, L149) — NVL wrap
```

### 2.3 SP patch 파일 종결자 + 의존 순서

> `oracle-db-workflow.md` 보강 — patch 파일 `END;` 다음 `/` 는 **별개 라인** 의무.

```sql
END;
/    -- ← 별개 라인 (newline 다음)
```

❌ `END;/` 한 줄 → `/` 가 body 안 포함 → INVALID

객체 의존 순서 (사고 사례 DMF0043 2026-06-17):
- CONTRIBUTE_MAIN_DATA → MAIN_SPREAD_TITLE 호출 → 후자 먼저 CREATE 후 전자 CREATE
- 또는 통합 SQL 끝에 fallback `ALTER PROCEDURE ... COMPILE;` 블록 의무

### 2.4 admin SHEET_COLUMNS 메타 동기화

> `ui-category-setup-column-meta.md` 의무.

FE store 의 `staticColumns` + `fetchStaticColumns` mount + search refetch + DataGrid prop 5 단계 의무. 화면 코드 안 하드코딩 column 배열 금지.

### 2.5 BE 응답 vs FE BASE_COLUMNS 매칭

> `sheet-columns-binding-match.md` 의무.

BE 응답의 `colNm` ↔ FE BASE_COLUMNS `binding` 매칭 0 mismatch 의무. 사고 패턴:

| 사고 | 원인 | fix |
|---|---|---|
| DMF0043 사내 SP cursor `DEPARTMENT_ID` vs FE BASE_COLUMNS `DEPARTMENT_NAME` | SP alias 변경 후 FE 미동기 | FE binding 갱신 |
| DMF0043_01 SHEET_NAME 다름 | constants 의 META_SHEETS 누락 | constants 갱신 |

### 2.6 DataGrid wrapper 전역 prop 영향

> 메모리 `feedback_shared_global_prop_change_forbidden.md`.

`packages/shared/**` 의 prop default 변경 금지. 화면별 fix 가 답.

### 2.7 메모리 + hook 기반 anti-simplification

> 컬럼명 추측 절대 금지. DDL 의무 grep:

```bash
python _artifacts/_diagnostics/ora.py desc <TABLE_NAME>
```

→ 모든 SQL 작성 전 DDL 정확 확인 의무. ORA-00904 발생 = 룰 위반.

### 2.8 클라우드 적용 후 cursor 검증

> SP patch 적용 후 다음 검증 의무:

```sql
-- LAST_DDL 갱신 + INVALID 확인
SELECT OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS')
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE '<PREFIX>%';

-- USER_ERRORS 확인
SELECT NAME, LINE, POSITION, TEXT FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME LIKE '<PREFIX>%';

-- Cursor 컬럼 개수 + dynamic 검증 (Python)
python _artifacts/_diagnostics/test_<sp>_first_row_null.py
```

---

## §3. 4 화면 핵심 비교표 (재작업 진입 시 참조)

| 화면 | MNU_ID | PIVOT | dynamic 컬럼 패턴 | NVL 처리 |
|---|---|---|---|---|
| Customer FCST Summary/Repair/SSPM | DMF0008 | ✅ | `<measure>` (예 RTF_SYS_RP) | 검토 필요 |
| Sales Future Price | DMF0020 | ✅ | `W_YYYYMMDD` | ✅ 적용됨 (기준선) |
| Contribute Main | DMF0043 | ✅ | `Y#YYYY#CODE`, `M#YYYYMM#CODE` | ✅ 2026-06-17 fix |
| Contribute View | DMF0043_01 | ✅ (via SalesList) | `Y#YYYY#CODE`, `M#YYYYMM#CODE` | 검토 필요 |

**재작업 시 의무**:
1. DMF0008 / DMF0043_01 의 SP body NVL 확인 → 없으면 §3.1 fix 적용
2. 4 화면 모두 SHEET_COLUMNS 메타 ↔ FE BASE_COLUMNS binding 매칭 0 mismatch 확인
3. 각 화면 메인 SP `python test_*_first_row_null.py` 실행 → 0 NULL 기대값
4. 클라우드 patch 적용 후 화면 검증 (Network 탭 + 화면 표시)

---

## §4. 자기 점검 8 항목

```
[ ] 1. 메인 SP 인벤토리 (SCM_ADM_PROC_M 조회) → 화면 호출 SP 모두 식별
[ ] 2. SHEET_COLUMNS 메타 인벤토리 (DDL 정확 컬럼명 사용)
[ ] 3. FE BASE_COLUMNS binding ↔ SHEET_COLUMNS.COLUMN_NAME 매칭
[ ] 4. PIVOT SP 의 NVL 처리 (§2.1) — 첫 row NULL 카운트 0 검증
[ ] 5. SP patch 파일 종결자 (`END;` 다음 줄 `/`) + 의존 순서 / fallback ALTER COMPILE
[ ] 6. admin staticColumns mount/refetch 5 단계 (ui-category-setup-column-meta.md)
[ ] 7. shared/* 공용 컴포넌트 전역 prop 변경 0 건
[ ] 8. 클라우드 적용 후 사후 검증 (INVALID 0 / USER_ERRORS 0 / Cursor NULL 0)
```

→ 1건이라도 ❌ 시 **사용자에게 보고 + 보강 후 재진행**.

---

## §5. 관련 hook / 메모리

- `pivot-dynamic-column-nvl.md` — PIVOT NULL 처리 의무 (DMF0043 root cause)
- `sp-body-minimal-change.md` — SP body 최소 변경
- `ui-category-setup-column-meta.md` — admin 메타 동기화
- `sheet-columns-binding-match.md` — BE/FE 컬럼명 매칭
- `oracle-db-workflow.md` — Oracle 작업 전반
- `anti-simplification.md` — DDL 추측 금지 (최우선)
- `screen-completion-gate.md` — 화면 종료 8 게이트
- 메모리 `feedback_be_no_modification_rule.md` — BE 변경 절대 금지
- 메모리 `feedback_shared_global_prop_change_forbidden.md` — shared/* 전역 변경 금지
