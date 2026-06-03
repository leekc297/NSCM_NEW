# 15. 라우팅 + MDI 탭 + LazyLoader

> NSCM 의 페이지 네비게이션 시스템. React Router v6 + MDI (Multi Document Interface) 탭 + lazy-load 화면 코드 분할.
>
> ⭐ **선행 룰**: [`03_FE_RULES.md`](03_FE_RULES.md), [`05_SCREEN_TEMPLATE.md`](05_SCREEN_TEMPLATE.md), [`11_AUTH_SECURITY.md`](11_AUTH_SECURITY.md) (메뉴 권한)
> ⭐ **연관**: [`17_NEW_SCREEN_QUICKSTART.md`](17_NEW_SCREEN_QUICKSTART.md) (신규 화면 라우트 등록)

---

## 1. 한 줄 요약

```
[Login] → useSessionStore.login() → 세션 메뉴 트리 수신
  ↓
[MainLayout] = Header + Sidebar(메뉴) + MDIContainer(탭 + Outlet)
  ↓ 사이드바 메뉴 클릭
[MDIStore].openTab(menu)
  ↓ tabs 배열에 추가 + router.navigate('/' + mnuUrl)
[React Router] / → MainLayout → MDIContainer → Outlet
  ↓ URL 매칭
[LazyLoader] = lazy(() => import('@feature/page'))
  ↓ Suspense fallback (ProgressIndicator)
[Page Component] tabId / title / menu props
```

---

## 2. 핵심 파일 위치

```
nscm-fe/apps/web/src/
├── core/
│   ├── App.tsx                 ← RouterProvider 진입점
│   ├── Providers.tsx           ← QueryClient + I18nextProvider + ...
│   ├── Router.tsx              ← createBrowserRouter (라우트 트리 전체)
│   └── LazyLoader.tsx          ← lazy() + Suspense + MDIStore 연동
├── layout/
│   ├── MainLayout.tsx          ← Header + Sidebar + MDIContainer
│   ├── header/Header.tsx       ← 로고/언어/사용자
│   └── sidebar/Sidebar.tsx     ← 메뉴 트리 (session.menus)
├── mdi/
│   ├── MDIContainer.tsx        ← Tabs + Outlet (현재 활성 탭 페이지)
│   ├── MDITabs.tsx             ← 탭 헤더 UI
│   ├── useMDIStore.ts          ← Zustand: tabs[] / activeIndex / openTab / closeTab
│   └── MDI.types.ts            ← AnyTab type
└── pages/
    ├── Home.tsx                ← 홈 (tabId='tab-home', closable=false)
    ├── NotFound.tsx            ← 404
    └── Templates.tsx           ← /ui (디자인 시스템 데모)

nscm-fe/packages/foundation/src/constants/route-paths.ts   ← ROUTE_PATHS 상수
```

---

## 3. 라우트 트리 구조 (React Router v6)

`Router.tsx` 의 `createBrowserRouter` 가 단일 트리 정의. 모든 페이지가 `MainLayout` 하위.

```tsx
createBrowserRouter([
  {
    path: '/',
    element: <MainLayout />,            // 헤더 + 사이드바 + MDI
    children: [
      { index: true, element: <Navigate to={ROUTE_PATHS.HOME} replace /> },
      { path: ROUTE_PATHS.HOME, element: <HomePage /> },

      // 도메인별 nested route
      {
        path: ROUTE_PATHS.ADMIN,        // 'admin'
        children: [
          {
            path: ROUTE_PATHS.SYSTEM,    // 'system'
            children: [
              { path: ROUTE_PATHS.SYS0001, element: <MessageManagementPageWithTab /> },
              { path: ROUTE_PATHS.SYS0002, element: <UserManagementPageWithTab /> },
              // ...
            ],
          },
        ],
      },

      // 동일 패턴: master / demand / report / authority

      { path: '*', element: <NotFoundPage /> },
    ],
  },
]);
```

> **3 단계 nested**: 도메인 (`admin`) → 카테고리 (`system`) → 화면 (`message-management`).
> 전체 URL 예시: `/admin/system/message-management`.

---

## 4. `ROUTE_PATHS` 상수 — 단일 진실의 소스

`foundation/src/constants/route-paths.ts` 에 모든 URL slug 등재:

```ts
export const ROUTE_PATHS = {
  HOME: 'home',
  ADMIN: 'admin',
  SYSTEM: 'system',
  MASTER: 'master',
  DEMAND: 'demand',
  DEMAND_PLAN: 'demand-plan',
  // ...

  // MENU_ID → slug 매핑 (leaf only)
  SYS0001: 'message-management',
  SYS0002: 'user-management',
  // ...
  DMF0004: 'sales-site',
  DMF0007: 'customer-fcst-master',
  DMF0082: 'forecast-price',
} as const;
```

### 4.1 신규 화면 추가 시
```
[ ] ROUTE_PATHS 에 신규 MENU_ID 1 행 추가 (slug 만, 부모 경로 X)
[ ] Router.tsx 의 적절한 nested children 에 { path: ROUTE_PATHS.{MENU_ID}, element: <{Page}WithTab /> } 추가
```

### 4.2 ❌ DB MNU_URL 에 전체 경로 저장 금지
- ✅ `SCM_ADM_MNU_M.MNU_URL` = `'sales-future-price'` (leaf slug 만)
- ❌ `MNU_URL` = `'/master/demand-master/sales-future-price'` (전체 경로 X)
- 사이드바가 부모 트리를 walk-up 하여 전체 경로 조립 (`useSessionStore.findMenuPath()`).

> 메모리 `reference_scm_adm_mnu_m_url_slug.md` 참조.

---

## 5. `LazyLoader` — 화면 코드 분할

```tsx
const UserManagementPageWithTab = LazyLoader(() =>
  import('@admin/user-management').then(m => ({ default: m.UserManagement }))
);
```

### 5.1 LazyLoader 의 책임
1. `React.lazy()` 로 동적 import (번들 분할 → 초기 로드 가속)
2. `<Suspense fallback={Spinner}>` 으로 로딩 중 ProgressIndicator 표시
3. **현재 활성 MDI 탭의 `tabId` / `title` / `menu`** props 자동 주입
4. 화면 컴포넌트는 단순히 `PageProps<MENU_ID>` 수신

### 5.2 페이지 컴포넌트 시그니처
```tsx
import { type PageProps } from '@foundation/models';
import type { MENU_ID } from './user-management.constants';

export const UserManagement = ({ tabId, title, menu }: PageProps<MENU_ID>) => {
  // tabId — 같은 화면 여러 탭 열 때 격리에 사용 (Zustand store key)
  // title — i18n 키 (예: 'MNU_SYS0002')
  // menu — 현재 탭의 Menu 객체 (mnuId, mnuUrl, ...)
};
```

> ❌ 페이지 컴포넌트 export 형식 변경 금지: 반드시 `named export` + `PageProps<MENU_ID>`.

---

## 6. MDI (Multi Document Interface) 탭

### 6.1 동작

```
[Sidebar] 메뉴 클릭
  ↓
useMDIStore.getState().openTab(menu)
  ↓
- 같은 mnuId 탭이 이미 있으면 (현재는 그냥 추가)
- 새 tabId (UUID) 생성
- tabs 배열에 추가
- activeIndex = tabs.length - 1
- router.navigate('/' + mnuUrl) — URL 갱신
  ↓
LazyLoader 가 activeIndex 의 tab.tabId 를 페이지에 주입
  ↓
페이지의 Zustand store 가 tabId 별로 격리 (createPersistedStoreWithTab)
```

### 6.2 `MDIStore` API

```ts
useMDIStore(state => state.tabs);          // 열린 탭 목록
useMDIStore(state => state.activeIndex);   // 현재 활성 탭 인덱스
useMDIStore(state => state.openTab);       // 메뉴 → 새 탭 열기
useMDIStore(state => state.setActiveTab);  // 탭 전환
useMDIStore(state => state.closeTab);      // 탭 닫기
useMDIStore(state => state.closeOtherTabs);
useMDIStore(state => state.closeAllTabs);
```

### 6.3 `tabId` 격리

같은 화면 (예: user-management) 을 여러 탭에서 열면 각 탭이 독립적 상태를 가져야 함:

```ts
// 페이지의 Zustand store 정의
export const useUserManagementStore = createPersistedStoreWithTab<State & Action>(
  (set, get) => ({ ... }),
  'user-management'    // store key (tabId 와 자동 조합)
);
```

→ `createPersistedStoreWithTab` 내부에서 `tabId + storeKey` 로 격리.

### 6.4 `TabIdContext`

`MDIContainer` 가 `TabIdContext.Provider` 로 활성 tabId 를 하위 트리에 전달:

```tsx
<TabIdContext.Provider value={tabs[activeIndex].tabId}>
  <Outlet />   {/* 페이지 컴포넌트가 여기서 렌더링 */}
</TabIdContext.Provider>
```

페이지에서 직접 `useContext(TabIdContext)` 호출 X — LazyLoader 가 props 로 주입.

### 6.5 홈 탭은 닫을 수 없음
```ts
const homeTab: AnyTab = {
  tabId: 'tab-home',
  mnuId: 'home',
  mnuUrl: ROUTE_PATHS.HOME,
  mnuMsgId: 'LBL00312',
  closable: false,        // X 버튼 표시 안 함
};
```

---

## 7. 권한 가드 (라우트 단계)

NSCM 은 별도의 PrivateRoute 컴포넌트가 없습니다. 권한은 **BE 단에서** `@AuthCheck(Type.ALL)` 로 처리:

- 라우트는 권한 무관 (URL 접근 자체는 허용)
- 페이지 진입 후 `useTabProcQuery` 호출 시 BE 가 403 응답
- axios 인터셉터가 403 → Alert 표시 (`14_ERROR_HANDLING.md`)
- 사이드바는 `session.menus` 만 표시 → 권한 없는 메뉴는 노출 안 됨

→ 상세: [`11_AUTH_SECURITY.md`](11_AUTH_SECURITY.md) §4.3

> 권한 분기를 라우트에서 처리하려는 시도 (PrivateRoute 등) 금지. **메뉴 트리 필터링 + BE 권한 체크** 2단으로 충분.

---

## 8. 신규 화면 라우트 등록 — 3 step

### Step A: `ROUTE_PATHS` 상수 추가
```ts
// foundation/src/constants/route-paths.ts
export const ROUTE_PATHS = {
  // ...
  DMF0099: 'sales-monitor',    // ★ leaf slug
} as const;
```

### Step B: `Router.tsx` 에 LazyLoader + 라우트 추가
```tsx
const SalesMonitorPageWithTab = LazyLoader(() =>
  import('@demand/sales-monitor').then(m => ({ default: m.SalesMonitor }))
);

// children 트리에서 적절한 위치 (도메인 → 카테고리)
{
  path: ROUTE_PATHS.DEMAND,
  children: [
    {
      path: ROUTE_PATHS.DEMAND_PLAN,
      children: [
        { path: ROUTE_PATHS.DMF0099, element: <SalesMonitorPageWithTab /> },  // ★
      ],
    },
  ],
}
```

### Step C: DB 메뉴 등록 시 `MNU_URL` 확인
```sql
-- BLOCK 2: SCM_ADM_MNU_M
INSERT INTO SCM_ADM_MNU_M (MNU_ID, MNU_URL, ...)
VALUES ('DMF0099', 'sales-monitor', ...);   -- ★ leaf slug 만 (부모 경로 X)
```

---

## 9. 흔한 실수

### 9.1 `MNU_URL` 에 전체 경로 저장
- 결과: 사이드바 walk-up 후 `/demand/demand-plan/demand/demand-plan/sales-monitor` 같은 잘못된 URL.
- 해결: leaf slug 만 (`'sales-monitor'`).

### 9.2 `ROUTE_PATHS` 누락 → `Router.tsx` 에 하드코딩
- 결과: 메뉴 이동 시 URL slug 불일치 (DB vs Router.tsx).
- 해결: 항상 `ROUTE_PATHS.{MENU_ID}` 사용.

### 9.3 LazyLoader 없이 직접 import
- 결과: 초기 번들에 모든 화면 포함 → 첫 로드 지연.
- 해결: 모든 화면 페이지는 `LazyLoader(() => import(...))` 경유.

### 9.4 페이지 컴포넌트가 default export
- 결과: LazyLoader 의 `m.SalesMonitor` 접근 실패.
- 해결: `export const SalesMonitor = ...` (named) 만 사용.

---

## 10. 자기 점검 체크리스트

```
[ ] ROUTE_PATHS 에 신규 MENU_ID 1행 (leaf slug 만)
[ ] Router.tsx 에 LazyLoader + nested children 등록
[ ] DB SCM_ADM_MNU_M.MNU_URL = leaf slug (전체 경로 금지)
[ ] 페이지 컴포넌트 named export (default 금지)
[ ] PageProps<MENU_ID> 타입 정확 적용 (tabId/title/menu)
[ ] tabId 별 store 격리 (createPersistedStoreWithTab)
[ ] 사이드바 walk-up 으로 전체 경로 조립됨을 확인 (useSessionStore.findMenuPath)
[ ] 라우트 단계 권한 가드 없음 (BE @AuthCheck + 사이드바 필터링이 책임)
```

---

## 11. 관련 문서

| 룰 | 주제 |
|---|---|
| [`03_FE_RULES.md`](03_FE_RULES.md) | apps/web 모노레포 구조 |
| [`05_SCREEN_TEMPLATE.md`](05_SCREEN_TEMPLATE.md) | 페이지 컴포넌트 표준 폴더 구조 |
| [`08_SCREEN_REGISTRATION.md`](08_SCREEN_REGISTRATION.md) | BLOCK 2 SCM_ADM_MNU_M (MNU_URL) 등록 |
| [`11_AUTH_SECURITY.md`](11_AUTH_SECURITY.md) §4 | @AuthCheck 기반 BE 권한 |
| [`17_NEW_SCREEN_QUICKSTART.md`](17_NEW_SCREEN_QUICKSTART.md) | 신규 화면 추가 9 step |
| 메모리 `reference_scm_adm_mnu_m_url_slug.md` | MNU_URL leaf slug 룰 |
