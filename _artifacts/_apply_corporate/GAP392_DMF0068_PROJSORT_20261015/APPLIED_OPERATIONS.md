# GAP392 DMF0068 Demand Manager 정렬(대소문자 무시) — 사내 ZIOUI1 적용 기록 (2026-10-15)

- DB: 59.19.252.148:2521/ZIOUI1 (SERVER_HOST=localhost) · 계정 SCM_MGR
- 기준 원문: 착수 시 ALL_SOURCE 재조회 · PKG_DMF0068 BODY LAST_DDL 2026-10-10 12:38:28 VALID (1,483줄) → `PKG_DMF0068_BODY.ASIS_20261015_195921.sql`
- AS-IS 대조: LGCE_SCMDEV(LESDFPSTO1C01, 콜레이션 `Latin1_General_CI_AS`) 직접 조회 — `DMF0068_GET_LOOKUPPROJECT` L65 `ORDER BY SEGMENT1` · `DMF0068_GET_ORDERLIST` L338/L469 `ORDER BY B.PROJECT_NAME, ISNULL(ORDERSTART,'999999'), B.MEASURE` → **정렬 문구는 TO-BE 와 동일, 차이는 콜레이션(CI vs BINARY)**
- 재현 파라미터: SCM_COM_SQL_LOG 10-15 15:10 FE 실전송값 (divisionId 40 · versionNo R_S_20260823_V003 · fromDt 202501 · toDt 202712), 사용자 minyonglee1
- AS-IS 순서 판정: TO-BE 가 돌려준 값 목록을 AS-IS DB 에서 `ORDER BY v COLLATE Latin1_General_CI_AS` 로 정렬한 순서와 위치 대조 (`repro.py`)

| # | 시각 | 작업 | 파일 | 결과 |
|---|---|---|---|---|
| 1 | 19:58:52 | 수정 전 재현 | `repro.py before` → `before.out.txt` | Project 콤보 35건 중 **12건**, 조회 결과 36세트 중 **6세트** 위치 다름 (GAP 기재와 일치) |
| 2 | 19:59:21 | PKG_DMF0068 BODY 패치(FRESH-GATE 통과, L1 1 · O1 2) | `apply_corp.py apply` → `apply.out.txt` / 적용본 `PKG_DMF0068_BODY.TOBE_20261015_195921.sql` | VALID · 오류 0 · 의존 INVALID 0 |
| 3 | 19:59:23 | 수정 후 검증 | `after.out.txt` | 두 목록 모두 위치 다름 **0건** · 행 수 72행/36세트 전후 동일 |
| 4 | 20:03~20:05:01 | 클라우드 패키지 리허설 | `_deploy_packages/DMF0068_GAP392_PROJSORT_CLOUD_20261015/_rehearsal_out/` | 99 원복 md5 = 수정 전 `26854a30…` · 10 재적용 md5 = 적용본 `8a7d892d…` |
| 5 | 20:06:24 | 최종 상태 재확인 | `final.out.txt` | 위치 다름 0건 (LAST_DDL 20:05:01, 내용 = #2 적용본) |

변경 3곳 (마커 `[GAP392 2026-10-15]`):
- `P_DMF0068_GET_LOOKUPPROJECT` — `ORDER BY SEGMENT1` → `ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1`
- `P_DMF0068_GET_ORDERLIST` 동적 SQL 2분기(SALES_PLAN·BIZ_PLAN) — `ORDER BY B.PROJECT_NAME, …` → `ORDER BY UPPER(B.PROJECT_NAME), B.PROJECT_NAME, …`

원복: `python apply_corp.py rollback` 또는 패키지 `A_DB/99_ROLLBACK_GAP392_PATCH.sql`.
