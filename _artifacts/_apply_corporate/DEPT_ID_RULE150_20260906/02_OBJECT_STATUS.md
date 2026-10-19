# 최초 작업 대상 18 객체 — 처리 현황 (2026-09-06, AJS)

| # | 유형 | 객체 | 비고 | 건수 변화 | 값 변화 지점 |
|--:|---|---|---|---|---|
| 1 | PACKAGE BODY | PKG_DMF0014 | **변경대상없음** — 6442/6499/6524 이미 `ITM.DEPT_ID`(2026-04-01 전환), AS-IS ①③ 은 주석 | — | — |
| 2 | PACKAGE BODY | PKG_DMF0020 | **9건 수정** (SALES_PRICE_TEMPLATE 2729·2805 / OWNER_DATA 3800 3쿼리 / FUTURE_PRICE 5285·5633 / POPUP 8005·8083·8473) | GET_SALES_PRICE_TEMPLATE 40/81/82 = 0/121/107 동일 · GET_OWNER_DATA 0/0/0 동일(V_TMPDEPT 후보 81: 108→109) · GET_SCM_MST_FUTURE_PRICE 8,652/9,956/10,520 동일 · POPUP 40 2,152 동일 · 81 2,454 동일 · **82 38,659→38,672 (+13)** | POPUP DEPT_ID: 81 NULL 122→2 / **82 NULL 0→3,063** (SITE_ITEM.DEPT_ID 결측 아이템) / 40 동일 |
| 3 | PACKAGE BODY | PKG_DMF0022 | **1건 수정** (1802 GT_DM22_SCM_MST_SITE_ITEM.DEPT_ID 스칼라→`A.DEPT_ID`) | 40/81/82 = 1,679/1,156/736 동일 | 없음 (DEPT 분포 13/16/12 동일·해시 동일) |
| 4 | PACKAGE BODY | PKG_DMF0035 | **1건 수정** (2247 GT_DM35 스칼라→`A.DEPT_ID`) | 370/517/199 동일 | 없음 (해시 동일) |
| 5 | PACKAGE BODY | PKG_DMF0040 | **1건 수정** (1307 E.DEPT_ID 추가 + 1335 TEAM=DEPT_INFO ON E.DEPT_ID + 1347 K ON E.DEPT_ID) | 81/82 = 394/476 동일 · 40 은 전/후 모두 300s 초과(측정불가) | 없음 (해시 동일) |
| 6 | PACKAGE BODY | PKG_DMF0044 | **5건 수정** (3084 스칼라 4개 / 8588 / 8718 / 8825 / 8847) | SAVE SP → 블록 SQL 대조: 8588 div별 동일 · 3084 23,199 전건 동일값 · 8718 0=0(룩업 부재 사각) · **8825 82분기 38,621→35,557** | 8825: item DEPT NULL 3,064행 분기1 이탈(분기2 UNION 으로 유지) |
| 7 | PACKAGE BODY | PKG_DMF0049 | **변경대상없음** — DEPT_ID 는 `DM_PLN_SALES_ETC_REPORT_C` 저장값 소비 + `TB_FX_USER` 본인부서(권한) | — | — |
| 8 | PACKAGE BODY | PKG_DMF0051 | **2건 수정** (1177 OW.DEPT_ID→`SMSI.DEPT_ID` / 1205·1215 GT_DM51_SCM_CITY DEPT = SITE_ITEM PK 4키) | 40 = 13,076 동일 · 81/82 = 0 동일 | 없음 (해시 동일) |
| 9 | PACKAGE BODY | PKG_DMF0074 | **4건 수정** (96·201·632·711 TEAM=DEPT_INFO ON SITE_ITEM/SI.DEPT_ID) | METAL_LINK_PRICE 0/4,390/480 동일 · TEMPLATE 342/145/74 동일 | 없음 (해시 동일) |
| 10 | PACKAGE BODY | PKG_DMF0082 | **6건 수정** (844 TEAM+K / 5066 UPLOAD DI ON SI.DEPT_ID / 7407 TEAM+K / 10395 GT_PJT / 10488 / 11045) | POPUP 40 2,220 동일 · 81 2,454 동일 · 82 전 0/후 300s 초과 · GET_MAIN_DATA(_CURRENT) 전/후 `ORA-00904 SORT_KEY`(기존 결함, 측정불가) | POPUP 81 NULL 122→2 · **5066 END_CUSTOMER 후보 81 333→340 · 82 1,297→1,375**(상위집합) |
| 11 | PROCEDURE | DMF0020_GET_SCM_MST_FUTURE_PRICE | **2건 수정** (697 PJT `SI.DEPT_ID` / 1044 TEAM=DEPT_INFO ON SITE_ITEM.DEPT_ID) — 649 NEW_DEPT_ID_TBL MAX 는 사용자 확정 유지 | 8,652/9,956/10,520 동일 | 없음 (해시 동일) |
| 12 | PROCEDURE | DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | **3건 수정** (292 GT_PJT `SI.DEPT_ID` / 370 TEAM·DEPRTMENT → SITE_ITEM.DEPT_ID / 752 SITE_PROJECT TEAM → SITE_ITEM.DEPT_ID) | 81 2,454 동일 · **82 38,659→38,672 (+13)** · 40 은 GT_DMF0020_PJT 적재 >10분으로 측정 제외 | 81 NULL 122→2 · **82 NULL 0→3,063** |
| 13 | PROCEDURE | PR_DM_BPS_METAL_LINK_S | **변경대상없음** — `A.DEPT_ID` = `DM_BPS_METAL_LINK_PRICE_C` 저장값(상류 PKG_DMF0074) | — | — |
| 14 | PROCEDURE | PR_DM_BPS_SALES_ETC_PLAN_S | **변경대상없음** — 251 이미 `D.DEPT_ID`(SITE_ITEM). `SU` OWNER 조인은 DEPT 미사용 잔존(사용자 확정 미변경) | — | — |
| 15 | PROCEDURE | PR_DM_BPS_SALES_PLAN_S | **변경대상없음** — 367/441/513 이미 `D.DEPT_ID`. `SU` 잔존 동일 | — | — |
| 16 | PROCEDURE | PR_DM_METAL_LINK_CUTOFF | **변경대상없음** — 85/154 저장값 이관 | — | — |
| 17 | VIEW | IF_DM_HI_CUST_FCST_INPUT_V | **변경대상없음** — `DM_HI_CUST_FCST_INPUT.DEPT_ID` passthrough | — | — |
| 18 | VIEW | IF_DM_HI_SALES_INPUT_V | **변경대상없음** — `DM_HI_SALES_INPUT.DEPT_ID` passthrough | — | — |

합계: 수정 10 객체 / 34 지점 (+ MAX 유지 1) · 변경대상없음 8 객체. 배포 10 객체 전부 VALID·USER_ERRORS 0.
건수 상이 = 2 커서(POPUP 82, standalone·PKG 동일 원인 +13) / 값 상이 = POPUP 81·82 DEPT_ID 컬럼 + SAVE/UPLOAD 3 지점(§01_ROWCOUNT_PARITY.md).
