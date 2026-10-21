# SCP0096 — To-Be Fact Pack 요약

- page_key: `supply/shipment-working-day-osp` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 14 · 컴포넌트 사용 21 · 하드코딩 컬럼 8 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 8건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspForm.tsx | component | 214 |
| features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | component | 389 |
| features/supply/src/pages/shipment-working-day-osp/hooks/useShipmentWorkingDayOspInputValue.ts | hook | 131 |
| features/supply/src/pages/shipment-working-day-osp/index.ts | index | 2 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.constants.ts | constants | 186 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | other | 41 |
| features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.types.ts | types | 106 |
| features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | page | 400 |
| features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | store | 239 |
| features/supply/src/pages/shipment-working-day-osp/__asis-mapping__.md | mapping | 153 |
| features/supply/src/pages/shipment-working-day-osp/__tests__/ShipmentWorkingDayOsp.spec.ts | test | 134 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentWorkingDayOspForm.tsx:59 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentWorkingDayOspForm.tsx:62 |
| SCP0096/dayRange//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:100 |
| SCP0096/Shipment Working Day OSP//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:115 |
| SCP0096/calendar//call-proc | hook | 1 | Y | ShipmentWorkingDayOsp.tsx:133 |
| /SCP0096/Shipment Working Day OSP/SAVE/call-proc | http | 1 | Y | ShipmentWorkingDayOsp.tsx:292 |
| /admin/menu/SCP0096/column | http | 1 | Y | useShipmentWorkingDayOspStore.ts:177 |
| /admin/menu/SCP0096/search-conditions | http | 1 | Y | useShipmentWorkingDayOspStore.ts:202 |

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
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 270 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 280 |
| g | updatedLayout | onLayout | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 335 |
| f | filterApplied | onFilterApplied | addHandler | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 365 |
| ShipmentWorkingDayOspForm | onSubmit | handleSearch | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 372 |
| ShipmentWorkingDayOspForm | onDivisionChange | resetGrid | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 373 |
| ShipmentWorkingDayOspForm | onInput | handleInputValue | jsx | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 374 |

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
| mergedColumns | col.colNm | col.colLblNm \|\| col.colNm | col.colWth ?? 100 | col.visible !== false |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 102 |
| mainStaticColumns | c.binding | c.header | c.width | true |  |  | meta-map | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 127 |
| leaf | dc.binding | dc.dayLabel \|\| dc.binding.slice(2) | 50 | true |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 164 |
| sumGroups | s.binding | s.header | 80 | showSum |  |  | object | features/supply/src/pages/shipment-working-day-osp/components/ShipmentWorkingDayOspGrid.tsx | 206 |
| buildDynSumColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | String(r.COLUMN_LABEL_NAME ?? '') \|\| binding.slice(2) |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/shipment-working-day-osp.dynamic-columns.ts | 35 |
|  | M_202611 | 2026-11 |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/__tests__/ShipmentWorkingDayOsp.spec.ts | 78 |
|  | W_20261144 | W44 |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/__tests__/ShipmentWorkingDayOsp.spec.ts | 79 |
|  | W_20261145 | W45 |  |  |  |  | object | features/supply/src/pages/shipment-working-day-osp/__tests__/ShipmentWorkingDayOsp.spec.ts | 80 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00662 | 2 |
| MSG01154 | 2 |
| MSG01153 | 2 |
| MSG00429 | 1 |
| MSG00097 | 2 |
| MSG00108 | 2 |
| MSG01037 | 1 |
| MSG00460 | 1 |
| MSG00672 | 2 |
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
| MSG00004 | 1 |
| MSG00135 | 1 |
| MSG00134 | 1 |
| MSG00050 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0096(11), SCP0019(8), SCP0095(7), DMF0014(4), SYS0013(2), SCP0010(1), SCP0031(1), SSP0015(1), DMF0048(1), DMF0021(1), SCP0120(1), SSP0025(1), SCP0025(1)
- SP/PKG: PKG_COM0000(11), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(9), PKG_SCP0096(7), P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(5), P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP(3), P_SCM0001_GET_SCP_MONTH_PERIOD(3), P_USER_ID(2), P_MEASURE(2), SCP0009_GET_SHEET_CALENDAR_3SPAN(1), SCM0001_GET_SCP_MONTH_PERIOD(1), P_ACTION(1), P_DIVISION_ID(1), P_PLANT_SITE_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | → DayWeek 값 없으면 Form 이 버튼 disabled 로 차단(:710-713 return) → Input Value 미선택(MSG00429) → #4 SelectDay 셀 미선택 | features/supply/src/pages/shipment-working-day-osp/hooks/useShipmentWorkingDayOspInputValue.ts | 31 |
| code | 편집 권한 없음 — 읽기전용 사용자는 D_ 셀이 잠겨 있다. AS-IS 는 같은 분기에서 MSG00135 를 띄우므로(무메시지 return 아님) | features/supply/src/pages/shipment-working-day-osp/hooks/useShipmentWorkingDayOspInputValue.ts | 52 |
| code | = 기능 비활성(10_RULES_KEEP F1 "빈 본문 override = 비활성" · screen-completion-gate G2 "() => undefined 빈 핸들러 0건") | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 337 |
| code | (2026-10-20 정정: 이전 '() => undefined 노출·무동작' 은 위 두 룰과 admin 메타에 어긋났다.) | features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx | 340 |
| endpoint | ui-dynamic-property-management — Column 동적 fetch (SCM_MST_SHEET_COLUMNS 6행, admin 즉시 반영). | features/supply/src/pages/shipment-working-day-osp/useShipmentWorkingDayOspStore.ts | 174 |

## 10. __asis-mapping__.md 상태
- 구현: 53
- 제외: 27
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-005 | §1 chkSum / UsrCheckBox | AS-IS Designer `this.chkSum.Visible = false`(:346)·Checked=false(.cs:121) — 사용자에게 보이지 않는 컨트롤. 3SPAN 은 W_/M_ 행을 주고 AS-IS 는 그 열을 만들되 SetSpreadColumn(.cs:353-356)이 항상 숨긴다(GET SP 데이터엔 W_/M_ 값 없음) = 토글 동작 없음(#138). 2026-10-20 2차 보완(원장 S96-13) Sum 버튼 제거 · 3차 보완: 합계 열 원천을 3SPAN 으로 정정(숨김 유지) | 제외 |
| D00-1-012 | §1 usrLayoutControl2 / UsrLayoutControl | AS-IS DevExpress 레이아웃 컨테이너 = TO-BE SearchArea/Grid 로 대체(레이아웃 프리미티브는 화면 요소 아님) | 제외 |
| D00-1-013 | §1 layoutControlGroup2 / LayoutControlGroup | AS-IS DevExpress 레이아웃 그룹 컨테이너 — 표현 전용, TO-BE Grid size 로 흡수(비즈니스 신호 아님) | 제외 |
| D00-1-014 | §1 components / Container | WinForms 디자이너 IContainer(비가시 컴포넌트 컨테이너) — UI 신호 아님 | 제외 |
| D00-1-015 | §1 layoutControlItem1 / LayoutControlItem | DevExpress 레이아웃 아이템(래퍼) — 실제 컨트롤은 §1 개별 행에 대사됨, 래퍼는 표현 전용 | 제외 |
| D00-1-016 | §1 layoutControlItem2 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-017 | §1 layoutControlItem3 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-018 | §1 layoutControlItem4 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-019 | §1 layoutControlItem7 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-020 | §1 layoutControlItem10 / LayoutControlItem | DevExpress 레이아웃 아이템 래퍼 — 표현 전용 | 제외 |
| D00-1-021 | §1 layoutSum / LayoutControlItem | chkSum(D00-1-005) 배치 래퍼 — chkSum 자체가 Designer Visible=false(:346) 비노출이라 래퍼도 화면 요소 아님(2026-10-20 정정) | 제외 |
| D00-1-022 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-023 | §1 emptySpaceItem2 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-024 | §1 emptySpaceItem3 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-025 | §1 emptySpaceItem4 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-026 | §1 emptySpaceItem5 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-027 | §1 emptySpaceItem6 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-028 | §1 emptySpaceItem9 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-1-029 | §1 emptySpaceItem10 / EmptySpaceItem | 레이아웃 여백 스페이서 — UI 신호 아님 | 제외 |
| D00-2-004 | §2 chkSum / CheckedChanged (.cs:324-337) | AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자가 토글할 수 없는 컨트롤이라 CheckedChanged 가 발생하지 않음 = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). W_/M_ 합계 열 자체는 3SPAN 으로 생성·숨김(D00-1-005). 2026-10-20 2차 보완(원장 S96-13) | 제외 |
| D00-2-006 | §2 spdMain / CellDoubleClick (.cs:817-819) | SetDblClickColumnShowHide(컬럼 접기/펼치기) — D00-3-032 와 동일 신호, AS-IS 부가기능(핵심 CRUD 무관)으로 미이식. 향후 요구 시 재설계 | 제외 |
| D00-3-015 | §3 SwitchLock / 286 | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 단 기존행 재편집 시 잠금 범위 재현 여부는 별도 검증 필요 | 제외 |
| D00-3-019 | §3 Visible= / 352 (chkSum SUM 토글) | AS-IS Designer `this.chkSum.Visible = false`(:346) — 사용자에게 보이지 않는 컨트롤 + AS-IS MSSQL SP·사내 Oracle GET SP 모두 D_ 일자열만 PIVOT(W_/M_ SUM 열 미생성) = 살아있는 동작 없음(#138, feedback_asis_delta_apply_criteria). 2026-10-20 2차 보완(원장 S96-13): Sum 커스텀 버튼 제거, Grid SUM 처리 코드는 showSum=false 로 비활성 보존 | 제외 |
| D00-3-020 | §3 LockColumn / 405 (spdInfo 제목시트 잠금) | 제목/헤더 시트 편집 불가 = TO-BE 는 헤더가 columnGroups 표현 전용(편집 대상 아님) — 구조적으로 편집 불가 | 제외 |
| D00-3-022 | §3 LockColumn / 472 (조회 직후 전열 잠금) | 미이식(2026-09-29, convert-core §2.4 규범 준수) — 조회 직후 개별 잠금 호출 없음. Grid 는 `editMode`(=`canEdit` 권한) off 일 때 전 셀 잠금(권한 없으면 읽기전용) 으로 동등 대체 | 제외 |
| D00-3-032 | §3 SetDblClickColumnShowHide / 819 | 더블클릭 컬럼 접기/펼치기 — AS-IS 부가기능(핵심 조회/편집/저장 무관), 전 화면 pivot 편의기능 미이식. 향후 요구 시 재설계 | 제외 |
| D00-4-007 | §4 DM.DM0003_GET_BUCKET_TYPE_CODE / DM0003_GET_BUCKET_TYPE_CODE (GetBucketType .cs:136,388-399) | dtBucketType 은 InitControls 에서 적재만 되고 소비 코드(cboBucketType_SelectedIndexChanged .cs:304-318 미배선 · SetSpreadColumn 분기 .cs:346-384 주석)가 전부 죽어 있음 — 살아있는 동작 없음(#138). PKG_SCP0096.P_DM0003_GET_BUCKET_TYPE_CODE 는 2026-10-19 이식분 보존(미호출) | 제외 |

