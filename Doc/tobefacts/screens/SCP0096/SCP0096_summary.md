# SCP0096 — To-Be Fact Pack 요약

- page_key: `supply/shipment-working-day-osp` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 6 (미해결 0, 주석 속 1) · 이벤트 14 · 컴포넌트 사용 21 · 하드코딩 컬럼 6 · 메시지 15
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 6건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | component | 214 |
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | component | 372 |
| features/supply/src/pages/shipment-working-day-osp/index.ts | index | 2 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.constants.ts | constants | 138 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | other | 60 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.types.ts | types | 95 |
| features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | page | 396 |
| features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | store | 177 |
| features/supply/src/pages/shipment-working-day-osp/__asis-mapping__.md | mapping | 116 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentWorkingDayOspForm.tsx:59 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentWorkingDayOspForm.tsx:62 |
| SCP0096/Shipment Working Day OSP//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:83 |
| /SCP0096/Shipment Working Day OSP/SAVE/call-proc | http | 1 | Y | ShipmentWorkingDayOsp.tsx:209 |
| /admin/menu/SCP0096/column | http | 1 | Y | useShipmentWorkingDayOspStore.ts:130 |
| /admin/menu/SCP0096/search-conditions | http | 1 | Y | useShipmentWorkingDayOspStore.ts:155 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 105 |
| SearchArea | onSearch | onSubmit | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 123 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,onDivisionChange | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 137 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 161 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 174 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 192 |
| Button | onClick | onInput | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 204 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 253 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 263 |
| g | updatedLayout | onLayout | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 318 |
| f | filterApplied | onFilterApplied | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 348 |
| ShipmentWorkingDayOspForm | onSubmit | handleSearch | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 360 |
| ShipmentWorkingDayOspForm | onDivisionChange | resetGrid | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 361 |
| ShipmentWorkingDayOspForm | onInput | handleInputValue | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 362 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| CustomDropdown | 4 |
| SearchArea | 1 |
| PeriodField | 1 |
| Button | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentWorkingDayOspForm | 1 |
| SubTitle | 1 |
| ShipmentWorkingDayOspGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | col.colNm | col.colLblNm \|\| col.colNm | col.colWth ?? 100 | col.visible !== false |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 90 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 114 |
| leaf | dc.binding | dc.dayLabel \|\| dc.binding.slice(2) | 56 | true |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 147 |
| sumGroups | s.binding | s.header | 80 | showSum |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 188 |
| buildDynSumColumns | name | name.replace(/^W_/, '') |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | 52 |
| buildDynSumColumns | name | `${ym.slice(0, 4)}-${ym.slice(4, 6)}` |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | 55 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00135 | 1 |
| MSG00134 | 1 |
| MSG00050 | 1 |
| MSG00004 | 1 |
| MSG00137 | 1 |
| MSG00152 | 1 |
| MSG00618 | 1 |
| LBL00112 | 1 |
| LBL00641 | 1 |
| LBL00005 | 1 |
| LBL00013 | 1 |
| LBL01067 | 1 |
| LBL01084 | 1 |
| LBL00872 | 1 |
| LBL00687 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0019(13), SCP0096(4), DMF0014(4), DMF0048(1), DMF0021(1), SCP0120(1), SSP0025(1), SCP0025(1)
- SP/PKG: PKG_SCP0096(8), P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(5), P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP(3), PKG_COM0000(3), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(3), P_USER_ID(2), P_MEASURE(2), P_ACTION(1), P_DIVISION_ID(1), P_PLANT_SITE_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 공백): 버튼은 노출하되 클릭 무동작. 무동작 함수 () => undefined 로 배선한다 — false 면 버튼이 숨겨지고 | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 247 |
| code | Form 이 버튼 disabled 로 차단(:710-713 return) → 형식(Y/N, MSG00050) → #4 SelectDay 셀 미선택(MSG00134). | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 264 |
| endpoint | ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 6행, admin 즉시 반영). | features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | 127 |

## 10. __asis-mapping__.md 상태
- 구현: 46
- 제외: 22
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-012 | §1 usrLayoutControl2 / UsrLayoutControl | AS-IS DevExpress 레이아웃 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-1-013 | §1 layoutControlGroup2 / LayoutControlGroup | AS-IS DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE Grid size 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-014 | §1 components / Container | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-015 | §1 layoutControlItem1 / LayoutControlItem | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-016 | §1 layoutControlItem2 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-018 | §1 layoutControlItem4 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-019 | §1 layoutControlItem7 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-020 | §1 layoutControlItem10 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-022 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-023 | §1 emptySpaceItem2 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-024 | §1 emptySpaceItem3 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-025 | §1 emptySpaceItem4 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-026 | §1 emptySpaceItem5 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-027 | §1 emptySpaceItem6 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-028 | §1 emptySpaceItem9 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-029 | §1 emptySpaceItem10 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-2-006 | §2 spdMain / CellDoubleClick (.cs:817-819) | SetDblClickColumnShowHide(컬럼 접기/펼치기) — D00-3-032 와 동일 신호, AS-IS 부가기능(핵심 CRUD 무관)으로 미이식. 향후 요구 시 재설계 | 제외 |
| D00-3-015 | §3 SwitchLock / 286 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-020 | §3 LockColumn / 405 (spdInfo 제목시트 잠금) | 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구조적으로 편집 불가 | 제외 |
| D00-3-022 | §3 LockColumn / 472 (조회 직후 전열 잠금) | 미이식(2026-09-29, convert-core §2.4 규범 준수) — 조회 직후 개별 잠금 호출 없음. Grid 는 `editMode`(=`canEdit` 권한) off 일 때 전 셀 잠금(권한 없으면 읽기전용) 으로 동등 대체 | 제외 |
| D00-3-032 | §3 SetDblClickColumnShowHide / 819 | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식. 향후 요구 시 재설계 | 제외 |

