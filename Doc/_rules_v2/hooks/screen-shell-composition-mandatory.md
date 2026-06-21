# Hook — Screen Shell Composition (Page / Form / Hook 인프라 의무, DMF0004 master)

> **Trigger**: T01 (신규 화면 / 화면 수정) + T05 (조회조건 Form) + T07 (데이터 조회 / SAVE)
> **Master reference**: `nscm-fe/features/master/src/pages/sales-site/` (DMF0004) — 전체 4 파일
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #21, 사용자 명시 — "DMF0004 의 Grid 이외 컴포넌트도 상속·재사용 형태 룰 정리")
> **짝 hook**: #60 `datagrid-shared-component-mandatory.md` (Grid 영역)

## 0. 원칙

화면은 **`@shared`/`@foundation` 인프라를 wrap 만** 한다. 화면별 코드는 **화면 전용 도메인 로직** (drill-down filter / row → modal callback / SAVE 분기) 만 정의. Page Shell / Form / Hook / Store 의 모든 표준 동작은 인프라에서 자동 처리.

---

## 1. DMF0004 화면 구조 (4 파일 표준)

```
features/master/src/pages/sales-site/
├─ SalesSite.tsx                  ← Page Shell (MainTitle / SubTitle / Form / Grid 조립, ~225 lines)
├─ SalesSite.module.scss          ← layout grid
├─ useSalesSiteStore.ts           ← State (createPersistedStoreWithTab + searchParams + filters 분리, ~140 lines)
├─ sales-site.constants.ts        ← MENU_ID / SHEETS / SHEET_INDEX / RESPONSE_SET
├─ components/
│  ├─ SalesSiteForm.tsx           ← Form (SearchArea + FormItem + CustomDropdown + useTabComboQueries)
│  ├─ SalesSiteGrid.tsx           ← Grid (DataGrid wrap — #60 적용)
│  ├─ SalesSiteCustomerGrid.tsx   ← Grid 변형 (drill-down)
│  ├─ SalesSiteLocationGrid.tsx   ← Grid 변형
│  └─ SalesSiteBucketGrid.tsx     ← Grid 변형
└─ utils/
   └─ sales-site.util.ts          ← cell auto-sync 등 화면 전용
```

---

## 2. Page Shell 시그니처 (DMF0004 `SalesSite.tsx`)

```tsx
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState } from 'react';

import type { HotkeyConfig, PageProps } from '@foundation/models';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle, TabItem, TabWrapper } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';

export const SalesSite = ({ tabId, title }: PageProps<MENU_ID>) => {
  // 1) refs — grid 갯수만큼 배열
  const gridRefs = [useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>(), useRef<FlexGrid>()];
  const gridFilterRefs = [useRef<FlexGridFilter>(), ...];

  // 2) store selectors (atomic — 객체 비교 회피)
  const initialized = useXxxStore(s => s.initialized);
  const filters = useXxxStore(s => s.filters);
  const staticColumns = useXxxStore(s => s.staticColumns);
  const fetchStaticColumns = useXxxStore(s => s.fetchStaticColumns);
  const searchParams = useXxxStore(s => s.searchParams);
  const openSearchArea = useXxxStore(s => s.openSearchArea);
  const setOpenSearchArea = useXxxStore(s => s.setOpenSearchArea);

  // 3) 데이터 fetch (sheet 마다 useTabProcQuery)
  const { data: siteData } = useTabProcQuery<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID, sheetName: SHEETS.SITE, tabId,
    filters: filters[SHEETS.SITE],
    enabled: !!filters[SHEETS.SITE],
  });

  // 4) mutation (SAVE) — sheet 마다 useProcMutation
  const { mutate: mutateSite } = useProcMutation<MENU_ID, SHEETS.SITE>({
    menuId: MENU_ID, sheetName: SHEETS.SITE, tabId,
  });

  // 5) saveWithValidation hook (필수값 자동 검증)
  const { saveWithValidation } = useSaveWithValidation();

  // 6) handlers — GridAction 위임
  const handleInsert = () => GridAction.addRow(gridRefs[activeTab].current, { /* defaults */ });
  const handleDelete = () => GridAction.removeRow(gridRefs[activeTab].current, true);
  const handleSave = () => {
    const saveData = siteData?.salesSite?.filter(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumns.salesSite, mutateSite);
  };

  // 7) hotkeyConfig — SubTitle 이 F5/F7/F8/F9 등으로 자동 연결
  const hotkeyConfig: HotkeyConfig = {
    insert: handleInsert, save: handleSave, delete: handleDelete,
    search: () => { setSiteFilters(); void fetchStaticColumns(); },
    manual: false, upload: false,
  };

  // 8) initial fetch
  useEffect(() => {
    if (!initialized) void fetchStaticColumns();
  }, [tabId]);

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID}
        openSearchArea={openSearchArea} toggleOpenSearchArea={setOpenSearchArea} />
      <XxxForm ... />
      <SubTitle menuId={MENU_ID}
        grid={gridRefs[activeTab]} gridFilter={gridFilterRefs[activeTab]}
        dataCount={...} excelFileName='Xxx'
        hotkeyConfig={hotkeyConfig} searchParam={searchParams} />
      <XxxGrid gridRef={gridRefs[0]} gridFilterRef={gridFilterRefs[0]} data={...} />
      {showDetail && (
        <TabWrapper persist>
          <TabItem label={t('LBL00xxx', '_Xxx')}>
            <XxxDetailGrid ... />
          </TabItem>
          ...
        </TabWrapper>
      )}
    </>
  );
};
```

---

## 3. 인프라 인벤토리 (재구현 금지 — 모든 자동 처리)

### 3.1 Page Shell — `@shared/components` + `@shared/panel`

| 컴포넌트 | 자동 제공 | 화면 주입 prop |
|---|---|---|
| **MainTitle** (`@shared/components`) | breadcrumb (메뉴 트리 walk-up) / favorite toggle / Search Area on-off Switch | `title` / `menuId` / `openSearchArea` / `toggleOpenSearchArea` (+ `disableSearchArea?`) |
| **SubTitle** (`@shared/components`) | F1~F11 hotkey 자동 매핑 (F1 manual / F3 sort / F4 filter / F5 search / F6 personalize / F7 save / F8 insert / F9 delete / Ctrl+U upload / Excel) + dataCount 표시 + customButtons | `menuId` / `grid` / `gridFilter` / `dataCount` / `excelFileName` / `hotkeyConfig` / `searchParam` (+ `useHotkey?` / `visible?` / `customButtons?` / `searchAction?`) |
| **TabWrapper** + **TabItem** (`@shared/components`) | 탭 전환 + persist (모든 자식 동시 mount) + 외부 controlled 모드 (`activeTabIndex` + `setActiveTabIndex`) | `persist?` / `activeTabIndex?` / `setActiveTabIndex?` / `onTabClick?` / `onClose?` / `clearAll?` / `clearOthers?` |
| **PanelGroup** + **Panel** (`@shared/panel`) ⭐ DMF0005 발견 | **다중 grid 영역 split** (resizable horizontal/vertical 분할 — TabWrapper 와 별개 패턴: 탭 전환이 아니라 **동시 보이기 + 사용자 resize**) | `<PanelGroup orientation='vertical'>` `<Panel>` `<XxxGrid />` `</Panel>` `<Panel>` `<XxxDetailGrid />` `</Panel>` `</PanelGroup>`. 조건부 표시 (`{open && <Panel>`) 가능. Tab 패턴 vs Panel 패턴 선택: 동등 우선순위 sheet 들 = Tab / 마스터-상세 동시 보기 = Panel |

### 3.2 Form / 조회조건 — `@shared/components` + `@shared/lges` + `@shared/mui`

| 컴포넌트 | 자동 제공 | 화면 주입 prop |
|---|---|---|
| **SearchArea** (`@shared/components`) | onSearch 버튼 + onResetCondition 버튼 + onSaveOption + myOptions Chip + `extraConditions` (2단 초과 시 3단 ▼ 토글) | `searchButtonLabel` / `isHidden` / `onSearch` / `onResetCondition` / `onSaveOption` / `conditions` / `extraConditions?` / `myOptions?` |
| **FormItem** (`@shared/lges`) | label + required (*) + labelAlign + labelSize + className 표준화 | `label` / `labelAlign` / `labelSize` / `required` / `className` / `render` (prop) |
| **CustomDropdown** (`@shared/components`) | multiple / allOption / useClearIcon / limitTags / disabled — combo 표준 | `value` / `options` / `onChange` (+ `multiple?` / `allOption?` / `useClearIcon?` / `limitTags?` / `isInput?`) |
| **InputField** (`@shared/lges`) ⭐ DMF0005 발견 | text input + endAdornment (popup trigger / clear icon 등) | `value` / `onChange` / `fullWidth` / `InputProps={{ endAdornment: <Button iconComponent={<FunctionSearchIcon onClick={...} />} /> }}` — **popup 호출 표준 패턴** (3.2A 참조) |
| **Grid** (`@shared/mui`) | 12 column layout (`size={4}` = 3 칸) — MUI Grid v6 표준 | `size` |
| **Checkbox** / **Label** (`@shared/lges`) | 체크박스 + 라벨 표준 (`depth='sub'`) | `checked` / `onChange` / `labelText` |

### 3.2A 공용 Popup 모달 (Form 필드 옆 검색 버튼 → 다이얼로그)

DMF0005 SalesSiteProjectModelForm + 다수 화면이 사용하는 표준 popup 카탈로그 (`nscm-fe/features/master/src/components/`):

| 모달 | 용도 | 표준 prop 5종 |
|---|---|---|
| **ProjectByDivisionModal** | Division + 권한별 Project 검색 | `open` / `modalClose` / `setSelectedValue(string)` / `preSearchParams={...searchParams}` / `callFromCell?:boolean` |
| **ItemByDivisionModal** | Division 권한별 Item 검색 (model/nickname) | 동일 |
| **OwnerByDivisionModal** | Division 권한별 Owner (사용자) 검색 | 동일 + `ownerId?` |
| **RegionModal** (DMF0004) | 국가 + 도시 검색 | `open` / `modalClose` / `setSelectedValue(country, countryName, city, cityName)` + `country?` / `city?` |
| **EndCustomerByDivisionDept** 등 | 카탈로그 확장 | 메모리 `feedback_search_fields_catalog.md` 참조 |

> **표준 사용 패턴**:
> ```tsx
> const [openProjectModal, setOpenProjectModal] = useState(false);
> // FormItem 안 InputField endAdornment 에 검색 버튼 (3.2 InputField 행)
> <ProjectByDivisionModal
>   open={openProjectModal}
>   modalClose={() => setOpenProjectModal(false)}
>   setSelectedValue={(projects) => setSearchParams({ projectCode: projects })}
>   preSearchParams={{ ...searchParams }}    // ← 현재 division/team 등 전달 (필수)
>   callFromCell={false}                      // ← Form 호출 / Grid 셀 호출 분기
> />
> ```
>
> Grid 셀 호출 시 (cellEditEnded / dblClick): `callFromCell={true}` + cell 위치별 dataItem 매칭.

### 3.2B Icon 패키지

| Import | 사용처 |
|---|---|
| `@shared/lges-icons` | NSCM 표준 (`FunctionSearchIcon` 등) — 우선 사용 |
| `@lges/design-system/icon` | shared 미re-export 시 직접 사용 (SubTitle 내부 등) |
| 화면별 자체 svg/png import | ⛔ 금지 — 디자인 시스템 통일성 |

### 3.3 데이터 fetch / 변경 — `@shared/hooks`

| Hook | 자동 처리 | 화면 주입 |
|---|---|---|
| **useTabProcQuery<M, S>** | apiClient.callProc → BE `/proc/{menuId}/{sheetName}/{action}` + tanstack query 캐시 (queryKey = `[tabId, sheetName, procedureAction, filters]`) + tabId 변경 시 invalidate + 실패 시 alert | `{ menuId, sheetName, procedureAction?='S', tabId, filters?, enabled?=false, queryOptions? }` |
| **useProcMutation<M, S, RS>** | apiClient.callMutationProc → BE `/proc/{menuId}/{sheetName}/SAVE` + 성공 시 invalidate + 실패 alert + onSuccess/onError | `{ menuId, sheetName, procedureAction?='SAVE', tabId, onSuccess?, onError? }` |
| **useTabComboQueries({ filters: [...combo SQL_ID] })** | 다중 combo 1 round-trip (`SCM_ADM_CMBO_SQL_M` 등록 SQL_ID 배열) | `{ filters: string[] }` → 반환 = combo data 배열 |
| **useSaveWithValidation()** | `checkMandatoryColumns` (`INPUT_TP_CD` MANDATORY/MANDATORY_INSERT_ONLY 검사) → 실패 시 MSG00013 alert / 성공 시 mutate(saveData) | `saveWithValidation(saveData, staticColumns, mutate)` |

### 3.4 State — `@shared/stores`

| Utility | 자동 처리 | 의도 |
|---|---|---|
| **createPersistedStoreWithTab<T>** | tabId 기반 multi-instance store (탭 마다 독립) + sessionStorage persist + immer + 자동 `reset()` 등록 | 동일 화면 다중 탭 동시 오픈 시 state 독립 |
| **useSessionStore** | 로그인 세션 (`session.div`, `session.user_id`, `session.lang`) + 메뉴 트리 + favorite | 초기 division / 권한 분기 |
| **useMessageStore** | alert / confirm / progress | `setAlert({ type, content })` |
| **useUIStore** | 로딩 progress | `setProgress(true)` |

### 3.5 Foundation — `@foundation`

| Symbol | import | 자동 처리 |
|---|---|---|
| **PageProps<M>** | `@foundation/models` | `{ tabId, title }` 화면 entry prop |
| **HotkeyConfig** | `@foundation/models` | `{ insert, save, delete, search, manual, upload }` → SubTitle 매핑 |
| **GridAction** | `@foundation/utils` | addRow / removeRow / excelDownload / personalizeCondition 등 (#60 §5.2) |
| **apiClient** | `@foundation/apis` | `apiClient.post/get` + `callProc` / `callMutationProc` 표준 path |
| **CRUD_TYPE** | `@foundation/constants` | `'I' / 'U' / 'D'` |

---

## 4. Store 표준 패턴 (DMF0004 `useSalesSiteStore.ts`)

```tsx
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores';

interface XxxState {
  initialized: boolean;
  filters: filtersBySheet;            // ← BE 호출 trigger key (조회 버튼 누르면 갱신)
  searchParams: SearchParamProps;     // ← UI 상태 (조회 버튼 누르기 전 입력)
  staticColumns: { [sheet in RESPONSE_SET]: RawFlexGridColumnConfig[] };
  openSearchArea: boolean;
}

interface XxxAction {
  reset: () => void;
  setMainFilters: () => void;               // ← searchParams → filters 적용 (조회 trigger)
  setDetailFilters: (filter?) => void;      // ← drill-down (grid 셀 더블클릭에서 호출)
  setSearchParams: (partial) => void;       // ← UI 변경 (cascade reset 동반)
  fetchStaticColumns: () => Promise<void>;  // ← admin 동적 fetch (column + searchParam 개인화)
  setOpenSearchArea: (open?) => void;
}

const initSearchParams: SearchParamProps = {
  divisionId: useSessionStore.getState().session.div ?? '40',  // ← 로그인 division 자동
  endCustomer: 'ALL', salesSite: 'ALL', ...
};

export const useXxxStore = createPersistedStoreWithTab<XxxState & XxxAction>(
  (set, get) => ({
    ...initState,
    setMainFilters: () => set(state => {
      state.filters[SHEETS.MAIN] = { ...state.searchParams };
      state.filters[SHEETS.DETAIL] = undefined;        // ← detail reset
    }),
    setSearchParams: searchParams => {
      set(state => {
        state.searchParams = { ...get().searchParams, ...searchParams };
        if (searchParams.divisionId) {
          void state.fetchStaticColumns();              // ← division 변경 시 column 재fetch
          state.filters = initState.filters;            // ← cascade reset
        }
      });
    },
    fetchStaticColumns: async () => {
      // 1) admin 동적 column meta (sheet 마다)
      const [a, b, ...] = await Promise.all([
        apiClient.post<RawFlexGridColumnConfig[]>(
          `/admin/menu/${MENU_ID}/column`,
          { sheetNm: RESPONSE_SET.A, divisionId: get().searchParams.divisionId === '40' ? '40' : undefined }
        ),
        ...
      ]);
      set(state => { state.staticColumns = { ... }; });

      // 2) 개인화 searchParam 복원 (admin SCM_ADM_USER_SEARCH_COND_M)
      if (get().initialized) return;
      const param = await apiClient.get<{ paramNm, paramCtn }[]>(
        `/admin/menu/${MENU_ID}/search-conditions`
      );
      if (param.data.result?.length > 0) {
        const searchParams = param.data.result.reduce((acc, curr) => {
          acc[curr.paramNm] = curr.paramCtn;
          return acc;
        }, {} as SearchParamProps);
        set(state => { state.searchParams = searchParams; });
      }
      set(state => { state.initialized = true; });
    },
  }),
  'xxx'  // sessionStorage key
);
```

> **핵심 분리**: `searchParams` (UI 입력) ↔ `filters` (BE trigger). 조회 버튼 시 `setMainFilters()` 가 복사. `setSearchParams` 자체는 BE 호출 trigger 아님. 이 분리가 cascade combo (#59) + drill-down 의 기반.

---

## 5. Form 표준 시그니처 (DMF0004 `SalesSiteForm.tsx`)

```tsx
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Checkbox, FormItem, Label } from '@shared/lges';
import { Grid } from '@shared/mui';

export const XxxForm = ({ setActiveTab, openDetail, setOpenDetail }: Props) => {
  const { t } = useTranslation();
  const openSearchArea = useXxxStore(s => s.openSearchArea);
  const searchParams = useXxxStore(s => s.searchParams);
  const setSearchParams = useXxxStore(s => s.setSearchParams);
  const fetchStaticColumns = useXxxStore(s => s.fetchStaticColumns);
  const setMainFilters = useXxxStore(s => s.setMainFilters);

  // ⭐ 다중 combo 1 RT (cascade combo filter #59)
  const [divisions, endCustomers, ...] = useTabComboQueries({
    filters: ['MyDivision', 'EndCustomer', 'SoldCustomer', 'SalesSite', 'YesOrNo'],
  });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      isHidden={!openSearchArea}
      onSearch={() => { setMainFilters(); void fetchStaticColumns(); }}
      conditions={
        <>
          <Grid size={4}>
            <FormItem label={t('LBL00001', '_Div.')} labelAlign='right' required render={() => (
              <CustomDropdown
                value={searchParams.divisionId}
                options={divisions?.map(item => ({ label: item.NAME, value: item.CODE })) ?? []}
                onChange={(_, option) => setSearchParams({
                  divisionId: option, endCustomer: 'ALL', soldToCustomer: 'ALL', salesSite: 'ALL',  // ← cascade reset
                })}
              />
            )} />
          </Grid>

          <Grid size={4}>
            <FormItem label={t('LBL00080', '_End Customer')} required render={() => (
              <CustomDropdown multiple allOption useClearIcon limitTags={1}
                disabled={searchParams.divisionId === '40'}
                value={searchParams.endCustomer}
                options={
                  [...new Map(                                                   // ← Map dedup (cascade #59 §3)
                    endCustomers
                      ?.filter(item => item.DIVISION_ID === searchParams.divisionId)  // ← filter by parent
                      .map(item => [`${item.DIVISION_ID}|${item.CODE}`, item])   // ← 복합 unique key
                  ).values()].map(item => ({ label: item.NAME, value: item.CODE })) ?? []
                }
                onChange={(_, options) => setSearchParams({ endCustomer: options })}
              />
            )} />
          </Grid>

          {/* ⭐ DMF0005 패턴 — InputField + endAdornment Button → popup trigger */}
          <Grid size={3}>
            <FormItem label={t('LBL00327', '_PJT')} labelAlign='right' render={() => (
              <InputField fullWidth
                value={searchParams.projectCode}
                InputProps={{
                  endAdornment: (
                    <Button appearance='outlined' priority='normal'
                      iconComponent={
                        <FunctionSearchIcon appearance='lined'
                          onClick={() => setOpenProjectModal(true)} />
                      } />
                  ),
                }}
                onChange={e => setSearchParams({ projectCode: e.target.value })}
              />
            )} />
          </Grid>
        </>
      }
    />

    {/* ⭐ DMF0005 패턴 — 공용 popup 모달 (표준 prop 5종) */}
    <ProjectByDivisionModal
      open={openProjectModal}
      modalClose={() => setOpenProjectModal(false)}
      setSelectedValue={(projects) => setSearchParams({ projectCode: projects })}
      preSearchParams={{ ...searchParams }}
      callFromCell={false}
    />
  );
};
```

### 5.A 다중 grid 영역 — Panel vs Tab 선택 (DMF0005 vs DMF0004 비교)

| 시나리오 | 표준 | 예시 |
|---|---|---|
| **마스터-상세** (동시 보기 + 사용자 resize) | `<PanelGroup orientation='vertical'>` + `<Panel>` 다중 | DMF0005 — Production + Purchase grid 위/아래 |
| **동등 sheet 들** (탭 전환) | `<TabWrapper persist>` + `<TabItem>` 다중 | DMF0004 — Customer / Location / Bucket 탭 |
| **단일 grid** | 둘 다 미사용 | DMF0006 — CustomerModelMapping |
| **상세 영역 토글** | `{showDetail && <Panel>...</Panel>}` 또는 `<TabWrapper persist>` 안 조건부 mount | DMF0005 — `{openPurchaseGrid && <Panel>...</Panel>}` |

---

## 6. PRE-WRITE 체크리스트 (15 항목 — 신규 화면 작성 전 의무)

```
[Page Shell]
[ ] 1. import: MainTitle / SubTitle / TabWrapper / TabItem 은 @shared/components
[ ] 2. import: useTabProcQuery / useProcMutation / useSaveWithValidation 은 @shared/hooks
[ ] 3. import: GridAction / HotkeyConfig / PageProps 는 @foundation
[ ] 4. PageProps<MENU_ID> 화면 entry signature 사용
[ ] 5. hotkeyConfig 6 항목 (insert/save/delete/search/manual/upload) 정의 → SubTitle 주입

[Form]
[ ] 6. SearchArea + FormItem + CustomDropdown + Grid (@shared/mui) 표준 5 종 import
[ ] 7. useTabComboQueries 1 round-trip 로 다중 combo (filters 배열) — 화면별 개별 fetch 금지
[ ] 8. cascade reset: 부모 dropdown 변경 시 자식 'ALL' (cascade-combo-filter.md #59 §1)
[ ] 9. Map dedup 복합 unique key 의무 (cascade-combo-filter.md #59 §3)

[Form 확장 — DMF0005 추가]
[ ] 13. InputField + endAdornment Button + FunctionSearchIcon → popup 호출 패턴 (자체 <input>+<button> 금지)
[ ] 14. 공용 popup 모달 사용 (ProjectByDivisionModal / ItemByDivisionModal / OwnerByDivisionModal / RegionModal) — 표준 prop 5종 (open/modalClose/setSelectedValue/preSearchParams/callFromCell) 의무. 자체 popup 작성 금지

[Page Shell 확장 — DMF0005 추가]
[ ] 15. 다중 grid 시 PanelGroup+Panel (`@shared/panel`) 또는 TabWrapper+TabItem 중 시나리오별 선택 (§5.A) — `<div>` flex 직접 split 금지

[Store]
[ ] 10. createPersistedStoreWithTab (@shared/stores) — useState/useReducer 금지
[ ] 11. searchParams ↔ filters 분리 — setSearchParams 자체 BE trigger 금지
[ ] 12. fetchStaticColumns: column meta + searchParam 개인화 (initialized 분기) 둘 다 처리
```

---

## 7. POST-WRITE grep (작성 직후 의무)

```bash
# 1. shared 인프라 미사용 (직접 element 조립)
grep -nR "<div className=\"main-title\\|titleArea\\|searchArea\\|subTitle\"" nscm-fe/features/
# 결과 = 0 — MainTitle/SearchArea/SubTitle 컴포넌트 사용 의무

# 2. useState 로 staticColumns 정의 (store 미사용)
grep -nR "useState<.*\\(staticColumns\\|searchParams\\|filters\\)" nscm-fe/features/*/src/pages/
# 결과 = 0 — store 의무

# 3. fetch / axios 직접 호출 (apiClient / useTabProcQuery 미사용)
grep -nR "from '@tanstack/react-query'" nscm-fe/features/*/src/pages/ | grep useQuery
grep -nR "fetch(\\|axios\\." nscm-fe/features/*/src/pages/
# 결과 = 0 — useTabProcQuery / useProcMutation / apiClient.post 의무

# 4. useTabComboQueries 가 아닌 combo 개별 호출
grep -nR "callProc.*BUTTON_TYPE\\.\\(COMBO\\|LOOKUP\\)" nscm-fe/features/*/src/pages/
# 결과 = 0 — useTabComboQueries 단일 RT 의무 (cascade-combo-filter #59)

# 5. SubTitle 미사용 (또는 hotkeyConfig 누락) — 화면 표준 UX 깨짐
grep -nR "<SubTitle" nscm-fe/features/*/src/pages/ | wc -l
# 결과 = 화면 수 일치
```

---

## 8. 안티 패턴 (PR 차단)

| 안티 패턴 | 사고 | 대체 |
|---|---|---|
| `<div className='title'>` + `<button>조회</button>` 직접 | breadcrumb / favorite / hotkey 모두 누락 | `<MainTitle>` + `<SubTitle>` |
| 화면 안 `useQuery({ queryKey: [...], queryFn: () => fetch(...) })` | tabId 분리 / 캐시 invalidate / 알림 모두 누락 | `useTabProcQuery` |
| 화면 안 `axios.post / fetch` 직접 | apiClient interceptor (auth / progress / alert) 무력화 | `apiClient.post` (Save 시 `useProcMutation`) |
| combo 마다 별도 `useTabProcQuery(BUTTON_TYPE.COMBO)` | N round-trip / cache key 분산 | `useTabComboQueries({ filters: [...SQL_ID] })` 1 RT |
| `useState<XxxState>` 화면 안 직접 | tabId 분리 / persist / cascade reset 누락 | `createPersistedStoreWithTab` |
| `setSearchParams` 호출 시 즉시 BE 조회 | 조회 버튼 무력화 / 자동 fetch 폭증 | `searchParams` (UI) ↔ `filters` (BE trigger) 분리 |
| 화면 안 `<Switch>` 으로 SearchArea on/off | MainTitle 표준 위치 깨짐 | `<MainTitle openSearchArea toggleOpenSearchArea>` |
| 화면 안 hotkey 직접 (`useEffect addEventListener keydown`) | F1~F11 중복 / SubTitle 표준 매핑 충돌 | `hotkeyConfig` → SubTitle |
| `<FormItem>` 없이 `<label>+<input>` 직접 | required (*) / labelAlign / i18n 키 누락 | `<FormItem label labelAlign required render>` |
| `<select>` / 자체 dropdown | combo i18n / Map dedup / disabled 패턴 누락 | `<CustomDropdown multiple allOption useClearIcon>` |
| `<input type='text'>` + `<button>검색</button>` 직접 | popup 카탈로그 미연동 / preSearchParams 누락 / 디자인 통일성 깨짐 | `<InputField InputProps={{ endAdornment: <Button iconComponent={<FunctionSearchIcon onClick />} /> }}>` + 공용 popup 모달 |
| 화면별 자체 popup 모달 작성 (Project / Item / Owner) | 권한 / preSearchParams / callFromCell 표준 분기 누락 | `ProjectByDivisionModal` / `ItemByDivisionModal` / `OwnerByDivisionModal` (`features/master/src/components/`) 의무 |
| 화면 안 `<div style={display:flex}>` 으로 grid 분할 | 사용자 resize 불가 / 표준 split layout 깨짐 | `<PanelGroup orientation>` + `<Panel>` (`@shared/panel`) 또는 `<TabWrapper persist>` |
| `import { Icon } from 'lucide-react'` 등 외부 아이콘 직접 | 디자인 시스템 통일성 깨짐 | `@shared/lges-icons` 또는 `@lges/design-system/icon` |

---

## 9. 핵심 import 인벤토리 (fe-import-check hook §1 동기화)

```ts
// Page Shell
import { MainTitle, SubTitle, TabWrapper, TabItem } from '@shared/components';
import { Panel, PanelGroup } from '@shared/panel';   // ⭐ DMF0005 — 마스터-상세 resize split

// Form / 조회조건
import { SearchArea, CustomDropdown, CustomDialog, MessageModal } from '@shared/components';
import { Button, FormItem, Label, Checkbox, InputField, DatePickerCalendar,
         DropdownField, Switch, Tooltip, TextField, Divider } from '@shared/lges';
import { Grid, Stack, Typography } from '@shared/mui';
import { FunctionSearchIcon } from '@shared/lges-icons';   // ⭐ NSCM 표준 (또는 @lges/design-system/icon)

// 공용 popup 모달 (features/master 내부 화면 = @master/components 또는 ../../../components)
import { ProjectByDivisionModal, ItemByDivisionModal, OwnerByDivisionModal,
         RegionModal } from '../../../components';   // ⭐ DMF0004/0005 표준

// Hooks
import { useTabProcQuery, useProcMutation, useTabComboQueries,
         useSaveWithValidation } from '@shared/hooks';

// State
import { createPersistedStoreWithTab, useSessionStore,
         useMessageStore, useUIStore } from '@shared/stores';

// Foundation
import { apiClient } from '@foundation/apis';
import type { HotkeyConfig, PageProps, RawFlexGridColumnConfig } from '@foundation/models';
import { GridAction, GridUtils } from '@foundation/utils';
import { CRUD_TYPE } from '@foundation/constants';

// Wijmo (Grid 내부 ref 타입만 — Grid JSX 직접 사용 금지, #60 참조)
import type { FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';

// i18n
const { t } = useTranslation();
```

> ⚠ `Box` / `Container` / `Paper` / `IconButton` / `TextField` / `Dialog` / `Autocomplete` 는 `@shared/mui` 에 **없음** — `<div>` + `<Stack>` 또는 `@shared/lges` / `@shared/components` 사용 (메모리 `feedback_runtime_error_prevention.md`).

---

## 10. 적용 화면 표

| 화면 | Page Shell (MainTitle/SubTitle/TabWrapper or **Panel**) | Form (SearchArea+FormItem+CustomDropdown + **InputField+Popup**) | Hook (useTabProcQuery/useProcMutation/useSaveWithValidation/useTabComboQueries) | Store (createPersistedStoreWithTab + searchParams/filters 분리) |
|---|:-:|:-:|:-:|:-:|
| **DMF0004 SalesSite** ⭐ master (Tab) | ✅ TabWrapper + 4 sheet (CUSTOMER/LOCATION/BUCKET) | ✅ + RegionModal (Grid 셀 호출) | ✅ | ✅ |
| **DMF0005 SalesSiteProjectModel** ⭐ master (Panel) | ✅ **PanelGroup vertical** + Production/Purchase 동시 보기 + `{openPurchaseGrid && <Panel>}` 토글 | ✅ + ProjectByDivisionModal / ItemByDivisionModal / OwnerByDivisionModal (Form InputField 호출) | ✅ | ✅ + `openPurchaseGrid` toggle state |
| **DMF0006 CustomerModelMapping** ⭐ master (단일 grid) | ✅ MainTitle + SubTitle 만 (TabWrapper/Panel 미사용 — 단일 sheet) | ✅ | ✅ — 단일 sheet `data?.o_rc1` | ✅ |

> ⚠️ **2026-06-18 사용자 정책**: DMF0004/0005/0006 **3 화면만 master**. 다른 화면 (DMF0003/0007/0008/0020/0043/0043_01/0072 등) 은 사용자 작성/마이그레이션 화면이므로 master/reference 에서 제외.
| admin/user-management (reference) | ✅ | ✅ | ✅ | ✅ |
| admin/menu (reference) | ✅ | ✅ | ✅ | ✅ |

> 신규 화면은 DMF0004 4 파일 패턴 그대로 따른다. 8 가지 인프라 (MainTitle/SubTitle/TabWrapper/SearchArea/FormItem/CustomDropdown/useTabProcQuery/createPersistedStoreWithTab) 미사용 시 PR 차단.

---

## 11. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| Grid 컴포넌트 (DataGrid + Foundation Utils) | `datagrid-shared-component-mandatory.md` (#60) |
| Cascade combo filter 5 단계 | `cascade-combo-filter.md` (#59) |
| SearchArea 2단 초과 시 extraConditions | `search-area-extra-conditions.md` (#?) |
| Form searchFields 카탈로그 | 메모리 `feedback_search_fields_catalog.md` |
| 조회조건 Form 표준 패턴 | 메모리 `feedback_form_search_area_standard.md` |
| FE Import 경로 의무 | `fe-import-check.md` (auto-attach) |
| Runtime error prevention (alias export 인벤토리) | `runtime-error-prevention.md` |
| shared/* default prop 변경 금지 | 메모리 `feedback_shared_global_prop_change_forbidden.md` |
| Master reference 경로 (DMF0004) | `nscm-fe/features/master/src/pages/sales-site/` |

---

## 12. 검증 — PR 차단 강도

§7 grep 5 항목 모두 0 line 또는 명시 예외 (주석 + memory entry).
§6 PRE-WRITE 12 + §10 적용 화면 표 의무.
위반 시 머지 차단 (anti-simplification 동등 강도). 사용자 결정 (2026-06-18).
