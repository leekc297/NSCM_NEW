# 권한그룹 판정 합집합(AUTHUNION) 적용 현황 — **조건식 형태 기준** (마커 아님)

> UNION=보유그룹 서브쿼리 동반 / SINGLE=`SEGMENT1 = 단일값` 만 / FE=P_USER_GROUP 자리 전달값

| 상태 | 객체 | UNION | SINGLE | 기타 | 화면 | FE 전달 | 근거 | SINGLE 라인 |
|---|---|---:|---:|---:|---|---|---|---|
| ⛔ 미적용 **최우선** | DMF0020_GET_OWNER_DATA | 0 | 1 | 0 | DMF0020 | USERID | master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314 | L90 |
| ⛔ 미적용 **최우선** | DMF0048_GET_DM_PLN_SALES_MONITORING | 0 | 1 | 0 | DMF0048 | GHOST | demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts:146 | L265 |
| ⛔ 미적용 **최우선** | PKG_DMF0020 | 0 | 1 | 0 | DMF0020 | USERID | master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314 | L3769 |
| ⛔ 미적용 **최우선** | PKG_DMF0048 | 0 | 1 | 0 | DMF0048 | GHOST | demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts:146 | L229 |
| ⛔ 미적용 | DMF0000_GET_MASTER_CHG_POPUP | 0 | 1 | 0 | DMF0000 | - |  | L24 |
| ⛔ 미적용 | DMF0004_GET_SALES_SITE_BUCKET_DATA | 0 | 1 | 0 | DMF0004 | - |  | L44 |
| ⛔ 미적용 | DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 0 | 1 | 0 | DMF0004 | - |  | L44 |
| ⛔ 미적용 | DMF0004_GET_SALES_SITE_DATA | 0 | 1 | 0 | DMF0004 | - |  | L47 |
| ⛔ 미적용 | DMF0004_GET_SALES_SITE_LOCATION_DATA | 0 | 1 | 0 | DMF0004 | - |  | L40 |
| ⛔ 미적용 | DMF0005_GET_OWNERINFO | 0 | 1 | 0 | DMF0005 | - |  | L33 |
| ⛔ 미적용 | DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | 0 | 1 | 0 | DMF0005 | - |  | L66 |
| ⛔ 미적용 | DMF0005_GET_SALES_SITE_MODEL_PURCHASE | 0 | 1 | 0 | DMF0005 | - |  | L314 |
| ⛔ 미적용 | DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 0 | 1 | 0 | DMF0006 | - |  | L33 |
| ⛔ 미적용 | DMF0007_GET_CUST_FCST_DATA | 0 | 1 | 0 | DMF0007 | - |  | L41 |
| ⛔ 미적용 | DMF0007_GET_CUST_PSI_DATA | 0 | 1 | 0 | DMF0007 | - |  | L47 |
| ⛔ 미적용 | DMF000_GET_OWNER_DATA | 0 | 1 | 0 | - | - |  | L65 |
| ⛔ 미적용 | DMF0014_GET_CUST_FCST_UPLOAD_DATA | 0 | 1 | 0 | DMF0014 | - |  | L74 |
| ⛔ 미적용 | DMF0051_1_GET_DM_PLN_BIZ_PLAN_WATERFALL | 0 | 1 | 0 | DMF0051 | - |  | L98 |
| ⛔ 미적용 | PKG_DMF0006 | 0 | 1 | 0 | DMF0006 | - |  | L77 |
| ⛔ 미적용 | PKG_DMF0014 | 0 | 1 | 0 | DMF0014 | - |  | L6237 |
| ⛔ 미적용 | PKG_SCM0002 | 0 | 1 | 0 | SCM0002 | - |  | L3065 |
| ⛔ 미적용 | P_COM0004_GET_OWNER_DATA | 0 | 1 | 0 | COM0004 | - |  | L17 |
| ⛔ 미적용 | P_COM0006_GET_OWNER_DATA | 0 | 1 | 0 | COM0006 | - |  | L17 |
| ⛔ 미적용 | P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION | 0 | 1 | 0 | DMF0005 | - |  | L22 |
| ⛔ 미적용 | P_DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | 0 | 1 | 0 | DMF0006 | - |  | L20 |
| ⛔ 미적용 | SCM0002_GET_TEAM_POPUP | 0 | 1 | 0 | SCM0002 | - |  | L74 |
| ⚠ 혼재 | PKG_COM0000 | 1 | 2 | 1 | COM0000 | - |  | L202, L218 |
| ✅ 적용 | DMF0020_GET_SCM_MST_FUTURE_PRICE | 1 | 0 | 0 | DMF0020 | USERID | master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314 | - |
| ✅ 적용 | DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | 1 | 0 | 0 | DMF0020 | USERID | master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314 | - |
| ✅ 적용 | PKG_DMF0003 | 1 | 0 | 0 | DMF0003 | GHOST | demand/src/pages/mkt-fcst/useMktFcstStore.ts:261 | - |
| ✅ 적용 | PKG_DMF0044 | 1 | 0 | 0 | DMF0044 | USERID | demand/src/pages/sales-reports/useSalesReportsStore.ts:133 | - |
| ✅ 적용 | PKG_DMF0049 | 1 | 0 | 0 | DMF0049 | USERID | demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts:127 | - |
| ✅ 적용 | PKG_DMF0082 | 7 | 0 | 3 | DMF0082 | GHOST | demand/src/pages/forecast-price/components/modals/SavePricePeriodModal.tsx:304 | - |
| ✅ 적용 | PKG_DMF0021 | 3 | 0 | 1 | DMF0021 | AUTHCMBO | demand/src/pages/sales-plan/useSalesPlanStore.ts:227 | - |
| ✅ 적용 | PKG_DMF0042 | 1 | 0 | 0 | DMF0042 | AUTHCMBO | demand/src/pages/business-plan/useBusinessPlanStore.ts:166 | - |
| · 판정없음 | P_DMF0020_GET_OWNER_DATA | 0 | 0 | 1 | DMF0020 | USERID | master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314 | - |
| · 판정없음 | DMF0008_GET_SALES_SITE_PROJECT_MODEL | 0 | 0 | 1 | DMF0008 | - |  | - |
| · 판정없음 | PKG_DMF0004 | 0 | 0 | 2 | DMF0004 | - |  | - |
| · 판정없음 | PKG_DMF0005 | 0 | 0 | 2 | DMF0005 | - |  | - |
| · 판정없음 | PKG_DMF0007 | 0 | 0 | 2 | DMF0007 | - |  | - |
| · 판정없음 | PKG_DMF0008 | 0 | 0 | 1 | DMF0008 | - |  | - |
| · 판정없음 | P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION_V2 | 0 | 0 | 1 | DMF0005 | - |  | - |
| · 판정없음 | P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE | 0 | 0 | 1 | DMF0005 | - |  | - |
| · 판정없음 | P_DMF0007_GET_CUST_FCST_DATA | 0 | 0 | 1 | DMF0007 | - |  | - |

## 종합: 미적용 26 / 적용 8 / 판정없음 9 / 혼재 1

## ⛔ 최우선 (단일그룹 × FE가 USER_ID 직전달 = **지금 발현**)
- **DMF0020_GET_OWNER_DATA** (DMF0020) — SINGLE 1곳 L90 · FE `master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314`
- **DMF0048_GET_DM_PLN_SALES_MONITORING** (DMF0048) — SINGLE 1곳 L265 · FE `demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts:146`
- **PKG_DMF0020** (DMF0020) — SINGLE 1곳 L3769 · FE `master/src/pages/sales-future-price/components/modals/PriceBatchInputModal.tsx:314`
- **PKG_DMF0048** (DMF0048) — SINGLE 1곳 L229 · FE `demand/src/pages/sales-monitoring/useSalesMonitoringStore.ts:146`
