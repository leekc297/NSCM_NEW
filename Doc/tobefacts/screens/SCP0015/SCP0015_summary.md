# SCP0015 — To-Be Fact Pack 요약

- page_key: `supply/plan-management` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 9 (미해결 1, 주석 속 0) · 이벤트 14 · 컴포넌트 사용 20 · 하드코딩 컬럼 0 · 메시지 11
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-management/components/EngineRunGrid.tsx | component | 79 |
| features/supply/src/pages/plan-management/components/EngineToolbar.tsx | component | 39 |
| features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | component | 129 |
| features/supply/src/pages/plan-management/components/PlanManagementGrid.module.scss | component | 36 |
| features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | component | 223 |
| features/supply/src/pages/plan-management/index.ts | index | 3 |
| features/supply/src/pages/plan-management/plan-management.constants.ts | constants | 88 |
| features/supply/src/pages/plan-management/plan-management.types.ts | types | 21 |
| features/supply/src/pages/plan-management/PlanManagement.module.scss | style | 28 |
| features/supply/src/pages/plan-management/PlanManagement.tsx | page | 471 |
| features/supply/src/pages/plan-management/usePlanManagementStore.ts | store | 177 |
| features/supply/src/pages/plan-management/utils/planManagementEngine.test.ts | test | 70 |
| features/supply/src/pages/plan-management/utils/planManagementEngine.ts | util | 54 |
| features/supply/src/pages/plan-management/utils/planManagementLock.test.ts | test | 88 |
| features/supply/src/pages/plan-management/utils/planManagementLock.ts | util | 58 |
| features/supply/src/pages/plan-management/utils/planManagementMerge.ts | util | 60 |
| features/supply/src/pages/plan-management/__asis-mapping__.md | mapping | 129 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | PlanManagementForm.tsx:47 |
| SCP0015/planMgmt//call-proc | hook | 1 | Y | PlanManagement.tsx:85 |
| SCP0015/engineRun//call-proc | hook | 1 | Y | PlanManagement.tsx:93 |
| SCP0015/planConfirm//call-proc | hook | 1 | Y | PlanManagement.tsx:104 |
| /SCP0015/planMgmt/{action}/call-proc | http | 1 | N | PlanManagement.tsx:261 |
| /admin/menu/SCP0015/column | http | 1 | Y | usePlanManagementStore.ts:156 |
| /SCP0015/planMgmt/STOP/call-proc | propagated | 1 | Y | PlanManagement.tsx:289 |
| /SCP0015/planMgmt/EXECUTE/call-proc | propagated | 1 | Y | PlanManagement.tsx:316 |
| /SCP0015/planMgmt/CONFIRM/call-proc | propagated | 1 | Y | PlanManagement.tsx:378 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| planMgmt | divisionId planYear planWeek sesUserGrId |  | P_RAISE_NOT_MIGRATED |
| engineRun | modelingId divisionId revisionNo | o_rc o_rc2 | P_RAISE_NOT_MIGRATED |
| planConfirm | modelingId divisionId revisionNo | o_rc | P_RAISE_NOT_MIGRATED |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | formatItem | handleFormatItem | addHandler | features/supply/src/pages/plan-management/components/EngineRunGrid.tsx | 51 |
| Button | onClick | onStop | jsx | features/supply/src/pages/plan-management/components/EngineToolbar.tsx | 33 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | 106 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-management/components/PlanManagementForm.tsx | 116 |
| grid | formatItem | handleFormatItem | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 123 |
| grid | beginningEdit | handleBeginningEdit | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 135 |
| grid | cellEditEnded | handleCellEditEnded | addHandler | features/supply/src/pages/plan-management/components/PlanManagementGrid.tsx | 146 |
| PlanManagementForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 416 |
| PlanManagementForm | onDivisionRows | setDivisionRows | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 418 |
| PlanManagementGrid | onRunClick | handleRun | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 441 |
| PlanManagementGrid | onConfirmClick | handleConfirmAction | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 442 |
| PlanManagementGrid | onRowDoubleClick | handleRowDoubleClick | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 443 |
| PlanManagementGrid | onRevisionChanged | handleRevisionChanged | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 444 |
| EngineToolbar | onStop | handleStop | jsx | features/supply/src/pages/plan-management/PlanManagement.tsx | 454 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 2 |
| FormItem | 2 |
| Panel | 2 |
| Stack | 1 |
| InputField | 1 |
| Button | 1 |
| Grid | 1 |
| CustomDropdown | 1 |
| SearchArea | 1 |
| MainTitle | 1 |
| PlanManagementForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| PlanManagementGrid | 1 |
| PanelSeparator | 1 |
| EngineToolbar | 1 |
| EngineRunGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00086 | 1 |
| LBL00039 | 1 |
| LBL01110 | 1 |
| MSG00097 | 1 |
| MSG01456 | 1 |
| MSG01457 | 1 |
| MSG01458 | 1 |
| MSG01460 | 1 |
| MSG01461 | 1 |
| MSG00006 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0015(4), SCP0009(1), DMF0006(1)
- SP/PKG: P_RAISE_NOT_MIGRATED(3), PKG_SCP0015(1), P_SCP0015_SAVE_PLAN_MST_STOP(1), P_SCP0015_SAVE_PLAN_MST_RUN(1), PR_SCP_ENG_CONTROL(1), P_SCP0015_SAVE_PLAN_MST_COMFIRM(1), PR_SCP_PLN_INTERFACE_PLAN(1), P_GROUP_ID(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | AS-IS FindData_Plan L670 checkRequired early-return, Roslyn 미포착 가드라 누락 주의. design 01 §2 행2) | features/supply/src/pages/plan-management/PlanManagement.tsx | 192 |
| code | AS-IS 는 조회 무시(early-return) | features/supply/src/pages/plan-management/PlanManagement.tsx | 199 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

