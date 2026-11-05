# SSP0012 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-confirm-detail` · feature: shipping · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 6 (미해결 0, 주석 속 2) · 이벤트 16 · 컴포넌트 사용 62 · 하드코딩 컬럼 50 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 50건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | component | 138 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | component | 194 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | component | 265 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.module.scss | component | 21 |
| features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | component | 149 |
| features/shipping/src/pages/shipment-plan-confirm-detail/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-confirm-detail/shipment-plan-confirm-detail.constants.ts | constants | 110 |
| features/shipping/src/pages/shipment-plan-confirm-detail/shipment-plan-confirm-detail.types.ts | types | 28 |
| features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.module.scss | style | 6 |
| features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | page | 298 |
| features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | store | 422 |
| features/shipping/src/pages/shipment-plan-confirm-detail/__asis-mapping__.md | mapping | 77 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0012/main/GET_BOD_DETAIL/call-proc | http | 1 | Y | BodDetailModal.tsx:89 |
| /SSP0012/main/GET_REQ_DRAFTING/call-proc | http | 1 | Y | ShipmentRequestDetailModal.tsx:141 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentPlanConfirmDetailForm.tsx:81 |
| SSP0012/main//call-proc | hook | 1 | Y | ShipmentPlanConfirmDetail.tsx:95 |
| /admin/menu/SSP0012/search-conditions | http | 1 | Y | useShipmentPlanConfirmDetailStore.ts:256 |
| /admin/menu/SSP0012/column | http | 1 | Y | useShipmentPlanConfirmDetailStore.ts:327 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 130 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 186 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 129 |
| CustomDropdown | onChange | <arrow> setDivisions,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 148 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 176 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 211 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 207 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 224 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 238 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailForm.tsx | 255 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | 91 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-confirm-detail/components/ShipmentPlanConfirmDetailGrid.tsx | 119 |
| ShipmentPlanConfirmDetailForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 169 |
| ShipmentPlanConfirmDetailForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 170 |
| ShipmentPlanConfirmDetailGrid | onDrilldown | setDrilldown | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 194 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[SHEETS.MAIN],columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map | jsx | features/shipping/src/pages/shipment-plan-confirm-detail/ShipmentPlanConfirmDetail.tsx | 241 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Box | 10 |
| FLabel | 8 |
| FValue | 8 |
| Grid | 5 |
| FormItem | 5 |
| DataGrid | 3 |
| Button | 3 |
| InputField | 3 |
| CustomDialog | 2 |
| CustomDropdown | 2 |
| RequestForm | 1 |
| SearchArea | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| ShipmentPlanConfirmDetailForm | 1 |
| SubTitle | 1 |
| ShipmentPlanConfirmDetailGrid | 1 |
| MaterialByDivisionModal | 1 |
| ColumnLayoutModal | 1 |
| BodDetailModal | 1 |
| ShipmentRequestDetailModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| BOD_COLUMNS | DIVISION_ID | Division | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 38 |
| BOD_COLUMNS | FROM_SITE | Code | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 40 |
| BOD_COLUMNS | FROM_CITY_NAME | City Name | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 41 |
| BOD_COLUMNS | FROM_COUNTRY | Country | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 42 |
| BOD_COLUMNS | FROM_CITY | City | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 43 |
| BOD_COLUMNS | TO_SITE | Code | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 45 |
| BOD_COLUMNS | TO_CITY_NAME | City Name | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 46 |
| BOD_COLUMNS | TO_COUNTRY | Country | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 47 |
| BOD_COLUMNS | TO_CITY | City | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 48 |
| BOD_COLUMNS | TRANSPORT_MODE | Trans Mode | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 50 |
| BOD_COLUMNS | LT_TOTAL | L/T | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 54 |
| BOD_COLUMNS | D_PORT_NAME | Port | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 56 |
| BOD_COLUMNS | D_COUNTRY | Country | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 57 |
| BOD_COLUMNS | D_PORT_CODE | Port Code | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 58 |
| BOD_COLUMNS | A_PORT_NAME | Port | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 60 |
| BOD_COLUMNS | A_COUNTRY | Country | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 61 |
| BOD_COLUMNS | A_PORT_CODE | Port Code | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 62 |
| BOD_COLUMNS | DAYS_MON | Mon | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 64 |
| BOD_COLUMNS | DAYS_TUE | Tue | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 65 |
| BOD_COLUMNS | DAYS_WED | Wed | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 66 |
| BOD_COLUMNS | DAYS_THU | Thu | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 67 |
| BOD_COLUMNS | DAYS_FRI | Fri | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 68 |
| BOD_COLUMNS | DAYS_SAT | Sat | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 69 |
| BOD_COLUMNS | DAYS_SUN | Sun | 40 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 70 |
| BOD_COLUMNS | LT_DEPARTURE_INLAND | Departure Inland | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 72 |
| BOD_COLUMNS | LT_WAIT_SHIPPING | Waiting For Shipping | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 73 |
| BOD_COLUMNS | LT_VOYAGE | Voyage | 60 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 74 |
| BOD_COLUMNS | LT_LAY_OFF_CLEARANCE | Lay Off/Customs Clearance | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 75 |
| BOD_COLUMNS | LT_ARRIVAL_INLAND | Arrival Inland | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 76 |
| BOD_COLUMNS | LT_SUM | Total L/T | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/BodDetailModal.tsx | 77 |
| DRAFTING_COLUMNS | ERP_SO_NO | SO No | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 41 |
| DRAFTING_COLUMNS | PROJECT_NAME | Project Name | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 42 |
| DRAFTING_COLUMNS | FCST_TYPE | FCST Type | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 43 |
| DRAFTING_COLUMNS | ITEM_ID | Model | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 44 |
| DRAFTING_COLUMNS | FROM_SITE | From Site | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 45 |
| DRAFTING_COLUMNS | TO_SITE | To Site | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 46 |
| DRAFTING_COLUMNS | INCOTERMS | Incoterms | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 47 |
| DRAFTING_COLUMNS | LT_DAY | L/T(Day) | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 49 |
| DRAFTING_COLUMNS | ETD | ETD | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 50 |
| DRAFTING_COLUMNS | ETA | ETA | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 51 |
| DRAFTING_COLUMNS | TRANSPORT_MODE | Trans Mode | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 52 |
| DRAFTING_COLUMNS | SHIPMENT_DATE | Shipment Date | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 53 |
| DRAFTING_COLUMNS | SHIPMENT_CONFIRM_QTY | Qty | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 54 |
| DRAFTING_COLUMNS | NEW_LT_DAY | L/T(Day) | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 56 |
| DRAFTING_COLUMNS | NEW_ETD | ETD | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 57 |
| DRAFTING_COLUMNS | NEW_ETA | ETA | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 58 |
| DRAFTING_COLUMNS | NEW_TRANSPORT_MODE | Trans Mode | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 59 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_DATE | Shipment Date | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 60 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_CONFIRM_QTY | Qty | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 61 |
| DRAFTING_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-confirm-detail/components/modals/ShipmentRequestDetailModal.tsx | 63 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL01122 | 1 |
| LBL01114 | 1 |
| LBL00112 | 1 |
| LBL00605 | 1 |
| MSG00667 | 1 |
| MSG00013 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0012(11), SCM0002(4), SSP0001(2), SSP0003(2), SSP0005(2), DMF0020(1), DMF0003(1), SSP0201(1), SSP0014(1), DMF0045(1)
- SP/PKG: SCM0001_GET_SCP_DAY_PERIOD(8), PKG_SSP0012(4), P_SSP0003_GET_REQ_DRAFTING(3), PKG_SCM0002(2), P_SCM0002_GET_SHIPMENT_PLAN_CONFIRM_BOD_POPUP(2), PKG_SSP0003(2), SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(2), P_SSP0003_GET_DRAFTING(2), P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL(2), P_DIVISION_ID(1), P_CHANGE_REQUEST_NO(1), P_LANGUAGE(1), P_SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP(1), P_SSP0012_BOD_POPUP_GET(1), FN_GET_IN_STR(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search). | features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | 52 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | 84 |
| endpoint | 단일 시트 컬럼메타 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지(그리드 공백). | features/shipping/src/pages/shipment-plan-confirm-detail/useShipmentPlanConfirmDetailStore.ts | 325 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

