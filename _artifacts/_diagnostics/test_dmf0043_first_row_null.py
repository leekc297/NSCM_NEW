#!/usr/bin/env python3
"""DMF0043 첫 row dynamic 컬럼 NULL 카운트 — patched SP 검증."""
import os, sys
import oracledb

u, p, d = os.getenv("NSCM_ORA_USER"), os.getenv("NSCM_ORA_PASS"), os.getenv("NSCM_ORA_DSN")
if not (u and p and d):
    sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN env vars required")

with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    rc = con.cursor()
    cur.callproc("DMF0043_GET_CONTRIBUTE_MAIN_DATA",
                 ['2024', '1', 'ALL', 'N', 'minyonglee1', '', rc])
    cols = [c[0] for c in rc.description]
    y_dyn = [(i, c) for i, c in enumerate(cols) if c.startswith('Y#')]
    m_dyn = [(i, c) for i, c in enumerate(cols) if c.startswith('M#')]
    rows = rc.fetchmany(1)
    if not rows:
        print("(no rows returned)")
        sys.exit(0)
    first = rows[0]
    y_null = sum(1 for i, _ in y_dyn if first[i] is None)
    m_null = sum(1 for i, _ in m_dyn if first[i] is None)
    print(f"First row dynamic col NULL count:")
    print(f"  Y# total={len(y_dyn)} NULL={y_null} valued={len(y_dyn)-y_null}")
    print(f"  M# total={len(m_dyn)} NULL={m_null} valued={len(m_dyn)-m_null}")
    print()
    print(f"Sample Y# values (first 5):")
    for i, c in y_dyn[:5]:
        print(f"  {c} = {first[i]!r}")
    print(f"Sample M# values (first 5):")
    for i, c in m_dyn[:5]:
        print(f"  {c} = {first[i]!r}")
    rc.close()
