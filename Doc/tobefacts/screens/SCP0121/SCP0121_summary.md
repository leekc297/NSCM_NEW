# SCP0121 — To-Be Fact Pack 요약

- page_key: `supply/plan-group-master` · feature: supply · As-is Fact Pack 있음
- 파일 18 · 엔드포인트 호출 12 (미해결 2, 주석 속 1) · 이벤트 24 · 컴포넌트 사용 51 · 하드코딩 컬럼 0 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-group-master/components/modals/owner-select-modal.constants.ts | constants | 39 |
| features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.module.scss | component | 56 |
| features/supply/src/pages/plan-group-master/components/modals/OwnerSelectModal.tsx | component | 332 |
| features/supply/src/pages/plan-group-master/components/modals/ownerSelectModalStore.ts | store | 41 |
| features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.module.scss | component | 54 |
| features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | component | 273 |
| features/supply/src/pages/plan-group-master/components/modals/planGroupInfoModalStore.ts | store | 41 |
| features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | component | 264 |
| features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | component | 138 |
| features/supply/src/pages/plan-group-master/hooks/usePlanGroupMasterValidation.ts | hook | 113 |
| features/supply/src/pages/plan-group-master/index.ts | index | 2 |
| features/supply/src/pages/plan-group-master/plan-group-master.constants.ts | constants | 97 |
| features/supply/src/pages/plan-group-master/plan-group-master.types.ts | types | 37 |
| features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | page | 296 |
| features/supply/src/pages/plan-group-master/usePlanGroupMasterStore.ts | store | 163 |
| features/supply/src/pages/plan-group-master/utils/plan-group-master.save.ts | util | 96 |
| features/supply/src/pages/plan-group-master/utils/plan-group-master.searchInfo.ts | util | 112 |
| features/supply/src/pages/plan-group-master/__asis-mapping__.md | mapping | 59 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0121/ownerPopup//call-proc | hook | 1 | Y | OwnerSelectModal.tsx:82 |
| /admin/menu/DMF000/column | http | 1 | Y | ownerSelectModalStore.ts:28 |
| (useTabComboQueries) | hook | 2 | Y | PlanGroupInfoModal.tsx:83 PlanGroupMasterForm.tsx:58 |
| {?GET_URL} | http | 1 | N | PlanGroupInfoModal.tsx:95 |
| {?SAVE_URL} | http | 1 | N | PlanGroupInfoModal.tsx:134 |
| /admin/menu/SCP0121/column | http | 2 | Y | planGroupInfoModalStore.ts:30 usePlanGroupMasterStore.ts:151 |
| SCP0121/searchInfo//call-proc | hook | 1 | Y | PlanGroupMaster.tsx:68 |
| SCP0121/main//call-proc | hook | 1 | Y | PlanGroupMaster.tsx:80 |
| /SCP0121/main/SAVE/call-proc | http | 1 | Y | PlanGroupMaster.tsx:169 |
| /admin/menu/SCP0121/search-conditions | http | 1 | Y | usePlanGroupMasterStore.ts:85 |

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
| Button | onClick | handleInsert | jsx | features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | 242 |
| Button | onClick | handleSave | jsx | features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | 250 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | 257 |
| OwnerSelectModal | onConfirm | handleOwnerConfirm | jsx | features/supply/src/pages/plan-group-master/components/modals/PlanGroupInfoModal.tsx | 268 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 140 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 154 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 178 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 197 |
| CustomDropdown | onChange | <arrow> changeLineParent | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 216 |
| CustomDropdown | onChange | <arrow> changeCondition | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 235 |
| CustomDropdown | onChange | <arrow> changeCondition | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterForm.tsx | 254 |
| grid | pastingCell | <arrow> sender.getColumn,dataMap.getDisplayValues,names.map,String,dataMap.getKeyValue,resolvePlanGroupCode | addHandler | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 85 |
| DataGrid | initialized | handleInitialized | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 122 |
| ModelByDivisionPopup | onClose | <arrow> setOpenItemModal | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 130 |
| ModelByDivisionPopup | onSelect | <arrow> setItemId | jsx | features/supply/src/pages/plan-group-master/components/PlanGroupMasterGrid.tsx | 131 |
| PlanGroupMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | 266 |
| PlanGroupInfoModal | onRegistered | handlePlanGroupRegistered | jsx | features/supply/src/pages/plan-group-master/PlanGroupMaster.tsx | 291 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| Button | 7 |
| CustomDropdown | 6 |
| DataGrid | 4 |
| ResultArea | 3 |
| CustomDialog | 2 |
| SearchArea | 2 |
| ProgressIndicator | 2 |
| ArrowChevron2Icon | 2 |
| InputField | 1 |
| ControlConfirmIcon | 1 |
| OwnerSelectModal | 1 |
| ModelByDivisionPopup | 1 |
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
| LBL00121 | 1 |
| LBL00111 | 1 |
| LBL00627 | 1 |
| MSG00097 | 1 |
| MSG00060 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG00618 | 1 |
| LBL00001 | 1 |
| LBL00009 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0121(5), COM0004(2), SCM0002(1), SCP0002(1), DMF0020(1)
- SP/PKG: PKG_SCP0121(2), P_SCP0121_GET_OWNER_DATA_POPUP(1), P_SCP0121_GET_PLAN_GROUP_POPUP(1), P_SCP0121_SAVE_PLAN_GR_POPUP(1), PKG_COM0000(1), P_SCP0121_GET_SEARCH_INFO(1), SCP0121_SAVE_PLAN_GROUP_LINE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 admin fetch (SCM_MST_SHEET_COLUMNS, sheet 'Plan Group Master' 11행). division 무관(고정 11컬럼). | features/supply/src/pages/plan-group-master/usePlanGroupMasterStore.ts | 149 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

