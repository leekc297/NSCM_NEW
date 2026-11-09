# SCP0016 — To-Be Fact Pack 요약

- page_key: `supply/waterfall-shipment-plan-fg` · feature: supply · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 17 · 컴포넌트 사용 27 · 하드코딩 컬럼 2 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | component | 292 |
| features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | component | 340 |
| features/supply/src/pages/waterfall-shipment-plan-fg/index.ts | index | 2 |
| features/supply/src/pages/waterfall-shipment-plan-fg/useWaterfallShipmentPlanFgStore.ts | store | 339 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.columns.ts | util | 259 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.derive.test.ts | test | 104 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.derive.ts | util | 85 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.merge.ts | util | 118 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.periods.test.ts | test | 80 |
| features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.periods.ts | util | 100 |
| features/supply/src/pages/waterfall-shipment-plan-fg/waterfall-shipment-plan-fg.constants.ts | constants | 128 |
| features/supply/src/pages/waterfall-shipment-plan-fg/waterfall-shipment-plan-fg.types.ts | types | 21 |
| features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.module.scss | style | 12 |
| features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | page | 342 |
| features/supply/src/pages/waterfall-shipment-plan-fg/__asis-mapping__.md | mapping | 222 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | WaterfallShipmentPlanFgForm.tsx:63 |
| (useTabLookupQueries) | hook | 1 | Y | WaterfallShipmentPlanFgForm.tsx:71 |
| SCP0016/spreadTitle//call-proc | hook | 1 | Y | WaterfallShipmentPlanFgGrid.tsx:67 |
| SCP0016/spreadTitleIso//call-proc | hook | 1 | Y | WaterfallShipmentPlanFgGrid.tsx:75 |
| /admin/menu/SCP0016/column | http | 1 | Y | useWaterfallShipmentPlanFgStore.ts:250 |
| /admin/menu/SCP0016/measure | http | 1 | Y | useWaterfallShipmentPlanFgStore.ts:277 |
| /admin/menu/SCP0016/search-conditions | http | 1 | Y | useWaterfallShipmentPlanFgStore.ts:315 |
| SCP0016/main//call-proc | hook | 1 | Y | WaterfallShipmentPlanFg.tsx:91 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId fromYyyymmdd toYyyymmdd bizType projectCode itemId versionNo electype programId sheetName | o_rc1 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SCP0016 |
| spreadTitle | startYyyymmdd endYyyymmdd | o_rc1 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SCP0016 |
| spreadTitleIso | startYyyymmdd endYyyymmdd | o_rc1 | PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO P_USER_ID SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SCP0016 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 167 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 196 |
| Button | onClick | onOpen | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 192 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 207 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 262 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgForm.tsx | 281 |
| g | updatedLayout | applyDynVisibility | addHandler | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | 153 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | 187 |
| g | scrollPositionChanged | onScroll | addHandler | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | 221 |
| host | dblclick | onDblClick | addEventListener | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | 278 |
| g | formatItem | handler | addHandler | features/supply/src/pages/waterfall-shipment-plan-fg/components/WaterfallShipmentPlanFgGrid.tsx | 311 |
| WaterfallShipmentPlanFgForm | onSearch | handleSearch | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 250 |
| WaterfallShipmentPlanFgForm | onModelSearch | <arrow> setOpenModel | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 251 |
| WaterfallShipmentPlanFgForm | onProjectSearch | <arrow> setOpenProject | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 252 |
| ColumnLayoutModal | onSave | handleSaveColumnLayout | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 328 |
| MeasureSelectModal | onApply | handleApplyMeasures | jsx | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 337 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 2 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| WaterfallShipmentPlanFgForm | 1 |
| SubTitle | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| WaterfallShipmentPlanFgGrid | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | m.binding | SUM | 100 | baseVisibleOf(bucket, chkSum, m.kind, isIsoWeek(m.binding)) |  |  | object | features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.columns.ts | 177 |
| buildDynamicColumns | m.binding | rank === 2 ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | baseVisibleOf(bucket, chkSum, m.kind, isIsoWeek(m.binding)) |  |  | object | features/supply/src/pages/waterfall-shipment-plan-fg/utils/waterfall.columns.ts | 218 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG00429 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00038 | 1 |
| LBL00606 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL00012 | 1 |
| LBL00687 | 1 |
| LBL00112 | 1 |
| LBL00605 | 1 |
| LBL00310 | 1 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 2 |
| MSG00606 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0016(12), SCP0017(11), SCP0018(8), SCP0025(1)
- SP/PKG: PKG_COM0000(4), PKG_SCP0016(3), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(3), P_DIVISION_ID(2), SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO(1), SCM0001_GET_SCP_MONTH_PERIOD(1), PR_GET_SHEET_MEASURE_LIST(1), P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | - 저장 없음(읽기전용, EditButton=MSG00109 후 return · SaveButton NO-OP · Insert/Delete 미노출) | features/supply/src/pages/waterfall-shipment-plan-fg/waterfall-shipment-plan-fg.constants.ts | 8 |
| endpoint | 컬럼/Measure 메타 fetch(mount 1회) + keep-alive 잔여 filters 무효화(자동조회 금지, nscm-patterns §5-7) | features/supply/src/pages/waterfall-shipment-plan-fg/WaterfallShipmentPlanFg.tsx | 78 |

## 10. __asis-mapping__.md 상태
- 구현: 67
- 해당없음: 20
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-017 | §1 usrLayoutControl2 / UsrLayoutControl | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-018 | §1 layoutControlGroup2 / LayoutControlGroup | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-019 | §1 lblCombo1 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-020 | §1 lblCombo / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-021 | §1 lblProject / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-022 | §1 lblItemId / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-023 | §1 lblBucket / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-024 | §1 lciSum / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-025 | §1 layoutControlItem1 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-026 | §1 layoutControlItem2 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-027 | §1 layoutControlItem3 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-028 | §1 layoutControlItem4 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-029 | §1 layoutControlItem5 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-030 | §1 layoutControlItem6 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-031 | §1 layoutControlItem7 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-032 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-033 | §1 emptySpaceItem2 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-034 | §1 emptySpaceItem3 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-035 | §1 components / Container | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체(별도 컨트롤 아님) | 해당없음 |
| D00-1-036 | §1 usrButton1 / UsrButton | AS-IS Designer 잔존 미사용 버튼 — 화면 로직·toolbarOverride·event 어디에도 배선 없음(00_checklist §2 이벤트 목록에 usrButton1 핸들러 부재). TO-BE 미노출 | 해당없음 |

