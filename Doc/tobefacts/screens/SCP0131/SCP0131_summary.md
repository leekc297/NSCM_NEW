# SCP0131 — To-Be Fact Pack 요약

- page_key: `supply/sales-site-priority` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 6 (미해결 0, 주석 속 1) · 이벤트 15 · 컴포넌트 사용 27 · 하드코딩 컬럼 0 · 메시지 14
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | component | 239 |
| features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | component | 139 |
| features/supply/src/pages/sales-site-priority/hooks/useSalesSitePriorityValidation.ts | hook | 79 |
| features/supply/src/pages/sales-site-priority/index.ts | index | 2 |
| features/supply/src/pages/sales-site-priority/sales-site-priority.constants.ts | constants | 109 |
| features/supply/src/pages/sales-site-priority/sales-site-priority.types.ts | types | 25 |
| features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | page | 182 |
| features/supply/src/pages/sales-site-priority/useSalesSitePriorityStore.ts | store | 182 |
| features/supply/src/pages/sales-site-priority/utils/sales-site-priority.cascadeCombo.ts | util | 66 |
| features/supply/src/pages/sales-site-priority/utils/sales-site-priority.editLock.ts | util | 54 |
| features/supply/src/pages/sales-site-priority/__asis-mapping__.md | mapping | 104 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | SalesSitePriorityForm.tsx:72 SalesSitePriorityGrid.tsx:43 |
| SCP0131/main//call-proc | hook | 2 | Y | SalesSitePriority.tsx:50 SalesSitePriority.tsx:57 |
| /admin/menu/SCP0131/search-conditions | http | 1 | Y | useSalesSitePriorityStore.ts:86 |
| /admin/menu/SCP0131/column | http | 1 | Y | useSalesSitePriorityStore.ts:160 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 94 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 109 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 138 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 158 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 189 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 190 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 183 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 202 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 215 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 60 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 78 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 89 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 114 |
| SalesSitePriorityForm | onSearch | handleSearch | jsx | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 160 |
| SalesSitePriorityGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 177 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 5 |
| CustomDropdown | 4 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| SalesSitePriorityForm | 1 |
| SubTitle | 1 |
| SalesSitePriorityGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00013 | 1 |
| MSG00001 | 1 |
| MSG01135 | 1 |
| MSG00699 | 1 |
| MSG01366 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG01122 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00015 | 1 |
| LBL00013 | 1 |
| LBL00639 | 1 |
| LBL00112 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0131(10), SCP0037(3), SCP0128(1), SCP0020(1), SCP0028(1)
- SP/PKG: SCP0131_GET_SALES_SITE_PRIORITY(2), PKG_SCP0131(2), SCP0131_SAVE_SALES_SITE_PRIORITY(1), SCP0128_GET_SEARCH_INFO(1), PKG_SCP0128(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시. | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 115 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 14행 등록됨, design 03 §1). | features/supply/src/pages/sales-site-priority/useSalesSitePriorityStore.ts | 23 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

