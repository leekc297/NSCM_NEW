# SCM0019 — To-Be Fact Pack 요약

- page_key: `admin/scp-if-blocking` · feature: admin · As-is Fact Pack 있음
- 파일 8 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 4 · 컴포넌트 사용 10 · 하드코딩 컬럼 0 · 메시지 8
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingForm.tsx | component | 90 |
| features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingGrid.tsx | component | 35 |
| features/admin/src/pages/scp-if-blocking/index.ts | index | 2 |
| features/admin/src/pages/scp-if-blocking/scp-if-blocking.constants.ts | constants | 57 |
| features/admin/src/pages/scp-if-blocking/scp-if-blocking.types.ts | types | 15 |
| features/admin/src/pages/scp-if-blocking/ScpIfBlocking.tsx | page | 211 |
| features/admin/src/pages/scp-if-blocking/useScpIfBlockingStore.ts | store | 146 |
| features/admin/src/pages/scp-if-blocking/__asis-mapping__.md | mapping | 88 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueryResults) | hook | 1 | Y | ScpIfBlocking.tsx:63 |
| SCM0019/main//call-proc | hook | 1 | Y | ScpIfBlocking.tsx:82 |
| /SCM0019/main/SAVE/call-proc | http | 1 | Y | ScpIfBlocking.tsx:114 |
| /admin/menu/SCM0019/column | http | 1 | Y | useScpIfBlockingStore.ts:106 |
| /admin/menu/SCM0019/search-conditions | http | 1 | Y | useScpIfBlockingStore.ts:124 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingForm.tsx | 36 |
| CustomDropdown | onChange | <arrow> String(picked??'').split(',').filter,String(picked??'').split,String,tokens.includes,divisionOptions.map,setSearch | jsx | features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingForm.tsx | 56 |
| PeriodField | onChange | <arrow> setSearch | jsx | features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingForm.tsx | 83 |
| ScpIfBlockingForm | onSearch | handleSearch | jsx | features/admin/src/pages/scp-if-blocking/ScpIfBlocking.tsx | 197 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| SearchArea | 1 |
| Grid | 1 |
| FormItem | 1 |
| CustomDropdown | 1 |
| PeriodField | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ScpIfBlockingForm | 1 |
| SubTitle | 1 |
| ScpIfBlockingGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00013 | 1 |
| LBL00112 | 1 |
| MSG00672 | 1 |
| MSG00006 | 1 |
| MSG00097 | 1 |
| MSG00013 | 1 |
| MSG00004 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCM0019(3), DMF0003(1), SCP0121(1), SSP0020(1), SCP0125(1), DMF0014(1), SCP0101(1), SCP0084(1)
- SP/PKG: PKG_SCM0019(4), P_USER_ID(1), P_SCM0019_SAVE(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | Period* (필수 — AS-IS layoutControlItem6.Text="Period*"). From~To YYYYMMDD. 공백 시 조회 차단(R6). 공용 PeriodField(features/master SearchFields) — 표준 레이아웃·높이정합(36px) 내장. DMF0003 등 선례. PeriodField 가 자체 <Grid> 를 포함하므로 바깥 Grid 로 감싸지 않는다. | features/admin/src/pages/scp-if-blocking/components/ScpIfBlockingForm.tsx | 74 |

## 10. __asis-mapping__.md 상태
- 구현: 10
- 해당없음: 6
- 제외: 2
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-006 | §1 usrLayoutControl1 / UsrLayoutControl | DevExpress 레이아웃 컨테이너(시각 전용) — TO-BE 는 React 셸(MainTitle/SubTitle/SearchArea)로 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-008 | §1 layoutControlGroup1 / LayoutControlGroup | DevExpress 레이아웃 그룹(시각 전용) — React 레이아웃 셸 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-009 | §1 layoutControlGroup2 / LayoutControlGroup | DevExpress 레이아웃 그룹(시각 전용) — React 레이아웃 셸 대체, 대응 컨트롤 없음 | 해당없음 |
| D00-1-012 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 여백 필러(시각 전용) — 대응 컨트롤 없음 | 해당없음 |
| D00-1-013 | §1 imageList1 / ImageList | WinForms 아이콘 리소스 인프라 — TO-BE 아이콘은 공용 컴포넌트 소관, 화면 대응물 없음 | 해당없음 |
| D00-1-014 | §1 components / Container | WinForms 디자이너 인프라(비 UI) — 대응물 없음 | 해당없음 |
| D00-3-001 | §3 SwitchLock / `()` | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23). 잠금 범위 재현 = 키컬럼 상시 S 잠금(D00-3-002)이 전부 — 편집모드 조건부 잠금 없음(이 화면) | 제외 |
| D00-3-004 | §3 LockColumn / 전열(0~max) 잠금(true) — 조회직후 | 조회직후 전열잠금 = EditButton 편집모드 OFF 상태(토글로 해제) — ANL-06 토글 어포던스 미이식, TO-BE 편집 기본 ON·키컬럼만 정적 S 잠금(D00-3-002) | 제외 |

