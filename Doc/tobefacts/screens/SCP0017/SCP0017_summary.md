# SCP0017 — To-Be Fact Pack 요약

- page_key: `supply/production-plan-waterfall` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 13 · 엔드포인트 호출 7 (미해결 0, 주석 속 2) · 이벤트 23 · 컴포넌트 사용 34 · 하드코딩 컬럼 1 · 메시지 31
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | component | 328 |
| features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | component | 359 |
| features/supply/src/pages/production-plan-waterfall/index.ts | index | 2 |
| features/supply/src/pages/production-plan-waterfall/production-plan-waterfall.constants.ts | constants | 173 |
| features/supply/src/pages/production-plan-waterfall/production-plan-waterfall.types.ts | types | 25 |
| features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.module.scss | style | 12 |
| features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | page | 368 |
| features/supply/src/pages/production-plan-waterfall/useProductionPlanWaterfallStore.ts | store | 346 |
| features/supply/src/pages/production-plan-waterfall/utils/waterfall.columns.ts | util | 228 |
| features/supply/src/pages/production-plan-waterfall/utils/waterfall.merge.ts | util | 113 |
| features/supply/src/pages/production-plan-waterfall/utils/waterfall.periods.test.ts | test | 42 |
| features/supply/src/pages/production-plan-waterfall/utils/waterfall.periods.ts | util | 105 |
| features/supply/src/pages/production-plan-waterfall/__asis-mapping__.md | mapping | 250 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ProductionPlanWaterfallForm.tsx:64 |
| (useTabLookupQueries) | hook | 1 | Y | ProductionPlanWaterfallForm.tsx:78 |
| SCP0017/title//call-proc | hook | 1 | Y | ProductionPlanWaterfallGrid.tsx:72 |
| SCP0017/main//call-proc | hook | 1 | Y | ProductionPlanWaterfall.tsx:101 |
| /admin/menu/SCP0017/column | http | 1 | Y | useProductionPlanWaterfallStore.ts:262 |
| /admin/menu/SCP0017/measure | http | 1 | Y | useProductionPlanWaterfallStore.ts:284 |
| /admin/menu/SCP0017/search-conditions | http | 1 | Y | useProductionPlanWaterfallStore.ts:322 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId operationGroup scmSiteId lineId itemId fromYyyymmdd toYyyymmdd versionNo electrodeType nickName gap programId sheetName debugMode | o_rc1 | SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SCP0017 |
| title | divisionId bucket fromYyyymmdd toYyyymmdd | o_rc1 | SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SCP0017 |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 149 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 176 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 187 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 247 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 248 |
| FunctionSearchIcon | onClick | onModelSearch | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 243 |
| InputField | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 275 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 276 |
| FunctionSearchIcon | onClick | onNickNameSearch | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 271 |
| PeriodField | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 288 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 306 |
| Checkbox | onChange | <arrow> setChkAll | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 312 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallForm.tsx | 317 |
| g | updatedLayout | applyDynVisibility | addHandler | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | 163 |
| g | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | 197 |
| g | scrollPositionChanged | onScroll | addHandler | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | 220 |
| host | dblclick | onDblClick | addEventListener | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | 275 |
| g | formatItem | handler | addHandler | features/supply/src/pages/production-plan-waterfall/components/ProductionPlanWaterfallGrid.tsx | 327 |
| ProductionPlanWaterfallForm | onSearch | handleSearch | jsx | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 273 |
| ProductionPlanWaterfallForm | onModelSearch | <arrow> setOpenModel | jsx | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 274 |
| ProductionPlanWaterfallForm | onNickNameSearch | <arrow> setOpenNickNamePopup | jsx | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 275 |
| ColumnLayoutModal | onSave | handleSaveColumnLayout | jsx | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 353 |
| MeasureSelectModal | onApply | handleApplyMeasures | jsx | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 363 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 5 |
| FormItem | 4 |
| Checkbox | 3 |
| CustomDropdown | 2 |
| InputField | 2 |
| Button | 2 |
| FunctionSearchIcon | 2 |
| MaterialByDivisionModal | 2 |
| SearchArea | 1 |
| PeriodField | 1 |
| Stack | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ProductionPlanWaterfallForm | 1 |
| SubTitle | 1 |
| IcGridColumnSetup | 1 |
| IcMeasureSelect | 1 |
| ProductionPlanWaterfallGrid | 1 |
| ColumnLayoutModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildDynamicColumns | m.binding | rank === 2 ? m.leaf \|\| m.small \|\| 'SUM' : 'SUM' | 90 | baseVisibleOf(bucket, chkSum, m.kind) |  |  | object | features/supply/src/pages/production-plan-waterfall/utils/waterfall.columns.ts | 186 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00667 | 1 |
| MSG00376 | 1 |
| MSG00429 | 1 |
| MSG00108 | 1 |
| MSG01187 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00005 | 1 |
| LBL00010 | 1 |
| LBL00606 | 1 |
| LBL00038 | 1 |
| LBL00710 | 1 |
| LBL00013 | 1 |
| LBL00632 | 1 |
| LBL01079 | 1 |
| LBL00669 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |
| LBL00618 | 1 |
| LBL00687 | 1 |
| LBL00112 | 1 |
| LBL00310 | 1 |
| LBL00711 | 1 |
| LBL00764 | 1 |
| LBL00765 | 1 |
| MSG00618 | 2 |
| MSG00606 | 2 |
| LBL00605 | 2 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0017(12), SCP0025(6), SCP0101(2), DMF0035(1)
- SP/PKG: PKG_SCP0017(5), P_SCP0017_GET_SHEET_CALENDAR_3SPAN(2), P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL(1), SCP0009_GET_SHEET_CALENDAR_3SPAN(1), SCM0001_GET_SCP_MONTH_PERIOD(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | - 저장 없음(읽기전용, InsertButton/DeleteButton/SaveButton 전량 NO-OP · EditButton 메시지 후 return) | features/supply/src/pages/production-plan-waterfall/production-plan-waterfall.constants.ts | 8 |
| code | 읽기전용: Insert/Delete/Save NO-OP(AS-IS 주석 본문), Edit=MSG00109 후 return. 자매 SCP0101(SEARCH-only) | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 40 |
| endpoint | 컬럼/Measure 메타 fetch(mount 1회) + keep-alive 잔여 filters 무효화(자동조회 금지, nscm-patterns §5-7) | features/supply/src/pages/production-plan-waterfall/ProductionPlanWaterfall.tsx | 79 |
| endpoint | admin SCM_MST_SHEET_COLUMNS('MODEL') 동적 fetch (ui-dynamic-property-management). SCP0017 25행 등록 확인됨. | features/supply/src/pages/production-plan-waterfall/useProductionPlanWaterfallStore.ts | 33 |

## 10. __asis-mapping__.md 상태
- 구현: 69
- 해당없음: 36
- 제외: 3
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-015 | §1 components / System.ComponentModel.Container | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-017 | §1 emptySpaceItem1 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-018 | §1 emptySpaceItem2 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-019 | §1 emptySpaceItem3 / EmptySpaceItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-020 | §1 layoutControlGroup2 / LayoutControlGroup | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-021 | §1 layoutControlItem1 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-022 | §1 layoutControlItem10 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-023 | §1 layoutControlItem11 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-024 | §1 layoutControlItem12 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-025 | §1 layoutControlItem13 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-026 | §1 layoutControlItem14 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-027 | §1 layoutControlItem2 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-028 | §1 layoutControlItem3 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-029 | §1 layoutControlItem4 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-030 | §1 layoutControlItem5 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-031 | §1 layoutControlItem6 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-032 | §1 layoutControlItem7 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-033 | §1 layoutControlItem9 / LayoutControlItem | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-034 | §1 lblBucket1 / LayoutControlItem | WinForms 레이아웃 프리미티브(라벨) — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-035 | §1 lblItemId / LayoutControlItem | WinForms 레이아웃 프리미티브(라벨) — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-1-037 | §1 spdMain_Sheet1 / SheetView | WinForms 레이아웃 프리미티브(SheetView) — React DataGrid 단일 시트로 대체 | 해당없음 |
| D00-1-040 | §1 usrButton1 / UsrButton | AS-IS dead control(Designer 33, 미노출) — 미이식(§1 usrButton1 dead control 소거) | 제외 |
| D00-1-041 | §1 usrConditionPanel1 / UsrConditionPanel | WinForms 레이아웃 프리미티브(조회영역 패널) — SearchArea 컴포넌트로 대체 | 해당없음 |
| D00-1-042 | §1 usrLayoutControl2 / UsrLayoutControl | WinForms 레이아웃 프리미티브 — React JSX/SCSS 구조로 대체 | 해당없음 |
| D00-3-037 | §3 SetActiveCell / (nSelRowOfMain, nSelColOfMain) 선택복원 | 재조회 후 선택셀 복원(R10) 미배선 — UX 편의 후속 결정(G9, 04 §④ / §7 잔여). 데이터/회귀 무관 저위험 | 제외 |
| D00-3-038 | §3 ShowCell / 선택셀 스크롤 이동 | 선택셀 중앙 스크롤(R10) 미배선 — 선택복원(D00-3-037)과 동일 UX 후속 결정(G9) | 제외 |
| D00-3-040 | §3 Query / (dsBinding) Line 그리드 바인딩 | LINE 시트 = AS-IS 미구동(spdLine/FindData_Line 전량 주석) — 미구현 재현(파리티, design 03 §6-2). §4 명시 | 해당없음 |
| D00-3-041 | §3 LockColumn / (0, GetMaxColumnIndex(), true) 전체 잠금 | LINE 시트 미구동(AS-IS 파리티) — MODEL 시트만 구동 | 해당없음 |
| D00-3-042 | §3 SmartColMerge / () | LINE 시트 병합 = AS-IS 미구동(spdLine 주석) — 미구현 재현(파리티) | 해당없음 |
| D00-3-043 | §3 SetDecimal / (i, nIdxStart, i, nIdxEnd, 2, true) 소수2자리 | siLine 소수처리 — LINE 시트 미구동(AS-IS 파리티) | 해당없음 |
| D00-3-044 | §3 SetActiveCell / (nSelRowOfLine, nSelColOfLine) | siLine 선택복원 — LINE 시트 미구동(AS-IS 파리티) | 해당없음 |
| D00-3-047 | §3 SetValue / 주합계/주일수 = weekSum/nCntDayOfWeek | R15 주/월 합계는 SP 서버계산 반환 → FE 표시만(design 03 §3.1). FE 재계산 없음, EOH 보정은 PKG 배포 후(§7 R15) | 해당없음 |
| D00-3-048 | §3 SetValue / 월합계/월일수 = monthSum/nCntDayOfMonth | R15 월합계 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-049 | §3 SetValue / 월컬럼 = 전일값 파생 | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-050 | §3 SetValue / 주컬럼 = 전일값 파생 | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-051 | §3 SetValue / 주컬럼 = 전일값 파생 | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-052 | §3 SetValue / 월컬럼 = 전일값 파생 | R15 전일값 파생 SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-053 | §3 SetValue / 주컬럼_D = weekSum_D | R15 주합계_D SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |
| D00-3-054 | §3 SetValue / 월컬럼_D = monthSum_D | R15 월합계_D SP 서버계산 반환 표시(design 03 §3.1) — FE 재계산 없음 | 해당없음 |

