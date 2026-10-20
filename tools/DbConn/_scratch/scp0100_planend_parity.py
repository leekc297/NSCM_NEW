"""SCP0100 GetPlanEndDate 파리티 (읽기 전용) — As-is UP_FX_GetCommonDataList_REPORT('PLAN_END_DATE','81',plan,'WEEKLY')
   ↔ To-Be 등록 콤보 SCPPlanPeriod_SCP SQL(사내 CMBO_SQL_M 원문 그대로, @planName/@divisionId 치환)"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import dbconn

out = []
t = dbconn.connect('tobe'); tc = t.cursor()
tc.execute("SELECT SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SCPPlanPeriod_SCP' AND USE_YN='Y'")
sql = tc.fetchone()[0]
sql = sql.read() if hasattr(sql, 'read') else sql
out.append('TOBE CMBO SQL: ' + ' '.join(sql.split()))
tc.execute("SELECT PLAN_NAME FROM (SELECT DISTINCT PLAN_NAME FROM SCM_MST_PLAN WHERE DIVISION_ID='81' AND PLAN_CYCLE='WEEKLY' ORDER BY PLAN_NAME DESC) WHERE ROWNUM<=6")
plans = [r[0] for r in tc.fetchall()]
tc.execute("SELECT DIVISION_ID, PLAN_NAME, PLAN_CYCLE, COUNT(*) FROM SCM_MST_PLAN GROUP BY DIVISION_ID, PLAN_NAME, PLAN_CYCLE HAVING COUNT(*) > 1")
dups = tc.fetchall()
out.append('TOBE dup (DIV,PLAN,CYCLE) groups: %d %s' % (len(dups), dups[:5]))
a = None
try:
    a = dbconn.connect('asis'); ac = a.cursor()
except Exception as e:
    out.append('ASIS ERROR ' + dbconn.mask(str(e)))
for p in plans:
    q = sql.replace('@planName', "'%s'" % p).replace('@divisionId', "'81'")
    tc.execute(q)
    rows = tc.fetchall()
    tobe = rows[0][1] if rows else None
    asis = 'n/a'
    if a:
        try:
            ac.execute("EXEC dbo.UP_FX_GetCommonDataList_REPORT @Code='PLAN_END_DATE', @Param1='81', @Param2=?, @Param3='WEEKLY'", p)
            r = ac.fetchone(); asis = r[0] if r else None
        except Exception as e:
            asis = 'ERR ' + dbconn.mask(str(e))[:120]
    out.append('plan=%s tobe_rows=%d tobe_end=%s asis_end=%s' % (p, len(rows), tobe, asis))

p = os.path.join(os.path.dirname(__file__), 'scp0100_planend_parity.out.txt')
open(p, 'w', encoding='utf-8').write('\n'.join(out))
print('\n'.join(out))
