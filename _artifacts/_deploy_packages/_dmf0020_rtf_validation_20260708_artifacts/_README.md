# DMF0020 (SalesFuturePrice) — RTF 정합 + 저장 마스터 검증 (증분 이관, 2026-07-08)

> **이번 라운드 변경분만** 취합 (FE 3 + SQL 2). BE Java 무변경. 압축 없음.
- 화면 ID: **DMF0020** | 도메인: `master` | slug: `sales-future-price`
- 선행: `_dmf0020_artifacts`(07-07 전체 증분) → `_dmf0020_perf_20260708_artifacts`(성능) → **본 패키지**.
  본 FE 파일들은 최신본(성능 수정 포함)이므로 선행 패키지 미적용 환경이면 선행 먼저(또는 `_dmf0020_artifacts` 하나로 통합 적용 — 동일 최신본 반영됨).

## 1. RTF measure 정합 (FE — AS-IS 실측 1:1, 사용자 확인 2026-07-08)
**증상**: LOC 입력 시 RTF 에도 값이 표시되고, 재조회하면 RTF=0.
**원인(실측)**: RTF(`RTF_SYS_RP`)는 통화가 아니라 **시스템 생성 measure** — 조회 SP 가 이동계획 판가(DM_PLN_SALES_PLAN×환율)에서 조회 시점 생성하며, 가격 적재 필터 `COLUMN_NAME <> 'RTF_SYS_RP'` 로 **저장값을 읽지 않음**. AS-IS 도 LOC 입력 시 RTF 미변경.

| 파일 | 변경 |
|---|---|
| `components/SalesFuturePriceGrid.tsx` | LOC 편집 시 **KRW/USD 만** 환율 재계산 — RTF 셀 미변경 |
| `SalesFuturePrice.tsx` | 저장 payload **RTF 제외** (LOC/KRW/USD 3쌍 — SP `HAVING COUNT(*)<3` 정확 충족) |
| `salesPriceExchange.ts` | 판정 유틸 `currencyCodesFromRateMap`/`isExchangeTargetMeasure` — **환율 데이터의 통화코드 집합** 기반(하드코딩 0, 환율 미로드 시 기존 동작 보존) |

## 2. 저장 시 마스터 정합 검증 (SQL — ⚠️ 사내 미배포, 승인 대기)
**요구**: 저장은 되는데 조회 JOIN 미통과로 미표시되는 케이스 → 저장 차단 + 미저장 사유 WARNING.
**구현**: `sql/02_SAVE_SP_master_validation_DEPLOY.sql` — 조회 SP 하드필터와 동일 기준 2검증(기존 검증 패턴 동일):
- (a) **Sales Site**: `SCM_MST_SITE` (DIV+SITE, `SITE_TYPE='SALES'`, `VALID_YN='Y'`) 미등록 → 차단
- (b) **사업부 Item**: `SCM_MST_ITEM_SN` (DIV+ITEM) 미등록 → 차단 (기존 Item 검증은 사업부 무관 — 격차 보강)
- 위반 시 `O_RESULT_CURSOR` `-1` + `[DIV/값] Invalid ... ! (마스터 미등록 - 저장해도 조회되지 않아 저장 차단) 외 N건` → FE alert 표출. 본 DML/COMMIT 이전 RETURN = 전체 미저장. `'D'`(삭제) 행 제외.
- 겸사: GTT `TRUNCATE`→`DELETE` 2건 (hook #107 / 부록 C-2 — mutex 경합 예방)
- `sql/01_SAVE_SP_ORIG_backup.sql` = 원본 백업.

## 3. 적용
```bash
# FE (화면 전용 3 파일)
cp fe/features/master/src/pages/sales-future-price/SalesFuturePrice.tsx        nscm-fe/features/master/src/pages/sales-future-price/
cp fe/features/master/src/pages/sales-future-price/salesPriceExchange.ts       nscm-fe/features/master/src/pages/sales-future-price/
cp fe/features/master/src/pages/sales-future-price/components/SalesFuturePriceGrid.tsx nscm-fe/features/master/src/pages/sales-future-price/components/
# DB (SCM_MGR) — 02 실행 → VALID + 잔존 TRUNCATE 0 + [V20260708-DMF0020] 2건 확인
```

## 4. 검증
1. Insert → LOC 입력: KRW/USD 만 재계산·빨강, **RTF 미변경**. 저장 후 재조회: RTF=시스템 값(신규 조합은 0 정상).
2. (SP 배포 후) 무효 Sales Site 조합 저장 → `Invalid Sales Site !` alert + 미저장 / 정상 조합 → 저장 + 재조회 표시.
3. 회귀: 기존 행 LOC 수정 저장 / Batch Price Input 저장(동일 SAVE SP 경유 — 검증 공유) / 삭제(price 0 → 'D') 정상.
