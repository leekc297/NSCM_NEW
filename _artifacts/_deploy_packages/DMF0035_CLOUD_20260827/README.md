# DMF0035_CLOUD_20260827 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조)

생성 2026-08-27 18:30 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py DMF0035` (SELECT 만 — DDL/DML 실행 없음)
화면 폴더는 features/**report**/src/pages (report 도메인). 공통 수정분 = OlapPivotGrid(FITONCE 폭 보존) + procedures.d.ts + report 피처 스캐폴드(클라우드에 report 피처 부재 시).
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC 포함 — 기이관이면 diff 후 skip) → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE 배포) → `90_VERIFY`
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 49본 (접두 ['GT_DM35'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0035_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-06 14:54'), ('PACKAGE BODY', 'VALID', '2026-08-20 23:07')] |
| 11_PKG_DMF0035_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-06 14:54'), ('PACKAGE BODY', 'VALID', '2026-08-20 23:07')] |
| 12_PKG_DMF0022_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-10 20:46'), ('PACKAGE BODY', 'VALID', '2026-08-21 00:53')] |
| 13_PKG_DMF0022_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-10 20:46'), ('PACKAGE BODY', 'VALID', '2026-08-21 00:53')] |
| 14_PKG_DMF0051_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-06 14:53'), ('PACKAGE BODY', 'VALID', '2026-08-21 01:38')] |
| 15_PKG_DMF0051_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-06 14:53'), ('PACKAGE BODY', 'VALID', '2026-08-21 01:38')] |
| 16_PKG_SCM0002_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-07-27 15:54'), ('PACKAGE BODY', 'VALID', '2026-08-20 15:48')] |
| 17_PKG_SCM0002_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-07-27 15:54'), ('PACKAGE BODY', 'VALID', '2026-08-20 15:48')] |
| 18_FUNCTION_FN_GET_DM_MKT_OWNER_NAME.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 19_FUNCTION_FN_NEXT_DAY.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 20_FUNCTION_UF_FX_STRING_SPLIT.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 21_PROCEDURE_PR_SCM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 22_FUNCTION_FN_SPLITSTRING.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 23_FUNCTION_FN_SCM_SYS_NVL.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 24_FUNCTION_SCM_ARR_SPL_CNT.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 25_FUNCTION_SCM_ARR_SPL_VAL.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 8 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 25_EXCEL_COLUMNS.sql | 0행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 17본 (FE 요청 21: 미등재 [' ', 'CityCode', 'CountryCode', 'VersionNo']) |
| 23_MSG_LBL_MNU.sql | 66행 / 미존재 ['MSG_API_DMF0035_bizPlanSpreadTitle_SEARCH', 'MSG_API_DMF0035_bizPlanWaterfall_SEARCH', 'MSG_API_DMF0035_mktFcstSpreadTitle_SEARCH', 'MSG_API_DMF0035_mktFcstWaterfall_SEARCH', 'MSG_API_DMF0035_salesPlanSpreadTitle_SEARCH', 'MSG_API_DMF0035_salesPlanWaterfall_SEARCH', 'MSG_API_DMF0035_versionWf_SEARCH', 'MSG_API_DMF0035_version_SEARCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 5 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 8 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 40 |
| 20:SCM_ADM_API_M | 8 |
| 24:DMF0073_GET_VERSION_SALESPRICE | 9 |
| 24:PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL | 25 |
| 24:PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE | 9 |
| 24:PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL | 25 |
| 24:PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE | 7 |
| 24:PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL | 22 |
| 24:PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE | 9 |
| 24:PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP | 8 |
| 22:SCM_MST_SHEET_COLUMNS:Mkt Fcst Waterfall | 71 |
| 22:SCM_MST_SHEET_MEASURE:Mkt Fcst Waterfall | 49 |

## B_FE (17 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
- `features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.constants.ts`
- `features/report/src/pages/demand-plan-waterfall/demand-plan-waterfall.types.ts`
- `features/report/src/pages/demand-plan-waterfall/DemandPlanWaterfall.tsx`
- `features/report/src/pages/demand-plan-waterfall/index.ts`
- `features/report/src/pages/demand-plan-waterfall/useDemandPlanWaterfallStore.ts`
- `features/report/src/pages/demand-plan-waterfall/__asis-mapping__.md`
- `features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.module.scss`
- `features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx`
- `features/report/src/pages/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx`
- `features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.module.scss`
- `features/report/src/pages/demand-plan-waterfall/components/OlapChartPane.tsx`
- `features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.module.scss`
- `features/report/src/pages/demand-plan-waterfall/components/WaterfallVersionModal.tsx`
- `features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.module.scss`
- `features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/OlapFieldRail.tsx`
- `features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/olapFieldRail.utils.ts`
- `features/report/src/pages/demand-plan-waterfall/components/olap-field-rail/RailIcons.tsx`

## FE_MERGE (6 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
- `packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx`
- `configs/types/procedures.d.ts`
- `procedures.d.ts.DMF0035_BLOCK.txt (추출 L157~L4492)`
- `features/report/package.json`
- `features/report/tsconfig.json`
- `features/report/src/index.ts`
- `configs/types/procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0035_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/shared/**` 공용 컴포넌트 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영.
- 피처 스캐폴드(`features/report/package.json` 등) → 클라우드에 해당 피처가 이미 있으면 skip.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): ['features/master/src/components']

## 이관 유의 (2026-08-27 세션 변경분)
- **B_FE 화면 폴더 전체**(features/report/src/pages/demand-plan-waterfall) — 오늘 변경: ①F6 저장 조회조건 오픈 시 복원 ②Grid Layout 팝업 → **우측 300px 도킹 레일**(`components/olap-field-rail/*`) ③Chart(PivotChart 하단 분할)·Export(공통 Excel→OLAP 내보내기) ④`OlapLayoutModal.tsx` 삭제(클라우드에 남아 있으면 **삭제**).
- **FE_MERGE**: `OlapPivotGrid.tsx` `[FITONCE]`(자동 폭맞춤 1회·리사이즈 보존) → 공통소스판과 3-way diff / `procedures.d.ts` → `_BLOCK.txt` 만 이식 / report 피처 스캐폴드 3본 → 클라우드에 report 피처 있으면 skip.
- 레일 폰트 Barlow 는 Google Fonts `@import`(폴백 system-ui). DB: PKG BODY LAST_DDL 08-20 23:07 이후 변경 없음(현재 기준 신선 덤프·멱등).
## 30~ standalone SP (API_M 배선, PKG 밖) — 2026-08-27 보강
- 30_PROCEDURE_DMF0073_GET_VERSION_SALESPRICE.sql (VALID 2026-07-21 16:39) 의존 ['TABLE:DM_MST_VERSION', 'TABLE:SCM_SYS_CALENDAR_M', 'TABLE:SCP_PLN_INTERFACE_YN', 'FUNCTION:FN_STRING_SPLIT', 'PROCEDURE:PR_SCM_SYS_LOG_BATCH', 'PACKAGE:PKG_SCM_USER_MNU']

## 40_GRANT_SYNONYM.sql — 앱 계정 EXECUTE + 시노님 (2026-08-27 보강)
- 대상 13: ['PKG_DMF0035', 'PKG_DMF0022', 'PKG_DMF0051', 'PKG_SCM0002', 'FN_GET_DM_MKT_OWNER_NAME', 'FN_NEXT_DAY', 'UF_FX_STRING_SPLIT', 'PR_SCM_SYS_LOG_BATCH', 'FN_SPLITSTRING', 'FN_SCM_SYS_NVL', 'SCM_ARR_SPL_CNT', 'SCM_ARR_SPL_VAL', 'DMF0073_GET_VERSION_SALESPRICE']
- 사고: DMF0040 클라우드 SCMP_APP 에 PKG_DMF0040 EXECUTE 부재 → 화면 SQL ERROR (SCM_MGR 재현은 정상). 10~32 적용 후 **반드시** 실행.

## 22A / 25A — 종속 PROGRAM_ID(DMF0022·DMF0051) 메타 동봉 (2026-08-27 사용자 지적)
- DMF0035 는 AS-IS 3UI 통합: MKT=PKG_DMF0035(PROGRAM_ID DMF0035) / Sales=PKG_DMF0022(**DMF0022**) / Biz=PKG_DMF0051(**DMF0051**). 각 PKG 는 `V_PROGRAM_ID` 로 자기 SHEET_COLUMNS/MEASURE 를 읽으므로 3 PROGRAM_ID 메타가 모두 있어야 한다.
- 초판 22_SHEET_META 는 DMF0035 만 → Sales/Biz 조회 컬럼 0 위험. `22A_SHEET_META_DEP_PROGRAMS.sql`(SHEET 단위 DELETE+INSERT) + `25A_EXCEL_COLUMNS_DEP_PROGRAMS.sql`(MERGE) 추가, 90_VERIFY 에 기대 건수 등재.
- 적용 순서: 22 → **22A** → 21 → 23 → 25 → **25A** → 26.
- FE 계약(procedures.d.ts): DMF0022 블록은 독립 키로 존재(사내 L56~L155) → FE_MERGE 에 `procedures.d.ts.DMF0022_BLOCK.txt` 추가. DMF0051 은 사내에 독립 키가 없고 DMF0035 블록의 `bizPlanWaterfall`/`bizPlanSpreadTitle` 시트가 그 계약이다.

## 클라우드 적용 결과 (2026-08-28)
- 20_MENU_WIRING_AUTH(MNU_M DMF0035 행) + 22A(DMF0022/DMF0051 시트 메타) 적용 후 **MKT / SALES / BIZ 3 GUBUN 조회 확인** (사용자). 40 GRANT 는 선행 적용.
- **2026-08-28 (오후) 배포 버전에서 다시 0행 신고** → `A_DB/92_DIAGNOSE_DEPLOYED_NO_DATA.sql` (읽기 전용 Q0~Q9 + 직접 호출 재현 Q8). ⭐ QA·DEV 두 DB 에서 각각 실행해 Q0 라벨과 함께 회신. 판정표 = 파일 끝 §판정 (A: DB 불일치 / B: 배포 대상 DB / C: 계정 권한 / D: 권한 뷰 / E: FE 번들 / F: NLS).
- **2026-08-28 판정 완료 (사용자 확인)**: 원인 = QA `SCM_ADM_MNU_M` 의 `SCM0020` 행이 MNU_URL=`demand-plan-waterfall`(사내는 `scm0020`) 로 등재 → 그 메뉴로 진입해 DMF0035 컴포넌트가 SCM0020 배선으로 뜸(오류 없이 0행). **DMF0035 메뉴로 진입하니 조회 정상**. 조치 권고 = QA/DEV 의 SCM0020 행 MNU_URL 을 사내값 `scm0020` 으로 정정(또는 USE_YN='N') — 정정 SQL 은 사용자 결정 후 별도. `90_VERIFY` V14 · hook #148 S7 등재.
- 2026-08-28: 사용자가 클라우드 `SCM0020` 메뉴 행 **삭제** 완료 → 잔여 없음. V14 는 향후 이관 게이트로 유지.
