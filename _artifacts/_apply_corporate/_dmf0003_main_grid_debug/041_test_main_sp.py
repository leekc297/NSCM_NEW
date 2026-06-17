"""Test DMF0020_GET_SCM_MST_FUTURE_PRICE 직접 호출 — error 확인"""
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
            '81',          # P_DIVISION_ID
            'ALL',         # P_DEPT_ID
            'ALL',         # P_END_CUSTOMER
            'ALL',         # P_SCM_SITE_ID
            'ALL',         # P_PLANT_SITE_ID
            'ALL',         # P_PROJECT_CODE
            'ALL',         # P_ITEM_ID
            'ALL',         # P_CUSTOMER_PROJECT_CODE
            'ALL',         # P_CUSTOMER_MODEL
            '20260622',    # P_FROM_YYYYMMDD
            '20260712',    # P_TO_YYYYMMDD
            'ALL',         # P_BIZTYPE
            'minyonglee1', # P_CREATED_BY
            'ALL',         # P_USERINFO
            'ALL',         # P_OWNER
            'N',           # P_OVER_RANGE
            'N',           # P_INVALID_EXEC
            'ALL',         # P_VERSION_TYPE
            rc1, rc2,
        ])
        cs = rc1.getvalue()
        rows = cs.fetchall() if cs else []
        cols = [d[0] for d in cs.description] if cs else []
        print(f"[OK] rows={len(rows)}, cols(total)={len(cols)}")
        w_cols = [c for c in cols if c.startswith('W_')]
        print(f"[W_ cols] {len(w_cols)}: {w_cols[:10]}")
    except Exception as e:
        print(f"[FAIL] {e}")
