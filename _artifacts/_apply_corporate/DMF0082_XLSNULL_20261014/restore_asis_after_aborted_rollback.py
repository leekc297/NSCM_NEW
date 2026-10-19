"""1차 리허설 원복 단계 중단(ORA-20003, 원문 무변경) 뒤 사내 PKG_DMF0082 BODY 를 착수 기준본으로 되돌린다.

FRESH-GATE: 현재 USER_SOURCE == 1차 적용본(PKG_DMF0082_BODY.TOBE.raw) 일 때만 실행 — 그 사이 타 작업자 변경이 있으면 중단.
복원본 = PKG_DMF0082_BODY.ASIS.raw (build_package.py 가 2026-10-14 13:36:57 USER_SOURCE 에서 받은 원문, LAST_DDL 11:50:01).
"""
import os
import sys

import oracledb

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
asis = open(os.path.join(HERE, "PKG_DMF0082_BODY.ASIS.raw"), encoding="utf-8").read()
tobe = open(os.path.join(HERE, "PKG_DMF0082_BODY.TOBE.raw"), encoding="utf-8").read()

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    now = "".join(r[0] or "" for r in cur).replace("\r\n", "\n")
    # FRESH-GATE
    assert now == tobe, "FRESH-GATE 실패: 현재 원문이 1차 적용본과 다름 — 중단"
    cur.execute("CREATE OR REPLACE " + asis)
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    st = cur.fetchone()
    cur.execute("SELECT COUNT(*) FROM USER_ERRORS WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY'")
    err = cur.fetchone()[0]
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    after = "".join(r[0] or "" for r in cur).replace("\r\n", "\n")
    print("STATUS", st, "ERR", err, "== ASIS", after == asis)
