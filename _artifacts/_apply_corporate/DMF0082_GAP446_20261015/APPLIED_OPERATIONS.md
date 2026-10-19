# DMF0082_GAP446_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` 과거 버전(SF/MF/SP) 분기 (마커 `[GAP446 2026-10-15]` 9곳)
- 방식: DB 만 변경 (FE 무변경)

## AS-IS 확인 (LGCE_SCMDEV `DMF0082_GET_MAIN_DATA`, 2026-07-22 — 실행 문장, 중첩주석 판정)
| # | AS-IS | TO-BE(수정 전) |
|---|---|---|
| C1 | `NOW_YYYYMMDD = FN_NEXT_DAY(버전일,'MON') - 7` = 버전일이 속한 주 월요일 (L256) | `버전일 - 7` |
| C2 | MF 계획 `A.YYYYMMDD >= F.NOW_YYYYMMDD` (L2775) | 없음 |
| C3 | MF 판가 `>= F.NOW_YYYYMMDD` (L3415) | 없음 |
| C4 | SF 계획 = `DM_PLN_CFM_MKT_DEMAND_PLAN_C` + `>= NOW` (L4262~4369) | AS-IS 주석 구간의 `DM_PLN_MKT_FCST_RESULT_C`(실적 구간) 를 읽음 |
| C5 | SP 실적 3종으로 Unit Price 계산 뒤 `DELETE … MEASURE IN ('MKT_AMT_KRW','MKT_AMT_LOC','RTF_SYS_RP')` (L4235~4238) | DM_ADMIN 보조 메저만 삭제 → 사용자 RTF_SYS_RP 잔존 |
- `FN_NEXT_DAY` AS-IS(MSSQL) ↔ TO-BE(Oracle) 동일 결과 확인: 20260824(월)·20260826(수) → 20260831 (−7 = 20260824)

## 변경
- C1: T_VERSION NOW 산식 / C2: MF 계획(81·40) 조건 추가 / C3: MF 판가(81·40) 조건 추가 / C4: SF 계획 블록을 MF 계획 블록 형태('SF%', NOW 포함)로 교체 / C5: SP 전용 Unit Price 블록 끝에 3종 삭제
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 14:21:29 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 검증 (40 · 2026-08-03~2026-12-31 · SCM_MGR 화면 설정(MKT_FCST·RTF_SYS_RP·SCM_FCST·CUST_FCST·KRW·USD·LOC) · ADMIN — 조회 전용)
| 버전 | 수정 전 | 수정 후 | GAP 기재 AS-IS |
|---|---|---|---|
| SF_W_20260824_V001 | 1,476 (판가 1,245 + RTF 231, 계획 수요 0) | **2,090** (MKT_FCST 233 · SCM_FCST 233 · RTF_SYS_RP 379 · 판가 1,245) | 2,164 |
| MF_W_20260824_V001 | 2,090 | 2,090 | 2,092 |
| SP_W_20260825_V001 | 1,459 (판가 1,228 + RTF_SYS_RP 231) | **1,228** (판가만) | **1,228** |
- SF = MF 결과 동일 사유: 사내 원장에서 SF_W_20260824 와 MF_W_20260824 스냅샷이 행 단위 동일(SF − MF = 0행).
- MF_W_20260824 무변화 사유: 버전일이 월요일이라 구 NOW(08-17)~신 NOW(08-24) 사이 계획·판가 행 0건 — 이 데이터로는 C1~C3 효과가 드러나지 않음.
- C1~C3 효과 확인: MF_W_20260921_V001 (구 NOW 09-14 ~ 신 NOW 09-21 사이 원장 계획 행 14건), 기간 2026-09-01~2026-12-31 — 호출 3.6초
  - GT_DMF0082_T_VERSION.NOW_YYYYMMDD = **20260921** (신 산식 반영, 구 산식이면 20260914)
  - GTT 의 MF 계획·판가 행 중 09-14~09-20 = **0건** (MKT_FCST 81 · SCM_FCST 81, 최소 일자 20261012)
  - ⚠ 한계: 오늘(10-15) 기준 계획구간 시작 V_FROM = 20261012 가 과거 버전의 NOW 보다 늦어, 14건은 V_FROM 으로도 이미 제외된다 → 현재 날짜로는 C1~C3 단독 효과를 데이터로 분리 입증 불가 (GAP 측정 시점에는 V_FROM 이 더 이른 날짜였던 것으로 보임). 구조는 AS-IS 실행 문장과 일치.
- GAP 기재 AS-IS 수치(2,164 / 2,092)와의 차이는 측정 DB 데이터 차이(사내 ZIOUI1 ↔ GAP 측정 환경)로 직접 비교 불가 — 구조(원천·조건)는 AS-IS 실행 문장과 일치.

## 이관 패키지
- `_artifacts/_deploy_packages/DMF0082_GAP446_PASTVER_CLOUD_20261015/` — 생성기 시뮬레이터(수정 전→적용 연산==적용본 · 적용본→원복 연산==수정 전) 통과 · 사내 리허설(15:14) 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · 99 원복 == 수정 전 원문 · 10 재적용 == 적용본 (원문 전체 일치) · 90 V4 인용부호 결함 정정 후 재실행 V1~V4 PASS
