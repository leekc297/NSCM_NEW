-- =============================================================================
-- 02_EXTRACT_DDL.sql (v3) — 클라우드 sqlplus/SQLcl 실행 → &UI_ID._DDL.sql 생성 (spool)
-- 대상: 축A(배선 메타)+축B(명칭) 유닛 + 의존 폐포(BFS 반복 확장) 의 &OWNER 소유 객체 전부
--   적용 순서 정렬: TYPE → SEQUENCE → TABLE(+INDEX/COMMENT/TRIGGER) → VIEW
--                 → PACKAGE SPEC → PACKAGE BODY → PROCEDURE → FUNCTION
-- 원칙: DBMS_METADATA 원문 — 산출물 1바이트 수정 금지
-- v2→v3 (2026-08-04): 재귀 CTE 폐포 → BFS 반복 확장으로 교체
--   (UNION ALL 재귀 = 전 경로 열거 — 다이아몬드 의존 그래프에서 지수 폭발·장시간 hang.
--    BFS = 레벨별 1쿼리 + 방문집합 dedup — 유일 객체 수에 선형)
-- =============================================================================
DEFINE UI_ID = 'SYS0016'
DEFINE OWNER = 'SCM_MGR'

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LONG 2000000 LONGCHUNKSIZE 32767 PAGESIZE 0 LINESIZE 32767
SET TRIMSPOOL ON TRIMOUT ON HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF
SET TIMING OFF

SPOOL &UI_ID._DDL.sql

DECLARE
    v_ui    CONSTANT VARCHAR2(30) := '&UI_ID';
    v_own   CONSTANT VARCHAR2(30) := '&OWNER';
    v_clob  CLOB;
    v_tot   PLS_INTEGER := 0;

    -- BFS 폐포: 방문집합('OWNER|NAME|TYPE') + 레벨 frontier('OWNER|NAME')
    TYPE t_seen IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(400);
    v_seen      t_seen;
    v_frontier  SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
    v_next      SYS.ODCIVARCHAR2LIST;
    v_batch     SYS.ODCIVARCHAR2LIST;
    v_clo_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();  -- &OWNER 소유 폐포 객체명
    v_units     SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
    v_depth     PLS_INTEGER := 0;
    v_key       VARCHAR2(400);
    v_nm        VARCHAR2(200);

    PROCEDURE put_clob(p CLOB) IS
        v_pos PLS_INTEGER := 1; v_nl PLS_INTEGER; v_len PLS_INTEGER := DBMS_LOB.GETLENGTH(p);
    BEGIN
        WHILE v_pos <= v_len LOOP
            v_nl := DBMS_LOB.INSTR(p, CHR(10), v_pos);
            IF v_nl = 0 OR v_nl IS NULL THEN v_nl := v_len + 1; END IF;
            DBMS_OUTPUT.PUT_LINE(RTRIM(DBMS_LOB.SUBSTR(p, LEAST(v_nl - v_pos, 32000), v_pos), CHR(13)));
            v_pos := v_nl + 1;
        END LOOP;
    END;

    PROCEDURE emit(p_md_type VARCHAR2, p_name VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('-- ===== ' || p_md_type || ' : ' || p_name || ' =====');
        v_clob := DBMS_METADATA.GET_DDL(p_md_type, p_name, v_own);
        put_clob(v_clob);
        DBMS_OUTPUT.PUT_LINE('/');
        IF p_md_type = 'TABLE' THEN
            FOR d IN (SELECT COLUMN_VALUE t FROM TABLE(SYS.ODCIVARCHAR2LIST('INDEX','COMMENT','TRIGGER'))) LOOP
                BEGIN
                    v_clob := DBMS_METADATA.GET_DEPENDENT_DDL(d.t, p_name, v_own);
                    put_clob(v_clob);
                    DBMS_OUTPUT.PUT_LINE('/');
                EXCEPTION WHEN OTHERS THEN
                    IF SQLCODE = -31608 THEN DBMS_OUTPUT.PUT_LINE('-- (종속 ' || d.t || ' 없음)');
                    ELSE DBMS_OUTPUT.PUT_LINE('-- !! 종속 ' || d.t || ' 추출 오류: ' || SQLERRM); END IF;
                END;
            END LOOP;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('-- !! ' || p_md_type || ' ' || p_name || ' 추출 오류: ' || SQLERRM);
    END;
BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);

    DBMS_OUTPUT.PUT_LINE('-- ' || v_ui || ' DDL (클라우드 추출 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI') || ') — 적용 순서 정렬본');

    -- [1] 시드 유닛 = 축A(배선 메타) + 축B(명칭 코드 객체)
    SELECT COLUMN_VALUE BULK COLLECT INTO v_units FROM (
        SELECT DISTINCT REGEXP_SUBSTR(A.API_URL, '[^.]+', 1, 1) AS COLUMN_VALUE
        FROM   SCM_ADM_MNU_BTN_MPG_M B
        JOIN   SCM_ADM_API_M A ON A.API_ID = B.API_ID
        WHERE  B.MNU_ID = v_ui AND A.API_URL IS NOT NULL
        UNION
        SELECT OBJECT_NAME FROM ALL_OBJECTS
        WHERE  OWNER = v_own AND OBJECT_NAME LIKE '%' || v_ui || '%'
        AND    OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER')
    );
    v_frontier := SYS.ODCIVARCHAR2LIST();
    FOR i IN 1 .. v_units.COUNT LOOP
        v_frontier.EXTEND; v_frontier(v_frontier.COUNT) := v_own || '|' || v_units(i);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-- 시드 유닛 ' || v_units.COUNT || '개');

    -- [2] BFS 폐포 (레벨별 확장 — 경로 열거 없음, 깊이 상한 20)
    WHILE v_frontier.COUNT > 0 AND v_depth < 20 LOOP
        v_depth := v_depth + 1;
        SELECT DISTINCT D.REFERENCED_OWNER || '|' || D.REFERENCED_NAME || '|' || D.REFERENCED_TYPE
        BULK COLLECT INTO v_batch
        FROM   ALL_DEPENDENCIES D
        JOIN   TABLE(v_frontier) F
               ON  D.OWNER = SUBSTR(F.COLUMN_VALUE, 1, INSTR(F.COLUMN_VALUE, '|') - 1)
               AND D.NAME  = SUBSTR(F.COLUMN_VALUE, INSTR(F.COLUMN_VALUE, '|') + 1)
        WHERE  D.REFERENCED_OWNER NOT IN ('SYS','PUBLIC','SYSTEM');

        v_next := SYS.ODCIVARCHAR2LIST();
        FOR i IN 1 .. v_batch.COUNT LOOP
            v_key := v_batch(i);
            IF NOT v_seen.EXISTS(v_key) THEN
                v_seen(v_key) := 1;
                -- 다음 레벨 frontier = OWNER|NAME (TYPE 제거)
                v_next.EXTEND;
                v_next(v_next.COUNT) := SUBSTR(v_key, 1, INSTR(v_key, '|', -1) - 1);
                -- &OWNER 소유분만 DDL 대상 수집
                IF SUBSTR(v_key, 1, INSTR(v_key, '|') - 1) = v_own THEN
                    v_nm := SUBSTR(v_key, INSTR(v_key, '|') + 1,
                                   INSTR(v_key, '|', -1) - INSTR(v_key, '|') - 1);
                    v_clo_names.EXTEND; v_clo_names(v_clo_names.COUNT) := v_nm;
                END IF;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('-- 폐포 레벨 ' || v_depth || ': 신규 ' || v_next.COUNT || ' (누적 유일 ' || v_seen.COUNT || ')');
        v_frontier := v_next;
    END LOOP;

    -- [3] DDL 추출 (적용 순서 정렬)
    FOR o IN (
        SELECT OBJECT_NAME, OBJECT_TYPE,
               DECODE(OBJECT_TYPE, 'PACKAGE','PACKAGE_SPEC', 'PACKAGE BODY','PACKAGE_BODY',
                                   OBJECT_TYPE) MD_TYPE,
               DECODE(OBJECT_TYPE, 'TYPE',1, 'SEQUENCE',2, 'TABLE',3, 'VIEW',4,
                                   'PACKAGE',5, 'PACKAGE BODY',6, 'PROCEDURE',7, 'FUNCTION',8, 'TRIGGER',9, 99) ORD
        FROM   ALL_OBJECTS O
        WHERE  O.OWNER = v_own
        AND    O.OBJECT_TYPE IN ('TYPE','SEQUENCE','TABLE','VIEW','PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION','TRIGGER')
        AND   (O.OBJECT_NAME LIKE '%' || v_ui || '%'
               OR O.OBJECT_NAME IN (SELECT COLUMN_VALUE FROM TABLE(v_units))
               OR O.OBJECT_NAME IN (SELECT COLUMN_VALUE FROM TABLE(v_clo_names)))
        ORDER BY ORD, OBJECT_NAME
    ) LOOP
        v_tot := v_tot + 1;
        emit(o.MD_TYPE, o.OBJECT_NAME);
    END LOOP;

    IF v_tot = 0 THEN
        DBMS_OUTPUT.PUT_LINE('-- !! 추출 대상 0건 — DISCOVER [A]/[B] 를 확인하십시오 (배선 메타 미등록 또는 명칭 패턴 불일치).');
    END IF;
    DBMS_OUTPUT.PUT_LINE('-- ===== 추출 끝 (총 ' || v_tot || ' 객체 / 폐포 유일 ' || v_seen.COUNT || ' / 깊이 ' || v_depth || ') =====');
END;
/

SPOOL OFF
PROMPT === &UI_ID._DDL.sql 생성 완료 — "!!" 오류 0건 + 끝줄 "(총 N 객체)" 확인 후 회수 ===
