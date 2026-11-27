# SCP0100 — To-Be Fact Pack 요약

- page_key: `supply/global-psi-report` · feature: supply · As-is Fact Pack 있음
- 파일 12 · 엔드포인트 호출 13 (미해결 1, 주석 속 5) · 이벤트 20 · 컴포넌트 사용 37 · 하드코딩 컬럼 1 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.module.scss | component | 13 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | component | 610 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | component | 345 |
| features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | component | 138 |
| features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | constants | 278 |
| features/supply/src/pages/global-psi-report/global-psi-report.types.ts | types | 30 |
| features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | page | 335 |
| features/supply/src/pages/global-psi-report/index.ts | index | 2 |
| features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | store | 316 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | util | 179 |
| features/supply/src/pages/global-psi-report/utils/globalPsiReportMerge.ts | util | 30 |
| features/supply/src/pages/global-psi-report/__asis-mapping__.md | mapping | 129 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | GlobalPsiReportForm.tsx:118 |
| (useTabLookupQueries) | hook | 1 | Y | GlobalPsiReportForm.tsx:125 |
| SCP0100/site//call-proc | hook | 2 | Y | GlobalPsiReportForm.tsx:137 GlobalPsiReportForm.tsx:148 |
| SCP0100/planDate//call-proc | hook | 1 | Y | GlobalPsiReportForm.tsx:165 |
| {?{comboId:PLAN_END_DATE_COMBO_ID,divisionId:PLAN_END_DATE_DIVISION,planName:planS} | http | 1 | N | GlobalPsiReportForm.tsx:273 |
| SCP0100/report//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:71 |
| SCP0100/searchLevel//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:78 |
| SCP0100/searchLevelDetail//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:85 |
| SCP0100/calendar//call-proc | hook | 1 | Y | GlobalPsiReport.tsx:138 |
| /admin/menu/SCP0100/column | http | 1 | Y | useGlobalPsiReportStore.ts:150 |
| /admin/menu/SCP0100/measure | http | 1 | Y | useGlobalPsiReportStore.ts:272 |
| /admin/menu/SCP0100/search-conditions | http | 1 | Y | useGlobalPsiReportStore.ts:293 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 313 |
| RadioGroup | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 340 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 373 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 407 |
| Button | onClick | onPopup | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 403 |
| InputField | onChange | <arrow> onChange | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 428 |
| SearchArea | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 439 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 528 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 591 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 596 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 257 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 314 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportGrid.tsx | 341 |
| ColumnLayoutModal | onSave | <arrow> settings.filter,saveTitleSet({menuId:MENU_ID,sheetName,columnType:TITLESET_COLUMN_TYPE,rows:visible.map((s,i)=>({name:s.COLUMN_NAME,sortOrderNo:i+1,colWidth:s.COL_WIDTH,cellColor:s.CELL_COLOR,textColor:s.TEXT_COLOR,})),}).then,saveTitleSet,visible.map,alertSaveFailed,queryClient.invalidateQueries | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 81 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed,fetchStaticMeasures | jsx | features/supply/src/pages/global-psi-report/components/GlobalPsiReportModals.tsx | 117 |
| GlobalPsiReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 242 |
| GlobalPsiReportForm | onItemSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 243 |
| GlobalPsiReportForm | onProjectSearch | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 244 |
| GlobalPsiReportGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 277 |
| GlobalPsiReportModals | onClose | <arrow> setPopupTarget | jsx | features/supply/src/pages/global-psi-report/GlobalPsiReport.tsx | 330 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 7 |
| FormItem | 6 |
| CustomDropdown | 2 |
| InputField | 2 |
| Checkbox | 2 |
| RadioGroup | 1 |
| Radio | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
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
| leafOf | c.columnName | Qty | 70 | true | true |  | object | features/supply/src/pages/global-psi-report/utils/globalPsiReportColumns.ts | 129 |

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
| LBL00012 | 1 |
| LBL00049 | 1 |
| LBL01163 | 1 |
| LBL00767 | 1 |
| LBL00690 | 1 |
| LBL01167 | 1 |
| LBL00684 | 1 |
| LBL00683 | 1 |
| LBL00605 | 1 |
| LBL00310 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0100(24), SCP0031(11), SCM0002(3), DMF0021(2), SCP0098(1), SCP0111(1), COM0013(1), COM0005(1), SCP0025(1), SCP0053(1), SCP0095(1)
- SP/PKG: P_DIVISION_ID(7), P_SCP0100_GET_SITE(5), P_SCP0100_GET_PLAN_DATE(5), PKG_SCP0100(5), P_BUCKET(4), P_ITEM_ID(3), P_PROJECT(3), FN_SPLITSTRING(3), P_CHK_AS(2), P_CHK_CELL_QTY(2), P_CELL_GROUP(2), P_NICK_NAME(2), P_SITE_TPYE(2), P_PROGRAM_ID(2), P_START_YYYYMMDD(2), P_FROM_SITE(2), P_TO_SITE(2), PR_GET_SHEET_COLUMN_LIST(2), P_SCP0100_GET_GLOBAL_PSI_REPORT(1), P_END_YYYYMMDD(1), DM0003_GET_BUCKET_TYPE_CODE(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_PLAN_START_YYYYMMDD(1), P_P_START_YYYYMMDD(1), PR_GET_SHEET_MEASURE_LIST(1), PKG_COM0000(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | Search Level → useTabLookupQueries('PRODUCT_LEVEL') — idx0=CELL_GROUP(§2.6) | features/supply/src/pages/global-psi-report/components/GlobalPsiReportForm.tsx | 61 |
| endpoint | 조회조건 콤보 원천 보조 SP 시트 — SCM_ADM_CMBO_SQL_M 미등록(콤보 SQL 아님)이라 useTabProcQuery(SEARCH)로 | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 20 |
| endpoint | 호출한다(design 02 §5.2 "useTabProcQuery(SP, sheet 별도)"). SHEETS(그리드 3시트)와 별개 네임스페이스 — | features/supply/src/pages/global-psi-report/global-psi-report.constants.ts | 21 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). 3시트 등록 확인됨 | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 56 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch ('Global PSI New' 36행, design 03 §1). PIVOT measure 세로축. | features/supply/src/pages/global-psi-report/useGlobalPsiReportStore.ts | 59 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

