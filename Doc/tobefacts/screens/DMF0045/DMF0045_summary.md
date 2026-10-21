# DMF0045 — To-Be Fact Pack 요약

- page_key: `demand/dmf0045` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 22 · 엔드포인트 호출 13 (미해결 0, 주석 속 5) · 이벤트 30 · 컴포넌트 사용 40 · 하드코딩 컬럼 1 · 메시지 40
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.module.scss | component | 18 |
| features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | component | 238 |
| features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | component | 290 |
| features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | component | 822 |
| features/demand/src/pages/dmf0045/components/ShipmentRequestModals.tsx | component | 268 |
| features/demand/src/pages/dmf0045/dmf0045.constants.ts | constants | 155 |
| features/demand/src/pages/dmf0045/dmf0045.types.ts | types | 74 |
| features/demand/src/pages/dmf0045/index.ts | index | 2 |
| features/demand/src/pages/dmf0045/ShipmentRequest.module.scss | style | 65 |
| features/demand/src/pages/dmf0045/ShipmentRequest.tsx | page | 507 |
| features/demand/src/pages/dmf0045/useShipmentRequestStore.ts | store | 521 |
| features/demand/src/pages/dmf0045/utils/dmf0045.api.ts | api | 124 |
| features/demand/src/pages/dmf0045/utils/dmf0045.bohFrontFill.ts | util | 52 |
| features/demand/src/pages/dmf0045/utils/dmf0045.division.ts | util | 20 |
| features/demand/src/pages/dmf0045/utils/dmf0045.editLock.ts | util | 138 |
| features/demand/src/pages/dmf0045/utils/dmf0045.gridCombos.ts | util | 15 |
| features/demand/src/pages/dmf0045/utils/dmf0045.merge.ts | util | 194 |
| features/demand/src/pages/dmf0045/utils/dmf0045.recalc.ts | util | 141 |
| features/demand/src/pages/dmf0045/utils/dmf0045.save.ts | util | 140 |
| features/demand/src/pages/dmf0045/utils/dmf0045.searchCombos.ts | util | 58 |
| features/demand/src/pages/dmf0045/utils/dmf0045.validate.ts | util | 122 |
| features/demand/src/pages/dmf0045/__asis-mapping__.md | mapping | 146 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /admin/menu/DMF0045/column | http | 2 | Y | BodItemRouteModal.tsx:65 useShipmentRequestStore.ts:343 |
| DMF0045/bodPopup//call-proc | hook | 1 | Y | BodItemRouteModal.tsx:92 |
| (useTabComboQueries) | hook | 3 | Y | ShipmentRequestForm.tsx:73 ShipmentRequestGrid.tsx:254 ShipmentRequest.tsx:69 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentRequestForm.tsx:85 |
| DMF0045/Pack Biz\|Cell Biz//call-proc | hook | 1 | Y | ShipmentRequest.tsx:97 |
| DMF0045/spreadTitle//call-proc | hook | 1 | Y | ShipmentRequest.tsx:106 |
| /admin/menu/DMF0045/measure | http | 1 | Y | useShipmentRequestStore.ts:372 |
| DMF0045/titleSet/SEARCH/call-proc | http | 1 | Y | useShipmentRequestStore.ts:389 |
| /admin/menu/DMF0045/search-conditions | http | 1 | Y | useShipmentRequestStore.ts:498 |
| /DMF0045/Pack Biz\|Cell Biz/SAVE/call-proc | http | 1 | Y | dmf0045.api.ts:97 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 167 |
| InputField | onChange | <arrow> setItemId | jsx | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 185 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 186 |
| Button | onClick | handleSubmit | jsx | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 223 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 230 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 164 |
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 181 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,onDivisionChange | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 200 |
| ProjectField | onChange | <arrow> set | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 241 |
| ItemField | onChange | <arrow> set | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 253 |
| CustomDropdown | onChange | <arrow> onBucketChange | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 272 |
| PeriodField | onChange | <arrow> set | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestForm.tsx | 283 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 467 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 505 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 507 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 571 |
| g | pastedCell | pastedCellHandler | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 579 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 624 |
| g | scrollPositionChanged | handleScrollInvalidate | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 628 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 696 |
| g | updatedLayout | applyDynVisibility | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 744 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 790 |
| ColumnLayoutModal | onSave | <arrow> onSettingChanged,applyColumnLayout,settings.map,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:activeSheet,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestModals.tsx | 198 |
| MeasureSelectModal | onApply | <arrow> onSettingChanged,applyVisibleMeasures,staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:activeSheet,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map | jsx | features/demand/src/pages/dmf0045/components/ShipmentRequestModals.tsx | 244 |
| ShipmentRequestForm | onSearch | handleSearch | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 435 |
| ShipmentRequestForm | onDivisionChange | handleDivisionChange | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 436 |
| ShipmentRequestForm | onBucketChange | handleBucketChange | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 437 |
| ShipmentRequestGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 467 |
| ShipmentRequestModals | onClose | <arrow> ({PROJECT:setOpenProject,BOD:setOpenBod,ITEM:setOpenItem,COLUMN:setOpenColumnSetting,MEASURE:setOpenMeasureSelect,})[key] | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 481 |
| ShipmentRequestModals | onSettingChanged | handleSettingChanged | jsx | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 502 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 3 |
| SearchArea | 2 |
| InputField | 2 |
| DataGrid | 2 |
| Button | 2 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| ProjectField | 1 |
| ItemField | 1 |
| PeriodField | 1 |
| ProjectByDivisionModal | 1 |
| ItemByDivisionModal | 1 |
| BodItemRouteModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| ShipmentRequestForm | 1 |
| SubTitle | 1 |
| ShipmentRequestGrid | 1 |
| ShipmentRequestModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mainDynamicColumns | m.binding | m.kind === 'D' ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | true |  |  | object | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 299 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00682 | 2 |
| LBL00683 | 2 |
| LBL00684 | 2 |
| LBL00112 | 2 |
| LBL00001 | 2 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00005 | 1 |
| LBL00710 | 1 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00097 | 1 |
| MSG00002 | 3 |
| MSG00113 | 1 |
| MSG00085 | 1 |
| MSG00227 | 1 |
| MSG00004 | 1 |
| MSG00137 | 1 |
| MSG00703 | 1 |
| MSG00618 | 1 |
| LBL00027 | 1 |
| LBL00669 | 1 |
| LBL00664 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00071 | 1 |
| LBL00605 | 2 |
| LBL00310 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0045(22), DMF0046(12), SCM0002(8), DMF0021(8), DMF0047(7), DMF0003(5), SSP0045(4), DMF0020(2), DMF0040(1), SYS0004(1), SCM0001(1)
- SP/PKG: P_CREATED_BY(9), P_DMF0045_GET_SPREAD_TITLE(5), P_DMF0045_GET_SHIPMENT_REQUEST(5), P_DIVISION_ID(3), PKG_DMF0045(2), P_DMF0045_SAVE_SHIPMENT_REQUEST(2), P_SHEET_NAME(2), P_PROJECT_CODE(2), P_ITEM_ID(2), P_TRANSPORT_MODE(2), DM0003_GET_BUCKET_TYPE_CODE(1), PR_GET_PROC_INFO_LIST(1), P_TEAM_ID(1), P_CUSTOMER(1), P_SCM_SITE_ID(1), P_PLANT_SITE_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_START_DT(1), P_END_DT(1), DMF0002_GET_TITLESET_POPUP(1), P_ACTIVE_FLAG(1), P_FROM_SITE(1), P_TO_SITE(1), P_INCOTERMS(1), P_FCST_TYPE(1), P_BOD_ID(1), P_MEASURE(1), P_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 팝업 컬럼 admin 메타(SCM_MST_SHEET_COLUMNS bodPopup) — 모달 자기완결 fetch(부모 store 미확장). | features/demand/src/pages/dmf0045/components/modals/BodItemRouteModal.tsx | 57 |
| code | 개인화 색 (ColumnLayoutModal 저장값) — 정적 컬럼만 (동적 기간 컬럼은 위에서 return). | features/demand/src/pages/dmf0045/components/ShipmentRequestGrid.tsx | 440 |
| endpoint | mount 시 1회 admin 메타 fetch (동적 속성관리 baseline) + persist 된 이전 filters 무효화 + | features/demand/src/pages/dmf0045/ShipmentRequest.tsx | 138 |
| code | 저장된 컬럼 개인화(titleSet) 복원 — fetchStaticColumns 가 await 후 메타에 적용. | features/demand/src/pages/dmf0045/useShipmentRequestStore.ts | 117 |
| endpoint | master hook §2.3 "UI 생성의 동적 속성관리" — Column 동적 fetch (SHEET_COLUMNS, division 서버 필터). | features/demand/src/pages/dmf0045/useShipmentRequestStore.ts | 335 |
| endpoint | master hook §5 — Measure 동적 fetch (SHEET_MEASURE — Measure Select 팝업 대상) | features/demand/src/pages/dmf0045/useShipmentRequestStore.ts | 369 |
| endpoint | — useTabComboQueries(CMBO 경로)가 아니라 useTabLookupQueries(LOOKUP 경로)로 조회해야 한다. | features/demand/src/pages/dmf0045/utils/dmf0045.searchCombos.ts | 34 |

## 10. __asis-mapping__.md 상태
- 구현: 51
- 해당없음: 29
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-010 | §1 clbDivision / LayoutControlItem | WinForms designer 레이아웃 아티팩트(clbDivision 는 Division 라벨/그룹 컨테이너) — TO-BE 무관 | 해당없음 |
| D00-1-014 | §1 components / System.ComponentModel.Container | WinForms designer 아티팩트(IContainer) — TO-BE 무관 | 해당없음 |
| D00-1-016 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem12 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem2 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-019 | §1 emptySpaceItem3 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-020 | §1 emptySpaceItem6 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-021 | §1 emptySpaceItem8 / EmptySpaceItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-022 | §1 imageList1 / System.Windows.Forms.ImageList | WinForms designer 아티팩트(아이콘 리소스 컨테이너) — TO-BE 무관 | 해당없음 |
| D00-1-023 | §1 layoutControlGroup1 / LayoutControlGroup | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-024 | §1 layoutControlGroup2 / LayoutControlGroup | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-025 | §1 layoutControlItem1 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-026 | §1 layoutControlItem2 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-027 | §1 layoutControlItem3 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-028 | §1 layoutControlItem4 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-029 | §1 layoutControlItem5 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-030 | §1 layoutControlItem6 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-031 | §1 layoutControlItem7 / LayoutControlItem | WinForms designer 레이아웃 아티팩트 — TO-BE 무관 | 해당없음 |
| D00-1-032 | §1 lblBucket / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label(Form.tsx:265)로 흡수 | 해당없음 |
| D00-1-033 | §1 lblCustomer / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-034 | §1 lblItemType / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-035 | §1 lblModel / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-036 | §1 lblPlantSite / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-037 | §1 lblProject / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-038 | §1 lblSalesSite / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-039 | §1 lblTeam / LayoutControlItem | WinForms 레이아웃 라벨 아티팩트 — TO-BE 는 FormItem label 로 흡수 | 해당없음 |
| D00-1-041 | §1 spdMain_Sheet1 / SheetView | FpSpread 디자이너 SheetView 아티팩트 — TO-BE 는 단일 FlexGrid(spdMain=D00-1-040)로 흡수, 시트 2종은 activeSheet 상태(store) | 해당없음 |
| D00-1-045 | §1 usrLayoutControl1 / UsrLayoutControl | WinForms 레이아웃 컨테이너 아티팩트 — TO-BE 는 SearchArea/Grid layout(D00-1-044)으로 흡수 | 해당없음 |
| D00-1-046 | §1 usrLayoutControl2 / UsrLayoutControl | WinForms 레이아웃 컨테이너 아티팩트 — TO-BE 는 SearchArea/Grid layout 으로 흡수 | 해당없음 |

