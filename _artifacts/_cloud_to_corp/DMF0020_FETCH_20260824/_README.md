# DMF0020 (Sales Future Price) — 클라우드 → 사내 **역이관** 대상 목록 (2026-08-24)

> 사내 백업 완료: `_artifacts/_backup/DMF0020_PRE_CLOUD_UPDATE_20260824/` (22본 + 배선 3표).
> 방식 = hook #122 `cloud-ui-db-object-fetch` — **`ALL_SOURCE` 원문 그대로**. 재작성·정리 금지.
> 목록 도출 = 추측 아님. 사내 `SCM_ADM_MNU_BTN_MPG_M` → `SCM_ADM_API_M` 배선 실측 + `ALL_DEPENDENCIES` 폐포.

## 1. ⭐ 추출 대상 — A군 (DMF0020 소유, 반드시 가져온다)

| # | 객체 | 유형 | 사내 상태 | 사내 줄수 | 배선 |
|---:|---|---|---|---:|---|
| 1 | `PKG_DMF0020` | PACKAGE (SPEC) | VALID | 195 | 내부 프로시저 16개 보유 |
| 2 | `PKG_DMF0020` | PACKAGE BODY | **INVALID** | 4,619 | exchange·salesPriceRange·salesPriceTemplate 조회/저장 |
| 3 | `DMF0020_GET_SCM_MST_FUTURE_PRICE` | PROCEDURE | **INVALID** | 1,195 | ⭐ **main SEARCH + priceBatch SEARCH** |
| 4 | `DMF0020_GET_SPREAD_TITLE_DATE` | PROCEDURE | VALID | 80 | main SPREAD_TITLE_DATE |
| 5 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` | PROCEDURE | VALID | 1,131 | **main SAVE** |
| 6 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | PROCEDURE | VALID | 796 | **priceBatch SAVE** |
| 7 | `DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` | PROCEDURE | **INVALID** | 319 | 배선은 PKG 경유지만 **의존 폐포에 실재**(PKG 가 이 단독본을 호출) |

`PKG_DMF0020` 내부 프로시저 16개 = `P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` · `P_DMF0020_EXCEL_UPLOAD` ·
`P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE` · `P_DMF0020_GET_FUTUREPRICE_INFO` ·
`P_DMF0020_GET_MEASURE_COUNTINFO` · `P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE` ·
`P_DMF0020_GET_OWNER_DATA` · `P_DMF0020_GET_SALES_PRICE_TEMPLATE` ·
`P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` · `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA` ·
`P_DMF0020_GET_SPREAD_TITLE` · `P_DMF0020_GET_SPREAD_TITLE_DATE` ·
`P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE` · `P_DMF0020_GET_WEEKDATA` ·
`P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` · `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION`
(BODY 1본을 가져오면 16개가 함께 온다 — 개별 추출 불필요)

## 2. ⛔ 추출 제외 — B군 (타 화면 소유 공용)

| 객체 | 소유 | 배선 |
|---|---|---|
| `DMF0002_GET_TITLESET_POPUP` | DMF0002 | DMF0020 titleSet SEARCH |
| `DMF0073_GET_VERSION_SALESPRICE` | DMF0073 | DMF0020 version SEARCH |

DMF0020 교체와 함께 덮으면 **타 화면이 깨진다**. 존재·상태만 확인하고 손대지 않는다.

## 3. ⛔ 추출 제외 — C군 (전사 공용 함수/패키지, 존재 확인만)

`FN_GET_DEPT_LIST` · `FN_GET_DIVISION_YN` · `FN_GET_MULTI_OWNER_NAME` · `FN_NEXT_DAY` · `FN_STRING_SPLIT` ·
`PKG_SCM_USER_MNU` · `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE` · `PR_SCM_SYS_LOG_BATCH`

## 4. 판단 유보 — D군 (사내엔 있으나 **배선 없음** = PKG 이전의 단독 잔재 13본)

`DMF0020_EXCEL_UPLOAD`(INVALID) · `DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE` · `DMF0020_GET_FUTUREPRICE_INFO` ·
`DMF0020_GET_MEASURE_COUNTINFO` · `DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE` · `DMF0020_GET_OWNER_DATA`(INVALID) ·
`DMF0020_GET_SALES_PRICE_TEMPLATE` · `DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` ·
`DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA` · `DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` ·
`DMF0020_GET_SPREAD_TITLE` · `DMF0020_GET_SPREAD_TITLE_SAVE_PRICE` · `DMF0020_GET_WEEKDATA` ·
`DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL`(INVALID) · `P_DMF0020_GET_OWNER_DATA`(INVALID, ORA-00907 실오류)

**같은 이름이 PKG 안에도 존재**한다(단독 ↔ `P_` 접두 PKG 버전). 클라우드 배선(`01` 의 I5)이
단독을 가리키면 A군에 편입해야 하고, PKG 만 가리키면 이 13본은 폐기 잔재다. **클라우드 배선을 보고 확정**한다.

## 5. 실행 순서 (클라우드)

```
1) 01_CLOUD_INVENTORY.sql        → 객체 실존·상태·줄수·INVALID 원인·**배선**
2) 03_CLOUD_WIRING_SNAPSHOT.sql  → API_M / BTN_MPG / PROC_M / 실인자수
3) 02_CLOUD_EXTRACT_SOURCE.sql   → ALL_SOURCE 원문 스풀 (A군 7본)
```

⚠ **순서를 지킬 것.** ①②로 **클라우드 배선이 사내와 같은지** 먼저 확정해야 한다.
배선이 다르면(예: 클라우드는 main SEARCH 도 PKG 경유) 가져올 소스 목록 자체가 달라진다.

## 6. 받은 뒤 사내에서 할 일

- 백업본과 **줄 단위 diff** → 무엇이 달라지는지 리포트
- `ALL_ARGUMENTS` 인자수 대조 (다르면 `PLS-00306` — 배선/BE 계약까지 손봐야 함)
- 적용 → 컴파일 → `ALL_OBJECTS` 전 VALID 확인 → 화면 조회/저장 스모크
- 원복이 필요하면 `_artifacts/_backup/DMF0020_PRE_CLOUD_UPDATE_20260824/` 를 그대로 실행
