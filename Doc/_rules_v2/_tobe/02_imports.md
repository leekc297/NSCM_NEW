# TO-BE 룰 02 — Import 표준 (alias / 정확 export)

> **추출 reference**: DMF0004~7 의 모든 import 통합

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | 02 |
| 토픽 | Import alias + 정확 export |
| 적용 trigger | 모든 .ts/.tsx 작성 |
| 관련 hook | `runtime-error-prevention.md`, `pre-write.md` |

---

## §1 표준 alias 인벤토리 (의무)

### §1.1 외부 lib (wijmo / react / etc)

```typescript
import { type FlexGrid, CellRange, AllowMerging, CellType } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useEffect, useRef, useState, type MutableRefObject } from 'react';
import dayjs, { type Dayjs } from '@foundation/dayjs';
import isoWeek from '@foundation/isoWeek';
```

**의무**:
- `dayjs` 는 `@foundation/dayjs` 통해서만 import (Vite locale 동적 import 우회 — 룰 26)
- wijmo 의 FlexGrid 는 `@mescius/wijmo.react.grid` (React component) 직접 import 금지 → `@shared/components/DataGrid` 사용 (룰 07)
- `@mescius/wijmo.grid` 의 `type FlexGrid` (Wijmo 클래스 타입) 만 ref 용도로 import

### §1.2 `@foundation/*` (Foundation layer)

| 경로 | export | 사용 |
|---|---|---|
| `@foundation/apis` | `apiClient` | 직접 fetch (store fetchStaticColumns 안) |
| `@foundation/constants` | `CRUD_TYPE`, `CELL_INPUT_EDIT_TYPE`, `CELL_CONTROL_TYPE` | grid cell 메타 |
| `@foundation/models` | `HotkeyConfig`, `PageProps<MENU_ID>`, `EditTracker`, `RawFlexGridColumnConfig`, `FlexGridColumnConfig` | 타입 |
| `@foundation/utils` | `GridAction`, `GridUtils`, `EditTracker` (값) | Grid 조작 |
| `@foundation/dayjs` | `dayjs` (default) | 일자 처리 |
| `@foundation/isoWeek` | `isoWeek` (default) | dayjs.extend(isoWeek) |

### §1.3 `@shared/*` (Shared layer)

| 경로 | export | 사용 |
|---|---|---|
| `@shared/components` | `MainTitle`, `SubTitle`, `SearchArea`, `CustomDropdown`, `DataGrid`, `TabWrapper`, `TabItem`, `CustomDialog` | 공용 컴포넌트 |
| `@shared/hooks` | `useTabComboQueries`, `useTabProcQuery`, `useProcMutation`, `useSaveWithValidation` | data hook |
| `@shared/stores` | `createPersistedStoreWithTab`, `useSessionStore` | Zustand store wrapper |
| `@shared/lges` | `Button`, `FormItem`, `InputField`, `Checkbox`, `Label`, `DatePickerCalendar` | LGES design system |
| `@shared/lges-icons` | `FunctionSearchIcon` 등 | 아이콘 |
| `@shared/mui` | `Grid` | MUI Grid (layout) |
| `@shared/panel` | `Panel`, `PanelGroup` | 분할 패널 (DMF0005 사용) |
| `@shared/clsx` | `clsx` | class name 조합 |

### §1.4 `@{domain}/*` (도메인 layer)

| 경로 | export | 사용 |
|---|---|---|
| `@master/components` | `ProjectByDivisionModal`, `ItemByDivisionModal`, `OwnerByDivisionModal`, `CustomerModal`, `TeamModal`, `RegionModal`, `StorageLocationModal`, `ColumnSettingModal`, `ProjectModal`, `OwnerModal` | 공용 modal |
| `@master/components/searchFields` | (Phase 5 G9/G10 신규 추가 후) DivisionField, TeamField, ... | 조회조건 카탈로그 |

### §1.5 같은 화면 내부 import

```typescript
// 메인 컴포넌트 → sub-component
import { CustomerModelMappingForm } from './components/CustomerModelMappingForm';
import { CustomerModelMappingGrid } from './components/CustomerModelMappingGrid';

// 메인 컴포넌트 → constants / store
import { MENU_ID, SHEETS } from './customer-model-mapping.constants';
import { useCustomerModelMappingStore } from './useCustomerModelMappingStore';

// sub-component → 상위 components (공용 modal)
import { ItemByDivisionModal, ProjectByDivisionModal } from '../../../components';
```

**의무**:
- 같은 폴더: `./X`
- sub 폴더: `./components/X`
- 부모 master 의 components: `../../../components` (master 도메인 안에서 상대 경로 허용 — 룰 03 §FE 의 예외)

---

## §2 핵심 export 위치 인벤토리 ⚠️ (정확성 의무)

> 사고 사례 (메모리 `feedback_runtime_error_prevention.md`): `Box` 를 `@shared/mui` 에서 import 시도 → 존재하지 않음 → 런타임 폭발.

### §2.1 `@shared/lges` 정확 export

✅ **있음**: `Button` / `FormItem` / `InputField` / `Checkbox` / `Label` / `DatePickerCalendar`

❌ **없음** (오용 사례):
- `Box` ← MUI 의 Box 직접 import 금지. `<div>` 또는 `<Stack>` 사용
- `Container` / `Paper` ← 동일
- `IconButton` ← `<Button>` 의 `iconComponent` prop 사용
- `TextField` ← `<InputField>` 사용
- `Dialog` ← `<CustomDialog>` 사용 (`@shared/components`)
- `Autocomplete` ← `<CustomDropdown>` 사용

### §2.2 `@shared/mui` 정확 export

✅ **있음**: `Grid` (MUI Grid v2)

❌ **없음**: 그 외 거의 모든 MUI 컴포넌트 (Box / Stack / Typography 등 → `@shared/lges` 또는 native HTML)

### §2.3 `@mescius/wijmo.grid` import 위치 (사고 사례)

```typescript
// ✅ 의무
import { CellRange, AllowMerging, CellType, DataMap, MergeManager } from '@mescius/wijmo.grid';

// ❌ 금지 (다른 패키지에서 시도하면 import 실패)
// import { DataMap } from '@mescius/wijmo';   // 실제로는 @mescius/wijmo.grid
```

**확인 명령**: 신규 화면 작성 시 `node_modules/@mescius/wijmo.grid/index.d.ts` 의 export grep 으로 cross-check.

---

## §3 금지 (anti-pattern)

### §3.1 상대 경로 import (`../../../`)

**금지**:
```typescript
import { useTabProcQuery } from '../../../../../shared/src/hooks';  ❌
import { GridAction } from '../../../../foundation/src/utils';      ❌
```

**의무**: alias (`@shared/hooks` / `@foundation/utils`).

**예외**: 같은 도메인 내부 `../../../components` (master/master 자기 자신 — DMF0006 grid 가 `@master/components` 대신 상대 경로 사용 — 변경 권장).

### §3.2 Feature 간 직접 import (admin → demand 등)

**금지**:
```typescript
// features/admin/src/pages/foo.tsx
import { BarComponent } from '@demand/...';   ❌
```

**의무**: 공용 컴포넌트는 `@shared/components` 또는 `@foundation/*` 로 끌어올린 후 양 도메인에서 사용.

→ apps/web 에서만 도메인 조합 가능.

### §3.3 default export

**금지**: `export default X` (페이지/store/util 모두 named export 만)

**예외**: 외부 lib (dayjs, isoWeek) 가 default export 인 경우만 `import X from '@foundation/X'`.

### §3.4 type import 누락

**금지**:
```typescript
import { FlexGrid } from '@mescius/wijmo.grid';   // 값으로 import (실제로는 type only 사용)
```

**의무**:
```typescript
import { type FlexGrid } from '@mescius/wijmo.grid';   // type-only import
// 또는
import type { FlexGrid } from '@mescius/wijmo.grid';
```

→ Tree-shaking + 빌드 성능 + ESM 호환.

### §3.5 `console.log` 잔존

**금지**: production 코드에 `console.log` / `console.debug` 잔존. `console.error` 만 허용 (예외 처리 시).

→ Lint 가 자동 차단 (`pnpm lint:fix` 시 fail).

---

## §4 자동 검증 (PR 머지 게이트)

```bash
# 1. 상대 경로 import 검출
rg -n "import.*'(\.\./){3,}" features/{domain}/src/pages/{screen}/ | wc -l   # = 0

# 2. Feature 간 import 검출 (admin → demand 등)
rg -n "from '@(demand|admin|master|factory|supply|shipping)/" features/admin/   # 동일 도메인만 OK
rg -n "from '@(demand|admin|master|factory|supply|shipping)/" features/demand/  # 동일

# 3. @shared/lges 의 Box / Container / Dialog 등 import 검출 (사고 패턴)
rg -n "from '@shared/lges'.*\{[^}]*\b(Box|Container|Paper|IconButton|TextField|Dialog|Autocomplete)\b" features/

# 4. default export 검출
rg -n "^export default " features/{domain}/src/pages/{screen}/ | wc -l   # = 0

# 5. console.log 검출
rg -n "console\.log" features/{domain}/src/pages/{screen}/ | wc -l   # = 0

# 6. type-only import 권장 (warning 만)
rg -n "import \{ FlexGrid \}" features/   # type 으로 변경 권장
```

---

## §5 AS-IS 매핑

| AS-IS | TO-BE |
|---|---|
| `using GSCM.Windows.Forms.Controls;` (UsrCombo 등) | `import { CustomDropdown } from '@shared/components';` |
| `using GSCM.Windows.Forms.Service;` (DataService) | `import { useTabProcQuery, useProcMutation } from '@shared/hooks';` |
| `using GSCM.App.Core.Security;` (UserInfoContext) | `import { useSessionStore } from '@shared/stores';` (BE 가 자동 주입 — FE 사용 거의 X) |
| `using GSCM.App.Core.Text;` (MessageHelper) | `import { useTranslation } from 'react-i18next';` + `setAlert/setConfirm` (`@shared/hooks`) |

---

## §6 reference file:line 인용

| 패턴 | reference |
|---|---|
| 표준 import 세트 (단순) | `CustomerModelMapping.tsx:1-13` (13 import) |
| 표준 import 세트 (multi-sheet) | `SalesSite.tsx:1-18` |
| `@foundation/constants` (CRUD_TYPE) | `CustomerFcstMaster.tsx:5` |
| `@foundation/dayjs + isoWeek` | `CustomerFcstMasterDateColumns.ts:2-6` |
| `@shared/panel` (Panel + PanelGroup) | `SalesSiteProjectModel.tsx:9` |
| 같은 도메인 modal import | `CustomerModelMappingForm.tsx:10` |

---

## §7 변경 이력

| 일자 | 변경 | 이유 |
|---|---|---|
| 2026-06-03 | 초안 (Phase 3 추출) | DMF0004~7 import 통합 분석 + 사고 사례 메모리 반영 |
