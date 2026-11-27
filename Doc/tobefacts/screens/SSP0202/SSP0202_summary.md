# SSP0202 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request-confirm` · feature: shipping · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 14 (미해결 1, 주석 속 2) · 이벤트 25 · 컴포넌트 사용 71 · 하드코딩 컬럼 0 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request-confirm/components/ConfirmDetailPanel.module.scss | component | 59 |
| features/shipping/src/pages/shipment-change-request-confirm/components/ConfirmDetailPanel.tsx | component | 253 |
| features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | component | 237 |
| features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | component | 185 |
| features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmSubGrid.tsx | component | 126 |
| features/shipping/src/pages/shipment-change-request-confirm/hooks/useConfirmDetailFold.ts | hook | 66 |
| features/shipping/src/pages/shipment-change-request-confirm/hooks/useShipmentChangeRequestConfirmActions.ts | hook | 167 |
| features/shipping/src/pages/shipment-change-request-confirm/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request-confirm/shipment-change-request-confirm.constants.ts | constants | 208 |
| features/shipping/src/pages/shipment-change-request-confirm/shipment-change-request-confirm.types.ts | types | 33 |
| features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.module.scss | style | 65 |
| features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | page | 512 |
| features/shipping/src/pages/shipment-change-request-confirm/useShipmentChangeRequestConfirmStore.ts | store | 287 |
| features/shipping/src/pages/shipment-change-request-confirm/utils/shipmentChangeRequestConfirmColumns.ts | util | 44 |
| features/shipping/src/pages/shipment-change-request-confirm/utils/shipmentChangeRequestConfirmResult.ts | util | 56 |
| features/shipping/src/pages/shipment-change-request-confirm/utils/shipmentChangeRequestConfirmSave.ts | util | 209 |
| features/shipping/src/pages/shipment-change-request-confirm/__asis-mapping__.md | mapping | 157 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentChangeRequestConfirmForm.tsx:58 |
| (useTabLookupQueries) | hook | 3 | Y | ShipmentChangeRequestConfirmForm.tsx:59 ShipmentChangeRequestConfirmForm.tsx:60 ShipmentChangeRequestConfirmMainGrid.tsx:54 |
| {?{comboId:ERP_BLOCK_COMBO,divisionId:divisionId\|\|FIXED_DIVISION,segment1:MENU_ID,} | http | 1 | N | useShipmentChangeRequestConfirmActions.ts:38 |
| /SSP0202/main/SCS_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmActions.ts:70 |
| /SSP0202/main/PLAN_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmActions.ts:103 |
| /SSP0202/main/IF_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmActions.ts:148 |
| SSP0202/main//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirm.tsx:102 |
| SSP0202/sub//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirm.tsx:109 |
| SSP0202/delegate//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirm.tsx:117 |
| /admin/menu/SSP0202/column | http | 1 | Y | useShipmentChangeRequestConfirmStore.ts:225 |
| /admin/menu/SSP0202/search-conditions | http | 1 | Y | useShipmentChangeRequestConfirmStore.ts:258 |
| /SSP0202/main/SAVE_40\|SAVE/call-proc | http | 1 | Y | shipmentChangeRequestConfirmSave.ts:197 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> onRejectReasonChange | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ConfirmDetailPanel.tsx | 245 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 75 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 105 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 128 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 146 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 176 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 166 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 209 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmForm.tsx | 227 |
| grid | formatItem | <arrow> str,s.getCellData | addHandler | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | 94 |
| grid | updatedLayout | attachDataMaps | addHandler | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | 124 |
| grid.hostElement | mousedown | <arrow> target?.closest,grid.hitTest,GridUtils.getRow,onRowDblClickRef.current | addEventListener | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | 136 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | 174 |
| DataGrid | gotFocus | onGridFocus | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmMainGrid.tsx | 181 |
| grid | loadedRows | <arrow> autoFitColumns | addHandler | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmSubGrid.tsx | 91 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmSubGrid.tsx | 114 |
| DataGrid | gotFocus | onGridFocus | jsx | features/shipping/src/pages/shipment-change-request-confirm/components/ShipmentChangeRequestConfirmSubGrid.tsx | 115 |
| ShipmentChangeRequestConfirmForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 403 |
| ShipmentChangeRequestConfirmForm | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 404 |
| ShipmentChangeRequestConfirmForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 405 |
| ShipmentChangeRequestConfirmMainGrid | onRowDblClick | handleRowDblClick | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 444 |
| ShipmentChangeRequestConfirmMainGrid | onGridFocus | <arrow> setFocusedSheet | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 445 |
| ConfirmDetailPanel | onRejectReasonChange | setRejectReason | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 460 |
| ShipmentChangeRequestConfirmSubGrid | onGridFocus | <arrow> setFocusedSheet | jsx | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 472 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 21 |
| FormItem | 15 |
| InputField | 11 |
| CustomDropdown | 4 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| DataGrid | 2 |
| Panel | 2 |
| SearchArea | 1 |
| PeriodField | 1 |
| MainTitle | 1 |
| ShipmentChangeRequestConfirmForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentChangeRequestConfirmMainGrid | 1 |
| PanelSeparator | 1 |
| ConfirmDetailPanel | 1 |
| ShipmentChangeRequestConfirmSubGrid | 1 |
| SsoUserModal | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00112 | 1 |
| LBL00022 | 1 |
| LBL00014 | 1 |
| LBL01061 | 1 |
| LBL00677 | 1 |
| LBL01106 | 1 |
| LBL01108 | 1 |
| LBL00618 | 1 |
| LBL00744 | 1 |
| LBL01125 | 1 |
| LBL01071 | 1 |
| LBL01052 | 1 |
| LBL01060 | 1 |
| LBL01104 | 1 |
| LBL00628 | 1 |
| LBL00624 | 1 |
| LBL01113 | 1 |
| MSG00109 | 1 |
| MSG01203 | 1 |
| MSG01204 | 1 |
| MSG01205 | 1 |
| MSG00181 | 1 |
| MSG01498 | 1 |
| MSG01294 | 1 |
| MSG01356 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG01215 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0003(29), SSP0202(13), SSP0201(11), SSP0200(10), COM0013(3), DMF0008(1), SSP0005(1)
- SP/PKG: PKG_SSP0202(7), P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM(2), P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK(2), SCM0001_GET_SCP_DAY_PERIOD(2), P_SHIPTO_CODE(2), P_SSP0202_GET_SCS_CONFIRM_ID_CHECK(1), P_SSP0202_GET_SSP_PLAN_PROCESSING_CHECK(1), P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM(1), P_SSP0202_GET_DELEGATEE_LOAD(1), P_SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(1), PKG_SCM0002(1), P_SCM0002_GET_MATERIAL_BY_DIVISION(1), FN_GET_IN_STR(1), SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM(1), P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | await 창(SCS/PLAN/ERP 조회)에서 더블클릭 시 두 흐름이 각자 IF_CHECK(커밋 SP)·SAVE 까지 진행할 | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 210 |
| code | 수 있었다. 아래 finally 가 모든 return 경로(차단·취소·사유·실패·성공·예외)에서 가드를 해제한다. | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 211 |
| code | 사용자 결정 2026-10-27(종전 () => undefined 노출 유지에서 표준 우선으로 전환). | features/shipping/src/pages/shipment-change-request-confirm/ShipmentChangeRequestConfirm.tsx | 343 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회). | features/shipping/src/pages/shipment-change-request-confirm/useShipmentChangeRequestConfirmStore.ts | 46 |
| endpoint | 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지. | features/shipping/src/pages/shipment-change-request-confirm/useShipmentChangeRequestConfirmStore.ts | 222 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

