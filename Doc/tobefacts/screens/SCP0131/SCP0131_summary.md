# SCP0131 — To-Be Fact Pack 요약

- page_key: `supply/sales-site-priority` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 7 (미해결 0, 주석 속 3) · 이벤트 19 · 컴포넌트 사용 27 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | component | 247 |
| features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | component | 333 |
| features/supply/src/pages/sales-site-priority/hooks/useSalesSitePriorityValidation.ts | hook | 97 |
| features/supply/src/pages/sales-site-priority/index.ts | index | 2 |
| features/supply/src/pages/sales-site-priority/sales-site-priority.constants.ts | constants | 114 |
| features/supply/src/pages/sales-site-priority/sales-site-priority.types.ts | types | 25 |
| features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | page | 212 |
| features/supply/src/pages/sales-site-priority/useSalesSitePriorityStore.ts | store | 201 |
| features/supply/src/pages/sales-site-priority/utils/sales-site-priority.cascadeCombo.ts | util | 98 |
| features/supply/src/pages/sales-site-priority/utils/sales-site-priority.editLock.ts | util | 54 |
| features/supply/src/pages/sales-site-priority/utils/salesSitePriority.saveRequest.ts | util | 134 |
| features/supply/src/pages/sales-site-priority/__asis-mapping__.md | mapping | 104 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | SalesSitePriorityForm.tsx:67 SalesSitePriorityGrid.tsx:49 SalesSitePriorityGrid.tsx:67 |
| SCP0131/main//call-proc | hook | 1 | Y | SalesSitePriority.tsx:62 |
| /admin/menu/SCP0131/search-conditions | http | 1 | Y | useSalesSitePriorityStore.ts:93 |
| /admin/menu/SCP0131/column | http | 1 | Y | useSalesSitePriorityStore.ts:179 |
| /SCP0131/main/SAVE/call-proc | http | 1 | Y | salesSitePriority.saveRequest.ts:124 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 96 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 112 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 141 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 161 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 194 |
| Button | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 190 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 206 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityForm.tsx | 221 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 105 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 114 |
| g | updatedLayout | applyLayoutFixes | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 150 |
| el | input | sanitizePrioInput | addEventListener | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 222 |
| g | prepareCellForEdit | prepareEditHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 224 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 242 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 267 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 278 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/sales-site-priority/components/SalesSitePriorityGrid.tsx | 308 |
| SalesSitePriorityForm | onSearch | handleSearch | jsx | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 190 |
| SalesSitePriorityGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 207 |

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
| MSG01230 | 1 |
| MSG01190 | 1 |
| MSG01036 | 1 |
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
| MSG00003 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0131(10), SCP0037(5), SCP0128(3), COM0013(3), SCP0127(3), SCP0133(3), SCP0018(2), SCP0013(1), SCP0028(1), SCP0126(1)
- SP/PKG: PKG_SCP0131(5), SCP0131_GET_SALES_SITE_PRIORITY(2), SCP0128_GET_SEARCH_INFO(2), P_SCP0131_SAVE_SALES_SITE_PRIORITY(2), SCP0131_SAVE_SALES_SITE_PRIORITY(1), PKG_SCP0128(1), FN_ASIS_SORT_KEY(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 무효화로 활성 조회를 재조회한다. 공용 useProcMutation({data:[rows]}) 은 이 SAVE SP 계약(전 | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 88 |
| code | 기준 division 이 없으면(미선택/다중) 알림 없이 return 한다. Division 은 진입 시 첫 값 자동선택 | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 136 |
| code | 삭제(design 01 §2#3 buttonGuards#1): `fps==null` early-return 재현 — 메시지 없이 조용히 무시. | features/supply/src/pages/sales-site-priority/SalesSitePriority.tsx | 147 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 14행 등록됨, design 03 §1). | features/supply/src/pages/sales-site-priority/useSalesSitePriorityStore.ts | 23 |
| endpoint | 왜 공용 useProcMutation({data:[rows]}) 가 아닌가: PKG_SCP0131.P_SCP0131_SAVE_SALES_SITE_PRIORITY | features/supply/src/pages/sales-site-priority/utils/salesSitePriority.saveRequest.ts | 5 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

