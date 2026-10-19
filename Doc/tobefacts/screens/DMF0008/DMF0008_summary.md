# DMF0008 — To-Be Fact Pack 요약

- page_key: `master/erp-edi-master` · feature: master · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 10 (미해결 1, 주석 속 0) · 이벤트 16 · 컴포넌트 사용 42 · 하드코딩 컬럼 0 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterForm.module.scss | component | 21 |
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterForm.tsx | component | 93 |
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterRepairGrid.tsx | component | 104 |
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx | component | 230 |
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterSspmGrid.tsx | component | 231 |
| features/master/src/pages/erp-edi-master/components/ErpEdiMasterSummaryGrid.tsx | component | 71 |
| features/master/src/pages/erp-edi-master/erp-edi-master.constants.ts | constants | 66 |
| features/master/src/pages/erp-edi-master/erp-edi-master.empty-rows.ts | other | 105 |
| features/master/src/pages/erp-edi-master/erp-edi-master.types.ts | types | 15 |
| features/master/src/pages/erp-edi-master/erp-edi-master.utils.ts | other | 80 |
| features/master/src/pages/erp-edi-master/ErpEdiMaster.module.scss | style | 208 |
| features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | page | 677 |
| features/master/src/pages/erp-edi-master/index.ts | index | 2 |
| features/master/src/pages/erp-edi-master/useErpEdiMasterStore.ts | store | 346 |
| features/master/src/pages/erp-edi-master/__asis-mapping__.md | mapping | 161 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ErpEdiMasterForm.tsx:28 |
| DMF0008/summary//call-proc | hook | 1 | Y | ErpEdiMaster.tsx:133 |
| DMF0008/repair//call-proc | hook | 1 | Y | ErpEdiMaster.tsx:141 |
| DMF0008/salesSite//call-proc | hook | 1 | Y | ErpEdiMaster.tsx:153 |
| DMF0008/sspm//call-proc | hook | 1 | Y | ErpEdiMaster.tsx:165 |
| DMF0008/updateHistory//call-proc | hook | 1 | Y | ErpEdiMaster.tsx:175 |
| /DMF0008/main/STATUS_UPDATE/call-proc | http | 1 | Y | ErpEdiMaster.tsx:241 |
| /DMF0008/{route}/SAVE/call-proc | http | 1 | N | ErpEdiMaster.tsx:457 |
| /admin/menu/DMF0008/column | http | 1 | Y | useErpEdiMasterStore.ts:295 |
| /admin/menu/DMF0008/search-conditions | http | 1 | Y | useErpEdiMasterStore.ts:319 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| summary | divisionId fromYyyymmdd toYyyymmdd sesUserId menuId | o_rc1 |  |
| repair | divisionId senderName flag fromYyyymmdd toYyyymmdd sesUserId menuId | o_rc1 |  |
| salesSite | divisionId soldTo shipTo scmSiteId sesUserId menuId | o_rc1 O_RESULT_CURSOR |  |
| sspm | divisionId itemId scmSiteId sesUserId menuId | o_rc1 |  |
| spreadTitle | programId sheetName divisionId startYyyymmdd endYyyymmdd sesUserId menuId | o_rc1 |  |
| updateHistory | sesUserId menuId | o_rc1 |  |
| main | divisionId fromYyyymmdd toYyyymmdd sesUserId menuId | o_rc1 | PKG_DMF0008 P_DMF0008_GET_EDI_MST_SUMMARY |
| division | sesUserId menuId | o_rc1 | PKG_DMF0008 P_DMF0008_GET_MY_DIVISION_LIST |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | <arrow> clearAllGrids,setSummaryFilters,fetchStaticColumns | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterForm.tsx | 36 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams,clearAllGrids,fetchStaticColumns | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterForm.tsx | 53 |
| DataGrid | formatItem | handleFormatItem | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterRepairGrid.tsx | 99 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx | 97 |
| grid | pastingCell | handleBeginningEdit | addHandler | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx | 99 |
| DataGrid | formatItem | handleFormatItem | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx | 208 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSalesSiteGrid.tsx | 209 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSspmGrid.tsx | 85 |
| grid | pastingCell | handleBeginningEdit | addHandler | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSspmGrid.tsx | 87 |
| DataGrid | formatItem | handleFormatItem | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSspmGrid.tsx | 169 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/master/src/pages/erp-edi-master/components/ErpEdiMasterSspmGrid.tsx | 170 |
| div | onClickCapture | <arrow> setFocusedSheet | jsx | features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | 590 |
| ErpEdiMasterSummaryGrid | onDblClick | handleSummaryDoubleClick | jsx | features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | 602 |
| div | onClickCapture | <arrow> setFocusedSheet | jsx | features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | 612 |
| ErpEdiMasterRepairGrid | onDblClick | handleRepairDoubleClick | jsx | features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | 631 |
| div | onClickCapture | <arrow> setFocusedSheet | jsx | features/master/src/pages/erp-edi-master/ErpEdiMaster.tsx | 644 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Stack | 4 |
| DataGrid | 4 |
| Panel | 4 |
| Label | 3 |
| Typography | 3 |
| Grid | 2 |
| PanelGroup | 2 |
| PanelSeparator | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |
| CustomerModal | 1 |
| TeamModal | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| OwnerByDivisionModal | 1 |
| MainTitle | 1 |
| ErpEdiMasterForm | 1 |
| SubTitle | 1 |
| ErpEdiMasterSummaryGrid | 1 |
| ErpEdiMasterRepairGrid | 1 |
| TabWrapper | 1 |
| ErpEdiMasterSalesSiteGrid | 1 |
| ErpEdiMasterSspmGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00612 | 1 |
| LBL00613 | 1 |
| LBL01155 | 1 |
| MSG00445 | 2 |
| MSG00446 | 2 |
| MSG00060 | 1 |
| MSG00605 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00096 | 1 |
| MSG00113 | 1 |
| MSG00618 | 3 |
| MSG00606 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0004(6), DMF0008(2)
- SP/PKG: DMF0000_GET_UPDATE_HISTORY(4), DMF0008_GET_SALES_SITE(3), DMF0008_GET_EDI_MST_SUMMARY(2), DMF0008_GET_EDI_MST_REPAIR(2), DMF0008_GET_SALES_SITE_PROJECT_MODEL(1), P_MESSAGE_CURSOR(1), DMF0008_SAVE_SALES_SITE_EDI_REPAIR(1), DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR(1), PR_DM_DNM_EDI_CALLOFF_STATUS(1), P_DMF0008_GET_EDI_MST_REPAIR(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | const object — enum 대체 (NSCM 단일 cursor 표준 'o_rc1' 다수 중복 허용) | features/master/src/pages/erp-edi-master/erp-edi-master.constants.ts | 21 |
| jsx | DMF0004 표준 명칭 (Form 호출). Partial<SearchCondition> 받음 | features/master/src/pages/erp-edi-master/useErpEdiMasterStore.ts | 54 |
| code | fetchStaticColumns — DMF0004 표준 (useSalesSiteStore:91 fetchStaticColumns 패턴 동일). 메모리 feedback_fetchstaticcolumns_no_initialized_guard: initialized 가드는 `if (initialized) return` 이 아닌 후반부의 search-conditions restore 부분에만 적용. column meta 는 매번 f | features/master/src/pages/erp-edi-master/useErpEdiMasterStore.ts | 282 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

