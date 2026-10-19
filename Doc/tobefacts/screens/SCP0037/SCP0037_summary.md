# SCP0037 — To-Be Fact Pack 요약

- page_key: `supply/operation-lt` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 15 · 컴포넌트 사용 22 · 하드코딩 컬럼 1 · 메시지 13
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | component | 238 |
| features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | component | 253 |
| features/supply/src/pages/operation-lt/hooks/useOperationLTValidation.ts | hook | 68 |
| features/supply/src/pages/operation-lt/index.ts | index | 2 |
| features/supply/src/pages/operation-lt/operation-lt.constants.ts | constants | 112 |
| features/supply/src/pages/operation-lt/operation-lt.types.ts | types | 26 |
| features/supply/src/pages/operation-lt/OperationLT.tsx | page | 210 |
| features/supply/src/pages/operation-lt/useOperationLTStore.ts | store | 195 |
| features/supply/src/pages/operation-lt/utils/operation-lt.columns.ts | util | 36 |
| features/supply/src/pages/operation-lt/utils/operation-lt.editLock.ts | util | 63 |
| features/supply/src/pages/operation-lt/utils/operation-lt.plantSite.ts | util | 105 |
| features/supply/src/pages/operation-lt/__asis-mapping__.md | mapping | 93 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | OperationLTForm.tsx:53 OperationLTGrid.tsx:78 |
| (useTabLookupQueries) | hook | 1 | Y | OperationLTForm.tsx:56 |
| SCP0037/main//call-proc | hook | 2 | Y | OperationLT.tsx:70 OperationLT.tsx:77 |
| /admin/menu/SCP0037/column | http | 1 | Y | useOperationLTStore.ts:114 |
| /admin/menu/SCP0037/search-conditions | http | 1 | Y | useOperationLTStore.ts:144 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,str | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 118 |
| CustomDropdown | onChange | <arrow> onPick,pickMulti | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 147 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 158 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 212 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 213 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 207 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/supply/src/pages/operation-lt/components/OperationLTForm.tsx | 228 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | 135 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | 157 |
| g | pastedCell | pastedCellHandler | addHandler | features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | 179 |
| g.hostElement | dblclick | dblclickHandler | addEventListener | features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | 200 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/operation-lt/components/OperationLTGrid.tsx | 223 |
| OperationLTForm | onSearch | handleSearch | jsx | features/supply/src/pages/operation-lt/OperationLT.tsx | 172 |
| OperationLTForm | onItemSearch | <arrow> setOpenMaterial | jsx | features/supply/src/pages/operation-lt/OperationLT.tsx | 172 |
| OperationLTGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/operation-lt/OperationLT.tsx | 192 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 4 |
| FormItem | 4 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| ItemByPlantSiteModal | 1 |
| MainTitle | 1 |
| OperationLTForm | 1 |
| SubTitle | 1 |
| OperationLTGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildColumns | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/operation-lt/utils/operation-lt.columns.ts | 15 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00672 | 1 |
| MSG00006 | 1 |
| MSG01092 | 1 |
| MSG01122 | 1 |
| MSG00004 | 1 |
| MSG00662 | 1 |
| MSG00699 | 1 |
| LBL00009 | 1 |
| LBL00001 | 1 |
| LBL00005 | 1 |
| LBL00021 | 1 |
| LBL00007 | 1 |
| LBL00112 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0037(7), SCP0020(2), SCP0042(2), SCP0031(1), SCP0100(1), COM0014(1), SCP0025(1)
- SP/PKG: SCP0037_GET_OPERATION_LT(2), PKG_SCP0037(2), SCP0037_SAVE_OPERATION_LT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 운영은 admin 동적 fetch(staticColumns)가 authoritative — 이 상수는 fallback 전용(하드코딩 아님). | features/supply/src/pages/operation-lt/operation-lt.constants.ts | 77 |
| code | F6 저장 조건 복원(fetchSearchConditions)을 컬럼 메타 fetch 보다 먼저 await 한다 — fetchStaticColumns 가 | features/supply/src/pages/operation-lt/OperationLT.tsx | 86 |
| endpoint | ui-dynamic-property-management — admin SCM_MST_SHEET_COLUMNS 동적 fetch (실측 13행 등록됨, design 03 §1). | features/supply/src/pages/operation-lt/useOperationLTStore.ts | 21 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

