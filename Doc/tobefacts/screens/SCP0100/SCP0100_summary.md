# SCP0100 — To-Be Fact Pack 요약

- page_key: `supply/global-psi-report` · feature: supply · As-is Fact Pack 있음
- 파일 10 · 엔드포인트 호출 12 (미해결 0, 주석 속 7) · 이벤트 19 · 컴포넌트 사용 31 · 하드코딩 컬럼 1 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | component | 440 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | component | 180 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | component | 124 |
| features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | constants | 225 |
| features/supply/src/pages/global-psi-report/global-psi-report.types.ts | types | 30 |
| features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | page | 303 |
| features/supply/src/pages/global-psi-report/index.ts | index | 2 |
| features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | store | 301 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | util | 128 |
| features/supply/src/pages/global-psi-report/__asis-mapping__.md | mapping | 129 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | GlobalPsiReportForm.tsx:87 |
| (useTabLookupQueries) | hook | 1 | Y | GlobalPsiReportForm.tsx:90 |
| SCP0100/site//call-proc | hook | 2 | Y | GlobalPsiReportForm.tsx:102 GlobalPsiReportForm.tsx:113 |
| SCP0100/planDate//call-proc | hook | 1 | Y | GlobalPsiReportForm.tsx:126 |
| SCP0100/report//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:69 |
| SCP0100/searchLevel//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:76 |
| SCP0100/searchLevelDetail//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:83 |
| SCP0100/calendar//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:124 |
| /admin/menu/SCP0100/column | http | 1 | Y | useGlobalPsiReportStore.ts:145 |
| /admin/menu/SCP0100/measure | http | 1 | Y | useGlobalPsiReportStore.ts:257 |
| /admin/menu/SCP0100/search-conditions | http | 1 | Y | useGlobalPsiReportStore.ts:278 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 206 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 233 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 266 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 267 |
| FunctionSearchIcon | onClick | onPopup | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 262 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 288 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 289 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 300 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 422 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 431 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 153 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 176 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,alertSaveFailed,queryClient.invalidateQueries | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 70 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed,fetchStaticMeasures | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 103 |
| GlobalPsiReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 227 |
| GlobalPsiReportForm | onItemSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 228 |
| GlobalPsiReportForm | onProjectSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 229 |
| GlobalPsiReportGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 257 |
| GlobalPsiReportModals | onClose | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 298 |

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
| DataGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| GlobalPsiReportForm | 1 |
| SubTitle | 1 |
| GlobalPsiReportGrid | 1 |
| ItemByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| GlobalPsiReportModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leafOf | c.columnName | c.columnLabel \|\| 'Qty' | 70 | true | true |  | object | features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | 86 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00618 | 1 |
| MSG00097 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00039 | 1 |
| LBL00710 | 1 |
| LBL01073 | 1 |
| LBL00050 | 1 |
| LBL00040 | 1 |
| LBL00617 | 1 |
| LBL00049 | 1 |
| LBL01129 | 1 |
| LBL00767 | 1 |
| LBL00690 | 1 |
| LBL00684 | 1 |
| LBL00683 | 1 |
| LBL00605 | 1 |
| LBL00310 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0100(12), SCM0002(3), DMF0021(2), SCP0111(1), SCP0031(1), SCP0025(1), SCP0053(1), SCP0095(1)
- SP/PKG: P_SCP0100_GET_SITE(5), P_SCP0100_GET_PLAN_DATE(5), PKG_SCP0100(5), P_CHK_AS(2), P_CHK_CELL_QTY(2), P_CELL_GROUP(2), P_SITE_TPYE(2), P_DIVISION_ID(2), P_BUCKET(2), P_PROGRAM_ID(2), P_FROM_SITE(2), P_TO_SITE(2), P_SCP0100_GET_GLOBAL_PSI_REPORT(1), P_START_YYYYMMDD(1), P_END_YYYYMMDD(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_PLAN_START_YYYYMMDD(1), P_ITEM_ID(1), P_NICK_NAME(1), P_PROJECT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Display → useTabLookupQueries('STOCK_TREND_DISPLAY') — 뷰 전환(로컬). 기본 GRID(§2.6) | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 50 |
| endpoint | Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6) | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 51 |
| endpoint | Plan Type → useTabLookupQueries('PLAN_TYPE') — 기본 'FN'(§2.6). AS-IS 자동재조회 NO-OP(§3) | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 52 |
| endpoint | 조회조건 콤보 원천 보조 SP 시트 — SCM_ADM_CMBO_SQL_M 미등록(콤보 SQL 아님)이라 useTabProcQuery(SEARCH)로 | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 20 |
| endpoint | 호출한다(design 02 §5.2 "useTabProcQuery(SP, sheet 별도)"). SHEETS(그리드 3시트)와 별개 네임스페이스 — | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 21 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 3시트 등록 확인됨 | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 54 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch ('Global PSI New' 36행, design 03 §1). PIVOT measure 세로축. | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 57 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

