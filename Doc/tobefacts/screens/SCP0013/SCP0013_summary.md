# SCP0013 — To-Be Fact Pack 요약

- page_key: `supply/production-plan-line` · feature: supply · As-is Fact Pack 있음
- 파일 25 · 엔드포인트 호출 19 (미해결 3, 주석 속 2) · 이벤트 36 · 컴포넌트 사용 48 · 하드코딩 컬럼 13 · 메시지 50
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 13건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx | component | 77 |
| features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.module.scss | component | 23 |
| features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | component | 544 |
| features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.module.scss | component | 29 |
| features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | component | 166 |
| features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.module.scss | component | 58 |
| features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | component | 544 |
| features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | component | 418 |
| features/supply/src/pages/production-plan-line/hooks/useProductionPlanLineValidation.ts | hook | 69 |
| features/supply/src/pages/production-plan-line/index.ts | index | 2 |
| features/supply/src/pages/production-plan-line/production-plan-line.constants.ts | constants | 286 |
| features/supply/src/pages/production-plan-line/production-plan-line.mock.ts | other | 79 |
| features/supply/src/pages/production-plan-line/production-plan-line.types.ts | types | 64 |
| features/supply/src/pages/production-plan-line/ProductionPlanLine.module.scss | style | 12 |
| features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | page | 598 |
| features/supply/src/pages/production-plan-line/useProductionPlanLineStore.ts | store | 335 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineColumns.ts | util | 157 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineDerive.test.ts | test | 139 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineDerive.ts | util | 132 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineDrilldown.test.ts | test | 75 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineDrilldown.ts | util | 79 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineEditLock.test.ts | test | 231 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineEditLock.ts | util | 232 |
| features/supply/src/pages/production-plan-line/utils/productionPlanLineFixSave.ts | util | 124 |
| features/supply/src/pages/production-plan-line/__asis-mapping__.md | mapping | 76 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabLookupQueries) | hook | 2 | Y | ProductionPlanInsertModal.tsx:115 ProductionPlanLineForm.tsx:94 |
| {?{comboId:'ItemProdPlanLinePopup_SCP',divisionId:params.divisionId,operationGroup} | http | 1 | N | ProductionPlanInsertModal.tsx:155 |
| {?{comboId:'LineProdPlanLinePopup_SCP',divisionId:params.divisionId,operationGroup} | http | 1 | N | ProductionPlanInsertModal.tsx:316 |
| {?{comboId:'OriginDivFromFinalItem_SCP',itemId}} | http | 1 | N | ProductionPlanInsertModal.tsx:340 |
| SCP0013/newCheck/SEARCH/call-proc | callProc | 1 | Y | ProductionPlanInsertModal.tsx:447 |
| SCP0013/savePopup/SAVE/call-proc | callProc | 1 | Y | ProductionPlanInsertModal.tsx:470 |
| SCP0013/load//call-proc | hook | 1 | Y | ProductionPlanLineLoadModal.tsx:60 |
| (useTabComboQueries) | hook | 1 | Y | ProductionPlanLineForm.tsx:81 |
| SCP0013/lineList//call-proc | hook | 1 | Y | ProductionPlanLineForm.tsx:125 |
| SCP0013/extraSpec//call-proc | hook | 1 | Y | ProductionPlanLineForm.tsx:143 |
| SCP0013/main//call-proc | hook | 2 | Y | ProductionPlanLine.tsx:94 ProductionPlanLine.tsx:102 |
| SCP0013/fix//call-proc | hook | 1 | Y | ProductionPlanLine.tsx:110 |
| SCP0013/editInfo//call-proc | hook | 1 | Y | ProductionPlanLine.tsx:171 |
| SCP0013/saveYn/SEARCH/call-proc | callProc | 1 | Y | ProductionPlanLine.tsx:301 |
| /admin/menu/SCP0013/column | http | 1 | Y | useProductionPlanLineStore.ts:248 |
| /admin/menu/SCP0013/measure | http | 1 | Y | useProductionPlanLineStore.ts:274 |
| /admin/menu/SCP0013/search-conditions | http | 1 | Y | useProductionPlanLineStore.ts:296 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| InputField | onChange | <arrow> setReason | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx | 52 |
| Button | onClick | <arrow> onConfirm | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx | 62 |
| Button | onClick | onClose | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx | 69 |
| g | updatedLayout | apply | addHandler | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 304 |
| g | cellEditEnded | onEdit | addHandler | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 385 |
| Button | onClick | handleInsert | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 510 |
| Button | onClick | handleDelete | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 517 |
| Button | onClick | <arrow> handleSave | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 525 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 527 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 110 |
| DataGrid | initialized | handleGridInit | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 148 |
| Button | onClick | modalClose | jsx | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 158 |
| CustomDropdown | onChange | <arrow> onPick,String(picked??'').split(',').filter,String(picked??'').split,String,v.toUpperCase | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 357 |
| CustomDropdown | onChange | <arrow> onPick,String | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 386 |
| InputField | onChange | <arrow> onPick | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 418 |
| Button | onClick | onItemSearch | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 414 |
| SearchArea | onSearch | onSearch | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 438 |
| PlanVersionCascade | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 489 |
| PeriodRangePicker | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 505 |
| Checkbox | onChange | <arrow> set | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineForm.tsx | 534 |
| grid | updatedLayout | applyHeaderHeight | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 190 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 239 |
| g | pastingCell | beginningEditHandler | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 241 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 286 |
| g | pastedCell | cellEditEndedHandler | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 287 |
| g | formatItem | formatHandler | addHandler | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 355 |
| g.hostElement? | dblclick | dblClickHandler | addEventListener | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 377 |
| DataGrid | initialized | handleGridInitialized | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 413 |
| DataGrid | gotFocus | onFocus | jsx | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 414 |
| ProductionPlanLineForm | onSearch | handleSearch | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 488 |
| ProductionPlanLineForm | onItemSearch | <arrow> setOpenItem | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 488 |
| ProductionPlanLineGrid | onFocus | <arrow>  | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 539 |
| ProductionPlanFixReasonModal | onClose | <arrow> setOpenFixReason | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 567 |
| ProductionPlanFixReasonModal | onConfirm | handleFixReasonConfirm | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 568 |
| ProductionPlanInsertModal | onSaved | handleInsertSaved | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 583 |
| MeasureSelectModal | onApply | <arrow> setVisibleMeasures | jsx | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 593 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 8 |
| Grid | 7 |
| FormItem | 4 |
| CustomDialog | 3 |
| DataGrid | 3 |
| InputField | 2 |
| Stack | 2 |
| CustomDropdown | 2 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| FunctionSearchIcon | 1 |
| SearchArea | 1 |
| PlanVersionCascade | 1 |
| PeriodRangePicker | 1 |
| Checkbox | 1 |
| MainTitle | 1 |
| ProductionPlanLineForm | 1 |
| SubTitle | 1 |
| IcMeasureSelect | 1 |
| ProductionPlanLineGrid | 1 |
| MaterialByDivisionModal | 1 |
| ProductionPlanLineLoadModal | 1 |
| ProductionPlanFixReasonModal | 1 |
| ProductionPlanInsertModal | 1 |
| MeasureSelectModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| col | colNm | colLblNm | width | true |  |  | meta-map | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanInsertModal.tsx | 90 |
| LOAD_COLUMNS | SCM_SITE_ID | Plant Site | 150 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 32 |
| LOAD_COLUMNS | FACTORY_NAME | Building | 160 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 33 |
| LOAD_COLUMNS | OPERATION_ID | Operation | 150 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 34 |
| LOAD_COLUMNS | LINE_NAME | Line | 90 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 35 |
| LOAD_COLUMNS | DIVISION_ID | Division | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 37 |
| LOAD_COLUMNS | LINE_ID | Line ID | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 38 |
| LOAD_COLUMNS | ORIGIN_DIVISION_ID | Origin Div | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 39 |
| LOAD_COLUMNS | ELECTRODE_TYPE | Electrode | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 40 |
| LOAD_COLUMNS | FACTORY_ID | Factory ID | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 41 |
| LOAD_COLUMNS | TYPE | Type | 0 |  |  |  | meta-shape | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanLineLoadModal.tsx | 42 |
| fallbackToRaw | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/supply/src/pages/production-plan-line/utils/productionPlanLineColumns.ts | 19 |
| buildPivotColumns | DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER | leafHeader | 70 | true |  |  | object | features/supply/src/pages/production-plan-line/utils/productionPlanLineColumns.ts | 98 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG01271 | 1 |
| MSG01272 | 1 |
| MSG00002 | 4 |
| MSG00429 | 1 |
| MSG00096 | 1 |
| MSG00135 | 1 |
| MSG01196 | 1 |
| MSG01273 | 1 |
| MSG00225 | 1 |
| MSG00165 | 1 |
| MSG00013 | 1 |
| MSG01262 | 1 |
| MSG00683 | 1 |
| MSG00014 | 1 |
| MSG01293 | 1 |
| MSG00004 | 1 |
| MSG00003 | 1 |
| MSG00108 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00042 | 1 |
| LBL00038 | 1 |
| LBL00043 | 1 |
| LBL00005 | 1 |
| LBL00010 | 1 |
| LBL00669 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |
| LBL00618 | 1 |
| LBL00039 | 1 |
| LBL01220 | 1 |
| LBL00040 | 1 |
| LBL00041 | 1 |
| LBL00013 | 1 |
| LBL00710 | 1 |
| LBL00632 | 1 |
| LBL00769 | 1 |
| LBL00687 | 1 |
| LBL00771 | 1 |
| LBL00772 | 1 |
| LBL01028 | 1 |
| LBL00773 | 1 |
| LBL00310 | 1 |
| LBL00625 | 1 |
| LBL00716 | 1 |
| LBL00627 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0013(20), DMF0082(8), SCP0025(3), SCP0020(2), SCP0011(2), SCP0005(1), DMF0049(1), SCP0024(1)
- SP/PKG: PKG_SCP0013(10), P_SCP0013_GET_PLAN_EDIT_INFO(4), P_SCP0013_SAVE_LINE_ROW_JSON(4), P_SCP0024_SAVE_PLAN_FIX_DS(4), PR_GET_SHEET_COLUMN_LIST(4), P_PLAN_START_YYYYMMDD(3), PKG_SCP0024(3), P_START_YYYYMMDD(3), P_SCP0013_LINE_LOAD_POPUP(2), P_SCP0013_GET_LINE_LIST(2), SCP0013_GET_EXTRA_SPEC(2), P_SCP0013_GET_PLAN_SAVE_YN(2), P_SCP0013_GET_EXTRA_SPEC(2), P_SCP0013_GET_LINE_NEW_CHECK(1), P_SCP0013_SAVE_LINE_POPUP(1), P_PLANT_SITE(1), SCM0001_GET_SCP_DAILY_PLAN_PERIOD(1), SCM0001_GET_SCP_DAY_PERIOD(1), P_SCP0013_GET_PROD_PLAN_LINEBY(1), P_SCP0013_SAVE_LINE_ROW(1), P_SCP0024_SAVE(1), P_CODE(1), SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET(1), P_DIVISION_ID(1), P_PLAN_TYPE(1), P_DATA(1), P_LINE_ID(1), SCP0013_GET_PLAN_EDIT_INFO(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 사유 확정(OK) 콜백 — 취소(onClose)는 저장을 중단한다(design 01 R6 — 취소 시 return). | features/supply/src/pages/production-plan-line/components/modals/ProductionPlanFixReasonModal.tsx | 12 |
| jsx | DataGrid 가 넘겨준 자기 그리드라 캐스팅 안전(CustomMergeManager<WijmoRowItem> 기대 타입과 동일 인스턴스). | features/supply/src/pages/production-plan-line/components/ProductionPlanLineGrid.tsx | 168 |
| code | filters 가 비면(division 변경·초기) early-return. 편집잠금(요청1)은 Form 이 콤보로 stageEditable 을 갱신해 담당. | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 320 |
| code | 여기 silent return 은 방어적 2차 가드(AS-IS BtnNew_Click 의 무메시지 early return 과 동일 성격). | features/supply/src/pages/production-plan-line/ProductionPlanLine.tsx | 375 |
| endpoint | admin SCM_MST_SHEET_COLUMNS 동적 fetch (ui-dynamic-property-management §2.3). SCP0013 'Line' 27행 등록 | features/supply/src/pages/production-plan-line/useProductionPlanLineStore.ts | 27 |
| endpoint | Measure 설정 팝업용 measure 메타 fetch (SCM_MST_SHEET_MEASURE SHEET_NAME='LINE'). | features/supply/src/pages/production-plan-line/useProductionPlanLineStore.ts | 55 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

