-- =============================================================================
-- Q02_LIVE_DURING_LOAD.sql — Qlik 적재 지연 진단 ② 적재 "중" 실시간 판정 (READ-ONLY, 전체 F5)
--   대상  : 클라우드 QA 오라클 / Qlik Replicate 가 SCP_ANL_SHIPMENT_PLAN_FG_C 에 적재하는 동안
--   계정  : SCM_MGR
--   언제  : ⭐ Qlik Task 가 이 테이블을 적재하고 있는 동안. 5~10분 간격으로 2~3회 실행하면 진행 속도까지 보임
--   실행  : SQL Developer = 스크립트 실행(F5) / sqlplus = @Q02_LIVE_DURING_LOAD.sql
--   변경  : 없음. SELECT 만 수행. 값 입력 없음.
--   세션 판별: ① 프로그램/모듈명(repctl·Replicate·Qlik·Attunity·attrep) ② 이 테이블 잠금 보유 ③ 이 테이블 DML SQL 실행
--             — 셋 중 하나라도 해당하면 "후보 세션". Qlik 프로그램명이 달라도 ②③ 으로 잡힌다.
--   ⚠ Qlik Full Load 의 direct path(OCI) 적재는 SQL 문장 없이 돌 수 있다 → [L5] 가 비고 [L2] 잠금 모드 6 이면 direct path.
-- =============================================================================
SET DEFINE OFF
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET FEEDBACK ON
SET VERIFY OFF
COLUMN JUDGE FORMAT A70
COLUMN PROGRAM FORMAT A36
COLUMN MODULE FORMAT A30
COLUMN MACHINE FORMAT A24
COLUMN EVENT FORMAT A40
COLUMN REASON FORMAT A22
COLUMN NAME FORMAT A40
COLUMN SQL_HEAD FORMAT A120
COLUMN OBJECT_NAME FORMAT A34
COLUMN METRIC_NAME FORMAT A40
SPOOL Q02_LIVE_DURING_LOAD_OUT.txt

PROMPT ################ [L0] 실행 시각 / DB ################
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','CON_NAME') CON_NAME,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;

PROMPT ################ [L1] ⭐ 후보 세션 (Qlik / 테이블 잠금 / 테이블 DML) — PROGRAM 열이 Qlik 프로그램명 ################
WITH OBJ AS (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' AND OBJECT_TYPE='TABLE'),
     LCK AS (SELECT DISTINCT INST_ID, SESSION_ID SID FROM GV$LOCKED_OBJECT WHERE OBJECT_ID IN (SELECT OBJECT_ID FROM OBJ)),
     SQ  AS (SELECT DISTINCT INST_ID, SQL_ID FROM GV$SQL
              WHERE REGEXP_LIKE(SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND COMMAND_TYPE IN (2,6,7,189))
SELECT S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.PROGRAM, S.MODULE, S.MACHINE, S.STATUS,
       NVL(S.EVENT,'-') EVENT, S.WAIT_CLASS, S.SECONDS_IN_WAIT SIW, S.SQL_ID, S.PREV_SQL_ID, S.LAST_CALL_ET,
       TO_CHAR(S.LOGON_TIME,'MM-DD HH24:MI:SS') LOGON, S.BLOCKING_SESSION BLK_BY,
       CASE WHEN (S.INST_ID,S.SID) IN (SELECT INST_ID, SID FROM LCK) THEN 'LOCK ' END ||
       CASE WHEN (S.INST_ID,S.SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ) OR (S.INST_ID,S.PREV_SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ) THEN 'SQL ' END ||
       CASE WHEN LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%repctl%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%replicat%'
              OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%qlik%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attunity%'
              OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attrep%' THEN 'NAME' END REASON
  FROM GV$SESSION S
 WHERE S.TYPE='USER' AND NOT (S.INST_ID=SYS_CONTEXT('USERENV','INSTANCE') AND S.SID=SYS_CONTEXT('USERENV','SID'))
   AND ( (S.INST_ID,S.SID) IN (SELECT INST_ID, SID FROM LCK)
      OR (S.INST_ID,S.SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
      OR (S.INST_ID,S.PREV_SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
      OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%repctl%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%replicat%'
      OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%qlik%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attunity%'
      OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attrep%' )
 ORDER BY S.INST_ID, S.SID;

PROMPT ################ [L2] ⭐ 테이블 잠금 모드 — 6(X)=direct path(테이블 독점, 병렬 세그먼트 직렬화) / 3(RX)=일반 INSERT ################
SELECT L.INST_ID, L.SESSION_ID SID, L.ORACLE_USERNAME, L.OS_USER_NAME, O.OWNER, O.OBJECT_NAME, L.LOCKED_MODE,
       CASE L.LOCKED_MODE WHEN 6 THEN '⚠ X 잠금 — direct path 적재 중 (다른 세션의 같은 테이블 DML 대기)'
                          WHEN 3 THEN 'RX — 일반(conventional) INSERT/UPDATE'
                          ELSE 'mode '||L.LOCKED_MODE END JUDGE
  FROM GV$LOCKED_OBJECT L JOIN ALL_OBJECTS O ON O.OBJECT_ID=L.OBJECT_ID
 WHERE O.OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' OR UPPER(O.OBJECT_NAME) LIKE 'ATTREP%'
 ORDER BY L.INST_ID, L.SESSION_ID;

PROMPT ################ [L3] ⭐⭐ 후보 세션 시간 분해 (유휴 포함, 접속 후 누적) — 가장 중요한 판정 ################
PROMPT --  'SQL*Net message from client' 비중이 크면 = DB 는 Qlik 이 다음 데이터를 보내주길 기다리는 중 → 원천 읽기·네트워크·Qlik 쪽 병목
PROMPT --  DB CPU / User I/O / Commit / Configuration(log file switch) / Concurrency 비중이 크면 = DB 쪽 병목
WITH OBJ AS (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' AND OBJECT_TYPE='TABLE'),
     LCK AS (SELECT DISTINCT INST_ID, SESSION_ID SID FROM GV$LOCKED_OBJECT WHERE OBJECT_ID IN (SELECT OBJECT_ID FROM OBJ)),
     SQ  AS (SELECT DISTINCT INST_ID, SQL_ID FROM GV$SQL
              WHERE REGEXP_LIKE(SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND COMMAND_TYPE IN (2,6,7,189)),
     C AS (SELECT S.INST_ID, S.SID FROM GV$SESSION S
            WHERE S.TYPE='USER' AND NOT (S.INST_ID=SYS_CONTEXT('USERENV','INSTANCE') AND S.SID=SYS_CONTEXT('USERENV','SID'))
              AND ( (S.INST_ID,S.SID) IN (SELECT INST_ID, SID FROM LCK)
                 OR (S.INST_ID,S.SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
                 OR (S.INST_ID,S.PREV_SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%repctl%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%replicat%'
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%qlik%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attunity%'
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attrep%' )),
     E AS (SELECT E.INST_ID, E.SID, E.EVENT, E.WAIT_CLASS, E.TOTAL_WAITS, E.TIME_WAITED_MICRO/1e6 SEC
             FROM GV$SESSION_EVENT E WHERE (E.INST_ID, E.SID) IN (SELECT INST_ID, SID FROM C)
           UNION ALL
           SELECT T.INST_ID, T.SID, 'DB CPU', 'CPU', NULL, T.VALUE/1e6
             FROM GV$SESS_TIME_MODEL T WHERE T.STAT_NAME='DB CPU' AND (T.INST_ID, T.SID) IN (SELECT INST_ID, SID FROM C))
SELECT INST_ID, SID, EVENT, WAIT_CLASS, TOTAL_WAITS, ROUND(SEC,1) SEC,
       ROUND(1000*SEC/NULLIF(TOTAL_WAITS,0),2) AVG_MS,
       ROUND(100*RATIO_TO_REPORT(SEC) OVER (PARTITION BY INST_ID, SID),1) PCT,
       CASE WHEN EVENT='SQL*Net message from client' AND 100*RATIO_TO_REPORT(SEC) OVER (PARTITION BY INST_ID, SID) >= 50
              THEN '⚠ DB 가 Qlik 을 기다림 — 원천(MSSQL)·네트워크·Qlik 서버 쪽 병목'
            WHEN EVENT LIKE 'log file switch%' THEN '⚠ Redo 로그 부족 — [S2] 그룹 크기·수 확대 대상'
            WHEN EVENT IN ('log file sync') THEN '커밋 대기 — 커밋 빈도·Redo 쓰기 속도'
            WHEN EVENT IN ('db file sequential read') THEN '인덱스 블록 읽기 — 인덱스 유지 비용 ([L6b] 객체 확인)'
            WHEN EVENT LIKE 'enq: TX - index contention%' THEN '⚠ 인덱스 리프 분할 경합 — 병렬 적재 + 인덱스'
            WHEN EVENT LIKE 'enq: TM%' THEN '⚠ 테이블 잠금 대기 — direct path 독점과 충돌'
            WHEN EVENT LIKE 'enq: HW%' THEN 'HWM 확장 경합'
            WHEN EVENT IN ('free buffer waits','write complete waits') THEN '⚠ DBWR 쓰기 지연 — 스토리지'
            WHEN EVENT LIKE 'direct path write%' THEN 'direct path 쓰기 — AVG_MS 크면 스토리지 지연'
            WHEN EVENT LIKE 'resmgr%' THEN '⚠ Resource Manager CPU 제한'
            WHEN EVENT='DB CPU' THEN 'CPU 사용 (인덱스 유지·데이터 변환)'
            ELSE '' END JUDGE
  FROM E
 WHERE SEC >= 0.5
 ORDER BY INST_ID, SID, SEC DESC;

PROMPT ################ [L4] 후보 세션 작업량 (접속 후 누적) — 행당 Redo·커밋 간격·네트워크 왕복 ################
WITH OBJ AS (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' AND OBJECT_TYPE='TABLE'),
     LCK AS (SELECT DISTINCT INST_ID, SESSION_ID SID FROM GV$LOCKED_OBJECT WHERE OBJECT_ID IN (SELECT OBJECT_ID FROM OBJ)),
     SQ  AS (SELECT DISTINCT INST_ID, SQL_ID FROM GV$SQL
              WHERE REGEXP_LIKE(SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND COMMAND_TYPE IN (2,6,7,189)),
     C AS (SELECT S.INST_ID, S.SID, S.LOGON_TIME FROM GV$SESSION S
            WHERE S.TYPE='USER' AND NOT (S.INST_ID=SYS_CONTEXT('USERENV','INSTANCE') AND S.SID=SYS_CONTEXT('USERENV','SID'))
              AND ( (S.INST_ID,S.SID) IN (SELECT INST_ID, SID FROM LCK)
                 OR (S.INST_ID,S.SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
                 OR (S.INST_ID,S.PREV_SQL_ID) IN (SELECT INST_ID, SQL_ID FROM SQ)
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%repctl%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%replicat%'
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%qlik%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attunity%'
                 OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attrep%' ))
SELECT C.INST_ID, C.SID, ROUND((SYSDATE-C.LOGON_TIME)*86400) CONNECTED_SEC,
       MAX(DECODE(N.NAME,'redo size',ST.VALUE)) REDO_BYTES,
       ROUND(MAX(DECODE(N.NAME,'redo size',ST.VALUE))/1024/1024/NULLIF((SYSDATE-C.LOGON_TIME)*86400,0),2) REDO_MB_PER_SEC,
       MAX(DECODE(N.NAME,'user commits',ST.VALUE)) COMMITS,
       MAX(DECODE(N.NAME,'execute count',ST.VALUE)) EXECS,
       MAX(DECODE(N.NAME,'db block changes',ST.VALUE)) BLOCK_CHANGES,
       MAX(DECODE(N.NAME,'session logical reads',ST.VALUE)) LOGICAL_READS,
       MAX(DECODE(N.NAME,'physical reads',ST.VALUE)) PHY_READS,
       MAX(DECODE(N.NAME,'physical writes direct',ST.VALUE)) DIRECT_WRITES,
       MAX(DECODE(N.NAME,'undo change vector size',ST.VALUE)) UNDO_BYTES,
       MAX(DECODE(N.NAME,'bytes received via SQL*Net from client',ST.VALUE)) NET_IN_BYTES,
       MAX(DECODE(N.NAME,'SQL*Net roundtrips to/from client',ST.VALUE)) ROUNDTRIPS,
       ROUND(MAX(DECODE(N.NAME,'CPU used by this session',ST.VALUE))/100,1) CPU_SEC
  FROM C JOIN GV$SESSTAT ST ON ST.INST_ID=C.INST_ID AND ST.SID=C.SID
         JOIN V$STATNAME N ON N.STATISTIC#=ST.STATISTIC#
 WHERE N.NAME IN ('redo size','user commits','execute count','db block changes','session logical reads','physical reads',
                  'physical writes direct','undo change vector size','bytes received via SQL*Net from client',
                  'SQL*Net roundtrips to/from client','CPU used by this session')
 GROUP BY C.INST_ID, C.SID, C.LOGON_TIME
 ORDER BY C.INST_ID, C.SID;

PROMPT ################ [L5] ⭐ 적재 SQL — 실행당 행수(=Qlik 배치 크기)·1만 행당 초·대기 구성 ################
PROMPT --  LOAD 열 'DIRECT(SYS_DL_CURSOR)' = OCI direct path 적재(실행 수·행 수가 0 으로 보일 수 있음 — [L3]·[L4] 로 판정)
PROMPT --  비어 있고 [L2] 가 모드 6 이면 direct path 적재 → [L3] 로 판정
SELECT S.INST_ID, S.SQL_ID, S.CHILD_NUMBER CH, DECODE(S.COMMAND_TYPE,2,'INSERT',6,'UPDATE',7,'DELETE',189,'MERGE',S.COMMAND_TYPE) OP,
       S.EXECUTIONS EX, S.ROWS_PROCESSED ROWS_P, ROUND(S.ROWS_PROCESSED/NULLIF(S.EXECUTIONS,0)) ROWS_PER_EX,
       ROUND(S.ELAPSED_TIME/1e6,1) ELA_S, ROUND(S.CPU_TIME/1e6,1) CPU_S, ROUND(S.USER_IO_WAIT_TIME/1e6,1) IO_S,
       ROUND(S.CONCURRENCY_WAIT_TIME/1e6,1) CONC_S, ROUND(S.APPLICATION_WAIT_TIME/1e6,1) APP_S, ROUND(S.CLUSTER_WAIT_TIME/1e6,1) CLU_S,
       ROUND(10000*S.ELAPSED_TIME/1e6/NULLIF(S.ROWS_PROCESSED,0),2) SEC_PER_10K_ROWS,
       S.BUFFER_GETS BG, S.DIRECT_WRITES DW,
       CASE WHEN UPPER(S.SQL_TEXT) LIKE '%SYS_DL_CURSOR%' THEN 'DIRECT(SYS_DL_CURSOR)'
            WHEN UPPER(S.SQL_TEXT) LIKE '%APPEND%' THEN 'APPEND' ELSE 'CONVENTIONAL' END LOAD,
       S.MODULE, TO_CHAR(S.LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') LAST_ACT,
       SUBSTR(S.SQL_TEXT,1,120) SQL_HEAD
  FROM GV$SQL S
 WHERE REGEXP_LIKE(S.SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND S.COMMAND_TYPE IN (2,6,7,189)
   AND S.LAST_ACTIVE_TIME > SYSDATE - 1
 ORDER BY S.LAST_ACTIVE_TIME DESC;

PROMPT ################ [L6] 최근 30분 ASH — 후보 세션 대기 분포 (활성 시간만) ################
WITH OBJ AS (SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' AND OBJECT_TYPE='TABLE'),
     IXO AS (SELECT O.OBJECT_ID FROM ALL_OBJECTS O JOIN ALL_INDEXES I ON I.OWNER=O.OWNER AND I.INDEX_NAME=O.OBJECT_NAME
              WHERE I.TABLE_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C' AND O.OBJECT_TYPE='INDEX'),
     SQ  AS (SELECT DISTINCT SQL_ID FROM GV$SQL WHERE REGEXP_LIKE(SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND COMMAND_TYPE IN (2,6,7,189))
SELECT A.PROGRAM, A.SQL_OPNAME, NVL(A.EVENT,'ON CPU') EVENT, NVL(A.WAIT_CLASS,'CPU') WAIT_CLASS, COUNT(*) SAMPLES,
       ROUND(100*RATIO_TO_REPORT(COUNT(*)) OVER (),1) PCT
  FROM GV$ACTIVE_SESSION_HISTORY A
 WHERE A.SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '30' MINUTE
   AND ( A.SQL_ID IN (SELECT SQL_ID FROM SQ)
      OR A.CURRENT_OBJ# IN (SELECT OBJECT_ID FROM OBJ UNION ALL SELECT OBJECT_ID FROM IXO)
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%repctl%' OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%replicat%'
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%qlik%' OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%attunity%'
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%attrep%' )
 GROUP BY A.PROGRAM, A.SQL_OPNAME, NVL(A.EVENT,'ON CPU'), NVL(A.WAIT_CLASS,'CPU')
 ORDER BY SAMPLES DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ################ [L6b] 최근 30분 ASH — 대기 중이던 객체 (PK/IX 비중이 크면 인덱스 유지가 병목) ################
WITH SQ AS (SELECT DISTINCT SQL_ID FROM GV$SQL WHERE REGEXP_LIKE(SQL_TEXT, '^\s*(INSERT|UPDATE|DELETE|MERGE)\s+(/\*.*?\*/\s*)?(INTO\s+|FROM\s+)?(RELATIONAL\s*\(\s*)?("?[A-Z0-9_$#]+"?\.)?"?SCP_ANL_SHIPMENT_PLAN_FG_C"?', 'in') AND COMMAND_TYPE IN (2,6,7,189))
SELECT NVL(O.OBJECT_NAME,'(obj# '||A.CURRENT_OBJ#||')') OBJECT_NAME, O.OBJECT_TYPE, NVL(A.EVENT,'ON CPU') EVENT, COUNT(*) SAMPLES,
       ROUND(100*RATIO_TO_REPORT(COUNT(*)) OVER (),1) PCT
  FROM GV$ACTIVE_SESSION_HISTORY A LEFT JOIN ALL_OBJECTS O ON O.OBJECT_ID=A.CURRENT_OBJ#
 WHERE A.SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '30' MINUTE
   AND ( A.SQL_ID IN (SELECT SQL_ID FROM SQ)
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%repctl%' OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%replicat%'
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%qlik%' OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%attunity%'
      OR LOWER(A.PROGRAM||' '||A.MODULE) LIKE '%attrep%' )
 GROUP BY NVL(O.OBJECT_NAME,'(obj# '||A.CURRENT_OBJ#||')'), O.OBJECT_TYPE, NVL(A.EVENT,'ON CPU')
 ORDER BY SAMPLES DESC
 FETCH FIRST 20 ROWS ONLY;

PROMPT ################ [L7] DB 전체 지표 (최근 60초) — Redo/초 · CPU · 쓰기량 (SRC=CDB/PDB 어느 뷰에서 왔는지) ################
SELECT 'SYSMETRIC' SRC, INST_ID, METRIC_NAME, ROUND(VALUE,2) VALUE, METRIC_UNIT, TO_CHAR(END_TIME,'HH24:MI:SS') END_TIME
  FROM GV$SYSMETRIC
 WHERE GROUP_ID=2
   AND METRIC_NAME IN ('Redo Generated Per Sec','Host CPU Utilization (%)','Average Active Sessions','CPU Usage Per Sec',
                       'Physical Write Total Bytes Per Sec','Physical Write Total IO Requests Per Sec','I/O Megabytes per Second',
                       'User Commits Per Sec','Executions Per Sec','Network Traffic Volume Per Sec','Database Wait Time Ratio')
UNION ALL
SELECT 'CON_SYSMETRIC', INST_ID, METRIC_NAME, ROUND(VALUE,2), METRIC_UNIT, TO_CHAR(END_TIME,'HH24:MI:SS')
  FROM GV$CON_SYSMETRIC
 WHERE METRIC_NAME IN ('Redo Generated Per Sec','Host CPU Utilization (%)','Average Active Sessions','CPU Usage Per Sec',
                       'Physical Write Total Bytes Per Sec','Physical Write Total IO Requests Per Sec','I/O Megabytes per Second',
                       'User Commits Per Sec','Executions Per Sec','Network Traffic Volume Per Sec','Database Wait Time Ratio')
 ORDER BY 1, 2, 3;

PROMPT ################ [L8] ⭐ DB 전체 대기 — 최근 10분 ASH (모든 포그라운드 세션, 활성 시간 기준) ################
SELECT NVL(A.EVENT,'ON CPU') EVENT, NVL(A.WAIT_CLASS,'CPU') WAIT_CLASS, COUNT(*) SAMPLES,
       ROUND(100*RATIO_TO_REPORT(COUNT(*)) OVER (),1) PCT,
       CASE WHEN A.EVENT LIKE 'log file switch%' THEN '⚠ Redo 로그 부족 — DB 전체 DML 정지'
            WHEN A.EVENT IN ('free buffer waits','write complete waits') THEN '⚠ DBWR 쓰기 지연'
            WHEN A.EVENT LIKE 'resmgr%' THEN '⚠ CPU 제한'
            ELSE '' END JUDGE
  FROM GV$ACTIVE_SESSION_HISTORY A
 WHERE A.SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '10' MINUTE AND A.SESSION_TYPE='FOREGROUND'
 GROUP BY NVL(A.EVENT,'ON CPU'), NVL(A.WAIT_CLASS,'CPU'), A.EVENT
 ORDER BY SAMPLES DESC
 FETCH FIRST 25 ROWS ONLY;

PROMPT ################ [L8b] 핵심 대기 이벤트 — 기동 후 누적 (사내: log file switch(checkpoint incomplete) 1회 평균 33,285ms / direct path write 26.7ms) ################
SELECT E.EVENT, E.WAIT_CLASS, E.TOTAL_WAITS, ROUND(E.TIME_WAITED_MICRO/1e6) SEC,
       ROUND(E.TIME_WAITED_MICRO/NULLIF(E.TOTAL_WAITS,0)/1000,2) AVG_MS,
       CASE WHEN E.EVENT LIKE 'log file switch (checkpoint incomplete)' THEN '⚠ 발생 자체가 Redo 과소 신호'
            WHEN E.EVENT IN ('log file parallel write','log file sync') AND E.TIME_WAITED_MICRO/NULLIF(E.TOTAL_WAITS,0)/1000 > 10 THEN '⚠ Redo 쓰기 10ms 초과 — 스토리지'
            WHEN E.EVENT IN ('db file parallel write','direct path write') AND E.TIME_WAITED_MICRO/NULLIF(E.TOTAL_WAITS,0)/1000 > 10 THEN '⚠ 쓰기 10ms 초과 — 스토리지'
            ELSE '' END JUDGE
  FROM V$SYSTEM_EVENT E
 WHERE E.EVENT IN ('log file switch (checkpoint incomplete)','log file switch completion','log file switch (archiving needed)',
                   'log file switch (private strand flush incomplete)','log file sync','log file parallel write','log buffer space',
                   'db file parallel write','direct path write','direct path write temp','db file sequential read','free buffer waits',
                   'write complete waits','buffer busy waits','enq: TX - index contention','enq: HW - contention','enq: TM - contention',
                   'checkpoint completed','resmgr:cpu quantum','SQL*Net more data from client')
 ORDER BY E.TIME_WAITED_MICRO DESC;

PROMPT ################ [L9] 로그 스위치 최근 3시간 (간격 분) — 사내 적재 시 시간당 10~13회 ################
SELECT THREAD#, SEQUENCE#, TO_CHAR(FIRST_TIME,'MM-DD HH24:MI:SS') FIRST_TIME,
       ROUND((FIRST_TIME - LAG(FIRST_TIME) OVER (PARTITION BY THREAD# ORDER BY SEQUENCE#))*1440,1) GAP_MIN
  FROM V$LOG_HISTORY
 WHERE FIRST_TIME > SYSDATE - 3/24
 ORDER BY THREAD#, SEQUENCE#;
SELECT INST_ID, THREAD#, STATUS, COUNT(*) GROUPS,
       CASE WHEN STATUS='ACTIVE' AND COUNT(*) >= 2 THEN '⚠ ACTIVE 다수 — 체크포인트가 Redo 순환을 못 따라감' ELSE '' END JUDGE
  FROM GV$LOG GROUP BY INST_ID, THREAD#, STATUS ORDER BY 1, 2, 3;

PROMPT ################ [L10] 후보 세션 트랜잭션 크기 — UNDO 사용량이 크면 커밋 간격이 김 ################
SELECT S.INST_ID, S.SID, S.PROGRAM, T.START_TIME, T.USED_UBLK, T.USED_UREC,
       ROUND(T.USED_UBLK*(SELECT TO_NUMBER(VALUE) FROM V$PARAMETER WHERE NAME='db_block_size')/1024/1024,1) UNDO_MB
  FROM GV$TRANSACTION T JOIN GV$SESSION S ON S.INST_ID=T.INST_ID AND S.SADDR=T.SES_ADDR
 WHERE LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%repctl%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%replicat%'
    OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%qlik%' OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attunity%'
    OR LOWER(S.PROGRAM||' '||S.MODULE) LIKE '%attrep%'
    OR (S.INST_ID, S.SID) IN (SELECT L.INST_ID, L.SESSION_ID FROM GV$LOCKED_OBJECT L JOIN ALL_OBJECTS O ON O.OBJECT_ID=L.OBJECT_ID
                               WHERE O.OBJECT_NAME='SCP_ANL_SHIPMENT_PLAN_FG_C')
 ORDER BY T.USED_UBLK DESC;

PROMPT ################ [L11] 블로킹 — 후보 세션이 막거나 막힌 관계 ################
SELECT W.INST_ID, W.SID WAITER, W.PROGRAM WAITER_PROGRAM, W.EVENT, W.SECONDS_IN_WAIT SIW,
       W.BLOCKING_INSTANCE B_INST, W.BLOCKING_SESSION BLOCKER,
       (SELECT B.PROGRAM FROM GV$SESSION B WHERE B.INST_ID=W.BLOCKING_INSTANCE AND B.SID=W.BLOCKING_SESSION) BLOCKER_PROGRAM
  FROM GV$SESSION W
 WHERE W.BLOCKING_SESSION IS NOT NULL AND W.WAIT_CLASS <> 'Idle'
 ORDER BY W.SECONDS_IN_WAIT DESC;

PROMPT ################ [L12] 같은 시각 다른 활성 세션 (CPU·I/O 경합 원인 후보) ################
SELECT S.INST_ID, S.SID, S.USERNAME, S.PROGRAM, S.MACHINE, NVL(S.EVENT,'-') EVENT, S.WAIT_CLASS, S.SQL_ID, S.LAST_CALL_ET
  FROM GV$SESSION S
 WHERE S.TYPE='USER' AND S.STATUS='ACTIVE' AND S.WAIT_CLASS <> 'Idle'
   AND NOT (S.INST_ID=SYS_CONTEXT('USERENV','INSTANCE') AND S.SID=SYS_CONTEXT('USERENV','SID'))
 ORDER BY S.LAST_CALL_ET DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ################ 끝 — Q02_LIVE_DURING_LOAD_OUT.txt 회신 (2~3회 실행 시 파일명 뒤에 _1/_2 붙여 보관) ################
SPOOL OFF
