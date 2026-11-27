# SCP0055 — To-Be Fact Pack 요약

- page_key: `supply/shipment-allo-report` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 7 (미해결 0, 주석 속 1) · 이벤트 11 · 컴포넌트 사용 27 · 하드코딩 컬럼 4 · 메시지 20
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | component | 349 |
| features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | component | 160 |
| features/supply/src/pages/shipment-allo-report/index.ts | index | 2 |
| features/supply/src/pages/shipment-allo-report/shipment-allo-report.constants.ts | constants | 87 |
| features/supply/src/pages/shipment-allo-report/shipment-allo-report.types.ts | types | 98 |
| features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | page | 393 |
| features/supply/src/pages/shipment-allo-report/useShipmentAlloReportStore.ts | store | 179 |
| features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | util | 290 |
| features/supply/src/pages/shipment-allo-report/__asis-mapping__.md | mapping | 39 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentAlloReportForm.tsx:67 |
| SCP0055/main//call-proc | hook | 3 | Y | ShipmentAlloReport.tsx:101 ShipmentAlloReport.tsx:108 ShipmentAlloReport.tsx:116 |
| SCP0055/note/SEARCH/call-proc | callProc | 1 | Y | ShipmentAlloReport.tsx:188 |
| /admin/menu/SCP0055/search-conditions | http | 1 | Y | useShipmentAlloReportStore.ts:148 |
| /admin/menu/SCP0055/column | http | 1 | Y | useShipmentAlloReportStore.ts:164 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId bizType cellTypeGr fromYyyymmdd toYyyymmdd planStartYyyymmdd fromsite teamId itemId nickname programId sheetName userId fcstYn debugMode | o_rc1 o_rc2 o_rc3 o_rc4 | PKG_SCP0055 |
| note | siteId deptId nickName planDate gapDate userId | o_rc1 | PKG_SCP0055 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 163 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 185 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 218 |
| Button | onClick | onPopup | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 211 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 230 |
| PeriodRangePicker | onChange | <arrow> set,start.slice,end.slice | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 259 |
| Checkbox | onChange | <arrow> set,Boolean | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 305 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | 77 |
| g | selectionChanged | selectionHandler | addHandler | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | 96 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | 138 |
| ShipmentAlloReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | 350 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| CustomDropdown | 2 |
| TabItem | 2 |
| ShipmentAlloReportGrid | 2 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| MaterialByDivisionModal | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentAlloReportForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leaf | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | header | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 80 |
| buildDerivedColumns | SUBTOTAL | 소계 | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 118 |
| buildDerivedColumns | GAP | GAP | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 122 |
| buildDerivedColumns | NOTE | 비고 | 200 |  | isGapTab |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 131 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00618 | 1 |
| LBL00669 | 1 |
| LBL00767 | 1 |
| LBL00044 | 1 |
| LBL00022 | 1 |
| LBL00042 | 1 |
| LBL01078 | 1 |
| LBL00710 | 1 |
| LBL00039 | 1 |
| LBL00065 | 1 |
| LBL00013 | 1 |
| MSG01340 | 1 |
| MSG01341 | 1 |
| MSG01344 | 1 |
| MSG00672 | 1 |
| MSG00004 | 1 |
| MSG00667 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0055(7), SCP0111(2), SCP0009(1), COM0013(1), SCM0002(1), SCP0018(1), SCP0131(1)
- SP/PKG: P_DEPT_ID(3), P_FCST_YN(2), P_ITEM_ID(2), P_NICKNAME(2), PKG_SCP0055(2), FN_SCM0001_TEAM_BY_DIVISION(1), DM0003_GET_BUCKET_TYPE_CODE(1), P_SITE_ID(1), P_NICK_NAME(1), P_SCM0000_SAVE_SRCH_COND(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 사전검증 3건(design 01 §2 #13) — Period From>To / PlanDate<GapDate / PlanDate=GapDate. | features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | 234 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(6칼럼, design 03 §1.1) — 미등록/실패 시 빈 배열. | features/supply/src/pages/shipment-allo-report/useShipmentAlloReportStore.ts | 161 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

