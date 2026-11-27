# SCP0132 — To-Be Fact Pack 요약

- page_key: `supply/constraint-of-shipment-qty` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 6 (미해결 0, 주석 속 4) · 이벤트 21 · 컴포넌트 사용 36 · 하드코딩 컬럼 0 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | component | 319 |
| features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | component | 249 |
| features/supply/src/pages/constraint-of-shipment-qty/constraint-of-shipment-qty.constants.ts | constants | 169 |
| features/supply/src/pages/constraint-of-shipment-qty/constraint-of-shipment-qty.types.ts | types | 30 |
| features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | page | 251 |
| features/supply/src/pages/constraint-of-shipment-qty/hooks/useConstraintOfShipmentQtyValidation.ts | hook | 141 |
| features/supply/src/pages/constraint-of-shipment-qty/index.ts | index | 2 |
| features/supply/src/pages/constraint-of-shipment-qty/useConstraintOfShipmentQtyStore.ts | store | 234 |
| features/supply/src/pages/constraint-of-shipment-qty/utils/constraint-of-shipment-qty.cascadeCombo.ts | util | 97 |
| features/supply/src/pages/constraint-of-shipment-qty/utils/constraint-of-shipment-qty.editLock.ts | util | 108 |
| features/supply/src/pages/constraint-of-shipment-qty/utils/constraintOfShipmentQtySaveRequest.ts | util | 161 |
| features/supply/src/pages/constraint-of-shipment-qty/__asis-mapping__.md | mapping | 89 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ConstraintOfShipmentQtyForm.tsx:62 |
| SCP0132/main//call-proc | hook | 1 | Y | ConstraintOfShipmentQty.tsx:67 |
| SCP0132/init//call-proc | hook | 1 | Y | ConstraintOfShipmentQty.tsx:82 |
| /admin/menu/SCP0132/column | http | 1 | Y | useConstraintOfShipmentQtyStore.ts:166 |
| /admin/menu/SCP0132/search-conditions | http | 1 | Y | useConstraintOfShipmentQtyStore.ts:197 |
| /SCP0132/main/SAVE/call-proc | http | 1 | Y | constraintOfShipmentQtySaveRequest.ts:145 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId fromSiteId toSiteId modelGroupName itemId stage fromDate toDate validYn | o_rc1 | SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY SCP0132_GET_SEARCH_INFO PKG_SCP0132 |
| init | divisionId scmSiteId | o_rc1 o_rc2 o_rc3 o_rc4 o_rc5 o_rc6 | SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY SCP0132_GET_SEARCH_INFO PKG_SCP0132 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 114 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,setDivisionKey | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 128 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 157 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 185 |
| Button | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 181 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 204 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 225 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 244 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 264 |
| PeriodRangePicker | onChange | handlePeriodChange | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 279 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 296 |
| g | updatedView | updatedViewHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 108 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 122 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 131 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 143 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 154 |
| g.hostElement | keydown | keydownHandler | addEventListener | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 173 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 190 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 224 |
| ConstraintOfShipmentQtyForm | onSearch | handleSearch | jsx | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 227 |
| ConstraintOfShipmentQtyGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 246 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 8 |
| CustomDropdown | 7 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ConstraintOfShipmentQtyForm | 1 |
| SubTitle | 1 |
| ConstraintOfShipmentQtyGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 1 |
| MSG00099 | 1 |
| MSG00022 | 1 |
| MSG00219 | 1 |
| MSG00458 | 1 |
| MSG00460 | 1 |
| MSG01081 | 1 |
| MSG00611 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG01122 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00063 | 1 |
| LBL00061 | 1 |
| LBL00007 | 1 |
| LBL00669 | 1 |
| LBL00013 | 1 |
| LBL00112 | 1 |
| MSG00003 | 1 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0132(6), SCP0128(4), SCP0127(4), SCP0131(2), SCP0006(2), SCP0011(2), SCP0130(1), SCP0053(1), DMF0020(1)
- SP/PKG: PKG_SCP0132(3), SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY(2), SCP0132_GET_SEARCH_INFO(2), SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY(1), P_SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 저장: SAVE SP 24개 IN 이 전부 CLOB 이라 공용 useProcMutation({data:[rows]}) 로는 전부 null 바인딩돼 | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 34 |
| code | 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시. | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 152 |
| endpoint | CLOB(JVARCHAR 아님)이라 공용 useProcMutation({data:[rows]}) 로는 BE 가 top-level camelCase 키를 | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 164 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 23행 등록됨, design 03 §1). | features/supply/src/pages/constraint-of-shipment-qty/useConstraintOfShipmentQtyStore.ts | 29 |
| endpoint | → 공용 useProcMutation({data:[rows]}) 로는 top-level 에 activeFlag/divisionId... camelCase 키가 없어 | features/supply/src/pages/constraint-of-shipment-qty/utils/constraintOfShipmentQtySaveRequest.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

