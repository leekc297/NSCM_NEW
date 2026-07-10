# DMF0020 (SalesFuturePrice) — 조회→표시 성능 보완 (증분 이관, 2026-07-08)

> **이번 라운드 변경분만** 취합 (4 파일, 전부 화면 전용 — **공유/공용 파일 0**, BE/DB 무변경).
> 전체 DMF0020 증분 패키지(`_dmf0020_artifacts`)에도 동일 파일이 반영되어 있음 — 클라우드에
> `_dmf0020_artifacts` 를 아직 적용 전이면 그 패키지 하나만 적용해도 본 건 포함됨.
- 화면 ID: **DMF0020** | 도메인: `master` | slug: `sales-future-price`
- 증상: SP 실행 1~3초인데 Grid 표시까지 수 초 추가 지연 (사용자 보고 2026-07-08)

## 1. 근본원인 — "조회 1회에 그리드 전체 재구축이 수십 회"
페이지가 조회 1회에 10회+ 리렌더(토스트/isFetching/데이터·콤보·메타 도착)되는데, 아래 4곳이
참조 불안정이라 리렌더마다 `DataGrid(memo)` 가 깨져 **wrapper 가 itemsSource(CollectionView 재생성) +
columnGroups(전 컬럼 트리 재구축, 정적 28+동적 50+) 를 반복 재적용**:

| # | 위치 | 유발원 | Fix |
|---|---|---|---|
| 1 | `SalesFuturePrice.tsx` | `spRows`/`rows` 매 렌더 새 배열 | **useMemo** 참조 안정화 |
| 2 | `SalesFuturePrice.tsx` | `onPopupCellDblClick` inline arrow → Grid 대형 effect(deps 포함) 매 렌더 재실행(핸들러 5종 재등록 + new MergeManager + `invalidate(true)`) | **useCallback** |
| 3 | `useSalesFuturePriceStore.ts` | 매 Search 마다 메타 refetch 가 동일 내용에도 새 배열 set → visibleColumns 참조 변경 → effect 재등록+invalidate 연쇄 | 3 fetch(컬럼/배치/measure) **내용 동일 시 set 생략**(JSON 비교 — admin 변경 시 즉시 반영 유지) |
| 4 | `modals/ExchangeRateModal.tsx` + `modals/PriceBatchInputModal.tsx` | `CustomDialog` 는 open=false 라도 mount → 숨겨진 모달 grid 가 메인 리렌더마다 재바인딩. Exchange: `allRows/filteredRows` 렌더 본문 계산(KRW 필터+pivot 매번 재계산) + JSX inline `.map` 컬럼 prop / Batch: `allRows` 본문 계산 + 미조회 `rows` 매번 새 `[]` | Exchange: `filteredRows`·컬럼 prop 2종 **useMemo** / Batch: `allRows` **useMemo** + `EMPTY_ROWS` 상수 |

> Version/Range 모달은 점검 결과 이미 안정(모듈 상수 컬럼 + memo rows) — 변경 없음.
> 기능 변경 0 (참조 안정화만) — admin 메타 변경 즉시 반영 등 기존 동작 전부 보존.

## 2. 패키지 구성
```
_dmf0020_perf_20260708_artifacts/
└── fe/features/master/src/pages/sales-future-price/
    ├── SalesFuturePrice.tsx                     (rows useMemo + useCallback)
    ├── useSalesFuturePriceStore.ts              (3 fetch 내용비교 set 생략)
    └── components/modals/
        ├── PriceBatchInputModal.tsx             (allRows useMemo + EMPTY_ROWS)
        └── ExchangeRateModal.tsx                (filteredRows/컬럼 prop useMemo)
```

## 3. 적용
```bash
# 화면 전용 4 파일 덮어쓰기 (공유 파일 없음 — diff 검토 부담 낮음)
cp fe/features/master/src/pages/sales-future-price/SalesFuturePrice.tsx \
   nscm-fe/features/master/src/pages/sales-future-price/
cp fe/features/master/src/pages/sales-future-price/useSalesFuturePriceStore.ts \
   nscm-fe/features/master/src/pages/sales-future-price/
cp fe/features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx \
   nscm-fe/features/master/src/pages/sales-future-price/components/modals/
cp fe/features/master/src/pages/sales-future-price/components/modals/ExchangeRateModal.tsx \
   nscm-fe/features/master/src/pages/sales-future-price/components/modals/
```
⚠️ 전제: 본 파일들은 `_dmf0020_artifacts`(2026-07-07 증분)의 후속 버전 — 클라우드가 그 증분 미적용 상태면
`_dmf0020_artifacts` 를 먼저(또는 그것만) 적용할 것 (본 4 파일 최신본 포함).

## 4. 검증
1. 조회(F5) → SP 응답(1~3초) 후 그리드 표시가 즉시(재구축 1회)인지.
2. Price Batch Input 모달 open→Search → 스피너 후 표시 즉시.
3. 회귀: MEASURE 'RTF' 라벨 / 콤보 명칭변환 / 셀 머지 / 3단 헤더 48px / Insert-편집-Save / admin UI Category 변경 후 Search 시 즉시 반영.
