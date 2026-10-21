# SCP0107 — To-Be Fact Pack 요약

- page_key: `supply/capa-teep-report` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 15 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 15 · 컴포넌트 사용 42 · 하드코딩 컬럼 1 · 메시지 26
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-teep-report/capa-teep-report.constants.ts | constants | 349 |
| features/supply/src/pages/capa-teep-report/capa-teep-report.types.ts | types | 132 |
| features/supply/src/pages/capa-teep-report/CapaTeepReport.tsx | page | 370 |
| features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | component | 378 |
| features/supply/src/pages/capa-teep-report/components/CapaTeepReportGrid.module.scss | component | 28 |
| features/supply/src/pages/capa-teep-report/components/CapaTeepReportGrid.tsx | component | 166 |
| features/supply/src/pages/capa-teep-report/components/modals/CapaTeepReportColumnModal.tsx | component | 120 |
| features/supply/src/pages/capa-teep-report/hooks/useCapaTeepReportCombos.ts | hook | 304 |
| features/supply/src/pages/capa-teep-report/hooks/useCapaTeepReportConditionEffects.ts | hook | 70 |
| features/supply/src/pages/capa-teep-report/index.ts | index | 2 |
| features/supply/src/pages/capa-teep-report/useCapaTeepReportStore.ts | store | 440 |
| features/supply/src/pages/capa-teep-report/utils/capaTeepReport.combos.ts | util | 461 |
| features/supply/src/pages/capa-teep-report/utils/capaTeepReport.cursors.ts | util | 54 |
| features/supply/src/pages/capa-teep-report/utils/capaTeepReport.dateColumns.ts | util | 162 |
| features/supply/src/pages/capa-teep-report/__asis-mapping__.md | mapping | 432 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0107/ASSEMBLY//call-proc | hook | 1 | Y | CapaTeepReport.tsx:83 |
| SCP0107/ELTR//call-proc | hook | 1 | Y | CapaTeepReport.tsx:90 |
| SCP0107/spreadTitle//call-proc | hook | 1 | Y | CapaTeepReport.tsx:102 |
| (useTabComboQueryResults) | hook | 1 | Y | useCapaTeepReportCombos.ts:87 |
| /admin/menu/SCP0107/search-conditions | http | 1 | Y | useCapaTeepReportStore.ts:256 |
| /admin/menu/SCP0107/column | http | 1 | Y | useCapaTeepReportStore.ts:368 |
| /admin/menu/SCP0107/measure | http | 1 | Y | useCapaTeepReportStore.ts:408 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| ASSEMBLY | version versionSeq divisionId siteId plantId factoryId lineId operationId electrodeType programId sheetName debugMode | o_rc1 | SCP0107_GET_CAPA_TEEP_ASSEMBLY SCP0107_GET_CAPA_TEEP_ELTR SCP0104_GET_SPREAD_TITLE PKG_SCP0107 PKG_SCP0104 P_SNAKE |
| ELTR | version versionSeq divisionId siteId plantId factoryId lineId operationId electrodeType programId sheetName debugMode | o_rc1 | SCP0107_GET_CAPA_TEEP_ASSEMBLY SCP0107_GET_CAPA_TEEP_ELTR SCP0104_GET_SPREAD_TITLE PKG_SCP0107 PKG_SCP0104 P_SNAKE |
| spreadTitle | fromYyyymm programId sheetName | o_rc1 | SCP0107_GET_CAPA_TEEP_ASSEMBLY SCP0107_GET_CAPA_TEEP_ELTR SCP0104_GET_SPREAD_TITLE PKG_SCP0107 PKG_SCP0104 P_SNAKE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaTeepReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-teep-report/CapaTeepReport.tsx | 333 |
| CapaTeepReportColumnModal | onClose | <arrow> setOpenColumnSetting | jsx | features/supply/src/pages/capa-teep-report/CapaTeepReport.tsx | 363 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 103 |
| CustomDropdown | onChange | <arrow> setSearchParamsWithLineTypeRefresh,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 124 |
| CustomDropdown | onChange | <arrow> setSearchParamsWithLineTypeRefresh,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 147 |
| CustomDropdown | onChange | <arrow> setSearchParamsWithLineTypeRefresh,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 170 |
| CustomDropdown | onChange | <arrow> setSearchParamsWithLineTypeRefresh,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 196 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 226 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 251 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 276 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 299 |
| CustomDropdown | onChange | <arrow> setSearchParamsWithLineTypeRefresh,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 330 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-teep-report/components/CapaTeepReportForm.tsx | 355 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-teep-report/components/CapaTeepReportGrid.tsx | 120 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,Number,String,clearFilters,settings.filter | jsx | features/supply/src/pages/capa-teep-report/components/modals/CapaTeepReportColumnModal.tsx | 73 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 11 |
| FormItem | 11 |
| CustomDropdown | 10 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaTeepReportForm | 1 |
| SubTitle | 1 |
| CapaTeepReportGrid | 1 |
| CapaTeepReportColumnModal | 1 |
| SearchArea | 1 |
| InputField | 1 |
| DataGrid | 1 |
| ColumnLayoutModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPeriodColumns | row.COLUMN_NAME | toPeriodHeaderLabel(String(row.COLUMN_LABEL_NAME ?? row.COLU | 80 | true | true |  | object | features/supply/src/pages/capa-teep-report/utils/capaTeepReport.dateColumns.ts | 126 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG01410 | 1 |
| MSG01044 | 1 |
| MSG01045 | 1 |
| MSG01390 | 1 |
| MSG01052 | 1 |
| MSG00003 | 1 |
| LBL01143 | 1 |
| LBL00001 | 1 |
| LBL00606 | 1 |
| LBL00605 | 3 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00112 | 1 |
| LBL00053 | 1 |
| LBL00027 | 1 |
| LBL00015 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00056 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0107(19), SCP0106(17), SCP0108(12), SCP0105(10), SCP0104(4), SCP0006(1), SCM0008(1)
- SP/PKG: PKG_SCP0104(7), PKG_SCP0107(4), P_SCP0104_GET_SPREAD_TITLE(3), SCP0107_GET_CAPA_TEEP_ASSEMBLY(1), SCP0107_GET_CAPA_TEEP_ELTR(1), PKG_SCP0100(1), P_SCP0100_GET_GLOBAL_PSI_REPORT(1), P_VERSION(1), P_VERSION_SEQ(1), P_DIVISION_ID(1), P_SITE_ID(1), P_PLANT_ID(1), P_FACTORY_ID(1), P_LINE_ID(1), P_OPERATION_ID(1), P_ELECTRODE_TYPE(1), P_PROGRAM_ID(1), P_SHEET_NAME(1), P_USER_ID(1), PR_GET_SHEET_COLUMN_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | enum 이 아니라 const 객체다 — `procedures.d.ts` 의 `SheetName<'SCP0107'>`(문자열 리터럴 유니온)에 | features/supply/src/pages/capa-teep-report/capa-teep-report.constants.ts | 23 |
| jsx | AS-IS GSCM.SCP.Forms.UIL Report/SCP0107_CAPA_TEEP_Report — CAPA TEEP Report(메뉴 Title "TEEP Report"). 설계: .atlas/gscm-design/SCP0107/design/00~03. 확정 결정: convert-flow/goal.md ⑥-1. 상세 매핑: __asis-mapping__.md. 도메인 SCP -> features/supply. 라우트는  | features/supply/src/pages/capa-teep-report/CapaTeepReport.tsx | 29 |
| code | 조회(F5) — AS-IS `FindButton()`(cs:1338~1351) 가드 2건을 재현한다. 단 **평가 순서는 AS-IS 와 반대다(의도적 차이)**: AS-IS 는 진행상태(`MSG00423`) -> 권한(`MSG00097`) 순이고 여기서는 권한 -> 진행상태 순이다. 권한 0건 사용자는 Version 후보도 0건이라 진행상태가 `'0'` 으로 파생돼 두 가드가 동시에 성립하는데, 그 경우 설계 `01 §4 V- | features/supply/src/pages/capa-teep-report/CapaTeepReport.tsx | 194 |
| endpoint | admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search** refetch(CLAUDE.md §2 체크3 / 03 §4.1). `divisionId` 는 넘기지 않는다: 메타 50행의 `DIVISION_ID` 가 전건 NULL = division 별 컬럼 분기가 없다(03 §1 공통, hook #92/#113 미해당). | features/supply/src/pages/capa-teep-report/useCapaTeepReportStore.ts | 358 |
| endpoint | Measure 메타 fetch(PIVOT 화면 의무, 2시트) — mount 1회 + 매 Search(CLAUDE.md §2 체크3 / hook #66). 메타 실측 56행(ASSEMBLY 28 / ELTR 28)이라 코드 하드코딩 배열을 두지 않는다. 주의: 렌더 자체는 GET SP 가 measure 행을 이미 조인해 내려주므로 이 메타에 의존하지 않는다 (03 §4.3 — ELTR 은 메타 28행인데 lookup 교집합으로 | features/supply/src/pages/capa-teep-report/useCapaTeepReportStore.ts | 398 |
| code | 상위 축 조건을 AND 로 건 마스터 부분집합. `divisionId` 가 ALL/빈 값이면 **필터를 통째로 걸지 않는다** — AS-IS 6개 `GetFilterXxx` 전부 `if (string.IsNullOrEmpty(division)) return "";` 이라 무필터(전건)가 되고, 그때는 `SHOP_GROUP_ID IN (...)` 절조차 생성되지 않는다(02 §3.4-1 / §4.3-1). 이 가드를 빼면 미선택 | features/supply/src/pages/capa-teep-report/utils/capaTeepReport.combos.ts | 294 |

## 10. __asis-mapping__.md 상태
- 구현: 48
- 제외: 11
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-015 | §1 components / Container | Designer 비가시 컴포넌트 컨테이너 — DOM 대응물이 없다(§1-3) | 제외 |
| D00-1-020 | §1 imageList1 / ImageList | 비가시 리소스(edit.png). TO-BE 아이콘 원천은 foundation assets 라 이식 대상이 아니다(§1-3) | 제외 |
| D00-1-021 | §1 layoutControlGroup1 / LayoutControlGroup | 사장 노드 — Items.AddRange 0건. 이식하면 빈 컨테이너가 생겨 hook #132 §1-2 위반(L-06 / §1-3) | 제외 |
| D00-1-023 | §1 layoutControlItem1 / LayoutControlItem | btnColumn 이 SubTitle 로 이동(L-20)해 조회영역 슬롯 자체가 사라진다(§1-3) | 제외 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView | Designer 초기 시트 잔재. 런타임은 AddSheet 2시트(ASSEMBLY/ELTR)로 대체된다(§1-3 / 03 §7.1) | 제외 |
| D00-1-036 | §1 usrLayoutControl1 / UsrLayoutControl | 사장 노드 — Form.Controls 미추가 + cs 참조 0건(L-05 / §1-3) | 제외 |
| D00-3-002 | §3 ColumnHeaderSpan / 1단 | 데드 — MergeKeyColumns 참조 0건(§9 G-02). 이식하면 AS-IS 에 없는 키컬럼 헤더 가로병합이 생긴다 | 제외 |
| D00-3-003 | §3 ColumnHeaderSpan / 2단 | 동 데드(§9 G-03) | 제외 |
| D00-3-004 | §3 ColumnHeaderSpan / 3단 | 동 데드(§9 G-04). 3단 헤더 근거는 SetSheetHeaderColumnSCP + RefreshSpreadDateColumn 쪽이다 | 제외 |
| D00-3-006 | §3 Delete / 행 제거 | 도달 불가 — 베이스 CheckValidation(Delete) 가 IsLock==true 로 먼저 차단(L-12). `handleDelete` alert 로 대체(§9 G-06) | 제외 |
| D00-3-012 | §3 SetValue / BASE_QTY 일괄 기입 | 데드 — SetBaseToDateColumns 참조 0건이고 내부 가드마저 주석 처리. 이식하면 조회값을 BASE_QTY 로 덮어쓰는 데이터 파괴(§9 G-12) | 제외 |

