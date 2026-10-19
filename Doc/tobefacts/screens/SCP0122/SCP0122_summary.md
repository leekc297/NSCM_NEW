# SCP0122 — To-Be Fact Pack 요약

- page_key: `supply/plan-activity-mgmt` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 15 · 하드코딩 컬럼 0 · 메시지 9
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | component | 156 |
| features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtGrid.tsx | component | 80 |
| features/supply/src/pages/plan-activity-mgmt/index.ts | index | 2 |
| features/supply/src/pages/plan-activity-mgmt/plan-activity-mgmt.constants.ts | constants | 76 |
| features/supply/src/pages/plan-activity-mgmt/plan-activity-mgmt.types.ts | types | 14 |
| features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx | page | 186 |
| features/supply/src/pages/plan-activity-mgmt/usePlanActivityMgmtStore.ts | store | 144 |
| features/supply/src/pages/plan-activity-mgmt/utils/plan-activity-mgmt.util.ts | util | 78 |
| features/supply/src/pages/plan-activity-mgmt/__asis-mapping__.md | mapping | 68 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | PlanActivityMgmtForm.tsx:39 PlanActivityMgmtGrid.tsx:34 |
| SCP0122/main//call-proc | hook | 1 | Y | PlanActivityMgmt.tsx:43 |
| /SCP0122/main/SAVE/call-proc | http | 1 | Y | PlanActivityMgmt.tsx:95 |
| /admin/menu/SCP0122/column | http | 1 | Y | usePlanActivityMgmtStore.ts:102 |
| /admin/menu/SCP0122/search-conditions | http | 1 | Y | usePlanActivityMgmtStore.ts:126 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId prsCd | o_rc1 | SCP0122_GET_PLAN_ACTIVITY_MGMT |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 76 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 90 |
| CustomDropdown | onChange | <arrow> planGroupOptions.find,setSearchParams,String | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 116 |
| CustomDropdown | onChange | <arrow> processOptions.find,setSearchParams,String | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 140 |
| grid | cellEditEnded | handleCellEditEnded | addHandler | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtGrid.tsx | 58 |
| PlanActivityMgmtForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx | 166 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| PlanActivityMgmtForm | 1 |
| SubTitle | 1 |
| PlanActivityMgmtGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00059 | 1 |
| LBL00112 | 1 |
| MSG00667 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |
| MSG00428 | 1 |
| MSG00043 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0006(3), SCP0122(2), SCP0025(1), SCP0123(1), SCP0005(1)
- SP/PKG: SCP0122_GET_PLAN_ACTIVITY_MGMT(2), SCP0122_SAVE_PLAN_ACTIVITY_MGMT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

