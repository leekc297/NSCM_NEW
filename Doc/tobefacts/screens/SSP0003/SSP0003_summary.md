# SSP0003 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request-confirm-ssp0003` · feature: shipping · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 17 (미해결 1, 주석 속 3) · 이벤트 24 · 컴포넌트 사용 71 · 하드코딩 컬럼 0 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | component | 184 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | component | 282 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | component | 139 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | component | 214 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/hooks/useShipmentChangeRequestConfirmSsp0003Actions.ts | hook | 92 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.constants.ts | constants | 253 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.types.ts | types | 34 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.module.scss | style | 31 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | page | 677 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | store | 284 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Columns.ts | util | 44 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Save.test.ts | test | 310 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/utils/shipmentChangeRequestConfirmSsp0003Save.ts | util | 284 |
| features/shipping/src/pages/shipment-change-request-confirm-ssp0003/__asis-mapping__.md | mapping | 81 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ShipmentChangeRequestConfirmSsp0003Form.tsx:59 ShipmentChangeRequestConfirmSsp0003Form.tsx:65 |
| (useTabLookupQueries) | hook | 3 | Y | ShipmentChangeRequestConfirmSsp0003Form.tsx:66 ShipmentChangeRequestConfirmSsp0003Form.tsx:69 ShipmentChangeRequestConfirmSsp0003MainGrid.tsx:58 |
| {?{comboId:ERP_BLOCK_COMBO,divisionId,segment1:MENU_ID,}} | http | 1 | N | useShipmentChangeRequestConfirmSsp0003Actions.ts:37 |
| /SSP0003/main/PLAN_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Actions.ts:55 |
| /SSP0003/main/SCS_CHECK/call-proc | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Actions.ts:77 |
| SSP0003/main//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:126 |
| SSP0003/sub//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:133 |
| SSP0003/delegate//call-proc | hook | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:141 |
| /common/web-service/erpIf/call | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:264 |
| /SSP0003/main/SAVE_DE/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:315 |
| /SSP0003/main/SAVE_40\|SAVE/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:334 |
| /SSP0003/main/IF_CHECK/call-proc | http | 1 | Y | ShipmentChangeRequestConfirmSsp0003.tsx:354 |
| /admin/menu/SSP0003/column | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Store.ts:233 |
| /admin/menu/SSP0003/search-conditions | http | 1 | Y | useShipmentChangeRequestConfirmSsp0003Store.ts:263 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId fromSite requestId fromYyyymmdd toYyyymmdd status language itemId changeType | o_rc1 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |
| sub | changeRequestNo language | o_rc1 o_rc2 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |
| delegate | divisionId apploval | o_rc1 | PKG_SSP0003 P_SSP0003_GET_CHG_REQ_CONFIRM P_SSP0003_GET_REQ_DRAFTING P_SSP0003_GET_DELEGATEE_LOAD |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> onRejectReasonChange | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | 176 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 113 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 131 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 160 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 184 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 202 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 226 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 222 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 254 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 250 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003Form.tsx | 272 |
| grid | formatItem | <arrow> str,s.getCellData | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | 90 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003MainGrid.tsx | 132 |
| grid | formatItem | formatHandler | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 152 |
| grid | loadedRows | fitHandler | addHandler | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 156 |
| grid.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 172 |
| DataGrid | initialized | <arrow> setGrid | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ShipmentChangeRequestConfirmSsp0003SubGrid.tsx | 208 |
| ShipmentChangeRequestConfirmSsp0003Form | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 562 |
| ShipmentChangeRequestConfirmSsp0003Form | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 563 |
| ShipmentChangeRequestConfirmSsp0003Form | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 564 |
| ShipmentChangeRequestConfirmSsp0003MainGrid | onRowDblClick | handleRowDblClick | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 603 |
| ConfirmDetailPanel | onRejectReasonChange | setRejectReason | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 612 |
| ShipmentChangeRequestConfirmSsp0003SubGrid | onToggle | toggleCheck | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 626 |
| ShipmentChangeRequestConfirmSsp0003SubGrid | onToggleAll | <arrow> (subRowsasunknownasRecord<string,unknown>[]).map,str,setCheckedIds | jsx | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/ShipmentChangeRequestConfirmSsp0003.tsx | 627 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 23 |
| FormItem | 15 |
| InputField | 11 |
| CustomDropdown | 4 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| DataGrid | 2 |
| Box | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| ProgressIndicator | 1 |
| MainTitle | 1 |
| ShipmentChangeRequestConfirmSsp0003Form | 1 |
| SubTitle | 1 |
| ShipmentChangeRequestConfirmSsp0003MainGrid | 1 |
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
- 화면ID: SSP0003(20), SSP0202(6), SSP0200(3), SSP0015(3), COM0013(1)
- SP/PKG: PKG_SSP0003(17), P_SSP0003_SAVE_REQ_CONFIRM(6), P_SSP0003_SAVE_REQ_DE_CONFIRM(4), P_SSP0003_GET_CHG_REQ_CONFIRM(3), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(3), FN_MULTY_TIME(3), SCM0001_GET_SCP_DAY_PERIOD(2), P_SPL_ARR(2), P_SSP0003_GET_PLAN_PROC_CHECK(1), PKG_SSP0200(1), P_SSP0200_GET_SHIPMENT_STATUS(1), P_SSP0003_GET_DELEGATEE_LOAD(1), P_SSP0003_SAVE_REQ_IF_CHECK(1), PR_SSP_ANL_SHIP_CONFIRM_HIST(1), P_CHANGE_STATUS(1), P_SSP0003_ERP_IFSEQ_MERGE(1), FN_GET_IN_STR(1), P_SSP0003_GET_REQ_DRAFTING(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다. | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/components/ConfirmDetailPanel.tsx | 40 |
| code | AS-IS 와 동일 위치기반 읽기(Object.values). 조회 실패 시 차단 안 함(catch → not blocked, AS-IS catch return false 와 동일 방어). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/hooks/useShipmentChangeRequestConfirmSsp0003Actions.ts | 50 |
| endpoint | call-proc 경로: apiClient.post(`/${MENU_ID}/${sheet}/${btnCode}/call-proc`, payload). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/shipment-change-request-confirm-ssp0003.constants.ts | 197 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회). | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | 43 |
| endpoint | 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4). 미등록/실패 시 빈 배열 유지. | features/shipping/src/pages/shipment-change-request-confirm-ssp0003/useShipmentChangeRequestConfirmSsp0003Store.ts | 230 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

