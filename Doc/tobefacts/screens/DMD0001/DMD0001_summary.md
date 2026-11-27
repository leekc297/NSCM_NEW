# DMD0001 — To-Be Fact Pack 요약

- page_key: `report/dashboard` · feature: report · As-is Fact Pack 없음(화면ID 미대응)
- 파일 43 · 엔드포인트 호출 12 (미해결 0, 주석 속 0) · 이벤트 20 · 컴포넌트 사용 23 · 하드코딩 컬럼 13 · 메시지 51
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 13건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/dashboard/components/coverMonthChart.map.test.ts | test | 33 |
| features/report/src/pages/dashboard/components/coverMonthChart.map.ts | component | 59 |
| features/report/src/pages/dashboard/components/CoverMonthChart.tsx | component | 73 |
| features/report/src/pages/dashboard/components/DashboardHeader.tsx | component | 166 |
| features/report/src/pages/dashboard/components/demandForecastChart.map.test.ts | test | 34 |
| features/report/src/pages/dashboard/components/demandForecastChart.map.ts | component | 36 |
| features/report/src/pages/dashboard/components/DemandForecastChart.tsx | component | 117 |
| features/report/src/pages/dashboard/components/excessStatus.map.test.ts | test | 50 |
| features/report/src/pages/dashboard/components/excessStatus.map.ts | component | 54 |
| features/report/src/pages/dashboard/components/ExcessStatus.tsx | component | 130 |
| features/report/src/pages/dashboard/components/forecastInfo.map.test.ts | test | 29 |
| features/report/src/pages/dashboard/components/forecastInfo.map.ts | component | 22 |
| features/report/src/pages/dashboard/components/ForecastInfo.tsx | component | 53 |
| features/report/src/pages/dashboard/components/inventoryProjectionChart.map.test.ts | test | 34 |
| features/report/src/pages/dashboard/components/inventoryProjectionChart.map.ts | component | 51 |
| features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | component | 156 |
| features/report/src/pages/dashboard/components/kpiSummary.map.test.ts | test | 37 |
| features/report/src/pages/dashboard/components/kpiSummary.map.ts | component | 68 |
| features/report/src/pages/dashboard/components/KpiSummary.tsx | component | 97 |
| features/report/src/pages/dashboard/components/mapeChart.map.test.ts | test | 27 |
| features/report/src/pages/dashboard/components/mapeChart.map.ts | component | 25 |
| features/report/src/pages/dashboard/components/MapeChart.tsx | component | 81 |
| features/report/src/pages/dashboard/components/productStatusGrid.map.test.ts | test | 40 |
| features/report/src/pages/dashboard/components/productStatusGrid.map.ts | component | 59 |
| features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | component | 153 |
| features/report/src/pages/dashboard/components/riskHeatMap.map.test.ts | test | 30 |
| features/report/src/pages/dashboard/components/riskHeatMap.map.ts | component | 20 |
| features/report/src/pages/dashboard/components/RiskHeatMap.tsx | component | 95 |
| features/report/src/pages/dashboard/demand-as-dashboard.constants.ts | constants | 50 |
| features/report/src/pages/dashboard/demand-as-dashboard.filters.test.ts | test | 20 |
| features/report/src/pages/dashboard/demand-as-dashboard.filters.ts | other | 38 |
| features/report/src/pages/dashboard/demand-as-dashboard.labels.ts | other | 53 |
| features/report/src/pages/dashboard/demand-as-dashboard.rules.ts | other | 77 |
| features/report/src/pages/dashboard/demand-as-dashboard.types.ts | types | 68 |
| features/report/src/pages/dashboard/DemandAsDashboard.module.scss | style | 605 |
| features/report/src/pages/dashboard/DemandAsDashboard.tsx | page | 159 |
| features/report/src/pages/dashboard/index.ts | index | 2 |
| features/report/src/pages/dashboard/useDashboardColumnLabels.ts | hook | 36 |
| features/report/src/pages/dashboard/useDemandAsDashboardStore.ts | store | 39 |
| features/report/src/pages/dashboard/wijmo-autosize.ts | other | 15 |
| features/report/src/pages/dashboard/wijmo-axis-unit.ts | other | 24 |
| features/report/src/pages/dashboard/wijmo-legend.ts | other | 31 |
| features/report/src/pages/dashboard/wijmo-tooltip.ts | other | 10 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMD0001/coverTrend//call-proc | hook | 1 | Y | CoverMonthChart.tsx:32 |
| (useTabComboQueries) | hook | 2 | Y | DashboardHeader.tsx:56 DemandAsDashboard.tsx:47 |
| DMD0001/demandTrend//call-proc | hook | 1 | Y | DemandForecastChart.tsx:39 |
| DMD0001/excess//call-proc | hook | 1 | Y | ExcessStatus.tsx:26 |
| DMD0001/forecastInfo//call-proc | hook | 1 | Y | ForecastInfo.tsx:18 |
| DMD0001/inventoryProjection//call-proc | hook | 1 | Y | InventoryProjectionChart.tsx:35 |
| DMD0001/kpi//call-proc | hook | 1 | Y | KpiSummary.tsx:54 |
| DMD0001/mape//call-proc | hook | 1 | Y | MapeChart.tsx:44 |
| DMD0001/productStatus//call-proc | hook | 1 | Y | ProductStatusGrid.tsx:38 |
| DMD0001/riskHeatmap//call-proc | hook | 1 | Y | RiskHeatMap.tsx:38 |
| /admin/menu/DMD0001/column | http | 1 | Y | useDashboardColumnLabels.ts:17 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| forecastInfo | yyyymmdd | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| kpi | divisionId yyyymmdd bizType endCustomer | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| productStatus | divisionId yyyymmdd bizType endCustomer | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| riskHeatmap | divisionId yyyymmdd bizType endCustomer | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| excess | divisionId yyyymmdd bizType endCustomer | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| coverTrend | divisionId yyyymmdd bizType endCustomer nickName | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| demandTrend | divisionId yyyymmdd bizType endCustomer nickName | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| inventoryProjection | divisionId yyyymmdd bizType endCustomer nickName | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |
| mape | divisionId yyyymmdd bizType endCustomer nickName | o_rc1 | PKG_DMD0001 P_DMD0001_GET_ |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onDivChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 97 |
| CustomDropdown | onChange | <arrow> onBaseMonthChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 108 |
| CustomDropdown | onChange | <arrow> onBizTypeChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 125 |
| CustomDropdown | onChange | <arrow> onOemChange | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 139 |
| IconButton | onClick | onRefresh | jsx | features/report/src/pages/dashboard/components/DashboardHeader.tsx | 147 |
| chart | rendered | <arrow> chart.axisX.convert,chart.axisY.convert,Number,Number.isFinite,e.engine.drawLine,e.engine.drawString | addHandler | features/report/src/pages/dashboard/components/DemandForecastChart.tsx | 72 |
| select | onChange | <arrow> onProductChange | jsx | features/report/src/pages/dashboard/components/DemandForecastChart.tsx | 102 |
| grid | formatItem | <arrow>  | addHandler | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 61 |
| chart | rendered | <arrow> chart.axisX.convert,chart.axisY.convert,Number,Number.isFinite,e.engine.drawLine,mark.label.split | addHandler | features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | 75 |
| select | onChange | <arrow> onProductChange | jsx | features/report/src/pages/dashboard/components/InventoryProjectionChart.tsx | 141 |
| grid | formatItem | <arrow>  | addHandler | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 91 |
| DashboardHeader | onDivChange | <arrow>  | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 114 |
| DashboardHeader | onBaseMonthChange | <arrow> setDraft | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 117 |
| DashboardHeader | onBizTypeChange | <arrow> setDraft | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 118 |
| DashboardHeader | onOemChange | <arrow> setDraft | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 119 |
| DashboardHeader | onRefresh | handleRefresh | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 120 |
| DemandForecastChart | onProductChange | <arrow> setDraft | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 136 |
| InventoryProjectionChart | onProductChange | <arrow> setDraft | jsx | features/report/src/pages/dashboard/DemandAsDashboard.tsx | 142 |
| chart | rendered | <arrow> host.querySelectorAll,labels.forEach,Number,l.getAttribute,top.getAttribute,Number.isFinite | addHandler | features/report/src/pages/dashboard/wijmo-axis-unit.ts | 8 |
| chart | rendered | <arrow> host.querySelectorAll<SVGElement>('.wj-legendellipse').forEach,host.querySelectorAll,el.setAttribute,chart.series.forEach,Boolean,line.setAttribute | addHandler | features/report/src/pages/dashboard/wijmo-legend.ts | 12 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| CustomDropdown | 4 |
| RiskCell | 3 |
| IconButton | 1 |
| SyncIcon | 1 |
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
| columns | product | header('PRODUCT', '_제품') | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 50 |
| columns | stock | header('STOCK', '_현재 재고 (EA)') | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 51 |
| columns | demand12m | header('DEMAND12M', '_예상 수요 (12M)') | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 52 |
| columns | excessEa | header('EXCESSEA', '_Excess (EA)') | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 53 |
| columns | excessAmount | header('EXCESSAMOUNT', '_Excess 금액 (억원)') | * |  |  |  | object | features/report/src/pages/dashboard/components/ExcessStatus.tsx | 54 |
| columns | product | header('PRODUCT', '_제품') | 0.8* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 80 |
| columns | oem | header('OEM', '_OEM') | 0.8* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 81 |
| columns | bizType | header('BIZTYPE', '_Biz Type') | 0.9* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 82 |
| columns | stock | header('STOCK', '_현재 재고 (EA)') | 1.1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 83 |
| columns | cover | header('COVER', '_Inventory Cover (개월)') | 1.9* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 84 |
| columns | shortageMonth | header('SHORTAGEMONTH', '_예상 부족월') | 1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 85 |
| columns | action | header('ACTION', '_권고 Action') | 1.1* |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 86 |
| columns | status | header('STATUS', '_상태') | 56 |  |  |  | object | features/report/src/pages/dashboard/components/ProductStatusGrid.tsx | 87 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01282 | 2 |
| LBL01283 | 1 |
| LBL01284 | 1 |
| LBL01285 | 1 |
| LBL01286 | 1 |
| LBL01287 | 1 |
| LBL01288 | 1 |
| LBL01289 | 1 |
| LBL01290 | 1 |
| LBL01291 | 1 |
| LBL01292 | 1 |
| LBL01293 | 1 |
| LBL01294 | 1 |
| LBL01295 | 1 |
| LBL01296 | 1 |
| LBL01297 | 1 |
| LBL01298 | 1 |
| LBL01299 | 1 |
| LBL01300 | 1 |
| LBL01301 | 1 |
| LBL01302 | 1 |
| LBL01303 | 1 |
| LBL01304 | 1 |
| LBL01305 | 1 |
| LBL01306 | 1 |
| LBL01307 | 1 |
| LBL01308 | 1 |
| LBL01309 | 1 |
| LBL01310 | 1 |
| LBL01311 | 1 |
| LBL01312 | 1 |
| LBL01313 | 1 |
| LBL01314 | 1 |
| LBL01315 | 1 |
| LBL01316 | 1 |
| LBL01317 | 1 |
| LBL01318 | 1 |
| LBL01319 | 1 |
| LBL01320 | 1 |
| LBL01321 | 1 |
| LBL00001 | 1 |
| LBL01322 | 1 |
| LBL01323 | 1 |
| LBL01324 | 1 |
| LBL01325 | 1 |
| LBL01326 | 1 |
| LBL01327 | 1 |
| LBL01279 | 1 |
| LBL01280 | 1 |
| LBL01281 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0055(3), SCP0114(2)
- SP/PKG: PKG_DMD0001(3), P_DMD0001_GET_EXCESS(2), P_DMD0001_GET_FORECAST_INFO(2), P_DMD0001_GET_KPI(2), P_DMD0001_GET_MAPE(2), P_DMD0001_GET_PRODUCT_STATUS(2), P_DMD0001_GET_RISK_HEATMAP(2), P_YYYYMMDD(2), P_DMD0001_GET_COVER_TREND(1), P_DMD0001_GET_DEMAND_TREND(1), P_DMD0001_GET_INVENTORY_PROJECTION(1), P_DMD0001_GET_(1), P_DIVISION_ID(1), P_BIZ_TYPE(1), P_END_CUSTOMER(1), P_NICK_NAME(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

