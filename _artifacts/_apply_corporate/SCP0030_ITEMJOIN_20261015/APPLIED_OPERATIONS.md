# SCP0030 조회 TIMEOUT — [E20261015-SCP0030ITEMJOIN] 적용 기록 (사내 ZIOUI1 · 2026-10-15)

## 접속
- DB = 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR

## 작업 ↔ 파일
| # | 작업 | 파일 | 결과 |
|---|---|---|---|
| 1 | PKG_SCP0030 BODY 착수 원문 조회(LAST_DDL 2026-10-15 09:08:26 VALID, 1026줄) | `_artifacts/_diagnostics/SCP0030_PERF_20261015/PKG_SCP0030_PACKAGE_BODY.ASIS.sql` | 원복 기준본 |
| 2 | 변형 벤치(DB 객체 무변경, 익명 블록) | `_diagnostics/SCP0030_PERF_20261015/bench_get_bod_item.py` · `plan_compare.py` | 6조건 행 집합 해시 동일 |
| 3 | P_SCP0030_GET_BOD_ITEM Model/Nickname 조건 EXISTS → JOIN (3곳 외과 치환, FRESH-GATE 통과) | `apply_itemjoin.py --apply` | 15:03:54 VALID · ALL_ERRORS 0 · DB==TOBE · SCM_MGR INVALID 65→65 |
| 4 | 적용 후 동등성(11조건, 실제 PKG vs 적용 전 원문) | `verify_after.py` | DIFF 0 |
| 5 | 클라우드 검증 SQL(조회 전용) 사내 사전 실행 | `CLOUD_VERIFY_SCP0030_GET_BOD_ITEM.sql` | C01~C07 오류 0 |

## 원복
- `PKG_SCP0030_PACKAGE_BODY.ASIS.sql` 앞에 `CREATE OR REPLACE ` 를 붙여 실행(적용 직전 원문). 그 사이 다른 변경이 있으면 3곳만 역치환.

## 실측 요약
- 전체 조회 289,551행. DB 단독(V$SQL 평균, 같은 조건 묶음) 4.38s/109K buffers → 3.18s/76K, 전체 조회 CONCATENATION 1 → 0
- BE 실측 fetch 1회 100행(V$SQL FETCHES 2,896) — 100행 38.5s / 1000행 9.9s / 2000행 9.6s (사내 원격 실측)
