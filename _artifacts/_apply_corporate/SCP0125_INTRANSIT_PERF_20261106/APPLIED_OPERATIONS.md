# SCP0125 해상재고 적재 속도 — 사내 ZIOUI1 적용 기록 (2026-11-06)

| 항목 | 값 |
|---|---|
| 대상 | SCM_MGR.PKG_SCP0125 PACKAGE BODY · P_LOAD_STOCK 의 `INSERT INTO GT_0125_INTRANSIT_V` 1문장 |
| 기준 원문 | ALL_SOURCE 조회 2026-11-06 16:07:52 (LAST_DDL 2026-11-04 14:48:44) → `PKG_SCP0125_BODY.ASIS.sql` |
| 적용 | `python -I apply.py` 2026-11-06 17:46:58 · FRESH-GATE 일치 · CREATE OR REPLACE |
| 적용 후 | LAST_DDL 2026-11-06 17:46:59 · VALID · ALL_ERRORS 0 · 적용본 = DB 원문 True · INVALID(SCP0125) 없음 (`apply_result.json`) |
| 원복 | `python -I apply.py --rollback` (현재 DB = TOBE 일 때만 ASIS 로) |

## 변경 내용
공용 뷰 `SCM_DNM_INTRANSIT_V` 를 직접 읽던 문장을, 뷰의 I · C 갈래 원문(LAST_DDL 2026-10-09 13:38:41)을 펼쳐 사업부 · 기준일 조건을 갈래 안에 넣은 문장으로 교체.
`NO_PUSH_PRED(B)` / `NO_PUSH_PRED(C) NO_PUSH_PRED(D)` 힌트 — 첫 실행 값으로 굳는 중첩 반복 계획(사내 실측 7~9초) 방지. 뷰 자체는 변경 없음.

## 검증 (실측)
- 결과 동등성: `cmp_select.py new_select_hint.sql cmp_result_hint.txt` — 337 조합(2026-07-01 이후 데이터 있는 사업부×기준일 + 데이터 없는 기준일 20) **같음 337 · 다름 0** (행 다중집합 비교, 17:46:46 완료). 평균 기존 1.31s → 대체 0.173s.
- 프로시저 측정 (`_diagnostics/_scp0125_perf/prof.py`, 17:47~17:50, 커서 준비 후):

| 프로시저 | 사업부/기준일 | 적용 후 total | 해상재고 문장(1354행) |
|---|---|---|---|
| P_SCP0125_GET_STOCK_ADJ | 81/20260824 | 2.66~2.78s (적용 직후 첫 실행 4.04s = 커서 최초 해석 1.32s 포함) | 0.08s |
| P_SCP0125_GET_STOCK_ADJ | 82/20260824 | 1.73~1.86s | 상위 3 밖 |
| P_SCP0125_GET_STOCK_ADJ | 40/20260824 | 0.90~0.93s | 0.23s |
| P_SCP0125_GET_STOCK_ADJ_UC | 81_UC/20260907 | 0.46~0.49s | — |
| P_SCP0125_GET_STOCK_ELEC_PLNT | 81/20260824 | 0.57s | — |
| P_SCP0125_GET_STOCK_ELEC_UC | 81_UC/20260907 | 0.13~0.15s | — |
| P_SCP0125_GET_STOCK_SECOND_OCV | 81/20260824 | 1.21~1.24s | — |

- 적용 전 같은 문장(사내): 1.3~2.5s/호출 (10-30·11-06 측정). 클라우드 개발(사용자 공유 11-06): 실행당 약 124s.

## 남은 병목 (미적용 · 승인 필요)
- 759행 / 3026행 GT_0125_OCV_EXCEPT: SCM_MST_MODEL_BOM 전체 읽기(gets 27만, 약 1.0s) — (PLANT_ID, PARENT_ITEM_ID) 인덱스 DDL 필요.
- 952행 GT_0125_INVENTORY_AGE 0.6~0.8s.
