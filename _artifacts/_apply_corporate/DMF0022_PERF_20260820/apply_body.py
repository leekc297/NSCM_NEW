# -*- coding: utf-8 -*-
"""PACKAGE BODY 파일 적용 + 룰 #136 3축 검증(STATUS / ALL_ERRORS / 마커 카운트).

사용: python apply_body.py <파일> [기대마커=카운트 ...]
예:   python apply_body.py 01_PATCHED_A_PKG_DMF0022_BODY.sql E20260820-D22PREREDUCE=2 E20260820-DS2=1 v_measure_sheet=6
어긋나면 즉시 원복 (00_BACKUP_PKG_DMF0022_BODY.sql).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
fname = sys.argv[1]
expect = dict()
for a in sys.argv[2:]:
    k, v = a.rsplit("=", 1)
    expect[k] = int(v)

body = open(f"{BASE}\\{fname}", encoding="utf-8").read().strip()
assert body.upper().startswith("PACKAGE BODY"), body[:80]
stmt = "CREATE OR REPLACE " + body

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")


def verify(tag):
    cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0022' ORDER BY 1""")
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'")
    errs = cur.fetchone()[0]
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    live = "".join(r[0] for r in cur.fetchall())
    mk = {k: live.count(k) for k in expect}
    print(f"[{tag}] STATUS {sts} / ALL_ERRORS {errs} / 마커 {mk}")
    ok = (errs == 0 and all(s == "VALID" for _, s in sts)
          and all(mk[k] == v for k, v in expect.items()))
    return ok, sts, errs, mk


try:
    cur.execute(stmt)
except Exception as e:
    print("[FAIL] 컴파일 예외:", e)
    raise
ok, sts, errs, mk = verify("APPLY")
if not ok:
    print("[ROLLBACK] 3축 검증 실패 → 원본 복원")
    orig = open(BASE + r"\00_BACKUP_PKG_DMF0022_BODY.sql", encoding="utf-8").read().strip()
    cur.execute("CREATE OR REPLACE " + orig)
    verify("ROLLBACK")
    con.close()
    sys.exit(1)
print("[OK] 룰 #136 3축 통과")
con.close()
