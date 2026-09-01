# DMF0074_CLOUD_20260831 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조 · 이관 대상만)

생성 2026-08-31 13:48 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260831.py DMF0074` (SELECT 만 — DDL/DML 실행 없음)
[E20260831] Excel Upload Validation 클라우드 확인용 재취합. DB = 사내 라이브 현재 기준 전량 (BODY 08-27 16:17 — D4/D5 정정·D4-NOLOADGUARD 포함). FE = 이관 제외: metal-link-price 모달 2본+store 2본은 2026-08-31 공통소스(클라우드 원천) 반영에서 ADOPT_COMMON/ADD 실측 — 클라우드가 동본 또는 최신. ⚠ 데이터 전제: MAX(SP_W·ATTRIBUTE7=Y) 버전에 SPW 원장(PLAN_C/RESULT_C) 실존해야 C19 계열·화면 조회 가능(90_VERIFY ANCHOR 판정).
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외
⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 (2026-08-04 사용자 확정).

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC·FUNCTION 포함 — 기이관이면 diff 후 skip) → **`40_GRANT_SYNONYM`** → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `22A_SHEET_META_DEP_PROGRAMS` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE / FE_MERGE 배포) → `90_VERIFY`(V11~V14 포함, `<TEST_USER>` 치환)
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 17본 (접두 ['GT_DM74'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0074_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-10 20:46'), ('PACKAGE BODY', 'VALID', '2026-08-27 16:17')] |
| 11_PKG_DMF0074_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-10 20:46'), ('PACKAGE BODY', 'VALID', '2026-08-27 16:17')] |
| 12_FUNCTION_FN_NEXT_DAY.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 13_PROCEDURE_PR_SCM_SYS_LOG_BATCH.sql | 의존 PROCEDURE (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 4 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 22A_SHEET_META_DEP_PROGRAMS.sql | 종속 PROGRAM_ID [] / 0행 |
| 25_EXCEL_COLUMNS.sql | 2행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 1본 (FE 요청 1: 미등재 []) |
| 23_MSG_LBL_MNU.sql | 69행 / 미존재 ['MSG00049', 'MSG00427', 'MSG_API_DMF0074_MAIN_EXCEL', 'MSG_API_DMF0074_MAIN_FILTER', 'MSG_API_DMF0074_MAIN_SAVE', 'MSG_API_DMF0074_MAIN_SEARCH', 'MSG_API_DMF0074_MAIN_SORT', 'MSG_API_DMF0074_MAIN_UPLOAD', 'MSG_API_DMF0074_TEMPLATE_SEARCH', 'MSG_API_DMF0074_VERSION_SEARCH'] |
| 40_GRANT_SYNONYM.sql | 대상 3: ['PKG_DMF0074', 'FN_NEXT_DAY', 'PR_SCM_SYS_LOG_BATCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 + V11~V14 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 3 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 9 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 24 |
| 20:SCM_ADM_API_M | 8 |
| 24:DMF0073_GET_VERSION_SALESPRICE | 9 |
| 24:PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD | 5 |
| 24:PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE | 14 |
| 24:PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE | 5 |
| 22:SCM_MST_SHEET_COLUMNS:DMF0074/Metal Link Price | 58 |

## 게이트 (hook #148 생성기 의무)
- G1 GRANT/시노님 대상 3: ['PKG_DMF0074', 'FN_NEXT_DAY', 'PR_SCM_SYS_LOG_BATCH']
- G2 종속 PROGRAM_ID: 없음
- G4 NLS 스캔(동적 CAST AS DATE / 마스크 없는 TO_DATE): 0건 []
- G5 procedures.d.ts 블록 경계: L588~L689

## B_FE (0 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)


## FE_MERGE (1 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
화면에서 import 로 도달하는 파일(폐포 0본) 중 **기준선(4b740ab~1) 이후 변경분 ∩** = 아래. 화면이 참조하지 않는 변경 파일은 이 패키지에 넣지 않았다(이관 대상만).
- `procedures.d.ts.DMF0074_BLOCK.txt (L588~L689, 시트 키 ['template', 'version'])`
- `procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0074_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/**` 공용 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영. 공용 파일은 다른 화면(DMF0082/0021 등)의 변경도 함께 담고 있을 수 있다 — diff 로 판단.
- `apps/web/**`(mdi 셸·viewRegistry) 는 세대 혼재라 파일 단위 덮어쓰기 ⛔ — 본 패키지 제외.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): 없음

## _survey
- `fe_check_20260831.txt` — 작업 트리 전체 lint + type-check (사용자 상시 지시). 기준선 2026-08-23: type-check 123 / lint 79 (BACKUP 폴더·SDM1010 계약 충돌 등 기존 잔재).
- `survey.json` — 생성 근거 전문.

## [E20260831] C_TESTDATA — Excel Upload Validation 확인 세트 (49 업로드 파일 + INDEX)

- 절차·데이터 전제(⚠ SPW 원장)·시효(Plan Date 202610) = `C_TESTDATA/README_테스트절차.md`
- 기대값 = 실측 기준 정정본 (01_C2=SKIP 정상 / 53_GATE=수동 축 / 순서 마스킹·사문 비고 유지)
- 90_VERIFY 말미 ANCHOR-1(MRF 버전 SPW 원장)·ANCHOR-2(기준행 조합)·ANCHOR-3(룩업/환율/EXCEL_COLUMNS) = 테스트 가능 상태 선판정

## [E20260831] 배선 역추적 보강 (§4.7-B)

- `14_PROCEDURE_DMF0073_GET_VERSION_SALESPRICE.sql` 추가 — Version 팝업 SP (PROC_M 9행 배선 실존·객체 부재 시 PLS-00306 계보) + 40_GRANT_SYNONYM 에 GRANT/시노님 추가
