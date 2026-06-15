# DMF0074 METAL LINK PRICE — Deploy Package (SKELETON)

> Phase B-7 — DMF0020 SalesFuturePrice (PIVOT 표준) reference
> 작성: 2026-06-07
> 분석서: Doc/_analysis/domain_DM/screens/DMF0074_MetalLinkPrice/ (8 MD, Phase A 완료)

## SKELETON (5 파일 + Router)

- `features/demand/src/pages/metal-link-price/` (5 파일)
- `route-paths.ts`: DMF0074: 'metal-link-price'
- `Router.tsx`: DEMAND > DEMAND_PLAN > DMF0074
- URL: `/demand/demand-plan/metal-link-price`

## 특수성

- 3 PKG SP (GET PIVOT + GET Template + Excel Upload)
- 11 events / 6 검증 / 5 popup (3 공용 + 2 신규)
- 40 사업부 별도 ID 처리 (`DMF0074_40` — Excel Upload formId 분기)
- Version=CURRENT (`DM_BPS_METAL_LINK_PRICE`) vs HISTORY (`DM_BPS_METAL_LINK_PRICE_C`) 분기
- PIVOT 패턴 (월별 가격 long→wide) — `DMF0000_GET_COMMON_SPREAD_TITLE` 사업부별 동적 헤더
- G10 MonthRangePicker (drpPeriodMonth)

## ⚠️ Phase B-7 후속

- 2 신규 popup (Template + ExcelUpload)
- PIVOT 동적 헤더 (FROZEN_COL_COUNT=14)
- MonthRangePicker (G10) wiring
- 40 사업부 분기 logic (Excel Upload formId)
- Version popup (DMF0073 — DMF0020 SalesPriceVersionModal 재사용)
- 메타 SQL 7-BLOCK
