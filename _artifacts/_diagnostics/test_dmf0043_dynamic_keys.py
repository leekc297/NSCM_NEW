#!/usr/bin/env python3
"""사내 DMF0043_GET_CONTRIBUTE_MAIN_DATA 직접 호출 + cursor 컬럼명 추출.

목적: 사내 patched SP 가 Y#/M# dynamic 컬럼 alias 정상 생성하는지 검증.
사용:
  python test_dmf0043_dynamic_keys.py [yyyy] [verSeq]
"""
import os, sys
import oracledb

YYYY = sys.argv[1] if len(sys.argv) > 1 else '2024'
VER_SEQ = sys.argv[2] if len(sys.argv) > 2 else '12'

u = os.getenv("NSCM_ORA_USER")
p = os.getenv("NSCM_ORA_PASS")
d = os.getenv("NSCM_ORA_DSN")
if not (u and p and d):
    sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN env vars required")

with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    rc = con.cursor()
    # IN: p_yyyy, p_ver_seq, p_dis, p_his, p_created_by, p_user_group / OUT: O_RC1
    cur.callproc("DMF0043_GET_CONTRIBUTE_MAIN_DATA",
                 [YYYY, VER_SEQ, 'ALL', 'N', 'minyonglee1', '', rc])

    # cursor metadata
    print(f"=== DMF0043_GET_CONTRIBUTE_MAIN_DATA(yyyy={YYYY}, verSeq={VER_SEQ}) ===")
    print(f"column count: {len(rc.description)}")
    cols = [c[0] for c in rc.description]
    base = [c for c in cols if not (c.startswith('Y#') or c.startswith('M#'))]
    y_dyn = [c for c in cols if c.startswith('Y#')]
    m_dyn = [c for c in cols if c.startswith('M#')]
    print(f"\n[BASE columns: {len(base)}]")
    for c in base:
        print(f"  {c}")
    print(f"\n[Y# dynamic: {len(y_dyn)}]")
    for c in y_dyn[:20]:
        print(f"  {c}")
    if len(y_dyn) > 20:
        print(f"  ... +{len(y_dyn) - 20} more")
    print(f"\n[M# dynamic: {len(m_dyn)}]")
    for c in m_dyn[:20]:
        print(f"  {c}")
    if len(m_dyn) > 20:
        print(f"  ... +{len(m_dyn) - 20} more")

    # sample first row
    rows = rc.fetchmany(1)
    if rows:
        print(f"\n[Sample row 1 (first 30 vals)]")
        for i, (col, val) in enumerate(zip(cols, rows[0])):
            if i >= 30:
                print(f"  ... +{len(cols) - 30} more cols")
                break
            print(f"  {col}: {val}")

    rc.close()
