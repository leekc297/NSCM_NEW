# SYS0004 — To-Be Fact Pack 요약

- page_key: `admin/ui-catrgory-setup` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 10 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 26 · 하드코딩 컬럼 0 · 메시지 11
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/ui-catrgory-setup/components/UICategoryColumnGrid.tsx | component | 35 |
| features/admin/src/pages/ui-catrgory-setup/components/UICategoryMeasureGrid.tsx | component | 35 |
| features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.module.scss | component | 18 |
| features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | component | 115 |
| features/admin/src/pages/ui-catrgory-setup/index.ts | index | 2 |
| features/admin/src/pages/ui-catrgory-setup/ui-category-setup.constants.ts | constants | 18 |
| features/admin/src/pages/ui-catrgory-setup/ui-category-setup.types.ts | types | 8 |
| features/admin/src/pages/ui-catrgory-setup/UICategorySetup.tsx | page | 133 |
| features/admin/src/pages/ui-catrgory-setup/useUICategorySetupSave.ts | hook | 78 |
| features/admin/src/pages/ui-catrgory-setup/useUICategorySetupStore.ts | store | 110 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | UICategorySetupForm.tsx:17 |
| SYS0004/column//call-proc | hook | 1 | Y | UICategorySetup.tsx:44 |
| SYS0004//SAVE/call-proc | http | 1 | Y | useUICategorySetupSave.ts:46 |
| /admin/menu/SYS0004/column | http | 2 | Y | useUICategorySetupStore.ts:70 useUICategorySetupStore.ts:73 |
| /admin/menu/SYS0004/search-conditions | http | 1 | Y | useUICategorySetupStore.ts:85 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| column | programId sheetName columnName columnLabelName valid | column measure |  |
| measure | programId sheetName columnName columnLabelName valid | column measure |  |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 24 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 37 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 53 |
| CustomDropdown | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 71 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 87 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/ui-catrgory-setup/components/UICategorySetupForm.tsx | 103 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 5 |
| InputField | 4 |
| DataGrid | 2 |
| TabItem | 2 |
| SearchArea | 1 |
| CustomDropdown | 1 |
| MainTitle | 1 |
| UICategorySetupForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |
| UICategoryColumnGrid | 1 |
| UICategoryMeasureGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00305 | 1 |
| LBL00306 | 1 |
| LBL00007 | 1 |
| LBL00307 | 1 |
| LBL00308 | 1 |
| LBL00309 | 1 |
| LBL00310 | 1 |
| MSG00003 | 2 |
| MSG00002 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: (없음)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 이 화면 전용 저장 뮤테이션 — 공통 useProcMutation 을 쓰지 않는 이유. 저장이 실패했는데도 "성공적으로 저장되었습니다!" 토스트가 뜨고 재조회로 넘어가는 문제가 있다 (2026-09-16 리포트 — SP 가 ORA-20001 로 막았는데 화면은 성공으로 보였다). 원인은 axios 에러 인터셉터가 HTTP 500 을 reject 가 아니라 **성공 응답으로 되돌려 보내는** 데 있다 (packages/found | features/admin/src/pages/ui-catrgory-setup/useUICategorySetupSave.ts | 8 |
| code | import type { SearchParamProps } from './ui-category-setup.types'; | features/admin/src/pages/ui-catrgory-setup/useUICategorySetupStore.ts | 6 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

