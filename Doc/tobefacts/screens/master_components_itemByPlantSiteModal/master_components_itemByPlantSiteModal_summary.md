# master_components_itemByPlantSiteModal — To-Be Fact Pack 요약

- page_key: `master/components/itemByPlantSiteModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 17 · 하드코딩 컬럼 9 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 9건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | constants | 38 |
| features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.module.scss | style | 20 |
| features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | page | 291 |
| features/master/src/components/itemByPlantSiteModal/itemByPlantSiteModalStore.ts | store | 59 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ItemByPlantSiteModal.tsx:79 |
| COM0014/itemByPlantSite//call-proc | hook | 1 | Y | ItemByPlantSiteModal.tsx:93 |
| /admin/menu/COM0014/column | http | 1 | Y | itemByPlantSiteModalStore.ts:36 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 201 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 240 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 241 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 276 |
| Button | onClick | modalClose | jsx | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 283 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| ITEM_BY_PLANT_SITE_COLUMNS | DIVISION_ID | Div | 80 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 29 |
| ITEM_BY_PLANT_SITE_COLUMNS | SCM_SITE_ID | SCM Site | 100 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 30 |
| ITEM_BY_PLANT_SITE_COLUMNS | SITE_DESCRIPTION | Site | 130 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 31 |
| ITEM_BY_PLANT_SITE_COLUMNS | ITEM_ID | Model Code | 110 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 32 |
| ITEM_BY_PLANT_SITE_COLUMNS | ITEM_NAME | Model | 140 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 33 |
| ITEM_BY_PLANT_SITE_COLUMNS | ITEM_TYPE | Type | 50 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 34 |
| ITEM_BY_PLANT_SITE_COLUMNS | NICK_NAME | Nick Name | 120 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 35 |
| ITEM_BY_PLANT_SITE_COLUMNS | ITEM_CLASS_NAME | Class Name | 120 |  |  |  | meta-shape | features/master/src/components/itemByPlantSiteModal/item-by-plant-site-modal.constants.ts | 36 |
| fallback | col.colNm | col.colLblNm | col.colWth | true |  |  | meta-map | features/master/src/components/itemByPlantSiteModal/ItemByPlantSiteModal.tsx | 111 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00015 | 1 |
| LBL01142 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0008(4), COM0014(4), COM0013(2), SCP0036(2), SCP0037(2), SSP0100(2), COM0012(1)
- SP/PKG: P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP(1), SCM0001_GET_DIVISION(1), SCM0001_GET_FROM_SITE_BY_DIVISION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

