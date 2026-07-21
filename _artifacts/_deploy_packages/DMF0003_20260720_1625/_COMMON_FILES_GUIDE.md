# DMF0003 전체 이관 — 공통 파일 patch 가이드 (신규 배포 기준)

> 신규 배포 시 아래 공통 파일에 DMF0003 진입점을 등록해야 한다(기존 repo 에 이미 있으면 skip).
> 기존 화면 보완만 반영하는 경우 = **공통 파일 patch 0** (모두 기등록 상태).

## 1. `apps/web/src/core/Router.tsx` — 라우트 + Lazy import (2곳)

**(a) LazyLoader (import 블록 근처, L96 선례):**
```tsx
const MktFcstPageWithTab = LazyLoader(() =>
  import('@demand/mkt-fcst').then(m => ({ default: m.MktFcst }))
);
```

**(b) 라우트 등록 (demand children, L287 선례):**
```tsx
// DMF0003 — MKT FCST (시장예측). slug = 사내 SCM_ADM_MNU_M.MNU_URL='mkt_forecast' 정합(필수).
//   ROUTE_PATHS(foundation) 무수정 정책 → 리터럴 slug 사용(DMF0014 동일 패턴).
{
  path: 'mkt_forecast',
  element: <MktFcstPageWithTab />,
},
```
> ⚠ slug 는 `mkt_forecast` **리터럴 고정** — 사내 `SCM_ADM_MNU_M.MNU_URL`(01 SQL)과 정확히 일치해야 메뉴 진입 성공. ROUTE_PATHS enum 등록 불요(리터럴 정책).

## 2. workspace alias `@demand` — 기설정 확인
`@demand/mkt-fcst` 가 `features/demand/src/pages/mkt-fcst/index.ts`(barrel) 를 가리키는지 확인(기존 demand 화면 존재 시 이미 설정됨).

## 3. 변경 **불필요** 공통 파일

| 파일 | 사유 |
|---|---|
| `ROUTE_PATHS` enum | 리터럴 slug 정책 — 등록 안 함 |
| `procedures.d.ts` (글로벌 type) | SHEETS/RESPONSE_SET 유니온 변경 없음 — call-proc 동적 경로 |
| `public/locales/*.json` | MSG 는 DB(SCM_ADM_MSG_M, 06 SQL)로만 등록 · FE 는 `t(MSG.xxx, '_fallback')` 런타임 조회 |
| BE Java | 동적 호출(makeProcedure/makeComboQuery) — SP 배선은 PROC_M(02) 메타. BE 코드 0 |

## 4. 필수 정합 (positional)
- **02 PROC_M ↔ sp/DMF0003_SAVE_MKT_FCST.sql** 는 반드시 함께 — SAVE SP 는 P_AUTHORITY 16번째 IN,
  PROC_M 도 authority SORT_ORD 16 / O_RC1 17 / O_RESULT_CURSOR 18. 한쪽만 적용 시 -9994/positional 오류.
- 03 SHEET_COLUMNS 의 MEASURE 컬럼 CELL_COMBO_DATA_TYPE='Measure' + FE 가 콤보 요청에 mnuId 전달
  (hook column-lookup-meta §1.3.1) — 둘 중 하나라도 빠지면 Measure 가 코드로 표시됨.
