SET SERVEROUTPUT ON SIZE UNLIMITED LINESIZE 32767 PAGESIZE 0 FEEDBACK ON DEFINE OFF
DECLARE
  v_sql_text  CLOB;
  v_col       VARCHAR2(4000);
  v_col_sum   VARCHAR2(4000) := '';
  v_col_total VARCHAR2(4000) := '';
  v_bottom    VARCHAR2(4000);
  v_bottom_sum VARCHAR2(4000) := '';
  v_groupby   VARCHAR2(4000);
  v_orderby   VARCHAR2(4000);
  v_program_id VARCHAR2(10) := 'DMF0043';
  v_sheet_name VARCHAR2(100) := 'ContributeSalesList';
  p_division_id VARCHAR2(10) := '40';
  p_ver_seq VARCHAR2(10) := '12';
  p_created_by VARCHAR2(50) := 'minyonglee1';
  p_end_cust_report VARCHAR2(20) := 'ALL';
  p_product_group   VARCHAR2(20) := 'ALL';
  p_biz_type        VARCHAR2(20) := 'ALL';
  v_col_name VARCHAR2(50);
  v_sort_order_no VARCHAR2(50);
  v_code VARCHAR2(50);
  v_large_code VARCHAR2(50);
  v_small_code VARCHAR2(50);
  v_seq NUMBER;
  v_rc SYS_REFCURSOR;
  CURSOR c_title IS
    SELECT U.PROGRAM_ID, U.SHEET_NAME, U.COLUMN_NAME, U.SORT_ORDER_NO
    FROM SCM_MGR.SCM_MST_TITLESET_USER U, SCM_MGR.SCM_MST_SHEET_COLUMNS C
    WHERE 1=1 AND U.PROGRAM_ID = C.PROGRAM_ID AND U.SHEET_NAME = C.SHEET_NAME AND U.COLUMN_NAME = C.COLUMN_NAME
    AND U.PROGRAM_ID = v_program_id AND U.SHEET_NAME = v_sheet_name AND U.USER_ID = p_created_by
    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    UNION ALL
    SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.SORT_ORDER_NO
    FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
    WHERE C.PROGRAM_ID = v_program_id AND C.SHEET_NAME = v_sheet_name AND C.DEFAULT_FLAG = '' AND C.VALID_YN = 'Y'
    ORDER BY SORT_ORDER_NO;
  CURSOR c_code IS
    SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ FROM (
      SELECT L.SEGMENT1 || '#' || CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE,
             L.SEGMENT1 AS LARGE_CODE, CASE WHEN L.SEGMENT4='Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END AS SMALL_CODE,
             RANK() OVER (ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4='Y' THEN 0 ELSE M.DISPLAY_SEQ END) AS SEQ
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L, SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
       WHERE L.LOOKUP_TYPE='DM_OS_CORP_CD' AND M.LOOKUP_TYPE='DM_CONTRIBUTION_TYPE_CD'
         AND L.VALID_YN='Y' AND L.SEGMENT3='Y' AND M.VALID_YN='Y') A
    ORDER BY A.SEQ;
BEGIN
  v_col := '';
  OPEN c_title;
  LOOP
    FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
    EXIT WHEN c_title%NOTFOUND;
    IF v_col = '' OR v_col IS NULL THEN
      v_col := 'A.' || v_col_name;
      v_groupby := ' GROUP BY A.' || v_col_name;
      v_orderby := ' ORDER BY A.' || v_col_name;
      v_bottom := '''Total''';
    ELSE
      v_col := v_col || ', A.' || v_col_name;
      v_groupby := v_groupby || ', A.' || v_col_name;
      v_orderby := v_orderby || ', A.' || v_col_name;
      v_bottom := v_bottom || ', null';
    END IF;
  END LOOP;
  CLOSE c_title;
  v_sql_text := 'WITH SALES_LIST AS (SELECT A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.DEPARTMENT_ID, A.DEPT_ID, A.CUST_REPORT, A.END_CUST_REPORT, A.SOLDTO_CUST_REPORT, A.SHIPTO_CODE, A.PRODUCT_GROUP, A.DM_BIZ_TYPE, A.EDIT_FLAG ';
  OPEN c_code;
  LOOP
    FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq;
    EXIT WHEN c_code%NOTFOUND;
    v_sql_text := v_sql_text || ', SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = ''' || v_small_code || ''' AND B.OS_CORP_CD = ''' || v_large_code || ''' THEN B.CONTRIBUTION_RATIO/100*A.AMT ELSE 0 END) AS ' || v_code || ' ';
    IF v_code NOT LIKE '%Total%' THEN
      v_col_sum := v_col_sum || ', SUM('||v_code||') AS ' || v_code;
      v_bottom_sum := v_bottom_sum || ', SUM('||v_code||') AS ' || v_code;
    END IF;
    IF v_code NOT LIKE '%Total%' THEN
      v_col_total := v_col_total || CASE WHEN v_col_total = '' THEN '' ELSE ' +' END || 'NVL(SUM(' || v_code || '), 0)';
    ELSE
      v_col_total := v_col_total || ' AS ' || v_code;
    END IF;
  END LOOP;
  CLOSE c_code;
  v_sql_text := v_sql_text || ' FROM SCM_MGR.GT_DMF0043_SALES_LIST_C A INNER JOIN SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL B ON A.DEPARTMENT_ID = B.DEPARTMENT_ID AND A.DEPT_ID = B.DEPT_ID AND A.END_CUST_REPORT = B.END_CUST_REPORT AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT AND A.PRODUCT_GROUP = B.PRODUCT_GROUP AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE AND A.YYYYMM = B.YYYYMM WHERE B.VER_SEQ = ' || p_ver_seq || ' [@v_end_cust_report] [@v_product_group] [@v_biz_type] ';
  v_sql_text := v_sql_text || ' GROUP BY A.YYYYMM, A.DEPARTMENT_NAME, A.DEPT_NAME, A.DEPARTMENT_ID, A.DEPT_ID, A.CUST_REPORT, A.END_CUST_REPORT, A.SOLDTO_CUST_REPORT, A.SHIPTO_CODE, A.PRODUCT_GROUP, A.DM_BIZ_TYPE, A.EDIT_FLAG) SELECT [@v_col]  [@v_col_Sum],' || v_col_total || ' FROM SALES_LIST A [@v_groupby] UNION ALL SELECT [@v_bottom] [@v_bottom_Sum],' || v_col_total || ' FROM SALES_LIST A [@v_orderby] ';
  v_sql_text := REPLACE(v_sql_text, '[@v_end_cust_report]', ' AND A.END_CUST_REPORT LIKE ''%' || p_end_cust_report || '%'' ');
  v_sql_text := REPLACE(v_sql_text, '[@v_product_group]', SCM_MGR.FN_SCM_GET_WHERE_SQL('A.PRODUCT_GROUP', 'IN', p_product_group));
  v_sql_text := REPLACE(v_sql_text, '[@v_biz_type]', SCM_MGR.FN_SCM_GET_WHERE_SQL('A.DM_BIZ_TYPE', 'IN', p_biz_type));
  v_sql_text := REPLACE(v_sql_text, '[@v_col]', v_col);
  v_sql_text := REPLACE(v_sql_text, '[@v_bottom]', v_bottom);
  v_sql_text := REPLACE(v_sql_text, '[@v_col_Sum]', v_col_sum);
  v_sql_text := REPLACE(v_sql_text, '[@v_bottom_Sum]', v_bottom_sum);
  v_sql_text := REPLACE(v_sql_text, '[@v_groupby]', v_groupby);
  v_sql_text := REPLACE(v_sql_text, '[@v_orderby]', v_orderby);
  -- Save v_sql_text first
  INSERT INTO SCM_MGR.DBG_VSQL_DUMP(ID, TS, BODY) VALUES (2, SYSTIMESTAMP, v_sql_text);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('v_sql_text saved, length=' || DBMS_LOB.GETLENGTH(v_sql_text));
  -- Try to OPEN
  BEGIN
    OPEN v_rc FOR v_sql_text;
    DBMS_OUTPUT.PUT_LINE('OPEN_OK');
    CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('OPEN_FAIL: ' || SQLCODE || ' / ' || SQLERRM);
  END;
END;
/
EXIT
