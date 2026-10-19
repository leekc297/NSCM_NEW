# SCP0110 — To-Be Fact Pack 요약

- page_key: `supply/demand-group-master` · feature: supply · As-is Fact Pack 있음
- 파일 14 · 엔드포인트 호출 9 (미해결 0, 주석 속 0) · 이벤트 20 · 컴포넌트 사용 33 · 하드코딩 컬럼 0 · 메시지 10
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | component | 230 |
| features/supply/src/pages/demand-group-master/components/GroupMasterGrid.tsx | component | 93 |
| features/supply/src/pages/demand-group-master/components/ModelListGrid.tsx | component | 99 |
| features/supply/src/pages/demand-group-master/demand-group-master.constants.ts | constants | 74 |
| features/supply/src/pages/demand-group-master/demand-group-master.types.ts | types | 15 |
| features/supply/src/pages/demand-group-master/DemandGroupMaster.module.scss | style | 45 |
| features/supply/src/pages/demand-group-master/DemandGroupMaster.tsx | page | 254 |
| features/supply/src/pages/demand-group-master/hooks/useDemandGroupMasterValidation.ts | hook | 114 |
| features/supply/src/pages/demand-group-master/index.ts | index | 2 |
| features/supply/src/pages/demand-group-master/useDemandGroupMasterStore.ts | store | 161 |
| features/supply/src/pages/demand-group-master/utils/demand-group-master.columns.ts | util | 39 |
| features/supply/src/pages/demand-group-master/utils/demand-group-master.combos.ts | util | 47 |
| features/supply/src/pages/demand-group-master/utils/demand-group-master.save.ts | util | 99 |
| features/supply/src/pages/demand-group-master/__asis-mapping__.md | mapping | 81 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 4 | Y | DemandGroupMasterForm.tsx:44 GroupMasterGrid.tsx:42 ModelListGrid.tsx:49 DemandGroupMaster.tsx:62 |
| SCP0110/groupName//call-proc | hook | 1 | Y | DemandGroupMaster.tsx:66 |
| SCP0110/modelList//call-proc | hook | 1 | Y | DemandGroupMaster.tsx:73 |
| /admin/menu/SCP0110/column | http | 1 | Y | useDemandGroupMasterStore.ts:119 |
| /admin/menu/SCP0110/search-conditions | http | 1 | Y | useDemandGroupMasterStore.ts:135 |
| /SCP0110/groupName\|modelList/SAVE/call-proc | http | 1 | Y | demand-group-master.save.ts:47 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| groupName | divisionId operationGroup groupName | o_rc1 | PKG_SCP0110 |
| modelList | divisionId operationGroup groupId groupName projectId itemId | o_rc1 | PKG_SCP0110 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 80 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 93 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 114 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 130 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 131 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 162 |
| FunctionSearchIcon | onClick | <arrow> setOpenProjectModal | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 156 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 193 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 187 |
| ProjectByDivisionPopup | onClose | <arrow> setOpenProjectModal | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 206 |
| ProjectByDivisionPopup | onSelect | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 208 |
| ModelByDivisionPopup | onClose | <arrow> setOpenItemModal | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 217 |
| ModelByDivisionPopup | onSelect | <arrow> setSearchParams | jsx | features/supply/src/pages/demand-group-master/components/DemandGroupMasterForm.tsx | 223 |
| DataGrid | gotFocus | <arrow> onFocus | jsx | features/supply/src/pages/demand-group-master/components/GroupMasterGrid.tsx | 88 |
| g | updatedLayout | resetExcludedMerge | addHandler | features/supply/src/pages/demand-group-master/components/ModelListGrid.tsx | 80 |
| DataGrid | gotFocus | <arrow> onFocus | jsx | features/supply/src/pages/demand-group-master/components/ModelListGrid.tsx | 95 |
| DemandGroupMasterForm | onSearch | handleSearch | jsx | features/supply/src/pages/demand-group-master/DemandGroupMaster.tsx | 220 |
| GroupMasterGrid | onFocus | setActiveGrid | jsx | features/supply/src/pages/demand-group-master/DemandGroupMaster.tsx | 237 |
| GroupMasterGrid | onRowDblClick | setModelListFilter | jsx | features/supply/src/pages/demand-group-master/DemandGroupMaster.tsx | 238 |
| ModelListGrid | onFocus | setActiveGrid | jsx | features/supply/src/pages/demand-group-master/DemandGroupMaster.tsx | 247 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| InputField | 3 |
| CustomDropdown | 2 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| DataGrid | 2 |
| Panel | 2 |
| SearchArea | 1 |
| ProjectByDivisionPopup | 1 |
| ModelByDivisionPopup | 1 |
| MainTitle | 1 |
| DemandGroupMasterForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| GroupMasterGrid | 1 |
| PanelSeparator | 1 |
| ModelListGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00037 | 1 |
| LBL00617 | 1 |
| LBL00669 | 1 |
| LBL00112 | 1 |
| MSG00043 | 1 |
| MSG00004 | 1 |
| MSG00002 | 1 |
| MSG00006 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0110(4), DMF0014(1)
- SP/PKG: PKG_SCP0110(4)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

