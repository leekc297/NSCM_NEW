# DMF12 신규 화면 메뉴 연결 fix (2026-06-08)

## 목적

DMF12 신규 화면 (DMF0014/0021/0042/0042_1/0042_2/0042_3/0044/0048/0049/0074/0081/0082) 의 메뉴 미표시 사고 fix.

hook `Doc/_rules_v2/hooks/menu-not-displayed-debug.md` 7단계 진단 결과:

| # | 사고 | 영향 | fix |
|---:|---|---|---|
| 1 | URL slug 8건 불일치 (DB `dmf0014` 형식 vs FE `customer-fcst-upload` 의미 slug) | 메뉴 클릭 시 NotFound | BLOCK 4 — UPDATE 8건 |
| 2 | UPPR_MNU_ID 3건 잘못 (`Demand_Plan` → `Bizplan`/`Sales_Report`) | 트리 walk-up 실패 | BLOCK 5 — UPDATE 3건 |
| 3 | 부모 메뉴 2건 누락 (BIZPLAN, SALES_REPORT) | 자식 표시 불가 | BLOCK 2 — INSERT 2건 |
| 4 | 자식 3건 등록 누락 (DMF0042_1/2/3) | row 자체 없음 | BLOCK 3 — INSERT 3건 |
| 5 | i18n 5건 누락 (MNU_BIZPLAN/SALES_REPORT/DMF0042_1/2/3) | 메뉴명 표시 불가 | BLOCK 1 — INSERT 5×3=15 row |
| 6 | 권한 누락 (3 그룹 × 신규 5 메뉴) | "권한 없음" | BLOCK 6 — INSERT 15 row |

## 사용자 요구

> "메뉴명칭은 기존에 있던 한글 사용시에도 기존에 등록되어 있던 영문명칭으로 해주세요."

- 모든 신규 메뉴명 영문 (`Biz Plan` / `Sales Report` / `Business Plan 1/2/3`)
- KO/EN/CN 3 LANG 모두 동일 영문 (기존 자매 패턴 — Demand Plan / Business Plan / Waterfall 등 모두 영문)

## 파일 세트 (4)

| 파일 | 용도 |
|---|---|
| `001_DMF12_menu_fix.sql` | 메인 (sqlplus 자동 적용, PROMPT/COMMIT 포함) |
| `001_DMF12_menu_fix_DBeaver.sql` | DBeaver 호환 (DML 만, SET/PROMPT 0건) |
| `001_DMF12_menu_fix_Verify.sql` | 적용 후 PASS/FAIL 검증 6 BLOCK |
| `001_DMF12_menu_fix_Diagnose.sql` | 사고 재발 진단 7 항목 |

## 적용 결과 (2026-06-08 sqlplus 실행 PASS)

```
i18n MNU 신규                                     15
부모 메뉴 2건 (Bizplan/Sales_Report)               2
자식 신규 3건 (DMF0042_1/2/3)                      3
URL slug 의미 (= 8건 OK)                           8
UPPR fix (= 3건 Bizplan/Sales_Report)              3
권한 신규 15건                                    15
```

## 14 메뉴 최종 트리 (사용자 화면)

```
Report (Report)
├── Waterfall
│   └── DMF0022 (sales-plan-waterfall)
├── Bizplan (biz-plan) ⭐ 신규
│   ├── DMF0042 (business-plan)
│   ├── DMF0042_1 (business-plan-1) ⭐ 신규
│   ├── DMF0042_2 (business-plan-2) ⭐ 신규
│   └── DMF0042_3 (business-plan-3) ⭐ 신규
└── Sales_Report (sales-report) ⭐ 신규
    ├── DMF0044 (sales-reports)
    └── DMF0049 (etc-sales-reports)

Demand
└── Demand_Plan (demand-plan)
    ├── DMF0003 (mkt_forecast)
    ├── DMF0048 (sales-monitoring) — URL slug fix
    ├── DMF0021 (sales-plan) — URL slug fix
    ├── DMF0014 (customer-fcst-upload) — URL slug fix
    ├── DMF0074 (metal-link-price) — URL slug fix
    ├── DMF0081 (mkt-forecast-auto) — URL slug fix
    └── DMF0082 (forecast-price)
```

## 적용 후 사용자 작업

⚠️ **BE 재기동 불필요** (메모리 `feedback_be_restart_login.md` — SCM_ADM_MNU_M / USER_GR_MNU_MPG_M / MSG_M 모두 BE 캐시 없이 매 요청마다 DB query)

브라우저:
1. F12 → Application → Storage → "Clear site data"
2. 또는 Console: `localStorage.clear(); sessionStorage.clear(); location.reload(true);`
3. 일반 창에서 새로고침 (메모리 `feedback_no_incognito_window_guide.md` — 시크릿 창 금지)
4. 사이드바 메뉴 확장 → Report > Bizplan / Sales Report / Demand > Demand Plan 모두 표시 확인

## 향후 신규 화면 작성 시 의무

`Doc/_rules_v2/hooks/menu-not-displayed-debug.md` 7단계 PR 머지 게이트:

- Step 1: MNU_URL = FE `route-paths.ts` slug 정확 일치 (의미 slug, `dmfXXXX` 형식 금지)
- Step 1.5: UPPR_MNU_ID = 자매 화면 cross-check (대소문자 sensitive — `Bizplan` 등 정확 표기)
- Step 1.6: SHT_NM = 'main' (단일 sheet 표준)
- Step 1.7: MNU_DESC NOT NULL
- Step 2: FE 라우터 + ROUTE_PATHS 등록
- Step 3-4: USER_GR_MNU_MPG_M 자식 + 부모 권한
- Step 5-7: 런타임/BE 메타/i18n

## cross-ref

- hook `Doc/_rules_v2/hooks/menu-not-displayed-debug.md` (7단계)
- 메모리 `feedback_mnu_uppr_case_standard.md` (대소문자 표준)
- 메모리 `feedback_mnu_desc_required.md` (NOT NULL 의무)
- 메모리 `reference_scm_adm_mnu_m_url_slug.md` (URL slug 의미)
- 룰 13 §10 (MNU_DESC) / §1.1 (URL slug)
