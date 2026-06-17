"""Compile v4 patched SP (Phase 1+2+3+4)"""
import os, pathlib
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    ddl = pathlib.Path(__file__).parent.joinpath("028_sp_body_patched_v4.sql").read_text(encoding="utf-8")
    if ddl.rstrip().endswith("/"):
        ddl = ddl.rstrip().rstrip("/").rstrip()
    try:
        cur.execute(ddl)
        print("[OK] CREATE OR REPLACE PROCEDURE v4")
    except Exception as e:
        print(f"[FAIL] {e}")
        raise
    cur.execute("SELECT status FROM all_objects WHERE owner='SCM_MGR' AND object_name='DMF0003_GET_MKT_FCST_DATA' AND object_type='PROCEDURE'")
    print(f"[STATUS] {cur.fetchone()[0]}")
    cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name='DMF0003_GET_MKT_FCST_DATA' ORDER BY sequence")
    errs = cur.fetchall()
    print(f"[ERRORS] {len(errs)}")
    for line, pos, t in errs[:10]:
        print(f"   {line}:{pos} {t}")
