# SSP0015 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-plan-mobility-it` · feature: shipping · As-is Fact Pack 있음
- 파일 20 · 엔드포인트 호출 37 (미해결 2, 주석 속 4) · 이벤트 74 · 컴포넌트 사용 138 · 하드코딩 컬럼 28 · 메시지 49
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 28건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | component | 186 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | component | 109 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.module.scss | component | 15 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | component | 188 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | component | 602 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | component | 359 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | component | 701 |
| features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMemoModal.tsx | component | 169 |
| features/shipping/src/pages/shipment-plan-mobility-it/index.ts | index | 2 |
| features/shipping/src/pages/shipment-plan-mobility-it/shipment-plan-mobility-it.constants.ts | constants | 346 |
| features/shipping/src/pages/shipment-plan-mobility-it/shipment-plan-mobility-it.types.ts | types | 42 |
| features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.module.scss | style | 103 |
| features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | page | 1849 |
| features/shipping/src/pages/shipment-plan-mobility-it/useShipmentPlanMobilityItStore.ts | store | 515 |
| features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.detailSheets.ts | util | 136 |
| features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.editLock.ts | util | 93 |
| features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.merge.ts | util | 137 |
| features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.save.ts | util | 301 |
| features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.sum.ts | util | 84 |
| features/shipping/src/pages/shipment-plan-mobility-it/__asis-mapping__.md | mapping | 87 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /SSP0015/main/GET_REQ_DRAFTING/call-proc | http | 1 | Y | ShipmentChangeRequestDraftingModal.tsx:140 |
| /SSP0015/main/GET_ORDER_DETAIL/call-proc | http | 1 | Y | ShipmentOrderDetailModal.tsx:62 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentPsiDetailBar.tsx:48 ShipmentPlanMobilityIt.tsx:213 |
| (useTabComboQueries) | hook | 1 | Y | ShipmentPsiForm.tsx:78 |
| /SSP0015/main/USER_CHECK/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:158 |
| SSP0015/main//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:240 |
| SSP0015/mainPacker//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:247 |
| /SSP0015/main/GET_SHIPMENT_PSI_PACKER_PAST/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:259 |
| SSP0015/calendar//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:267 |
| SSP0015/confirmDetail//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:277 |
| /SSP0015/main/GET_SHIPMENT_CONFIRM_DETAIL_PACKER/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:288 |
| SSP0015/whStock//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:296 |
| SSP0015/holdStock//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:303 |
| SSP0015/mesStock//call-proc | hook | 2 | Y | ShipmentPlanMobilityIt.tsx:310 ShipmentPlanMobilityIt.tsx:604 |
| SSP0015/scsStock//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:317 |
| SSP0015/stockLocationDetail//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:324 |
| SSP0015/shipmentResult//call-proc | hook | 1 | Y | ShipmentPlanMobilityIt.tsx:331 |
| /SSP0015/main/GET_SHIPMENT_PSI_COMMENTS/call-proc | http | 2 | Y | ShipmentPlanMobilityIt.tsx:343 ShipmentPlanMobilityIt.tsx:1472 |
| /SSP0015/main/SAVE/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:490 |
| {?endpoint} | http | 1 | N | ShipmentPlanMobilityIt.tsx:519 |
| /SSP0015/holdStock/SAVE/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:573 |
| /common/web-service/erpIf/call | http | 2 | Y | ShipmentPlanMobilityIt.tsx:797 ShipmentPlanMobilityIt.tsx:834 |
| /SSP0015/main/IF_CHECK/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:823 |
| /SSP0015/main/DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:852 |
| /SSP0015/main/ERP_ERROR_CONFIRM/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:884 |
| /SSP0015/main/GET_SHIPMENT_STATUS/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:1075 |
| /SSP0015/main/GET_ERP_SO_NO_CNT/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:1138 |
| /SSP0015/main/CHECK_CONFIRM_CHANGETIME/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:1168 |
| /SSP0015/main/{draftBtn}/call-proc | http | 1 | N | ShipmentPlanMobilityIt.tsx:1217 |
| /SSP0015/main/SAVE_SHIPMENT_PSI_COMMENTS/call-proc | http | 1 | Y | ShipmentPlanMobilityIt.tsx:1582 |
| /admin/menu/SSP0015/column | http | 1 | Y | useShipmentPlanMobilityItStore.ts:434 |
| /admin/menu/SSP0015/measure | http | 1 | Y | useShipmentPlanMobilityItStore.ts:462 |
| /admin/menu/SSP0015/search-conditions | http | 1 | Y | useShipmentPlanMobilityItStore.ts:491 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId fromSite itemId planStartYyyymmdd planType fromYyyymmdd toYyyymmdd userId myModelChk programId sheetName debugMode seq partLeaderChk teamLeaderChk nonChk delegateeChk | o_rc1 o_rc2 o_rc3 |  |
| mainPacker | divisionId fromSite itemId planStartYyyymmdd planType fromYyyymmdd toYyyymmdd userId myModelChk programId sheetName debugMode seq partLeaderChk teamLeaderChk nonChk delegateeChk | o_rc1 |  |
| calendar | startYyyymmdd endYyyymmdd | o_rc1 | PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |
| confirmDetail | divisionId fromSite itemId fromYyyymmdd toYyyymmdd planStartYyyymmdd language userId myModelChk requestor partLeaderChk teamLeaderChk searchYn nonChk realFlag debugMode delegateeChk | o_rc1 |  |
| holdStock | divisionId fromSite itemId planStartYyyymmdd planType seq language searchYn userId myModelChk partLeaderChk teamLeaderChk nonChk delegateeChk | o_rc1 |  |
| mesStock | divisionId fromSite itemId planStartYyyymmdd userId lotId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk language | o_rc1 |  |
| whStock | divisionId itemId planStartYyyymmdd planType planSeq fromSite userId myModelChk partLeaderChk teamLeaderChk searchYn nonChk delegateeChk | o_rc1 |  |
| scsStock | divisionId planStartYyyymmdd fromSite itemId userId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk | o_rc1 |  |
| stockLocationDetail | divisionId companyId fromSite itemId planStartYyyymmdd dblFlag language programId sheetName debugMode userId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk | o_rc1 |  |
| shipmentResult | divisionId fromSite itemId fromYyyymmdd toYyyymmdd type userId companyId myModelChk partLeaderChk teamLeaderChk delegateeChk nonChk realFlag planStartYyyymmdd | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 179 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 102 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 71 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 80 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 104 |
| Button | onClick | onModelSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 100 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 120 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 147 |
| Button | onClick | onRequestorSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 143 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 170 |
| Button | onClick | onDetailSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailBar.tsx | 181 |
| g | beginningEdit | gateHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 188 |
| g | pastingCell | gateHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 189 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 203 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 255 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 256 |
| g | pastedCell | pastedDateHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 294 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 311 |
| g | beginningEdit | gate | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 345 |
| g | pastingCell | gate | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 346 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 365 |
| g | cellEditEnding | editEnding | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 389 |
| g | pastingCell | pasteCheck | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 390 |
| g | cellEditEnded | dateCheck | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 414 |
| g | pastedCell | dateCheck | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 415 |
| g | updatedLayout | <arrow> pinFooterToBottom | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 457 |
| g | formatItem | fmt | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 481 |
| g | formatItem | paint | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 545 |
| DataGrid | gotFocus | handleGotFocus | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 595 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 176 |
| CustomDropdown | onChange | <arrow>  | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 194 |
| CustomDropdown | onChange | <arrow> set,str(picked).split(',').filter,str(picked).split,str | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 218 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 236 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 265 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 261 |
| CustomDropdown | onChange | <arrow> handlePlanDateChange,str | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 281 |
| PeriodField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 294 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 324 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 329 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 334 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 339 |
| Checkbox | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 345 |
| g | updatedLayout | applyMerge | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 336 |
| g | loadedRows | applyMerge | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 338 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 351 |
| g | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 371 |
| g.hostElement | keydown | qtyKeyHandler | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 396 |
| edt | input | <arrow> clean | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 407 |
| edt | compositionend | clean | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 410 |
| g | prepareCellForEdit | prepareCellForEditHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 412 |
| g | cellEditEnding | qtyEditEndingHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 423 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 525 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 592 |
| g.hostElement | click | clickHandler | addEventListener | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 599 |
| g | updatedLayout | applyDynVisibility | addHandler | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 656 |
| InputField | onChange | <arrow> setChangeQty,onlyDigits | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMemoModal.tsx | 117 |
| InputField | onChange | <arrow> setComments | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMemoModal.tsx | 136 |
| Button | onClick | handleSubmit | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMemoModal.tsx | 154 |
| Button | onClick | onClose | jsx | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMemoModal.tsx | 161 |
| ShipmentPsiMainGrid | onDrilldown | handleMainDrilldown | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1636 |
| ShipmentPsiMainGrid | onFigureDrilldown | handleFigureDrilldown | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1637 |
| ShipmentPsiMainGrid | onMemo | canMemo ? handleMemo : undefined | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1640 |
| ShipmentPsiForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1653 |
| ShipmentPsiForm | onItemSearch | <arrow> setOpenItemMain | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1653 |
| ShipmentPsiDetailBar | onDetailSearch | handleDetailSearch | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1696 |
| ShipmentPsiDetailBar | onModelSearch | <arrow> setOpenItemDetail | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1697 |
| ShipmentPsiDetailBar | onRequestorSearch | <arrow> setOpenRequestor | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1698 |
| ShipmentPsiDetailGrid | onConfirmDetail | setReqDraftingNo | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1729 |
| ShipmentPsiDetailGrid | onOrderDetail | setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1730 |
| MeasureSelectModal | onApply | <arrow> setOpenMeasure,applyVisibleMeasures,(staticMeasures[activeMainSheet]??[]).map,saveTitleSet({menuId:MENU_ID,sheetName:ADMIN_SHEET_NAME[activeMainSheet]??'',columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1786 |
| ShipmentPsiMemoModal | onClose | <arrow> setMemoCtx | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1831 |
| ShipmentPsiMemoModal | onSave | handleMemoSave | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1832 |
| ShipmentOrderDetailModal | onClose | <arrow> setOrderDetailCtx | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1837 |
| ShipmentChangeRequestDraftingModal | onClose | <arrow> setReqDraftingNo | jsx | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1844 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Box | 17 |
| Grid | 15 |
| FormItem | 11 |
| RO | 10 |
| FLabel | 8 |
| FValue | 8 |
| Button | 8 |
| InputField | 7 |
| CustomDropdown | 5 |
| Checkbox | 5 |
| DataGrid | 4 |
| CustomDialog | 3 |
| Stack | 3 |
| PeriodField | 3 |
| FunctionSearchIcon | 3 |
| TabItem | 3 |
| TabWrapper | 2 |
| Panel | 2 |
| MaterialByDivisionModal | 2 |
| RequestForm | 1 |
| SearchArea | 1 |
| Label | 1 |
| Typography | 1 |
| ControlConfirmIcon | 1 |
| IcMeasureSelect | 1 |
| ShipmentPsiMainGrid | 1 |
| MainTitle | 1 |
| ShipmentPsiForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PanelSeparator | 1 |
| ShipmentPsiDetailBar | 1 |
| ShipmentPsiDetailGrid | 1 |
| MeasureSelectModal | 1 |
| SsoUserModal | 1 |
| ShipmentPsiMemoModal | 1 |
| ShipmentOrderDetailModal | 1 |
| ShipmentChangeRequestDraftingModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| DRAFTING_COLUMNS | ERP_SO_NO | SO No | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 41 |
| DRAFTING_COLUMNS | PROJECT_NAME | Project Name | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 42 |
| DRAFTING_COLUMNS | FCST_TYPE | FCST Type | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 43 |
| DRAFTING_COLUMNS | ITEM_ID | Model | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 44 |
| DRAFTING_COLUMNS | FROM_SITE | From Site | 80 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 45 |
| DRAFTING_COLUMNS | TO_SITE | To Site | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 46 |
| DRAFTING_COLUMNS | INCOTERMS | Incoterms | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 47 |
| DRAFTING_COLUMNS | LT_DAY | L/T(Day) | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 49 |
| DRAFTING_COLUMNS | ETD | ETD | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 50 |
| DRAFTING_COLUMNS | ETA | ETA | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 51 |
| DRAFTING_COLUMNS | TRANSPORT_MODE | Trans Mode | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 52 |
| DRAFTING_COLUMNS | SHIPMENT_DATE | Shipment Date | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 53 |
| DRAFTING_COLUMNS | SHIPMENT_CONFIRM_QTY | Qty | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 54 |
| DRAFTING_COLUMNS | NEW_LT_DAY | L/T(Day) | 70 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 56 |
| DRAFTING_COLUMNS | NEW_ETD | ETD | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 57 |
| DRAFTING_COLUMNS | NEW_ETA | ETA | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 58 |
| DRAFTING_COLUMNS | NEW_TRANSPORT_MODE | Trans Mode | 75 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 59 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_DATE | Shipment Date | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 60 |
| DRAFTING_COLUMNS | NEW_SHIPMENT_CONFIRM_QTY | Qty | 90 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 61 |
| DRAFTING_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentChangeRequestDraftingModal.tsx | 63 |
| ORDER_DETAIL_COLUMNS | SO_NO | SO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 41 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_NO | SO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 42 |
| ORDER_DETAIL_COLUMNS | SO_ITEM_QTY | SO Item Qty | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 43 |
| ORDER_DETAIL_COLUMNS | DO_NO | DO NO. | 120 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 44 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_NO | DO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 45 |
| ORDER_DETAIL_COLUMNS | DO_ITEM_QTY | DO Item Qty. | 110 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 46 |
| ORDER_DETAIL_COLUMNS | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentOrderDetailModal.tsx | 47 |
| dynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| 'SUM' : m.kind === 'B' ? m.leaf : | 80 | isDynVisible(m.kind, bucketType, chkSumRef.current) |  |  | object | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 173 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00284 | 1 |
| MSG00225 | 1 |
| MSG00004 | 2 |
| MSG00704 | 1 |
| MSG00013 | 1 |
| MSG00429 | 1 |
| MSG01291 | 1 |
| MSG01289 | 1 |
| MSG01261 | 1 |
| MSG01185 | 1 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| MSG01230 | 1 |
| MSG00109 | 1 |
| MSG00002 | 1 |
| MSG00003 | 1 |
| MSG01395 | 1 |
| MSG01257 | 1 |
| MSG00611 | 1 |
| MSG01206 | 1 |
| MSG01258 | 1 |
| MSG01259 | 1 |
| MSG01202 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00710 | 1 |
| LBL00687 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL01142 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL01090 | 1 |
| LBL01108 | 1 |
| LBL01093 | 1 |
| LBL01101 | 1 |
| LBL01124 | 1 |
| LBL01070 | 1 |
| LBL01109 | 1 |
| LBL01115 | 1 |
| LBL00310 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00783 | 1 |
| MSG01208 | 1 |
| MSG01215 | 1 |
| MSG01309 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0015(36), SSP0200(5), SSP0300(5), SSP0003(5), SCM0002(4), SSP0021(2), SSP0060(2), SSP0012(1), SCP0020(1)
- SP/PKG: PKG_SSP0003(4), P_SSP0003_GET_DRAFTING(4), SCM0001_GET_SCP_DAY_PERIOD(4), P_ACTIVE_FLAG(4), P_SSP0003_GET_REQ_DRAFTING(3), SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(2), P_SSP0300_GET_ORDER_DETAIL(2), PKG_SSP0300(2), SSP0002_GET_USER_INFO_LIST(2), P_SSP0003_SAVE_REQ_IF_CHECK(2), P_PLAN_TYPE(2), P_SSP0015_SAVE_SHIPMENT_PSI(2), P_USER_ID(2), P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING(2), P_CHANGE_REQUEST_NO(1), P_LANGUAGE(1), FN_MULTY_TIME(1), PR_GET_PROC_INFO_LIST(1), SSP0300_GET_ORDER_DETAIL(1), P_SSP0200_USER_CHECK(1), PKG_SSP0002(1), P_SSP0002_GET_USER_INFO_LIST(1), P_SSP0015_SCM_SSP_DEL_DRAFTING_BY_CONFIRM(1), P_SSP0015_SCM_SSP_ERP_ERROR_CONFIRM(1), P_SSP0003_GET_IF_CHECK(1), P_SSP0003_IF_CHECK(1), P_SSP0015_GET_WH_STOCK(1), FN_STRING_SPLIT(1), P_NONCHK(1), P_DIVISION_ID(1), P_FROM_SITE(1), P_ITEM_ID(1), P_PLAN_START_YYYYMMDD(1), P_YYYYMMDD(1), P_MEASURE(1), P_DEBUG_MODE(1), PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(1), P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40(1), P_SSP0015_SAVE_BLOCK_STOCK_DATA(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | staticColumns fetch(시트별 ~13회 순차 도착)마다 재렌더될 때 그리드가 매번 재처리돼 과도한 깜빡임이 난다. | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 85 |
| code | }); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiDetailGrid.tsx | 410 |
| code | const companyId = useSessionStore(s => s.session.companyId); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 160 |
| endpoint | const [myModelDefaultCheck] = useTabLookupQueries({ filters: [LOOKUP.MY_MODEL_DEFAULT_CHECK] }); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 161 |
| code | const myModelDefaultApplied = useRef(false); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 162 |
| code | useEffect(() => { | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 163 |
| code | if (myModelDefaultApplied.current) return; | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 164 |
| code | if (!companyId \|\| !myModelDefaultCheck \|\| myModelDefaultCheck.length === 0) return; | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 165 |
| code | const whitelist = new Set(myModelDefaultCheck.map(r => str(r.CODE))); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 166 |
| code | if (whitelist.has(companyId)) set({ chkMyModel: true }); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 168 |
| code | }, [companyId, myModelDefaultCheck]); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiForm.tsx | 170 |
| jsx | const mergeWrappedRef = useRef<FlexGridType \| null>(null); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 217 |
| code | g.mergeManager = new ShipmentPsiMergeManager(g.mergeManager); | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 301 |
| code | 편집 가능 셀(= WH_IN 최신 Plan D_)만 Wijmo 편집에 맡기고(return), 그 외 잠긴 셀은 drill/memo. | features/shipping/src/pages/shipment-plan-mobility-it/components/ShipmentPsiMainGrid.tsx | 565 |
| code | const mainRows = useMemo<MainRow[]>( | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 364 |
| code | () => | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 365 |
| code | ); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 370 |
| code | const mainRows = useMemo<MainRow[]>( | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 398 |
| code | () => | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 399 |
| code | ); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 406 |
| code | const detailStaticColumns = useMemo(() => { | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 446 |
| code | if (mainSheet !== 'packer') return staticColumns; | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 447 |
| code | if (!cd) return staticColumns; | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 449 |
| code | const packerHidden = new Set(['ERP_SO_NO', 'TRANSPORT_MODE']); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 450 |
| code | return { | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 451 |
| code | [SHEETS.CONFIRM_DETAIL]: cd.map(c => | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 453 |
| code | }; | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 456 |
| code | }, [staticColumns, mainSheet]); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 457 |
| code | setDetailFilter(SHEETS.CONFIRM_DETAIL, 'N'); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 546 |
| endpoint | const { mutate: mutateHold } = useProcMutation<MENU_ID, SHEETS.HOLD_STOCK>({ | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 559 |
| code | onSuccess: () => { | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 563 |
| code | holdStockEditTrackerRef.current?.clearChanges(); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 564 |
| code | setToast({ type: 'success', message: t(MSG.SAVED, '__Saved successfully.') }); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 565 |
| code | setDetailFilter(SHEETS.HOLD_STOCK, 'N'); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 566 |
| code | }); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 568 |
| code | setDetailFilter(SHEETS.MES_STOCK, 'N'); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 611 |
| code | setToast({ type: 'error', message: t(MSG.NO_MODIFICATION, '__No modifications have been made.') }); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1055 |
| code | mutateHold(dirty as unknown as HoldStockRow[]); | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1313 |
| code | if (activeDetailSheet !== SHEETS.HOLD_STOCK) return; // AS-IS Insert 가드(Hold stock 한정, 01 R5) | features/shipping/src/pages/shipment-plan-mobility-it/ShipmentPlanMobilityIt.tsx | 1368 |
| code | const KEEP = new Set<string>([SHEETS.MAIN, SHEETS.MAIN_PACKER, SHEETS.CALENDAR]); | features/shipping/src/pages/shipment-plan-mobility-it/useShipmentPlanMobilityItStore.ts | 188 |
| endpoint | Measure 동적 fetch (SCM_MST_SHEET_MEASURE) — MeasureSelectModal 대상. 시트별 보관. | features/shipping/src/pages/shipment-plan-mobility-it/useShipmentPlanMobilityItStore.ts | 455 |
| code | const blank = typeof va === 'string' && va.trim() === ''; | features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.merge.ts | 67 |
| code | return !blank && va === (rb[binding] ?? ''); | features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.merge.ts | 68 |
| code | shipmentDate: r => str(r.SHIPMENT_DATE), // proc 가 SUBSTR(1,10)+REPLACE('-') 로 정규화 | features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.save.ts | 225 |
| code | newEtdDate: r => str(r.NEW_ETD), | features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.save.ts | 230 |
| code | newEtaDate: r => str(r.NEW_ETA), | features/shipping/src/pages/shipment-plan-mobility-it/utils/shipment-plan-mobility-it.save.ts | 231 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

