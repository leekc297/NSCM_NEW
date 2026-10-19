# SCP0108 — To-Be Fact Pack 요약

- page_key: `supply/capa-lob-report` · feature: supply · As-is Fact Pack 있음
- 파일 16 · 엔드포인트 호출 6 (미해결 0, 주석 속 1) · 이벤트 22 · 컴포넌트 사용 55 · 하드코딩 컬럼 1 · 메시지 29
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/capa-lob-report/capa-lob-report.constants.ts | constants | 272 |
| features/supply/src/pages/capa-lob-report/capa-lob-report.types.ts | types | 119 |
| features/supply/src/pages/capa-lob-report/CapaLobReport.tsx | page | 343 |
| features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | component | 425 |
| features/supply/src/pages/capa-lob-report/components/CapaLobReportGrid.module.scss | component | 15 |
| features/supply/src/pages/capa-lob-report/components/CapaLobReportGrid.tsx | component | 133 |
| features/supply/src/pages/capa-lob-report/components/modals/CapaLobReportColumnModal.tsx | component | 110 |
| features/supply/src/pages/capa-lob-report/components/modals/CapaLobReportItemPopup.tsx | component | 50 |
| features/supply/src/pages/capa-lob-report/hooks/useCapaLobReportCombos.ts | hook | 310 |
| features/supply/src/pages/capa-lob-report/hooks/useCapaLobReportConditionEffects.ts | hook | 67 |
| features/supply/src/pages/capa-lob-report/index.ts | index | 2 |
| features/supply/src/pages/capa-lob-report/useCapaLobReportStore.ts | store | 488 |
| features/supply/src/pages/capa-lob-report/utils/capaLobReport.combos.ts | util | 392 |
| features/supply/src/pages/capa-lob-report/utils/capaLobReport.cursors.ts | util | 96 |
| features/supply/src/pages/capa-lob-report/utils/capaLobReport.dateColumns.ts | util | 151 |
| features/supply/src/pages/capa-lob-report/__asis-mapping__.md | mapping | 192 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| SCP0108/CURRENT//call-proc | hook | 1 | Y | CapaLobReport.tsx:85 |
| SCP0108/CUTOFF//call-proc | hook | 1 | Y | CapaLobReport.tsx:92 |
| SCP0108/spreadTitle//call-proc | hook | 1 | Y | CapaLobReport.tsx:103 |
| (useTabComboQueryResults) | hook | 1 | Y | useCapaLobReportCombos.ts:82 |
| /admin/menu/SCP0108/search-conditions | http | 1 | Y | useCapaLobReportStore.ts:297 |
| /admin/menu/SCP0108/column | http | 1 | Y | useCapaLobReportStore.ts:432 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| CURRENT | version versionSeq divisionId siteId plantId factoryId lineId operationId nickName electrodeType bottleneckFlag programId sheetName | o_rc1 o_rc2 | SCP0108_GET_CAPA_LOB_CURRENT SCP0108_GET_CAPA_LOB SCP0104_GET_SPREAD_TITLE PKG_SCP0108 PKG_SCP0104 P_SNAKE |
| CUTOFF | version versionSeq divisionId siteId plantId factoryId lineId operationId nickName electrodeType bottleneckFlag programId sheetName | o_rc1 o_rc2 | SCP0108_GET_CAPA_LOB_CURRENT SCP0108_GET_CAPA_LOB SCP0104_GET_SPREAD_TITLE PKG_SCP0108 PKG_SCP0104 P_SNAKE |
| spreadTitle | fromYyyymm programId sheetName | o_rc1 | SCP0108_GET_CAPA_LOB_CURRENT SCP0108_GET_CAPA_LOB SCP0104_GET_SPREAD_TITLE PKG_SCP0108 PKG_SCP0104 P_SNAKE |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CapaLobReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/capa-lob-report/CapaLobReport.tsx | 301 |
| CapaLobReportForm | onOpenItemPopup | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-lob-report/CapaLobReport.tsx | 302 |
| CapaLobReportColumnModal | onClose | <arrow> setOpenColumnSetting | jsx | features/supply/src/pages/capa-lob-report/CapaLobReport.tsx | 333 |
| CapaLobReportItemPopup | onClose | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/capa-lob-report/CapaLobReport.tsx | 338 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 131 |
| CustomDropdown | onChange | <arrow> handleDivisionChange,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 147 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 179 |
| CustomDropdown | onChange | <arrow> handleDivisionTypeChange,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 216 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 241 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 266 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 291 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 314 |
| CustomDropdown | onChange | <arrow> handleOperationChange,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 343 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 362 |
| InputField | onChange | <arrow> setSearchParams | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 387 |
| FunctionSearchIcon | onClick | onOpenItemPopup | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 395 |
| CustomDropdown | onChange | <arrow> setSearchParams,String | jsx | features/supply/src/pages/capa-lob-report/components/CapaLobReportForm.tsx | 415 |
| grid | formatItem | formatItemHandler | addHandler | features/supply/src/pages/capa-lob-report/components/CapaLobReportGrid.tsx | 83 |
| ColumnLayoutModal | onSave | <arrow> applyColumnLayout,settings.map,Number,String,clearFilters,settings.filter | jsx | features/supply/src/pages/capa-lob-report/components/modals/CapaLobReportColumnModal.tsx | 64 |
| CapaItemPopup | onClose | onClose | jsx | features/supply/src/pages/capa-lob-report/components/modals/CapaLobReportItemPopup.tsx | 35 |
| CapaItemPopup | onSelect | <arrow> selectedAll.map(item=>toStr(item.nickName)).filter,selectedAll.map,toStr,Array.from(newSet(values)).join,Array.from,setSearchParams | jsx | features/supply/src/pages/capa-lob-report/components/modals/CapaLobReportItemPopup.tsx | 38 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 14 |
| FormItem | 14 |
| CustomDropdown | 12 |
| InputField | 2 |
| IcGridColumnSetup | 1 |
| MainTitle | 1 |
| CapaLobReportForm | 1 |
| SubTitle | 1 |
| CapaLobReportGrid | 1 |
| CapaLobReportColumnModal | 1 |
| CapaLobReportItemPopup | 1 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| ColumnLayoutModal | 1 |
| CapaItemPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPeriodColumns | row.COLUMN_NAME | String(row.COLUMN_LABEL_NAME ?? row.COLUMN_NAME) | columnWidth | true | true |  | object | features/supply/src/pages/capa-lob-report/utils/capaLobReport.dateColumns.ts | 116 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG01410 | 1 |
| MSG01044 | 1 |
| MSG01045 | 1 |
| MSG00096 | 1 |
| MSG01390 | 1 |
| MSG01052 | 1 |
| MSG00003 | 1 |
| LBL01143 | 1 |
| LBL00605 | 3 |
| LBL00038 | 1 |
| LBL01059 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00053 | 1 |
| LBL00606 | 1 |
| LBL00014 | 1 |
| LBL00015 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00056 | 1 |
| LBL00054 | 1 |
| LBL00055 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0108(18), SCP0105(16), SCP0104(5), SCP0106(4), SCP0025(2)
- SP/PKG: PKG_SCP0104(6), PKG_SCP0108(5), P_SCP0104_GET_SPREAD_TITLE(3), SCP0108_GET_CAPA_LOB_CURRENT(1), SCP0108_GET_CAPA_LOB(1), PKG_SCP0100(1), P_SCP0100_GET_GLOBAL_PSI_REPORT(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | enum 이 아니라 const 객체다 — `procedures.d.ts` 의 `SheetName<'SCP0108'>`(문자열 리터럴 유니온)에 | features/supply/src/pages/capa-lob-report/capa-lob-report.constants.ts | 21 |
| jsx | 개인화 조회조건 복원 (SubTitle F6 저장분 되불러오기, 1회) — 자매 SCP0105 `restoreSearchConditions`. 저장측은 Page 가 `<SubTitle searchParam={sp}>` 로 이미 배선돼 있으나(F6), 복원측이 없으면 저장은 되는데 **새로고침/재진입 시 조건이 사라진다**(basic-check #3 재발 함정). GET `/admin/menu/{MENU_ID}/search-co | features/supply/src/pages/capa-lob-report/useCapaLobReportStore.ts | 273 |
| endpoint | admin 컬럼 메타 fetch(2시트) — mount 1회 + **매 Search 마다** refetch(CLAUDE.md §2 체크3). `MAIN` 15행은 BE 가 `VALID_YN='Y'` 로 걸러 오지 않는다 — `SHEETS` 유니온에도 없다(03 §0.3 / V-05). `divisionId` 는 넘기지 않는다: 메타 44행의 `DIVISION_ID` 가 전건 NULL = division 별 컬럼 분기가 없다(0 | features/supply/src/pages/capa-lob-report/useCapaLobReportStore.ts | 416 |
| code | 상위 축 조건을 AND 로 건 마스터 부분집합. `divisionId` 가 비면 **필터를 통째로 걸지 않는다** — AS-IS 6개 `GetFilterXxx` 전부 `if (string.IsNullOrEmpty(division)) return "";` 이라 전건이 나온다(02 §3.3 공통 가드 / §4.4). 빈 목록으로 만들면 AS-IS 위반이다. | features/supply/src/pages/capa-lob-report/utils/capaLobReport.combos.ts | 269 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

