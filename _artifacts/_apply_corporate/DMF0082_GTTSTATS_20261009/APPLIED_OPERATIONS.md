# APPLIED_OPERATIONS — [E20261009-DMF0082GTTSTATS] DMF0082 조회 GTT 대표 통계 고정 (사내 ZIOUI1)

| 항목 | 값 |
|---|---|
| 대상 | `GT_DMF0082_TEMP_SITE_ITEM` · `TEMP_SELECT_MEASURE` · `T_WS_FCST` · `TEMP_FCST_N_PRICE` · `T_LAST_DATA_SETUP_FCST` · `MF_SP` (GTT 6본) — 통계·PREF 만. SP/힌트/데이터/인덱스 변경 없음 |
| 적용 | 2026-10-09 16:28:50 `apply_gttstats.py apply` — `GLOBAL_TEMP_TABLE_STATS=SHARED` + `SET_TABLE_STATS`/`SET_COLUMN_STATS(NO_INVALIDATE=>FALSE)` (`01_GTTSTATS_applied_stmts.txt`, `_result.json`) |
| 값 | 적용 직전 같은 세션에서 GET(40/81/82) 호출 뒤 GTT 실적재 실측의 최대치: TEMP_SITE_ITEM 39,070행(PROJECT 1,456·SITE 1,181·ITEM 3,772) · TEMP_FCST_N_PRICE 72,139행 · MF_SP 72,139 · T_LAST_DATA_SETUP_FCST 2,834 · SELECT_MEASURE 8 · WS_FCST 14 |
| 배경 | 클라우드 QA 10-09 12:08 재컴파일 뒤 81 TIMEOUT(c3bg6q8n39195 카르테시안·d019r0hbb0muh PHV 3633386171 3,711초). 사내는 같은 문장 HASH 0.05~1초. 파싱 시점 GTT 추정 의존(07-31 DMF0003 동형). 사용자 지시: '/' 방향 유지·현재 데이터 기준으로 느리지 않게·힌트 금지 |

## 검증 (`_result.json`)

| 호출 | 전 | 후#1(재파싱) | 후#2 | 결과(RC1~RC5·RESULT, RC3 시각 제외) |
|---|---:|---:|---:|---|
| 40 / minyonglee1 | 9.93s | 3.88s | 3.24s | 동일 2,099행 |
| 81 / minyonglee1 | 3.75s | 4.18s | 4.39s | 동일 2,383행 |
| 82 / minyonglee1 | 4.33s | 4.97s | 5.05s | 동일 2,608행 |
| 82 / k0101 (9메저) | 8.83s | 8.69s | 19.34s(노이즈 · 재측정 9.25/8.90) | 동일 8,108행 |

- 계획: `c3bg6q8n39195` 3995613941→294698915 · `d019r0hbb0muh` 2682586817→2054382907 · `6bucw2kzuc0nt` 3737877804→1088113275 — 전부 HASH JOIN, `GT_DMF0082_TEMP_SITE_ITEM` E-Rows 19,535(고정 통계 기반). Note 에 `dynamic statistics used` **없음**(3문장). `18xg1y5298qgq` 는 PHV 유지(다른 소형 GTT 에만 동적 샘플링 잔존).
- 재컴파일 모사: `ALTER PACKAGE PKG_DMF0082 COMPILE BODY`(16:32:07) 뒤 81/40/82 호출 — PHV 집합 동일, 5.1/3.8/10.2초.
- 클라우드 파일 리허설(사내, 파일 그대로): 00 → 90 → 99(원복: 6 GTT NUM_ROWS 공백·PREF SESSION) → 10(재적용) → 90 — 오류 0 (`_rehearsal_out/`).

## 사내에서 한 작업 ↔ 패키지 파일

| 작업 | 사내 | 클라우드 (`_deploy_packages/DMF0082_GTTSTATS_CLOUD_20261009/A_DB/`) |
|---|---|---|
| 선판정 | `apply_gttstats.py measure` | `00_PRECHECK_CLOUD.sql` |
| 통계 설정 | `apply_gttstats.py apply` (= `01_GTTSTATS_applied_stmts.txt`) | `10_SET_GTT_STATS.sql` |
| 검증 | 내장 before/after + 재컴파일 모사 | `90_VERIFY.sql` (V4 가 81·40 GET 호출) |
| 원복 | `apply_gttstats.py rollback` | `99_ROLLBACK_GTT_STATS.sql` |

## 범위 밖 (결정 대기)
- 사내 콜드 I/O(판가 원장 랜덤 읽기 3만 블록 → 첫 조회 400초): 커버링 인덱스 vs 주간 요약 테이블.
- '/' 82 AS_Inv PLANT_SITE_ID 행 분리 27키: 차주 데이터 정리 예정(사용자).
