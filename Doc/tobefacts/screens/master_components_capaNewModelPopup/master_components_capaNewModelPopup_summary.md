# master_components_capaNewModelPopup — To-Be Fact Pack 요약

- page_key: `master/components/capaNewModelPopup` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 5 · 엔드포인트 호출 8 (미해결 0, 주석 속 0) · 이벤트 16 · 컴포넌트 사용 34 · 하드코딩 컬럼 24 · 메시지 17
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 24건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | constants | 194 |
| features/master/src/components/capaNewModelPopup/capaNewModelPopup.calendar.ts | other | 40 |
| features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts | other | 172 |
| features/master/src/components/capaNewModelPopup/CapaNewModelPopup.module.scss | style | 41 |
| features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | page | 491 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 6 | Y | CapaNewModelPopup.tsx:91 CapaNewModelPopup.tsx:93 CapaNewModelPopup.tsx:97 CapaNewModelPopup.tsx:101 CapaNewModelPopup.tsx:105 CapaNewModelPopup.tsx:111 |
| /SCP0049/newModel/SEARCH/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:167 |
| /SCP0049/mailSend/SAVE/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:254 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | beginningEdit | lockHandler | addHandler | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 204 |
| grid | pastingCell | lockHandler | addHandler | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 205 |
| SearchArea | onSearch | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 286 |
| CustomDropdown | onChange | <arrow> setDivisionId,String,setGroupId,setPlantId,setFactoryId,setLineId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 297 |
| CustomDropdown | onChange | <arrow> setGroupId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 319 |
| CustomDropdown | onChange | <arrow> setPlantId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 334 |
| CustomDropdown | onChange | <arrow> setFactoryId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 349 |
| CustomDropdown | onChange | <arrow> setLineId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 364 |
| CustomDropdown | onChange | <arrow> setOperationId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 379 |
| InputField | onChange | <arrow> setModelId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 395 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 396 |
| Button | onClick | <arrow> setModelPopupOpen | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 402 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 416 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 417 |
| Button | onClick | <arrow> handleRequest | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 463 |
| Button | onClick | onClose | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 470 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 8 |
| FormItem | 8 |
| CustomDropdown | 6 |
| Button | 3 |
| InputField | 2 |
| CustomDialog | 1 |
| SearchArea | 1 |
| FunctionSearchIcon | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |
| MaterialByDivisionModal | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildCapaNewModelColumns | DIVISION_ID | Division | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 129 |
| buildCapaNewModelColumns | COMPANY_ID | Company | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 130 |
| buildCapaNewModelColumns | SITE_ID | Site | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 131 |
| buildCapaNewModelColumns | PLANT_ID | Plant | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 132 |
| buildCapaNewModelColumns | FACTORY_ID | Building | 70 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 133 |
| buildCapaNewModelColumns | LINE_ID | Line | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 134 |
| buildCapaNewModelColumns | LINE_NAME | Line Name | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 135 |
| buildCapaNewModelColumns | OPERATION_ID | Operation | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 136 |
| buildCapaNewModelColumns | ITEM_ID | Material | 100 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 137 |
| buildCapaNewModelColumns | NICK_NAME | Nick Name | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 138 |
| buildCapaNewModelColumns | LANE_QTY | Lane | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 139 |
| buildCapaNewModelColumns | ELECTRODE_TYPE | Line Type | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 150 |
| buildCapaNewModelColumns | USER_ID_1 | USER_ID_1 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 151 |
| buildCapaNewModelColumns | USER_ID_2 | USER_ID_2 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 152 |
| buildCapaNewModelColumns | USER_ID_3 | USER_ID_3 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 153 |
| buildCapaNewModelColumns | USER_ID_4 | USER_ID_4 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 154 |
| buildCapaNewModelColumns | USER_ID_5 | USER_ID_5 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 155 |
| buildCapaNewModelColumns | USER_ID_6 | USER_ID_6 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 156 |
| buildCapaNewModelColumns | USER_ID_7 | USER_ID_7 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 157 |
| buildCapaNewModelColumns | USER_ID_8 | USER_ID_8 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 158 |
| buildCapaNewModelColumns | USER_ID_9 | USER_ID_9 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 159 |
| buildCapaNewModelColumns | USER_ID_10 | USER_ID_10 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 160 |
| REQUEST_CHK_COLUMN | REQUEST_CHK | Mail Req | 60 | true |  | DataType.Boolean | object | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 167 |
| buildCapaMonthColumns | `${DYN_MONTH_PREFIX}${ym}` | `${ym.slice(0, 4)}-${ym.slice(4, 6)}` | 60 | true |  |  | object | features/master/src/components/capaNewModelPopup/capaNewModelPopup.calendar.ts | 30 |

## 7. 메시지 코드
| code | count |
|---|---|
| MSG00337 | 1 |
| MSG00203 | 1 |
| MSG00004 | 1 |
| MSG00284 | 1 |
| MSG00133 | 1 |
| MSG00339 | 1 |
| MSG00021 | 1 |
| MSG00327 | 1 |
| LBL00112 | 1 |
| LBL00001 | 1 |
| LBL00313 | 1 |
| LBL00030 | 1 |
| LBL00008 | 1 |
| LBL00010 | 1 |
| LBL00009 | 1 |
| LBL00618 | 1 |
| LBL00021 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0049(8), SCP0006(3), SYS0011(1), SCP0201(1)
- SP/PKG: PKG_SCP0049(2), PR_UI_FP01886_AUTHORITY_REQUEST(2), P_GET_SHEET_CALENDAR_POPUP(1), PKG_SYS0011(1), P_SYS0011_GET_MY_AUTH_DATA(1), P_USER_ID(1), SCP0049_GET_SHEET_CALENDAR_POPUP(1), P_GET_NEW_MODEL(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

