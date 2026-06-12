#!/usr/bin/env python3
"""DMF0043_GET_MAIN_VARSION_DATA 직접 호출 + 결과 fetch."""
import oracledb, time

CONN_PARAMS = dict(
    user="SCM_MGR",
    password="!SCMroqkf2026",
    dsn=oracledb.makedsn(host="121.162.245.167", port=2521, sid="ESSCMD"),
)


def main():
    conn = oracledb.connect(**CONN_PARAMS)
    cur = conn.cursor()
    rc = cur.var(oracledb.CURSOR)
    t0 = time.time()
    try:
        print("=== Calling DMF0043_GET_MAIN_VARSION_DATA('minyonglee1', 'DMF0043') ===")
        cur.callproc("DMF0043_GET_MAIN_VARSION_DATA", ["minyonglee1", "DMF0043", rc])
        dt = time.time() - t0
        print(f"[OK] callproc 완료 — {dt:.2f}s")
        c = rc.getvalue()
        if c is None:
            print("  None cursor")
        else:
            rows = c.fetchmany(10)
            cols = [d[0] for d in c.description] if c.description else []
            remaining = sum(1 for _ in c)
            total = len(rows) + remaining
            print(f"  Total rows: {total}")
            print(f"  Cols: {cols}")
            for r in rows[:5]:
                print(f"  Row: {r}")
            c.close()
    except oracledb.DatabaseError as e:
        dt = time.time() - t0
        print(f"[ERR] {dt:.2f}s: {e}")
    cur.close()
    conn.close()


if __name__ == "__main__":
    main()
