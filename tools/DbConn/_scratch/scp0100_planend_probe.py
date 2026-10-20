"""SCP0100 GetPlanEndDate 원천 조사 (읽기 전용) — As-is UP_FX_GetCommonDataList_REPORT 원문 + To-Be 대응 객체 검색"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import dbconn

out = []
try:
    a = dbconn.connect('asis')
    cur = a.cursor()
    cur.execute("SELECT OBJECT_DEFINITION(OBJECT_ID('SystemManager.UP_FX_GetCommonDataList_REPORT'))")
    r = cur.fetchone()
    txt = (r[0] or '') if r else ''
    out.append('=== ASIS UP_FX_GetCommonDataList_REPORT (len %d) ===' % len(txt))
    out.append(txt)
except Exception as e:
    out.append('ASIS ERROR: ' + dbconn.mask(str(e)))

try:
    t = dbconn.connect('tobe')
    cur = t.cursor()
    cur.execute("""SELECT OWNER, NAME, TYPE, LINE, TEXT FROM ALL_SOURCE
                   WHERE OWNER IN ('SCM_MGR','SCM_APP','SCMD') AND (UPPER(TEXT) LIKE '%PLAN_END_DATE%' OR UPPER(NAME) LIKE '%COMMONDATALIST_REPORT%')
                   ORDER BY OWNER, NAME, TYPE, LINE""")
    rows = cur.fetchall()
    out.append('=== TOBE ALL_SOURCE hits %d ===' % len(rows))
    for r in rows[:300]:
        out.append('%s.%s %s L%s: %s' % (r[0], r[1], r[2], r[3], (r[4] or '').rstrip()))
    cur.execute("""SELECT OBJECT_NAME, PROCEDURE_NAME, OBJECT_TYPE FROM ALL_PROCEDURES
                   WHERE OWNER='SCM_MGR' AND (OBJECT_NAME LIKE '%COMMON%REPORT%' OR PROCEDURE_NAME LIKE '%PLAN_END%' OR OBJECT_NAME LIKE 'PKG_SCP0100%')""")
    for r in cur.fetchall():
        out.append('PROC %s.%s %s' % r)
except Exception as e:
    out.append('TOBE ERROR: ' + dbconn.mask(str(e)))

p = os.path.join(os.path.dirname(__file__), 'scp0100_planend_probe.out.txt')
open(p, 'w', encoding='utf-8').write('\n'.join(out))
print(p)
