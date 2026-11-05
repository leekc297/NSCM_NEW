import sys; sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); import dbconn, datetime
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
print(datetime.datetime.now())
c.execute("""SELECT S.SQL_ID, S.CHILD_NUMBER, S.PLAN_HASH_VALUE, S.EXECUTIONS, ROUND(S.ELAPSED_TIME/1e6,1) EL, S.BUFFER_GETS,
                    S.IS_RESOLVED_ADAPTIVE_PLAN, S.OPTIMIZER_ENV_HASH_VALUE, S.FIRST_LOAD_TIME, S.LAST_ACTIVE_TIME, O.OBJECT_NAME, S.IS_BIND_SENSITIVE, S.IS_BIND_AWARE, S.IS_SHAREABLE
             FROM V$SQL S LEFT JOIN DBA_OBJECTS O ON O.OBJECT_ID = S.PROGRAM_ID
             WHERE S.PARSING_SCHEMA_NAME='SCM_MGR' AND S.SQL_TEXT LIKE 'INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE%'
               AND S.SQL_FULLTEXT LIKE '%MKT_FCST_PP%' AND S.SQL_FULLTEXT LIKE '%DM_PLN_CFM_MKT_DEMAND_PLAN%'
             ORDER BY O.OBJECT_NAME, S.SQL_ID, S.CHILD_NUMBER""")
rows = c.fetchall()
for r in rows: print(r)
seen = set()
for r in rows:
    key = (r[0], r[1])
    if key in seen: continue
    seen.add(key)
    c.execute("""SELECT ID, PARENT_ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,'')||' '||NVL(OBJECT_NAME,''), CARDINALITY
                 FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=:n ORDER BY ID""", s=r[0], n=r[1])
    pl = c.fetchall()
    print('== plan', r[0], 'child', r[1], 'phv', r[2], 'pkg', r[10], 'resolved', r[6], 'rows', len(pl))
    for p in pl:
        if any(k in p[2] for k in ('PK_DM_PLN_CFM_MKT_DEMAND_PLAN','CARTESIAN','NESTED LOOPS','HASH JOIN','DM_PLN_CFM_MKT_DEMAND_PLAN','STATISTICS COLLECTOR')):
            print(f"   {p[0]:4d} p{p[1] if p[1] is not None else -1:4d} {p[2][:90]:90s} card={p[3]}")
