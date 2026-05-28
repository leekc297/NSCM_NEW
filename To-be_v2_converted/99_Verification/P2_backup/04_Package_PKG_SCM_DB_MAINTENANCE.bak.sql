/*=============================================================================================
 * File         : 04_Package_PKG_SCM_DB_MAINTENANCE.sql
 * Description  : Package — PKG_SCM_DB_MAINTENANCE
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM_DB_MAINTENANCE 
/*=====================================================================================================================================================
     * Program ID   : PKG_SCM_DB_MAINTENANCE
     * Description  : Oracle DB 주기 관리 패키지
     * Program History
     *=====================================================================================================================================================
     *   Date       In Charge      Description
     *=====================================================================================================================================================
     *  
     * 2026.02.26   김준규           Oracle DB 주기적 점검 및 처리 통합 패키지(with Claude Opus 4.6)
    */
AS

    -- -------------------------------------------------------
    -- PIPELINED FUNCTION 용 TYPE 정의 (패키지 내부 관리)
    -- Oracle 12c 이상에서 패키지 내 TYPE으로 PIPELINED 사용 가능
    -- DB Object Type(CREATE TYPE) 대비 변경/관리가 용이
    -- -------------------------------------------------------

    -- 유지보수 실행 이력 조회 ROW TYPE
    TYPE T_MAINT_HIST_ROW IS RECORD (
        LOG_SEQ       NUMBER,           -- 로그 일련번호
        EXEC_TYPE     VARCHAR2(50),     -- 실행 유형
        START_TIME    VARCHAR2(19),     -- 시작 시간 (YYYY-MM-DD HH24:MI:SS)
        END_TIME      VARCHAR2(19),     -- 종료 시간
        ELAPSED_SEC   NUMBER,           -- 소요 시간 (초)
        TARGET_OWNER  VARCHAR2(30),     -- 대상 스키마
        SUCCESS_CNT   NUMBER,           -- 성공 건수
        FAIL_CNT      NUMBER,           -- 실패 건수
        STATUS        VARCHAR2(10),     -- RUNNING / DONE / ERROR
        REMARKS       VARCHAR2(4000)    -- 비고
    );
    TYPE T_MAINT_HIST_TAB IS TABLE OF T_MAINT_HIST_ROW;

    -- Tablespace 사용률 추이 조회 ROW TYPE
    TYPE T_TBS_TREND_ROW IS RECORD (
        SNAP_DATE       VARCHAR2(10),   -- 날짜 (YYYY-MM-DD)
        TABLESPACE_NAME VARCHAR2(30),   -- 테이블스페이스명
        TOTAL_MB        NUMBER,         -- 전체 크기 (MB)
        USED_MB         NUMBER,         -- 사용 크기 (MB)
        FREE_MB         NUMBER,         -- 여유 크기 (MB)
        USED_PCT        NUMBER,         -- 사용률 (%)
        ALERT_YN        VARCHAR2(1)     -- 경고 여부 (Y/N)
    );
    TYPE T_TBS_TREND_TAB IS TABLE OF T_TBS_TREND_ROW;

    -- -------------------------------------------------------
    -- 1. UNUSABLE 인덱스 재생성
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_REBUILD_UNUSABLE_INDEX(
        P_OWNER     IN VARCHAR2 DEFAULT NULL,   -- NULL이면 전체 (시스템 제외)
        P_ONLINE_YN IN VARCHAR2 DEFAULT 'Y',    -- Y: ONLINE REBUILD
        P_LOG_SEQ   IN NUMBER   DEFAULT NULL
    );

    -- -------------------------------------------------------
    -- 2. 인덱스/테이블 통계 정보 갱신
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_GATHER_STALE_STATS(
        P_OWNER      IN VARCHAR2 DEFAULT NULL,  -- NULL이면 전체
        P_PERCENT    IN NUMBER   DEFAULT 30,    -- 샘플 비율 (%)
        P_CASCADE_YN IN VARCHAR2 DEFAULT 'Y',   -- Y: 인덱스 통계도 함께
        P_LOG_SEQ    IN NUMBER   DEFAULT NULL
    );

    -- -------------------------------------------------------
    -- 3. INVALID Object 재컴파일
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_RECOMPILE_INVALID_OBJ(
        P_OWNER IN VARCHAR2   DEFAULT NULL,       -- NULL이면 전체
        P_LOG_SEQ IN NUMBER   DEFAULT NULL
    );

    -- -------------------------------------------------------
    -- 4. Lock/Block 세션 탐지 및 Kill (Kill은 P_KILL_YN='Y' 일때만)
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_KILL_BLOCKED_SESSION(
        P_WAIT_MIN  IN NUMBER   DEFAULT 10,     -- 대기 기준 분
        P_KILL_YN   IN VARCHAR2 DEFAULT '',    -- Y: 실제 Kill 수행
        P_LOG_SEQ   IN NUMBER   DEFAULT NULL
    );

    -- -------------------------------------------------------
    -- 5. Temp / Tablespace 사용률 점검
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_CHECK_TABLESPACE_USAGE(
        P_ALERT_PCT IN NUMBER DEFAULT 80,      -- 경고 기준 사용률(%)
        P_SAVE_YN   IN VARCHAR2 DEFAULT 'Y'
    );

    -- -------------------------------------------------------
    -- 6. 오래된 Audit 로그 정리
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_PURGE_AUDIT_LOG(
        P_KEEP_DAYS IN NUMBER DEFAULT 90        -- 보존 기간(일)
    );

    -- 7. 오래된 파티션 DROP
    --    P_EXECUTE_YN = '' : 대상 확인만 출력 (기본값, 안전)
    --    P_EXECUTE_YN = 'Y' : 실제 DROP 수행
    PROCEDURE PR_SCM_DROP_OLD_PARTITION(
        P_KEEP_MONTHS IN NUMBER   DEFAULT 12,
        P_EXECUTE_YN  IN VARCHAR2 DEFAULT ''
    );

    -- 8. 전체 유지보수 일괄 수행 (메인 진입점)
    -- -------------------------------------------------------
    PROCEDURE PR_SCM_RUN_ALL_MAINTENANCE(
        P_OWNER IN VARCHAR2 DEFAULT NULL
    );

    -- 9. 유지보수 실행 이력 조회 (PIPELINED FUNCTION)
    --    SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY());
    FUNCTION FN_SCM_MAINT_HISTORY(
        P_DAYS IN NUMBER DEFAULT 7
    ) RETURN T_MAINT_HIST_TAB PIPELINED;

    -- 10. Tablespace 사용률 추이 조회 (PIPELINED FUNCTION)
    --     SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND());
    FUNCTION FN_SCM_TBS_TREND(
        P_TBS_NAME IN VARCHAR2 DEFAULT NULL,
        P_DAYS     IN NUMBER   DEFAULT 30
    ) RETURN T_TBS_TREND_TAB PIPELINED;
    
END PKG_SCM_DB_MAINTENANCE;

/*
-- ============================================================
-- SECTION 4. DBMS_SCHEDULER 등록
--   JOB_SCM_DB_MAINTENANCE : 매일 02:00 - 전체 유지보수
--   JOB_SCM_DROP_PARTITION : 매월  1일 03:00 - 파티션 DROP
-- ============================================================
BEGIN
    BEGIN DBMS_SCHEDULER.DROP_JOB('JOB_SCM_DB_MAINTENANCE'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_SCHEDULER.DROP_JOB('JOB_SCM_DROP_PARTITION'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- 유지보수 전체 (매일 02:00)
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'JOB_SCM_DB_MAINTENANCE',
        JOB_TYPE        => 'STORED_PROCEDURE',
        JOB_ACTION      => 'SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RUN_ALL_MAINTENANCE',
        START_DATE      => TRUNC(SYSDATE + 1) + 2/24,
        REPEAT_INTERVAL => 'FREQ=DAILY; BYHOUR=2; BYMINUTE=0; BYSECOND=0',
        ENABLED         => TRUE,
        COMMENTS        => 'Oracle DB 전체 유지보수 (Index Rebuild / Stats / Recompile / Lock / TBS)'
    );

    -- 파티션 DROP (매월 1일 03:00)
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'JOB_SCM_DROP_PARTITION',
        JOB_TYPE        => 'PLSQL_BLOCK',
        JOB_ACTION      => q'[BEGIN SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'Y'); END;]',
        START_DATE      => TRUNC(LAST_DAY(SYSDATE) + 1) + 3/24,  -- 다음달 1일 03:00
        REPEAT_INTERVAL => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=3; BYMINUTE=0; BYSECOND=0',
        ENABLED         => TRUE,
        COMMENTS        => '이력 테이블 오래된 파티션 자동 DROP (12개월 초과분 삭제)'
    );

    DBMS_OUTPUT.PUT_LINE('=== JOB 등록 완료 ===');
    DBMS_OUTPUT.PUT_LINE('  JOB_SCM_DB_MAINTENANCE : 매일 02:00');
    DBMS_OUTPUT.PUT_LINE('  JOB_SCM_DROP_PARTITION : 매월 1일 03:00');
END;
*/


-- ============================================================
-- SECTION 5. 수동 실행 예시
-- ============================================================
/*
SET SERVEROUTPUT ON SIZE UNLIMITED;

-- 전체 유지보수 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RUN_ALL_MAINTENANCE;

-- 개별 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_REBUILD_UNUSABLE_INDEX;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_GATHER_STALE_STATS;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RECOMPILE_INVALID_OBJ;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_CHECK_TABLESPACE_USAGE;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_KILL_BLOCKED_SESSION(P_WAIT_MIN=>5, P_KILL_YN=>'');

-- 파티션 DROP: 대상 확인 (실제 DROP 안함, 기본값)
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'');
-- 파티션 DROP: 실제 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'Y');

-- TBS 사용률 추이 조회 (PIPELINED FUNCTION - SELECT로 조회)
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND());
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND('USERS', 60));
-- 경고 항목만 필터
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND())
WHERE  ALERT_YN = 'Y'
ORDER BY SNAP_DATE DESC;
-- 특정 TBS 사용률 증가 추이
SELECT SNAP_DATE, TABLESPACE_NAME, USED_PCT, USED_MB
FROM   TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND(P_DAYS => 90))
ORDER BY TABLESPACE_NAME, SNAP_DATE;

-- 유지보수 이력 조회 (PIPELINED FUNCTION)
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY());        -- 최근 7일
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(30));      -- 최근 30일
-- 실패/에러 건만 필터
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(30))
WHERE  STATUS = 'ERROR'
ORDER BY START_TIME DESC;
-- 상세 이력과 JOIN
SELECT H.LOG_SEQ, H.EXEC_TYPE, H.START_TIME, H.STATUS,
       D.OBJECT_NAME, D.STATUS AS DTL_STATUS, D.ERROR_MSG
FROM   TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(7)) H
JOIN   SCM_MGR.SCM_MAINT_DTL D ON D.LOG_SEQ = H.LOG_SEQ
WHERE  D.STATUS = 'FAIL'
ORDER BY H.START_TIME DESC;

-- 현재 파티션 목록 확인
SELECT TABLE_NAME, PARTITION_NAME, HIGH_VALUE,
       NUM_ROWS, BLOCKS,
       ROUND(BLOCKS * 8 / 1024, 1) AS SIZE_MB
FROM   DBA_TAB_PARTITIONS
WHERE  TABLE_OWNER = 'SCM_MGR'
  AND  TABLE_NAME IN ('SCM_MAINT_LOG','SCM_MAINT_DTL','SCM_TBS_SNAPSHOT','SCM_LOCK_HISTORY')
ORDER BY TABLE_NAME, PARTITION_NAME;

-- 테이블 직접 조회
SELECT * FROM SCM_MGR.SCM_MAINT_LOG    ORDER BY LOG_SEQ DESC;
SELECT * FROM SCM_MGR.SCM_MAINT_DTL    WHERE LOG_SEQ = 1 ORDER BY DTL_SEQ;
SELECT * FROM SCM_MGR.SCM_TBS_SNAPSHOT ORDER BY SNAP_DATE DESC, USED_PCT DESC;
SELECT * FROM SCM_MGR.SCM_LOCK_HISTORY ORDER BY DETECT_TIME DESC;

-- JOB 상태 확인
SELECT JOB_NAME, ENABLED, STATE, LAST_START_DATE, NEXT_RUN_DATE
FROM   DBA_SCHEDULER_JOBS
WHERE  JOB_NAME IN ('JOB_SCM_DB_MAINTENANCE','JOB_SCM_DROP_PARTITION');
*/;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM_DB_MAINTENANCE AS

    -- -------------------------------------------------------
    -- 내부: 콘솔 로그 출력
    -- -------------------------------------------------------
    PROCEDURE LOG(P_MSG IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '] ' || P_MSG);
    END LOG;

    -- -------------------------------------------------------
    -- 내부: 실행 요약 로그 시작 → LOG_SEQ 반환
    -- -------------------------------------------------------
    FUNCTION FN_START_LOG(
        P_EXEC_TYPE    IN VARCHAR2,
        P_TARGET_OWNER IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_SEQ NUMBER;
    BEGIN
        SELECT SCM_MGR.SEQ1_SCM_MAINT_LOG.NEXTVAL INTO V_SEQ FROM DUAL;
        INSERT INTO SCM_MGR.SCM_MAINT_LOG
            (LOG_SEQ, EXEC_TYPE, START_TIME, TARGET_OWNER, STATUS)
        VALUES
            (V_SEQ, P_EXEC_TYPE, SYSDATE, P_TARGET_OWNER, 'RUNNING');
        COMMIT;
        RETURN V_SEQ;
    END FN_START_LOG;

    -- -------------------------------------------------------
    -- 내부: 실행 요약 로그 종료
    -- -------------------------------------------------------
    PROCEDURE END_LOG(
        P_LOG_SEQ   IN NUMBER,
        P_SUCCESS   IN NUMBER,
        P_FAIL      IN NUMBER,
        P_STATUS    IN VARCHAR2 DEFAULT 'DONE',
        P_REMARKS   IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        UPDATE SCM_MGR.SCM_MAINT_LOG
        SET    END_TIME    = SYSDATE,
               ELAPSED_SEC = ROUND((SYSDATE - START_TIME) * 86400),
               SUCCESS_CNT = P_SUCCESS,
               FAIL_CNT    = P_FAIL,
               STATUS      = P_STATUS,
               REMARKS     = P_REMARKS
        WHERE  LOG_SEQ    = P_LOG_SEQ
          AND  START_TIME >= TRUNC(SYSDATE, 'MM');  -- 파티션 프루닝
        COMMIT;
    END END_LOG;

    -- -------------------------------------------------------
    -- 내부: 상세 이력 저장
    -- -------------------------------------------------------
    PROCEDURE SAVE_DTL(
        P_LOG_SEQ     IN NUMBER,
        P_EXEC_TYPE   IN VARCHAR2,
        P_OWNER       IN VARCHAR2,
        P_OBJECT_NAME IN VARCHAR2,
        P_OBJECT_TYPE IN VARCHAR2,
        P_PARTITION   IN VARCHAR2 DEFAULT NULL,
        P_STATUS      IN VARCHAR2 DEFAULT 'OK',
        P_ERROR_MSG   IN VARCHAR2 DEFAULT NULL
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO SCM_MGR.SCM_MAINT_DTL
            (DTL_SEQ, LOG_SEQ, EXEC_TYPE, OWNER, OBJECT_NAME, OBJECT_TYPE,
             PARTITION_NAME, STATUS, ERROR_MSG, EXEC_TIME)
        VALUES
            (SCM_MGR.SEQ1_SCM_MAINT_DTL.NEXTVAL, P_LOG_SEQ, P_EXEC_TYPE,
             P_OWNER, P_OBJECT_NAME, P_OBJECT_TYPE,
             P_PARTITION, P_STATUS, P_ERROR_MSG, SYSDATE);
        COMMIT;
    END SAVE_DTL;

    -- -------------------------------------------------------
    -- 내부: Lock 이력 저장 (AUTONOMOUS_TRANSACTION 분리)
    --       ※ PRAGMA AUTONOMOUS_TRANSACTION 은 서브프로그램
    --          선언부에만 가능 → FOR LOOP 내 DECLARE 블록 불가
    --          → 별도 내부 프로시저로 분리하여 호출
    -- -------------------------------------------------------
    PROCEDURE SAVE_LOCK_LOG(
        P_SID       IN NUMBER,
        P_SERIAL    IN NUMBER,
        P_USERNAME  IN VARCHAR2,
        P_MODULE    IN VARCHAR2,
        P_MACHINE   IN VARCHAR2,
        P_BLOCKING  IN NUMBER,
        P_WAIT_SEC  IN NUMBER,
        P_SQL_ID    IN VARCHAR2,
        P_KILL_YN   IN VARCHAR2,
        P_KILL_TIME IN DATE
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        V_LOCK_SEQ NUMBER;
    BEGIN
        SELECT SCM_MGR.SEQ1_SCM_LOCK_HISTORY.NEXTVAL INTO V_LOCK_SEQ FROM DUAL;

        INSERT INTO SCM_MGR.SCM_LOCK_HISTORY (
            LOCK_SEQ, DETECT_TIME,
            BLOCKED_SID, BLOCKED_SERIAL, BLOCKED_USER,
            BLOCKED_MODULE, BLOCKED_MACHINE,
            BLOCKING_SID, WAIT_SEC, SQL_ID,
            KILL_YN, KILL_TIME
        ) VALUES (
            V_LOCK_SEQ, SYSDATE,
            P_SID, P_SERIAL, P_USERNAME,
            P_MODULE, P_MACHINE,
            P_BLOCKING, P_WAIT_SEC, P_SQL_ID,
            P_KILL_YN, P_KILL_TIME
        );
        COMMIT;
    END SAVE_LOCK_LOG;


    -- ============================================================
    -- 1. UNUSABLE 인덱스 재생성
    -- ============================================================
    PROCEDURE PR_SCM_REBUILD_UNUSABLE_INDEX(
        P_OWNER     IN VARCHAR2 DEFAULT NULL,
        P_ONLINE_YN IN VARCHAR2 DEFAULT 'Y',
        P_LOG_SEQ   IN NUMBER   DEFAULT NULL
    ) IS
        V_SQL        VARCHAR2(500);
        V_SUCCESS    NUMBER  := 0;
        V_FAIL       NUMBER  := 0;
        V_ONLINE     VARCHAR2(10) := CASE WHEN UPPER(P_ONLINE_YN) = 'Y' THEN ' ONLINE' ELSE '' END;
        V_SEQ        NUMBER  := NVL(P_LOG_SEQ, FN_START_LOG('REBUILD_INDEX', P_OWNER));
        V_STANDALONE BOOLEAN := P_LOG_SEQ IS NULL;
    BEGIN
        LOG('=== PR_SCM_REBUILD_UNUSABLE_INDEX START ===');

        -- 일반 인덱스
        FOR R IN (
            SELECT OWNER, INDEX_NAME, TABLE_NAME
            FROM   DBA_INDEXES
            WHERE  STATUS      = 'UNUSABLE'
              AND  PARTITIONED = 'NO'
              AND  (P_OWNER IS NULL OR OWNER = UPPER(P_OWNER))
              AND  OWNER NOT IN ('SYS','SYSTEM','DBSNMP','SYSMAN','OUTLN',
                                 'MDSYS','ORDSYS','XDB','ORDDATA','WMSYS','SCMC')
            ORDER BY OWNER, TABLE_NAME
        ) LOOP
            BEGIN
                V_SQL := 'ALTER INDEX ' || R.OWNER || '.' || R.INDEX_NAME || ' REBUILD' || V_ONLINE;
                EXECUTE IMMEDIATE V_SQL;
                V_SUCCESS := V_SUCCESS + 1;
                LOG('[OK] ' || R.OWNER || '.' || R.INDEX_NAME);
                SAVE_DTL(V_SEQ, 'REBUILD_INDEX', R.OWNER, R.INDEX_NAME, 'INDEX', NULL, 'OK');
            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        EXECUTE IMMEDIATE 'ALTER INDEX ' || R.OWNER || '.' || R.INDEX_NAME || ' REBUILD';
                        V_SUCCESS := V_SUCCESS + 1;
                        LOG('[OK-OFFLINE] ' || R.OWNER || '.' || R.INDEX_NAME);
                        SAVE_DTL(V_SEQ, 'REBUILD_INDEX', R.OWNER, R.INDEX_NAME, 'INDEX', NULL, 'OK', 'OFFLINE 재시도');
                    EXCEPTION
                        WHEN OTHERS THEN
                            V_FAIL := V_FAIL + 1;
                            LOG('[FAIL] ' || R.OWNER || '.' || R.INDEX_NAME || ' -> ' || SQLERRM);
                            SAVE_DTL(V_SEQ, 'REBUILD_INDEX', R.OWNER, R.INDEX_NAME, 'INDEX', NULL, 'FAIL', SQLERRM);
                    END;
            END;
        END LOOP;

        -- 파티션 인덱스
        FOR P IN (
            SELECT INDEX_OWNER, INDEX_NAME, PARTITION_NAME
            FROM   DBA_IND_PARTITIONS
            WHERE  STATUS = 'UNUSABLE'
              AND  (P_OWNER IS NULL OR INDEX_OWNER = UPPER(P_OWNER))
              AND  INDEX_OWNER NOT IN ('SYS','SYSTEM','DBSNMP','SYSMAN','OUTLN',
                                       'MDSYS','ORDSYS','XDB','ORDDATA','WMSYS','SCMC')
            ORDER BY INDEX_OWNER, INDEX_NAME
        ) LOOP
            BEGIN
                V_SQL := 'ALTER INDEX ' || P.INDEX_OWNER || '.' || P.INDEX_NAME
                      || ' REBUILD PARTITION ' || P.PARTITION_NAME || V_ONLINE;
                EXECUTE IMMEDIATE V_SQL;
                V_SUCCESS := V_SUCCESS + 1;
                LOG('[OK-PART] ' || P.INDEX_OWNER || '.' || P.INDEX_NAME || ' [' || P.PARTITION_NAME || ']');
                SAVE_DTL(V_SEQ, 'REBUILD_INDEX', P.INDEX_OWNER, P.INDEX_NAME, 'INDEX PARTITION', P.PARTITION_NAME, 'OK');
            EXCEPTION
                WHEN OTHERS THEN
                    BEGIN
                        EXECUTE IMMEDIATE 'ALTER INDEX ' || P.INDEX_OWNER || '.' || P.INDEX_NAME
                                       || ' REBUILD PARTITION ' || P.PARTITION_NAME;
                        V_SUCCESS := V_SUCCESS + 1;
                        SAVE_DTL(V_SEQ, 'REBUILD_INDEX', P.INDEX_OWNER, P.INDEX_NAME, 'INDEX PARTITION', P.PARTITION_NAME, 'OK', 'OFFLINE 재시도');
                    EXCEPTION
                        WHEN OTHERS THEN
                            V_FAIL := V_FAIL + 1;
                            LOG('[FAIL-PART] ' || P.INDEX_NAME || ' -> ' || SQLERRM);
                            SAVE_DTL(V_SEQ, 'REBUILD_INDEX', P.INDEX_OWNER, P.INDEX_NAME, 'INDEX PARTITION', P.PARTITION_NAME, 'FAIL', SQLERRM);
                    END;
            END;
        END LOOP;

        IF V_STANDALONE THEN END_LOG(V_SEQ, V_SUCCESS, V_FAIL); END IF;
        LOG('=== REBUILD 완료: 성공 ' || V_SUCCESS || '건 / 실패 ' || V_FAIL || '건 ===');
    END PR_SCM_REBUILD_UNUSABLE_INDEX;


    -- ============================================================
    -- 2. Stale Stats 갱신
    -- ============================================================
    PROCEDURE PR_SCM_GATHER_STALE_STATS(
        P_OWNER      IN VARCHAR2 DEFAULT NULL,
        P_PERCENT    IN NUMBER   DEFAULT 30,
        P_CASCADE_YN IN VARCHAR2 DEFAULT 'Y',
        P_LOG_SEQ    IN NUMBER   DEFAULT NULL
    ) IS
        V_CASCADE    BOOLEAN := UPPER(P_CASCADE_YN) = 'Y';
        V_SUCCESS    NUMBER  := 0;
        V_FAIL       NUMBER  := 0;
        V_SEQ        NUMBER  := NVL(P_LOG_SEQ, FN_START_LOG('GATHER_STATS', P_OWNER));
        V_STANDALONE BOOLEAN := P_LOG_SEQ IS NULL;
    BEGIN
        LOG('=== PR_SCM_GATHER_STALE_STATS START ===');

        FOR R IN (
            SELECT DISTINCT OWNER, TABLE_NAME
            FROM   DBA_TAB_STATISTICS
            WHERE  STALE_STATS = 'YES'
              AND  (P_OWNER IS NULL OR OWNER = UPPER(P_OWNER))
              AND  OWNER NOT IN ('SYS','SYSTEM','DBSNMP','SYSMAN','OUTLN',
                                 'MDSYS','ORDSYS','XDB','ORDDATA','WMSYS','SCMC')
            ORDER BY OWNER, TABLE_NAME
        ) LOOP
            BEGIN
                DBMS_STATS.GATHER_TABLE_STATS(
                    OWNNAME          => R.OWNER,
                    TABNAME          => R.TABLE_NAME,
                    ESTIMATE_PERCENT => P_PERCENT,
                    CASCADE          => V_CASCADE,
                    METHOD_OPT       => 'FOR ALL COLUMNS SIZE AUTO',
                    DEGREE           => DBMS_STATS.DEFAULT_DEGREE
                );
                V_SUCCESS := V_SUCCESS + 1;
                LOG('[OK] ' || R.OWNER || '.' || R.TABLE_NAME);
                SAVE_DTL(V_SEQ, 'GATHER_STATS', R.OWNER, R.TABLE_NAME, 'TABLE', NULL, 'OK');
            EXCEPTION
                WHEN OTHERS THEN
                    V_FAIL := V_FAIL + 1;
                    LOG('[FAIL] ' || R.OWNER || '.' || R.TABLE_NAME || ' -> ' || SQLERRM);
                    SAVE_DTL(V_SEQ, 'GATHER_STATS', R.OWNER, R.TABLE_NAME, 'TABLE', NULL, 'FAIL', SQLERRM);
            END;
        END LOOP;

        IF V_STANDALONE THEN END_LOG(V_SEQ, V_SUCCESS, V_FAIL); END IF;
        LOG('=== STATS 갱신 완료: 성공 ' || V_SUCCESS || '건 / 실패 ' || V_FAIL || '건 ===');
    END PR_SCM_GATHER_STALE_STATS;


    -- ============================================================
    -- 3. INVALID Object 재컴파일
    -- ============================================================
    PROCEDURE PR_SCM_RECOMPILE_INVALID_OBJ(
        P_OWNER   IN VARCHAR2 DEFAULT NULL,
        P_LOG_SEQ IN NUMBER   DEFAULT NULL
    ) IS
        V_SQL        VARCHAR2(500);
        V_SUCCESS    NUMBER  := 0;
        V_FAIL       NUMBER  := 0;
        V_SEQ        NUMBER  := NVL(P_LOG_SEQ, FN_START_LOG('RECOMPILE', P_OWNER));
        V_STANDALONE BOOLEAN := P_LOG_SEQ IS NULL;
    BEGIN
        LOG('=== PR_SCM_RECOMPILE_INVALID_OBJ START ===');

        FOR R IN (
            SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
            FROM   DBA_OBJECTS
            WHERE  STATUS      = 'INVALID'
              AND  OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY',
                                   'TRIGGER','VIEW','SYNONYM','TYPE','TYPE BODY')
              AND  (P_OWNER IS NULL OR OWNER = UPPER(P_OWNER))
              AND  OWNER NOT IN ('SYS','SYSTEM','DBSNMP','SYSMAN','OUTLN',
                                 'MDSYS','ORDSYS','XDB','ORDDATA','WMSYS','SCMC')
            ORDER BY OWNER,
                     CASE OBJECT_TYPE
                         WHEN 'TYPE'         THEN 1
                         WHEN 'VIEW'         THEN 2
                         WHEN 'PACKAGE'      THEN 3
                         WHEN 'PACKAGE BODY' THEN 4
                         WHEN 'PROCEDURE'    THEN 5
                         WHEN 'FUNCTION'     THEN 6
                         WHEN 'TRIGGER'      THEN 7
                         ELSE 8 END
        ) LOOP
            BEGIN
                IF    R.OBJECT_TYPE = 'PACKAGE BODY' THEN
                    V_SQL := 'ALTER PACKAGE ' || R.OWNER || '.' || R.OBJECT_NAME || ' COMPILE BODY';
                ELSIF R.OBJECT_TYPE = 'TYPE BODY' THEN
                    V_SQL := 'ALTER TYPE '    || R.OWNER || '.' || R.OBJECT_NAME || ' COMPILE BODY';
                ELSE
                    V_SQL := 'ALTER ' || R.OBJECT_TYPE || ' ' || R.OWNER || '.' || R.OBJECT_NAME || ' COMPILE';
                END IF;

                EXECUTE IMMEDIATE V_SQL;
                V_SUCCESS := V_SUCCESS + 1;
                LOG('[OK] ' || R.OWNER || '.' || R.OBJECT_NAME || ' (' || R.OBJECT_TYPE || ')');
                SAVE_DTL(V_SEQ, 'RECOMPILE', R.OWNER, R.OBJECT_NAME, R.OBJECT_TYPE, NULL, 'OK');
            EXCEPTION
                WHEN OTHERS THEN
                    V_FAIL := V_FAIL + 1;
                    LOG('[FAIL] ' || R.OWNER || '.' || R.OBJECT_NAME || ' -> ' || SQLERRM);
                    SAVE_DTL(V_SEQ, 'RECOMPILE', R.OWNER, R.OBJECT_NAME, R.OBJECT_TYPE, NULL, 'FAIL', SQLERRM);
            END;
        END LOOP;

        IF V_STANDALONE THEN END_LOG(V_SEQ, V_SUCCESS, V_FAIL); END IF;
        LOG('=== RECOMPILE 완료: 성공 ' || V_SUCCESS || '건 / 실패 ' || V_FAIL || '건 ===');
    END PR_SCM_RECOMPILE_INVALID_OBJ;


    -- ============================================================
    -- 4. Lock/Block 세션 탐지 및 Kill
    -- ============================================================
    PROCEDURE PR_SCM_KILL_BLOCKED_SESSION(
        P_WAIT_MIN  IN NUMBER   DEFAULT 10,
        P_KILL_YN   IN VARCHAR2 DEFAULT '',
        P_LOG_SEQ   IN NUMBER   DEFAULT NULL
    ) IS
        V_KILL_CMD   VARCHAR2(200);
        V_COUNT      NUMBER  := 0;
        V_SEQ        NUMBER  := NVL(P_LOG_SEQ, FN_START_LOG('KILL_SESSION', NULL));
        V_STANDALONE BOOLEAN := P_LOG_SEQ IS NULL;
        -- 세션별 처리 결과 변수
        V_KILL_YN2   VARCHAR2(1);
        V_KILL_TIME  DATE;
    BEGIN
        LOG('=== PR_SCM_KILL_BLOCKED_SESSION START (기준: ' || P_WAIT_MIN || '분, KILL=' || P_KILL_YN || ') ===');

        FOR R IN (
            SELECT S.SID, S.SERIAL#, S.USERNAME,
                   S.BLOCKING_SESSION, S.SECONDS_IN_WAIT,
                   S.MODULE, S.MACHINE, S.SQL_ID
            FROM   V$SESSION S
            WHERE  S.BLOCKING_SESSION IS NOT NULL
              AND  S.SECONDS_IN_WAIT  >= P_WAIT_MIN * 60
              AND  S.STATUS           = 'ACTIVE'
            ORDER BY S.SECONDS_IN_WAIT DESC
        ) LOOP
            -- 세션별 초기화
            V_KILL_YN2  := '';
            V_KILL_TIME := NULL;

            LOG('[BLOCKED] SID=' || R.SID
                || ' USER='         || NVL(R.USERNAME, '(none)')
                || ' WAIT='         || ROUND(R.SECONDS_IN_WAIT/60,1) || '분'
                || ' BLOCKING_SID=' || R.BLOCKING_SESSION);

            IF UPPER(P_KILL_YN) = 'Y' THEN
                BEGIN
                    V_KILL_CMD := 'ALTER SYSTEM KILL SESSION ''' || R.SID || ',' || R.SERIAL# || ''' IMMEDIATE';
                    EXECUTE IMMEDIATE V_KILL_CMD;
                    V_COUNT     := V_COUNT + 1;
                    V_KILL_YN2  := 'Y';
                    V_KILL_TIME := SYSDATE;
                    LOG('[KILLED] SID=' || R.SID);
                EXCEPTION
                    WHEN OTHERS THEN
                        LOG('[KILL FAIL] SID=' || R.SID || ' -> ' || SQLERRM);
                END;
            END IF;

            -- 이력 저장: AUTONOMOUS_TRANSACTION 은 SAVE_LOCK_LOG 내부에서 처리
            SAVE_LOCK_LOG(
                P_SID       => R.SID,
                P_SERIAL    => R.SERIAL#,
                P_USERNAME  => R.USERNAME,
                P_MODULE    => R.MODULE,
                P_MACHINE   => R.MACHINE,
                P_BLOCKING  => R.BLOCKING_SESSION,
                P_WAIT_SEC  => R.SECONDS_IN_WAIT,
                P_SQL_ID    => R.SQL_ID,
                P_KILL_YN   => V_KILL_YN2,
                P_KILL_TIME => V_KILL_TIME
            );
        END LOOP;

        IF V_STANDALONE THEN END_LOG(V_SEQ, V_COUNT, 0); END IF;
        LOG('=== LOCK 탐지 완료' || CASE WHEN UPPER(P_KILL_YN)='Y' THEN ' / KILL: '||V_COUNT||'건' ELSE ' (KILL 미수행)' END || ' ===');
    END PR_SCM_KILL_BLOCKED_SESSION;


    -- ============================================================
    -- 5. Tablespace 사용률 점검 + 스냅샷 저장
    -- ============================================================
    PROCEDURE PR_SCM_CHECK_TABLESPACE_USAGE(
        P_ALERT_PCT IN NUMBER   DEFAULT 80,
        P_SAVE_YN   IN VARCHAR2 DEFAULT 'Y'
    ) IS
        V_ALERT_COUNT NUMBER := 0;
        V_TODAY       DATE   := TRUNC(SYSDATE);
    BEGIN
        LOG('=== PR_SCM_CHECK_TABLESPACE_USAGE START (경고기준: ' || P_ALERT_PCT || '%) ===');

        IF UPPER(P_SAVE_YN) = 'Y' THEN
            DELETE FROM SCM_MGR.SCM_TBS_SNAPSHOT WHERE SNAP_DATE = V_TODAY;
        END IF;

        FOR R IN (
            SELECT TS.TABLESPACE_NAME,
                   TS.STATUS,
                   ROUND(NVL(F.FREE_MB,0), 1)                                  AS FREE_MB,
                   ROUND(NVL(U.USED_MB,0), 1)                                  AS USED_MB,
                   ROUND(NVL(U.USED_MB,0) + NVL(F.FREE_MB,0), 1)              AS TOTAL_MB,
                   ROUND(NVL(U.USED_MB,0)
                         / NULLIF(NVL(U.USED_MB,0)+NVL(F.FREE_MB,0),0)*100, 1) AS USED_PCT
            FROM   DBA_TABLESPACES TS
            LEFT JOIN (
                SELECT TABLESPACE_NAME, ROUND(SUM(BYTES)/1024/1024,1) AS FREE_MB
                FROM   DBA_FREE_SPACE GROUP BY TABLESPACE_NAME
            ) F ON F.TABLESPACE_NAME = TS.TABLESPACE_NAME
            LEFT JOIN (
                SELECT TABLESPACE_NAME, ROUND(SUM(BYTES)/1024/1024,1) AS USED_MB
                FROM   DBA_SEGMENTS GROUP BY TABLESPACE_NAME
            ) U ON U.TABLESPACE_NAME = TS.TABLESPACE_NAME
            WHERE  TS.CONTENTS <> 'TEMPORARY'
            ORDER BY USED_PCT DESC NULLS LAST
        ) LOOP
            IF R.USED_PCT >= P_ALERT_PCT THEN
                V_ALERT_COUNT := V_ALERT_COUNT + 1;
                LOG('[ALERT!] ' || RPAD(R.TABLESPACE_NAME,30)
                    || ' 사용률=' || R.USED_PCT || '%'
                    || ' (사용=' || R.USED_MB || 'MB / 전체=' || R.TOTAL_MB || 'MB)');
            ELSE
                LOG('[OK]    ' || RPAD(R.TABLESPACE_NAME,30)
                    || ' 사용률=' || R.USED_PCT || '%');
            END IF;

            IF UPPER(P_SAVE_YN) = 'Y' THEN
                INSERT INTO SCM_MGR.SCM_TBS_SNAPSHOT (
                    SNAP_SEQ, SNAP_DATE, TABLESPACE_NAME, STATUS,
                    TOTAL_MB, USED_MB, FREE_MB, USED_PCT, ALERT_YN
                ) VALUES (
                    SCM_MGR.SEQ1_SCM_TBS_SNAPSHOT.NEXTVAL, V_TODAY,
                    R.TABLESPACE_NAME, R.STATUS,
                    R.TOTAL_MB, R.USED_MB, R.FREE_MB, R.USED_PCT,
                    CASE WHEN R.USED_PCT >= P_ALERT_PCT THEN 'Y' ELSE '' END
                );
            END IF;
        END LOOP;

        IF UPPER(P_SAVE_YN) = 'Y' THEN
            COMMIT;
            LOG('스냅샷 저장 완료');
        END IF;

        IF V_ALERT_COUNT > 0 THEN
            LOG('*** 경고! ' || V_ALERT_COUNT || '개 TABLESPACE ' || P_ALERT_PCT || '% 초과 ***');
        END IF;
    END PR_SCM_CHECK_TABLESPACE_USAGE;


    -- ============================================================
    -- 6. Audit 로그 정리
    -- ============================================================
    PROCEDURE PR_SCM_PURGE_AUDIT_LOG(
        P_KEEP_DAYS IN NUMBER DEFAULT 90
    ) IS
        V_COUNT  NUMBER;
        V_BEFORE DATE := TRUNC(SYSDATE) - P_KEEP_DAYS;
    BEGIN
        LOG('=== PR_SCM_PURGE_AUDIT_LOG START (기준: ' || TO_CHAR(V_BEFORE,'YYYY-MM-DD') || ' 이전) ===');

        SELECT COUNT(*) INTO V_COUNT FROM SYS.AUD$ WHERE NTIMESTAMP# < V_BEFORE;
        LOG('삭제 대상: ' || V_COUNT || '건');

        IF V_COUNT > 0 THEN
            DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
                AUDIT_TRAIL_TYPE        => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
                USE_LAST_ARCH_TIMESTAMP => FALSE,
                CONTAINER               => DBMS_AUDIT_MGMT.CONTAINER_CURRENT
            );
            LOG('AUDIT TRAIL CLEAN 완료');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN LOG('[ERROR] ' || SQLERRM);
    END PR_SCM_PURGE_AUDIT_LOG;


    -- ============================================================
    -- 7. 오래된 파티션 DROP
    --    대상 테이블 : SCM_MAINT_LOG, SCM_MAINT_DTL,
    --                 SCM_TBS_SNAPSHOT, SCM_LOCK_HISTORY
    --    파티션명 규칙 : P_YYYYMM
    --    기준 : 오늘 기준 P_KEEP_MONTHS 개월 초과 파티션 삭제
    --    P_EXECUTE_YN = '' : 대상 목록만 출력 (기본, 안전)
    --    P_EXECUTE_YN = 'Y' : 실제 DROP 수행
    -- ============================================================
    PROCEDURE PR_SCM_DROP_OLD_PARTITION(
        P_KEEP_MONTHS IN NUMBER   DEFAULT 12,
        P_EXECUTE_YN  IN VARCHAR2 DEFAULT ''
    ) IS
        V_CUTOFF_YYYYMM VARCHAR2(6);
        V_SQL           VARCHAR2(500);
        V_DROP_COUNT    NUMBER := 0;

        TYPE T_TABLE_LIST IS TABLE OF VARCHAR2(50);
        V_TABLES T_TABLE_LIST := T_TABLE_LIST(
            'SCM_MAINT_LOG',
            'SCM_MAINT_DTL',
            'SCM_TBS_SNAPSHOT',
            'SCM_LOCK_HISTORY'
        );
    BEGIN
        -- 삭제 기준 월 (오늘에서 N개월 전)
        -- 예) 보존 12개월, 오늘 2026-02 → 2025-02 이전 파티션 삭제
        V_CUTOFF_YYYYMM := TO_CHAR(ADD_MONTHS(SYSDATE, -P_KEEP_MONTHS), 'YYYYMM');

        LOG('=== PR_SCM_DROP_OLD_PARTITION START ===');
        LOG('보존 기간 : ' || P_KEEP_MONTHS || '개월');
        LOG('삭제 기준 : P_' || V_CUTOFF_YYYYMM || ' 미만 파티션');
        LOG('실행 여부 : ' || P_EXECUTE_YN || ' (Y=실제DROP / N=확인만)');
        LOG(RPAD('-', 72, '-'));

        FOR T IN 1 .. V_TABLES.COUNT LOOP
            FOR P IN (
                SELECT  TP.TABLE_NAME,
                        TP.PARTITION_NAME,
                        TP.HIGH_VALUE,
                        TP.NUM_ROWS,
                        TP.BLOCKS
                FROM    DBA_TAB_PARTITIONS TP
                WHERE   TP.TABLE_OWNER    = 'SCM_MGR'
                  AND   TP.TABLE_NAME     = V_TABLES(T)
                  AND   TP.PARTITION_NAME LIKE 'P\_2%' ESCAPE '\'  -- P_YYYYMM 형태만
                  AND   REPLACE(TP.PARTITION_NAME, 'P_', '') < V_CUTOFF_YYYYMM
                ORDER BY TP.PARTITION_NAME
            ) LOOP
                LOG('[대상] ' || RPAD(P.TABLE_NAME, 22)
                    || ' 파티션=' || RPAD(P.PARTITION_NAME, 10)
                    || ' ROWS='   || RPAD(NVL(TO_CHAR(P.NUM_ROWS), '?'), 8)
                    || ' BLOCKS=' || NVL(TO_CHAR(P.BLOCKS), '?'));

                IF UPPER(P_EXECUTE_YN) = 'Y' THEN
                    BEGIN
                        -- UPDATE GLOBAL INDEXES : 글로벌 인덱스 UNUSABLE 방지
                        V_SQL := 'ALTER TABLE SCM_MGR.' || P.TABLE_NAME
                              || ' DROP PARTITION '     || P.PARTITION_NAME
                              || ' UPDATE GLOBAL INDEXES';
                        EXECUTE IMMEDIATE V_SQL;
                        V_DROP_COUNT := V_DROP_COUNT + 1;
                        LOG('[DROPPED] ' || P.TABLE_NAME || ' > ' || P.PARTITION_NAME);
                    EXCEPTION
                        WHEN OTHERS THEN
                            LOG('[DROP FAIL] ' || P.TABLE_NAME || '.' || P.PARTITION_NAME
                                || ' -> ' || SQLERRM);
                    END;
                END IF;
            END LOOP;
        END LOOP;

        LOG(RPAD('-', 72, '-'));
        IF UPPER(P_EXECUTE_YN) = 'Y' THEN
            LOG('=== DROP 완료: 총 ' || V_DROP_COUNT || '개 파티션 삭제됨 ===');
        ELSE
            LOG('=== 확인 완료 (실제 DROP 미수행). P_EXECUTE_YN=>''Y'' 로 실행 시 DROP 수행 ===');
        END IF;
    END PR_SCM_DROP_OLD_PARTITION;


    -- ============================================================
    -- 8. 전체 유지보수 일괄 수행
    -- ============================================================
    PROCEDURE PR_SCM_RUN_ALL_MAINTENANCE(
        P_OWNER IN VARCHAR2 DEFAULT NULL
    ) IS
        V_SEQ NUMBER;
    BEGIN
        V_SEQ := FN_START_LOG('RUN_ALL', P_OWNER);
        LOG('======================================');
        LOG('  Oracle DB 전체 유지보수 일괄 시작');
        LOG('======================================');

        PR_SCM_CHECK_TABLESPACE_USAGE (P_ALERT_PCT   => 80,  P_SAVE_YN     => 'Y');
        PR_SCM_GATHER_STALE_STATS     (P_OWNER       => P_OWNER, P_LOG_SEQ  => V_SEQ);
        PR_SCM_REBUILD_UNUSABLE_INDEX (P_OWNER       => P_OWNER, P_LOG_SEQ  => V_SEQ);
        PR_SCM_RECOMPILE_INVALID_OBJ  (P_OWNER       => P_OWNER, P_LOG_SEQ  => V_SEQ);
        PR_SCM_KILL_BLOCKED_SESSION   (P_WAIT_MIN     => 10,  P_KILL_YN    => '', P_LOG_SEQ => V_SEQ);
        PR_SCM_PURGE_AUDIT_LOG        (P_KEEP_DAYS   => 90);

        -- 파티션 DROP 은 별도 JOB(JOB_SCM_DROP_PARTITION)으로 매월 1일 수행
        -- 전체 배치에서 매일 호출하지 않도록 분리

        END_LOG(V_SEQ, 0, 0, 'DONE', '전체 유지보수 완료');

        LOG('======================================');
        LOG('  Oracle DB 전체 유지보수 완료');
        LOG('======================================');
    EXCEPTION
        WHEN OTHERS THEN
            END_LOG(V_SEQ, 0, 0, 'ERROR', SQLERRM);
            RAISE;
    END PR_SCM_RUN_ALL_MAINTENANCE;


    -- ============================================================
    -- 9. 유지보수 실행 이력 조회 (PIPELINED FUNCTION)
    --    SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY());
    --    SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(30));
    --    SELECT * FROM TABLE(...) WHERE STATUS = 'ERROR';
    -- ============================================================
    FUNCTION FN_SCM_MAINT_HISTORY(
        P_DAYS IN NUMBER DEFAULT 7
    ) RETURN T_MAINT_HIST_TAB PIPELINED IS
        V_ROW T_MAINT_HIST_ROW;
    BEGIN
        FOR R IN (
            SELECT LOG_SEQ, EXEC_TYPE, START_TIME, END_TIME,
                   ELAPSED_SEC, TARGET_OWNER, SUCCESS_CNT, FAIL_CNT,
                   STATUS, REMARKS
            FROM   SCM_MGR.SCM_MAINT_LOG
            WHERE  START_TIME >= SYSDATE - P_DAYS
            ORDER BY START_TIME DESC
        ) LOOP
            V_ROW.LOG_SEQ      := R.LOG_SEQ;
            V_ROW.EXEC_TYPE    := R.EXEC_TYPE;
            V_ROW.START_TIME   := TO_CHAR(R.START_TIME, 'YYYY-MM-DD HH24:MI:SS');
            V_ROW.END_TIME     := TO_CHAR(R.END_TIME,   'YYYY-MM-DD HH24:MI:SS');
            V_ROW.ELAPSED_SEC  := R.ELAPSED_SEC;
            V_ROW.TARGET_OWNER := R.TARGET_OWNER;
            V_ROW.SUCCESS_CNT  := R.SUCCESS_CNT;
            V_ROW.FAIL_CNT     := R.FAIL_CNT;
            V_ROW.STATUS       := R.STATUS;
            V_ROW.REMARKS      := R.REMARKS;
            PIPE ROW (V_ROW);
        END LOOP;
        RETURN;
    END FN_SCM_MAINT_HISTORY;


    -- ============================================================
    -- 10. Tablespace 사용률 추이 조회 (PIPELINED FUNCTION)
    --     SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND());
    --     SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND('USERS', 60));
    -- ============================================================
    FUNCTION FN_SCM_TBS_TREND(
        P_TBS_NAME IN VARCHAR2 DEFAULT NULL,
        P_DAYS     IN NUMBER   DEFAULT 30
    ) RETURN T_TBS_TREND_TAB PIPELINED IS
        V_ROW T_TBS_TREND_ROW;
    BEGIN
        FOR R IN (
            SELECT SNAP_DATE,
                   TABLESPACE_NAME,
                   TOTAL_MB,
                   USED_MB,
                   FREE_MB,
                   USED_PCT,
                   ALERT_YN
            FROM   SCM_MGR.SCM_TBS_SNAPSHOT
            WHERE  SNAP_DATE >= TRUNC(SYSDATE) - P_DAYS
              AND  (P_TBS_NAME IS NULL OR TABLESPACE_NAME = UPPER(P_TBS_NAME))
            ORDER BY TABLESPACE_NAME, SNAP_DATE
        ) LOOP
            V_ROW.SNAP_DATE       := TO_CHAR(R.SNAP_DATE, 'YYYY-MM-DD');
            V_ROW.TABLESPACE_NAME := R.TABLESPACE_NAME;
            V_ROW.TOTAL_MB        := R.TOTAL_MB;
            V_ROW.USED_MB         := R.USED_MB;
            V_ROW.FREE_MB         := R.FREE_MB;
            V_ROW.USED_PCT        := R.USED_PCT;
            V_ROW.ALERT_YN        := R.ALERT_YN;
            PIPE ROW (V_ROW);
        END LOOP;
        RETURN;
    END FN_SCM_TBS_TREND;

END PKG_SCM_DB_MAINTENANCE;


/*
-- ============================================================
-- SECTION 4. DBMS_SCHEDULER 등록
--   JOB_SCM_DB_MAINTENANCE : 매일 02:00 - 전체 유지보수
--   JOB_SCM_DROP_PARTITION : 매월  1일 03:00 - 파티션 DROP
-- ============================================================
BEGIN
    BEGIN DBMS_SCHEDULER.DROP_JOB('JOB_SCM_DB_MAINTENANCE'); EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_SCHEDULER.DROP_JOB('JOB_SCM_DROP_PARTITION'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- 유지보수 전체 (매일 02:00)
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'JOB_SCM_DB_MAINTENANCE',
        JOB_TYPE        => 'STORED_PROCEDURE',
        JOB_ACTION      => 'SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RUN_ALL_MAINTENANCE',
        START_DATE      => TRUNC(SYSDATE + 1) + 2/24,
        REPEAT_INTERVAL => 'FREQ=DAILY; BYHOUR=2; BYMINUTE=0; BYSECOND=0',
        ENABLED         => TRUE,
        COMMENTS        => 'Oracle DB 전체 유지보수 (Index Rebuild / Stats / Recompile / Lock / TBS)'
    );

    -- 파티션 DROP (매월 1일 03:00)
    DBMS_SCHEDULER.CREATE_JOB(
        JOB_NAME        => 'JOB_SCM_DROP_PARTITION',
        JOB_TYPE        => 'PLSQL_BLOCK',
        JOB_ACTION      => q'[BEGIN SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'Y'); END;]',
        START_DATE      => TRUNC(LAST_DAY(SYSDATE) + 1) + 3/24,  -- 다음달 1일 03:00
        REPEAT_INTERVAL => 'FREQ=MONTHLY; BYMONTHDAY=1; BYHOUR=3; BYMINUTE=0; BYSECOND=0',
        ENABLED         => TRUE,
        COMMENTS        => '이력 테이블 오래된 파티션 자동 DROP (12개월 초과분 삭제)'
    );

    DBMS_OUTPUT.PUT_LINE('=== JOB 등록 완료 ===');
    DBMS_OUTPUT.PUT_LINE('  JOB_SCM_DB_MAINTENANCE : 매일 02:00');
    DBMS_OUTPUT.PUT_LINE('  JOB_SCM_DROP_PARTITION : 매월 1일 03:00');
END;
*/


-- ============================================================
-- SECTION 5. 수동 실행 예시
-- ============================================================
/*
SET SERVEROUTPUT ON SIZE UNLIMITED;

-- 전체 유지보수 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RUN_ALL_MAINTENANCE;

-- 개별 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_REBUILD_UNUSABLE_INDEX;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_GATHER_STALE_STATS;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_RECOMPILE_INVALID_OBJ;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_CHECK_TABLESPACE_USAGE;
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_KILL_BLOCKED_SESSION(P_WAIT_MIN=>5, P_KILL_YN=>'');

-- 파티션 DROP: 대상 확인 (실제 DROP 안함, 기본값)
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'');
-- 파티션 DROP: 실제 수행
EXEC SCM_MGR.PKG_SCM_DB_MAINTENANCE.PR_SCM_DROP_OLD_PARTITION(P_KEEP_MONTHS=>12, P_EXECUTE_YN=>'Y');

-- TBS 사용률 추이 조회 (PIPELINED FUNCTION - SELECT로 조회)
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND());
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND('USERS', 60));
-- 경고 항목만 필터
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND())
WHERE  ALERT_YN = 'Y'
ORDER BY SNAP_DATE DESC;
-- 특정 TBS 사용률 증가 추이
SELECT SNAP_DATE, TABLESPACE_NAME, USED_PCT, USED_MB
FROM   TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_TBS_TREND(P_DAYS => 90))
ORDER BY TABLESPACE_NAME, SNAP_DATE;

-- 유지보수 이력 조회 (PIPELINED FUNCTION)
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY());        -- 최근 7일
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(30));      -- 최근 30일
-- 실패/에러 건만 필터
SELECT * FROM TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(30))
WHERE  STATUS = 'ERROR'
ORDER BY START_TIME DESC;
-- 상세 이력과 JOIN
SELECT H.LOG_SEQ, H.EXEC_TYPE, H.START_TIME, H.STATUS,
       D.OBJECT_NAME, D.STATUS AS DTL_STATUS, D.ERROR_MSG
FROM   TABLE(SCM_MGR.PKG_SCM_DB_MAINTENANCE.FN_SCM_MAINT_HISTORY(7)) H
JOIN   SCM_MGR.SCM_MAINT_DTL D ON D.LOG_SEQ = H.LOG_SEQ
WHERE  D.STATUS = 'FAIL'
ORDER BY H.START_TIME DESC;

-- 현재 파티션 목록 확인
SELECT TABLE_NAME, PARTITION_NAME, HIGH_VALUE,
       NUM_ROWS, BLOCKS,
       ROUND(BLOCKS * 8 / 1024, 1) AS SIZE_MB
FROM   DBA_TAB_PARTITIONS
WHERE  TABLE_OWNER = 'SCM_MGR'
  AND  TABLE_NAME IN ('SCM_MAINT_LOG','SCM_MAINT_DTL','SCM_TBS_SNAPSHOT','SCM_LOCK_HISTORY')
ORDER BY TABLE_NAME, PARTITION_NAME;

-- 테이블 직접 조회
SELECT * FROM SCM_MGR.SCM_MAINT_LOG    ORDER BY LOG_SEQ DESC;
SELECT * FROM SCM_MGR.SCM_MAINT_DTL    WHERE LOG_SEQ = 1 ORDER BY DTL_SEQ;
SELECT * FROM SCM_MGR.SCM_TBS_SNAPSHOT ORDER BY SNAP_DATE DESC, USED_PCT DESC;
SELECT * FROM SCM_MGR.SCM_LOCK_HISTORY ORDER BY DETECT_TIME DESC;

-- JOB 상태 확인
SELECT JOB_NAME, ENABLED, STATE, LAST_START_DATE, NEXT_RUN_DATE
FROM   DBA_SCHEDULER_JOBS
WHERE  JOB_NAME IN ('JOB_SCM_DB_MAINTENANCE','JOB_SCM_DROP_PARTITION');
*/;
/
