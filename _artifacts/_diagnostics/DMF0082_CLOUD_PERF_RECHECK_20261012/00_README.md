# DMF0082 — 클라우드 조회 속도 재점검 SQL 세트 R01~R06 (2026-10-12)

> 대상: `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA` 와 화면 [Search] 가 쏘는 시트 호출 전부 (titleSet · version · spreadTitle · buttonAuth · **FcstNPrice(메인)** · futurePriceInfo · savePriceTitle · savePriceData)
> 배경: '/' 전환(SLASHDEF 10-08 · SLASHOBJ PKG 재컴파일 10-09 · 데이터 유입 10-11~) 뒤 클라우드 일부 조회가 느려진 체감. 09-30·10-09 선행 진단(C01~C07 · D01~D07) 이후 상태를 **전체 세션별 소요시간부터 다시 전수 측정**하고 튜닝 대상을 고르기 위한 세트.
> 룰: `oracle-perf-fix-priority-order.md`(#129) **0-a 호출별 전수 측정(>=2초만 대상) → 0-b 병목 문장 실측 → 1~4 근본 → 5 힌트(승인 후)**. 클라우드 실측 전 수정 착수 금지 · 힌트 임의 추가 금지.
> 모든 스크립트 **READ-ONLY · 값 입력 없이 파일 전체 F5** (R04 만 SP 를 실행하나 GTT 만 채우고 매 회 ROLLBACK). 계정 `SCM_MGR`. RAC 대비 `GV$` 사용.
> 사내 ZIOUI1 검증: 6본 전부 실행, 오류 0 (2026-10-12 00:30~01:30). 사내 기준값은 스크립트에 인라인.

## 1. 실행 순서

| 순서 | 파일 | 언제 | 소요 | 회신 파일 |
|---:|---|---|---|---|
| 1 | [R01_ENV_STATE.sql](R01_ENV_STATE.sql) | 아무 때나 · **QA / DEV 둘 다** | 1~3분 ([E5] 원천 3표 6개월 집계) | `R01_ENV_STATE_OUT.txt` |
| 2 | [R02_SCREEN_CALL_SESSIONS.sql](R02_SCREEN_CALL_SESSIONS.sql) | 아무 때나 (BE 가 붙은 DB) — **최근 14일 화면 호출 전수** | SYS_LOG 크기에 비례 (PK 외 인덱스 없음 — 섹션마다 1회 읽음, 수 분) | `R02_SCREEN_CALL_SESSIONS_OUT.txt` |
| 3 | 클라우드 화면에서 **Division 40 → 81 → 82 각 1회 Search** (가능하면 메저 선택이 많은 실사용 계정으로 한 번 더) | — | — | — |
| 3' | 느린 Search 가 돌고 있는 동안 [R06_LIVE_DURING_SEARCH.sql](R06_LIVE_DURING_SEARCH.sql) 1회 | 조회 중 | 수 초 | `R06_LIVE_DURING_SEARCH_OUT.txt` |
| 4 | [R03_DB_SESSION_SQL_ATTRIB.sql](R03_DB_SESSION_SQL_ATTRIB.sql) | **3 직후** (ASH 메모리 보관 중) | 수 초~1분 | `R03_DB_SESSION_SQL_ATTRIB_OUT.txt` |
| 5 | [R05_PLAN_OF_SQLID.sql](R05_PLAN_OF_SQLID.sql) | 4 직후 — [P0] 가 ASH 상위 3 SQL_ID 계획 **자동** 출력. R03 [D2] 상위 SQL_ID 를 `DEFINE SQL_ID` 에 넣어 재실행하면 [P1]~[P6] | 수 초 | `R05_PLAN_OUT.txt` |
| 6 | [R04_SP_STAGE_PROFILE.sql](R04_SP_STAGE_PROFILE.sql) | 한가한 때 — 40/81/82 각 2회 SP 직접 실행 (`DBMS_OUTPUT`) | 사내 1분 · 클라우드는 소요만큼 | `R04_SP_STAGE_PROFILE_OUT.txt` |
| 7 | [R07_MEASURE_SET_HISTORY.sql](R07_MEASURE_SET_HISTORY.sql) | 1차 결과 수신 뒤 — 사용자 메저 집합·변경 시점·titleSet SAVE 이력 (§8.4) | 수 초 | `R07_MEASURE_SET_HISTORY_OUT.txt` |
| 7' | R04 를 `c_user := 'k0101'` 로 1회 | 사내 k0101 과 같은 메저 조건 직접 대조 | 1~2분 | `R04_k0101_OUT.txt` |

- SQL Developer: 파일 열고 **스크립트 실행(F5)**. R04 는 `DBMS_OUTPUT` 이라 스크립트 출력 창 또는 SPOOL 로 확인.
- ⚠ 클라우드는 **QA·DEV 2개 DB** — R01 [E0] 로 BE datasource 와 대조해 **BE 가 보는 DB** 에서 R02~R06 실행.
- 권한 없는 뷰(`DBA_HIST_*`·`GV$SQL_MONITOR`·`DBA_TEMP_FREE_SPACE`·`DBMS_XMLGEN`)는 그 문장만 오류 — 무시하고 나머지 회신.
- R02 `DEFINE DAYS = 14`, R03/R05 `DEFINE MIN = 240` 은 필요 시 숫자만 바꾼다 (값 입력 없이도 전체 F5 가능).
- R04 의 `c_user`/`c_group` 을 R02 [C6] 에서 느리게 나온 사용자 ID/GRP 로 바꾸면 그 사용자 메저 조건으로 재현된다 (09-30 k0101 사례 — ADMIN 계정에서는 안 보인다).

## 2. 무엇을 보나 (섹션별)

| 파일 | 섹션 | 확인 내용 |
|---|---|---|
| R01 | E0 | 접속 DB (QA/DEV) |
| | **E1** | PKG_DMF0082 BODY 판본 — 사내 지문 `17034/885965`(10-09 16:32) + 마커 18종 (QRYPERF/NOSTATS/CLOUDPERF/ONEREAD/81MKTAMT/BTNAUTH/AJS/**SLASH 71·DASH 65 리터럴**/HINT 17·GET_MAIN 7/IDX02 0/DS2 7/GATHER 0) + GET_MAIN 힌트 줄 원문 |
| | **E2** | ⭐ 이 DB 의 이벤트 시각표 — SLASHDEF 테이블 ALTER · '/' DEFAULT 컬럼 수(사내 2,005 · '-' 잔존 87) · SLASHOBJ PKG LAST_DDL·'/' 리터럴 · GTTSTATS 6본 LAST_ANALYZED · 82/40 '/' 행 최초 생성 시각 |
| | E3 | 옵티마이저 파라미터 14종 사내 대조 |
| | **E4** | GT_DMF0082 GTT 6본 SHARED 통계 — 10-09 GTTSTATS 패키지 적용 여부 (사내 값 39070/8/14/72139/2834/72139 · LOCK 없음) + 6본 밖 고정 통계 |
| | **E5 / E5b** | ⭐ '/' 데이터 분포 — 조회 기간 PLANT_SITE_ID DASH/SLASH/VAL/NULL 행수 division 별(사내 대조) · 같은 키가 '-'/'/' 두 행으로 갈린 키 수(사내 0) |
| | E6 / E6b / E7 | 원천 통계·STALE·ALTER 이후 미수집 / PLANT_SITE_ID 포함 컬럼 통계 / 인덱스 결손 |
| | E8 | 60초↑ 타 세션 (노이즈) |
| R02 | C0 | 시트 × 액션(SEARCH/SAVE/FORM_DATA/UPLOAD…) 인벤토리 — 액션은 `MNU_BTN_CD` |
| | **C1** | ⭐ 호출별 전수 300건 — DB_S / SERVER_S / TOTAL_S / PRE_DB_S / BE_POST_S + 필터 유무 + JUDGE(`대상(>=2s)` / `NO_END` / `ERR`) |
| | **C2** | ⭐ 화면 Search 1회 묶음 — FcstNPrice 기준 ±창 안의 부속 시트 호출을 합쳐 "한 번의 조회 = 몇 초" (MAIN_DB_S · OTHER_DB_S · SHEETS 목록) |
| | **C3** | ⭐⭐ 시트 × division 요약(SEARCH 만) — N·MIN·MED·P90·MAX·>=2초 비율·NO_END → **튜닝 대상 선정표** |
| | **C4 / C4b** | ⭐ 일자 × division 추이(메인) / 일자 × 시트(부속) — 어느 날부터 뛰었나 |
| | **C5** | ⭐⭐ 이벤트 전/후 자동 비교 — PKG BODY LAST_DDL · SLASHDEF 테이블 ALTER · 82 '/' 행 최초 생성, 각 전후 중앙값·P90 배수 → 어느 이벤트 뒤 악화인지 |
| | C6 | 사용자별 소요 × 선택 메저(CUST/AMT) |
| | C7 | 같은 사용자·시트 5초 내 중복 호출 (FE 2회 호출 현상) |
| | C8 / C9 | 오류·NO_END 전수 / versionType·qtyYn·필터 유무별 소요 |
| R03 | **D1** | ⭐ DB 세션(INST×SID×SERIAL) 단위 활성 초 · CPU/IO/하드파싱 초 · TOP1/TOP2 SQL |
| | **D2 / D2b** | ⭐⭐ division 별 문장 귀속 — SYS_LOG SEARCH 호출 창 안 ASH 를 division 에 귀속해 SQL_ID 순위 + 사내 1회 초(CORP_SEC) + GTTSTATS 기대 PHV 대조 + TAG |
| | D3 / D4 | 대기 이벤트 / 상위 5 문장 계획 라인 핫스팟 |
| | D5 / D6 / D7 | GV$SQL 1회당 비용(사내 대조·10-09 타임아웃 PHV 표시) / 다중 계획 / DS=0 커서·BE 세션 |
| | **D8** | ⭐⭐ AWR 10-01~ 주요 15 SQL_ID 시간대별 1회 초·PHV — 느려진 첫 시각·계획 변경 시각 (GTTSTATS 적용본 PHV ✅ · 10-09 타임아웃 PHV ❌) |
| | D9 / D10 | AWR 일자별 PKG 총량 / AWR ASH 일자 × SQL_ID |
| | **D11** | GTT 1행 추정 NL 함정 — TEMP_SITE_ITEM 조인 문장 전부, E-Rows(사내 39070) · NL_RISK |
| R04 | (A) | SP 시간 · 커서 6개 fetch 시간 · 행수 + **사내 기준(2회차) 병기** |
| | **(B)** | 문장별 귀속(V$SQL 델타) — 라인 · 초 · BG · DR · 하드파싱 + 사내SEC/SEC_X/PHV비교 (사내 75 SQL_ID 기준 내장) |
| | (C) / (D) | 내 세션 ASH / 세션 통계 델타 |
| R05 | **P0** | ⭐ 자동 — ASH 상위 3 SQL_ID 계획(ALLSTATS LAST · Peeked Binds · Note) |
| | P1~P6 | 지정 SQL_ID 자식 커서·전문·계획·객체 통계·AWR 14일 PHV |
| R06 | T1 / T1b | 지금 도는 세션의 문장·대기 / 그 계획 자동 |
| | T2~T4 | 잠금 사슬 / DML 잠금 / SQL Monitor |
| | T5~T10 | 120분 화면 이력(액션 포함) / 호출×문장×대기 ASH / 10초↑ 자식 커서 / 객체 상태 / TEMP / GTT NL 함정 |

## 3. 판정표 — 결과 → 원인 → 조치 방향

| # | 관찰 | 원인 계통 | 조치 방향 (#129 순서) |
|---:|---|---|---|
| 0 | R01 E1 마커 ⚠/❌ (IDX02>0 · GATHER>0 · ONEREAD<3 · SLASH≠71) | 09-30~10-09 패키지 미적용/다른 BODY | 해당 패키지 적용 여부 확인 후 재측정 |
| 1 | R01 E4 `GTTSTATS 미적용` + R03 D11 NL_RISK=Y·E-Rows 1 + D5/D8 PHV ❌(248268428/3633386171/1149543853) | **재컴파일 뒤 GTT 1행 추정 재발** (10-09 TIMEOUT 기전) | `DMF0082_GTTSTATS_CLOUD_20261009` 적용 → 재측정 |
| 2 | R02 C5: `PKG BODY LAST_DDL` 이벤트에서만 RATIO≥1.5 | 재컴파일 → 커서 무효화·재파싱 계획 변화 | R03 D8 로 PHV 변경 문장 특정 → R05 계획 → 1-b/3/4 |
| 3 | R02 C5: `SLASHDEF 테이블 ALTER` 이벤트에서 RATIO≥1.5 + R01 E6 `통계가 ALTER 이전` | DEFAULT 변경 뒤 통계 미수집·선택도 오추정 | 통계 재수집(DBA) 후 재측정 |
| 4 | R02 C5: `82 '/' 행 최초 생성` 이벤트에서 RATIO≥1.5 + R01 E5 DASH·SLASH 공존 + E5b SPLIT_KEYS>0 | '/' 데이터 유입으로 같은 키 2행 → 조인 폭·PIVOT 행 분열 | '/' 데이터 정리(차주) — 코드 원복 아님 |
| 5 | R02 C3: FcstNPrice 만 대상, 부속 시트 <2s | 메인 SP 단독 문제 | R03 D2 → R05 |
| 6 | R02 C3: titleSet/spreadTitle/buttonAuth 도 2s↑ 간헐 | 공유 DB 부하·커넥션 대기(C1 PRE_DB_S) | C1 PRE_DB_S·R01 E8 로 부하 시간대 분리 |
| 7 | R02 C1: BE_POST_S ≈ DB_S 이상 | BE 직렬화·결과로그 (#129 §8 fetch 축) | SQL 아님 — F1~F4 |
| 8 | R03 D2 상위 = `d019r0hbb0muh` + EVT `db file sequential read` + DR 큼 | 판가 원장 PK 랜덤읽기(콜드) — 사내 1회차 406s 재현 계보 | 1-b 소비집합 축소 → 3 SARGable → 4 커버링 인덱스/요약 테이블 제안(결정 대기 건) |
| 9 | R03 D2 상위 TAG=`81MKTAMT`(`gqk1z11svf3q3` 등) | 10-02 금액 arm — 사내 메저 메타 40 전용이라 사내 측정 불가 | R05 계획(DM_PLN_SALES_PLAN 접근경로) → 1-b/3/4 |
| 10 | R03 D2 상위 TAG=`실적 arm`(`2nysu9tbng9v4` L2089) + C6 느린 사용자 CUST_SEL>0 | CUST 종속 실적 arm (09-30 k0101) | 그 사용자로 R04 재현 → arm 특정 |
| 11 | R03 D5/D7 `❌ DS=0 커서` | dynamic_sampling 0 으로 파싱된 커서 잔존 | 커서 무효화 + 시스템 파라미터(DBA) |
| 12 | R02 C7 FcstNPrice DUP_PAIRS>0 | FE 가 Search 를 2회 전송 | FE 원인 (SQL 과 별개) |
| 13 | R04 (B) 상위가 `사내없음` | 클라우드 BODY 문장이 사내와 다름 | R01 E1 지문·마커로 원문 대조 |
| 14 | R04 (B) DR 큼·CPU 작음·PHV same | 캐시 밀림(공유 DB I/O 부하) — 계획 문제 아님 | 한가한 때 재측정 (사내 10-12 00:17 1회차가 이 유형: 40 L605 8.8s DR 29,924 · 81 L1213 18.4s DR 41,584) |

## 4. 사내 기준값 (ZIOUI1 · 2026-10-12 · BODY 17034/885965 · GTTSTATS 적용 상태 · ADMIN/minyonglee1 · 당월~+6개월 · Current)

**R04 (단독 실행 01:10, 2회차 = R04 내장 기준)**

| Division | 1회차 SP | 2회차 SP | fetch | RC1 행수 | 2회차 최대 문장 |
|---|---:|---:|---:|---:|---|
| 40 | 2.79s | **2.87s** | 0.53s | 2,099 | `18xg1y5298qgq` L4175 MF_SP 0.57s · `56fkh52zfndm7` L4705 결과 0.52s · `631pzfvq8r0ut` L1850 0.43s |
| 81 | 3.87s | **3.69s** | 0.67s | 2,383 | `d019r0hbb0muh` L1667 ONEREAD 판가 0.99s(PHV 2054382907) · `18xg` 0.69s · `56fk` 0.66s |
| 82 | 4.93s | **4.54s** | 0.79s | 2,608 | `d019r0hbb0muh` 1.66s (10-09 9.47s → GTTSTATS 뒤 개선) · `18xg` 1.01s · `56fk` 0.79s |

- 1회 1초 넘는 문장은 `d019r0hbb0muh`(82 1.66s) 하나. `c3bg6q8n39195` 81 0.056s(PHV 294698915 HASH). GTTSTATS 적용본 PHV: c3bg 294698915 · d019 2054382907 · 6bucw 1088113275 · 18xg 3971101268.
- ⚠ 같은 날 00:17 1회차 실행(타 세션 3개 3.6시간 I/O 작업 중)은 40 11.9s / 81 22.1s — `0rp3b1v236wwz` L605 8.8s(DR 29,924) · `gfjpdh7fc1u59` L1213 18.4s(DR 41,584), CPU 0.3s, PHV 동일 → **캐시 밀림 I/O 노이즈**. 판정표 #14. 보존: `_corp_R04_out_run1_0017.txt`.

**R02 (SYS_LOG 14일, SEARCH 만)** — 사내도 콜드 구간은 타임아웃급:

| 시트 | DIV | N | MED_DB | P90_DB | MAX_DB | ≥2s |
|---|---|---:|---:|---:|---:|---:|
| FcstNPrice | 40 | 56 | 14s | 78s | 793s | 100% |
| FcstNPrice | 81 | 24 | 7.5s | 197s | 381s | 79% |
| FcstNPrice | 82 | 6 | 7s | 241s | 245s | 100% |
| titleSet / spreadTitle / buttonAuth / version | — | 127/52/49/87 | 0s | ≤1.4s | 4~7s | 2~11% 간헐 |

- 09-29 21:26·21:37 의 373s·868s 는 **SAVE** 호출 (액션 열이 없던 선행 D02/C02 에서는 조회로 집계됐음 — 이번 세트부터 `MNU_BTN_CD='SEARCH'` 로 분리).
- '/' 전환 상태(사내): SLASHDEF 테이블 ALTER 10-08 16:00~16:05 · '/' DEFAULT 2,005 컬럼('-' 잔존 87) · PKG BODY 10-09 16:32 · GTTSTATS 10-09 16:38 · 82 `PLANT_SITE_ID='/'` 6,586행 최초 10-11 17:24 · **E5b 분리 키 0** · 조회기간 분포: MKT_FCST 40 DASH 54,592/VAL 46,862 · 81 VAL 46,878 · 82 DASH 19,152/SLASH 6,586/VAL 7,534.

## 5. 회신 요청

R01(QA·DEV) · R02 · R06(조회 중) · R03 · R05 · R04 출력 파일. 결과를 받으면 §3 판정표로 원인을 확정하고 #129 순서(0-b → 1-b → 3 → 4 → 5)로 조치안을 만들어 **사내 선검증 후** 클라우드 패키지로 만든다. 힌트는 승인 후에만.

## 6. 파일 구성

| 파일 | 용도 |
|---|---|
| `R01~R06_*.sql` | 클라우드 실행용 (위 순서) |
| `_run_on_corp.py` | 이 SQL 들을 사내 ZIOUI1 에서 그대로 실행하는 검증기 (`python _run_on_corp.py R02_SCREEN_CALL_SESSIONS.sql -D DAYS=14`) |
| `_build_r04_baseline.py` · `_corp_R04_out.txt` | R04 의 사내 SQL_ID 기준값(75건) 삽입 원천 (01:10 단독 2회차) |
| `_corp_R04_out_run1_0017.txt` | 00:17 부하 중 1회차 (I/O 노이즈 사례, 판정표 #14) |
| `_corp_R01~R06_out.txt` | 사내 검증 실행 결과 (클라우드 결과와 나란히 비교용) |
| 전편 | [DMF0082_81_TIMEOUT_20261009](../DMF0082_81_TIMEOUT_20261009/00_README.md) (D01~D07 · GTTSTATS 원인 확정) · [DMF0082_CLOUD_PERFCHK_20260930](../DMF0082_CLOUD_PERFCHK_20260930/00_README.md) (C01~C07) |

## 8. 클라우드 QA 결과 판정 (2026-10-12 09:03~09:14 수신 · 원문 `_cloud_QA_R01-R06_out_20261012.txt`)

### 8.1 상태 (R01)
- BODY 17032/885680 — 사내와 차이는 10-08 AJS 저장 경로 4줄만(조회 무관). 힌트 7·'/' 리터럴 71·ONEREAD·QRYPERF 전부 동일 → **코드 차이 제외**.
- 이벤트: SLASHOBJ 재컴파일 10-09 12:08 · '/' 데이터 전환 10-10 ~11:50 · SLASHDEF ALTER 10-10 19:40~20:13 · 통계 수집 10-10 · GTTSTATS 10-11 23:37 (6본 PASS).
- '/' 데이터: 40·82 의 '-' 가 전부 '/' (DASH 0) · **분리 키 0** → '/' 전환 자체는 행을 가르지 않았다. 사내는 미전환('-')이라 E5 의 표기 차이는 결함 아님.
- 파라미터 차이 = adaptive_plans FALSE · cpu 48 · PGA 4GB (09-30 과 동일). 인덱스 결손 0. STALE = DM_PLN_SALES_PLAN_C 만.

### 8.2 호출 세션 (R02) — SEARCH 만
| 시트·DIV | N | MED | P90 | MAX | 판정 |
|---|---:|---:|---:|---:|---|
| FcstNPrice 40 | 175 | 18s | 38.6s | 90s | 대상 (98% ≥2s) |
| FcstNPrice 81 | 143 | 10s | 102s | 9,479s | 타임아웃급 (10-09 14:27~15:53 3건 4,720~9,479s = GTT 1행 추정, GTTSTATS 로 소멸) |
| FcstNPrice 82 | 4 | 10s | 14.5s | 16s | 대상 |
| savePriceData 40 | 2 | 14s | — | 19s | 대상(팝업, 별건) |
| titleSet·buttonAuth·version·spreadTitle | — | 0s | ≤0s | 1~19s | 제외 (spreadTitle 3건 간헐) |
- 일자 추이(C4): 81 10-06 6~9s → 10-09 4,720~9,479s(재컴파일 뒤) → 10-11 31~35s(GTTSTATS 뒤) · 40 10-06 9~13s → 10-09 25~48s → 10-11 17~23s → 10-12 22s.
- C5: PKG 재컴파일(10-09) 뒤 40 1.59배·81 4.25배 · SLASHDEF(10-10) 뒤 81 3.88배(표본 3). 부속 시트 변화 없음. 중복 호출(C7) FcstNPrice 40 34쌍·81 31쌍(FE 2회 전송, DB 낭비 1,294s).
- C6: 클라우드 minyonglee1 메저 9개(MKT_AMT_KRW·CUST_FCST 포함) · k0101 9개 · jaeuk.shin 9개. **사내 minyonglee1 은 LOC 1개** → §4 사내 기준(2.87/3.69/4.54s)은 비교 기준이 아니다.

### 8.3 문장 귀속 (R03·R04·R05) — 계획이 아니라 행수
| 문장 | 클라우드 minyonglee1(9메저) 40/81/82 | 사내 minyonglee1(1메저) | 사내 k0101(9메저, 부하 중) | 판정 |
|---|---|---|---|---|
| `18xg1y5298qgq` L4182 MF_SP INSERT | 5.3s/7.7s/16.7s · 행 152K/205K/437K · TEMP 108~268MB | 0.57/0.69/1.0s · 49K/59K/70K | CPU 2.0/2.3/3.5s · **152K/185K/213K** | 행수는 메저 집합이 결정(40 은 사내 k0101 과 클라우드가 152K 동일) · 같은 행수에 클라우드 CPU 2.3배 |
| `b66195aqtf5qn` L4705 결과 PIVOT SELECT | 5.2s/4.9s/13.4s · 8,041/8,239/16,365행 | 0.5~0.8s · 2,099~2,608 | 1.6/2.1/3.2s · 6,906/7,628/8,105 | 행수 비례 + 클라우드 CPU 2.7배 |
| `d019r0hbb0muh` L1667 판가 ONEREAD | 3.9s/10.1s(82) · 189K/435K행 · IDX02 RANGE+HASH · WINDOW SORT TEMP 204MB | 0.99/1.66s · 117K/139K | (콜드 I/O 노이즈) | 82 판가 원장이 사내 2.1배(465,897 행) |
| fetch(커서) | 5.2/4.9/13.5s | 0.5~0.8s | 1.6/2.1/3.3s | 결과 행수 비례 |
- 계획: 클라우드 18xg(PHV 1292870751)·사내(3971101268) 모두 **HASH 조인 + `MERGE JOIN OUTER`+`BUFFER SORT`+`VW_LAT`(L4310 VD 인라인뷰, ON 절의 `p_division_id='82'` 가 lateral 로 전개되어 F 행마다 재평가)** 같은 구조. GTT E-Rows 39070/19535 = GTTSTATS 반영. NL 함정 0. DS=0 커서 27개는 평균 0.003s 로 무해.
- D8/D10: 18xg 1회 처리행 10-06 58K → 10-07 152K → 10-08 161~195K → 10-11 186K → 10-12 265K 로 증가(같은 PHV) — 메저 추가에 따른 행수 증가가 시간 증가의 실체. 10-09 의 3,711s/2,213s 는 GTT 1행 추정(PHV 3633386171) 별건.

### 8.4 결론 (0-a/0-b 완료 · 수정 미착수)
1. **'/' 전환은 원인이 아니다** — 코드·계획·GTT 통계 동일, 분리 키 0, 10-09 TIMEOUT 은 재컴파일 재파싱(GTTSTATS 로 해소).
2. 느려진 실체 = **처리 행수 증가(선택 메저 9개, CUST_FCST 고객 축 분할)** × **클라우드 행당 CPU 2~2.7배** × 82 판가 원장 2.1배. 같은 메저 조건(k0101) 사내 행수와 클라우드 행수가 거의 같다.
3. #129 순서 후보 (승인 후 착수): **1순위** L4310 VD 인라인뷰 lateral 해소(조건을 뷰 안으로·사전 1회 적재) · **1-b** MF_SP INSERT 의 60여 속성 MAX() 집계를 키 단위 분리(집계는 QTY 만, 속성은 키 GTT 조인) 로 SORT GROUP BY 입력 축소(TEMP 유출 108~268MB 제거) · 결과 PIVOT fetch 는 #129 §8 F1/F3(전부 NULL 컬럼·행 축소). 힌트 없음.
4. **R07 로 확정 (`_cloud_QA_R07_out_20261012.txt`)**: minyonglee1 메저 집합 변경 이력 = 10-02 18:05 **1개** → 10-06 10:20 **6개**(81 6~9s 구간) → 10-09 11:06 7개 → 13:35 8개 → **15:11 9개**(MKT_AMT_KRW·CUST_FCST 추가, 이후 81 31~35s · 40 17~23s). 느려진 시각과 메저 추가 시각이 일치. 클라우드 실사용자 24명 중 대부분은 기본 세트 7개(CUST_FCST 포함)라 운영에서도 81 조회는 10초대 이상이 예상되며, 튜닝 목표(3초)는 여전히 유효. MKT_AMT 는 40·81계열, CUST_FCST 는 81계열에만 열려 있음(82 는 둘 다 없음 → 82 의 48s 는 판가 2.1배 + CPU).
5. 클라우드 R04 `c_user := 'k0101'` 1회는 선택 사항(행수 대조는 사내 k0101 로 이미 성립).

### 8.5 조치 결과 (10-12 오후)
- **1순위 LATFIX 사내 적용 10:31(리허설 재적용 10:46)** `[E20261012-DMF0082LATFIX]` — VD 인라인뷰 ON 절 바인드 조건을 뷰 안으로. 복제본 6커서 전행 동등성 6/6 PASS. MF_SP INSERT 1회 CPU 1.15→0.47~0.64s(1메저) · 1.33~1.70→0.95~1.51s(9메저), 계획 VW_LAT·MERGE JOIN 소멸. 클라우드 패치형 패키지 `_deploy_packages/DMF0082_LATFIX_CLOUD_20261012/` (00→10→90, 롤백 99) 사내 왕복 리허설 통과 · **클라우드 미적용**.
- **1-b NOGRPBY 폐기** — MF_SP INSERT 의 GROUP BY 가 항등(사내 실측 그룹=행 1:1)이라 제거하면 CPU 0.31~0.65s 로 더 줄지만, 시나리오 매트릭스 `Current,MF_W_…`(복수 버전 동시 조회)에서 FAIL(40 해시 상이 · 81 7,674→8,602행). 원인: 중복제거 블록(L3737~3749)의 키가 **전 컬럼(VERSION_NO 포함)** 이라 MF_SP GROUP BY 키(VERSION_NO 제외) 유일성은 구조 보장이 아니었고, 복수 버전 행을 원본은 SUM/MAX 로 합친다. 측정된 유일성 ≠ 구조적 유일성. 결과 동일 요건 위반 → 적용 안 함(파일 `_not_shipped_NOGRPBY/`).
- 부수 관찰: 사내 Cutoff 버전 조회(SF_W 40 898s · MF_W 81 905~1,292s)는 당일 AJS 의 `DM_PLN_MKT_FCST_C` 인덱스 재생성(병렬, 4시간↑) 중 측정 — 별건, 부하 해소 뒤 재측정 필요.

## 7. 선행 세트와 다른 점

1. **호출 세션 전수 축 신설 (R02)** — 시트 전부 × 액션 분리 × 호출 1회 묶음 × 이벤트 전/후 자동 비교. 선행 D02 [S1] 은 FcstNPrice 1시트·SAVE 미분리였다.
2. **'/' 전환 상태 축 신설 (R01 E2/E5/E5b)** — DEFAULT·객체·통계·데이터 유입 4 이벤트 시각 + DASH/SLASH 분포 + 분리 키.
3. **GTTSTATS 적용 상태 축 (R01 E4 · R03 D8/D11)** — 10-09 패키지 적용 여부와 기대 PHV 를 기준으로 판정.
4. R04 사내 기준값을 GTTSTATS 적용 뒤 값으로 갱신 (10-09 D03 기준은 적용 전 PHV).
