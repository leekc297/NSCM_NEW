# master_components_projectByDivisionModal — To-Be Fact Pack 요약

- page_key: `master/components/projectByDivisionModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 4 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 23 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/projectByDivisionModal/project-by-division-modal.constants.ts | constants | 8 |
| features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.module.scss | style | 42 |
| features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | page | 399 |
| features/master/src/components/projectByDivisionModal/projectByDivisionModalStore.ts | store | 43 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ProjectByDivisionModal.tsx:72 ProjectByDivisionModal.tsx:83 |
| COM0005/projectByDivision//call-proc | hook | 1 | Y | ProjectByDivisionModal.tsx:91 |
| /admin/menu/COM0005/column | http | 1 | Y | projectByDivisionModalStore.ts:29 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | 239 |
| InputField | onChange | <arrow> setProjectCode | jsx | features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | 338 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | 339 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | 384 |
| Button | onClick | modalClose | jsx | features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx | 391 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| CustomDropdown | 4 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| InputField | 1 |
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
| LBL00334 | 1 |
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00044 | 1 |
| LBL00080 | 1 |
| LBL00011 | 1 |
| LBL00012 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0005(3), DMF0020(1), DMF0021(1), DMF0082(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

