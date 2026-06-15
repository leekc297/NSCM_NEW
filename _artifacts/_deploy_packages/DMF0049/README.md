# DMF0049 ETC SALES REPORTS — Deploy Package (SKELETON)

> Phase B-6 — DMF0044 popup 공유
> 작성: 2026-06-07

## SKELETON (5 파일 + Router)

- `features/report/src/pages/etc-sales-reports/` (5 파일)
- `route-paths.ts`: DMF0049: 'etc-sales-reports'
- `Router.tsx`: REPORT > SALES_REPORT > DMF0049
- URL: `/report/sales-report/etc-sales-reports`

## 특수성

- 42 cols (T_DEPARTMENT_ID / T_DEPT_ID / ETC_DESCR / Cell_Name — ETC 분류 특수)
- SAVE SP 36 IN params (가장 많음)
- 신규 popup 0 (DMF0044 의 4 popup 재사용)

## ⚠️ Phase B-6 후속

- DMF0044 4 popup 재사용 wiring (SalesReportExchange / Textbox / Version / UnitedVersion)
- SAVE SP 36 param 정밀 매핑
- 42 cols 정밀 추출
- 메타 SQL 7-BLOCK
