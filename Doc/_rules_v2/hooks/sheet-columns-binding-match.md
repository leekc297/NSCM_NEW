# Hook — SHEET_COLUMNS binding ↔ SP 반환 컬럼 일치 의무 + 하드코딩 staticColumns 금지

> **트리거**: 신규 화면 SHEET_COLUMNS 등록 또는 grid sub-component 작성 시
>
> **목적**: `SCM_MST_SHEET_COLUMNS.COLUMN_NAME` (FE binding) 이 SP 반환 컬럼명과 정확 일치하도록 강제 + 하드코딩 `[{binding,header,width}]` 안티 패턴 차단

작성: 2026-06-09 (SCM0005 Dynamic Query 4 grid 사고: cell 값 빈 칸 + grid column 0개)
관련 룰: `_tobe/07_datagrid.md`, `_tobe/12_metadata_sql.md`
상위 룰: `anti-simplification.md`

---

## §0. 사고 (2026-06-09)

### §0.1 사고 #1: SHEET_COLUMNS 0건 → grid column 0개

```typescript
// ❌ DynamicQueryMainGrid (SCM0005) — 하드코딩 staticColumns
<DataGrid
  staticColumns={[
    { binding: 'QUERY_ID', header: 'Query ID', width: 100 },
    ...
  ]}
/>
```

DataGrid wrapper 의 `mapRawColumnsToWijmoColumns(staticColumns.filter(c => c.display))` 가 `display='Y'` 인 column 만 통과시킴. 하드코딩 형식 (`binding/header/width`) 은 `display` 필드 없음 → filter 통과 0건 → **column 0개 렌더**.

### §0.2 사고 #2: SHEET_COLUMNS binding ↔ SP 반환 컬럼 mismatch → cell 값 빈 칸

```
SHEET_COLUMNS (SYS0013/columns):
  COLUMN_NAME = COL_NM / COL_HEADER / DATA_TYPE / WIDTH / SORT_ORD   ← 임의 명명

SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS 반환:
  COLUMN_NAME / VALUE_YN / VALUE_TYPE / VALID_YN / CREATED_BY / ...  ← 실제
```

→ Wijmo binding `COL_NM` 으로 row['COL_NM'] 찾음 → undefined → **cell 빈 칸** (row 는 추가됨, 값만 안 보임).

---

## §1. 의무 패턴

### §1.1 SHEET_COLUMNS.COLUMN_NAME = SP 반환 컬럼명 (case-sensitive)

| 항목 | 의무 |
|---|---|
| `SHEET_COLUMNS.COLUMN_NAME` | SP `OPEN cursor FOR SELECT ... AS XXX` 의 alias 와 정확히 일치 |
| 대소문자 | Wijmo binding 은 case-sensitive (`COLUMN_NAME ≠ column_name`) |
| SP alias 누락 시 | `SELECT A.COLUMN_NAME` 만 있으면 BE 응답 key 가 `COLUMN_NAME` (Oracle 기본 대문자) |
| SP alias 명시 시 | `SELECT a.col AS USER_NAME` → BE 응답 key 는 `USER_NAME` |

### §1.2 SP 반환 컬럼 인벤토리 추출 SQL

```sql
-- 모든 SP 의 SELECT alias 추출
SELECT NAME, TEXT
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR'
   AND NAME = 'P_{MENU_ID}_{ACTION}'
   AND UPPER(TEXT) LIKE '%SELECT%'
 ORDER BY LINE;
```

또는 실제 호출 후 BE log 의 `@o_rc1: [{...}]` JSON 의 key 인벤토리 확인.

### §1.3 하드코딩 staticColumns 금지

```typescript
// ❌ 금지 — 하드코딩 {binding, header, width}
<DataGrid staticColumns={[{ binding: 'X', header: 'X', width: 100 }]} />
```

```typescript
// ✅ 의무 — store fetchStaticColumns + SHEET_COLUMNS 메타
const staticColumns = useStore(s => s.staticColumns[SHEETS.MAIN]);
<DataGrid staticColumns={staticColumns} />
```

→ DataGrid wrapper 의 `RawFlexGridColumnConfig` 형식 (DISPLAY_FLAG='Y' 포함) 자동 통과.

---

## §2. PRE-WRITE 자기 점검

```
☐ SP body 의 OPEN cursor FOR SELECT alias 모두 추출?
☐ SHEET_COLUMNS INSERT 의 COLUMN_NAME 이 SP alias 와 정확 일치 (대소문자 포함)?
☐ Grid sub-component 가 store fetchStaticColumns 사용 (하드코딩 금지)?
☐ 동적 컬럼 (사용자 SQL 결과 등) 인 경우 useMemo + data[0] keys 패턴?
```

---

## §3. POST-WRITE 자동 검증

### §3.1 SHEET_COLUMNS 등록 후 SP 호출 결과 비교

```sql
-- SHEET_COLUMNS 의 binding 인벤토리
SELECT SHEET_NAME, COLUMN_NAME
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0013'
 ORDER BY SHEET_NAME, SORT_ORDER_NO;

-- BE log 확인: { "@o_rc1": [{ "COLUMN_NAME":"x", "VALUE_YN":"Y", ... }] }
-- 위 2 인벤토리 diff = 0 의무
```

### §3.2 FE grep — 하드코딩 staticColumns 검출

```bash
# 위반 패턴 검출 (staticColumns 안에 binding 하드코딩)
grep -rE "staticColumns=\{\[\s*\{\s*binding:" nscm-fe/features/

# 결과 = 0 의무 (모두 store 사용)
```

### §3.3 동적 컬럼 패턴 검증

```bash
# Dynamic SQL 결과처럼 컬럼이 user 입력에 따라 달라지는 grid 는
# useMemo + data[0] keys 패턴 사용 의무
grep -nE "useMemo.*Object\.keys" nscm-fe/features/.../{GridName}.tsx
```

---

## §4. PR 머지 게이트

- [ ] 모든 grid 가 store-fetched `staticColumns` 또는 useMemo dynamic columns 사용
- [ ] SHEET_COLUMNS 등록 화면 = SP 반환 컬럼 alias 와 정확 일치
- [ ] `__asis-mapping__.md` 의 `## Grid 컬럼 매핑` 표에 SP 반환 컬럼 vs SHEET_COLUMNS binding 매핑 명시

---

## §5. cross-ref

| 항목 | 룰 |
|---|---|
| DataGrid wrapper 의 `mapRawColumnsToWijmoColumns` | `packages/shared/src/components/organisms/data-grid/DataGrid.tsx:98` |
| RawFlexGridColumnConfig 형식 | `@foundation/models` |
| dual cursor 표준 | hook `sp-dual-cursor-pattern.md` |
| 동적 컬럼 useMemo 패턴 | 룰 07 §11 (신규) |
| 메모리 | `feedback_sheet_columns_binding_must_match_sp`, `feedback_grid_no_hardcoded_static_columns` |

---

## §6. 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-09 | 초안 작성 | SCM0005 DynamicQuery 4 grid 사고 (cell 빈 칸 + column 0개) |
