# SCP0125 — To-Be Fact Pack 요약

- page_key: `supply/workbench` · feature: supply · As-is Fact Pack 있음
- 파일 19 · 엔드포인트 호출 11 (미해결 3, 주석 속 0) · 이벤트 20 · 컴포넌트 사용 28 · 하드코딩 컬럼 0 · 메시지 18
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/workbench/components/WorkbenchForm.tsx | component | 328 |
| features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | component | 336 |
| features/supply/src/pages/workbench/hooks/useWorkbenchData.ts | hook | 223 |
| features/supply/src/pages/workbench/hooks/useWorkbenchValidation.ts | hook | 283 |
| features/supply/src/pages/workbench/index.ts | index | 4 |
| features/supply/src/pages/workbench/useWorkbenchStore.ts | store | 178 |
| features/supply/src/pages/workbench/utils/workbench.cascade.ts | util | 62 |
| features/supply/src/pages/workbench/utils/workbench.columns.ts | util | 69 |
| features/supply/src/pages/workbench/utils/workbench.derive.test.ts | test | 179 |
| features/supply/src/pages/workbench/utils/workbench.derive.ts | util | 121 |
| features/supply/src/pages/workbench/utils/workbench.editLock.test.ts | test | 145 |
| features/supply/src/pages/workbench/utils/workbench.editLock.ts | util | 91 |
| features/supply/src/pages/workbench/utils/workbench.gridCombos.ts | util | 209 |
| features/supply/src/pages/workbench/utils/workbench.insert.ts | util | 71 |
| features/supply/src/pages/workbench/utils/workbench.save.ts | util | 219 |
| features/supply/src/pages/workbench/workbench.constants.ts | constants | 573 |
| features/supply/src/pages/workbench/Workbench.tsx | page | 460 |
| features/supply/src/pages/workbench/workbench.types.ts | types | 66 |
| features/supply/src/pages/workbench/__asis-mapping__.md | mapping | 358 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | WorkbenchForm.tsx:89 |
| (useTabLookupQueries) | hook | 1 | Y | useWorkbenchData.ts:77 |
| SCP0125/init//call-proc | hook | 1 | Y | useWorkbenchData.ts:97 |
| SCP0125/mktFcst//call-proc | hook | 1 | Y | useWorkbenchData.ts:111 |
| SCP0125/{?stockSheet}//call-proc | hook | 1 | N | useWorkbenchData.ts:118 |
| SCP0125/{?stockElecSheet}//call-proc | hook | 1 | N | useWorkbenchData.ts:125 |
| SCP0125/elecDemand//call-proc | hook | 1 | Y | useWorkbenchData.ts:132 |
| SCP0125/stock2ndOcv//call-proc | hook | 1 | Y | useWorkbenchData.ts:139 |
| /admin/menu/SCP0125/column | http | 1 | Y | useWorkbenchStore.ts:135 |
| /admin/menu/SCP0125/search-conditions | http | 1 | Y | useWorkbenchStore.ts:153 |
| /SCP0125/{sheet}/SAVE/call-proc | http | 1 | N | Workbench.tsx:271 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| init |  | o_rc1 o_rc2 o_rc3 o_rc4 o_rc5 o_rc6 o_rc7 o_rc8 o_rc9 | PKG_SCP0125 |
| mktFcst | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| stock | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| stockUc | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| stockElec | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| stockElecUc | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| elecDemand | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |
| stock2ndOcv | divisionId planStartYyyymmdd versionNo nickName itemId | o_rc1 | PKG_SCP0125 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 181 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,onDivisionChange | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 199 |
| CustomDropdown | onChange | <arrow> onPlanDateChange,String | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 222 |
| DatePickerCalendar | onChange | <arrow> setSearchParams,date?.format | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 246 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 269 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 300 |
| Button | onClick | <arrow> setOpenItemModal | jsx | features/supply/src/pages/workbench/components/WorkbenchForm.tsx | 296 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 173 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 193 |
| grid | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 212 |
| grid | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 219 |
| grid.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 237 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 285 |
| DataGrid | cellEditEnded | <arrow> str,GridUtils.getBinding,applyDerived | jsx | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 286 |
| ModelByDivisionPopup | onClose | <arrow> setOpenItemModal | jsx | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 323 |
| ModelByDivisionPopup | onSelect | <arrow> setCellValue | jsx | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 324 |
| WorkbenchForm | onSearch | handleSearch | jsx | features/supply/src/pages/workbench/Workbench.tsx | 417 |
| WorkbenchForm | onDivisionChange | handleDivisionChange | jsx | features/supply/src/pages/workbench/Workbench.tsx | 418 |
| WorkbenchForm | onPlanDateChange | handlePlanDateChange | jsx | features/supply/src/pages/workbench/Workbench.tsx | 419 |
| WorkbenchGrid | onFocus | <arrow> setActiveTab | jsx | features/supply/src/pages/workbench/Workbench.tsx | 451 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| DatePickerCalendar | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| MaterialByDivisionModal | 1 |
| DataGrid | 1 |
| ProjectByDivisionModal | 1 |
| ModelByDivisionPopup | 1 |
| MainTitle | 1 |
| WorkbenchForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| TabItem | 1 |
| WorkbenchGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00039 | 1 |
| LBL00060 | 1 |
| LBL00618 | 1 |
| LBL00112 | 1 |
| MSG00667 | 1 |
| MSG01149 | 1 |
| MSG01039 | 1 |
| MSG00428 | 1 |
| MSG01081 | 1 |
| MSG01437 | 1 |
| MSG00457 | 1 |
| MSG00458 | 1 |
| MSG00013 | 1 |
| MSG01082 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0125(19), SCP0123(2)
- SP/PKG: P_USER_ID(4), PKG_SCP0125(2), FN_GET_DIVISION(1), PKG_NSCM_UI_COM_LOOKUP(1), PR_GET_LOOKUP_INFO_LIST(1), FN_CHAR_TO_DATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | if (!underEdit) e.cell.textContent = toDisplayDate(row?.[COL.DUE_DATE]); | features/supply/src/pages/workbench/components/WorkbenchGrid.tsx | 169 |
| code | 저장 대상 행을 검증하고 실제로 보낼 행만 돌려준다. 실패 시 alert 후 `undefined` (AS-IS 는 첫 위반에서 `return` 하며 그 행 이후는 검사하지 않는다 — 같은 동작). | features/supply/src/pages/workbench/hooks/useWorkbenchValidation.ts | 124 |
| code | R15 저장 — 3중 가드(EDIT 권한 / 빈 그리드는 Toast) 후 검증 39건 → `^` 결합 payload. `CRUD_TYPE` 마킹 행만 대상이며 자체 행상태 필드는 쓰지 않는다. AS-IS D13("Edit 모드 아니면 return")은 모드가 아니라 `canEdit` 로 재표현한다(규범 §2.4). | features/supply/src/pages/workbench/Workbench.tsx | 319 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

