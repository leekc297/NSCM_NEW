# DMF0044 — To-Be Fact Pack 요약

- page_key: `demand/sales-reports` · feature: demand · As-is Fact Pack 있음
- 파일 31 · 엔드포인트 호출 35 (미해결 1, 주석 속 2) · 이벤트 47 · 컴포넌트 사용 45 · 하드코딩 컬럼 5 · 메시지 34
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 5건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.module.scss | component | 39 |
| features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | component | 936 |
| features/demand/src/pages/sales-reports/components/modals/exchangeRateModalStore.ts | store | 32 |
| features/demand/src/pages/sales-reports/components/modals/index.ts | index | 3 |
| features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx | component | 204 |
| features/demand/src/pages/sales-reports/components/modals/textboxModalStore.ts | store | 23 |
| features/demand/src/pages/sales-reports/components/SalesReportsForm.module.scss | component | 193 |
| features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | component | 165 |
| features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | component | 824 |
| features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx | component | 241 |
| features/demand/src/pages/sales-reports/index.ts | index | 2 |
| features/demand/src/pages/sales-reports/sales-reports.constants.ts | constants | 106 |
| features/demand/src/pages/sales-reports/sales-reports.types.ts | types | 48 |
| features/demand/src/pages/sales-reports/SalesReports.module.scss | style | 148 |
| features/demand/src/pages/sales-reports/SalesReports.tsx | page | 754 |
| features/demand/src/pages/sales-reports/useSalesReportsStore.test.tsx | test | 182 |
| features/demand/src/pages/sales-reports/useSalesReportsStore.ts | store | 354 |
| features/demand/src/pages/sales-reports/utils/sales-reports.api.test.ts | test | 111 |
| features/demand/src/pages/sales-reports/utils/sales-reports.api.ts | api | 99 |
| features/demand/src/pages/sales-reports/utils/sales-reports.division.test.ts | test | 22 |
| features/demand/src/pages/sales-reports/utils/sales-reports.division.ts | util | 8 |
| features/demand/src/pages/sales-reports/utils/sales-reports.editLock.test.ts | test | 182 |
| features/demand/src/pages/sales-reports/utils/sales-reports.editLock.ts | util | 115 |
| features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.test.ts | test | 111 |
| features/demand/src/pages/sales-reports/utils/sales-reports.gridCombos.ts | util | 209 |
| features/demand/src/pages/sales-reports/utils/sales-reports.merge.ts | util | 287 |
| features/demand/src/pages/sales-reports/utils/sales-reports.save.test.ts | test | 154 |
| features/demand/src/pages/sales-reports/utils/sales-reports.save.ts | util | 262 |
| features/demand/src/pages/sales-reports/utils/sales-reports.validate.test.ts | test | 60 |
| features/demand/src/pages/sales-reports/utils/sales-reports.validate.ts | util | 23 |
| features/demand/src/pages/sales-reports/__asis-mapping__.md | mapping | 364 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| DMF0044/exchangeRate//call-proc | hook | 1 | Y | ExchangeRateModal.tsx:206 |
| DMF0044/exchangeRate/SEARCH_DATA/call-proc | hook | 1 | Y | ExchangeRateModal.tsx:220 |
| DMF0044/exchangeRate/TITLE/call-proc | hook | 1 | Y | ExchangeRateModal.tsx:234 |
| /admin/menu/DMF0044/column | http | 2 | Y | ExchangeRateModal.tsx:334 useSalesReportsStore.ts:291 |
| DMF0044/textbox//call-proc | hook | 1 | Y | TextboxModal.tsx:48 |
| (useTabComboQueries) | hook | 4 | Y | SalesReportsForm.tsx:50 SalesReportsGrid.tsx:151 SalesReportsGrid.tsx:201 SalesReports.tsx:73 |
| DMF0044/MDF Reports//call-proc | hook | 1 | Y | SalesReports.tsx:97 |
| DMF0044/spreadTitle//call-proc | hook | 1 | Y | SalesReports.tsx:106 |
| DMF0044/measure//call-proc | hook | 1 | Y | SalesReports.tsx:121 |
| /admin/menu/DMF0044/search-conditions | http | 1 | Y | useSalesReportsStore.ts:200 |
| /admin/menu/DMF0044/measure | http | 1 | Y | useSalesReportsStore.ts:309 |
| DMF0044/MDF Reports/SAVE/call-proc | callProc | 6 | Y | sales-reports.api.test.ts:20 sales-reports.api.test.ts:26 sales-reports.api.test.ts:32 sales-reports.api.test.ts:41 sales-reports.api.test.ts:47 sales-reports.api.ts:85 |
| /DMF0044/titleSet/SAVE/call-proc | http | 1 | Y | sales-reports.api.ts:25 |
| /DMF0044/{sheet}/{btnCd}/call-proc | http | 1 | N | sales-reports.api.ts:69 |
| DMF0044/MDF Reports/SAVE_CF/call-proc | callProc | 1 | Y | sales-reports.api.ts:87 |
| DMF0044/exchangeRate/SAVE/call-proc | callProc | 1 | Y | sales-reports.api.ts:93 |
| DMF0044/textbox/SAVE/call-proc | callProc | 1 | Y | sales-reports.api.ts:98 |
| /DMF0044/MDF Reports/SAVE/call-proc | propagated | 6 | Y | sales-reports.api.test.ts:20 sales-reports.api.test.ts:26 sales-reports.api.test.ts:32 sales-reports.api.test.ts:41 sales-reports.api.test.ts:47 sales-reports.api.ts:85 |
| /DMF0044/MDF Reports/SAVE_CF/call-proc | propagated | 1 | Y | sales-reports.api.ts:87 |
| /DMF0044/exchangeRate/SAVE/call-proc | propagated | 1 | Y | sales-reports.api.ts:93 |
| /DMF0044/textbox/SAVE/call-proc | propagated | 1 | Y | sales-reports.api.ts:98 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| MDF Reports | divisionId mdfType yyyy spVersionNo dataType userGroup userId mnuId | data |  |
| spreadTitle | divisionId startDt endDt | data |  |
| measure | dataType userId mnuId | data |  |
| unitedVersion | divisionId sdt edt versionType description userId mnuId | data |  |
| exchangeRate | divisionId year versionNo userId mnuId | data |  |
| textbox | versionNo userId mnuId | data rc2 rc3 |  |
| titleSet | programId sheetName columnType divisionId | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| globalThis.window | keydown | handler | addEventListener | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 73 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 543 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 544 |
| g | updatedLayout | normalizeHeader | addHandler | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 595 |
| SearchArea | onSearch | handleSearch | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 813 |
| DivisionField | onChange | <arrow> handleConditionChange | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 823 |
| CustomDropdown | onChange | <arrow> handleConditionChange,String | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 838 |
| InsertHotkey | onInsert | handleInsert | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 891 |
| Button | onClick | handleInsert | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 897 |
| Button | onClick | handleExcel | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 910 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 920 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 928 |
| InputField | onChange | <arrow> setValue | jsx | features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx | 172 |
| Button | onClick | <arrow> handleSave | jsx | features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx | 189 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/sales-reports/components/modals/TextboxModal.tsx | 196 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 64 |
| DivisionField | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,dayjs().format,dayjs | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 71 |
| CustomDropdown | onChange | <arrow> set,String,onReportTypeChange | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 96 |
| YearField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 118 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 129 |
| VersionField | onOpenPopup | onOpenVersionModal | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 144 |
| VersionField | onValueChange | <arrow> set | jsx | features/demand/src/pages/sales-reports/components/SalesReportsForm.tsx | 149 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 523 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 553 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 554 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 606 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 607 |
| g | pastingCell | capturePasteRange | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 665 |
| g | pastedCell | propagatePaste | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 666 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 678 |
| g.hostElement | mousedown | mouseDownCapture | addEventListener | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 693 |
| g.hostElement | keydown | keyDownCapture | addEventListener | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 704 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 712 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 769 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 791 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,settings.filter,saveTitleSet,visible.map,onClose | jsx | features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx | 160 |
| MeasureSelectModal | onApply | <arrow> applyVisibleMeasures,staticMeasures.map,saveTitleSet('M',selected.map((name,i)=>({name,sortOrderNo:i+1}))).then,saveTitleSet,selected.map,fetchStaticMeasures | jsx | features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx | 194 |
| VersionModal | onSelect | onVersionSelect | jsx | features/demand/src/pages/sales-reports/components/SalesReportsModals.tsx | 219 |
| SalesReportsForm | onSearch | handleSearch | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 692 |
| SalesReportsForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 693 |
| SalesReportsForm | onReportTypeChange | handleReportTypeChange | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 694 |
| SalesReportsForm | onOpenVersionModal | <arrow> setOpenModal | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 695 |
| SalesReportsGrid | onItemCellDblClick | <arrow> setItemTargetRow,setOpenModal | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 725 |
| SalesReportsModals | onClose | <arrow> setOpenModal | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 741 |
| SalesReportsModals | onItemSelect | applyPopupSelection | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 743 |
| SalesReportsModals | onMeasureApply | resetGrid | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 746 |
| SalesReportsModals | onVersionSelect | <arrow> setSearchCondition | jsx | features/demand/src/pages/sales-reports/SalesReports.tsx | 747 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 6 |
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 3 |
| ProgressIndicator | 3 |
| CustomDialog | 2 |
| SearchArea | 2 |
| DivisionField | 2 |
| DataGrid | 2 |
| ResultArea | 1 |
| InsertHotkey | 1 |
| FileExceldownloadIcon | 1 |
| InputField | 1 |
| YearField | 1 |
| VersionField | 1 |
| ItemByDivisionModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| VersionModal | 1 |
| ExchangeRateModal | 1 |
| TextboxModal | 1 |
| IcExchangeRate | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| SalesReportsForm | 1 |
| SubTitle | 1 |
| SalesReportsGrid | 1 |
| SalesReportsModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| dynamicColumns | c.binding | c.mm | 120 | true |  |  | object | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 351 |
| mainDynamicColumns | m.binding | m.label | 225 | true |  |  | object | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 327 |
| evalDyn | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  |  |  |  | lockCtxRef.current.dataType | object | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 356 |
| readGridGroupInput | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/sales-reports/SalesReports.tsx | 233 |
| cell | params.binding ?? 'M_202607' |  |  |  |  | params.dataType ?? DATA_TYPE.CUTOFF | object | features/demand/src/pages/sales-reports/utils/sales-reports.editLock.test.ts | 17 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00667 | 1 |
| LBL00661 | 4 |
| LBL00664 | 1 |
| LBL00086 | 2 |
| LBL00670 | 1 |
| LBL00111 | 1 |
| LBL00627 | 1 |
| LBL00112 | 1 |
| LBL00795 | 1 |
| LBL00089 | 1 |
| LBL00797 | 1 |
| LBL00798 | 1 |
| MSG00283 | 1 |
| MSG00688 | 1 |
| MSG00681 | 1 |
| MSG00429 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| MSG00676 | 1 |
| MSG00618 | 1 |
| MSG00680 | 1 |
| MSG00096 | 1 |
| MSG00682 | 1 |
| MSG00683 | 1 |
| MSG00684 | 1 |
| MSG00685 | 1 |
| MSG00686 | 1 |
| MSG00687 | 1 |
| LBL00310 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0044(29), DMF0003(10), DMF0042(9), DMF0049(8), DMF0020(2), DMF0072(1), DMF0074(1), DM0002(1), DMF0040(1), DMF0053(1)
- SP/PKG: DMF0044_GET_SPREAD_TITLE(6), P_DMF0044_GET_MEASURE(4), P_DMF0044_GET_SALES_REPORTS_DATA(4), P_YYYYMMDD(2), DMF0044_GET_SALES_REPORTS_DATA(2), P_CREATED_BY(2), PKG_DMF0044(2), DMF0044_GET_SCM_MST_EXCHANGE_RATE_POPUP(1), DMF0044_GET_EXCHANGE_POPUP_SPREAD_TITLE(1), P_VERSION_NO(1), P_YYYYMM(1), P_DESCRIPTION1(1), P_ACTION_TYPE(1), P_MDF_TYPE(1), P_USER_GROUP(1), SCM0002_SET_TITLESET_POPUP(1), P_DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT(1), P_DMF0044_SAVE_TEXTBOX(1), P_CUTOFF_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | [문제] 종전에는 `if (!gridRef.current) return;` 으로 끝냈다. 그런데 이 모달은 다이얼로그 | features/demand/src/pages/sales-reports/components/modals/ExchangeRateModal.tsx | 523 |
| code | 편집 중인 셀(editRange 가드로 조기 return)과 정적/동적 어디에도 안 걸리는 컬럼 | features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx | 456 |
| code | F8 Insert — Data Type=2(ETC) 전용 (AS-IS InsertRow L973 분기 return). | features/demand/src/pages/sales-reports/SalesReports.tsx | 300 |
| code | silent (AS-IS 분기 return 파리티) | features/demand/src/pages/sales-reports/SalesReports.tsx | 304 |
| code | *주석 처리돼 있다**(`//if (GetText(ActiveRowIndex, Action) != "I") return;`) — 즉 AS-IS 는 | features/demand/src/pages/sales-reports/SalesReports.tsx | 365 |
| code | silent (AS-IS 분기 return 파리티) | features/demand/src/pages/sales-reports/SalesReports.tsx | 378 |
| jsx | `SubTitle.tsx` 가 `{buttonActions.save === false \|\| (<Button .../>)}` 로 그린다. | features/demand/src/pages/sales-reports/SalesReports.tsx | 622 |
| jsx | action: () => setOpenModal('COLUMN'), iconComponent: <IcGridColumnSetup />, | features/demand/src/pages/sales-reports/SalesReports.tsx | 665 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 46건 'MDF Reports', hook #113 서버 직접 비교) | features/demand/src/pages/sales-reports/useSalesReportsStore.ts | 288 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 18건 — Measure Select 팝업 대상) | features/demand/src/pages/sales-reports/useSalesReportsStore.ts | 306 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

