# Hook — Grid 상호작용 표준 (selectionMode / 액션 버튼 배치 / 자동 체크 금지 / Recently-Added)

> **트리거**: 신규 화면이 다중 grid + checkbox + row selection 조합을 사용할 때
>
> **목적**: DataGrid 표준 patterns 4 종 (selection / button placement / no auto-check / recently-added) 강제 적용

작성: 2026-06-06 (SCM0008 Auth Request 4 사고 묶음)
관련 룰: `_tobe/07_datagrid.md`, `_tobe/09_subtitle_hotkey.md`
상위 룰: `anti-simplification.md`

---

## §0. 4 패턴 인벤토리

| # | 패턴 | 사고 |
|---:|---|---|
| 1 | **selectionMode**: row-click 선택은 `SelectionMode.Row` 명시 | SCM0008 Authority grid — 사용자 "row 선택이 안 됨" 보고 |
| 2 | **그리드 특화 액션 버튼 배치**: `TitleArea rightButtons` (SubTitle 아님) | SCM0008 — Add/Delete 가 SubTitle 에 있어 사용자 혼선 |
| 3 | **서버 데이터로 row 자동 체크 금지** | SCM0008 — APPROVAL_RESULT 기반 자동 체크 → 다수 row 미리 체크된 상태 |
| 4 | **Recently-Added row 표시 (loadedRows event)** | SCM0008 — useEffect 만으로는 grid.rows 갱신 전 → 체크 안 됨 |

---

## §1. 패턴 #1 — selectionMode 명시

### §1.1 의무 매트릭스

| 화면 유형 | selectionMode | useCheckbox | 사유 |
|---|---|---|---|
| 단일 row 선택 (검색/CRUD 대상 1행) | **`SelectionMode.Row`** | (X) | 클릭으로 row 전체 하이라이트 |
| 다중 row 선택 (체크박스) | (default `MultiRange`) | **`useCheckbox`** | Selector 가 row.isSelected toggle |
| 셀 편집 | `MultiRange` (default) | (X) | 셀 범위 선택 + 편집 |

### §1.2 사고 사례

```typescript
// ❌ Authority grid (단일 row 선택 의도) 가 default MultiRange
<DataGrid<AuthorityRow>
  staticColumns={cols}
  isReadOnly
  // selectionMode 미명시 → MultiRange → 셀 클릭만 선택, row 전체 하이라이트 안 됨
/>
```

→ 사용자 클릭 시 row 가 시각적으로 선택되지 않음 → `getSelectedRows` 빈 배열 → ADD 시도 시 "Authority 선택 안됨" 오류.

```typescript
// ✅ Fix
import { SelectionMode } from '@mescius/wijmo.grid';

<DataGrid<AuthorityRow>
  staticColumns={cols}
  selectionMode={SelectionMode.Row}
  isReadOnly
/>
```

### §1.3 PRE-WRITE 체크리스트

```
☐ 사용자가 이 grid 에서 어떻게 선택하나?
  - row 클릭 → SelectionMode.Row
  - checkbox 클릭 → useCheckbox (selectionMode 는 default)
  - 셀 편집 → MultiRange (default)

☐ 처음부터 row select 의 의미 정확히 결정?
  → AS-IS .cs 의 spdMain.SelectionPolicy / btnXxx_Click 가 어느 row 를 의존하는지 분석
```

---

## §2. 패턴 #2 — 그리드 특화 액션 버튼 배치

### §2.1 배치 표준

| 액션 범위 | 배치 위치 | 예 |
|---|---|---|
| 화면 전체 (CRUD/Search/Excel) | `<SubTitle>` 의 hotkeyConfig / customButtons | Search / Sort / Filter / Excel |
| 화면 전체 (특화 1개 액션) | `<SubTitle customButtons>` | Request, Submit |
| 그리드 특화 (Add/Delete/특정 grid 의 row 대상) | **`<TitleArea isSubTitle rightButtons={...}>`** | Add / Delete (MyAuthorityList 의) |

### §2.2 사고 사례

```typescript
// ❌ SCM0008 초기 — 모든 액션이 SubTitle 에
<SubTitle customButtons={[
  { label: 'Request', action: handleRequest },
  { label: 'Add', action: handleAdd },        // ← MyAuthorityList 만 의미
  { label: 'Delete', action: handleDelete },  // ← MyAuthorityList 만 의미
]} />
```

→ 사용자 혼선: "Add 가 어느 grid 에 row 를 추가하는지?"

```typescript
// ✅ Fix
<SubTitle customButtons={[{ label: 'Request', action: handleRequest }]} />

<TitleArea
  isSubTitle
  title='My Authority List'
  depth='h4'
  rightButtons={
    <>
      <Button onClick={handleAdd} buttonLabel='Add' size='small' appearance='outlined' />
      <Button onClick={handleDelete} buttonLabel='Delete' size='small' appearance='outlined' />
    </>
  }
/>
```

### §2.3 PRE-WRITE 체크리스트

```
☐ 액션의 row 대상이 어느 grid?
  → "MyAuthorityList 만" → 해당 TitleArea rightButtons
  → "화면 전체 데이터" → SubTitle

☐ TitleArea 의 rightButtons prop 존재 확인 (@lges/design-system)?
  → `node_modules/@lges/design-system/components/ui/title-area/sub-title-area.d.ts` 의 SubTitleAreaProps.rightButtons
```

---

## §3. 패턴 #3 — 서버 데이터 기반 row 자동 체크 금지

### §3.1 원칙

**Checkbox state = 사용자 의도** (action 대상 선택)
**Server data (APPROVAL_RESULT, IS_ACTIVE, etc.) ≠ checkbox state**

### §3.2 사고 사례

```typescript
// ❌ SCM0008 초기 — APPROVAL_RESULT 기반 자동 체크
useEffect(() => {
  for (...) {
    const result = item.APPROVAL_RESULT.trim();
    if (isReject) row.isSelected = false;
    else if (isFinalApproved) row.isSelected = true;  // ← 자동 체크
  }
}, [data]);
```

→ 페이지 진입 시 다수 row 자동 체크 → 사용자가 다른 row 추가 체크 후 Delete 클릭 시 의도치 않은 자동 체크 row 까지 삭제됨.

```typescript
// ✅ Fix — 자동 체크 제거
useEffect(() => {
  for (...) {
    if (hasRecentAdd) {
      // recently-added 패턴 (§4)
      row.isSelected = recent.has(key);
    } else {
      row.isSelected = false;  // ← 모두 unchecked default
    }
  }
}, [data, recentlyAddedKeys]);
```

### §3.3 PRE-WRITE 체크리스트

```
☐ checkbox state 를 자동으로 setting 하는 로직이 있나?
  → server data 기반 (APPROVAL_RESULT / IS_ACTIVE / STATUS 등) = 금지
  → 사용자 액션 직후 표시 (recently-added 등) = 허용 (§4 패턴)
```

---

## §4. 패턴 #4 — Recently-Added row 표시 (loadedRows event)

### §4.1 사고

```typescript
// ❌ useEffect 만 사용 — refetch 후 grid.rows 갱신 전 실행
useEffect(() => {
  if (recentlyAddedKeys.size > 0) {
    for (let i = 0; i < grid.rows.length; i += 1) {
      const row = grid.rows[i];
      // ... grid.rows 가 OLD data 라 매칭 0건
    }
  }
}, [data, recentlyAddedKeys]);
```

→ React useEffect 가 fetch 완료 후 즉시 실행되지만 Wijmo 의 grid.rows 는 다음 frame 에 갱신 → 매칭 0건 → 체크 안 됨.

### §4.2 표준 패턴 (loadedRows event + ref)

```typescript
import { useEffect, useRef, type MutableRefObject } from 'react';
import type { FlexGrid } from '@mescius/wijmo.grid';

const recentKeysRef = useRef<Set<string> | undefined>(recentlyAddedKeys);
recentKeysRef.current = recentlyAddedKeys;
const handlerInstalledRef = useRef(false);

const applyRowSelection = (grid: FlexGrid) => {
  const recent = recentKeysRef.current;
  for (let i = 0; i < grid.rows.length; i += 1) {
    const row = grid.rows[i];
    if (!row?.dataItem) continue;
    const key = `${item.PK1}::${item.PK2}`;
    row.isSelected = recent ? recent.has(key) : false;
  }
};

useEffect(() => {
  const grid = gridRef.current;
  if (!grid) return;
  if (!handlerInstalledRef.current) {
    grid.loadedRows.addHandler((s: FlexGrid) => applyRowSelection(s));
    handlerInstalledRef.current = true;
  }
  applyRowSelection(grid);
}, [data, recentlyAddedKeys]);
```

**3 요소**:
1. `recentKeysRef` — 매 render 마다 ref.current 갱신 (handler 가 항상 latest 값 읽음)
2. `grid.loadedRows.addHandler` — Wijmo grid 가 새 row 로딩 완료 후 발화
3. `handlerInstalledRef` — handler 1 회만 install

### §4.3 부모 컴포넌트의 mutation onSuccess

```typescript
mutateXxx(rows, {
  onSuccess: () => {
    setRecentlyAddedKeys(new Set(addedKeys));      // state 갱신
    void queryClient.invalidateQueries({ queryKey: [tabId] });  // refetch
    setToast({ ... });
  },
});
```

→ refetch → 새 data → loadedRows 발화 → recently-added row 체크 표시.

---

## §5. 통합 PR 머지 게이트

- [ ] 단일 row 선택 grid 모두 `selectionMode={SelectionMode.Row}` 명시
- [ ] checkbox grid 모두 `useCheckbox` prop + `collectCheckedRows(grid)` 사용
- [ ] 그리드 특화 액션 버튼 (Add/Delete 등) 은 SubTitle 이 아닌 해당 grid 의 TitleArea rightButtons
- [ ] 서버 데이터 기반 row.isSelected 자동 setting 0 건
- [ ] Recently-added 표시는 loadedRows event handler + ref 패턴 사용 (useEffect 단독 금지)

---

## §6. cross-ref

| 항목 | 룰 |
|---|---|
| selectionMode 표준 | `_tobe/07_datagrid.md` §selection (신규) |
| 액션 버튼 배치 | `_tobe/09_subtitle_hotkey.md` §grid-scoped-buttons (신규) |
| Wijmo Selector + isSelected | `node_modules/@mescius/wijmo.grid.selector/index.d.ts` |
| loadedRows event API | https://www.grapecity.com/wijmo/api/classes/Wijmo_grid.FlexGrid.html#loadedRows |
| 메모리 | `feedback_grid_selectionmode_row` / `feedback_grid_action_button_placement` / `feedback_no_auto_check_on_server_state` / `feedback_recently_added_loadedrows_pattern` |

---

## §7. 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-06 | 초안 작성 | SCM0008 Auth Request 4 사고 묶음 |
