# WEEKLY_ROLLING 날짜 경계 변수화 (DB 단, 클라우드 이관) — 배치 속도개선 방법 2

> 마커 `[E20261007-DATEVAR]` — `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING` 1 객체

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — 프로시저 1개. 데이터·메타·FE·BE 변경 없음. (선택) 통계 갱신 2 테이블 |
| 사내 적용 | **완료 · VALID** (ZIOUI1, 2026-10-07 22:00:19) — [APPLIED_OPERATIONS.md](../../_apply_corporate/WEEKLY_ROLLING_DATEVAR_20261007/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 전제 | 클라우드 원문에 치환 패턴이 54w 2곳 / 1w 9곳 있고 마커가 없을 것 — 00 PRECHECK 가 판정. 사내 변경 직전 판 = 2026-10-06 15:38:38 914줄 md5 `e5f7388498f8846a9b09cfa8c37f8cf1` |
| BE 재기동 | 불요 |

## 1. 변경
술어 안 `TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')`(9곳)·`- 7*54`(2곳)를 시작 때 1회 계산한 변수 `V_FROM_1W`/`V_FROM_54W` 로 바꾼다. 선언 2줄 + 대입 2줄 + 치환 11곳 = +7줄(913→920). 결과 행은 같다(같은 식을 미리 계산). 힌트·인덱스 없음.

왜: 클라우드 AWR(10-05 15:00, 40/MF_W) 에서 L384 `INSERT DM_PLN_MKT_FCST_C`(sql_id `dfrascwsp66jy`) 가 65초 — 함수 술어 때문에 선택도 추정 2,618행(실제 423,068) → `IDX_DM_PLN_MKT_FCST_N1` 범위탐색 + ROWID 단일블록 읽기. 게다가 81/82 로 파싱된 계획을 40 이 공유(DBA_HIST_SQLBIND). 리터럴 날짜면 추정 362K·풀스캔.

## 2. 사내 검증
- VALID · 마커 14 · 술어 안 함수 잔존 0 · 의존 객체 0
- 동치(조회): L384 첫 갈래 SELECT 건수·합계 — 40 191,466 / 81 114,236 / 82 131,053 전부 함수형 = 바인드형. 소요 함수형 58.9s·11.3s·5.1s → 바인드형 0.8s·0.6s·0.5s (캐시 통제 재측정 = `_cache_control_result.json`)
- 통계 갱신: DM_PLN_MKT_FCST(285s) · DM_PLN_CFM_MKT_DEMAND_PLAN(161s)
- 배치 본체(WEEKLY_ROLLING 전체) 는 사내에서 실행하지 않음 — 버전 생성·Sales Plan 동기화를 수반하므로. 클라우드 다음 주 월요일 15:00 실행 결과(AWR phv·elapsed)로 효과 확인.

## 3. 작업 ↔ 파일 (SCM_MGR, QA → DEV)
| # | 작업 | 파일 | 비고 |
|---|---|---|---|
| 1 | 선판정 | A_DB/00_PRECHECK_CLOUD.sql | H-APPLIED / H-PATTERN / H-LINES |
| 2 | 보관 | A_DB/05_BACKUP_CLOUD_SOURCE.sql | `BAK_SRC_WR_DATEVAR` |
| 3 | 적용 | A_DB/10_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql | 전체본 — H-LINES 일치 때만. 다르면 §4 |
| 4 | 안전망 | A_DB/13_RECOMPILE_DEPENDENTS.sql | |
| 5 | (선택·DBA) 통계 | A_DB/20_STATS_GATHER_OPTIONAL.sql | 배치 직전 시점 권장 |
| 6 | 검증 | A_DB/90_VERIFY.sql | V1~V6 |

## 4. 판본이 다르면
[12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) 의 diff 를 수동 반영(규칙 4개는 파일 머리에). 반영 뒤 90 의 V2=14·V3=0·V4=2 면 된다.

## 5. 효과 확인 (다음 주 월요일 15:00 뒤)
`BATCH_PERF_WEEKLY_ROLLING_20261007/03_root_block_measure.sql` Q13 또는 DBA_HIST_SQLBIND 한 줄 쿼리로 `dfrascwsp66jy` 의 phv·elapsed 확인. 여전히 인덱스 계획이면 방법 1(40 전용 문장 분리)로.

롤백: A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql → 13.
