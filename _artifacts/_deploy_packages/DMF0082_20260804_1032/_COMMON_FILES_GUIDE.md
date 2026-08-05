# DMF0082_20260804_1032 — 공통 파일 수정 가이드

> 공통 파일은 패키지에 포함하지 않는다 (룰 22 §2.2) — 아래 patch 만 수동 적용.
> DMF0082 는 기존 화면이므로 route-paths / Router / locales 신규 등록은 **불필요** (기등록).

## 1. `nscm-fe/configs/types/procedures.d.ts` — FcstNPrice request 에 plantSiteId 1줄

### Before (DMF0082.FcstNPrice.request — `salesSite: string;` 다음)
```ts
        salesSite: string;
        itemId: string;
```

### After
```ts
        salesSite: string;
        plantSiteId: string;
        itemId: string;
```

> `pnpm gen:procedures` 를 사용하는 환경이면 DB PROC_M 반영(sql/03B) 후 재생성으로 대체 가능.

## 2. 나머지 공통 파일 — 변경 없음

| 파일 | 조치 |
|---|---|
| `route-paths.ts` | 없음 (DMF0082: 'forecast-price' 기등록) |
| `Router.tsx` | 없음 |
| `public/locales/{KO,EN,CN}.json` | 없음 — locale 은 이관 제외 (사용자 확정 2026-07-24, t() fallback) |

## 3. 적용 후

```
cd nscm-fe && pnpm type-check && pnpm build   # 클라우드는 pnpm 사용 환경
```
