# DMF0049_CLOUD_20260828 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조 · 이관 대상만)

생성 2026-08-28 15:40 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260828.py DMF0049` (SELECT 만 — DDL/DML 실행 없음)
DB = 08-28 SARGSWEEP(SAVE 3건 직접 술어 + DIVISION '-' 정규화) 포함 라이브 현재 기준. PKG_DMF0049 는 PKG_DMF0044 에 의존(ALL_DEPENDENCIES) → 12/13 으로 동봉(DMF0044 패키지와 동일 본문). FE = VERSION 조회항목 gridSize=3(-01) + 08-20 이후 폴더 변경분.
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외
⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 (2026-08-04 사용자 확정).

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC·FUNCTION 포함 — 기이관이면 diff 후 skip) → **`40_GRANT_SYNONYM`** → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `22A_SHEET_META_DEP_PROGRAMS` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE / FE_MERGE 배포) → `90_VERIFY`(V11~V14 포함, `<TEST_USER>` 치환)
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 6본 (접두 ['GT_DMF0049'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0049_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-07-23 16:56'), ('PACKAGE BODY', 'VALID', '2026-08-28 10:32')] |
| 11_PKG_DMF0049_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-07-23 16:56'), ('PACKAGE BODY', 'VALID', '2026-08-28 10:32')] |
| 12_PKG_DMF0044_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-20 18:53'), ('PACKAGE BODY', 'VALID', '2026-08-28 10:32')] |
| 13_PKG_DMF0044_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-20 18:53'), ('PACKAGE BODY', 'VALID', '2026-08-28 10:32')] |
| 14_FUNCTION_FN_GET_COUNTRY_KR_NAME.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 15_FUNCTION_FN_GET_DM_MKT_OWNER_NAME.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 16_PROCEDURE_PR_DM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 17_PROCEDURE_PR_SCM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 11 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 22A_SHEET_META_DEP_PROGRAMS.sql | 종속 PROGRAM_ID ['DMF0044'] / 80행 |
| 25_EXCEL_COLUMNS.sql | 0행 |
| 26_LOOKUP_DETAIL.sql | 1행 |
| 21_CMBO_SQL.sql | 21본 (FE 요청 21: 미등재 []) |
| 23_MSG_LBL_MNU.sql | 75행 / 미존재 ['LBL00513', 'MSG_API_DMF0049_main_COLUMN_SETUP', 'MSG_API_DMF0049_main_DELETE', 'MSG_API_DMF0049_main_EXCEL', 'MSG_API_DMF0049_main_FILTER', 'MSG_API_DMF0049_main_INSERT', 'MSG_API_DMF0049_main_MEASURE_SELECT', 'MSG_API_DMF0049_main_SAVE', 'MSG_API_DMF0049_main_SEARCH', 'MSG_API_DMF0049_main_SORT', 'MSG_API_DMF0049_main_SP_VER', 'MSG_API_DMF0049_measure_SEARCH', 'MSG_API_DMF0049_spreadTitle_SEARCH', 'MSG_API_DMF0049_titleSet_SAVE', 'MSG_API_DMF0049_titleSet_SEARCH', 'MSG_API_DMF0049_unitedVersion_ACTION', 'MSG_API_DMF0049_unitedVersion_ACTION_BP', 'MSG_API_DMF0049_unitedVersion_SEARCH', 'MSG_API_DMF0049_unitedVersion_TITLE', 'MSG_API_DMF0049_unitedVersion_TRANSFER'] |
| 40_GRANT_SYNONYM.sql | 대상 6: ['PKG_DMF0049', 'PKG_DMF0044', 'FN_GET_COUNTRY_KR_NAME', 'FN_GET_DM_MKT_OWNER_NAME', 'PR_DM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 + V11~V14 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 4 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 19 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 70 |
| 20:SCM_ADM_API_M | 19 |
| 24:DMF0002_GET_TITLESET_POPUP | 7 |
| 24:PKG_DMF0000.P_DMF0000_GET_COMMON_SPREAD_TITLE | 8 |
| 24:PKG_DMF0044.P_DMF0044_GET_SALES_VERSION_POPUP | 9 |
| 24:PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE | 6 |
| 24:PKG_DMF0044.P_DMF0044_SAVE_BIZ_PLAN_VERSION_COPY | 6 |
| 24:PKG_DMF0044.P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY | 9 |
| 24:PKG_DMF0049.P_DMF0049_GET_MEASURE | 5 |
| 24:PKG_DMF0049.P_DMF0049_GET_SALES_ETC_REPORTS_DATA | 10 |
| 24:PKG_DMF0049.P_DMF0049_GET_SPREAD_TITLE | 8 |
| 24:PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C | 37 |
| 24:SCM0002_SET_TITLESET_POPUP | 14 |
| 22:SCM_MST_SHEET_COLUMNS:DMF0049/MDF Reports | 42 |
| 22:SCM_MST_SHEET_MEASURE:DMF0049/MDF Reports | 3 |
| 22A:SCM_MST_SHEET_COLUMNS:DMF0044/MDF Reports | 46 |
| 22A:SCM_MST_SHEET_COLUMNS:DMF0044/MDFVerpopup | 12 |
| 22A:SCM_MST_SHEET_COLUMNS:DMF0044/exchangeRate | 4 |
| 22A:SCM_MST_SHEET_MEASURE:DMF0044/MDF Reports | 18 |

## 게이트 (hook #148 생성기 의무)
- G1 GRANT/시노님 대상 6: ['PKG_DMF0049', 'PKG_DMF0044', 'FN_GET_COUNTRY_KR_NAME', 'FN_GET_DM_MKT_OWNER_NAME', 'PR_DM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH']
- G2 종속 PROGRAM_ID: ['DMF0044']
- G4 NLS 스캔(동적 CAST AS DATE / 마스크 없는 TO_DATE): 0건 []
- G5 procedures.d.ts 블록 경계: L3352~L3462

## B_FE (18 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
- `features/demand/src/pages/etc-sales-reports/etc-sales-reports.constants.ts`
- `features/demand/src/pages/etc-sales-reports/etc-sales-reports.types.ts`
- `features/demand/src/pages/etc-sales-reports/EtcSalesReports.module.scss`
- `features/demand/src/pages/etc-sales-reports/EtcSalesReports.tsx`
- `features/demand/src/pages/etc-sales-reports/index.ts`
- `features/demand/src/pages/etc-sales-reports/useEtcSalesReportsStore.ts`
- `features/demand/src/pages/etc-sales-reports/__asis-mapping__.md`
- `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.module.scss`
- `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsForm.tsx`
- `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsGrid.tsx`
- `features/demand/src/pages/etc-sales-reports/components/EtcSalesReportsModals.tsx`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.api.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.division.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.editLock.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.gridCombos.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.merge.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.save.ts`
- `features/demand/src/pages/etc-sales-reports/utils/etc-sales-reports.validate.ts`

## FE_MERGE (42 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
화면에서 import 로 도달하는 파일(폐포 114본) 중 **기준선(4b740ab~1) 이후 변경분 ∩** = 아래. 화면이 참조하지 않는 변경 파일은 이 패키지에 넣지 않았다(이관 대상만).
- `features/demand/src/components/versionModal/VersionModal.module.scss`
- `features/demand/src/components/versionModal/VersionModal.tsx`
- `features/master/src/components/index.ts`
- `features/master/src/components/itemByDivisionModal/ItemByDivisionModal.tsx`
- `features/master/src/components/measureSelectModal/MeasureSelectModal.tsx`
- `features/master/src/components/ownerByDivisionModal/OwnerByDivisionModal.tsx`
- `features/master/src/components/projectByDivisionModal/ProjectByDivisionModal.tsx`
- `features/master/src/components/searchFields/SearchFields.debug.ts`
- `features/master/src/components/searchFields/SearchFields.tsx`
- `features/master/src/components/searchFields/SearchFields.utils.ts`
- `packages/foundation/src/apis/axios.ts`
- `packages/foundation/src/constants/button-type.ts`
- `packages/foundation/src/constants/column-config.ts`
- `packages/foundation/src/constants/index.ts`
- `packages/foundation/src/models/common/column-config.ts`
- `packages/foundation/src/models/common/combo.ts`
- `packages/foundation/src/utils/columnMapping.ts`
- `packages/foundation/src/utils/gridAction.ts`
- `packages/foundation/src/utils/index.ts`
- `packages/foundation/src/utils/mergeManager.ts`
- `packages/foundation/src/utils/string.ts`
- `packages/shared/src/components/molecules/customDropdown/components/CustomListbox.module.scss`
- `packages/shared/src/components/molecules/customDropdown/components/CustomListbox.tsx`
- `packages/shared/src/components/molecules/customDropdown/components/CustomListboxRow.module.scss`
- `packages/shared/src/components/molecules/customDropdown/components/CustomListboxRow.tsx`
- `packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx`
- `packages/shared/src/components/molecules/customDropdown/CustomDropdownMui.module.scss`
- `packages/shared/src/components/molecules/dialog/components/CustomDialogContent.module.scss`
- `packages/shared/src/components/organisms/data-grid/DataGrid.tsx`
- `packages/shared/src/components/organisms/data-grid/dataGridUtils.ts`
- `packages/shared/src/components/organisms/data-grid/titleSetApi.ts`
- `packages/shared/src/components/organisms/data-grid/useRowParamCombos.ts`
- `packages/shared/src/components/organisms/index.ts`
- `packages/shared/src/components/organisms/main-title/MainTitle.tsx`
- `packages/shared/src/components/organisms/search-area/SearchArea.tsx`
- `packages/shared/src/components/organisms/sub-title/SubTitle.tsx`
- `packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx`
- `packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts`
- `packages/shared/src/hooks/useCustomQueryClient.ts`
- `packages/shared/src/stores/useDirtyRegistry.ts`
- `packages/shared/src/stores/useMessageStore.ts`
- `procedures.d.ts.DMF0049_BLOCK.txt (L3352~L3462, 시트 키 ['spreadTitle', 'measure', 'unitedVersion', 'titleSet'])`
- `procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0049_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/**` 공용 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영. 공용 파일은 다른 화면(DMF0082/0021 등)의 변경도 함께 담고 있을 수 있다 — diff 로 판단.
- `apps/web/**`(mdi 셸·viewRegistry) 는 세대 혼재라 파일 단위 덮어쓰기 ⛔ — 본 패키지 제외.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): ['features/master/src/components']

## _survey
- `fe_check_20260828.txt` — 작업 트리 전체 lint + type-check (사용자 상시 지시). 기준선 2026-08-23: type-check 123 / lint 79 (BACKUP 폴더·SDM1010 계약 충돌 등 기존 잔재).
- `survey.json` — 생성 근거 전문.
- FE 검증(2026-08-28, `fe-check.ps1 all` 작업트리 전체): turbo Tasks 26/26 successful · type-check `error TS` **0건** · lint **errors 0 / warnings 203**(기존 잔재 — 8 패키지 합) · 소요 ?. 원문 = `_survey/fe_check_20260828.txt`
- 23_MSG '메타 미존재 코드' 중 LBL00513/MSG00281/MSG00321 은 화면 소스의 **주석(AS-IS 참조)에만** 출현 — 실소비 아님(hook #138 주석≠LIVE). MSG_API_* 는 API_MSG_ID 관례상 MSG_M 행 없음(타 패키지 동일).
