# CELL_PROD_SITE_ID 빈값 = '-' (AS-IS 파리티) — 사내/클라우드 공용 패치형 패키지

> 마커 `[E20261027-CELLPRODDASH]` · CELL_PROD_SITE_ID **한 컬럼만** (다른 컬럼 무변경)

| 항목 | 값 |
|---|---|
| 증상 | 클라우드 DMF0082 조회 시 같은 키가 실적/계획 2줄 (81 BMW_US_SPA · A18BW2003 · APBMW48CL-B1-360 · MKT FCST[R+P]) |
| 원인 | 실적 원장 `DM_PLN_SALES_PLAN_RESULT.CELL_PROD_SITE_ID` = `'/'` (TO-BE DEFAULT ON NULL '/' · 실적 매핑 `ELSE '/'`) vs 계획 arm 리터럴 `'-'` → Cell Prod Site 를 표시한 계정에서 줄 분리 (클라우드 V01 진단 실측) |
| AS-IS (LGCE_SCMDEV 실측) | 전 사업부 빈값 `'-'` — 원장 DEFAULT '-'(SALES_PLAN·SALES_PLAN_RESULT·MKT_FCST_RESULT) · DMF0082 81 계획 arm '-' · 실적 매핑 ELSE '-'(L934·L1158) · 40 은 '-' = Common 코드 · 데이터 '/' 0건 |
| 사내 적용 | **완료** ZIOUI1 2026-10-27 15:05 로직 → 15:11 DEFAULT·데이터 → 리허설 원복·재적용 15:15 · [APPLIED_OPERATIONS.md](../../_apply_corporate/CELLPROD_SLASH_20261027/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| BE 재기동 · FE | 불요 |

## 실행 순서 (SCM_MGR · 각 파일 전체 F5 · 값 입력 없음)
| # | 파일 | 내용 / 기대 |
|---|---|---|
| 1 | A_DB/00_PRECHECK.sql | P1 PKG앵커 `2 PASS` · P1 MAP줄 `SELECT_2=2 · GROUPBY_1=1` · P3 테이블별 DEFAULT · `'/'` 행 수 |
| 2 | A_DB/10_APPLY_LOGIC_PATCH.sql | `APPLIED — PKG_DMF0082 VALID` · `APPLIED — PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING VALID` (적용돼 있으면 SKIP) |
| 3 | A_DB/20_ALTER_DEFAULT.sql | DEFAULT `'/'` 테이블마다 `ALTERED … '/' → '-'` · 끝에 `의존 객체 재컴파일 완료 · 실패 0` |
| 4 | A_DB/30_DATA_SLASH_TO_DASH.sql | `전환 n / 대상 n` (먼저 파일 안 `c_dry_run` 을 `'Y'` 로 바꿔 건수·PK 충돌만 볼 수 있음) |
| 5 | A_DB/90_VERIFY.sql | 마커 PKG 2 · MAPPING 3 · VALID/ERR 0 · 전 테이블 DEFAULT `'-'` · `합계 '/'행 0` |

원복: 99_ROLLBACK_1_DATA → 99_ROLLBACK_2_DEFAULT → 99_ROLLBACK_3_LOGIC (역순). 데이터는 기록 테이블 `ZZ_CELLPROD_DASH_DATA_20261027`(ROWID·이전 값), DEFAULT 는 `ZZ_CELLPROD_DASH_DFLT_20261027` 기준.

## 내용
1. **PKG_DMF0082** — GET_MAIN_DATA · GET_MAIN_DATA_CURRENT 의 `[E20261013-DMF0082AFSSHARE]` 직전에 조회용 임시 테이블 `CELL_PROD_SITE_ID` `'/'`·공백 → `'-'` 1문장씩. 원장에 `'/'` 가 남아 있어도 한 줄.
2. **PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING** (실적 생성) — CELL_PROD_SITE_ID CASE `ELSE '/'` 3곳(SELECT 2 · GROUP BY 1) → `'-'` (2026.10.11 변경분을 AS-IS 로 복원 · 원래 '-' 주석 줄은 그대로 둠).
3. **DEFAULT** — CELL_PROD_SITE_ID DEFAULT `'/'` 인 테이블(사내 21개: DM_PLN_SALES_PLAN(_C/_C_KEEP/_H) · SALES_PLAN_RESULT(_C/_C_KEEP) · MKT_FCST_RESULT(_C/_C_KEEP) · CFM_MKT_DEMAND_PLAN(_C/_C_KEEP/_H) · CFM_SELLING_PRICE(_C/_C_KEEP/_H) · DEMANDID_PEGGING · DEMAND_CHANGE_STATUS · NET_DEMAND) → `'-'` (ON NULL 유지). 이 컬럼을 빼고 INSERT 하는 적재도 `'-'` 가 된다.
4. **데이터** — CELL_PROD_SITE_ID `'/'`·공백 → `'-'` (전 사업부). 사내 82 DM_PLN_SALES_PLAN 39,835건 · PK 충돌 0.

## 주의
- **20 은 테이블 DDL** — 그 테이블을 쓰는 PKG/PROC 가 INVALID 가 된다(사내 17개). 스크립트가 실행 전 VALID 이던 객체만 재컴파일하고 실패 목록을 출력한다. 실행 중 세션은 ORA-04068 이 날 수 있으니 **배치·화면 사용이 적을 때** 실행.
- 30 은 전 테이블 1회 전체 조회(수천만 행 _C 포함) — 시간이 걸린다. 바꾸는 행만 기록·갱신.
- 패치형 — 10 은 이 DB 의 USER_SOURCE 위 치환. 앵커가 다르면 해당 객체만 중단(원문 무변경) → 00 P1 결과 회신.
- **범위 밖(미변경)**: `'/'` 를 CELL_PROD 에 쓰는 다른 로직 — `PR_DM_LONGPLAN_40_DELETE_IMPORT`(40 장기계획 import · `THEN '/' ELSE '/'` 4곳, AS-IS '-') 등. 필요 시 별도 요청.

## 리허설 (사내 ZIOUI1 2026-10-27, `_rehearsal_out/`)
00 → 10(SKIP) → 30 DRY(대상 39,835 · 충돌 0) → 20(21개) → 30(39,835) → 90(PASS · 단 PKG BODY INVALID 발견) → 99_1(39,835 복원) → 99_2 → 99_3(ROLLED BACK) → 90(마커 원복 · '/' 39,835 복귀) → 10 → 20 → 30 → 90.
INVALID 발견 후 20/99_2 에 재컴파일 추가 → 99_2 → 20(재컴파일 실패 0) → 90 PASS · INVALID 총수 46 = DDL 전과 동일.
최종 사내 원문 == 사내 적용본(01) 2객체 True.

## 추가 (2026-10-27 17:30) — _C 2개 테이블 PK 충돌 정리
클라우드 30 실행 시 `DM_PLN_MKT_FCST_RESULT_C` · `DM_PLN_SALES_PLAN_RESULT_C` 가 PK 충돌로 건너뜀 → [A_DB/_CHECK_PK_CONFLICT_C.sql](A_DB/_CHECK_PK_CONFLICT_C.sql) 점검 결과
충돌 1,982 · 48,014 쌍 **전부 QTY 동일**(scm_batch 가 10-13~10-21 같은 컷오프를 '-' · '/' 로 두 번 적재 = 완전 중복, 키 합산 시 2배).

| # | 파일 | 기대 |
|---|---|---|
| 6 | A_DB/25_DEDUP_C_PK_CONFLICT.sql | D0 오늘 생긴 '/' 행·DEFAULT 확인 → D1 테이블별 `중복(QTY 같음) n` · `QTY 다름 0` · `백업 n → ZZ_CPD_*_DUP_20261027 · 삭제 n` |
| 7 | A_DB/30_DATA_SLASH_TO_DASH.sql (재실행) | 두 테이블 남은 '/' 행(212 · 600) `전환` |
| 8 | A_DB/90_VERIFY.sql | `합계 '/'행 0` |

- 25 는 같은 키에 QTY 가 같은 '-' 행이 있는 '/' 행만 지운다('-' 유지). QTY 가 다른 쌍은 지우지 않고 건수만 출력(회신).
- 지운 행은 백업 테이블에 전 컬럼 보존. 백업 건수 ≠ 삭제 건수면 전체 취소.
- 원복 순서: 99_ROLLBACK_1_DATA → **99_ROLLBACK_0_DEDUP** → 99_ROLLBACK_2_DEFAULT → 99_ROLLBACK_3_LOGIC
- 사내 검증: 각 테이블에 '/' 모의 중복 1행 → 25 DRY(1) → 25(백업 1·삭제 1) → 25 재실행(0) → 99_0(1행 복원) → 모의 행·백업 테이블 정리 (사내 '/' 잔존 0)
