# TO-BE 룰 09 — SubTitle + hotkeyConfig (CRUD 6대 + Search Aux 4대 + Excel)

> **추출 reference**: 4 reference 화면 모두 동일 패턴 + 메모리 `feedback_asis_button_mapping_mandatory.md` + `feedback_search_aux_default_activation.md`

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 09 |
| 토픽 | SubTitle + hotkeyConfig + CRUD 6대 + Search Aux 4대 + Excel |
| 적용 trigger | 메인 컴포넌트의 SubTitle 사용 |
| 관련 hook | `asis-button-mapping.md` |

---

## §1 표준 SubTitle 사용 (의무)

```typescript
import { SubTitle } from '@shared/components';
import type { HotkeyConfig } from '@foundation/models';

const hotkeyConfig: HotkeyConfig = {
  insert: handleInsert,
  delete: handleDelete,
  search: setFilters,
  save: handleSave,
  manual: false,
  upload: false,
  // sort / filter / condition / resetCondition 명시 생략 = 자동 활성 (SubTitle DefaultButtonActions)
};

<SubTitle
  menuId={MENU_ID}
  grid={gridRef}                       // 또는 gridRefs[activeTab]
  gridFilter={gridFilterRef}           // 또는 gridFilterRefs[activeTab]
  dataCount={data?.o_rc1?.length ?? 0}
  excelFileName='Customer-Model-Mapping'
  hotkeyConfig={hotkeyConfig}
  searchParam={searchParams}
  // (선택) useHotkey={true}  — default true
/>
```

### §1.1 의무 사항 인벤토리

| # | 의무 | reference |
|---:|---|---|
| 1 | `menuId={MENU_ID}` 명시 | 모든 화면 |
| 2 | `grid` / `gridFilter` (single ref 또는 active sheet ref) | 모든 화면 |
| 3 | `dataCount` (총 데이터 카운트 표시) | 모든 화면 |
| 4 | `excelFileName` (다운로드 파일명) | 모든 화면 |
| 5 | `hotkeyConfig` (HotkeyConfig type) — F-key 매핑 | 모든 화면 |
| 6 | `searchParam` (저장 시 SP 호출에 전달) | 모든 화면 |

---

## §2 hotkeyConfig 10 키 (CRUD 6대 + Search Aux 4대) 매핑

### §2.1 10 키 표

| F-key | hotkeyConfig key | AS-IS BaseForm | 결정 정책 |
|---|---|---|---|
| F1 | (없음 — Help 미사용) | HelpButton | (TO-BE 미사용) |
| F2 | (없음 — TO-BE column meta 자동) | EditButton | column meta `_inputEditType` 자동 |
| F3 | (생략 = 자동 활성) | OnClickSortButton | DataGrid `allowSorting={true}` 자동 |
| F4 | (생략 = 자동 활성) | OnClickFilterButton | FlexGridFilter 자동 |
| F5 | `search` | OnClickFindButton → FindButton | 의무 명시 (handler) |
| F6 | `condition` | OnClickConditionButton (사용자별 저장) | **Phase 5 G1 후**: useSearchConditionPersistence.saveCondition |
| F7 | `save` | OnClickSaveButton → SaveButton | 의무 명시 (handler) |
| F8 | `insert` | OnClickInsertButton → InsertButton | 의무 명시 (handler) |
| F9 | `delete` | OnClickDeleteButton → DeleteButton | 의무 명시 (handler) |
| F10 | `resetCondition` | OnClickResetConditionButton | **Phase 5 G1 후**: useSearchConditionPersistence.resetCondition |
| F12 | (없음 — excel 자동) | OnClickExcelButton | `excelFileName` prop 자동 |
| - | `manual` | (Help 매뉴얼) | 의무 `false` (사용 안 함) |
| - | `upload` | (Excel 업로드) | 의무 `false` (G5 후 결정) |

### §2.2 정책 4 종

| 정책 | 사용 |
|---|---|
| **명시 (함수)** | 화면이 그 동작 사용 (handler 호출) — `search: handleSearch` |
| **명시 (`false`)** | 화면이 명시적 미사용 (버튼 숨김) — `manual: false`, `upload: false` |
| **생략 (자동 활성)** | SubTitle 의 DefaultButtonActions 사용 (sort/filter/condition/resetCondition 4 키) |
| **명시 (undefined / 빈 함수 금지)** | `() => undefined` / `() => {}` 절대 금지 (AS-IS 분석 없는 placeholder) |

### §2.2.1 ⭐ 공통 버튼 기본 표시 정책 (2026-06-06 사용자 명시 요구)

> **"각 화면에 공통기능 버튼은 기본적으로 전체를 표기하는 것을 전체로 추가/삭제 기능이 없으면 추가/삭제 버튼은 삭제, 저장기능이 없으면 저장 버튼은 삭제 그외 버튼은 전체가 항상 보이고 기능을 구현해주세요."**

**Hidden allowlist (이 3 키만 false 허용 — AS-IS 분석 결과 기능이 없을 때)**:

| 키 | false 허용 조건 |
|---|---|
| `insert` | AS-IS `.cs §4 Button` 에 `protected override InsertButton()` 없음 또는 빈 본문 + customButtons 가 동등 동작 제공 |
| `delete` | AS-IS `.cs §4 Button` 에 `protected override DeleteButton()` 없음 또는 빈 본문 + customButtons 가 동등 동작 제공 |
| `save` | AS-IS `.cs §4 Button` 에 `protected override SaveButton()` 없음 또는 customButtons 즉시 mutate (별도 Save 단계 없음) |

**Always-visible (항상 표시 + 기능 구현 의무 — false 금지)**:

| 키 | 의무 |
|---|---|
| `search` (F5) | SearchArea 존재 시 SearchArea 가 처리 / SearchArea 부재 시 **§2.5 searchAction 의무** |
| `sort` (F3) | 생략 = 자동 활성 (DataGrid `allowSorting={true}`) — false 금지 |
| `filter` (F4) | 생략 = 자동 활성 (FlexGridFilter) — false 금지 |
| `excel` (F12) | 생략 = 자동 활성 (`excelFileName` prop) — false 금지 |
| `condition` (F6) | 생략 = 자동 활성. 단 UsrConditionPanel 부재 화면은 false (§2.4 메모리 룰) |
| `resetCondition` (F10) | 생략 = 자동 활성. 단 UsrConditionPanel 부재 화면은 false (§2.4 메모리 룰) |

**Always-false (false 의무)**:

| 키 | 의무 |
|---|---|
| `manual` | AS-IS 매뉴얼 미사용 — `manual: false` 명시 |
| `upload` | AS-IS 업로드 버튼 있을 때만 함수 / 없으면 `upload: false` 명시 |

**Anti-pattern (절대 금지)**:

```typescript
// ❌ AuthRequest (SCM0008) 2026-06-06 위반 사례 — 모든 키 false
const hotkeyConfig: HotkeyConfig = {
  insert: false, delete: false, save: false,
  search: false, condition: false, resetCondition: false,
  excel: false, upload: false, manual: false,
};
// → Sort / Filter / Excel 까지 모두 숨김 → 데이터 grid 있는 화면에서 UX 손상
```

**Correct (SCM0008 fix 패턴)**:

```typescript
// ✅ customButtons (Add/Delete/Request) 가 CRUD 대체 + SearchArea 부재
const hotkeyConfig: HotkeyConfig = {
  insert: false,           // customButtons 의 Add 가 대체
  delete: false,           // customButtons 의 Delete 가 대체
  save: false,             // customButtons 의 Request 가 즉시 mutate
  condition: false,        // UsrConditionPanel 부재 (§2.4)
  resetCondition: false,   // UsrConditionPanel 부재 (§2.4)
  manual: false,
  upload: false,
  // sort / filter / excel: 생략 = 자동 활성 (always-visible)
};
// + SearchArea 부재 → searchAction 의무 (§2.5)
```

### §2.3 Search Aux 4 키 기본 활성 정책 (메모리 룰)

> 메모리 `feedback_search_aux_default_activation.md`: Sort/Filter/Condition/ResetCondition 4 키는 `hotkeyConfig` 명시 생략 = 자동 활성.

**자동 활성 (생략)**:
```typescript
const hotkeyConfig: HotkeyConfig = {
  insert: handleInsert,
  delete: handleDelete,
  search: setFilters,
  save: handleSave,
  manual: false,
  upload: false,
  // sort / filter / condition / resetCondition 생략 → 자동 활성
};
```

**SubTitle 의 DefaultButtonActions 자동 제공**:
- **Sort (F3)**: DataGrid `allowSorting={true}` 자동
- **Filter (F4)**: FlexGridFilter 자동 (DataGrid 내장)
- **Condition (F6)**: **Phase 5 G1 후 신규**: `useSearchConditionPersistence.saveCondition(searchParams)` 자동
- **ResetCondition (F10)**: **Phase 5 G1 후 신규**: `setConfirm(t('MSG00397'))` → `resetCondition()` 자동

### §2.5 ⭐ SearchArea 부재 화면 — SubTitle 좌측 Search 버튼 의무 (2026-06-06 신규)

> **"조회조건이 없는 경우에는 공통버튼 왼쪽에 서치 버튼 추가해주세요."** (사용자 명시 요구)

**조건**:
- `MainTitle` 에 `disableSearchArea` prop 설정 또는 SearchArea 컴포넌트 미사용
- 화면에 `useTabProcQuery` / `useTabComboQueries` 기반 조회 동작이 존재

**의무**:
- `<SubTitle>` 에 `searchAction={handleSearch}` prop 명시
- SubTitle 이 **공통버튼 좌측에 "Search(F5)" 버튼** 자동 렌더 + F5 hotkey 자동 연동

```typescript
import { useQueryClient } from '@tanstack/react-query';

const queryClient = useQueryClient();

const handleSearch = () => {
  // 모든 조회 query refetch (또는 특정 sheet 만)
  void queryClient.invalidateQueries({ queryKey: ['proc', MENU_ID] });
};

<MainTitle title={title} menuId={MENU_ID} disableSearchArea />
<SubTitle
  menuId={MENU_ID}
  grid={gridRef}
  gridFilter={gridFilterRef}
  dataCount={data?.o_rc?.length ?? 0}
  excelFileName='Auth Request'
  hotkeyConfig={hotkeyConfig}
  searchAction={handleSearch}    // ⭐ SearchArea 부재 화면 의무
  customButtons={customButtons}
/>
```

**SubTitle.tsx 구현 (`packages/shared/src/components/organisms/sub-title/SubTitle.tsx`)**:
- `searchAction?: () => void` prop 추가
- rightButtons 의 맨 앞 (= customButtons 보다 더 좌측) 에 Search 버튼 렌더
- F5 hotkey 자동 연동 (hotkeyConfig.search 우선, 없으면 searchAction)

**Anti-pattern**:
```typescript
// ❌ SearchArea 부재 + searchAction 미명시 → 사용자가 조회 트리거 불가
<MainTitle title={title} menuId={MENU_ID} disableSearchArea />
<SubTitle ... hotkeyConfig={{ search: false, ... }} />
```

### §2.4 UsrConditionPanel 0건 화면의 condition/resetCondition false (메모리 룰)

> 메모리 `feedback_search_aux_default_activation.md` (Phase 5 G1 신규 구현 전 default):

**조건**: AS-IS 화면에 `UsrConditionPanel` 없음 (조회조건 영역 자체가 없는 화면).

**의무**:
```typescript
const hotkeyConfig: HotkeyConfig = {
  // ...
  condition: false,         // 조회조건 자체가 없으므로 저장 의미 없음
  resetCondition: false,
  manual: false,
  upload: false,
};
```

→ Phase 5 G1 신규 구현 후에도 이 정책 유지 (조회조건 없는 화면은 G1 미적용).

---

## §3 hotkeyConfig 패턴 (multi-sheet 화면)

### §3.1 activeTab 기반 handler

```typescript
const handleInsert = () => {
  if (!gridRefs[activeTab].current) return;
  GridAction.addRow(gridRefs[activeTab].current, {
    DIVISION_ID: filters[SHEETS.SITE]?.divisionId ?? '81',
    SCM_SITE_ID: activeTab === SHEET_INDEX.SITE ? undefined : filters[SHEETS.CUSTOMER]?.salesSite,
  });
};

const handleSave = () => {
  switch (activeTab) {
    case SHEET_INDEX.SITE: {
      const saveData = siteData?.salesSite?.filter?.(item => item.CRUD_TYPE) ?? [];
      saveWithValidation(saveData, staticColumns.salesSite, mutateSite);
      break;
    }
    case SHEET_INDEX.CUSTOMER: { ... }
    // ...
  }
};
```

→ `gridRefs[activeTab]` + switch (`activeTab`).

**reference**: `SalesSite.tsx:100-141`.

### §3.2 active sheet 의 grid / gridFilter

```typescript
<SubTitle
  grid={gridRefs[activeTab]}           // ⭐ active sheet 의 grid
  gridFilter={gridFilterRefs[activeTab]}
  dataCount={detailDataCountByTab[activeTab] ?? 0}
  // ...
/>
```

**reference**: `SalesSite.tsx:172-180`.

### §3.3 detailDataCountByTab (tab 별 count)

```typescript
const detailDataCountByTab: Record<number, number> = {
  [SHEET_INDEX.SITE]: siteData?.salesSite.length ?? 0,
  [SHEET_INDEX.CUSTOMER]: detailData?.salesCustomer.length ?? 0,
  [SHEET_INDEX.LOCATION]: detailData?.salesLocation.length ?? 0,
  [SHEET_INDEX.BUCKET]: detailData?.salesBucket.length ?? 0,
};
```

**reference**: `SalesSite.tsx:93-98`.

---

## §4 customButtons (화면 특화 버튼)

### §4.1 표준 customButtons (선택)

```typescript
const hotkeyConfig: HotkeyConfig = {
  // ... 10 키
  customButtons: [
    {
      id: 'unique-id',
      label: t('LBL_BUTTON_LABEL'),
      icon: <CustomIcon />,
      onClick: () => { ... },
      disabled: false,
    },
  ],
};
```

→ AS-IS 화면 안 추가 버튼 (예: "Auto Sync", "Recalculate") TO-BE 이전 시 `customButtons` 로 매핑.

> **현재 4 reference 화면 (DMF0004~7) 은 customButtons 미사용** — 신규 화면에서 도입 가능.

---

## §5 handleSave 표준 (의무)

### §5.1 single sheet (DMF0006 baseline)

```typescript
const handleSave = () => {
  const saveData = data?.o_rc1.filter(row => row.CRUD_TYPE);
  saveWithValidation(saveData, staticColumn, mutate);
};
```

**3 단계**:
1. **변경 행 filter**: `data?.o_rc1.filter(row => row.CRUD_TYPE)` — CRUD_TYPE 가 있는 (INSERT/UPDATE/MODIFY/DELETE) 행만
2. **validation**: `useSaveWithValidation.saveWithValidation(saveData, staticColumn, mutate)` — 필수 컬럼 null 체크 + 자동 alert
3. **mutation**: `mutate` 자동 호출 (react-query)

### §5.2 multi-sheet (DMF0004)

```typescript
const handleSave = () => {
  switch (activeTab) {
    case SHEET_INDEX.SITE: {
      const saveData = siteData?.salesSite?.filter?.(item => item.CRUD_TYPE) ?? [];
      const staticColumn = staticColumns.salesSite;
      saveWithValidation(saveData, staticColumn, mutateSite);
      break;
    }
    // ... 다른 sheet
  }
};
```

### §5.3 dynamic column + pivot (DMF0007)

```typescript
const handleSave = () => {
  if (activeIndex === SHEET_INDEX.CUSTOMER_FCST) {
    const rows = fcstData?.o_rc1 ?? [];
    const editMap = fcstEditTrackerRef.current?.getOriginalValues();
    const saveData: FcstRow[] = [];
    
    rows
      .filter(row => row.CRUD_TYPE)
      .forEach(row => {
        Object.keys(row).forEach(key => {
          if (!key.startsWith('D_')) return;
          const changeMap = editMap?.get(row);
          // MODIFY 일 때만 변경된 cell 만 save (full row save 아님)
          if (row.CRUD_TYPE === CRUD_TYPE.MODIFY && (!changeMap || !(key in changeMap))) return;
          saveData.push(buildPivotedRow(row, key, 'CUST_FCST') as unknown as FcstRow);
        });
      });
    saveWithValidation(saveData, staticColumns[SHEETS.CUSTOMER_FCST], saveFcst);
  } else {
    // PSI 동일
  }
};
```

→ wide table → long format pivot. AS-IS Spread 의 row × column 매트릭스 저장 방식.

**reference**: `CustomerFcstMaster.tsx:142-174`.

---

## §6 handleInsert / handleDelete 표준

### §6.1 handleInsert (의무 default)

```typescript
const handleInsert = () => {
  if (!gridRef.current) return;
  GridAction.addRow(gridRef.current, {
    DIVISION_ID: filters?.divisionId ?? '81',   // searchParams 의 default 값
    // ... 다른 default
  });
};
```

→ `GridAction.addRow(grid, defaultValues)` — 새 row 추가 + CRUD_TYPE='I' 자동 + EditTracker 자동 추적.

### §6.2 handleDelete (의무 default)

```typescript
const handleDelete = () => {
  if (!gridRef.current) return;
  GridAction.removeRow(gridRef.current, true);   // 두 번째 인자 true = confirm 표시
};
```

→ `GridAction.removeRow(grid, true)` — 선택 row 의 CRUD_TYPE='D' 마킹 + grid 표시 (실제 삭제는 SaveButton 시).

---

## §7 금지 (anti-pattern)

### §7.1 `() => undefined` 빈 handler (메모리 룰)

**금지** (메모리 `feedback_asis_button_mapping_mandatory.md`):
```typescript
const hotkeyConfig: HotkeyConfig = {
  insert: () => undefined,   ❌ AS-IS 분석 없이 placeholder
  delete: () => {},          ❌ 동일
};
```

**의무**:
- 사용: 정확한 handler 함수
- 미사용: `false` (버튼 숨김)
- 자동 활성: 생략 (Sort/Filter/Condition/ResetCondition)

### §7.2 `manual` / `upload` 누락

**금지**: hotkeyConfig 에 manual / upload 미명시 → SubTitle default 활성 (의도치 않은 버튼).

**의무**:
```typescript
manual: false,
upload: false,
```

### §7.3 AS-IS CRUD 6대 + Search Aux 4대 cross-check 누락

**금지** (메모리 `feedback_asis_button_mapping_mandatory.md` 룰 25 §1.5.1 / §1.5.3):
- AS-IS `.cs §4 Button` 의 CRUD 6대 (protected override Find/Insert/Delete/Edit/Save/Excel) 분석 누락
- BaseForm.cs default Search Aux 4대 (OnClickSort/Filter/Condition/ResetCondition) 분석 누락

**의무**: AS-IS .cs 의 button 매핑 → hotkeyConfig 의 function (활성) / false (숨김) / 생략 (자동 활성) 결정 → `__asis-mapping__.md ## Button 매핑` 문서화.

### §7.4 ⭐ 공통 버튼 일괄 false (2026-06-06 사용자 명시 금지)

**금지**: 모든 hotkeyConfig 키를 `false` 로 설정 → Sort/Filter/Excel 등 always-visible 버튼까지 숨김.

```typescript
// ❌ 절대 금지 (AuthRequest SCM0008 2026-06-06 위반 사례)
const hotkeyConfig: HotkeyConfig = {
  insert: false, delete: false, save: false,
  search: false, condition: false, resetCondition: false,
  excel: false, upload: false, manual: false,
};
```

**의무**: §2.2.1 Hidden allowlist (insert/delete/save 만 false 허용) + Always-visible (sort/filter/excel) + UsrConditionPanel 부재 시만 condition/resetCondition false.

### §7.5 ⭐ SearchArea 부재 + searchAction 누락 (2026-06-06 사용자 명시 금지)

**금지**: `disableSearchArea` 또는 SearchArea 미사용 화면이 `searchAction` prop 누락.

**의무**: §2.5 — SearchArea 부재 시 `searchAction={handleSearch}` 의무 (공통버튼 좌측 Search 버튼 자동 렌더).

### §7.7 excelFileName 누락

**금지**: `<SubTitle>` 에 `excelFileName` 누락 → F12 Excel 다운로드 시 자동 파일명 (의미 없음).

**의무**: `excelFileName='{Screen Name}'` 명시 (예: `'Customer-Model-Mapping'`).

---

## §8 자동 검증 (PR 머지 게이트)

```bash
MAIN="features/{domain}/src/pages/{screen}/{Name}.tsx"

# 1. SubTitle 의무 props
grep -A 10 "<SubTitle" "$MAIN" | grep -c "menuId="  # ≥ 1
grep -A 10 "<SubTitle" "$MAIN" | grep -c "hotkeyConfig="  # ≥ 1
grep -A 10 "<SubTitle" "$MAIN" | grep -c "excelFileName="  # ≥ 1

# 2. hotkeyConfig manual/upload 명시
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -c "manual:"  # ≥ 1
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -c "upload:"  # ≥ 1

# 3. () => undefined / () => {} 빈 handler 금지
grep -nE "=> undefined|=> \{\s*\}" "$MAIN" | wc -l  # = 0

# 4. CRUD 6대 + Search Aux 4대 매핑 cross-check
# AS-IS .cs 의 OverrideButton 카운트 = TO-BE hotkeyConfig 의 명시 키 카운트 + false 키 카운트
# (수동 검토 — __asis-mapping__.md 의 Button 매핑 표 참조)

# 5. saveWithValidation 사용
grep -c "saveWithValidation" "$MAIN"  # ≥ 1

# 6. ⭐ 일괄 false 금지 (2026-06-06) — Sort/Filter/Excel 까지 false 면 위반
awk '/hotkeyConfig:.*HotkeyConfig/,/^\s*\};/' "$MAIN" | grep -cE "(sort|filter|excel):\s*false"  # = 0

# 7. ⭐ SearchArea 부재 + searchAction 누락 검출 (2026-06-06)
if grep -q "disableSearchArea" "$MAIN"; then
  grep -c "searchAction=" "$MAIN"  # ≥ 1 (의무)
fi

# 6. GridAction.addRow / removeRow 사용
grep -c "GridAction.addRow" "$MAIN"  # ≥ 1
grep -c "GridAction.removeRow" "$MAIN"  # ≥ 1
```

---

## §9 AS-IS 매핑

| AS-IS BaseForm F-key | TO-BE hotkeyConfig |
|---|---|
| F1 HelpButton virtual | (TO-BE 미사용 — 메뉴 manual: false) |
| F2 EditButton virtual + IsLock 가드 | (TO-BE 미사용 — column meta `_inputEditType` 자동) |
| F3 OnClickSortButton (column toggle) | (생략 = 자동 활성, DataGrid `allowSorting={true}`) |
| F4 OnClickFilterButton (column toggle) | (생략 = 자동 활성, FlexGridFilter) |
| F5 OnClickFindButton → FindButton | `search: handleSearch / setFilters` |
| F6 OnClickConditionButton (저장) | (Phase 5 G1 신규 후) `condition: 자동 활성` |
| F7 OnClickSaveButton → SaveButton + MSG00133 가드 | `save: handleSave` (변경 행 filter + saveWithValidation + mutate) |
| F8 OnClickInsertButton → InsertButton + CheckValidation | `insert: handleInsert` (GridAction.addRow + default values) |
| F9 OnClickDeleteButton → DeleteButton | `delete: handleDelete` (GridAction.removeRow with confirm) |
| F10 OnClickResetConditionButton | (Phase 5 G1 신규 후) `resetCondition: 자동 활성` |
| F12 OnClickExcelButton → ExcelButton + ExportExcel | `excelFileName` (자동 export) |

---

## §10 reference file:line 인용

| 패턴 | reference |
|---|---|
| 표준 hotkeyConfig | `CustomerModelMapping.tsx:66-73` |
| Multi-sheet handleSave switch | `SalesSite.tsx:114-141` |
| activeTab 기반 grid 동적 ref | `SalesSite.tsx:172-180` |
| detailDataCountByTab | `SalesSite.tsx:93-98` |
| Pivot save (DMF0007) | `CustomerFcstMaster.tsx:117-174` |
| handleSearch 의 EditTracker clear | `CustomerFcstMaster.tsx:72-79` |
| 표준 GridAction 사용 | `CustomerModelMapping.tsx:44-55` |

---

## §12 그리드 특화 액션 버튼 배치 표준 (2026-06-06 신규)

### §12.1 배치 원칙

| 액션 범위 | 배치 위치 | 예 |
|---|---|---|
| 화면 전체 (CRUD/Search/Excel/Sort/Filter) | `<SubTitle>` hotkeyConfig | F-key 매핑 |
| 화면 전체 (특화 1개 액션) | `<SubTitle customButtons>` | Request / Submit |
| **그리드 특화 (Add/Delete/특정 grid 의 row 대상)** | **`<TitleArea isSubTitle rightButtons={...}>`** | Add / Delete (특정 grid 의) |

### §12.2 표준 패턴

```typescript
// 화면 전체 액션은 SubTitle
<SubTitle
  customButtons={[
    { label: 'Request', action: handleRequest },   // ← 화면 전체 의미
  ]}
  hotkeyConfig={hotkeyConfig}
/>

// 그리드 특화 액션은 해당 grid 의 TitleArea
<TitleArea
  isSubTitle
  title='My Authority List'
  depth='h4'
  rightButtons={
    <>
      <Button onClick={handleAdd}    buttonLabel='Add'    size='small' appearance='outlined' />
      <Button onClick={handleDelete} buttonLabel='Delete' size='small' appearance='outlined' />
    </>
  }
/>
<MyAuthorityListGrid ... />
```

### §12.3 anti-pattern

```typescript
// ❌ SCM0008 초기 — 모든 액션이 SubTitle (Add/Delete 도 화면 전체로 인지 유발)
<SubTitle customButtons={[
  { label: 'Request', action: handleRequest },
  { label: 'Add', action: handleAdd },        // ← 어느 grid 인지 불명
  { label: 'Delete', action: handleDelete },
]} />
```

### §12.4 PRE-WRITE 체크리스트

```
☐ 각 action 의 row 대상 grid 가 명확한가?
  → "MyAuthorityList 만" → 해당 TitleArea rightButtons 배치 의무
  → "화면 전체 데이터" → SubTitle customButtons
☐ TitleArea 의 rightButtons prop 사용 가능 확인?
  → @lges/design-system 의 SubTitleAreaProps.rightButtons (확인 완료)
```

### §12.5 cross-ref

- hook `grid-interaction-patterns.md` §2
- 메모리 `feedback_grid_action_button_placement`

---

## §11 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 SubTitle/hotkeyConfig 통합 + 메모리 룰 cross-ref |
| 2026-06-06 | §2.2.1 공통 버튼 기본 표시 정책 신설 + §2.5 SearchArea 부재 searchAction 신설 + §7.4/§7.5 anti-pattern + §8 grep #6/#7 자동 검증 | 사용자 명시 요구 (SCM0008 일괄 false + Search 버튼 누락 사고). hidden allowlist = insert/delete/save 만 |
| 2026-06-06 | §12 그리드 특화 액션 버튼 배치 (TitleArea rightButtons) 신설 | SCM0008 Auth Request — Add/Delete 가 SubTitle 에 있어 사용자 혼선 |
| 2026-06-12 | hotkeyConfig 의 모든 버튼 (search/insert/save/delete/excel/upload/manual + customButtons) 은 `useTabBtnPermissions` + `hasButton(BTN_CD)` 조건부 callback 의무. 하드코딩 `search: handleSearch` 금지. **hook `menu-button-dynamic-fetch.md` + master `ui-dynamic-property-management.md`** 참조 의무 | 사용자 명시 — "UI 생성의 동적 속성관리" Menu Button 부분 (admin SYS0009 변경 즉시 반영) |
