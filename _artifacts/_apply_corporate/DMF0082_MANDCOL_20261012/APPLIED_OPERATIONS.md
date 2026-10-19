# DMF0082_MANDCOL — 사내 ZIOUI1 적용 기록 (2026-10-12)

마커 `[E20261012-DMF0082MANDCOL]` · 대상 `SCM_MGR.PKG_DMF0082` PACKAGE BODY (`P_DMF0082_GET_MAIN_DATA` 숨김 판정 2곳)

## 기준 원문
- 조회 DB ZIOUI1 · 조회 2026-10-12 18:10 · BODY LAST_DDL 2026-10-12 16:31:39 (15:56 조회본과 내용 동일 — 16:31 은 재컴파일만)
- 백업 `00_BACKUP_PKG_DMF0082_BODY.sql` · 적용본 `01_PKG_DMF0082_BODY.sql` (원문 대비 추가 33줄, 삭제·변경 0줄)

## 실행한 작업
| 시각 | 작업 | 결과 |
|---|---|---|
| 18:10 | `build_apply.py build` | 17,040 → 17,073줄 · 마커 2 |
| 18:16:54 | `build_apply.py apply` | FRESH-GATE PASS · DB==적용본 · VALID · USER_ERRORS 0 · SCM_MGR INVALID 7 → 7 |
| 18:22~18:23 | 클라우드 패키지 리허설 (99 → 00 → 90 → 10 → 90 → 00) | 왕복 PASS · 최종 상태 = 적용 (LAST_DDL 18:23:13 · 마커 2) |

권한·시노님·메타·데이터 변경 없음.

## 전후 비교 (`test_mandcol.py`, 그리드 결과 전행)
| 케이스 | 적용 전 | 적용 후 | 판정 |
|---|---|---|---|
| A · 40 · k0101 (저장 내역에 CELL_PROD_SITE_ID 없음) | 6,913행 · 같은 키에 Cell Prod 2개↑ 0 | 7,095행 · 185 | 변경 (의도) — LOC/KRW/USD 2,099 → 2,158 |
| B · 40 · candoism (CELL_PROD_SITE_ID 있음) | 7,418행 | 7,418행 | 전행 동일 |
| C · 81 · eunah.koo (PLANT_SITE_ID 없음 · 81 은 필수) | 3,061행 · Plant 2개↑ 0 | 3,128행 · 64 | 변경 (의도) — LOC 2,316 → 2,383 |
| D · 40 · eunah.koo (PLANT_SITE_ID 없음 · 40 은 필수 아님) | 3,705행 | 3,705행 | 전행 동일 |

## 미실행
- 화면(브라우저) 확인 미실행.
- 클라우드 미적용 — 패키지 `_deploy_packages/DMF0082_MANDCOL_CLOUD_20261012/`.
