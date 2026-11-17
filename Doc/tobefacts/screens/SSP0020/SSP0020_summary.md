# SSP0020 — To-Be Fact Pack 요약

- page_key: `shipping/delegate` · feature: shipping · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 7 (미해결 0, 주석 속 1) · 이벤트 8 · 컴포넌트 사용 25 · 하드코딩 컬럼 1 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/delegate/components/DelegateForm.module.scss | component | 13 |
| features/shipping/src/pages/delegate/components/DelegateForm.tsx | component | 173 |
| features/shipping/src/pages/delegate/components/DelegateGrid.tsx | component | 50 |
| features/shipping/src/pages/delegate/delegate.constants.ts | constants | 147 |
| features/shipping/src/pages/delegate/Delegate.module.scss | style | 8 |
| features/shipping/src/pages/delegate/Delegate.tsx | page | 493 |
| features/shipping/src/pages/delegate/delegate.types.ts | types | 18 |
| features/shipping/src/pages/delegate/hooks/useDelegateValidation.ts | hook | 156 |
| features/shipping/src/pages/delegate/index.ts | index | 2 |
| features/shipping/src/pages/delegate/useDelegateStore.ts | store | 157 |
| features/shipping/src/pages/delegate/utils/delegateColumns.ts | util | 42 |
| features/shipping/src/pages/delegate/__asis-mapping__.md | mapping | 107 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueryResults) | hook | 1 | Y | Delegate.tsx:92 |
| SSP0020/Delegate//call-proc | hook | 1 | Y | Delegate.tsx:116 |
| /SSP0020/Delegate/SAVE/call-proc | http | 1 | Y | Delegate.tsx:251 |
| /SSP0020/Delegate/UNSET/call-proc | http | 1 | Y | Delegate.tsx:346 |
| /SSP0020/Delegate/USER_CHECK/call-proc | http | 1 | Y | useDelegateValidation.ts:137 |
| /admin/menu/SSP0020/column | http | 1 | Y | useDelegateStore.ts:100 |
| /admin/menu/SSP0020/search-conditions | http | 1 | Y | useDelegateStore.ts:126 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 55 |
| InputField | onChange | <arrow> setInput | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 83 |
| Button | onClick | onDelegateeSearch | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 78 |
| CustomDropdown | onChange | <arrow> String(picked??'').split(',').filter,String(picked??'').split,String,tokens.includes,setInput,tokens.filter | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 106 |
| DatePickerCalendar | onChange | <arrow> setInput,date?.format | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 143 |
| DatePickerCalendar | onChange | <arrow> setInput,date?.format | jsx | features/shipping/src/pages/delegate/components/DelegateForm.tsx | 158 |
| DelegateForm | onSearch | handleSearch | jsx | features/shipping/src/pages/delegate/Delegate.tsx | 435 |
| DelegateForm | onDelegateeSearch | <arrow> setOpenUser | jsx | features/shipping/src/pages/delegate/Delegate.tsx | 436 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| DatePickerCalendar | 2 |
| TabItem | 2 |
| DelegateGrid | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| CustomDropdown | 1 |
| DataGrid | 1 |
| IcSave | 1 |
| ControlCloseIcon | 1 |
| MainTitle | 1 |
| DelegateForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| SsoUserModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| col | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/shipping/src/pages/delegate/utils/delegateColumns.ts | 25 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00672 | 1 |
| MSG01288 | 1 |
| MSG00667 | 1 |
| MSG01302 | 1 |
| MSG00700 | 1 |
| MSG01301 | 1 |
| MSG01308 | 1 |
| MSG01153 | 1 |
| MSG00219 | 1 |
| MSG01299 | 1 |
| MSG01300 | 1 |
| MSG01303 | 1 |
| MSG01305 | 1 |
| MSG01304 | 1 |
| LBL00001 | 1 |
| LBL00013 | 1 |
| LBL01069 | 1 |
| LBL00112 | 1 |
| LBL00111 | 1 |
| LBL01128 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0020(6), SSP0014(3)
- SP/PKG: PKG_SSP0020(10), P_USER_CHECK(6), P_SAVE_UNSET(2), P_GET_DELEGATE(1), P_SAVE_DELEGATE(1), P_DIVISION_ID(1), SSP0020_GET_DELEGATE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 없어 SmartColMergeOld() 가 병합 기준 컬럼을 못 찾고 즉시 return(SpreadInfo.cs:13225-13240). | features/shipping/src/pages/delegate/components/DelegateGrid.tsx | 24 |
| code | `string.IsNullOrEmpty(sDelegateeID) && UserName_Search(txtDelegatee.Text) == false → return` | features/shipping/src/pages/delegate/Delegate.tsx | 195 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (2시트) — 미등록/실패 시 빈 배열(그리드 constants fallback). | features/shipping/src/pages/delegate/useDelegateStore.ts | 96 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

