# -*- coding: utf-8 -*-
"""[E20260820-VERPUSH] 사내 적용 + 룰 #136 3축 검증 (실패 시 백업본 즉시 원복)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"
PKG = "PKG_DMF0035"
MARK = "E20260820-VERPUSH"
EXPECT_MARK = 6

patched = open(BASE + r"\01_PATCHED_PKG_DMF0035_BODY.sql", encoding="utf-8").read().strip()
backup = open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", encoding="utf-8").read().strip()
assert patched.upper().startswith("PACKAGE BODY") and backup.upper().startswith("PACKAGE BODY")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")


def verify(tag):
    """룰 #136 3축 — 대상 객체 실측 (엉뚱한 객체 상태 출력 금지)."""
    cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
                     FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n
                     AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') ORDER BY 1""", {"n": PKG})
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", {"n": PKG})
    errs = cur.fetchone()[0]
    cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' AND INSTR(TEXT,:m) > 0""", {"n": PKG, "m": MARK})
    mk = cur.fetchone()[0]
    print(f"  [{tag}] STATUS={sts}  ALL_ERRORS={errs}  마커({MARK})={mk}")
    return sts, errs, mk


print("=== 적용 전 ===")
verify("PRE")

print("=== CREATE OR REPLACE 적용 ===")
cur.execute("CREATE OR REPLACE " + patched)
sts, errs, mk = verify("POST")

ok = (errs == 0
      and len(sts) == 2
      and all(s == "VALID" for _, s, _ in sts)
      and mk == EXPECT_MARK)
if not ok:
    print(f"!! 3축 불일치 (기대: 2객체 VALID / ERRORS 0 / 마커 {EXPECT_MARK}) — 백업본 원복")
    cur.execute("CREATE OR REPLACE " + backup)
    verify("ROLLBACK")
    con.close()
    sys.exit(1)

print(f"[OK] 3축 PASS — PACKAGE/BODY VALID · ALL_ERRORS 0 · 마커 {mk}/{EXPECT_MARK}")
con.close()
