# 23. FE Import Inventory — alias/export 정확 매핑표

> ⭐ **신규 화면 생성/수정 시 반드시 이 문서를 먼저 참조**
> Vite Dev 서버에서 "Failed to fetch dynamically imported module" 오류는 **거의 모두 import 경로 불일치** 때문임.
> 본 문서는 nscm-fe workspace 의 **실제 export 인벤토리** (2026-05-22 기준).

작성: 2026-05-22 (DMF0020 적용 시 6종 import 오류 발생 → 본 문서 작성)
관련 hook: `hooks/fe-import-check.md`

---

## §0. Path Alias 정의 (tsconfig.base.json)

```
@admin/<screen>       → features/admin/src/pages/<screen>/index.ts
@authority/<screen>   → features/authority/src/pages/<screen>/index.ts
@master/<screen>      → features/master/src/pages/<screen>/index.ts
@demand/<screen>      → features/demand/src/pages/<screen>/index.ts
@supply/<screen>      → features/supply/src/pages/<screen>/index.ts
@factory/<screen>     → features/factory/src/pages/<screen>/index.ts
@shipping/<screen>    → features/shipping/src/pages/<screen>/index.ts
@report/<screen>      → features/report/src/pages/<screen>/index.ts

@foundation/<sub>     → packages/foundation/src/<sub>/index.ts  또는  src/lib/<sub>.ts
@shared/<sub>         → packages/shared/src/<sub>/index.ts      또는  src/lib/<sub>.ts
```

**중요**: `@foundation` / `@shared` 의 *서브 경로* 만 import 가능. **루트 `@foundation` / `@shared` import 금지**.

---

## §1. `@shared/components` (정확한 export 목록)

`packages/shared/src/components/index.ts` 가 재export 하는 **유일한 출처**.

| 컴포넌트 | export 형식 | 비고 |
|---|---|---|
| `CustomDropdown` | named | `molecules/customDropdown/CustomDropdown` |
| `CustomDropdownMui` | named | `molecules/customDropdown/CustomDropdownMui` |
| `TabWrapper`, `TabItem` | named | `molecules/tab/Tab` |
| `CustomDialog` | named (memo) | `molecules/dialog/CustomDialog` ⚠ **`Dialog` 아님** |
| `DialogNavigationType`, `DialogNavigationPosition`, `DialogNavigationSize`, `DialogNavigationProps` | type | `molecules/dialog/CustomDialog` |
| `DataGrid` | named (memo) | `organisms/data-grid/DataGrid` |
| `ColumnButton` | named | `organisms/column-button/ColumnButton` |
| `MainTitle` | named (memo) | `organisms/main-title/MainTitle` |
| `SubTitle` | named (memo) | `organisms/sub-title/SubTitle` |
| `ToastMessage` | named | `organisms/toast-message/ToastMessage` |
| `Alert` | named | `organisms/alert/Alert` |
| `SearchArea` | named | `organisms/search-area/SearchArea` |
| `SearchAreaProps` | type | `organisms/search-area/SearchArea` |
| `MessageModal` | named | `templates/modals/message-modal/MessageModal` |
| `SsoUserModal` | named | `templates/modals/sso-user-modal/SsoUserModal` |
| `SsoDeptModal` | named | `templates/modals/sso-dept-modal/SsoDeptModal` |

**⚠ 자주 오용되는 이름 (실제 미존재 — `@shared/components` 에 없음)**:
| 잘못된 이름 | 실제 위치 / 대체 |
|---|---|
| ❌ `Dialog` | ✅ `CustomDialog` (이름 변경됨) |
| ❌ `Button` | ✅ `@shared/lges` 의 `Button` |
| ❌ `InputField` | ✅ `@shared/lges` 의 `InputField` |
| ❌ `DateRangePicker` | ✅ `@shared/lges` 의 `DatePickerCalendar` (range mode) |
| ❌ `MonthPicker` | ✅ `@shared/lges` 의 `DatePickerCalendar` (month mode) |
| ❌ `DatePicker` | ✅ `@shared/lges` 의 `DatePickerCalendar` |

---

## §2. `@shared/lges` (디자인 시스템 re-export)

`packages/shared/src/lib/lges.ts` — `@lges/design-system` 의 다음 항목만 re-export:

```
Avatar, AvatarProps
ThemeSwitchProvider
Button, ButtonProps
Checkbox, CheckboxProps
DatePickerCalendar, DatePickerCalendarProps
DateRangePickerValueType                 ← 타입만 (컴포넌트 없음)
DropdownOption
FormItem, FormItemProps
Label, LabelProps
Switch, SwitchProps
TitleArea, TitleAreaProps
InputField, InputFieldProps
Tooltip, TooltipProps
DropdownField, DropdownFieldProps
Divider
ProgressIndicator
MessageBar
TextField
FileUploader
DialogNavigationSize                     ← 타입만
DetailTableLine, DetailTableRow,
DetailTableHeaderCell, DetailTableDataCell, DetailTableBox
```

**⚠ 자주 오용되는 이름 (실제 미존재 — `@shared/lges` 에 없음)**:
| 잘못된 이름 | 실제 대체 |
|---|---|
| ❌ `CheckboxField` | ✅ `Checkbox` |
| ❌ `Dialog` | ✅ `@shared/components` 의 `CustomDialog` |
| ❌ `DateRangePicker` (컴포넌트) | ✅ `DatePickerCalendar` (range 모드 prop) |
| ❌ `MonthPicker` | ✅ `DatePickerCalendar` (month 모드 prop) |
| ❌ `Form` | ✅ `FormItem` (단일 행), `@shared/components` 의 `SearchArea` (영역 컨테이너) |

---

## §3. `@shared/hooks` (오직 3개)

`packages/shared/src/hooks/index.ts`:
```
useClearAppData         ← 전체 React-Query 캐시 + persist 클리어
useSaveWithValidation   ← saveWithValidation(saveData, columns, mutate, options?)
useCustomQueryClient    ← 내부 re-export. 아래 dynamic-proc hook 들도 여기서 export
```

`useCustomQueryClient.ts` 에서 추가 export (같은 `@shared/hooks` alias 로 import):
```
useTabProcQuery<M, S>            ← 메인 조회 (SP 동적 호출)
useProcMutation<M, S, R?>        ← CRUD mutation
useTabComboQuery({ comboId })    ← 단일 콤보
useTabComboQueries({ filters })  ← 다중 콤보 (배열)
useTabLookupQuery({ lookupId })  ← 단일 룩업
useTabLookupQueries({ filters }) ← 다중 룩업
```

**⚠ 잘못된 import**: `useTabProcQuery` 를 `@foundation/query-client` 에서 import 금지. `@shared/hooks` 가 유일한 경로.

---

## §4. `@shared/stores` (정확한 export)

`packages/shared/src/stores/index.ts`:
```
useAuthStore               ← 로그인/로그아웃
useUIStore                 ← UI 전역 상태
useSessionStore            ← 세션 (userId 등)
useMessageStore            ← Alert/Confirm/Toast 트리거 (setAlert, setConfirm)
useDataGridStore           ← Grid 공통 상태 (selected row 등)
useMotherStore             ← 전역 i18n/dev 상태

// createStore 모듈에서 별도 export:
useStore                   ← zustand 'useStore' re-export
TabIdContext, useTabid     ← MDI 탭 ID context
BaseTabState (interface)
createPersistedStore<T>    ← 단일 페이지용
createPersistedStoreWithTab<T>  ← MDI 탭별 상태 (★ 신규 화면 표준)
PersistedStore<T> (type)
createStandardStore<T>     ← persist 없는 일반 store
```

---

## §5. `@shared/*` 기타 (lib subpath)

| import | 파일 | 내용 |
|---|---|---|
| `@shared/clsx` | `lib/clsx.ts` | `clsx` re-export |
| `@shared/icons` | `lib/icons.ts` | MUI icons 일부 (`ArrowDropDown`, `Add`, `Remove` 등) |
| `@shared/lges-icons` | `lib/lges-icons.ts` | `@lges/design-system/icon` 일부 (`FunctionSearchIcon` 등) |
| `@shared/mui` | `lib/mui.ts` | **정확 export 목록** 아래 §5.1 참조 |
| `@shared/panel` | `lib/panel.ts` | `react-resizable-panels` re-export (`Panel`, `PanelGroup`, `PanelSeparator`) |

**⚠ 충돌 주의**: `Button` 이 `@shared/lges` (lges-design-system) 와 `@shared/mui` (MUI) 양쪽에 존재. 디자인 시스템 우선 (`@shared/lges`) 사용.

### §5.1 `@shared/mui` 정확 export 목록 (2026-05-28 보강 — DMF0020 `Box` 오류 사고)

`packages/shared/src/lib/mui.ts` 의 **유일한** export (1줄도 추가 없이 정확):

```
Button, ButtonProps                ← @shared/lges 의 Button 우선 사용 (충돌 주의)
Typography, TypographyProps
Tooltip, tooltipClasses, TooltipProps
styled
Grid, GridProps
Stack, StackProps
useMediaQuery
InputAdornment
```

**⚠ 자주 오용되는 이름 (실제 미존재 — `@shared/mui` 에 없음)**:

| 잘못된 이름 | 실제 위치 / 대체 |
|---|---|
| ❌ `Box` | ✅ 단순 wrapper 면 `<div className={styles.X}>`. layout 이 필요하면 `<Stack>` (방향 자동). MUI Box 가 정말 필요하면 `@mui/material` 직접 import (단 비표준) |
| ❌ `Container` | ✅ `<div>` + SCSS Module |
| ❌ `Paper` | ✅ `<div>` + SCSS Module (커스텀 그림자) |
| ❌ `IconButton` | ✅ `@shared/lges` 의 `Button` + `iconComponent` prop |
| ❌ `TextField` | ✅ `@shared/lges` 의 `InputField` |
| ❌ `Select` / `MenuItem` | ✅ `@shared/components` 의 `CustomDropdown` |
| ❌ `Dialog` | ✅ `@shared/components` 의 `CustomDialog` |
| ❌ `Autocomplete` | ✅ `@shared/components` 의 `CustomDropdown` (단일/다중 모두 지원) |
| ❌ `Checkbox` | ✅ `@shared/lges` 의 `Checkbox` |

**사고 사례 (2026-05-28)**: DMF0020 SalesPriceVersionModal / ColumnTitleSetModal 작성 시 `import { Box, Stack } from '@shared/mui'` → Vite SyntaxError ("does not provide an export named 'Box'") → 화면 진입 자체 실패.

---

## §6. `@foundation/*` 인벤토리

### §6.1 `@foundation/constants`

```
HTTP_STATUS (enum), API_CONFIG       ← app-config
ROUTE_PATHS                          ← route-paths
CRUD_TYPE                            ← row-crud
CELL_INPUT_EDIT_TYPE (enum), CELL_CONTROL_TYPE (enum)  ← column-config
BUTTON_TYPE (enum)                   ← button-type
```

### §6.2 `@foundation/models`

```
// common/api-response
ApiResponse<T>, I18nResponse

// common/menu
Menu

// common/session
UserSession

// common/page-props
PageProps<M extends MenuId>

// common/column-config
RawFlexGridColumnConfig
FlexGridColumnConfig

// common/hotkey
Hotkeys (enum), HotkeyConfig

// common/combo
ComboParam, ComboResponse

// common/lookup
LookupParam, LookupResponse

// demand/forecast-price → DMF0082 전용. 신규 화면은 자체 types.ts 권장.
```

### §6.3 `@foundation/utils`

```
formatDate, formatDateTime, parseDate, ... (date)
capitalize, kebabCase, camelCase, ... (string)
formatNumber, formatCurrency, clamp, ... (number)
getUuid (ulid)
CustomMergeManager<T> (mergeManager)
DynamicColumnManager, isNonEditableDateColumn (gridColumns)
EditTracker<T> (editTracker) ← class
GridAction (gridAction) ← namespace ({ addRow, deleteRow, ... })
mapRawColumnsToWijmoColumns (columnMapping)
GridUtils (gridUtils) ← namespace ({ getBinding, ... })
```

### §6.4 `@foundation/apis`

```
apiClient        ← axios 기본
mockApiClient    ← axios mock
```

### §6.5 `@foundation/*` 기타 lib subpath

| import | export |
|---|---|
| `@foundation/dayjs` | default `dayjs` |
| `@foundation/i18n` | `t`, `useTranslation`, `I18nextProvider`, `supportedLngs`, `i18n` |
| `@foundation/isoWeek` | default plugin |
| `@foundation/lodash` | default `lodash` |
| `@foundation/query-client` | `useQuery`, `useMutation`, `useQueryClient`, `useQueries`, `UseQueryOptions`, `PersistQueryClientProvider`, `queryClient`, `idbPersister`, `useIsBusy` |

---

## §7. Global Types (자동 인식, import 불필요)

### §7.1 `configs/types/global.d.ts`

```
JsonPrimitive, JsonObject, JsonValue
WijmoPrimitive, WijmoRowItem (interface)
Lookup  ← { CODE, NAME, ... }
```

### §7.2 `configs/types/auto-imports.d.ts`

```
useTranslation   ← @foundation/i18n 의 useTranslation 이 글로벌로 노출
```

> 단, `useTranslation` 은 **import 불필요**하지만 `t` 함수는 `useTranslation()` 호출 결과에서만 얻음.
> 직접 `t(...)` 를 import 하고 싶다면 `import { t } from '@foundation/i18n'`.

### §7.3 `configs/types/procedures.d.ts`

```
ProcedureMap                                    ← 전체 SP 타입 맵
MenuId                                          ← ProcedureMap 의 key
SheetName<M>                                    ← M 의 sheet 이름
ProcRequest<M, S>                               ← request 타입
ResponseKeys<M, S>                              ← response set 이름들
ResponseData<M, S, RS?>                         ← 단일 row 타입 (★ 가장 많이 씀)
ProcResponse<M, S>                              ← 전체 response
MutateRequest<M, S, RS>
MutateResponse
```

**⚠ 신규 화면은 `procedures.d.ts` 에 entry 등록 후에만 `ResponseData<MENU_ID, ...>` 사용 가능**.
- 수동 등록 또는 `pnpm gen:procedures` 자동 생성.
- 미등록 화면에서 `ResponseData<'DMFXXXX', ...>` 사용 시 `MenuId` 제약 위반 → 타입 에러 (Vite는 통과하지만 type-check 실패).
- 임시 우회: `ResponseData<MENU_ID, SHEETS.MAIN>` 대신 `Record<string, unknown>` 사용 + 등록 후 교체.

---

## §8. `@mescius/wijmo.*` (Wijmo 직접 import)

표준 패턴 — `@shared/components` 의 `DataGrid` 가 wrapper. 그러나 타입은 직접 import:
```ts
import { type FlexGrid } from '@mescius/wijmo.grid';
import { type FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { type CellRangeEventArgs } from '@mescius/wijmo.grid';
```

⚠ Wijmo `FlexGrid` 컴포넌트 자체를 직접 사용 금지. 항상 `@shared/components` 의 `DataGrid` wrapper 사용 (`Doc/_dev_rules/12_GRID_COMMON.md`).

---

## §9. 표준 화면 import 템플릿 (복사용)

### §9.1 메인 페이지 (`<Screen>.tsx`)

```tsx
import { type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { HotkeyConfig, PageProps } from '@foundation/models';
import type { EditTracker } from '@foundation/utils';
import { GridAction } from '@foundation/utils';
import { MainTitle, SubTitle } from '@shared/components';
import { useProcMutation, useSaveWithValidation, useTabProcQuery } from '@shared/hooks';
import { useMessageStore } from '@shared/stores';

import { <Screen>Form } from './componenets/<Screen>Form';
import { <Screen>Grid } from './componenets/<Screen>Grid';
import { MENU_ID, SHEET_NAME } from './<screen>.constants';
import { use<Screen>Store } from './use<Screen>Store';
```

### §9.2 Form (검색 영역)

```tsx
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { Button, Checkbox, DatePickerCalendar, FormItem, InputField } from '@shared/lges';
import { Grid, Stack } from '@shared/mui';
import { useSessionStore } from '@shared/stores';
```

### §9.3 Modal/Popup

```tsx
import { type FlexGrid } from '@mescius/wijmo.grid';
import { useRef, useState } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { EditTracker } from '@foundation/utils';
import { CustomDialog, CustomDropdown, DataGrid } from '@shared/components';  // ★ Dialog 아님!
import { useProcMutation, useTabProcQuery } from '@shared/hooks';
import { Button, FormItem, InputField } from '@shared/lges';                   // ★ lges 에서!
import { useMessageStore } from '@shared/stores';
```

### §9.4 Hook (validation/expression)

```tsx
import { useCallback } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { GridUtils } from '@foundation/utils';
import { useMessageStore } from '@shared/stores';
```

### §9.5 Store (`use<Screen>Store.ts`)

```ts
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

import { MENU_ID, SHEETS } from './<screen>.constants';
```

---

## §10. 표준 폴더 구조 (참조: `customer-forecast-master`, `forecast-price`, `erp-edi-master`)

```
features/<domain>/src/pages/<screen>/
├── <Screen>.tsx                              ← 메인 페이지 (named export)
├── <screen>.constants.ts                     ← MENU_ID / SHEETS / RESPONSE_SET / 기타 enum
├── use<Screen>Store.ts                       ← Zustand store (createPersistedStoreWithTab)
├── index.ts                                  ← `export { <Screen> } from './<Screen>';`
├── componenets/  ← 주의: 표준 폴더명 `componenets` (오타 보존, 기존 customer-fcst-master 일관성)
│   ├── <Screen>Form.tsx
│   ├── <Screen>Form.module.scss
│   ├── <Screen>Grid.tsx
│   └── <Screen>Grid.module.scss (optional)
├── hooks/                                     ← validation/expression 분리 시
│   ├── use<Screen>Validation.ts
│   └── use<Screen>Expression.ts
└── modals/                                    ← POPUP 분리 시
    ├── <X>Modal.tsx
    └── <X>Modal.module.scss
```

> ⚠ `componenets` 오타는 기존 `customer-fcst-master` 의 표준입니다. `components` 사용 시 mixed naming. 신규 화면 **신규 작성 시 `components` 권장** 단, 기존 화면 수정 시 폴더명 그대로 유지.

신규 화면의 `index.ts` (alias `@<domain>/<screen>` 해결을 위해 필수):
```ts
export { <Screen> } from './<Screen>';
```

상위 `features/<domain>/src/index.ts` 에도 추가 (Vite HMR 안정성):
```ts
export * from './pages/<screen>/<Screen>';
```

---

## §11. Routing 등록 (3 곳 필수)

```
1. packages/foundation/src/constants/route-paths.ts
   → ROUTE_PATHS.<MENU_ID> = '<leaf-slug>'

2. apps/web/src/core/Router.tsx
   → LazyLoader 선언 + 적절한 부모 children 안에 라우트 추가

3. features/<domain>/src/index.ts
   → re-export (위 §10)
```

**DB 등록 (별도)**:
```
SCM_ADM_MNU_M, SCM_ADM_MSG_M, SCM_ADM_PROC_M, SCM_ADM_API_M,
SCM_ADM_MNU_BTN_MPG_M, SCM_MST_SHEET_COLUMNS,
SCM_ADM_USER_GR_MNU_MPG_M + ..._BTN_MPG_M  ← 권한 2 테이블 모두
```

**procedures.d.ts 등록**:
```
configs/types/procedures.d.ts → MENU_ID 의 sheet/request/response 타입
또는 `pnpm gen:procedures` 자동 갱신
```

---

## §12. Vite Dev 서버 오류 진단

| 증상 | 원인 | 해결 |
|---|---|---|
| `Failed to fetch dynamically imported module: .../index.ts` | 자식 모듈에서 export 미존재 import 발생 → Vite 500 → 부모 lazy import 실패 | 본 문서 §1~§5 cross-check |
| `500 Internal Server Error` on `.tsx` | TS 컴파일/transform 실패 | dev 서버 콘솔 로그에 정확한 import 경로 확인 |
| `lazy: Element type is invalid` | named export 누락 (default export 만 있음 등) | `export { Foo } from './Foo'` 확인 |
| 페이지 빈 화면 + 콘솔에 `MenuId` 타입 에러 | `procedures.d.ts` 에 MENU_ID 미등록 | 등록 또는 `Record<string, unknown>` 임시 사용 |

---

## ⭐ §12.A `features/master/src/components/*` 공용 Modal 인벤토리 (2026-06-02 신설)

> ⭐ **DRY 원칙: 신규 화면에서 Project/Item/Team/Region lookup popup 이 필요할 때 신규 작성 전 본 인벤토리 1차 확인. 동일 기능 있으면 그대로 import 재사용.**

작성 계기: DMF0072 NN Master Mapping 작업 시 Project/Item Popup 신규 작성 시도 → 동일 기능 modal 이 이미 customer-model-mapping/sales-site-project-model/sales-plan-waterfall 에서 사용 중 확인 → 신규 작성 없이 재사용.

### §12.A.1 인벤토리

| 컴포넌트 | menuId | sheetName | 사용 화면 | 특징 |
|---|---|---|---|---|
| `ProjectByDivisionModal` | `COM0005` | `projectByDivision` | customer-model-mapping / sales-site-project-model / sales-plan-waterfall / **nn-master-mapping (DMF0072)** | Division/Team/EndCustomer/SalesSite 사전 채움 |
| `ItemByDivisionModal` | `COM0008` | `itemByDivision` | customer-model-mapping / sales-site-project-model / sales-plan-waterfall / **nn-master-mapping (DMF0072)** / forecast-price | `headerTitle?` prop (2026-06-02) |
| `TeamModal` / `OwnerModal` / `RegionModal` / `StorageLocationModal` / `ProjectModal` | (별도) | — | sales-site-project-model | 단독 lookup |

### §12.A.2 표준 import (3단계 root-relative)

```ts
// 같은 master/src/pages/<screen> 내부:
import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';

// 다른 feature (예: features/demand) 에서:
import { ItemByDivisionModal } from 'features/master/src/components';
```

⚠️ `'../../../../components/...'` 4단계 개별 파일 path 는 표준 위반. `index.ts` re-export 활용.

### §12.A.3 공통 Props signature

```ts
interface XxxByDivisionModalProps {
  open: boolean;
  modalClose: () => void;
  setSelectedValue: (codes: string, names?: string, ...extra) => void;  // comma-join string
  preSearchParams: ProcRequest<MENU_ID, SHEET>;
  callFromCell: boolean;          // true: 단일 선택 (cell 편집), false: search 영역 호출
  headerTitle?: string;           // 화면별 헤더 커스터마이즈 (ItemByDivisionModal — 2026-06-02 추가)
}
```

### §12.A.4 `headerTitle` prop override 패턴

기존 화면 영향 0 (옵션 prop, 기본값 = 기존 i18n key).

```tsx
// 정의 측 (ItemByDivisionModal.tsx)
<h2 className='headerTitle'>{headerTitle ?? t('LBL00343', '_ItemByDivisionPopup')}</h2>

// 호출 측 (DMF0072)
<ItemByDivisionModal headerTitle='Model/Nickname Popup' ... />
```

지양: 화면별 wrapper modal 신규 작성 (중복 코드, "한 사람이 개발한 것처럼" 위반).

### §12.A.5 자기 점검 (PRE-WRITE — 신규 popup 작성 전)

```bash
# 1. master/src/components 의 기존 modal 인벤토리
ls nscm-fe/features/master/src/components/ | grep -i "modal\|popup"

# 2. 신규 작성 의도와 동일/유사한 modal 존재 여부
grep -rln "export const .*ByDivisionModal\|export const .*Modal" \
     nscm-fe/features/master/src/components/

# 3. 동일 modal + i18n header 만 다른 경우 → headerTitle prop 옵션 추가
# 4. 완전 다른 기능 → 신규 작성 (master/src/components 안에 두기)
```

**신규 작성 전 본 인벤토리 1차 확인 누락 = anti-simplification 위반.**

### §12.A.6 cross-ref

- 룰 25 §3.3 POPUP 신규 생성 vs 기존 화면 활용 분기
- 룰 12 §11 POPUP → Modal 통합 패턴
- 메모리 `reference_public_modals_master_components.md`

---

## §13. 변경 이력

- 2026-05-22 (DMF0020 사고 반영): 신규 작성.
  - 6종 import 오류 (Dialog/Button/InputField/DateRangePicker/MonthPicker/CheckboxField) 발견 → 본 문서로 항구 방지.
  - 관련 hook: `Doc/_dev_rules/hooks/fe-import-check.md`.
- **2026-06-02 (DMF0072 NN Master Mapping 작업)**: §12.A 공용 Modal 인벤토리 신설.
  - `master/src/components/{projectByDivisionModal,itemByDivisionModal,teamModal,...}` 7종 인벤토리 + cross-ref 사용 화면 표.
  - `headerTitle?` prop override 패턴 표준화 (기존 화면 영향 0).
  - 신규 작성 전 1차 확인 의무 (anti-simplification).
  - 메모리: `reference_public_modals_master_components.md`
