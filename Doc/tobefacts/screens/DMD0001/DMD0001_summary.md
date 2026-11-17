# DMD0001 — To-Be Fact Pack 요약

- page_key: `report/dashboard` · feature: report · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 0 (미해결 0, 주석 속 0) · 이벤트 14 · 컴포넌트 사용 17 · 하드코딩 컬럼 13 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 13건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/dashboard/components/CoverMonthChart.tsx | component | 45 |
| features/report/src/pages/dashboard/components/DashboardHeader.tsx | component | 65 |
| features/report/src/pages/dashboard/components/DemandForecastChart.tsx | component | 92 |
| features/report/src/pages/dashboard/components/ExcessStatus.tsx | component | 99 |
| features/report/src/pages/dashboard/components/ForecastInfo.tsx | component | 30 |
| features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | component | 118 |
| features/report/src/pages/dashboard/components/KpiSummary.tsx | component | 77 |
| features/report/src/pages/dashboard/components/MapeChart.tsx | component | 57 |
| features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | component | 102 |
| features/report/src/pages/dashboard/components/RiskHeatMap.tsx | component | 71 |
| features/report/src/pages/dashboard/demand-as-dashboard.constants.ts | constants | 3 |
| features/report/src/pages/dashboard/demand-as-dashboard.mock.ts | other | 274 |
| features/report/src/pages/dashboard/DemandAsDashboard.module.scss | style | 576 |
| features/report/src/pages/dashboard/DemandAsDashboard.tsx | page | 73 |
| features/report/src/pages/dashboard/index.ts | index | 2 |
| features/report/src/pages/dashboard/wijmo-autosize.ts | other | 15 |
| features/report/src/pages/dashboard/wijmo-tooltip.ts | other | 10 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
(없음)

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| select | onChange | <arrow> onBaseMonthChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 29 |
| select | onChange | <arrow> onBizTypeChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 39 |
| select | onChange | <arrow> onOemChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 49 |
| chart | rendered | <arrow> chart.axisX.convert,chart.axisY.convert,Number,Number.isFinite,e.engine.drawLine,e.engine.drawString | addHandler | features/report/src/pages/dashboard/components/DemandForecastChart.tsx | 48 |
| select | onChange | <arrow> onProductChange | jsx | features/report/src/pages/dashboard/components/DemandForecastChart.tsx | 77 |
| grid | formatItem | <arrow>  | addHandler | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 33 |
| chart | rendered | <arrow> chart.axisX.convert,chart.axisY.convert,Number,Number.isFinite,e.engine.drawLine,mark.label.split | addHandler | features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | 48 |
| select | onChange | <arrow> onProductChange | jsx | features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | 103 |
| grid | formatItem | <arrow>  | addHandler | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 44 |
| DashboardHeader | onBaseMonthChange | setBaseMonth | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 37 |
| DashboardHeader | onBizTypeChange | setBizType | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 38 |
| DashboardHeader | onOemChange | setOem | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 39 |
| DemandForecastChart | onProductChange | setDemandProduct | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 52 |
| InventoryProjectionChart | onProductChange | setInvProduct | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 57 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| RiskCell | 3 |
| InfoOutlined | 1 |
| ReportProblemOutlined | 1 |
| Icon | 1 |
| MapeBar | 1 |
| DashboardHeader | 1 |
| KpiSummary | 1 |
| ProductStatusGrid | 1 |
| RiskHeatMap | 1 |
| DemandForecastChart | 1 |
| InventoryProjectionChart | 1 |
| CoverMonthChart | 1 |
| ExcessStatus | 1 |
| MapeChart | 1 |
| ForecastInfo | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | product | 제품 | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 22 |
| columns | stock | 현재 재고 (EA) | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 23 |
| columns | demand12m | 예상 수요 (12M) | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 24 |
| columns | excessEa | Excess (EA) | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 25 |
| columns | excessAmount | Excess 금액 (억원) | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 26 |
| columns | product | 제품 | 0.8* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 33 |
| columns | oem | OEM | 0.8* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 34 |
| columns | bizType | Biz Type | 0.9* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 35 |
| columns | stock | 현재 재고 (EA) | 1.1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 36 |
| columns | cover | Inventory Cover (개월) | 1.9* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 37 |
| columns | shortageMonth | 예상 부족월 | 1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 38 |
| columns | action | 권고 Action | 1.1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 39 |
| columns | status | 상태 | 56 |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 40 |

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

