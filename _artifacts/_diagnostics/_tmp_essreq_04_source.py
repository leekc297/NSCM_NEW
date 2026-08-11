# -*- coding: utf-8 -*-
"""ALL_SOURCE 텍스트 참조 + PKG_DMF0003 내 호출 위치 + 행수 (읽기 전용)"""
import sys, io, os, re
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

def q(title, sql, binds=None):
    print("=" * 110); print("### " + title); print("=" * 110)
    try:
        cur.execute(sql, binds or {})
        cols = [c[0] for c in cur.description]; rows = cur.fetchall()
        print(" | ".join(cols))
        for r in rows:
            print(" | ".join("" if v is None else str(v).rstrip() for v in r))
        print("(%d rows)" % len(rows))
        return rows
    except Exception as e:
        print("ERR:", e); return []
    finally:
        print()

# 1. 행수
for t in ('SSP_ANL_ESS_REQ', 'SSP_ANL_ESS_REQ_H', 'SSP_ANL_ESS_REQ_NET', 'GT_PRSSP_ANL_ESS_REQ', 'GT_PRSSP_ANL_ESS_REQ_NET'):
    q("COUNT SCM_MGR.%s" % t, "SELECT COUNT(*) cnt FROM SCM_MGR.%s" % t)

# 1b. temporary 여부
q("temporary flag", """
SELECT table_name, temporary, num_rows, TO_CHAR(last_analyzed,'YYYY-MM-DD') last_analyzed
  FROM ALL_TABLES WHERE owner='SCM_MGR' AND table_name LIKE '%ANL_ESS_REQ%' ORDER BY 1
""")

# 2. 전 DB 텍스트 참조 (ALL_SOURCE)
q("ALL_SOURCE 텍스트 참조 객체 (SSP_ANL_ESS_REQ)", """
SELECT owner, type, name, COUNT(*) hit_lines
  FROM ALL_SOURCE
 WHERE owner IN ('SCM_MGR','FP_MGR','SCMC','SETUP_MGR')
   AND INSTR(UPPER(text),'SSP_ANL_ESS_REQ') > 0
 GROUP BY owner, type, name ORDER BY 1,2,3
""")

# 3. PKG_DMF0003 BODY 안의 참조 라인
q("PKG_DMF0003 BODY 내 'SSP_ANL_ESS_REQ' 라인", """
SELECT type, line, text FROM ALL_SOURCE
 WHERE owner='SCM_MGR' AND name='PKG_DMF0003'
   AND INSTR(UPPER(text),'SSP_ANL_ESS_REQ') > 0 ORDER BY type, line
""")

# 4. PKG_DMF0003 BODY 의 PROCEDURE 선언 라인 (귀속용)
q("PKG_DMF0003 BODY PROCEDURE/FUNCTION 선언 라인", """
SELECT line, text FROM ALL_SOURCE
 WHERE owner='SCM_MGR' AND name='PKG_DMF0003' AND type='PACKAGE BODY'
   AND REGEXP_LIKE(UPPER(text),'^\\s*(PROCEDURE|FUNCTION)\\s')
 ORDER BY line
""")

# 5. PR_SSP_ANL_ESS_REQ 본문 내 참조 라인
q("PR_SSP_ANL_ESS_REQ 본문 내 대상 테이블 참조 라인", """
SELECT name, line, text FROM ALL_SOURCE
 WHERE owner='SCM_MGR' AND name IN ('PR_SSP_ANL_ESS_REQ','PR_SSP_ANL_ESS_REQ_NET')
   AND INSTR(UPPER(text),'ANL_ESS_REQ') > 0 ORDER BY name, line
""")

con.close()
