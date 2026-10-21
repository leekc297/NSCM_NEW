# SCP0053 — To-Be Fact Pack 요약

- page_key: `supply/scp-bom` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 11 · 엔드포인트 호출 5 (미해결 0, 주석 속 1) · 이벤트 18 · 컴포넌트 사용 27 · 하드코딩 컬럼 0 · 메시지 15
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | component | 209 |
| features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | component | 160 |
| features/supply/src/pages/scp-bom/hooks/useScpBomValidation.ts | hook | 35 |
| features/supply/src/pages/scp-bom/index.ts | index | 2 |
| features/supply/src/pages/scp-bom/scp-bom.constants.ts | constants | 89 |
| features/supply/src/pages/scp-bom/scp-bom.types.ts | types | 17 |
| features/supply/src/pages/scp-bom/ScpBom.tsx | page | 199 |
| features/supply/src/pages/scp-bom/useScpBomStore.ts | store | 171 |
| features/supply/src/pages/scp-bom/utils/scp-bom.editLock.ts | util | 20 |
| features/supply/src/pages/scp-bom/utils/scp-bom.save.ts | util | 92 |
| features/supply/src/pages/scp-bom/__asis-mapping__.md | mapping | 138 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ScpBomForm.tsx:53 |
| SCP0053/SCP BOM//call-proc | hook | 1 | Y | ScpBom.tsx:62 |
| /admin/menu/SCP0053/column | http | 1 | Y | useScpBomStore.ts:118 |
| /admin/menu/SCP0053/search-conditions | http | 1 | Y | useScpBomStore.ts:148 |
| /SCP0053/SCP BOM/SAVE/call-proc | http | 1 | Y | scp-bom.save.ts:67 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 74 |
| CustomDropdown | onChange | <arrow> confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision,String | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 94 |
| CustomDropdown | onChange | <arrow> set,pickMulti | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 119 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 148 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 149 |
| FunctionSearchIcon | onClick | onModelSearch | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 143 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 165 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 166 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 182 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 183 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 199 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 71 |
| g | formatItem | handler | addHandler | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 89 |
| g | beginningEdit | handler | addHandler | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 107 |
| g | pastingCell | handler | addHandler | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 125 |
| ScpBomForm | onSearch | handleSearch | jsx | features/supply/src/pages/scp-bom/ScpBom.tsx | 161 |
| ScpBomForm | onModelSearch | <arrow> setOpenMaterial | jsx | features/supply/src/pages/scp-bom/ScpBom.tsx | 162 |
| ScpBomForm | onDivisionAuth | setDivisionAuth | jsx | features/supply/src/pages/scp-bom/ScpBom.tsx | 163 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| InputField | 3 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ScpBomForm | 1 |
| SubTitle | 1 |
| ScpBomGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00618 | 1 |
| LBL00033 | 1 |
| LBL00034 | 1 |
| LBL01051 | 1 |
| MSG01329 | 1 |
| MSG01330 | 1 |
| MSG01331 | 1 |
| MSG01332 | 1 |
| MSG00097 | 1 |
| MSG00672 | 1 |
| MSG00006 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0053(7), SCP0037(1), SCP0025(1)
- SP/PKG: PKG_SCP0053(4), P_SCP0053_GET_SCP_BOM(2), P_SCP0053_SAVE_SCP_BOM(2)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 최신 운영 소스와 다를 수 있어 보류. 복원 시 아래 disabled 주석 해제 + onChange 를 () => undefined 로 되돌림. | features/supply/src/pages/scp-bom/components/ScpBomForm.tsx | 87 |
| code | useEffect(() => { | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 133 |
| code | if (!g) return; | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 135 |
| code | const handler = (sender: FlexGrid, e: FormatItemEventArgs) => { | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 136 |
| code | if (e.panel.cellType !== CellType.Cell) return; | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 137 |
| code | e.cell.style.backgroundColor = isRowLocked(row) ? ROW_LOCK_BG : ''; | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 139 |
| code | }; | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 140 |
| code | g.formatItem.addHandler(handler); | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 141 |
| code | g.invalidate(); | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 142 |
| code | return () => g.formatItem?.removeHandler(handler); | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 143 |
| code | }, [gridRef, rows]); | features/supply/src/pages/scp-bom/components/ScpBomGrid.tsx | 144 |
| code | import { useScpBomValidation } from './hooks/useScpBomValidation'; | features/supply/src/pages/scp-bom/ScpBom.tsx | 21 |
| code | const { validateSearch } = useScpBomValidation(); // V1 가드 임시 비활성 (2026-10-07) | features/supply/src/pages/scp-bom/ScpBom.tsx | 36 |
| code | if (!validateSearch(sc)) return; | features/supply/src/pages/scp-bom/ScpBom.tsx | 89 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch(실측 27행, design 03 §1). | features/supply/src/pages/scp-bom/useScpBomStore.ts | 19 |

## 10. __asis-mapping__.md 상태
- 구현: 8
- 해당없음: 4
- 제외: 1
| design_id | summary | reason | status |
|---|---|---|---|
| D00-3-002 | §3 205 / siMain | ChangeActiveSheet — 단일 그리드(Except 미부착, design 01 R6) 활성시트 전환 없음 | 해당없음 |
| D00-3-004 | §3 216 / siMain | VisibleTab 단일시트 탭 — 단일 DataGrid 탭 UI 없음(design 01 R6) | 해당없음 |
| D00-3-005 | §3 345 / siMain | SwitchLock EDIT 모드 토글 미이식(asis_to_tobe.md §11 전 화면 공통). INPUT_TP_CD 메타 상시 재현 | 제외 |
| D00-3-012 | §3 667 / siMain | IsLockCell CellClick — AS-IS 바디 빈 블록(design 03 §3.2) no-op | 해당없음 |
| D00-3-013 | §3 707 / siMain | ChangeActiveSheet ActiveSheetChanged — 단일 시트 재동기화 원천 제거 | 해당없음 |

