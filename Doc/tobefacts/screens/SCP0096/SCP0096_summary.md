# SCP0096 — To-Be Fact Pack 요약

- page_key: `supply/shipment-working-day-osp` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 9 (미해결 0, 주석 속 1) · 이벤트 19 · 컴포넌트 사용 25 · 하드코딩 컬럼 6 · 메시지 19
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 6건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | component | 210 |
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | component | 444 |
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.module.scss | component | 13 |
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.tsx | component | 147 |
| features/supply/src/pages/shipment-working-day-osp/index.ts | index | 2 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.constants.ts | constants | 193 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | other | 70 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.types.ts | types | 113 |
| features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | page | 431 |
| features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | store | 187 |
| features/supply/src/pages/shipment-working-day-osp/__asis-mapping__.md | mapping | 116 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ShipmentWorkingDayOspForm.tsx:65 ShipmentWorkingDayOspInputModal.tsx:50 |
| SCP0096/dayRange//call-proc | hook | 1 | Y | ShipmentWorkingDayOspForm.tsx:89 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentWorkingDayOspInputModal.tsx:49 |
| SCP0096/Shipment Working Day OSP//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:86 |
| SCP0096/calendar//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:96 |
| /SCP0096/Shipment Working Day OSP/SAVE/call-proc | http | 1 | Y | ShipmentWorkingDayOsp.tsx:243 |
| /admin/menu/SCP0096/column | http | 1 | Y | useShipmentWorkingDayOspStore.ts:140 |
| /admin/menu/SCP0096/search-conditions | http | 1 | Y | useShipmentWorkingDayOspStore.ts:165 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 137 |
| SearchArea | onSearch | onSubmit | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 155 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,onDivisionChange | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 169 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | 194 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 266 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 276 |
| g | cellEditEnding | rangeGuardHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 291 |
| el | beforeinput | guardDefaultMaxOnInput | addEventListener | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 323 |
| g | prepareCellForEdit | prepareEditHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 325 |
| g | updatedLayout | onLayout | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 390 |
| f | filterApplied | onFilterApplied | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 420 |
| CustomDropdown | onChange | <arrow> setDayWeekCode,String | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.tsx | 102 |
| CustomDropdown | onChange | <arrow> setInputValue,String | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.tsx | 120 |
| Button | onClick | handleOk | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.tsx | 132 |
| Button | onClick | onClose | jsx | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspInputModal.tsx | 139 |
| ShipmentWorkingDayOspForm | onSubmit | handleSearch | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 397 |
| ShipmentWorkingDayOspForm | onDivisionChange | resetGrid | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 397 |
| ShipmentWorkingDayOspInputModal | onClose | <arrow> setInputModalOpen | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 425 |
| ShipmentWorkingDayOspInputModal | onConfirm | handleInputConfirm | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 426 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 4 |
| CustomDropdown | 4 |
| Button | 2 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| CustomDialog | 1 |
| MainTitle | 1 |
| ShipmentWorkingDayOspForm | 1 |
| SubTitle | 1 |
| ShipmentWorkingDayOspGrid | 1 |
| ShipmentWorkingDayOspInputModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| mergedColumns | col.colNm | col.colLblNm \|\| col.colNm | col.colWth ?? 100 | col.visible !== false |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 95 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 120 |
| leaf | dc.binding | dc.dayLabel \|\| dc.binding.slice(2) | 56 | true |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 158 |
| sumGroups | s.binding | s.header | 80 | showSum |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 201 |
| buildDynSumColumns | name | name.replace(/^W_/, '') |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | 62 |
| buildDynSumColumns | name | `${ym.slice(0, 4)}-${ym.slice(4, 6)}` |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | 65 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00662 | 1 |
| MSG00013 | 1 |
| MSG01153 | 1 |
| MSG00108 | 1 |
| MSG01082 | 1 |
| MSG00002 | 1 |
| MSG00137 | 1 |
| MSG00152 | 1 |
| MSG00618 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00013 | 1 |
| LBL01067 | 1 |
| LBL01084 | 1 |
| LBL00872 | 1 |
| LBL00687 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0096(12), SCP0019(10), SCP0010(3), DMF0014(3), DMF0048(1), DMF0021(1), SCP0120(1), SSP0025(1), SCP0025(1)
- SP/PKG: PKG_COM0000(8), PKG_SCP0096(8), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(6), P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(5), P_USER_ID(5), P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP(3), P_SCM0001_GET_SCP_MONTH_PERIOD(2), FN_MULTY_TIME(2), P_MEASURE(2), P_ACTION(1), P_DIVISION_ID(1), P_PLANT_SITE_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 공백): 버튼은 노출하되 클릭 무동작. 무동작 함수 () => undefined 로 배선한다 — false 면 버튼이 숨겨지고 | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 284 |
| endpoint | ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 6행, admin 즉시 반영). | features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | 137 |

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

