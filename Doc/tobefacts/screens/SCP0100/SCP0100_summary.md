# SCP0100 — To-Be Fact Pack 요약

- page_key: `supply/global-psi-report` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 13 (미해결 0, 주석 속 7) · 이벤트 22 · 컴포넌트 사용 37 · 하드코딩 컬럼 2 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | component | 540 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | component | 260 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | component | 134 |
| features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | constants | 275 |
| features/supply/src/pages/global-psi-report/global-psi-report.types.ts | types | 30 |
| features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | page | 310 |
| features/supply/src/pages/global-psi-report/index.ts | index | 2 |
| features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | store | 322 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportCalendar.ts | util | 23 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | util | 204 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportMerge.ts | util | 42 |
| features/supply/src/pages/global-psi-report/__asis-mapping__.md | mapping | 234 |
| features/supply/src/pages/global-psi-report/__tests__/GlobalPsiReport.spec.ts | test | 198 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | GlobalPsiReportForm.tsx:97 GlobalPsiReportForm.tsx:209 |
| (useTabLookupQueries) | hook | 1 | Y | GlobalPsiReportForm.tsx:100 |
| SCP0100/site//call-proc | hook | 2 | Y | GlobalPsiReportForm.tsx:114 GlobalPsiReportForm.tsx:126 |
| SCP0100/planDate//call-proc | hook | 1 | Y | GlobalPsiReportForm.tsx:141 |
| SCP0100/report//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:70 |
| SCP0100/searchLevel//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:77 |
| SCP0100/searchLevelDetail//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:84 |
| SCP0100/calendar//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:128 |
| /admin/menu/SCP0100/column | http | 1 | Y | useGlobalPsiReportStore.ts:153 |
| /admin/menu/SCP0100/measure | http | 1 | Y | useGlobalPsiReportStore.ts:278 |
| /admin/menu/SCP0100/search-conditions | http | 1 | Y | useGlobalPsiReportStore.ts:299 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 260 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 291 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 324 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 325 |
| FunctionSearchIcon | onClick | onPopup | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 320 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 346 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 347 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 358 |
| PeriodField | onChange | changePeriod | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 407 |
| RadioGroup | onChange | <arrow> setSearchMode | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 445 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 523 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 528 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 193 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 231 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 256 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,alertSaveFailed,queryClient.invalidateQueries | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 80 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed,fetchStaticMeasures | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 113 |
| GlobalPsiReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 226 |
| GlobalPsiReportForm | onItemSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 227 |
| GlobalPsiReportForm | onProjectSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 228 |
| GlobalPsiReportGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 258 |
| GlobalPsiReportModals | onClose | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 305 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 2 |
| InputField | 2 |
| Checkbox | 2 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| RadioGroup | 1 |
| Radio | 1 |
| Stack | 1 |
| DataGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| GlobalPsiReportForm | 1 |
| SubTitle | 1 |
| GlobalPsiReportGrid | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| GlobalPsiReportModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leafOf | c.columnName | Qty | 70 | true | true |  | object | features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | 154 |
| LEVEL_COLS | colNm | colNm |  |  |  |  | meta-map | features/supply/src/pages/global-psi-report/__tests__/GlobalPsiReport.spec.ts | 146 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00618 | 1 |
| LBL00050 | 2 |
| LBL00316 | 1 |
| MSG01186 | 2 |
| MSG00097 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00039 | 1 |
| LBL00013 | 1 |
| LBL00710 | 1 |
| LBL01073 | 1 |
| LBL00040 | 1 |
| LBL00012 | 1 |
| LBL00618 | 1 |
| LBL00049 | 1 |
| LBL00045 | 1 |
| LBL01167 | 1 |
| LBL00690 | 1 |
| LBL00684 | 1 |
| LBL00683 | 1 |
| LBL00605 | 1 |
| LBL00310 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0100(15), SCM0002(2), DMF0021(2), SCP0031(2), SCP0111(1), SCP0025(1), SCP0053(1), SCP0095(1)
- SP/PKG: PKG_SCP0100(8), P_SCP0100_GET_SITE(5), P_SCP0100_GET_PLAN_DATE(4), P_DIVISION_ID(4), P_CHK_AS(2), P_CHK_CELL_QTY(2), P_CELL_GROUP(2), FN_SPLITSTRING(2), P_SITE_TPYE(2), P_BUCKET(2), P_PROGRAM_ID(2), P_SEARCH_LEVEL(2), P_FROM_SITE(2), P_TO_SITE(2), P_SCP0100_GET_GLOBAL_PSI_REPORT(1), P_START_YYYYMMDD(1), P_END_YYYYMMDD(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_PLAN_START_YYYYMMDD(1), P_ITEM_ID(1), P_NICK_NAME(1), P_PROJECT(1), PR_GET_SHEET_COLUMN_LIST(1), P_SCP0100_GET_SHEET_CALENDAR_3SPAN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6) | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 58 |
| endpoint | Plan Type → useTabLookupQueries('PLAN_TYPE') — 기본 'FN'. AS-IS PlanType.Enabled=false(designer:1159) 비활성 | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 59 |
| endpoint | Unit → useTabLookupQueries('SCP_UNIT_QTY')(AS-IS ScpUtils.GetUnitQty) — 로컬 표시배율, 서버 재조회 없음 | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 60 |
| endpoint | 조회조건 콤보 원천 보조 SP 시트 — SCM_ADM_CMBO_SQL_M 미등록(콤보 SQL 아님)이라 useTabProcQuery(SEARCH)로 | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 20 |
| endpoint | 호출한다(design 02 §5.2 "useTabProcQuery(SP, sheet 별도)"). SHEETS(그리드 3시트)와 별개 네임스페이스 — | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 21 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 3시트 등록 확인됨 | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 55 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch ('Global PSI New' 36행, design 03 §1). PIVOT measure 세로축. | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 58 |

## 10. __asis-mapping__.md 상태
- 제외: 8
- 구현: 62
- null = null` 필드 때문에 DataGrid mergeManager prop 전달 시 Wijmo copy() 가 'Unknown property "inner"' 단언 → 화면 열면 그리드 생성 실패(E2E smoke 라벨 0/15). 처리: 필드 제거 — 위임 인스턴스는 모듈 `WeakMap<FlexGrid, CustomMergeManager>` 에 보관(getMergedRange 에서 panel.grid 키로 조회) · 수정 뒤 화면을 열어 콘솔 단언 0 확인 → 2026-10-21 회귀 정정(H06): 위 MergeManager 의 인스턴스 필드 inner 가 Wijmo copy() 'Unknown property' 단언으로 화면 생성 실패(19:22 smoke 오류 화면) → utils/globalPsiReportMerge.ts:17-25 모듈 WeakMap<FlexGrid,CustomMergeManager> 로 이동, 클래스는 메서드만(:27-40): 1
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-001 | §1 usrButton1 / UsrButton | designer 실측 EventName=null·Controls.Add 미등록·codeBehind 참조 0건 = dead control(CA-105 동일) | 제외 |
| D00-1-007 | §1 cboGraphType / UsrCombo | 핸들러 본문 공백(.cs:1773 NO-OP) + 차트 미이관 + LBL 미등록(부록 B-5) — CB-119 동일 | 제외 |
| D00-1-023 | §1 chartMain / ChartControl (splitContainer1.Panel1) | As-is 원문 실측(2026-10-20): designer.cs:1445 `DataBindings = null` · 디자이너 기본 Series 1개(점 0)만 있고 .cs 본문의 chartMain 참조 0건 · 유일한 데이터 주입 후보 `SetCalculating_chart()` 는 주석(.cs:1870) → 데이터가 한 번도 바인딩되지 않는 빈 차트(사실상 dead control, usrButton1 D00-1-001 과 같은 판정). 또한 차트 컴포넌트가 프레임워크 카탈로그·map_control.csv 에 없어 도입 금지(new_screen.md) → GEN_NOTES '룰 보완 후보' 등록 | 제외 |
| D00-2-004 | §2 cboGraphType / SelectedIndexChanged (.cs:1773 본문 공백) | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-007 | §2 cboDisplay / SelectedIndexChanged (.cs:1824) splitContainer Panel1(차트)/Panel2(그리드) 비율 전환 | 핸들러가 바꾸는 것은 Panel1MinSize/SplitterDistance(0/750/270)뿐이고 Panel1 의 유일한 내용물 chartMain 은 데이터가 한 번도 바인딩되지 않는 빈 차트(D00-1-023 제외 근거) → Chart/All 은 빈 영역만 넓혀 그리드를 줄이는 효과. 기본값 Grid 화면은 동일. 빈 패널 재현 여부는 사용자 결정 항목(GEN_NOTES) | 제외 |
| D00-2-014 | §2 cboPlanType / SelectedIndexChanged (.cs:1985 본문 공백) | NO-OP — 살아있는 동작 없음 | 제외 |
| D00-2-017 | §2 chkCellQty / CheckedChanged (.cs:1915 본문 전부 주석) | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-2-018 | §2 chkAS / CheckedChanged (.cs:1924 본문 전부 주석) | 주석 처리 코드(commented_calls) 이식 금지 — 살아있는 동작 없음 | 제외 |
| D00-6-005 | InitSpreadDateColumn / 787·794 (ColumnHeaderSpan 3단 — Large 월 / Small 주 / Qty) | ⚠ 2026-10-21 실측 정정(사용자 확인 요청): 라이브 헤더가 144px 한 칸으로 병합되고 'Qty' 행이 없음 · As-is = 3행(SetSheetHeaderColumn 3) 20/20/20~30px, 0행 LARGE(월) · 1행 SMALL(주)/'Qty' · 2행 'Qty'. 처리 지침 ① utils/globalPsiReportColumns.ts leafOf header 를 'Qty' 고정(As-is ColumnHeaderSpan 이 1~2행을 'Qty' 로 덮음 — COLUMN_LABEL_NAME 사용 금지) ② 행 높이: 공용 DataGrid 는 initialized 1회만 적용하므로 Grid 의 DataGrid initialized 에서 grid.updatedLayout.addHandler(() => { const r = grid.columnHeaders.rows; if (Math.round(r.defaultSize) !== HEADER_ROW_HEIGHT) r.defaultSize = HEADER_ROW_HEIGHT; }) 등록(공용 변경 없음) — 게이트 check.js H01 · E2E smoke 'header' 어노테이션(행 3·리터럴 Qty·높이 ≤32×3)으로 확인 → 2026-10-21 보완: ①leaf 'Qty' 고정(Cols:110·134) ②Grid:202-236 updatedLayout 헤더 행 높이 재적용(공용 변경 없음) — H01 해소. 라이브 헤더 행 수·높이는 런타임 미검증 ⚠ 2026-10-21 18:5x 규칙 정정(사용자 실측 지적): 라이브 = 월 칸 h48(행 0~1 병합) / Qty 행 h24 · Qty 가 전 월에 걸쳐 **1칸(w910)으로 가로 병합** — As-is 와 반대(월 행 20 / Qty 1~2행 병합 40~50, 월마다 Qty 분리). 처리 지침 ① **Qty 칸 분리**: 헤더 가로 병합을 끈다 — DataGrid allowMerging 을 AllowMerging.Cells(본문 병합만) 로 넘기거나 mergeManager 가 ColumnHeader 패널은 건너뛰게(동일 문구 인접 셀 자동 병합 금지). 상단 월 칸이 분리돼 있으면 하단 Qty 도 월마다 자동 분리돼야 한다 ② **행 높이 역전**: 그룹(월/주) 행 = 20px, leaf(Qty) 행 = 40px(As-is 1~2행 병합). applyHeaderHeight 를 행 인덱스별 높이로(마지막 행 40, 나머지 20). 월간은 헤더 2행(월/Qty)이어야 한다 — 현재 3행이 생기는 원인(숨긴 주간 그룹 깊이) 제거 ③ 주간 = 월 20 / 주 20 / Qty 30. 검증 = E2E smoke header 어노테이션(리터럴 칸 수·leaf 행 높이 ≥ 상단 행) → 2026-10-21 수선(E2E smoke header 행 2=72+24 · 18:5x 지침): ①Qty 월마다 분리 + 1·2행 세로 병합 해소 = 화면 전용 GlobalPsiReportMergeManager(기간칼럼 헤더만 Wijmo 기본 컬럼그룹 범위, 고정 컬럼·본문은 공용 CustomMergeManager 위임 — 공용 변경 없음, H05 해소) ②행 높이 = 그룹 20 / Qty 40(월간)·30(주간) 행별 재적용 ③월간 2행(M_ 의 SMALL 라벨로 중간 그룹 생성 안 함). 라이브 헤더는 런타임 미검증 ⚠ 2026-10-21 19:5x 런타임 사고: 수선 1 이 넣은 utils/globalPsiReportMerge.ts 의 `private inner: CustomMergeManager | null = null` 필드 때문에 DataGrid mergeManager prop 전달 시 Wijmo copy() 가 'Unknown property "inner"' 단언 → 화면 열면 그리드 생성 실패(E2E smoke 라벨 0/15). 처리: 필드 제거 — 위임 인스턴스는 모듈 `WeakMap<FlexGrid, CustomMergeManager>` 에 보관(getMergedRange 에서 panel.grid 키로 조회) · 수정 뒤 화면을 열어 콘솔 단언 0 확인 → 2026-10-21 회귀 정정(H06): 위 MergeManager 의 인스턴스 필드 inner 가 Wijmo copy() 'Unknown property' 단언으로 화면 생성 실패(19:22 smoke 오류 화면) → utils/globalPsiReportMerge.ts:17-25 모듈 WeakMap<FlexGrid,CustomMergeManager> 로 이동, 클래스는 메서드만(:27-40) |

