#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""B-1 사실확보 — SCM_ADM_LOOKUP_MASTER_DETAIL 실제 컬럼 기준 (조회 전용)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec("[1] 테이블 컬럼 인벤토리 (추측 금지 — DDL 실측)")
show(*fetch(cur, """SELECT column_id, column_name, data_type, data_length, nullable, data_default
                      FROM all_tab_columns WHERE owner='SCM_MGR'
                       AND table_name='SCM_ADM_LOOKUP_MASTER_DETAIL' ORDER BY column_id"""))

sec("[2] 제약 (PK/UNIQUE) — 중복이 애초에 가능했던 이유")
show(*fetch(cur, """SELECT c.constraint_name, c.constraint_type, cc.position, cc.column_name
                      FROM all_constraints c JOIN all_cons_columns cc
                        ON cc.owner=c.owner AND cc.constraint_name=c.constraint_name
                     WHERE c.owner='SCM_MGR' AND c.table_name='SCM_ADM_LOOKUP_MASTER_DETAIL'
                       AND c.constraint_type IN ('P','U')
                     ORDER BY c.constraint_name, cc.position"""))

sec("[3] 대상 2키의 전 행 원문 (ROWID 포함 — 삭제 전 보존)")
cur.execute("""SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR'
                AND table_name='SCM_ADM_LOOKUP_MASTER_DETAIL' ORDER BY column_id""")
cols = [r[0] for r in cur.fetchall()]
sel = ", ".join(cols)
cur.execute(f"""SELECT ROWIDTOCHAR(ROWID) AS RID, {sel}
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE='REPORT_GROUP2'
                   AND SEGMENT1 IN ('LGE/KT&'||'G','동남아')
                 ORDER BY SEGMENT1, ROWID""")
hdr = [c[0] for c in cur.description]
rows = cur.fetchall()
for r in rows:
    print("\n  ----")
    for h, v in zip(hdr, r):
        if v is not None:
            print(f"    {h:<22} = {v!r}")

sec("[4] 두 행의 payload 가 완전히 동일한가 (ROWID·감사컬럼 제외)")
payload = [c for c in cols if c not in ('CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE')]
expr = "||'|'||".join(f"NVL(TO_CHAR({c}),'~')" for c in payload)
show(*fetch(cur, f"""
SELECT SEGMENT1, COUNT(*) cnt, COUNT(DISTINCT {expr}) distinct_payload,
       CASE WHEN COUNT(DISTINCT {expr})=1 THEN '완전 동일(안전 삭제 가능)'
            ELSE '차이 있음(어느 행을 남길지 판단 필요)' END verdict
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='REPORT_GROUP2' AND SEGMENT1 IN ('LGE/KT&'||'G','동남아')
 GROUP BY SEGMENT1"""))

sec("[5] REPORT_GROUP2 전체 중복 (2건 외 추가 여부)")
show(*fetch(cur, """SELECT SEGMENT1, COUNT(*) cnt FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE='REPORT_GROUP2' GROUP BY SEGMENT1
                    HAVING COUNT(*)>1 ORDER BY SEGMENT1"""))

sec("[6] 영향범위 — REPORT_GROUP2 참조 DB 객체 전수")
show(*fetch(cur, """SELECT owner, name, type, COUNT(*) hit_lines FROM all_source
                     WHERE UPPER(text) LIKE '%REPORT_GROUP2%'
                     GROUP BY owner, name, type ORDER BY owner, name"""))

con.close()
