# SSP0014 — To-Be Fact Pack 요약

- page_key: `shipping/shipment-model-pic` · feature: shipping · As-is Fact Pack 있음
- 파일 13 · 엔드포인트 호출 10 (미해결 0, 주석 속 0) · 이벤트 18 · 컴포넌트 사용 28 · 하드코딩 컬럼 1 · 메시지 15
- Grid 컬럼 출처: 메타(/column·titleSet) 사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 1건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | component | 259 |
| features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx | component | 217 |
| features/shipping/src/pages/shipment-model-pic/hooks/useShipmentModelPicValidation.ts | hook | 68 |
| features/shipping/src/pages/shipment-model-pic/index.ts | index | 2 |
| features/shipping/src/pages/shipment-model-pic/shipment-model-pic.constants.ts | constants | 172 |
| features/shipping/src/pages/shipment-model-pic/shipment-model-pic.types.ts | types | 64 |
| features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.module.scss | style | 12 |
| features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | page | 566 |
| features/shipping/src/pages/shipment-model-pic/useShipmentModelPicStore.ts | store | 198 |
| features/shipping/src/pages/shipment-model-pic/utils/shipmentModelPicColumns.ts | util | 50 |
| features/shipping/src/pages/shipment-model-pic/utils/shipmentModelPicEditLock.ts | util | 16 |
| features/shipping/src/pages/shipment-model-pic/utils/shipmentModelPicUserLookup.ts | util | 45 |
| features/shipping/src/pages/shipment-model-pic/__asis-mapping__.md | mapping | 175 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 1 | Y | ShipmentModelPicForm.tsx:76 |
| (useTabLookupQueries) | hook | 2 | Y | ShipmentModelPicForm.tsx:80 ShipmentModelPicGrid.tsx:76 |
| /SSP0014/main/USER_CHECK/call-proc | http | 1 | Y | useShipmentModelPicValidation.ts:47 |
| (useTabComboQueryResults) | hook | 1 | Y | ShipmentModelPic.tsx:87 |
| SSP0014/main//call-proc | hook | 1 | Y | ShipmentModelPic.tsx:163 |
| /SSP0014/main/SAVE/call-proc | http | 1 | Y | ShipmentModelPic.tsx:343 |
| /admin/menu/SSP0014/column | http | 1 | Y | useShipmentModelPicStore.ts:139 |
| /admin/menu/SSP0014/search-conditions | http | 1 | Y | useShipmentModelPicStore.ts:165 |
| COM0010/ssoUser/SEARCH/call-proc | callProc | 1 | Y | shipmentModelPicUserLookup.ts:31 |

## 3. procedures.d.ts 등재 시트
| sheet | request_keys | response_cursors | sp_hints |
|---|---|---|---|
| main | divisionId operationGroup fromSite validYn itemId userId language | o_rc1 | PKG_SSP0015 PKG_COM0000 P_SCP0009_GET_SHEET_CALENDAR_3SPAN PKG_SSP0014 P_SSP0014_GET_MODEL_PIC |

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| SearchArea | onSearch | onSearch | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 102 |
| CustomDropdown | onChange | <arrow> String,confirmIfDirtyKey(tabDirtyKey(tabId),'search').then,confirmIfDirtyKey,tabDirtyKey,set,clearFilters | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 121 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 153 |
| CustomDropdown | onChange | <arrow> set,String(picked??'').split(',').filter,String(picked??'').split,String | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 175 |
| CustomDropdown | onChange | <arrow> set,String | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 199 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 230 |
| InputField | onKeyDown | <arrow> handleEnterSearch | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 231 |
| FunctionSearchIcon | onClick | onItemSearch | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 225 |
| InputField | onChange | <arrow> set | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 248 |
| InputField | onKeyDown | <arrow> handleEnterSearch | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicForm.tsx | 249 |
| g | formatItem | formatItemHandler | addHandler | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx | 107 |
| g | cellEditEnded | deriveName | addHandler | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx | 161 |
| g | pastedCell | deriveName | addHandler | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx | 162 |
| DataGrid | gotFocus | onFocus | jsx | features/shipping/src/pages/shipment-model-pic/components/ShipmentModelPicGrid.tsx | 213 |
| ShipmentModelPicForm | onSearch | hasButton('SEARCH') ? handleSearch : undefined | jsx | features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | 501 |
| ShipmentModelPicForm | onItemSearch | <arrow> setOpenItem | jsx | features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | 502 |
| ShipmentModelPicGrid | onUserCellDblClick | handleUserCellDblClick | jsx | features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | 533 |
| ShipmentModelPicGrid | onFocus | <arrow>  | jsx | features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | 534 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 6 |
| FormItem | 6 |
| CustomDropdown | 4 |
| InputField | 2 |
| SearchArea | 1 |
| Button | 1 |
| FunctionSearchIcon | 1 |
| DataGrid | 1 |
| MainTitle | 1 |
| ShipmentModelPicForm | 1 |
| SubTitle | 1 |
| ShipmentModelPicGrid | 1 |
| SsoUserModal | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| col | c.key | c.header | c.width ?? 100 | true |  |  | meta-map | features/shipping/src/pages/shipment-model-pic/utils/shipmentModelPicColumns.ts | 22 |

## 7. 메시지 코드
| code | count |
|---|---|
| LBL00001 | 1 |
| LBL00027 | 1 |
| LBL00022 | 1 |
| LBL00639 | 1 |
| LBL00669 | 1 |
| LBL00618 | 1 |
| LBL00339 | 1 |
| LBL00112 | 1 |
| MSG00672 | 1 |
| MSG00003 | 1 |
| MSG01261 | 1 |
| MSG00097 | 1 |
| MSG00004 | 1 |
| MSG00667 | 1 |
| MSG01052 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SSP0014(9), COM0010(3), SCM0002(2), DMF0020(1), SCP0005(1)
- SP/PKG: PKG_SSP0014(7), P_SSP0014_SAVE_MODEL_PIC(3), P_SSP0014_GET_USER_ID_CHECK(2), P_USER_ID(2), P_SSP0014_GET_MODEL_PIC(2), P_ITEM_ID(2), P_CREATE_ID(1), P_DIVISION_ID(1), P_OPERATION_GROUP(1), P_FROM_SITE(1), P_VALID_YN(1), P_LANGUAGE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
| kind | snippet | file | line |
|---|---|---|---|
| code | 그대로 살아 버튼이 실제 동작한다 — no-op 로 만들려면 반드시 () => undefined 를 명시한다 | features/shipping/src/pages/shipment-model-pic/ShipmentModelPic.tsx | 476 |

## 10. __asis-mapping__.md 상태
- 구현: 39
- 해당없음: 8
- 제외: 3
| design_id | summary | reason | status |
|---|---|---|---|
| D00-1-011 | §1 emptySpaceItem1 / EmptySpaceItem(스페이서) | WinForms 좌표 레이아웃 스페이서. MUI Grid size 자동 정렬로 불필요(패딩 등가). | 해당없음 |
| D00-1-012 | §1 emptySpaceItem2 / EmptySpaceItem(스페이서) | 동 D00-1-011 — 좌표 스페이서, React 레이아웃에서 불요. | 해당없음 |
| D00-1-022 | §1 usrButton1 / UsrButton(ButtonAccessType=None, 미배치) | AS-IS 렌더 안 함(미배치 헬퍼 버튼). TO-BE 대상 아님(00 §1 근거). | 제외 |
| D00-1-023 | §1 components / Container(디자이너 컨테이너) | WinForms 디자이너 IContainer — React 무관(비 UI 요소). | 해당없음 |
| D00-1-024 | §1 imageList1 / ImageList("edit.png" 팝업셀 아이콘) | AS-IS cellTypeImage(edit.png) 이미지버튼 → TO-BE 는 셀 더블클릭 오픈으로 대체(이미지 아이콘 미사용, nscm-patterns §5-16). | 해당없음 |
| D00-2-004 | §2 spdMain / TopChange(스크롤 재병합) | 스크롤 재병합은 공용 DataGrid 내부 처리. 신규행 없어 재병합 노이즈 없음. 시각 파리티는 사용자 육안 축. | 해당없음 |
| D00-3-001 | §3 SmartColMerge / 223 (InitSpread 초기병합) | 초기 병합은 공용 DataGrid 관장(화면 미배선). 시각 파리티 사용자 육안 축. | 해당없음 |
| D00-3-002 | §3 SwitchLock / 272 (EditButton 편집토글) | AS-IS EditButton(SwitchLock) 수정모드 토글 어포던스는 전 화면 공통 미이관 결정(convert-core §2.4, `Doc/Doc_lgc_bak/rules/11_asis_parity/asis_to_tobe.md` §11). 단 그 신호에 묶여 있던 잠금 범위는 별개 질문이라 메타로, 시트 잠금 가드(cs:628 `IsLock`)는 `canEdit=hasButton('EDIT')` 권한축으로 각각 이관했다 | 제외 |
| D00-3-009 | §3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰) | 조회 직후 전체 lock(뷰 모드) 미이관(Edit 토글 제거). 키/이름/감사 13열은 여전히 컬럼메타 lock. | 제외 |
| D00-3-013 | §3 SmartColMerge / 364 (조회 후 병합) | 조회 후 병합은 공용 DataGrid 관장(화면 미배선). 시각 파리티 사용자 육안 축. | 해당없음 |
| D00-3-014 | §3 SmartColMerge / 622 (TopChange 재병합) | 스크롤 재병합 공용 DataGrid 관장. 신규행 없어 노이즈 없음. 시각 사용자 육안 축. | 해당없음 |

