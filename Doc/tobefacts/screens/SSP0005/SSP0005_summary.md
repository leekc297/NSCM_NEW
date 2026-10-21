# SSP0005 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-working-day` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 8 (미해결 0, 주석 속 1) · 이벤트 13 · 컴포넌트 사용 22 · 하드코딩 컬럼 1 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | component | 226 |
| features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | component | 212 |
| features/shipping/src/pages/shipment-working-day/index.ts | index | 2 |
| features/shipping/src/pages/shipment-working-day/shipment-working-day.constants.ts | constants | 164 |
| features/shipping/src/pages/shipment-working-day/shipment-working-day.types.ts | types | 59 |
| features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.module.scss | style | 13 |
| features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.tsx | page | 500 |
| features/shipping/src/pages/shipment-working-day/useShipmentWorkingDayStore.ts | store | 267 |
| features/shipping/src/pages/shipment-working-day/utils/shipmentWorkingDayBulkInput.ts | util | 124 |
| features/shipping/src/pages/shipment-working-day/utils/shipmentWorkingDayColumns.ts | util | 97 |
| features/shipping/src/pages/shipment-working-day/utils/shipmentWorkingDaySave.ts | util | 68 |
| features/shipping/src/pages/shipment-working-day/__asis-mapping__.md | mapping | 200 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentWorkingDayForm.tsx:62 |
| (useTabComboQueryResults) | hook | 1 | Y | ShipmentWorkingDay.tsx:96 |
| SSP0005/Shipment Working Day//call-proc | hook | 1 | Y | ShipmentWorkingDay.tsx:118 |
| SSP0005/calendar//call-proc | hook | 1 | Y | ShipmentWorkingDay.tsx:129 |
| /SSP0005/Shipment Working Day/SAVE/call-proc | http | 1 | Y | ShipmentWorkingDay.tsx:285 |
| /admin/menu/SSP0005/column | http | 1 | Y | useShipmentWorkingDayStore.ts:184 |
| /admin/menu/SSP0005/search-conditions | http | 1 | Y | useShipmentWorkingDayStore.ts:210 |
| /SSP0005/Shipment Working Day/GET_SCP_PERIOD/call-proc | http | 1 | Y | useShipmentWorkingDayStore.ts:245 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| Shipment Working Day | fromYyyymmdd toYyyymmdd divisionId companyId debugMode | o_rc1 | PKG_SSP0005 P_SSP0005_GET_SHIPMENT_WORKING_DAY PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |
| calendar | startYyyymmdd endYyyymmdd | o_rc1 | PKG_SSP0005 P_SSP0005_GET_SHIPMENT_WORKING_DAY PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 104 |
| CustomDropdown | onChange | <arrow> setSearchCondition,str | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 122 |
| CustomDropdown | onChange | <arrow> setSearchCondition,str | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 145 |
| PeriodField | onChange | <arrow> setSearchCondition | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 162 |
| CustomDropdown | onChange | <arrow> setSearchCondition,str | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 180 |
| CustomDropdown | onChange | <arrow> setSearchCondition,str | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 201 |
| Button | onClick | onInput | jsx | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayForm.tsx | 216 |
| grid | formatItem | formatHandler | addHandler | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | 91 |
| grid | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | 101 |
| grid | pastingCell | pastingCellHandler | addHandler | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | 116 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | 178 |
| ShipmentWorkingDayForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.tsx | 470 |
| ShipmentWorkingDayForm | onInput | handleInputValue | jsx | features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.tsx | 471 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 4 |
| CustomDropdown | 4 |
| SearchArea | 1 |
| PeriodField | 1 |
| Button | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentWorkingDayForm | 1 |
| SubTitle | 1 |
| ShipmentWorkingDayGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| leaf | dc.binding | dc.dayLabel \|\| dc.binding.slice(2) | 70 | true |  |  | object | features/shipping/src/pages/shipment-working-day/utils/shipmentWorkingDayColumns.ts | 54 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG01122 | 1 |
| MSG01153 | 1 |
| MSG00614 | 1 |
| MSG00719 | 1 |
| MSG00672 | 1 |
| MSG00152 | 1 |
| MSG00618 | 1 |
| MSG00137 | 1 |
| LBL00047 | 1 |
| LBL00001 | 1 |
| LBL00013 | 1 |
| LBL01067 | 1 |
| LBL01084 | 1 |
| LBL00872 | 1 |
| LBL00112 | 1 |
| LBL00069 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0005(4), SCP0096(3), SSP0200(2), SCP0010(1), SCP0031(1), SCP0095(1), SSP0015(1), SCP0020(1), SSP0014(1)
- SP/PKG: PKG_COM0000(5), PKG_SSP0005(5), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(3), P_SSP0005_GET_SHIPMENT_WORKING_DAY(2), P_SCM0001_GET_SCP_PERIOD(2), P_ACTIVE_FLAG(2), P_SSP0005_SAVE_SHIPMENT_WORKING_DAY(1), PKG_NSCM_UI_COM_LOOKUP(1), PR_GET_LOOKUP_INFO_LIST(1), P_SSP0005_SAVE_(1), P_DIVISION_ID(1), FN_MULTY_TIME(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 편집 가능 셀 <=> /^D_\d{8}$/.test(binding) AND canEdit (03 §3-a). | features/shipping/src/pages/shipment-working-day/components/ShipmentWorkingDayGrid.tsx | 41 |
| code | 가드 #5 — 요일 미선택이면 조용히 return(cs:703-706). 요일 콤보는 빈값이 될 수 없어 | features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.tsx | 413 |
| code | () => undefined 로 배선한다 — false 면 버튼이 숨겨지고(AS-IS 는 보인다), 키를 생략하면 | features/shipping/src/pages/shipment-working-day/ShipmentWorkingDay.tsx | 441 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(mount + Search 마다). 실측 2행 등록돼 있다. | features/shipping/src/pages/shipment-working-day/useShipmentWorkingDayStore.ts | 177 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

