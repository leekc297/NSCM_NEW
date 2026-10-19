-- [E20261008-SLASHOBJ] 생성 2026-10-08 17:00 · 대상 97객체

-- 02_CLOUD_PRECHECK — 클라우드 객체 원문이 사내 '적용 전' 원문과 같은지 (PL/SQL: ALL_SOURCE 줄수·총길이·'-' 줄수 비교). SAME 인 객체만 03 로 적용.
--   DIFF 객체 = 클라우드 판본이 사내와 다름 → 전체 원문 덮어쓰기 금지. engine.py plan/apply --dsn <클라우드> 로 그 DB 원문 기준 재적용 또는 수작업.
SET PAGESIZE 0 LINESIZE 300 HEADING OFF FEEDBACK OFF
WITH exp AS (
    SELECT 'PROCEDURE' AS t, 'DMF0020_GET_SCM_MST_FUTURE_PRICE' AS n, 1198 AS exp_lines, 69687 AS exp_len, 39 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AS n, 751 AS exp_lines, 26380 AS exp_len, 26 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'P_SYS0012_APPROVE' AS n, 120 AS exp_lines, 5366 AS exp_len, 4 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'P_SYS0012_REJECT' AS n, 83 AS exp_lines, 3341 AS exp_len, 2 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'P_SYS0014_SAVE_GROUP_USER_M' AS n, 187 AS exp_lines, 9296 AS exp_len, 1 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_COM0000' AS n, 4101 AS exp_lines, 173200 AS exp_len, 87 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0004' AS n, 1606 AS exp_lines, 71602 AS exp_len, 11 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0014' AS n, 11484 AS exp_lines, 748114 AS exp_len, 3 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0020' AS n, 10166 AS exp_lines, 485686 AS exp_len, 119 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0021' AS n, 3935 AS exp_lines, 257080 AS exp_len, 176 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0022' AS n, 3791 AS exp_lines, 227830 AS exp_len, 21 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0035' AS n, 4519 AS exp_lines, 268743 AS exp_len, 46 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0042' AS n, 5969 AS exp_lines, 304945 AS exp_len, 109 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0043' AS n, 3453 AS exp_lines, 126101 AS exp_len, 40 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0044' AS n, 10489 AS exp_lines, 588455 AS exp_len, 446 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0045' AS n, 2380 AS exp_lines, 118011 AS exp_len, 126 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0049' AS n, 1298 AS exp_lines, 71778 AS exp_len, 22 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0051' AS n, 1852 AS exp_lines, 105794 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0072' AS n, 885 AS exp_lines, 38913 AS exp_len, 7 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0074' AS n, 4302 AS exp_lines, 250292 AS exp_len, 13 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_DMF0082' AS n, 17033 AS exp_lines, 885375 AS exp_len, 157 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_NSCM_UI_COM_LOOKUP' AS n, 163 AS exp_lines, 9747 AS exp_len, 21 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V2' AS n, 8113 AS exp_lines, 362087 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V3' AS n, 8256 AS exp_lines, 368255 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V4' AS n, 8256 AS exp_lines, 368395 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V5' AS n, 8375 AS exp_lines, 372583 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V6' AS n, 8375 AS exp_lines, 372718 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_S39V7' AS n, 8393 AS exp_lines, 374032 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCM0002' AS n, 5944 AS exp_lines, 272793 AS exp_len, 61 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0005' AS n, 2155 AS exp_lines, 95234 AS exp_len, 7 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0007' AS n, 1140 AS exp_lines, 70871 AS exp_len, 9 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0009' AS n, 5921 AS exp_lines, 270488 AS exp_len, 109 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0010' AS n, 3026 AS exp_lines, 135953 AS exp_len, 20 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0011' AS n, 2472 AS exp_lines, 127311 AS exp_len, 27 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0013' AS n, 6254 AS exp_lines, 284411 AS exp_len, 59 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0017' AS n, 2369 AS exp_lines, 109632 AS exp_len, 14 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0018' AS n, 455 AS exp_lines, 21827 AS exp_len, 8 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0020' AS n, 1510 AS exp_lines, 89202 AS exp_len, 9 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0025' AS n, 831 AS exp_lines, 45584 AS exp_len, 31 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0027' AS n, 862 AS exp_lines, 42582 AS exp_len, 11 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0030' AS n, 975 AS exp_lines, 44366 AS exp_len, 14 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0031' AS n, 1423 AS exp_lines, 58227 AS exp_len, 24 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0039' AS n, 8424 AS exp_lines, 377098 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0039_VF' AS n, 8157 AS exp_lines, 363703 AS exp_len, 56 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0048' AS n, 621 AS exp_lines, 28863 AS exp_len, 8 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0049' AS n, 21806 AS exp_lines, 1057489 AS exp_len, 98 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0055' AS n, 988 AS exp_lines, 48421 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0098' AS n, 2834 AS exp_lines, 129577 AS exp_len, 31 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0100' AS n, 5092 AS exp_lines, 232479 AS exp_len, 102 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SCP0105' AS n, 4592 AS exp_lines, 232468 AS exp_len, 35 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SDM1010' AS n, 3309 AS exp_lines, 141746 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0012' AS n, 414 AS exp_lines, 22534 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0015' AS n, 11131 AS exp_lines, 591438 AS exp_len, 273 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0019' AS n, 616 AS exp_lines, 35123 AS exp_len, 9 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0021' AS n, 6562 AS exp_lines, 347381 AS exp_len, 115 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0023_CHK' AS n, 3675 AS exp_lines, 188744 AS exp_len, 125 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0045' AS n, 2141 AS exp_lines, 117546 AS exp_len, 70 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0060' AS n, 8282 AS exp_lines, 447180 AS exp_len, 136 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0200' AS n, 3294 AS exp_lines, 156314 AS exp_len, 28 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SSP0201' AS n, 3159 AS exp_lines, 148872 AS exp_len, 27 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SYS0010' AS n, 1607 AS exp_lines, 71297 AS exp_len, 27 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SYS0012' AS n, 294 AS exp_lines, 13356 AS exp_len, 6 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SYS0013' AS n, 1034 AS exp_lines, 38460 AS exp_len, 14 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_SYS0014' AS n, 344 AS exp_lines, 14948 AS exp_len, 3 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_ZTMP_S015J' AS n, 2672 AS exp_lines, 160956 AS exp_len, 123 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_ZTMP_S015K' AS n, 2121 AS exp_lines, 117062 AS exp_len, 37 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PACKAGE BODY' AS t, 'PKG_ZTMP_S200B' AS n, 807 AS exp_lines, 44844 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_ANL_KPI_SALES_ACCURACY' AS n, 288 AS exp_lines, 12959 AS exp_len, 2 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_ANL_KPI_SUMMARY' AS n, 1259 AS exp_lines, 82985 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_ANL_MKT_PSI_DATA' AS n, 920 AS exp_lines, 41028 AS exp_len, 7 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE' AS n, 887 AS exp_lines, 59849 AS exp_len, 7 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_CUST_ITEM_MAPPING' AS n, 624 AS exp_lines, 23427 AS exp_len, 3 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_DNM_CREATE_C_WS_RTF' AS n, 1242 AS exp_lines, 75199 AS exp_len, 49 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_DNM_CREATE_WS_RTF' AS n, 1205 AS exp_lines, 73883 AS exp_len, 50 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_DNM_EDI_CALLOFF_DATA' AS n, 820 AS exp_lines, 36197 AS exp_len, 7 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_DNM_EDI_CALLOFF_MKT_FCST' AS n, 1336 AS exp_lines, 85839 AS exp_len, 16 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_CUST_FCST_RECORD' AS n, 948 AS exp_lines, 48549 AS exp_len, 10 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AS n, 3201 AS exp_lines, 216268 AS exp_len, 40 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING' AS n, 984 AS exp_lines, 77728 AS exp_len, 43 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_MKT_FCST_TO_NET_DEMAND' AS n, 819 AS exp_lines, 52757 AS exp_len, 19 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE' AS n, 1980 AS exp_lines, 78163 AS exp_len, 12 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_DM_PLN_SALES_PLAN_RESULT_MOVE' AS n, 171 AS exp_lines, 5711 AS exp_len, 2 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC' AS n, 368 AS exp_lines, 13826 AS exp_len, 4 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCM_MST_PROJECT_SCHEDULE' AS n, 443 AS exp_lines, 19310 AS exp_len, 1 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL' AS n, 5568 AS exp_lines, 226696 AS exp_len, 46 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE' AS n, 5378 AS exp_lines, 221667 AS exp_len, 40 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS' AS n, 5641 AS exp_lines, 227113 AS exp_len, 46 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL' AS n, 7123 AS exp_lines, 272882 AS exp_len, 54 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SSP_ANL_SHIP_UPDATE_BOH_VAL' AS n, 287 AS exp_lines, 14167 AS exp_len, 15 AS exp_dash FROM dual
 UNION ALL
    SELECT 'PROCEDURE' AS t, 'PR_SSP_ANL_SHIPMENT_PLAN_FG' AS n, 1534 AS exp_lines, 70998 AS exp_len, 33 AS exp_dash FROM dual
)
, act AS (
    SELECT type AS t, name AS n, COUNT(*) AS act_lines, SUM(LENGTH(RTRIM(text, CHR(10)||CHR(13)))) AS act_len, SUM(CASE WHEN text LIKE '%''-''%' THEN 1 ELSE 0 END) AS act_dash
      FROM all_source WHERE owner = 'SCM_MGR' GROUP BY type, name
)
SELECT 'PRECHECK | ' || RPAD(e.t, 13) || ' | ' || RPAD(e.n, 55) || ' | ' || CASE WHEN a.n IS NULL THEN 'MISSING' WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 'SAME' ELSE 'DIFF' END
    || ' | lines ' || e.exp_lines || '/' || NVL(TO_CHAR(a.act_lines), '-') || ' | len ' || e.exp_len || '/' || NVL(TO_CHAR(a.act_len), '-') || ' | dash ' || e.exp_dash || '/' || NVL(TO_CHAR(a.act_dash), '-') AS line
  FROM exp e LEFT JOIN act a ON a.t = e.t AND a.n = e.n
 ORDER BY CASE WHEN a.n IS NULL THEN 2 WHEN a.act_lines = e.exp_lines AND a.act_len = e.exp_len AND a.act_dash = e.exp_dash THEN 0 ELSE 1 END, e.t, e.n;

-- VIEW 7건: DBMS_METADATA DDL 기준이라 줄수 비교만 (참고). 적용 전 사내 DDL 줄수 = SCM_DNM_PRODUCT_RESULT_V=259, SCP_XLS_PSI_GLOBAL_ELECTRODE_LOAD_RATIO_V=73, SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_CELL_V=282, SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_BP_V=2249, SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V=1758, SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V2=1883, SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V=514
SELECT 'PRECHECK-VIEW | ' || view_name || ' | text_length=' || text_length || ' | status=' || (SELECT status FROM all_objects o WHERE o.owner = v.owner AND o.object_name = v.view_name AND o.object_type = 'VIEW') AS line FROM all_views v WHERE owner = 'SCM_MGR' AND view_name IN ('SCM_DNM_PRODUCT_RESULT_V','SCP_XLS_PSI_GLOBAL_ELECTRODE_LOAD_RATIO_V','SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_CELL_V','SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_BP_V','SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V','SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V2','SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V') ORDER BY 1;