# SCP0097 — To-Be Fact Pack 요약

- page_key: `supply/scp-bom-elec` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 10 · 컴포넌트 사용 15 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/scp-bom-elec/components/ScpBomElecForm.tsx | component | 146 |
| features/supply/src/pages/scp-bom-elec/components/ScpBomElecGrid.tsx | component | 121 |
| features/supply/src/pages/scp-bom-elec/hooks/useScpBomElecValidation.ts | hook | 27 |
| features/supply/src/pages/scp-bom-elec/index.ts | index | 2 |
| features/supply/src/pages/scp-bom-elec/scp-bom-elec.constants.ts | constants | 73 |
| features/supply/src/pages/scp-bom-elec/scp-bom-elec.types.ts | types | 14 |
| features/supply/src/pages/scp-bom-elec/ScpBomElec.tsx | page | 176 |
| features/supply/src/pages/scp-bom-elec/useScpBomElecStore.ts | store | 159 |
| features/supply/src/pages/scp-bom-elec/utils/scp-bom-elec.editLock.ts | util | 20 |
| features/supply/src/pages/scp-bom-elec/utils/scp-bom-elec.save.ts | util | 84 |
| features/supply/src/pages/scp-bom-elec/__asis-mapping__.md | mapping | 128 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ScpBomElecForm.tsx:44 |
| SCP0097/SCP BOM Elec//call-proc | hook | 1 | Y | ScpBomElec.tsx:53 |
| /admin/menu/SCP0097/column | http | 1 | Y | useScpBomElecStore.ts:108 |
| /admin/menu/SCP0097/search-conditions | http | 1 | Y | useScpBomElecStore.ts:139 |
| /SCP0097/SCP BOM Elec/SAVE/call-proc | http | 1 | Y | scp-bom-elec.save.ts:58 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/scp-bom-elec/components/ScpBomElecForm.tsx | 79 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,changeDivision | jsx | features/supply/src/pages/scp-bom-elec/components/ScpBomElecForm.tsx | 96 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom-elec/components/ScpBomElecForm.tsx | 118 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom-elec/components/ScpBomElecForm.tsx | 136 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/scp-bom-elec/components/ScpBomElecGrid.tsx | 51 |
| g | beginningEdit | handler | addHandler | features/supply/src/pages/scp-bom-elec/components/ScpBomElecGrid.tsx | 71 |
| g | pastingCell | handler | addHandler | features/supply/src/pages/scp-bom-elec/components/ScpBomElecGrid.tsx | 89 |
| g | formatItem | handler | addHandler | features/supply/src/pages/scp-bom-elec/components/ScpBomElecGrid.tsx | 103 |
| ScpBomElecForm | onSearch | handleSearch | jsx | features/supply/src/pages/scp-bom-elec/ScpBomElec.tsx | 155 |
| ScpBomElecForm | onDivisionAuth | setDivisionAuth | jsx | features/supply/src/pages/scp-bom-elec/ScpBomElec.tsx | 155 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| InputField | 2 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ScpBomElecForm | 1 |
| SubTitle | 1 |
| ScpBomElecGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00033 | 1 |
| LBL00034 | 1 |
| LBL00112 | 1 |
| MSG00097 | 1 |
| MSG00606 | 1 |
| MSG00006 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0053(6), SCP0097(6), SCP0031(1)
- SP/PKG: PKG_SCP0097(4), P_SCP0097_GET_SCP_BOM_ELEC(2), P_SCP0097_SAVE_SCP_BOM_ELEC(2), P_DIVISION_ID(1), P_PARENT_ID(1), P_CHILD_ID(1), P_DEBUG_MODE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 13행, design 03 §1). | features/supply/src/pages/scp-bom-elec/useScpBomElecStore.ts | 19 |

## 10. __asis-mapping__.md 상태
- 구현: 9
- 해당없음: 4
- 제외: 1
| design_id | summary | reason | status |
|---|---|---|---|
| D00-3-002 | W2 ChangeActiveSheet(cs:185) InitSpread | 단일 그리드로 소멸 — Except 시트 미구현(design 01 R5), 활성시트 전환 개념 없음 | 해당없음 |
| D00-3-004 | R5 VisibleTab(cs:196) 시트탭 | 단일 DataGrid — 시트탭 UI 없음(단일 시트 SCP BOM Elec) | 해당없음 |
| D00-3-005 | W4 SwitchLock(cs:248) EditButton 편집모드 토글 | EDIT 모드 토글 어포던스 미이식(asis_to_tobe.md §11 전 화면 공통, convert-core §2.4). 편집범위는 INPUT_TP_CD 메타로 상시 재현 | 제외 |
| D00-3-013 | W12 IsLockCell(cs:457) CellClick | AS-IS 조건통과 후 빈 블록(no-op — 소스 확정). Wijmo isReadOnly/beginningEdit 이 대체 | 해당없음 |
| D00-3-014 | W13 ChangeActiveSheet(cs:497) ActiveSheetChanged shtMain 재동기 | 단일 시트로 소멸 — 활성시트 전환 없음 | 해당없음 |

