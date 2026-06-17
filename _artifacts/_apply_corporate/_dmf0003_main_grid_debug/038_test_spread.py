"""Test DMF0020_GET_SPREAD_TITLE_DATE — 6월말~7월초 W27 분리 확인"""
import os
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    rc1 = cur.var(oracledb.CURSOR)
    rc2 = cur.var(oracledb.CURSOR)
    cur.callproc("SCM_MGR.DMF0020_GET_SPREAD_TITLE_DATE", ['20260620', '20260720', 'minyonglee1', rc1, rc2])
    cs = rc1.getvalue()
    rows = cs.fetchall()
    cols = [d[0] for d in cs.description]
    print(f"[OK] {len(rows)} rows, cols={cols}")
    for r in rows:
        d = dict(zip(cols, r))
        if d.get('WEEK_NAME') in ('W27', 'W26', 'W28'):
            print(f"  BASIS_START_DATE={d['BASIS_START_DATE']} BASIS_YYYYMM={d['BASIS_YYYYMM']} WEEK_NAME={d['WEEK_NAME']} mmdd={d['DATE_SHORT1_NAME']}")
