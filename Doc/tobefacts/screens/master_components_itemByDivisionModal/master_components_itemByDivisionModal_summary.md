# master_components_itemByDivisionModal — To-Be Fact Pack 요약

- page_key: `master/components/itemByDivisionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 4 (미해결 1, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 29 · 하드코딩 컬럼 1 · 메시지 11
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/itemByDivisionModal/item-by-division-modal.constants.ts | constants | 94 |
| features/master/src/components/itemByDivisionModal/ItemByDivisionModal.module.scss | style | 19 |
| features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | page | 654 |
| features/master/src/components/itemByDivisionModal/itemByDivisionModalStore.ts | store | 47 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ItemByDivisionModal.tsx:168 ItemByDivisionModal.tsx:199 |
| COM0008/{?sheetName}//call-proc | hook | 1 | N | ItemByDivisionModal.tsx:255 |
| /admin/menu/COM0008/column | http | 1 | Y | itemByDivisionModalStore.ts:31 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 458 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 576 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 577 |
| CustomDropdown | onChange | <arrow> setSelectedItemType | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 593 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 639 |
| Button | onClick | modalClose | jsx | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 646 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 5 |
| InputField | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | entry.colLblNm | entry.colWth | true |  |  | meta-map | features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx | 308 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 2 |
| LBL00343 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00012 | 1 |
| LBL00618 | 1 |
| LBL00068 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0008(7), SCP0048(3), DMF0020(3), DMF0005(2), DMF0008(2), DMF0010(1), DMF0006(1), COM0013(1), DMF0021(1), DMF0042(1), DMF0072(1), DMF0082(1)
- SP/PKG: P_MENU_ID(1), P_ITEM_TYPE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

