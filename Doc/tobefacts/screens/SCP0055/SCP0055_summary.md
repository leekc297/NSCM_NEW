# SCP0055 — To-Be Fact Pack 요약

- page_key: `supply/shipment-allo-report` · feature: supply · As-is Fact Pack 있음
- 파일 9 · 엔드포인트 호출 6 (미해결 0, 주석 속 1) · 이벤트 12 · 컴포넌트 사용 32 · 하드코딩 컬럼 4 · 메시지 18
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 4건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | component | 255 |
| features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | component | 96 |
| features/supply/src/pages/shipment-allo-report/index.ts | index | 2 |
| features/supply/src/pages/shipment-allo-report/shipment-allo-report.constants.ts | constants | 66 |
| features/supply/src/pages/shipment-allo-report/shipment-allo-report.types.ts | types | 98 |
| features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | page | 266 |
| features/supply/src/pages/shipment-allo-report/useShipmentAlloReportStore.ts | store | 172 |
| features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | util | 262 |
| features/supply/src/pages/shipment-allo-report/__asis-mapping__.md | mapping | 39 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentAlloReportForm.tsx:46 |
| SCP0055/main//call-proc | hook | 3 | Y | ShipmentAlloReport.tsx:75 ShipmentAlloReport.tsx:82 ShipmentAlloReport.tsx:90 |
| /admin/menu/SCP0055/search-conditions | http | 1 | Y | useShipmentAlloReportStore.ts:141 |
| /admin/menu/SCP0055/column | http | 1 | Y | useShipmentAlloReportStore.ts:157 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId bizType cellTypeGr fromYyyymmdd toYyyymmdd planStartYyyymmdd fromsite teamId itemId nickname programId sheetName userId fcstYn debugMode | o_rc1 o_rc2 o_rc3 o_rc4 | PKG_SCP0055 |
| note | siteId deptId nickName planDate gapDate programId | o_rc1 | PKG_SCP0055 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 105 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 126 |
| InputField | onChange | <arrow>  | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 153 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 154 |
| FunctionSearchIcon | onClick | onPopup | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 149 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 166 |
| DatePickerCalendar | onChange | <arrow> set,d.format | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 198 |
| DatePickerCalendar | onChange | <arrow> set,d.format | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 213 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportForm.tsx | 227 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | 62 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/shipment-allo-report/components/ShipmentAlloReportGrid.tsx | 72 |
| ShipmentAlloReportForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | 223 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 5 |
| CustomDropdown | 2 |
| DatePickerCalendar | 2 |
| ItemByDivisionModal | 2 |
| TabItem | 2 |
| ShipmentAlloReportGrid | 2 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| IcSetting | 1 |
| MainTitle | 1 |
| ShipmentAlloReportForm | 1 |
| SubTitle | 1 |
| TabWrapper | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leaf | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | header | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 71 |
| buildDerivedColumns | SUBTOTAL | 소계 | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 101 |
| buildDerivedColumns | GAP | GAP | 70 |  | true |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 105 |
| buildDerivedColumns | NOTE | 비고 | 200 |  | !isEditable |  | object | features/supply/src/pages/shipment-allo-report/utils/shipment-allo-report.columns.ts | 114 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00664 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
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
| MSG00344 | 1 |
| MSG00345 | 1 |
| MSG00348 | 1 |
| MSG00004 | 1 |
| MSG00100 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0055(3)
- SP/PKG: PKG_SCP0055(2), DM0003_GET_BUCKET_TYPE_CODE(1), P_FCST_YN(1), P_SCM0000_SAVE_SRCH_COND(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 사전검증 3건(design 01 §2 #13) — Period From>To / PlanDate<GapDate / PlanDate=GapDate. | features/supply/src/pages/shipment-allo-report/ShipmentAlloReport.tsx | 118 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(6칼럼, design 03 §1.1) — 미등록/실패 시 빈 배열. | features/supply/src/pages/shipment-allo-report/useShipmentAlloReportStore.ts | 154 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

