# BASE vs JOIN_A 실행계획 실측 비교 (statistics_level=ALL, DB 객체 무변경)
import sys, re
from bench_get_bod_item import *
u, p, d = ora.conn_info(); c = oracledb.connect(user=u, password=p, dsn=d); cur = c.cursor()
cur.execute("ALTER SESSION SET statistics_level=ALL")
args = eval(sys.argv[1]) if len(sys.argv) > 1 else ['ALL','ALL','ALL','ALL','ALL','','','ALL','minyonglee1','SCP0030']
for v in ('BASE', 'JOIN_A'):
    for rep in range(3):
        el, n, hx = run(cur, v, args)
    key = "TABLE(:B" if v == 'BASE' else None
    # SQL_TEXT 는 앞 1000자만 보관돼 문장으로 구분 불가 → 사내 실측 SQL_ID 로 구분 (BASE=PKG 와 동일 문장)
    cur.execute("SELECT SQL_ID, CHILD_NUMBER FROM V$SQL WHERE SQL_ID=:s ORDER BY LAST_ACTIVE_TIME DESC FETCH FIRST 1 ROWS ONLY",
                s={'BASE': '1304f0spf3u9w', 'JOIN_A': 'dx0q8wbnya762'}[v])
    sid, ch = cur.fetchone()
    cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s,:c,'ALLSTATS LAST'))", s=sid, c=ch)
    out = [r[0] for r in cur]
    pathlib.Path('plan_%s.txt' % v).write_text('\n'.join(out), encoding='utf-8')
    top = [l for l in out if re.match(r'\|\s+0 \|', l)]
    conc = sum('CONCATENATION' in l for l in out)
    print(v, sid, 'rows=%d' % n, 'CONCATENATION=%d' % conc, top[0] if top else '')
