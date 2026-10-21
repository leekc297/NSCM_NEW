# DMF0007 — To-Be Fact Pack 요약

- page_key: `master/customer-forecast-master` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 9 · 컴포넌트 사용 21 · 하드코딩 컬럼 4 · 메시지 7
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterFcstGrid.tsx | page | 127 |
| features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | page | 223 |
| features/master/src/pages/customer-forecast-master/customer-fcst-master.constants.ts | constants | 12 |
| features/master/src/pages/customer-forecast-master/customer-fcst-master.uniqueCheck.ts | other | 76 |
| features/master/src/pages/customer-forecast-master/CustomerFcstMaster.tsx | page | 227 |
| features/master/src/pages/customer-forecast-master/index.ts | index | 2 |
| features/master/src/pages/customer-forecast-master/useCustomerFcstMasterStore.ts | store | 121 |
| features/master/src/pages/customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts | util | 106 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | CustomerFcstMasterForm.tsx:58 CustomerFcstMaster.tsx:47 |
| DMF0007/customerFcst//call-proc | hook | 2 | Y | CustomerFcstMaster.tsx:59 CustomerFcstMaster.tsx:67 |
| /admin/menu/DMF0007/column | http | 1 | Y | useCustomerFcstMasterStore.ts:80 |
| /admin/menu/DMF0007/search-conditions | http | 1 | Y | useCustomerFcstMasterStore.ts:90 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| customerFcst | planWeek divisionId endCustomer scmSiteId bucketType validYn userId | o_rc1 | PKG_DMF0007 P_DMF0007_GET_CUST_FCST_DATA P_DMF0007_GET_CUST_PSI_DATA P_DMF0007_SAVE_CUST_FCST_DATA |
| customerPSI | planWeek divisionId endCustomer scmSiteId bucketType validYn userId | o_rc1 | PKG_DMF0007 P_DMF0007_GET_CUST_FCST_DATA P_DMF0007_GET_CUST_PSI_DATA P_DMF0007_SAVE_CUST_FCST_DATA |
| customerPsiPivot | planWeek divisionId endCustomer scmSiteId bucketType validYn userId | o_rc1 | P_DMF0007_GET_CUST_PSI_PIVOT_DATA PKG_DMF0007 P_DMF0007_GET_CUST_FCST_DATA P_DMF0007_GET_CUST_PSI_DATA P_DMF0007_SAVE_CUST_FCST_DATA |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | cellEditEnded | handleCellChange | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterFcstGrid.tsx | 121 |
| DataGrid | pastedCell | handleCellChange | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterFcstGrid.tsx | 123 |
| SearchArea | onSearch | onSubmit | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 100 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 113 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 139 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 186 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/master/src/pages/customer-forecast-master/componenets/CustomerFcstMasterForm.tsx | 209 |
| CustomerFcstMasterForm | onSubmit | handleSearch | jsx | features/master/src/pages/customer-forecast-master/CustomerFcstMaster.tsx | 207 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 5 |
| DataGrid | 1 |
| SearchArea | 1 |
| MainTitle | 1 |
| CustomerFcstMasterForm | 1 |
| SubTitle | 1 |
| CustomerFcstMasterFcstGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| defaultLowerColumnProps |  |  | 70 | true |  |  | object | features/master/src/pages/customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts | 14 |
| columns | `D_${startDate.format('YYYYMMDD')}` | startDate.format('M/D') |  |  |  |  | object | features/master/src/pages/customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts | 55 |
| columns | `D_${startDate.startOf('isoWeek').format('YYYYMMDD')}` | startDate.startOf('isoWeek').format('M/D') |  |  |  |  | object | features/master/src/pages/customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts | 74 |
| columns | `D_${startDate.startOf('month').format('YYYYMMDD')}` | startDate.startOf('month').format('M/D') |  |  |  |  | object | features/master/src/pages/customer-forecast-master/utils/CustomerFcstMasterDateColumns.ts | 93 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00136 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00032 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00007 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0007(2), DMF0006(1)
- SP/PKG: PKG_DMF0007(1), P_DMF0007_GET_CUST_FCST_DATA(1), P_PLAN_WEEK(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 가드(if (searchParams.divisionId) return)에 걸려 자동선택이 발화하지 않고, '81' 권한이 없는 | features/master/src/pages/customer-forecast-master/useCustomerFcstMasterStore.ts | 39 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

