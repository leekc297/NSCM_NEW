# SCP0025 — To-Be Fact Pack 요약

- page_key: `supply/shipment-plan-fix` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 15 · 엔드포인트 호출 8 (미해결 0, 주석 속 2) · 이벤트 17 · 컴포넌트 사용 23 · 하드코딩 컬럼 2 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 2건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | component | 252 |
| features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | component | 269 |
| features/supply/src/pages/shipment-plan-fix/hooks/useShipmentPlanFixValidation.ts | hook | 40 |
| features/supply/src/pages/shipment-plan-fix/index.ts | index | 2 |
| features/supply/src/pages/shipment-plan-fix/shipment-plan-fix.constants.ts | constants | 172 |
| features/supply/src/pages/shipment-plan-fix/shipment-plan-fix.types.ts | types | 20 |
| features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.module.scss | style | 12 |
| features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | page | 230 |
| features/supply/src/pages/shipment-plan-fix/useShipmentPlanFixStore.ts | store | 209 |
| features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixColumns.ts | util | 166 |
| features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixDerive.ts | util | 95 |
| features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixMerge.ts | util | 100 |
| features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixSave.ts | util | 150 |
| features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixVisibility.ts | util | 50 |
| features/supply/src/pages/shipment-plan-fix/__asis-mapping__.md | mapping | 133 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | ShipmentPlanFixForm.tsx:51 ShipmentPlanFix.tsx:68 |
| (useTabLookupQueries) | hook | 1 | Y | ShipmentPlanFixForm.tsx:55 |
| SCP0025/main//call-proc | hook | 2 | Y | ShipmentPlanFix.tsx:53 ShipmentPlanFix.tsx:60 |
| /admin/menu/SCP0025/column | http | 1 | Y | useShipmentPlanFixStore.ts:136 |
| /SCP0025/main/GET_SCP_DAY_PERIOD/call-proc | http | 1 | Y | useShipmentPlanFixStore.ts:160 |
| /admin/menu/SCP0025/search-conditions | http | 1 | Y | useShipmentPlanFixStore.ts:186 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 111 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 141 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 152 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 201 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 202 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 197 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 228 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixForm.tsx | 243 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 108 |
| g | updatedLayout | syncFixedBindings | addHandler | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 138 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 155 |
| g | updatedLayout | applyPivotVisibility | addHandler | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 195 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 234 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/shipment-plan-fix/components/ShipmentPlanFixGrid.tsx | 265 |
| ShipmentPlanFixForm | onSearch | handleSearch | jsx | features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | 184 |
| ShipmentPlanFixForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | 184 |
| ShipmentPlanFixGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | 210 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| InputField | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentPlanFixForm | 1 |
| SubTitle | 1 |
| ShipmentPlanFixGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| fallbackToRaw | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixColumns.ts | 15 |
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafHeader | 70 | isPivotVisible(binding, bucket, chkSum) |  |  | object | features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixColumns.ts | 108 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00096 | 1 |
| MSG01307 | 1 |
| MSG00014 | 1 |
| MSG00683 | 1 |
| MSG01078 | 1 |
| MSG00004 | 1 |
| MSG00108 | 1 |
| MSG00662 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00038 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00618 | 1 |
| LBL00687 | 1 |
| LBL00112 | 1 |
| LBL00772 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0025(19), SCP0024(10), SSP0015(8), SSP0200(3)
- SP/PKG: PKG_SCP0025(7), FN_GET_DIVISION_DIV(3), P_SCP0025_SAVE_FIX_DATASET(3), PKG_COM0000(2), P_SCM0001_GET_SCP_DAY_PERIOD(2), P_SCP0025_GET_SHIP_PLAN_FIX(1), P_DATA(1), P_USER_ID(1), P_SCP0025_GET(1), P_SCP0025_SAVE(1), SCM0001_GET_SCP_DAY_PERIOD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| endpoint | admin 동적 메타(SCM_MST_SHEET_COLUMNS 'Shipment Plan Fix' 20행) — mount 1회 fetch(hook #66). Search 시에도 refetch. | features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | 85 |
| code | 부활 방지를 위해 키를 명시적 무동작으로 둔다(skill §3 규칙: 키 생략·false 금지, 명시적 () => undefined). | features/supply/src/pages/shipment-plan-fix/ShipmentPlanFix.tsx | 168 |
| endpoint | admin SCM_MST_SHEET_COLUMNS('Shipment Plan Fix') 동적 fetch (ui-dynamic-property-management §2.3). 20행 등록 확인. | features/supply/src/pages/shipment-plan-fix/useShipmentPlanFixStore.ts | 30 |
| jsx | (2) 엑셀 내려받기용 — 사유를 Fix Reason 행의 일자(D_<YYYYMMDD>) pivot 바인딩에도 직접 심는다. | features/supply/src/pages/shipment-plan-fix/utils/shipmentPlanFixDerive.ts | 83 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

