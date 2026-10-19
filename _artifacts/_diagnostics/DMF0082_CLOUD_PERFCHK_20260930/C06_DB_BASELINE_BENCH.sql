-- =============================================================================
-- C06_DB_BASELINE_BENCH.sql — DB 자체 처리 속도 기준 벤치 (사내 ↔ 클라우드 동일 작업 비교 · READ-ONLY)
--   계정: SCM_MGR · SQL Developer F5 / sqlplus @C06_DB_BASELINE_BENCH.sql
--   목적: 같은 실행계획·같은 BG 인 문장이 클라우드에서 2.5~3배 느린 현상(C03 비교)을 SQL 과 무관하게 정량화.
--     B1 = 순수 CPU (PL/SQL 루프)                → CPU 코어 속도
--     B2 = SQL 행 생성 + 해시 집계 (메모리)        → SQL 엔진 CPU
--     B3 = 넓은 행 정렬 (PGA · TEMP 유출 여부)     → DMF0082 MF_SP·PIVOT 와 같은 유형
--     B4 = GTT 적재·삭제 (INSERT 20만 행 · ROLLBACK) → DMF0082 스테이징 유형 (redo/undo · GTT 저장소)
--   각 3회 · 최소값으로 비교. 영구 테이블 변경 없음 (B4 는 GT_DMF0082_PARAM_TOKEN 에 넣고 ROLLBACK).
--   ⚠ 같은 시각대 두 DB 에서 실행하면 비교가 정확하다.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
SET FEEDBACK OFF
SPOOL C06_DB_BASELINE_BENCH_OUT.txt
DECLARE
    TYPE t_n IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    r t_n; t0 NUMBER; n NUMBER; x NUMBER;
    v_tmp0 NUMBER; v_tmp1 NUMBER;
    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;
    FUNCTION mn(a t_n) RETURN VARCHAR2 IS m NUMBER := 1e9; s VARCHAR2(100);
    BEGIN FOR i IN 1 .. a.COUNT LOOP m := LEAST(m, a(i)); s := s || TO_CHAR(a(i)/100,'FM990.00') || ' '; END LOOP;
          RETURN RPAD(TO_CHAR(m/100,'FM990.00') || 's', 9) || '(' || TRIM(s) || ')'; END;
    FUNCTION tmpw RETURN NUMBER IS v NUMBER;
    BEGIN SELECT S.VALUE INTO v FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC# = S.STATISTIC#
           WHERE N.NAME = 'physical writes direct temporary tablespace'; RETURN v; END;
BEGIN
    p('DB=' || SYS_CONTEXT('USERENV','DB_NAME') || '  HOST=' || SYS_CONTEXT('USERENV','SERVER_HOST')
      || '  INSTANCE=' || SYS_CONTEXT('USERENV','INSTANCE_NAME') || '  ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));

    FOR i IN 1 .. 3 LOOP                                   -- B1 순수 CPU
        t0 := DBMS_UTILITY.GET_TIME; x := 0;
        FOR j IN 1 .. 20000000 LOOP x := x + MOD(j, 7); END LOOP;
        r(i) := DBMS_UTILITY.GET_TIME - t0;
    END LOOP;
    p('B1 PL/SQL 루프 2천만회          ' || mn(r));

    FOR i IN 1 .. 3 LOOP                                   -- B2 행 생성 + 해시 집계
        t0 := DBMS_UTILITY.GET_TIME;
        SELECT COUNT(*) INTO n FROM (SELECT MOD(LEVEL, 50000) K, SUM(LEVEL) S FROM DUAL CONNECT BY LEVEL <= 3000000 GROUP BY MOD(LEVEL, 50000));
        r(i) := DBMS_UTILITY.GET_TIME - t0;
    END LOOP;
    p('B2 300만행 생성·해시집계        ' || mn(r));

    FOR i IN 1 .. 3 LOOP                                   -- B3 넓은 행 정렬 (20만 행 × 약 300B — MF_SP 와 유사)
        v_tmp0 := tmpw; t0 := DBMS_UTILITY.GET_TIME;
        SELECT COUNT(*) INTO n FROM (
          SELECT K, MAX(A1), MAX(A2), MAX(A3), MAX(A4), SUM(Q) FROM (
            SELECT MOD(LEVEL, 200000) K, RPAD('A'||LEVEL, 60, 'x') A1, RPAD('B'||LEVEL, 60, 'y') A2,
                   RPAD('C'||LEVEL, 60, 'z') A3, RPAD('D'||LEVEL, 60, 'w') A4, LEVEL Q
              FROM DUAL CONNECT BY LEVEL <= 200000)
          GROUP BY K ORDER BY K);
        r(i) := DBMS_UTILITY.GET_TIME - t0; v_tmp1 := tmpw;
    END LOOP;
    p('B3 20만행×300B 정렬집계         ' || mn(r) || '  TEMP 쓰기 블록(마지막) ' || (v_tmp1 - v_tmp0));

    FOR i IN 1 .. 3 LOOP                                   -- B4 GTT 적재 20만 행 + ROLLBACK
        t0 := DBMS_UTILITY.GET_TIME;
        INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
        SELECT 'C06_BENCH', RPAD(TO_CHAR(LEVEL), 40, 'x') FROM DUAL CONNECT BY LEVEL <= 200000;
        ROLLBACK;
        r(i) := DBMS_UTILITY.GET_TIME - t0;
    END LOOP;
    p('B4 GTT INSERT 20만행+ROLLBACK   ' || mn(r));
END;
/
SPOOL OFF
SET FEEDBACK ON
