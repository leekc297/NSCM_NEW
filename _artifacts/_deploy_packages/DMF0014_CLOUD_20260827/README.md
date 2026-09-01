# DMF0014_CLOUD_20260827 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조)

생성 2026-08-27 18:12 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py DMF0014` (SELECT 만 — DDL/DML 실행 없음)
FE 는 오늘 수정 파일 1본만(사용자 지시). DB 는 현재 기준 전량.
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC 포함 — 기이관이면 diff 후 skip) → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE 배포) → `90_VERIFY`
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
| 25_EXCEL_COLUMNS.sql | 1행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 3본 (FE 요청 4: 미등재 [' ']) |
| 23_MSG_LBL_MNU.sql | 81행 / 미존재 ['MSG_API_DMF0014_DAY_RANGE_SEARCH', 'MSG_API_DMF0014_MAIN_DELETE', 'MSG_API_DMF0014_MAIN_EXCEL', 'MSG_API_DMF0014_MAIN_FILTER', 'MSG_API_DMF0014_MAIN_INSERT', 'MSG_API_DMF0014_MAIN_SAVE', 'MSG_API_DMF0014_MAIN_SEARCH', 'MSG_API_DMF0014_MAIN_SORT', 'MSG_API_DMF0014_MAIN_UPLOAD', 'MSG_API_DMF0014_SPREAD_TITLE_SEARCH', 'MSG_API_DMF0014_UPLOAD_SAVE'] |
| 90_VERIFY.sql | 기대 카운트 실측 |

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
| 22:SCM_MST_SHEET_COLUMNS:FCST Upload | 15 |

## B_FE (1 파일 — 실경로 `nscm-fe/` 기준 구조 보존)
- `features/demand/src/pages/customer-fcst-upload/components/CustomerFcstTemplateModal.tsx`

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): ['features/master/src/components', 'features/master/src/components/searchFields/SearchFields.debug']
`configs/types/procedures.d.ts` 는 전체 교체 파일 — 클라우드판과 diff 후 해당 화면 블록만 병합 권장.

## 이관 유의 (2026-08-27 세션 변경분)
- **PKG_DMF0014 BODY** `[E20260827-EXCELFORM-HDRONLY]` — Excel Form 이 헤더 캐리어 1행만 반환(데이터 0). 08-23 GRAYZERO·BUCKETNLS 판 위에 누적된 **사내 라이브 전체 덤프**라 통째 교체하면 이전 미적용분도 함께 올라간다.
- **B_FE 1파일** `CustomerFcstTemplateModal.tsx` — 헤더 캐리어 행을 데이터로 내보내지 않음. SP 만 올리면 양식에 빈 데이터 1행이 생기므로 반드시 함께 배포.
- `23_MSG_LBL_MNU` 의 "미존재 코드" `MSG_API_DMF0014_*` = API_M.API_MSG_ID 참조값이 사내 MSG_M 에도 없음(종전 패키지와 동일 상태·화면 무영향).
- 화면 폴더 외 의존 `features/master/src/components/searchFields/SearchFields.debug.ts` 는 클라우드 공통소스에 있어야 함(부재 시 별도 이관).
## 30~ standalone SP (API_M 배선, PKG 밖) — 2026-08-27 보강
- 30_PROCEDURE_PR_GET_DAY_RANGE.sql (VALID 2026-07-21 16:39) 의존 ['TABLE:SCM_SYS_CALENDAR_M', 'TABLE:TB_FX_USER', 'FUNCTION:FN_MULTY_TIME']

## 40_GRANT_SYNONYM.sql — 앱 계정 EXECUTE + 시노님 (2026-08-27 보강)
- 대상 7: ['PKG_DMF0014', 'FN_SCM_GET_WHERE_SQL', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST', 'PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40', 'PR_DM_SYS_LOG_BATCH', 'PR_SCM_SYS_LOG_BATCH', 'PR_GET_DAY_RANGE']
- 사고: DMF0040 클라우드 SCMP_APP 에 PKG_DMF0040 EXECUTE 부재 → 화면 SQL ERROR (SCM_MGR 재현은 정상). 10~32 적용 후 **반드시** 실행.

## 14_PROCEDURE_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40.sql 재생성 — [E20260827-NLSDATE] (사내 적용 VALID)
- DMF0040 클라우드 ORA-01861 사고(세션 NLS_DATE_FORMAT 의존 `CAST(VARCHAR2 AS DATE)`)와 동일 패턴 1곳: `CAST(A.SUMMARY_BUCKET_VALUE AS DATE)` → `TO_DATE(A.SUMMARY_BUCKET_VALUE,'YYYYMMDD')` (hook #109). 클라우드 BE 세션(DD-MON-RR)에서 WEEKLY 버킷 처리 시 동일 실패 예정이었음.
