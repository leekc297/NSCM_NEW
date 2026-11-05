import sys; sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); import dbconn
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
for sid in ['4cjr1z5k3zv0m','gmxq8vpuv7ahx','7bkjc2n8cwq8z']:
    c.execute("SELECT DISTINCT CHILD_NUMBER FROM V$SQL_PLAN WHERE SQL_ID=:s ORDER BY 1", s=sid)
    for (ch,) in c.fetchall():
        c.execute("""SELECT ID, PARENT_ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,'')||' '||NVL(OBJECT_NAME,''), CARDINALITY
                     FROM V$SQL_PLAN WHERE SQL_ID=:s AND CHILD_NUMBER=:n ORDER BY ID""", s=sid, n=ch)
        pl = c.fetchall()
        # find the A4 branch: the subtree that contains PK_DM_PLN_CFM_MKT_DEMAND_PLAN or 2nd full scan
        print('==', sid, 'child', ch, 'rows', len(pl))
        for p in pl:
            if any(k in p[2] for k in ('PK_DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_CFM_MKT_DEMAND_PLAN ','UNION-ALL','CARTESIAN','STATISTICS COLLECTOR')):
                print(f"   {p[0]:4d} p{p[1] if p[1] is not None else -1:4d} {p[2][:90]:90s} card={p[3]}")
