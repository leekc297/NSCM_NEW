# SCP0080 — To-Be Fact Pack 요약

- page_key: `supply/group-code-management` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 9 (미해결 0, 주석 속 3) · 이벤트 22 · 컴포넌트 사용 30 · 하드코딩 컬럼 2 · 메시지 19
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | component | 222 |
| features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | component | 277 |
| features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.module.scss | component | 18 |
| features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | component | 153 |
| features/supply/src/pages/group-code-management/group-code-management.constants.ts | constants | 113 |
| features/supply/src/pages/group-code-management/group-code-management.types.ts | types | 50 |
| features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | page | 340 |
| features/supply/src/pages/group-code-management/hooks/useGroupCodePicCheck.ts | hook | 47 |
| features/supply/src/pages/group-code-management/index.ts | index | 2 |
| features/supply/src/pages/group-code-management/useGroupCodeManagementStore.ts | store | 189 |
| features/supply/src/pages/group-code-management/utils/group-code-management.editLock.ts | util | 106 |
| features/supply/src/pages/group-code-management/utils/group-code-management.save.ts | util | 196 |
| features/supply/src/pages/group-code-management/__asis-mapping__.md | mapping | 87 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | GroupCodeManagementForm.tsx:61 GroupCodeManagementForm.tsx:71 |
| (useTabComboQueryResults) | hook | 1 | Y | GroupCodeRtfGubunModal.tsx:58 |
| SCP0080/main//call-proc | hook | 1 | Y | GroupCodeManagement.tsx:78 |
| /SCP0080/main/SAVE/call-proc | http | 1 | Y | GroupCodeManagement.tsx:113 |
| /SCP0080/main/PIC_CHECK/call-proc | http | 1 | Y | useGroupCodePicCheck.ts:26 |
| /admin/menu/SCP0080/column | http | 2 | Y | useGroupCodeManagementStore.ts:121 useGroupCodeManagementStore.ts:181 |
| /admin/menu/SCP0080/search-conditions | http | 1 | Y | useGroupCodeManagementStore.ts:140 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | noDivisionAuth ? undefined : onSearch | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 93 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 110 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 137 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 175 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 176 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 170 |
| CustomDropdown | onChange | <arrow> String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase,set,sel.has | jsx | features/supply/src/pages/group-code-management/components/GroupCodeManagementForm.tsx | 199 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 128 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 145 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 154 |
| g.hostElement | keydown | keyDownBlockHandler | addEventListener | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 170 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 185 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 198 |
| g | updatedLayout | applyBottomHeaderHeight | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 212 |
| g | updatedLayout | applyCellMerge | addHandler | features/supply/src/pages/group-code-management/components/GroupCodeManagementGrid.tsx | 222 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | 138 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | 145 |
| GroupCodeManagementForm | onSearch | handleSearch | jsx | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 279 |
| GroupCodeManagementForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 279 |
| GroupCodeManagementGrid | onPicCellDblClick | handlePicCellDblClick | jsx | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 300 |
| GroupCodeManagementGrid | onPicCellEdited | handlePicCellEdited | jsx | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 301 |
| GroupCodeManagementGrid | onRtfCellDblClick | handleRtfCellDblClick | jsx | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 302 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| Button | 3 |
| DataGrid | 2 |
| SearchArea | 1 |
| InputField | 1 |
| FunctionSearchIcon | 1 |
| CustomDialog | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| ControlConfirmIcon | 1 |
| MainTitle | 1 |
| GroupCodeManagementForm | 1 |
| SubTitle | 1 |
| GroupCodeManagementGrid | 1 |
| SsoUserModal | 1 |
| GroupCodeRtfGubunModal | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | CODE | Code | 90 | true |  |  | meta-shape | features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | 41 |
| POPUP_COLUMNS | NAME | Name | 300 | true |  |  | meta-shape | features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | 42 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00669 | 2 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00009 | 1 |
| LBL00618 | 1 |
| LBL01156 | 1 |
| LBL01077 | 1 |
| LBL01102 | 1 |
| LBL00007 | 1 |
| LBL01055 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00048 | 1 |
| MSG00002 | 1 |
| MSG00284 | 1 |
| MSG01261 | 1 |
| MSG00133 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0050(8), SCP0080(5), DMF0020(2), DMF0004(1)
- SP/PKG: P_SCP0080_GET_GROUP_CODE_MANAGEMENT(4), PKG_SCP0080(3), PKG_SCP0050(3), P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP(3), P_DIVISION_ID(3), P_SCP0080_SAVE_GROUP_CODE_MANAGEMENT(2), P_USER_ID(2), P_DEBUG_MODE(1), P_SCP0080_SAVE_(1), PR_GET_SHEET_COLUMN_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | data 뿐 아니라 isPending 도 필요해 useTabComboQueryResults(전체 쿼리 객체) 를 쓴다. | features/supply/src/pages/group-code-management/components/GroupCodeRtfGubunModal.tsx | 57 |
| jsx | 본 화면 그리드는 FlexGrid<GroupCodeRow> 제네릭에 직접 대입하므로 원자값 인덱스가 필수). | features/supply/src/pages/group-code-management/group-code-management.types.ts | 42 |
| endpoint | ui-dynamic-property-management §3 — Menu Button 권한 동적 fetch (하드코딩 금지) | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 71 |
| endpoint | 진입 시 1회 admin 컬럼 메타 + 저장 조회조건 fetch (초기화 가드). | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 94 |
| code | INSERT/DELETE 는 AS-IS 무동작(NO-OP) — false·키생략 금지, 명시적 () => undefined. | features/supply/src/pages/group-code-management/GroupCodeManagement.tsx | 256 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

