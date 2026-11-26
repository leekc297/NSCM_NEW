import sys,time
sys.path.insert(0,'tools/DbConn')
from dbconn import connect
SQL=open('Doc/verify/DMF0082/rtf3/repro.sql',encoding='utf-8').read().split(';\n')
with connect('tobe') as cx:
    cx.call_timeout=60000
    cur=cx.cursor()
    for i,s in enumerate(SQL):
        s=s.strip()
        if not s: continue
        t=time.time(); cur.execute(s); r=cur.fetchall()
        print(f'-- Q{i+1}', round(time.time()-t,2),'s', [d[0] for d in cur.description])
        for x in r[:15]: print(x)
