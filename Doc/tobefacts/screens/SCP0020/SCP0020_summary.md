# SCP0020 — To-Be Fact Pack 요약

- page_key: `supply/tact-time` · feature: supply · As-is Fact Pack 있음
- 파일 17 · 엔드포인트 호출 11 (미해결 0, 주석 속 1) · 이벤트 27 · 컴포넌트 사용 27 · 하드코딩 컬럼 1 · 메시지 24
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | component | 149 |
| features/supply/src/pages/tact-time/components/TactTimeForm.tsx | component | 239 |
| features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | component | 251 |
| features/supply/src/pages/tact-time/hooks/useTactTimeValidation.test.tsx | test | 251 |
| features/supply/src/pages/tact-time/hooks/useTactTimeValidation.ts | hook | 137 |
| features/supply/src/pages/tact-time/index.ts | index | 2 |
| features/supply/src/pages/tact-time/tact-time.constants.ts | constants | 247 |
| features/supply/src/pages/tact-time/tact-time.types.ts | types | 23 |
| features/supply/src/pages/tact-time/TactTime.module.scss | style | 53 |
| features/supply/src/pages/tact-time/TactTime.tsx | page | 348 |
| features/supply/src/pages/tact-time/useTactTimeStore.ts | store | 227 |
| features/supply/src/pages/tact-time/utils/tactTimeColumns.ts | util | 34 |
| features/supply/src/pages/tact-time/utils/tactTimeDerive.test.ts | test | 58 |
| features/supply/src/pages/tact-time/utils/tactTimeDerive.ts | util | 57 |
| features/supply/src/pages/tact-time/utils/tactTimeEditLock.test.ts | test | 118 |
| features/supply/src/pages/tact-time/utils/tactTimeEditLock.ts | util | 189 |
| features/supply/src/pages/tact-time/__asis-mapping__.md | mapping | 83 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | TactTimeForm.tsx:64 |
| (useTabLookupQueries) | hook | 2 | Y | TactTimeForm.tsx:71 TactTime.tsx:58 |
| SCP0020/plant//call-proc | hook | 2 | Y | TactTime.tsx:82 TactTime.tsx:104 |
| SCP0020/packer//call-proc | hook | 2 | Y | TactTime.tsx:89 TactTime.tsx:109 |
| SCP0020/except//call-proc | hook | 2 | Y | TactTime.tsx:96 TactTime.tsx:114 |
| /admin/menu/SCP0020/column | http | 1 | Y | useTactTimeStore.ts:176 |
| /admin/menu/SCP0020/search-conditions | http | 1 | Y | useTactTimeStore.ts:206 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 77 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 106 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 107 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 145 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 130 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 147 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 191 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 228 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 224 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 102 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 144 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 145 |
| editor | beforeinput | <arrow> value.slice,PRIORITY_PATTERN.test,next.replaceAll,ev.preventDefault | addEventListener | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 153 |
| editor | input | <arrow> editor.value.replace(/\D/g,'').slice,editor.value.replace | addEventListener | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 163 |
| g.hostElement | keydown | hostKeydownHandler | addEventListener | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 177 |
| g | prepareCellForEdit | prepareCellForEditHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 190 |
| g | cellEditEnding | cellEditEndingHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 191 |
| g | pastingCell | pastingCellHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 192 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 201 |
| g | formatItem | formatItemHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 211 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 247 |
| TactTimeForm | onSearch | handleSearch | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 259 |
| TactTimeForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 259 |
| TactTimeMainGrid | onRowDblClick | <arrow> exceptSrc.some,setAlert,t,setExceptFilter | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 283 |
| TactTimeMainGrid | onFocus | <arrow> setFocused | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 308 |
| TactTimeExceptGrid | onFocus | <arrow> setFocused | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 322 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| DataGrid | 2 |
| Panel | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| MainTitle | 1 |
| TactTimeForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| TactTimeMainGrid | 1 |
| PanelSeparator | 1 |
| TactTimeExceptGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/tact-time/utils/tactTimeColumns.ts | 16 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00027 | 1 |
| LBL00010 | 1 |
| LBL00618 | 1 |
| MSG00429 | 1 |
| MSG00617 | 1 |
| MSG00002 | 1 |
| MSG00043 | 1 |
| MSG00048 | 1 |
| MSG00611 | 1 |
| MSG01036 | 1 |
| MSG00085 | 1 |
| MSG00105 | 1 |
| MSG00108 | 1 |
| MSG00109 | 1 |
| MSG00662 | 1 |
| MSG01035 | 1 |
| MSG00703 | 1 |
| MSG00137 | 1 |
| MSG00203 | 1 |
| MSG00004 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0020(9), SCM0002(1)
- SP/PKG: SCP0020_GET_TACT_TIME(1), SCP0020_SAVE_TACT_TIME(1), FN_GET_DIVISION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | setCell('TACT_TIME', deriveTactTimeFromDaily(row.DAILY_CAPACITY)); | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 91 |
| jsx | <FunctionSearchIcon appearance='lined' onClick={onItemSearch} /> | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 216 |
| code | setCell('TACT_TIME', deriveTactTimeFromDaily(row.DAILY_CAPACITY)); | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 127 |
| code | if (row) onRowDblClick(row); | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 198 |
| code | AS-IS: 조회된 행이 없으면 신규행 추가 불가 (cs:760/817 ActiveRowIndex<0 return). | features/supply/src/pages/tact-time/TactTime.tsx | 174 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 → | features/supply/src/pages/tact-time/useTactTimeStore.ts | 27 |
| code | if (d === null \|\| d === 0) return 0; | features/supply/src/pages/tact-time/utils/tactTimeDerive.ts | 30 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

