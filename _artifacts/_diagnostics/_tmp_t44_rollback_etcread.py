#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ETCREAD 변경 원복 — 배포 전 백업본을 그대로 재배포 (회귀 확인에 따른 즉시 롤백)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

BACKUP = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate"
                      r"\BACKUP_PKG_DMF0044_BODY_pre_etcread_20260811.sql")
sql = BACKUP.read_text(encoding="utf-8").rstrip().rstrip("/").rstrip()
print(f"[rollback] {BACKUP.name} ({len(sql.splitlines()):,}행)")

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    cur.execute(sql)
    cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
                    WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0044' ORDER BY 1""")
    for r in cur.fetchall():
        print("  %-14s %s" % r)
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
                    WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' ORDER BY SEQUENCE""")
    for e in cur.fetchall():
        print("  ⛔ L%s:%s %s" % e)
    for m, exp in (('ETCREAD 2026\\-08\\-11', 0), ('TUNE\\-V 2026\\-08\\-10', 2),
                   ('TUNE\\-J 2026\\-08\\-10', 9), ('TUNE\\-S 2026\\-08\\-10', 1)):
        cur.execute("""SELECT NVL(SUM(REGEXP_COUNT(TEXT, :m)),0) FROM ALL_SOURCE
                        WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044' AND TYPE='PACKAGE BODY'""",
                    {"m": m})
        got = cur.fetchone()[0]
        print(f"  마커 {m.replace(chr(92),'')} = {got} (기대 {exp}) {'✅' if got == exp else '⛔'}")
    # 원복 확인 — ETC 조회 행수
    c1 = con.cursor(); c2 = con.cursor()
    cur.callproc("PKG_DMF0044.P_DMF0044_GET_SALES_REPORTS_DATA",
                 ['40', 'REPORT_SP_W', '2026', 'R_S_20260810_V010_C', '2',
                  'minyonglee1', 'minyonglee1', 'minyonglee1', 'DMF0044', c1, c2])
    print(f"\n  [확인] ETC 조회 행수 = {len(c1.fetchall()):,}  (회귀 시 2 / 정상 38)")
