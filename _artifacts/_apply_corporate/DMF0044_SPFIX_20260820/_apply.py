#!/usr/bin/env python3
"""
01_PATCHED_PKG_DMF0044_BODY.sql 를 사내 Oracle 에 적용 + 룰 #136 검증 3축.
실패 시 00_BACKUP 으로 즉시 원복.
  usage: python _apply.py            # 적용
         python _apply.py rollback   # 백업본으로 원복
"""
import sys, pathlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa
import oracledb

HERE = pathlib.Path(__file__).resolve().parent
BACKUP = HERE / "00_BACKUP_PKG_DMF0044_BODY_LIVE.sql"
PATCH = HERE / "01_PATCHED_PKG_DMF0044_BODY.sql"
MARKERS = {"[E20260820-CFMERGE]": 2, "[E20260820-CFSETBASED]": 2,
           "[E20260820-CFNOSTATS]": 1, "[E20260820-EXAUTH]": 4}


def ddl_text(path):
    t = path.read_text(encoding="utf-8").replace("\r", "")
    t = t.rstrip()
    assert t.endswith("/"), f"{path.name}: 종결자 '/' 없음"
    t = t[:-1].rstrip()
    assert t.upper().startswith("CREATE OR REPLACE PACKAGE BODY"), f"{path.name}: 헤더 불일치"
    return t


def verify(cur, expect_markers):
    ok = True
    cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
    st = cur.fetchall()
    print("  [축1] STATUS:", st)
    if sorted(st) != [('PACKAGE', 'VALID'), ('PACKAGE BODY', 'VALID')]:
        ok = False; print("  !! 축1 FAIL")
    cur.execute("""SELECT TYPE, LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
    errs = cur.fetchall()
    print(f"  [축2] ALL_ERRORS: {len(errs)} 건")
    for e in errs[:20]:
        print("      ", e)
    if errs:
        ok = False; print("  !! 축2 FAIL")
    cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    live = "".join(t for _, t in cur.fetchall())
    for m, exp in expect_markers.items():
        got = live.count(m)
        flag = "OK" if got == exp else "!! MISMATCH"
        print(f"  [축3] marker {m:26s} live={got} expect={exp} {flag}")
        if got != exp:
            ok = False
    return ok


mode = sys.argv[1] if len(sys.argv) > 1 else "apply"
src = BACKUP if mode == "rollback" else PATCH
expect = {} if mode == "rollback" else MARKERS
ddl = ddl_text(src)
print(f"MODE={mode}  source={src.name}  chars={len(ddl)}")

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
    try:
        cur.execute(ddl)
        print("CREATE OR REPLACE: 실행 완료")
    except Exception as e:
        print(f"CREATE OR REPLACE FAIL: {e}")
        sys.exit(2)
    cur.execute("ALTER PACKAGE SCM_MGR.PKG_DMF0044 COMPILE BODY")
    print("--- 룰 #136 검증 3축 ---")
    if not verify(cur, expect):
        print("\n!! 검증 실패 — 백업본으로 즉시 원복 시도")
        cur.execute(ddl_text(BACKUP))
        cur.execute("ALTER PACKAGE SCM_MGR.PKG_DMF0044 COMPILE BODY")
        print("--- 원복 후 재검증 ---")
        verify(cur, {})
        sys.exit(3)
    print("\n검증 3축 전량 PASS")
