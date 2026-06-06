# Hook — runtime-error-prevention (기본 런타임 오류 사전 차단)

> **트리거**: 신규 FE 화면 / 모달 작성 시
>
> **목적**: 사고 사례 (Box import / DataMap 위치 / FlexGridColumnGroup 폭발 / NUMBER cast 등) 사전 차단

---

## §0 사고 사례 인벤토리 (메모리 통합)

| # | 사고 | 메모리 | 룰 |
|---|---|---|---|
| 1 | `Box` 를 `@shared/lges` 에서 import 시도 → 존재 안 함 | `feedback_runtime_error_prevention.md` | 룰 02 §2.1 |
| 2 | `Container / Dialog / Paper / IconButton / TextField / Autocomplete` 동일 | 동일 | 동일 |
| 3 | Edit 후 변수 미정의 (isEss 등) → 런타임 폭발 | 동일 | 동일 |
| 4 | Wijmo FlexGridColumnGroup single-child → `_setOwnerList is not a function` | `feedback_wijmo_columngroup_jsx_avoid.md` | 룰 07 §3.2 |
| 5 | NUMBER → String 변환 누락 → `value?.trim is not a function` | `feedback_no_type_cast_around_runtime.md` | 룰 07 §3.6 |
| 6 | `DataMap` 을 `@mescius/wijmo` 에서 import → 실제로는 `@mescius/wijmo.grid` | 메모리 | 룰 02 §2.3 |
| 7 | SCM_ADM_PROC_M 메타 누락 → `PLS-00306` | `feedback_proc_meta_mandatory.md` | 룰 12 §2.4 |
| 8 | React Query refetch loop (preSearchParams 매 render 새 객체) | `feedback_popup_dialog_layout.md` | 룰 06 §3.6 |
| 9 | CustomDialog position='overflow' → 중앙 미표시 | `feedback_popup_dialog_layout.md` | 룰 10 §4.2 |
| 10 | SCSS min-height: 70vh → CustomDialog DEFAULT_HEIGHT 무시 + 잘림 | 동일 | 동일 |

---

## §1 POST-WRITE grep 검증 (사고 사례 자동 검출)

```bash
F="{written_file}"

# 1. Box / Dialog / Container import 검출
grep -cE "from '@shared/lges'.*\b(Box|Container|Paper|IconButton|TextField|Dialog|Autocomplete)\b" "$F"   # = 0

# 2. FlexGridColumnGroup single-child
awk '/<FlexGridColumnGroup/,/<\/FlexGridColumnGroup>/' "$F" | awk '/<FlexGridColumn /{count++} END {if (count < 2 && count > 0) print "WARN: single leaf"}'

# 3. NUMBER → String 누락 (CustomDropdown value)
# (수동 검토 — Oracle NUMBER 컬럼이 value 로 직접 전달 안 되도록)
grep -nE "<CustomDropdown[^>]*value=\{row\." "$F" | head -5   # → row.X 가 NUMBER 인지 cross-check

# 4. wijmo.grid 에서 DataMap import (위치 정확)
grep -cE "from '@mescius/wijmo'.*\bDataMap\b" "$F"   # = 0 (@mescius/wijmo.grid 가 정확)

# 5. preSearchParams 의 매 render 새 객체 (refetch loop)
grep -B 2 "preSearchParams=\{\{ \.\.\." "$F" | grep -c "useMemo"   # ≥ 1 (사용 시)

# 6. CustomDialog position='overflow' 사용 검출
grep -E "position=['\"]overflow['\"]" "$F"   # = 0 (basic 권장)

# 7. SCSS min-height vh 강제
SCSS="${F%.tsx}.module.scss"
test -f "$SCSS" && grep -cE "min-height: \d+vh|height: \d+vh" "$SCSS"   # = 0
```

---

## §2 PRE-WRITE 자기 점검

- [ ] **alias 정확 export 인벤토리 확인** (룰 02 §2):
  - `@shared/lges` 에서 가져올 컴포넌트가 실제 존재하는지 cross-check
  - `@shared/mui` 에서 `Grid` 외 다른 것 가져오기 금지

- [ ] **Wijmo class import 위치**:
  - `FlexGrid` (type) → `@mescius/wijmo.grid`
  - `DataMap`, `CellRange`, `CellType`, `AllowMerging` → `@mescius/wijmo.grid`
  - `FlexGridFilter` → `@mescius/wijmo.grid.filter`
  - `FlexGridColumnGroup` JSX → wijmo.react.grid (사용 권장 X)

- [ ] **BE PROC_M 메타 의무**: SP body 작성 직후 `SCM_ADM_PROC_M` INSERT (camelCase) 작성 — `PLS-00306` 사고 회피

- [ ] **NUMBER → String 변환**: Oracle NUMBER 컬럼 (SEQ / YEAR / ID 등) 을 `value` prop 으로 전달 시 `String(row.COL)` 명시

- [ ] **preSearchParams useMemo**: modal 의 preSearchParams 가 객체 spread 시 `useMemo`

---

## §3 적용 룰 cross-ref

| 사고 | 룰 |
|---|---|
| Box / Dialog import | 룰 02 §2.1 |
| Wijmo class import 위치 | 룰 02 §2.3 + 룰 23 §8.1 (기존) |
| FlexGridColumnGroup polyfill | 룰 07 §3.2 + 룰 27 §F |
| NUMBER → String 변환 | 룰 07 §3.6 |
| PROC_M 메타 누락 | 룰 12 §2.4 |
| refetch loop | 룰 06 §3.6 / 룰 07 §3.8 |
| CustomDialog position | 룰 10 §4.2 + 메모리 `feedback_popup_dialog_layout` |
