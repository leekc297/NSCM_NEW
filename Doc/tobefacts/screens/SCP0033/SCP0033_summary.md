# SCP0033 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-semi-dept-day` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 12 · 엔드포인트 호출 5 (미해결 0, 주석 속 0) · 이벤트 15 · 컴포넌트 사용 16 · 하드코딩 컬럼 1 · 메시지 15
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | component | 173 |
| features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx | component | 162 |
| features/shipping/src/pages/shipment-semi-dept-day/hooks/useShipmentSemiDeptDayValidation.ts | hook | 64 |
| features/shipping/src/pages/shipment-semi-dept-day/index.ts | index | 2 |
| features/shipping/src/pages/shipment-semi-dept-day/shipment-semi-dept-day.constants.ts | constants | 179 |
| features/shipping/src/pages/shipment-semi-dept-day/shipment-semi-dept-day.types.ts | types | 32 |
| features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.module.scss | style | 12 |
| features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | page | 376 |
| features/shipping/src/pages/shipment-semi-dept-day/useShipmentSemiDeptDayStore.ts | store | 174 |
| features/shipping/src/pages/shipment-semi-dept-day/utils/shipmentSemiDeptDayColumns.ts | util | 66 |
| features/shipping/src/pages/shipment-semi-dept-day/utils/shipmentSemiDeptDayEditLock.ts | util | 48 |
| features/shipping/src/pages/shipment-semi-dept-day/__asis-mapping__.md | mapping | 184 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentSemiDeptDayForm.tsx:45 |
| SCP0033/main//call-proc | hook | 1 | Y | ShipmentSemiDeptDay.tsx:78 |
| /SCP0033/main/SAVE/call-proc | http | 1 | Y | ShipmentSemiDeptDay.tsx:243 |
| /admin/menu/SCP0033/column | http | 1 | Y | useShipmentSemiDeptDayStore.ts:125 |
| /admin/menu/SCP0033/search-conditions | http | 1 | Y | useShipmentSemiDeptDayStore.ts:146 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | 99 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | 121 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | 144 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | 145 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayForm.tsx | 163 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx | 91 |
| g | beginningEdit | beginningEditHandler | addHandler | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx | 110 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx | 128 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-semi-dept-day/components/ShipmentSemiDeptDayGrid.tsx | 158 |
| ShipmentSemiDeptDayForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 325 |
| ShipmentSemiDeptDayGrid | onItemCellDblClick | handleItemCellDblClick | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 353 |
| ShipmentSemiDeptDayGrid | onDivisionRequired | <arrow> setAlert,t | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 354 |
| ShipmentSemiDeptDayGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 360 |
| ModelByDivisionPopup | onClose | <arrow> setItemPopup | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 369 |
| ModelByDivisionPopup | onSelect | handleModelSelected | jsx | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 370 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 3 |
| FormItem | 3 |
| CustomDropdown | 2 |
| SearchArea | 1 |
| InputField | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentSemiDeptDayForm | 1 |
| SubTitle | 1 |
| ShipmentSemiDeptDayGrid | 1 |
| ModelByDivisionPopup | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| col | c.key | c.header | c.width ?? 100 | c.visible !== false |  |  | meta-map | features/shipping/src/pages/shipment-semi-dept-day/utils/shipmentSemiDeptDayColumns.ts | 41 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00669 | 1 |
| LBL00639 | 1 |
| LBL00112 | 1 |
| LBL00664 | 1 |
| LBL00343 | 1 |
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00004 | 1 |
| MSG00060 | 1 |
| MSG00097 | 1 |
| MSG00667 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0033(9), SCM0002(8), SSP0025(5), SSP0024(4), SCP0020(2), DMF0003(1), DMF0020(1)
- SP/PKG: PKG_SCP0033(4), P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY(2), P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY(1), P_SCP0033_SAVE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | deleteOnlyNew=true — 선택 신규행('I')만 제거, 기존행은 무변경(no-op, AS-IS DeleteButton return). | features/shipping/src/pages/shipment-semi-dept-day/ShipmentSemiDeptDay.tsx | 146 |

## 10. __asis-mapping__.md 상태
- 구현: 27
- 제외: 6
- 해당없음: 3
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-008 | §1 layoutControlGroup1 / LayoutControlGroup | DevExpress 레이아웃 그룹 컨테이너 = 데드 스캐폴딩(design 01 §1 경고). 자체 visual 산출이 없고 TO-BE 는 공용 SearchArea + MUI Grid 가 배치를 담당해 대응 객체를 만들지 않는다(controls(16) 표 "미재현"). | 제외 |
| D00-1-009 | §1 layoutControlGroup2 / LayoutControlGroup | 동일 계열 컨테이너 전용 레이아웃 그룹(visual 산출 없음). TO-BE SearchArea/Grid 배치로 흡수 — 대응 객체 미생성. | 제외 |
| D00-1-010 | §1 usrLayoutControl1 / UsrLayoutControl | 조회영역 레이아웃 컨트롤(데드 스캐폴딩, design 01 §1). TO-BE 공용 SearchArea 가 대체하며 화면 코드에 대응 객체가 없다. | 제외 |
| D00-1-012 | §1 emptySpaceItem3 / EmptySpaceItem | 레이아웃 여백 filler(정적, 기능 없음). TO-BE 는 MUI Grid size 배분으로 여백이 생성돼 대응 객체가 불필요. | 제외 |
| D00-1-015 | §1 components / Container | WinForms Designer 의 비visual 컴포넌트 컨테이너 — 런타임 UI 산출이 없다. React 에 대응 개념 자체가 없어 이식 대상이 아니다. | 해당없음 |
| D00-1-016 | §1 imageList1 / ImageList | WinForms 아이콘 리소스 목록(비visual). TO-BE 아이콘은 공용 lges-icons 컴포넌트가 제공해 화면 자산으로 이식하지 않는다. | 해당없음 |
| D00-3-003 | §3 VisibleTab / (true) | FpSpread 시트 탭 가시성 API. TO-BE 는 시트 탭 개념이 없는 단일 공용 DataGrid 라 대응 호출이 성립하지 않는다(그리드는 항상 표시). | 해당없음 |
| D00-3-011 | §3 SwitchLock / () (EditButton — 편집모드 잠금 토글) | **사용자 지시(2026-09-23)로 미재현**: Edit 버튼을 두지 않고 진입부터 상시 편집한다. AS-IS 의 SwitchLock 토글(전잠금<->개방) 단계 자체를 없앤 것이며, 개방 범위(기존행 DEPARTURE_DAY/VALID_YN, 신규행 +DIVISION_ID/ITEM_ID)는 그대로다. | 제외 |
| D00-3-015 | §3 LockColumn / (0, GetMaxColumnIndex(), true) 조회 후 전체 잠금 | **사용자 지시(2026-09-23)로 미재현**: 상시 편집이라 조회 직후 전잠금 단계가 없다. 편집 가능 셀 화이트리스트(기존행 DEPARTURE_DAY/VALID_YN)는 그대로 적용된다. | 제외 |

