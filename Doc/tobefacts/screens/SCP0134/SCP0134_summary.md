# SCP0134 — To-Be Fact Pack 요약

- page_key: `supply/plan-management` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 10 · 컴포넌트 사용 15 · 하드코딩 컬럼 0 · 메시지 16
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-management/components/EngineRunGrid.tsx | component | 44 |
| features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | component | 133 |
| features/supply/src/pages/plan-management/components/PlanManagementGrid.module.scss | component | 41 |
| features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | component | 203 |
| features/supply/src/pages/plan-management/index.ts | index | 3 |
| features/supply/src/pages/plan-management/plan-management.constants.ts | constants | 114 |
| features/supply/src/pages/plan-management/plan-management.types.ts | types | 18 |
| features/supply/src/pages/plan-management/PlanManagement.module.scss | style | 63 |
| features/supply/src/pages/plan-management/PlanManagement.tsx | page | 291 |
| features/supply/src/pages/plan-management/usePlanManagementStore.ts | store | 175 |
| features/supply/src/pages/plan-management/__asis-mapping__.md | mapping | 129 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | PlanManagementForm.tsx:49 |
| SCP0134/mainGrid//call-proc | hook | 1 | Y | PlanManagement.tsx:78 |
| SCP0134/detailGrid//call-proc | hook | 1 | Y | PlanManagement.tsx:86 |
| /SCP0134/mainGrid/EXECUTE/call-proc | http | 1 | Y | PlanManagement.tsx:149 |
| /admin/menu/SCP0134/search-conditions | http | 1 | Y | usePlanManagementStore.ts:134 |
| /admin/menu/SCP0134/column | http | 1 | Y | usePlanManagementStore.ts:154 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| mainGrid | divisionId planYear planWeek sesUserGrId |  | PKG_SCP0134 P_SCP0134_GET_PLAN_MST P_SCP0134_GET_PLAN_ENGINE_RUN P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN |
| detailGrid | divisionId revisionNo | o_rc o_rc2 | PKG_SCP0134 P_SCP0134_GET_PLAN_MST P_SCP0134_GET_PLAN_ENGINE_RUN P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | 108 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | 118 |
| grid | formatItem | handleFormatItem | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 123 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 133 |
| grid | cellEditEnded | handleCellEditEnded | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 143 |
| PlanManagementForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 249 |
| PlanManagementForm | onDivisionRows | setDivisionRows | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 251 |
| PlanManagementGrid | onAction | handleAction | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 271 |
| PlanManagementGrid | onRowSelect | handleRowSelect | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 272 |
| PlanManagementGrid | onRevisionChanged | handleRevisionChanged | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 273 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 2 |
| Panel | 2 |
| Grid | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |
| SearchArea | 1 |
| MainTitle | 1 |
| PlanManagementForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PlanManagementGrid | 1 |
| PanelSeparator | 1 |
| EngineRunGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00086 | 1 |
| LBL00039 | 1 |
| LBL01110 | 1 |
| MSG00097 | 1 |
| MSG00033 | 2 |
| MSG01458 | 1 |
| MSG01457 | 1 |
| MSG01460 | 1 |
| MSG01459 | 1 |
| MSG01474 | 1 |
| MSG01473 | 1 |
| MSG01472 | 1 |
| MSG01471 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0134(3), SCP0015(2)
- SP/PKG: PKG_SCP0134(4), P_SCP0134_SAVE_PLAN_MANAGEMENT_ACTV_RUN(3), P_ACTV_CD(1), FN_GET_DIVISION(1), P_SCP0134_GET_PLAN_MST(1), P_USER_ID(1), P_GROUP_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

