# 03. Frontend 상세 룰 (React 19 + Turborepo + TypeScript)

> 실제 nscm-fe 코드(`features/admin/src/pages/user-management/`)를 기준으로 한 표준 패턴.
> 모든 신규 화면은 본 룰을 따라야 합니다.

## 1. 모노레포 구조

```
nscm-fe/
├── apps/
│   └── web/                  # 메인 SPA 진입점
│       ├── src/
│       │   ├── core/        # 앱 초기화 (라우터, theme, i18n provider)
│       │   ├── layout/      # 헤더/사이드바
│       │   ├── pages/       # 라우팅된 페이지 wrapper
│       │   └── mdi/         # MDI 탭 관리
│       └── package.json     # name: @web
│
├── packages/
│   ├── foundation/           # Layer 1 (framework agnostic)
│   │   └── src/
│   │       ├── apis/        # axios.ts, interceptors
│   │       ├── assets/      # 이미지, 아이콘
│   │       ├── constants/   # API_CONFIG, CRUD_TYPE 등
│   │       ├── lib/         # 외부 라이브러리 래퍼 (i18n 등)
│   │       ├── models/      # 타입 정의 (PageProps, ApiResponse 등)
│   │       ├── styles/      # SCSS 디자인 시스템
│   │       └── utils/       # GridAction, GridUtils, EditTracker 등
│   │
│   └── shared/               # Layer 2 (React 의존, framework 의존)
│       └── src/
│           ├── components/  # Button, DataTable, MainTitle, SubTitle 등
│           ├── hooks/       # useTabProcQuery, useProcMutation, useSaveWithValidation
│           ├── lges/        # LGES 디자인 시스템 컴포넌트 (FormItem, InputField)
│           ├── mui/         # MUI 래퍼 (Grid 등 LGES 테마 적용)
│           └── stores/      # Zustand 전역 (createPersistedStoreWithTab, useMessageStore)
│
└── features/                 # Layer 3 (도메인별)
    ├── admin/                # 시스템 관리 (사용자/그룹/메뉴/권한)
    ├── demand/               # DM 도메인 (Sales Plan, Mkt Fcst 등)
    ├── master/               # SCM Master 도메인
    ├── factory/              # FP (Forecast Plan, Factory)
    ├── supply/               # SCP (Supply Chain Plan)
    └── shipping/             # SSP (Sales Sourcing Plan)
        └── src/
            ├── pages/
            │   └── {kebab-case-page}/
            │       ├── {PageName}.tsx
            │       ├── {page-name}.constants.ts
            │       ├── use{PageName}Store.ts
            │       ├── index.ts
            │       └── components/
            │           ├── {PageName}Form.tsx
            │           ├── {PageName}Form.module.scss
            │           └── {PageName}Grid.tsx
            └── components/   # feature 공통 컴포넌트
```

## 2. Workspace alias

`tsconfig.json` + `vite.config.ts`에 정의된 alias를 **반드시** 사용:

| Alias | 대상 | 사용 |
|---|---|---|
| `@foundation` | `packages/foundation/src` | `import { apiClient } from '@foundation/apis'` |
| `@shared` | `packages/shared/src` | `import { MainTitle } from '@shared/components'` |
| `@admin` | `features/admin/src/pages/{name}` | `import { UserManagement } from '@admin/user-management'` |
| `@demand`, `@master`, `@factory`, `@supply`, `@shipping` | 각 features | 동일 |

**금지**: 상대 경로 `../../../packages/shared`.

## 3. 페이지 구조 (Skeleton)

화면 1개 = 5~7개 파일 (최소):

```
features/{domain}/src/pages/{kebab-page}/
├── {PageName}.tsx                  # 메인 컴포넌트 (데이터 + 조합)
├── {page-name}.constants.ts        # MENU_ID, SHEETS, RESPONSE_SET enum
├── use{PageName}Store.ts           # Zustand store (탭별 격리)
├── index.ts                        # export * (배럴)
└── components/
    ├── {PageName}Form.tsx          # 검색 영역 (SearchArea)
    ├── {PageName}Form.module.scss  # SCSS Module
    └── {PageName}Grid.tsx          # Wijmo FlexGrid 그리드
```

### 3.1 메인 컴포넌트 (`{PageName}.tsx`)

**원칙**: 데이터 관리 + 컴포넌트 조합만. UI는 components/ 하위로 위임.

```tsx
export const PageName = ({ tabId, title }: PageProps<MENU_ID>) => {
  const gridRef = useRef<FlexGrid<...>>();
  const gridFilterRef = useRef<FlexGridFilter>();

  // store 셀렉터 — 개별 셀렉터 사용 (객체 destructuring X)
  const filters = useStore(state => state.filters);
  const setFilters = useStore(state => state.setFilters);

  // 데이터 조회/저장
  const { data } = useTabProcQuery<MENU_ID>({ menuId, sheetName, tabId, filters, enabled });
  const { mutate } = useProcMutation<MENU_ID>({ menuId, sheetName, tabId });

  // 저장 핸들러
  const onSave = () => {
    const saveData = data?.o_rc?.filter(item => item.CRUD_TYPE) ?? [];
    saveWithValidation(saveData, staticColumn, mutate);
  };

  return (
    <>
      <MainTitle title={title} menuId={MENU_ID} {...} />
      <PageNameForm />
      <SubTitle menuId={MENU_ID} grid={gridRef} {...} />
      <PageNameGrid gridRef={gridRef} gridFilterRef={gridFilterRef} data={data?.o_rc ?? []} />
    </>
  );
};
```

### 3.2 Constants (`{page-name}.constants.ts`)

```ts
export const MENU_ID = 'SYS0002' as const;
export type MENU_ID = typeof MENU_ID;

export enum SHEETS {
  USER_MGMT = 'userMgmt',
  // 다중 시트면 여러 개
}

export enum RESPONSE_SET {
  USER_MGMT = 'o_rc',
  // BE Procedure가 반환하는 cursor 이름과 일치
}
```

### 3.3 Store (`use{PageName}Store.ts`)

**`createPersistedStoreWithTab`** 헬퍼 사용 — 탭별 격리 + persist.

```ts
import { apiClient } from '@foundation/apis';
import type { RawFlexGridColumnConfig } from '@foundation/models';
import { createPersistedStoreWithTab } from '@shared/stores';

interface SearchParamProps { user: string; group: string; useYn: string; }
interface State {
  initialized: boolean;
  filters?: ProcRequest<MENU_ID, SHEETS.USER_MGMT>;
  searchParams: SearchParamProps;
  staticColumns: RawFlexGridColumnConfig[];
  isOpenSearchArea: boolean;
}
interface Action {
  reset: () => void;
  setSearchParams: (p: Partial<SearchParamProps>) => void;
  setFilters: () => void;
  fetchStaticColumns: () => Promise<void>;
  setOpenSearchArea: (open?: boolean) => void;
}

const initState: State = {
  initialized: false,
  filters: undefined,
  searchParams: { user: '', group: 'ALL', useYn: 'Y' },
  staticColumns: [],
  isOpenSearchArea: true,
} as const;

export const useUserManagementStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({
    ...initState,
    reset: () => set(initState),
    setSearchParams: searchParams => set(state => {
      state.searchParams = { ...get().searchParams, ...searchParams };
    }),
    setFilters: () => set(state => {
      state.filters = { ...state.searchParams };
    }),
    fetchStaticColumns: async () => {
      const result = await apiClient.post<RawFlexGridColumnConfig[]>(
        `/admin/menu/${MENU_ID}/column`,
        { sheetNm: SHEETS.USER_MGMT }
      );
      set(state => { state.staticColumns = result.data.result; });
      // 추가 초기화 로직
    },
    setOpenSearchArea: open => set(state => {
      state.isOpenSearchArea = open ?? !state.isOpenSearchArea;
    }),
  }),
  'user-management'  // 탭 storage key (페이지마다 고유)
);
```

### 3.4 Form 컴포넌트 (`{PageName}Form.tsx`)

- 검색 조건 입력 UI
- `SearchArea` 래퍼 사용
- `FormItem` + `InputField`/`CustomDropdown` 조합
- MUI `<Grid>` 12 컬럼 시스템

```tsx
import { CustomDropdown, SearchArea } from '@shared/components';
import { useTabComboQueries } from '@shared/hooks';
import { FormItem, InputField } from '@shared/lges';
import { Grid } from '@shared/mui';
import { useTranslation } from 'react-i18next';

import { useUserManagementStore } from '../useUserManagementStore';
import styles from './UserManagementForm.module.scss';

export const UserManagementForm = () => {
  const { t } = useTranslation();
  const searchParams = useUserManagementStore(s => s.searchParams);
  const setSearchParams = useUserManagementStore(s => s.setSearchParams);
  const setFilters = useUserManagementStore(s => s.setFilters);
  const isOpenSearchArea = useUserManagementStore(s => s.isOpenSearchArea);

  const [yesOrNo, group] = useTabComboQueries({ filters: ['YesOrNo', 'UserGroup'] });

  return (
    <SearchArea
      searchButtonLabel={t('LBL00112', '_Search')}
      onSearch={setFilters}
      isHidden={!isOpenSearchArea}
      conditions={
        <>
          <Grid size={3}>
            <FormItem
              label={t('LBL00339', '_User ID(Name)')}
              labelAlign='right'
              labelSize='long'
              render={() => (
                <InputField
                  fullWidth
                  value={searchParams.user}
                  onChange={e => setSearchParams({ user: e.target.value })}
                />
              )}
            />
          </Grid>
          {/* 추가 필드 */}
        </>
      }
    />
  );
};
```

### 3.5 Grid 컴포넌트 (`{PageName}Grid.tsx`)

- `@mescius/wijmo.grid` 사용
- `DataGrid` 래퍼 활용 (`@shared/components`)
- `EditTracker`로 CRUD 추적
- `GridUtils`/`GridAction` 유틸 사용

```tsx
import { CellRange, CellType, type FlexGrid } from '@mescius/wijmo.grid';
import type { FlexGridFilter } from '@mescius/wijmo.grid.filter';
import { useRef, type MutableRefObject } from 'react';

import { CRUD_TYPE } from '@foundation/constants';
import { GridUtils, type EditTracker } from '@foundation/utils';
import { DataGrid } from '@shared/components';
import { useMessageStore } from '@shared/stores';

import type { MENU_ID, RESPONSE_SET, SHEETS } from '../user-management.constants';
import { useUserManagementStore } from '../useUserManagementStore';

interface Props {
  gridRef: MutableRefObject<FlexGrid<ResponseData<MENU_ID, SHEETS.USER_MGMT>> | undefined>;
  gridFilterRef: MutableRefObject<FlexGridFilter | undefined>;
  data: ResponseData<MENU_ID, SHEETS.USER_MGMT>[];
}

export const UserManagementGrid = ({ gridRef, gridFilterRef, data }: Props) => {
  const editTrackerRef = useRef<EditTracker<ResponseData<MENU_ID, SHEETS.USER_MGMT, RESPONSE_SET.USER_MGMT>>>();
  const staticColumns = useUserManagementStore(s => s.staticColumns);
  const { setAlert } = useMessageStore();

  return (
    <DataGrid
      gridRef={gridRef}
      gridFilterRef={gridFilterRef}
      editTrackerRef={editTrackerRef}
      data={data}
      columns={staticColumns}
      // 이벤트 핸들러
    />
  );
};
```

## 4. 상태 관리 (Zustand)

### 4.1 사용 원칙

| 항목 | 권장 |
|---|---|
| 페이지 상태 | `createPersistedStoreWithTab` (탭별 격리) |
| 전역 상태 | `useMessageStore`, `useSessionStore` 등 (packages/shared/src/stores) |
| 컴포넌트 로컬 | `useState` 가능 |
| 폼 입력 | React Hook Form (필요 시) |

### 4.2 셀렉터 사용

```tsx
// ❌ 통째로 — 리렌더링 폭발
const store = useUserManagementStore();

// ❌ destructuring — 일부 변경 시 전체 리렌더링
const { filters, setFilters, searchParams } = useUserManagementStore();

// ✅ 개별 셀렉터 — 해당 값 변경 시에만 리렌더링
const filters = useUserManagementStore(s => s.filters);
const setFilters = useUserManagementStore(s => s.setFilters);
const searchParams = useUserManagementStore(s => s.searchParams);
```

## 5. API 호출

### 5.1 표준 훅 — useTabProcQuery / useProcMutation

```tsx
import { useProcMutation, useTabProcQuery } from '@shared/hooks';

// 조회
const { data, refetch } = useTabProcQuery<MENU_ID>({
  menuId: MENU_ID,
  sheetName: SHEETS.USER_MGMT,
  tabId,
  filters,
  enabled: filters !== undefined,
});

// 저장/수정/삭제 — CRUD_TYPE 마킹 후 mutate
const { mutate } = useProcMutation<MENU_ID>({ menuId, sheetName, tabId });
```

### 5.2 직접 apiClient 호출 (특수 경우)

```tsx
import { apiClient } from '@foundation/apis';

// 컬럼 메타 조회 (Procedure 외 일반 API)
const result = await apiClient.post<RawFlexGridColumnConfig[]>(
  `/admin/menu/${MENU_ID}/column`,
  { sheetNm: SHEETS.USER_MGMT }
);
result.data.result  // BaseResponse<T>.result
```

### 5.3 에러 처리

`axios-interceptors.ts`가 자동으로:
- DB cursor 결과 코드(`O_RESULT_CURSOR[0].CODE` != 0) → throw Error
- BE 응답 코드(`response.data.code` != 0) → throw Error

화면에서는:
```tsx
const { setAlert } = useMessageStore();

try {
  await mutate(...);
  setAlert({ severity: 'success', message: '저장 완료' });
} catch (e) {
  setAlert({ severity: 'error', message: e.message });
}
```

## 6. 스타일링 (SCSS Modules)

```scss
// UserManagementForm.module.scss
.formContainer {
  display: flex;
  gap: 16px;
  padding: 8px;
}

.label {
  font-weight: 500;
  color: var(--color-text-primary);
}
```

```tsx
import styles from './UserManagementForm.module.scss';

<div className={styles.formContainer}>...</div>
```

**금지**:
- ❌ inline style `<div style={{padding: 8}}>`
- ❌ 전역 CSS 클래스 충돌
- ✅ CSS 변수 (`var(--color-*)`) — 디자인 토큰

## 7. i18n

```tsx
import { useTranslation } from 'react-i18next';
import { i18n } from '@foundation/i18n';

const { t } = useTranslation();
<button>{t('LBL00112', '_Search')}</button>  // 코드 + fallback 영문

// 현재 언어
i18n.language;  // 'ko' / 'en'
```

메시지 코드는 `public/locales/{en|ko}/...` 또는 DB `SCM_ADM_MESSAGE_M` 마스터.

## 8. 명명 규약 (재확인)

| 항목 | 규칙 | 예시 |
|---|---|---|
| Component 파일 | PascalCase | `UserManagement.tsx` |
| 폴더 | kebab-case | `user-management/` |
| 훅/스토어 | camelCase + `use` prefix | `useUserManagementStore.ts` |
| 타입 파일 | kebab-case + `.types.ts` | `user-management.types.ts` |
| 상수 파일 | kebab-case + `.constants.ts` | `user-management.constants.ts` |
| 인터페이스 | PascalCase, `I` prefix X | `interface UserManagementState` |
| 타입 | PascalCase | `type SearchParamProps = ...` |
| Enum | UPPER_SNAKE_CASE 값 | `enum SHEETS { USER_MGMT = 'userMgmt' }` |
| 함수 | camelCase, 동사 시작 | `fetchStaticColumns`, `setSearchParams` |
| 상수 변수 | UPPER_SNAKE_CASE 또는 PascalCase | `MENU_ID`, `API_CONFIG` |
| Boolean | `is*` / `has*` / `should*` prefix | `isOpenSearchArea`, `hasMenuAuth` |

## 9. 의존성 규칙 (재강조)

```
✅ apps/web      → features/* + shared + foundation
✅ features/*    → shared + foundation
✅ shared        → foundation
❌ foundation    → shared / features / apps (역방향)
❌ features/A    → features/B (Feature 간 직접)
```

Feature 간 의존이 필요하면:
- 공통 로직은 `shared`로 이동
- 또는 `apps/web`에서 조합

## 10. Testing (Vitest)

```tsx
// UserManagement.test.tsx
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { UserManagement } from './UserManagement';

describe('UserManagement', () => {
  it('renders MainTitle with given title', () => {
    render(<UserManagement tabId='tab1' title='사용자 관리' />);
    expect(screen.getByText('사용자 관리')).toBeInTheDocument();
  });
});
```

명령: `pnpm test` (전체) / `pnpm --filter @admin test` (특정 feature).

## 11. 빌드 / 배포

```bash
pnpm build         # turbo가 의존성 그래프 따라 병렬 빌드
pnpm preview       # apps/web preview 서버
```

산출물: `apps/web/dist/`.

## 12. ⭐ Wijmo Grid 에 As-Is Validation / Expression 적용 (필수)

### 12.1. 원칙

신규 화면 1개를 생성할 때 다음 두 산출물의 **모든 행**이 To-Be 코드에 매핑되어야 한다:

- **Validation**: `Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/validation.md` (총 2,683건)
- **Expression**: `Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/expressions.md` (총 1,766건)
- **Excel 시트**: `{27|28|29}_*_Screens/*_{화면ID}.xlsx` 의 `11_Validation` + `12_Expression`

### 12.2. 권장 폴더 구조 (Validation/Expression hook 분리)

```
features/demand/src/pages/dmf0021-sales-plan/
├── Dmf0021SalesPlan.tsx
├── hooks/
│   ├── useDmf0021Data.ts            # useTabProcQuery
│   ├── useDmf0021Validation.ts      # ⭐ Validation.md 행 100% 반영
│   └── useDmf0021Expression.ts      # ⭐ Expressions.md 행 100% 반영
├── components/
│   ├── Dmf0021SalesPlanGrid.tsx     # FlexGrid (일반) 또는 FlexSheet (Cell.Formula 사용 시)
│   └── Dmf0021SalesPlanForm.tsx
├── stores/  / types/  / constants/
└── __asis-mapping__.md              # ⭐ 매핑 매트릭스
```

### 12.3. FlexGrid vs FlexSheet 선택

| 케이스 | 컴포넌트 |
|---|---|
| 일반 데이터 그리드 (편집 + 조회 + 합계) | **FlexGrid** (`@mescius/wijmo.react.grid`) |
| Excel-like `Cells[r,c].Formula = "=..."` 사용 | **FlexSheet** (`@mescius/wijmo.react.grid.sheet`) |
| 피벗/다축 집계 | **PivotGrid** |

> DM 49 화면 중 5건만 Cell.Formula 사용 (예: DMF0009_BizPlanPrice_Input). 나머지는 모두 FlexGrid.

### 12.4. 7 패턴 매핑 표 (Validation)

| As-Is | To-Be Wijmo |
|---|---|
| `MessageHelper.GMessageBox("MSG####")` | `showAlert(t('msg.MSG####'))` |
| `MessageBox.Show(...)` | `await confirm({ message })` |
| `GetColumnIndex(...) == -1` | `if (!grid.columns.getColumn(name)) return;` |
| 사전 검증 `if (조건) return/break` | Zod schema + form validator |
| Grid 이벤트 (`_CellChange`) | `grid.cellEditEnding.addHandler` / `cellEditEnded` |
| 권한 분기 (`UserInfo.IsJVPlanner`) | `useUserStore` 셀렉터 |
| 사업부 분기 (40/81/82) | `switch (division)` — 통합 금지, 그대로 보존 |

### 12.5. 6 패턴 매핑 표 (Expression)

| As-Is | To-Be Wijmo |
|---|---|
| `Cells[r,c].Formula = "=SUM(...)"` | `sheet.setCellData(r, c, '=SUM(...)', false, true)` (FlexSheet) |
| 합계변수 `iSum/dblTotal` | `<FlexGridColumn aggregate="Sum" />` 또는 `CollectionView.groupDescriptions` |
| `LockRange(...)` / `.Locked = true/false` | `cellEditEnding` + `e.cancel = true` 또는 `isReadOnly={(item) => ...}` |
| `SetValue(r, c, expr)` 산술 | `cellEditEnded` 핸들러 내 row 갱신 + `s.invalidate()` |
| `ColumnHeaderSpan(..., "SUM", ...)` | `groupHeaderFormat` 또는 footer row |
| `_CellChange` 이벤트 계산 | `grid.cellEditEnded.addHandler` |

### 12.6. 표준 코드 (Validation Hook)

```ts
// features/demand/src/pages/dmf0021-sales-plan/hooks/useDmf0021Validation.ts
import { z } from 'zod';
import { useUserStore } from '@shared/stores';
import { t } from '@foundation/lib/i18n';
import type { Dmf0021Row } from '../types/dmf0021.types';

// AS-IS: DMF0021_SalesPlan.cs:1234 — MessageHelper.GMessageBox("MSG0001")
const baseSchema = z.object({
  DIVISION_ID: z.string().min(1, 'msg.MSG0001'),
  // ... (validation.md 행마다 1:1 매핑)
});

export function useDmf0021Validation(division: string) {
  const isJvPlanner = useUserStore((s) => s.isJvPlanner);

  return (row: Dmf0021Row): string[] => {
    const errors: string[] = [];
    const parsed = baseSchema.safeParse(row);
    if (!parsed.success) errors.push(...parsed.error.errors.map((e) => e.message));

    // AS-IS: cs:440 — 사업부 분기 (반드시 보존)
    switch (division) {
      case '40': /* AS-IS: cs:441-460 */ break;
      case '81': /* AS-IS: cs:461-475 */ break;
      case '82': /* AS-IS: cs:476-490 */ break;
    }

    // AS-IS: cs:512 — 권한 분기
    if (isJvPlanner && !row.JV_PLAN_REASON) errors.push('msg.MSG0456');

    return errors;
  };
}
```

### 12.7. 표준 코드 (Expression — 조건부잠금)

```tsx
// AS-IS: DMF0021_SalesPlan.cs:994 — siMain.LockRange(i, j, ..., false)
const onCellEditEnding = (s: wjGrid.FlexGrid, e: wjGrid.CellEditEndingEventArgs) => {
  const row = s.rows[e.row].dataItem as Dmf0021Row;
  const col = s.columns[e.col].binding!;
  // AS-IS: cs:994 — INSERT 행만 편집 가능
  if (row.CRUD_TYPE !== 'I' && col === 'DIVISION_ID') {
    e.cancel = true;
  }
};
```

### 12.8. 매핑 매트릭스 (필수 파일)

`features/{domain}/src/pages/{page}/__asis-mapping__.md`:

```markdown
# DMF0021 As-Is → To-Be 매핑

## Validation (총 141건)

| # | As-Is Line | As-Is Code | To-Be 위치 | 상태 |
|---:|---:|---|---|---|
| 1 | 335 | `if (sDivision != null...)` | hooks/useDmf0021Validation.ts:32 | ✅ |
| 2 | 337 | `if (sDivision == "82")` | hooks/useDmf0021Validation.ts:35 | ✅ |
| ... | ... | ... | ... | ... |

## Expression (총 120건)
...
```

### 12.9. 자기 점검

```
[ ] validation.md 행 수 = useXxxValidation 반영 건수
[ ] expressions.md 행 수 = useXxxExpression / cellTemplate 반영 건수
[ ] 각 적용 코드에 // AS-IS: 라인 주석 포함?
[ ] __asis-mapping__.md 작성?
[ ] 사업부 분기(40/81/82) 통합/단순화 없이 보존?
[ ] Cell.Formula 사용 화면은 FlexSheet 적용?
[ ] MSG#### → t('msg.MSG####') 변환?
```

→ **상세**: [`09_WIJMO_VALIDATION_EXPRESSION.md`](09_WIJMO_VALIDATION_EXPRESSION.md)

---

> 본 룰은 실제 `features/admin/src/pages/user-management/`를 기준으로 작성됐습니다.
> 신규 화면은 이 패턴을 그대로 복사하여 시작하세요.
> ⭐ As-Is Validation/Expression 누락 0건이 PR 머지 조건입니다.
