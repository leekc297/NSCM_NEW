# DMF0044 SALES REPORTS — Deploy Package (SKELETON)

> Phase B-5 — Report domain + Figma 적용
> 작성: 2026-06-07
> Figma: ✅ Doc/_figma/screens/DMF0044.md + DMF0044.svg + DMF0044_Table.svg

## SKELETON 작업 내역 (5 파일 + Router)

- `features/report/src/pages/sales-reports/` (5 파일: constants/types/store/Main/index)
- `route-paths.ts`: DMF0044 + SALES_REPORT slug
- `Router.tsx`: REPORT > SALES_REPORT > DMF0044
- URL: `/report/sales-report/sales-reports`

## ⚠️ Phase B-5 후속 (High)

- 4 신규 popup (SalesReportExchange / SalesReport_Textbox / Sales_Version / United_Version)
- SAVE_C_CF SP (2,896줄) wiring — Currency Forward / Cumulative Forecast variant 저장
- 35 cols 정밀 + 다단 헤더
- Figma 1:1 재현 검증 (figma-mapping-check hook)
- 메타 SQL 7-BLOCK
- validation hook (analysis 간소 — 원본 .cs 200+ 라인 재read 의무)
