# DMF0048 SalesMonitoring — Deploy Package

> NSCM TO-BE 신규 화면 — Sales Monitoring (DM Plan, 조회 전용)
> 작성: 2026-06-07 (Phase B-1 발판 화면)
> 자매 reference: DMF0020 SalesFuturePrice (PIVOT + 동적 헤더 패턴)

## 작업 내역

### FE 신규 파일 (10)
- `nscm-fe/features/demand/src/pages/sales-monitoring/`
  - `index.ts` / `SalesMonitoring.tsx` / `SalesMonitoring.module.scss`
  - `sales-monitoring.constants.ts` (MENU_ID + SHEETS + RESPONSE_SET + BUCKET_TYPE + DIVISION + MAIN_COLUMNS 51 + MSG)
  - `sales-monitoring.types.ts` (SearchCondition + SalesMonitoringRow + Meta + SpreadTitleRow + Payload)
  - `useSalesMonitoringStore.ts` (createPersistedStoreWithTab + setSearchCondition + setFilter)
  - `components/SalesMonitoringForm.tsx` (SearchArea + 카탈로그 11 field + Division 종속 reset)
  - `components/SalesMonitoringGrid.tsx` (DataGrid + 51 cols + 동적 시간축 헤더 + frozenColumns)
  - `hooks/useSalesMonitoringValidation.ts` (4 검증 — Division/기간/3년/concurrency)
  - `__asis-mapping__.md` (4축 매핑 100% — PR 머지 게이트)

### Router 등록
- `nscm-fe/packages/foundation/src/constants/route-paths.ts` (+1 row: `DMF0048: 'sales-monitoring'`)
- `nscm-fe/apps/web/src/core/Router.tsx` (+ lazy import + DEMAND_PLAN children +1 route)
- URL: `/demand/demand-plan/sales-monitoring`

### 메타 SQL 7-BLOCK (1 파일 — 60+ row INSERT)
- `_artifacts/_deploy_packages/DMF0048/03_META/010_DMF0048_meta.sql`
  - BLOCK 1: MSG_M (2 API 메시지)
  - BLOCK 2: MNU_M (1 row, UPPR_MNU_ID='Demand_Plan')
  - BLOCK 3: SHEET_COLUMNS (51 cols)
  - BLOCK 4: PROC_M (30 rows = 23 main SP + 7 spread title SP)
  - BLOCK 5: API_M (2 endpoint)
  - BLOCK 6: MNU_BTN_MPG_M (2 button)
  - BLOCK 7: USER_GR_MNU_MPG_M + USER_GR_MNU_BTN_MPG_M (GUEST + minyonglee1 그룹)

## ✅ 정식 완성 작업 (Phase B-1 — Task #18 + #19 모두 완료, 2026-06-07)

### Task #18 — PKG body 보강 (✅ 4 SQL 파일 작성 완료)

기존 PKG_DMF0048 의 spec 에 `P_DMF0048_GET_SPREAD_TITLE` 선언만 있고 body 누락 → standalone SP 로 분리 작성.

- **A. standalone SP 신규**: `01_SP_BODY/020_DMF0048_SPREAD_TITLE_create.sql` (~240줄)
  - 6 IN + dual OUT cursor (`O_RC1` + `O_RESULT_CURSOR`)
  - DAILY/WEEKLY/MONTHLY 분기 + 사용자 정의/시스템 컬럼 + 동적 시간축 통합 (D_/W_/M_)
  - 출처: `To-be_v2_converted/07_Standalone_SP/_archive_absorbed_into_PKG/05_Standalone_SP_DMF0048.sql` 의 SELECT 를 OPEN cursor FOR 로 wrap
- **B. PKG spec 정리**: `01_SP_BODY/021_DMF0048_pkg_spec_remove_SPREAD_TITLE.sql`
  - PKG_DMF0048 spec 에서 SPREAD_TITLE 선언 제거 (body 누락 해결)
  - `GET_DM_PLN_SALES_MONITORING` 그대로 보존 (sp-body-minimal-change 의무 준수)
  - ALTER PACKAGE COMPILE BODY 자동 실행
- **C. API_URL 정정**: `03_META/030_DMF0048_meta_api_url_fix.sql`
  - `PKG_DMF0048.P_DMF0048_GET_SPREAD_TITLE` → `P_DMF0048_GET_SPREAD_TITLE` (standalone)
- **D. Verify**: `05_VERIFY/020_DMF0048_SPREAD_TITLE_Verify.sql`
  - 7 단계 검증 (SP VALID / PKG VALID / ALL_ARGUMENTS 8행 / PROC_M match / API_M URL / SALES_MONITORING 보존)

### Task #19 — FE 정식 완성 (✅ 보강 완료)

- ✅ Form 보강: chkSum/chkColor/InternalYN 체크박스 + Multi-currency 콤보 + **Division=40 분기** (Project/PlantSite `disabled`)
- ✅ Grid 보강: CellDoubleClick popup trigger + SUM 헤더 동적 (headersVisibility toggle)
- ✅ SalesMonitoring.tsx 메인: `customButtons` (Column Setting + Measure) + ColumnSettingModal wiring
- ✅ DBeaver/Verify/Diagnose 3 파일 세트 (feedback_sql_dual_output)

### ✅ Option A 1차 + 2차 (2026-06-08) — 후속 보강 모두 완료

**Option A 1차** (Form/Grid + DBeaver 3 파일):
- Form 체크박스 3 + Multi-currency placeholder + Division=40 분기
- Grid CellDoubleClick + SUM 헤더 (headersVisibility)
- ColumnSettingModal wiring
- DBeaver/Verify/Diagnose 3 파일

**Option A 2차** (사고 정정 + 미매핑 100% 보강):
- ⚠️ 이전 "read-only" 판단 정정 → **부분 편집 가능** (D_ 컬럼만, Dsdm_Changed L1390)
- `useSalesMonitoringExpression` hook 신규 (Expression 7건 100% 매핑):
  - chkSum W_/M_ visibility toggle
  - chkColor setResultPeriod (실적 Gainsboro / 계획 White / 현재 주 Green cssClass)
  - Dsdm_Changed cellEditEnded (D_ 편집 시 Weekly+Monthly SUM 자동 재계산)
- btnMeasure 정확 (ColumnSettingModal columnType='measure' 동일 popup mode 분기)
- F12 Excel 실제 구현 (Wijmo FlexGridXlsxConverter.saveAsync)
- CellDoubleClick wiring 제거 (AS-IS L1385 빈 함수 확인)
- Multi-currency cboKRW/USD/LOC 빈 함수 확인 (AS-IS L2116/2126/2136)
- cboBucketType_Click 매핑 (canChangeBucketType — Insert 'I' 차단 MSG00227)
- bucketType prop drilling 완료
- __asis-mapping__.md 4축 100% (21 events 모두 ✅ + ➖ 명확 표기)
- DBeaver Diagnose Step 4.5~4.7 (메뉴 미연결 진단 — 부모 메뉴 권한 + minyonglee1 그룹 + FIX SQL placeholder)
- Save 비활성 결정 명확화 (PKG_DMF0048 SAVE SP 미정의 확인)

## 실행 순서 (정식 완성 — Phase B-1 완료)

```bash
# 1. 메타 SQL 실행 (멱등 NOT EXISTS — 안전 재실행)
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0048/03_META/010_DMF0048_meta.sql

# 2. PKG body 보강 — 4 파일 순서대로
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0048/01_SP_BODY/020_DMF0048_SPREAD_TITLE_create.sql
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0048/01_SP_BODY/021_DMF0048_pkg_spec_remove_SPREAD_TITLE.sql
docker exec -i scmoracle sqlplus scm_mgr/scm_mgr@XEPDB1 < /artifacts/_deploy_packages/DMF0048/03_META/030_DMF0048_meta_api_url_fix.sql

# 3. Verify 실행 (DBeaver)
#    _artifacts/_deploy_packages/DMF0048/05_VERIFY/010_DMF0048_meta_DBeaver_Verify.sql  (메타 10 검증)
#    _artifacts/_deploy_packages/DMF0048/05_VERIFY/020_DMF0048_SPREAD_TITLE_Verify.sql   (SPREAD_TITLE 7 검증)
#    → 모든 STATUS 컬럼이 'MATCH' / 'OK' 또는 ROW_CNT = EXPECT 일치

# 4. BE 재기동 불필요 (GeneralController 동적 SP 라우팅, 메타 lookup 자동 갱신)

# 5. FE 화면 검증
#    http://127.0.0.1:5173 (localhost 금지) → minyonglee1 로그인
#    Demand > Demand Plan > Sales Monitoring
#    - 체크박스 3 (Internal/Sum/Color)
#    - Division 변경 시 Project/PlantSite 자동 비활성 (div=40)
#    - [Column Setting] [Measure] 버튼 표시
#    - 조회 → 동적 헤더 (D_/W_/M_) + Grid 표시
```

## 진단 (사고 시)

```
_artifacts/_deploy_packages/DMF0048/05_VERIFY/010_DMF0048_meta_DBeaver_Diagnose.sql
  - menu-not-displayed-debug 7단계 (URL/UPPR_MNU_ID/SHT_NM/MNU_DESC/권한)
  - PROC_M ↔ SP signature mismatch
  - PKG status (VALID 검증)
  - SHEET_COLUMNS dedupe
```

## 메모리 cross-ref

- `feedback_new_screen_features_location` ✅ (Demand_Plan → features/demand)
- `feedback_mnu_uppr_case_standard` ✅ (UPPR_MNU_ID='Demand_Plan' case 정확)
- `feedback_sheet_name_main_standard` ✅ (SHT_NM='main')
- `feedback_form_search_area_standard` ✅ (SearchArea + FormItem + 카탈로그)
- `feedback_search_fields_catalog` ✅ (`@master/searchFields` 11 field 재사용)
- `feedback_grid_editable_coloring_mandatory` ✅ (DataGrid + _inputEditType='S' 조회 전용)
- `feedback_asis_button_mapping_mandatory` ✅ (CRUD 6 + Search Aux 4 = 10 대)
- `feedback_common_button_visibility_default` ✅ (Hidden allowlist: insert/delete/save false)
- `feedback_proc_meta_mandatory` ✅ (PROC_M 30 row, COL_NM 자동 채움 키 정확)
- `feedback_sql_idempotent_insert_all` ✅ (모든 INSERT NOT EXISTS 멱등)
- `feedback_search_aux_default_activation` ✅ (sort/filter/excel/search 자동 활성, condition/resetCondition false)
- `feedback_search_button_when_no_searcharea` ✅ (searchAction prop — SubTitle 좌측 F5 버튼)

## Hook 적용

- `pre-write.md` + `post-write.md` + `pre-submit.md` (모든 작업 공통)
- `screen-create-checklist.md` (T01 신규 화면)
- `asis-coverage-check.md` (4축 매핑 — `__asis-mapping__.md`)
- `asis-button-mapping.md` (10 대 버튼)
- `grid-column-meta-mandatory.md` (51 cols 메타)
- `runtime-error-prevention.md` (Wijmo / Box / @shared/mui)
- `menu-not-displayed-debug.md` (UPPR_MNU_ID 대소문자 + SHT_NM + MNU_DESC + MNU_URL slug)
- `sheet-columns-binding-match.md` (COLUMN_NAME ↔ SP alias case)
- `proc-meta-signature-match.md` (PROC_M positional 일치)
- `sp-body-minimal-change.md` (PKG body 보강 시)
- `mutation-onsuccess-defaults.md` (조회 전용 → 해당 없음)
- `grid-interaction-patterns.md` (selectionMode/loadedRows)
- `search-button-when-no-searcharea.md` (searchAction prop)
- `pivot-frozen-columns.md` (frozenColumns=4)
- `wijmo-merge-sticky-content.md` (HierarchicalMerge — 후속)
- `deploy-package-completeness.md` (PR 머지 게이트)
