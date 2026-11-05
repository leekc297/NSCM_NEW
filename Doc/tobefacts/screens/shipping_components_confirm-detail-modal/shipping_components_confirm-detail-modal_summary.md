# shipping_components_confirm-detail-modal — To-Be Fact Pack 요약

- page_key: `shipping/components/confirm-detail-modal` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 1 · 엔드포인트 호출 1 (미해결 1, 주석 속 0) · 이벤트 0 · 컴포넌트 사용 14 · 하드코딩 컬럼 23 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 23건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | page | 181 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{menuId}/{sheetName}/SEARCH/call-proc | http | 1 | N | ConfirmDetailModal.tsx:120 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
(없음)

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Box | 7 |
| HeaderField | 5 |
| CustomDialog | 1 |
| DataGrid | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| CONFIRM_DETAIL_COLUMNS | CONFIRM_ID | Confirm/Plan ID | 110 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 58 |
| CONFIRM_DETAIL_COLUMNS | ERP_SO_NO | SO No | 110 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 59 |
| CONFIRM_DETAIL_COLUMNS | PROJECT_NAME | Project Name | 130 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 60 |
| CONFIRM_DETAIL_COLUMNS | FCST_TYPE | FCST Type | 90 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 61 |
| CONFIRM_DETAIL_COLUMNS | ITEM_ID | Model | 110 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 62 |
| CONFIRM_DETAIL_COLUMNS | FROM_SITE | From Site | 80 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 63 |
| CONFIRM_DETAIL_COLUMNS | TO_SITE | To Site | 100 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 64 |
| CONFIRM_DETAIL_COLUMNS | INCOTERMS | Incoterms | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 65 |
| CONFIRM_DETAIL_COLUMNS | LT_DAY | L/T(Day) | 60 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 67 |
| CONFIRM_DETAIL_COLUMNS | ETD | ETD | 80 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 68 |
| CONFIRM_DETAIL_COLUMNS | ETA | ETA | 80 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 69 |
| CONFIRM_DETAIL_COLUMNS | TRANSPORT_MODE | Trans Mode | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 70 |
| CONFIRM_DETAIL_COLUMNS | SHIPMENT_DATE | Shipment Date | 90 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 71 |
| CONFIRM_DETAIL_COLUMNS | SHIPMENT_CONFIRM_QTY | Qty | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 72 |
| CONFIRM_DETAIL_COLUMNS | NEW_LT_DAY | L/T(Day) | 60 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 74 |
| CONFIRM_DETAIL_COLUMNS | NEW_ETD | ETD | 80 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 75 |
| CONFIRM_DETAIL_COLUMNS | NEW_ETA | ETA | 80 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 76 |
| CONFIRM_DETAIL_COLUMNS | NEW_TRANSPORT_MODE | Trans Mode | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 77 |
| CONFIRM_DETAIL_COLUMNS | NEW_SHIPMENT_DATE | Shipment Date | 90 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 78 |
| CONFIRM_DETAIL_COLUMNS | NEW_SHIPMENT_CONFIRM_QTY | Qty | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 79 |
| CONFIRM_DETAIL_COLUMNS | DIFF_QTY | Diff Qty | 70 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 81 |
| CONFIRM_DETAIL_COLUMNS | CHANGE_REASON_CODE | Change Reason | 110 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 82 |
| CONFIRM_DETAIL_COLUMNS | CHANGE_REASON_DETAIL | Reason Detail | 130 |  |  |  | meta-shape | features/shipping/src/components/confirm-detail-modal/ConfirmDetailModal.tsx | 83 |

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: SSP0060(2), SSP0021(1), SCM0002(1)
- SP/PKG: PKG_SSP0060(1), P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING(1), P_CHANGE_REQUEST_NO(1), P_USER_ID(1), P_LANGUAGE(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

