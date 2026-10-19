# SCP0123 — To-Be Fact Pack 요약

- page_key: `supply/plan-control` · feature: supply · As-is Fact Pack 있음
- 파일 15 · 엔드포인트 호출 10 (미해결 0, 주석 속 1) · 이벤트 15 · 컴포넌트 사용 24 · 하드코딩 컬럼 0 · 메시지 25
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | component | 47 |
| features/supply/src/pages/plan-control/components/PlanControlForm.tsx | component | 198 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.module.scss | component | 32 |
| features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | component | 167 |
| features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | hook | 469 |
| features/supply/src/pages/plan-control/hooks/usePlanControlPolling.ts | hook | 128 |
| features/supply/src/pages/plan-control/index.ts | index | 2 |
| features/supply/src/pages/plan-control/plan-control.constants.ts | constants | 163 |
| features/supply/src/pages/plan-control/plan-control.types.ts | types | 39 |
| features/supply/src/pages/plan-control/PlanControl.module.scss | style | 49 |
| features/supply/src/pages/plan-control/PlanControl.tsx | page | 250 |
| features/supply/src/pages/plan-control/usePlanControlStore.ts | store | 184 |
| features/supply/src/pages/plan-control/utils/planControl.activity.test.ts | test | 121 |
| features/supply/src/pages/plan-control/utils/planControl.activity.ts | util | 74 |
| features/supply/src/pages/plan-control/__asis-mapping__.md | mapping | 298 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0123/planControl/SEARCH/call-proc | callProc | 2 | Y | usePlanControlCellActions.ts:115 usePlanControlCellActions.ts:440 |
| /SCP0123/planControl/SAVE/call-proc | http | 1 | Y | usePlanControlCellActions.ts:159 |
| SCP0123/planControl//call-proc | hook | 2 | Y | usePlanControlPolling.ts:81 PlanControl.tsx:123 |
| SCP0123/engineRun//call-proc | hook | 1 | Y | usePlanControlPolling.ts:90 |
| (useTabComboQueries) | hook | 1 | Y | PlanControl.tsx:80 |
| SCP0123/searchInfo//call-proc | hook | 1 | Y | PlanControl.tsx:89 |
| /admin/menu/SCP0123/column | http | 1 | Y | usePlanControlStore.ts:71 |
| /admin/menu/SCP0123/search-conditions | http | 1 | Y | usePlanControlStore.ts:166 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| planControl | divisionId planGroupId planStartYyyymmdd actvCd planId | planControl | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| engineRun | divisionId planGroupId planStartYyyymmdd actvCd planId | engineRun | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |
| searchInfo | userId | planGroupList | PKG_SCP0123 P_SCP0123_GET_PLAN_CONTROL P_SCP0123_SAVE_PLAN_ACTV_RUN P_SCP0123_GET_PLAN_ENGINE_RUN PKG_COM0000 P_SCP0121_GET_SEARCH_INFO |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/EngineRunGrid.tsx | 44 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 114 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 132 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 155 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/plan-control/components/PlanControlForm.tsx | 187 |
| grid.hostElement | keydown | blockComboCellKey | addEventListener | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 141 |
| DataGrid | beginningEdit | handleBeginningEdit | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 160 |
| DataGrid | cellEditEnded | cellEditEnded | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 161 |
| DataGrid | formatItem | handleFormatItem | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 162 |
| DataGrid | gotFocus | gotFocus | jsx | features/supply/src/pages/plan-control/components/PlanControlGrid.tsx | 163 |
| PlanControlForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 193 |
| PlanControlGrid | cellEditEnded | handleCellEditEnded | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 225 |
| PlanControlGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 226 |
| EngineRunGrid | gotFocus | <arrow> setFocusSub | jsx | features/supply/src/pages/plan-control/PlanControl.tsx | 240 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 3 |
| DataGrid | 2 |
| Panel | 2 |
| SearchArea | 1 |
| DatePickerCalendar | 1 |
| MainTitle | 1 |
| PlanControlForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PlanControlGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| EngineRunGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00039 | 1 |
| LBL00014 | 1 |
| LBL00112 | 1 |
| LBL01149 | 1 |
| MSG00667 | 1 |
| MSG01125 | 1 |
| MSG01122 | 1 |
| MSG01456 | 1 |
| MSG01457 | 1 |
| MSG01438 | 1 |
| MSG01439 | 1 |
| MSG01441 | 1 |
| MSG01442 | 1 |
| MSG00003 | 1 |
| MSG01462 | 1 |
| MSG01463 | 1 |
| MSG01464 | 1 |
| MSG01465 | 2 |
| MSG01466 | 2 |
| MSG01467 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0039(5), SCP0122(2), SCP0123(2), SCP0025(1), SCP0108(1), SCP0020(1), SCM0005(1), SYS0013(1), SSP0021(1)
- SP/PKG: P_USER_ID(2), PKG_SCP0123(2), P_SCP0123_GET_PLAN_CONTROL(1), P_SCP0123_SAVE_PLAN_ACTV_RUN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | confirm 은 Promise<boolean> — "No" 면 그 자리에서 중단한다(AS-IS DialogResult.No return). | features/supply/src/pages/plan-control/hooks/usePlanControlCellActions.ts | 84 |
| endpoint | 일단위 판정 집합의 조회 경로. useTabLookupQueries(admin/lookup)를 쓰면 응답 컬럼명이 | features/supply/src/pages/plan-control/plan-control.constants.ts | 41 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

