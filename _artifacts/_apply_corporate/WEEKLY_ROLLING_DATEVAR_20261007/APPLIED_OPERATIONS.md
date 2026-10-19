# APPLIED_OPERATIONS — [E20261007-DATEVAR] PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 날짜 경계 변수화 (사내 ZIOUI1)

| 항목 | 값 |
|---|---|
| 대상 | `SCM_MGR.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING` (PROCEDURE) 1 객체 |
| 기준 원문 | 2026-10-06 15:38:38, 913줄, md5 `e5f7388498f8846a9b09cfa8c37f8cf1` (`00_BACKUP_*.sql`, `_fresh_state.json`) |
| 적용 | 2026-10-07 22:00:19, 920줄(+7), md5 `8920e484c97208436542156489029516`, VALID, ALL_ERRORS 0 (`_apply_result.json`) |
| 도구 | `build_apply.py apply` (FRESH-GATE: 적용 직전 ALL_SOURCE 재조회 → 치환 대상 수 54w 2 / 1w 9 assert → CREATE OR REPLACE → 재조회 원문 == 패치본 assert) |
| 배경 | 배치 속도개선 1건째(40/MF_W 15.1분) — 메일 대기 10.5분 종료 후 루트 자체 164초 중 L384 INSERT 65초의 원인 = 술어 안 `FN_NEXT_DAY(SYSDATE)` 로 선택도 오추정(2,618 vs 423,068) + 81/82 파싱 계획 공유. 사용자 "권장순서(방법 2 → 효과 확인 → 방법 1)" 지시 |

## 변경 내용 (원본 + 7줄, 외과적 치환)

| # | 위치(적용 후 줄) | 내용 |
|---|---|---|
| ① | L82~85 | 선언 `V_FROM_1W`, `V_FROM_54W` VARCHAR2(8 CHAR) + 사유 주석 |
| ② | L95~96 | `V_FROM_1W := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')` / `V_FROM_54W := … - 7*54 …` (시작부, `V_DELIMITER := '^'` 다음) |
| ③ | L258·296·301·343·386·349·482·612·704 | `TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')` → `V_FROM_1W` (9곳) |
| ④ | L518·613 | `… - 7*54 …` → `V_FROM_54W` (2곳) |

주석 블록(MSSQL 원문 `dbo.FN_NEXT_DAY(GETDATE()…)`)은 패턴이 달라 영향 없음. 힌트·인덱스·데이터 변경 없음. 결과 행 동일(같은 식을 시작 때 1회 계산).

## 검증 (`t01_verify.py`, `t02_cache_control.py`)

1. VALID · 마커 14 · 술어 안 함수 잔존 0 · 의존 객체 0 (INVALID 목록은 기존 것, 본 객체 의존 아님)
2. 동치 — L384 첫 갈래 SELECT 건수·합계 (함수 술어 vs 바인드):
   | 사업부 | 건수 | 합계 | 함수형 | 바인드형 |
   |---|---|---|---|---|
   | 40 | 191,466 | -466,925,865,884 | 58.9s | 0.8s |
   | 81 | 114,236 | -6,248,802,611 | 11.3s | 0.6s |
   | 82 | 131,053 | -1,168,869,381 | 5.1s | 0.5s |
   캐시 통제(변수→함수→변수 순, 40): 0.3s → 4.9s → 0.2s — 둘 다 풀스캔 계획인 사내에서도 함수형이 느림 = `FN_NEXT_DAY(SYSDATE)` 가 행마다 평가됨(비결정적 함수). 추정치 함수 51,524 → 변수 207K.
3. 통계 갱신(사내): `DM_PLN_MKT_FCST` 2,255,111행 (285s) · `DM_PLN_CFM_MKT_DEMAND_PLAN` 420,354행 (161s), degree 4
4. 배치 본체는 사내에서 실행하지 않음 (버전 생성·Sales Plan 동기화 수반). 효과는 클라우드 다음 주 월요일 15:00 AWR(`dfrascwsp66jy` phv·elapsed)로 확인.

## 사내에서 한 작업 ↔ 패키지 파일

| 작업 | 패키지 |
|---|---|
| 원문 백업 | `00_BACKUP_*.sql` (사내) / 클라우드는 `05_BACKUP_CLOUD_SOURCE.sql` |
| CREATE OR REPLACE | `_deploy_packages/WEEKLY_ROLLING_DATEVAR_CLOUD_20261007/A_DB/10_*.sql` (+ 판본 다르면 `12_CHANGE_BLOCK`) |
| 통계 갱신 2 테이블 | `A_DB/20_STATS_GATHER_OPTIONAL.sql` (DBA 선택) |
| 검증 | `A_DB/90_VERIFY.sql` |

롤백(사내): `00_BACKUP_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql` 실행.
