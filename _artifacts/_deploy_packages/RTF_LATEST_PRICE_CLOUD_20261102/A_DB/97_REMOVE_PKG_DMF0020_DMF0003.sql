-- 97_REMOVE [E20261102-RTFLATESTPRICE] (SCM_MGR, whole-file F5, no input, idempotent) removes the block from PKG_DMF0020 and PKG_DMF0003: both are now out of scope.
-- No marker = SKIP. Marker present but block text differs = stop with source unchanged. Needs no backup table.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_n CONSTANT VARCHAR2(128) := 'PKG_DMF0020';
    c_t CONSTANT VARCHAR2(30)  := 'PACKAGE BODY';
    v_src CLOB; v_new CLOB; v_blk VARCHAR2(32767);
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
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - no block: ' || c_n);
        RETURN;
    END IF;
    v_blk := '        /* [E20261102-RTFLATESTPRICE] RTF week without price: use latest earlier price for SalesAmt */' || CHR(10) ||
        '        MERGE INTO GT_PRDM_SALES_PLAN_TEMP_SINGLE T' || CHR(10) ||
        '        USING ( SELECT S.ROWID AS RID' || CHR(10) ||
        '                     , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE) AS CURRENCY' || CHR(10) ||
        '                     , MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE) AS PRICE' || CHR(10) ||
        '                     , MAX(R.QTY) AS RTF_QTY' || CHR(10) ||
        '                  FROM GT_PRDM_SALES_PLAN_TEMP_SINGLE S' || CHR(10) ||
        '                  JOIN SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = S.YYYYMMDD' || CHR(10) ||
        '                  JOIN SCM_MST_FUTURE_PRICE P' || CHR(10) ||
        '                    ON P.DIVISION_ID = S.DIVISION_ID AND P.PROJECT_CODE = S.PROJECT_CODE AND P.SCM_SITE_ID = S.SCM_SITE_ID' || CHR(10) ||
        '                   AND P.ITEM_ID = S.ITEM_ID AND P.DOM_EXP = S.DOM_EXP AND P.FCST_TYPE = S.FCST_TYPE AND P.INCOTERMS = S.INCOTERMS' || CHR(10) ||
        '                   AND P.PLANT_SITE_ID = S.PLANT_SITE_ID' || CHR(10) ||
        '                   AND P.MEASURE = CASE S.MEASURE WHEN ''SalesAmt_KRW'' THEN ''KRW'' WHEN ''SalesAmt_USD'' THEN ''USD'' ELSE ''LOC'' END' || CHR(10) ||
        '                   AND P.PRICE > 0' || CHR(10) ||
        '                   AND P.YYYYMMDD < C.BASIS_START_DATE' || CHR(10) ||
        '                  LEFT JOIN GT_PRDM_SALES_PLAN_TEMP_SINGLE R' || CHR(10) ||
        '                    ON R.DIVISION_ID = S.DIVISION_ID AND R.PROJECT_CODE = S.PROJECT_CODE AND R.SCM_SITE_ID = S.SCM_SITE_ID' || CHR(10) ||
        '                   AND R.ITEM_ID = S.ITEM_ID AND R.DOM_EXP = S.DOM_EXP AND R.FCST_TYPE = S.FCST_TYPE AND R.INCOTERMS = S.INCOTERMS' || CHR(10) ||
        '                   AND R.PLANT_SITE_ID = S.PLANT_SITE_ID AND R.CELL_PROD_SITE_ID = S.CELL_PROD_SITE_ID' || CHR(10) ||
        '                   AND R.YYYYMMDD = S.YYYYMMDD AND R.MEASURE = ''RTF_SYS_RP''' || CHR(10) ||
        '                 WHERE S.MEASURE IN ( ''RTF'', ''RTF_SYS_RP'', ''SalesAmt_KRW'', ''SalesAmt_LOC'', ''SalesAmt_USD'' )' || CHR(10) ||
        '                   AND S.CURRENCY IS NULL' || CHR(10) ||
        '                 GROUP BY S.ROWID ) F' || CHR(10) ||
        '           ON ( T.ROWID = F.RID )' || CHR(10) ||
        '         WHEN MATCHED THEN' || CHR(10) ||
        '              UPDATE SET T.CURRENCY = F.CURRENCY' || CHR(10) ||
        '                       , T.QTY      = CASE WHEN T.MEASURE LIKE ''SalesAmt%'' THEN ROUND(NVL(F.RTF_QTY, 0) * F.PRICE, 5) ELSE T.QTY END;' || CHR(10) ||
        '' || CHR(10);
    v_new := REPLACE(v_src, v_blk, '');
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 OR DBMS_LOB.GETLENGTH(v_src) - DBMS_LOB.GETLENGTH(v_new) <> LENGTH(v_blk) THEN
        RAISE_APPLICATION_ERROR(-20003, c_n || ' block text differs - source unchanged. Send this result.');
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('REMOVED - ' || c_n || ' VALID');
END;
/
DECLARE
    c_n CONSTANT VARCHAR2(128) := 'PKG_DMF0003';
    c_t CONSTANT VARCHAR2(30)  := 'PACKAGE BODY';
    v_src CLOB; v_new CLOB; v_blk VARCHAR2(32767);
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
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - no block: ' || c_n);
        RETURN;
    END IF;
    v_blk := '' || CHR(10) ||
        '            /* [E20261102-RTFLATESTPRICE] RTF week without price: use latest earlier price for SalesAmt */' || CHR(10) ||
        '            INSERT INTO SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC' || CHR(10) ||
        '            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE)' || CHR(10) ||
        '            SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS' || CHR(10) ||
        '                 , CASE P.MEASURE WHEN ''KRW'' THEN ''SalesAmt_KRW'' WHEN ''LOC'' THEN ''SalesAmt_LOC'' ELSE ''SalesAmt_USD'' END' || CHR(10) ||
        '                 , W.PLANT_SITE_ID, W.YYYYMMDD' || CHR(10) ||
        '                 , MAX(P.CURRENCY) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE)' || CHR(10) ||
        '                 , CAST(ROUND(W.QTY * MAX(P.PRICE) KEEP (DENSE_RANK LAST ORDER BY P.YYYYMMDD, P.PRICE), 5) AS NUMBER(30, 10))' || CHR(10) ||
        '                 , NULL, NULL' || CHR(10) ||
        '            FROM   ( SELECT T.*, C.BASIS_START_DATE' || CHR(10) ||
        '                     FROM   SCM_MGR.GT_FSPS_T_MKT_FCST T' || CHR(10) ||
        '                     JOIN   SCM_MGR.SCM_SYS_CALENDAR_M C ON C.BASIS_YYYYMMDD = T.YYYYMMDD' || CHR(10) ||
        '                     WHERE  T.MEASURE = ''RTF_SYS_RP'' AND T.QTY <> 0 ) W' || CHR(10) ||
        '            JOIN   SCM_MGR.SCM_MST_FUTURE_PRICE P' || CHR(10) ||
        '                ON P.DIVISION_ID = W.DIVISION_ID AND P.PROJECT_CODE = W.PROJECT_CODE AND P.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '               AND P.ITEM_ID = W.ITEM_ID AND P.DOM_EXP = W.DOM_EXP AND P.FCST_TYPE = W.FCST_TYPE AND P.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '               AND P.PLANT_SITE_ID = W.PLANT_SITE_ID' || CHR(10) ||
        '               AND P.MEASURE IN (''KRW'', ''LOC'', ''USD'')' || CHR(10) ||
        '               AND P.PRICE > 0' || CHR(10) ||
        '               AND P.YYYYMMDD < W.BASIS_START_DATE' || CHR(10) ||
        '            WHERE  NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FSPS_T_PRICE X' || CHR(10) ||
        '                                WHERE X.DIVISION_ID = W.DIVISION_ID AND X.PROJECT_CODE = W.PROJECT_CODE AND X.SCM_SITE_ID = W.SCM_SITE_ID' || CHR(10) ||
        '                                  AND X.ITEM_ID = W.ITEM_ID AND X.DOM_EXP = W.DOM_EXP AND X.FCST_TYPE = W.FCST_TYPE AND X.INCOTERMS = W.INCOTERMS' || CHR(10) ||
        '                                  AND X.PLANT_SITE_ID = W.PLANT_SITE_ID AND X.MEASURE = P.MEASURE AND X.YYYYMMDD = W.BASIS_START_DATE )' || CHR(10) ||
        '            AND    NOT EXISTS ( SELECT 1' || CHR(10) ||
        '                                FROM   SCM_MGR.SCM_MST_SITE_ITEM A' || CHR(10) ||
        '                                     , SCM_MGR.DM_PLN_SALES_PLAN  B' || CHR(10) ||
        '                                WHERE  SALES_PLAN_ADJUST_YN  = ''N''' || CHR(10) ||
        '                                AND    A.ITEM_ID             = B.ITEM_ID' || CHR(10) ||
        '                                AND    A.DIVISION_ID         = B.DIVISION_ID' || CHR(10) ||
        '                                AND    A.PROJECT_CODE        = B.PROJECT_CODE' || CHR(10) ||
        '                                AND    A.SCM_SITE_ID         = B.SCM_SITE_ID' || CHR(10) ||
        '                                AND    B.LAST_UPDATED_BY NOT IN (''SYSTEM'', ''CUTOFF'')' || CHR(10) ||
        '                                AND    B.YYYYMMDD           >= V_NEXT_MON_MINUS7' || CHR(10) ||
        '                                AND    A.DIVISION_ID         = W.DIVISION_ID' || CHR(10) ||
        '                                AND    A.PROJECT_CODE        = W.PROJECT_CODE' || CHR(10) ||
        '                                AND    A.SCM_SITE_ID         = W.SCM_SITE_ID' || CHR(10) ||
        '                                AND    A.ITEM_ID             = W.ITEM_ID )' || CHR(10) ||
        '            GROUP BY W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS, W.PLANT_SITE_ID, W.YYYYMMDD, W.QTY, P.MEASURE;' || CHR(10) ||
        '            UPDATE SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC T' || CHR(10) ||
        '            SET    T.CURRENCY = ( SELECT MAX(X.CURRENCY) FROM SCM_MGR.GT_FSPS_SALES_PLAN_TEMP_LOC X' || CHR(10) ||
        '                                  WHERE  X.MEASURE = ''SalesAmt_LOC'' AND X.DIVISION_ID = T.DIVISION_ID AND X.PROJECT_CODE = T.PROJECT_CODE' || CHR(10) ||
        '                                  AND    X.SCM_SITE_ID = T.SCM_SITE_ID AND X.ITEM_ID = T.ITEM_ID AND X.DOM_EXP = T.DOM_EXP AND X.FCST_TYPE = T.FCST_TYPE' || CHR(10) ||
        '                                  AND    X.INCOTERMS = T.INCOTERMS AND X.PLANT_SITE_ID = T.PLANT_SITE_ID AND X.YYYYMMDD = T.YYYYMMDD )' || CHR(10) ||
        '            WHERE  T.MEASURE = ''RTF_SYS_RP'' AND T.CURRENCY IS NULL;' || CHR(10);
    v_new := REPLACE(v_src, v_blk, '');
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 OR DBMS_LOB.GETLENGTH(v_src) - DBMS_LOB.GETLENGTH(v_new) <> LENGTH(v_blk) THEN
        RAISE_APPLICATION_ERROR(-20003, c_n || ' block text differs - source unchanged. Send this result.');
    END IF;
    compile_src(v_new);
    IF st(c_n, c_t) <> 'VALID' THEN
        compile_src(v_src);
        RAISE_APPLICATION_ERROR(-20002, c_n || ' compile failed - source restored (status now ' || st(c_n, c_t) || ')');
    END IF;
    DBMS_OUTPUT.PUT_LINE('REMOVED - ' || c_n || ' VALID');
END;
/
