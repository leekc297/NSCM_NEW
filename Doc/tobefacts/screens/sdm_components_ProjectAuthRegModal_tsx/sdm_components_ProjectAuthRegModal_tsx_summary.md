# sdm_components_ProjectAuthRegModal_tsx — To-Be Fact Pack 요약

- page_key: `sdm/components/ProjectAuthRegModal.tsx` · feature: sdm · As-is Fact Pack 없음(화면ID 미대응)
- 파일 1 · 엔드포인트 호출 5 (미해결 5, 주석 속 1) · 이벤트 11 · 컴포넌트 사용 8 · 하드코딩 컬럼 0 · 메시지 2
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/sdm/src/components/ProjectAuthRegModal.tsx | other | 638 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| {MENU_ID}/{?SHEETS.POP1_TREE}//call-proc | hook | 1 | N | ProjectAuthRegModal.tsx:137 |
| {MENU_ID}/{?SHEETS.POP1_GRID1}//call-proc | hook | 1 | N | ProjectAuthRegModal.tsx:144 |
| {MENU_ID}/{?SHEETS.POP1_GRID2}//call-proc | hook | 1 | N | ProjectAuthRegModal.tsx:153 |
| {MENU_ID}/{?SHEETS.POP1_GRID3}//call-proc | hook | 1 | N | ProjectAuthRegModal.tsx:162 |
| {MENU_ID}/{?SHEETS.POP1_GRID4}//call-proc | hook | 1 | N | ProjectAuthRegModal.tsx:171 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| document | keydown | onKeyDown | addEventListener | features/sdm/src/components/ProjectAuthRegModal.tsx | 208 |
| button | onClick | <arrow> toggleExpand | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 258 |
| button | onClick | <arrow> selectDept | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 268 |
| g | formatItem | formatHandler | addHandler | features/sdm/src/components/ProjectAuthRegModal.tsx | 375 |
| g.hostElement | click | clickHandler | addEventListener | features/sdm/src/components/ProjectAuthRegModal.tsx | 391 |
| button | onClick | onClick | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 474 |
| input | onChange | <arrow> setUserNameInput | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 515 |
| input | onKeyDown | <arrow> handleUserSearch | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 516 |
| Button | onClick | handleUserSearch | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 526 |
| Button | onClick | modalClose | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 622 |
| Button | onClick | <arrow> handleOk | jsx | features/sdm/src/components/ProjectAuthRegModal.tsx | 630 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| DataGrid | 4 |
| Button | 3 |
| CustomDialog | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SDM1010(3), SDM1020(2)
- SP/PKG: P_SDM1010_(1), PKG_SDM1010(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | 열 때마다 초기화 + 모달 시트 메타 fetch (SHEET_COLUMNS — POP1_TREE/GRID1/2/3/4) | features/sdm/src/components/ProjectAuthRegModal.tsx | 104 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

