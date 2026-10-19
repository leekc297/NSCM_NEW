# SCP0104 — To-Be Fact Pack 요약

- page_key: `supply/capa-line-assign` · feature: supply · As-is Fact Pack 있음
- 파일 22 · 엔드포인트 호출 17 (미해결 6, 주석 속 1) · 이벤트 38 · 컴포넌트 사용 53 · 하드코딩 컬럼 1 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-line-assign/capa-line-assign.constants.ts | constants | 485 |
| features/supply/src/pages/capa-line-assign/capa-line-assign.types.ts | types | 56 |
| features/supply/src/pages/capa-line-assign/CapaLineAssign.module.scss | style | 8 |
| features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | page | 894 |
| features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.module.scss | component | 18 |
| features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | component | 378 |
| features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | component | 270 |
| features/supply/src/pages/capa-line-assign/components/CapaLineSopGrid.tsx | component | 123 |
| features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModals.module.scss | component | 22 |
| features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | component | 197 |
| features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | component | 194 |
| features/supply/src/pages/capa-line-assign/hooks/useCapaLineAssignValidation.ts | hook | 87 |
| features/supply/src/pages/capa-line-assign/hooks/useCapaLineCascade.ts | hook | 343 |
| features/supply/src/pages/capa-line-assign/index.ts | index | 5 |
| features/supply/src/pages/capa-line-assign/useCapaLineAssignStore.ts | store | 412 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssign.cascade.ts | util | 60 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssign.dummyCode.ts | util | 74 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssign.editLock.ts | util | 59 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssign.gridCombos.ts | util | 259 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssign.save.ts | util | 160 |
| features/supply/src/pages/capa-line-assign/utils/capaLineAssignColumns.ts | util | 217 |
| features/supply/src/pages/capa-line-assign/__asis-mapping__.md | mapping | 227 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0104/spreadTitle//call-proc | hook | 1 | Y | CapaLineAssign.tsx:176 |
| SCP0104/{?assignSheet}//call-proc | hook | 1 | N | CapaLineAssign.tsx:199 |
| SCP0104/{?sopSheet}//call-proc | hook | 1 | N | CapaLineAssign.tsx:206 |
| (useTabComboQueries) | hook | 8 | Y | CapaLineAssign.tsx:227 CapaLineAssign.tsx:228 useCapaLineCascade.ts:75 useCapaLineCascade.ts:79 useCapaLineCascade.ts:81 useCapaLineCascade.ts:85 |
| /SCP0104/{activeSheet}/SAVE/call-proc | http | 1 | N | CapaLineAssign.tsx:420 |
| SCP0104/{?sheet}//call-proc | hook | 2 | N | CapaLineAssignModelModal.tsx:88 CapaLineModal.tsx:83 |
| /admin/menu/SCP0104/column | http | 1 | Y | useCapaLineAssignStore.ts:330 |
| /admin/menu/SCP0104/search-conditions | http | 1 | Y | useCapaLineAssignStore.ts:383 |
| /SCP0104/{sheet}/CHECK_NAME_ON_DUMMY_CODE/call-proc | http | 1 | N | capaLineAssign.dummyCode.ts:41 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaLineAssignForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 736 |
| CapaLineAssignGrid | onCellDblClick | handleAssignCellDblClick | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 772 |
| CapaLineAssignGrid | onUnknownItemName | handleUnknownItemName | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 773 |
| CapaLineModal | onClose | <arrow> setOpenLinePopup | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 798 |
| CapaLineModal | onConfirm | handleLinePopupConfirm | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 799 |
| CapaLineAssignModelModal | onClose | <arrow> setOpenSopModelPopup | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 810 |
| CapaLineAssignModelModal | onConfirm | handleSopModelConfirm | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 811 |
| CapaItemPopup | onClose | <arrow> setItemPopupRow | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 832 |
| CapaItemPopup | onSelect | <arrow> handleItemPopupSelect | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 833 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,clearAssignFilters,settings.filter,saveTitleSet({menuId:MENU_ID,sheetName:sheet,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((setting,index)=>({name:setting.COLUMN_NAME,sortOrderNo:index+1,colWidth:setting.COL_WIDTH,cellColor:setting.CELL_COLOR,textColor:setting.TEXT_COLOR,})),}).then,saveTitleSet | jsx | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 850 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 157 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 186 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 204 |
| SearchArea | onResetCondition | handleResetCondition | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 205 |
| CustomDropdown | onChange | <arrow> changeDivisionType,Number | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 257 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 324 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 325 |
| Button | onClick | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 334 |
| CapaItemPopup | onClose | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 360 |
| CapaItemPopup | onSelect | <arrow> [...newSet(selectedAll.map(selection=>(isEltr?selection.itemId:(selection.nickName??''))).filter(Boolean)),].join,selectedAll.map(selection=>(isEltr?selection.itemId:(selection.nickName??''))).filter,selectedAll.map,setSearchParams | jsx | features/supply/src/pages/capa-line-assign/components/CapaLineAssignForm.tsx | 361 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | 139 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | 166 |
| grid | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | 194 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | 203 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/capa-line-assign/components/CapaLineAssignGrid.tsx | 220 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineSopGrid.tsx | 78 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineSopGrid.tsx | 86 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/capa-line-assign/components/CapaLineSopGrid.tsx | 94 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | 125 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | 126 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | 151 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | 182 |
| Button | onClick | onClose | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineAssignModelModal.tsx | 189 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | 120 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | 121 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | 146 |
| Button | onClick | handleSubmit | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | 179 |
| Button | onClick | onClose | jsx | features/supply/src/pages/capa-line-assign/components/modals/CapaLineModal.tsx | 186 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 7 |
| Button | 5 |
| InputField | 4 |
| DataGrid | 4 |
| CustomDropdown | 3 |
| SearchArea | 3 |
| TabItem | 2 |
| CapaItemPopup | 2 |
| CustomDialog | 2 |
| ProgressIndicator | 2 |
| ResultArea | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaLineAssignForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| CapaLineAssignGrid | 1 |
| CapaLineSopGrid | 1 |
| CapaLineModal | 1 |
| CapaLineAssignModelModal | 1 |
| ColumnLayoutModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildDateColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafLabel | 40 | true |  |  | object | features/supply/src/pages/capa-line-assign/utils/capaLineAssignColumns.ts | 49 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00109 | 1 |
| MSG00667 | 1 |
| LBL00001 | 1 |
| LBL00053 | 1 |
| LBL00606 | 1 |
| LBL00040 | 1 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00015 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00056 | 1 |
| LBL00054 | 1 |
| LBL00669 | 1 |
| LBL00639 | 1 |
| LBL00632 | 1 |
| LBL00769 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00414 | 1 |
| LBL00605 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0104(8), SCP0114(2), DMF0044(1), SCP0105(1), SCP0106(1)
- SP/PKG: PKG_SCP0104(4), P_SCP0104_GET_SPREAD_TITLE(3), SCP0104_CHECK_NAME_ON_DUMMY_CODE(2)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | Insert(F8) — SubTitle INSERT 1개를 `activeTab` 으로 라우팅한다(U-1 확정, hook #97). AS-IS 는 공통 `InsertButton` 이 SOP 탭에서 early-return(B11) 하기 때문에 SOP 전용 `btnSopNew` 를 따로 뒀다. TO-BE 는 그 우회를 없애고 **가드 3개(R-13)만 SOP 분기에 재현**한다. 전부 메시지 없이 조용히 return 하는 것도 AS | features/supply/src/pages/capa-line-assign/CapaLineAssign.tsx | 349 |
| endpoint | admin `SCM_MST_SHEET_COLUMNS` 동적 fetch(8 라우팅 시트 → 7 메타 시트). 미등록/실패 시 빈 배열을 유지한다 — 화면은 컬럼 0개로 뜨고 그 사실이 곧 메타 누락 신호다 (constants 하드코딩 fallback 을 두지 않는다 — CLAUDE.md §2 체크4 "속성 단위 덮어쓰기 금지"). | features/supply/src/pages/capa-line-assign/useCapaLineAssignStore.ts | 320 |
| jsx | 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 정본 `scp-bom` `restoreSearchConditions`. 저장측은 page 가 `<SubTitle searchParam={sc}>` 로 이미 배선돼 있으나, 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(basic-check #3 재발 함정). GET `/admin/menu/{MENU_ID}/search-cond | features/supply/src/pages/capa-line-assign/useCapaLineAssignStore.ts | 364 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

