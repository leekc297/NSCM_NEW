"""Test div 81, 6/22~7/12 — W27 split 검증"""
import os
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    rc1 = cur.var(oracledb.CURSOR)
    rc2 = cur.var(oracledb.CURSOR)
    try:
        cur.callproc("SCM_MGR.DMF0020_GET_SCM_MST_FUTURE_PRICE", [
            '81','ALL','ALL','ALL','ALL','ALL','ALL','ALL','ALL',
            '20260622','20260712','ALL','minyonglee1','ALL','ALL','N','N','ALL',
            rc1, rc2,
        ])
        cs = rc1.getvalue()
        cols = [d[0] for d in cs.description] if cs else []
        w_cols = sorted([c for c in cols if c.startswith('W_')])
        rows = cs.fetchall()
        print(f"[OK] div=81, 6/22~7/12: rows={len(rows)}, W_cols={len(w_cols)}")
        for c in w_cols: print(f"  {c}")
    except Exception as e:
        print(f"[FAIL] {e}")
