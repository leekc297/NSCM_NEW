# 공통소스 다운로드 백업/보고 — 2026-08-25

원천 : `common/main` = `d2d7c282` (2026-08-24 22:45, eunjoo-hwang/nscm-fe)
직전 기준선 : `badd49a0` (2026-08-23 21:42) / 그 이전 로컬 적용본 `f9409878` (2026-08-23 14:48)
대상 : `nscm-fe/{apps,features,packages,public}` 4폴더

## 판정 방식 (3-way + 이력 대조)
로컬 파일 내용이 **공통소스의 어떤 이력본과도 일치하지 않을 때만** "내 편집본"으로 본다.
(rename 추적 포함 · 개행 CRLF/LF 정규화 후 비교 — 저장소 blob 에 CRLF 혼재)
`mtime` 단독 판정은 쓰지 않았다 — 일괄 다운로드가 mtime 을 갱신해 오판을 만든다.

## 결과
| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 1,048 | - |
| 공통 최신 채택(갱신) | 75 | 덮어씀 (로컬=직전 공통 사본) |
| 공통 신규 파일 | 33 | 추가 |
| 공통 파일 복원 | 5 | CascadeFields 3 + customer-model-mapping.gridCombos 2 |
| **로컬 유지(내 편집)** | **9** | 보존 |
| 로컬 고유 파일 | 99 | 보존 |
| 의도 삭제 유지 | 3 | stale test 3종 (FE_STALE_TESTS_20260823 에서 삭제 결정) |

## 3-way 병합 처리 (내 것 + 공통 것 둘 다 살림)
- `packages/shared/.../data-grid/dataGridUtils.ts` — 내 TEXT_MODAL 3 hunk + 공통 `isCellEditable` predicate(신규 52줄). 충돌 0.
- `features/master/.../modals/PriceBatchInputModal.tsx` — 공통 최신본(1,414줄) 채택 후
  내 2026-08-24 'ALL' sentinel 수정(siteFilter) 재적용. 내 사본 = `PriceBatchInputModal.tsx.MINE_BAK`.

## 내용 동일(prettier 포맷차)이라 공통본 채택
`string.ts` / `OlapPivotGrid.tsx` / `forecast-price/ForecastPrice.tsx` / `forecast-price/components/ForecastPriceGrid.tsx`
→ 원본은 `merged_before/`, `*.MINE_BAK` 보존.

## 최종 로컬 유지 9건 (공통은 08-23 이후 무변경 = 손실 없음)
- features/admin/src/pages/dynamic-query/DynamicQuery.tsx
- features/demand/src/pages/forecast-price/__asis-mapping__.md
- features/demand/src/pages/forecast-price/utils/forecast-price.groupMeasure.test.ts
- features/demand/src/pages/sales-reports/utils/sales-reports.api.ts (+ .test.ts)
- packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx
- packages/shared/src/stores/useDirtyRegistry.ts
- packages/shared/src/components/organisms/data-grid/dataGridUtils.ts (병합본)
- features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx (병합본)

## 검증
`_artifacts/_tools/fe-check.ps1 type-check` → **13/13 successful** (error 0)

## 원복
`files/` = 덮어쓰기 전 원본 75건 · `01_tracked_changes.patch` = 다운로드 직전 전체 작업트리 diff
