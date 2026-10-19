# DMF0021 — To-Be Fact Pack 요약

- page_key: `demand/sales-plan` · feature: demand · As-is Fact Pack 있음
- 파일 27 · 엔드포인트 호출 14 (미해결 0, 주석 속 3) · 이벤트 30 · 컴포넌트 사용 34 · 하드코딩 컬럼 3 · 메시지 42
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 3건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/sales-plan/components/SalesPlanForm.module.scss | component | 28 |
| features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | component | 498 |
| features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | component | 1250 |
| features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx | component | 302 |
| features/demand/src/pages/sales-plan/index.ts | index | 2 |
| features/demand/src/pages/sales-plan/sales-plan.constants.ts | constants | 227 |
| features/demand/src/pages/sales-plan/sales-plan.types.ts | types | 59 |
| features/demand/src/pages/sales-plan/SalesPlan.module.scss | style | 72 |
| features/demand/src/pages/sales-plan/SalesPlan.tsx | page | 609 |
| features/demand/src/pages/sales-plan/useSalesPlanStore.test.tsx | test | 256 |
| features/demand/src/pages/sales-plan/useSalesPlanStore.ts | store | 595 |
| features/demand/src/pages/sales-plan/utils/sales-plan.api.ts | api | 158 |
| features/demand/src/pages/sales-plan/utils/sales-plan.auth.test.ts | test | 19 |
| features/demand/src/pages/sales-plan/utils/sales-plan.auth.ts | util | 12 |
| features/demand/src/pages/sales-plan/utils/sales-plan.division.ts | util | 93 |
| features/demand/src/pages/sales-plan/utils/sales-plan.editLock.test.ts | test | 177 |
| features/demand/src/pages/sales-plan/utils/sales-plan.editLock.ts | util | 264 |
| features/demand/src/pages/sales-plan/utils/sales-plan.gridCombos.ts | util | 50 |
| features/demand/src/pages/sales-plan/utils/sales-plan.insertAnchor.test.ts | test | 69 |
| features/demand/src/pages/sales-plan/utils/sales-plan.insertAnchor.ts | util | 68 |
| features/demand/src/pages/sales-plan/utils/sales-plan.merge.ts | util | 193 |
| features/demand/src/pages/sales-plan/utils/sales-plan.save.test.ts | test | 67 |
| features/demand/src/pages/sales-plan/utils/sales-plan.save.ts | util | 203 |
| features/demand/src/pages/sales-plan/utils/sales-plan.searchCombos.ts | util | 78 |
| features/demand/src/pages/sales-plan/utils/sales-plan.validate.ts | util | 131 |
| features/demand/src/pages/sales-plan/__asis-analysis__.md | other | 261 |
| features/demand/src/pages/sales-plan/__asis-mapping__.md | mapping | 783 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 5 | Y | SalesPlanForm.tsx:96 SalesPlanForm.tsx:113 SalesPlanGrid.tsx:137 SalesPlan.tsx:69 SalesPlan.tsx:162 |
| DMF0021/dayRange//call-proc | hook | 1 | Y | SalesPlan.tsx:102 |
| DMF0021/Sales Plan//call-proc | hook | 1 | Y | SalesPlan.tsx:121 |
| DMF0021/spreadTitle//call-proc | hook | 1 | Y | SalesPlan.tsx:130 |
| DMF0021/measureInfo//call-proc | hook | 1 | Y | SalesPlan.tsx:151 |
| /admin/menu/DMF0021/column | http | 1 | Y | useSalesPlanStore.ts:415 |
| /admin/menu/DMF0021/search-conditions | http | 1 | Y | useSalesPlanStore.ts:434 |
| /admin/menu/DMF0021/measure | http | 1 | Y | useSalesPlanStore.ts:458 |
| DMF0021/titleSet/SEARCH/call-proc | http | 1 | Y | useSalesPlanStore.ts:498 |
| /DMF0021/Sales Plan/SAVE/call-proc | http | 1 | Y | sales-plan.api.ts:131 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Sales Plan | divisionId deptId endCustomer scmSiteId projectCode itemId itemType fromYyyymmdd nowYyyymmdd toYyyymmdd sesUserId plantSiteId bizType owner internalYn userGroup bucket userDeptId | data calendar editAuth |  |
| spreadTitle | startYyyymmdd endYyyymmdd sesUserId divisionId bucket | data |  |
| measureInfo |  | data |  |
| dayRange | createdBy month | o_rc1 o_rc2 |  |
| titleSet | programId sheetName columnType sesUserId divisionId mnuId | o_rc1 |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 196 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 272 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,String,onDivisionChange | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 289 |
| CustomDropdown | onChange | <arrow> set,toMulti,String | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 392 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 401 |
| CustomDropdown | onChange | <arrow> validation.validateBucketChange,hasPendingChanges,setBucketType | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 413 |
| div | onKeyDownCapture | openFieldModalOnEnter | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 430 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 434 |
| div | onKeyDownCapture | openFieldModalOnEnter | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 444 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 448 |
| OwnerField | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 472 |
| Checkbox | onChange | <arrow> set | jsx | features/demand/src/pages/sales-plan/components/SalesPlanForm.tsx | 488 |
| g | updatedLayout | attach | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 277 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 749 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 824 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 826 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 942 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 956 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 1002 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 1006 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 1091 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 1141 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 1210 |
| ColumnLayoutModal | onSave | <arrow> onSettingChanged,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx | 230 |
| MeasureSelectModal | onApply | <arrow> onSettingChanged,applyVisibleMeasures,staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:SHEETS.MAIN,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/sales-plan/components/SalesPlanModals.tsx | 277 |
| SalesPlanForm | onSearch | handleSearch | jsx | features/demand/src/pages/sales-plan/SalesPlan.tsx | 530 |
| SalesPlanForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/sales-plan/SalesPlan.tsx | 531 |
| SalesPlanGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/sales-plan/SalesPlan.tsx | 566 |
| SalesPlanModals | onClose | <arrow> ({PROJECT:setOpenProject,ITEM:setOpenItem,TEAM:setOpenTeam,COLUMN:setOpenColumnSetting,MEASURE:setOpenMeasureSelect,})[key] | jsx | features/demand/src/pages/sales-plan/SalesPlan.tsx | 578 |
| SalesPlanModals | onSettingChanged | clearGridOnSettingChange | jsx | features/demand/src/pages/sales-plan/SalesPlan.tsx | 600 |

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
| SalesPlanForm | 1 |
| SubTitle | 1 |
| SalesPlanGrid | 1 |
| SalesPlanModals | 1 |
| ProgressIndicator | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | true |  |  | object | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 472 |
| buildGroupKeyOf | column?.binding ?? '' |  |  | column?.visible !== false |  |  | object | features/demand/src/pages/sales-plan/SalesPlan.tsx | 320 |
| col | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER |  |  | visible |  |  | object | features/demand/src/pages/sales-plan/utils/sales-plan.insertAnchor.test.ts | 11 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 2 |
| LBL00683 | 2 |
| LBL00684 | 2 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
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
| MSG00164 | 1 |
| MSG00429 | 1 |
| MSG00113 | 1 |
| MSG00227 | 1 |
| MSG00085 | 1 |
| MSG00670 | 1 |
| MSG00361 | 1 |
| MSG00002 | 1 |
| MSG00004 | 1 |
| LBL00605 | 2 |
| LBL00310 | 3 |
| LBL00669 | 1 |
| LBL00024 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0003(16), DMF0021(14), DMF0082(7), DMF0020(4), DMF0014(3), DMF0040(2), DMF0053(2), SCM0001(1), SYS0004(1), COM0008(1), DMF0048(1)
- SP/PKG: P_DMF0021_GET_SPREAD_TITLE(6), PR_GET_DAY_RANGE(6), P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX(5), P_USERINFO(3), DMF0003_GET_BUCKET_TYPE_CODE(2), P_DMF0021_GET_SALES_PLAN_MEASUREINFO(2), P_USER_DEPT_ID(2), PR_GET_SHEET_COLUMN_LIST(1), P_BUCKET(1), P_BUCKET_TYPE(1), PKG_DMF0021(1), P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL(1), P_CREATED_BY(1), DMF0002_GET_TITLESET_POPUP(1), DMF0003_GET_SPREAD_TITLE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return). | features/demand/src/pages/sales-plan/components/SalesPlanGrid.tsx | 723 |
| endpoint | ⭐ mount 시 1회 admin 메타 fetch (#42/#65 동적 속성관리 baseline) + persist 된 이전 filters 무효화. | features/demand/src/pages/sales-plan/SalesPlan.tsx | 209 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/sales-plan/useSalesPlanStore.ts | 102 |
| endpoint | ⭐ master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS 66건, division 서버 필터). | features/demand/src/pages/sales-plan/useSalesPlanStore.ts | 406 |
| endpoint | ⭐ master hook §5 — Measure 동적 fetch (SHEET_MEASURE 31건 — Measure Select 팝업 대상) | features/demand/src/pages/sales-plan/useSalesPlanStore.ts | 455 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

