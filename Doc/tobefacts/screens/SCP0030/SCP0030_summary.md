# SCP0030 — To-Be Fact Pack 요약

- page_key: `supply/bod-item` · feature: supply · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 20 · 컴포넌트 사용 47 · 하드코딩 컬럼 17 · 메시지 22
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 17건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/bod-item/bod-item.constants.ts | constants | 236 |
| features/supply/src/pages/bod-item/bod-item.types.ts | types | 23 |
| features/supply/src/pages/bod-item/BodItem.module.scss | style | 15 |
| features/supply/src/pages/bod-item/BodItem.tsx | page | 427 |
| features/supply/src/pages/bod-item/components/BodExcludedGrid.tsx | component | 136 |
| features/supply/src/pages/bod-item/components/BodItemForm.module.scss | component | 12 |
| features/supply/src/pages/bod-item/components/BodItemForm.tsx | component | 210 |
| features/supply/src/pages/bod-item/components/BodItemGrid.tsx | component | 98 |
| features/supply/src/pages/bod-item/components/modals/GetBodItemModal.module.scss | component | 22 |
| features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | component | 180 |
| features/supply/src/pages/bod-item/index.ts | index | 2 |
| features/supply/src/pages/bod-item/useBodItemStore.ts | store | 148 |
| features/supply/src/pages/bod-item/utils/bod-item.util.ts | util | 122 |
| features/supply/src/pages/bod-item/__asis-mapping__.md | mapping | 67 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0030/bodItem//call-proc | hook | 2 | Y | BodItem.tsx:77 BodItem.tsx:105 |
| SCP0030/bodItemExcluded//call-proc | hook | 2 | Y | BodItem.tsx:97 BodItem.tsx:116 |
| (useTabComboQueries) | hook | 1 | Y | BodItemForm.tsx:41 |
| SCP0030/bodPopup//call-proc | hook | 1 | Y | GetBodItemModal.tsx:72 |
| /admin/menu/SCP0030/column | http | 1 | Y | useBodItemStore.ts:110 |
| /admin/menu/SCP0030/search-conditions | http | 1 | Y | useBodItemStore.ts:126 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| bodItem | divisionId fromSite toSite incoterms transMode itemId nickName valid | o_rc1 | PKG_SCP0030 P_SCP0030_ |
| bodItemExcluded | divisionId fromSite toSite incoterms transMode itemId nickName valid planGroupId | o_rc1 | PKG_SCP0030 P_SCP0030_ |
| itemPopup | divisionId scmSite itemId | o_rc1 | PKG_SCP0030 P_SCP0030_ |
| bodPopup | divisionId itemId planGroup | o_rc1 | PKG_SCP0030 P_SCP0030_ |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| BodItemForm | onSearch | handleSearch | jsx | features/supply/src/pages/bod-item/BodItem.tsx | 338 |
| BodItemForm | onOpenItemSearch | <arrow> setItemSearchOpen | jsx | features/supply/src/pages/bod-item/BodItem.tsx | 339 |
| BodExcludedGrid | onItemCellDblClick | <arrow> setItemPopup | jsx | features/supply/src/pages/bod-item/BodItem.tsx | 377 |
| BodExcludedGrid | onBodCellDblClick | <arrow> setBodPopup | jsx | features/supply/src/pages/bod-item/BodItem.tsx | 378 |
| grid | beginningEdit | handler | addHandler | features/supply/src/pages/bod-item/components/BodExcludedGrid.tsx | 98 |
| grid | updatedLayout | apply | addHandler | features/supply/src/pages/bod-item/components/BodExcludedGrid.tsx | 113 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 55 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 76 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 92 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 109 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 125 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 143 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 160 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 176 |
| FunctionSearchIcon | onClick | onOpenItemSearch | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 181 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/bod-item/components/BodItemForm.tsx | 200 |
| grid | beginningEdit | handler | addHandler | features/supply/src/pages/bod-item/components/BodItemGrid.tsx | 61 |
| grid | updatedLayout | apply | addHandler | features/supply/src/pages/bod-item/components/BodItemGrid.tsx | 76 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 165 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 172 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 8 |
| FormItem | 8 |
| CustomDropdown | 7 |
| DataGrid | 3 |
| Button | 3 |
| TabItem | 2 |
| MaterialByDivisionModal | 2 |
| MainTitle | 1 |
| BodItemForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| BodItemGrid | 1 |
| BodExcludedGrid | 1 |
| GetBodItemModal | 1 |
| SearchArea | 1 |
| InputField | 1 |
| FunctionSearchIcon | 1 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | FROM_SITE_NAME | From Site | 150 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 30 |
| POPUP_COLUMNS | TO_SITE_NAME | To Site | 150 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 31 |
| POPUP_COLUMNS | ITEM_ID | Model | 130 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 32 |
| POPUP_COLUMNS | PRIORITY | Priority | 70 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 33 |
| POPUP_COLUMNS | INCOTERMS | Incoterms | 80 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 34 |
| POPUP_COLUMNS | TRANSPORT_MODE | Trans Mode | 90 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 35 |
| POPUP_COLUMNS | BOD_ITEM_VALID | BOD Item Valid | 90 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 36 |
| POPUP_COLUMNS | DAYS_MON | Mon | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 38 |
| POPUP_COLUMNS | DAYS_TUE | Tue | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 39 |
| POPUP_COLUMNS | DAYS_WED | Wed | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 40 |
| POPUP_COLUMNS | DAYS_THU | Thu | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 41 |
| POPUP_COLUMNS | DAYS_FRI | Fri | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 42 |
| POPUP_COLUMNS | DAYS_SAT | Sat | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 43 |
| POPUP_COLUMNS | DAYS_SUN | Sun | 45 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 44 |
| POPUP_COLUMNS | LEAD_TIME | L/T(Day) | 80 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 45 |
| POPUP_COLUMNS | FROM_YYYYMMDD | From | 100 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 46 |
| POPUP_COLUMNS | TO_YYYYMMDD | To | 100 | true |  |  | meta-shape | features/supply/src/pages/bod-item/components/modals/GetBodItemModal.tsx | 47 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00025 | 1 |
| LBL00024 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00767 | 1 |
| LBL01054 | 1 |
| LBL00002 | 1 |
| LBL00007 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00108 | 1 |
| MSG00129 | 1 |
| MSG01230 | 1 |
| MSG00611 | 1 |
| MSG00002 | 1 |
| MSG00085 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0030(3), SCP0007(3), SCP0130(1), COM0013(1)
- SP/PKG: PKG_SCP0030(3), PR_GET_SHEET_COLUMN_LIST(2), PKG_NSCM_UI_COM_MENU(1), P_SCP0030_SAVE_BOD_EXCLUDED_ITEM(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Search(=setFilters 가 새 filters 객체를 만듦)마다 재조회 — 기존 useTabProcQuery(filters 참조 변경 시 조회)와 같은 규약. | features/supply/src/pages/bod-item/BodItem.tsx | 91 |
| code | 메인(BOD Item): action != 'I' 면 즉시 return하고, InsertButton(cs:247~)은 본문 전건 주석("insert 없음", | features/supply/src/pages/bod-item/BodItem.tsx | 174 |
| code | DELETE 도 Excluded 전용 — BOD Item 은 Insert 없음 → 신규행 없음 → AS-IS DeleteButton(action!='I' return)상 삭제 불가(cs:239-245). | features/supply/src/pages/bod-item/BodItem.tsx | 313 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

