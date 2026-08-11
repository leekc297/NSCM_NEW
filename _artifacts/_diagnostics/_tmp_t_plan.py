#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""_tmp_t_plan.py — 병목 후보 문장의 전문/플랜 실측 (읽기 전용)

1) ALL_SOURCE 라인 정렬 확인 (PROGRAM_LINE# ↔ 소스 라인)
2) SQL_FULLTEXT 앞부분 — 어느 문장인지 확정
3) V$SQL_PLAN (EST) + V$SQL_PLAN_MONITOR (ACT) 대조
"""
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

SQLIDS = sys.argv[1:] or ["761qq1a2shbyp", "fndp8c35xn8y5", "7m5ac7znzv40r"]


def rows(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    return cols, cur.fetchall()


def show(title, cols, data, maxw=130):
    print("\n=== %s ===" % title)
    if not data:
        print("  (0 rows)")
        return
    print(" | ".join(cols))
    for r in data:
        print(" | ".join(str("" if v is None else v)[:maxw] for v in r))
    print("(%d rows)" % len(data))


def main():
    import oracledb

    u, p, d = conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()

        show("ALL_SOURCE 라인 정렬 확인", *rows(cur, """
            SELECT LINE, RTRIM(TEXT) AS TXT FROM ALL_SOURCE
             WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'
               AND LINE IN (1,2,8550,8576,8592,8607,8620,9614,9660)
             ORDER BY LINE"""))

        for sid in SQLIDS:
            cur.execute("""SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, EXECUTIONS,
                                  ROUND(ELAPSED_TIME/1e6,1), BUFFER_GETS, ROWS_PROCESSED,
                                  PROGRAM_LINE#, SUBSTR(SQL_FULLTEXT,1,400)
                             FROM V$SQL WHERE SQL_ID = :s ORDER BY CHILD_NUMBER""", {"s": sid})
            for r in cur.fetchall():
                print("\n########## SQL_ID %s child %s plan %s ##########" % (r[0], r[1], r[2]))
                print("  exec=%s elapsed=%ss bget=%s rows=%s src_line=%s" % (r[3], r[4], r[5], r[6], r[7]))
                print("  --- FULLTEXT head ---")
                print("  " + str(r[8]).replace("\n", "\n  ")[:1200])

            show("V$SQL_PLAN %s (EST)" % sid, *rows(cur, """
                SELECT ID, PARENT_ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,'') AS OP
                     , OBJECT_NAME, CARDINALITY AS EST_ROWS, COST, ACCESS_PREDICATES IS NOT NULL AS HAS_ACC
                  FROM V$SQL_PLAN WHERE SQL_ID = :s AND CHILD_NUMBER = (
                        SELECT MIN(CHILD_NUMBER) FROM V$SQL WHERE SQL_ID = :s)
                 ORDER BY ID""", {"s": sid}))

            show("V$SQL_PLAN_MONITOR %s (EST vs ACT)" % sid, *rows(cur, """
                SELECT PLAN_LINE_ID AS ID, LPAD(' ',PLAN_DEPTH)||PLAN_OPERATION||' '||NVL(PLAN_OPTIONS,'') AS OP
                     , PLAN_OBJECT_NAME AS OBJ, PLAN_CARDINALITY AS EST, OUTPUT_ROWS AS ACT
                     , STARTS
                  FROM V$SQL_PLAN_MONITOR
                 WHERE SQL_ID = :s
                   AND (SID, SQL_EXEC_ID) = (SELECT SID, SQL_EXEC_ID FROM (
                            SELECT SID, SQL_EXEC_ID FROM V$SQL_PLAN_MONITOR WHERE SQL_ID = :s
                             ORDER BY SQL_EXEC_START DESC NULLS LAST) WHERE ROWNUM=1)
                 ORDER BY PLAN_LINE_ID""", {"s": sid}))


if __name__ == "__main__":
    main()
