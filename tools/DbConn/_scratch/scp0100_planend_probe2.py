"""SCP0100 GetPlanEndDate — As-is UP_FX_GetCommonDataList_REPORT 원문 (읽기 전용)"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import dbconn

out = []
try:
    a = dbconn.connect('asis')
    cur = a.cursor()
    cur.execute("""SELECT s.name, o.name, m.definition FROM sys.sql_modules m
                   JOIN sys.objects o ON o.object_id = m.object_id
                   JOIN sys.schemas s ON s.schema_id = o.schema_id
                   WHERE o.name LIKE '%CommonDataList_REPORT%'""")
    for r in cur.fetchall():
        out.append('=== %s.%s ===' % (r[0], r[1]))
        out.append(r[2] or '')
    if not out:
        out.append('ASIS: no module matched')
except Exception as e:
    out.append('ASIS ERROR: ' + dbconn.mask(str(e)))

p = os.path.join(os.path.dirname(__file__), 'scp0100_planend_probe2.out.txt')
open(p, 'w', encoding='utf-8').write('\n'.join(out))
print(p)
