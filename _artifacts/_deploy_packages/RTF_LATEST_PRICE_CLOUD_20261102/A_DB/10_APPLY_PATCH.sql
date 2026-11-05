-- SOURCE-FRESH: SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW PROCEDURE LAST_DDL=2026-11-02 15:39:46 FETCHED=2026-11-02 15:53:45 DB=ZIOUI1
-- SOURCE-FRESH: SCM_MGR.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE PROCEDURE LAST_DDL=2026-11-02 15:39:46 FETCHED=2026-11-02 15:53:45 DB=ZIOUI1
-- 10_APPLY [E20261102-RTFLATESTPRICE] (SCM_MGR, whole-file F5, no input, idempotent)
-- RTF week without a price row: SalesAmt uses the latest earlier price (>0). UI input validation is unchanged. Price ledgers are not written.
-- Reads this DB's USER_SOURCE and inserts blocks at anchors only. Marker present = SKIP. Anchor count != 1 = stop with source unchanged.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_RTFLP_SRC_20261102';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZB_RTFLP_SRC_20261102 (OBJ_NAME VARCHAR2(128) NOT NULL, OBJ_TYPE VARCHAR2(30) NOT NULL, SRC CLOB NOT NULL, SAVED_AT DATE NOT NULL, CONSTRAINT PK_ZB_RTFLP_SRC_2026110 PRIMARY KEY (OBJ_NAME, OBJ_TYPE))';
    END IF;
END;
/
DECLARE
    c_n CONSTANT VARCHAR2(128) := 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW';
    c_t CONSTANT VARCHAR2(30)  := 'PROCEDURE';
    v_src CLOB; v_new CLOB; lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER;
    v_tok VARCHAR2(4000); v_blk VARCHAR2(32767); n PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := 'E20261102-RTFLATESTPRICE';
    FUNCTION src(p_n VARCHAR2, p_t VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_n AND TYPE = p_t ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN v;
    END;
    PROCEDURE compile_src(p_sql CLOB) IS   -- ORA-24344(컴파일 오류)만 아래 STATUS 로 판정, 그 외 오류는 그대로 올린다
    BEGIN
        EXECUTE IMMEDIATE TO_CLOB('CREATE OR REPLACE ') || p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -24344 THEN RAISE; END IF;
    END;
    FUNCTION st(p_n VARCHAR2, p_t VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(30);
    BEGIN
        SELECT STATUS INTO v FROM USER_OBJECTS WHERE OBJECT_NAME = p_n AND OBJECT_TYPE = p_t;
        RETURN v;
    END;
BEGIN
    v_src := src(c_n, c_t);
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied: ' || c_n);
        RETURN;
    END IF;
    v_new := v_src;
    -- patch 1
    lo := 1; hi := DBMS_LOB.GETLENGTH(v_new) + 1;
    
    v_tok := ''' : A007--''';
    pos := DBMS_LOB.INSTR(v_new, v_tok, lo);
    IF lo = 0 OR hi = 0 OR pos = 0 OR pos >= hi OR (DBMS_LOB.INSTR(v_new, v_tok, pos + 1) BETWEEN 1 AND hi - 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW anchor 1 not exactly 1 - source unchanged. Send this result.');
    END IF;
    pos := DBMS_LOB.INSTR(v_new, CHR(10), pos + LENGTH(v_tok) - 1) + 1;
    v_blk := '' || CHR(10) ||
        '                /* [E20261102-RTFLATESTPRICE] RTF week without price: use latest earlier price for SalesAmt */' || CHR(10) ||
        '                IF ( V_DIVISION_ID = ''40'' ) THEN' || CHR(10) ||
        '                    INSERT INTO GT_PRDM_T2_PRICE' || CHR(10) ||
        '                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )' || CHR(10) ||
        '                    SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.ITEM_ID, W.BASIS_START_DATE' || CHR(10) ||
        '                         , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE), P.MEASURE, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS' || CHR(10) ||
        '                         , MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE)' || CHR(10) ||
        '                      FROM ( SELECT DISTINCT T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, C.BASIS_START_DATE' || CHR(10) ||
        '                               FROM GT_PRDM_T2_MKT_FCST T' || CHR(10) ||
        '                               JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = T.YYYYMMDD' || CHR(10) ||
        '                              WHERE T.MEASURE = ''RTF_SYS_RP'' AND T.QTY <> 0 ) W' || CHR(10) ||
        '                      JOIN DM_PLN_CFM_SELLING_PRICE P' || CHR(10) ||
        '                        ON P.DIVISION_ID = W.DIVISION_ID' || CHR(10) ||
        '                       AND P.END_CUSTOMER = W.PROJECT_CODE' || CHR(10) ||
        '                       AND P.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '                       AND P.ITEM_ID = W.ITEM_ID' || CHR(10) ||
        '                       AND P.DOM_EXP = W.DOM_EXP' || CHR(10) ||
        '                       AND P.FCST_TYPE = W.FCST_TYPE' || CHR(10) ||
        '                       AND P.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '                       AND P.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '                           AND P.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID' || CHR(10) ||
        '                       AND P.MEASURE IN ( ''KRW'', ''LOC'', ''USD'' )' || CHR(10) ||
        '                       AND P.PRICE > 0' || CHR(10) ||
        '                       AND P.YYYYMMDD < W.BASIS_START_DATE' || CHR(10) ||
        '                     WHERE NOT EXISTS ( SELECT 1 FROM GT_PRDM_T2_PRICE X' || CHR(10) ||
        '                                         WHERE X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '                                           AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE' || CHR(10) ||
        '                                           AND X.INCOTERMS = W.INCOTERMS AND X.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '                                           AND X.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID' || CHR(10) ||
        '                                           AND X.MEASURE = P.MEASURE AND X.YYYYMMDD = W.BASIS_START_DATE )' || CHR(10) ||
        '                     GROUP BY W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.BASIS_START_DATE, P.MEASURE;' || CHR(10) ||
        '                ELSE' || CHR(10) ||
        '                    INSERT INTO GT_PRDM_T2_PRICE' || CHR(10) ||
        '                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )' || CHR(10) ||
        '                    SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.PLANT_SITE_ID, ''-'', W.ITEM_ID, W.BASIS_START_DATE' || CHR(10) ||
        '                         , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE), P.MEASURE, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS' || CHR(10) ||
        '                         , MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE)' || CHR(10) ||
        '                      FROM ( SELECT DISTINCT T.DIVISION_ID, T.PROJECT_CODE, T.SCM_SITE_ID, T.PLANT_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, C.BASIS_START_DATE' || CHR(10) ||
        '                               FROM GT_PRDM_T2_MKT_FCST T' || CHR(10) ||
        '                               JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = T.YYYYMMDD' || CHR(10) ||
        '                              WHERE T.MEASURE = ''RTF_SYS_RP'' AND T.QTY <> 0 ) W' || CHR(10) ||
        '                      JOIN SCM_MST_FUTURE_PRICE P' || CHR(10) ||
        '                        ON P.DIVISION_ID = W.DIVISION_ID' || CHR(10) ||
        '                       AND P.PROJECT_CODE = W.PROJECT_CODE' || CHR(10) ||
        '                       AND P.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '                       AND P.ITEM_ID = W.ITEM_ID' || CHR(10) ||
        '                       AND P.DOM_EXP = W.DOM_EXP' || CHR(10) ||
        '                       AND P.FCST_TYPE = W.FCST_TYPE' || CHR(10) ||
        '                       AND P.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '                       AND P.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '                       AND P.MEASURE IN ( ''KRW'', ''LOC'', ''USD'' )' || CHR(10) ||
        '                       AND P.PRICE > 0' || CHR(10) ||
        '                       AND P.YYYYMMDD < W.BASIS_START_DATE' || CHR(10) ||
        '                     WHERE NOT EXISTS ( SELECT 1 FROM GT_PRDM_T2_PRICE X' || CHR(10) ||
        '                                         WHERE X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '                                           AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE' || CHR(10) ||
        '                                           AND X.INCOTERMS = W.INCOTERMS AND X.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '                                           AND X.MEASURE = P.MEASURE AND X.YYYYMMDD = W.BASIS_START_DATE )' || CHR(10) ||
        '                     GROUP BY W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.PLANT_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.BASIS_START_DATE, P.MEASURE;' || CHR(10) ||
        '                END IF;' || CHR(10);
    v_new := SUBSTR(v_new, 1, pos - 1) || v_blk || SUBSTR(v_new, pos);
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_RTFLP_SRC_20261102 WHERE OBJ_NAME = :1 AND OBJ_TYPE = :2' INTO n USING c_n, c_t;
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO ZB_RTFLP_SRC_20261102 VALUES (:1, :2, :3, SYSDATE)' USING c_n, c_t, v_src;
        COMMIT;
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED - ' || c_n || ' VALID');
END;
/
DECLARE
    c_n CONSTANT VARCHAR2(128) := 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE';
    c_t CONSTANT VARCHAR2(30)  := 'PROCEDURE';
    v_src CLOB; v_new CLOB; lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER;
    v_tok VARCHAR2(4000); v_blk VARCHAR2(32767); n PLS_INTEGER;
    c_mark CONSTANT VARCHAR2(40) := 'E20261102-RTFLATESTPRICE';
    FUNCTION src(p_n VARCHAR2, p_t VARCHAR2) RETURN CLOB IS
        v CLOB;
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v, TRUE);
        FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = p_n AND TYPE = p_t ORDER BY LINE) LOOP
            DBMS_LOB.WRITEAPPEND(v, LENGTH(r.TEXT), r.TEXT);
        END LOOP;
        RETURN v;
    END;
    PROCEDURE compile_src(p_sql CLOB) IS   -- ORA-24344(컴파일 오류)만 아래 STATUS 로 판정, 그 외 오류는 그대로 올린다
    BEGIN
        EXECUTE IMMEDIATE TO_CLOB('CREATE OR REPLACE ') || p_sql;
    EXCEPTION WHEN OTHERS THEN
        IF SQLCODE <> -24344 THEN RAISE; END IF;
    END;
    FUNCTION st(p_n VARCHAR2, p_t VARCHAR2) RETURN VARCHAR2 IS
        v VARCHAR2(30);
    BEGIN
        SELECT STATUS INTO v FROM USER_OBJECTS WHERE OBJECT_NAME = p_n AND OBJECT_TYPE = p_t;
        RETURN v;
    END;
BEGIN
    v_src := src(c_n, c_t);
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied: ' || c_n);
        RETURN;
    END IF;
    v_new := v_src;
    -- patch 1
    lo := 1; hi := DBMS_LOB.GETLENGTH(v_new) + 1;
    
    v_tok := ''' : A006--''';
    pos := DBMS_LOB.INSTR(v_new, v_tok, lo);
    IF lo = 0 OR hi = 0 OR pos = 0 OR pos >= hi OR (DBMS_LOB.INSTR(v_new, v_tok, pos + 1) BETWEEN 1 AND hi - 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE anchor 1 not exactly 1 - source unchanged. Send this result.');
    END IF;
    pos := DBMS_LOB.INSTR(v_new, CHR(10), pos + LENGTH(v_tok) - 1) + 1;
    v_blk := '' || CHR(10) ||
        '		DELETE FROM GT_PRMF_T2_PRICE WHERE CREATED_BY = ''RTF_LATEST_PRICE'';	/* [E20261102-RTFLATESTPRICE] RTF week without price: use latest earlier price for SalesAmt */' || CHR(10);
    v_new := SUBSTR(v_new, 1, pos - 1) || v_blk || SUBSTR(v_new, pos);
    -- patch 2
    lo := 1; hi := DBMS_LOB.GETLENGTH(v_new) + 1;
    
    v_tok := ''' : A003--''';
    pos := DBMS_LOB.INSTR(v_new, v_tok, lo);
    IF lo = 0 OR hi = 0 OR pos = 0 OR pos >= hi OR (DBMS_LOB.INSTR(v_new, v_tok, pos + 1) BETWEEN 1 AND hi - 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE anchor 2 not exactly 1 - source unchanged. Send this result.');
    END IF;
    pos := DBMS_LOB.INSTR(v_new, CHR(10), pos + LENGTH(v_tok) - 1) + 1;
    v_blk := '' || CHR(10) ||
        '		/* [E20261102-RTFLATESTPRICE] RTF week without price: use latest earlier price for SalesAmt */' || CHR(10) ||
        '		IF (V_DIVISION_ID = ''40'') THEN' || CHR(10) ||
        '		INSERT INTO GT_PRMF_T2_PRICE' || CHR(10) ||
        '		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '		, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )' || CHR(10) ||
        '		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID' || CHR(10) ||
        '			 , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE), P.MEASURE, W.BASIS_START_DATE' || CHR(10) ||
        '			 , MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE)' || CHR(10) ||
        '			 , ''RTF_LATEST_PRICE'', SYSDATE' || CHR(10) ||
        '		  FROM ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, BASIS_START_DATE' || CHR(10) ||
        '				   FROM GT_PRMF_T2_MKT_FCST' || CHR(10) ||
        '				  WHERE MEASURE = ''RTF_SYS_RP'' AND QTY <> 0 ) W' || CHR(10) ||
        '		  JOIN DM_PLN_CFM_SELLING_PRICE P' || CHR(10) ||
        '			ON P.DIVISION_ID = W.DIVISION_ID AND P.PROJECT_CODE = W.PROJECT_CODE AND P.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '		   AND P.ITEM_ID = W.ITEM_ID AND P.DOM_EXP = W.DOM_EXP AND P.FCST_TYPE = W.FCST_TYPE AND P.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '		   AND P.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID' || CHR(10) ||
        '		   AND P.MEASURE IN (''KRW'', ''LOC'', ''USD'')' || CHR(10) ||
        '		   AND P.PRICE > 0' || CHR(10) ||
        '		   AND P.YYYYMMDD < W.BASIS_START_DATE' || CHR(10) ||
        '		 WHERE NOT EXISTS ( SELECT 1 FROM GT_PRMF_T2_PRICE X' || CHR(10) ||
        '							 WHERE X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '							   AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE AND X.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '							   AND X.PLANT_SITE_ID = W.PLANT_SITE_ID AND X.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID' || CHR(10) ||
        '							   AND X.MEASURE = P.MEASURE AND X.YYYYMMDD = W.BASIS_START_DATE )' || CHR(10) ||
        '		 GROUP BY W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.BASIS_START_DATE, P.MEASURE;' || CHR(10) ||
        '		ELSIF (SUBSTR(V_DIVISION_ID, 1, 2) = ''81'') THEN' || CHR(10) ||
        '		INSERT INTO GT_PRMF_T2_PRICE' || CHR(10) ||
        '		( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID' || CHR(10) ||
        '		, CURRENCY, MEASURE, YYYYMMDD, PRICE, CREATED_BY, CREATION_DATE )' || CHR(10) ||
        '		SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID' || CHR(10) ||
        '			 , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE), P.MEASURE, W.BASIS_START_DATE' || CHR(10) ||
        '			 , MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE)' || CHR(10) ||
        '			 , ''RTF_LATEST_PRICE'', SYSDATE' || CHR(10) ||
        '		  FROM ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, CELL_PROD_SITE_ID, BASIS_START_DATE' || CHR(10) ||
        '				   FROM GT_PRMF_T2_MKT_FCST' || CHR(10) ||
        '				  WHERE MEASURE = ''RTF_SYS_RP'' AND QTY <> 0 ) W' || CHR(10) ||
        '		  JOIN SCM_MST_FUTURE_PRICE P' || CHR(10) ||
        '			ON P.DIVISION_ID = W.DIVISION_ID AND P.PROJECT_CODE = W.PROJECT_CODE AND P.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '		   AND P.ITEM_ID = W.ITEM_ID AND P.DOM_EXP = W.DOM_EXP AND P.FCST_TYPE = W.FCST_TYPE AND P.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '		   AND P.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '		   AND P.MEASURE IN (''KRW'', ''LOC'', ''USD'')' || CHR(10) ||
        '		   AND P.PRICE > 0' || CHR(10) ||
        '		   AND P.YYYYMMDD < W.BASIS_START_DATE' || CHR(10) ||
        '		 WHERE NOT EXISTS ( SELECT 1 FROM GT_PRMF_T2_PRICE X' || CHR(10) ||
        '							 WHERE X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '							   AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE AND X.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '							   AND X.PLANT_SITE_ID = W.PLANT_SITE_ID AND X.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID' || CHR(10) ||
        '							   AND X.MEASURE = P.MEASURE AND X.YYYYMMDD = W.BASIS_START_DATE )' || CHR(10) ||
        '		 GROUP BY W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.BASIS_START_DATE, P.MEASURE;' || CHR(10) ||
        '		END IF;' || CHR(10) ||
        '		UPDATE GT_PRMF_SALES_PLAN_TEMP T' || CHR(10) ||
        '		   SET T.CURRENCY = ( SELECT MAX(X.CURRENCY) FROM GT_PRMF_T2_PRICE X' || CHR(10) ||
        '							   WHERE X.CREATED_BY = ''RTF_LATEST_PRICE'' AND X.MEASURE = ''LOC''' || CHR(10) ||
        '								 AND X.DIVISION_ID = T.DIVISION_ID AND X.PROJECT_CODE = T.PROJECT_CODE AND X.SCM_SITE_ID = T.SCM_SITE_ID' || CHR(10) ||
        '								 AND X.ITEM_ID = T.ITEM_ID AND X.DOM_EXP = T.DOM_EXP AND X.FCST_TYPE = T.FCST_TYPE AND X.INCOTERMS = T.INCOTERMS' || CHR(10) ||
        '								 AND X.PLANT_SITE_ID = T.PLANT_SITE_ID AND X.CELL_PROD_SITE_ID = T.CELL_PROD_SITE_ID' || CHR(10) ||
        '								 AND X.YYYYMMDD = ( SELECT C.BASIS_START_DATE FROM SCM_SYS_CALENDAR_M C WHERE C.BASIS_YYYYMMDD = T.YYYYMMDD ) )' || CHR(10) ||
        '		 WHERE T.MEASURE = ''RTF_SYS_RP'' AND T.CURRENCY IS NULL;' || CHR(10);
    v_new := SUBSTR(v_new, 1, pos - 1) || v_blk || SUBSTR(v_new, pos);
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_RTFLP_SRC_20261102 WHERE OBJ_NAME = :1 AND OBJ_TYPE = :2' INTO n USING c_n, c_t;
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'INSERT INTO ZB_RTFLP_SRC_20261102 VALUES (:1, :2, :3, SYSDATE)' USING c_n, c_t, v_src;
        COMMIT;
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED - ' || c_n || ' VALID');
END;
/
