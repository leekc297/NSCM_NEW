# master_components_projectModal — To-Be Fact Pack 요약

- page_key: `master/components/projectModal` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 4 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 5 · 컴포넌트 사용 13 · 하드코딩 컬럼 0 · 메시지 5
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/projectModal/project-modal-constants.ts | constants | 8 |
| features/master/src/components/projectModal/ProjectModal.module.scss | style | 19 |
| features/master/src/components/projectModal/ProjectModal.tsx | page | 217 |
| features/master/src/components/projectModal/projectModalStore.ts | store | 41 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ProjectModal.tsx:45 |
| COM0012/project//call-proc | hook | 1 | Y | ProjectModal.tsx:58 |
| /admin/menu/COM0012/column | http | 1 | Y | projectModalStore.ts:27 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/master/src/components/projectModal/ProjectModal.tsx | 141 |
| InputField | onChange | <arrow> handleProjectChange | jsx | features/master/src/components/projectModal/ProjectModal.tsx | 168 |
| InputField | onKeyDown | <arrow> handleSearch | jsx | features/master/src/components/projectModal/ProjectModal.tsx | 169 |
| Button | onClick | handleSubmit | jsx | features/master/src/components/projectModal/ProjectModal.tsx | 202 |
| Button | onClick | modalClose | jsx | features/master/src/components/projectModal/ProjectModal.tsx | 209 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 2 |
| FormItem | 2 |
| Button | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| InputField | 1 |
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
| LBL00012 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: COM0012(1), DMF0082(1)
- SP/PKG: PKG_COM0000(1), P_COM0012_GET_PROJECT_BY_ONLY_DIVISION_POPUP(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

