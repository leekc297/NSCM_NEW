# GAP 413 — DMF0072 하역지·플랜트 빈값 매핑 ↔ EDI 미연결 보완 (2026-10-15)

## 요구
- DMF0072 에서 하역지(UNLOADING_POINT)·플랜트(CUSTOMER_PLANT)를 비워 등록한 신규 매핑이 EDI 자료와 연결되지 않음.
- 조회·연결 시 `NULL / '' / ' ' / '-' / '/'` 를 모두 하나("값 없음")로 인지. 이후 저장값이 '-'→'/' 등으로 바뀌어도 연결 유지.
- 작업 범위 = DB 객체 보완만 (FE/BE 무변경).

## 원인
| 객체 | 빈값 비교 상수 | '/' 행 처리 |
|---|---|---|
| PKG_DMF0072 저장 (신규 INSERT) | 저장값 `'/'` · 기존행 판정 `'@#@#@#'` | 재저장 시 '-'/' ' 기존행을 못 찾아 별도 행 INSERT |
| PR_DM_CUST_MODEL_MAPPING (EDI→매핑 기초행) | `' '` | '/' 행을 못 보고 `' '` 쌍둥이 행 생성 (MAPPING_ITEM_ID 기본값=ITEM_ID) |
| PR_DM_CUST_MODEL_MAPPING_IF (NERP IF) | `' '` | 동일 |
| PR_DM_DNM_EDI_CALLOFF_MKT_FCST (EDI→MKT_FCST) | `' '` | '/' 는 ' ' 와 불일치 → 미연결 |
| PR_DM_PLN_CUST_FCST_RECORD (EDI→CUST_FCST_H) | 매핑 GTT `'/'` · 조인 PLANT/CUST_ITEM `' '` | 빈 플랜트는 '/' vs ' ' 로 **항상** 미연결 (기존 결함 포함) |

사내 실측: 매핑 원장의 "값 없음" = `' '`(EDI 배치) · `'-'`(이관분) 혼재, 동일 논리키 쌍둥이 7건 존재(같은 원인으로 생성된 흔적).

## 조치 (비교식만 — 저장값·출력값 불변)
정규화식: `NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM(x)),'-'),'--'),'/'), <객체별 기존 상수>)` 를 **양변**에 적용.
매핑 GTT 적재(MKT_FCST·CUST_FCST_RECORD)는 SELECT·GROUP BY 를 같은 식으로 → 변형 행이 1행으로 합쳐져 중복 집계 없음.

| 객체 | 변경 라인(ALL_SOURCE.LINE) | 치환 | 적용 후 LAST_DDL | STATUS |
|---|---|---:|---|---|
| PKG_DMF0072 BODY | 576-578, 603-605 | 12 | 2026-10-15 10:59:14 | VALID |
| PR_DM_CUST_MODEL_MAPPING | 164-166, 193-195 | 12 | 2026-10-15 10:59:15 | VALID |
| PR_DM_CUST_MODEL_MAPPING_IF | 206-208, 372-374 | 12 | 2026-10-15 10:59:15 | VALID |
| PR_DM_DNM_EDI_CALLOFF_MKT_FCST | 292-294, 303-304, 413-415, 941-943 | 18 | 2026-10-15 10:59:15 | VALID |
| PR_DM_PLN_CUST_FCST_RECORD | 176-178, 185-187, 278-280 | 12 | 2026-10-15 10:59:15 | VALID |

- DB: 사내 ZIOUI1 (SERVER_HOST=localhost, 59.19.252.148). 기준본 = 적용 직전 ALL_SOURCE 재조회, FRESH-GATE 통과.
- 파일: `PATCH_*.sql`(적용본, SOURCE-FRESH 스탬프) · `ORIG_*.sql`(롤백용 적용 전 원문) · `build_apply.py`(build/apply).

## 검증
| 항목 | 결과 |
|---|---|
| 컴파일 | 5/5 VALID · ALL_ERRORS 0 · 의존 객체(PR_DM_DNM_EDI_CALLOFF, DMF0072_GET_NNMASTER_MAPPING_WRAPPER) VALID |
| DB 원문 == 적용본 | 5/5 일치 · 표식 라인 38 |
| 회귀(SELECT 시뮬레이션, EDI 2026-01-01~ STATUS='S') | 매칭 EDI 행 38,999 → 38,999 (손실 0) · 조인 행 = EDI 행 (중복 집계 증가 0) |
| 현상 재현(가상 매핑행, 원장 무변경) | 하역지·플랜트 빈 EDI × 매핑 `'/'` : 0 → **1** / `'-'` : 0 → **1** / `' '` : 1 → 1 |
| 배치 실제 실행 | **미실행** — PR_DM_DNM_EDI_CALLOFF 계열은 DM_PLN_MKT_FCST·CUST_FCST_H 를 재생성하므로 사내 임의 실행 안 함. 다음 정기 배치 후 확인 필요 |
| DMF0072 화면 저장 E2E | **미실행** — 화면에서 빈 하역지/플랜트로 기존 '-' 행 재저장 시 중복 행이 생기지 않는지 확인 필요 |

## 클라우드 이관
- 패키지: `_artifacts/_deploy_packages/DMF0072_G413_SENTINEL_CLOUD_20261015/` (DB 내 라인 치환 방식 — 전체 덮어쓰기 아님)
- 사내 실행 검증으로 아래 재적용이 발생 (최종 상태 = 적용본, 바이트 일치 확인)
  | 시각 | 작업 |
  |---|---|
  | 11:1x | 패키지 99_ROLLBACK 실행(원복) → 00_PRECHECK q-quote 결함 발견 → build_apply.py apply 로 즉시 재적용 (LAST_DDL 11:15:56) |
  | 11:17 | 패키지 전체 사이클 재검증: 99_ROLLBACK → 00_PRECHECK → 01_APPLY → 01_APPLY(SKIP) (최종 LAST_DDL 11:17:46 내외) |
  | 11:18 | 중단 경로 검증(SKIP 해제 사본) — ORA-20413, 객체 무변경 |

## 롤백
`ORIG_*.sql` 5본 실행 (적용 전 원문 그대로).
