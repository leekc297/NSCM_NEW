# SCP0001 — To-Be Fact Pack 요약

- page_key: `supply/plant-site` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 21 · 엔드포인트 호출 22 (미해결 0, 주석 속 1) · 이벤트 52 · 컴포넌트 사용 86 · 하드코딩 컬럼 0 · 메시지 33
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | component | 204 |
| features/supply/src/pages/plant-site/components/modals/cityByCountryModalStore.ts | store | 32 |
| features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | component | 229 |
| features/supply/src/pages/plant-site/components/modals/customerModalStore.ts | store | 34 |
| features/supply/src/pages/plant-site/components/modals/PlantSiteModal.module.scss | component | 21 |
| features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | component | 230 |
| features/supply/src/pages/plant-site/components/modals/vendorModalStore.ts | store | 33 |
| features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | component | 194 |
| features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | component | 161 |
| features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | component | 370 |
| features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | component | 202 |
| features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | component | 128 |
| features/supply/src/pages/plant-site/index.ts | index | 2 |
| features/supply/src/pages/plant-site/plant-site.constants.ts | constants | 100 |
| features/supply/src/pages/plant-site/PlantSite.module.scss | style | 16 |
| features/supply/src/pages/plant-site/PlantSite.tsx | page | 434 |
| features/supply/src/pages/plant-site/usePlantSiteStore.ts | store | 213 |
| features/supply/src/pages/plant-site/utils/plant-site.cityLookup.ts | util | 51 |
| features/supply/src/pages/plant-site/utils/plant-site.plantSiteCombo.ts | util | 42 |
| features/supply/src/pages/plant-site/utils/plant-site.util.ts | util | 166 |
| features/supply/src/pages/plant-site/__asis-mapping__.md | mapping | 130 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| COM0002/customer//call-proc | hook | 2 | Y | CityByCountryModal.tsx:56 CustomerModal.tsx:66 |
| /admin/menu/COM0002/column | http | 2 | Y | cityByCountryModalStore.ts:22 customerModalStore.ts:24 |
| (useTabComboQueries) | hook | 5 | Y | VendorModal.tsx:58 PlantSiteForm.tsx:29 PlantSiteGrid.tsx:57 PlantSiteLocationGrid.tsx:53 PlantSite.tsx:74 |
| SCP0001/vendor//call-proc | hook | 1 | Y | VendorModal.tsx:65 |
| /admin/menu/SCP0001/column | http | 2 | Y | vendorModalStore.ts:23 usePlantSiteStore.ts:171 |
| SCP0001/site//call-proc | hook | 2 | Y | PlantSite.tsx:80 PlantSite.tsx:109 |
| SCP0001/location//call-proc | hook | 2 | Y | PlantSite.tsx:87 PlantSite.tsx:114 |
| SCP0001/customer//call-proc | hook | 2 | Y | PlantSite.tsx:94 PlantSite.tsx:119 |
| SCP0001/locationOsp//call-proc | hook | 2 | Y | PlantSite.tsx:101 PlantSite.tsx:124 |
| /admin/menu/SCP0001/search-conditions | http | 1 | Y | usePlantSiteStore.ts:189 |
| COM0001/region/SEARCH/call-proc | http | 1 | Y | plant-site.cityLookup.ts:33 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| site | divisionId plantId scmSiteId ospYn validYn newYn | o_rc1 save | PKG_SCP0001 P_SCP0001_GET_ P_SCP0001_SAVE_ P_DATA |
| location | divisionId scmSiteId validYn | o_rc1 save | PKG_SCP0001 P_SCP0001_GET_ P_SCP0001_SAVE_ P_DATA |
| customer | divisionId scmSiteId activeFlag createdBy userGroup | o_rc1 save | PKG_SCP0001 P_SCP0001_GET_ P_SCP0001_SAVE_ P_DATA |
| locationOsp | divisionId scmSiteId validYn | o_rc1 save | PKG_SCP0001 P_SCP0001_GET_ P_SCP0001_SAVE_ P_DATA |
| vendor | vendorCode vendorName paker | o_rc1 | PKG_SCM0002 P_SCM0002_GET_VENDOR_POPUP PKG_SCP0001 P_SCP0001_GET_ P_SCP0001_SAVE_ P_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 129 |
| InputField | onChange | <arrow> setCountryInput | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 140 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 141 |
| InputField | onChange | <arrow> setCityInput | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 154 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 155 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 189 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/plant-site/components/modals/CityByCountryModal.tsx | 196 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 147 |
| InputField | onChange | <arrow> setSoldToInput | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 165 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 166 |
| InputField | onChange | <arrow> setShipToInput | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 179 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 180 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 214 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/plant-site/components/modals/CustomerModal.tsx | 221 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 139 |
| InputField | onChange | <arrow> setCodeInput | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 150 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 151 |
| InputField | onChange | <arrow> setNameInput | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 164 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 165 |
| CustomDropdown | onChange | <arrow> setPakerInput,str | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 181 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 215 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/plant-site/components/modals/VendorModal.tsx | 222 |
| grid | beginningEdit | editHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | 118 |
| grid | pastingCell | pasteHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | 119 |
| grid | formatItem | formatHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | 120 |
| DataGrid | gotFocus | handleFocus | jsx | features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | 179 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteCustomerGrid.tsx | 180 |
| SearchArea | onSearch | runSearch | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 68 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 85 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 100 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 115 |
| CustomDropdown | onChange | <arrow> setSearchParams,str | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 133 |
| CustomDropdown | onChange | <arrow> setSearchParams,str | jsx | features/supply/src/pages/plant-site/components/PlantSiteForm.tsx | 151 |
| grid | updatedLayout | attach | addHandler | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 122 |
| grid | updatedLayout | attach | addHandler | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 165 |
| grid | beginningEdit | editHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 229 |
| grid | pastingCell | editHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 230 |
| grid | formatItem | formatHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 231 |
| DataGrid | gotFocus | handleFocus | jsx | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 349 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 350 |
| DataGrid | pastedCell | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteGrid.tsx | 351 |
| grid | beginningEdit | handler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | 108 |
| grid | pastingCell | pasteHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | 109 |
| DataGrid | gotFocus | handleFocus | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | 196 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | 197 |
| DataGrid | pastedCell | handlePaste | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationGrid.tsx | 198 |
| grid | beginningEdit | editHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 92 |
| grid | pastingCell | pasteHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 93 |
| grid | formatItem | formatHandler | addHandler | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 94 |
| DataGrid | gotFocus | handleFocus | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 122 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 123 |
| DataGrid | pastedCell | handleCellEdit | jsx | features/supply/src/pages/plant-site/components/PlantSiteLocationOspGrid.tsx | 124 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 13 |
| FormItem | 13 |
| InputField | 9 |
| DataGrid | 7 |
| Button | 6 |
| SearchArea | 4 |
| CustomDropdown | 4 |
| CustomDialog | 3 |
| ProgressIndicator | 3 |
| ResultArea | 3 |
| ControlConfirmIcon | 3 |
| TabItem | 3 |
| Panel | 2 |
| CustomerModal | 1 |
| VendorModal | 1 |
| CityByCountryModal | 1 |
| MainTitle | 1 |
| PlantSiteForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PlantSiteGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| PlantSiteLocationGrid | 1 |
| PlantSiteCustomerGrid | 1 |
| PlantSiteLocationOspGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00004 | 1 |
| LBL00005 | 1 |
| LBL00006 | 1 |
| LBL00007 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL01147 | 1 |
| LBL00643 | 1 |
| LBL01148 | 1 |
| LBL01094 | 1 |
| LBL01162 | 1 |
| LBL01161 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| LBL00674 | 1 |
| LBL00317 | 1 |
| LBL00318 | 1 |
| LBL00081 | 1 |
| LBL00320 | 1 |
| LBL00337 | 1 |
| LBL00332 | 1 |
| MSG00096 | 1 |
| MSG00014 | 1 |
| MSG00129 | 1 |
| MSG01468 | 1 |
| MSG01183 | 1 |
| MSG01235 | 1 |
| MSG00028 | 1 |
| MSG01144 | 1 |
| MSG00060 | 1 |
| MSG00614 | 1 |
| MSG01079 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0001(9), SCP0005(7), COM0001(3), COM0002(3), SCM0002(1)
- SP/PKG: PKG_COM0000(2), PKG_SCM0002(2), P_SCM0002_GET_VENDOR_POPUP(2), P_COM0001_GET_CITY_BY_COUNTRY_POPUP(1), P_COM0002_GET_CUSTOMER_BY_DIVISION_POPUP(1), PKG_SCP0001(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 4시트 fetch(mount + Search refetch — CLAUDE.md §2 체크 3, PIVOT 아님 → measure 불요). | features/supply/src/pages/plant-site/usePlantSiteStore.ts | 168 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

