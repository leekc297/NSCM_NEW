# DMF0014_CLOUD_20260831 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조 · 이관 대상만)

생성 2026-08-31 13:03 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py DMF0014` (SELECT 만 — DDL/DML 실행 없음)
[E20260831] Excel Upload Validation 클라우드 확인용 재취합. DB = 사내 라이브 현재 기준 전량 (0827 패키지 대비 delta: PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 이 0827 18:12 취합 후 20:14 재배포 — 구 패키지 14번 파일은 구본). FE = 이관 제외: customer-fcst-upload 6파일은 2026-08-31 공통소스(클라우드 원천) 반영에서 ADOPT_COMMON/SAME 실측 — 클라우드가 동본 또는 최신.
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외
⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 (2026-08-04 사용자 확정).

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC·FUNCTION 포함 — 기이관이면 diff 후 skip) → **`40_GRANT_SYNONYM`** → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `22A_SHEET_META_DEP_PROGRAMS` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE / FE_MERGE 배포) → `90_VERIFY`(V11~V14 포함, `<TEST_USER>` 치환)
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 32본 (접두 ['GT_DM14', 'GT_DPCF'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0014_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-14 14:05'), ('PACKAGE BODY', 'VALID', '2026-08-27 16:51')] |
| 11_PKG_DMF0014_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-14 14:05'), ('PACKAGE BODY', 'VALID', '2026-08-27 16:51')] |
| 12_FUNCTION_FN_SCM_GET_WHERE_SQL.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 13_PROCEDURE_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 14_PROCEDURE_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 15_PROCEDURE_PR_DM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 16_PROCEDURE_PR_SCM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 6 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 22A_SHEET_META_DEP_PROGRAMS.sql | 종속 PROGRAM_ID [] / 0행 |
| 25_EXCEL_COLUMNS.sql | 1행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 3본 (FE 요청 3: 미등재 []) |
| 23_MSG_LBL_MNU.sql | 81행 / 미존재 ['MSG_API_DMF0014_DAY_RANGE_SEARCH', 'MSG_API_DMF0014_MAIN_DELETE', 'MSG_API_DMF0014_MAIN_EXCEL', 'MSG_API_DMF0014_MAIN_FILTER', 'MSG_API_DMF0014_MAIN_INSERT', 'MSG_API_DMF0014_MAIN_SAVE', 'MSG_API_DMF0014_MAIN_SEARCH', 'MSG_API_DMF0014_MAIN_SORT', 'MSG_API_DMF0014_MAIN_UPLOAD', 'MSG_API_DMF0014_SPREAD_TITLE_SEARCH', 'MSG_API_DMF0014_UPLOAD_SAVE'] |
| 40_GRANT_SYNONYM.sql | 대상 6: ['PKG_DMF0014', 'FN_SCM_GET_WHERE_SQL', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40', 'PR_DM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 + V11~V14 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 6 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 12 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 60 |
| 20:SCM_ADM_API_M | 12 |
| 24:PKG_DMF0014.P_DMF0014_CUST_FCST_EXCEL_UPLOAD | 5 |
| 24:PKG_DMF0014.P_DMF0014_GET_CUST_FCST_UPLOAD_DATA | 17 |
| 24:PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA | 17 |
| 24:PKG_DMF0014.P_DMF0014_GET_SPREAD_TITLE | 7 |
| 24:PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA | 18 |
| 24:PR_GET_DAY_RANGE | 5 |
| 22:SCM_MST_SHEET_COLUMNS:DMF0014/FCST Upload | 15 |

## 게이트 (hook #148 생성기 의무)
- G1 GRANT/시노님 대상 6: ['PKG_DMF0014', 'FN_SCM_GET_WHERE_SQL', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40', 'PR_DM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH']
- G2 종속 PROGRAM_ID: 없음
- G4 NLS 스캔(동적 CAST AS DATE / 마스크 없는 TO_DATE): 0건 []
- G5 procedures.d.ts 블록 경계: L1069~L1154

## B_FE (0 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)


## FE_MERGE (1 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
화면에서 import 로 도달하는 파일(폐포 0본) 중 **기준선(4b740ab~1) 이후 변경분 ∩** = 아래. 화면이 참조하지 않는 변경 파일은 이 패키지에 넣지 않았다(이관 대상만).
- `procedures.d.ts.DMF0014_BLOCK.txt (L1069~L1154, 시트 키 ['spreadTitle', 'dayRange'])`
- `procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0014_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/**` 공용 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영. 공용 파일은 다른 화면(DMF0082/0021 등)의 변경도 함께 담고 있을 수 있다 — diff 로 판단.
- `apps/web/**`(mdi 셸·viewRegistry) 는 세대 혼재라 파일 단위 덮어쓰기 ⛔ — 본 패키지 제외.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): 없음

## _survey
- `fe_check_20260831.txt` — 작업 트리 전체 lint + type-check (사용자 상시 지시). 기준선 2026-08-23: type-check 123 / lint 79 (BACKUP 폴더·SDM1010 계약 충돌 등 기존 잔재).
- `survey.json` — 생성 근거 전문.

## [E20260831] C_TESTDATA — Excel Upload Validation 확인 세트

- `C_TESTDATA/cases/00_OK.xlsx ~ 18_MDL.xlsx` 19본 = 업로드용 단일 시트 (사내 실측 19/19 PASS — `C_TESTDATA/사내_실측_리포트_20260831.md`)
- `C_TESTDATA/DMF0014_ExcelUpload_ValidationCases_20260831.xlsx` = INDEX+대조용 (⚠ 업로드 금지 — BE 는 첫 시트만 읽음)
- 절차/기대값/시효(2026-09-06) = `C_TESTDATA/README_테스트절차.md`
- 90_VERIFY 말미 ANCHOR-1~4 = 기준행 마스터 앵커 존재 판정 (0 이면 00_OK 부터 마스터 오류 — 앵커 교체 필요)

## [E20260831] 0827 패키지 대비 핵심 delta

- `14_PROCEDURE_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql` : 0827 패키지(18:12 취합)에 담긴 것은 **구본** — 사내 20:14 재배포본으로 갱신 (본 패키지가 정본)
- 그 외 객체·메타 = 0827 과 동일 세대 (PKG BODY 08-27 16:51 등) — 재적용 무해(멱등)
- FE 미동봉 근거: customer-fcst-upload 6파일 = 2026-08-31 공통소스(클라우드 원천) 반영 시 ADOPT_COMMON/SAME 실측 — 클라우드가 동본 또는 최신
