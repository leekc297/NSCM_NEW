# DMF0040_CLOUD_20260827 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조)

생성 2026-08-27 18:30 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py DMF0040` (SELECT 만 — DDL/DML 실행 없음)
공통 수정분 = procedures.d.ts(DMF0040 계약 블록).
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC 포함 — 기이관이면 diff 후 skip) → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE 배포) → `90_VERIFY`
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 6본 (접두 ['GT_DM40'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0040_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-07-21 16:39'), ('PACKAGE BODY', 'VALID', '2026-08-27 00:28')] |
| 11_PKG_DMF0040_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-07-21 16:39'), ('PACKAGE BODY', 'VALID', '2026-08-27 00:28')] |
| 12_PKG_DMF0007_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-07-21 16:39'), ('PACKAGE BODY', 'VALID', '2026-08-25 11:41')] |
| 13_PKG_DMF0007_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-07-21 16:39'), ('PACKAGE BODY', 'VALID', '2026-08-25 11:41')] |
| 14_FUNCTION_FN_MULTY_TIME.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 15_PROCEDURE_PR_SCM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 5 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 25_EXCEL_COLUMNS.sql | 0행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 12본 (FE 요청 16: 미등재 [' ', 'CityCode', 'CountryCode', 'VersionNo']) |
| 23_MSG_LBL_MNU.sql | 72행 / 미존재 ['MSG00166', 'MSG_API_DMF0040_mktFcstComparison_SEARCH', 'MSG_API_DMF0040_spreadTitle_SEARCH', 'MSG_API_DMF0040_titleSet_SAVE', 'MSG_API_DMF0040_titleSet_SEARCH', 'MSG_API_DMF0040_version_SEARCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 4 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 5 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 20 |
| 20:SCM_ADM_API_M | 5 |
| 24:DMF0002_GET_TITLESET_POPUP | 7 |
| 24:DMF0040_GET_SPREAD_TITLE | 7 |
| 24:PKG_DMF0040.P_DMF0040_GET_MKT_FCST_COMPARISON | 20 |
| 24:PKG_SCM0002.P_SCM0002_GET_VERSIONBYWATERFALLPOPUP | 8 |
| 24:SCM0002_SET_TITLESET_POPUP | 14 |
| 22:SCM_MST_SHEET_COLUMNS:Mkt Fcst Waterfall | 48 |
| 22:SCM_MST_SHEET_MEASURE:Mkt Fcst Waterfall | 3 |

## B_FE (12 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
- `features/demand/src/pages/mkt-fcst-comparison/index.ts`
- `features/demand/src/pages/mkt-fcst-comparison/mkt-fcst-comparison.constants.ts`
- `features/demand/src/pages/mkt-fcst-comparison/mkt-fcst-comparison.types.ts`
- `features/demand/src/pages/mkt-fcst-comparison/MktFcstComparison.tsx`
- `features/demand/src/pages/mkt-fcst-comparison/useMktFcstComparisonStore.ts`
- `features/demand/src/pages/mkt-fcst-comparison/__asis-mapping__.md`
- `features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.module.scss`
- `features/demand/src/pages/mkt-fcst-comparison/components/ComparisonVersionModal.tsx`
- `features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.module.scss`
- `features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonForm.tsx`
- `features/demand/src/pages/mkt-fcst-comparison/components/MktFcstComparisonGrid.tsx`
- `features/demand/src/pages/mkt-fcst-comparison/utils/mkt-fcst-comparison.api.ts`

## FE_MERGE (2 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
- `configs/types/procedures.d.ts`
- `procedures.d.ts.DMF0040_BLOCK.txt (추출 L4486~L4495)`
- `configs/types/procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0040_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/shared/**` 공용 컴포넌트 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영.
- 피처 스캐폴드(`features/report/package.json` 등) → 클라우드에 해당 피처가 이미 있으면 skip.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): ['features/master/src/components']

## 이관 유의 (2026-08-27 세션 변경분)
- **B_FE 화면 폴더 전체** — 오늘 변경: F6 저장 조회조건 오픈 시 복원(`restoreSearchConditions`). **FE_MERGE**: `procedures.d.ts` → `_BLOCK.txt` 만 이식.
- **PKG_DMF0040 BODY** 08-27 00:28 판(변환 잠재결함 4계열 정정). 의존 `PKG_DMF0007` 덤프(기이관이면 diff 후 skip).
- `20_MENU_WIRING_AUTH` 의 MNU_M MERGE 에 ROUTE_PATH/MNU_URL=`mkt-fcst-comparison` 포함 — **B_FE 배포 후** 실행. `MSG00166` 미존재 = PKG_DMF0007 주석 참조(무영향).
## 30~ standalone SP (API_M 배선, PKG 밖) — 2026-08-27 보강
- 30_PROCEDURE_DMF0002_GET_TITLESET_POPUP.sql (VALID 2026-08-22 12:59) 의존 ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER']
- 31_PROCEDURE_DMF0040_GET_SPREAD_TITLE.sql (VALID 2026-07-27 16:32) 의존 ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER', 'TABLE:SCM_SYS_CALENDAR_M', 'PROCEDURE:PR_SCM_SYS_LOG_BATCH']
- 32_PROCEDURE_SCM0002_SET_TITLESET_POPUP.sql (VALID 2026-08-07 19:37) 의존 ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER', 'FUNCTION:SCM_ARR_SPL_CNT', 'FUNCTION:SCM_ARR_SPL_VAL', 'PROCEDURE:PR_SCM_SYS_LOG_BATCH']

## 40_GRANT_SYNONYM.sql — 앱 계정 EXECUTE + 시노님 (2026-08-27 보강)
- 대상 7: ['PKG_DMF0040', 'PKG_DMF0007', 'FN_MULTY_TIME', 'PR_SCM_SYS_LOG_BATCH', 'DMF0002_GET_TITLESET_POPUP', 'DMF0040_GET_SPREAD_TITLE', 'SCM0002_SET_TITLESET_POPUP']
- 사고: DMF0040 클라우드 SCMP_APP 에 PKG_DMF0040 EXECUTE 부재 → 화면 SQL ERROR (SCM_MGR 재현은 정상). 10~32 적용 후 **반드시** 실행.

## 11_PKG_DMF0040_BODY.sql 재생성 — [E20260827-NLSDATE] (2026-08-27 20:09 사내 적용 VALID)
- 클라우드 실오류: `ORA-01861 literal does not match format string` @ PKG_DMF0040 line 1471 (DBMS_SQL) — 동적 SQL 의 `CAST(F.CUTOFF_YYYYMMDD AS DATE)` 7곳이 세션 NLS_DATE_FORMAT 의존 (BE JDBC 세션 `DD-MON-RR` 에서 실패, DBeaver/사내 세션은 통과).
- 정정: `TO_DATE(F.CUTOFF_YYYYMMDD, 'YYYYMMDD')` 명시 마스크 7곳 (hook #109). 검증 `dmf0040_nlsdate_verify.py`: DD-MON-RR 세션에서 ASIS 식 ORA-01861 재현 → 정정 식·정정 PKG 호출 정상.
- 적용: 이 11 파일을 SCM_MGR 로 재적용 → 화면 재조회. (40 GRANT/시노님은 이미 적용됨)
