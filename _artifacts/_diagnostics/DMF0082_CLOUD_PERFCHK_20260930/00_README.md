# DMF0082 조회 — 클라우드 속도 점검 SQL 세트

> 대상: `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA` (화면 [Search] · `FcstNPrice/SEARCH/call-proc`)
> 목적: 클라우드에서만 느린 조회의 **병목 구간(DB / BE / 네트워크)** 과 **병목 문장(SQL_ID · 계획 라인 · 대기 이벤트)** 을 한 번에 특정
> 모든 스크립트는 **READ-ONLY** (C03 만 SP 를 실행하나 GTT 만 채우고 매 회 ROLLBACK). 계정 `SCM_MGR`.
> 사내 ZIOUI1 에서 4본 모두 실행 검증 완료 (2026-09-30, 문법·권한 오류 0) — 사내 기준값은 스크립트에 내장.

## 1. 실행 순서

| 순서 | 파일 | 언제 | 소요 | 회신 파일 |
|---:|---|---|---|---|
| 1 | [C01_ENV_STATE.sql](C01_ENV_STATE.sql) | 아무 때나 · **QA / DEV 둘 다** | 수 초 | `C01_ENV_STATE_OUT.txt` |
| 2 | 클라우드 화면에서 Division **40 / 81 / 82** 각각 Search (가능하면 각 2회) | — | — | — |
| 3 | [C02_SCREEN_LOG_ASH.sql](C02_SCREEN_LOG_ASH.sql) | **2 직후** (BE 가 붙은 DB) | 수 초 | `C02_SCREEN_LOG_ASH_OUT.txt` |
| 4 | [C03_SP_STAGE_PROFILE.sql](C03_SP_STAGE_PROFILE.sql) | 3 다음 (BE 가 붙은 DB) | div × 2회 × 조회시간 | `C03_SP_STAGE_PROFILE_OUT.txt` |
| 5 | [C04_PLAN_OF_SQLID.sql](C04_PLAN_OF_SQLID.sql) | C02 [S2] / C03 (B) 상위 SQL_ID 마다 `DEFINE SQL_ID` 바꿔 실행 | 수 초 | `C04_PLAN_<SQL_ID>_OUT.txt` |

- SQL Developer: 파일 열고 **스크립트 실행(F5)**. C03 은 `DBMS_OUTPUT` 을 쓰므로 스크립트 출력 창 또는 SPOOL 파일로 확인.
- C03 이 오래 걸리면 `c_divs := '82'` 처럼 하나로 좁혀 먼저 실행. `c_group` 은 C02 [S1] 의 `USER_GROUP` 값(화면이 실제 보낸 값)으로 맞출 것.
- C04 에서 **A-Rows(실측 행수)** 까지 보려면 C03 을 `c_rowstats := 'Y'` 로 한 번 더 돌린 뒤 C04 실행.
- ⚠ 클라우드는 **QA·DEV 2개 DB** — C01 [E0] 결과를 BE `application.yml` datasource 와 대조해 **BE 가 보는 DB** 에서 C02~C04 실행.

## 2. 무엇을 보나 (섹션별)

| 파일 | 섹션 | 확인 내용 |
|---|---|---|
| C01 | E0 | 접속 DB (QA/DEV 구분) |
| | **E1** | 09-30 조회 속도개선(QRYPERF) BODY 적용 여부 — 사내 지문 `16176/830176` · 마커 22 · 활성 GATHER 0 · IDX02 힌트 2 |
| | E2 | 옵티마이저·자원 파라미터 26종 사내 대조 (`optimizer_dynamic_sampling` 등) |
| | E3 | 조회 관련 31 테이블 인덱스 사내 대조 — 결손·컬럼 상이·UNUSABLE 만 출력 |
| | E4 | 31 테이블 행수·용량·통계일·STALE·잠금 사내 대조 (`ROWS_X` = 클라우드÷사내) |
| | E5 | `GT_DMF0082_*` GTT 통계 잠금·고정값 |
| | E6 | 60초 넘게 실행 중인 타 세션 (측정 노이즈) |
| C02 | **S1** | 화면 Search 1회의 **DB / SERVER / TOTAL** 구간 분해 (`SCM_COM_SYS_LOG`, BE 가 매 호출 기록) |
| | **S2** | 실제 화면 세션(BE)의 ASH — PKG_DMF0082 안에서 시간을 쓴 SQL_ID 순위 (샘플 1 ≈ 1초) |
| | S3 | 대기 이벤트 구성 (CPU / 풀스캔 / 랜덤IO / TEMP / 파싱) |
| | S4 | 상위 5 문장의 **계획 라인 · 오브젝트** 핫스팟 |
| | S5 | V$SQL 1회당 비용 (자식 커서 단위) |
| | S6 | 같은 SQL_ID 에 계획 여러 개 — 나쁜 자식 커서 고정 |
| | S7 | 커서 생성 시 `optimizer_dynamic_sampling` 값 (0 으로 굳은 커서 탐지) |
| | S8 | 세션별 dynamic_sampling 현재값 (참고) |
| C03 | (A) | SP 시간 · 결과 커서 6개 fetch 시간 · 행수 + **사내 기준 병기** |
| | **(B)** | 문장별 귀속 (V$SQL 델타) — 라인 · 초 · BG · DR · 하드파싱 + **사내SEC / SEC_X / 사내BG / PHV비교** |
| | (C) | 내 세션 ASH — SQL_ID × 이벤트 |
| | (D) | 세션 통계 델타 (논리/물리 IO · 하드파싱 · TEMP · CPU) |
| C04 | P1~P6 | 자식 커서별 비용 · SQL 전문 · 최근/최선 계획 비교 · 계획 내 객체 통계 · AWR 14일 이력 |

## 3. 판정표 — 결과 → 원인 → 조치 방향

| # | 관찰 | 원인 계통 | 조치 방향 |
|---:|---|---|---|
| 0 | C01 E1 `❌ QRYPERF 미적용` | 09-30 개선 BODY 가 클라우드에 없음 (사내 82 240s→6s 의 주 조치) | [`DMF0082_QRYPERF_CLOUD_20260930`](../../_deploy_packages/DMF0082_QRYPERF_CLOUD_20260930/00_README.md) 적용(QA·DEV) 후 재측정 |
| 1 | C02 S1 `SERVER_S − DB_S` 가 큼 (사내 ≈ 0.5~1.2s) | BE — 결과 매핑·`SystemLogAspect` 결과 JSON 로그 | BE 공통 조치 (전 화면 영향 → 별도 결정) |
| 2 | C02 S1 `TOTAL_S − SERVER_S` 가 큼 (사내 ≈ 0.1~0.2s) | 네트워크·프록시·FE 수신 | 응답 크기·인프라 |
| 3 | C02 S1 `PRE_DB_S` 가 큼 | 커넥션 풀 고갈 / 권한체크 지연 | BE 풀·동시 요청 |
| 4 | C03 (B) `PHV비교 ≠` + BG 수십 배 | **실행계획 차이** | C04 로 계획 확인 → 5·6·7 로 분기 |
| 5 | C04 에서 `GT_DMF0082_*` E-Rows ≈ 1, 실제 수만 / `MERGE JOIN CARTESIAN`·`NESTED LOOPS` | GTT 카디널리티 오추정 (07-31 DMF0003 유형 · 파싱 시점 고정) | 해당 GTT 1본만 적재 직후 세션 통계 수집 또는 힌트 — **SP 의 GATHER 대상인지 먼저 확인, LOCK 금지** |
| 6 | C04 에서 영구 테이블 `TABLE ACCESS FULL` + C02 S3 `direct path read` 지배 | 인덱스 미사용 · C01 E3 결손 | 결손 인덱스 이관(사내 DDL) / 통계 재수집 |
| 7 | C02 S6 같은 SQL_ID 에 PHV 여러 개, 느린 PHV 가 최근 사용 | 나쁜 자식 커서 재사용 (BE 풀) | `SET_TABLE_STATS … NO_INVALIDATE=>FALSE` 로 무효화 후 재파싱 (SCM_MGR 은 `DBMS_SHARED_POOL` 불가) |
| 8 | C03 (B) `PHV same` · BG 비슷 · SEC_X 만 큼 · DR 큼 | 스토리지 IO / 버퍼 캐시 부족 | C02 S3 이벤트로 IO 계통 확인 → 인프라 |
| 9 | C03 (B) `PHV same` · BG_X ≈ C01 E4 ROWS_X | 데이터량 차이 | SP 구조 개선 (적재 후 삭제 → 선필터 등) |
| 10 | C03 (D) `parse count (hard)` 수백 · (B) `HP` 다수 | 하드파싱 과다 (통계수집·커서 무효화) | C01 E1 GATHER_ACTIVE 확인 |
| 11 | C03 (B) 상위가 `사내없음` | 클라우드 BODY 문장이 사내와 다름 | C01 E1 지문 확인 → 클라우드 원문 대조 |
| 12 | C02 S7 `❌ DS=0 커서` | dynamic_sampling 0 으로 파싱된 커서 잔존 | 해당 SQL 커서 무효화 + 클라우드 `ALTER SYSTEM … optimizer_dynamic_sampling=2` (DBA) |

## 4. 사내 기준값 (ZIOUI1 · 2026-09-30 · QRYPERF 적용 후 · ADMIN · 당월~+6개월 · Current)

**화면 경로 (C02 S1 과 같은 지표, 09-30 08:04~08:54 실측)**

| Division | DB_S | SERVER_S | TOTAL_S |
|---|---:|---:|---:|
| 40 | 3.97~4.36 | 4.44~5.24 | 4.44~5.44 |
| 81 | 4.78~5.14 | 5.32~5.60 | 5.32~5.60 |
| 82 | 4.94~6.05 | 5.65~7.08 | 5.65~7.08 |

**SP 직접 (C03 2회차, 09:30 경)**

| Division | SP | 커서 fetch | DB 합 | 결과 행수 RC1 |
|---|---:|---:|---:|---:|
| 40 | 2.50s | 0.47s | 2.97s | 2,098 |
| 81 | 3.04s | 0.57s | 3.61s | 2,394 |
| 82 | 3.54s | 0.74s | 4.28s | 2,622 |

- 문장 귀속률 99% 이상 (귀속 합 ≈ DB 합) · 동적샘플링 재귀 0초 · 하드파싱 0 (2회차) · DR 0 · 대기 거의 전부 ON CPU.
- 1회 1초 넘는 문장 없음. 상위 3: `18xg1y5298qgq`(MF_SP INSERT, L3899) 0.5~0.8s · `fk3tvpkzsq2vx`(결과 PIVOT SELECT, L4423) 0.5~0.7s · `12v19yag54ut1`/`631pzfvq8r0ut`(TEMP_FCST_N_PRICE INSERT) 0.4~0.6s.
- `DB_S`(화면) − `DB 합`(C03) ≈ 1s = JDBC 전송 + BE 결과 JSON 로그 직렬화 (`SystemLogAspect` 가 DAO 종료 시각을 직렬화 뒤에 기록).
- 사내 V$SQL 에는 개선 전 커서 `b6wn3kx02pryu`(L1243, `SCM_MST_FUTURE_PRICE` 풀스캔)가 아직 남아 있다 (해당 자식 커서 일부 1회 37~131초). 클라우드에서 이 SQL_ID 가 C02 상위에 나오면 **QRYPERF 미적용 상태**라는 뜻이다 (적용 후 문장은 `3d2xnx839ksnt`, L1237).

## 5. 회신 요청

C01 (QA·DEV) · C02 · C03 출력 파일 + C04 (상위 SQL_ID 1~3개). 결과를 받으면 §3 판정표로 원인을 확정하고, 조치 SQL 을 사내 선검증 후 클라우드 패키지로 만든다.

## 6. 파일 구성

| 파일 | 용도 |
|---|---|
| `C01~C04_*.sql` | 클라우드 실행용 (위 순서) |
| `_c01_template.sql` · `_build_c01.py` · `_collect_corp_baseline.py` · `_corp_baseline.json` | C01 의 사내 기준값 채취·삽입 (재채취: `python _collect_corp_baseline.py && python _build_c01.py`) |
| `_build_c03_baseline.py` · `_corp_C03_out.txt` | C03 의 사내 SQL_ID 기준값 254건 삽입 원천 |
| `_run_on_corp.py` | 이 SQL 들을 사내 ZIOUI1 에서 그대로 실행하는 검증기 (`python _run_on_corp.py C02_SCREEN_LOG_ASH.sql -D MIN=120`) |
| `_corp_C02_out.txt` · `_corp_C03_verify.txt` · `_corp_C04_out.txt` | 사내 검증 실행 결과 (클라우드 결과와 나란히 비교용) |
