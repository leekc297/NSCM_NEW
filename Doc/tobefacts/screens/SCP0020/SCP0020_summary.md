# SCP0020 — To-Be Fact Pack 요약

- page_key: `supply/tact-time` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 17 · 엔드포인트 호출 10 (미해결 0, 주석 속 1) · 이벤트 21 · 컴포넌트 사용 27 · 하드코딩 컬럼 1 · 메시지 23
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | component | 119 |
| features/supply/src/pages/tact-time/components/TactTimeForm.tsx | component | 233 |
| features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | component | 170 |
| features/supply/src/pages/tact-time/hooks/useTactTimeValidation.test.tsx | test | 212 |
| features/supply/src/pages/tact-time/hooks/useTactTimeValidation.ts | hook | 136 |
| features/supply/src/pages/tact-time/index.ts | index | 2 |
| features/supply/src/pages/tact-time/tact-time.constants.ts | constants | 246 |
| features/supply/src/pages/tact-time/tact-time.types.ts | types | 23 |
| features/supply/src/pages/tact-time/TactTime.module.scss | style | 48 |
| features/supply/src/pages/tact-time/TactTime.tsx | page | 302 |
| features/supply/src/pages/tact-time/useTactTimeStore.ts | store | 227 |
| features/supply/src/pages/tact-time/utils/tactTimeColumns.ts | util | 34 |
| features/supply/src/pages/tact-time/utils/tactTimeDerive.test.ts | test | 44 |
| features/supply/src/pages/tact-time/utils/tactTimeDerive.ts | util | 41 |
| features/supply/src/pages/tact-time/utils/tactTimeEditLock.test.ts | test | 114 |
| features/supply/src/pages/tact-time/utils/tactTimeEditLock.ts | util | 186 |
| features/supply/src/pages/tact-time/__asis-mapping__.md | mapping | 83 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | TactTimeForm.tsx:64 |
| (useTabLookupQueries) | hook | 1 | Y | TactTimeForm.tsx:71 |
| SCP0020/plant//call-proc | hook | 2 | Y | TactTime.tsx:66 TactTime.tsx:88 |
| SCP0020/packer//call-proc | hook | 2 | Y | TactTime.tsx:73 TactTime.tsx:93 |
| SCP0020/except//call-proc | hook | 2 | Y | TactTime.tsx:80 TactTime.tsx:98 |
| /admin/menu/SCP0020/column | http | 1 | Y | useTactTimeStore.ts:176 |
| /admin/menu/SCP0020/search-conditions | http | 1 | Y | useTactTimeStore.ts:206 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 62 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 86 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 87 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/tact-time/components/TactTimeExceptGrid.tsx | 115 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 130 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 147 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 191 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 221 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 222 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/tact-time/components/TactTimeForm.tsx | 216 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 90 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 127 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 128 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 136 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/tact-time/components/TactTimeMainGrid.tsx | 166 |
| TactTimeForm | onSearch | handleSearch | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 233 |
| TactTimeForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 233 |
| TactTimeMainGrid | onRowDblClick | <arrow> setExceptFilter | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 257 |
| TactTimeMainGrid | onFocus | <arrow> setFocused | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 265 |
| TactTimeExceptGrid | onFocus | <arrow> setFocused | jsx | features/supply/src/pages/tact-time/TactTime.tsx | 279 |

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
| MSG00137 | 1 |
| MSG00203 | 1 |
| MSG00004 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0020(9), SCM0002(1)
- SP/PKG: SCP0020_GET_TACT_TIME(1), SCP0020_SAVE_TACT_TIME(1), FN_GET_DIVISION(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | AS-IS: 조회된 행이 없으면 신규행 추가 불가 (cs:760/817 ActiveRowIndex<0 return). | features/supply/src/pages/tact-time/TactTime.tsx | 156 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch (미등록 시 빈 배열 → | features/supply/src/pages/tact-time/useTactTimeStore.ts | 27 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

