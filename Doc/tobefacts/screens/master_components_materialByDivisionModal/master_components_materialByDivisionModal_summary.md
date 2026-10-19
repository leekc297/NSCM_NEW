# master_components_materialByDivisionModal — To-Be Fact Pack 요약

- page_key: `master/components/materialByDivisionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 18 · 하드코딩 컬럼 0 · 메시지 4
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/materialByDivisionModal/material-by-division-modal.constants.ts | constants | 19 |
| features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.module.scss | style | 20 |
| features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | page | 350 |
| features/master/src/components/materialByDivisionModal/materialByDivisionModalStore.ts | store | 42 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | MaterialByDivisionModal.tsx:111 |
| COM0013/materialByDivision//call-proc | hook | 1 | Y | MaterialByDivisionModal.tsx:128 |
| /admin/menu/COM0013/column | http | 1 | Y | materialByDivisionModalStore.ts:30 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | 244 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | 296 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | 297 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | 335 |
| Button | onClick | modalClose | jsx | features/master/src/components/materialByDivisionModal/MaterialByDivisionModal.tsx | 342 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| InputField | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| ControlConfirmIcon | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00021 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0013(2), COM0008(2), SCP0022(1), SCM0002(1)
- SP/PKG: SCM0001_GET_DIVISION(2), PKG_SCM0002(1), P_SCM0002_GET_MATERIAL_BY_DIVISION(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

