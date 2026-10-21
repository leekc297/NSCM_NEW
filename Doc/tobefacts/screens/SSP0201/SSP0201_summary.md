# SSP0201 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 26 · 엔드포인트 호출 14 (미해결 1, 주석 속 2) · 이벤트 30 · 컴포넌트 사용 72 · 하드코딩 컬럼 0 · 메시지 37
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request/components/RequestActionBar.module.scss | component | 6 |
| features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | component | 45 |
| features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | component | 199 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | component | 231 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | component | 249 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | component | 132 |
| features/shipping/src/pages/shipment-change-request/hooks/useShipmentChangeRequestValidation.ts | hook | 105 |
| features/shipping/src/pages/shipment-change-request/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request/shipment-change-request.constants.ts | constants | 291 |
| features/shipping/src/pages/shipment-change-request/shipment-change-request.types.ts | types | 38 |
| features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.module.scss | style | 67 |
| features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | page | 621 |
| features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | store | 265 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestColumns.ts | util | 74 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestDerive.ts | util | 55 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestEditLock.ts | util | 52 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestInsert.ts | util | 66 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestModifySave.test.ts | test | 289 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestModifySave.ts | util | 217 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestNewSave.test.ts | test | 358 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestNewSave.ts | util | 490 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestResult.test.ts | test | 192 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestResult.ts | util | 92 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.test.ts | test | 336 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.ts | util | 178 |
| features/shipping/src/pages/shipment-change-request/__asis-mapping__.md | mapping | 294 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | RequestInfoPanel.tsx:28 ShipmentChangeRequestForm.tsx:54 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentChangeRequestForm.tsx:57 useShipmentChangeRequestValidation.ts:25 |
| {?{comboId:'SSPBlockCheckIF_SCP',divisionId:divisionId\|\|FIXED_DIVISION,}} | http | 1 | N | useShipmentChangeRequestValidation.ts:33 |
| SSP0201/main//call-proc | hook | 1 | Y | ShipmentChangeRequest.tsx:116 |
| SSP0201/sub//call-proc | hook | 1 | Y | ShipmentChangeRequest.tsx:123 |
| /admin/menu/SSP0201/column | http | 1 | Y | useShipmentChangeRequestStore.ts:214 |
| /admin/menu/SSP0201/search-conditions | http | 1 | Y | useShipmentChangeRequestStore.ts:237 |
| /SSP0201/main/SAVE/call-proc | http | 2 | Y | shipmentChangeRequestModifySave.ts:202 shipmentChangeRequestNewSave.ts:480 |
| /SSP0201/main/REQ_NO/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:82 |
| /SSP0201/main/SAVE_NEW/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:189 |
| /SSP0201/main/SEARCH_NEW/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:320 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onRequestComplete | jsx | features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | 33 |
| Button | onClick | onCancel | jsx | features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | 38 |
| FunctionSearchIcon | onClick | onApprovalSearch | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 124 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 149 |
| CustomDropdown | onChange | <arrow> onChange,String | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 167 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 191 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 70 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 128 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 156 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 169 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 198 |
| InputField | onKeyDown | <arrow> onSearch | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 199 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 193 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 221 |
| g | beginningEdit | editGate | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 111 |
| g | pastingCell | editGate | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 112 |
| g | cellEditEnded | cellEditEndedHandler | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 149 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 165 |
| grid | loadedRows | <arrow> autoFitColumns | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 84 |
| grid | formatItem | <arrow>  | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 87 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 128 |
| ShipmentChangeRequestForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 482 |
| ShipmentChangeRequestForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 482 |
| ShipmentChangeRequestMainGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 517 |
| ShipmentChangeRequestMainGrid | onBlockedEdit | onBlockedEdit | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 518 |
| RequestInfoPanel | onChange | setRequestInfo | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 536 |
| RequestInfoPanel | onApprovalSearch | <arrow> setOpenApproval | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 537 |
| RequestActionBar | onRequestComplete | handleChangeRequest | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 546 |
| RequestActionBar | onCancel | handleCancel | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 547 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 18 |
| FormItem | 13 |
| InputField | 8 |
| CustomDropdown | 5 |
| Button | 4 |
| Panel | 3 |
| FunctionSearchIcon | 2 |
| DataGrid | 2 |
| PanelSeparator | 2 |
| Stack | 1 |
| Box | 1 |
| SearchArea | 1 |
| PeriodField | 1 |
| MainTitle | 1 |
| ShipmentChangeRequestForm | 1 |
| SubTitle | 1 |
| PanelGroup | 1 |
| ShipmentChangeRequestMainGrid | 1 |
| RequestInfoPanel | 1 |
| RequestActionBar | 1 |
| ShipmentChangeRequestSubGrid | 1 |
| MaterialByDivisionModal | 1 |
| ProjectByDivisionModal | 1 |
| SsoUserModal | 1 |

## 6. 하드코딩 Grid 컬럼
(없음)

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00097 | 1 |
| MSG00133 | 1 |
| MSG00001 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG00267 | 1 |
| MSG00174 | 1 |
| MSG00195 | 1 |
| MSG00202 | 1 |
| MSG00201 | 1 |
| MSG00194 | 1 |
| MSG00189 | 1 |
| MSG00287 | 1 |
| MSG00098 | 1 |
| MSG00293 | 1 |
| MSG00013 | 1 |
| MSG01269 | 1 |
| MSG00328 | 1 |
| LBL00001 | 1 |
| LBL00022 | 1 |
| LBL00023 | 1 |
| LBL00040 | 1 |
| LBL00014 | 1 |
| LBL01115 | 1 |
| LBL00618 | 1 |
| LBL01111 | 1 |
| LBL01063 | 1 |
| LBL00112 | 1 |
| LBL00107 | 1 |
| LBL01105 | 1 |
| LBL01125 | 1 |
| LBL01107 | 1 |
| LBL01108 | 1 |
| LBL01071 | 1 |
| LBL01052 | 1 |
| LBL01060 | 1 |
| LBL01104 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0200(36), SSP0201(22), SSP0003(2), SSP0202(2), SSP0015(1), SSP0014(1), SSP0026(1)
- SP/PKG: PKG_SSP0201(11), SCM0001_GET_SCP_DAY_PERIOD(3), P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST(2), P_ACTIVE_FLAG(2), SSP0201_GET_CHANGE_REQ_NO(2), P_CONFIRM_ID(2), FN_MULTY_TIME(2), P_DEBUG_MODE(2), FN_GET_IN_STR(1), SSP0201_GET_SHIPMENT_CHANGE_REQUEST(1), P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING(1), SSP0201_SAVE_SHIPMENT_CONFIRM_NEW(1), P_SSP0201_GET_CHANGE_REQ_NO(1), P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW(1), P_SSP0201_SAVE(1), P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N(1), P_DIVISION_ID(1), P_FROM_SITE(1), P_ERP_SO_NO(1), P_ITEM_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_STATUS(1), P_CHANGE_TYPE(1), P_LANGUAGE(1), P_TO_SITE(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다 — 비우지 않으면 | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 45 |
| code | 재조회는 **await 가능**해야 한다 — 저장 가드(savingRef)가 재조회 완료까지 잡혀 있어야 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 148 |
| code | DeleteButton — **저장 전 신규행(CRUD_TYPE='I')만** 그리드에서 걷어낸다(사용자 지시 2026-10-07). AS-IS `DeleteButton()`(cs:688~691)은 본문이 빈 NO-OP 라 종전 TO-BE 도 `() => undefined` 였는데, 넣은 신규행을 되돌릴 방법이 없어 자매 SSP0200 과 동일한 실동작을 부여했다. 수정행·기존행은 제거도 `CRUD_TYPE='D'` 마킹도 하 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 196 |
| code | 저장 실행 — 수정행·신규행을 **한 흐름**으로 처리한다(utils/shipmentChangeRequestSaveChain.ts). 번호 1회 채번 -> 수정행 DRAFTING -> 신규행(SAVE_NEW/SEARCH_NEW/DRAFTING). 실패하면 그 자리에서 멈춘다. 종전엔 두 체인이 따로 있고 `handleSave` 가 "신규가 있으면 신규만 하고 return" 했다 — 같이 수정한 기존행이 저장되지 않았고, 번호도 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 282 |
| code | 연타 방지 가드(savingRef) 규약 — Save / Request Complete / Cancel 3핸들러 공통. 1. **핸들러 진입 즉시** 켠다. 확인창(setAlert confirm)보다 먼저여야 한다 — 종전 구현은 confirm **뒤에** 켰기 때문에, 느린 회선에서 Save 를 두 번 누르면 확인창이 두 개 떠 둘 다 통과하고 SAVE_NEW 가 2회 나갔다(신규행이 중복 채번·중복 적재된다). 2. `tr | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 327 |
| code | 취소 **동작 자체**는 이번에 바꾸지 않는다(다음 단계) — 연타 가드와 재조회 await 만 입힌다. | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 389 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회). | features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | 36 |
| endpoint | 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4.1). 미등록/실패 시 빈 배열 유지. | features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | 211 |
| code | SSP0201 저장 실행체인 — **수정행과 신규행을 한 흐름으로** 처리한다. AS-IS `SaveButton()`(cs:764)은 저장 1회에 변경요청번호를 **한 번만** 채번하고(2단계, L783~794) 그 번호로 수정행 DRAFTING(GetERPInterface 2번 루프)과 신규행 체인(5·6단계)을 모두 처리한다. 종전 TO-BE 는 두 체인이 따로 있었고 `handleSave` 가 `if (inserted.l | features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.ts | 1 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

