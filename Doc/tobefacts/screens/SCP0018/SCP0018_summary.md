# SCP0018 — To-Be Fact Pack 요약

- page_key: `supply/waterfall-shipment-plan-semi` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 8 (미해결 0, 주석 속 0) · 이벤트 13 · 컴포넌트 사용 33 · 하드코딩 컬럼 2 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | component | 343 |
| features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiGrid.tsx | component | 342 |
| features/supply/src/pages/waterfall-shipment-plan-semi/index.ts | index | 2 |
| features/supply/src/pages/waterfall-shipment-plan-semi/useWaterfallShipmentPlanSemiStore.ts | store | 237 |
| features/supply/src/pages/waterfall-shipment-plan-semi/utils/waterfall-shipment-plan-semi.api.ts | api | 37 |
| features/supply/src/pages/waterfall-shipment-plan-semi/waterfall-shipment-plan-semi.constants.ts | constants | 71 |
| features/supply/src/pages/waterfall-shipment-plan-semi/waterfall-shipment-plan-semi.types.ts | types | 35 |
| features/supply/src/pages/waterfall-shipment-plan-semi/WaterfallShipmentPlanSemi.tsx | page | 186 |
| features/supply/src/pages/waterfall-shipment-plan-semi/__asis-mapping__.md | mapping | 71 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | WaterfallShipmentPlanSemiForm.tsx:47 WaterfallShipmentPlanSemiForm.tsx:59 |
| /admin/menu/SCP0018/column | http | 1 | Y | useWaterfallShipmentPlanSemiStore.ts:172 |
| /admin/menu/SCP0018/measure | http | 1 | Y | useWaterfallShipmentPlanSemiStore.ts:186 |
| /admin/menu/SCP0018/search-conditions | http | 1 | Y | useWaterfallShipmentPlanSemiStore.ts:213 |
| /SCP0018/titleSet/SAVE/call-proc | http | 1 | Y | waterfall-shipment-plan-semi.api.ts:26 |
| SCP0018/main//call-proc | hook | 1 | Y | WaterfallShipmentPlanSemi.tsx:52 |
| SCP0018/spreadTitle//call-proc | hook | 1 | Y | WaterfallShipmentPlanSemi.tsx:59 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | fromYyyymmdd toYyyymmdd divisionId operationGroup itemId versionNo electype programId sheetName userId | o_rc1 | PKG_SCP0018 P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL PKG_SCP0009 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |
| spreadTitle | startYyyymmdd endYyyymmdd userId | o_rc1 | PKG_SCP0018 P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL PKG_SCP0009 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |
| spreadTitleIso | startYyyymmdd endYyyymmdd userId | o_rc1 | P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO PKG_SCP0018 P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL PKG_SCP0009 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSubmit | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 129 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivisionTouched,setDivision | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 148 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 172 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 193 |
| Button | onClick | <arrow> setItemModalOpen | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 201 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 228 |
| CustomDropdown | onChange | <arrow> setSearchParams,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 260 |
| CustomDropdown | onChange | <arrow> setSearchParams,String,clearData | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 285 |
| PeriodField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 298 |
| Checkbox | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiForm.tsx | 314 |
| g | formatItem | handler | addHandler | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiGrid.tsx | 314 |
| WaterfallShipmentPlanSemiForm | onSubmit | handleSubmit | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/WaterfallShipmentPlanSemi.tsx | 148 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet,selected.map,clearData | jsx | features/supply/src/pages/waterfall-shipment-plan-semi/WaterfallShipmentPlanSemi.tsx | 173 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 5 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodField | 1 |
| Checkbox | 1 |
| MaterialByDivisionModal | 1 |
| DataGrid | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| WaterfallShipmentPlanSemiForm | 1 |
| SubTitle | 1 |
| WaterfallShipmentPlanSemiGrid | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| columns | m.binding | SUM | 100 | dynVisible(m.kind) | true |  | object | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiGrid.tsx | 197 |
| columns | m.binding | m.kind === 'D' ? m.leaf \|\| m.binding : 'SUM' | m.kind === 'B' ? 0 : undefined | dynVisible(m.kind) | true | m.kind === 'B' ? DataType.String : undefined | object | features/supply/src/pages/waterfall-shipment-plan-semi/components/WaterfallShipmentPlanSemiGrid.tsx | 234 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00109 | 1 |
| MSG00013 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00618 | 1 |
| LBL00038 | 1 |
| LBL00710 | 1 |
| LBL00606 | 1 |
| LBL00013 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |
| LBL00109 | 3 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0018(16), COM0013(2), SCP0016(2), SCP0025(2), DMF0053(1)
- SP/PKG: PKG_COM0000(3), SCM0001_GET_SCP_MONTH_PERIOD(2), PKG_SCP0009(2), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(2), PKG_SCP0018(2), P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO(1), SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 클릭 시 MSG00109 안내 후 무조건 NO-OP(단순 () => undefined 는 오답 — 메시지 재현 필수). | features/supply/src/pages/waterfall-shipment-plan-semi/WaterfallShipmentPlanSemi.tsx | 119 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

