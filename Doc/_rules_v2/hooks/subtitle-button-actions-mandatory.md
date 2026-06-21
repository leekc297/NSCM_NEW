# Hook — SubTitle 공통 버튼 11종 자동 매핑 의무 (추가/삭제/저장/Sort/Filter/Condition/Reset Condition + 4종)

> **Trigger**: T01 (신규 화면) + T07 (Button / CRUD / hotkeyConfig)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #25, 사용자 명시 — "공통 버튼 기능 구현 일괄 반영 룰")
> **세트 hook**: #60 (Grid) + #61 (Shell) + #62 (Regression Zero) + #63 (Conventions) + **#64 (SubTitle Buttons, 본 hook)**
> **인프라 소스**: `nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx` + `nscm-fe/packages/foundation/src/models/common/hotkey.ts`

## 0. 원칙 (불변)

신규 화면은 **`<SubTitle>` 컴포넌트 1 개 + `hotkeyConfig: HotkeyConfig` 1 객체** 만 정의하면 11 공통 버튼 (추가 / 삭제 / 저장 / Sort / Filter / Condition / Reset Condition / Excel / Upload / Manual / Search) 이 모두 표준 동작 + F1~F10 단축키 + 알림 + 권한 표시까지 자동 연결된다. **화면에서 직접 button 작성 / keydown handler / Excel 다운로드 logic 작성 절대 금지**.

---

## 1. 11 공통 버튼 매핑표 (DefaultButtonActions — SubTitle.tsx L65~115)

| Hotkey | hotkeyConfig 키 | Default 동작 | 라벨 | 화면 의무 |
|:-:|---|---|---|:-:|
| **F1** | `manual` | `GridAction.getManual(menuId)` | Manual(F1) | 선택 (`manual: false` 권장) |
| F2 | (`_F2_Unused`) | (미사용) | — | — |
| **F3** | `sort` | `GridAction.toggleColumnSort(grid.current)` | Sort(F3) | ⭐ **자동** (구현 0) |
| **F4** | `filter` | `GridAction.toggleColumnFilter(grid, gridFilter)` | Filter(F4) | ⭐ **자동** (구현 0) |
| **F5** | `search` | `alert('검색은 화면별로 구현하세요')` | Search(F5) | ⭐⭐ **화면 의무** |
| **F6** | `condition` | `GridAction.personalizeCondition(menuId, searchParam).then(MSG00010)` | Condition(F6) | ⭐ **자동** (`searchParam` prop 의무) |
| **F7** | `save` | `alert('저장은 화면별로 구현하세요')` | Save(F7) | ⭐⭐ **화면 의무** |
| **F8** | `insert` | `GridAction.addRow(grid, {})` | Insert(F8) | ⭐ 자동 (default 값 주입 권장 — `{ DIVISION_ID: filters?.divisionId ?? '81' }` 등) |
| **F9** | `delete` | `GridAction.removeRow(grid)` + 빈 선택 MSG00014 | Delete(F9) | ⭐ **자동** (구현 0) |
| **F10** | `resetCondition` | confirm MSG00009 → `GridAction.resetPersonalizedCondition(menuId)` + storage reset → MSG00011 | Reset Condition(F10) | ⭐ **자동** (구현 0) |
| (Hotkey 없음) | `excel` | `GridAction.excelDownload(grid, excelFileName, setProgress)` | (아이콘만) | ⭐ **자동** (`excelFileName` prop 의무) |
| (Hotkey 없음) | `upload` | (default 없음) | (아이콘만) | 선택 (`upload: false` 또는 화면 구현) |

### 1.1 자동 = 7 / 화면 의무 = 2 / 선택 = 2

- **자동 (7)**: `sort`/`filter`/`condition`/`resetCondition`/`delete`/`excel` + (default 값 미주입 시) `insert` — **화면이 아무것도 안 해도 작동**
- **화면 의무 (2)**: `search` (F5) / `save` (F7) — default 가 alert 이므로 반드시 구현
- **선택 (2)**: `manual` / `upload` — 보통 `false` 로 비활성화

### 1.2 비활성화 vs 사용자 정의

```ts
const hotkeyConfig: HotkeyConfig = {
  // ⭐ 화면 의무 (default 가 alert 임)
  search: () => { setFilters(); void fetchStaticColumns(); },
  save: handleSave,

  // ⭐ insert default 가 빈 row 라 권장 default 주입
  insert: () => GridAction.addRow(gridRefs[activeTab].current, {
    DIVISION_ID: filters?.divisionId ?? '81',  // ← 화면 default 주입
  }),

  // ⭐ delete 는 default 그대로면 생략 가능 — 또는 분기 시 override
  delete: () => GridAction.removeRow(gridRefs[activeTab].current, true),  // true = hard delete

  // ⭐ 비활성화 (버튼 + 단축키 모두 제거)
  manual: false,
  upload: false,

  // ⭐ sort / filter / condition / resetCondition / excel — 생략 시 자동
};
```

### 1.3 `false` vs `undefined` (생략) 동작 차이

| 값 | 버튼 표시 | 단축키 동작 |
|---|---|---|
| `() => void` | 표시 + onClick | 단축키 시 호출 |
| `false` | **비표시** | **무시** |
| 생략 (`undefined`) | 표시 + DefaultButtonActions | 단축키 시 DefaultButtonActions |

→ 화면에서 `manual: false` / `upload: false` 명시는 **비활성화** 의도. 생략은 default 동작 사용.

---

## 2. SubTitle 표준 시그니처 (DMF0004 SalesSite.tsx master)

```tsx
import type { HotkeyConfig } from '@foundation/models';
import { SubTitle } from '@shared/components';
import { useSaveWithValidation, useTabProcQuery, useProcMutation } from '@shared/hooks';

const { saveWithValidation } = useSaveWithValidation();
const { mutate } = useProcMutation<MENU_ID, SHEETS.MAIN>({ menuId, sheetName, tabId });

const handleSave = () => {
  const saveData = data?.main?.filter(item => item.CRUD_TYPE) ?? [];
  saveWithValidation(saveData, staticColumns.main, mutate);
};

const hotkeyConfig: HotkeyConfig = {
  insert: () => GridAction.addRow(gridRef.current, {
    DIVISION_ID: filters?.divisionId ?? '81',  // ← 권한 default 주입
  }),
  delete: () => GridAction.removeRow(gridRef.current, true),
  save: handleSave,
  search: () => { setFilters(); void fetchStaticColumns(); },
  manual: false,
  upload: false,
  // sort / filter / condition / resetCondition / excel — 생략 (자동)
};

<SubTitle
  menuId={MENU_ID}                      // ⭐ manual / condition / resetCondition 의 BE 호출 키
  grid={gridRef}                         // ⭐ insert / delete / sort / filter / excel 의 grid 참조
  gridFilter={gridFilterRef}             // ⭐ filter 토글 의 FlexGridFilter
  dataCount={data?.main?.length ?? 0}    // ⭐ 표시 카운트
  excelFileName='Sales Site'             // ⭐ excel 다운로드 파일명 (필수 — 미주입 시 'Excel File' fallback)
  hotkeyConfig={hotkeyConfig}            // ⭐ 화면 의무 5 항목 + 비활성화
  searchParam={searchParams}             // ⭐ condition (F6) 의 개인화 저장 payload
/>
```

### 2.1 props 의무 / 선택

| Prop | 의무? | 용도 |
|---|:-:|---|
| `menuId` | ✅ | manual / condition / resetCondition BE 호출 키 |
| `grid` | ✅ | 모든 grid 액션 (insert/delete/sort/filter/excel) 의 ref |
| `gridFilter` | ✅ | filter (F4) 토글 의 FlexGridFilter ref |
| `dataCount` | ✅ | 표시 카운트 (0 시 미표시) |
| `excelFileName` | ✅ | Excel 다운로드 파일명 |
| `hotkeyConfig` | ✅ | 5 의무 액션 + 비활성화 |
| `searchParam` | ✅ | F6 개인화 저장 payload (`Record<string, string>`) |
| `useHotkey` | – | default `true` (F1~F10 자동) |
| `visible` | – | default `true` |
| `customButtons` | – | 화면 전용 추가 버튼 배열 |
| `searchAction` | – | F5 단독 override (hotkeyConfig.search 외 별도 옵션) |

---

## 3. 7 사용자 요청 항목 매핑 (사용자 명시)

| 요청 | hotkeyConfig | 단축키 | 자동? | 화면 의무 코드 |
|---|---|:-:|:-:|---|
| **추가** | `insert` | F8 | 자동 (빈 row) | `() => GridAction.addRow(gridRef.current, { DIVISION_ID: filters?.divisionId ?? '81' })` (권장 default 주입) |
| **삭제** | `delete` | F9 | ✅ 자동 (default OK) | 생략 또는 `() => GridAction.removeRow(gridRef.current, true)` (hard delete 시) |
| **저장** | `save` | F7 | ⭐ 의무 | `handleSave = () => { const saveData = ...filter(CRUD_TYPE); saveWithValidation(saveData, staticColumns.X, mutate); }` |
| **Sort** | `sort` | F3 | ✅ 자동 | 생략 (DefaultButtonActions = `GridAction.toggleColumnSort`) |
| **Filter** | `filter` | F4 | ✅ 자동 | 생략 (DefaultButtonActions = `GridAction.toggleColumnFilter`) |
| **Condition** (조회조건 저장) | `condition` | F6 | ✅ 자동 + `searchParam` prop 의무 | 생략 (DefaultButtonActions = `GridAction.personalizeCondition(menuId, searchParam) + MSG00010`) |
| **Reset Condition** | `resetCondition` | F10 | ✅ 자동 (MSG00009 confirm + MSG00011 alert) | 생략 (DefaultButtonActions = `GridAction.resetPersonalizedCondition(menuId)` + `useMotherStore.reset()`) |

→ **7 요청 중 5 (sort/filter/condition/resetCondition/delete) 는 화면 코드 0 line** 으로 표준 동작. 화면 의무 = `insert` default 주입 + `save` 구현 2 항목.

---

## 4. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 사고 / 대체 |
|---:|---|---|
| 1 | 화면 안 `<Button onClick={handleInsert}>추가</Button>` 직접 작성 | SubTitle 자동 표시 무력화 / 단축키 미연결 / customButtons 사용도 금지 — `hotkeyConfig.insert` 만 |
| 2 | `useEffect(() => { window.addEventListener('keydown', ...) })` 자체 단축키 | SubTitle DefaultButtonActions 중복 → F4 wijmo datamap 사고 등. `hotkeyConfig` 만 |
| 3 | 화면 안 `XLSX.writeFile` 자체 Excel 다운로드 | `GridAction.excelDownload` + `excelFileName` prop 만 |
| 4 | 화면 안 `apiClient.post('/admin/menu/condition', searchParams)` 자체 개인화 저장 | `searchParam` prop 주입 → F6 자동 + MSG00010 alert |
| 5 | `<SubTitle>` 없이 화면 작성 | Page Shell 깨짐 — MainTitle + SubTitle 둘 다 의무 (#61) |
| 6 | `excelFileName` 누락 | Excel 다운로드 시 'Excel File' fallback (의미 없는 파일명) |
| 7 | `searchParam` 누락 | F6 condition 동작 안 함 (early return) |
| 8 | `grid` / `gridFilter` ref 미주입 (raw `useRef<FlexGrid>()` 안 주입) | sort/filter/excel/insert/delete 모두 미동작 |
| 9 | `delete` 를 화면별 `splice` 로 override | EditTracker / CRUD_TYPE='D' 누락 — `GridAction.removeRow(grid, true)` 만 (메모리 #60 §5.2) |
| 10 | `save` 호출 시 `useSaveWithValidation` 미사용 (raw `mutate` 호출) | 필수값 검증 누락 → ORA-01400 (MSG00013 미표시) |
| 11 | `save` 시 `staticColumns` 미주입 | `useSaveWithValidation` 의 `checkMandatoryColumns` 가 무력화 → 필수값 검증 0 |
| 12 | `hotkeyConfig.search` 미정의 (default alert 잔존) | F5 누를 때 "검색은 화면별로 구현하세요" alert — 사용자 경험 깨짐 |
| 13 | `customButtons` 으로 표준 7 버튼 (insert/delete/save/sort/filter/condition/resetCondition) 재구현 | 단축키 미연결 + 표시 위치 표준 깨짐 — `customButtons` 는 화면 전용 추가 액션만 |

---

## 5. PRE-WRITE 체크리스트 (작성 직전 — 12 항목)

```
[ ] 1.  <SubTitle> 컴포넌트 1 개 + hotkeyConfig 1 객체 — 자체 <Button> 추가/삭제/저장 0?
[ ] 2.  hotkeyConfig.search 정의 (default alert 회피)?
[ ] 3.  hotkeyConfig.save 정의 + useSaveWithValidation(saveData, staticColumns.X, mutate)?
[ ] 4.  hotkeyConfig.insert 정의 + GridAction.addRow(grid, { ...권한 default })?
[ ] 5.  hotkeyConfig.delete — 생략 (자동) 또는 GridAction.removeRow(grid, true)?
[ ] 6.  manual / upload — false (비활성화) 명시?
[ ] 7.  sort / filter / condition / resetCondition / excel — 생략 (자동)?
[ ] 8.  excelFileName prop 명시 (Excel 다운로드 의미 있는 이름)?
[ ] 9.  searchParam prop 주입 (F6 condition 동작)?
[ ] 10. menuId / grid / gridFilter / dataCount prop 전체 주입?
[ ] 11. 자체 keydown handler / Excel logic / personalize logic 작성 0?
[ ] 12. customButtons 은 화면 전용 추가 액션만 (표준 7 버튼 재구현 0)?
```

---

## 6. POST-WRITE grep (작성 직후 의무)

```bash
SCREEN="nscm-fe/features/{domain}/src/pages/{my-screen}"

# 1. 자체 keydown handler
grep -nE "addEventListener\\('keydown'" "$SCREEN"
# 결과 = 0 (SubTitle 이 자동)

# 2. 자체 Excel 다운로드 logic
grep -nE "XLSX\\.|excelDownload|writeFile" "$SCREEN" | grep -v "GridAction\\.excelDownload"
# 결과 = 0

# 3. 자체 추가/삭제/저장 button
grep -nE "<Button[^>]*buttonLabel=['\"](Insert|Delete|Save|Sort|Filter|Condition)" "$SCREEN"
# 결과 = 0 (SubTitle 자동 렌더링)

# 4. hotkeyConfig.search / save 정의 확인
grep -nE "search:\\s*[(]|save:\\s*[(]" "$SCREEN"
# 결과 ≥ 2 (둘 다 정의)

# 5. excelFileName 누락
grep -nE "<SubTitle" "$SCREEN" -A 15 | grep -E "excelFileName" | wc -l
# 결과 ≥ 1
```

---

## 7. customButtons — 화면 전용 추가 액션만 (DMF0005 적용 사례)

표준 7 버튼 외에 화면 전용 액션 (예: "복사", "전송", "Approval" 등) 이 필요할 때만 사용:

```tsx
const customButtons: CustomButtonProps[] = [
  {
    label: t('LBL00xxx', '_Copy'),
    action: handleCopy,
    appearance: 'outlined',
    priority: 'normal',
    size: 'small',
  },
];

<SubTitle ... customButtons={customButtons} />
```

⛔ **표준 7 버튼 (insert/delete/save/sort/filter/condition/resetCondition) 을 customButtons 로 재정의 금지** — 단축키 미연결 + 위치 표준 깨짐. 그 7 항목은 `hotkeyConfig` 으로만.

---

## 8. searchAction prop — F5 단독 override

`hotkeyConfig.search` 외에 별도 F5 핸들러 필요 시 (특수 화면):

```tsx
<SubTitle ... searchAction={() => customSearch()} />
```

→ buttonActions[F5] = searchAction (hotkeyConfig.search 무시). 보통 불필요 — `hotkeyConfig.search` 로 충분.

---

## 9. Excel 다운로드 — 자동 처리 (별도 logic 작성 금지)

```ts
// SubTitle 의 DefaultButtonActions[Hotkeys._Excel]:
() => grid.current && void GridAction.excelDownload(
  grid.current,
  excelFileName ?? 'Excel File',
  setProgress
);
```

- 화면 의무: `excelFileName='Sales Site'` 등 의미 있는 이름 주입
- `GridAction.excelDownload` (`@foundation/utils`) 내부:
  - Wijmo 의 `wijmo.grid.xlsx.FlexGridXlsxConverter` 사용 (Wijmo 표준)
  - useUIStore `setProgress` 자동 표시
  - 컬럼 메타 (admin 동적) 반영

⛔ 화면 안 `import { FlexGridXlsxConverter } from '@mescius/wijmo.grid.xlsx'` 직접 import 금지.

---

## 10. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Page Shell + Form + Store | hook `screen-shell-composition-mandatory.md` (#61) |
| Grid 영역 (DataGrid + Foundation Utils) | hook `datagrid-shared-component-mandatory.md` (#60) |
| Type/Lint 0 + Hard Boundary | hook `regression-zero-mandatory.md` (#62) |
| 폴더 구조 / Conventions | hook `screen-conventions-mandatory.md` (#63) |
| ASIS Button → TOBE 매핑 (CRUD 6 + Search Aux 4) | hook `asis-button-mapping.md` |
| SearchArea 부재 시 Search 버튼 | hook `search-button-when-no-searcharea.md` |
| GridAction 11 method 인벤토리 | hook #60 §5.2 |
| HotkeyConfig 타입 | `nscm-fe/packages/foundation/src/models/common/hotkey.ts` |
| SubTitle 실 구현 | `nscm-fe/packages/shared/src/components/organisms/sub-title/SubTitle.tsx` |

---

## 11. 검증 — PR 차단 강도

§5 PRE-WRITE 12 + §6 POST-WRITE grep 5 + §4 안티패턴 13종 모두 PR 차단 (anti-simplification 동등).
사용자 결정 (2026-06-18, 필수 항목 — "공통 버튼 기능 구현 일괄 반영").
