# NSCMFE_PRE_COMMON_20260908 — 공통소스 5e1a83b9 반영 전 백업 + 분류표

- 공통 HEAD: **5e1a83b9** (2026-09-08 11:05 "fix(foundation): 조회조건 라벨 폭을 뷰포트 분기 없이 140px로 고정")
- 직전 기준선: **40f7ad9c** (2026-09-03 16:31, 09-03 적용) — 로컬 198파일이 이 기준선과 정확히 일치해 실측 확정
- 사용자 지시: **"내가 가지고 있는 소스가 더 최신이면 내 걸로 유지"**
- 판정: mtime ⛔ — 3자 내용 대조(기준선·공통·로컬) + 개행 정규화 + **공통 이력 전수 대조** + Python 바이너리 I/O
- 백업 = 이번 반영으로 덮인 로컬 원본 **225파일**(공통채택 198 + local_edit 26 + procedures.d.ts). 원복 = 본 폴더 nscm-fe/ 이하를 실경로 복사.

## 분류 (공통 변경 291파일, 4폴더)
| 구분 | 건수 | 처리 |
|---|---:|---|
| 이미 일치 | 16 | 무처리 |
| 공통채택 (로컬=기준선, 내가 안 건드림) | 198 | 공통본 적용 |
| 신규 추가 | 49 | 공통본 추가 |
| 이력본 일치 → 공통채택 | 7 | 로컬이 공통 **과거 판본**과 동일 = 내 편집본 아님 |
| 3-way 병합 성공 | 2 | 양쪽 변경 병합 |
| **충돌 → 로컬 유지** | **17** | **내 것이 최신 — 사용자 지시대로 로컬 보존** |
| 로컬 부재(공통만 보유) | 2 | 미채택 (아래) |

### 충돌 → 로컬 유지 (17) — 내 작업분 보존
- features/admin/src/pages/dynamic-query/DynamicQuery.tsx
- features/demand/src/pages/customer-fcst-upload/CustomerFcstUpload.tsx
- features/demand/src/pages/customer-fcst-upload/useCustomerFcstUploadStore.ts
- features/demand/src/pages/forecast-price/ForecastPrice.tsx
- features/demand/src/pages/forecast-price/components/ForecastPriceGrid.tsx
- features/demand/src/pages/forecast-price/components/ForecastPriceGridUtils.ts
- features/demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx
- features/demand/src/pages/forecast-price/forecast-price.constants.ts
- features/demand/src/pages/sales-monitoring/utils/sales-monitoring.combos.test.ts
- features/demand/src/pages/sales-reports/SalesReports.tsx
- features/master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx
- features/spms-demand/src/pages/project-list/components/ProjectListGrid.tsx
- features/spms-demand/src/pages/project-master/components/ProjectMasterTab1Grid.tsx
- packages/shared/src/components/organisms/data-grid/DataGrid.tsx
- packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx
- public/locales/EN.json
- public/locales/KO.json

### 3-way 병합 성공 (2)
- packages/shared/src/components/organisms/data-grid/dataGridUtils.ts
- packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx

⚠ **쌍 주의**: 공통 `DataGrid.tsx`(충돌→로컬 유지) ↔ 병합된 `dataGridUtils.ts` 는 쌍 규약 대상.
반드시 type-check 로 정합 확인할 것.

### 이력본 일치 → 공통채택 (7)
로컬 사본이 공통 **과거 커밋 판본**과 바이트 동일 = 내 편집본이 아니라 낡은 사본이라 공통 최신본 채택.
- apps/web/src/mdi/AtlasBridge.tsx
- features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx · CustFcstWaterfallGrid.tsx
- features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx · MktFcstComparisonForm.tsx · MktFcstComparisonGrid.tsx
- features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts

### 로컬 부재 → 미채택 (2)
- features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.tsx
- features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx
→ 내 DMF0035 통합(3UI→GUBUN) 구조에는 없는 파일이고 로컬 어디서도 import 하지 않는다.
  직전 09-03 회차도 동일하게 미채택. 받으면 미참조 파일이 늘어 컴파일 위험만 생긴다.

## 4폴더 밖 동반 조치 — configs/types/procedures.d.ts
공통 변경 = 310줄 추가(4개 소hunk + 274줄 블록). 대조 결과:
- DMF0035 `o_rc2`(mktFcst/salesPlan/bizPlan 3곳) · DMF0082 ForecastPrice 블록 = **로컬에 이미 존재** → 무처리
- **SDM2010 / SDM2020 블록(274줄)만 신규** → 블록 경계 규약대로 RawProcedureMap 닫는 괄호 앞에 삽입
  (전체본 덮어쓰기 ⛔ — 로컬 자체 편집분 보존)

## 미수행 — 검증
⚠ **type-check / lint 미실행**. 사용자 지시(2026-09-02) "별도 요청 전까지 type-check/lint 자동 수행 금지" 를 따랐다.
공통 HEAD 는 소스-테스트 불일치가 반복되는 저장소이므로(전력 3회) **요청 시 `_artifacts/_tools/fe-check.ps1` 로 확인 필요**.
