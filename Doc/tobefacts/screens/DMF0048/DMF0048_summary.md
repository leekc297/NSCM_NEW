# DMF0048 — To-Be Fact Pack 요약

- page_key: `demand/sales-monitoring` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 10 (미해결 0, 주석 속 3) · 이벤트 21 · 컴포넌트 사용 32 · 하드코딩 컬럼 4 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.module.scss | component | 71 |
| features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | component | 412 |
| features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | component | 696 |
| features/demand/src/pages/sales-monitoring/index.ts | index | 2 |
| features/demand/src/pages/sales-monitoring/sales-monitoring.constants.ts | constants | 352 |
| features/demand/src/pages/sales-monitoring/sales-monitoring.types.ts | types | 61 |
| features/demand/src/pages/sales-monitoring/SalesMonitoring.module.scss | style | 35 |
| features/demand/src/pages/sales-monitoring/SalesMonitoring.tsx | page | 437 |
| features/demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts | store | 504 |
| features/demand/src/pages/sales-monitoring/utils/sales-monitoring.combos.test.ts | test | 33 |
| features/demand/src/pages/sales-monitoring/utils/sales-monitoring.combos.ts | util | 18 |
| features/demand/src/pages/sales-monitoring/utils/sales-monitoring.merge.ts | util | 152 |
| features/demand/src/pages/sales-monitoring/__asis-mapping__.md | mapping | 144 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 3 | Y | SalesMonitoringForm.tsx:64 SalesMonitoringForm.tsx:77 SalesMonitoringForm.tsx:120 |
| DMF0048/Sales Monitoring//call-proc | hook | 1 | Y | SalesMonitoring.tsx:72 |
| DMF0048/spreadTitle//call-proc | hook | 1 | Y | SalesMonitoring.tsx:81 |
| DMF0048/dayRange//call-proc | hook | 1 | Y | SalesMonitoring.tsx:100 |
| /admin/menu/DMF0048/search-conditions | http | 1 | Y | useSalesMonitoringStore.ts:248 |
| /admin/menu/DMF0048/column | http | 1 | Y | useSalesMonitoringStore.ts:362 |
| DMF0048/titleSet/SEARCH/call-proc | http | 1 | Y | useSalesMonitoringStore.ts:390 |
| /admin/menu/DMF0048/measure | http | 1 | Y | useSalesMonitoringStore.ts:444 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Sales Monitoring | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd createdBy plantSiteId biztype owner internalYn userinfo bucket userDeptId sesUserId mnuId | o_rc1 o_rc2 |  |
| spreadTitle | startYyyymmdd endYyyymmdd createdBy divisionId bucket | o_rc1 |  |
| dayRange | createdBy month | o_rc1 o_rc2 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 160 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 190 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 204 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 280 |
| CustomDropdown | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 292 |
| CustomDropdown | onChange | <arrow> set,toArr | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 310 |
| CustomDropdown | onChange | <arrow> set,toArr | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 329 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 344 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 356 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 378 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/sales-monitoring/components/SalesMonitoringForm.tsx | 402 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 453 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 460 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 464 |
| g | updatedLayout | onLayout | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 530 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 583 |
| g | updatedLayout | applyFooter | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 634 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 664 |
| SalesMonitoringForm | onSearch | handleSearch | jsx | features/demand/src/pages/sales-monitoring/SalesMonitoring.tsx | 315 |
| ColumnLayoutModal | onSave | <arrow> clearGridOnSettingChange,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,//⚠️팝업조회(위sheetName/columnType)와반드시같은값이어야한다.sheetName:SHEETS.MAIN,columnType:'C',rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/sales-monitoring/SalesMonitoring.tsx | 361 |
| MeasureSelectModal | onApply | <arrow> clearGridOnSettingChange,applyVisibleMeasures,staticMeasures[SHEETS.MAIN].map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).//필수:저장키는팝업조회와같은상수를써야한다(다르면재진입시개인화유실).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/sales-monitoring/SalesMonitoring.tsx | 410 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 5 |
| SearchArea | 1 |
| PeriodField | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| OwnerField | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| SalesMonitoringForm | 1 |
| SubTitle | 1 |
| SalesMonitoringGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | object | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 125 |
| mergedColumns | col.colNm | col.colLblNm \|\| fb?.header \|\| col.colNm | col.colWth ?? fb?.width ?? 100 | col.visible !== false |  |  | object | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 141 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 242 |
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | true |  |  | object | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 289 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 1 |
| LBL00683 | 1 |
| LBL00684 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00710 | 1 |
| LBL00068 | 1 |
| LBL00085 | 1 |
| LBL00005 | 1 |
| LBL00687 | 1 |
| MSG00137 | 1 |
| MSG00108 | 1 |
| MSG00164 | 1 |
| MSG00097 | 1 |
| MSG00227 | 1 |
| MSG00618 | 1 |
| LBL00605 | 2 |
| LBL00310 | 2 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0048(3), DMF0003(3), DMF0020(2), SYS0004(1)
- SP/PKG: PR_GET_DAY_RANGE(9), DMF0048_GET_SPREAD_TITLE(7), PKG_DMF0048(5), P_DMF0048_GET_DM_PLN_SALES_MONITORING(5), DMF0003_GET_BUCKET_TYPE_CODE(2), FN_SPLITSTRING(2), PR_GET_SHEET_MEASURE_LIST(2), PKG_NSCM_UI_COM_MENU(1), PR_GET_SHEET_COLUMN_LIST(1), DMF0002_GET_TITLESET_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | ⭐ 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 대상 (동적 기간 컬럼은 위에서 return). | features/demand/src/pages/sales-monitoring/components/SalesMonitoringGrid.tsx | 438 |
| endpoint | VISIBLE_FLAG='Y' 이면서 division 대표 컬럼). 정본은 admin 동적 fetch (fetchStaticColumns) — 본 | features/demand/src/pages/sales-monitoring/sales-monitoring.constants.ts | 97 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts | 94 |
| endpoint | ⭐ ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 54행, admin 즉시 반영) | features/demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts | 351 |
| endpoint | ⭐ Measure 동적 fetch (PIVOT 화면 의무 — SCM_MST_SHEET_MEASURE 39행) | features/demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts | 438 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

