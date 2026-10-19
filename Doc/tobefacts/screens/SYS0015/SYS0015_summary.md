# SYS0015 — To-Be Fact Pack 요약

- page_key: `admin/program` · feature: admin · As-is Fact Pack 없음(화면ID 미대응)
- 파일 7 · 엔드포인트 호출 3 (미해결 0, 주석 속 0) · 이벤트 3 · 컴포넌트 사용 9 · 하드코딩 컬럼 0 · 메시지 2
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/program/components/ProgramForm.tsx | component | 41 |
| features/admin/src/pages/program/components/ProgramMainGrid.tsx | component | 31 |
| features/admin/src/pages/program/index.ts | index | 2 |
| features/admin/src/pages/program/program.constants.ts | constants | 11 |
| features/admin/src/pages/program/Program.module.scss | style | 7 |
| features/admin/src/pages/program/Program.tsx | page | 98 |
| features/admin/src/pages/program/useProgramStore.ts | store | 71 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SYS0015/main//call-proc | hook | 2 | Y | Program.tsx:29 Program.tsx:37 |
| /admin/menu/SYS0015/column | http | 1 | Y | useProgramStore.ts:52 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | setFilters | jsx | features/admin/src/pages/program/components/ProgramForm.tsx | 19 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/admin/src/pages/program/components/ProgramForm.tsx | 31 |
| InputField | onKeyDown | <arrow> setFilters | jsx | features/admin/src/pages/program/components/ProgramForm.tsx | 32 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| InputField | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProgramForm | 1 |
| SubTitle | 1 |
| ProgramMainGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00644 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SYS0004(1)
- SP/PKG: (없음)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

