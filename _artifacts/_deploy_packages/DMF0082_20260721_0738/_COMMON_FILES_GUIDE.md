# DMF0082 전체 이관 — 공통 파일 patch 가이드 (신규 배포 기준)

> 신규 배포 시 아래 공통 파일에 DMF0082 진입점을 등록해야 한다(기존 repo 에 이미 있으면 skip).
> 기존 화면 보완만 반영하는 경우 = **공통 파일 patch 0** (모두 기등록 상태).

## 1. `apps/web/src/core/Router.tsx` — 라우트 + Lazy import (2곳)

**(a) LazyLoader (import 블록):**
```tsx
const ForecastPricePageWithTab = LazyLoader(() =>
  import('@demand/forecast-price').then(m => ({ default: m.ForecastPrice }))
);
```

**(b) 라우트 등록 (demand children):**
```tsx
// DMF0082 — Fcst&Price MGMT. slug = 사내 SCM_ADM_MNU_M.MNU_URL='forecast-price' 정합(필수).
{
  path: 'forecast-price',
  element: <ForecastPricePageWithTab />,
},
```
> ⚠ slug 는 `forecast-price` **리터럴 고정** — 사내 `SCM_ADM_MNU_M.MNU_URL`(01 SQL)·`route-paths.ts`·`Router.tsx` **3-SET 동일** 해야 메뉴 진입 성공(feedback_route_slug_mnu_url_3set). ROUTE_PATHS enum 등록 불요(리터럴 정책, DMF0014 동일).

## 2. workspace alias `@demand` — 기설정 확인
`@demand/forecast-price` 가 `features/demand/src/pages/forecast-price/index.ts`(barrel, `export { ForecastPrice }`) 를 가리키는지 확인(기존 demand 화면 존재 시 이미 설정됨).

## 3. 변경 **불필요** 공통 파일

| 파일 | 사유 |
|---|---|
| `ROUTE_PATHS` enum | 리터럴 slug 정책 — 등록 안 함 |
| `procedures.d.ts` (글로벌 type) | SHEETS/RESPONSE_SET 유니온 변경 없음 — call-proc 동적 경로(regression 글로벌 type NO 확인) |
| `public/locales/*.json` | MSG 는 DB(SCM_ADM_MSG_M, 06 SQL)로만 등록 · FE 는 `t(MSG.xxx, '_fallback')` 런타임 조회 |
| BE Java | 동적 호출(makeProcedure/makeComboQuery) — SP 배선은 PROC_M(02)·콤보는 CMBO_SQL_M(05) 메타. BE 코드 0 |

## 4. 필수 정합 (positional / 캐스케이드)
- **02 PROC_M ↔ sp/ SP 시그니처** 반드시 함께 — 특히 `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA`(SEARCH, 12 IN + 6 커서)·`DMF0082_SAVE_MAIN_DATA`(16 IN '^' bulk). 한쪽만 적용 시 -9994/positional.
- **05 CMBO 신규 2종 ↔ FE getCombo comboId** 정합: `SalesBucket`(FE `applySalesBucket`)·`FcstPriceEditMeasure`(FE `applyEditMeasures`). 미적용 시 Insert 배분요일 항상 월요일 / Measure 콤보 미필터.
- **07 LOOKUP `DM_UI_EDITABLE_MEASURE`(SEGMENT1='DMF0082')** ↔ 05 `FcstPriceEditMeasure` 동반 — lookup 디테일 없으면 편집 Measure 콤보 0행.
- 03 SHEET_COLUMNS 의 콤보 컬럼(MEASURE/CELL_PROD_SITE_ID/Incoterms 등) CELL_COMBO_DATA_TYPE ↔ 05 CMBO 등록 + FE mnuId 전달(hook column-lookup-meta §1.3.1).
- ⭐ **GET SP 커서 정합**: 배분/잠금(#1/#4)이 GET drop4(달력 MONTH_DAY_CNT/WEEK_DAY_CNT)·drop1(M3_CUTOFF_DATE)에 의존 → sp/PKG_DMF0082_BODY(라이브 div81 반영본) 필수. 구 PKG 배포 시 배분 오류.
