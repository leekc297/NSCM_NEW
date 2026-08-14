# DMF0044/0049 — GT/GTT SP DS2 표준 적용 SQL (2026-08-12, 직접 적용용)

> 목적: GT/GTT 사용 프로시저 도입부에 `ALTER SESSION SET optimizer_dynamic_sampling = 2` 삽입
> (클라우드 GTT 무통계 10배 지연 방어 — 2026-08-06 표준). 사내 기적용·VALID.

| # | 파일 | 내용 |
|---|---|---|
| 1 | `01_PKG_DMF0044_BODY_DS2.sql` | BODY 전체본(CREATE OR REPLACE) — GT 사용 9 프로시저 삽입 (BP_REPORT_DEPT/EXCHANGE_RATE/PRODUCT_CREATE·GET_SALES_REPORTS_DATA·SAVE_BIZ_PLAN_VERSION_COPY·SAVE_DM_EXCHANGE_RATE_REPORT·SAVE_SALES_PLAN_REPORT_C(+_CF)·SALES_REPORT_DEPT_CREATE) + 말미 VERIFY 3항목 |
| 2 | `02_PKG_DMF0049_BODY_DS2.sql` | BODY 전체본 — GT 사용 2 프로시저 삽입 (GET_SALES_ETC_REPORTS_DATA·SAVE_SALES_ETC_REPORT_C) + VERIFY |

- 실행: sqlplus 에서 파일 그대로 실행 (`SET DEFINE OFF` 권장 — 본문에 `&` 없음 확인됨).
- QA·DEV 2개 DB 각각 적용.
- 마커: `--[E20260812-DS2]` (멱등 판단 — 이미 적용된 DB 에 재실행해도 CREATE OR REPLACE 라 무해).
