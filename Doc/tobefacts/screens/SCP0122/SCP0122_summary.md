# SCP0122 — To-Be Fact Pack 요약

- page_key: `supply/plan-activity-mgmt` · feature: supply · As-is Fact Pack 있음
- 파일 11 · 엔드포인트 호출 6 (미해결 0, 주석 속 0) · 이벤트 6 · 컴포넌트 사용 15 · 하드코딩 컬럼 0 · 메시지 9
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | component | 188 |
| features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtGrid.tsx | component | 84 |
| features/supply/src/pages/plan-activity-mgmt/index.ts | index | 2 |
| features/supply/src/pages/plan-activity-mgmt/plan-activity-mgmt.constants.ts | constants | 79 |
| features/supply/src/pages/plan-activity-mgmt/plan-activity-mgmt.types.ts | types | 14 |
| features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx | page | 227 |
| features/supply/src/pages/plan-activity-mgmt/usePlanActivityMgmtStore.ts | store | 144 |
| features/supply/src/pages/plan-activity-mgmt/utils/plan-activity-mgmt.util.test.ts | test | 102 |
| features/supply/src/pages/plan-activity-mgmt/utils/plan-activity-mgmt.util.ts | util | 131 |
| features/supply/src/pages/plan-activity-mgmt/__asis-mapping__.md | mapping | 130 |
| features/supply/src/pages/plan-activity-mgmt/__tests__/PlanActivityMgmt.asis.spec.ts | test | 36 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | PlanActivityMgmtForm.tsx:39 PlanActivityMgmtGrid.tsx:34 |
| SCP0122/main//call-proc | hook | 1 | Y | PlanActivityMgmt.tsx:50 |
| /SCP0122/main/SAVE/call-proc | http | 1 | Y | PlanActivityMgmt.tsx:107 |
| /admin/menu/SCP0122/column | http | 1 | Y | usePlanActivityMgmtStore.ts:102 |
| /admin/menu/SCP0122/search-conditions | http | 1 | Y | usePlanActivityMgmtStore.ts:126 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId planGroupId prsCd | o_rc1 | SCP0122_GET_PLAN_ACTIVITY_MGMT |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 109 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,setDivision | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 123 |
| CustomDropdown | onChange | <arrow> planGroupOptions.find,setSearchParams,String | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 148 |
| CustomDropdown | onChange | <arrow> processOptions.find,setSearchParams,String | jsx | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtForm.tsx | 172 |
| grid | cellEditEnded | handleCellEditEnded | addHandler | features/supply/src/pages/plan-activity-mgmt/components/PlanActivityMgmtGrid.tsx | 62 |
| PlanActivityMgmtForm | onSearch | handleSearch | jsx | features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx | 207 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 3 |
| SearchArea | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| PlanActivityMgmtForm | 1 |
| SubTitle | 1 |
| PlanActivityMgmtGrid | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00002 | 1 |
| LBL00059 | 1 |
| LBL00112 | 1 |
| MSG00667 | 1 |
| MSG00004 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00428 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0122(5), SCP0006(3), SCP0123(2), SCP0025(1), SCP0005(1)
- SP/PKG: SCP0122_GET_PLAN_ACTIVITY_MGMT(3), SCP0121_GET_SEARCH_INFO(2), SCP0122_SAVE_PLAN_ACTIVITY_MGMT(2), P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 실패 = AS-IS 와 같이 "Error!\nMsg : <SP 오류문>" 알림, 편집 상태 유지. | features/supply/src/pages/plan-activity-mgmt/PlanActivityMgmt.tsx | 120 |

## 10. __asis-mapping__.md 상태
- 해당없음: 11
- 구현: 14
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-001 | §1 usrLayoutControl1 / UsrLayoutControl | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-002 | §1 layoutControlGroup1 / LayoutControlGroup | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-003 | §1 usrLayoutControl2 / UsrLayoutControl | WinForms/DevExpress 레이아웃 컨테이너 — 단 cs:124 `SetDivisionAuthCheck(usrLayoutControl2)` 의 비활성화는 Form `noAuthDivision`(components/PlanActivityMgmtForm.tsx:91) 로 이식 | 해당없음 |
| D00-1-007 | §1 layoutControlGroup2 / LayoutControlGroup | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-008 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-009 | §1 layoutControlItem2 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-010 | §1 layoutControlItem9 / LayoutControlItem | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-1-011 | §1 Division / LayoutControlItem | WinForms/DevExpress 레이아웃 라벨 — FormItem label LBL00001 로 흡수 | 해당없음 |
| D00-1-013 | §1 spdMain_Sheet1 / SheetView | FpSpread 디자이너 SheetView — DataGrid 1개 + SHEETS.MAIN='main' 으로 흡수 | 해당없음 |
| D00-1-014 | §1 imageList1 / ImageList | WinForms/DevExpress 레이아웃·디자이너 아티팩트 — React JSX/SCSS·FormItem label·공용 인디케이터로 흡수 | 해당없음 |
| D00-6-001 | §6 타이틀 SP / DB루프 컬럼 생성 — 없음 | 2026-10-22 진단: As-is 에 GetSpdTitle·*_GET_SHEET_CALENDAR_3SPAN·*_SPREAD_TITLE·InitSpreadDateColumn·Add*Column DB루프 없음(Fact Pack summary §2·§4-2·§11 = 메타형 `SetSheetHeaderColumnSCP@SetSpreadInit:212` 와 Designer 속성 4행뿐). 컬럼 = SCM_MST_SHEET_COLUMNS 'Plan Activity Mgmt' 15행(admin 컬럼 메타, D00-5-001). 헤더 1행(`AddSheet(spdMain,…,1,1,30)` cs:185) — ColumnHeaderSpan/리터럴 leaf 없음(H01·H05 대상 아님). RESPONSE_SET `o_rc1` = proc_params OUT COL_NM 일치(B26) | 해당없음 |

