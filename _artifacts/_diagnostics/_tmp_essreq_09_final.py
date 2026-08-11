# -*- coding: utf-8 -*-
"""마무리 확인: SCMC 사본 상태/주석여부 + 다중경로 확인 (읽기 전용)"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def q(t, s):
    print("=" * 105); print("### " + t); print("=" * 105)
    cur.execute(s); cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print(" | ".join(cols))
    for r in rows: print(" | ".join("" if v is None else str(v).rstrip() for v in r))
    print("(%d rows)\n" % len(rows))

q("SCMC.DMF0003_SAVE_PRPOPUP 상태", """
SELECT owner, object_name, object_type, status FROM ALL_OBJECTS
 WHERE object_name='DMF0003_SAVE_PRPOPUP' ORDER BY 1
""")

print("=" * 105); print("### SCMC.DMF0003_SAVE_PRPOPUP 388~404"); print("=" * 105)
cur.execute("""SELECT line, text FROM ALL_SOURCE WHERE owner='SCMC' AND name='DMF0003_SAVE_PRPOPUP'
               AND line BETWEEN 386 AND 404 ORDER BY line""")
for ln, tx in cur.fetchall(): print("%5d| %s" % (ln, (tx or '').rstrip()))
print()

q("SSP_ANL_ESS_REQ 로의 직접 의존 엣지 (경로 다중성)", """
SELECT owner, name, type, referenced_owner, referenced_name, referenced_type
  FROM ALL_DEPENDENCIES
 WHERE referenced_name IN ('SSP_ANL_ESS_REQ','SSP_ANL_ESS_REQ_H','SSP_ANL_ESS_REQ_NET')
   AND owner='SCM_MGR' ORDER BY 5,2
""")

q("PKG_DMF0003 BODY 직접 참조 SSP_* (직접 엣지 없음 확인)", """
SELECT referenced_owner, referenced_name, referenced_type FROM ALL_DEPENDENCIES
 WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND referenced_name LIKE '%ANL_ESS%' ORDER BY 2
""")
con.close()
