# SCP0028 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-lot-size` · feature: shipping · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 30 · 컴포넌트 사용 55 · 하드코딩 컬럼 7 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 7건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.module.scss | component | 44 |
| features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | component | 388 |
| features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | component | 259 |
| features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | component | 157 |
| features/shipping/src/pages/shipment-lot-size/hooks/useShipmentLotSizeValidation.ts | hook | 80 |
| features/shipping/src/pages/shipment-lot-size/index.ts | index | 2 |
| features/shipping/src/pages/shipment-lot-size/shipment-lot-size.constants.ts | constants | 183 |
| features/shipping/src/pages/shipment-lot-size/shipment-lot-size.types.ts | types | 26 |
| features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.module.scss | style | 12 |
| features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | page | 407 |
| features/shipping/src/pages/shipment-lot-size/useShipmentLotSizeStore.ts | store | 175 |
| features/shipping/src/pages/shipment-lot-size/utils/shipmentLotSize.columns.ts | util | 40 |
| features/shipping/src/pages/shipment-lot-size/utils/shipmentLotSize.derive.ts | util | 34 |
| features/shipping/src/pages/shipment-lot-size/utils/shipmentLotSize.editLock.ts | util | 14 |
| features/shipping/src/pages/shipment-lot-size/utils/shipmentLotSize.saveRequest.ts | util | 93 |
| features/shipping/src/pages/shipment-lot-size/__asis-mapping__.md | mapping | 83 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ShipmentLotSizeBatchModal.tsx:79 ShipmentLotSizeForm.tsx:53 |
| SCP0028/popup//call-proc | hook | 1 | Y | ShipmentLotSizeBatchModal.tsx:96 |
| SCP0028/main//call-proc | hook | 1 | Y | ShipmentLotSize.tsx:85 |
| /SCP0028/main/INSERT/call-proc | http | 1 | Y | ShipmentLotSize.tsx:215 |
| /admin/menu/SCP0028/column | http | 1 | Y | useShipmentLotSizeStore.ts:130 |
| /admin/menu/SCP0028/search-conditions | http | 1 | Y | useShipmentLotSizeStore.ts:151 |
| /SCP0028/main/SAVE/call-proc | http | 1 | Y | shipmentLotSize.saveRequest.ts:78 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId operationGroup fromSite toSite transMode itemId valid | o_rc1 | PKG_SCP0028 P_SCP0028_GET_SHIPMENT_LOT_SIZE P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP |
| input | divisionId operationGroup fromSite toSite itemId userId | o_rc1 | PKG_SCP0028 P_SCP0028_GET_SHIPMENT_LOT_SIZE P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP |
| popup | divisionId operationGroup fromSite toSite itemId actionFlag | o_rc1 | PKG_SCP0028 P_SCP0028_GET_SHIPMENT_LOT_SIZE P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleFind | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 248 |
| CustomDropdown | onChange | <arrow> String,setFromSite,setToSite,setOpGroup,setModel,setDiv | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 262 |
| CustomDropdown | onChange | <arrow> setFromSite,String | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 292 |
| CustomDropdown | onChange | <arrow> setToSite,String | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 309 |
| InputField | onChange | <arrow> setModel | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 325 |
| InputField | onKeyDown | <arrow> handleFind | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 326 |
| CustomDropdown | onChange | <arrow> setOpGroup,String | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 341 |
| Button | onClick | handleConfirm | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 373 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 380 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 94 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 121 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 143 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 181 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 211 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 212 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 207 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 230 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeForm.tsx | 249 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 80 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 96 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 97 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 115 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 128 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-lot-size/components/ShipmentLotSizeGrid.tsx | 153 |
| ShipmentLotSizeForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 321 |
| ShipmentLotSizeForm | onItemSearch | <arrow> setItemModalOpen | jsx | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 322 |
| ShipmentLotSizeGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 358 |
| ShipmentLotSizeBatchModal | onClose | <arrow> setBatchMode | jsx | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 399 |
| ShipmentLotSizeBatchModal | onConfirm | <arrow> handleBatchDeleteConfirm,handleBatchInputConfirm | jsx | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 400 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 12 |
| CustomDropdown | 10 |
| Button | 3 |
| SearchArea | 2 |
| InputField | 2 |
| DataGrid | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| FunctionSearchIcon | 1 |
| MainTitle | 1 |
| ShipmentLotSizeForm | 1 |
| SubTitle | 1 |
| ShipmentLotSizeGrid | 1 |
| MaterialByDivisionModal | 1 |
| ShipmentLotSizeBatchModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | DIVISION_ID | t(LBL.DIVISION, 'Division') | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 110 |
| columns | OPERATION_GROUP_ID | t(LBL.OPERATION_GROUP, 'Operation Group') | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 111 |
| columns | FROM_SITE_DESCRIPTION | t(LBL.FROM_SITE, 'From Site') | 150 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 112 |
| columns | TO_SITE_DESCRIPTION | t(LBL.TO_SITE, 'To Site') | 150 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 113 |
| columns | ITEM_ID | t(LBL.MODEL, 'Model') | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 114 |
| columns | NICK_NAME | t('LBL00767', 'Nick Name') | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 115 |
| buildColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | meta-map | features/shipping/src/pages/shipment-lot-size/utils/shipmentLotSize.columns.ts | 18 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00767 | 1 |
| MSG00429 | 2 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00639 | 1 |
| LBL00025 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL01142 | 1 |
| LBL00112 | 1 |
| LBL00872 | 1 |
| LBL00108 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00002 | 1 |
| MSG00133 | 1 |
| MSG00006 | 1 |
| MSG00031 | 1 |
| MSG00618 | 1 |
| MSG00099 | 1 |
| MSG00699 | 1 |
| MSG01091 | 1 |
| MSG00014 | 1 |
| MSG00683 | 1 |
| MSG00719 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0028(10), SCP0005(4), SCP0006(2), SCP0025(2), SCM0002(2), SSP0025(2), SCM0008(1), SSP0003(1), COM0013(1), SCP0001(1)
- SP/PKG: PKG_SCP0028(11), P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP(3), P_SCP0028_GET_SHIPMENT_LOT_SIZE(2), P_SCP0028_SAVE_SHIPMENT_LOT_SIZE(2), P_USER_ID(2), P_DEBUG_MODE(2), FN_GET_LOOKUP_CODE_DESC(1), FN_GET_SCM_SITE_DESCRIPTION(1), P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT(1), PKG_NSCM_UI_COM_AUTH(1), PR_GET_MNU_BTN_AUTH(1), P_ACTIVE_FLAG(1), P_VALID_YN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | AS-IS `if (action_flag=="D") { if (GMessageBox("MSG00016") != Yes) return; }` (cs:362~364). | features/shipping/src/pages/shipment-lot-size/components/modals/ShipmentLotSizeBatchModal.tsx | 202 |
| jsx | 저장검증 3종(design 03 §4.3): LOT<INC / 0값 (클라) → 통과 후 메타 필수검증(saveWithValidation) → SAVE. | features/shipping/src/pages/shipment-lot-size/ShipmentLotSize.tsx | 191 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(미등록 시 빈 배열 → constants | features/shipping/src/pages/shipment-lot-size/useShipmentLotSizeStore.ts | 21 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

