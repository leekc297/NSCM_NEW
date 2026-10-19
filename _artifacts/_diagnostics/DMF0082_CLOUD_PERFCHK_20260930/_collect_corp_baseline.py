# -*- coding: utf-8 -*-
"""사내 ZIOUI1 기준값 채취 → C01 에 인라인 대조 데이터로 삽입 (READ-ONLY)."""
import io, sys, pathlib, json
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb
T = ["DM_PLN_MKT_FCST","DM_PLN_MKT_FCST_C","DM_PLN_MKT_FCST_RESULT","DM_PLN_MKT_FCST_RESULT_C",
     "DM_PLN_SALES_PLAN_RESULT","DM_PLN_SALES_PLAN_RESULT_C","DM_PLN_CFM_MKT_DEMAND_PLAN","DM_PLN_CFM_MKT_DEMAND_PLAN_C",
     "DM_PLN_CFM_SELLING_PRICE","DM_PLN_CFM_SELLING_PRICE_C","SCM_MST_FUTURE_PRICE","SCM_MST_FUTURE_PRICE_C",
     "SCM_MST_SITE_ITEM","DM_PLN_PR_DETAIL","DM_MST_CUSTOMER_FCST","SCM_SYS_CALENDAR_M","SCM_MST_TITLESET_USER",
     "SCM_MST_SHEET_MEASURE","SCM_MST_SHEET_COLUMNS","SCM_ITEM_M_SN","SCM_MST_PROJECT","SCM_MST_SITE","DM_MST_VERSION",
     "DM_MST_BUCKET_CONVERSION","SCP_PLN_INTERFACE_YN","SCM_ADM_USER_GR_MPG_M","SCM_MST_SSO_USER_INFO",
     "SCM_MST_SSO_DEPT_INFO","SCM_ADM_LOOKUP_MASTER_DETAIL","SCM_MST_CITY","SCM_MST_COUNTRY"]
u, p, d = conn_info(); cn = oracledb.connect(user=u, password=p, dsn=d); c = cn.cursor()
inl = ",".join(f"'{t}'" for t in T)
out = {"tables": T}
c.execute(f"""SELECT T.TABLE_NAME, T.NUM_ROWS, TO_CHAR(T.LAST_ANALYZED,'YYYY-MM-DD'),
  (SELECT ROUND(SUM(BYTES)/1048576) FROM USER_SEGMENTS S WHERE S.SEGMENT_NAME=T.TABLE_NAME) MB, T.DEGREE, T.PARTITIONED
  FROM USER_TABLES T WHERE T.TABLE_NAME IN ({inl}) ORDER BY 1""")
out["stats"] = c.fetchall()
c.execute(f"""SELECT I.TABLE_NAME, I.INDEX_NAME, I.STATUS,
  (SELECT LISTAGG(NVL2(E.COLUMN_EXPRESSION,'EXPR',C.COLUMN_NAME),',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION)
     FROM USER_IND_COLUMNS C LEFT JOIN USER_IND_EXPRESSIONS E ON E.INDEX_NAME=C.INDEX_NAME AND E.COLUMN_POSITION=C.COLUMN_POSITION
    WHERE C.INDEX_NAME=I.INDEX_NAME) COLS
  FROM USER_INDEXES I WHERE I.TABLE_NAME IN ({inl}) ORDER BY 1,2""")
out["idx"] = c.fetchall()
c.execute("""SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME IN ('optimizer_dynamic_sampling','optimizer_mode','optimizer_index_cost_adj',
 'optimizer_index_caching','optimizer_features_enable','cursor_sharing','statistics_level','cpu_count','parallel_max_servers',
 'parallel_degree_policy','parallel_force_local','pga_aggregate_target','pga_aggregate_limit','sga_target','memory_target',
 'db_file_multiblock_read_count','optimizer_adaptive_plans','optimizer_adaptive_statistics','_optimizer_use_feedback',
 'optimizer_use_sql_plan_baselines','result_cache_mode','db_cache_size','shared_pool_size','sga_max_size',
 'session_cached_cursors','open_cursors','optimizer_capture_sql_plan_baselines') ORDER BY NAME""")
out["param"] = c.fetchall()
c.execute("SELECT BANNER_FULL FROM V$VERSION"); out["ver"] = c.fetchall()
print(json.dumps(out, ensure_ascii=False, indent=0, default=str))
pathlib.Path("_corp_baseline.json").write_text(json.dumps(out, ensure_ascii=False, default=str), encoding="utf-8")
