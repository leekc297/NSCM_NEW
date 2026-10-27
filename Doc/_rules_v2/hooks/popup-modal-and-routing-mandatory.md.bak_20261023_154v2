# Hook — Popup Modal 작성 + Router 등록 표준 (DMF0004 RegionModal master)

> **Trigger**: T01 (신규 화면 / popup 작성) + T13 (Routing / 메뉴)
> **PR 차단 강도**: ⭐⭐⭐ (anti-simplification 동등)
> **신설일**: 2026-06-18 (자가 진화 #28, 사용자 명시 — "더 누락된 거 한번만 더 확인" 보강)
> **세트 hook**: #60+#61+#62+#63+#64+#65+#66 + **#67 (본 hook)**
> **Master reference**: `nscm-fe/features/master/src/components/regionModal/` + `apps/web/src/core/Router.tsx`

## 0. 원칙

DMF0004/0005/0006 의 공용 popup 모달 (`features/master/src/components/{xxxModal}/`) 표준 5 파일 + Router 등록 4 단계 (DB / `route-paths.ts` / `Router.tsx` / FE 폴더) + SCSS class camelCase 명명 + `@foundation/lodash` wrap + `MODAL_XXX` 가상 MENU_ID 패턴.

---

## 1. 공용 Popup 모달 표준 5 파일 (RegionModal master)

### 1.1 폴더 구조
```
features/{domain}/src/components/{camelCaseModal}/   ⭐ 폴더 = camelCase! (kebab-case 아님)
├─ XxxModal.tsx               ← PascalCase 메인
├─ XxxModal.module.scss
├─ xxx-modal.constants.ts     ← kebab-case (화면 constants 표준 동일)
└─ xxxModalStore.ts           ← (선택) 자체 store
```

### 1.2 명명 매핑 표
| 항목 | 형식 | RegionModal 예 |
|---|---|---|
| 폴더 | camelCase | `regionModal/` |
| 메인 | PascalCase | `RegionModal.tsx` |
| Constants | kebab-case | `region-modal.constants.ts` |
| Store | camelCase + `Store` | `regionModalStore.ts` |

> ⚠️ **폴더가 화면(`pages/`)과 다름**: 화면 폴더 = kebab-case (`sales-site/`) / popup 폴더 = camelCase (`regionModal/`). NSCM 컨벤션 정확 준수.

### 1.3 `features/{domain}/src/components/index.ts` barrel — 모든 popup re-export
```ts
export * from './columnSettingModal/ColumnSettingModal';
export * from './regionModal/RegionModal';
export * from './ownerModal/OwnerModal';
// ... 신규 popup 추가 시 1 line 추가
```

화면에서 사용: `import { RegionModal } from '../../../components';` (4 도메인 동일)

---

## 2. Popup constants.ts 표준 (RegionModal master)

```ts
// region-modal.constants.ts
export const MODAL_REGION = 'COM0001' as const;          // ⭐ 가상 MENU_ID = 실제 admin DB popup ID
export type MODAL_REGION = typeof MODAL_REGION;

export const MODAL_SHEET_REGION = 'region' as const;     // ⭐ 가상 SHEETS
export type MODAL_SHEET_REGION = typeof MODAL_SHEET_REGION;

export const MODAL_NAME = 'countryPopup';                 // BE-FE 매핑 키 (BE 응답 키)
```

### 2.1 의무 사항
- `MODAL_XXX` const + type **듀얼 export** (#63 §2 화면 constants 와 동일 패턴)
- `MODAL_XXX = 'COMxxxx'` — **실제 admin DB `SCM_ADM_MNU_M` 의 popup MENU_ID** (가상 string 임의 작명 금지)
- `as const` 단언 의무
- `MODAL_SHEET_XXX` = popup 의 SP sheet 이름 (BE SP 호출 시 sheetName)
- `MODAL_NAME` = BE 응답 식별자 (선택)

### 2.2 다른 화면에서 ResponseData 인용 (#66 §5 cross-ref)
```tsx
// 다른 화면 Grid 에서
import type { MODAL_OWNER } from '../../../components/ownerModal/owner-modal.constants';

const handleOwnerSelected = (
  selectedUsers: ResponseData<MODAL_OWNER, 'owner', 'o_rc1'>[]
) => { ... };
```

---

## 3. Popup Modal 표준 시그니처 (RegionModal master)

```tsx
import { CellType, type FlexGrid } from '@mescius/wijmo.grid';
import { useEffect, useRef, useState } from 'react';

import _ from '@foundation/lodash';                                   // ⭐ NSCM lodash wrap
import { GridUtils } from '@foundation/utils';
import { SearchArea, DataGrid, CustomDialog } from '@shared/components';  // ⭐ CustomDialog wrap
import { useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';
import { ControlConfirmIcon } from '@shared/lges-icons';
import { Grid } from '@shared/mui';

import { MODAL_REGION, MODAL_SHEET_REGION } from './region-modal.constants';
import styles from './RegionModal.module.scss';
import { useRegionModalStore } from './regionModalStore';

interface RegionModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (countryCode: string, countryName: string, cityCode: string, cityName: string) => void;
  country?: string;
  city?: string;
}

export const RegionModal = ({ open, modalClose, setSelectedValue, country='', city='' }: Props) => {
  const { t } = useTranslation();
  const gridRef = useRef<FlexGrid<ResponseData<MODAL_REGION, MODAL_SHEET_REGION, 'o_rc1'>>>();

  const { data: regionData } = useTabProcQuery<MODAL_REGION>({
    menuId: MODAL_REGION,
    sheetName: MODAL_SHEET_REGION,
    tabId: MODAL_REGION,                          // ⭐ 가상 tabId = MENU_ID 동일
    filters: EMPTY_FILTER,
    enabled: true,
  });

  // filter state — 화면 안 useState (modalFilters)
  const [modalFilters, setModalFilters] = useState<{ country: string; city: string }>(EMPTY_FILTER);

  // 검색 filter — useState + lodash.debounce 50ms
  const handleFilterChange = _.debounce((country: string, city: string) => {
    setModalFilters({ country, city });
  }, 50);

  // 클라이언트 측 필터 (대용량 popup 데이터 BE 재호출 회피)
  const itemsSource = (regionData?.o_rc1 ?? []).filter(
    region => (region.COUNTRY_NAME ?? '').toLowerCase().includes(modalFilters.country.toLowerCase())
              && (region.CITY_NAME ?? '').toLowerCase().includes(modalFilters.city.toLowerCase())
  );

  // 셀 더블클릭 → setSelectedValue + modalClose
  const handleDblClick = (mouseEvent: MouseEvent) => { ... setSelectedValue(...); modalClose(); };

  return (
    <CustomDialog open={open} onClose={modalClose} title={t('LBL00xxx', '_Region')} ...>
      <SearchArea ... />
      <DataGrid<...> gridRef={gridRef} itemsSource={itemsSource} dblClick={handleDblClick} ... />
      <Button onClick={() => { setSelectedValue(...); modalClose(); }}>Confirm</Button>
    </CustomDialog>
  );
};
```

### 3.1 의무 props 4 + 선택 N

| Prop | 의무? | 용도 |
|---|:-:|---|
| `open` | ✅ | dialog 열림 상태 |
| `modalClose` | ✅ | 닫기 callback |
| `setSelectedValue` | ✅ | 선택 결과 전달 callback (N 인자 가능) |
| 선택 prop (`country`, `city`, `divisionId`, `preSearchParams`, `callFromCell` 등) | – | 초기값 / 호출 컨텍스트 |

### 3.2 표준 패턴
- `CustomDialog` 으로 wrap (`@shared/components`) — 자체 modal 작성 금지
- `useTabProcQuery({ tabId: MODAL_XXX })` — 가상 tabId = MENU_ID
- 검색 filter = 화면 안 `useState` (`modalFilters`) + `_.debounce(50)` 클라이언트 측 필터
- 대용량 데이터는 BE 재호출 대신 클라이언트 필터 (성능)
- 더블클릭 또는 Confirm 버튼 → `setSelectedValue(...) + modalClose()`

---

## 4. Popup 자체 Store (선택) — `xxxModalStore.ts`

```ts
// regionModalStore.ts
import { create } from 'zustand';
import { apiClient } from '@foundation/apis';

interface RegionModalState {
  initialized: boolean;
  staticColumns: RawFlexGridColumnConfig[];
}

interface RegionModalAction {
  fetchStaticColumns: () => Promise<void>;
  reset: () => void;
}

// ⭐ createPersistedStoreWithTab 미사용 — popup 은 단순 zustand create
export const useRegionModalStore = create<RegionModalState & RegionModalAction>((set, get) => ({
  initialized: false,
  staticColumns: [],
  fetchStaticColumns: async () => {
    if (get().initialized) return;
    const result = await apiClient.post<RawFlexGridColumnConfig[]>(
      `/admin/menu/${MODAL_REGION}/column`,
      { sheetNm: MODAL_SHEET_REGION }
    );
    set({ staticColumns: result.data.result, initialized: true });
  },
  reset: () => set({ initialized: false, staticColumns: [] }),
}));
```

### 4.1 의무 사항
- popup 자체 store 는 **`create()` (zustand) 만** — `createPersistedStoreWithTab` 사용 금지 (popup 은 tabId 분리 불필요)
- `initialized` flag 로 1회만 fetch
- staticColumns + reset 표준
- 화면 (다른 화면 호출 시) 마다 mount/unmount 시 reset 호출 의무

---

## 5. Router 등록 4 단계 (#63 §1.2 4 cross-check 의 구체 절차)

신규 화면 등록 시 다음 **4 위치** 모두 의무:

### 5.1 DB `SCM_ADM_MNU_M.MNU_URL`
```sql
INSERT INTO SCM_ADM_MNU_M (MNU_ID, MNU_URL, ...)
VALUES ('DMF0099', 'my-screen', ...);   -- ⭐ leaf slug only (메모리 reference_scm_adm_mnu_m_url_slug.md)
```

### 5.2 `packages/foundation/src/constants/route-paths.ts`
```ts
export const ROUTE_PATHS = {
  // ...
  DMF0004: 'sales-site',                    // ⭐ DMF{메뉴ID}: '폴더명' (kebab-case)
  DMF0005: 'sales-site-project-model',
  DMF0006: 'customer-model-mapping',
  DMF0099: 'my-screen',                     // ← 신규 추가
} as const;
```

### 5.3 `apps/web/src/core/Router.tsx`
```tsx
import { ROUTE_PATHS } from '@foundation/constants';
import { LazyLoader } from './LazyLoader';

// 1) LazyLoader 등록 (파일 상단)
const MyScreenWithTab = LazyLoader(() =>
  import('@master/my-screen').then(m => ({ default: m.MyScreen }))
  //       ⭐ alias              ⭐ 메인 export
);

// 2) Router children 배열 추가 (적절한 부모 path 아래)
{
  path: ROUTE_PATHS.MASTER,
  children: [
    {
      path: ROUTE_PATHS.DEMAND_MASTER,    // ⭐ Lv2 parent
      children: [
        { path: ROUTE_PATHS.DMF0099, element: <MyScreenWithTab /> },   // ← 신규
      ],
    },
  ],
}
```

### 5.4 FE 폴더 = `features/master/src/pages/my-screen/`
- `MENU_ID = 'DMF0099' as const`
- 폴더명 = `'my-screen'` (kebab-case)
- `index.ts` = `export { MyScreen } from './MyScreen';`

### 5.5 ⭐ 4 cross-check 동일성 의무
| Layer | 값 |
|---|---|
| DB `SCM_ADM_MNU_M.MNU_URL` | `'my-screen'` |
| `route-paths.ts` `ROUTE_PATHS.DMF0099` | `'my-screen'` |
| `Router.tsx` `import('@master/my-screen')` | `'my-screen'` |
| FE 폴더명 | `'my-screen'` |

**1 불일치 = 라우팅 404 / 메뉴 미표시 / 빌드 fail**. PR 직전 4 위치 grep cross-check 의무.

---

## 6. SCSS Class 명명 camelCase 표준 (DMF0004 master)

| 클래스 | 용도 | 화면 |
|---|---|---|
| `customForm` | FormItem 안 grid template 반응형 | DMF0004 Form |
| `customGrid` | FormItem 안 flex grid | DMF0004 Form |
| `customCheckbox` | Checkbox + Label 묶음 | DMF0004 Form |
| `formItem` | FormItem 자체 className | DMF0005/0006 Form |
| `input` | InputField / CustomDropdown className | DMF0006 Form |
| `inputWithSearch` | InputField + endAdornment Button | DMF0005/0006 Form |
| `upperGrid` / `lowerGrid` | flex-grow 비율 layout | DMF0004 master |
| `customPanelGroup` | PanelGroup className | DMF0005 |
| `GridWrapper` | grid 컨테이너 | (PascalCase 예외 — 기존 잔존, neutralize 권장) |

### 6.1 의무 사항
- **camelCase 만** — PascalCase / kebab-case 금지 (`Custom-Form` / `custom_form` ⛔)
- 표준 class 이름 (`customForm` / `formItem` / `input` 등) 우선 재사용
- 신규 class 는 의미 단어 + camelCase

### 6.2 반응형 mixin 표준
```scss
.customForm {
  @include respond-to('HD') {
    grid-template-columns: 100px auto;
  }
  @include respond-to('FHD') {
    grid-template-columns: 140px auto;
  }
}
```
- `@include respond-to('HD' | 'FHD')` 표준 mixin 사용
- 미디어 쿼리 직접 작성 (`@media (min-width: ...)`) 금지

---

## 7. `@foundation/lodash` 표준 (직접 `lodash` 금지)

```ts
import _ from '@foundation/lodash';        // ✅ NSCM 표준
import _ from 'lodash';                    // ⛔ 금지
import { debounce } from 'lodash';         // ⛔ 금지

const handleFilterChange = _.debounce(..., 50);
const grouped = _.groupBy(items, 'KEY');
```

### 7.1 의무 사항
- `@foundation/lodash` alias 만 사용
- tree-shaking 자동 (default export)
- import 경로 인벤토리 (fe-import-check.md §1) 동기화

---

## 8. PRE-WRITE 체크리스트 (Popup / Router — 12 항목)

```
[Popup 작성 시]
[ ] 1.  폴더 camelCase (`regionModal/`) — kebab-case 아님?
[ ] 2.  파일 5 표준 (XxxModal.tsx + module.scss + xxx-modal.constants.ts + xxxModalStore.ts + barrel export)?
[ ] 3.  MODAL_XXX = 실제 admin DB popup ID (`'COMxxxx'`) — 가상 임의 작명 0?
[ ] 4.  CustomDialog 으로 wrap — 자체 modal 0?
[ ] 5.  useTabProcQuery({ tabId: MODAL_XXX }) 가상 tabId 사용?
[ ] 6.  검색 filter 클라이언트 측 useState + `_.debounce(50)` — BE 재호출 0?
[ ] 7.  popup store = create() (zustand) — createPersistedStoreWithTab 미사용?
[ ] 8.  features/{domain}/src/components/index.ts barrel 에 1 line export 추가?

[Router 등록 시]
[ ] 9.  DB SCM_ADM_MNU_M.MNU_URL = '폴더명' (leaf slug)?
[ ] 10. packages/foundation/.../route-paths.ts 에 `DMFxxxx: '폴더명'` 추가?
[ ] 11. apps/web/src/core/Router.tsx LazyLoader + children 배열 추가?
[ ] 12. 4 위치 모두 '폴더명' 동일 (grep 으로 cross-check)?

[SCSS / Import]
[+] SCSS class camelCase + `@include respond-to('HD' | 'FHD')` mixin 사용?
[+] lodash 사용 시 `@foundation/lodash` 표준 import?
```

---

## 9. POST-WRITE grep (작성 직후 의무)

```bash
# 1. Popup 폴더 명명 — camelCase 확인
ls nscm-fe/features/{domain}/src/components/ | grep -v '^[a-z][a-zA-Z]*$'   # PascalCase/kebab-case 검출 = 0

# 2. 자체 modal (CustomDialog 미사용)
grep -nE "<dialog|<Dialog|<MUIDialog" nscm-fe/features/{domain}/src/components/*Modal*/*.tsx
# 결과 = 0 — CustomDialog 만

# 3. lodash 직접 import
grep -rnE "from 'lodash'" nscm-fe/features/ nscm-fe/packages/shared/
# 결과 = 0 — `from '@foundation/lodash'` 만

# 4. Router 4 cross-check (신규 화면 등록 시)
SLUG='my-screen'
grep -nE "$SLUG" packages/foundation/src/constants/route-paths.ts apps/web/src/core/Router.tsx
# 결과 ≥ 2 (route-paths.ts + Router.tsx) — 둘 다 검출 의무

# 5. SCSS class 명명 (camelCase 검증)
grep -nE "^\\.[A-Z]|^\\.[a-z-]+-[a-z]" nscm-fe/features/*/src/pages/*/*.module.scss
# 결과 — PascalCase + kebab-case 검출 시 변환 또는 검토

# 6. 미디어 쿼리 직접 사용
grep -nE '@media \\(' nscm-fe/features/*/src/pages/*/*.module.scss
# 결과 = 0 — @include respond-to() 만
```

---

## 10. 안티 패턴 (PR 차단)

| # | 안티 패턴 | 대체 |
|---:|---|---|
| 1 | popup 폴더 kebab-case (`region-modal/`) | camelCase (`regionModal/`) |
| 2 | popup 메인 파일이 폴더와 다른 이름 (`Modal.tsx`) | PascalCase + 폴더명 일치 (`RegionModal.tsx`) |
| 3 | `MODAL_XXX = 'MY_POPUP'` 임의 string | 실제 admin DB popup MENU_ID (`'COMxxxx'`) |
| 4 | 자체 `<dialog>` / `<Dialog>` (MUI 직접) | `<CustomDialog>` (`@shared/components`) |
| 5 | popup store `createPersistedStoreWithTab` | popup 은 `create()` (zustand) 단순 |
| 6 | popup 검색 시 매번 BE 호출 | 클라이언트 측 useState filter + `_.debounce(50)` |
| 7 | `import { debounce } from 'lodash'` 직접 | `import _ from '@foundation/lodash'` |
| 8 | `route-paths.ts` 미등록 화면을 Router 에 추가 | 4 위치 (DB / route-paths / Router / 폴더) 모두 동시 |
| 9 | `MNU_URL` 에 전체 경로 (`'/master/demand-master/sales-site'`) | leaf slug only (`'sales-site'`) — 메모리 `reference_scm_adm_mnu_m_url_slug.md` |
| 10 | SCSS class kebab-case (`custom-form`) 또는 PascalCase (`CustomForm`) | camelCase (`customForm`) |
| 11 | `@media (min-width: ...)` 직접 미디어 쿼리 | `@include respond-to('HD' \| 'FHD')` mixin |
| 12 | popup barrel `index.ts` 누락 (화면이 `import { Modal } from './regionModal/RegionModal'` 직접) | `features/{domain}/src/components/index.ts` 1 line export 추가 후 `from '../../../components'` |

---

## 11. 관련 hook / 메모리 cross-ref

| 항목 | 참조 |
|---|---|
| 화면 폴더 구조 / 명명 / constants 5 export | hook `screen-conventions-mandatory.md` (#63) |
| Cell→Popup 4 단계 호출 패턴 | hook #63 §7 + #66 |
| 다른 popup ResponseData 인용 | hook `grid-cell-interaction-patterns-mandatory.md` (#66) §5 |
| FE Import 경로 인벤토리 | `fe-import-check.md` (auto-attach) |
| MNU_URL leaf slug 표준 | 메모리 `reference_scm_adm_mnu_m_url_slug.md` |
| PascalCase→kebab-case 변환 사고 | 메모리 `feedback_kebab_case_consecutive_uppercase.md` |
| 메뉴 권한 / button mapping | 메모리 `reference_perm_seed_tables.md` |
| SearchArea + Form 표준 | hook `screen-shell-composition-mandatory.md` (#61) |
| 공용 popup 인벤토리 11종 | `features/master/src/components/` (regionModal / customerModal / itemByDivisionModal / ownerByDivisionModal / ownerModal / projectByDivisionModal / projectModal / storageLocationModal / teamModal / columnSettingModal / searchFields) |
| Master reference | `nscm-fe/features/master/src/components/regionModal/` + `apps/web/src/core/Router.tsx` |

---

## 12. 검증 — PR 차단 강도

§8 PRE-WRITE 12 + §9 POST-WRITE grep 6 + §10 안티패턴 12 모두 PR 차단.
사용자 cross-check 요청 (2026-06-18 "한번만 더 확인" 2 회차).
