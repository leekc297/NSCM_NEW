# shipping_components_order-detail-modal — To-Be Fact Pack 요약

- page_key: `shipping/components/order-detail-modal` · feature: shipping · As-is Fact Pack 없음(화면ID 미대응)
- 파일 1 · 엔드포인트 호출 1 (미해결 1, 주석 속 0) · 이벤트 1 · 컴포넌트 사용 6 · 하드코딩 컬럼 7 · 메시지 0
- Grid 컬럼 출처: 메타(/column·titleSet) 미사용 · spreadTitle(동적 헤더 SP) 미사용 · 하드코딩 컬럼 정의 7건

## 1. 파일
| file | role | lines |
|---|---|---|
| features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | page | 155 |

## 2. 엔드포인트 (URL 단위, 살아있는 코드만)
| url | kind | calls | resolved | where |
|---|---|---|---|---|
| /{menuId}/{shtNm}/{btnId}/call-proc | http | 1 | N | OrderDetailModal.tsx:96 |

## 3. procedures.d.ts 등재 시트
(없음)

## 4. 이벤트 배선
| element | event | handler | via | file | line |
|---|---|---|---|---|---|
| Button | onClick | onClose | jsx | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 147 |

## 5. 컴포넌트 사용 집계
| component | count |
|---|---|
| Box | 3 |
| CustomDialog | 1 |
| DataGrid | 1 |
| Button | 1 |

## 6. 하드코딩 Grid 컬럼
| context | binding | header | width | visible | isReadOnly | dataType | via | file | line |
|---|---|---|---|---|---|---|---|---|---|
| buildOrderDetailColumns | SO_NO | `${so} NO.` | 120 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 60 |
| buildOrderDetailColumns | SO_ITEM_NO | `${so} Item No.` | 100 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 61 |
| buildOrderDetailColumns | SO_ITEM_QTY | `${so} Item Qty` | 110 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 62 |
| buildOrderDetailColumns | DO_NO | DO NO. | 120 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 63 |
| buildOrderDetailColumns | DO_ITEM_NO | DO Item No. | 100 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 64 |
| buildOrderDetailColumns | DO_ITEM_QTY | DO Item Qty. | 110 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 65 |
| buildOrderDetailColumns | CONFIRM_ID | Confirm ID | 130 | true |  |  | meta-shape | features/shipping/src/components/order-detail-modal/OrderDetailModal.tsx | 66 |

## 7. 메시지 코드
(없음)

## 8. 주석 속 As-is 참조
- 화면ID: SSP0200(2), SSP0015(1), SSP0060(1), SSP0300(1)
- SP/PKG: P_SSP0300_GET_ORDER_DETAIL(1), P_DIVISION_ID(1), P_ERP_SO_NO(1), P_CONFIRM_ID(1), P_ITEM_ID(1), PKG_SSP0300(1), PKG_SSP0060(1), PKG_SSP0021(1)
## 9. 주석 처리된 코드 (현행 기능 아님)
(없음)

## 10. __asis-mapping__.md 상태
- (매핑 파일 없음)
(없음)

