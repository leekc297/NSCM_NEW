# SCM0014 — To-Be Fact Pack 요약

- page_key: `supply/validation-shipment-result` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 7 (미해결 0, 주석 속 0) · 이벤트 17 · 컴포넌트 사용 32 · 하드코딩 컬럼 0 · 메시지 10
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | component | 266 |
| features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultGrid.tsx | component | 52 |
| features/supply/src/pages/validation-shipment-result/index.ts | index | 2 |
| features/supply/src/pages/validation-shipment-result/useValidationShipmentResultStore.ts | store | 167 |
| features/supply/src/pages/validation-shipment-result/validation-shipment-result.constants.ts | constants | 65 |
| features/supply/src/pages/validation-shipment-result/validation-shipment-result.types.ts | types | 21 |
| features/supply/src/pages/validation-shipment-result/validation-shipment-result.util.ts | other | 34 |
| features/supply/src/pages/validation-shipment-result/ValidationShipmentResult.tsx | page | 154 |
| features/supply/src/pages/validation-shipment-result/__asis-mapping__.md | mapping | 59 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | ValidationShipmentResultForm.tsx:50 ValidationShipmentResultForm.tsx:54 ValidationShipmentResultForm.tsx:59 ValidationShipmentResultForm.tsx:62 |
| /admin/menu/SCM0014/search-conditions | http | 1 | Y | useValidationShipmentResultStore.ts:131 |
| /admin/menu/SCM0014/column | http | 1 | Y | useValidationShipmentResultStore.ts:152 |
| SCM0014/main//call-proc | hook | 1 | Y | ValidationShipmentResult.tsx:46 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId plantSiteId salesSiteId projectCode itemId fromYyyymmdd toYyyymmdd resultType | o_rc1 | SCM0014_GET_VALIDATION_SHIPMENT_RESULT PKG_SCM0014 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 103 |
| CustomDropdown | onChange | <arrow> str,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 119 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 144 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 164 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 194 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 195 |
| FunctionSearchIcon | onClick | onProjectSearch | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 189 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 226 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 227 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 221 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 241 |
| CustomDropdown | onChange | <arrow> set,str | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultForm.tsx | 256 |
| grid | updatedLayout | <arrow> Math.round | addHandler | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultGrid.tsx | 32 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/validation-shipment-result/components/ValidationShipmentResultGrid.tsx | 47 |
| ValidationShipmentResultForm | onSearch | handleSearch | jsx | features/supply/src/pages/validation-shipment-result/ValidationShipmentResult.tsx | 113 |
| ValidationShipmentResultForm | onProjectSearch | <arrow> setOpenProject | jsx | features/supply/src/pages/validation-shipment-result/ValidationShipmentResult.tsx | 114 |
| ValidationShipmentResultForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/validation-shipment-result/ValidationShipmentResult.tsx | 115 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 6 |
| CustomDropdown | 4 |
| InputField | 2 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ValidationShipmentResultForm | 1 |
| SubTitle | 1 |
| ValidationShipmentResultGrid | 1 |
| ProjectByDivisionModal | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00719 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00011 | 1 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL00052 | 1 |
| LBL00112 | 1 |
| LBL00013 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0007(5), SCP0085(3), SCP0025(2), SCP0039(2), COM0013(1), COM0008(1), SCM0014(1)
- SP/PKG: PKG_SCM0014(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

