# DMF0021_01 — To-Be Fact Pack 요약

- page_key: `demand/sales-plan-01` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 20 · 엔드포인트 호출 14 (미해결 0, 주석 속 3) · 이벤트 29 · 컴포넌트 사용 34 · 하드코딩 컬럼 4 · 메시지 44
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.module.scss | component | 8 |
| features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | component | 462 |
| features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | component | 1347 |
| features/demand/src/pages/sales-plan-01/components/SalesPlan01Modals.tsx | component | 305 |
| features/demand/src/pages/sales-plan-01/index.ts | index | 2 |
| features/demand/src/pages/sales-plan-01/sales-plan-01.constants.ts | constants | 236 |
| features/demand/src/pages/sales-plan-01/sales-plan-01.types.ts | types | 59 |
| features/demand/src/pages/sales-plan-01/SalesPlan01.module.scss | style | 72 |
| features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | page | 639 |
| features/demand/src/pages/sales-plan-01/useSalesPlan01Store.ts | store | 595 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.api.ts | api | 158 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.auth.ts | util | 12 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.division.ts | util | 93 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.editLock.ts | util | 264 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.gridCombos.ts | util | 50 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.insertAnchor.ts | util | 68 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.merge.ts | util | 193 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.save.ts | util | 207 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.searchCombos.ts | util | 78 |
| features/demand/src/pages/sales-plan-01/utils/sales-plan-01.validate.ts | util | 135 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | SalesPlan01Form.tsx:93 SalesPlan01Form.tsx:110 SalesPlan01Grid.tsx:149 SalesPlan01.tsx:70 SalesPlan01.tsx:163 |
| DMF0021_01/dayRange//call-proc | hook | 1 | Y | SalesPlan01.tsx:103 |
| DMF0021_01/Sales Plan//call-proc | hook | 1 | Y | SalesPlan01.tsx:122 |
| DMF0021_01/spreadTitle//call-proc | hook | 1 | Y | SalesPlan01.tsx:131 |
| DMF0021_01/measureInfo//call-proc | hook | 1 | Y | SalesPlan01.tsx:152 |
| /admin/menu/DMF0021_01/column | http | 1 | Y | useSalesPlan01Store.ts:415 |
| /admin/menu/DMF0021_01/search-conditions | http | 1 | Y | useSalesPlan01Store.ts:434 |
| /admin/menu/DMF0021_01/measure | http | 1 | Y | useSalesPlan01Store.ts:458 |
| DMF0021_01/titleSet/SEARCH/call-proc | http | 1 | Y | useSalesPlan01Store.ts:498 |
| /DMF0021_01/Sales Plan/SAVE/call-proc | http | 1 | Y | sales-plan-01.api.ts:131 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 193 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 241 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String,onDivisionChange | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 258 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 358 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 367 |
| CustomDropdown | onChange | <arrow> validation.validateBucketChange,hasPendingChanges,setBucketType | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 379 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 399 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 411 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 434 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Form.tsx | 452 |
| g | updatedLayout | attach | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 289 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 767 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 842 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 844 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 960 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 974 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1020 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1024 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1132 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1182 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1251 |
| g | updatedLayout | applyFooter | addHandler | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 1301 |
| ColumnLayoutModal | onSave | <arrow> onSettingChanged,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Modals.tsx | 233 |
| MeasureSelectModal | onApply | <arrow> onSettingChanged,applyVisibleMeasures,staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/sales-plan-01/components/SalesPlan01Modals.tsx | 280 |
| SalesPlan01Form | onSearch | handleSearch | jsx | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 560 |
| SalesPlan01Form | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 561 |
| SalesPlan01Grid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 596 |
| SalesPlan01Modals | onClose | <arrow> ({PROJECT:setOpenProject,ITEM:setOpenItem,TEAM:setOpenTeam,COLUMN:setOpenColumnSetting,MEASURE:setOpenMeasureSelect,})[key] | jsx | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 608 |
| SalesPlan01Modals | onSettingChanged | clearGridOnSettingChange | jsx | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 630 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| SearchArea | 1 |
| PeriodField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| TeamModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| SalesPlan01Form | 1 |
| SubTitle | 1 |
| SalesPlan01Grid | 1 |
| SalesPlan01Modals | 1 |
| ProgressIndicator | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| titleMetas | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  | spColumnWidth(r.COLUMN_WIDTH) |  |  |  | object | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 356 |
| dynColMetas | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  | titleWidth |  |  |  | object | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 382 |
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | m.width ?? DYN_COL_DEFAULT_WIDTH | true |  |  | object | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 490 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 341 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 2 |
| LBL00683 | 2 |
| LBL00684 | 2 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 2 |
| LBL00080 | 2 |
| LBL00011 | 2 |
| LBL00085 | 1 |
| LBL00068 | 1 |
| LBL00710 | 1 |
| LBL00005 | 1 |
| LBL00687 | 1 |
| MSG00618 | 2 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00137 | 1 |
| MSG00667 | 1 |
| MSG00108 | 1 |
| MSG01505 | 1 |
| MSG00429 | 1 |
| MSG00113 | 1 |
| MSG00680 | 1 |
| MSG00085 | 1 |
| MSG00670 | 1 |
| MSG00361 | 1 |
| MSG01091 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| LBL00605 | 2 |
| LBL00310 | 3 |
| LBL00669 | 1 |
| LBL00024 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003(19), DMF0021(15), DMF0082(5), DMF0020(4), DMF0014(3), DMF0042(3), DMF0040(2), DMF0053(2), SCM0001(1), SYS0004(1), COM0008(1), DMF0005(1), DMF0021_01(1), DMF0020_01(1), DMF0048(1)
- SP/PKG: P_DMF0021_GET_SPREAD_TITLE(6), PR_GET_DAY_RANGE(6), P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX(5), P_USERINFO(3), DMF0003_GET_BUCKET_TYPE_CODE(2), P_DMF0021_GET_SALES_PLAN_MEASUREINFO(2), P_USER_DEPT_ID(2), PR_GET_SHEET_COLUMN_LIST(1), PKG_DMF0021_01(1), P_BUCKET(1), P_BUCKET_TYPE(1), PKG_DMF0021(1), P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL(1), P_CREATED_BY(1), DMF0002_GET_TITLESET_POPUP(1), DMF0003_GET_SPREAD_TITLE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return). | features/demand/src/pages/sales-plan-01/components/SalesPlan01Grid.tsx | 741 |
| endpoint | ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline) + persist 된 이전 filters 무효화. | features/demand/src/pages/sales-plan-01/SalesPlan01.tsx | 230 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/sales-plan-01/useSalesPlan01Store.ts | 102 |
| endpoint | ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS 66건, division 서버 필터). | features/demand/src/pages/sales-plan-01/useSalesPlan01Store.ts | 406 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 31건 — Measure Select 팝업 대상) | features/demand/src/pages/sales-plan-01/useSalesPlan01Store.ts | 455 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

