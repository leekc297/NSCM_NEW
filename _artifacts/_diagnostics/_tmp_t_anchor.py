#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_anchor.py — 패치 앵커 정확도 검증 (파일 읽기 전용) + 세션 상태"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = ROOT / "_artifacts" / "_apply_corporate" / "BACKUP_PKG_DMF0044_BODY_pre_tunet_20260810.sql"

A1 = "                SELECT A.DIVISION_ID, A.PRODUCT_GROUP\n"
A2 = "SELECT /*+ LEADING(A B) USE_HASH(B) NO_MERGE(A) NO_MERGE(B) NO_PUSH_PRED(B) */"


def main():
    text = SRC.read_text(encoding="utf-8")
    lines = text.splitlines()
    print("파일 %s (%d 행)" % (SRC.name, len(lines)))
    print("\n[앵커 ① Transfer 분기 SELECT] count = %d" % text.count(A1))
    for i, ln in enumerate(lines, 1):
        if ln.startswith("                SELECT A.DIVISION_ID"):
            print("  L%d: %r" % (i, ln))
    print("\n[앵커 ② BP LOC 힌트] count = %d" % text.count(A2))
    for i, ln in enumerate(lines, 1):
        if A2 in ln:
            print("  L%d: %r" % (i, ln[:130]))
    print("\n[대조] 'SELECT A.DIVISION_ID' 전체 등장")
    for i, ln in enumerate(lines, 1):
        if "SELECT A.DIVISION_ID" in ln:
            print("  L%d: %r" % (i, ln[:100]))
    print("\n[대조] 'NO_PUSH_PRED' 전체 등장")
    for i, ln in enumerate(lines, 1):
        if "NO_PUSH_PRED" in ln:
            print("  L%d: %r" % (i, ln[:130]))

    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        print("\n=== V$SESSION ACTIVE (USER) ===")
        cur.execute("""SELECT SID, SERIAL#, SUBSTR(PROGRAM,1,32), STATUS, SUBSTR(EVENT,1,38),
                              SECONDS_IN_WAIT, SQL_ID, SUBSTR(BLOCKING_SESSION_STATUS,1,12), BLOCKING_SESSION
                         FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'""")
        for r in cur.fetchall():
            print("  ", r)
        print("\n=== PKG_DMF0044 LAST_DDL ===")
        cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI:SS')
                         FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'""")
        for r in cur.fetchall():
            print("  ", r)


if __name__ == "__main__":
    main()
