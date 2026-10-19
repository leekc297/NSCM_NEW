# SCP0130 — To-Be Fact Pack 요약

- page_key: `supply/scheduled-receipt-information` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 9 (미해결 0, 주석 속 2) · 이벤트 21 · 컴포넌트 사용 36 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | component | 212 |
| features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | component | 129 |
| features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | component | 174 |
| features/supply/src/pages/scheduled-receipt-information/index.ts | index | 2 |
| features/supply/src/pages/scheduled-receipt-information/scheduled-receipt-information.constants.ts | constants | 95 |
| features/supply/src/pages/scheduled-receipt-information/scheduled-receipt-information.types.ts | types | 40 |
| features/supply/src/pages/scheduled-receipt-information/ScheduledReceiptInformation.tsx | page | 311 |
| features/supply/src/pages/scheduled-receipt-information/useScheduledReceiptInformationStore.ts | store | 164 |
| features/supply/src/pages/scheduled-receipt-information/utils/scheduledReceiptInformationDate.ts | util | 12 |
| features/supply/src/pages/scheduled-receipt-information/utils/scheduledReceiptInformationEditLock.ts | util | 59 |
| features/supply/src/pages/scheduled-receipt-information/utils/scheduledReceiptInformationSaveValidation.ts | util | 80 |
| features/supply/src/pages/scheduled-receipt-information/__asis-mapping__.md | mapping | 165 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | ScheduledReceiptInformationForm.tsx:48 ScheduledReceiptInformationForm.tsx:49 ScheduledReceiptInformation.tsx:102 |
| SCP0130/virtualBom//call-proc | hook | 2 | Y | ScheduledReceiptInformation.tsx:113 ScheduledReceiptInformation.tsx:128 |
| SCP0130/scheduledReceipt//call-proc | hook | 2 | Y | ScheduledReceiptInformation.tsx:120 ScheduledReceiptInformation.tsx:133 |
| /admin/menu/SCP0130/column | http | 1 | Y | useScheduledReceiptInformationStore.ts:116 |
| /admin/menu/SCP0130/search-conditions | http | 1 | Y | useScheduledReceiptInformationStore.ts:144 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| virtualBom | divisionId planGroupId siteId itemIdChild validYn fromDate itemId | o_rc1 | SCP0130_GET_VIRTUAL_BOM SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION SCP0130_SAVE_SCHEDULED_RECIEPT_ PKG_SCP0130 |
| scheduledReceipt | divisionId planGroupId siteId itemIdChild validYn fromDate itemId | o_rc1 | SCP0130_GET_VIRTUAL_BOM SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION SCP0130_SAVE_SCHEDULED_RECIEPT_ PKG_SCP0130 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 66 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 83 |
| CustomDropdown | onChange | <arrow>  | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 101 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 129 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 123 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 143 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 164 |
| CustomDropdown | onChange | <arrow>  | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 176 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationForm.tsx | 191 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | 60 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | 61 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | 75 |
| g | pastedCell | pastedPlanGroupHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | 103 |
| DataGrid | gotFocus | <arrow> onFocus | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationMainGrid.tsx | 125 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 75 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 76 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 88 |
| g | pastedCell | pastedPlanGroupHandler | addHandler | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 115 |
| DataGrid | gotFocus | <arrow> onFocus | jsx | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 154 |
| ScheduledReceiptInformationVirtualBomGrid | onFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/scheduled-receipt-information/ScheduledReceiptInformation.tsx | 292 |
| ScheduledReceiptInformationMainGrid | onFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/scheduled-receipt-information/ScheduledReceiptInformation.tsx | 304 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 5 |
| MaterialByDivisionModal | 2 |
| DataGrid | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DatePickerCalendar | 1 |
| MainTitle | 1 |
| ScheduledReceiptInformationForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| ScheduledReceiptInformationVirtualBomGrid | 1 |
| ScheduledReceiptInformationMainGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| MSG00013 | 1 |
| MSG00046 | 1 |
| MSG00085 | 1 |
| MSG00050 | 1 |
| MSG00165 | 1 |
| MSG00260 | 1 |
| MSG00004 | 1 |
| MSG00129 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00015 | 1 |
| LBL01062 | 1 |
| LBL00639 | 1 |
| LBL00062 | 1 |
| LBL01142 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0130(7), SCP0053(2), SCP0128(2), SCP0025(1), SCP0122(1), SCP0127(1)
- SP/PKG: PKG_SCP0130(2), SCP0130_GET_VIRTUAL_BOM(1), SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Virtual Bom 시트 그리드 — design/03_grid-columns.md §1.2/§3 white-list 재현. ITEM_ID 셀 더블클릭 → 품목 팝업(`MaterialByDivisionModal`, design/02_search-combo.md §4.6 확정 재사용, gridSignals#21 SetText 재현) — buttonGuards#4/#5(헤더 더블클릭 제외 / 잠금 또는 비편집모드&&비신규행 시 팝 | features/supply/src/pages/scheduled-receipt-information/components/ScheduledReceiptInformationVirtualBomGrid.tsx | 34 |
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0130/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 가 문자열 그대로 매칭). DB 실측(design/03_grid-columns.md §1) 값을 그대로 쓴다 — 코드 키(SHEETS)와 분리(formation.constants.ts 선례와 동일 패턴). | features/supply/src/pages/scheduled-receipt-information/scheduled-receipt-information.constants.ts | 27 |
| code | buttonGuards#1 — fps==null(선택 행 없음) 시 무동작 return(design/01_layout.md §2 #3, | features/supply/src/pages/scheduled-receipt-information/ScheduledReceiptInformation.tsx | 175 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

