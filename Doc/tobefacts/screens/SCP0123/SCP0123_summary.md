# SCP0123 — To-Be Fact Pack 요약

- page_key: `supply/plan-control` · feature: supply · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 15 (미해결 3, 주석 속 1) · 이벤트 27 · 컴포넌트 사용 51 · 하드코딩 컬럼 0 · 메시지 27
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | component | 47 |
| features/supply/src/pages/plan-control/components/PlanControlForm.tsx | component | 198 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.module.scss | component | 44 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | component | 195 |
| features/supply/src/pages/plan-control/components/PlanIdCreatePopup.module.scss | component | 84 |
| features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | component | 562 |
| features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | hook | 503 |
| features/supply/src/pages/plan-control/hooks/usePlanControlPolling.ts | hook | 128 |
| features/supply/src/pages/plan-control/index.ts | index | 2 |
| features/supply/src/pages/plan-control/plan-control.constants.ts | constants | 200 |
| features/supply/src/pages/plan-control/plan-control.types.ts | types | 52 |
| features/supply/src/pages/plan-control/PlanControl.module.scss | style | 49 |
| features/supply/src/pages/plan-control/PlanControl.tsx | page | 266 |
| features/supply/src/pages/plan-control/usePlanControlStore.ts | store | 195 |
| features/supply/src/pages/plan-control/utils/planControl.activity.test.ts | test | 121 |
| features/supply/src/pages/plan-control/utils/planControl.activity.ts | util | 74 |
| features/supply/src/pages/plan-control/__asis-mapping__.md | mapping | 298 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {?{comboId:'LookupCommon',lookupType:SYS_PROD_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:112 |
| {?{comboId:'LookupCommon',lookupType:SYS_SHIP_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:113 |
| {?{comboId:'LookupCommon',lookupType:GM_DIVISION_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:114 |
| SCP0123/planIdInfo/SEARCH/call-proc | callProc | 1 | Y | PlanIdCreatePopup.tsx:116 |
| /SCP0123/planIdCreate/SAVE/call-proc | http | 1 | Y | PlanIdCreatePopup.tsx:277 |
| SCP0123/planControl/SEARCH/call-proc | callProc | 2 | Y | usePlanControlCellActions.ts:134 usePlanControlCellActions.ts:474 |
| /SCP0123/planControl/SAVE/call-proc | http | 1 | Y | usePlanControlCellActions.ts:178 |
| SCP0123/planControl//call-proc | hook | 2 | Y | usePlanControlPolling.ts:81 PlanControl.tsx:130 |
| SCP0123/engineRun//call-proc | hook | 1 | Y | usePlanControlPolling.ts:90 |
| (useTabComboQueries) | hook | 1 | Y | PlanControl.tsx:87 |
| SCP0123/searchInfo//call-proc | hook | 1 | Y | PlanControl.tsx:96 |
| /admin/menu/SCP0123/column | http | 1 | Y | usePlanControlStore.ts:77 |
| /admin/menu/SCP0123/search-conditions | http | 1 | Y | usePlanControlStore.ts:177 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| planControl | divisionId planGroupId planStartYyyymmdd actvCd planId | planControl | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| engineRun | divisionId planGroupId planStartYyyymmdd actvCd planId | engineRun | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| searchInfo | userId | planGroupList | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| planIdInfo | divisionId planGroupId planStartYyyymmdd planId | horizonInfo frozenInfo fpPlanList scpPlanList planInfo | P_SCP0123_GET_PLAN_ID_INFO PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| planIdCreate | divisionId planGrId planGrName prsCd planStartYyyymmdd planEndYyyymmdd dmdVerId prodRefSysDivsCd prodRefSysPlanId prodFrzStartYyyymmdd prodFrzEndYyyymmdd cellProdFrzStartYyyymmdd cellProdFrzEndYyyymmdd shipRefSysDivsCd shipRefSysPlanId shipFrzStartYyyymmdd shipFrzEndYyyymmdd pramTyCd planDesc prodNoFrzYn cellNoFrzYn shipNoFrzYn sesUserId |  | P_SCP0123_SAVE_PLAN_ID_CREATE PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | 44 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 114 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 155 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 187 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 143 |
| grid | formatItem | handleFormatItem | addHandler | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 144 |
| grid.hostElement | keydown | blockComboCellKey | addEventListener | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 170 |
| DataGrid | cellEditEnded | cellEditEnded | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 189 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 190 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 191 |
| DatePickerCalendar | onChange | <arrow> onChange | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 337 |
| Checkbox | onChange | onToggleNoFrozen | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 362 |
| CustomDropdown | onChange | <arrow> handleProdCdChange,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 422 |
| CustomDropdown | onChange | <arrow> setProdPlanId,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 448 |
| CustomDropdown | onChange | <arrow> handleShipCdChange,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 483 |
| CustomDropdown | onChange | <arrow> setShipPlanId,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 509 |
| InputField | onChange | <arrow> setDesc | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 531 |
| Button | onClick | <arrow> saveData | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 546 |
| Button | onClick | closeAndReset | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 554 |
| PlanControlForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 204 |
| PlanControlGrid | cellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 236 |
| PlanControlGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 237 |
| EngineRunGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 251 |
| PlanIdCreatePopup | onClose | <arrow> setPlanIdCreateContext | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 260 |
| PlanIdCreatePopup | onSaved | <arrow> queryClient.invalidateQueries | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 261 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 15 |
| CustomDropdown | 7 |
| InputField | 5 |
| Grid | 3 |
| DataGrid | 2 |
| DatePickerCalendar | 2 |
| Button | 2 |
| Panel | 2 |
| SearchArea | 1 |
| Checkbox | 1 |
| CustomDialog | 1 |
| MainTitle | 1 |
| PlanControlForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PlanControlGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| EngineRunGrid | 1 |
| PlanIdCreatePopup | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL01149 | 2 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00039 | 1 |
| LBL00014 | 1 |
| LBL00112 | 1 |
| MSG00667 | 1 |
| MSG01125 | 1 |
| MSG01122 | 1 |
| MSG01456 | 1 |
| MSG01197 | 1 |
| MSG01438 | 1 |
| MSG01439 | 1 |
| MSG01441 | 1 |
| MSG01442 | 1 |
| MSG00003 | 1 |
| MSG01479 | 1 |
| MSG01480 | 1 |
| MSG01481 | 1 |
| MSG01482 | 1 |
| MSG01483 | 1 |
| MSG01484 | 1 |
| MSG00108 | 1 |
| MSG01465 | 1 |
| MSG01466 | 1 |
| MSG01467 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0039(5), SCP0122(2), SCP0123(2), SCP0025(1), SCP0108(1), SCP0020(1), SCM0005(1), SYS0013(1), SCP0100(1), SSP0021(1)
- SP/PKG: PKG_SCP0123(4), P_USER_ID(2), P_SCP0123_GET_PLAN_ID_INFO(2), P_SCP0123_GET_PLAN_CONTROL(1), P_SCP0123_SAVE_PLAN_ACTV_RUN(1), P_SCP0123_PLAN_ID_INFO_GET(1), P_SCP0123_PLAN_ID_SAVE(1), P_SCP0123_SAVE_PLAN_ID_CREATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | <DataGrid formatItem={...}> prop 이 아니라 아래 effect 에서 gridRef 에 직접 addHandler 한다 — | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 63 |
| jsx | <DataGrid beginningEdit={...}> prop 으로 넘기지 않는다 — DataGrid 의 setEditableColumns | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 120 |
| code | confirm 은 Promise<boolean> — "No" 면 그 자리에서 중단한다(AS-IS DialogResult.No return). | features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | 85 |
| endpoint | 일단위 판정 집합의 조회 경로. useTabLookupQueries(admin/lookup)를 쓰면 응답 컬럼명이 | features/supply/src/pages/plan-control/plan-control.constants.ts | 58 |
| code | removeRow 가 살아나 AS-IS 에 없던 행 추가·삭제가 실제로 동작한다. () => undefined 로 버튼만 렌더하고 | features/supply/src/pages/plan-control/PlanControl.tsx | 177 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

