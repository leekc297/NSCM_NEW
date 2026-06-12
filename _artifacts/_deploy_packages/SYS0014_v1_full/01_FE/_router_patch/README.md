# SYS0014 Router 등록 patch (클라우드 적용 의무)

## 1) packages/foundation/src/constants/route-paths.ts

다음 라인 추가 (다른 SYS00XX 사이 알파벳 정렬 위치):

```ts
SYS0014: 'group-user',
```

## 2) apps/web/src/core/Router.tsx

(a) LazyLoader import (상단 import 블록, 다른 admin LazyLoader 옆):

```tsx
const GroupUserPageWithTab = LazyLoader(() =>
  import('@admin/group-user').then(m => ({ default: m.GroupUser }))
);
```

(b) Router children — `ROUTE_PATHS.SYSTEM` 하위 (다른 SYS00XX 와 함께):

```tsx
{
  path: ROUTE_PATHS.SYS0014,
  element: <GroupUserPageWithTab />,
},
```

## 3) DB 메뉴 (UPPR_MNU_ID 정렬)

`03_META/01_MNU_i18n.sql` 의 `UPPR_MNU_ID='System'` 정확히 적용. (예: `Admin_Menu` 였다면 정렬)

## 4) BE 재기동 + 브라우저 새로고침
