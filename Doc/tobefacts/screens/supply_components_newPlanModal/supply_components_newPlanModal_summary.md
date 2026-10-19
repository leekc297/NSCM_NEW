# supply_components_newPlanModal — To-Be Fact Pack 요약

- page_key: `supply/components/newPlanModal` · feature: supply · As-is Fact Pack 없음(화면ID 미대응)
- 파일 8 · 엔드포인트 호출 11 (미해결 11, 주석 속 0) · 이벤트 11 · 컴포넌트 사용 16 · 하드코딩 컬럼 18 · 메시지 12
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 18건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/supply/src/components/newPlanModal/index.ts | index | 6 |
| features/supply/src/components/newPlanModal/newPlan.constants.ts | constants | 51 |
| features/supply/src/components/newPlanModal/newPlan.test.ts | test | 342 |
| features/supply/src/components/newPlanModal/newPlan.ts | other | 347 |
| features/supply/src/components/newPlanModal/NewPlanBodModal.module.scss | style | 22 |
| features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | page | 250 |
| features/supply/src/components/newPlanModal/NewPlanModal.module.scss | style | 36 |
| features/supply/src/components/newPlanModal/NewPlanModal.tsx | page | 733 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{params.menuId}/bodPopup/SEARCH/call-proc | http | 1 | N | NewPlanBodModal.tsx:126 |
| {?{comboId:COMBO_ID.BOD_ITEM,divisionId:context.divisionId,operationGroup:context.} | http | 1 | N | NewPlanModal.tsx:225 |
| {?{comboId:COMBO_ID.ORIGIN_DIVISION}} | http | 1 | N | NewPlanModal.tsx:231 |
| {?{comboId:COMBO_ID.PROJECT,divisionId:ee?'':context.divisionId,scmSiteId:'',itemI} | http | 1 | N | NewPlanModal.tsx:234 |
| {?{comboId:COMBO_ID.SITE,siteType:'PLANT',divisionId:''}} | http | 1 | N | NewPlanModal.tsx:241 |
| {?{comboId:COMBO_ID.SITE,siteType:toSiteType,divisionId:''}} | http | 1 | N | NewPlanModal.tsx:242 |
| {?{comboId:COMBO_ID.LOOKUP,lookupType:ELECTRODE_LOOKUP_TYPE}} | http | 1 | N | NewPlanModal.tsx:243 |
| {?operationGroupComboArgs(context.programId,ee)} | http | 1 | N | NewPlanModal.tsx:244 |
| /admin/menu/{menuId}/column | http | 1 | N | NewPlanModal.tsx:269 |
| /{menuId}/newCheck/SEARCH/call-proc | http | 1 | N | NewPlanModal.tsx:594 |
| /{menuId}/savePopup/SAVE/call-proc | http | 1 | N | NewPlanModal.tsx:608 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | handleSubmit | jsx | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 235 |
| Button | onClick | modalClose | jsx | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 242 |
| g | beginningEdit | beginningEditHandler | addHandler | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 427 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 445 |
| g | formatItem | formatEditableHandler | addHandler | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 464 |
| g.hostElement | click | clickHandler | addEventListener | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 489 |
| g | updatedLayout | layoutHandler | addHandler | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 493 |
| Button | onClick | handleInsert | jsx | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 690 |
| Button | onClick | handleDelete | jsx | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 691 |
| Button | onClick | handleSave | jsx | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 700 |
| Button | onClick | modalClose | jsx | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 707 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Button | 6 |
| CustomDialog | 2 |
| ResultArea | 2 |
| DataGrid | 2 |
| ControlConfirmIcon | 2 |
| ProgressIndicator | 1 |
| NewPlanBodModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| POPUP_COLUMNS | FROM_SITE_NAME | From Site | 150 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 71 |
| POPUP_COLUMNS | TO_SITE_NAME | To Site | 150 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 72 |
| POPUP_COLUMNS | ITEM_ID | Model | 130 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 73 |
| POPUP_COLUMNS | PRIORITY | Priority | 70 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 74 |
| POPUP_COLUMNS | INCOTERMS | Incoterms | 80 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 75 |
| POPUP_COLUMNS | TRANSPORT_MODE | Trans Mode | 90 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 76 |
| POPUP_COLUMNS | BOD_ITEM_VALID | BOD Item Valid | 90 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 77 |
| POPUP_COLUMNS | DAYS_MON | Mon | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 78 |
| POPUP_COLUMNS | DAYS_TUE | Tue | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 79 |
| POPUP_COLUMNS | DAYS_WED | Wed | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 80 |
| POPUP_COLUMNS | DAYS_THU | Thu | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 81 |
| POPUP_COLUMNS | DAYS_FRI | Fri | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 82 |
| POPUP_COLUMNS | DAYS_SAT | Sat | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 83 |
| POPUP_COLUMNS | DAYS_SUN | Sun | 45 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 84 |
| POPUP_COLUMNS | LEAD_TIME | L/T(Day) | 80 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 85 |
| POPUP_COLUMNS | FROM_YYYYMMDD | From | 100 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 86 |
| POPUP_COLUMNS | TO_YYYYMMDD | To | 100 |  |  |  | meta-shape | features/supply/src/components/newPlanModal/NewPlanBodModal.tsx | 87 |
| toRaw | c.key | c.label | c.width | true |  |  | meta-map | features/supply/src/components/newPlanModal/NewPlanModal.tsx | 374 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00674 | 1 |
| LBL00716 | 1 |
| LBL00111 | 1 |
| LBL00627 | 1 |
| MSG01075 | 1 |
| MSG01104 | 1 |
| MSG01126 | 1 |
| MSG00013 | 1 |
| MSG00428 | 1 |
| MSG01271 | 1 |
| MSG00606 | 1 |
| MSG01196 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0009(5), SCP0010(5), SCM0002(5), SCP0030(1), SCP0013(1)
- SP/PKG: PKG_SCM0002(3), P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK(1), P_SCM0002_SAVE_SHIPMENT_PLAN_NEW(1), P_SCM0002_GET_BODITEM_FOR_SUPPLY_POPUP(1), PR_GET_SHEET_COLUMN_LIST(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

