# NSCMFE_PRE_COMMON_20260901 — 공통소스 8f0b2a60 반영 전 백업 + 분류표

- 공통 HEAD: 8f0b2a60 (2026-09-01 08:57 "mod. salesplan 미사용 콤보 제거") / 직전 기준선: 76a1cffd (08-31 적용)
- 판정: mtime ⛔ — 3자 내용 대조(기준선·공통·로컬, 개행 정규화, Python 바이너리 I/O)
- 백업 = 이번 반영으로 덮인 로컬 원본 97파일 (공통채택 87 + 3way 10). 원복 = 본 폴더 nscm-fe/ 이하를 실경로 복사.

## 분류 (공통 변경 128파일)
- 동일(이미 일치) 15 / 공통채택(로컬=기준선) 87 / 신규추가 16 / 3-way 병합 10 / 삭제·충돌 0

### 3-way 병합 성공 (6)
  - features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx
  - features/demand/src/pages/forecast-price/components/modals/VersionSelectModal.tsx
  - features/demand/src/pages/metal-link-price/components/modals/MetalLinkVersionModal.tsx
  - features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx
  - features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx
  - features/master/src/pages/sales-future-price/components/modals/SalesPriceVersionModal.tsx

### 병합 충돌 → 로컬 유지 (4) — 로컬이 최신 판정(주말 작업분)
  - features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx
  - features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts
  - features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx
  - features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx

## 4폴더 밖 동반 조치
- configs/types/procedures.d.ts: COM0008 블록만 공통본 교체(로컬 블록=기준선 그대로 확인) —
  공통 신규 ItemByDivisionModal 의 itemBySmallDivision 시트 쌍 (블록 경계 규약, 전체본 덮어쓰기 ⛔)

## 공통 HEAD 결함 로컬 정합 (3번째 계보)
- sales-monitoring.combos.test.ts — 공통이 콤보 export 제거하며 자기 test 미정합(HEAD 컴파일 불가)
  → BIZ_TYPE_COMBO_ID/bizTypeComboFilterOf describe 삭제 정합 [E20260901-COMMONSYNC]
- lint 정합 2건(lint:fix): AtlasBridge.tsx import/order · sales-reports ExchangeRateModal 미사용 import

## 검증
- type-check 13/13 + lint 0 error (fe-check all 26/26, 2026-09-01)
- 내 3화면(demand-plan-waterfall/mkt-fcst-comparison/cust-fcst-waterfall)·OlapPivotGrid·useCustomQueryClient 는
  공통이 미변경 → 로컬 최신 그대로 유지 (이관 패키지와 정합)
