# Qlik Replicate → 클라우드 QA `SCP_ANL_SHIPMENT_PLAN_FG_C` 적재 지연 진단 SQL (2026-10-14)

> 증상: Qlik Replicate(ETL)로 `SCP_ANL_SHIPMENT_PLAN_FG_C`(1억 건 이상)를 클라우드 QA 오라클에 적재할 때 지연이 큼.
> 목적: 지연이 **DB 쪽**(인덱스 유지·Redo·스토리지·CPU)인지, **Qlik/원천/네트워크 쪽**(DB 가 데이터를 기다림)인지 실측으로 가른다.
> 룰: `oracle-perf-fix-priority-order.md`(#129) 0-b — **병목을 실측으로 특정하기 전에 조치하지 않는다.**
> 3본 모두 **조회 전용 · 값 입력 없음 · 파일 전체 F5** · 바인드/`DEFINE`/`&` 0개 · 탭 문자 0개. 계정 `SCM_MGR`. RAC 대비 `GV$`.
> 사내 ZIOUI1 모사 실행: 3본 모두 **오류 0** (2026-10-14 18:49~18:57, `_corp_*_out.txt`). 사내 기준값은 스크립트 안 CORP/JUDGE 열에 인라인.

## 1. 실행 순서

1. [Q01_ENV_TABLE_STATIC.sql](Q01_ENV_TABLE_STATIC.sql) — **아무 때나 1회**. DB 로깅 모드·Redo 구성·파라미터·대상 테이블 구조·Qlik 제어 테이블. 회신 `Q01_ENV_TABLE_STATIC_OUT.txt`
2. [Q02_LIVE_DURING_LOAD.sql](Q02_LIVE_DURING_LOAD.sql) — ⭐ **Qlik 이 이 테이블을 적재하는 동안** 실행. 5~10분 간격으로 2~3회 실행하면 진행 속도까지 보임(회신 파일명 뒤에 `_1`/`_2`). 회신 `Q02_LIVE_DURING_LOAD_OUT.txt`
3. [Q03_HISTORY_AFTER_LOAD.sql](Q03_HISTORY_AFTER_LOAD.sql) — 적재 후, 또는 이미 지난 느린 적재를 볼 때. ASH 메모리 4시간 + AWR 8일. 회신 `Q03_HISTORY_AFTER_LOAD_OUT.txt`

4. [Q04_QLIK_APPLY_EXCEPTIONS.sql](Q04_QLIK_APPLY_EXCEPTIONS.sql) — (10-14 추가) Q01 [S6] 에서 SCM_MGR."attrep_apply_exceptions" 287,194행 확인 → 테이블별·오류코드별·시간대별 집계 + FG_C 오류 표본 + attrep_changes 크기. 아무 때나. 회신 `Q04_QLIK_APPLY_EXCEPTIONS_OUT.txt`

- SQL Developer: 파일 열고 **스크립트 실행(F5)**. 각 파일이 같은 폴더에 `*_OUT.txt` 를 SPOOL 한다(출력 창 내용을 그대로 복사해 보내도 됨).
- 권한 없는 뷰(`DBA_*`·`DBA_HIST_*`·`GV$ARCHIVE_DEST` 등)는 **그 문장만** ORA-00942 — 무시하고 나머지를 회신.
- 같이 보내 주시면 판정이 빨라지는 Qlik Task 설정: Target table preparation(Do nothing / Truncate / Drop and Create) · Full Load commit rate · Oracle 타깃 "Use direct path full load" · Apply 모드(Batch optimized / Transactional) · Parallel Load 사용 여부 · Qlik 서버 위치(사내/클라우드).

## 2. 판정 기준 (어디를 보면 되나)

| 질문 | 볼 곳 | 판정 |
|---|---|---|
| ⭐ DB 가 느린가, Qlik/원천이 느린가 | Q02 **[L3]** | `SQL*Net message from client` 가 50% 이상 → **DB 는 Qlik 이 보내 주길 기다리는 중**(원천 MSSQL 읽기·네트워크·Qlik 서버 병목). DB CPU·User I/O·Commit·Configuration 이 크면 **DB 쪽** |
| Redo 로그가 작은가 | Q01 [S2]·[S2b] · Q02 [L8]·[L8b]·[L9] · Q03 [H7]·[H8] | `log file switch (checkpoint incomplete)` 발생 = Redo 과소. 사내는 1회 평균 **33초 정지**, 적재 시 시간당 10~13회 스위치 |
| direct path 로 적재 중인가 | Q02 [L2] 잠금 모드 · [L5] LOAD 열 · Q03 [H5] | 모드 6(X) 또는 `INSERT /*+ SYS_DL_CURSOR */ INTO RELATIONAL(...)` = direct path. 모드 3 + 일반 INSERT = conventional(행마다 인덱스 3개 갱신) |
| Redo 가 전량 생성되는가 | Q01 [S1] | `ARCHIVELOG + FORCE_LOGGING=YES` → direct path·NOLOGGING 이어도 Redo 전량. 사내는 NOARCHIVELOG |
| 인덱스 유지가 병목인가 | Q02 [L3] `db file sequential read`·DB CPU · [L6b] 객체 | 대기 객체가 `PK_`/`IX01_`/`IX02_` 에 몰리면 인덱스 유지 비용 |
| 스토리지 쓰기가 느린가 | Q02 [L8b] · Q03 [H7] AVG_MS | `direct path write`·`log file parallel write` 10ms 초과. 사내 direct path write 평균 26.7ms |
| Qlik 배치 크기 | Q02 [L5]·Q03 [H5] `ROWS_PER_EX` · [L4] COMMITS | 실행당 행수 = Qlik 배치. 커밋 수 대비 적재 행수 = 커밋 단위 |
| CPU 경합 | Q02 [L7] Host CPU · [L12] · Q03 [H3] | 같은 시각 다른 무거운 세션 / `resmgr:cpu quantum` |
| 테이블 구조가 사내와 같은가 | Q01 [S5]~[S5f] | 사내: 파티션 없음 / 40컬럼 / PK 12컬럼 / 인덱스 3개 / 트리거·FK·MV 로그 0 / 보조로그 그룹 1(PK) |

## 3. 사내 ZIOUI1 기준값 (2026-10-14 실측 — 비교용)

| 항목 | 사내 |
|---|---|
| 로깅 | NOARCHIVELOG / FORCE_LOGGING NO / 스탠바이 없음 |
| Redo | 2,048MB × 3그룹 × 1멤버 · 10-14 13~14시 시간당 10~13회 스위치 |
| 대기 누적 | log file switch (checkpoint incomplete) 29회 · 평균 33,285ms / direct path write 평균 26.6ms |
| 자원 | CPU 8 · SGA 128GB(버퍼 캐시 113GB) · PGA 32GB · UNDO 7.7GB · filesystemio_options=none |
| 테이블 | 47,184,760행 · 행 197B · 테이블 10.34GB · PK 5.52GB(BLEVEL 4) · IX01 1.85GB · IX02 0.97GB · 파티션 없음 |
| 1억 건당 예상 증가 | 테이블 약 21.8GB + 인덱스 약 17GB (현재 통계 비례 — 참고치) |
| Qlik 흔적 | `SCM_MGR."attrep_apply_exceptions"` (10-09 Data Pump 복원 때 함께 생성, 0행) |
| direct path 문장 형태 | `INSERT /*+ SYS_DL_CURSOR */ INTO RELATIONAL("SCM_MGR"."SCP_ANL_SHIPMENT_PLAN_FG_C" ...)` (10-09 Data Pump 복원 시 AWR) |

## 4. 부속 파일

- [_run_on_corp.py](_run_on_corp.py) — 사내 F5 모사 러너. `&`·탭 문자가 있으면 오류로 판정(클라우드 클라이언트에서 DEFINE 치환이 안 되는 사례 대비).
- `_corp_Q01_ENV_TABLE_STATIC_out.txt` · `_corp_Q02_LIVE_DURING_LOAD_out.txt` · `_corp_Q03_HISTORY_AFTER_LOAD_out.txt` — 사내 실행 결과(오류 0).

## 5. 사내 모사 중 정정한 것 (기록)

- 테이블명이 **문자열 안에** 들어간 무관한 INSERT(예: 백업 테이블에 소스 원문 적재)가 적재 SQL 로 잡히는 오탐 → 테이블명 LIKE 대신 **DML 대상 정규식**(`INSERT/UPDATE/DELETE/MERGE … [RELATIONAL(] [스키마.]SCP_ANL_SHIPMENT_PLAN_FG_C`)으로 교체.
- PDB 에서는 `GV$SYSMETRIC`·`GV$EVENTMETRIC`·`DBA_HIST_SYSMETRIC_SUMMARY` 가 0행 → `GV$CON_SYSMETRIC`·`DBA_HIST_CON_SYSMETRIC_SUMM` 를 UNION 하고(SRC 열로 구분), 최근 60초 이벤트는 ASH 10분 집계로 대체.
- 보조로그 그룹(PK) 1건은 사내에도 있으므로 "부속 객체" 경고 판정에서 제외하고 목록에만 표시.

## 6. 클라우드 QA Q01 1차 결과 요약 (2026-10-14 19:49, OCGSCMQ_P01 · RAC 2노드 · Exadata ASM)

- NOARCHIVELOG / FORCE NO / 스탠바이 없음 → 아카이브·Data Guard 원인 **제외**
- Redo 1GB × 10그룹 × 2스레드. 스레드1 로그 스위치 10-11 20시 ~ 10-13 03시 **시간당 100~170회(20~30초 간격)** — DB 전체 Redo(다른 Qlik 작업 포함, FG_C 단독 귀속 불가)
- ⭐ SGA 12GB · **버퍼 캐시 4.6~5.7GB** (사내 116GB) · PGA 4GB · CPU 48
- FG_C 108,883,348행(통계 10-13 22:25) · 테이블 23.81GB · 인덱스 합 23.78GB(PK 13.29 / IX01 6.8 / IX02 3.69) · 파티션 없음 · 구조 사내와 동일
- Qlik: SCM_MGR `attrep_apply_exceptions` 287,194행 · `attrep_changes*` 다수(10-13~14 생성 = CDC 일괄 적용 진행 중). INF_MGR 646,162 · ENG_SCP 11,478
- 출력이 [S6] 에서 잘려 [S6b]·[S7] 미수신

## 7. 클라우드 QA Q04 결과 요약 (2026-10-14 19:53)

- SCM_MGR `attrep_apply_exceptions` 287,951행 · 기간 **09-28 10:50 ~ 10-06 18:51** (10-07 이후 0건)
- **SCP_ANL_SHIPMENT_PLAN_FG_C 오류 0건** → 원인 ②(Qlik 적용 오류로 1건씩 재적용) **FG_C 에는 해당 없음**
- 오류 대부분: `RE - Test` 작업 SCP_PLN_ALLOCATION "Error creating Net Changes" 216,138 (09-30 1분간) · ORA-20999 "0 rows affected" 70,992 (09-28~29, 9테이블) · ORA-00001 PK 위반 소량
- Qlik 작업명: `QA - SCMDEV CDC` · `QA - SCMDEV CDC - SCP SSP`(SCP 계열 — FG_C 소속 추정) · `RE - Test`
- `attrep_changes*` 는 세그먼트 없음(비어 있음) → 현재 CDC 적용 대기분 거의 없음
- 남은 원인 후보: ① 인덱스 23.8GB vs 버퍼 캐시 약 5GB(물리 읽기) · Redo 스위치 폭증(10-11 20시~10-13 03시) → Q03 [H4]·[H7] 로 확정

## 8. 클라우드 QA Q03B 결과 판정 (2026-10-14 20시대)

- Q03 [H4] 장시간 미종료 → [Q03B_AWR_LOADWINDOW_FAST.sql](Q03B_AWR_LOADWINDOW_FAST.sql) 로 대체(SNAP_ID 범위·OR 분리·CLOB 정규식 제거). 사내 11.9초.
- ⚠ [B0] 스냅샷 82개인데 SNAP_ID 범위 3317~4348 → PDB/CDB(또는 노드) DBID 가 섞여 범위가 새어 [B1]·[B1b]·[B5] 에 10-06~10-14 가 포함됨. 판정은 시간대별 행으로 함.
- Qlik 프로그램 = `repctl@lchddwexapob1` (**DB 서버 1번 노드에서 실행**) — Qlik↔오라클 네트워크는 로컬.
- ⭐ **Full Load (10-11 17시 ~ 10-13 08시)** `fr8a4mu383uwp INSERT INTO ... VALUES` — **실행 수 = 행 수 (1행씩 실행)**. 시간당 900만~2,100만 행, 1만 행당 1.2~2.1초(DB 시간). IO 대기 시간당 60~100초뿐·CPU 800~1,000초 → 인덱스 캐시 부족은 **주원인 아님**(뒤로 갈수록 오히려 빨라짐). 병목 = 행 단위 실행(배열/direct path 미사용).
- ⭐ **CDC DELETE** `0zfz07pka9ysv DELETE FROM FG_C WHERE (DIVISION_ID, VERSION_NO, CUTOFF_DATE, …)` — 처리 행 0 인데 실행당 150~3,600초, 10-09 07~09시 3시간 CPU 약 13,800초, 10-13 16시 물리 읽기 요청 1,170만. FG_C 테이블 물리 읽기 4.5억 블록의 주체. 계획 확인 필요 → [Q05_QLIK_DML_PLAN.sql](Q05_QLIK_DML_PLAN.sql).
- CDC INSERT `drxd1y8d336nr`(대상)·`gn59mxj6ngncj`(`SCP_ANL_SHIPMENT_PLAN_FG_C__ct` 변경 이력) — 2회 실행에 260만 행, 1만 행당 0.6~0.9초(정상 배치). Store Changes 로 같은 양이 __ct 에도 적재.
