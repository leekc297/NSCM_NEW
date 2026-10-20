# DMF0052 — To-Be Fact Pack 요약

- page_key: `report/dmf0052` · feature: report · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 9 · 컴포넌트 사용 41 · 하드코딩 컬럼 0 · 메시지 10
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | component | 112 |
| features/report/src/pages/dmf0052/components/Dmf0052GridData.tsx | component | 58 |
| features/report/src/pages/dmf0052/components/Dmf0052GridSummary.tsx | component | 34 |
| features/report/src/pages/dmf0052/components/Dmf0052GridSummaryPjt.tsx | component | 70 |
| features/report/src/pages/dmf0052/components/Dmf0052GridSummaryStatus.tsx | component | 34 |
| features/report/src/pages/dmf0052/components/modals/GSCMDataModal.module.scss | component | 8 |
| features/report/src/pages/dmf0052/components/modals/GSCMDataModal.tsx | component | 112 |
| features/report/src/pages/dmf0052/dmf0052.constants.ts | constants | 29 |
| features/report/src/pages/dmf0052/Dmf0052.tsx | page | 204 |
| features/report/src/pages/dmf0052/hooks/useDmf0052Validation.ts | hook | 69 |
| features/report/src/pages/dmf0052/index.ts | index | 3 |
| features/report/src/pages/dmf0052/useDmf0052Store.ts | store | 169 |
| features/report/src/pages/dmf0052/__asis-mapping__.md | mapping | 85 |
| features/report/src/pages/dmf0052/__tests__/Dmf0052.asis.spec.ts | test | 37 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | Dmf0052Form.tsx:24 Dmf0052Form.tsx:31 |
| DMF0052/EDI Summary GSCM DATA Popup//call-proc | hook | 1 | Y | GSCMDataModal.tsx:43 |
| DMF0052/SUMMARY//call-proc | hook | 1 | Y | Dmf0052.tsx:50 |
| DMF0052/Summary Pjt//call-proc | hook | 1 | Y | Dmf0052.tsx:59 |
| DMF0052/Summary Status//call-proc | hook | 1 | Y | Dmf0052.tsx:68 |
| DMF0052/SUMMARY\|ERP Data\|GSCM Data\|Summary Pjt\|Summary Status\|EDI Summary GSCM DATA Popup\|Site Popup\|spreadTitle//call-proc | hook | 1 | Y | Dmf0052.tsx:90 |
| /admin/menu/DMF0052/column | http | 1 | Y | useDmf0052Store.ts:104 |
| /admin/menu/DMF0052/search-conditions | http | 1 | Y | useDmf0052Store.ts:109 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 51 |
| Checkbox | onChange | handleTodayChange | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 61 |
| ItemField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 69 |
| ProjectField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 76 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 84 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/report/src/pages/dmf0052/components/Dmf0052Form.tsx | 101 |
| Button | onClick | handleSubmit | jsx | features/report/src/pages/dmf0052/components/modals/GSCMDataModal.tsx | 104 |
| Button | onClick | modalClose | jsx | features/report/src/pages/dmf0052/components/modals/GSCMDataModal.tsx | 105 |
| GSCMDataModal | onSelect | handleModalSelect | jsx | features/report/src/pages/dmf0052/Dmf0052.tsx | 196 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Panel | 6 |
| DataGrid | 5 |
| SubTitle | 4 |
| PanelGroup | 3 |
| PanelSeparator | 3 |
| Grid | 2 |
| FormItem | 2 |
| Button | 2 |
| SearchArea | 1 |
| Checkbox | 1 |
| ItemField | 1 |
| ProjectField | 1 |
| PeriodField | 1 |
| CustomDropdown | 1 |
| CustomDialog | 1 |
| MainTitle | 1 |
| Dmf0052Form | 1 |
| Dmf0052GridSummary | 1 |
| Dmf0052GridSummaryPjt | 1 |
| Dmf0052GridSummaryStatus | 1 |
| Dmf0052GridData | 1 |
| GSCMDataModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00013 | 1 |
| LBL00012 | 1 |
| LBL00106 | 1 |
| LBL00061 | 1 |
| LBL00062 | 1 |
| MSG00097 | 2 |
| MSG00108 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0052(12)
- SP/PKG: DMF0052_GET_ERP_DATA(2), DMF0052_GET_DETAIL_DATA(2), DMF0052_GET_SITE_POPUP(2), DMF0052_GET_SUMMARY_DATA(1), DMF0052_GET_PJT_DATA(1), DMF0052_GET_STATUS_DATA(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | AS-IS SP 1: DMF0052_GET_SITE_POPUP — 등록 3-키는 register.json / <ID>_registration.sql 참조 | features/report/src/pages/dmf0052/components/modals/GSCMDataModal.tsx | 35 |
| jsx | SCM_ADM_PROC_M.COL_NM(camelCase) 과 키가 같아야 BE 가 positional 매핑한다 — 등록 SQL(<ID>_registration.sql BLOCK 2) 과 대사할 것 | features/report/src/pages/dmf0052/useDmf0052Store.ts | 20 |

## 10. __asis-mapping__.md 상태
- 해당없음: 21
- 구현: 32
- 제외: 1
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-001 | §1 splitContainer1 / SplitContainer | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 splitContainer2 / SplitContainer | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-004 | §1 spdSummary_Sheet1 / SheetView | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-006 | §1 spdSummaryPJT_Sheet1 / SheetView | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-007 | §1 usrLayoutControl1 / UsrLayoutControl | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-016 | §1 layoutControlGroup1 / LayoutControlGroup | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem3 / EmptySpaceItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-018 | §1 layoutControlItem1 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-019 | §1 lblProject / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-020 | §1 layoutControlItem3 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-021 | §1 lblModel / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-022 | §1 layoutControlItem4 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-023 | §1 Period / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-024 | §1 lblEDISender / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-025 | §1 layoutControlItem2 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-026 | §1 splitContainer3 / SplitContainer | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-028 | §1 spdSummaryStatus_Sheet1 / SheetView | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-030 | §1 spdData_Sheet1 / SheetView | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS enum/activeSheet 상태로 흡수 | 해당없음 |
| D00-1-031 | §1 imageList1 / ImageList | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-4-006 | §4 DM.DMF0052_GET_SPREAD_TITLE / DMF0052_GET_SPREAD_TITLE | 그리드 헤더 메타 → /admin/menu/{MENU}/column(SCM_MST_SHEET_COLUMNS) + spreadTitle 시트(동적 헤더 SP) | 해당없음 |
| D00-4-007 | §4 DM.UP_FX_GetCommonDataList_DM / UP_FX_GETCOMMONDATALIST_DM | 공통 콤보 조회 → useTabComboQueries(콤보ID 등록) | 해당없음 |
| D00-5-004 | §5 시트 'Site Popup' / 메타 정의만, 코드 미참조(미사용 가능) (9컬럼) | 메타 정의만 있고 As-is 코드 미참조(미사용) — 실제 팝업은 'EDI Summary GSCM DATA Popup' 하드코딩 시트 사용, 등록·배선 생략 | 제외 |

