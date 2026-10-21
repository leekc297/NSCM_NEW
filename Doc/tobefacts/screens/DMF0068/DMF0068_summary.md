# DMF0068 — To-Be Fact Pack 요약

- page_key: `demand/demand-manager` · feature: demand · As-is Fact Pack 없음(화면ID 미대응)
- 파일 19 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 24 · 컴포넌트 사용 33 · 하드코딩 컬럼 2 · 메시지 22
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/demand/src/pages/demand-manager/components/DemandManagerForm.module.scss | component | 71 |
| features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | component | 117 |
| features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | component | 422 |
| features/demand/src/pages/demand-manager/components/modals/index.ts | index | 2 |
| features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | component | 350 |
| features/demand/src/pages/demand-manager/components/modals/versionPopupModalStore.ts | store | 46 |
| features/demand/src/pages/demand-manager/demand-manager.constants.ts | constants | 124 |
| features/demand/src/pages/demand-manager/demand-manager.types.ts | types | 78 |
| features/demand/src/pages/demand-manager/DemandManager.module.scss | style | 79 |
| features/demand/src/pages/demand-manager/DemandManager.tsx | page | 381 |
| features/demand/src/pages/demand-manager/index.ts | index | 2 |
| features/demand/src/pages/demand-manager/useDemandManagerStore.ts | store | 203 |
| features/demand/src/pages/demand-manager/utils/demand-manager.api.ts | api | 64 |
| features/demand/src/pages/demand-manager/utils/demand-manager.insertAnchor.ts | util | 12 |
| features/demand/src/pages/demand-manager/utils/demand-manager.merge.ts | util | 108 |
| features/demand/src/pages/demand-manager/utils/demand-manager.months.ts | util | 56 |
| features/demand/src/pages/demand-manager/utils/demand-manager.save.ts | util | 91 |
| features/demand/src/pages/demand-manager/utils/demand-manager.validate.ts | util | 87 |
| features/demand/src/pages/demand-manager/__asis-mapping__.md | mapping | 105 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | VersionPopupModal.tsx:71 |
| DMF0068/versionPopup//call-proc | hook | 1 | Y | VersionPopupModal.tsx:111 |
| DMF0068/ContributeSalesList//call-proc | hook | 1 | Y | DemandManager.tsx:73 |
| DMF0068/lookupProject//call-proc | hook | 1 | Y | DemandManager.tsx:82 |
| /admin/menu/DMF0068/search-conditions | http | 1 | Y | useDemandManagerStore.ts:105 |
| /admin/menu/DMF0068/column | http | 1 | Y | useDemandManagerStore.ts:177 |
| /DMF0068/ContributeSalesList/SAVE/call-proc | http | 1 | Y | demand-manager.api.ts:49 |
| /DMF0068/ContributeSalesList/DELETE/call-proc | http | 1 | Y | demand-manager.api.ts:58 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| ContributeSalesList | divisionId versionNo fromDt toDt | o_rc1 o_rc2 | PKG_DMF0068 P_DMF0068_GET_ORDERLIST P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP P_DMF0068_GET_LOOKUPPROJECT P_DMF0068_SAVE_ORDERLIST_JSON P_DMF0068_DEL_ORDERLIST_JSON |
| versionPopup | startYyyymmdd endYyyymmdd divisionId versionType description | o_rc1 | PKG_DMF0068 P_DMF0068_GET_ORDERLIST P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP P_DMF0068_GET_LOOKUPPROJECT P_DMF0068_SAVE_ORDERLIST_JSON P_DMF0068_DEL_ORDERLIST_JSON |
| lookupProject | divisionId versionNo | o_rc1 | PKG_DMF0068 P_DMF0068_GET_ORDERLIST P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP P_DMF0068_GET_LOOKUPPROJECT P_DMF0068_SAVE_ORDERLIST_JSON P_DMF0068_DEL_ORDERLIST_JSON |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | 37 |
| InputField | onChange | <arrow> onChangeVersion | jsx | features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | 59 |
| Button | onClick | onOpenVersionModal | jsx | features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | 65 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | 87 |
| DatePickerCalendar | onChange | <arrow> set,date?.format | jsx | features/demand/src/pages/demand-manager/components/DemandManagerForm.tsx | 101 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 227 |
| g | beginningEdit | beginningEditHandler | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 236 |
| g | pastingCell | beginningEditHandler | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 240 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 264 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 266 |
| g | updatedLayout | applyLayout | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 302 |
| f | filterApplied | onFilterApplied | addHandler | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 384 |
| g | formatItem | formatHandler | addHandler | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 215 |
| SearchArea | onSearch | <arrow> refetch | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 248 |
| PeriodField | onChange | <arrow> setSdt,setEdt | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 268 |
| CustomDropdown | onChange | <arrow> setVersionType,String | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 281 |
| InputField | onChange | <arrow> setDescription | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 294 |
| div | onDoubleClick | handleGridDoubleClick | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 304 |
| Button | onClick | adoptCurrentSelection | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 335 |
| Button | onClick | modalClose | jsx | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 342 |
| DemandManagerForm | onSearch | handleSearch | jsx | features/demand/src/pages/demand-manager/DemandManager.tsx | 345 |
| DemandManagerForm | onOpenVersionModal | <arrow> setOpenVersionModal | jsx | features/demand/src/pages/demand-manager/DemandManager.tsx | 346 |
| DemandManagerForm | onChangeVersion | <arrow> setSearchCondition | jsx | features/demand/src/pages/demand-manager/DemandManager.tsx | 347 |
| VersionPopupModal | onSelect | <arrow> setSearchCondition | jsx | features/demand/src/pages/demand-manager/DemandManager.tsx | 376 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| Button | 3 |
| SearchArea | 2 |
| InputField | 2 |
| DatePickerCalendar | 2 |
| DataGrid | 2 |
| CustomDropdown | 2 |
| FunctionSearchIcon | 1 |
| CustomDialog | 1 |
| PeriodField | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| MainTitle | 1 |
| DemandManagerForm | 1 |
| SubTitle | 1 |
| DemandManagerGrid | 1 |
| VersionPopupModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | m.binding | m.label | 100 | true |  |  | object | features/demand/src/pages/demand-manager/components/DemandManagerGrid.tsx | 128 |
| gridStaticColumns | c.key | c.header | c.width | true |  |  | meta-map | features/demand/src/pages/demand-manager/components/modals/VersionPopupModal.tsx | 127 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00513 | 1 |
| LBL00013 | 2 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00052 | 1 |
| LBL00608 | 1 |
| MSG00614 | 1 |
| MSG00672 | 1 |
| MSG01081 | 1 |
| MSG00699 | 1 |
| MSG00096 | 1 |
| MSG00700 | 1 |
| MSG01135 | 1 |
| MSG00113 | 1 |
| MSG00260 | 1 |
| MSG00701 | 1 |
| MSG00283 | 1 |
| MSG00618 | 1 |
| MSG00702 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: DMF0068(4), DMF0082(2), DMF0003(1)
- SP/PKG: PKG_DMF0068(9), P_DMF0068_GET_LOOKUPPROJECT(3), P_DMF0068_GET_ORDERLIST(3), P_DMF0068_SAVE_ORDERLIST_JSON(2), P_DMF0068_DEL_ORDERLIST_JSON(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 넣어야 했고, 그 탓에 제약을 못 맞춰 <DataGrid> 에 캐스팅을 붙여 왔다. | features/demand/src/pages/demand-manager/demand-manager.types.ts | 13 |
| endpoint | ⭐ master hook §2.3 — Column 동적 fetch (SHEET_COLUMNS 159건 'ContributeSalesList') | features/demand/src/pages/demand-manager/useDemandManagerStore.ts | 174 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

