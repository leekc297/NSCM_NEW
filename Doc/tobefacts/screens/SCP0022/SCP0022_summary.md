# SCP0022 — To-Be Fact Pack 요약

- page_key: `supply/formation` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 9 (미해결 0, 주석 속 1) · 이벤트 22 · 컴포넌트 사용 29 · 하드코딩 컬럼 0 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/formation/components/FormationExceptGrid.tsx | component | 130 |
| features/supply/src/pages/formation/components/FormationExceptLtGrid.tsx | component | 121 |
| features/supply/src/pages/formation/components/FormationForm.tsx | component | 171 |
| features/supply/src/pages/formation/components/FormationGrid.tsx | component | 146 |
| features/supply/src/pages/formation/formation.constants.ts | constants | 132 |
| features/supply/src/pages/formation/Formation.module.scss | style | 48 |
| features/supply/src/pages/formation/Formation.tsx | page | 476 |
| features/supply/src/pages/formation/index.ts | index | 2 |
| features/supply/src/pages/formation/useFormationStore.ts | store | 138 |
| features/supply/src/pages/formation/__asis-mapping__.md | mapping | 84 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | FormationForm.tsx:29 |
| SCP0022/formation//call-proc | hook | 2 | Y | Formation.tsx:148 Formation.tsx:170 |
| SCP0022/except//call-proc | hook | 2 | Y | Formation.tsx:155 Formation.tsx:175 |
| SCP0022/exceptLt//call-proc | hook | 2 | Y | Formation.tsx:162 Formation.tsx:181 |
| /admin/menu/SCP0022/column | http | 1 | Y | useFormationStore.ts:91 |
| /admin/menu/SCP0022/search-conditions | http | 1 | Y | useFormationStore.ts:109 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| formation | divisionId plantSiteId itemId | formation |  |
| except | divisionId plantSiteId itemId | formationExcept |  |
| exceptLt | divisionId plantSiteId itemId | formationExceptLt |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| DataGrid | gotFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/formation/components/FormationExceptGrid.tsx | 122 |
| DataGrid | initialized | attachNumberInputBlock | jsx | features/supply/src/pages/formation/components/FormationExceptGrid.tsx | 123 |
| DataGrid | beginningEdit | handleBeginEdit | jsx | features/supply/src/pages/formation/components/FormationExceptGrid.tsx | 124 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/formation/components/FormationExceptGrid.tsx | 125 |
| DataGrid | pastedCell | handlePasted | jsx | features/supply/src/pages/formation/components/FormationExceptGrid.tsx | 126 |
| DataGrid | gotFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/formation/components/FormationExceptLtGrid.tsx | 114 |
| DataGrid | initialized | attachNumberInputBlock | jsx | features/supply/src/pages/formation/components/FormationExceptLtGrid.tsx | 115 |
| DataGrid | beginningEdit | handleBeginEdit | jsx | features/supply/src/pages/formation/components/FormationExceptLtGrid.tsx | 116 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/formation/components/FormationExceptLtGrid.tsx | 117 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/formation/components/FormationForm.tsx | 83 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setSearchParams | jsx | features/supply/src/pages/formation/components/FormationForm.tsx | 96 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/formation/components/FormationForm.tsx | 119 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/formation/components/FormationForm.tsx | 148 |
| FunctionSearchIcon | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/formation/components/FormationForm.tsx | 142 |
| DataGrid | gotFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/formation/components/FormationGrid.tsx | 138 |
| DataGrid | initialized | attachNumberInputBlock | jsx | features/supply/src/pages/formation/components/FormationGrid.tsx | 139 |
| DataGrid | beginningEdit | handleBeginEdit | jsx | features/supply/src/pages/formation/components/FormationGrid.tsx | 140 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/supply/src/pages/formation/components/FormationGrid.tsx | 141 |
| DataGrid | pastedCell | handlePasted | jsx | features/supply/src/pages/formation/components/FormationGrid.tsx | 142 |
| grid.hostElement | keydown | <arrow> hasBlockedChar,currentBinding,event.preventDefault | addEventListener | features/supply/src/pages/formation/formation.constants.ts | 108 |
| grid.hostElement | paste | <arrow> event.clipboardData?.getData,hasBlockedChar,currentBinding,event.preventDefault | addEventListener | features/supply/src/pages/formation/formation.constants.ts | 117 |
| grid | pastingCell | <arrow> hasBlockedChar,String | addHandler | features/supply/src/pages/formation/formation.constants.ts | 127 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 3 |
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| Panel | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| MaterialByDivisionModal | 1 |
| MainTitle | 1 |
| FormationForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| FormationGrid | 1 |
| PanelSeparator | 1 |
| TabWrapper | 1 |
| FormationExceptGrid | 1 |
| FormationExceptLtGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01037 | 2 |
| MSG00699 | 2 |
| MSG00085 | 2 |
| MSG00667 | 2 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00021 | 1 |
| MSG00611 | 1 |
| MSG00700 | 2 |
| MSG00003 | 1 |
| MSG01104 | 1 |
| MSG01149 | 1 |
| MSG00004 | 1 |
| MSG01135 | 1 |
| MSG01080 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0006(3), DMF0004(1), SCP0022(1), SCP0125(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 컬럼 메타 fetch(/admin/menu/SCP0022/column)의 sheetNm 은 SCM_MST_SHEET_COLUMNS.SHEET_NAME 과 정확히 일치해야 한다(BE 가 문자열 그대로 매칭). SCP0022 는 공백 포함 표시명으로 배포돼 있어 코드 키(SHEETS)와 분리한다. | features/supply/src/pages/formation/formation.constants.ts | 40 |
| code | import { createPersistedStoreWithTab, useSessionStore } from '@shared/stores'; | features/supply/src/pages/formation/useFormationStore.ts | 3 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

