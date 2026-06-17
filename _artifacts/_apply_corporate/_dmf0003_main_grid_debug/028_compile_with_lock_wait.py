"""DDL_LOCK_TIMEOUT 설정 + CREATE OR REPLACE 시도 (stale session 자연 해제 대기)"""
import os, pathlib
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    # 30분 lock wait
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")
    print("[OK] DDL_LOCK_TIMEOUT = 1800 sec (30 min)")

    ddl = pathlib.Path(__file__).parent.joinpath("028_sp_body_patched_v3.sql").read_text(encoding="utf-8")
    # '/' 단독 라인 제거 (CREATE OR REPLACE PROCEDURE 만 단일 statement)
    if ddl.rstrip().endswith("/"):
        ddl = ddl.rstrip().rstrip("/").rstrip()

    print(f"[INFO] DDL length: {len(ddl):,} chars")
    try:
        cur.execute(ddl)
        print("[OK] CREATE OR REPLACE PROCEDURE")
    except Exception as e:
        print(f"[FAIL] {e}")
        raise

    # STATUS 확인
    cur.execute("SELECT status FROM all_objects WHERE owner='SCM_MGR' AND object_name='DMF0003_GET_MKT_FCST_DATA' AND object_type='PROCEDURE'")
    row = cur.fetchone()
    print(f"[STATUS] {row[0] if row else 'NOT FOUND'}")

    # USER_ERRORS
    cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name='DMF0003_GET_MKT_FCST_DATA' ORDER BY sequence")
    errs = cur.fetchall()
    if errs:
        print(f"[ERRORS] {len(errs)} compile errors:")
        for line, pos, text in errs[:20]:
            print(f"   line {line}:{pos} {text}")
    else:
        print("[OK] No compile errors")
