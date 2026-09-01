# DMF0053_CLOUD_20260827 — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조)

생성 2026-08-27 18:30 · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_20260827.py DMF0053` (SELECT 만 — DDL/DML 실행 없음)
공통 수정분 = procedures.d.ts(DMF0053 계약 블록). C_DATA = CREATE_DATE 채움(2026-08-27 패키지 승계).
SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC 포함 — 기이관이면 diff 후 skip) → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE 배포) → `90_VERIFY`
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
| 01_DDL_GTT.sql | GTT 17본 (접두 ['GT_DM53', 'GT_DMF0053'] + ALL_DEPENDENCIES) |
| 10_PKG_DMF0053_SPEC.sql | SPEC [('PACKAGE', 'VALID', '2026-08-24 10:57'), ('PACKAGE BODY', 'VALID', '2026-08-27 10:53')] |
| 11_PKG_DMF0053_BODY.sql | BODY [('PACKAGE', 'VALID', '2026-08-24 10:57'), ('PACKAGE BODY', 'VALID', '2026-08-27 10:53')] |
| 12_FUNCTION_FN_GET_DM_MKT_OWNER_NAME.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 13_FUNCTION_FN_STRING_SPLIT.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 14_FUNCTION_UF_FX_STRING_SPLIT.sql | 의존 FUNCTION (기이관이면 skip 가능) |
| 20_MENU_WIRING_AUTH.sql | MERGE ON PK 실측 |
| 24_PROC_M.sql | 4 SP |
| 22_SHEET_META.sql | 시트 단위 재적재 |
| 25_EXCEL_COLUMNS.sql | 0행 |
| 26_LOOKUP_DETAIL.sql | 0행 |
| 21_CMBO_SQL.sql | 11본 (FE 요청 14: 미등재 [' ', 'CityCode', 'CountryCode']) |
| 23_MSG_LBL_MNU.sql | 45행 / 미존재 ['MSG_API_DMF0053_main_SEARCH', 'MSG_API_DMF0053_titleSet_SAVE', 'MSG_API_DMF0053_titleSet_SEARCH', 'MSG_API_DMF0053_title_SEARCH'] |
| 90_VERIFY.sql | 기대 카운트 실측 |

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
| 20:SCM_ADM_PROGRAM | 1 |
| 20:SCM_ADM_MNU_M | 1 |
| 20:SCM_ADM_USER_GR_MNU_MPG_M | 4 |
| 20:SCM_ADM_MNU_BTN_MPG_M | 4 |
| 20:SCM_ADM_USER_GR_MNU_BTN_MPG_M | 16 |
| 20:SCM_ADM_API_M | 4 |
| 24:DMF0002_GET_TITLESET_POPUP | 7 |
| 24:PKG_DMF0053.P_DMF0053_GET_CUST_FCST_WATERFALL | 25 |
| 24:PKG_DMF0053.P_DMF0053_GET_SPREAD_TITLE | 9 |
| 24:SCM0002_SET_TITLESET_POPUP | 14 |
| 22:SCM_MST_SHEET_COLUMNS:CUST Fcst Waterfall | 66 |
| 22:SCM_MST_SHEET_MEASURE:CUST Fcst Waterfall | 2 |

## B_FE (9 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
- `features/demand/src/pages/cust-fcst-waterfall/cust-fcst-waterfall.constants.ts`
- `features/demand/src/pages/cust-fcst-waterfall/cust-fcst-waterfall.types.ts`
- `features/demand/src/pages/cust-fcst-waterfall/CustFcstWaterfall.tsx`
- `features/demand/src/pages/cust-fcst-waterfall/index.ts`
- `features/demand/src/pages/cust-fcst-waterfall/useCustFcstWaterfallStore.ts`
- `features/demand/src/pages/cust-fcst-waterfall/__asis-mapping__.md`
- `features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallForm.tsx`
- `features/demand/src/pages/cust-fcst-waterfall/components/CustFcstWaterfallGrid.tsx`
- `features/demand/src/pages/cust-fcst-waterfall/utils/cust-fcst-waterfall.api.ts`

## FE_MERGE (2 — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
- `configs/types/procedures.d.ts`
- `procedures.d.ts.DMF0053_BLOCK.txt (추출 L4572~L4581)`
- `configs/types/procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.DMF0053_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/shared/**` 공용 컴포넌트 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영.
- 피처 스캐폴드(`features/report/package.json` 등) → 클라우드에 해당 피처가 이미 있으면 skip.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): ['features/master/src/components']

## 이관 유의 (2026-08-27 세션 변경분)
- **PKG_DMF0053 BODY** 10:53 판 — `[E20260827-ITEMSTAT]`(81 25분+→2.2s) + `[E20260827-MEASALWAYS]`. **22_SHEET_META** 에 MEASURE `VISIBLE_FLAG='Y'`·`DEFAULT_FLAG='Y'`(14:44 정정) 반영.
- **C_DATA** `[E20260827-CFHCD]` — `DM_PLN_CUST_FCST_H.CREATE_DATE` NULL 채움: `python load_create_date_from_csv.py`(환경변수 NSCM_ORA_* = 클라우드) · NULL-only UPDATE 멱등. **메인 SP Input Date 필터가 이 컬럼을 보므로 미적용 시 전 사용자 0행.**
- **B_FE 화면 폴더 전체** — 오늘 변경: F6 복원 + 드릴다운 가시성 state 화. **FE_MERGE**: `procedures.d.ts` → `_BLOCK.txt` 만 이식. MNU ROUTE(`cust-fcst-waterfall`)는 `20_MENU_WIRING_AUTH` 포함 — **B_FE 배포 후** 실행.
- EDI 원장은 81 계열 전용(40/82 0행 정상). SCP Planner 메뉴권한 미등재 — 운영 결정.
## 30~ standalone SP (API_M 배선, PKG 밖) — 2026-08-27 보강
- 30_PROCEDURE_DMF0002_GET_TITLESET_POPUP.sql (VALID 2026-08-22 12:59) 의존 ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER']
- 31_PROCEDURE_SCM0002_SET_TITLESET_POPUP.sql (VALID 2026-08-07 19:37) 의존 ['TABLE:SCM_MST_SHEET_COLUMNS', 'TABLE:SCM_MST_TITLESET_USER', 'FUNCTION:SCM_ARR_SPL_CNT', 'FUNCTION:SCM_ARR_SPL_VAL', 'PROCEDURE:PR_SCM_SYS_LOG_BATCH']

## 40_GRANT_SYNONYM.sql — 앱 계정 EXECUTE + 시노님 (2026-08-27 보강)
- 대상 6: ['PKG_DMF0053', 'FN_GET_DM_MKT_OWNER_NAME', 'FN_STRING_SPLIT', 'UF_FX_STRING_SPLIT', 'DMF0002_GET_TITLESET_POPUP', 'SCM0002_SET_TITLESET_POPUP']
- 사고: DMF0040 클라우드 SCMP_APP 에 PKG_DMF0040 EXECUTE 부재 → 화면 SQL ERROR (SCM_MGR 재현은 정상). 10~32 적용 후 **반드시** 실행.
