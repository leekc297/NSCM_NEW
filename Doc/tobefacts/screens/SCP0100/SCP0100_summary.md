# SCP0100 — To-Be Fact Pack 요약

- page_key: `supply/global-psi-report` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 13 (미해결 0, 주석 속 7) · 이벤트 20 · 컴포넌트 사용 32 · 하드코딩 컬럼 2 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | component | 510 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | component | 217 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | component | 124 |
| features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | constants | 275 |
| features/supply/src/pages/global-psi-report/global-psi-report.types.ts | types | 30 |
| features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | page | 310 |
| features/supply/src/pages/global-psi-report/index.ts | index | 2 |
| features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | store | 322 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportCalendar.ts | util | 23 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | util | 170 |
| features/supply/src/pages/global-psi-report/__asis-mapping__.md | mapping | 231 |
| features/supply/src/pages/global-psi-report/__tests__/GlobalPsiReport.spec.ts | test | 168 |

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
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 492 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 501 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 190 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 213 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,alertSaveFailed,queryClient.invalidateQueries | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 70 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed,fetchStaticMeasures | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 103 |
| GlobalPsiReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 226 |
| GlobalPsiReportForm | onItemSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 227 |
| GlobalPsiReportForm | onProjectSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 228 |
| GlobalPsiReportGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 258 |
| GlobalPsiReportModals | onClose | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 305 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 4 |
| CustomDropdown | 2 |
| InputField | 2 |
| Checkbox | 2 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
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
| leafOf | c.columnName | c.columnLabel \|\| 'Qty' | 70 | true | true |  | object | features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | 128 |
| LEVEL_COLS | colNm | colNm |  |  |  |  | meta-map | features/supply/src/pages/global-psi-report/__tests__/GlobalPsiReport.spec.ts | 116 |

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
- 화면ID: SCP0100(14), SCM0002(2), DMF0021(2), SCP0031(2), SCP0111(1), SCP0025(1), SCP0053(1), SCP0095(1)
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
- 구현: 61
- 미구현: 3
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
| D00-7-015 | 카탈로그 'Global PSI New' NoName(Search Level/Detail 라디오) = 조회조건 삭제 | 사람 판단 필요: 카탈로그(2026-01-22 v0.4)는 삭제 지시이나, 삭제하면 Detail(REPORT 시트) 진입 경로가 사라짐 — 이후 REPORT 시트 SHEET_COLUMNS 15행·btn_auth 'report' 시트 등록(2026-09-24)이 기능 유지 근거. hook #112 §4-1 '최신 지시 우선·충돌 보고' | 미구현 |
| D00-7-016 | 카탈로그 Cell Qty·A/S 체크박스 = 공통기능화 검토(조회영역 승계 금지, 임의 삭제도 금지) | 사용자 확인 필요: hook #112 §2.5 — 재배치(표시 옵션/공통버튼 등)는 확정 스펙 아님. P_CHK_CELL_QTY/P_CHK_AS 는 SP 파라미터라 위치만 결정 대상 | 미구현 |
| D00-7-017 | MSG01186 KO 문구('조회 시작일은 Plan Date보다 크거나 같아야 합니다.')가 EN·AS-IS 규칙과 반대 의미 | 사용자 결정 필요: 기존 MSG 문구 UPDATE 는 #140(MSG 원장 INSERT 전용) 범위 밖 — KO 사용자에게 반대 안내가 나감 | 미구현 |

