# master_components_capaNewModelPopup — To-Be Fact Pack 요약

- page_key: `master/components/capaNewModelPopup` · feature: master · As-is Fact Pack 없음(화면ID 미대응)
- 파일 5 · 엔드포인트 호출 14 (미해결 1, 주석 속 0) · 이벤트 20 · 컴포넌트 사용 35 · 하드코딩 컬럼 25 · 메시지 18
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 25건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | constants | 201 |
| features/master/src/components/capaNewModelPopup/capaNewModelPopup.calendar.ts | other | 40 |
| features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts | other | 172 |
| features/master/src/components/capaNewModelPopup/CapaNewModelPopup.module.scss | style | 23 |
| features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | page | 775 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| (useTabComboQueries) | hook | 9 | Y | CapaNewModelPopup.tsx:109 CapaNewModelPopup.tsx:111 CapaNewModelPopup.tsx:115 CapaNewModelPopup.tsx:119 CapaNewModelPopup.tsx:123 CapaNewModelPopup.tsx:129 |
| /SYS0011/myAuthorityList/SEARCH/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:161 |
| /{FP_INSTANCE_ENDPOINT.mnuId}/fpInstance/SEARCH/call-proc | http | 1 | N | CapaNewModelPopup.tsx:182 |
| /SCP0049/newModel/SEARCH/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:256 |
| /SCP0049/newModel/SAVE/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:483 |
| /SCP0049/mailSend/SAVE/call-proc | http | 1 | Y | CapaNewModelPopup.tsx:558 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| grid | beginningEdit | beginningEditHandler | addHandler | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 331 |
| grid | pastingCell | beginningEditHandler | addHandler | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 332 |
| grid | formatItem | formatHandler | addHandler | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 347 |
| SearchArea | onSearch | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 590 |
| CustomDropdown | onChange | <arrow> setDivisionId,String,setGroupId,setPlantId,setFactoryId,setLineId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 601 |
| CustomDropdown | onChange | <arrow> setGroupId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 623 |
| CustomDropdown | onChange | <arrow> setPlantId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 638 |
| CustomDropdown | onChange | <arrow> setFactoryId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 653 |
| CustomDropdown | onChange | <arrow> setLineId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 668 |
| CustomDropdown | onChange | <arrow> setOperationId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 683 |
| InputField | onChange | <arrow> setModelId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 696 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 697 |
| InputField | onChange | <arrow> setItemId | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 710 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 711 |
| InputField | onChange | <arrow> setNickName | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 724 |
| InputField | onKeyDown | <arrow> fetchList | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 725 |
| DataGrid | cellEditEnded | handleCellEdit | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 743 |
| Button | onClick | <arrow> handleRequest | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 753 |
| Button | onClick | <arrow> handleSave | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 760 |
| Button | onClick | onClose | jsx | features/master/src/components/capaNewModelPopup/CapaNewModelPopup.tsx | 767 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Grid | 9 |
| FormItem | 9 |
| CustomDropdown | 6 |
| InputField | 3 |
| Button | 3 |
| CustomDialog | 1 |
| SearchArea | 1 |
| ProgressIndicator | 1 |
| ResultArea | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildCapaNewModelColumns | CHK | Save | 50 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 127 |
| buildCapaNewModelColumns | DIVISION_ID | Division | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 136 |
| buildCapaNewModelColumns | COMPANY_ID | Company | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 137 |
| buildCapaNewModelColumns | SITE_ID | Site | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 138 |
| buildCapaNewModelColumns | PLANT_ID | Plant | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 139 |
| buildCapaNewModelColumns | FACTORY_ID | Building | 70 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 140 |
| buildCapaNewModelColumns | LINE_ID | Line | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 141 |
| buildCapaNewModelColumns | LINE_NAME | Line Name | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 142 |
| buildCapaNewModelColumns | OPERATION_ID | Operation | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 143 |
| buildCapaNewModelColumns | ITEM_ID | Material | 100 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 144 |
| buildCapaNewModelColumns | NICK_NAME | Nick Name | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 145 |
| buildCapaNewModelColumns | LANE_QTY | Lane | 60 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 146 |
| buildCapaNewModelColumns | ELECTRODE_TYPE | Line Type | 90 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 157 |
| buildCapaNewModelColumns | USER_ID_1 | USER_ID_1 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 158 |
| buildCapaNewModelColumns | USER_ID_2 | USER_ID_2 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 159 |
| buildCapaNewModelColumns | USER_ID_3 | USER_ID_3 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 160 |
| buildCapaNewModelColumns | USER_ID_4 | USER_ID_4 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 161 |
| buildCapaNewModelColumns | USER_ID_5 | USER_ID_5 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 162 |
| buildCapaNewModelColumns | USER_ID_6 | USER_ID_6 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 163 |
| buildCapaNewModelColumns | USER_ID_7 | USER_ID_7 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 164 |
| buildCapaNewModelColumns | USER_ID_8 | USER_ID_8 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 165 |
| buildCapaNewModelColumns | USER_ID_9 | USER_ID_9 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 166 |
| buildCapaNewModelColumns | USER_ID_10 | USER_ID_10 | 80 | true |  |  | meta-map | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 167 |
| REQUEST_CHK_COLUMN | REQUEST_CHK | Mail Req | 60 | true |  | DataType.Boolean | object | features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts | 174 |
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
| LBL00669 | 1 |
| LBL00021 | 1 |
| LBL00767 | 1 |

## 8. 주석 속 As-is 참조
- 화면ID: SCP0049(9), SCP0006(4), SYS0011(2)
- SP/PKG: PKG_SCP0049(3), PR_UI_FP01886_AUTHORITY_REQUEST(3), PKG_SYS0011(2), P_SYS0011_GET_MY_AUTH_DATA(2), P_USER_ID(2), P_GET_SHEET_CALENDAR_POPUP(1), SCP0049_GET_SHEET_CALENDAR_POPUP(1), P_GET_NEW_MODEL(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

