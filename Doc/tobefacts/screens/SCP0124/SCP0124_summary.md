# SCP0124 — To-Be Fact Pack 요약

- page_key: `supply/plan-group-dashboard` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 7 · 컴포넌트 사용 20 · 하드코딩 컬럼 0 · 메시지 9
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | component | 185 |
| features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardGrid.tsx | component | 41 |
| features/supply/src/pages/plan-group-dashboard/index.ts | index | 2 |
| features/supply/src/pages/plan-group-dashboard/plan-group-dashboard.constants.ts | constants | 69 |
| features/supply/src/pages/plan-group-dashboard/plan-group-dashboard.types.ts | types | 14 |
| features/supply/src/pages/plan-group-dashboard/plan-group-dashboard.util.ts | other | 64 |
| features/supply/src/pages/plan-group-dashboard/PlanGroupDashboard.tsx | page | 116 |
| features/supply/src/pages/plan-group-dashboard/usePlanGroupDashboardStore.ts | store | 160 |
| features/supply/src/pages/plan-group-dashboard/__asis-mapping__.md | mapping | 51 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | PlanGroupDashboardForm.tsx:57 |
| SCP0124/searchInfo//call-proc | hook | 1 | Y | PlanGroupDashboardForm.tsx:63 |
| SCP0124/main//call-proc | hook | 1 | Y | PlanGroupDashboard.tsx:68 |
| /admin/menu/SCP0124/column | http | 1 | Y | usePlanGroupDashboardStore.ts:112 |
| /admin/menu/SCP0124/search-conditions | http | 1 | Y | usePlanGroupDashboardStore.ts:139 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId plantId completedYn startDate endDate | o_rc1 | SCP0124_GET_PLAN_GROUP_DASHBOARD PKG_SCP0124 P_SCP0121_GET_SEARCH_INFO |
| searchInfo | userId | plantList planGroupList | PKG_COM0000 P_SCP0121_GET_SEARCH_INFO SCP0124_GET_PLAN_GROUP_DASHBOARD PKG_SCP0124 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 89 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 104 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 128 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 151 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 166 |
| PeriodRangePicker | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 177 |
| PlanGroupDashboardForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-group-dashboard/PlanGroupDashboard.tsx | 97 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| CustomDropdown | 4 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| PlanGroupDashboardForm | 1 |
| SubTitle | 1 |
| PlanGroupDashboardGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00030 | 1 |
| LBL00058 | 1 |
| LBL00013 | 1 |
| MSG00665 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0123(5), SCP0124(3), SCP0025(3), SCP0039(1), SCP0120(1), SCP0126(1)
- SP/PKG: P_SCP0121_GET_SEARCH_INFO(4), PKG_SCP0124(2), PKG_COM0000(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 채워진 뒤(0→N)엔 `!divisionId` 가드가 즉시 return → 중복 setDivision·루프 없음. | features/supply/src/pages/plan-group-dashboard/components/PlanGroupDashboardForm.tsx | 78 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

