# TO-BE 룰 08 — Column Meta (`_inputEditType` / `_ctrlType` / `_modalKey`)

> **추출 reference**: `@foundation/constants` 의 CELL_INPUT_EDIT_TYPE / CELL_CONTROL_TYPE + DMF0007 dateColumns + 메모리 `feedback_grid_editable_coloring_mandatory.md` / `feedback_grid_popup_cell_mandatory.md`

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 08 |
| 토픽 | column meta (`_inputEditType` / `_ctrlType` / `_modalKey` / `_display` / `dataMap`) |
| 적용 trigger | grid column 정의 / staticColumns / dynamicColumns |
| 관련 hook | `grid-column-meta.md` |

---

## §1 표준 column meta 인벤토리 (의무)

### §1.1 `_inputEditType` (편집 가능성)

```typescript
import { CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
```

| enum | 의미 | cell coloring | AS-IS 매핑 |
|---|---|---|---|
| `CELL_INPUT_EDIT_TYPE.OPTIONAL` (O) | 편집 가능 (optional) | `.wj-cell-editable` (#fff8cd 노란색) | UsrSpread 편집 cell |
| `CELL_INPUT_EDIT_TYPE.REQUIRED` (R) | 편집 가능 (필수) | 동일 + required indicator | required column |
| `CELL_INPUT_EDIT_TYPE.MODIFY` (M) | 수정만 (insert 불가) | 편집 가능 (조건부) | LockColumn INSERT |
| `CELL_INPUT_EDIT_TYPE.INSERT_ONLY` (IO) | 입력만 (수정 불가) | INSERT 시만 편집 | LockRange UPDATE |
| `CELL_INPUT_EDIT_TYPE.INSERT_MODIFY` (IM) | 입력 + 수정 가능 | 항상 편집 가능 | (편집 cell) |
| `CELL_INPUT_EDIT_TYPE.DISABLED` (D) 또는 미명시 | 조회만 | `.wj-cell-non-editable` (#f1f4f3 회색) | LockColumn 전체 |

> **의무 (메모리 `feedback_grid_editable_coloring_mandatory.md`)**: 모든 column 에 `_inputEditType` 명시. 미명시 = 자동 회색 (조회). DataGrid wrapper 가 `formatItem` 자동 처리 — FlexGrid 직접 사용 시 수동 작성 필요.

### §1.2 `_ctrlType` (편집 컨트롤 타입)

```typescript
import { CELL_CONTROL_TYPE } from '@foundation/constants';
```

| enum | 의미 | AS-IS 매핑 |
|---|---|---|
| `CELL_CONTROL_TYPE.TEXT` | 일반 텍스트 입력 | 기본 cell |
| `CELL_CONTROL_TYPE.NUMBER` | 숫자 입력 (포맷 자동) | UsrQtyEditor / AddNumColumn |
| `CELL_CONTROL_TYPE.COMBO` | dropdown (dataMap 사용) | SetCellTypeCombo |
| `CELL_CONTROL_TYPE.CHECKBOX` | 체크박스 | CheckBoxCellType |
| `CELL_CONTROL_TYPE.DATE` | 날짜 picker | DateCellType |
| `CELL_CONTROL_TYPE.FPModal` | popup modal cell | cellTypeImage |
| `CELL_CONTROL_TYPE.MASKED` | 마스크된 입력 (Y/N) | MaskCellType |

### §1.3 `_modalKey` (popup cell 의 modal 종류)

```typescript
{ binding: 'PROJECT_CODE', _ctrlType: CELL_CONTROL_TYPE.FPModal, _modalKey: 'PROJECT' }
```

| `_modalKey` | 호출 modal (TO-BE 공용) |
|---|---|
| `'PROJECT'` | `ProjectByDivisionModal` |
| `'ITEM'` | `ItemByDivisionModal` |
| `'OWNER'` | `OwnerByDivisionModal` |
| `'CUSTOMER'` | `CustomerModal` |
| `'TEAM'` | `TeamModal` |
| `'STORAGE'` | `StorageLocationModal` |
| `'REGION'` | `RegionModal` |
| `'SOLDTO'` | (Phase 5 G11 신규 SoldtoByDivisionModal) |

### §1.4 기타 column meta

| meta | 의미 | 예 |
|---|---|---|
| `binding` | 데이터 컬럼 명 (필수) | `'PROJECT_CODE'` |
| `header` | 헤더 텍스트 (i18n) | `t('LBL00327')` 또는 hard text |
| `width` | 픽셀 너비 | `100` |
| `align` | 정렬 | `'center' / 'left' / 'right'` |
| `format` | 표시 포맷 | `'#,##0.00'` (NUMBER), `'YYYY-MM-DD'` (DATE) |
| `allowSorting` | 정렬 허용 | `true` (default) / `false` |
| `allowMerging` | 머지 허용 | `false` (default) / `true` |
| `allowResizing` | 너비 조절 허용 | `true` (default) |
| `allowDragging` | column 이동 허용 | `true` (default) |
| `visible` | 표시 여부 | `true` (default) |
| `isRequired` | 필수 입력 (저장 시 검증) | `false` (default) |
| `dataMap` | combo options (string array 또는 객체) | `['Y', 'N']` |
| `_display` | display only (저장 안 함) | `true` / `false` (default) |
| `columns` | sub-column (multi-row header) | `[{...}, {...}]` |

### §1.5 multi-row header (2 row)

```typescript
{
  header: 'YYYY-MM (group)',   // 1 row (상단)
  align: 'center',
  columns: [
    {
      binding: 'D_20260301',
      header: '3/1',           // 2 row (하단)
      // ... 다른 meta
    },
  ],
}
```

→ DMF0007 의 dateColumns 표준 (utils/CustomerFcstMasterDateColumns.ts).

---

## §2 표준 column 정의 (BE 메타)

### §2.1 BE response (`/admin/menu/{menuId}/column`) 형식

```typescript
// RawFlexGridColumnConfig (from @foundation/models)
interface RawFlexGridColumnConfig {
  binding: string;
  header: string;
  width?: number;
  align?: 'left' | 'center' | 'right';
  format?: string;
  visible?: boolean;
  isRequired?: boolean;
  _inputEditType?: CELL_INPUT_EDIT_TYPE;
  _ctrlType?: CELL_CONTROL_TYPE;
  _modalKey?: string;
  _display?: boolean;
  dataMap?: string[] | { value: string; label: string }[];
  columns?: RawFlexGridColumnConfig[];
  // ... 다른 wijmo 표준 props
}
```

### §2.2 BE column meta 등록 (메타 SQL — 룰 12 cross-ref)

`SCM_ADM_MNU_M_SHEET_COLUMNS` 테이블 (이름 변경 가능) 에 row 단위 등록:

```sql
INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS (MNU_ID, SHT_NM, COL_NM, COL_HEAD, COL_WIDTH, COL_ALIGN, 
    INPUT_TP_CD, CTRL_TP_CD, MODAL_KEY, IS_REQUIRED, IS_DISPLAY, ...) 
VALUES ('DMF0006', 'customerModelMapping', 'PROJECT_CODE', 'Project Code', 100, 'center', 
    'IO', 'FPModal', 'PROJECT', 'Y', 'N', ...);
```

→ BE Controller 가 row 를 `RawFlexGridColumnConfig` 로 변환 후 응답.

---

## §3 dynamic column 표준 (DMF0007)

### §3.1 동적 column 생성 패턴

```typescript
// utils/{name}DateColumns.ts
import { CELL_CONTROL_TYPE, CELL_INPUT_EDIT_TYPE } from '@foundation/constants';
import dayjs from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
import type { FlexGridColumnConfig } from '@foundation/models';

dayjs.extend(isoWeek);

const defaultUpperColumnProps: FlexGridColumnConfig = {
  header: '',
  align: 'center',
  columns: [],
};

const defaultLowerColumnProps: FlexGridColumnConfig = {
  binding: '',
  header: '',
  align: 'center',
  allowDragging: true,
  allowMerging: false,
  allowResizing: true,
  allowSorting: false,
  width: 70,
  visible: true,
  _inputEditType: CELL_INPUT_EDIT_TYPE.OPTIONAL,
  _ctrlType: CELL_CONTROL_TYPE.COMBO,
  _display: true,
  dataMap: ['Y', 'N'],
  isRequired: false,
};

export const getFcstRangeByBucket = (bucket: string): FlexGridColumnConfig[] => {
  const dateColumnGroups: FlexGridColumnConfig[] = [];
  let startDate = dayjs();
  
  if (bucket === 'DAILY') {
    const endDate = dayjs().add(12, 'month');
    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: startDate.format('ddd').toUpperCase(),     // 요일 (MON/TUE)
        columns: [{
          ...defaultLowerColumnProps,
          header: startDate.format('M/D'),                  // 일자 (3/1)
          binding: `D_${startDate.format('YYYYMMDD')}`,    // binding D_20260301
        }],
      });
      startDate = startDate.add(1, 'day');
    }
  } else if (bucket === 'WEEKLY') {
    // ISO week 사용 (`dayjs.extend(isoWeek)`)
    const endDate = dayjs().add(30, 'month');
    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: `${startDate.isoWeekYear()}${String(startDate.isoWeek()).padStart(2, '0')}`,
        columns: [{
          ...defaultLowerColumnProps,
          header: startDate.startOf('isoWeek').format('M/D'),
          binding: `D_${startDate.startOf('isoWeek').format('YYYYMMDD')}`,
        }],
      });
      startDate = startDate.add(1, 'week');
    }
  } else if (bucket === 'MONTHLY') {
    const endDate = dayjs().add(30, 'month');
    while (startDate.isBefore(endDate) || startDate.isSame(endDate)) {
      dateColumnGroups.push({
        ...defaultUpperColumnProps,
        header: startDate.format('YYYY-MM'),
        columns: [{
          ...defaultLowerColumnProps,
          header: startDate.startOf('month').format('M/D'),
          binding: `D_${startDate.startOf('month').format('YYYYMMDD')}`,
        }],
      });
      startDate = startDate.add(1, 'month');
    }
  }
  
  return dateColumnGroups;
};
```

### §3.2 사용 패턴

```typescript
// store
interface State {
  dateColumns: FlexGridColumnConfig[];
}

fetchDateColumns: () => {
  const result = getFcstRangeByBucket(get().searchParams.bucketType);
  set(state => { state.dateColumns = result; });
}

// Grid
<DataGrid
  staticColumns={staticColumn}
  dynamicColumns={dateColumns}    // ⭐
  ...
/>
```

### §3.3 dynamic column binding 규약

| 형식 | 의미 |
|---|---|
| `D_YYYYMMDD` | 일자 column (DAILY/WEEKLY/MONTHLY 모두) |
| `M_YYYYMM` | 월 column (월 단위 화면) |
| `W_YYYYWW` | 주 column (주 단위 화면) |
| `Q_YYYYQ` | 분기 column |

→ AS-IS Spread 의 `AddNumColumn` + `ColumnHeaderSpan` 동등. wide table 데이터 — save 시 `buildPivotedRow` 로 long format 변환 (룰 03 §2.4 cross-ref).

---

## §4 금지 (anti-pattern)

### §4.1 `_inputEditType` 미명시

**금지**:
```typescript
{ binding: 'X', header: 'X' }   ❌ → 자동 회색 (조회) — 의도와 다를 수 있음
```

**의무**: 모든 column 에 명시 (편집 의도 명확화).

### §4.2 popup cell 에 `_ctrlType` / `_modalKey` 미명시

**금지** (메모리 `feedback_grid_popup_cell_mandatory.md`):
```typescript
{ binding: 'PROJECT_CODE', _inputEditType: 'IO' }   ❌ Modal 호출 안 됨
```

**의무**:
```typescript
{
  binding: 'PROJECT_CODE',
  _inputEditType: CELL_INPUT_EDIT_TYPE.INSERT_ONLY,
  _ctrlType: CELL_CONTROL_TYPE.FPModal,
  _modalKey: 'PROJECT',
}
```

+ Grid 컴포넌트에 dblClick handler + `_modalKey` 별 modal 분기 (룰 07 §1).

### §4.3 dataMap 누락 (combo cell)

**금지**:
```typescript
{ binding: 'VALID_YN', _ctrlType: CELL_CONTROL_TYPE.COMBO }   ❌ dataMap 없음 → dropdown 빈 list
```

**의무**:
```typescript
{
  binding: 'VALID_YN',
  _ctrlType: CELL_CONTROL_TYPE.COMBO,
  dataMap: ['Y', 'N'],   // 또는 [{value, label}, ...]
}
```

### §4.4 isRequired + null 저장

**금지**:
```typescript
{ binding: 'PROJECT_CODE', isRequired: true }   // 그러나 save 시 null 허용
```

**의무**: `useSaveWithValidation` 이 isRequired column 의 null/빈 값 자동 검증 + 사용자 alert. PR 머지 게이트.

### §4.5 width 0 또는 음수

**금지**: `width: 0` (보이지 않는 column 은 `visible: false` 사용).

**의무**: `width: 최소 50` 또는 `visible: false`.

### §4.6 동적 column 의 binding 충돌

**금지**: dynamic column 의 binding 이 static column 과 겹침.

**의무**: dynamic column 은 prefix (`D_` / `M_` / `W_`) 사용 → static 과 분리.

---

## §5 자동 검증 (PR 머지 게이트)

```bash
# BE 메타 SQL 안 검증
SQL="_artifacts/{N}_{MENU_ID}_metadata.sql"

# 1. _inputEditType (INPUT_TP_CD) 명시
grep -c "INPUT_TP_CD" "$SQL"  # ≥ column 수 (모두 명시)

# 2. popup cell 의 modal_key 명시
grep -E "CTRL_TP_CD.*FPModal" "$SQL" | grep -v "MODAL_KEY" | wc -l  # = 0

# 3. dataMap 명시 (combo cell)
grep -E "CTRL_TP_CD.*COMBO" "$SQL" | grep -v "DATA_MAP" | wc -l  # = 0

# 4. FE dynamic column binding 충돌
STATIC=$(rg -oE "binding: '\w+'" features/{domain}/src/pages/{screen}/ | sort -u)
DYNAMIC_PREFIX=$(rg -oE "binding: \`D_" features/{domain}/src/pages/{screen}/ | wc -l)
# STATIC 의 binding 이 D_ 시작 = 0
```

---

## §6 AS-IS 매핑

| AS-IS Spread | TO-BE column meta |
|---|---|
| `siMain.LockColumn(col, true)` | `_inputEditType: 'D'` (DISABLED) — 회색 cell |
| `siMain.LockColumn(col, false)` | `_inputEditType: 'O'` (OPTIONAL) — 노란색 cell |
| `siMain.LockRange2(row, col, lockColor)` | (TO-BE column meta + CRUD_TYPE 자동) |
| `SetCellTypeCombo(col, items)` | `_ctrlType: 'COMBO'` + `dataMap` |
| `AddNumColumn(col, format)` | `_ctrlType: 'NUMBER'` + `format` |
| `cellTypeImage` (popup icon) | `_ctrlType: 'FPModal'` + `_modalKey` |
| `ColumnHeaderSpan(span)` (multi-row header) | `columns: [...]` (sub-column) |
| `SetSpreadColumn(dt)` (동적 column) | `dynamicColumns` prop + util 함수 (룰 03 §2.4) |
| `siMain.Columns[col].Width = 100` | `width: 100` |
| `siMain.Columns[col].Visible = false` | `visible: false` |

---

## §7 reference file:line 인용

| 패턴 | reference |
|---|---|
| BE 메타 (column 정의) | `_artifacts/12_DMF0020_metadata_v2_part2.sql` 의 INSERT INTO SCM_ADM_MNU_M_SHEET_COLUMNS |
| FE staticColumns 사용 | `CustomerModelMappingGrid.tsx:30 + 119` |
| dynamicColumns 사용 | `CustomerFcstMasterFcstGrid.tsx:30 + 63` |
| dynamic column util 표준 | `customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts` (89 lines) |
| defaultUpperColumnProps + defaultLowerColumnProps | `CustomerFcstMasterDateColumns.ts:8-29` |
| 2-row header (group + leaf) | `CustomerFcstMasterDateColumns.ts:38-47` |
| ISO week 처리 | `CustomerFcstMasterDateColumns.ts:55-65` |

---

## §8 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | column meta 표준 + dynamic column util + 사고 사례 통합 |
