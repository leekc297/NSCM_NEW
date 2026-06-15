# DMF0042 + 3 variants — BUSINESS PLAN Deploy Package (4 화면 SKELETON)

> Phase B-4 / B-4-2 / B-4-3 / B-4-4 — DMF0042 메인 + 3 variants (사용자 확정: 4 화면 모두 별도)
> 작성: 2026-06-07
> 자매 reference: DMF0020 (PIVOT 행잠금) + DMF0021 (Plan 다단 헤더) + DMF0048 (Plan 표준)

## 4 화면 인벤토리

| MENU_ID | FE 폴더 | URL | 자매 비교 |
|---|---|---|---|
| DMF0042 | features/report/src/pages/business-plan/ | /report/biz-plan/business-plan | 메인 (3,564줄) |
| DMF0042_1 | features/report/src/pages/business-plan-1/ | /report/biz-plan/business-plan-1 | variant 1 (~3,000줄) |
| DMF0042_2 | features/report/src/pages/business-plan-2/ | /report/biz-plan/business-plan-2 | variant 2 (~3,000줄) |
| DMF0042_3 | features/report/src/pages/business-plan-3/ | /report/biz-plan/business-plan-3 | variant 3 (~3,000줄) |

## 작업 내역 (16 파일)

### DMF0042 메인 (5 파일)
- constants / types / store / Main / index

### DMF0042_1/_2/_3 variants (각 4 파일 = 12)
- constants (MENU_ID + slug 만 다름, 다른 export 는 메인에서 re-export)
- store (createPersistedStoreWithTab name 변경)
- Main (BusinessPlan1/2/3.tsx)
- index

### Router 등록 (5 row 추가)
- `route-paths.ts`: BIZPLAN + DMF0042/_1/_2/_3 (5 slug)
- `Router.tsx`: REPORT children 에 BIZPLAN 신규 + 4 route

## ⚠️ Phase B-4~B-4-4 후속 작업 (High Priority)

### 공통 (4 화면 모두)
- 9 SP 정밀 매핑 + 메타 SQL 7-BLOCK × 4
- 97 validation + 62 expression (PIVOT 행잠금 57) — hook 신규
- 68 cols Grid + 다단 헤더
- 4 신규 popup (ExchangeRate / Textbox / Version / UnitedVersion)
- _bulk_fix_v2 SP audit 검증 (2026-06-01 적용 결과)
- CRUD handler (handleSave / handleInsert / handleDelete)

### variants 1/2/3 특수
- AS-IS DMF0042_1/_2/_3 .cs 정밀 분석 (각 3,000줄)
- variants 별 column / validation / expression 차이 식별
- 공통 component 추출 (BusinessPlanForm / BusinessPlanGrid) — variants 재사용

### 메타 SQL ⏳ 미작성 (Phase B-4 후속)

각 화면별 `_artifacts/_deploy_packages/DMF0042{,_1,_2,_3}/03_META/010_*_meta.sql`

## 실행

본 SKELETON 은 Router 등록 만. 메타 SQL 미작성 시 메뉴 진입 X.
Phase B-4 후속 완성 후 정식 실행.
