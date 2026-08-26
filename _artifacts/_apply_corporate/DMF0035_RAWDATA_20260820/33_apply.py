# -*- coding: utf-8 -*-
"""BODY 패치본 적용 + 룰 #136 3축 검증. 사용: 33_apply.py <패치파일> <마커> <기대마커수>

3축: ①STATUS(PACKAGE/PACKAGE BODY VALID) ②ALL_ERRORS 0 ③마커 카운트.
어긋나면 즉시 백업본으로 원복하고 비정상 종료.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
patch, MARK, NMARK = sys.argv[1], sys.argv[2], int(sys.argv[3])
body = open(f"{BASE}\\{patch}", encoding="utf-8").read().strip()
assert body.upper().startswith("PACKAGE BODY"), body[:80]
assert body.count(MARK) == NMARK, f"패치파일 마커 {body.count(MARK)} (기대 {NMARK})"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 30")


def three_axis():
    cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                   AND OBJECT_NAME='PKG_DMF0035' AND OBJECT_TYPE IN ('PACKAGE','PACKAGE BODY') ORDER BY 1""")
    sts = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'")
    errs = cur.fetchone()[0]
    marks = {}
    for mk in (MARK, "E20260820-DS2", "E20260820-WFITEMPERF", "E20260820-VERPUSH"):
        cur.execute("""SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
                       AND TYPE='PACKAGE BODY' AND INSTR(TEXT,:m)>0""", {"m": mk})
        marks[mk] = cur.fetchone()[0]
    return sts, errs, marks


def rollback():
    print("[ROLLBACK] 백업본으로 원복 시도")
    bk = open(BASE + r"\00_BACKUP_PKG_DMF0035_BODY.sql", encoding="utf-8").read().strip()
    cur.execute("CREATE OR REPLACE " + bk)
    sts, errs, marks = three_axis()
    print(f"[ROLLBACK] {sts} / ERRORS {errs} / {marks}")


try:
    cur.execute("CREATE OR REPLACE " + body)
    print(f"[apply] {patch} — CREATE OR REPLACE PACKAGE BODY 실행")
except Exception as e:
    print(f"[FAIL] 컴파일 예외: {e}")
    rollback()
    sys.exit(1)

sts, errs, marks = three_axis()
print(f"[축1 STATUS ] {sts}")
print(f"[축2 ERRORS ] {errs}")
print(f"[축3 마커   ] {marks}")
ok = (errs == 0 and all(s == "VALID" for _, s in sts) and marks[MARK] == NMARK
      and marks["E20260820-DS2"] == 1 and marks["E20260820-WFITEMPERF"] == 2
      and marks["E20260820-VERPUSH"] >= 6)
if not ok:
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                   AND NAME='PKG_DMF0035' ORDER BY SEQUENCE FETCH FIRST 15 ROWS ONLY""")
    for r in cur.fetchall():
        print("  ⛔", r)
    rollback()
    con.close()
    sys.exit(2)
print("[OK] 룰 #136 3축 PASS")
con.close()
