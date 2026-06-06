# Hook — grid-column-meta (Column 메타 표준 자동 검증)

> **트리거**: Grid 컴포넌트 작성 / 메타 SQL BLOCK 6 작성 시
>
> **목적**: 모든 column 의 `_inputEditType` / `_ctrlType` / `_modalKey` 명시 확인

---

## §0 PRE-WRITE 자기 점검

- [ ] BE 메타 SQL (`BLOCK 6 SCM_ADM_MNU_M_SHEET_COLUMNS`) 작성 직전:
  - 모든 column 에 `INPUT_TP_CD` 명시 (O/R/M/IO/IM/D)
  - popup cell 에 `CTRL_TP_CD='FPModal'` + `MODAL_KEY` 명시
  - combo cell 에 `CTRL_TP_CD='COMBO'` + `DATA_MAP` 명시
  - NUMBER cell 에 `CTRL_TP_CD='NUMBER'` + `FORMAT` 명시

- [ ] FE Grid 컴포넌트 작성 시:
  - DataGrid 사용 (FlexGrid 직접 사용 X)
  - dblClick handler 에 binding → modal 분기
  - modal callback 에 EditTracker.storeChange + refreshRange
  - CRUD_TYPE.INSERT 가드 (modal cell)

---

## §1 POST-WRITE grep 검증

### §1.1 BE 메타 SQL

```bash
SQL="_artifacts/{N}_{MENU_ID}_metadata.sql"

# 1. INPUT_TP_CD 명시 (모든 column)
COLS=$(grep -c "INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS" "$SQL")
INPUT_TP_FILLED=$(grep -E "INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS" "$SQL" -A 50 | grep -c "INPUT_TP_CD\s*=\s*'[A-Z]+'")
test "$INPUT_TP_FILLED" -eq "$COLS"

# 2. popup cell 의 MODAL_KEY 의무
grep -E "CTRL_TP_CD\s*=\s*'FPModal'" "$SQL" | grep -v "MODAL_KEY" | wc -l   # = 0

# 3. combo cell 의 DATA_MAP 의무
grep -E "CTRL_TP_CD\s*=\s*'COMBO'" "$SQL" | grep -v "DATA_MAP" | wc -l   # = 0

# 4. width 0 / 음수 검출
grep -E "COL_WIDTH\s*=\s*0\b|COL_WIDTH\s*=\s*-" "$SQL" | wc -l   # = 0
```

### §1.2 FE Grid 컴포넌트

```bash
GRID="features/{domain}/src/pages/{screen}/components/{Name}Grid.tsx"

# 1. DataGrid 사용 (FlexGrid 직접 X)
grep -c "<DataGrid" "$GRID"   # ≥ 1
grep -c "from '@mescius/wijmo.react.grid'" "$GRID"   # = 0

# 2. CRUD_TYPE 가드 (modal cell)
awk '/setOpen.*Modal\(true\)/,/return/' "$GRID" | grep -c "CRUD_TYPE\.\(INSERT\|MODIFY\)"   # ≥ 1

# 3. EditTracker.storeChange + refreshRange (modal callback)
grep -c "editTrackerRef.current?.storeChange" "$GRID"   # ≥ 1 (modal callback 시)
grep -c "refreshRange(new CellRange" "$GRID"   # ≥ 1

# 4. binding 별 분기 (dblClick)
grep -c "binding === " "$GRID"   # ≥ 1 (modal 사용 시)
```

---

## §2 dynamic column 추가 검증 (DMF0007 패턴)

```bash
UTIL="features/{domain}/src/pages/{screen}/utils/{purpose}.ts"
test -f "$UTIL" || exit 0   # dynamic column 없으면 skip

# 1. CELL_INPUT_EDIT_TYPE + CELL_CONTROL_TYPE import (defaultLowerColumnProps)
grep -c "CELL_INPUT_EDIT_TYPE\|CELL_CONTROL_TYPE" "$UTIL"   # ≥ 2

# 2. binding prefix (D_/M_/W_)
grep -E "binding: \`(D_|M_|W_|Q_)" "$UTIL" | wc -l   # ≥ 1

# 3. dayjs.extend(isoWeek) (WEEKLY 사용 시)
grep -c "dayjs.extend(isoWeek)" "$UTIL"   # 1 (WEEKLY) 또는 0 (DAILY/MONTHLY only)
```

---

## §3 적용 룰 cross-ref

| 항목 | 룰 |
|---|---|
| Column meta enum | `_tobe/08_column_meta.md` §1 |
| dynamic column util | `_tobe/08_column_meta.md` §3 + `customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts` |
| BE BLOCK 6 메타 | `_tobe/12_metadata_sql.md` §2.6 |
| DataGrid wrapper | `_tobe/07_datagrid.md` |
| Modal cell + CRUD_TYPE 가드 | `_tobe/07_datagrid.md` §3.5 + 메모리 `feedback_grid_popup_cell_mandatory.md` |
| Editable cell coloring | 메모리 `feedback_grid_editable_coloring_mandatory.md` |

---

## §4 사고 사례 (메모리)

| 사고 | 메모리 | 룰 |
|---|---|---|
| `_inputEditType` 누락 | `feedback_grid_editable_coloring_mandatory.md` | 룰 08 §1.1 |
| popup cell `_ctrlType` / `_modalKey` 누락 | `feedback_grid_popup_cell_mandatory.md` | 룰 08 §1.3 |
| Wijmo FlexGridColumnGroup single-child | `feedback_wijmo_columngroup_jsx_avoid.md` | 룰 07 §3.2 |
| NUMBER → String 변환 누락 (YEAR 콤보) | `feedback_no_type_cast_around_runtime.md` | 룰 07 §3.6 |
| PIVOT frozen column 누락 | `feedback_pivot_frozen_columns.md` | 룰 07 §3.7 |
