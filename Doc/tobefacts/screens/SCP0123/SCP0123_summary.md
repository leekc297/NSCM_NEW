# SCP0123 — To-Be Fact Pack 요약

- page_key: `supply/plan-control` · feature: supply · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 16 (미해결 3, 주석 속 1) · 이벤트 32 · 컴포넌트 사용 59 · 하드코딩 컬럼 0 · 메시지 27
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | component | 47 |
| features/supply/src/pages/plan-control/components/PlanControlForm.tsx | component | 198 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.module.scss | component | 44 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | component | 231 |
| features/supply/src/pages/plan-control/components/PlanIdCreatePopup.module.scss | component | 160 |
| features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | component | 892 |
| features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | hook | 504 |
| features/supply/src/pages/plan-control/hooks/usePlanControlPolling.ts | hook | 128 |
| features/supply/src/pages/plan-control/index.ts | index | 2 |
| features/supply/src/pages/plan-control/plan-control.constants.ts | constants | 212 |
| features/supply/src/pages/plan-control/plan-control.types.ts | types | 52 |
| features/supply/src/pages/plan-control/PlanControl.module.scss | style | 49 |
| features/supply/src/pages/plan-control/PlanControl.tsx | page | 276 |
| features/supply/src/pages/plan-control/usePlanControlStore.ts | store | 195 |
| features/supply/src/pages/plan-control/utils/planControl.activity.test.ts | test | 121 |
| features/supply/src/pages/plan-control/utils/planControl.activity.ts | util | 74 |
| features/supply/src/pages/plan-control/__asis-mapping__.md | mapping | 298 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {?{comboId:'LookupCommon',lookupType:SYS_PROD_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:145 |
| {?{comboId:'LookupCommon',lookupType:SYS_SHIP_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:146 |
| {?{comboId:'LookupCommon',lookupType:GM_DIVISION_LOOKUP_TYPE}} | http | 1 | N | PlanIdCreatePopup.tsx:147 |
| SCP0123/planIdInfo/SEARCH/call-proc | callProc | 1 | Y | PlanIdCreatePopup.tsx:149 |
| /SCP0123/planIdCreate82/SAVE/call-proc | http | 1 | Y | PlanIdCreatePopup.tsx:408 |
| /SCP0123/planIdCreate/SAVE/call-proc | http | 1 | Y | PlanIdCreatePopup.tsx:501 |
| SCP0123/planControl/SEARCH/call-proc | callProc | 2 | Y | usePlanControlCellActions.ts:134 usePlanControlCellActions.ts:475 |
| /SCP0123/planControl/SAVE/call-proc | http | 1 | Y | usePlanControlCellActions.ts:178 |
| SCP0123/planControl//call-proc | hook | 2 | Y | usePlanControlPolling.ts:81 PlanControl.tsx:136 |
| SCP0123/engineRun//call-proc | hook | 1 | Y | usePlanControlPolling.ts:90 |
| (useTabComboQueries) | hook | 1 | Y | PlanControl.tsx:93 |
| SCP0123/searchInfo//call-proc | hook | 1 | Y | PlanControl.tsx:102 |
| /admin/menu/SCP0123/column | http | 1 | Y | usePlanControlStore.ts:77 |
| /admin/menu/SCP0123/search-conditions | http | 1 | Y | usePlanControlStore.ts:177 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| planControl | divisionId planGroupId planStartYyyymmdd actvCd planId | planControl | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| engineRun | divisionId planGroupId planStartYyyymmdd actvCd planId | engineRun | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| searchInfo | userId | planGroupList | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| planIdInfo | divisionId planGroupId planStartYyyymmdd planId | horizonInfo frozenInfo fpPlanList scpPlanList planInfo pramTpList | P_SCP0123_GET_PLAN_ID_INFO PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| planIdCreate | divisionId planGrId planGrName prsCd planStartYyyymmdd planEndYyyymmdd dmdVerId prodRefSysDivsCd prodRefSysPlanId prodFrzStartYyyymmdd prodFrzEndYyyymmdd cellProdFrzStartYyyymmdd cellProdFrzEndYyyymmdd shipRefSysDivsCd shipRefSysPlanId shipFrzStartYyyymmdd shipFrzEndYyyymmdd pramTyCd planDesc prodNoFrzYn cellNoFrzYn shipNoFrzYn sesUserId |  | P_SCP0123_SAVE_PLAN_ID_CREATE PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| planIdCreate82 | divisionId planGrId planGrName prsCd planStartYyyymmdd planEndYyyymmdd dmdVerId prodRefSysDivsCd prodRefSysPlanId linkProdFrzStartYyyymmdd linkProdFrzEndYyyymmdd pmduProdFrzStartYyyymmdd pmduProdFrzEndYyyymmdd cellProdFrzStartYyyymmdd cellProdFrzEndYyyymmdd shipRefSysDivsCd shipRefSysPlanId linkShipFrzStartYyyymmdd linkShipFrzEndYyyymmdd pmduShipFrzStartYyyymmdd pmduShipFrzEndYyyymmdd cellShipFrzStartYyyymmdd cellShipFrzEndYyyymmdd pramTyCd planDesc linkProdNoFrzYn pmduProdNoFrzYn cellProdNoFrzYn linkShipNoFrzYn pmduShipNoFrzYn cellShipNoFrzYn sesUserId linkProdRefSysDivsCd linkProdRefSysPlanId pmduProdRefSysDivsCd pmduProdRefSysPlanId cellProdRefSysDivsCd cellProdRefSysPlanId linkShipRefSysDivsCd linkShipRefSysPlanId pmduShipRefSysDivsCd pmduShipRefSysPlanId cellShipRefSysDivsCd cellShipRefSysPlanId |  | PKG_SCP0123 P_SCP0123_SAVE_PLAN_ID_CREATE_82 P_SCP0123_PLAN_ID_82_SAVE P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | 44 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 114 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 155 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 187 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 179 |
| grid | formatItem | handleFormatItem | addHandler | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 180 |
| grid.hostElement | keydown | blockComboCellKey | addEventListener | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 206 |
| DataGrid | cellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 225 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 226 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 227 |
| DatePickerCalendar | onChange | <arrow> onChange | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 557 |
| Checkbox | onChange | onToggleNoFrozen | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 584 |
| CustomDropdown | onChange | <arrow> handleLevelCdChange(setLevels,key),handleLevelCdChange,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 613 |
| CustomDropdown | onChange | <arrow> updateLevel,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 626 |
| Checkbox | onChange | toggleAllNoFrozen(setProdLevels) | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 703 |
| Checkbox | onChange | toggleAllNoFrozen(setShipLevels) | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 717 |
| CustomDropdown | onChange | <arrow> handleProdCdChange,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 737 |
| CustomDropdown | onChange | <arrow> setProdPlanId,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 765 |
| CustomDropdown | onChange | <arrow> handleShipCdChange,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 802 |
| CustomDropdown | onChange | <arrow> setShipPlanId,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 830 |
| CustomDropdown | onChange | <arrow> setParamCd,String | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 849 |
| InputField | onChange | <arrow> setDesc | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 861 |
| Button | onClick | <arrow> saveData | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 876 |
| Button | onClick | closeAndReset | jsx | features/supply/src/pages/plan-control/components/PlanIdCreatePopup.tsx | 884 |
| PlanControlForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 209 |
| PlanControlGrid | cellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 241 |
| PlanControlGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 242 |
| EngineRunGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 256 |
| PlanIdCreatePopup | onClose | <arrow> setPlanIdCreateContext | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 265 |
| PlanIdCreatePopup | onSaved | <arrow> queryClient.invalidateQueries,invalidateCombos | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 266 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| FormItem | 18 |
| CustomDropdown | 10 |
| InputField | 4 |
| Grid | 3 |
| Checkbox | 3 |
| DataGrid | 2 |
| DatePickerCalendar | 2 |
| Button | 2 |
| Panel | 2 |
| SearchArea | 1 |
| Fragment | 1 |
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
| MSG00033 | 1 |
| MSG01197 | 1 |
| MSG01438 | 1 |
| MSG01439 | 1 |
| MSG01441 | 1 |
| MSG01442 | 1 |
| MSG00003 | 1 |
| MSG01490 | 1 |
| MSG01491 | 1 |
| MSG01492 | 1 |
| MSG01493 | 1 |
| MSG01494 | 1 |
| MSG01495 | 1 |
| MSG00108 | 1 |
| MSG01465 | 1 |
| MSG01466 | 1 |
| MSG01467 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0039(5), SCP0122(2), SCP0123(2), SCP0025(1), SCP0108(1), SCP0020(1), SCM0005(1), SYS0013(1), SCP0100(1), SSP0021(1)
- SP/PKG: PKG_SCP0123(5), P_SCP0123_GET_PLAN_ID_INFO(3), P_USER_ID(2), P_SCP0123_SAVE_PLAN_ID_CREATE_82(1), P_SCP0123_GET_PLAN_CONTROL(1), P_SCP0123_SAVE_PLAN_ACTV_RUN(1), P_SCP0123_PLAN_ID_INFO_GET(1), P_SCP0123_PLAN_ID_SAVE(1), P_SCP0123_SAVE_PLAN_ID_CREATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | <DataGrid formatItem={...}> prop 이 아니라 아래 effect 에서 gridRef 에 직접 addHandler 한다 — | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 72 |
| jsx | <DataGrid beginningEdit={...}> prop 으로 넘기지 않는다 — DataGrid 의 setEditableColumns | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 135 |
| code | confirm 은 Promise<boolean> — "No" 면 그 자리에서 중단한다(AS-IS DialogResult.No return). | features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | 85 |
| endpoint | 일단위 판정 집합의 조회 경로. useTabLookupQueries(admin/lookup)를 쓰면 응답 컬럼명이 | features/supply/src/pages/plan-control/plan-control.constants.ts | 63 |
| code | removeRow 가 살아나 AS-IS 에 없던 행 추가·삭제가 실제로 동작한다. () => undefined 로 버튼만 렌더하고 | features/supply/src/pages/plan-control/PlanControl.tsx | 183 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

