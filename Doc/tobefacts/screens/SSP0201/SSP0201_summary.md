# SSP0201 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-change-request` · feature: shipping · As-is Fact Pack 있음
- 파일 33 · 엔드포인트 호출 22 (미해결 4, 주석 속 2) · 이벤트 34 · 컴포넌트 사용 72 · 하드코딩 컬럼 0 · 메시지 44
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 0건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-change-request/components/RequestActionBar.module.scss | component | 10 |
| features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | component | 45 |
| features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | component | 214 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | component | 228 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | component | 491 |
| features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | component | 132 |
| features/shipping/src/pages/shipment-change-request/hooks/useShipmentChangeRequestBusyTask.ts | hook | 38 |
| features/shipping/src/pages/shipment-change-request/hooks/useShipmentChangeRequestCellCombos.ts | hook | 136 |
| features/shipping/src/pages/shipment-change-request/hooks/useShipmentChangeRequestValidation.test.ts | test | 49 |
| features/shipping/src/pages/shipment-change-request/hooks/useShipmentChangeRequestValidation.ts | hook | 255 |
| features/shipping/src/pages/shipment-change-request/index.ts | index | 2 |
| features/shipping/src/pages/shipment-change-request/shipment-change-request.constants.ts | constants | 395 |
| features/shipping/src/pages/shipment-change-request/shipment-change-request.types.ts | types | 41 |
| features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.module.scss | style | 67 |
| features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | page | 968 |
| features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | store | 379 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestCancel.ts | util | 134 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestColumns.ts | util | 86 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestComplete.ts | util | 239 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestDerive.test.ts | test | 88 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestDerive.ts | util | 298 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestEditLock.ts | util | 49 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestInsert.ts | util | 111 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestModifySave.test.ts | test | 289 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestModifySave.ts | util | 217 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestNewSave.test.ts | test | 358 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestNewSave.ts | util | 490 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestResult.test.ts | test | 192 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestResult.ts | util | 92 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.test.ts | test | 336 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.ts | util | 178 |
| features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestStatusCheck.ts | util | 79 |
| features/shipping/src/pages/shipment-change-request/__asis-mapping__.md | mapping | 296 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 2 | Y | RequestInfoPanel.tsx:31 ShipmentChangeRequestForm.tsx:54 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentChangeRequestForm.tsx:57 useShipmentChangeRequestValidation.ts:90 |
| (useTabComboQueryResults) | hook | 1 | Y | useShipmentChangeRequestCellCombos.ts:68 |
| {?{comboId:COMBO.CELL_END_CUSTOMER,divisionId:div,scmSiteId,itemId,param5:'P',}} | http | 1 | N | useShipmentChangeRequestCellCombos.ts:92 |
| {?{comboId:'SSPBlockCheckIF_SCP',segment1:MENU_ID}} | http | 1 | N | useShipmentChangeRequestValidation.ts:136 |
| SSP0201/main//call-proc | hook | 1 | Y | ShipmentChangeRequest.tsx:219 |
| SSP0201/sub//call-proc | hook | 1 | Y | ShipmentChangeRequest.tsx:226 |
| /SSP0201/main/GET_SCP_DAY_PERIOD/call-proc | http | 1 | Y | useShipmentChangeRequestStore.ts:204 |
| {?{comboId:COMBO.REQUESTOR_DEPT}} | http | 1 | N | useShipmentChangeRequestStore.ts:295 |
| {?{comboId:COMBO.DEPT_NAME,deptId,param1:String(useSessionStore.getState().session} | http | 1 | N | useShipmentChangeRequestStore.ts:302 |
| /admin/menu/SSP0201/column | http | 1 | Y | useShipmentChangeRequestStore.ts:324 |
| /admin/menu/SSP0201/search-conditions | http | 1 | Y | useShipmentChangeRequestStore.ts:347 |
| /SSP0201/main/CANCEL/call-proc | http | 1 | Y | shipmentChangeRequestCancel.ts:121 |
| /SSP0201/main/COMPLETE/call-proc | http | 1 | Y | shipmentChangeRequestComplete.ts:208 |
| /SSP0201/main/SAVE/call-proc | http | 2 | Y | shipmentChangeRequestModifySave.ts:202 shipmentChangeRequestNewSave.ts:480 |
| /SSP0201/main/REQ_NO/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:82 |
| /SSP0201/main/SAVE_NEW/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:189 |
| /SSP0201/main/SEARCH_NEW/call-proc | http | 1 | Y | shipmentChangeRequestNewSave.ts:320 |
| /SSP0201/main/STATUS_CHECK/call-proc | http | 1 | Y | shipmentChangeRequestStatusCheck.ts:44 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onRequestComplete | jsx | features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | 33 |
| Button | onClick | onCancel | jsx | features/shipping/src/pages/shipment-change-request/components/RequestActionBar.tsx | 38 |
| Button | onClick | onApprovalSearch | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 134 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 158 |
| CustomDropdown | onChange | <arrow> onChange,String | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 177 |
| InputField | onChange | <arrow> onChange | jsx | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 205 |
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 70 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 101 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 128 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 156 |
| PeriodField | onChange | <arrow> setPeriod | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 169 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 196 |
| Button | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 192 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestForm.tsx | 218 |
| g | updatedLayout | attach | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 157 |
| g | beginningEdit | editGate | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 217 |
| g | pastingCell | editGate | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 218 |
| g | cellEditEnded | applyCellChange | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 366 |
| g | pastedCell | applyCellChange | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 367 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 389 |
| g | selectionChanged | refreshEndCustomerOnFocus | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 404 |
| grid | loadedRows | <arrow> autoFitColumns | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 84 |
| grid | formatItem | <arrow>  | addHandler | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 87 |
| DataGrid | initialized | handleInitialized | jsx | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestSubGrid.tsx | 128 |
| ShipmentChangeRequestForm | onSearch | handleSearch | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 807 |
| ShipmentChangeRequestForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 808 |
| ShipmentChangeRequestMainGrid | onPopupCellDblClick | handlePopupCellDblClick | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 858 |
| ShipmentChangeRequestMainGrid | onEndCustomerSourceChanged | applyEndCustomer | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 859 |
| ShipmentChangeRequestMainGrid | onEndCustomerCellFocus | focusEndCustomer | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 860 |
| ShipmentChangeRequestMainGrid | onBlockedEdit | onBlockedEdit | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 861 |
| RequestInfoPanel | onChange | setRequestInfo | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 879 |
| RequestInfoPanel | onApprovalSearch | <arrow> setOpenApproval | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 880 |
| RequestActionBar | onRequestComplete | handleChangeRequest | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 889 |
| RequestActionBar | onCancel | handleCancel | jsx | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 890 |

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
| MSG01189 | 1 |
| MSG00684 | 1 |
| MSG01213 | 1 |
| MSG01212 | 1 |
| MSG01206 | 1 |
| MSG01353 | 1 |
| MSG01081 | 1 |
| MSG01202 | 2 |
| MSG00287 | 1 |
| MSG00098 | 1 |
| MSG01296 | 1 |
| MSG00614 | 1 |
| MSG01290 | 1 |
| MSG01269 | 1 |
| MSG00328 | 1 |
| MSG01188 | 1 |
| MSG00316 | 1 |
| MSG00353 | 1 |
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
- 화면ID: SSP0200(74), SSP0201(30), SSP0003(3), SSP0026(2), SSP0202(2), COM0013(1), SSP0015(1), SSP0014(1)
- SP/PKG: PKG_SSP0201(11), SCM0001_GET_SCP_DAY_PERIOD(7), P_FROM_SITE(3), FN_MULTY_TIME(3), P_CONFIRM_ID(3), P_SSP0201_GET_SHIPMENT_STATUS(2), P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST(2), P_TO_SITE(2), PKG_COM0000(2), P_SCM0001_GET_SCP_DAY_PERIOD(2), P_ACTIVE_FLAG(2), SSP0201_GET_CHANGE_REQ_NO(2), P_DEBUG_MODE(2), FN_GET_SCM_SITE_DESCRIPTION(1), P_USER_DEPT_ID(1), P_REQUEST_DEPT_ID(1), FN_GET_IN_STR(1), P_TIMEZONE(1), SSP0201_GET_SHIPMENT_CHANGE_REQUEST(1), P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING(1), P_CHANGE_REQUEST_NO(1), P_SPL_ARR(1), SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE(1), P_SSP0201_COMPLETE(1), P_AUTH(1), P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING(1), SSP0201_SAVE_SHIPMENT_CONFIRM_NEW(1), P_SSP0201_GET_CHANGE_REQ_NO(1), P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW(1), P_SSP0201_SAVE(1), P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N(1), P_DIVISION_ID(1), P_ERP_SO_NO(1), P_ITEM_ID(1), P_FROM_YYYYMMDD(1), P_TO_YYYYMMDD(1), P_STATUS(1), P_CHANGE_TYPE(1), P_LANGUAGE(1), P_USER_ID(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| jsx | 우측 1/3 은 빈 칸(`<Grid size={4} />`)으로 비워 2열을 유지한다 — 비우지 않으면 | features/shipping/src/pages/shipment-change-request/components/RequestInfoPanel.tsx | 55 |
| code | NEW_LT_DAY 공백이면 파생 없음 → AS-IS 처럼 그 자리에서 끝낸다(마킹·전파 없음, cs:5528 return). | features/shipping/src/pages/shipment-change-request/components/ShipmentChangeRequestMainGrid.tsx | 293 |
| code | Save / Request Complete / Cancel 공통 실행 래퍼 — **연타 가드 + 전역 스피너**를 한자리에 모은다. `savingRef` : 재진입 차단(같은 핸들러 연타 + 서로 다른 핸들러 교차 호출). 조회·Insert·New· Delete 도 이 플래그를 읽어 "저장 중"에는 비켜선다. `runBusy` : react-query mutation 으로 감싸 `useIsBusy([tabId])` 가 전역 스 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 184 |
| code | 재조회는 **await 가능**해야 한다 — 저장 가드(savingRef)가 재조회 완료까지 잡혀 있어야 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 255 |
| code | DeleteButton — **저장 전 신규행(CRUD_TYPE='I')만** 그리드에서 걷어낸다(사용자 지시 2026-10-07). AS-IS `DeleteButton()`(cs:688~691)은 본문이 빈 NO-OP 라 종전 TO-BE 도 `() => undefined` 였는데, 넣은 신규행을 되돌릴 방법이 없어 자매 SSP0200 과 동일한 실동작을 부여했다. 수정행·기존행은 제거도 `CRUD_TYPE='D'` 마킹도 하 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 362 |
| code | 저장 실행 — 수정행·신규행을 **한 흐름**으로 처리한다(utils/shipmentChangeRequestSaveChain.ts). 번호 1회 채번 -> 수정행 DRAFTING -> 신규행(SAVE_NEW/SEARCH_NEW/DRAFTING). 실패하면 그 자리에서 멈춘다. 종전엔 두 체인이 따로 있고 `handleSave` 가 "신규가 있으면 신규만 하고 return" 했다 — 같이 수정한 기존행이 저장되지 않았고, 번호도 | features/shipping/src/pages/shipment-change-request/ShipmentChangeRequest.tsx | 451 |
| endpoint | ui-dynamic-property-management §2.3 — admin SCM_MST_SHEET_COLUMNS 동적 fetch(메인/서브 2회). | features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | 43 |
| code | await 사이에 restore 가 periodRestored 를 세웠을 수 있다 — 쓰기 직전 재확인(느린 SP 대비). | features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | 217 |
| endpoint | 메인/서브 2 시트 컬럼메타 각각 fetch (design 03 §4.1). 미등록/실패 시 빈 배열 유지. | features/shipping/src/pages/shipment-change-request/useShipmentChangeRequestStore.ts | 321 |
| code | SSP0201 변경요청 취소(btnCancel) — **서버에 초안 무효화를 보낸다.** AS-IS: GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0201_ShipmentChangeRequest.cs `BtnCancel_Click`(L3021~3040): 1. `siSub.ActiveSheet.RowCount == 0` 이면 return (호출부 가드) 2. MSG00195 확인창, No 면 return (호출부 | features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestCancel.ts | 1 |
| code | SHIPMENT_DATE 입력 파생 (설계 §3.2:230 / AS-IS cs:5514-5558). NEW_LT_DAY 가 공백이면 파생이 없다(cs:5528 return) — 임의로 0 으로 보지 않는다. 동일 SO 전파는 **편집 행에서 구한 이 값 하나**를 전 대상 행에 그대로 쓴다(cs:5553-5558). | features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestDerive.ts | 88 |
| code | SSP0201 저장 실행체인 — **수정행과 신규행을 한 흐름으로** 처리한다. AS-IS `SaveButton()`(cs:764)은 저장 1회에 변경요청번호를 **한 번만** 채번하고(2단계, L783~794) 그 번호로 수정행 DRAFTING(GetERPInterface 2번 루프)과 신규행 체인(5·6단계)을 모두 처리한다. 종전 TO-BE 는 두 체인이 따로 있었고 `handleSave` 가 `if (inserted.l | features/shipping/src/pages/shipment-change-request/utils/shipmentChangeRequestSaveChain.ts | 1 |

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

