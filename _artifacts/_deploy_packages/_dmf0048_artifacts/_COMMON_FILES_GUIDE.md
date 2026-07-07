# DMF0048 — 공통 파일 가이드 (route-paths / Router / procedures.d.ts)

> 신규 화면이므로 아래 3 공통 파일에 DMF0048 항목이 **없으면 추가**하세요.

## 1. `nscm-fe/packages/foundation/src/constants/route-paths.ts`
```ts
  DMF0048: 'sales-monitoring',
```

## 2. `nscm-fe/apps/web/src/core/Router.tsx`
### (a) LazyLoader 선언
```tsx
const SalesMonitoringPageWithTab = LazyLoader(() =>
  import('@demand/sales-monitoring').then(m => ({ default: m.SalesMonitoring }))
);
```
### (b) 라우트 등록 (demand nested)
```tsx
              // DMF0048 — Sales Monitoring. ROUTE_PATHS.DMF0048='sales-monitoring' = SCM_ADM_MNU_M.MNU_URL 정합(필수)
              {
                path: ROUTE_PATHS.DMF0048,
                element: <SalesMonitoringPageWithTab />,
              },
```

## 3. `nscm-fe/configs/types/procedures.d.ts`
`RawProcedureMap` 의 `DMF0048` 블록 — 전체는 `common/procedures.d.ts_DMF0048_block.txt` 참조.
누락 시 해당 블록 추가 또는 클라우드에서 `pnpm gen:procedures` 재생성.

## 4. i18n
이번 이관에 신규 LBL/MSG 추가 없음(기존 LBL00xxx 재사용). locales 변경 불필요.
