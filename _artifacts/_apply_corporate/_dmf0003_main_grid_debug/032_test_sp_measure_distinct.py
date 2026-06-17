"""DMF0003 SP 직접 호출 → o_rc1 결과의 distinct MEASURE 값 확인 (minyonglee1 권한 12 measure 가 모두 반환되는지)"""
import os
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()

    o_rc1 = cur.var(oracledb.CURSOR)
    o_rc2 = cur.var(oracledb.CURSOR)
    o_rc3 = cur.var(oracledb.CURSOR)
    o_result = cur.var(oracledb.CURSOR)

    cur.callproc("SCM_MGR.DMF0003_GET_MKT_FCST_DATA", [
        '40',               # 1  P_DIVISION_ID
        'ALL',              # 2  P_SCM_SITE_ID
        'ALL',              # 3  P_PLANT_SITE_ID
        'ALL',              # 4  P_TEAM_ID
        'ALL',              # 5  P_CUSTOMER
        'ALL',              # 6  P_BIZ_TYPE
        '%',                # 7  P_PROJECT_CODE
        '%',                # 8  P_ITEM_ID
        '20260616',         # 9  P_FROM_YYYYMMDD
        '20260914',         # 10 P_TO_YYYYMMDD
        'minyonglee1',      # 11 P_CREATED_BY
        'GR_PLANT',         # 12 P_USER_GROUP
        'ALL',              # 13 P_ITEM_TYPE
        '',                 # 14 P_OWNER
        'N',                # 15 P_QTY_YN
        'N',                # 16 P_CELL_YN
        'N',                # 17 P_INVALID_EXEC
        'N',                # 18 P_AS_YN
        '20',               # 19 P_USER_DEPT_ID
        'ALL',              # 20 P_SENDER_CODE
        'minyonglee1',      # 21 P_USER_ID
        'DMF0003',          # 22 P_MENU_ID
        o_rc1, o_rc2, o_rc3, o_result,
    ])

    cs = o_rc1.getvalue()
    if cs is None:
        print("[ERR] o_rc1 NULL")
    else:
        rows = cs.fetchall()
        cols = [d[0] for d in cs.description]
        midx = cols.index('MEASURE') if 'MEASURE' in cols else None
        print(f"[OK] o_rc1 rows={len(rows)}, columns={len(cols)}")
        if midx is not None:
            measures = {r[midx] for r in rows}
            print(f"[INFO] distinct MEASURE count={len(measures)}")
            for m in sorted(str(x) for x in measures):
                print(f"   - {m}")
        else:
            print(f"[WARN] MEASURE column not found. columns: {cols[:20]}...")
