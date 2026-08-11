#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""A 앵커 유일성 + B-1 대상 행 원문/영향범위 사실확보 (조회 전용)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[A] 앵커 유일성 — 라이브 BODY 내 ', C.ATTRIBUTE1 AS PRODUCT_DETAIL' 출현 수")
cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())
for s in (", C.ATTRIBUTE1 AS PRODUCT_DETAIL",
          "C.ATTRIBUTE1 AS PRODUCT_DETAIL",
          "NVL(C.ATTRIBUTE1"):
    print(f"    {s!r:<45} = {live.count(s)}")
i = live.find("C.ATTRIBUTE1 AS PRODUCT_DETAIL")
print("\n  [문맥]")
print("\n".join("    " + x for x in live[max(0, i-320):i+120].splitlines()))

sec("[B-1] REPORT_GROUP2 중복 대상 행 — 전 컬럼 원문 (삭제 전 보존용)")
show(*fetch(cur, """
SELECT LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
       DISPLAY_SEQ, USE_YN, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3,
       CREATED_BY, TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') creation_date,
       LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') last_update,
       ROWID
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2'
   AND SEGMENT1 IN ('LGE/KT&'||'G', '동남아')
 ORDER BY SEGMENT1, CREATION_DATE, ROWID"""))

sec("[B-1] 두 행이 완전히 동일한가 (ROWID 제외 전 컬럼 비교)")
show(*fetch(cur, """
SELECT SEGMENT1, COUNT(*) cnt,
       COUNT(DISTINCT SEGMENT2||'|'||NVL(SEGMENT3,'~')||'|'||NVL(SEGMENT4,'~')||'|'||NVL(SEGMENT5,'~')
             ||'|'||NVL(TO_CHAR(DISPLAY_SEQ),'~')||'|'||NVL(USE_YN,'~')
             ||'|'||NVL(ATTRIBUTE1,'~')||'|'||NVL(ATTRIBUTE2,'~')||'|'||NVL(ATTRIBUTE3,'~')) distinct_payload
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' AND SEGMENT1 IN ('LGE/KT&'||'G','동남아')
 GROUP BY SEGMENT1"""))

sec("[B-1] 이 테이블에 PK/UNIQUE 제약이 있는가 (있으면 중복이 애초에 불가능했어야 함)")
show(*fetch(cur, """
SELECT c.constraint_name, c.constraint_type, cc.position, cc.column_name
  FROM all_constraints c JOIN all_cons_columns cc
    ON cc.owner=c.owner AND cc.constraint_name=c.constraint_name
 WHERE c.owner='SCM_MGR' AND c.table_name='SCM_ADM_LOOKUP_MASTER_DETAIL'
   AND c.constraint_type IN ('P','U') ORDER BY c.constraint_name, cc.position"""))

sec("[B-1] REPORT_GROUP2 전체 중복 현황 (2건 외에 더 있는가)")
show(*fetch(cur, """
SELECT SEGMENT1, COUNT(*) cnt FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' GROUP BY SEGMENT1 HAVING COUNT(*)>1 ORDER BY SEGMENT1"""))

sec("[B-1] 영향범위 — REPORT_GROUP2 를 참조하는 DB 객체 전수")
show(*fetch(cur, """
SELECT owner, name, type, COUNT(*) hit_lines
  FROM all_source
 WHERE UPPER(text) LIKE '%REPORT_GROUP2%'
   AND owner IN ('SCM_MGR','SCMC','SCMD_APP','SCMP_APP')
 GROUP BY owner, name, type ORDER BY owner, name"""))

con.close()
