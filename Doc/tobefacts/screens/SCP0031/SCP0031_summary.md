# SCP0031 — To-Be Fact Pack 요약

- page_key: `supply/global-psi` · feature: supply · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 8 (미해결 1, 주석 속 3) · 이벤트 22 · 컴포넌트 사용 33 · 하드코딩 컬럼 1 · 메시지 21
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | component | 465 |
| features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | component | 340 |
| features/supply/src/pages/global-psi/components/GlobalPsiModals.tsx | component | 67 |
| features/supply/src/pages/global-psi/global-psi.constants.ts | constants | 161 |
| features/supply/src/pages/global-psi/global-psi.types.ts | types | 27 |
| features/supply/src/pages/global-psi/GlobalPsi.tsx | page | 281 |
| features/supply/src/pages/global-psi/index.ts | index | 2 |
| features/supply/src/pages/global-psi/useGlobalPsiStore.ts | store | 245 |
| features/supply/src/pages/global-psi/utils/globalPsiColumns.test.ts | test | 65 |
| features/supply/src/pages/global-psi/utils/globalPsiColumns.ts | util | 219 |
| features/supply/src/pages/global-psi/utils/globalPsiMerge.ts | util | 100 |
| features/supply/src/pages/global-psi/utils/globalPsiPlanVersion.ts | util | 50 |
| features/supply/src/pages/global-psi/__asis-mapping__.md | mapping | 185 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | GlobalPsiForm.tsx:86 GlobalPsiForm.tsx:90 |
| SCP0031/main//call-proc | hook | 1 | Y | GlobalPsi.tsx:61 |
| SCP0031/calendar//call-proc | hook | 1 | Y | GlobalPsi.tsx:82 |
| {?{comboId:PLAN_PERIOD_COMBO_ID,planName:sc.planStartYyyymmdd,divisionId:sc.divisi} | http | 1 | N | GlobalPsi.tsx:144 |
| /admin/menu/SCP0031/column | http | 1 | Y | useGlobalPsiStore.ts:172 |
| /admin/menu/SCP0031/measure | http | 1 | Y | useGlobalPsiStore.ts:200 |
| /admin/menu/SCP0031/search-conditions | http | 1 | Y | useGlobalPsiStore.ts:221 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 260 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 287 |
| Checkbox | onChange | onToggle | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 305 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 316 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 357 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 358 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 352 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 386 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 387 |
| FunctionSearchIcon | onClick | onNickNameSearch | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 381 |
| CascadeDropdown | onChange | <arrow> selectPlanDate,set | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 425 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/global-psi/components/GlobalPsiForm.tsx | 455 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 160 |
| g | updatedLayout | syncFixedBindings | addHandler | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 183 |
| g | updatedLayout | applyPivotVisibility | addHandler | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 222 |
| g.hostElement | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 262 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 311 |
| MeasureSelectModal | onApply | <arrow> staticMeasures.map,saveTitleSet({menuId:MENU_ID,sheetName:MEASURE_SHEET_NAME,//Measure개인화—폭/색은대상이아니라미전달(빈값으로저장됨).columnType:TITLESET_MEASURE_TYPE,rows:selected.map((name,i)=>({name,sortOrderNo:i+1})),}).then,saveTitleSet,selected.map,alertSaveFailed,fetchStaticMeasures | jsx | features/supply/src/pages/global-psi/components/GlobalPsiModals.tsx | 46 |
| GlobalPsiForm | onSearch | handleSearch | jsx | features/supply/src/pages/global-psi/GlobalPsi.tsx | 216 |
| GlobalPsiForm | onItemSearch | <arrow> setOpenItemPopup | jsx | features/supply/src/pages/global-psi/GlobalPsi.tsx | 217 |
| GlobalPsiForm | onNickNameSearch | <arrow> setOpenNickNamePopup | jsx | features/supply/src/pages/global-psi/GlobalPsi.tsx | 218 |
| GlobalPsiModals | onClose | <arrow> setOpenMeasurePopup | jsx | features/supply/src/pages/global-psi/GlobalPsi.tsx | 277 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 5 |
| CustomDropdown | 2 |
| InputField | 2 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| MaterialByDivisionModal | 2 |
| Checkbox | 1 |
| SearchArea | 1 |
| CascadeDropdown | 1 |
| PeriodField | 1 |
| DataGrid | 1 |
| MeasureSelectModal | 1 |
| IcMeasureSelect | 1 |
| MainTitle | 1 |
| GlobalPsiForm | 1 |
| SubTitle | 1 |
| GlobalPsiGrid | 1 |
| GlobalPsiModals | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafHeader | 70 | isColVisibleForBucket(binding, bucket, chkSum) | true |  | object | features/supply/src/pages/global-psi/utils/globalPsiColumns.ts | 166 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00618 | 1 |
| MSG00013 | 1 |
| MSG00097 | 1 |
| MSG00402 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00039 | 1 |
| LBL00040 | 1 |
| LBL00768 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00632 | 1 |
| LBL00687 | 1 |
| LBL00310 | 1 |
| LBL00682 | 1 |
| LBL00683 | 1 |
| LBL00684 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0025(14), SCP0031(10), SCP0100(7), SCP0013(5), DMF0003(2), SCP0095(2), SCM0002(1), DMF0021(1)
- SP/PKG: PKG_SCP0031(2), P_SCP0031_GET_GLOBAL_PSI(1), PKG_COM0000(1), P_SCP0009_GET_SHEET_CALENDAR_3SPAN(1), SCM0001_GET_SCP_MONTH_PERIOD(1), PR_GET_SHEET_MEASURE_LIST(1), P_DIVISION_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | return) 행별 명시값 48 이 안 지워져 헤더가 그대로 높게 남는다. 각 row.height 를 실제 tier 수로 | features/supply/src/pages/global-psi/components/GlobalPsiGrid.tsx | 283 |
| code | HORIZON_END_DATE 를 넘으면 종료일을 horizon 으로 되돌리고 이번 조회를 중단한다(AS-IS return). | features/supply/src/pages/global-psi/global-psi.constants.ts | 112 |
| endpoint | mount — keep-alive 탭에 남은 stale filters 자동발사 차단(clearFilters) + admin 동적 메타 fetch(mount 1회). | features/supply/src/pages/global-psi/GlobalPsi.tsx | 107 |
| code | 중단한다(return). 조회 자체가 무해하도록 AS-IS 도 try/catch 로 감싸므로, 콤보 실패·0행이면 clamp 없이 진행. | features/supply/src/pages/global-psi/GlobalPsi.tsx | 140 |
| code | horizon 초과 = 종료일 되돌리고 조회 중단(AS-IS return) | features/supply/src/pages/global-psi/GlobalPsi.tsx | 175 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch(convert-core §2.4 하드코딩 금지). 미등록/실패 시 빈 배열. | features/supply/src/pages/global-psi/useGlobalPsiStore.ts | 38 |
| endpoint | SCM_MST_SHEET_MEASURE 동적 fetch(design 03 §1-C 'Global PSI' 16행). PIVOT measure 세로축. | features/supply/src/pages/global-psi/useGlobalPsiStore.ts | 41 |

## 10. __asis-mapping__.md 상태
- 구현: 54
- 해당없음: 17
- 제외: 3
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-015 | §1 components / Container | 비가시 WinForms IContainer(디자이너 스캐폴딩) — React 무등가, design 00 §1 static | 해당없음 |
| D00-1-017 | §1 emptySpaceItem1 / EmptySpaceItem | DevExpress 레이아웃 여백 스캐폴딩 — React Grid 무등가, design 00 §1 영역1 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem3 / EmptySpaceItem | DevExpress 레이아웃 여백 스캐폴딩 — React Grid 무등가, design 00 §1 영역1 | 해당없음 |
| D00-1-019 | §1 layoutControlGroup2 / LayoutControlGroup | DevExpress 레이아웃 그룹 컨테이너 — SearchArea 로 대체, design 00 §1 영역1 | 해당없음 |
| D00-1-020 | §1 layoutControlItem1 / LayoutControlItem | 레이아웃 라벨 스캐폴딩(Bucket 라벨) — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-021 | §1 layoutControlItem13 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-022 | §1 layoutControlItem2 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-023 | §1 layoutControlItem3 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-024 | §1 layoutControlItem4 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-025 | §1 layoutControlItem5 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-026 | §1 layoutControlItem7 / LayoutControlItem | 레이아웃 라벨 스캐폴딩 — FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-027 | §1 lblBucket / LayoutControlItem | Bucket 라벨 스캐폴딩 — BUCKET FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-028 | §1 lblCombo1 / LayoutControlItem | Division 라벨 스캐폴딩 — DIVISION FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-029 | §1 lblItemId / LayoutControlItem | Material 라벨 스캐폴딩 — MATERIAL FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-030 | §1 lblToSite / LayoutControlItem | To Site 라벨 스캐폴딩 — TO_SITE FormItem label 로 흡수, design 00 §1 | 해당없음 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView | FpSpread SheetView — 공용 DataGrid 단일 시트로 흡수(GlobalPsiGrid.tsx), design 00 §1 | 해당없음 |
| D00-1-036 | §1 usrButton1 / UsrButton | orphan(x0y0/tabIndex0) 미parent·미참조 헬퍼 버튼 — 이식 제외(design 01 §1.1 #36, __asis-mapping__ §5) | 제외 |
| D00-1-037 | §1 usrLayoutControl2 / UsrLayoutControl | DevExpress 레이아웃 컨트롤 루트 — SearchArea 로 대체, design 00 §1 영역1 | 해당없음 |
| D00-2-010 | §2 spdMain / CellDoubleClick | SetDblClickColumnShowHide(pivot 드릴다운) — 공용 DataGrid pivot 컬럼 collapse 미제공(자매 SCP0100 동일)·저위험 잔여, design 04 명시. D00-3-025 와 동일 미이식 결정 | 제외 |
| D00-3-025 | §3 SetDblClickColumnShowHide / 817 | pivot 드릴다운 컬럼 show/hide — 공용 DataGrid pivot 컬럼 collapse 미제공(자매 SCP0100 동일)·저위험 잔여, design 04 명시 | 제외 |

