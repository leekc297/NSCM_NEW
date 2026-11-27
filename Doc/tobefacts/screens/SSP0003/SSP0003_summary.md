# SSP0003 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request-confirm-ssp0003` · feature: shipping · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 20 (미해결 2, 주석 속 3) · 이벤트 24 · 컴포넌트 사용 72 · 하드코딩 컬럼 0 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | component | 267 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | component | 302 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | component | 139 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | component | 222 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/hooks/useShipmentChangeRequestConfirmSsp0003Actions.ts | hook | 92 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.constants.ts | constants | 262 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.types.ts | types | 34 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.module.scss | style | 77 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | page | 841 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | store | 304 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Columns.ts | util | 44 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Save.test.ts | test | 355 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Save.ts | util | 314 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/__asis-mapping__.md | mapping | 81 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ShipmentChangeRequestConfirmSsp0003Form.tsx:61 ShipmentChangeRequestConfirmSsp0003Form.tsx:67 |
| (useTabLookupQueries) | hook | 3 | Y | ShipmentChangeRequestConfirmSsp0003Form.tsx:68 ShipmentChangeRequestConfirmSsp0003Form.tsx:71 ShipmentChangeRequestConfirmSsp0003MainGrid.tsx:58 |
| {?{comboId:ERP_BLOCK_COMBO,divisionId,segment1:MENU_ID,}} | http | 1 | N | useShipmentChangeRequestConfirmSsp0003Actions.ts:37 |
| /SSP0003/main/PLAN_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Actions.ts:55 |
| /SSP0003/main/SCS_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Actions.ts:77 |
| SSP0003/main//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:131 |
| SSP0003/sub//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:138 |
| SSP0003/delegate//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:146 |
| /common/web-service/erpIf/call | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:262 |
| /SSP0003/main/IF_CHECK/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:286 |
| /SSP0003/main/{btn}/call-proc | http | 1 | N | ShipmentChangeRequestConfirmSsp0003.tsx:305 |
| /SSP0003/main/SAVE_DE/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:473 |
| /SSP0003/main/SAVE_40\|SAVE/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:529 |
| /admin/menu/SSP0003/column | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Store.ts:253 |
| /admin/menu/SSP0003/search-conditions | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Store.ts:283 |
| /SSP0003/main/DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM/call-proc | propagated | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:357 |
| /SSP0003/main/ERP_ERROR_CONFIRM/call-proc | propagated | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:366 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId fromSite requestId fromYyyymmdd toYyyymmdd status language itemId changeType | o_rc1 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |
| sub | changeRequestNo language | o_rc1 o_rc2 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |
| delegate | divisionId apploval | o_rc1 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> onRejectReasonChange | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | 259 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 121 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 139 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 168 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 192 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 210 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 240 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 230 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 274 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 264 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 292 |
| grid | formatItem | <arrow> str,s.getCellData | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | 90 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | 132 |
| grid | formatItem | formatHandler | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 160 |
| grid | loadedRows | fitHandler | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 164 |
| grid.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 180 |
| DataGrid | initialized | <arrow> setGrid | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 216 |
| ShipmentChangeRequestConfirmSsp0003Form | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 707 |
| ShipmentChangeRequestConfirmSsp0003Form | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 708 |
| ShipmentChangeRequestConfirmSsp0003Form | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 709 |
| ShipmentChangeRequestConfirmSsp0003MainGrid | onRowDblClick | handleRowDblClick | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 757 |
| ConfirmDetailPanel | onRejectReasonChange | setRejectReason | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 772 |
| ShipmentChangeRequestConfirmSsp0003SubGrid | onToggle | toggleCheck | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 786 |
| ShipmentChangeRequestConfirmSsp0003SubGrid | onToggleAll | <arrow> (subRowsasunknownasRecord<string,unknown>[]).map,str,setCheckedIds | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 787 |

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
| ProgressIndicator | 1 |
| MainTitle | 1 |
| ShipmentChangeRequestConfirmSsp0003Form | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentChangeRequestConfirmSsp0003MainGrid | 1 |
| PanelSeparator | 1 |
| ConfirmDetailPanel | 1 |
| ShipmentChangeRequestConfirmSsp0003SubGrid | 1 |
| SsoUserModal | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00014 | 1 |
| LBL01061 | 1 |
| LBL00677 | 1 |
| LBL00618 | 1 |
| LBL01106 | 1 |
| LBL01108 | 1 |
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
| MSG01395 | 1 |
| MSG01294 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG01407 | 1 |
| MSG01408 | 1 |
| MSG01409 | 1 |
| MSG01401 | 1 |
| MSG01208 | 1 |
| MSG01215 | 1 |
| MSG01309 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0003(21), SSP0200(13), SSP0202(6), COM0013(3), SSP0015(3), SSP0201(2), SCP0101(1), SCM0019(1)
- SP/PKG: PKG_SSP0003(17), P_SSP0003_SAVE_REQ_CONFIRM(7), P_SSP0003_GET_CHG_REQ_CONFIRM(4), P_SSP0003_SAVE_REQ_DE_CONFIRM(4), FN_MULTY_TIME(3), P_DIVISION_ID(3), SCM0001_GET_SCP_DAY_PERIOD(2), P_SSP0003_SAVE_REQ_IF_CHECK(2), P_SPL_ARR(2), P_SSP0003_GET_PLAN_PROC_CHECK(1), PKG_SSP0200(1), P_SSP0200_GET_SHIPMENT_STATUS(1), P_SSP0003_GET_DELEGATEE_LOAD(1), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(1), PR_SSP_ANL_SHIP_CONFIRM_HIST(1), PKG_SCM0002(1), P_SCM0002_GET_MATERIAL_BY_DIVISION(1), FN_GET_IN_STR(1), P_SSP0003_GET_REQ_DRAFTING(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다. | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | 40 |
| code | AS-IS 와 동일 위치기반 읽기(Object.values). 조회 실패 시 차단 안 함(catch → not blocked, AS-IS catch return false 와 동일 방어). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/hooks/useShipmentChangeRequestConfirmSsp0003Actions.ts | 50 |
| endpoint | call-proc 경로: apiClient.post(`/${MENU_ID}/${sheet}/${btnCode}/call-proc`, payload). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.constants.ts | 197 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | 43 |
| endpoint | 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지. | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | 250 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

