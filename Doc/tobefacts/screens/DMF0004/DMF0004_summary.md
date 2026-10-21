# DMF0004 — To-Be Fact Pack 요약

- page_key: `master/sales-site` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 14 · 엔드포인트 호출 11 (미해결 0, 주석 속 0) · 이벤트 14 · 컴포넌트 사용 42 · 하드코딩 컬럼 0 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/sales-site/components/SalesSiteBucketGrid.tsx | component | 88 |
| features/master/src/pages/sales-site/components/SalesSiteCustomerGrid.tsx | component | 173 |
| features/master/src/pages/sales-site/components/SalesSiteForm.module.scss | component | 30 |
| features/master/src/pages/sales-site/components/SalesSiteForm.tsx | component | 286 |
| features/master/src/pages/sales-site/components/SalesSiteGrid.tsx | component | 168 |
| features/master/src/pages/sales-site/components/SalesSiteLocationGrid.tsx | component | 105 |
| features/master/src/pages/sales-site/index.ts | index | 2 |
| features/master/src/pages/sales-site/sales-site.constants.ts | constants | 35 |
| features/master/src/pages/sales-site/SalesSite.module.scss | style | 70 |
| features/master/src/pages/sales-site/SalesSite.tsx | page | 381 |
| features/master/src/pages/sales-site/useSalesSiteStore.ts | store | 190 |
| features/master/src/pages/sales-site/utils/sales-site.salesSiteCombo.ts | util | 145 |
| features/master/src/pages/sales-site/utils/sales-site.util.test.ts | test | 121 |
| features/master/src/pages/sales-site/utils/sales-site.util.ts | util | 246 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | SalesSiteForm.tsx:58 SalesSiteForm.tsx:90 SalesSiteForm.tsx:104 |
| DMF0004/site//call-proc | hook | 2 | Y | SalesSite.tsx:64 SalesSite.tsx:80 |
| DMF0004/customer//call-proc | hook | 2 | Y | SalesSite.tsx:72 SalesSite.tsx:86 |
| DMF0004/location//call-proc | hook | 1 | Y | SalesSite.tsx:96 |
| DMF0004/bucket//call-proc | hook | 1 | Y | SalesSite.tsx:106 |
| /admin/menu/DMF0004/column | http | 1 | Y | useSalesSiteStore.ts:130 |
| /admin/menu/DMF0004/search-conditions | http | 1 | Y | useSalesSiteStore.ts:159 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| site | divisionId endCustomer salesSite activeFlag soldToCustomer | salesSite |  |
| customer | divisionId salesSite activeFlag | salesCustomer salesLocation salesBucket |  |
| location | divisionId salesSite activeFlag | salesCustomer salesLocation salesBucket |  |
| bucket | divisionId salesSite activeFlag | salesCustomer salesLocation salesBucket |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site/components/SalesSiteBucketGrid.tsx | 83 |
| DataGrid | cellEditEnded | handleIncotermsChange | jsx | features/master/src/pages/sales-site/components/SalesSiteBucketGrid.tsx | 84 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site/components/SalesSiteCustomerGrid.tsx | 158 |
| DataGrid | cellEditEnded | handleRepYnChange | jsx | features/master/src/pages/sales-site/components/SalesSiteCustomerGrid.tsx | 159 |
| SearchArea | onSearch | <arrow> setSiteFilters,fetchStaticColumns | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 116 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams,setOpenDetailGrid | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> setSearchParams,setOpenDetailGrid | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 172 |
| CustomDropdown | onChange | <arrow> setSearchParams,setOpenDetailGrid | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 205 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 230 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 256 |
| Checkbox | onChange | <arrow> setOpenDetailGrid,setActiveTab | jsx | features/master/src/pages/sales-site/components/SalesSiteForm.tsx | 271 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site/components/SalesSiteGrid.tsx | 154 |
| DataGrid | cellEditEnded | handleAutoSalesSite | jsx | features/master/src/pages/sales-site/components/SalesSiteGrid.tsx | 155 |
| DataGrid | gotFocus | handleFocus | jsx | features/master/src/pages/sales-site/components/SalesSiteLocationGrid.tsx | 92 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 5 |
| DataGrid | 4 |
| TabItem | 3 |
| Panel | 2 |
| CustomerModal | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| Label | 1 |
| RegionModal | 1 |
| StorageLocationModal | 1 |
| MainTitle | 1 |
| SalesSiteForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| SalesSiteGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| SalesSiteCustomerGrid | 1 |
| SalesSiteLocationGrid | 1 |
| SalesSiteBucketGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00080 | 1 |
| LBL00081 | 1 |
| LBL00011 | 1 |
| LBL00007 | 1 |
| LBL00316 | 1 |
| LBL00314 | 1 |
| LBL00315 | 1 |
| LBL00032 | 1 |
| MSG00028 | 1 |
| MSG00060 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003(3), DMF0006(2), DMF0007(2), DMF0082(2), DMF0005(1), DMF0004(1)
- SP/PKG: P_DMF0004_GET_SALES_SITE_DETAIL_DATA(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

