-- 99_ROLLBACK_3_LOGIC — [E20261027-CELLPRODDASH] 로직 원복 (PKG 삽입 2곳 제거 · MAPPING '-' → '/' 3곳 되돌림). 전체 F5, 멱등
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src CLOB; v_new CLOB; v_p1 PLS_INTEGER; v_p2 PLS_INTEGER; v_cs PLS_INTEGER; v_ce PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := 'E20261027-CELLPRODDASH';
    c_anc  CONSTANT VARCHAR2(200) := '    /* [E20261013-DMF0082AFSSHARE]';
    c_b1   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 1: P_DMF0082_GET_MAIN_DATA
        '    /* [E20261027-CELLPRODDASH] Cell Prod Site 빈값 표기 통일 ''/'' → ''-'' (사용자 확인 2026-10-27).' || CHR(10) ||
        '       AS-IS 는 전 사업부 빈값 = ''-'' (원장 DEFAULT ''-'' · 81 계획 arm 리터럴 ''-'' · 40 은 ''-'' = Common 코드).' || CHR(10) ||
        '       TO-BE 원장 DEFAULT ''/'' · 실적 매핑 ELSE ''/'' 기간에 적재된 실적 행이 ''/'' 라 같은 키의 계획(''-'')과 줄이 갈렸다' || CHR(10) ||
        '       (클라우드 81 BMW_US_SPA · Cell Prod Site 를 화면에 표시한 계정). 원장 정리와 별개로 조회 결과에 ''/'' · 공백이 섞여도 ''-'' 로 맞춘다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    UPDATE SCM_MGR.GT_DMF0082_MF_SP' || CHR(10) ||
        '    SET    CELL_PROD_SITE_ID = ''-''' || CHR(10) ||
        '    WHERE  CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL);' || CHR(10) ||
        '' || CHR(10);
    c_b2   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT
        '    /* [E20261027-CELLPRODDASH] Cell Prod Site 빈값 표기 통일 ''/'' → ''-'' (사용자 확인 2026-10-27).' || CHR(10) ||
        '       AS-IS 는 전 사업부 빈값 = ''-'' (원장 DEFAULT ''-'' · 81 계획 arm 리터럴 ''-'' · 40 은 ''-'' = Common 코드).' || CHR(10) ||
        '       TO-BE 원장 DEFAULT ''/'' · 실적 매핑 ELSE ''/'' 기간에 적재된 실적 행이 ''/'' 라 같은 키의 계획(''-'')과 줄이 갈렸다' || CHR(10) ||
        '       (클라우드 81 BMW_US_SPA · Cell Prod Site 를 화면에 표시한 계정). 원장 정리와 별개로 조회 결과에 ''/'' · 공백이 섞여도 ''-'' 로 맞춘다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    UPDATE SCM_MGR.GTT_MF_SP' || CHR(10) ||
        '    SET    CELL_PROD_SITE_ID = ''-''' || CHR(10) ||
        '    WHERE  CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL);' || CHR(10) ||
        '' || CHR(10);
    c_o1 CONSTANT VARCHAR2(400) := '                     ELSE ''/'' END AS CELL_PROD_SITE_ID    --  2026.10.11 AJS' || CHR(10);   -- MAPPING 원문 줄 (2곳)
    c_r1 CONSTANT VARCHAR2(400) := '                     ELSE ''-'' END AS CELL_PROD_SITE_ID    --  [E20261027-CELLPRODDASH] 2026.10.27 AS-IS ELSE ''-'' 복원 (2026.10.11 AJS ''/'')' || CHR(10);
    c_o2 CONSTANT VARCHAR2(400) := '                      ELSE ''/'' END;    --  2026.10.11 AJS' || CHR(10);   -- MAPPING 원문 줄 (1곳)
    c_r2 CONSTANT VARCHAR2(400) := '                      ELSE ''-'' END;    --  [E20261027-CELLPRODDASH] 2026.10.27 AS-IS ELSE ''-'' 복원 (2026.10.11 AJS ''/'')' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    FUNCTION src(p_name VARCHAR2, p_type VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_name AND TYPE = p_type ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));
    END;
    PROCEDURE recompile(p_name VARCHAR2, p_type VARCHAR2, p_new CLOB, p_old CLOB, p_msg VARCHAR2) IS
        v_st VARCHAR2(30); v_err PLS_INTEGER;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_new;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = p_name AND OBJECT_TYPE = p_type;
        SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type;
        IF v_st <> 'VALID' OR v_err > 0 THEN
            FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
                DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
            END LOOP;
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_old;
            RAISE_APPLICATION_ERROR(-20005, p_name || ' 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원');
        END IF;
        DBMS_OUTPUT.PUT_LINE(p_msg || ' — ' || p_name || ' ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    END;
BEGIN
    v_src := src('PKG_DMF0082', 'PACKAGE BODY');
    IF cnt(v_src, c_mark) = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082 마커 없음'); RETURN; END IF;
    IF cnt(v_src, c_b1) <> 1 OR cnt(v_src, c_b2) <> 1 THEN RAISE_APPLICATION_ERROR(-20001, 'PKG_DMF0082 중단 — 삽입 문구 매칭 불일치 · 원문 무변경'); END IF;
    v_new := REPLACE(REPLACE(v_src, c_b1, NULL), c_b2, NULL);
    IF cnt(v_new, c_mark) <> 0 THEN RAISE_APPLICATION_ERROR(-20004, 'PKG_DMF0082 중단 — 마커 잔존 · 원문 무변경'); END IF;
    recompile('PKG_DMF0082', 'PACKAGE BODY', v_new, v_src, 'ROLLED BACK');
END;
/
DECLARE
    v_src CLOB; v_new CLOB;
    c_mark CONSTANT VARCHAR2(40) := 'E20261027-CELLPRODDASH';
    c_anc  CONSTANT VARCHAR2(200) := '    /* [E20261013-DMF0082AFSSHARE]';
    c_b1   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 1: P_DMF0082_GET_MAIN_DATA
        '    /* [E20261027-CELLPRODDASH] Cell Prod Site 빈값 표기 통일 ''/'' → ''-'' (사용자 확인 2026-10-27).' || CHR(10) ||
        '       AS-IS 는 전 사업부 빈값 = ''-'' (원장 DEFAULT ''-'' · 81 계획 arm 리터럴 ''-'' · 40 은 ''-'' = Common 코드).' || CHR(10) ||
        '       TO-BE 원장 DEFAULT ''/'' · 실적 매핑 ELSE ''/'' 기간에 적재된 실적 행이 ''/'' 라 같은 키의 계획(''-'')과 줄이 갈렸다' || CHR(10) ||
        '       (클라우드 81 BMW_US_SPA · Cell Prod Site 를 화면에 표시한 계정). 원장 정리와 별개로 조회 결과에 ''/'' · 공백이 섞여도 ''-'' 로 맞춘다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    UPDATE SCM_MGR.GT_DMF0082_MF_SP' || CHR(10) ||
        '    SET    CELL_PROD_SITE_ID = ''-''' || CHR(10) ||
        '    WHERE  CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL);' || CHR(10) ||
        '' || CHR(10);
    c_b2   CONSTANT VARCHAR2(32767) :=   -- PKG 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT
        '    /* [E20261027-CELLPRODDASH] Cell Prod Site 빈값 표기 통일 ''/'' → ''-'' (사용자 확인 2026-10-27).' || CHR(10) ||
        '       AS-IS 는 전 사업부 빈값 = ''-'' (원장 DEFAULT ''-'' · 81 계획 arm 리터럴 ''-'' · 40 은 ''-'' = Common 코드).' || CHR(10) ||
        '       TO-BE 원장 DEFAULT ''/'' · 실적 매핑 ELSE ''/'' 기간에 적재된 실적 행이 ''/'' 라 같은 키의 계획(''-'')과 줄이 갈렸다' || CHR(10) ||
        '       (클라우드 81 BMW_US_SPA · Cell Prod Site 를 화면에 표시한 계정). 원장 정리와 별개로 조회 결과에 ''/'' · 공백이 섞여도 ''-'' 로 맞춘다.' || CHR(10) ||
        '       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    UPDATE SCM_MGR.GTT_MF_SP' || CHR(10) ||
        '    SET    CELL_PROD_SITE_ID = ''-''' || CHR(10) ||
        '    WHERE  CELL_PROD_SITE_ID = ''/'' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL);' || CHR(10) ||
        '' || CHR(10);
    c_o1 CONSTANT VARCHAR2(400) := '                     ELSE ''/'' END AS CELL_PROD_SITE_ID    --  2026.10.11 AJS' || CHR(10);   -- MAPPING 원문 줄 (2곳)
    c_r1 CONSTANT VARCHAR2(400) := '                     ELSE ''-'' END AS CELL_PROD_SITE_ID    --  [E20261027-CELLPRODDASH] 2026.10.27 AS-IS ELSE ''-'' 복원 (2026.10.11 AJS ''/'')' || CHR(10);
    c_o2 CONSTANT VARCHAR2(400) := '                      ELSE ''/'' END;    --  2026.10.11 AJS' || CHR(10);   -- MAPPING 원문 줄 (1곳)
    c_r2 CONSTANT VARCHAR2(400) := '                      ELSE ''-'' END;    --  [E20261027-CELLPRODDASH] 2026.10.27 AS-IS ELSE ''-'' 복원 (2026.10.11 AJS ''/'')' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    FUNCTION src(p_name VARCHAR2, p_type VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_name AND TYPE = p_type ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN REPLACE(v, CHR(13) || CHR(10), CHR(10));
    END;
    PROCEDURE recompile(p_name VARCHAR2, p_type VARCHAR2, p_new CLOB, p_old CLOB, p_msg VARCHAR2) IS
        v_st VARCHAR2(30); v_err PLS_INTEGER;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_new;
        SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = p_name AND OBJECT_TYPE = p_type;
        SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type;
        IF v_st <> 'VALID' OR v_err > 0 THEN
            FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = p_name AND TYPE = p_type ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
                DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
            END LOOP;
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || p_old;
            RAISE_APPLICATION_ERROR(-20005, p_name || ' 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원');
        END IF;
        DBMS_OUTPUT.PUT_LINE(p_msg || ' — ' || p_name || ' ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    END;
BEGIN
    v_src := src('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE');
    IF cnt(v_src, c_mark) = 0 THEN DBMS_OUTPUT.PUT_LINE('SKIP — MAPPING 마커 없음'); RETURN; END IF;
    v_new := v_src;
    v_new := REPLACE(v_new, c_r1, c_o1);
    v_new := REPLACE(v_new, c_r2, c_o2);
    IF cnt(v_new, c_mark) <> 0 THEN RAISE_APPLICATION_ERROR(-20004, 'MAPPING 중단 — 마커 잔존 · 원문 무변경'); END IF;
    recompile('PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING', 'PROCEDURE', v_new, v_src, 'ROLLED BACK');
END;
/
SELECT 'POST' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0082','PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING') ORDER BY 2, 3;
