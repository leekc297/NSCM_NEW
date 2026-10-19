# DMF0082 — 클라우드 Division 81 조회 TIMEOUT 검증 SQL 세트 (2026-10-09)

> 대상: `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA` (화면 [Search] · `FcstNPrice/SEARCH/call-proc`) — **81 만 TIMEOUT, 40 은 느려졌으나 완료**
> 목적: 클라우드에서 81 조회가 **어느 문장(SQL_ID · BODY 줄) · 어느 접근경로 · 어느 대기** 에서 시간을 쓰는지 특정하고, 사내 기준과 대조한다.
> 모든 스크립트는 **READ-ONLY · 값 입력 없이 파일 전체 F5** 실행 가능 (D03 만 SP 를 실행하나 GTT 만 채우고 매 회 ROLLBACK). 계정 `SCM_MGR`.
> 사내 ZIOUI1 에서 6본 모두 그대로 실행 검증 완료 (2026-10-09 15:10~15:30, 문법·권한 오류 0) — 사내 기준값은 스크립트에 내장.
> 룰: `oracle-perf-fix-priority-order.md`(#129) 0-a/0-b 단계 — **대상 환경(클라우드) 실측 전 수정 착수 금지 · 힌트 임의 추가 금지**.

> ⭐ **10-09 16:00 갱신**: 클라우드 QA D05·D07 결과로 원인 확정 — 10-09 12:08 PKG_DMF0082 재컴파일('/' 패키지) 직후 재파싱에서 GTT 1행 추정(c3bg6q8n39195 카르테시안·d019r0hbb0muh PHV 3633386171 3,711초). 조치 = GTT 통계 고정 패키지 [DMF0082_GTTSTATS_CLOUD_20261009](../../_deploy_packages/DMF0082_GTTSTATS_CLOUD_20261009/00_README.md). 클라우드가 RAC(OCGSCMQ1)라 D01/D02/D04/D05 의 V$ 뷰를 GV$ 로 전환(INST_ID 조인 포함). D07 = '/' vs AJS 시간축 판정 추가.

## 1. 실행 순서

| 순서 | 파일 | 언제 | 소요 | 회신 파일 |
|---:|---|---|---|---|
| 1 | [D01_ENV_BODY_STATE.sql](D01_ENV_BODY_STATE.sql) | 아무 때나 · **QA / DEV 둘 다** | 수 초 | `D01_ENV_BODY_STATE_OUT.txt` |
| 2 | 클라우드 화면에서 **Division 81 Search** (타임아웃까지 기다림) → 이어서 **Division 40 Search** | — | — | — |
| 2' | 81 Search 를 누른 뒤 **1~4분 사이** 에 [D05_TIMEOUT_LIVE.sql](D05_TIMEOUT_LIVE.sql) 1회 (살아 있는 세션·문장·계획을 잡음) | 조회 중 | 수 초 | `D05_TIMEOUT_LIVE_OUT.txt` (1차) |
| 3 | [D02_SCREEN_LOG_ASH_81.sql](D02_SCREEN_LOG_ASH_81.sql) | **2 직후** (BE 가 붙은 DB) | 수 초 | `D02_SCREEN_LOG_ASH_81_OUT.txt` |
| 4 | [D04_PLAN_OF_SQLID.sql](D04_PLAN_OF_SQLID.sql) | 3 직후 — [P0] 가 ASH 상위 3 SQL_ID 계획을 **자동** 출력. D02 [S2]/[S2c] 의 SQL_ID 를 `DEFINE SQL_ID` 에 넣어 재실행하면 [P1]~[P6] | 수 초 | `D04_PLAN_OUT.txt` |
| 5 | [D06_81_DATA_PROFILE.sql](D06_81_DATA_PROFILE.sql) | 아무 때나 | 수십 초 | `D06_81_DATA_PROFILE_OUT.txt` |
| 6 | [D03_SP_STAGE_PROFILE_81.sql](D03_SP_STAGE_PROFILE_81.sql) | 한가한 때 (BE 가 붙은 DB) — 81 → 40 각 2회 SP 직접 실행 · **81 이 타임아웃급이면 그만큼 걸림(세션 제한 없음, 끝까지 둔다)** | 81 소요 × 2 + 40 | `D03_SP_STAGE_PROFILE_81_OUT.txt` |
| 6' | 타임아웃 후 [D05_TIMEOUT_LIVE.sql](D05_TIMEOUT_LIVE.sql) 1회 더 ([T5]~[T10] 이력 판정) | 타임아웃 후 | 수 초 | `D05_TIMEOUT_LIVE_OUT.txt` (2차) |

- SQL Developer: 파일 열고 **스크립트 실행(F5)**. D03 은 `DBMS_OUTPUT` 이라 스크립트 출력 창 또는 SPOOL 파일로 확인.
- D03 의 `c_user`/`c_group` 을 **타임아웃을 본 사용자의 로그인 ID / D02 [S1] USER_GROUP** 으로 바꾸면 그 사용자 메저 조건으로 재현된다 (09-30 k0101 사례 — 메저 선택이 많은 계정에서만 폭발).
- ⚠ 클라우드는 **QA·DEV 2개 DB** — D01 [E0] 결과를 BE datasource 와 대조해 **BE 가 보는 DB** 에서 D02~D06 실행.
- 권한 없는 뷰(`V$SQL_MONITOR`·`DBA_HIST_*`·`DBA_TEMP_FREE_SPACE`)는 그 문장만 오류 — 무시하고 나머지 결과 회신.

## 2. 무엇을 보나 (섹션별)

| 파일 | 섹션 | 확인 내용 |
|---|---|---|
| D01 | E0 | 접속 DB (QA/DEV) |
| | **E1** | PKG_DMF0082 BODY 판본 — 사내 현재 지문 `17034/885965` + **패치 마커 12종** 대조 (QRYPERF 22 · CLOUDPERF 3 · ONEREAD 3 · CUSTEXCEL 6 · FXZERO 10 · 81SP 2 · **81MKTAMT 10** · BTNAUTH 2 · AJS_1008 4 · IDX02_HINT **0** · DS2 7 · GATHER_ACT **0**) |
| | E2 | 옵티마이저 파라미터 14종 사내 대조 (`optimizer_dynamic_sampling` 등) |
| | E3 | 81 원천 7 테이블 인덱스 사내 대조 — 결손·상이·UNUSABLE 만 출력 (사내 25본) |
| | E4 / E4b | 11 테이블 행수·통계일·STALE·잠금 + 핵심 컬럼 NDV·히스토그램 |
| | E5 / E6 | `GT_DMF0082_*`(사내 34본) 통계 잠금·고정값 / 60초↑ 타 세션 |
| D02 | **S1 / S1b** | 화면 Search 호출 이력 — division 별 **DB / SERVER / TOTAL** + 요약 (`SCM_COM_SYS_LOG`) |
| | **S2** | ⭐ **81 호출 시간창 안의 ASH 만** 골라 SQL_ID 순위 (81 귀속) · TAG = 81MKTAMT / ONEREAD / 실적arm |
| | S2b / S2c | 전체 PKG 진입 ASH (대체) / 호출(세션×실행) 단위 소요와 TOP1·TOP2 SQL |
| | S3 / S4 | 대기 이벤트 구성 / 상위 5 문장의 계획 라인·오브젝트 핫스팟 |
| | S5 / S6 / S7 / S8 | V$SQL 1회당 비용(TAG 포함) / 계획 여러 개 / 커서의 dynamic_sampling / BE 세션 설정 |
| | **S9** | AWR 7일 — 1회 10초↑ 이력 (ASH 창을 놓친 과거 타임아웃 · 10-02 전후 PHV 변화) |
| D03 | (A) | SP 시간 · 결과 커서 6개 fetch 시간 · 행수 + **사내 기준(2회차) 병기** |
| | **(B)** | 문장별 귀속 (V$SQL 델타) — 라인 · 초 · BG · DR · 하드파싱 + **사내SEC / SEC_X / 사내BG / PHV비교** (사내 75 SQL_ID 기준 내장) |
| | (C) / (D) | 내 세션 ASH / 세션 통계 델타 (논리·물리 IO · TEMP · CPU) |
| D04 | **P0** | ⭐ 자동 — ASH 상위 3 SQL_ID 의 계획(ALLSTATS LAST · Peeked Binds · Note) |
| | P1~P6 | 지정 SQL_ID 의 자식 커서·전문·계획·객체 통계·AWR 14일 PHV 이력 |
| D05 | T1 / **T1b** | 지금 도는 세션의 문장·대기 / 그 문장들의 계획 **자동** 출력 |
| | T2 / T3 / T4 | 잠금 사슬 / 원천 테이블 DML 잠금 / SQL Monitor |
| | T5 / T6 / T7 | 120분 화면 이력 / 호출×문장×대기 ASH / 1회 10초↑ 자식 커서 (TAG) |
| | T8 / T9 / **T10** | 객체 상태 / TEMP / **GTT 1행 추정 NESTED LOOPS 함정** (TEMP_SITE_ITEM 조인 문장 전부 · PERM_OBJS) |
| D06 | **V1** | 조회 기간 안 원천 행수 — division 별 **사내 대조** (81 vs 40 데이터량 가설 판정) |
| | V2 ~ V6 | 판가 원장 폭 / 사용자별 선택 메저 / 메저 메타 DIVISION 범위 / 81 메저 분포 / 실적 원장 13주 |

## 3. 판정표 — 결과 → 원인 → 조치 방향

| # | 관찰 | 원인 계통 | 조치 방향 |
|---:|---|---|---|
| 0 | D01 E1 마커 `⚠/❌` (특히 ONEREAD<3 · IDX02_HINT>0 · GATHER_ACT>0) | 09-30 패키지(누적본) 미적용 — 09-30 타임아웃 원인 그대로 | `DMF0082_CUSTEXCEL_CLOUD_20260930`(누적) 적용 여부 확인 후 재측정 |
| 1 | D02 S1b: 81 만 `DB_S` 수 분·NO_END, 40 은 수 초~수십 초 | DB 구간 — 81 분기 문장 | S2/S2c → D04 |
| 2 | D02 S2 상위 = `d019r0hbb0muh`(L1667, **ONEREAD 판가**) · EVT = `db file sequential read`/`cell single block physical read` · DR 큼 | **PK_SCM_MST_FUTURE_PRICE 범위스캔 + ROWID 랜덤읽기**(사내 cold 398s 재현, §4) — 클라우드 FUTURE_PRICE 가 사내 22배(07-31 실측)면 그 배수로 폭발 | #129 순서: 1-b 소비집합 선행축소 → 3 SARGable/기존 인덱스(IDX02 가 왜 안 쓰이나 — LEAST/GREATEST 바인드 범위) → 4 인덱스 제안 → 5 힌트는 승인 후 |
| 3 | D02 S2 상위 TAG=`81MKTAMT`(L1612·2390·2805, `DM_PLN_SALES_PLAN` GROUP BY) | 10-02 신규 arm — 사내는 MKT_AMT 메저 메타가 40 전용이라 0행(0.01s). **클라우드는 81 메타가 열려 있어 실제 실행**됨 — 사내에서 실측 불가 | D04 계획: `DM_PLN_SALES_PLAN` 접근경로(IDX_N1 DIVISION_ID,YYYYMMDD 범위 vs 풀스캔)·GTT 조인 순서 확인 후 결정 |
| 4 | D04 P0/P3: `GT_DMF0082_*` E-Rows 1 인데 실제 수만 / `NESTED LOOPS` 안쪽 대형표 INDEX RANGE SCAN / `MERGE JOIN CARTESIAN` | GTT 카디널리티 오추정 (파싱 시점 고정 · 07-31 유형) | 해당 GTT 1본 적재 직후 세션 통계 또는 커서 무효화(`SET_TABLE_STATS NO_INVALIDATE=>FALSE`) — **SP GATHER 대상·LOCK 금지 확인** |
| 5 | D04 Peeked Binds `:B5='82'` 인데 81 조회가 그 자식 재사용 | 82 에서 파싱된 계획 공유 (81/82 공용 분기) | 커서 무효화 후 81 로 재파싱 → 재측정 |
| 6 | D02 S3 `direct path read` 지배 + D04 영구 테이블 `TABLE ACCESS FULL` | 풀스캔 (인덱스 미사용·결손 — D01 E3) | 결손 인덱스 이관 / 통계 재수집 |
| 7 | D05 T2 BLK_SID 있음 · T1 EVT `enq:`/`library cache pin` | 잠금·재컴파일 충돌 (T8 LAST_DDL 겹침) | 차단 세션 처리 / 적용 시간대 분리 |
| 8 | D05 T9 TEMP 큼 · T1 EVT `direct path write temp` | TEMP 유출 (PGA 부족 · WINDOW SORT 36K행 L1667) | PGA/TEMP 확인 · 윈도 범위 축소 |
| 9 | D06 V1 81 `CNT_X` ≫ 40 `CNT_X` | 데이터량 (그래도 타임아웃 = 계획 동반) | SP 구조 개선(선필터) |
| 10 | D06 V3 타임아웃 사용자 MEASURES 많음(CUST·AMT 선택) | 사용자 메저 의존 (09-30 k0101 유형) | 그 사용자 조건으로 D03 재현 → 해당 arm 특정 |
| 11 | D02 S7 `❌ DS=0 커서` | dynamic_sampling 0 으로 파싱된 커서 잔존 | 커서 무효화 + 클라우드 `ALTER SYSTEM … optimizer_dynamic_sampling=2`(DBA) |
| 12 | D03 (B) 상위가 `사내없음` | 클라우드 BODY 문장이 사내와 다름 | D01 E1 지문·마커로 원문 대조 |

## 4. 사내 기준값 (ZIOUI1 · 2026-10-09 15:07~15:20 · BODY 17034/885965 · ADMIN/minyonglee1 · 당월~+6개월 · Current)

**⭐ 사내에서도 81 1회차(콜드)가 406초 — 클라우드 증상과 같은 모양이 재현된다.** 2회차(캐시)는 4초.

| Division | 1회차 SP (콜드·하드파싱) | 2회차 SP (캐시) | fetch | RC1 행수 | 1회차 지배 문장 |
|---|---:|---:|---:|---:|---|
| 40 | 49.4s | 3.34s | 0.6s | 2,099 | `4svg4dhnqxh8f` L1267 (40 판가 LAST_DATA_SETUP_PRICE) 39.4s · DR 7,800 |
| **81** | **406.6s** | 4.15s | 0.7s | 2,383 | **`d019r0hbb0muh` L1667 (ONEREAD 81/82 판가 INSERT) 397.9s · CPU 1.9s · DR 29,948 · 122,092행** |
| 82 | 224.4s | 13.9s | 0.9s | 2,608 | 같은 `d019r0hbb0muh` 219.5s · DR 76,003 · 144,262행 |

- `d019r0hbb0muh` 계획(PHV 2682586817, `_corp_D04_d019r0hbb0muh_out.txt`): `PK_SCM_MST_FUTURE_PRICE` **INDEX RANGE SCAN(DIVISION_ID 만 access, YYYYMMDD 는 LEAST/GREATEST 바인드 filter) → TABLE ACCESS BY INDEX ROWID BATCHED 112K → HASH JOIN GTT → WINDOW SORT**. 시간의 99% 가 디스크 랜덤읽기(CPU 1.9s vs 398s) — 2회차는 DR 0 으로 1.07s. 사내 09-30 메모(1회 ~186s)와 같은 문장. IDX02(DIVISION_ID,YYYYMMDD,…) 는 선택되지 않음.
- 1회차 다른 문장: `c3bg6q8n39195` L1397 (81/82 수요 arm, DM_PLN_MKT_FCST) 3.9s · `19mfxqb34sbky` L855 (TEMP_SITE_ITEM_ALL) 2.1~5.1s · `18xg1y5298qgq` L4175 (MF_SP) 0.8s · `56fkh52zfndm7` L4705 (결과 SELECT) 0.7s.
- 81MKTAMT 금액 arm `gqk1z11svf3q3` L1612: 사내 0행·0.01s — **사내 메저 메타 MKT_AMT 가 DIVISION_ID='40' 단독**이라 81 조회에서 메저가 선택되지 않아 실행 자체가 비어 있다. 클라우드는 81 계열 메타가 열려 있어(10-02 사용자 확인 "클라우드에서 잘 보입니다") 실제로 실행된다 → **클라우드 D03/D02 S2 에서만 측정 가능**.
- AWR(사내 7일, D02 S9): `d019r0hbb0muh` 10-08 19:00 **2,765s(1회, 117만 행 처리)** · 10-02 18:00 114s — 사내 저장 작업과 겹친 재컴파일 직후로 추정, 클라우드와 무관하나 이 문장의 분산이 크다는 증거.
- 화면 경로(사내 SYS_LOG 7일): 40 평균 DB 169.7s(최대 793s, 사내 DB 부하일) — 사내는 81 화면 호출 이력 없음.

## 5. 회신 요청

D01 (QA·DEV) · D05(조회 중 1차) · D02 · D04 · D06 · D03 · D05(타임아웃 후 2차) 출력 파일. 결과를 받으면 §3 판정표로 원인을 확정하고, #129 순서(1-b → 3 → 4 → 5)로 조치안을 만들어 **사내 선검증 후** 클라우드 패키지로 만든다. 힌트는 승인 후에만.

## 6. 파일 구성

| 파일 | 용도 |
|---|---|
| `D01~D06_*.sql` | 클라우드 실행용 (위 순서) |
| `_run_on_corp.py` | 이 SQL 들을 사내 ZIOUI1 에서 그대로 실행하는 검증기 (`python _run_on_corp.py D02_SCREEN_LOG_ASH_81.sql -D MIN=240 -D SQL_ID=-`) |
| `_build_d03_baseline.py` · `_corp_D03_out.txt` | D03 의 사내 SQL_ID 기준값(75건) 삽입 원천 (2회차) — 1회차 콜드 수치는 §4 |
| `_corp_D01~D06_out.txt` · `_corp_D04_d019r0hbb0muh_out.txt` | 사내 검증 실행 결과 (클라우드 결과와 나란히 비교용) |
| 전편 | [DMF0082_CLOUD_PERFCHK_20260930](../DMF0082_CLOUD_PERFCHK_20260930/00_README.md) (C01~C07 · 09-30 타임아웃 = IDX02 힌트 NL → ONEREAD 로 철회) |
