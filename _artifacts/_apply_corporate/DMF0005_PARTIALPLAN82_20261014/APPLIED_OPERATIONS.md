# DMF0005 82 Sheet — PARTIAL_PLAN_YN 컬럼 표시 [PARTIALPLAN82 / E20261014-DMF0005PARTIALGET]

- 대상 DB : 사내 ZIOUI1 (59.19.252.148:2521, SERVER_HOST=localhost) / SCM_MGR
- 클라우드 : 미적용 (아래 1 · 2 둘 다 필요)

## 실행 작업 ↔ 파일

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 10-14 10:08:48 | `SCM_MST_SHEET_COLUMNS` 에 DMF0005 / production_82 / PARTIAL_PLAN_YN 1행 추가 (MERGE, 없을 때만 INSERT) + COMMIT | `01_MERGE_SHEET_COLUMNS_PARTIAL_PLAN_YN.sql` | 1행 추가 · 재실행 시 변화 없음 |
| 2 | 10-14 10:15:49 | `PKG_DMF0005` BODY 재생성 — 조회 프로시저에 2줄 추가 | `01_PKG_DMF0005_BODY.sql` (생성 · 적용 = `build_apply.py`) | VALID · 오류 0 |
| - | - | 원복 (미실행) | 메타 `99_ROLLBACK_SHEET_COLUMNS_PARTIAL_PLAN_YN.sql` · BODY `00_BACKUP_PKG_DMF0005_BODY.sql` | - |

권한 · 시노님 · SPEC · 별도 재컴파일 작업 없음.

## 1. Sheet 메타 — 값의 근거

- 원천 = 같은 화면 기존 행 DMF0005 / Production / PARTIAL_PLAN_YN (DIVISION_ID '82', 적용 직전 재조회 값과 동일)
- 원천 그대로 : 라벨 `Partial Plan YN` · 순서 259 · 정렬 ASC · 폭 80 · FPComboBox / YesOrNo · 가운데 정렬 · VISIBLE Y · DEFAULT Y · USER_SELECTABLE Y · VALID Y · INPUT_TP_CD S
- production_82 Sheet 기존 27행과 같게 둔 것 : DIVISION_ID · SMALL_CLASS_LABEL_NAME · LARGE_CLASS_LABEL_NAME = NULL (원천은 '82' / 'Partial Plan YN' / NULL)
- 감사 컬럼 : admin / SYSDATE

## 2. 조회 프로시저 — P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION

- 기준본 = 10-14 10:15 사내 ALL_SOURCE 재조회 (BODY LAST_DDL 2026-10-13 17:13:18) · 적용 직전 재조회 일치 확인 후 적용
- 추가 2줄 (기존 줄 무변경 — 추가 줄을 빼면 원문과 동일, 1,990줄 → 1,992줄)
  - 200행 `, SI.PARTIAL_PLAN_YN` — BASE 목록 끝
  - 407행 `, BF.PARTIAL_PLAN_YN` — 최종 SELECT 끝 (중간 BF 는 `SELECT B.*` 라 그대로 전달)
- AS-IS `DMF0005_GET_SALES_SITE_MODEL_PRODUCTION` 과 같이 원장 값을 그대로 반환 (`SITE_ITEM.PARTIAL_PLAN_YN`)
- 조회 결과 컬럼이 맨 끝에 1개 늘어난다 (52 → 53). 81 · 40 도 같은 프로시저라 컬럼은 내려가지만 Sheet 메타가 없어 화면에는 나오지 않는다.

## 검증

| 항목 | 결과 |
|---|---|
| 메타 적용 전 → 후 | production_82 27행 → 28행 · 다른 Sheet 행 수 변화 없음 · 재실행 28행 유지 |
| `PR_GET_SHEET_COLUMN_LIST('minyonglee1','DMF0005','production','82')` | 28행 · PARTIAL_PLAN_YN 포함(27번째, Update By 다음 · MDM Active 앞) / 81 · 40 호출에는 없음 |
| BODY 적용 | PACKAGE BODY VALID · USER_ERRORS 0 · DB 원문 = 적용본 · SCM_MGR INVALID 63 → 63 |
| 조회 전후 비교 (`test_call.py`, 조회조건 없음 · Active ALL) | 82 38,621행 · 81 42,088행 · 40 15,569행 — 행 수 · 기존 52컬럼 값 · 순서 모두 동일 |
| 새 컬럼 값 | 원장 `SCM_MST_SITE_ITEM.PARTIAL_PLAN_YN` 과 다른 행 0 · 82 = Y 3,868 / N 34,753 · 81 · 40 = 전부 N |

## 미실행

- 화면 확인 (BE · FE 경유)
- 클라우드 적용
