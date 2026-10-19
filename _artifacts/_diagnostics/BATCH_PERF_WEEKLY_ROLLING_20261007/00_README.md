# 배치 속도 진단 — PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING (40 사업부 MF_W)

> 대상 호출: `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING('40', 'MKT FCST Weekly Cutoff', 'MF_W', 'Weekly Rolling', 'system')`
> 조회 전용 · DB 변경 없음 · 클라우드 SCM_MGR(또는 `SCM_SYS_LOG_BATCH` 조회 권한 계정)에서 실행

| 파일 | 내용 |
|---|---|
| [01_weekly_rolling_log_diag.sql](01_weekly_rolling_log_diag.sql) | 진단 쿼리 Q0~Q6 (전주 월~목 자동 계산) |
| [02_root_block_L236-712_corp_20261007.sql](02_root_block_L236-712_corp_20261007.sql) | 루트 자체 93초 구간 원문(사내 ALL_SOURCE, 줄번호 = PROGRAM_LINE# 대조용) |
| [03_root_block_measure.sql](03_root_block_measure.sql) | 1순위 실측 쿼리 Q7~Q12b (문장별 공유풀 실측 · 실행계획 · 카디널리티 · 통계/인덱스/파티션 · ASH/AWR) |
| `_run_diag.py` | 사내 ZIOUI1 사전 검증용 실행기 (`python _run_diag.py [03_….sql] [from] [to] [division] [--only=Q10,Q12b]`) |

## 로그 구조

- 모든 배치 SP 가 `PR_SCM_SYS_LOG_BATCH` / `PR_DM_SYS_LOG_BATCH` 로 `SCM_MGR.SCM_SYS_LOG_BATCH` 에 기록
- `PROGRAM_NAME` = SP 이름 · `LOG_TYPE` = START / END / ERROR / INVALID / APPEND … · `DESCRIPTION` = `Div: 40 / MF_W` · `EVENT_DATE` = 시각 · `CREATED_BY` = 실행 계정(배치 = `scm_batch`)
- 루트 SP 가 부르는 하위 SP 도 각자 START/END 를 남기므로, 루트 START~END 구간 안의 로그를 시간순으로 놓으면 단계별 소요가 나온다
- 인덱스가 없는 테이블이라 기간을 넓히면 느려진다

## 쿼리 읽는 법

| 쿼리 | 보는 것 | 판단 |
|---|---|---|
| Q0 | 전주 월 00:00 ~ 목 24:00 | 다른 기간은 각 쿼리의 `w` 두 날짜를 직접 바꾼다 |
| Q1 | 루트 SP 실행별 시작·종료·소요(분)·상태 | `미종료` = END/ERROR 없이 끊김(세션 kill·타임아웃 의심) |
| Q2 | 실행 1건의 단계별 타임라인, `GAP_SEC` = 직전 로그와의 간격 | **GAP 이 큰 행의 직전 구간이 병목**. 하위 SP START 앞의 큰 GAP = 루트 SP 자체 로직(로그 없는 SQL) |
| Q3 | 호출 체인 SP 별 소요 합계·최대·호출 수 | `TOTAL_MIN` 상위 = 튜닝 1순위 · `NOT_ENDED` > 0 = 오류·중단 |
| Q4 | 기간 안 ERROR/INVALID 전부 (타 SP 포함) | `SQL_ERR_CODE`·`BACKTRACE` 로 줄 번호 특정 |
| Q5 | 최근 8주 사업부별 소요 추이 | 개선 전후 비교 기준선 |
| Q6 | (선택, V$ 권한) 공유풀에 남은 무거운 SQL — `FROM_PROGRAM`·`PROGRAM_LINE#` 로 SP 줄 특정 | 공유풀에서 밀려났으면 안 나옴. 실행 직후 조회해야 유효 |

## 사내 사전 검증 (2026-10-07, 2026-09-28~10-01)

- 사내에는 전주에 40 사업부 실행이 없고 81 계열 6건만 있어 81 로 검증 — 쿼리 6종 전부 정상 실행
- 81 본체 7.5분 중 큰 간격: `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW` 139초 · VERSION_CREATE 뒤 FUTURE_PRICE_CUTOFF 전 53초(루트 자체 로직) · `PR_DM_PLN_MKT_FCST_TO_NET_DEMAND` 43초
- Q3 에 호출 체인 IN 조건을 넣어 같은 시각 같은 계정의 메일·SMS 배치 로그(`SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG` 198건)를 걷어냄

## 클라우드 실측 결과 (사용자 공유, 2026-10-07)

전주(09-28~10-01) 40/MF_W 1회 = 09-28 15:00:00 → 15:15:03, **15.1분**

| 구간 | 소요 | 비고 |
|---|---|---|
| 루트 자체 (VERSION_CREATE 뒤 ~ FUTURE_PRICE_CUTOFF 전) | 93초 | MKT_FCST → _C 컷오프 INSERT, 로그 없음 |
| PR_SCM_MST_FUTURE_PRICE_CUTOFF | 82초 | |
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW | 15초 | |
| PR_DM_PLN_MKT_FCST_TO_NET_DEMAND | 55초 | |
| PR_DM_PLN_DEMANDID_PEGGING(_SECTION_SUM) | 18초 | |
| PR_DM_PLN_SALES_PLAN_CUTOFF (SP_D) | 5초 | |
| **PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND** | **10.5분** (15:04:30 → 15:15:03) | 수신자 108명 1통씩 + 5명마다 `DBMS_SESSION.SLEEP(30)` (MSSQL `WAITFOR DELAY` 변환 잔재) |

- 메일 건 = **종료** (사용자 2026-10-07): 사내 본(LAST_DDL 2026-10-07 06:48:56)은 대기 삭제 + 수신자 4,000바이트 슬롯 묶음이 이미 적용됨. 클라우드는 옛 본 — 이관 시 40/MF_W ≈ 4.5분, 40/SF_W·81/82 MF_W 도 동일 효과. 이관 패키지는 별건(아직 없음).
- 다음 순위(미착수): 루트 자체 93초 · FUTURE_PRICE_CUTOFF 82초 · TO_NET_DEMAND 55초 — hook #129 순서(클라우드 실행계획 실측 → 수정)

## 1순위 실측 (03_root_block_measure.sql) — 클라우드에서 실행할 순서

| 순서 | 쿼리 | 결과로 알 수 있는 것 | 비고 |
|---|---|---|---|
| 1 | Q7 | 3개 SP 안 각 SQL 의 누적 시간·I/O·행수 (공유풀) — elapsed_sec 상위 = 대상 문장 | 이번 주 월요일 실행이 공유풀에 남아 있을 때만. 비면 Q12 |
| 2 | Q8 | Q7 상위 3개 SQL_ID 의 실제 실행계획 | `'&sql_id'` 에 값 대입 |
| 3 | Q10 · Q10b | 테이블 통계 시점·크기·인덱스·파티션(INTERVAL on CUTOFF_YYYYMMDD_DATE) | 2초 |
| 4 | Q9 | 40 사업부 카디널리티 (문장별 다루는 행수) | COUNT 라 느림(사내 4.6분) — 한가한 시간 |
| 5 | Q11 → Q12 / Q12b | 93초 구간 시각 → 그 동안 SQL 별 대기 이벤트(ASH/AWR) | Diagnostics Pack 권한 필요, 없으면 ORA-00942 |

- 사내 검증(2026-10-07): 6종 문법 통과. 사내 09-30 81 실행 53초 구간의 AWR(Q12b)은 `log file sync`·`log buffer space` 가 상위 — DELETE/INSERT 리두 쓰기 대기. 클라우드도 같은지 Q12 로 확인.
- 사내 테이블 규모: DM_PLN_MKT_FCST 225만 · DM_PLN_MKT_FCST_C 4,000만(파티션, 통계 09-29) · DM_PLN_CFM_MKT_DEMAND_PLAN_C 923만(파티션) · DM_PLN_MKT_FCST_RESULT_C 625만(파티션)

## 1순위 실측 결과 1차 (클라우드, 사용자 공유 2026-10-07)

- 이번 주 10-05 15:00 실행의 루트 자체 구간 = **15:00:00 → 15:02:44, 164초** (전주 93초보다 늘어남)
- Q7(공유풀 잔존)에 남은 것 2건만:
  | SP · 줄 | SQL_ID | 실행 | 누적 | 1회 | CPU | gets | disk | rows |
  |---|---|---|---|---|---|---|---|---|
  | WEEKLY_ROLLING L517 INSERT DM_PLN_MKT_FCST_RESULT_C | 5m72jpcz22092 | 8 | 57.7s | 7.2s | 44.5s | 1.31M | 47K | 141,614 |
  | FUTURE_PRICE_CUTOFF L517 INSERT SCM_MST_FUTURE_PRICE_C | 0xv2kudsy19hn | 6 | 42.7s | 7.1s | 26.5s | 365K | **782K** | 32,130 |
  나머지 문장(L248/254/291/297/384/616/623)은 공유풀에서 밀려남 → Q13(AWR) 으로
- Q9 클라우드 40 규모: DM_PLN_MKT_FCST 40 = 1,264,359행(BALANCE 648K · VMI_DIO 148K · MKT_FCST_LATEST 99K · MKT_FCST 97K …) · MKT_FCST_C 최신 MF_W 450,180행(전체 2,984만) · RESULT 2,195,258 · RESULT_C 최신 39,093 · CFM_MKT_DEMAND_PLAN 518,209 · CFM_MKT_DEMAND_PLAN_C 최신 465,205(전체 3,008만)
- Q10 클라우드 통계: **DM_PLN_CFM_MKT_DEMAND_PLAN stale 150%**(66만 행에 변경 99만 — 매일 DELETE+INSERT 전량 재작성) · DM_PLN_MKT_FCST 19% · MKT_FCST_C 11%(통계 10-02) · FUTURE_PRICE 12.6%. 인덱스: MKT_FCST 4개(PK 10컬럼) · MKT_FCST_C 6개(PK 14컬럼) · CFM_MKT_DEMAND_PLAN_C PK 16컬럼 · RESULT_C 5개 — 45만~47만 행 INSERT 마다 전부 유지
- ASH/AWR 접근 가능(ORA-00942 없음). Q12·Q12b·Q8 은 치환값 없이 실행돼 0행 → 아래 값으로 재실행 필요

## 1순위 실측 결과 2차 — 164초 구간의 문장별 분해 (클라우드 AWR 10초 샘플, 10-05 15:00:00~15:02:44)

| SQL_ID | 문장 (SQL_ID 는 환경 공통 — 사내 AWR 원문으로 식별) | 샘플(10s) | 비중 | 대기 성격 |
|---|---|---|---|---|
| `dfrascwsp66jy` | **WEEKLY_ROLLING L384 `INSERT DM_PLN_MKT_FCST_C` ← DM_PLN_MKT_FCST × SCM_MST_SITE_ITEM (UNION ALL)** · 45만 행 | 180 | ≈56% (≈90s) | flash cache 단일블록 읽기 100 · CPU 60 · gc 20 |
| `5m72jpcz22092` | WEEKLY_ROLLING L517 `INSERT DM_PLN_MKT_FCST_RESULT_C` ← DM_PLN_MKT_FCST_RESULT · 3.9만 행 | 100 | ≈31% (≈50s) | CPU 80 · 단일블록 읽기 20 |
| `dc3k173upcjfj` | WEEKLY_ROLLING L623 `INSERT DM_PLN_CFM_MKT_DEMAND_PLAN_C` ← DM_PLN_CFM_MKT_DEMAND_PLAN · 46.5만 행 | 40 | ≈13% (≈20s) | CPU |

(DELETE L248/291/616 과 INSERT L254/297 은 샘플에 안 잡힘 = 각 10초 미만)

실행계획에서 보인 것 (클라우드 DISPLAY_CURSOR · 사내 DISPLAY_AWR):
- `5m72jpcz22092`: 클라우드는 `IDX_DM_PLN_MKT_FCST_RESULT_N1(DIVISION_ID, MEASURE, YYYYMMDD)` 를 DIVISION_ID + YYYYMMDD 범위로 탐색 — 2번째 컬럼 MEASURE 가 조건에 없어 40 사업부 인덱스 전 구간(219만 건)을 훑고 YYYYMMDD 로 거른다. 사내는 PK 로 같은 양상. E-Rows 1,192 vs 실제 ≈3.9만.
- `0xv2kudsy19hn`(FUTURE_PRICE_CUTOFF, 82초): ① `DM_PLN_MKT_FCST_C` 를 VERSION_NO 로만 찾아 **PARTITION RANGE ALL**(파티션 키 CUTOFF_YYYYMMDD_DATE 조건 없음) · E-Rows 224 vs 실제 45만 ② `SCM_MST_FUTURE_PRICE` 를 `IDX02(DIVISION_ID, YYYYMMDD)` 로 `YYYYMMDD >= :B1` 이후 전부 읽고(disk 782K) `SUBSTR(YYYYMMDD,1,6) < :B5` 는 인덱스로 못 거름(비 SARGable).
- `dfrascwsp66jy`(사내 계획): `DM_PLN_MKT_FCST` 를 `PK(DIVISION_ID, PROJECT_CODE, …)` 범위 탐색 — YYYYMMDD 가 PK 의 9번째라 40 사업부 126만 행 전부를 인덱스 ROWID 로 읽음(단일블록 읽기 100 샘플과 부합). 클라우드 계획은 미확인(DISPLAY_AWR 필요).

3차(클라우드 DISPLAY_AWR, `dfrascwsp66jy` 4개 판본 전부): `IDX_DM_PLN_MKT_FCST_N1(DIVISION_ID,MEASURE,YYYYMMDD)` 를 DIVISION_ID+YYYYMMDD 로 범위탐색(MEASURE `NOT IN` 이라 키 불가 — SQL Analysis Report 지적) → 40 사업부 126만 건 훑고 ROWID BATCHED 로 ~42만 행 단일블록 읽기. 예상 2,618행 vs 실제 423,068행.
검증(클라우드, 변경 없음): L384 첫 갈래 SELECT 를 COUNT 로 — 함수 날짜 / 리터럴 '20261005' 모두 423,068행·합계 동일. EXPLAIN PLAN 은 **둘 다 `TABLE ACCESS STORAGE FULL`**(블룸 필터 해시 조인) — 예상치는 함수 62,979 → 리터럴 362K 로 개선. 즉 리터럴 '40' 이면 풀스캔을 고르는데 SP 안(:B1 바인드)에서는 인덱스 경로 → **사업부 바인드 피킹 의심**(81_UC 등 작은 사업부로 하드파싱된 커서를 40 이 공유). 확인 = DBA_HIST_SQLBIND 피킹값 + 스냅별 plan_hash.

4차(DBA_HIST_SQLBIND·SQLSTAT, `dfrascwsp66jy`, 09-29~10-07): 계획 3종이 전부 **81/82 실행 때 만들어지고 40 이 재사용** — 1989277581(09-29 03:00 peek 81) → 459585693(10-02 00:00 peek 82) → 1734135108(10-04 00:00 peek 82). 40 실행(450,180행)은 그 계획으로 38.8s·65.1s(10-05 15:00)·48.8s·57.3s, gets 4.2~5.2M. 40 으로 파싱된 계획은 한 번도 없음. 리터럴 '40' EXPLAIN 은 풀스캔(cost 9,307) 인데 82 기준 인덱스 계획(cost 6,206)이 더 싸게 보여 그 커서를 공유 → **커서 공유(바인드 피킹) 확정**. ACS 는 사업부별 1일 1회라 작동 못 함.

5차(클라우드 소요 실측 `04_L384_elapsed_T1-T3.sql` T0, 10-07 22:50, cnt 423,068·합계 동일 3종): **T1 함수날짜+리터럴 '40' = 5.18s · T2 리터럴 날짜 = 0.17s · T3 바인드 :B1(40 으로 먼저 파싱)+함수날짜 = 14.47s**. T3 가 T1 보다 느림 = 40 이 자기 계획을 가져도 **술어 안 `FN_NEXT_DAY(SYSDATE)` 가 남아 있으면 인덱스 경로(2,618행 오추정)를 고름** → 원인은 커서 공유보다 함수 술어. 날짜를 변수(바인드)로 빼면 피킹값으로 범위 선택도가 바로 잡혀 풀스캔(T2 경로, 1초 미만~수 초) → **방법 2(DATEVAR) 로 충분, 방법 1(40 문장 분리) 불필요 판정**. 기대: L384 65s → ≤5s, 루트 164s → ≈100s(다음 병목 L517 ≈50s · L623 ≈20s).
(이전에 전달한 T1~T3 는 `'…[Org.]'` 의 `]'` 가 `q'[ ]'` 종결자와 겹쳐 깨짐 — `q'{ }'` 로 정정)

수정 후보(승인 전 — 적용 안 함): 각 문장의 접근 경로가 "사업부 전체를 읽고 날짜로 거르는" 형태라 ① YYYYMMDD 를 앞세운 인덱스 또는 기존 `IDX_N1(DIVISION_ID, MEASURE, YYYYMMDD)` 를 MEASURE 조건과 함께 타게 하는 조건 보강 ② FUTURE_PRICE_CUTOFF 의 `SUBSTR(YYYYMMDD,1,6) < :B5` → `YYYYMMDD < :B5||'01'` 등가 치환, `DM_PLN_MKT_FCST_C` 조건에 CUTOFF_YYYYMMDD(=당일) 추가로 파티션 가지치기 ③ 적재 테이블의 인덱스 6개·PK 14~16컬럼 유지 비용은 구조 문제라 별도 결정.

## 한계

- 로그는 SP 단위 START/END 뿐이라 SP 내부 어느 SQL 이 느린지는 Q2 의 GAP 과 Q6(V$) 로만 추정 — 정밀 튜닝은 hook #129 순서(대상 환경 실측 → 실행계획) 로 진행
- `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE` 등 PROGRAM_NAME 을 호출자가 넘기는 SP 는 로그 이름이 다를 수 있음 — Q2 에서 이름 없는 구간이 보이면 Q3 IN 목록에 추가
