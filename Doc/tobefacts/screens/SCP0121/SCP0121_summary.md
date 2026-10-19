# SCP0121 — To-Be Fact Pack 요약

- page_key: `supply/plan-group-master` · feature: supply · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 7 (미해결 0, 주석 속 1) · 이벤트 18 · 컴포넌트 사용 44 · 하드코딩 컬럼 0 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-group-master/components/modals/owner-select-modal.constants.ts | constants | 39 |
| features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.module.scss | component | 56 |
| features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | component | 332 |
| features/supply/src/pages/plan-group-master/components/modals/ownerSelectModalStore.ts | store | 41 |
| features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.module.scss | component | 8 |
| features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | component | 55 |
| features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | component | 273 |
| features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | component | 143 |
| features/supply/src/pages/plan-group-master/hooks/usePlanGroupMasterValidation.ts | hook | 106 |
| features/supply/src/pages/plan-group-master/index.ts | index | 2 |
| features/supply/src/pages/plan-group-master/plan-group-master.constants.ts | constants | 106 |
| features/supply/src/pages/plan-group-master/plan-group-master.types.ts | types | 37 |
| features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | page | 272 |
| features/supply/src/pages/plan-group-master/usePlanGroupMasterStore.ts | store | 118 |
| features/supply/src/pages/plan-group-master/utils/plan-group-master.save.ts | util | 95 |
| features/supply/src/pages/plan-group-master/utils/plan-group-master.searchInfo.ts | util | 112 |
| features/supply/src/pages/plan-group-master/__asis-mapping__.md | mapping | 59 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0121/ownerPopup//call-proc | hook | 1 | Y | OwnerSelectModal.tsx:82 |
| /admin/menu/DMF000/column | http | 1 | Y | ownerSelectModalStore.ts:28 |
| (useTabComboQueries) | hook | 1 | Y | PlanGroupMasterForm.tsx:60 |
| SCP0121/searchInfo//call-proc | hook | 1 | Y | PlanGroupMaster.tsx:67 |
| SCP0121/main//call-proc | hook | 1 | Y | PlanGroupMaster.tsx:79 |
| /SCP0121/main/SAVE/call-proc | http | 1 | Y | PlanGroupMaster.tsx:145 |
| /admin/menu/SCP0121/column | http | 1 | Y | usePlanGroupMasterStore.ts:106 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| ownerPopup | divisionId search ownerId | o_rc1 o_rc2 | PKG_SCP0121 P_SCP0121_GET_OWNER_DATA_POPUP |
| main | divisionId operationId plantId factoryId lineId planGroupId | o_rc1 | SCP0121_GET_PLAN_GROUP_LINE SCP0121_SAVE_PLAN_GROUP_LINE PKG_SCP0121 P_SCP0121_GET_OWNER_DATA_POPUP |
| searchInfo | userId | plantList factoryList lineList planGroupList targetList operationList | PKG_COM0000 P_SCP0121_GET_SEARCH_INFO PKG_SCP0121 P_SCP0121_GET_OWNER_DATA_POPUP |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 228 |
| InputField | onChange | <arrow> setUserInput | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 238 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 239 |
| Button | onClick | handleMoveToUser | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 278 |
| Button | onClick | handleMoveToBase | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 285 |
| Button | onClick | handleConfirm | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 317 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | 324 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 149 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 163 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 187 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 206 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 225 |
| CustomDropdown | onChange | <arrow> changeCondition | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 244 |
| CustomDropdown | onChange | <arrow> changeCondition | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 263 |
| grid | pastingCell | <arrow> sender.getColumn,dataMap.getDisplayValues,names.map,String,dataMap.getKeyValue,resolvePlanGroupCode | addHandler | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 85 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 122 |
| PlanGroupMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | 242 |
| PlanGroupInfoModal | onRegistered | handlePlanGroupRegistered | jsx | features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | 267 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| CustomDropdown | 6 |
| Button | 4 |
| DataGrid | 3 |
| CustomDialog | 2 |
| SearchArea | 2 |
| ResultArea | 2 |
| ArrowChevron2Icon | 2 |
| InputField | 1 |
| ProgressIndicator | 1 |
| ControlConfirmIcon | 1 |
| ItemByDivisionModal | 1 |
| MainTitle | 1 |
| PlanGroupMasterForm | 1 |
| SubTitle | 1 |
| PlanGroupMasterGrid | 1 |
| PlanGroupInfoModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00339 | 1 |
| LBL00112 | 2 |
| LBL00664 | 1 |
| LBL00716 | 1 |
| LBL00107 | 1 |
| MSG01104 | 1 |
| LBL00002 | 2 |
| LBL00641 | 2 |
| MSG00097 | 1 |
| MSG00013 | 1 |
| MSG00060 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG00618 | 1 |
| LBL00009 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0121(5), COM0004(2), SCM0002(1), DMF0020(1)
- SP/PKG: PKG_SCP0121(1), P_SCP0121_GET_OWNER_DATA_POPUP(1), PKG_COM0000(1), P_SCP0121_GET_SEARCH_INFO(1), SCP0121_SAVE_PLAN_GROUP_LINE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 admin fetch (SCM_MST_SHEET_COLUMNS, sheet 'Plan Group Master' 11행). division 무관(고정 11컬럼). | features/supply/src/pages/plan-group-master/usePlanGroupMasterStore.ts | 104 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

