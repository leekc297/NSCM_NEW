#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_wait.py — 선행 배포(library cache pin 대기 중) 완료까지 감시 (읽기 전용)

⚠ KILL 하지 않는다. 상태만 관측한다.
"""
import pathlib
import sys
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

MAX_S = int(sys.argv[1]) if len(sys.argv) > 1 else 540
STEP = 20


def main():
    import oracledb

    u, p, d = conn_info()
    t0 = time.time()
    while True:
        with oracledb.connect(user=u, password=p, dsn=d) as con:
            cur = con.cursor()
            cur.execute("""SELECT SID, SUBSTR(PROGRAM,1,22), SUBSTR(EVENT,1,30),
                                  SECONDS_IN_WAIT, SQL_ID, BLOCKING_SESSION
                             FROM V$SESSION WHERE TYPE='USER' AND STATUS='ACTIVE'
                            ORDER BY SID""")
            sess = cur.fetchall()
            cur.execute("""SELECT TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS
                            WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044'
                              AND OBJECT_TYPE='PACKAGE BODY'""")
            ddl = cur.fetchone()
            cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT,'DESCNULL 2026-08-10')),0)
                                , NVL(SUM(REGEXP_COUNT(TEXT,'TUNE-T 2026-08-10')),0)
                             FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                              AND TYPE='PACKAGE BODY'""")
            marks = cur.fetchone()
        el = int(time.time() - t0)
        pins = [s for s in sess if s[2] and "library cache pin" in s[2]]
        print("[+%4ds] BODY LAST_DDL=%s %s | DESCNULL=%d TUNE-T=%d | ACTIVE=%d (pin 대기 %d)"
              % (el, ddl[0], ddl[1], marks[0], marks[1], len(sess), len(pins)))
        for s in sess:
            print("          SID %-4s %-22s %-30s wait=%-5s sql=%s blk=%s"
                  % (s[0], s[1], s[2], s[3], s[4], s[5]))
        if not pins:
            print("  → library cache pin 대기 해소")
            return 0
        if el >= MAX_S:
            print("  → 감시 시한 도달 (여전히 대기 중)")
            return 2
        time.sleep(STEP)


if __name__ == "__main__":
    sys.exit(main())
