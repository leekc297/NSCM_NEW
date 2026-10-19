# SCP0132 — To-Be Fact Pack 요약

- page_key: `supply/constraint-of-shipment-qty` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 19 · 컴포넌트 사용 40 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | component | 323 |
| features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | component | 143 |
| features/supply/src/pages/constraint-of-shipment-qty/constraint-of-shipment-qty.constants.ts | constants | 142 |
| features/supply/src/pages/constraint-of-shipment-qty/constraint-of-shipment-qty.types.ts | types | 30 |
| features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | page | 189 |
| features/supply/src/pages/constraint-of-shipment-qty/hooks/useConstraintOfShipmentQtyValidation.ts | hook | 82 |
| features/supply/src/pages/constraint-of-shipment-qty/index.ts | index | 2 |
| features/supply/src/pages/constraint-of-shipment-qty/useConstraintOfShipmentQtyStore.ts | store | 188 |
| features/supply/src/pages/constraint-of-shipment-qty/utils/constraint-of-shipment-qty.cascadeCombo.ts | util | 40 |
| features/supply/src/pages/constraint-of-shipment-qty/utils/constraint-of-shipment-qty.editLock.ts | util | 94 |
| features/supply/src/pages/constraint-of-shipment-qty/__asis-mapping__.md | mapping | 92 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ConstraintOfShipmentQtyForm.tsx:61 |
| SCP0132/main//call-proc | hook | 2 | Y | ConstraintOfShipmentQty.tsx:53 ConstraintOfShipmentQty.tsx:60 |
| /admin/menu/SCP0132/column | http | 1 | Y | useConstraintOfShipmentQtyStore.ts:135 |
| /admin/menu/SCP0132/search-conditions | http | 1 | Y | useConstraintOfShipmentQtyStore.ts:166 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 89 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 104 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 133 |
| InputField | onChange | <arrow>  | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 164 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 158 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 184 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 204 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 224 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 248 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 265 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 283 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyForm.tsx | 300 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 61 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 71 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 83 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 95 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/constraint-of-shipment-qty/components/ConstraintOfShipmentQtyGrid.tsx | 118 |
| ConstraintOfShipmentQtyForm | onSearch | handleSearch | jsx | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 166 |
| ConstraintOfShipmentQtyGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 184 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 10 |
| FormItem | 10 |
| CustomDropdown | 7 |
| DatePickerCalendar | 2 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
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
| MSG00001 | 1 |
| MSG00099 | 1 |
| MSG00022 | 1 |
| MSG00219 | 1 |
| MSG00458 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG01122 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL01092 | 1 |
| LBL00061 | 1 |
| LBL00639 | 1 |
| LBL00062 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0132(5), SCP0131(3), SCP0020(1), SCP0130(1), SCP0053(1), DMF0020(1)
- SP/PKG: PKG_SCP0132(4), SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY(2), SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_QTY(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시. | features/supply/src/pages/constraint-of-shipment-qty/ConstraintOfShipmentQty.tsx | 117 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 23행 등록됨, design 03 §1). | features/supply/src/pages/constraint-of-shipment-qty/useConstraintOfShipmentQtyStore.ts | 23 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

