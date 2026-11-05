# SSP0200 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request-plan` · feature: shipping · As-is Fact Pack 있음
- 파일 32 · 엔드포인트 호출 43 (미해결 7, 주석 속 0) · 이벤트 48 · 컴포넌트 사용 101 · 하드코딩 컬럼 11 · 메시지 53
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 11건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request-plan/components/ChangeRequestPlanSubGrid.tsx | component | 106 |
| features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.module.scss | component | 32 |
| features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | component | 232 |
| features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.module.scss | component | 23 |
| features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.tsx | component | 135 |
| features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | component | 118 |
| features/shipping/src/pages/shipment-change-request-plan/components/RequestActionBar.module.scss | component | 10 |
| features/shipping/src/pages/shipment-change-request-plan/components/RequestActionBar.tsx | component | 45 |
| features/shipping/src/pages/shipment-change-request-plan/components/RequestInfoPanel.tsx | component | 213 |
| features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | component | 318 |
| features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | component | 615 |
| features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanModals.tsx | component | 159 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanCellCombos.ts | hook | 216 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanPreChecks.ts | hook | 166 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanRequestor.ts | hook | 37 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanSaveActions.ts | hook | 611 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanToolbar.ts | hook | 54 |
| features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanValidation.ts | hook | 206 |
| features/shipping/src/pages/shipment-change-request-plan/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request-plan/shipment-change-request-plan.constants.ts | constants | 534 |
| features/shipping/src/pages/shipment-change-request-plan/shipment-change-request-plan.types.ts | types | 56 |
| features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.module.scss | style | 87 |
| features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | page | 641 |
| features/shipping/src/pages/shipment-change-request-plan/useShipmentChangeRequestPlanStore.ts | store | 414 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanColumns.ts | util | 137 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanDerive.ts | util | 234 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanEditLock.ts | util | 37 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanInsert.ts | util | 71 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanRequest.ts | util | 267 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanSave.test.ts | test | 249 |
| features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanSave.ts | util | 644 |
| features/shipping/src/pages/shipment-change-request-plan/__asis-mapping__.md | mapping | 244 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0200/main/USER_CHECK/call-proc | http | 1 | Y | ApprovalUserModal.tsx:130 |
| /SSP0200/main/GET_ORDER_DETAIL/call-proc | http | 1 | Y | OrderDetailModal.tsx:58 |
| (useTabComboQueries) | hook | 2 | Y | RequestInfoPanel.tsx:40 ShipmentChangeRequestPlanForm.tsx:79 |
| (useTabLookupQueries) | hook | 4 | Y | ShipmentChangeRequestPlanForm.tsx:82 useShipmentChangeRequestPlanCellCombos.ts:67 useShipmentChangeRequestPlanCellCombos.ts:68 useShipmentChangeRequestPlanValidation.ts:98 |
| (useTabComboQueryResults) | hook | 1 | Y | useShipmentChangeRequestPlanCellCombos.ts:72 |
| {?{comboId:COMBO.CELL_TRANS_MODE,divisionId:div,fromSite,toSite,incoterms,}} | http | 1 | N | useShipmentChangeRequestPlanCellCombos.ts:111 |
| {?{comboId:COMBO.CELL_END_CUSTOMER,divisionId:div,scmSiteId,itemId,param5:'',}} | http | 1 | N | useShipmentChangeRequestPlanCellCombos.ts:149 |
| /SSP0200/main/{buttonCode}/call-proc | http | 2 | N | useShipmentChangeRequestPlanPreChecks.ts:22 shipmentChangeRequestPlanRequest.ts:229 |
| {?{comboId:COMBO.ERP_BLOCK,segment1:MENU_ID}} | http | 1 | N | useShipmentChangeRequestPlanValidation.ts:189 |
| SSP0200/main//call-proc | hook | 1 | Y | ShipmentChangeRequestPlan.tsx:114 |
| SSP0200/main/SEARCH_NEW/call-proc | hook | 1 | Y | ShipmentChangeRequestPlan.tsx:124 |
| SSP0200/sub//call-proc | hook | 1 | Y | ShipmentChangeRequestPlan.tsx:132 |
| {?{comboId:COMBO.REQUESTOR_DEPT}} | http | 1 | N | useShipmentChangeRequestPlanStore.ts:302 |
| {?{comboId:COMBO.DEPT_NAME,deptId,param1:String(useSessionStore.getState().session} | http | 1 | N | useShipmentChangeRequestPlanStore.ts:309 |
| /admin/menu/SSP0200/column | http | 1 | Y | useShipmentChangeRequestPlanStore.ts:332 |
| /admin/menu/SSP0200/search-conditions | http | 1 | Y | useShipmentChangeRequestPlanStore.ts:357 |
| /SSP0200/main/GET_SCP_DAY_PERIOD/call-proc | http | 1 | Y | useShipmentChangeRequestPlanStore.ts:390 |
| /SSP0200/main/SAVE/call-proc | http | 1 | Y | shipmentChangeRequestPlanSave.ts:153 |
| /SSP0200/main/SAVE_SHIPMENT_REQUEST_DRAFTING/call-proc | http | 2 | Y | shipmentChangeRequestPlanSave.ts:288 shipmentChangeRequestPlanSave.ts:468 |
| /SSP0200/main/ERP_IFSEQ_MERGE/call-proc | http | 1 | Y | shipmentChangeRequestPlanSave.ts:511 |
| /common/web-service/erpIf/call | http | 1 | Y | shipmentChangeRequestPlanSave.ts:549 |
| /SSP0200/main/DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM/call-proc | http | 1 | Y | shipmentChangeRequestPlanSave.ts:601 |
| /SSP0200/main/ERP_ERROR_CONFIRM/call-proc | http | 1 | Y | shipmentChangeRequestPlanSave.ts:629 |
| /SSP0200/main//SSP0200/main/USER_CHECK/call-proc/call-proc | propagated | 1 | Y | ApprovalUserModal.tsx:130 |
| /SSP0200/main//SSP0200/main/GET_ORDER_DETAIL/call-proc/call-proc | propagated | 1 | Y | OrderDetailModal.tsx:58 |
| /SSP0200/main/GET_CHANGE_REQ_NO/call-proc | propagated | 1 | Y | useShipmentChangeRequestPlanPreChecks.ts:64 |
| /SSP0200/main/GET_SHIPMENT_STATUS/call-proc | propagated | 1 | Y | useShipmentChangeRequestPlanPreChecks.ts:80 |
| /SSP0200/main/GET_ERP_SO_NO_CNT/call-proc | propagated | 1 | Y | useShipmentChangeRequestPlanPreChecks.ts:119 |
| /SSP0200/main//admin/menu/SSP0200/column/call-proc | propagated | 1 | Y | useShipmentChangeRequestPlanStore.ts:332 |
| /SSP0200/main//SSP0200/main/GET_SCP_DAY_PERIOD/call-proc/call-proc | propagated | 1 | Y | useShipmentChangeRequestPlanStore.ts:390 |
| /SSP0200/main//SSP0200/main/SAVE/call-proc/call-proc | propagated | 1 | Y | shipmentChangeRequestPlanSave.ts:153 |
| /SSP0200/main//SSP0200/main/SAVE_SHIPMENT_REQUEST_DRAFTING/call-proc/call-proc | propagated | 2 | Y | shipmentChangeRequestPlanSave.ts:288 shipmentChangeRequestPlanSave.ts:468 |
| /SSP0200/main//SSP0200/main/ERP_IFSEQ_MERGE/call-proc/call-proc | propagated | 1 | Y | shipmentChangeRequestPlanSave.ts:511 |
| /SSP0200/main//common/web-service/erpIf/call/call-proc | propagated | 1 | Y | shipmentChangeRequestPlanSave.ts:549 |
| /SSP0200/main//SSP0200/main/DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM/call-proc/call-proc | propagated | 1 | Y | shipmentChangeRequestPlanSave.ts:601 |
| /SSP0200/main//SSP0200/main/ERP_ERROR_CONFIRM/call-proc/call-proc | propagated | 1 | Y | shipmentChangeRequestPlanSave.ts:629 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | loadedRows | <arrow> autoFitColumns | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ChangeRequestPlanSubGrid.tsx | 67 |
| grid | formatItem | <arrow>  | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ChangeRequestPlanSubGrid.tsx | 70 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ChangeRequestPlanSubGrid.tsx | 102 |
| InputField | onChange | <arrow> setKeyword | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 199 |
| InputField | onKeyDown | <arrow> findData | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 200 |
| Button | onClick | <arrow> findData | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 202 |
| Button | onClick | handleSelect | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 220 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 223 |
| InputField | onChange | <arrow> setCount,e.target.value.replace | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.tsx | 98 |
| InputField | onKeyDown | <arrow> e.preventDefault,handleSubmit | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.tsx | 99 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.tsx | 120 |
| Button | onClick | modalClose | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/InsertMultipleModal.tsx | 127 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 110 |
| Button | onClick | onRequestComplete | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestActionBar.tsx | 33 |
| Button | onClick | onCancel | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestActionBar.tsx | 38 |
| Button | onClick | onApprovalSearch | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestInfoPanel.tsx | 128 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestInfoPanel.tsx | 152 |
| CustomDropdown | onChange | <arrow> onChange,String | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestInfoPanel.tsx | 170 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request-plan/components/RequestInfoPanel.tsx | 205 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 127 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,changeDivision,String | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 141 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 169 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 191 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 209 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 224 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 250 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 246 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 267 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 284 |
| Checkbox | onChange | setSingleProcess | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanForm.tsx | 308 |
| grid | updatedLayout | attach | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 184 |
| grid | beginningEdit | editGate | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 286 |
| grid | pastingCell | editGate | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 287 |
| grid | cellEditEnded | onCellEditEnded | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 448 |
| grid | pastedCell | onPastedCell | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 458 |
| grid | formatItem | onFormatItem | addHandler | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 505 |
| InsertMultipleModal | onConfirm | onInsertMultiple | jsx | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanModals.tsx | 154 |
| ShipmentChangeRequestPlanForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 496 |
| ShipmentChangeRequestPlanForm | onItemSearch | <arrow> clearPopupTarget,setOpenItem | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 497 |
| ShipmentChangeRequestPlanMainGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 556 |
| ShipmentChangeRequestPlanMainGrid | onDrillDown | handleDrillDown | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 557 |
| ShipmentChangeRequestPlanMainGrid | onBlocked | handleBlocked | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 558 |
| RequestInfoPanel | onChange | setRequestInfo | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 573 |
| RequestInfoPanel | onApprovalSearch | <arrow> setOpenApproval | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 574 |
| RequestActionBar | onRequestComplete | handleRequestComplete | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 580 |
| RequestActionBar | onCancel | handleCancel | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 581 |
| ShipmentChangeRequestPlanModals | onInsertMultiple | handleInsertMultiple | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 622 |
| OrderDetailModal | onClose | <arrow> setOrderDetail | jsx | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 629 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 20 |
| FormItem | 15 |
| InputField | 11 |
| Button | 10 |
| CustomDropdown | 5 |
| DataGrid | 4 |
| CustomDialog | 3 |
| Stack | 3 |
| Box | 3 |
| Panel | 3 |
| FunctionSearchIcon | 2 |
| PanelSeparator | 2 |
| ControlConfirmIcon | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| Label | 1 |
| Checkbox | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| ApprovalUserModal | 1 |
| InsertMultipleModal | 1 |
| MainTitle | 1 |
| ShipmentChangeRequestPlanForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentChangeRequestPlanMainGrid | 1 |
| RequestInfoPanel | 1 |
| RequestActionBar | 1 |
| ChangeRequestPlanSubGrid | 1 |
| ShipmentChangeRequestPlanModals | 1 |
| OrderDetailModal | 1 |
| ProgressIndicator | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | USERID | User ID | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 82 |
| POPUP_COLUMNS | USERNAME | User Name | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 83 |
| POPUP_COLUMNS | USERNAME_E | English Name | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 91 |
| POPUP_COLUMNS | DEPT_NAME | Dept Name | 240 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 99 |
| ORDER_DETAIL_COLUMNS | SO_NO | SO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 39 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_NO | SO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 40 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_QTY | SO Item Qty | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 41 |
| ORDER_DETAIL_COLUMNS | DO_NO | DO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 42 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_NO | DO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 43 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_QTY | DO Item Qty. | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 44 |
| ORDER_DETAIL_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-change-request-plan/components/modals/OrderDetailModal.tsx | 45 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01208 | 1 |
| MSG01215 | 1 |
| MSG01309 | 1 |
| MSG00667 | 1 |
| MSG00004 | 1 |
| MSG00001 | 1 |
| MSG00614 | 1 |
| MSG00429 | 1 |
| MSG01275 | 1 |
| MSG01189 | 1 |
| MSG00684 | 1 |
| MSG01188 | 1 |
| MSG01258 | 1 |
| MSG01259 | 1 |
| MSG01202 | 1 |
| MSG01296 | 1 |
| MSG01126 | 1 |
| MSG01206 | 1 |
| MSG01212 | 1 |
| MSG01213 | 1 |
| MSG01291 | 1 |
| MSG00247 | 1 |
| MSG00328 | 1 |
| MSG01269 | 1 |
| MSG01317 | 1 |
| MSG01350 | 1 |
| MSG01347 | 1 |
| MSG01081 | 1 |
| MSG01209 | 1 |
| MSG01082 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00014 | 1 |
| LBL01115 | 1 |
| LBL00618 | 1 |
| LBL01111 | 1 |
| LBL01063 | 1 |
| LBL01061 | 1 |
| LBL00112 | 1 |
| LBL00632 | 1 |
| LBL01107 | 1 |
| LBL01108 | 1 |
| LBL01071 | 1 |
| LBL01052 | 1 |
| LBL01125 | 1 |
| LBL01060 | 1 |
| LBL01104 | 1 |
| LBL01105 | 1 |
| LBL00107 | 1 |
| LBL01028 | 1 |
| LBL00358 | 1 |
| LBL00359 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0200(14), SSP0015(5), SSP0201(3), SSP0024(2), SCP0001(2), SSP0002(1), SSP0050(1), COM0010(1), SSP0014(1), SSP0020(1), SSP0025(1), SSP0202(1), SSP0019(1), SCP0028(1), SSP0003(1)
- SP/PKG: PKG_SSP0200(15), FN_MULTY_TIME(3), P_TIME_ZONE(3), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW(3), P_ACTIVE_FLAG(3), P_SSP0300_GET_ORDER_DETAIL(2), P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST(2), SSP0200_GET_SHIPMENT_DIVISION(2), PKG_COM0000(2), P_SCM0001_GET_SCP_DAY_PERIOD(2), P_SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING(2), PKG_SSP0002(1), P_SSP0002_GET_USER_INFO_LIST(1), SSP0002_GET_USER_INFO_LIST(1), P_SEARCH(1), P_DEL_FLAG(1), P_IF_SEND_FLAG(1), P_SSP0200_GET_SHIPMENT_REQUEST_DRAFTING(1), PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE(1), P_SSP0200_ERP_IFSEQ_MERGE(1), P_STATUS(1), SSP0300_GET_ORDER_DETAIL(1), P_TIMEZONE(1), SSP0200_GET_ITEM_FROM_BOD(1), P_SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE(1), P_OPEN_ERROR(1), P_MESSAGE(1), P_SSP0200_SAVE_SHIPMENT_CONFIRM_NEW(1), P_ERP_ATTR3(1), P_USER_ID(1), P_SSP0200_SAVE_SHIPMENT_REQUEST_DRAFTING(1), P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM(1), P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM(1), P_SSP0200_SCM_SSP_DEL_DRAFTING_BY_CONFIRM(1), P_SSP0200_SCM_SSP_ERP_ERROR_CONFIRM(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | · `display` 누락 -> `DataGrid.tsx:979` 의 `filter(column => column.display)` 에서 전건 탈락 | features/shipping/src/pages/shipment-change-request-plan/components/modals/ApprovalUserModal.tsx | 74 |
| code | 파생이 불가한 입력(LT 공백 등)이면 AS-IS 도 그 자리에서 return 해 전파가 없다. | features/shipping/src/pages/shipment-change-request-plan/components/ShipmentChangeRequestPlanMainGrid.tsx | 438 |
| code | 수정행 묶음 저장 — AS-IS `GetERPInterface` **2번째 루프**(cs:3593~3640)의 이식이다. 묶음마다 DRAFTING SP 1콜(`SoNo`/`NonSoNo`) -> 2행 이상이면 IFSEQ 병합(cs:4514) -> ERP I/F(cs:4516). 실패해도 다음 묶음을 계속 돌린다 — AS-IS 도 `bReturn = false` 만 세우고 `//return false;` 는 주석이다(cs:361 | features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanSaveActions.ts | 210 |
| code | SubTitle 툴바 구성 — `01_layout.md §2-E` 확정값을 그대로 옮긴다(재판단 금지). - `search` : master + detail **동시** 조회(`FindButton` cs:757). - `insert` : `InsertButton` 내부 가드(`RowCount>0`) 재현은 핸들러 쪽. - `save` : `useSaveWithValidation` 과 세트. - `delete` : **저장 전  | features/shipping/src/pages/shipment-change-request-plan/hooks/useShipmentChangeRequestPlanToolbar.ts | 11 |
| code | const searchedDivisionId = String(filters[SHEETS.MAIN]?.divisionId ?? ''); | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 149 |
| code | GridAction.addRow(grid, buildCopiedRow(base, sc.divisionId) as never, 'above', true); | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 341 |
| code | DeleteButton — **저장 전 신규행(CRUD_TYPE='I')만** 그리드에서 걷어낸다(사용자 지시 2026-10-03). 수정중인 행과 기존 조회행은 제거도, `CRUD_TYPE='D'` 마킹도 하지 않는다 — `GridAction.removeRow` 의 2번째 인자 `deleteOnlyNew=true` 가 그 규약이다 (정본 선례: admin/user-management `onDelete` / master/sal | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 351 |
| code | GridAction.addRowSet(grid, copied as never[], 'above', { preserveMergeManager: true }); | features/shipping/src/pages/shipment-change-request-plan/ShipmentChangeRequestPlan.tsx | 395 |
| code | AS-IS 2번 루프의 호출 단위를 그대로 복원한다 — ERP_SO_NO 가 있는 수정행은 **같은 SO 묶음 1콜**(`SoNo`), 없는 수정행은 **행마다 1콜**(`NonSoNo`). 어느 쪽이든 CHANGE_TYPE='P' 행은 제외된다(cs:3602 / cs:4393). 묶음 멤버는 `source` 전체에서 찾는다 — 사용자가 직접 건드리지 않은 같은 SO 의 행도 AS-IS 가 함께 싣는다(cs:4384~4399  | features/shipping/src/pages/shipment-change-request-plan/utils/shipmentChangeRequestPlanSave.ts | 381 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

