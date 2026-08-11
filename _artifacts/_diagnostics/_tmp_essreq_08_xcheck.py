# -*- coding: utf-8 -*-
"""정확일치 AS-IS 호출자 + TO-BE 역의존 + SCMC 사본 라인 (읽기 전용)"""
import sys, io, os, json
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

# --- AS-IS JSON 정확일치 ---
data = json.load(open(r"C:\Projects\NSCM\_analysis\_scan\phase1_db.json", encoding='utf-8'))
sps = data['sps']
print("=" * 110)
print("### AS-IS phase1_db.json — sps_called 정확일치 호출자")
print("=" * 110)
for tgt in ('PR_SSP_ANL_ESS_REQ', 'PR_SSP_ANL_ESS_REQ_NET'):
    callers = [s for s in sps if tgt in [str(c).upper() for c in (s.get('sps_called') or [])]]
    print("TARGET %s : %d callers" % (tgt, len(callers)))
    for c in callers:
        print("   %-12s %-10s %-38s lines=%s dynSQL=%s" % (c.get('db'), c.get('schema'), c.get('name'),
                                                           c.get('line_count'), c.get('uses_dynamic_sql')))
    print()

print("### AS-IS PR_SSP_ANL_ESS_REQ 엔트리 상세")
for s in sps:
    if s.get('name') in ('PR_SSP_ANL_ESS_REQ', 'PR_SSP_ANL_ESS_REQ_NET'):
        print(" ", s.get('db'), s.get('schema'), s.get('name'), "lines=", s.get('line_count'))
        print("    tables_referenced:", s.get('tables_referenced'))
        print("    sps_called:", s.get('sps_called'))
print()

print("### AS-IS DMF0003_SAVE_PRPOPUP / _PROD 엔트리")
for s in sps:
    if str(s.get('name')).startswith('DMF0003_SAVE_PRPOPUP') or s.get('name') == 'DMF0070_AUTO_PR_REQUEST':
        print(" ", s.get('db'), s.get('schema'), s.get('name'), "lines=", s.get('line_count'))
        print("    sps_called:", s.get('sps_called'))
print()

# --- TO-BE ---
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

def q(title, sql):
    print("=" * 110); print("### " + title); print("=" * 110)
    cur.execute(sql)
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    print(" | ".join(cols))
    for r in rows:
        print(" | ".join("" if v is None else str(v).rstrip() for v in r))
    print("(%d rows)\n" % len(rows))

q("TO-BE 역의존: PR_SSP_ANL_ESS_REQ 를 참조하는 객체", """
SELECT owner, name, type FROM ALL_DEPENDENCIES
 WHERE referenced_name IN ('PR_SSP_ANL_ESS_REQ','PR_SSP_ANL_ESS_REQ_NET')
   AND referenced_type='PROCEDURE' ORDER BY 1,3,2
""")

q("TO-BE 역의존: SSP_ANL_ESS_REQ(TABLE) 를 참조하는 객체", """
SELECT owner, name, type FROM ALL_DEPENDENCIES
 WHERE referenced_name='SSP_ANL_ESS_REQ' AND referenced_type='TABLE' ORDER BY 1,3,2
""")

q("SCMC.DMF0003_SAVE_PRPOPUP 내 참조 라인", """
SELECT line, text FROM ALL_SOURCE
 WHERE owner='SCMC' AND name='DMF0003_SAVE_PRPOPUP' AND INSTR(UPPER(text),'ANL_ESS_REQ')>0 ORDER BY line
""")

q("SCM_MGR.DMF0070_AUTO_PR_REQUEST 내 참조 라인", """
SELECT line, text FROM ALL_SOURCE
 WHERE owner='SCM_MGR' AND name='DMF0070_AUTO_PR_REQUEST' AND INSTR(UPPER(text),'ANL_ESS_REQ')>0 ORDER BY line
""")

q("DMF0070 / SSP0027 가 API_M 에 등록되어 있는가", """
SELECT DISTINCT m.MNU_ID, a.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M m
  JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID=m.API_ID
 WHERE m.MNU_ID IN ('DMF0070','SSP0027') OR UPPER(a.API_URL) LIKE '%DMF0070%' OR UPPER(a.API_URL) LIKE '%SSP0027%'
 ORDER BY 1,2
""")

con.close()
