# SSP0012 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-confirm-detail` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 4 (미해결 0, 주석 속 2) · 이벤트 17 · 컴포넌트 사용 31 · 하드코딩 컬럼 0 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | component | 50 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/DrilldownModal.module.scss | component | 25 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | component | 45 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | component | 239 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | component | 127 |
| features/shipping/src/pages/shipment-plan-confirm-detail/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-confirm-detail/shipment-plan-confirm-detail.constants.ts | constants | 89 |
| features/shipping/src/pages/shipment-plan-confirm-detail/shipment-plan-confirm-detail.types.ts | types | 28 |
| features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.module.scss | style | 6 |
| features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | page | 212 |
| features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | store | 243 |
| features/shipping/src/pages/shipment-plan-confirm-detail/__asis-mapping__.md | mapping | 59 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentPlanConfirmDetailForm.tsx:65 |
| SSP0012/main//call-proc | hook | 1 | Y | ShipmentPlanConfirmDetail.tsx:57 |
| /admin/menu/SSP0012/search-conditions | http | 1 | Y | useShipmentPlanConfirmDetailStore.ts:164 |
| /admin/menu/SSP0012/column | http | 1 | Y | useShipmentPlanConfirmDetailStore.ts:221 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 97 |
| CustomDropdown | onChange | <arrow> setDivisions,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 115 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 143 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 179 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 180 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 174 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 193 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 210 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 211 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 228 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 229 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | 71 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | 97 |
| ShipmentPlanConfirmDetailForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 149 |
| ShipmentPlanConfirmDetailForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 150 |
| ShipmentPlanConfirmDetailGrid | onDrilldown | setDrilldown | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 171 |
| ColumnSettingModal | onSave | <arrow> fetchStaticColumns,setOpenColumnSetting | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 191 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| InputField | 3 |
| CustomDialog | 2 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| DataGrid | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ShipmentPlanConfirmDetailForm | 1 |
| SubTitle | 1 |
| ShipmentPlanConfirmDetailGrid | 1 |
| ItemByDivisionModal | 1 |
| ColumnSettingModal | 1 |
| BodDetailModal | 1 |
| ShipmentRequestDetailModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00013 | 1 |
| LBL00669 | 1 |
| LBL01122 | 1 |
| LBL01114 | 1 |
| LBL00112 | 1 |
| LBL00783 | 1 |
| LBL00605 | 1 |
| MSG00667 | 1 |
| MSG00109 | 1 |
| MSG00013 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0012(4), SCM0002(1), SSP0201(1), SSP0014(1)
- SP/PKG: PKG_SSP0012(6), SCM0001_GET_SCP_DAY_PERIOD(4), P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL(2), FN_GET_IN_STR(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search). | features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | 32 |
| endpoint | 단일 시트 컬럼메타 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지(그리드 공백). | features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | 219 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

